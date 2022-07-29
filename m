Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAF9C584E0F
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 11:33:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234937AbiG2JdR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 05:33:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234698AbiG2JdQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 05:33:16 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC533140B1;
        Fri, 29 Jul 2022 02:33:15 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26T7VCTg005245;
        Fri, 29 Jul 2022 02:33:05 -0700
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2046.outbound.protection.outlook.com [104.47.57.46])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3hjyn8sp9t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Jul 2022 02:33:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lrOPgW0NMlKnb6fEYkss2IrHCBtb3xoQNtcr7Hdsp0maXoaPXWsXfbIgmlTJtQdlMgEagoSZzn6QOqvukGPYIETXqbySewOrnKZV2le57bG3iQaqFJG04f2Ype3sL4OmpB7cTscJeoeSU0OiwOJEnV+BsLjcjEepoO/ly+9iePN/e9gsfdNPKrtX3v5CZEUpz/cAzFJvHN5/mRUBqPuO7dOqdg5dEn8jbWGGeXBbce9chAhnYzW5OsKQ6AvneoUp8wZ6f53qmAJauHieIunnc/M/c887VQRKtFIW+o45BQCMtuPeaJ9BGrc4tzJ25GpuqwJ3Pp8+yrTSVgp4wlm5OQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uuFuHhF8WmDDZmK86jiRATzMt3USmnwq8+PBxyr2Eso=;
 b=hZ0YX+3uWobBJsiE2kkyBF00PDS3zEVhkhGIKdCnQQMhYmyhVkFdZzxZiRkA97XxBVxsdLry31Vh9y+8UgMI0E4Xz9Z8MIo5eAwjhmfLC8fwyntRqC/Ze9rluuogERmBn/I7lhirOGDz3e6bs2u8j1KwG6oeviqvYuANtChkfl88deba7oI5uP7Xfa0V1e581d22gcWWG2aIlN9ycdz5KehkSIIOrEZ3jZsNHufvxcGSdWf2DpwOqpQ1LGxNfKkByxvoOoPE5mdq1ZuDl+XaNf/Mhw2H7AfjYKwDosNovM86Pr/yTsV1hnIE/0+Rt4sd+1Lgr4pSbWYM+BhVk8vXig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uuFuHhF8WmDDZmK86jiRATzMt3USmnwq8+PBxyr2Eso=;
 b=rJtbN+t64QwrbLsVCXGYcCnQvTED6Fa9prybGELLnMYKQWoSH5IDqpkVheSrMIWrdryF2OiNYUgzbpT9meBaR5ehRx8qqkFAhV9zl/+qSs7BUaZXiw693fJhv9hEaG8M83BZFZWsc/7KEiGUZorxy220ut378lzAehARgTb/MMM=
Received: from CO1PR18MB4666.namprd18.prod.outlook.com (2603:10b6:303:e5::24)
 by MWHPR18MB1616.namprd18.prod.outlook.com (2603:10b6:300:cf::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.11; Fri, 29 Jul
 2022 09:33:03 +0000
Received: from CO1PR18MB4666.namprd18.prod.outlook.com
 ([fe80::f17d:2241:467a:eeb]) by CO1PR18MB4666.namprd18.prod.outlook.com
 ([fe80::f17d:2241:467a:eeb%7]) with mapi id 15.20.5482.011; Fri, 29 Jul 2022
 09:33:03 +0000
From:   Subbaraya Sundeep Bhatta <sbhatta@marvell.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Naveen Mamindlapalli <naveenm@marvell.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>
Subject: Re: [net PATCH] octeontx2-pf: Reduce minimum mtu size to 60
Thread-Topic: [net PATCH] octeontx2-pf: Reduce minimum mtu size to 60
Thread-Index: AQHYoy4zf4LbZ0cr1Uaj3A8adEB7Lg==
Date:   Fri, 29 Jul 2022 09:33:03 +0000
Message-ID: <CO1PR18MB46665FA74B25A50E98BE32FFA1999@CO1PR18MB4666.namprd18.prod.outlook.com>
References: <20220728123812.21974-1-naveenm@marvell.com>
 <YuMGMiFv8TAiUI11@lunn.ch>
In-Reply-To: <YuMGMiFv8TAiUI11@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2dda23a9-cb82-41e4-291a-08da714555bb
x-ms-traffictypediagnostic: MWHPR18MB1616:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7GUNSBFyR/Omi4HJ8lzlR/zPJNLrEP5Plr2j8EM07S8Z7wjSUmuItfFlXfmbzD6gUgCr7OGVFraY2/5w5qE/wCQ24H9aiA9YNoDQBPl4ODTmlcHjCeM/peOSu0d2fZLQn23eEDaxKyRNZsLpP3CINg2bs/wqqhLgR1fKUSO0GxMH2bLfYevOFnBR2VwuQbtWvyKozcN+KyKYC/s3V2e+Ltghtb9XqGH7UEcffrMMPaNwhEp/QK78vsnGyEeasbeQpevmhPmstb02RVYcwWoyeSpMHAt7cNi0OGJmB5pH4e6KLO4OTs+I4z0DD4FXIx7v3NWaIMfsD3hiIEZuHtNh+RGwULSJhqEgDcR1SPS/RKNrnaeWtV2i8I1Gvi3Nhf5/sFFcFEUJF17B+ta9k/IFVm4zVmizuMfaxpipKFSLtUKllWEEFCGdwBEHd8pp/8zkRIbP/t2IBnkZgW3xKL1gZpqaNTCW/d2jlZzZGJUpsh1hME5GfootEfYQ7j8dt81ETdR62m2F1MaGWbCkOijbDs4LWqoSRWcsXs78cisMDEE+/5phwSFUij0YtCeJJj5Hb2tfdmbXkpzu8ERweRmXhIS/yw3olOxofjvTCdJjKwNmsojyUIYxhCZL9Fca3R7g/NhFeapTiVwox3mmmpf2aj/H1Sg5u5oX6YMExJqdmoi+s/jIukBjXt2hzD7NDeHf6RUy6y99ul2xZB5Ud6D+8/4JSjwUWTmRO56WrV/st9P0O9HzDeThspP958aiqpmd198Xd4E93gxSh1j8bkR0EgZ1H7auXKyWoiVqet8i2zY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR18MB4666.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(396003)(376002)(136003)(366004)(39860400002)(316002)(64756008)(8676002)(66946007)(91956017)(66476007)(66556008)(122000001)(86362001)(4326008)(66446008)(5660300002)(76116006)(52536014)(38070700005)(2906002)(8936002)(38100700002)(478600001)(107886003)(186003)(33656002)(6506007)(7696005)(26005)(41300700001)(71200400001)(9686003)(55016003)(53546011)(54906003)(83380400001)(110136005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?gZaGpOZ2jpXDmLWxLwTNwNfIF2Py+vEwU50hEJEiu17w6RubhzB234Pi35?=
 =?iso-8859-1?Q?kkKCXEjlx0UBEY9VDTII5tkWDxsYTYAYEUT65cTBZCSN3/hTqPf3CtgwZ6?=
 =?iso-8859-1?Q?gqrUKbKNl/6HGoxkc5BIZyRQdwZNqmKOq7flDZwfpQu5Bhru+LvvwGr1AW?=
 =?iso-8859-1?Q?3QtOyWyanjfnn3Ws+XmvrXWhRYsKuqF5k56hvfO5u8Xws3plLRlaefZdf3?=
 =?iso-8859-1?Q?CVv74cS28UNRawVyUHCcsYp88mZc8mN5raI7bNbfvYF/OkTqHPej4WVXg8?=
 =?iso-8859-1?Q?PCaxBhBvDyLZO0mRjDzO6sPOxRWOzKpCmrfS2M4G5u1d3pABA5Cmga3W+g?=
 =?iso-8859-1?Q?muNvk//Ozag2m3qsh0xqAeYGR2YYuNbuTUasCdXErJhhPgfgK8gJhalbpj?=
 =?iso-8859-1?Q?/LiHRWApyn3km4sF0bgsZrKJdg0CHibaaltNQ0ftXroWTQMOJ8LFU1HMKy?=
 =?iso-8859-1?Q?j8Q39os6a7Lm4ElQ7cf8SdYSFKQbcWDwWOZzV/Cei044IJA2DrI/jD09Hs?=
 =?iso-8859-1?Q?Ql9ejbVPUTdk18s1R33ZcaLndPv8n7ERKr02MPCOe+KERLIhHQh2qCFkt3?=
 =?iso-8859-1?Q?gFr/l7ZiJ0N+Hf8F22mhfisOGFR0oCjg3mdfO24bEj1I4IQH1lYfJnRUkD?=
 =?iso-8859-1?Q?V1XJyCWjNnqeZV4enTb8JSizuq7d21uVWM/jEjNVdU/rpbt4oCbXGLSeoY?=
 =?iso-8859-1?Q?CKNMmcUsIovvlT+OoXRk2rSuroF5WrtDWZjkEwXmz1bF/6Qgd3J8FFgDNS?=
 =?iso-8859-1?Q?dqNDjlUmj1Mnaje3WxwtHay2Zh9rKHzSJkA+FQ56B3KJSkXm+8qmmhBUfg?=
 =?iso-8859-1?Q?iwswGaSv/FG6GjCu3Vog1/B6kDHgo/F+RQ2MkMJn5Xp7QdrsM9RCdRuDED?=
 =?iso-8859-1?Q?gKUoe1okofHGZGR80xRvYf4l3SSE0zWmvZC6QwL1DAvZ37Dw+YlcqIJUWe?=
 =?iso-8859-1?Q?Pb54zOSBO4MSJCmgg4Ts52UADASaSuRqiFBQI+YKAyFkSv8VKzl0N1GVR6?=
 =?iso-8859-1?Q?0LCZA/AxTH8znVXHU4giiZ28Q6iQeFaQCqskkckaoy6x6C/uI2cjt4gs4l?=
 =?iso-8859-1?Q?qupLDWVfBhhjVTBGrWYbxuC+Cxjn0xFzv3qLj3jsGuQ6C1F/l5LJPj9ZwK?=
 =?iso-8859-1?Q?pUBg89myvHDVH95S70TLH/tV8GjIpPTN7+oMLdANl0NBPGzTZqnkwKbSHK?=
 =?iso-8859-1?Q?qkdd1MBQFj8IwuhceZjRMQaxGXEs2AHmomO+HH6WX4y7d7+ymF7Jr43Par?=
 =?iso-8859-1?Q?FhQHSugwkr96uZw4jjIb20gevKrgjP9SGA28jvZb1M0I7MRoWkw4hGx3Y6?=
 =?iso-8859-1?Q?RzlBm7GxqHJ1bNslgjV8MWOfkIJsLFbNQyaS20UIWeYjZ+whzcUPKaMhiV?=
 =?iso-8859-1?Q?s1UQXw/NDslBErrTTlVWuxCjsbM5BJEI4/g4UFVwMSOFduV02rRpq9IOUM?=
 =?iso-8859-1?Q?75kOMS6/6c8gR8L8TSqlM0ZsZqZfWMxqXEJB7DCOJcExYUQ2aizV8jf6St?=
 =?iso-8859-1?Q?xgbACsIV8XQGWzjFJPM+KajXW4MiYLiykjrhTIdRnFmbczXACwdFkxunSp?=
 =?iso-8859-1?Q?bOQdDrJXRbcMQHrz3sed6tDPOebndGV+v6JtGiz/Wi1hA9bDsL6mel++Wu?=
 =?iso-8859-1?Q?P2JpYXMQjmOF50TQgnkWAoWZB2uYlfYlKX?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR18MB4666.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2dda23a9-cb82-41e4-291a-08da714555bb
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2022 09:33:03.1045
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gUwWzeOTUZz9TfHgW1yFLwiVJ1kYtIvJIOfTyansysQmFoL1UFpICi7vcPetKN2GbL31LzQ2XviRVOfo9GnCfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR18MB1616
X-Proofpoint-ORIG-GUID: VCg3VdYgZtJzMd724hFU8ff0qmSxCLXU
X-Proofpoint-GUID: VCg3VdYgZtJzMd724hFU8ff0qmSxCLXU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-28_06,2022-07-28_02,2022-06-22_01
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,=0A=
=0A=
Added PTP maintainer also in v2. We fixed this to work with latest ptp4l si=
nce after debugging we found=0A=
ptp4l complains bad message for Sync packets. =0A=
Lets hear from Richard.=0A=
=0A=
Thanks,=0A=
Sundeep=0A=
=0A=
________________________________________=0A=
From: Andrew Lunn <andrew@lunn.ch>=0A=
Sent: Friday, July 29, 2022 3:27 AM=0A=
To: Naveen Mamindlapalli=0A=
Cc: davem@davemloft.net; edumazet@google.com; kuba@kernel.org; pabeni@redha=
t.com; netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Sunil Kovvuri =
Goutham; Subbaraya Sundeep Bhatta=0A=
Re: [net PATCH] octeontx2-pf: Reduce minimum mtu size to 60=0A=
=0A=
----------------------------------------------------------------------=0A=
On Thu, Jul 28, 2022 at 06:08:12PM +0530, Naveen Mamindlapalli wrote:=0A=
> From: Subbaraya Sundeep <sbhatta@marvell.com>=0A=
>=0A=
> PTP messages like SYNC, FOLLOW_UP, DELAY_REQ are of size 58 bytes.=0A=
> Using a minimum packet length as 64 makes NIX to pad 6 bytes of=0A=
> zeroes while transmission. This is causing latest ptp4l application to=0A=
> emit errors since length in PTP header and received packet are not same.=
=0A=
> Padding upto 3 bytes is fine but more than that makes ptp4l to assume=0A=
> the pad bytes as a TLV. Hence reduce the size to 60 from 64.=0A=
=0A=
Please Cc: the PTP maintainer for changes like this.=0A=
=0A=
I also don't follow your explanation. At least for the original 802.3,=0A=
you had to pad packets shorter than 64 bytes, otherwise CSMA/CD did=0A=
not work. So i would expect PTP messages should be padded to 64?=0A=
=0A=
Or is you hardware doing the padding wrong, and this is a workaround=0A=
for that bug?=0A=
=0A=
    Andrew=0A=
