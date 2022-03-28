Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC21B4E8D8B
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 07:45:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237647AbiC1Fqi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 01:46:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231955AbiC1Fqh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 01:46:37 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AD0F5006F
        for <netdev@vger.kernel.org>; Sun, 27 Mar 2022 22:44:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1648446297; x=1679982297;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=dQeECniiMobqnr06450Td/lQfvZTsastjnopkzaW51Y=;
  b=LqdSHK97bFxwnicsP96s7AqTXHbOi+G6lBzCjb0pwn2WWAufBAcqOQaX
   I4ctXIfqJXHBrX8XBW1NvMhatEDnH9tNJ4nVWy5U0QJjKbkxbVhPiOVdg
   zTUKgyVGf183F7n6ngfQcJOC+5BpGj2J/lKugpWLns+Ph8qkdKB4QAI7b
   ii2iuu+oCE6LSOV+QQVvhi8pd8YDysIyn3EbbUd2uoK0eXnRmkyo21Wdg
   3MYjLaBl5K2GDrFW5eyuKHhOeJjjQdCGlrbr13xur/7mE3NXRF+l2tpw8
   0Sa/0yGHFsG3CMelJECd739+GFJcWmot24x9uot7raNbbJDYPAfXka3IG
   w==;
X-IronPort-AV: E=Sophos;i="5.90,216,1643644800"; 
   d="scan'208";a="196420007"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 28 Mar 2022 13:44:56 +0800
IronPort-SDR: HLvxgYbxphqLfisD4t49ez+Pd08vZTwhxdkm7jZsz72aEk+dfcHvtt+/Rf6Vs3zzppI03pi05b
 XV+1lLIJtqMWU2JjLtCFUxHqUcEiUrtDmghGw9g0fHGV5M3nKGnXSsScnhJnw3XOtFZ5YDIKN7
 ncNhh4P6JJ2ZXvu1GSBwXO5bh9DSfJhx0AG11XuPKpdiaO1/sxegmj/HqRBLPV8iZfXUpoboPQ
 kclMxxUsyeRkvw2XKoU0OoUORsWtNbCnruIzLWfawoGjOqfeBded/0ZjizwNYsB/8asOZLTLbB
 N3kG9DE+GRfeI0y5qoOwPG5X
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Mar 2022 22:16:43 -0700
IronPort-SDR: IJQDd1OnnsmFq29acUSt/ePmL72tEQwjCpyfKavW1dbV3sazLJhVwFvX578PBEwEE9IX5qGwKL
 LSsZWo/aACOXsQUzU6z2K34eKQYgjNO9NXNesCURhE2VrscxJ4CYPkywHQfF1mf8L1g2arF+yA
 zLjyZC9bhtWcr4Zd5dOvSbMZxvOq9ss8gSn6lZRB99jBY6QzEu17XwTodK7mrzUyVbhz9J8zPQ
 4CFdfvmYrNCMXuPRjK+qQyKkt5xlHVahxj/3ctNVsgNKn20uisxprzk5IMm8cOiGjm5ZJiDWlz
 c8s=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Mar 2022 22:44:57 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4KRhVJ4VDdz1SVnx
        for <netdev@vger.kernel.org>; Sun, 27 Mar 2022 22:44:56 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1648446296; x=1651038297; bh=dQeECniiMobqnr06450Td/lQfvZTsastjno
        pkzaW51Y=; b=CnkXNbptBp/uAlk5E5ZgXOL+xv9oAM3kpgnnRLDJ+8itP+ON0/g
        BkADept+nizAgswuGrfYCFbGxD0FW+I22Uyx3iu2zk1L6YVSMi1ToJDJFKXdfOLb
        KTlngJqHe73E8C2NR1pk2RxJTNG/BuxGMZuzsLq/WqaZ/+fiQtyLDbYlyC3rEpjj
        MCqIThuSs5Dqhu1HFzYxpmmmmDi91o5VIsQcRIFY2DpkCP5lu2a3A0g3xUFa2plr
        AgPl/7BdKzboKsVsDwIi3qeOGAEqRmn0jinPUO/7izPwzbF72ZOJfP8p6WRJfY4n
        cbqAfmhZkNzb5DnTQH2VgyE497BHisgL5wA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id T0htCxSEyC85 for <netdev@vger.kernel.org>;
        Sun, 27 Mar 2022 22:44:56 -0700 (PDT)
Received: from [10.225.163.121] (unknown [10.225.163.121])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4KRhVH0RjTz1Rvlx;
        Sun, 27 Mar 2022 22:44:54 -0700 (PDT)
Message-ID: <2bc8f270-e402-5e34-8d87-6b02fe8ef777@opensource.wdc.com>
Date:   Mon, 28 Mar 2022 14:44:53 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v2] net: bnxt_ptp: fix compilation error
Content-Language: en-US
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Netdev <netdev@vger.kernel.org>,
        Pavan Chebbi <pavan.chebbi@broadcom.com>
References: <20220328033540.189778-1-damien.lemoal@opensource.wdc.com>
 <CACKFLi=+5NpbeHDkDdKLg9uyfiDw4NL0=q0=shfrAYhqP+z2=w@mail.gmail.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <CACKFLi=+5NpbeHDkDdKLg9uyfiDw4NL0=q0=shfrAYhqP+z2=w@mail.gmail.com>
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

On 3/28/22 14:36, Michael Chan wrote:
> On Sun, Mar 27, 2022 at 8:35 PM Damien Le Moal
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
>> Use the TSIO_PIN_VALID() macroin bnxt_ptp_enable() to check the result
>> of the calls to ptp_find_pin() in bnxt_ptp_enable() to fix this
>> compilation error.
>>
>> Fixes: 9e518f25802c ("bnxt_en: 1PPS functions to configure TSIO pins")
>> Cc: <stable@vger.kernel.org>
>> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
>> ---
>> Changes from v1:
>> * No need to change the TSIO_PIN_VALID() macro as pin_id is an unsigne=
d
>>   value.
>>
>>  drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c b/drivers/n=
et/ethernet/broadcom/bnxt/bnxt_ptp.c
>> index a0b321a19361..3c8fccbb9013 100644
>> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
>> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
>> @@ -390,7 +390,7 @@ static int bnxt_ptp_enable(struct ptp_clock_info *=
ptp_info,
>>                 /* Configure an External PPS IN */
>>                 pin_id =3D ptp_find_pin(ptp->ptp_clock, PTP_PF_EXTTS,
>>                                       rq->extts.index);
>> -               if (!on)
>> +               if (!on || !TSIO_PIN_VALID(pin_id))
>=20
> I think we need to return an error if !TSIO_PIN_VALID().  If we just
> break, we'll still use pin_id after the switch statement.
>=20
>>                         break;
>>                 rc =3D bnxt_ptp_cfg_pin(bp, pin_id, BNXT_PPS_PIN_PPS_I=
N);
>>                 if (rc)
>> @@ -403,7 +403,7 @@ static int bnxt_ptp_enable(struct ptp_clock_info *=
ptp_info,
>>                 /* Configure a Periodic PPS OUT */
>>                 pin_id =3D ptp_find_pin(ptp->ptp_clock, PTP_PF_PEROUT,
>>                                       rq->perout.index);
>> -               if (!on)
>> +               if (!on || !TSIO_PIN_VALID(pin_id))
>=20
> Same here.

The call to bnxt_ptp_cfg_pin() after the swith will return -ENOTSUPP for
invalid pin IDs. So I did not feel like adding more changes was necessary=
.

We can return an error if you insist, but what should it be ? -EINVAL ?
-ENODEV ? -ENOTSUPP ? Given that bnxt_ptp_cfg_pin() return -ENOTSUPP, we
could use that code.

>=20
>>                         break;
>>
>>                 rc =3D bnxt_ptp_cfg_pin(bp, pin_id, BNXT_PPS_PIN_PPS_O=
UT);
>> --
>> 2.35.1
>>


--=20
Damien Le Moal
Western Digital Research
