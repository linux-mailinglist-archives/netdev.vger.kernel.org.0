Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C76B5EEF36
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 09:37:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235291AbiI2HhS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 03:37:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234856AbiI2HhR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 03:37:17 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8A6F139405;
        Thu, 29 Sep 2022 00:37:16 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id a5-20020a17090aa50500b002008eeb040eso4757286pjq.1;
        Thu, 29 Sep 2022 00:37:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:user-agent:subject:cc:to:from:date:from:to:cc:subject
         :date;
        bh=lRDabKlu0VBYKSU5QYLvJ9Pkx/efyXICUlVHkJ+J9pg=;
        b=Nttqx33DDjsvYIs8B+hK2tXoTtHvH0ZKBEjCFvov78fIMR9/5CqDyljobcMqFdcm1E
         KrpSJkvN6Uct9iJ5zcrQhb3xQ5sz7DgSQVgI5ANQuGm+HWJR0J2tK9sKPE9TrxV/XIxb
         z3eNdyCFzSYFV4ZoIOiz9L4JlOqLcaGxTD81Uz+9TJFu37plCkW0CfT3gWVuNEG8ZGTb
         z88hxGhlm0RNp0x7MlqdUA89f1y6i/hCd9/rTZ01qKJoluqKat8Z1e77wp6ql8Kzsa2v
         rd0sIvoh/NpQmtrrNSePyfE/DEMpMmgzWNUzDUBQe72Wl5QeS8HXZTorwy47/31YFbbT
         ULXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:user-agent:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date;
        bh=lRDabKlu0VBYKSU5QYLvJ9Pkx/efyXICUlVHkJ+J9pg=;
        b=BFtO8Ufjdvj8H9IoBfBHcnSuBo6ciTBKJxFKMgm3l0SJfhs7nEDmZ6K7ISRoGerFcr
         QGpCV1Fn3zqKF510AfautKJ5/e5hj4S4EVMJ1wXEiSYE3HYj8pCfUPwc6n6mZu+l3cmB
         MRtloLkSqdI58vy8resA5IQ689dFla4bBMSKaxToxYNraNLNmVoKyS0/5SDk9Z5jVgZK
         iM0qe82NeApTKau4gpnAGwuorGoEYB3Eu7JZOeReFdwMuoAAMTIVotkDDSajBoUezz97
         v44TOIWtoFFB2CgJZM7GGYYDMFYg9b5t8aIFIXmRpwiMJP44Lk6jL0Gb0bDC0cUO9pkI
         XMHg==
X-Gm-Message-State: ACrzQf0A3BG5DNUT/2WEFpH6DIBRQLrkzBMpPwQLuLlJQtgiwc/G8lW7
        h3ts9oLu18caVvAJUm9qa+F1PMGqnv4=
X-Google-Smtp-Source: AMsMyM4moUqGZRua5IKM6m7W7rYR6IQ3QyvLqfSU/Pqfs6qWCO/2zBBDv2nTKLgSuc+nXlVseq5hqQ==
X-Received: by 2002:a17:90b:238c:b0:207:7040:9c6 with SMTP id mr12-20020a17090b238c00b00207704009c6mr2293079pjb.236.1664437035412;
        Thu, 29 Sep 2022 00:37:15 -0700 (PDT)
Received: from ?IPv6:::1? ([2601:647:5e00:1473:68e8:ad15:75fc:a64c])
        by smtp.gmail.com with ESMTPSA id n4-20020a170903110400b0016dcbdf9492sm5218950plh.92.2022.09.29.00.37.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Sep 2022 00:37:14 -0700 (PDT)
Date:   Thu, 29 Sep 2022 00:37:14 -0700
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Krzysztof Opasiak <k.opasiak@samsung.com>
CC:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] nfc: s3fwrn5: fix order of freeing resources
User-Agent: K-9 Mail for Android
In-Reply-To: <26fd03ad-181c-97c5-f620-6ac296cf1829@linaro.org>
References: <20220929050426.955139-1-dmitry.torokhov@gmail.com> <f0982b75-ede3-cc56-1160-8fda0faae356@linaro.org> <26fd03ad-181c-97c5-f620-6ac296cf1829@linaro.org>
Message-ID: <36AC4067-78C6-4986-8B97-591F93E266D8@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On September 29, 2022 12:27:19 AM PDT, Krzysztof Kozlowski <krzysztof=2Ekoz=
lowski@linaro=2Eorg> wrote:
>On 29/09/2022 09:26, Krzysztof Kozlowski wrote:
>> On 29/09/2022 07:04, Dmitry Torokhov wrote:
>>> Caution needs to be exercised when mixing together regular and managed
>>> resources=2E In case of this driver devm_request_threaded_irq() should
>>> not be used, because it will result in the interrupt being freed too
>>> late, and there being a chance that it fires up at an inopportune
>>> moment and reference already freed data structures=2E
>>=20
>> Non-devm was so far recommended only for IRQF_SHARED, not for regular
>> ones=2E

If we are absolutely sure there is no possibility of interrupts firing the=
n devm
should be ok, but it is much safer not to use it=2E Or use custom devm act=
ions
to free non-managed resources=2E

>> Otherwise you have to fix half of Linux kernel drivers=2E=2E=2E=20

Yes, if they are doing the wrong thing=2E

>> why is s3fwrn5 special?
>>=20

I simply happened to look at it=2E

>
>> Please use scripts/get_maintainers=2Epl to Cc also netdev folks=2E
>
>Ah, they are not printed for NFC drivers=2E So never mind last comment=2E
>
>Best regards,
>Krzysztof
>

Thanks=2E

--=20
Dmitry
