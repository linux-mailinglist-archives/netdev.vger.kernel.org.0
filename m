Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 849404E8E05
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 08:19:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238081AbiC1GUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 02:20:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238388AbiC1GUq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 02:20:46 -0400
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF6B54133B
        for <netdev@vger.kernel.org>; Sun, 27 Mar 2022 23:19:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1648448346; x=1679984346;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=RjuGAMSNpFhDL9R9KYQsF5lQuk3OXXCw1B6PseBdFbo=;
  b=iujPJ24Vg6X27jfVv07y/W8PYj6nIwEpjLx9cHAO/hCmhfpZUa4oE7fx
   FBMSLQYgopZvfwW27QApsv/GHOnncqQSCnE4I/RDzJfWgT+O7q5F+5XHE
   ZeUUpH/Bn5CLKB4VB/BhUqN39+dDftyIdDQldO3W+VW8ViKqO4jkCvpA/
   swi6Ogp1fwRxMMFYDIX06tfYVNfa1PGVFjdPt/7CHBIqYlMBsjwYGhY95
   bIP4dnobC2PLsd49pb6bOKxbzL4a2lUvomRyf4SWd351gquzeXShLMfjQ
   6AEvPGlns4Tk7kWYAEokYtKCHKrvW2zCs1n7zcDjzSm2J0FlawcKmy/zw
   g==;
X-IronPort-AV: E=Sophos;i="5.90,216,1643644800"; 
   d="scan'208";a="197333493"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 28 Mar 2022 14:19:06 +0800
IronPort-SDR: WwRGIh5YaC+eo3ybYwmOMJOxOL2JdwUpuAJTSXSuuBKVEtlibZih+cpkpS+LIVHnCGBrI5Cf3w
 JMv+UpLX4Qsil4hroLbkbQ9zrjzzuPTL2/Gju6De6zWkoq4UuWHicPXzJ4mVuFb0V2A/0V1oGT
 3Tr6qfirjxNrDtH5rSxD45UwLhLEhFJQn/f8fsEzBcTc5+WSONzWUfwfQR0OJ8LyWeQeWyhMUV
 P/5p294VT5hIep/nYWVZKfdo03BZ8KJU/C9szwYO3x+0wsQxJVT276yb7L4wrese+Jhi48yyET
 ZwYN3/XwYakD6lNUywgVKIuA
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Mar 2022 22:49:58 -0700
IronPort-SDR: jRdKe8cbOq9tqaRUkZfKkX9SJz2KNDKJDL32B3UTGjpeg/gh/Vn4aASawrXtexHPnRyZO1g26T
 15IIq5TWPnOHWcax964PWpaFhj5SguJWnfC/GlkOFXQzM/AzDLmexMycbpjacMO2jdlROux4bm
 jLiB+StaJiPHZT28Ty/Zs+OZdocVI36VkDmgai0MWC0TyAR7kQ5GkNP+r6dMDZRK1KKq8AwQJD
 okg1Il9B7fmCXDmdrcFh/bSiZx6jnvQdGIcMjYU4eUWd+vbuGaylIRdibLRzl9Xne7xeEKpqF6
 UdM=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Mar 2022 23:19:05 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4KRjFh46Hpz1SVp0
        for <netdev@vger.kernel.org>; Sun, 27 Mar 2022 23:19:04 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1648448343; x=1651040344; bh=RjuGAMSNpFhDL9R9KYQsF5lQuk3OXXCw1B6
        PseBdFbo=; b=sBBQmCyL7C50ulZGTdG0xXvnL9RMJkbYu+LMcb+FNcxh9+NNe3o
        NyaEAY+TaXpiu2fYPHizL2shSuiYoT8i036iI/Kgv/jJsEQ4Lq2WjzvJQlA8hgGH
        axYatkI2Z955SnClShfQ9NykX17/dSY2y4sKbLaqBYTvVYWpZBAgHo6IFUk1oIT5
        PzLrZ6cU/saebcw+e+XPnw1RViUyd5JA92Csq4PEyCvTlFhjXw2qhDcMH2paSD1D
        eV07zYs+gSj1EQrkDV7GHACuJ8j9B2KoGwZ7NDHhVLRJgHzFRBsbPEZqEcZBi/eX
        0KBcAQlTPoNthBEKr+IaYCTzyVGxs26ZNDA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id P-_3yhvuLGen for <netdev@vger.kernel.org>;
        Sun, 27 Mar 2022 23:19:03 -0700 (PDT)
Received: from [10.225.163.121] (unknown [10.225.163.121])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4KRjFf6yrYz1Rvlx;
        Sun, 27 Mar 2022 23:19:02 -0700 (PDT)
Message-ID: <83c47061-4f4f-6a92-b2b9-ad8cbb2da99a@opensource.wdc.com>
Date:   Mon, 28 Mar 2022 15:19:01 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v2] net: bnxt_ptp: fix compilation error
Content-Language: en-US
To:     Pavan Chebbi <pavan.chebbi@broadcom.com>
Cc:     Michael Chan <michael.chan@broadcom.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Netdev <netdev@vger.kernel.org>
References: <20220328033540.189778-1-damien.lemoal@opensource.wdc.com>
 <CACKFLi=+5NpbeHDkDdKLg9uyfiDw4NL0=q0=shfrAYhqP+z2=w@mail.gmail.com>
 <2bc8f270-e402-5e34-8d87-6b02fe8ef777@opensource.wdc.com>
 <CALs4sv3Wm+oNVZcnWScEk0f3zfLcnApn90iTPt0kSvhuzjXk1Q@mail.gmail.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <CALs4sv3Wm+oNVZcnWScEk0f3zfLcnApn90iTPt0kSvhuzjXk1Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/28/22 15:10, Pavan Chebbi wrote:
> On Mon, Mar 28, 2022 at 11:14 AM Damien Le Moal
> <damien.lemoal@opensource.wdc.com> wrote:
>>
>> On 3/28/22 14:36, Michael Chan wrote:
>>> On Sun, Mar 27, 2022 at 8:35 PM Damien Le Moal
>>> <damien.lemoal@opensource.wdc.com> wrote:
>>>>
>>>> The Broadcom bnxt_ptp driver does not compile with GCC 11.2.2 when
>>>> CONFIG_WERROR is enabled. The following error is generated:
>>>>
>>>> drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c: In function =E2=80=98=
bnxt_ptp_enable=E2=80=99:
>>>> drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c:400:43: error: array
>>>> subscript 255 is above array bounds of =E2=80=98struct pps_pin[4]=E2=
=80=99
>>>> [-Werror=3Darray-bounds]
>>>>   400 |  ptp->pps_info.pins[pin_id].event =3D BNXT_PPS_EVENT_EXTERNA=
L;
>>>>       |  ~~~~~~~~~~~~~~~~~~^~~~~~~~
>>>> In file included from drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c:=
20:
>>>> drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h:75:24: note: while
>>>> referencing =E2=80=98pins=E2=80=99
>>>>    75 |         struct pps_pin pins[BNXT_MAX_TSIO_PINS];
>>>>       |                        ^~~~
>>>> cc1: all warnings being treated as errors
>>>>
>>>> This is due to the function ptp_find_pin() returning a pin ID of -1 =
when
>>>> a valid pin is not found and this error never being checked.
>>>> Use the TSIO_PIN_VALID() macroin bnxt_ptp_enable() to check the resu=
lt
>>>> of the calls to ptp_find_pin() in bnxt_ptp_enable() to fix this
>>>> compilation error.
>>>>
>>>> Fixes: 9e518f25802c ("bnxt_en: 1PPS functions to configure TSIO pins=
")
>>>> Cc: <stable@vger.kernel.org>
>>>> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
>>>> ---
>>>> Changes from v1:
>>>> * No need to change the TSIO_PIN_VALID() macro as pin_id is an unsig=
ned
>>>>   value.
>>>>
>>>>  drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c | 4 ++--
>>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c b/drivers=
/net/ethernet/broadcom/bnxt/bnxt_ptp.c
>>>> index a0b321a19361..3c8fccbb9013 100644
>>>> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
>>>> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
>>>> @@ -390,7 +390,7 @@ static int bnxt_ptp_enable(struct ptp_clock_info=
 *ptp_info,
>>>>                 /* Configure an External PPS IN */
>>>>                 pin_id =3D ptp_find_pin(ptp->ptp_clock, PTP_PF_EXTTS=
,
>>>>                                       rq->extts.index);
>>>> -               if (!on)
>>>> +               if (!on || !TSIO_PIN_VALID(pin_id))
>>>
>>> I think we need to return an error if !TSIO_PIN_VALID().  If we just
>>> break, we'll still use pin_id after the switch statement.
>>>
>>>>                         break;
>>>>                 rc =3D bnxt_ptp_cfg_pin(bp, pin_id, BNXT_PPS_PIN_PPS=
_IN);
>>>>                 if (rc)
>>>> @@ -403,7 +403,7 @@ static int bnxt_ptp_enable(struct ptp_clock_info=
 *ptp_info,
>>>>                 /* Configure a Periodic PPS OUT */
>>>>                 pin_id =3D ptp_find_pin(ptp->ptp_clock, PTP_PF_PEROU=
T,
>>>>                                       rq->perout.index);
>>>> -               if (!on)
>>>> +               if (!on || !TSIO_PIN_VALID(pin_id))
>>>
>>> Same here.
>>
>> The call to bnxt_ptp_cfg_pin() after the swith will return -ENOTSUPP f=
or
>> invalid pin IDs. So I did not feel like adding more changes was necess=
ary.
>>
>> We can return an error if you insist, but what should it be ? -EINVAL =
?
>> -ENODEV ? -ENOTSUPP ? Given that bnxt_ptp_cfg_pin() return -ENOTSUPP, =
we
>> could use that code.
>=20
> Would it not be better if we add a check only to validate the
> ptp_find_pin is not returning -1
> explicitly? TSIO_PIN_VALID validates just the MAX side. So I think
> adding a check for -1 only
> is valid and won't duplicate the code inside the two functions.

I did that in v1, but pin_id is unsigned (u8). So changing
TSIO_PIN_VALID() to check for "pin >=3D 0" is a bit silly in this case.
But looking at other drivers using ptp_find_pin(), many do check the
return value first...

Sending a v3 with that check added.

>=20
>>
>>>
>>>>                         break;
>>>>
>>>>                 rc =3D bnxt_ptp_cfg_pin(bp, pin_id, BNXT_PPS_PIN_PPS=
_OUT);
>>>> --
>>>> 2.35.1
>>>>
>>
>>
>> --
>> Damien Le Moal
>> Western Digital Research


--=20
Damien Le Moal
Western Digital Research
