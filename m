Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D7A36142F6
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 02:58:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbiKAB6b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 21:58:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiKAB63 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 21:58:29 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-eastusazon11020018.outbound.protection.outlook.com [52.101.51.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 433D8B3A;
        Mon, 31 Oct 2022 18:58:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oTmMFLTs6QCrYbTjGbpyVL1yoNUFk2TrBgg25NY4ynftcTcA5omliqUO/jWkstwPycaS/VZHpiFDyK7zzn10I4PmECaQEI/BVSjg9s4zIxLdw4Dom2RXXhQ6joJgjsPHj0RXZAjBPiXIAYX4VPk4Ylb0cnLVqgTNhcHBc+BaggHwglyc8nG/X2UwP+MU5QTlmeGnoSXTm5gqNupYYh3NEcBXoQnNPwWjnrnDVDYtP+/2+b9XHk5lehtAPO3RxRpV2DpVGaD7pv9Wb6nlTBxrv0a0Xkz02hDU4nDPH6UunPa7AIM7t0J3E7ciaZyr5Zaew8ouBfS1j2MK0vAiTvOxzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y1TX2NsCn9TDS5qbmTEEpVi92v763lTWo10fBV2oXug=;
 b=gaZVcCyUqemhumbDdpGqI+VN/eIMxyLL5mjvrFYEWogQbsT+cdmGVQXVpQ8JKrZnjqg9tq6AQp/SfoGSBWU8eZHSoiQ53VT1vDxl7+JXjDQGVrtR4ntBpCJkjfoHV6jBOB6/NjdCeVv2cOo3gM/U4iRjjzhAawDtlHAnm8ra4PwtWmdtjxcbIA3GN2R91fknfPM3p8J1Km8c+w1u3XP8jIYlQsjK61H60iqP/WLYm99HpwYXrzvmJJA+cCDcw0rJegFrhbc5oBIBL+aoivHPS9zAVFl+I+WrWvgY4VvybjEl0Ssg3+ftiB+02hYjaukQ0lctJjxyYj89iWhpZrhIuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y1TX2NsCn9TDS5qbmTEEpVi92v763lTWo10fBV2oXug=;
 b=dnaMHDpXZGTuOtcaPdUVCHzBStJRDO1SO0N7rbgdUJ6wIL/XwDgokk2hYo6Q4UX52Cita/2PfqhXW9+lvrnf5sG8BxoixRq5Z8nelO1h6yn+5nhxzRP4v0pZS3GrXhZOyv5tbsmxfcLu63g77H+NPdyouh1J0GWivVVbuGY3jQI=
Received: from SA1PR21MB1335.namprd21.prod.outlook.com (2603:10b6:806:1f2::11)
 by MN0PR21MB3219.namprd21.prod.outlook.com (2603:10b6:208:37c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.1; Tue, 1 Nov
 2022 01:58:24 +0000
Received: from SA1PR21MB1335.namprd21.prod.outlook.com
 ([fe80::600e:e49e:869e:4c2f]) by SA1PR21MB1335.namprd21.prod.outlook.com
 ([fe80::600e:e49e:869e:4c2f%7]) with mapi id 15.20.5813.001; Tue, 1 Nov 2022
 01:58:24 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "arseny.krasnov@kaspersky.com" <arseny.krasnov@kaspersky.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>
Subject: RE: [PATCH 2/2] vsock: fix possible infinite sleep in
 vsock_connectible_wait_data()
Thread-Topic: [PATCH 2/2] vsock: fix possible infinite sleep in
 vsock_connectible_wait_data()
Thread-Index: AQHY7QTh+QitYrOHoEaiTHgoa20hMK4pTYIg
Date:   Tue, 1 Nov 2022 01:58:24 +0000
Message-ID: <SA1PR21MB1335A7C6DD342BCA6C0CCCD7BF369@SA1PR21MB1335.namprd21.prod.outlook.com>
References: <20221028205646.28084-1-decui@microsoft.com>
 <20221028205646.28084-3-decui@microsoft.com>
 <20221031084327.63vikvodhs7aowhe@sgarzare-redhat>
In-Reply-To: <20221031084327.63vikvodhs7aowhe@sgarzare-redhat>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=27e3ca28-3444-411e-bba8-1522ffae6258;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-11-01T01:46:34Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR21MB1335:EE_|MN0PR21MB3219:EE_
x-ms-office365-filtering-correlation-id: 9999bfc2-5b50-4f43-d31e-08dabbac8f9e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2xr5RH/vICW5cQuDWhvK1L6iQFNhg6G+sXZRppEvx3bF4S034haSP+ZUJc2XkdwYsB+oMCRNCtoILdx8VEia6czU3sGRpCBDtm4vdu0uISYBqJYTvWe7viTaNGpZDdDTWYyBiVZ5+FTOHiDgy+ZzFCJNJeHNJ299sUxsO12e8wnlKtlhT9e4KgIrtRAVpQMifL6s81PkkTMUoatbhKBJxnK8dzYts5sPyBz5KvQErgTscf6AiqIQaXxPpR8Y9LeEHFgPiVK1VbVRNaojcZlYwZYubE55uUXucaI7WRoBTrNzKwJmVsANybbJz4ohVTR/EIxXae5UHLW2noxbHHP+SNEub88VQjc7zR5puxFBOo6YX1IhcaK7JUVJXMgr/pS0SWd3x3z4UETL8FGQQPCEpNVXgOhyNnGnbBwvh5xoI3Fp9Jw5BY41WV/TqkvL5YEBF4cUo28ePsy4LfjkM1t6HMGo/YhgkCNaL5MeUl4P6+/4czWNnguUXpNQuD8ag/kJsvekq/KsHtKVJEgYbq/KZjnsGAhOD8k5W9L21wEpAlaHLFtu8msYdJBA7PGWpjX+P/zpij7Fmp4nAkpxwt7jIDdigAZdApDZOdvwh828sli/A+IOSlogj2Pmm8aUSnVhNmkI5tSFUkpgOCAR8RfEWXaOR+V+OC2V2fFjKLD+mBtrcFDR8wMbXIz3MU27eYsQ8GBkElSTD5/0ohcagX5892J/YiX0+agmtxsMwJ6BKI5GAotiDTx1bQGSfd0yX7nZMbKkwjOeKiaZJ663RqllOTw4t1kz7d/r++Nq0ZMzvWMVpfU7adNSfchHPvIBt5gO
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR21MB1335.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(376002)(136003)(396003)(39860400002)(346002)(451199015)(186003)(86362001)(82960400001)(33656002)(52536014)(82950400001)(64756008)(38070700005)(122000001)(8676002)(5660300002)(7416002)(66446008)(8936002)(66476007)(2906002)(76116006)(66556008)(41300700001)(38100700002)(66946007)(8990500004)(7696005)(6506007)(54906003)(6916009)(9686003)(26005)(316002)(478600001)(4326008)(55016003)(71200400001)(10290500003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?0qLBtfI+fgmLdjsNpjAcJS/FtvJViInwZpE+W9Ysp8whAsrtuezxnSSMeNes?=
 =?us-ascii?Q?AFgSFCHblCEXJJCCzFrW/SirstZ5mylaxRnjHzhsM01zkG1khXE44HM2oBcM?=
 =?us-ascii?Q?rUkdiN3BX5gatlh4i5KR5R3Mt7DxaJ3YjtGl0Ca2YNL2LuQhvVbDVD2Vc+ng?=
 =?us-ascii?Q?kuG/cdmP192EBRkPxfT7Ij3gmXdq9ufD4dGSe45CNM9xTTyPOCdvC82sSCDn?=
 =?us-ascii?Q?JuyXKLJgabJPJrt0Xuj7WdNhym+kBPBYA53kqoYly8JXu3h8AK8UUuqmqk9e?=
 =?us-ascii?Q?Nm71Ekybus5JwlL7czMskzmC4WxYLJNWusImX9YmO3XFSYOs6iNhmdZnGLO+?=
 =?us-ascii?Q?QLRuR1VAP/BMpsWHlA55a8lf+aJ1FDGJ5XXsvuJ4tM3y3F9IX4PSrfKnb7GV?=
 =?us-ascii?Q?po8wen3zHZu+pN9Xc6fZnlRWhds6vgviLUYXM+sijQPXTaa9imNl6J+Orctv?=
 =?us-ascii?Q?dixk9poB+LcbVJBt+dA+WExDVtJ06FoYH0CkezmfTwZLQCheQ+hvPnJW4dLj?=
 =?us-ascii?Q?SjX3lD5qUn2FTJT9ejhf+uYlvFPJp1dN8y6ngN+3d8hqHxpwYIilvdpsePZ4?=
 =?us-ascii?Q?l3aKNKNIEjJtrwz9yn97uekZL3OXrJe1Jb5t4d22pMlCWuciZH6AzJmYpkFw?=
 =?us-ascii?Q?eGjZ5rvY9ZkkblA8k9FYyZSQH8GR9LDQkeFjv0Xp69ZMbGLfgvz7t/bXXt5z?=
 =?us-ascii?Q?TAHC1A3zJ0RUOpwFHYUMSn8ew6hoQB1OoepbhcQmKp6hFsBtz4rV1o18CkDe?=
 =?us-ascii?Q?DrKLORnPILCE9NzJ+1bQcVQn/C6Kwo+Kcur3GtutpLsV8XiBC/xO6ZR7eqr8?=
 =?us-ascii?Q?OZXnBB9D7+I2NFAcdfDcHRGNThGrYW+VNoCeQOskNT2kzl8WacM7tYTXUyCG?=
 =?us-ascii?Q?llhzulzomaez2PN5MEeCl9r7uGZ3nqxZCkB1IQRZxKOTsGLZsULvwzZZuHWY?=
 =?us-ascii?Q?DymXAVHWkqWpLjwJ0mqtWHGwUCHdgU2H7pNrctpFv6zCITcpUyXXUL09WhLb?=
 =?us-ascii?Q?gpWe4ueMhNZ7RIerbcVMeDJLKDR4tIxyhKwz36pMtVAZNEbicbQEeEptzhol?=
 =?us-ascii?Q?vXSVvXmng7K/fX8puuiU0UiEKeDKlxD0gdxTQdwg2e7pr/aRGxlh5IW20m4g?=
 =?us-ascii?Q?Ss/Lvls49JEcVlkVAsrBJV1SNV2xHmvq196HTnIUh/8UlUcS/YwfHswoJfBn?=
 =?us-ascii?Q?YtjZciWBK2lQyFUz9k+4dfCz992qsTQCiIn6ENo5qhp4FBahxGX455YO1YSp?=
 =?us-ascii?Q?Aw6rhBN9F/NKAiSVQTpho0eriIR+HTO653ahzHaKhjyLqPrnVtFe0cZkWUoH?=
 =?us-ascii?Q?s2uVA5GVUw7nqXtOeGO7iiwu7YSEjmMqMap33vy6uqta1Esk0G9HOpylXFGf?=
 =?us-ascii?Q?xaZ73XiuvswhKHBIy0eXB5CiRiPu0zJlt9ZaEoCv5KgOsNrmQOvomc1OGGQS?=
 =?us-ascii?Q?R/bQskas8I/dhNycRBUC1102XbAdoSg0RxOGRepHORMQ6j7SMy0YlBviRXmU?=
 =?us-ascii?Q?aIQCsAmBgfC9c2tOGkjUtMIpHFJv2gkL1fvAVcizHGwJUeYMMMpUExDZr9P+?=
 =?us-ascii?Q?uUj/kKvOa3YIHo53+h/9J3DyoXM2LM90t/WRSp0Q?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR21MB1335.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9999bfc2-5b50-4f43-d31e-08dabbac8f9e
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2022 01:58:24.4041
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Fr9vQiKO01sfZKMsD00BWLcI+LsThpMnP1nJK5n1WtPiwQ13S0AtLwlfgFwvdiCq7IU7eaZnqZvdwT19lSxqgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR21MB3219
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Stefano Garzarella <sgarzare@redhat.com>
> Sent: Monday, October 31, 2022 1:43 AM
>  ...
> s/qeuue/queue
Will fix this.
=20
> >@@ -1905,8 +1905,11 @@ static int vsock_connectible_wait_data(struct
> sock *sk,
> > 	err =3D 0;
> > 	transport =3D vsk->transport;
> >
> >-	while ((data =3D vsock_connectible_has_data(vsk)) =3D=3D 0) {
> >+	while (1) {
> > 		prepare_to_wait(sk_sleep(sk), wait, TASK_INTERRUPTIBLE);
> >+		data =3D vsock_connectible_has_data(vsk);
> >+		if (data !=3D 0)
> >+			break;
> >
> > 		if (sk->sk_err !=3D 0 ||
> > 		    (sk->sk_shutdown & RCV_SHUTDOWN) ||
> >@@ -1937,6 +1940,8 @@ static int vsock_connectible_wait_data(struct sock
> *sk,
> > 			err =3D -EAGAIN;
> > 			break;
> > 		}
> >+
> >+		finish_wait(sk_sleep(sk), wait);
>=20
> Since we are going to call again prepare_to_wait() on top of the loop,
> is finish_wait() call here really needed?

It's not needed. Will remove this and send v2.

> What about following what we do in vsock_accept and vsock_connect?
>=20
>      prepare_to_wait()
>=20
>      while (condition) {
>          ...
>          prepare_to_wait();
>      }
>=20
>      finish_wait()
>=20
> I find it a little more readable, but your solution is fine too.
>=20
> Thanks,
> Stefano

I'd like to stay with my version, as it only needs one line of
prepare_to_wait(), and IMO it's more readable if we only exit from
inside the while loop.


