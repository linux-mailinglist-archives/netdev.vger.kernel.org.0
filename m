Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8C3B4B96A3
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 04:25:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231846AbiBQDZz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 22:25:55 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232964AbiBQDZv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 22:25:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6846528A115
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 19:25:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1CFD6B811E1
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 03:25:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C185C340E9;
        Thu, 17 Feb 2022 03:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645068335;
        bh=yLXBCbSaaIGpaERgjZsn+vWdZNJbzwDE1I2+ugzntNw=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=NabIJRKVb4ciwO+C8IkWgURm6fJAxbu3kPu59vI0c20unbL9J6YQ4gDUDbz23gUWu
         35xUIQOBU9z/qU2lRf6lwgDrsEOcncECc0aijbN/PXO0AK2K1m/ONuZlFNyEF6If0j
         XBSfxtXdBflP7/2txHSOGHZNMrz3lCgYte81z86760Xb5MWtPp1ldXS4a1sfoX2mGV
         +DmyPTlAXrXj8d3BoRvqkurDIJYDK1I8PDrEev/4gxJRcj5tA2kCTNHdn/9DocA4KS
         4r7dYASawOGcG9VkFnGzPVEzJUgqW7DFbOSnlcy134NGL0l+O0XFV2B2rIUOv8frZN
         rmdtRMOAKIK/A==
Message-ID: <8a3802ca-38a2-4baa-3e7e-8ab016eb98d5@kernel.org>
Date:   Wed, 16 Feb 2022 20:25:33 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Subject: Re: [PATCH net-next] ipv6/addrconf: ensure addrconf_verify_rtnl() has
 completed
Content-Language: en-US
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>
References: <20220216182037.3742-1-eric.dumazet@gmail.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220216182037.3742-1-eric.dumazet@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/16/22 11:20 AM, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Before freeing the hash table in addrconf_exit_net(),
> we need to make sure the work queue has completed,
> or risk NULL dereference or UAF.
> 
> Thus, use cancel_delayed_work_sync() to enforce this.
> We do not hold RTNL in addrconf_exit_net(), making this safe.
> 
> Fixes: 8805d13ff1b2 ("ipv6/addrconf: use one delayed work per netns")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>
> ---
>  net/ipv6/addrconf.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>

