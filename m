Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 096B3224073
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 18:18:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbgGQQSQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 12:18:16 -0400
Received: from mail-eopbgr680096.outbound.protection.outlook.com ([40.107.68.96]:51169
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726351AbgGQQSP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Jul 2020 12:18:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JYgR9ZhkBM8SL48QMQBBDASZnLeAGEA/nEsN9xxlDOUIkU8Qqr2igJa3mp319J5S7KFS6eGVYbAZt3umoA3HAm9G2wGJXoZIKaO0xSs9mPc9v3Hhj6DctH1L9cu4YZPZ27zvFZgoUWTuQzKCwVdfEroNWLBq/7DkBhNMj6KSuLf48Py8ttfILOhTd416X5XfkD7zrL7haykn7WYsVWBNXoiOCIHAuYnD5WjgHsMnInzPB3oTQ6VlOCCMYKU3cXnO+EUR7Mel+Xer3MKNKFLGGBW1h7wM+VC1E432RuwSyorFFetLtCC9MBT4eE23LTiRKeChXpO6XcQUVs8VhtYBdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B+AjnOIOgolYyE11NgKqEyjdDpwqQPg/XC0vH56j3Ug=;
 b=Sf16PVkl0LFIz8hOranDqLl/IXcFyp5k7/UFe/4oy9NS/WvSPJ6boGp5fwsYJuO1VZvFKqxjPE7I1sTm+CpVVpMW/MsVTzTMnH8ZtwH6m3Rn4+ucvKFryHbgjzVL3TEbWFTT2yHRjfr86svC12kvSbbyfWsF3/NvnQNRIpUynZ+2SUmktpacC7+HLC6Apkww5dTQZXPqXxi9UFk07i8WqWXfHdkAS4KVwrw4d72aroB4WbMxBSDIRhvkW7hJtONjok14iPvPhVb9yk48OR3AlqbHgGnIFM2NXujCcCRF6yWAAcqv+DC6akNyGoAy7XZ1k7Exi3E9N8zoKH1cfuRftA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B+AjnOIOgolYyE11NgKqEyjdDpwqQPg/XC0vH56j3Ug=;
 b=PvKy/h6YZyRSExyYxd2dpMDD27t/d24WSFioiqjj9/9owTbFVGIuL/9nvIU+Vam8iFoXoQhUSjp1LpridevgA2SgahiazFSEoeyXMTJyaDHv1WM9FUcdBbsxizcnCer//A+zGIJUxBCcp9wnP/i2IFRfj/p1JlMosgmftluiQ2M=
Received: from DM5PR2101MB0934.namprd21.prod.outlook.com (2603:10b6:4:a5::36)
 by DM5PR21MB0139.namprd21.prod.outlook.com (2603:10b6:3:a5::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.13; Fri, 17 Jul
 2020 16:18:12 +0000
Received: from DM5PR2101MB0934.namprd21.prod.outlook.com
 ([fe80::88cd:6c37:e0f5:2743]) by DM5PR2101MB0934.namprd21.prod.outlook.com
 ([fe80::88cd:6c37:e0f5:2743%3]) with mapi id 15.20.3195.019; Fri, 17 Jul 2020
 16:18:12 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        Chi Song <Song.Chi@microsoft.com>
CC:     KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next] net: hyperv: Add attributes to show RX/TX
 indirection table
Thread-Topic: [PATCH net-next] net: hyperv: Add attributes to show RX/TX
 indirection table
Thread-Index: AdZb/5iAkDMuWyahRIOBehKiULg7mgATtGGAAAFgBuA=
Date:   Fri, 17 Jul 2020 16:18:11 +0000
Message-ID: <DM5PR2101MB09344BA75F08EC926E31E040CA7C0@DM5PR2101MB0934.namprd21.prod.outlook.com>
References: <HK0P153MB027502644323A21B09F6DA60987C0@HK0P153MB0275.APCP153.PROD.OUTLOOK.COM>
 <20200717082451.00c59b42@hermes.lan>
In-Reply-To: <20200717082451.00c59b42@hermes.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-07-17T16:18:09Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=4f488d37-0bc3-4b8f-8dae-75f6ee25d480;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0
authentication-results: networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=none action=none
 header.from=microsoft.com;
x-originating-ip: [75.100.88.238]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 2273e9d3-cae1-4b35-0d74-08d82a6d007e
x-ms-traffictypediagnostic: DM5PR21MB0139:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR21MB0139CB8ED207FC40F2A1870DCA7C0@DM5PR21MB0139.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zz/j9XFBIeR4z/EDDDb7nCxHSEvSovXQGzyTD0ZHQQGkH89VtB+pR5rUo4cbkqXiXJ20v90Lcc6+v/Crk3MmryWDJbUbiSfZH+LdJgGooPRJ1sUewdxH6HnJnkpQAufKqSxoZGjPOzKwGgPyOn9D2Rr3QHhe2M+pb/WiH9oL3mfMhub6rOYWxTOk0BN/QciSjbyAZP+KRBJEwimKtdrwuVYeRv1q28/+z9DdXXpfCybLi09FYc8NNb4wrq/jKrhuDgqYDevuoG7a44Kr1C/S+TaA0oEqKg1DMX9U5KLexXDqsCI4ltUq7WHkRsPPyg5VyCu1x47O5HxG5tLqOwSNiQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR2101MB0934.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(376002)(346002)(396003)(366004)(8936002)(5660300002)(478600001)(316002)(6636002)(52536014)(8676002)(71200400001)(54906003)(110136005)(33656002)(8990500004)(55016002)(9686003)(7416002)(76116006)(82950400001)(82960400001)(7696005)(83380400001)(10290500003)(64756008)(66446008)(4326008)(66946007)(66476007)(66556008)(6506007)(53546011)(2906002)(86362001)(186003)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: kDl4UmBJMCZBL/nsaVf0SWJY5ko2e7GsQXQ62rZIrXBaKNZpgsBNqLhSGrKjnVZ8641YG24qwfZhVr/cK93WleTiRBPumyadMvL4DcxLWQVY4LUCWJyeyHWJERRxwig6fDQkk+3bO6Km96BBIA/KSg49pLP13wv7MzdL5LZTVaNyOaOM0dBhtuUx9NORxQWo4qtIzyqXz+Nec4T0ACFin19x2RaP7p6qDbWLIBJIe5AnoZi4uOCP22Dri6zfranL4p3mGarh7GETmk6/ZCbTN+t4YukfGCq/FXG5jUwsACVZpVCXhGrquxBQghJNnq5dGKm4pN8LbAUx29GMJcUIzYMccdf4T0g02uIapJhYn5EQHh+mgA2+r/xLFVKu/6FsB2+1/Hnd0KqTvfy6RpI+YPnyR6W+lRU1UjcGASzzPAsYplIghNrZxb+UB2kfDaX4P3lJ8EwOM2X8pP1l7QxzlENeyAaH43LsUwX/L82fiB4=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR2101MB0934.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2273e9d3-cae1-4b35-0d74-08d82a6d007e
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jul 2020 16:18:11.8699
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lkBS1Fyg54xnIJSGlnNlYSxuapziFsolIt1i0lEBcrhjRtazDXvz7K0XKgR1oIATN+eyrhr0VRaMGMg0U7W6Qw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR21MB0139
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Stephen Hemminger <stephen@networkplumber.org>
> Sent: Friday, July 17, 2020 11:25 AM
> To: Chi Song <Song.Chi@microsoft.com>
> Cc: KY Srinivasan <kys@microsoft.com>; Haiyang Zhang
> <haiyangz@microsoft.com>; Stephen Hemminger <sthemmin@microsoft.com>;
> Wei Liu <wei.liu@kernel.org>; David S. Miller <davem@davemloft.net>; Jaku=
b
> Kicinski <kuba@kernel.org>; Alexei Starovoitov <ast@kernel.org>; Daniel
> Borkmann <daniel@iogearbox.net>; Martin KaFai Lau <kafai@fb.com>; Song
> Liu <songliubraving@fb.com>; Yonghong Song <yhs@fb.com>; Andrii Nakryiko
> <andriin@fb.com>; John Fastabend <john.fastabend@gmail.com>; KP Singh
> <kpsingh@chromium.org>; linux-hyperv@vger.kernel.org;
> netdev@vger.kernel.org
> Subject: Re: [PATCH net-next] net: hyperv: Add attributes to show RX/TX
> indirection table
>=20
> On Fri, 17 Jul 2020 06:04:31 +0000
> Chi Song <Song.Chi@microsoft.com> wrote:
>=20
> > The network is observed with low performance, if TX indirection table i=
s
> imbalance.
> > But the table is in memory and set in runtime, it's hard to know. Add t=
hem to
> attributes can help on troubleshooting.
>=20
>=20
> The receive indirection table comes from RSS configuration.
> The RSS configuration is already visible via ethtool so adding sysfs supp=
ort for
> that is redundant.
>=20
> The transmit indirection table comes from the host, and is unique to this=
 driver.
> So adding a sysfs file for that makes sense.
>=20
> The format of sysfs files is that in general there should be one value pe=
r file.
>=20
> One other possibility would be to make these as attributes under each que=
ues.
> But that is harder.

The vmbus has per channel sysfs entries, but the channels are numbered by=20
Rel_ID globally (not the subchannel index). Also the TX table is a many to =
one
mapping from table index to channel index, ie. Multiple table entries map t=
o=20
one channel. So display the TX indirection table entries under each channel=
=20
will requires additional steps to figure out the actual table contents.
In sysfs, most files are short. But there are existing examples, such as " =
uevent"=20
contains multiple values, even name and value pairs.

We knew the ethtool can output the RX table. But for Azure telemetry tools,=
=20
it prefers to access the info from sysfs. Also in some minimal installation=
,=20
"ethtool" may not always be installed. It will be more reliable for Azure=20
telemetry tools to have the data in sysfs as well.

Thanks,
- Haiyang
