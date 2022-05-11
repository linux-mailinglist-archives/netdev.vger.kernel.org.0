Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47B08522DC9
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 10:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242822AbiEKH7v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 03:59:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235522AbiEKH7t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 03:59:49 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79EB865D12
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 00:59:48 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id i1so1121633plg.7
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 00:59:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=peT7r8pDYHzB7rvEWL8t+lzxBsS2mteBeDziDEpDcxM=;
        b=fE4YTvXu0C/FrN8OkeXnm0r8eTWhe+lomko+A82CJexvcLb1a/Fp5vBVlncz4fCz5Q
         Q7PfUwnc3FS61FcjVFgNQ3QB33Hp5pCRtG3rqAHAw9RH6Gb1upkLDC/6hO6XPEhM8iOg
         cuPsYbZIoMBagF2MrMmcBZsaietcvTgS+/AjIdluAIjtfAHndhvof+LxPt1R8SfuwBy7
         GRZAn2QfTqMrbzaBgfcoPwBPnqc/NiSc1PnlSu05wlmYeIVbuLjGFan6JI1owGtB9Jrx
         CKg0fTi8inkJnR3O9MGKXVuJj0qi5ctgnZU4Hc2Ha4galV0PE1CjkJTO5txy9rlU5GrN
         dH6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=peT7r8pDYHzB7rvEWL8t+lzxBsS2mteBeDziDEpDcxM=;
        b=pFUaqfciTDnJRezZ+otXP/naLFPI5spNwdbgdfCG2FPJQZTiIVEoUtoXyn757q/QWt
         HcqFcvF1kEPXbOEr2HaaCgK2Y2T0Ftm7HfDF/NBryQAWayBc/9qdoQDqllGLGGPEe1Tj
         IwIlK2bBb4DmiEVXhzMlziZehL45usqjqleVpcs17nbQl8D8q1fve7wtW+fC/Dr685z4
         lfHYNUV7cwZhMTbfeebMqgQdGgJbX7KE7zQzmVJxihnd+g50V5s2LVywRZ6C+JtqO53k
         nVy+G44ey2YnXk30lskx7RaVyYcPSGqSbBDHtzwhOCHlK//HNAqbuiIZ2fzG5d0x98Yn
         Q0dQ==
X-Gm-Message-State: AOAM530RZ8UJnAf2Px69sF3+HtWFnuMrSDZHXj6bqK34U2TLrMdbqeHu
        D6KskZLJ8gnIXOLg4wO+dGE=
X-Google-Smtp-Source: ABdhPJz3YMcCAIB9HfabrwiBVOIssBIbO4SLBM1BBAhSOAV2R/8FT/VP7zGfq3FTxoKAc805KiBh6Q==
X-Received: by 2002:a17:90b:4b0d:b0:1dc:3d21:72c1 with SMTP id lx13-20020a17090b4b0d00b001dc3d2172c1mr4035859pjb.21.1652255987875;
        Wed, 11 May 2022 00:59:47 -0700 (PDT)
Received: from smtpclient.apple ([223.104.68.106])
        by smtp.gmail.com with ESMTPSA id c9-20020a621c09000000b0050dc762814bsm946308pfc.37.2022.05.11.00.59.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 May 2022 00:59:47 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.80.82.1.1\))
Subject: Re: [Intel-wired-lan] [PATCH] igb_ethtool: fix efficiency issues in
 igb_set_eeprom
From:   lixue liang <lixue.liang5086@gmail.com>
In-Reply-To: <8d7e86ad-932c-d08c-3131-762edd553b22@molgen.mpg.de>
Date:   Wed, 11 May 2022 15:59:41 +0800
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        anthony.l.nguyen@intel.com, Jakub Kicinski <kuba@kernel.org>,
        intel-wired-lan@lists.osuosl.org, Netdev <netdev@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <B0201E3D-98F5-490E-81CF-45B16A06760D@gmail.com>
References: <20220510012159.8924-1-lianglixue@greatwall.com.cn>
 <8d7e86ad-932c-d08c-3131-762edd553b22@molgen.mpg.de>
To:     Paul Menzel <pmenzel@molgen.mpg.de>
X-Mailer: Apple Mail (2.3696.80.82.1.1)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Paul,

Thank you very much for your reply and suggestions.I have made the =
corresponding changes according to your suggestion.

In addition, for the problem that the invalid mac address cannot load =
the igb driver, I personally think there is a better way to modify it,=20=

and I will resubmit the patch about igb_main.c.

It's the same question, but I may not know how to continue submitting =
new patches on this email, sorry about that.

> 2022=E5=B9=B45=E6=9C=8811=E6=97=A5 14:41=EF=BC=8CPaul Menzel =
<pmenzel@molgen.mpg.de> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Dear lianglixue,
>=20
>=20
> Thank you for your patch.
>=20
> Am 10.05.22 um 03:21 schrieb lianglixue:
>=20
> It=E2=80=99d be great if you spelled your name with spaces (if =
possible).
>=20
> Also, currently your Google Mail address would be used for the Author =
field. If you want to use your company(?) address, please add a From: =
line at the top.
>=20
>> Modify the value of eeprom in igb_set_eeprom. If the mac address
>> of i210 is changed to illegal, then in igp_probe in the
>> igb_main file, is_valid_eth_addr (netdev->dev_addr) exits
>> with an error, causing the igb driver to fail to load,
>> such as ethtool -E eth0 magic 0x15338086 offset 0 value 0x01.
>> In this way, the igb driver can no longer be loaded,
>> and the legal mac address cannot be recovered through ethtool;
>> add is_valid_eth_addr to igb_set_eeprom to determine
>> whether it is legal to rewrite, so as to avoid driver
>> errors due to illegal mac addresses.
>=20
> Please reflow the text for 75 characters per line.
>=20
>> Signed-off-by: lianglixue <lianglixue@greatwall.com.cn>
>> ---
>> drivers/net/ethernet/intel/igb/igb_ethtool.c | 7 +++++++
>> 1 file changed, 7 insertions(+)
>> diff --git a/drivers/net/ethernet/intel/igb/igb_ethtool.c =
b/drivers/net/ethernet/intel/igb/igb_ethtool.c
>> index 2a5782063f4c..30554fd684db 100644
>> --- a/drivers/net/ethernet/intel/igb/igb_ethtool.c
>> +++ b/drivers/net/ethernet/intel/igb/igb_ethtool.c
>> @@ -798,6 +798,13 @@ static int igb_set_eeprom(struct net_device =
*netdev,
>> 	if (eeprom->magic !=3D (hw->vendor_id | (hw->device_id << 16)))
>> 		return -EFAULT;
>> +	if (hw->mac.type =3D=3D e1000_i210 && eeprom->offset =3D=3D 0) {
>> +		if (!is_valid_ether_addr(bytes)) {
>> +			dev_err(&adapter->pdev->dev, "Invalid MAC =
Address for i210\n");
>> +			return -EINVAL;
>> +		}
>> +	}
>> +
>> 	max_len =3D hw->nvm.word_size * 2;
>> 	first_word =3D eeprom->offset >> 1;
>=20
>=20
> Kind regards,
>=20
> Paul

