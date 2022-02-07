Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D37DB4AB4FA
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 07:41:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231396AbiBGG3u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 01:29:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242735AbiBGGIT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 01:08:19 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60DAFC043181;
        Sun,  6 Feb 2022 22:08:18 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id u12so3250160plq.10;
        Sun, 06 Feb 2022 22:08:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=PHS5WqAWZreqQEZLkxFcHhD/e2ICT/LSBM8dDEtfxbg=;
        b=QZDNjRLoskRVkeCj3CgednO7LBL+RNIVsMLnalremj/WJjLWx1P2PZI5vxO/ULGsYp
         Lx2ogV6lxbXecpE7M/5GtwyWvJjRFlmapc+dGEJN4sb8jlzJq0GchlpGdFXKmumhqyzu
         noTyBBFR7I9jxb7Laq4zD2xG9/MDpwErCzAGpPSQMRaywPX61vmSHpd9I9TWkj5mH4Xc
         mUHrp+zjO0z95dCCG0Oj1Bd4lqmhkH9WSOhRLtcqxStu1YcV6z5K/aSe8pmGH1HFkJGS
         pAmTEdRPEEE/QkwmIkJs+SAryWrAlgVpOklUY9FYjSUdEVPcO7c7vgjS4E7kSzQ5hTa0
         HqCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=PHS5WqAWZreqQEZLkxFcHhD/e2ICT/LSBM8dDEtfxbg=;
        b=n/pEPcHiuoJDEuOhY2QyC5w/djIL6fb47XgEsL9H8LN2snoroMoAekJXrLe8oLsUWs
         qDHWIAbzQUObZrTow6ZPJ9UygOd2d+naTcdMlrwYRuLl3WwaDAwJwLkYd56R+car/6jz
         2q56sXubTjgoQxs2XpFQDqpbjO/ysVCq64Xb+enPFPAhYr9rO0LDWFo64qCxHnvdRQIi
         bvCuqrs4vSMtfHCZFQ3Os8JXEfmdbqUD79tViTx+Y+THDG+5prmHhtYtIgmcQT0M8xi2
         J3S7t5fq8MJZQaIA4mnAtn3LfL3LwVtQZRq7ZbtOQ9Fw922fANLjGVY5rztNpTzDMdAV
         W9Og==
X-Gm-Message-State: AOAM532bnmbZ+y+rCoLGa/tBkj8e+I/vkAhyRTJuBocfEkarFq/v+62s
        t9DpiqLmqUWorFeTnUnp4vPBYw6PvkA=
X-Google-Smtp-Source: ABdhPJwdiFua/cXNLUkdANjjJNfOcsXYh110a+B0xwciURrp1YFvc5u9bJ6hyPsk1WaqHQzahHk4Hw==
X-Received: by 2002:a17:90b:249:: with SMTP id fz9mr16732914pjb.99.1644214097809;
        Sun, 06 Feb 2022 22:08:17 -0800 (PST)
Received: from [10.0.2.64] ([209.37.97.194])
        by smtp.googlemail.com with ESMTPSA id ns21sm19288525pjb.43.2022.02.06.22.08.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Feb 2022 22:08:17 -0800 (PST)
Message-ID: <b5514b41-4a1b-4b97-6d46-82d9334dcab2@gmail.com>
Date:   Sun, 6 Feb 2022 22:08:15 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH net-next 0/4] inet: Separate DSCP from ECN bits using new
 dscp_t type
Content-Language: en-US
To:     Guillaume Nault <gnault@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgense?= =?UTF-8?Q?n?= 
        <toke@redhat.com>, Shuah Khan <shuah@kernel.org>,
        linux-kselftest@vger.kernel.org,
        Russell Strong <russell@strong.id.au>,
        Dave Taht <dave.taht@gmail.com>
References: <cover.1643981839.git.gnault@redhat.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <cover.1643981839.git.gnault@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/4/22 5:58 AM, Guillaume Nault wrote:
> The networking stack currently doesn't clearly distinguish between DSCP
> and ECN bits. The entire DSCP+ECN bits are stored in u8 variables (or
> structure fields), and each part of the stack handles them in their own
> way, using different macros. This has created several bugs in the past
> and some uncommon code paths are still unfixed.
> 
> Such bugs generally manifest by selecting invalid routes because of ECN
> bits interfering with FIB routes and rules lookups (more details in the
> LPC 2021 talk[1] and in the RFC of this series[2]).
> 
> This patch series aims at preventing the introduction of such bugs (and
> detecting existing ones), by introducing a dscp_t type, representing
> "sanitised" DSCP values (that is, with no ECN information), as opposed
> to plain u8 values that contain both DSCP and ECN information. dscp_t
> makes it clear for the reader what we're working on, and Sparse can
> flag invalid interactions between dscp_t and plain u8.
> 
> This series converts only a few variables and structures:
> 
>   * Patch 1 converts the tclass field of struct fib6_rule. It
>     effectively forbids the use of ECN bits in the tos/dsfield option
>     of ip -6 rule. Rules now match packets solely based on their DSCP
>     bits, so ECN doesn't influence the result any more. This contrasts
>     with the previous behaviour where all 8 bits of the Traffic Class
>     field were used. It is believed that this change is acceptable as
>     matching ECN bits wasn't usable for IPv4, so only IPv6-only
>     deployments could be depending on it. Also the previous behaviour
>     made DSCP-based ip6-rules fail for packets with both a DSCP and an
>     ECN mark, which is another reason why any such deploy is unlikely.
> 
>   * Patch 2 converts the tos field of struct fib4_rule. This one too
>     effectively forbids defining ECN bits, this time in ip -4 rule.
>     Before that, setting ECN bit 1 was accepted, while ECN bit 0 was
>     rejected. But even when accepted, the rule would never match, as
>     the packets would have their ECN bits cleared before doing the
>     rule lookup.
> 
>   * Patch 3 converts the fc_tos field of struct fib_config. This is
>     equivalent to patch 2, but for IPv4 routes. Routes using a
>     tos/dsfield option with any ECN bit set is now rejected. Before
>     this patch, they were accepted but, as with ip4 rules, these routes
>     couldn't match any packet, since their ECN bits are cleared before
>     the lookup.
> 
>   * Patch 4 converts the fa_tos field of struct fib_alias. This one is
>     pure internal u8 to dscp_t conversion. While patches 1-3 had user
>     facing consequences, this patch shouldn't have any side effect and
>     is there to give an overview of what future conversion patches will
>     look like. Conversions are quite mechanical, but imply some code
>     churn, which is the price for the extra clarity a possibility of
>     type checking.
> 
> To summarise, all the behaviour changes required for the dscp_t type
> approach to work should be contained in patches 1-3. These changes are
> edge cases of ip-route and ip-rule that don't currently work properly.
> So they should be safe. Also, a kernel selftest is added for each of
> them.
> 

seems like the right directions to me.

Acked-by: David Ahern <dsahern@kernel.org>




