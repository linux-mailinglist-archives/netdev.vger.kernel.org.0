Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71462C90EA
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 20:33:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728878AbfJBSdc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 14:33:32 -0400
Received: from mail-eopbgr720094.outbound.protection.outlook.com ([40.107.72.94]:6377
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728213AbfJBSdb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Oct 2019 14:33:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H2Z44t4l6DDQx5heTyHhbbaqjDKGFv85hX4c0ilXMpIwxx8oSYRfAV4jZ9ZujhOBn9yijMzDUuKJgUDRKY6TPWaVgnqmsrXuxpPgincyJxfuWzeK+MmTShRvLyOUtqU4xQ1+EUf/dFKn2nQO6jGn1fN4LWRSBhhp0+8BcfVof+pNyHjV3zke7ZEzyjQ7JIDqZao3UKzJ9BgXvWs/AGlTDX2F6ymPvpykbHT+Tp80y38kuHKC5p9dNgl17qIPh/KO+HQY5iLyLrg8vppt6wAOevNU8e7XK4F6iBcGhrwcwJiI0ff5srTgabCZCVejFSBDLf+xLoFtELMQJ0NElChbaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MfaakOvVKh6sWe2c1NFlTgWaa+PjdjxjhohWVtSafkM=;
 b=iMD+PkIRXPcyuj2wZlcht0LbK33EvQD9TR0sXnIki0hc8UXwOXnctHHLGBMEkIDonQg5UmF7df6OFiv7Rv9d2uzLb4LBUOLAWZ3i8uxywp/vgTEOUrWn2B8MhupYp1AQqaSbV0NUTQejzU6OUASbIIGdTQLD+e5NVZxTaPyZIUeiPaG0aptBVkGa17xDTfZLEVjzosZ9NdJCIJbvA5omgmNJODkO7p3vyYXBR89EHfdILDsnzipDhQN5RN57wCIEhGzBuFygjvs7IVwOvi0fs3HGIqeXD+kCp7krVHxyvMZU2+fXoHDyVNdJQVVd+3dr+7HdvN3TbjCZsWu+zFkHZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wavecomp.com; dmarc=pass action=none header.from=mips.com;
 dkim=pass header.d=mips.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wavecomp.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MfaakOvVKh6sWe2c1NFlTgWaa+PjdjxjhohWVtSafkM=;
 b=P31RELQSunA/xbpOBnmNdw2Rr/vq8g56BqFNWV2GsNXaO9lvYtgbdGknjoMcozkvZNcasVBupvP+IKoh3e8Dyr9cTPigaRgsFZz7Yjn3XcGwuqOpzNVmBQ4O69okJ5ERYdgdDLmo5ey637/6pab9fOefeO/np22A1mbtvWlqelk=
Received: from MWHPR2201MB1277.namprd22.prod.outlook.com (10.172.60.12) by
 MWHPR2201MB1728.namprd22.prod.outlook.com (10.164.206.158) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.20; Wed, 2 Oct 2019 18:33:28 +0000
Received: from MWHPR2201MB1277.namprd22.prod.outlook.com
 ([fe80::498b:c2cd:e816:1481]) by MWHPR2201MB1277.namprd22.prod.outlook.com
 ([fe80::498b:c2cd:e816:1481%2]) with mapi id 15.20.2305.023; Wed, 2 Oct 2019
 18:33:28 +0000
From:   Paul Burton <paul.burton@mips.com>
To:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
CC:     Thomas Bogendoerfer <tbogendoerfer@suse.de>,
        Jonathan Corbet <corbet@lwn.net>,
        Ralf Baechle <ralf@linux-mips.org>,
        James Hogan <jhogan@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rtc@vger.kernel.org" <linux-rtc@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>
Subject: Re: [PATCH v6 1/4] nvmem: core: add nvmem_device_find
Thread-Topic: [PATCH v6 1/4] nvmem: core: add nvmem_device_find
Thread-Index: AQHVeU/izk9pg3Pj4EutFLPn+qErTQ==
Date:   Wed, 2 Oct 2019 18:33:28 +0000
Message-ID: <20191002183327.grhkxlbyu65vvhr4@pburton-laptop>
References: <20190923114636.6748-1-tbogendoerfer@suse.de>
 <20190923114636.6748-2-tbogendoerfer@suse.de>
 <ce44c762-f9a6-b4ef-fa8a-19ee4a6d391f@linaro.org>
In-Reply-To: <ce44c762-f9a6-b4ef-fa8a-19ee4a6d391f@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR11CA0075.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::16) To MWHPR2201MB1277.namprd22.prod.outlook.com
 (2603:10b6:301:18::12)
user-agent: NeoMutt/20180716
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pburton@wavecomp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [12.94.197.246]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 26570fdc-ab56-4eab-f9cf-08d7476704a0
x-ms-traffictypediagnostic: MWHPR2201MB1728:
x-microsoft-antispam-prvs: <MWHPR2201MB1728A3B40E419150E36038B8C19C0@MWHPR2201MB1728.namprd22.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0178184651
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(7916004)(366004)(346002)(136003)(376002)(39850400004)(396003)(55674003)(51914003)(189003)(199004)(229853002)(99286004)(476003)(186003)(26005)(33716001)(446003)(486006)(7736002)(76176011)(44832011)(66556008)(6916009)(1076003)(66066001)(386003)(11346002)(7416002)(478600001)(102836004)(25786009)(52116002)(14454004)(5660300002)(4744005)(305945005)(6506007)(53546011)(3846002)(8676002)(316002)(4326008)(6246003)(6436002)(58126008)(42882007)(256004)(54906003)(2906002)(6116002)(71190400001)(71200400001)(66446008)(64756008)(66476007)(66946007)(81156014)(8936002)(81166006)(6486002)(9686003)(6512007);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR2201MB1728;H:MWHPR2201MB1277.namprd22.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: wavecomp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OcLuc9kmZQnZ975cJcf7sfkyc7Ta3aSUnvXxqjJ/iiT0jVgnYFbgPs+Y7xr3mcvwb9szDk3fN/7ZaYYHY+6Zq1fvkYCak445zCrot+g2hwiFasPIDQC7PSePKu9roXokZhW7aMknMJID5mikX8Tdel+Z3EPsTY6zvgBiQHGgqQulmAe7Cb9RRkOTASyR+vLJHF7IygL8tx786GpLacegCTBqRmJQqS5uVVYKexIfjCGbAugt+DFrhhQA8l26dJskDu3rc7Bhda/njE37+8KnVH5q3hUJmNb9Kp2BEIXjdj6cwEvR1EIrpXF8Iq105sNkql+3V3qRa9bKdloF4Q0VL84VEE6V8UJTsaaGBEaOq1oafxUjHgfkXV36hcG33jiM9B+nTLdX9zLqg3exT/B/Qpe8zfTpI/Er1LGuGjdBqgs=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F75C05FC784E8D4589A7A23C018BBA8C@namprd22.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: mips.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26570fdc-ab56-4eab-f9cf-08d7476704a0
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Oct 2019 18:33:28.4365
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 463607d3-1db3-40a0-8a29-970c56230104
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cxslBc7G3MeA2bVoNVt+BrLBaslT17n4DwWa8m+QkD4eqcfd912Dc8kYocR1/i9IVgx7RD3PnIaxEUpv0i/chw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR2201MB1728
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Tue, Oct 01, 2019 at 11:11:58AM +0100, Srinivas Kandagatla wrote:
> On 23/09/2019 12:46, Thomas Bogendoerfer wrote:
> > nvmem_device_find provides a way to search for nvmem devices with
> > the help of a match function simlair to bus_find_device.
> >=20
> > Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
> > ---
>=20
> Thanks for the patch,
> This patch looks good for me.
>=20
> Do you know which tree is going to pick this series up?
>=20
> I can either apply this patch to nvmem tree
>=20
> or here is my Ack for this patch to take it via other trees.
>=20
> Reviewed-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> Acked-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

Thanks - if you don't mind I'll take this through mips-next along with
the following patch that depends on it.

Thomas: I see patch 3 has an issue reported by the kbuild test robot,
        and still needs acks from the MFD & network maintainers. Can I
	presume it's safe to apply patches 1 & 2 without 3 & 4 in the
	meantime?

Paul
