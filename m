Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D714F584916
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 02:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233310AbiG2AdF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 20:33:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232169AbiG2AdE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 20:33:04 -0400
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BCAA192B0
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 17:33:03 -0700 (PDT)
Received: by mail-qv1-xf30.google.com with SMTP id i7so2607477qvr.8
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 17:33:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FuXfq54gaBU3WVJ8EGJbS+I/QmMnoh2/iow/WTEp/L4=;
        b=JeIXV8TnX9Vn1N/9taEForyaRS/P/4zAguz70tJvrL+F7CpeQx8iPdjWWxXsJHimXB
         7mySMytTDyYi4TcSNvuEvQUIcFZ5D1m0svCPlwVziJPyGWesF8+swfgznclIMSL4TM4K
         peMLTQrUzNkUuf1ydvwqk7qH8u7VoHNDhU4Cz1xoRLOuP1OrakfijL1q0JpCuBMeV7fq
         Jd6V+Hczh7FJAgB9urZA8DtDnSiB9L6GgfhrWiJbgmw0rYnL5WKCN3pLQbKS4z6XLfL1
         L3xjr13FmxbK5itLC9UQxZ7SQvcR00/dG6MQ7rHzK49yiWtcd82nE0JHdiUmhW/3Mdvq
         KuIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FuXfq54gaBU3WVJ8EGJbS+I/QmMnoh2/iow/WTEp/L4=;
        b=REwf5PO35VQe8UUghw4/kcJfrgGac+BhvnD6CM1xvsY5IAtEDkwRVFqt+cX/X1q5ak
         MQ6xfPCd8JmPQbRRP0iQFYSCoXH5S0PTyS3mzVLK3apsfPpQUyMFjaVqE5/P6drZaQZL
         g/eZEICWGCecsMLW1xe8MDiC0oG5IiQRBqSamdU19V+WZyHlZAEjKSJbZxIPqE+8jhEe
         dkFzGl4QefMJgjZQIt2tm6JJi4zzVjVPXYG0XZ2JD4hZZkerLB2wPoL9friMHdXIPWjb
         ecSKODBOklOJpZOnRjpY+/bfVkZzjdNAmsynCMZ+xYYN19bmszzOg9QGLXKAhfi9OqXs
         oFAw==
X-Gm-Message-State: ACgBeo0S4g53CIvDOi8by58g1L5a0UFSq+XwEyyYjwhmiKYuPLRvqCop
        CNMSjY/lDHiG8a5mj6nJOTWHMpGrw3o=
X-Google-Smtp-Source: AA6agR7ryaTeATixUU6TaRSDm0zmLIAXh5FROHfs/uCVmEvXz9mWMMMzkdWc3BmyOUdozr9CAFneRQ==
X-Received: by 2002:a05:6214:23c5:b0:470:2c64:fa2f with SMTP id hr5-20020a05621423c500b004702c64fa2fmr1511853qvb.64.1659054782515;
        Thu, 28 Jul 2022 17:33:02 -0700 (PDT)
Received: from [192.168.1.201] (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with ESMTPSA id t17-20020a37ea11000000b006b5bf5d45casm1485802qkj.27.2022.07.28.17.33.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jul 2022 17:33:01 -0700 (PDT)
Subject: Re: [PATCH 4/x] sunhme: switch to devres
To:     Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc:     netdev@vger.kernel.org
References: <4686583.GXAFRqVoOG@eto.sf-tec.de>
 <11922663.O9o76ZdvQC@eto.sf-tec.de>
 <00f00bdf-1a76-693f-5c8f-9b4ceaf76b91@gmail.com>
 <7685c7df-83ed-a3a0-6e61-42bd48713dc9@gmail.com>
 <8005d74d1e4ff2bdd75f8fefe70561a0@sf-tec.de>
From:   Sean Anderson <seanga2@gmail.com>
Message-ID: <7e286518-2f01-6042-4d23-94d8846774db@gmail.com>
Date:   Thu, 28 Jul 2022 20:33:01 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <8005d74d1e4ff2bdd75f8fefe70561a0@sf-tec.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/28/22 3:52 PM, Rolf Eike Beer wrote:
> Am 2022-07-27 05:58, schrieb Sean Anderson:
>> On 7/26/22 11:49 PM, Sean Anderson wrote:
>=20
>>> This looks good, but doesn't apply cleanly. I rebased it as follows:
>=20
> Looks like what my local rebase has also produced.
>=20
> The sentence about the leak from the commitmessage can be dropped then,=

> as this leak has already been fixed.
>=20
>>> diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet=
/sun/sunhme.c
>>> index eebe8c5f480c..e83774ffaa7a 100644
>>> --- a/drivers/net/ethernet/sun/sunhme.c
>>> +++ b/drivers/net/ethernet/sun/sunhme.c
>>> @@ -2990,21 +2990,23 @@ static int happy_meal_pci_probe(struct pci_de=
v *pdev,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 qp->happy_meal=
s[qfe_slot] =3D dev;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>>
>>> -=C2=A0=C2=A0=C2=A0 hpreg_res =3D pci_resource_start(pdev, 0);
>>> -=C2=A0=C2=A0=C2=A0 err =3D -ENODEV;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if ((pci_resource_flags(pdev, 0) & IOR=
ESOURCE_IO) !=3D 0) {
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 printk(KERN_ER=
R "happymeal(PCI): Cannot find proper PCI device base address.\n");
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto err_out_c=
lear_quattro;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>> -=C2=A0=C2=A0=C2=A0 if (pci_request_regions(pdev, DRV_NAME)) {
>>> +
>>> +=C2=A0=C2=A0=C2=A0 if (!devm_request_region(&pdev->dev, pci_resource=
_start(pdev, 0),
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pci_resource_len(pdev, 0),
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 DRV_NAME)) {
>>
>> Actually, it looks like you are failing to set err from these *m
>> calls, like what
>> you fixed in patch 3. Can you address this for v2?
>=20
> It returns NULL on error, there is no error code I can set.

So it does. A quick grep shows that most drivers return -EBUSY.

--Sean

