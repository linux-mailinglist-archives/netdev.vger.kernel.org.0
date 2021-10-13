Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C656A42C065
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 14:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233571AbhJMMq5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 08:46:57 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:45651 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233922AbhJMMq5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 08:46:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1634129094; x=1665665094;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=SZJX07Mo+CZ6KEiPsTWRuPDYhJ7dV2qdSgL2k2wL41Q=;
  b=CtgMjpQiOEe6Cgf1eO7QvpjTyW8CGngnFcJG0G2kV0wwjU9bKM4tFMlS
   Wqvv+3VwGWa61tAvF1JqApVlZsK3PRE46ljTHMyjXhBx1vrVLonFP8iKC
   1LREJIGFJ1kLQUQ3h62UGTXXSfe5qeNAI7vPKAjW3NagRKp2xlfsIidgV
   8MjelMWLFLJZC8swX2PXhSuwFW6QGFHWLM0a5yXYtboWw0Q1GVo5bpgzQ
   6scrgUTCmCLwKegWvaJuzH1pWRkFpTST+nqc4pmySH29pS9PrMJt1qezp
   JuITY1VEjx93ko64fhuvA7I9tmYAz5Rcq+rHmnsZn5OfgUm5Ux3/NSOeq
   g==;
IronPort-SDR: 1vpNLFmuQu+pSmZQIMT4muy5UD5zmVX7z38Tz8L7jEBQFxPLYh6vUlJACFy+uLunIc+er9f1El
 6SadPTCTpBl7i0vVvj4YiDd4ZY0Le9dj9FetUaYxRxasbvMmgTBV5sIbmo/PaqSg1KGTYoxc4C
 Eofwwt4aQBFJnh3dUmS3py+n1yygdIfDkw6l/T51T1/rfGnpRc15+Cdu+WfEIdUSQtspSnprcH
 2InNUIiHpMKpQCf+unrC9SoxdRQcxj7/5tj5hPdN35f3dpU90tg/5BUUxMUa5EAIxkkjc0wfzY
 EXQfDZODPfnbcnl85hT/0NFg
X-IronPort-AV: E=Sophos;i="5.85,370,1624345200"; 
   d="scan'208";a="139561970"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Oct 2021 05:44:53 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Wed, 13 Oct 2021 05:44:52 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14 via Frontend Transport; Wed, 13 Oct 2021 05:44:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CPE5vrnWReBJ7/tziOe+Zfjz0H0jh/vdmywOTRE9pwjN9yY0+RUuouQ/9ai2Aw5i0S2UBhQWU9FZd9CdO/fiy3TX1bXbI/2TMpCHtYfvdj+LGzTHecfbdaOyUWWyaRsvV00pbQkQKqBQjnjdNFqoJdCLDgKcuOBW6bNxf4GNQre0qAqMZzjc0X+eVIL9OoAJExtP0NkPB0KTNV0Dm8F/ukYDBefPrH2IorIVv830oJCuSn3ZB2y9CgWLY+BQvx2/timWyxzj/UD8DjOS4AYvntSG6/Y7koJ4J71XZ2YDfCO1dFKZlZGgSgkISq/WyzmDWKZhwtjLuO5uy5PUb2yl8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SECMx9Qwa5TRL5hYbUdl+lI3Hvoj+BdSp9ripkATdaM=;
 b=JRh4QzfWFWGAred796A7pj2FVdL1O10WRjaqgU+oJA58Xpc6aQvIAJ3Gl+pw1+knxEMWOvpdxwQdDVvR5zsWG+UJ3+sLx/2kaDD2RAhqDKVOWOTljescbI8+b54qactUgaEezdwWabSbI20xGaULyN9mXwNF8LOteB08glZOY/CLlYdT3w/sNz83qQ+pBNgxPwnD0tlk5yT4kJelY9GAsGa7A6IQbjaX6TZ8f9WJ7fT6xVsccCKt47Zwg6WvfnZovhgN0W43eA5rhOo2hnDdZPcWHW5c+nXjTa4883lowAo51oNdlqvylHEcwQToVFHb0p6/6Qqr02EFwzALhgWbzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SECMx9Qwa5TRL5hYbUdl+lI3Hvoj+BdSp9ripkATdaM=;
 b=jwKQZo+IGk5mMQ7lETHZf2bJb4ybbaL9o8UA9H+nj2Nunr0Z/zYQ0glAx13phukIZErzskU6zkXFarb7N7HfaXJklhCouSizvlmF9kPm36UWI9U++iBVXyHmoKrIUO2ZOVzmZnhcUjEblkpiEwu175SbLHwLxRjCCzDGA+kEjI4=
Received: from CH0PR11MB5561.namprd11.prod.outlook.com (2603:10b6:610:d4::8)
 by CH0PR11MB5564.namprd11.prod.outlook.com (2603:10b6:610:d7::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.20; Wed, 13 Oct
 2021 12:44:46 +0000
Received: from CH0PR11MB5561.namprd11.prod.outlook.com
 ([fe80::4907:3693:d51c:af7e]) by CH0PR11MB5561.namprd11.prod.outlook.com
 ([fe80::4907:3693:d51c:af7e%9]) with mapi id 15.20.4587.026; Wed, 13 Oct 2021
 12:44:45 +0000
From:   <Yuiko.Oshino@microchip.com>
To:     <kuba@kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>, <richardcochran@gmail.com>
Subject: RE: [PATCH net-next] net: microchip: lan743x: add support for PTP
 pulse width (duty cycle)
Thread-Topic: [PATCH net-next] net: microchip: lan743x: add support for PTP
 pulse width (duty cycle)
Thread-Index: AQHXv3APHaVpeTKsFUOp5D2pQ5OlfavP6GcAgAD4kDA=
Date:   Wed, 13 Oct 2021 12:44:45 +0000
Message-ID: <CH0PR11MB5561CCFC048FBAD8C936E5898EB79@CH0PR11MB5561.namprd11.prod.outlook.com>
References: <1634046593-64312-1-git-send-email-yuiko.oshino@microchip.com>
 <20211012145350.0d7d96bb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211012145350.0d7d96bb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4dc16cc8-676b-4b2d-ca37-08d98e473c96
x-ms-traffictypediagnostic: CH0PR11MB5564:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH0PR11MB5564DD490085E36929572B418EB79@CH0PR11MB5564.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: azFQhDXU8e5TYcoW0Abg3IdSVxK90ptfnQv+SXGbLD+sOkQvS62PPs39eK7caQWuMlX9qd9vYsiZGXrshXwJ5+TJhyaFupvJMkaxtW1rzJxi3cz80jdJLp2xAHRXSXasjlgh+nBgk7dlmJ7iPJa/gh7i34EwR/FfkQ2QQvAyUBcSickkjMcpnDApguFMdrNFVwNs/IanJXkzCfjYGfXGkcX5xjZ9HzHkfT71Xb0PaeN7M0JtAmeYwypyGAyuDB+5DdgpeVYU/dKddBmK7jr1BN8pKG2fEbOahgUIU4Ymh03Cq4GzTH00lt3pFhHxZYq337+dZTC0FQ3E7fI9OX309L+GU8FTaOuaTXSKtoIZ9yHNerkE7Nv61i3sDYPrJw1WpImqF9ynRPfEBD0k9SdFM6oJCA9y1cldkIVUlPekCrx5bdSZjTsxOoABD0WUo/U0UtpTTE1aXbgah7GGnf4eUPvWVJAYvW4w3yfjqbPXRQL9iBR4G9qxDEfhsDdZYWAUlM6h045FktdVMiuh8uJE8NnJYDiUM/D4ERfm64jJrNg4Mbi902xqyanuAKNSAWLOvgsV6D6gFCPpNfyZnSDSpulvNTRvzP127LTsUDel8LgJvgyXtFZHmzQ67JvY7kVU1/1vVZS7w4nQyswuOyKY2ejbsAy2LM3gFIcVpFzoum/KEOTT+cpgJslaMaxRWuVGwAaFuGDwl8TY1SxKN7+G1Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5561.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(33656002)(9686003)(2906002)(55016002)(122000001)(4326008)(83380400001)(38070700005)(54906003)(8676002)(6916009)(26005)(71200400001)(5660300002)(38100700002)(66446008)(316002)(64756008)(66476007)(86362001)(8936002)(52536014)(7696005)(66556008)(508600001)(186003)(76116006)(6506007)(66946007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?HBzzGgMueSgZOWaL7wd5ga+NFgixMQg18U/VAJPfjVWT1zMh9/PeCr9Wk5uz?=
 =?us-ascii?Q?9Sy0oXl4dhHO8ete4SA/d1XfPPRQqjwdVZodaoLt7hZIBZI6dHt9BcElbI+N?=
 =?us-ascii?Q?Igl6qySq2Aag8b5FjZPjtDgvSZfJItgxFhol+MZQp77eNupuyNq5TFRNfAho?=
 =?us-ascii?Q?EkI/vdexsiCl0xpvJ9ISq/20ugxZdyg2POJ8KhF6t7x6MA8bsizzPt7y/fmI?=
 =?us-ascii?Q?sRgNN6+ZQYvSg6QM7FMtNIOJ6HfytAM+AqWFDY7yOm/DRn0cqXde2eJcNHyo?=
 =?us-ascii?Q?JjBPkQQR9jipOhRSnq918RWCbjObzzer/rSHP0skq8dRemsySnCwdK3W5pbv?=
 =?us-ascii?Q?fXJnWyYTGsbVVaMUefDGG1BsuZMBKKiLrpM2+tjBf1M9RissLZ6P3oCA3bur?=
 =?us-ascii?Q?qgaWAD7iyIpYocuJeKeoCXzJ+oQnn5ZQapU/Nb4NWAb+sZP1HPLzhj0Iv/Aj?=
 =?us-ascii?Q?fOTKVHwKZd39A2OoIUvu3/jWk6pkrbZertQjbfw9MXl6Fg0CXvXMVoA+r6Gd?=
 =?us-ascii?Q?iWBg9SK1hPTE3jKV49EYj3BdkcyUaoMMOLayE0rlWkZzYnCrL4/tlAuZW8EU?=
 =?us-ascii?Q?0wvzCXo5L6cuYHOx41nN27H91kFd2Hx2x8BO34GvFB7d7ZffYIUqDJWRgmqr?=
 =?us-ascii?Q?46qUP18BbiSDLgHBQ7a1yPX1AUBbkWCcPFLt33VAvyMGC5peHmqTwCfP93rL?=
 =?us-ascii?Q?4PSukHncX9OaRGHAKjC+DKjtZ8+1JCMkdzut8N4f/nOE9EMyO1UHwWZPO5/q?=
 =?us-ascii?Q?uzHa18w+3aDHbunlVUUDqN2s9Oe2OuleBYcQVmZRC9XzGtFc0krv4gHcGyfV?=
 =?us-ascii?Q?FjvRn6hWMxt8BrOE7r9b4VjIh8pM2ygxRiXWrUvbEWUKBrA9IaikIWOHHFSu?=
 =?us-ascii?Q?Y40whM2C9JDU5oLbOZ6XqAszL0lB0l6sQyUn4l1/DqqyZnzB5LqkLYq0JiSW?=
 =?us-ascii?Q?6Xntje1QwY85jpG0X1lt2DPestANFUFSFEeViawG3sCd2Pvj1aLnpltWl6Tn?=
 =?us-ascii?Q?9E4iGV7oSpox5u1B6crKezjyZa1jqE0NysFxlQlS3FtQIzaC8z/YkUuF+PI2?=
 =?us-ascii?Q?YyQoBT3wqCK8VzRI91PmlzLmmthQ4+3katNBmhq3+mkPiPmBKaRz5JLEBk0u?=
 =?us-ascii?Q?S0b1hHegXYevQdgB33oB/EAo5UqH/TpjCjP8Yjn/9UAdDQXm9t9/Jc1dqm/m?=
 =?us-ascii?Q?YpcWw0/Hg1q/HgNA2ZZmNiOgvv2rg7J7RSLqeaYSsBBiQbi7rxWDAM6O8c19?=
 =?us-ascii?Q?72Woo60xhlkqLxLChWudAWTzkltIyNyoC4qNyiWifB4E7JOz6uU+D4vz7XgR?=
 =?us-ascii?Q?csc=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5561.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4dc16cc8-676b-4b2d-ca37-08d98e473c96
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Oct 2021 12:44:45.9216
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8TDGn2FRQhSQU3SolEFTya1vOP0BWfnU3E5O1utyU8W2hAQlDXCv5/232srlhhIDcjBY0xuNzAnM7/gjpJ6bHu6XrSnDnNzbAeKKRRYq6Ko=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5564
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>-----Original Message-----
>From: Jakub Kicinski <kuba@kernel.org>
>Sent: Tuesday, October 12, 2021 5:54 PM
>To: Yuiko Oshino - C18177 <Yuiko.Oshino@microchip.com>
>Cc: davem@davemloft.net; netdev@vger.kernel.org; UNGLinuxDriver
><UNGLinuxDriver@microchip.com>; Richard Cochran
><richardcochran@gmail.com>
>Subject: Re: [PATCH net-next] net: microchip: lan743x: add support for PTP=
 pulse
>width (duty cycle)
>
>EXTERNAL EMAIL: Do not click links or open attachments unless you know the
>content is safe
>
>On Tue, 12 Oct 2021 09:49:53 -0400 yuiko.oshino@microchip.com wrote:
>> From: Yuiko Oshino <yuiko.oshino@microchip.com>
>>
>> If the PTP_PEROUT_DUTY_CYCLE flag is set, then check if the request_on
>> value in ptp_perout_request matches the pre-defined values or a toggle
>> option.
>> Return a failure if the value is not supported.
>>
>> Preserve the old behaviors if the PTP_PEROUT_DUTY_CYCLE flag is not
>> set.
>>
>> Tested with an oscilloscope on EVB-LAN7430:
>> e.g., to output PPS 1sec period 500mS on (high) to GPIO 2.
>>  ./testptp -L 2,2
>>  ./testptp -p 1000000000 -w 500000000
>>
>> Signed-off-by: Yuiko Oshino <yuiko.oshino@microchip.com>
>
>Please make sure to CC Richard on PTP-related changes.

I did not know. Thank you!

>
>> diff --git a/drivers/net/ethernet/microchip/lan743x_main.h
>> b/drivers/net/ethernet/microchip/lan743x_main.h
>> index 6080028c1df2..34c22eea0124 100644
>> --- a/drivers/net/ethernet/microchip/lan743x_main.h
>> +++ b/drivers/net/ethernet/microchip/lan743x_main.h
>> @@ -279,6 +279,7 @@
>>  #define PTP_GENERAL_CONFIG_CLOCK_EVENT_1MS_  (3)  #define
>> PTP_GENERAL_CONFIG_CLOCK_EVENT_10MS_ (4)
>>  #define PTP_GENERAL_CONFIG_CLOCK_EVENT_200MS_        (5)
>> +#define PTP_GENERAL_CONFIG_CLOCK_EVENT_TOGGLE_       (6)
>>  #define PTP_GENERAL_CONFIG_CLOCK_EVENT_X_SET_(channel, value) \
>>       (((value) & 0x7) << (1 + ((channel) << 2)))
>>  #define PTP_GENERAL_CONFIG_RELOAD_ADD_X_(channel)    (BIT((channel) <<
>2))
>> diff --git a/drivers/net/ethernet/microchip/lan743x_ptp.c
>> b/drivers/net/ethernet/microchip/lan743x_ptp.c
>> index ab6d719d40f0..9380e396f648 100644
>> --- a/drivers/net/ethernet/microchip/lan743x_ptp.c
>> +++ b/drivers/net/ethernet/microchip/lan743x_ptp.c
>> @@ -491,9 +491,10 @@ static int lan743x_ptp_perout(struct lan743x_adapte=
r
>*adapter, int on,
>>       int perout_pin =3D 0;
>>       unsigned int index =3D perout_request->index;
>>       struct lan743x_ptp_perout *perout =3D &ptp->perout[index];
>> +     int ret =3D 0;
>>
>>       /* Reject requests with unsupported flags */
>> -     if (perout_request->flags)
>> +     if (perout_request->flags & ~PTP_PEROUT_DUTY_CYCLE)
>>               return -EOPNOTSUPP;
>>
>>       if (on) {
>> @@ -518,6 +519,7 @@ static int lan743x_ptp_perout(struct lan743x_adapter
>*adapter, int on,
>>               netif_warn(adapter, drv, adapter->netdev,
>>                          "Failed to reserve event channel %d for PEROUT\=
n",
>>                          index);
>> +             ret =3D -EBUSY;
>>               goto failed;
>>       }
>>
>> @@ -529,6 +531,7 @@ static int lan743x_ptp_perout(struct lan743x_adapter
>*adapter, int on,
>>               netif_warn(adapter, drv, adapter->netdev,
>>                          "Failed to reserve gpio %d for PEROUT\n",
>>                          perout_pin);
>> +             ret =3D -EBUSY;
>>               goto failed;
>>       }
>>
>> @@ -540,27 +543,93 @@ static int lan743x_ptp_perout(struct
>lan743x_adapter *adapter, int on,
>>       period_sec +=3D perout_request->period.nsec / 1000000000;
>>       period_nsec =3D perout_request->period.nsec % 1000000000;
>>
>> -     if (period_sec =3D=3D 0) {
>> -             if (period_nsec >=3D 400000000) {
>> +     if (perout_request->flags & PTP_PEROUT_DUTY_CYCLE) {
>> +             struct timespec64 ts_on, ts_period;
>> +             s64 wf_high, period64, half;
>> +             s32 reminder;
>> +
>> +             ts_on.tv_sec =3D perout_request->on.sec;
>> +             ts_on.tv_nsec =3D perout_request->on.nsec;
>> +             wf_high =3D timespec64_to_ns(&ts_on);
>> +             ts_period.tv_sec =3D perout_request->period.sec;
>> +             ts_period.tv_nsec =3D perout_request->period.nsec;
>> +             period64 =3D timespec64_to_ns(&ts_period);
>> +
>> +             if (period64 < 200) {
>> +                     netif_warn(adapter, drv, adapter->netdev,
>> +                                "perout period too small, minimum is 20=
0nS\n");
>> +                     ret =3D -EOPNOTSUPP;
>> +                     goto failed;
>> +             }
>> +             if (wf_high >=3D period64) {
>> +                     netif_warn(adapter, drv, adapter->netdev,
>> +                                "pulse width must be smaller than perio=
d\n");
>> +                     ret =3D -EINVAL;
>> +                     goto failed;
>> +             }
>> +
>> +             /* Check if we can do 50% toggle on an even value of perio=
d.
>> +              * If the period number is odd, then check if the requeste=
d
>> +              * pulse width is the same as one of pre-defined width val=
ues.
>> +              * Otherwise, return failure.
>> +              */
>> +             half =3D div_s64_rem(period64, 2, &reminder);
>> +             if (!reminder) {
>> +                     if (half =3D=3D wf_high) {
>> +                             /* It's 50% match. Use the toggle option *=
/
>> +                             pulse_width =3D
>PTP_GENERAL_CONFIG_CLOCK_EVENT_TOGGLE_;
>> +                             /* In this case, devide period value by 2 =
*/
>> +                             ts_period =3D ns_to_timespec64(div_s64(per=
iod64, 2));
>> +                             period_sec =3D ts_period.tv_sec;
>> +                             period_nsec =3D ts_period.tv_nsec;
>> +
>> +                             goto program;
>> +                     }
>> +             }
>> +             /* if we can't do toggle, then the width option needs to b=
e the exact
>match */
>> +             if (wf_high =3D=3D 200000000) {
>>                       pulse_width =3D PTP_GENERAL_CONFIG_CLOCK_EVENT_200=
MS_;
>> -             } else if (period_nsec >=3D 20000000) {
>> +             } else if (wf_high =3D=3D 10000000) {
>>                       pulse_width =3D PTP_GENERAL_CONFIG_CLOCK_EVENT_10M=
S_;
>> -             } else if (period_nsec >=3D 2000000) {
>> +             } else if (wf_high =3D=3D 1000000) {
>>                       pulse_width =3D PTP_GENERAL_CONFIG_CLOCK_EVENT_1MS=
_;
>> -             } else if (period_nsec >=3D 200000) {
>> +             } else if (wf_high =3D=3D 100000) {
>>                       pulse_width =3D PTP_GENERAL_CONFIG_CLOCK_EVENT_100=
US_;
>> -             } else if (period_nsec >=3D 20000) {
>> +             } else if (wf_high =3D=3D 10000) {
>>                       pulse_width =3D PTP_GENERAL_CONFIG_CLOCK_EVENT_10U=
S_;
>> -             } else if (period_nsec >=3D 200) {
>> +             } else if (wf_high =3D=3D 100) {
>>                       pulse_width =3D PTP_GENERAL_CONFIG_CLOCK_EVENT_100=
NS_;
>>               } else {
>>                       netif_warn(adapter, drv, adapter->netdev,
>> -                                "perout period too small, minimum is 20=
0nS\n");
>> +                                "duty cycle specified is not supported\=
n");
>> +                     ret =3D -EOPNOTSUPP;
>>                       goto failed;
>>               }
>>       } else {
>> -             pulse_width =3D PTP_GENERAL_CONFIG_CLOCK_EVENT_200MS_;
>> +             if (period_sec =3D=3D 0) {
>> +                     if (period_nsec >=3D 400000000) {
>> +                             pulse_width =3D
>PTP_GENERAL_CONFIG_CLOCK_EVENT_200MS_;
>> +                     } else if (period_nsec >=3D 20000000) {
>> +                             pulse_width =3D PTP_GENERAL_CONFIG_CLOCK_E=
VENT_10MS_;
>> +                     } else if (period_nsec >=3D 2000000) {
>> +                             pulse_width =3D PTP_GENERAL_CONFIG_CLOCK_E=
VENT_1MS_;
>> +                     } else if (period_nsec >=3D 200000) {
>> +                             pulse_width =3D
>PTP_GENERAL_CONFIG_CLOCK_EVENT_100US_;
>> +                     } else if (period_nsec >=3D 20000) {
>> +                             pulse_width =3D PTP_GENERAL_CONFIG_CLOCK_E=
VENT_10US_;
>> +                     } else if (period_nsec >=3D 200) {
>> +                             pulse_width =3D
>PTP_GENERAL_CONFIG_CLOCK_EVENT_100NS_;
>> +                     } else {
>> +                             netif_warn(adapter, drv, adapter->netdev,
>> +                                        "perout period too small, minim=
um is 200nS\n");
>> +                             ret =3D -EOPNOTSUPP;
>> +                             goto failed;
>> +                     }
>> +             } else {
>> +                     pulse_width =3D PTP_GENERAL_CONFIG_CLOCK_EVENT_200=
MS_;
>> +             }
>>       }
>> +program:
>>
>>       /* turn off by setting target far in future */
>>       lan743x_csr_write(adapter,
>> @@ -599,7 +668,7 @@ static int lan743x_ptp_perout(struct
>> lan743x_adapter *adapter, int on,
>>
>>  failed:
>>       lan743x_ptp_perout_off(adapter, index);
>> -     return -ENODEV;
>> +     return ret;
>>  }
>>
>>  static int lan743x_ptpci_enable(struct ptp_clock_info *ptpci,

