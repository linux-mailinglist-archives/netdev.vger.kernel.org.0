Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4D026B830A
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 21:47:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbjCMUq7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 16:46:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbjCMUq4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 16:46:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B01CB7C973
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 13:46:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 46DD7614C7
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 20:46:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C828C433D2;
        Mon, 13 Mar 2023 20:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678740414;
        bh=z5io68AxXIcUrFhzQ2G53H24PW5Wg88DDApGnm2cpMY=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=FyN4QnaNV1CItgZ70PqdnES6tApr0E1kkJL0ltcs3gMqaqwv6vnu52S9iy0bJo6YO
         R9fobCVxSI2dcckNFHvYP68pWLrjnFbDpqkwh8HvlDzu0yFZGRNMy/91BRNZE0E8KF
         fIFBI83NnUkvMWpHGwfKYkhaf1oUr9ki4ANIynYlEiU1LFptae1cE8Z+V16scbAat7
         H8rtAogWo6SBxNXO/2JXcQIQRRkRMmavfDm+RTSKK9//K3Iiqox9ryJgm4nfiu1WJS
         bGzjRAZwVqrMj+zJmDXcufYZtZ8xBv/8+ryoWFXE1PQXR04t88nRTZ/QIFE1wUjV9s
         hfRUtXVg4uDvA==
Message-ID: <0121dad1-8ae4-9b05-7d26-1afba472340f@kernel.org>
Date:   Mon, 13 Mar 2023 14:46:53 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.7.2
Subject: Re: [PATCH net-next 2/2] ipv6: remove one read_lock()/read_unlock()
 pair in rt6_check_neigh()
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com
References: <20230313201732.887488-1-edumazet@google.com>
 <20230313201732.887488-3-edumazet@google.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20230313201732.887488-3-edumazet@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/13/23 2:17 PM, Eric Dumazet wrote:
> rt6_check_neigh() uses read_lock() to protect n->nud_state reading.
> 
> This seems overkill and causes false sharing.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> ---
>  net/ipv6/route.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>

