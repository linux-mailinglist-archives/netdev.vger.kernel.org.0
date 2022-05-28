Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 163B95369A2
	for <lists+netdev@lfdr.de>; Sat, 28 May 2022 03:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355345AbiE1BTY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 21:19:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230072AbiE1BTV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 21:19:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29E181269B6;
        Fri, 27 May 2022 18:19:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B5092B82637;
        Sat, 28 May 2022 01:19:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FF49C385A9;
        Sat, 28 May 2022 01:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653700757;
        bh=JKhuZuzj7rrWPpcjMl/vYJSvkb/t387A6sRohxD4yVo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=b81VP1GR2ARMhrupnq/aO7FT2BAPTwj0e9tQjzvHzuPLQFXiQN96nZ7vQKIeadg5f
         xzpBxh6y3jEblGolpCQ16H62hoOH7OVR6kiqnnAzOFa6Yq8mEtsicSlZA83iI9UXmZ
         XUQhjiMKSC0r512VWiTjbx+qztD48bSDQ6MQDgx1p5msXjEeUE/Kow/4Y9km3T4dPH
         5a/I2ME2aD5xlIta17M+qr2ftbd6RFvxu3LjCgaiZYdn3KiFQJXKxo71n3x7F5Mw4S
         8eB8JR7J3DDv+2G+nFVoVB4Gr3xgUmWVO/3fxFDkfLkTQIx1az3j8M5E2mt8xtmGlx
         fmeO+b0otUMkw==
Date:   Fri, 27 May 2022 18:19:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     menglong8.dong@gmail.com
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, nhorman@tuxdriver.com,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        imagedong@tencent.com, dsahern@kernel.org, talalahmad@google.com,
        keescook@chromium.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH net-next 3/3] net: dropreason: reformat the comment fo
 skb drop reasons
Message-ID: <20220527181915.6e776577@kernel.org>
In-Reply-To: <20220527071522.116422-4-imagedong@tencent.com>
References: <20220527071522.116422-1-imagedong@tencent.com>
        <20220527071522.116422-4-imagedong@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 27 May 2022 15:15:22 +0800 menglong8.dong@gmail.com wrote:
> From: Menglong Dong <imagedong@tencent.com>
> 
> To make the code clear, reformat the comment in dropreason.h to k-doc
> style.
> 
> Now, the comment can pass the check of kernel-doc without warnning:
> 
> $ ./scripts/kernel-doc -v -none include/linux/dropreason.h
> include/linux/dropreason.h:7: info: Scanning doc for enum skb_drop_reason
> 
> Signed-off-by: Menglong Dong <imagedong@tencent.com>

I feel bad for suggesting this after you reformatted all the values 
but could we use inline notation here? With a huge enum like this
there's a lot of scrolling between documentation and the value.

/**
 * enum skb_drop_reason - the reasons of skb drops
 *
 * The reason of skb drop, which is used in kfree_skb_reason().
 * en...maybe they should be splited by group?
 */
 enum skb_drop_reason {
	/**
	 * @SKB_NOT_DROPPED_YET: skb is not dropped yet (used for no-drop case)
	 */
 	SKB_NOT_DROPPED_YET = 0,
	/** @SKB_DROP_REASON_NOT_SPECIFIED: drop reason is not specified */
	SKB_DROP_REASON_NOT_SPECIFIED,
	/** @SKB_DROP_REASON_NO_SOCKET: socket not found */
	SKB_DROP_REASON_NO_SOCKET,
...
