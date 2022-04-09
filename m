Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76CE74FA222
	for <lists+netdev@lfdr.de>; Sat,  9 Apr 2022 05:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240690AbiDIDwb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 23:52:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231783AbiDIDw2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 23:52:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8799ECB25;
        Fri,  8 Apr 2022 20:50:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 41BDC622CA;
        Sat,  9 Apr 2022 03:50:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C41AC385A0;
        Sat,  9 Apr 2022 03:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649476221;
        bh=TR63dPr9fJPfot2802e64a1epeSUkv6k0Aki8zERagk=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=gtoTUM/NnYz0uCGUQVXRs0qomk4d6l6RM/0qIVvBL2fNt9Usu6ePW2SJY+UXa/pns
         VICSx05ydTjTirxs0D7gELSKS8On3yN+c64WM9r1FtuwAvzPrG645XWAMsokJijqXS
         A4HJ16Asw/aeL9zMcNGWq8E+Zvs5XyOccWNOKyWqE40oUDh9AXhpDjMUayinFN9w5k
         8wcNhMjUfRKUrX7d5u+AdzziYbe16zGq4K2LOkwVBmY6wQLTQp/gHCbq63hKL7ZQAy
         Sf87Srnx7X5ks6Zrbc8Mlem2GB2DztYWPTqHHtNmy3c99eM2eYPwBuIjlYh8xffnSf
         eQ+LDG3CPgj8Q==
Message-ID: <3d5c2bfc-cfb1-ea2d-f88c-36e0e4f92293@kernel.org>
Date:   Fri, 8 Apr 2022 21:50:19 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH RESEND net-next v5 2/4] net: skb: rename
 SKB_DROP_REASON_PTYPE_ABSENT
Content-Language: en-US
To:     menglong8.dong@gmail.com, kuba@kernel.org, pabeni@redhat.com
Cc:     rostedt@goodmis.org, mingo@redhat.com, xeb@mail.ru,
        davem@davemloft.net, yoshfuji@linux-ipv6.org,
        imagedong@tencent.com, edumazet@google.com, kafai@fb.com,
        talalahmad@google.com, keescook@chromium.org, alobakin@pm.me,
        flyingpeng@tencent.com, mengensun@tencent.com,
        dongli.zhang@oracle.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, benbjiang@tencent.com
References: <20220407062052.15907-1-imagedong@tencent.com>
 <20220407062052.15907-3-imagedong@tencent.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220407062052.15907-3-imagedong@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/7/22 12:20 AM, menglong8.dong@gmail.com wrote:
> From: Menglong Dong <imagedong@tencent.com>
> 
> As David Ahern suggested, the reasons for skb drops should be more
> general and not be code based.
> 
> Therefore, rename SKB_DROP_REASON_PTYPE_ABSENT to
> SKB_DROP_REASON_UNHANDLED_PROTO, which is used for the cases of no
> L3 protocol handler, no L4 protocol handler, version extensions, etc.
> 
> From previous discussion, now we have the aim to make these reasons
> more abstract and users based, avoiding code based.
> 
> Signed-off-by: Menglong Dong <imagedong@tencent.com>
> ---
>  include/linux/skbuff.h     | 8 +++-----
>  include/trace/events/skb.h | 2 +-
>  net/core/dev.c             | 8 +++-----
>  3 files changed, 7 insertions(+), 11 deletions(-)
> 


Reviewed-by: David Ahern <dsahern@kernel.org>
