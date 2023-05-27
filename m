Return-Path: <netdev+bounces-5858-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 271C771332B
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 09:49:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5814328192C
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 07:49:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E846A742C6;
	Sat, 27 May 2023 07:49:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DADE87E
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 07:49:30 +0000 (UTC)
Received: from CY4PR02CU007.outbound.protection.outlook.com (mail-westcentralusazon11011001.outbound.protection.outlook.com [40.93.199.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25624C9;
	Sat, 27 May 2023 00:49:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CnmC/dGNbxqVbg408eJLacq1rtdaSqttTg4jBiJNt0lsfTQjSBocBxEiNn/LxKmxbdUdoOmwPyNW54km2yR77gpSTReFHghqhnf67brIq/cdZ1gqYBLbVmi2RSJFiuNCyHtY4Ai1ZeyBXQC4rFB7xItclyXVgBlAzCgvRTpAvwp8zZCnZ0drfSVKM6DXWm4kZkM8bT4dnOw/YKhe1O8AlgqMAv4/tZ1gMPELLo5jTQboyLBRV17WeqHFRB4nC9dbg3Iyl6WmzxifiQsO0JJJlmj5DfGNRzKAYkknwKpPmpe2+O9U5eVhGjq1d2GMvVd1dQVYaRG388XKeBP+/FvZRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EB4WTB1YazPEJPZMiX4RVzGx1ItdLcV9gspk7oPhcuc=;
 b=IVYhQCr/Ru4RBybPcEEbzifNQpNWWoUoJXDbNuQ2tUzJmIfZfiYYZRW/KlRouyO2wi4WS8kvAks/DE5m0fN6maheVvX0BiWoqg3Cc2pyWA1iO9dcAmvowOzVilU+d93jeWRyCUOrmq/5a/f7x41tjXl3LGLFKu/6KdKgF7TgG3Ta2w/FqKdAWayf4Hy4zacTnx9YDYxld9xq6KlIzs6MF7u5H1LPfNrDbIb+zKthvXyIAURoRpMSgoIzqrpUyffDB8SoCFmmz2pQLvdmsz5quBkvk1WJso1P2NvNMXmPW46+gcAPacx7HKPqEheeH3/enp+k07w/QPiKZxeVnSD/aQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EB4WTB1YazPEJPZMiX4RVzGx1ItdLcV9gspk7oPhcuc=;
 b=L9QhB/0pCfTlKKqjCt/MD9/jLUuqYlI9skkWSU1VXJQVBaOXqUDq/2m9bl1Qu6TxCkfxnjqfP1cNaaYs4EVt9awCBW6m0YYMRoma2zaZbbo+QDYcZZHgi6Zb89MnQyr04jLU4a7RaW6OlNBLy/gE4JcplKkA+QlScVCYgZ3wSaY=
Received: from BL0PR05MB5409.namprd05.prod.outlook.com (2603:10b6:208:6e::17)
 by SJ0PR05MB8760.namprd05.prod.outlook.com (2603:10b6:a03:389::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.19; Sat, 27 May
 2023 07:49:26 +0000
Received: from BL0PR05MB5409.namprd05.prod.outlook.com
 ([fe80::65aa:236f:5a07:fd78]) by BL0PR05MB5409.namprd05.prod.outlook.com
 ([fe80::65aa:236f:5a07:fd78%4]) with mapi id 15.20.6433.018; Sat, 27 May 2023
 07:49:26 +0000
From: Ashwin Dayanand Kamat <kashwindayan@vmware.com>
To: Simon Horman <simon.horman@corigine.com>
CC: Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, "David S . Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	"linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Srivatsa Bhat
	<srivatsab@vmware.com>, "srivatsa@csail.mit.edu" <srivatsa@csail.mit.edu>,
	Alexey Makhalov <amakhalov@vmware.com>, Vasavi Sirnapalli
	<vsirnapalli@vmware.com>, Ajay Kaher <akaher@vmware.com>, Tapas Kundu
	<tkundu@vmware.com>, Keerthana Kalyanasundaram <keerthanak@vmware.com>
Subject: Re: [PATCH v2] net/sctp: Make sha1 as default algorithm if fips is
 enabled
Thread-Topic: [PATCH v2] net/sctp: Make sha1 as default algorithm if fips is
 enabled
Thread-Index: AQHZXMdG4h0xVBWDyEeNOj/spVySWK8HRTEAgAPH+wCAAFzigIBiu+UA
Date: Sat, 27 May 2023 07:49:26 +0000
Message-ID: <B70BBC83-2B9F-4C49-943D-74C424EA4DCE@vmware.com>
References: <1679493880-26421-1-git-send-email-kashwindayan@vmware.com>
 <ZBtpJO3ycoNHXj0p@corigine.com>
 <4BCFED42-2BBD-42B0-91C5-B12FEE000812@vmware.com>
 <964CD5A7-95E2-406D-9A52-F80390DC9F79@vmware.com>
In-Reply-To: <964CD5A7-95E2-406D-9A52-F80390DC9F79@vmware.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL0PR05MB5409:EE_|SJ0PR05MB8760:EE_
x-ms-office365-filtering-correlation-id: 7658c47b-2d47-4ff4-8f3c-08db5e86e4d9
x-ld-processed: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 p0pBqwoesp3v5/ymxTvfwoRjuLjarIHW/kiLJ/CPZjmEx0t+Hab5NxwKOZVfoJ+eJi0F1GcJd7peJWrdQZoBElWzJ+4E9ZSkvwqaId1YemTCbY6JBhV7j9nFvBTc7yAV0Msp8m3GqRakgAIQ9wK+EMxQc16MqeatKxCKvDqhtIH5qHfz9TfOlmxzGYkpRIOI6t1SZR6U5QBngif5zdoar5DyH980XsPVQyY/+ghxLGSfHNCsXFt3VKo4y5Mf7p+uxfj5SLHaUYZ+jKmeXPMBB6rEglroZtF+fvo9rrQlsChnbiC94yDsnYgXmQZVJYaDBYKfO+tAJtormdMqp/YVDZ+jLn6qAoJGuDi0GqxGtvJzG6CLoM3JXgHqncVR2StUTwOe2VT8vBxO1ozVIkasYeRYHq+NSv99vFZ2/Jc0jlKQT3KZwNIifZyhbRpQqJLcYo7WwkeKaijCdc+e+i3/p2fZPFz2g1RKjC6lh1CIKMs8M90FgwxV/hqAkS4kbr6qWDfV3mCHgG4QTQSI3/g2DO87Gx5jGh5iTDj51SPbwKPEpaE3NIY4nswCEOzneNzMeKhD/KSXhdB803wxCfHEJEBoJZnNouORNXmyEYnkeTXnydtKSa8N0IvXIVpFyijbOzRM0oO76VaabM/mu88UPQ==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR05MB5409.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(136003)(376002)(366004)(39860400002)(451199021)(54906003)(186003)(86362001)(83380400001)(478600001)(2616005)(38070700005)(2906002)(64756008)(36756003)(66476007)(6916009)(66446008)(66556008)(53546011)(6506007)(6512007)(76116006)(33656002)(66946007)(38100700002)(4326008)(107886003)(122000001)(91956017)(71200400001)(7416002)(316002)(41300700001)(6486002)(8936002)(8676002)(5660300002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?548zaqL9eqVpfNattO40VvF2ZDPUhYB021nbdJyPdnRVSgTZbV+F8fhiz4ip?=
 =?us-ascii?Q?0c1azskByvjzRrzaWPfcod/m7NchFbdhwJIB1L/6/xq+eLd6E8wQ0YnqrloL?=
 =?us-ascii?Q?UNPOq0XJ3p4ajSP8WVeZ/8+XJ30hHX7DLRE8rrrxjgLTeoDp5PepKBWmBbvP?=
 =?us-ascii?Q?9F0Ss4V2Aj6eFa6HU+M4BPIbSdslatgT6YeoFDZ55L7yop0tj3kUO0uQJDem?=
 =?us-ascii?Q?tMZO5eDHQrFus69vUkatWjm+FUovxGLP/kuDqCwGJDcMn/+0EQyDuVUBl+g0?=
 =?us-ascii?Q?m8CftpK8YD0pP2oqJz/nK82wsSDOpyDunZogJ+tVjPY+KIGCkc1IxBHvYtxS?=
 =?us-ascii?Q?6GZLI+UDlrBP0FKdZNKqA0PCwYCsPY+YwTRubiFU2omyKY6+xX68Em3wyi2e?=
 =?us-ascii?Q?kEOlN6HppQ5GdVBUa2dfC0jRt2edNPWAEOJtCW+I0KqUdG0TwWR/wVBAZUmg?=
 =?us-ascii?Q?y/czC5H4kstTIO9zZDWTh+ggwVZigUc5rn8FDQzX9k701ha4I1rrwcM0Y4b9?=
 =?us-ascii?Q?DcvYZRSBCheg1HXZj4+JZcIoNOX2eVa0ioP0u5yBHa+ftPMj6wPjpAxUf7rM?=
 =?us-ascii?Q?eNeBaOcIIMpQjAUkdBKFZtl166QlU6CUoTzHlkQIJF1xAA3xumxbVXTKQu+o?=
 =?us-ascii?Q?bUJ9oi6rle9XINM57CRLKUk9GL5RQ8s/uT6zl03txIBnGISndGtq/bQvCE5u?=
 =?us-ascii?Q?8K19QbObidNl3JnSwHlkyDQxwd+rXbKn1vezFB59yF2+gIo0ZDNM+MgUlHtS?=
 =?us-ascii?Q?EjCLVrSbN8o2GdWuOS0PFDead7NxQgzktY+aE7HeGdx82iwaSK3i4Q7i1kzt?=
 =?us-ascii?Q?KpqMYF2MPRwewhiCbCDqDyroMdKR+mKZSbbExTWZ1ouIq5J9MQ6msWTBLbQo?=
 =?us-ascii?Q?eZzEwR5A8UzQkQ+F5kyOPI3ew2TVWGjzr0QlJRZPvmxuwalrFQ9VaB8a4bnX?=
 =?us-ascii?Q?iBvg/ZOPSU+jG6lgigjtnn0zvPeMsoAZbuPknIX16tQmUL8rLFreN9rouhL9?=
 =?us-ascii?Q?6Qzha32lNebOPQYvm7JWZG0JjByBdtxOHl0GqGpUotEME//tqzVR27GxFO1P?=
 =?us-ascii?Q?TT/dxhPK9M5t9obGQZe0uNyvemNnEcdNMwWwg5+OkSFN+vZYDsmuqOGOIxTI?=
 =?us-ascii?Q?SVtIBn0kB5N6Ll8GpoC+Vme6JHN1A0ZxMlDZBSYI4Pnk7bb9Cx3mxziXxx4W?=
 =?us-ascii?Q?cONfwNMEUDLw9zEPCra5+dsqly3ab60+ltDoJSs0hyJJOac4BmsK3fFQH1rO?=
 =?us-ascii?Q?2EdwA7hD5zVXt4l1R5JS25q2EqJ7FkKYcdZbtJJbuuAMkBE58llt26Lc5siZ?=
 =?us-ascii?Q?JkF6w8rweEl5cNM2XkjafBvpHEm9dlY7QeYa5ul+NfbHhGBpeQBnwXqSERvb?=
 =?us-ascii?Q?hftkT6ixJ5PepMf8PLdSceF8da5ykmnd0D7dRuIZ2YofWxRDavr/jgb12TeN?=
 =?us-ascii?Q?4P1altYMmb8b75GMScn6IB3qFGvuH6EBgN1vuWVxDroMFL4NQCnjAnFU8cxf?=
 =?us-ascii?Q?avWUuASVG2q369nyBwIU7HXhgWY9eb2Oh7P/3mOswuTng18ZbGqkBeddNLi5?=
 =?us-ascii?Q?TSoTol2ByhAkgsMEpxc0EAdb11p7bb998lWl8XuBgb1VhFtJ5LLq3MEa2zGA?=
 =?us-ascii?Q?r7eDQV1K1Zn9/D/nhgx5izqqYNBgkGbyp7PDzxajHwnee1Y/FLl4l/1cQwft?=
 =?us-ascii?Q?BSX3iw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <828AEDFE5F3FC646A084072ABF6555D0@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR05MB5409.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7658c47b-2d47-4ff4-8f3c-08db5e86e4d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 May 2023 07:49:26.0555
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nmV7u6+TEzO843uEk8lUVKIjbss4XLKFoB//lVhAfLNvx1brdPcxFutZnmldRlTsNGxUAsFCZAZQMUrgBwX/ig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR05MB8760
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> On 25-Mar-2023, at 12:03 PM, Ashwin Dayanand Kamat <kashwindayan@vmware.c=
om> wrote:
>=20
>=20
>> On 23-Mar-2023, at 2:16 AM, Simon Horman <simon.horman@corigine.com> wro=
te:
>>=20
>> !! External Email
>>=20
>> On Wed, Mar 22, 2023 at 07:34:40PM +0530, Ashwin Dayanand Kamat wrote:
>>> MD5 is not FIPS compliant. But still md5 was used as the default
>>> algorithm for sctp if fips was enabled.
>>> Due to this, listen() system call in ltp tests was failing for sctp
>>> in fips environment, with below error message.
>>>=20
>>> [ 6397.892677] sctp: failed to load transform for md5: -2
>>>=20
>>> Fix is to not assign md5 as default algorithm for sctp
>>> if fips_enabled is true. Instead make sha1 as default algorithm.
>>>=20
>>> Fixes: ltp testcase failure "cve-2018-5803 sctp_big_chunk"
>>> Signed-off-by: Ashwin Dayanand Kamat <kashwindayan@vmware.com>
>>> ---
>>> v2:
>>> the listener can still fail if fips mode is enabled after
>>> that the netns is initialized. So taking action in sctp_listen_start()
>>> and buming a ratelimited notice the selected hmac is changed due to fip=
s.
>>> ---
>>> net/sctp/socket.c | 10 ++++++++++
>>> 1 file changed, 10 insertions(+)
>>>=20
>>> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
>>> index b91616f819de..a1107f42869e 100644
>>> --- a/net/sctp/socket.c
>>> +++ b/net/sctp/socket.c
>>> @@ -49,6 +49,7 @@
>>> #include <linux/poll.h>
>>> #include <linux/init.h>
>>> #include <linux/slab.h>
>>> +#include <linux/fips.h>
>>> #include <linux/file.h>
>>> #include <linux/compat.h>
>>> #include <linux/rhashtable.h>
>>> @@ -8496,6 +8497,15 @@ static int sctp_listen_start(struct sock *sk, in=
t backlog)
>>> struct crypto_shash *tfm =3D NULL;
>>> char alg[32];
>>>=20
>>> + if (fips_enabled && !strcmp(sp->sctp_hmac_alg, "md5")) {
>>> +#if (IS_ENABLED(CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1))
>>=20
>> I'm probably misunderstanding things, but would
>> IS_ENABLED(CONFIG_SCTP_COOKIE_HMAC_SHA1)
>> be more appropriate here?
>>=20
>=20
> Hi Simon,
> I have moved the same check from sctp_init() to here based on the review =
for v1 patch.
> Please let me know if there is any alternative which can be used?
>=20
> Thanks,
> Ashwin Kamat
>=20
Hi Team,
Any update on this?

Thanks,
Ashwin Kamat
>>> + sp->sctp_hmac_alg =3D "sha1";
>>> +#else
>>> + sp->sctp_hmac_alg =3D NULL;
>>> +#endif
>>> + net_info_ratelimited("changing the hmac algorithm, as md5 is not supp=
orted when fips is enabled");
>>> + }
>>> +
>>> /* Allocate HMAC for generating cookie. */
>>> if (!sp->hmac && sp->sctp_hmac_alg) {
>>> sprintf(alg, "hmac(%s)", sp->sctp_hmac_alg);
>>> --
>>> 2.39.0
>>>=20
>>=20
>> !! External Email: This email originated from outside of the organizatio=
n. Do not click links or open attachments unless you recognize the sender.
>=20
>=20
>=20
>=20
>=20


