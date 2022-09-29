Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B3A25EEFB6
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 09:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235171AbiI2HvJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 03:51:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234315AbiI2HvF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 03:51:05 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A54C57227;
        Thu, 29 Sep 2022 00:51:04 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id c198so722411pfc.13;
        Thu, 29 Sep 2022 00:51:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:user-agent:subject:cc:to:from:date:from:to:cc:subject
         :date;
        bh=yFvmqnF9YgT1RoX/KUss7lgqXi4Gu3CXoG1FdMemSQE=;
        b=ZmpQ5yGBMi6ylVxwdOyqP1m8Nlc+c0RSeH5eiAZdprmmc+hZpgzoz0UOXoSF3m4GF7
         gtqXs48XexYHVtDHegySkrOD3FCLqLUgi4vfjB3TSsjFhN+iReODI/MXF5jlouT5W+LR
         9OOg3F7GzTxWJ5hLNQBZ6KiyGrGKq6C+82SQdzfVmUAuE4kuHHuIF7J5J4lcA+ZV9DX8
         V2w/bLIaVDFbdRH/U4dpt2F0QC/ZkKn7g7A0renqiJ0TDj+Z3j/I3ATEC2WXIBGJkNmQ
         E2UiJtT+CnmhBdknuMzzhcMQdViqVzVzt/zw6onSYdmDkQV0rB8bk1Ea9TXut5gDcwcA
         7SHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:user-agent:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date;
        bh=yFvmqnF9YgT1RoX/KUss7lgqXi4Gu3CXoG1FdMemSQE=;
        b=qYZqCb5D9wJSNNapT/hI1CP37OBkdzz/02vK9Vv5zvujhVHYzuTD9ERulZ85+P48pY
         R2Tib2B4neFdfuBl1hUT+0KsZacnoRoMqBV6jRqdWmXmP0v/lXp7RwJ10J20vMtM6Wnw
         pWxxTu2INcZFkTlwzKC9ldTOmHuhCbz5fsEjz/iFBjdkIPgFLRCPPEf10JL+1qMhTCqO
         BPNDDvz7VZftFJj3wpDU398qQR2shXZtRwDEff1BVQ3dzrjDKt4OGAuZK3yZ1dU8DYcH
         oi1VjQ4bUDUpSrUF92RqcV1gcgbQBIZW1Dm2ljekHU69GTkhgfOh/oF1Pm47ZiSM/D4s
         BNOw==
X-Gm-Message-State: ACrzQf0sMj6Kaa+MBl4/9q30lNtgi9wO09x82uLPstwxluoLE4iDveU0
        vxNkJL2KbBjwUJeIeN6nPR9xbdVg0QQ=
X-Google-Smtp-Source: AMsMyM7o5IubPnHRuYknJLpMVIcn0X1JrIzc8nndiAKidbHHdc0KeAK/KwcZjLvQXp+NI5OrhI2KoQ==
X-Received: by 2002:aa7:9532:0:b0:53e:7875:39e1 with SMTP id c18-20020aa79532000000b0053e787539e1mr2195240pfp.82.1664437863536;
        Thu, 29 Sep 2022 00:51:03 -0700 (PDT)
Received: from ?IPv6:::1? ([2601:647:5e00:1473:68e8:ad15:75fc:a64c])
        by smtp.gmail.com with ESMTPSA id h8-20020a170902680800b00178ab008364sm5105685plk.37.2022.09.29.00.51.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Sep 2022 00:51:03 -0700 (PDT)
Date:   Thu, 29 Sep 2022 00:51:02 -0700
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Krzysztof Opasiak <k.opasiak@samsung.com>
CC:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] nfc: s3fwrn5: fix order of freeing resources
User-Agent: K-9 Mail for Android
In-Reply-To: <1b81d1ec-3050-b983-654b-52c955091274@linaro.org>
References: <20220929050426.955139-1-dmitry.torokhov@gmail.com> <f0982b75-ede3-cc56-1160-8fda0faae356@linaro.org> <26fd03ad-181c-97c5-f620-6ac296cf1829@linaro.org> <36AC4067-78C6-4986-8B97-591F93E266D8@gmail.com> <1b81d1ec-3050-b983-654b-52c955091274@linaro.org>
Message-ID: <DECCEB72-EE37-4DE4-A734-47A681195BDD@gmail.com>
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

On September 29, 2022 12:42:08 AM PDT, Krzysztof Kozlowski <krzysztof=2Ekoz=
lowski@linaro=2Eorg> wrote:
>On 29/09/2022 09:37, Dmitry Torokhov wrote:
>> On September 29, 2022 12:27:19 AM PDT, Krzysztof Kozlowski <krzysztof=
=2Ekozlowski@linaro=2Eorg> wrote:
>>> On 29/09/2022 09:26, Krzysztof Kozlowski wrote:
>>>> On 29/09/2022 07:04, Dmitry Torokhov wrote:
>>>>> Caution needs to be exercised when mixing together regular and manag=
ed
>>>>> resources=2E In case of this driver devm_request_threaded_irq() shou=
ld
>>>>> not be used, because it will result in the interrupt being freed too
>>>>> late, and there being a chance that it fires up at an inopportune
>>>>> moment and reference already freed data structures=2E
>>>>
>>>> Non-devm was so far recommended only for IRQF_SHARED, not for regular
>>>> ones=2E
>>=20
>> If we are absolutely sure there is no possibility of interrupts firing =
then devm
>> should be ok, but it is much safer not to use it=2E Or use custom devm =
actions
>> to free non-managed resources=2E
>
>I am not sure and the pattern itself is a bit risky, I agree=2E However
>the driver calls s3fwrn5_remove() which then calls
>s3fwrn5_phy_power_ctrl() which cuts the power via GPIO pin=2E I assume
>that the hardware should stop generating interrupts at this point=2E

Ok, fair enough=2E The GPIO is mandatory, so I guess the chip will be disa=
bled=2E

>
>>=20
>>>> Otherwise you have to fix half of Linux kernel drivers=2E=2E=2E=20
>>=20
>> Yes, if they are doing the wrong thing=2E
>
>What I meant, that this pattern appears pretty often=2E If we agree that
>this driver has a risky pattern (hardware might not be off after
>remove() callback), then we should maybe document it somewhere and
>include it in usual reviews=2E

I have been saying that mixing managed and non managed resource is
dangerous for years=2E Disabling clocks before shutting off interrupts, fr=
eeing
memory, etc, is not safe=2E The best approach with devm is all or nothing=
=2E

Thanks=2E

--=20
Dmitry
