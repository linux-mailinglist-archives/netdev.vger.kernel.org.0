Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FEA864B92F
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 17:04:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235529AbiLMQEM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 11:04:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231888AbiLMQEK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 11:04:10 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94D9920F41
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 08:04:04 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id 4so238330plj.3
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 08:04:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=yonsei-ac-kr.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=p7nELjFEyt08qzaYX+tdhdA8OCWRgud90hr8qeI+kFU=;
        b=FxpdeSdY5XArR0c1ht6LKaeUWTCIhUlmlKtTqgdL2G3GoG6vZpqVYmh/FjQA9GY+zv
         NcY7+0uFaIg1keChvqT9PrXn7cHLdOMJKiccOHv6XmWhjZAbMjj91E5HdN9czaXasY1y
         cuTERoMrgCxndxZ2qaIeilorAInyUDi530PSFtuIi9t//++m9hCYBz1eh6KJeZdoOG1Q
         OnS2NnAqJ/us1xKCSKK/et527179SAxZv17wRJYts6URyeZZtRPGh2+ts3whNZz5KWZD
         VyLT3RXLveb5KDWUreYCOAZmEwKE/ruQl0QzMt4NtO/uvfp5FglGZnRxCkzY1IC2p4SV
         gxjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p7nELjFEyt08qzaYX+tdhdA8OCWRgud90hr8qeI+kFU=;
        b=XYVzhwOwlpW5pAqX0PZmMWIVfUr/fTNUAwM/HZZ4+OMCdpfv9yYbC2CO5wlQfa4AoH
         MDO9rTS60Gl38gcD30ycBzA6ZrVE2YukK4a+FN08IPcqVz8Z+MUbTSPcTne7Q9WieoyK
         DpwXVIwOUERkSj1r+oXNDpVNm/kJtqecAyYBw36xQQGfPDn0ZGxWXI2rVeOR5UHG7qUn
         XluZR/EHekUYpL22nC8rlDqJrZmu/44xns4iMKn4tuWaEqoBwFE/ZWZC+u4JN83c4EVN
         8N56SpYzglzGk8afnvjQ1+IZJwvnrp0IgJnjtiqDDjMgdJZrfA0GYpvF+pEraVYfZHOG
         uiiQ==
X-Gm-Message-State: ANoB5plAmuR+NIQS0eFFcTP2vUTK/U8jlZuFmwPAErkri1Rlzqh5nLDz
        KtjX2wqMjP9Td1fVthLS9tbY6A==
X-Google-Smtp-Source: AA0mqf7OWmxIyQKMOg/jafGnCfi3iLynbuwivtQ0ewOBgrZ5iLVR2NjrO9XtDyDT+T/jpaJwHdb2cg==
X-Received: by 2002:a17:90b:4a8c:b0:219:e763:1d21 with SMTP id lp12-20020a17090b4a8c00b00219e7631d21mr21916572pjb.5.1670947444022;
        Tue, 13 Dec 2022 08:04:04 -0800 (PST)
Received: from medve-MS-7D32 ([165.132.118.52])
        by smtp.gmail.com with ESMTPSA id lj12-20020a17090b344c00b0021828120643sm7387495pjb.45.2022.12.13.08.04.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Dec 2022 08:04:03 -0800 (PST)
Date:   Wed, 14 Dec 2022 01:03:58 +0900
From:   Minsuk Kang <linuxlovemin@yonsei.ac.kr>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        netdev@vger.kernel.org
Cc:     linma@zju.edu.cn, davem@davemloft.net, sameo@linux.intel.com,
        linville@tuxdriver.com, dokyungs@yonsei.ac.kr,
        jisoo.jang@yonsei.ac.kr, Minsuk Kang <linuxlovemin@yonsei.ac.kr>
Subject: Re: Re: [PATCH net v2] nfc: pn533: Clear nfc_target before being used
Message-ID: <20221213160358.GA109198@medve-MS-7D32>
References: <20221213142746.108647-1-linuxlovemin@yonsei.ac.kr>
 <decda09c-34ed-ce22-13c4-2f12085e99bd@linaro.org>
 <cd3a1383-9d6a-19ad-fd6e-c45da7e646b4@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cd3a1383-9d6a-19ad-fd6e-c45da7e646b4@linaro.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 13, 2022 at 03:41:36PM +0100, Krzysztof Kozlowski wrote:
> On 13/12/2022 15:38, Krzysztof Kozlowski wrote:
> > On 13/12/2022 15:27, Minsuk Kang wrote:
> >> Fix a slab-out-of-bounds read that occurs in nla_put() called from
> >> nfc_genl_send_target() when target->sensb_res_len, which is duplicated
> >> from an nfc_target in pn533, is too large as the nfc_target is not
> >> properly initialized and retains garbage values. Clear nfc_targets with
> >> memset() before they are used.
> >>
> >> Found by a modified version of syzkaller.
> >>
> >> BUG: KASAN: slab-out-of-bounds in nla_put
> >> Call Trace:
> >>  memcpy
> >>  nla_put
> >>  nfc_genl_dump_targets
> >>  genl_lock_dumpit
> >>  netlink_dump
> >>  __netlink_dump_start
> >>  genl_family_rcv_msg_dumpit
> >>  genl_rcv_msg
> >>  netlink_rcv_skb
> >>  genl_rcv
> >>  netlink_unicast
> >>  netlink_sendmsg
> >>  sock_sendmsg
> >>  ____sys_sendmsg
> >>  ___sys_sendmsg
> >>  __sys_sendmsg
> >>  do_syscall_64
> >>
> >> Fixes: 673088fb42d0 ("NFC: pn533: Send ATR_REQ directly for active device detection")
> >> Fixes: 361f3cb7f9cf ("NFC: DEP link hook implementation for pn533")
> >> Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> > 
> > How did it happen? From where did you get it?
> 
> I double checked - I did not send it. This is some fake tag. Please do
> not add fake/invented/created tags with people's names.

Sorry for my confusion.

https://elixir.bootlin.com/linux/v5.17.1/source/Documentation/process/submitting-patches.rst#L505

I missed the definition of the tag as I did not read the document
carefully and misunderstood that the tag simply means I have got a
reply from maintainers and I should manually attach it if that is
the case. I will rewrite the patch after I make sure I fully
understand the whole rules.

Best regards,
Minsuk
