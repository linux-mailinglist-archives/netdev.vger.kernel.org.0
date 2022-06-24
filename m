Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64F64559A32
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 15:15:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231511AbiFXNOK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 09:14:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232131AbiFXNOE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 09:14:04 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40C264FC52
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 06:14:02 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id u9so3513922oiv.12
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 06:14:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :content-transfer-encoding:user-agent:mime-version;
        bh=Z1QNWitNpIhDD6xVRF3hfQnWEf2O3mgHXPvPI0LkFC0=;
        b=o/QNz/AHbDLfUvYIe0DVyRQbf2NiZNPpXcdLAQghiQkpOgbCnYoFBFYt+knQ8frfhj
         uExBLcUT1kl2GPAlkhYdTNl9zajh2y9ieatm/vqLtCW9Oa4+YrArrL5qfyjuLhYnrViM
         vu0a/RjTWufluq5veAoTd5wJGoHFXT5WddPPHYyaebZAIB8xSlNVPAHP2zjO2YE3Fq44
         a3LvQxdxAb/4Twsr8jG+LVAX07ckH42F+s5aoUyZlp428Zn5z0smInBIMgoNGZaa8Yqu
         nGS1qWNB8P6TKQuFdlsm2OKtUuwOqM29BXATU4UX7CbvSRUjd50LOCF8s0G1ipQ44aXp
         hcIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:content-transfer-encoding:user-agent:mime-version;
        bh=Z1QNWitNpIhDD6xVRF3hfQnWEf2O3mgHXPvPI0LkFC0=;
        b=kcvXc0PJL71wIgjl4MtYJlkMlEwbJen210B3PPpLG+pYJaYiVHsUGDB1dm+6Lgs2wo
         z7ZXg5Zv8UdVMNLJMY6PMqdAMeiRKG94QMQNUwPhPpJmFRqpnufupNAhWwEh3R2eSgs2
         fSrWwJO3GyW+YmDKw7Qe0Zm5QvZjsz7AhH2RlyemG1ztyL4E3QMNJQ+OCgRuMv5eC+gj
         Ey3fR0QaKaqseB2DKr+xT7Rkut2ONZDq/WPB4ZXS+TP1lK6x05ZoiGi6IsVTlwT3twP/
         s2oTQkGEffWWQe9c84Gy8oukIVEY8lssxwUXDhU3bOBiaOZ8fc8Ke3y5xVDtoeUholTE
         H+OA==
X-Gm-Message-State: AJIora+k6aT3WCiXfxfhCokBmtzsI5MtZ5NhLhvrQYPmu+nBAZ/vUsSr
        TV4uvrYFfzyG9oLOlsjB4ZB3zj3osPQ=
X-Google-Smtp-Source: AGRyM1vLDAAzpvwNXg99R12lAmWaq7O+2WewDnHNNf+K2liCeZk6c2dp0ZeZXmu5K2H3sBc2ABLp0Q==
X-Received: by 2002:a05:6808:1411:b0:335:174b:807e with SMTP id w17-20020a056808141100b00335174b807emr2024825oiv.67.1656076441613;
        Fri, 24 Jun 2022 06:14:01 -0700 (PDT)
Received: from ?IPv6:2804:14c:71:96e6:64c:ef9b:3df0:9e8d? ([2804:14c:71:96e6:64c:ef9b:3df0:9e8d])
        by smtp.gmail.com with ESMTPSA id k25-20020a9d7019000000b0060c5e0afa8dsm1534308otj.34.2022.06.24.06.14.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jun 2022 06:14:01 -0700 (PDT)
Message-ID: <80de8b6d88485fd6882d32a77d7a78777d5ae491.camel@gmail.com>
Subject: Re: [PATCH] net: usb: ax88179_178a: corrects packet receiving
From:   Jose Alonso <joalonsof@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Date:   Fri, 24 Jun 2022 10:13:58 -0300
In-Reply-To: <20220623214705.2ac24b16@kernel.org>
References: <9a2a2790acfd45bef2cd786dc92407bcd6c14448.camel@gmail.com>
         <20220623214705.2ac24b16@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.1 (3.44.1-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2022-06-23 at 21:47 -0700, Jakub Kicinski wrote:
> On Thu, 23 Jun 2022 11:06:05 -0300 Jose Alonso wrote:
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * In current firmware there=
 is 2 entries per packet.
>=20
> Do you know what FW version you have?
I don't know.

