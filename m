Return-Path: <netdev+bounces-7223-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 127B871F194
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 20:21:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8789F1C210BD
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 18:21:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F30248256;
	Thu,  1 Jun 2023 18:21:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A59847017
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 18:21:27 +0000 (UTC)
Received: from MW2PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012004.outbound.protection.outlook.com [52.101.48.4])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E856F19D;
	Thu,  1 Jun 2023 11:21:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EAyLn394Jostiz6JU53A4pCghmSg+gMuhjivOpYMlfG+QQA4lD+69NhHNlj5ZiIkjBKsNaRqPR5W/v1FGQAMD2ae8mMRBznbM0NC5VTCQr811Yc6X3PHjxIG4kVyz3Prr3HmUTAahhdcjUaX9eVFCxWx0/xrBIlwR0ifDjKvfCDM8pBrdQ58Nm5faGGQxi7r/KB53iqCdrAQIdnk2BE81yXT2ptWzRfZqfgO7xtJZxOexc9z8QET/mbAoEF34i/flY3p5O92u6i6OQV5auzyVXB3wXNtbZbAc6qqxTTxF24O13Uq2HagVQdn5giQ+mbaq/zzF2CoXTS3E3u8+gkdug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MHoRpvw8HSyWR9vu8KTOeT9kWZQz8g9cVS9bFOkoSq4=;
 b=KCdMX60ZoiNLhwNo1+yJroW3ukNNzYecBNeLIyqgNNb1z3m2oimsrDG+fhICjhx0ZxtDTpSNeE4BlPG/CwxaGIqAektYjeSwOOT78NPezE2AWdF2Ei1TQygNbgiYCllJRiWHdjmoRQAmCj5kZIMU+ryXDaUDBo7d7RAc9hJrrETMdsDZj6BgsizH71mWSue7wz0ubVeU6JBn9EQdRccUGeOtClsdpASCZrGNsaXJtCdtgsZKU8uhUmhqNX2vhpyqhVkBvGJse2rUZ/wRJps9PIY7Ldlby6zDd453xSyAvYLIXSWZQ64Pu1kqkil2PMD/TsSWNfElSgSUcDjSi2oYiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MHoRpvw8HSyWR9vu8KTOeT9kWZQz8g9cVS9bFOkoSq4=;
 b=tbEK/Mysyn58peLRNVXPpY+KkVMBDE3kq/ZBYwPC3RNLehzrAEgWIZGN0DStPA9L8MbBnHVOG4LACzpVFz6Cub7ciPOzwkVdApR6tXm4aNgmO+PlEhvgCnGjX9wBlGu5J2aehG9T5E2PvaxeqjTteiDXVi5Z4ipxUaOzjBvmrmE=
Received: from DM6PR05MB5418.namprd05.prod.outlook.com (2603:10b6:5:5d::31) by
 SJ0PR05MB8152.namprd05.prod.outlook.com (2603:10b6:a03:395::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.22; Thu, 1 Jun
 2023 18:21:19 +0000
Received: from DM6PR05MB5418.namprd05.prod.outlook.com
 ([fe80::e933:485f:bd5b:a090]) by DM6PR05MB5418.namprd05.prod.outlook.com
 ([fe80::e933:485f:bd5b:a090%6]) with mapi id 15.20.6455.020; Thu, 1 Jun 2023
 18:21:19 +0000
From: Ashwin Dayanand Kamat <kashwindayan@vmware.com>
To: Simon Horman <simon.horman@corigine.com>
CC: Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, "David S . Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	"linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Alexey
 Makhalov <amakhalov@vmware.com>, Vasavi Sirnapalli <vsirnapalli@vmware.com>,
	Ajay Kaher <akaher@vmware.com>, Tapas Kundu <tkundu@vmware.com>, Keerthana
 Kalyanasundaram <keerthanak@vmware.com>
Subject: Re: [PATCH v2] net/sctp: Make sha1 as default algorithm if fips is
 enabled
Thread-Topic: [PATCH v2] net/sctp: Make sha1 as default algorithm if fips is
 enabled
Thread-Index:
 AQHZXMdG4h0xVBWDyEeNOj/spVySWK8HRTEAgAPH+wCAAFzigIBiu+UAgABrS4CACCDsgA==
Date: Thu, 1 Jun 2023 18:21:19 +0000
Message-ID: <9996C569-B942-4E46-978D-AF91C7543B53@vmware.com>
References: <1679493880-26421-1-git-send-email-kashwindayan@vmware.com>
 <ZBtpJO3ycoNHXj0p@corigine.com>
 <4BCFED42-2BBD-42B0-91C5-B12FEE000812@vmware.com>
 <964CD5A7-95E2-406D-9A52-F80390DC9F79@vmware.com>
 <B70BBC83-2B9F-4C49-943D-74C424EA4DCE@vmware.com>
 <ZHIQBUEvo49G9j/0@corigine.com>
In-Reply-To: <ZHIQBUEvo49G9j/0@corigine.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR05MB5418:EE_|SJ0PR05MB8152:EE_
x-ms-office365-filtering-correlation-id: f89b3755-018c-43c3-496c-08db62ccff3f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 QECUQXBdD+Gvzf6Wnv24BVYH8158eoszXsb89Ms8K/LYeb4ME94CeFLr1hBf8iCpnUowbuNHmD8WILUQG3l77hUgsk1lXvd50lfxsZRvAh+NxSPld5Wl9z26/SQSPWItQ1FsU2YKHpsiIwd0fNiu5JqrRBDh0nazFdvDBoJaGgeHK+JwIjzSRXmCdWCwIyA97VIbH4ZgxBN4tC+lOdX0fDIYMXlnFcilQqEEbfcdKUH3Etmgd4PkrDpTDkg9c/UYnJy+WqY0fr/iEcA1YCBGKZTCQXwZgzUMssSlSur6z5rT8u4+MsnkUbFPqVECUsvzVgzD/58GYeD/b5ApBPBRlIpNFEfh4QbNZzhhjG09wIY/lNBcH0jajAujDJJpG2kQjeL9gnPR1qwHX7fwKgCqqdNjtXMnb0BzbK2QYKa8PuNW3B7K5NuNwg/mNn3H7A5hbpXGvXOgD1Ma5FlTHP3mcI3f7EpocobcHSZoUIHWbzbYq0fgDd1KXyyWwG44uvYpmqNnX83n3SzGAkwvJwDuSyNu2GfY1pDtxKsizH56X2IGkOI9ETZ6oKGYGwphRmTR3MFsRYhsUXevztE69BiREXECvOtAEL/so12n72WeQU/Mhhlvafk3GuFnwvE2ZjmsEPSCssXof6/8vUigwe4fCA==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR05MB5418.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(366004)(136003)(39860400002)(396003)(451199021)(186003)(107886003)(41300700001)(38100700002)(2616005)(71200400001)(83380400001)(6506007)(6512007)(53546011)(6486002)(478600001)(54906003)(66946007)(122000001)(66556008)(4326008)(66476007)(64756008)(76116006)(316002)(91956017)(6916009)(7416002)(5660300002)(8676002)(8936002)(38070700005)(33656002)(86362001)(2906002)(66446008)(36756003)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?QSqqwVdaAgRqueQ5PuVaTY06dL/ZpI5Gbhom1WMnqvuuz0fGSMuSCkWh7NYW?=
 =?us-ascii?Q?TuRKrWTI+7UhrJMzUGIXgZ0fU4UcL1KPdzkazK3tzfI0KrFMuFb5eowbU9TG?=
 =?us-ascii?Q?nBuTbLgpFMwzeOfR1UgpbxdMtjfcr2PHIafB1HgegEnBcwLYCbd78J9auwue?=
 =?us-ascii?Q?jVXdzT779IC8HiFKUEjBVc9T9eoQUTwEIvSZOoU5S3YTf6WOju9cBgYbYpUd?=
 =?us-ascii?Q?wVJ9c2DD0uK7nM6cJGmEVNpLBg9tXnbeu1qQQBT+cBsj3GvYACVchJ/r45rp?=
 =?us-ascii?Q?CY9QeoqRNZ9kOekIVdpYv7c21HWegFfgBD8SU1qDBpzHipMD1m7Gq/icG5Cc?=
 =?us-ascii?Q?qWhjW+7NguwNbEDHoGHvfiQw9FSXZaPvM6B+uSkoiEVLYBX1eS0raR6T2d94?=
 =?us-ascii?Q?UHYRFkMyMwB5JkKrJ4TiTJLqPlj2gXuthomYXMJrcgG/M7UfPaEqUb8vbePz?=
 =?us-ascii?Q?j4en1og+bmpwONCC0vhYoiCYL5yC8yyWOY1ZaoX6Law00MN+j/p24Hvq3cQk?=
 =?us-ascii?Q?rhwKD5nsLp3v3qhkv5pHObI5ns3ivjen97hRXXMuabYx9rfPH+649Gd4vxn2?=
 =?us-ascii?Q?sSOaaLchbu1kMLEr2a8HaXGimW1P1AT49Yl0a52VWf0cRYG6oYr3vo4EIXlK?=
 =?us-ascii?Q?paxg+V1OGS7JQoN01Lr36OaRbu0wM/XKa6tIK3j6gLbbmljh2qX1MbJSwIGz?=
 =?us-ascii?Q?bJcpcP28dzlUEl8Vy4r7T5ZIqV9C+kqh8rjLClMDFRFGwfSK/0ytcIVbset4?=
 =?us-ascii?Q?t+Va9GMQl7tRtUwyULJL1e2bjjTcy/Jb/TqCvDeJ6OtCheCwu1d/OcegAgq6?=
 =?us-ascii?Q?6ZHxm/0iY4uInigWoKesxSJzupu5H+8gy7dSfUa//WBkHitKZLH8wc02DRJR?=
 =?us-ascii?Q?8ay53h3+WoH8mMS/cPS5ZVLqJMWIfsfF6XK22gwxVXebftQU2Xzg+3eS8T7M?=
 =?us-ascii?Q?k05rtlxzLjYK8Pvw1bB6yCtx/4+JOv4AYb5GO0PpKhtTz6jQRZw0u4PAahag?=
 =?us-ascii?Q?eWl1IdPKVdG2UY9WhKEoZvXbyHzR+PqarJagEntJGDHdHXtONM9xh+hl/QT/?=
 =?us-ascii?Q?IBn/SB9S3KB0Mvj9Wbv2D3wPDEGSLUU55p+142QRyLyDT6ZKvWbW98mjdtwG?=
 =?us-ascii?Q?Ol/nKzeeA+PxFXoLNtN/WrTQ5aiTTRMohR+WN862iqNtSOoMMrf0WYy0pJYI?=
 =?us-ascii?Q?pVf4yzQeO9WfAqg1y2beOU96UTOVDRwaXb10Ypu5Q+I/iUWe9uW4imtmN9TX?=
 =?us-ascii?Q?tHmb5zVC4dXOvo+DjF0Ux+lDtO6OZha/75fdMvQgjrGudXjVq+NQ+0zw4/0l?=
 =?us-ascii?Q?AVGDnXNM88y4WLGI5b8QaxzVC/B25wf39lLeLakiYZEE1nV+77QleNmWpMCG?=
 =?us-ascii?Q?FHVcBqmXY4nnVewTltHlmdySSr/TeJo2cwzyNScqaQ3zMqL5mRUcxo/0eIBj?=
 =?us-ascii?Q?kQtM85nQZYTyQhpvBV88DkBBo2ZgiJ7qFi71F84gO2lSG21aZ5xgjI7Qt93i?=
 =?us-ascii?Q?Fze7tt9VO9DElDrFFhyk7KZX9Y226GnU8by4894U0sEG2dE8fqv1SpwyN5ol?=
 =?us-ascii?Q?R+sOoErZed0KXaQrc4yQsDXGFPSP6f21GAeZO6gWsKcHuCZrKvPJUAxYdU3y?=
 =?us-ascii?Q?BalIFdYCuUD+Z/FXcvYTGtqVn6HoJ5+0Q+7vord31ppyLnsfT66x6ZvlZsTw?=
 =?us-ascii?Q?s07duQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <32D7682B59FBF54CAA422C71C536CA8D@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR05MB5418.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f89b3755-018c-43c3-496c-08db62ccff3f
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jun 2023 18:21:19.7865
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CsbtG+Id23hkdJaSTKPw2y3egrKgETjQ+b4aC0jXiksQev2jCpmeTULlB61Y4aVpRMC9ZVV9V4IddZg8odRVVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR05MB8152
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> On 27-May-2023, at 7:43 PM, Simon Horman <simon.horman@corigine.com> wrot=
e:
>=20
> !! External Email
>=20
> On Sat, May 27, 2023 at 07:49:26AM +0000, Ashwin Dayanand Kamat wrote:
>>=20
>>=20
>>> On 25-Mar-2023, at 12:03 PM, Ashwin Dayanand Kamat <kashwindayan@vmware=
.com> wrote:
>>>=20
>>>=20
>>>> On 23-Mar-2023, at 2:16 AM, Simon Horman <simon.horman@corigine.com> w=
rote:
>>>>=20
>>>> !! External Email
>>>>=20
>>>> On Wed, Mar 22, 2023 at 07:34:40PM +0530, Ashwin Dayanand Kamat wrote:
>>>>> MD5 is not FIPS compliant. But still md5 was used as the default
>>>>> algorithm for sctp if fips was enabled.
>>>>> Due to this, listen() system call in ltp tests was failing for sctp
>>>>> in fips environment, with below error message.
>>>>>=20
>>>>> [ 6397.892677] sctp: failed to load transform for md5: -2
>>>>>=20
>>>>> Fix is to not assign md5 as default algorithm for sctp
>>>>> if fips_enabled is true. Instead make sha1 as default algorithm.
>>>>>=20
>>>>> Fixes: ltp testcase failure "cve-2018-5803 sctp_big_chunk"
>>>>> Signed-off-by: Ashwin Dayanand Kamat <kashwindayan@vmware.com>
>>>>> ---
>>>>> v2:
>>>>> the listener can still fail if fips mode is enabled after
>>>>> that the netns is initialized. So taking action in sctp_listen_start(=
)
>>>>> and buming a ratelimited notice the selected hmac is changed due to f=
ips.
>>>>> ---
>>>>> net/sctp/socket.c | 10 ++++++++++
>>>>> 1 file changed, 10 insertions(+)
>>>>>=20
>>>>> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
>>>>> index b91616f819de..a1107f42869e 100644
>>>>> --- a/net/sctp/socket.c
>>>>> +++ b/net/sctp/socket.c
>>>>> @@ -49,6 +49,7 @@
>>>>> #include <linux/poll.h>
>>>>> #include <linux/init.h>
>>>>> #include <linux/slab.h>
>>>>> +#include <linux/fips.h>
>>>>> #include <linux/file.h>
>>>>> #include <linux/compat.h>
>>>>> #include <linux/rhashtable.h>
>>>>> @@ -8496,6 +8497,15 @@ static int sctp_listen_start(struct sock *sk, =
int backlog)
>>>>> struct crypto_shash *tfm =3D NULL;
>>>>> char alg[32];
>>>>>=20
>>>>> + if (fips_enabled && !strcmp(sp->sctp_hmac_alg, "md5")) {
>>>>> +#if (IS_ENABLED(CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1))
>>>>=20
>>>> I'm probably misunderstanding things, but would
>>>> IS_ENABLED(CONFIG_SCTP_COOKIE_HMAC_SHA1)
>>>> be more appropriate here?
>>>>=20
>>>=20
>>> Hi Simon,
>>> I have moved the same check from sctp_init() to here based on the revie=
w for v1 patch.
>>> Please let me know if there is any alternative which can be used?
>>>=20
>>> Thanks,
>>> Ashwin Kamat
>>>=20
>> Hi Team,
>> Any update on this?
>=20
> Hi Ashwin,
>=20
> I don't recall exactly what I was thinking 2 months ago.
> But looking at this a second time it seems that I may have misread your
> patch: I now have no objections to it in its original form.
Thanks Simon.
I have Updated the v3 patch with some minor changes.  Please review the sam=
e.

>=20
> !! External Email: This email originated from outside of the organization=
. Do not click links or open attachments unless you recognize the sender.


