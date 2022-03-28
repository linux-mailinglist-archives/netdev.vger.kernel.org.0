Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E82384E8E88
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 09:01:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235069AbiC1HCu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 03:02:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238649AbiC1HCr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 03:02:47 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BF59115D
        for <netdev@vger.kernel.org>; Mon, 28 Mar 2022 00:01:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1648450863; x=1679986863;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=L5sIGQxQZ10m1oP8yY0PjBEgZylHOhi8PoJRC1x63jU=;
  b=cr9RVsMutgTclQmymRMQbpSa8MzXcgbOUE6C6GCxyN2fA82y06cCcXn0
   gwWDfxrPqxEoN1jQ8shEy1FB7NHSR9sVfqpebi/K9vrnhIUbT5ysz+3t/
   Gkdif6aVoWxOC9sfNo/N50F4oeCG108m3gp3cYZP13K3r9ncGO3aUxqkz
   lsaRDyMHwD9K8We9wXaT2ELkZmmRQvcv9kZ1KE6BePW17Rn8BejamtJxi
   n4zYg3PX4NFiKvBCes0WWkZ6JXWIor/QnyxF0G32DfCK+9bMW1003ktb7
   mSB51TjyJtadUF9IJrwJHVaXcD6GYrtxoWxCyLbGcTblRi6snryzk6QBE
   A==;
X-IronPort-AV: E=Sophos;i="5.90,216,1643644800"; 
   d="scan'208";a="201266125"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 28 Mar 2022 15:01:03 +0800
IronPort-SDR: VdDvQEiMVKsWlXjEzT1yz1iFk+Qn5LS5imWfgPu0fauVUNnO3dBYhrsgv0vWy628fuFq5Hr9cG
 ngGj7Mzk5MDAlLh8KieQvsG9OgyMHJdEOLPNozF4748JB/mK8byHysZZb8f79LOZrvdV5Od8VA
 EhY40EvpMYaft+R55qcZRPclDzmOLi0KFHxDBC7Tx06EmFAYcUu9e3bDp8Y+yYhRtYGfpwk1fy
 HtP2KyC5EjQ20f8qPlGjOBZICdSmpRVvpWeZaDyJ+lyC0LxTa4OSQFTLB0I5pKmgGmvJkVsyA+
 zT7TXavXHIx6OPu5lWzC9efJ
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Mar 2022 23:32:51 -0700
IronPort-SDR: w5gO+wTCXWL7Resp0jHjc1mARfe7EWDOEgSHM1hmBgHMnWW6IrLJtXsMDnIhzkpqkjNT3MwE/y
 mICqT3C9bmWzkx/KNy65Bnd2phwQ0bgqEmM31/Dl5Ik44jFOeQhm46Jt+rguOYHk8++GONzLIB
 do5tbzxmwseUpoG7S1hTh79yrgjt8+0CXO93A+09bSvM6I6yCGO1EUMbvEYrgOUxlT7QVbk/DA
 qDSDKXhdGL23rJJPDlgOavtNAohv3J4LATO85p0vquQWlGBTi4RmF9bTfl4/8cmn0NwlJjMy6/
 lIw=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 28 Mar 2022 00:01:05 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4KRkB82blzz1SVny
        for <netdev@vger.kernel.org>; Mon, 28 Mar 2022 00:01:04 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1648450863; x=1651042864; bh=L5sIGQxQZ10m1oP8yY0PjBEgZylHOhi8PoJ
        RC1x63jU=; b=uNF+TQanmHu3tyzpQ0jEwdvlJ9y4jjGkfHhhnXcF88mY76AX8d5
        c3dqklqTNuPhrE9Hdl7snYTEB/FiGEIN9GJVnJ1A0+xwFJ2Z61BDIXfoW6qq0iM6
        8NaCbmrVEtbsyc2P63NbseyIXZVYXJKf3T5qOfwjXXksV21/7Ufs/5guzkqbLbrx
        O1zaySly5jrvXUfC+EJ16xSkWHSC7Pg7ARLJUYjl5xl7twJrlA9OEmpXzx7XyWq4
        Gnx17ka4i0F5/mKPmeaG/LoM80FxKUFbnxBDldUeaHqmeD47EcNra/Ym8tkAZAAb
        A6yrroSmrpur7tT7f60SQgt2DzPZr1YZQJw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id sXlvPJpXQwBs for <netdev@vger.kernel.org>;
        Mon, 28 Mar 2022 00:01:03 -0700 (PDT)
Received: from [10.225.163.121] (unknown [10.225.163.121])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4KRkB66zVdz1Rvlx;
        Mon, 28 Mar 2022 00:01:02 -0700 (PDT)
Message-ID: <03676250-34b4-27ac-4f50-4d507266c7a6@opensource.wdc.com>
Date:   Mon, 28 Mar 2022 16:01:01 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v3] net: bnxt_ptp: fix compilation error
Content-Language: en-US
To:     Pavan Chebbi <pavan.chebbi@broadcom.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Linux Netdev List <netdev@vger.kernel.org>
References: <20220328062708.207079-1-damien.lemoal@opensource.wdc.com>
 <CALs4sv2X4_VWkqDmA7E3Wi6CBFrAok+s-_MiL=S=a9uiP07otA@mail.gmail.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <CALs4sv2X4_VWkqDmA7E3Wi6CBFrAok+s-_MiL=S=a9uiP07otA@mail.gmail.com>
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

On 3/28/22 15:38, Pavan Chebbi wrote:
> On Mon, Mar 28, 2022 at 11:57 AM Damien Le Moal
> <damien.lemoal@opensource.wdc.com> wrote:
>>
>> The Broadcom bnxt_ptp driver does not compile with GCC 11.2.2 when
>> CONFIG_WERROR is enabled. The following error is generated:
>>
>> drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c: In function =E2=80=98bn=
xt_ptp_enable=E2=80=99:
>> drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c:400:43: error: array
>> subscript 255 is above array bounds of =E2=80=98struct pps_pin[4]=E2=80=
=99
>> [-Werror=3Darray-bounds]
>>   400 |  ptp->pps_info.pins[pin_id].event =3D BNXT_PPS_EVENT_EXTERNAL;
>>       |  ~~~~~~~~~~~~~~~~~~^~~~~~~~
>> In file included from drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c:20=
:
>> drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h:75:24: note: while
>> referencing =E2=80=98pins=E2=80=99
>>    75 |         struct pps_pin pins[BNXT_MAX_TSIO_PINS];
>>       |                        ^~~~
>> cc1: all warnings being treated as errors
>>
>> This is due to the function ptp_find_pin() returning a pin ID of -1 wh=
en
>> a valid pin is not found and this error never being checked.
>> Change the TSIO_PIN_VALID() function to also check that a pin ID is no=
t
>> negative and use this macro in bnxt_ptp_enable() to check the result o=
f
>> the calls to ptp_find_pin() to return an error early for invalid pins.
>> This fixes the compilation error.
>>
>> Fixes: 9e518f25802c ("bnxt_en: 1PPS functions to configure TSIO pins")
>> Cc: <stable@vger.kernel.org>
>> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
>> ---
>> Changes from v2:
>> * Restore the improved check in TSIO_PIN_VALID() and use this macro to
>>   return an error early in bnxt_ptp_enable() in case of invalid pin ID=
.
>> Changes from v1:
>> * No need to change the TSIO_PIN_VALID() macro as pin_id is an unsigne=
d
>>   value.
>>
>>  drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c | 6 +++++-
>>  drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h | 2 +-
>>  2 files changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c b/drivers/n=
et/ethernet/broadcom/bnxt/bnxt_ptp.c
>> index a0b321a19361..9c2ad5e67a5d 100644
>> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
>> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
>> @@ -382,7 +382,7 @@ static int bnxt_ptp_enable(struct ptp_clock_info *=
ptp_info,
>>         struct bnxt_ptp_cfg *ptp =3D container_of(ptp_info, struct bnx=
t_ptp_cfg,
>>                                                 ptp_info);
>>         struct bnxt *bp =3D ptp->bp;
>> -       u8 pin_id;
>> +       int pin_id;
>>         int rc;
>>
>>         switch (rq->type) {
>> @@ -390,6 +390,8 @@ static int bnxt_ptp_enable(struct ptp_clock_info *=
ptp_info,
>>                 /* Configure an External PPS IN */
>>                 pin_id =3D ptp_find_pin(ptp->ptp_clock, PTP_PF_EXTTS,
>>                                       rq->extts.index);
>> +               if (!TSIO_PIN_VALID(pin_id))
>> +                       return -EOPNOTSUPP;
>=20
> Thanks. Could we now remove this check from the function bnxt_ptp_cfg_p=
in() ?

Having a quick glance at all the call sites, it looks like it would be OK=
.
But may be in a different patch ?

This patch is not actually fixing any real problem. It is only fixing gcc
not being able to detect that pin_id can never be with an invalid value
since bnxt_ptp_cfg_pin() would fail before pin_id is used in the
assignment in bnxt_ptp_enable().

Thoughts ?

>=20
>>                 if (!on)
>>                         break;
>>                 rc =3D bnxt_ptp_cfg_pin(bp, pin_id, BNXT_PPS_PIN_PPS_I=
N);
>> @@ -403,6 +405,8 @@ static int bnxt_ptp_enable(struct ptp_clock_info *=
ptp_info,
>>                 /* Configure a Periodic PPS OUT */
>>                 pin_id =3D ptp_find_pin(ptp->ptp_clock, PTP_PF_PEROUT,
>>                                       rq->perout.index);
>> +               if (!TSIO_PIN_VALID(pin_id))
>> +                       return -EOPNOTSUPP;
>>                 if (!on)
>>                         break;
>>
>> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h b/drivers/n=
et/ethernet/broadcom/bnxt/bnxt_ptp.h
>> index 373baf45884b..530b9922608c 100644
>> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h
>> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h
>> @@ -31,7 +31,7 @@ struct pps_pin {
>>         u8 state;
>>  };
>>
>> -#define TSIO_PIN_VALID(pin) ((pin) < (BNXT_MAX_TSIO_PINS))
>> +#define TSIO_PIN_VALID(pin) ((pin) >=3D 0 && (pin) < (BNXT_MAX_TSIO_P=
INS))
>>
>>  #define EVENT_DATA2_PPS_EVENT_TYPE(data2)                            =
  \
>>         ((data2) & ASYNC_EVENT_CMPL_PPS_TIMESTAMP_EVENT_DATA2_EVENT_TY=
PE)
>> --
>> 2.35.1
>>


--=20
Damien Le Moal
Western Digital Research
