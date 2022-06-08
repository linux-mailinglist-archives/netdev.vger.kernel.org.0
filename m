Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72DB2543E9E
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 23:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236239AbiFHV33 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 17:29:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236212AbiFHV31 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 17:29:27 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D6B428F
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 14:29:20 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id 187so19415535pfu.9
        for <netdev@vger.kernel.org>; Wed, 08 Jun 2022 14:29:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=K8EjNsfsMMCDtxcdjawTmchaeNnCrPQsGjRCfNOh4V8=;
        b=ZbfHCpQhl7A8qqJ0vKA6ZTlVH4SIwnrTulf1q91xkb+zlUW0PNRQJ2OWa7F29C+SmX
         eiLDGGTmUXv7aTLCv188A/rmbDyDbdg+lnOfTf/eCvrLe7ChEayXN1ZGs5RYkHQXKzV8
         yLp9/b8Ulh9T9E9PJ0ewWYfInSQ2iRrg5+Z9dH4IMpZePmESFGALnTj1IyQeK56JQYTP
         8/ZYC6zI3jjlsgy07cYWFy+PClzuGsfOVLCZTUU/TJWr3byeXTxgHboA+ymj7Ij/Mz9z
         6WXUz+uQpJnaK5ItR7XcSvjev5IUP7+dv4UjL/bT88MGlr/PnX1z4rdddE+PaV1VKne5
         g0EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=K8EjNsfsMMCDtxcdjawTmchaeNnCrPQsGjRCfNOh4V8=;
        b=XD7m71Qi/8R1NEArEPOXGrz45rxIqBftRWmQZBUz/+khs3+8dHPcOnErbAeB8HglKG
         bx8nc0WVXh00DUyruaPMxsYQyRkJjA16Wehe5McTDql0e+GymY9cUryzIN8GlEFtXzxg
         TmmybBXbY7ECU2i8w9Ss9dzsKoSolTJ1cYTq4zHeWS/pUgvdckGLP+bZWG/Z4y7f1rSj
         gOuSPeiJNlZf2yM9kFxQ8v+q/qUF9JKphlCtfQOJoW2ZLS+7QJZV5R22EGezaGQ+m77l
         FzH5u1TSNQgDSKsVI7nQHvj0Ihe3z9JeSPVbfhT4FH9wRPskaNb7HXeCL/ystK0rVEFr
         KsjQ==
X-Gm-Message-State: AOAM532I6QR5HQwZ5oS2MQgGJ8fbtv6z4Wt9DyH0TfygYjnSJNrR5RmY
        ++rPG4VgQYIjZghtppspI9Q=
X-Google-Smtp-Source: ABdhPJyAK6YjxwyAVcCiuqgOAIjXrdi/PVyNQT2KtkTu1o40Ui4wErDfTcPGUlc1rszGsRf3f3nxfg==
X-Received: by 2002:a05:6a00:1989:b0:519:133c:737e with SMTP id d9-20020a056a00198900b00519133c737emr37130211pfl.26.1654723759957;
        Wed, 08 Jun 2022 14:29:19 -0700 (PDT)
Received: from [100.127.84.93] ([2620:10d:c090:400::4:f897])
        by smtp.gmail.com with ESMTPSA id f132-20020a636a8a000000b003fd31d64e23sm11222861pgc.63.2022.06.08.14.29.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 Jun 2022 14:29:19 -0700 (PDT)
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     netdev@vger.kernel.org, kernel-team@fb.com,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Lasse Johnsen <l@ssejohnsen.me>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>
Subject: Re: [PATCH net-next v6 2/3] net: phy: broadcom: Add PTP support for some Broadcom PHYs.
Date:   Wed, 08 Jun 2022 14:29:15 -0700
X-Mailer: MailMate (1.14r5852)
Message-ID: <BCC0CDAF-B59D-4A7A-ABDD-7DEBBADAF3A3@gmail.com>
In-Reply-To: <20220608205558.GB16693@hoboy.vegasvil.org>
References: <20220608204451.3124320-1-jonathan.lemon@gmail.com>
 <20220608204451.3124320-3-jonathan.lemon@gmail.com>
 <20220608205558.GB16693@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8 Jun 2022, at 13:55, Richard Cochran wrote:

> On Wed, Jun 08, 2022 at 01:44:50PM -0700, Jonathan Lemon wrote:
>> This adds PTP support for BCM54210E Broadcom PHYs, in particular,
>> the BCM54213PE, as used in the Rasperry PI CM4.  It has only been
>> tested on that hardware.
>
> ...
>
>> +static const struct ptp_clock_info bcm_ptp_clock_info = {
>> +	.owner		= THIS_MODULE,
>> +	.name		= KBUILD_MODNAME,
>> +	.max_adj	= 100000000,
>
> Does this really work?  See below.
>
>> +	.gettimex64	= bcm_ptp_gettimex,
>> +	.settime64	= bcm_ptp_settime,
>> +	.adjtime	= bcm_ptp_adjtime,
>> +	.adjfine	= bcm_ptp_adjfine,
>> +	.do_aux_work	= bcm_ptp_do_aux_work,
>> +};
>
> On another phy from the same (?) family (541xx), I found that the
> synch becomes unstable when slewing more than:
>
> 	port->caps.max_adj	= 62500,

The 100000000 value I probably copied from elsewhere.

For testing, I’ve been running ts2phc and ptp4l, and haven’t noticed any
problems - but may have just been lucky.

Do you have a stress test to verify one way or the other?
—
Jonathan
