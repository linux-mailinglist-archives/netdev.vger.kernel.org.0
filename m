Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2EF737FF60
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 22:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233092AbhEMUlq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 16:41:46 -0400
Received: from mail-mw2nam10on2090.outbound.protection.outlook.com ([40.107.94.90]:61757
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231431AbhEMUlm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 May 2021 16:41:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fbOmQ/u3dnKjRC1oLgOdcFibgDXpocZXCIcwRdxQ6K6Xm0vmkAEeNdw5HNM/g1EK12ScYIyySY/kWRn8RGHmBBMSqIxhicS0d2WMj+g+K1ZVTVNW0nZ9TbfByjLUx1jcdFkLW6D+0JEitT363oMm1LfPNbBbWAHDSBreoQ81eKGmLPNTOwtA6SAkBFjW7/jHJzco/Iu8DelaQ6nkwhsqNo+51gOf8PK346qdImeDSRZNhf8kmu+7cIM+ejFQDt9vauG3uPZk3GDcoKF0goKNwlr787wf0ZEDGWF+jspJn0cU+trLVwW72Toyn5CqoY3nhYNQMlLWSfAVgu5/034RMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TRIX7wfERB2y44BiUPQ+wUImPnycC2Fz2a40gVBGw8I=;
 b=jVswR8bbQiVW5YuhEVSojn45KtKP9A77cSqJPI2LNVtdBPlIWCm50czEjmVApKZLx7w84zxKkos8UoD51AAiGoKIRI1j2jnVnMCt2Fc7fQO4H+2BQQ12/vZ1gR+kuMGWe7rfAId1PJ4TQXg8sHrht2qW70bACv9Mct8CSgnW9bR8QtxkL2RyH7aFyoSlAlyt3R+W+rFhoK8GZtlh5c5xPbX0H+JQhqjfPIem0Fn0w75qzEIJ7X0nPqXQ52RKnrArqjbHlGLYnpNJ1BAJHQOXEcBADUD82J+eKcckkZcyEcGUV9n9yZKMto63klx/+SAtK6EgAxV3dVqUarf23rcFaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TRIX7wfERB2y44BiUPQ+wUImPnycC2Fz2a40gVBGw8I=;
 b=MuPBwWiTjeu1fjmm3GXuSp2vWJdfBYBlH0iNxSH2A+wvmBfio7nYo8JsbJ90wF2Nz0ej10c0k2CaxVlRB8m4Hba1jfrJ28zrvNmOztA+0Ymlgm71ys910gbuIvu1/z67YlxF86ELgw9LwdF84sdMggRRTWPo4uSLIoU5MZ65aF8=
Received: from MW2PR2101MB0892.namprd21.prod.outlook.com
 (2603:10b6:302:10::24) by MW4PR21MB2001.namprd21.prod.outlook.com
 (2603:10b6:303:68::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.7; Thu, 13 May
 2021 20:40:30 +0000
Received: from MW2PR2101MB0892.namprd21.prod.outlook.com
 ([fe80::5548:cbd8:43cd:aa3d]) by MW2PR2101MB0892.namprd21.prod.outlook.com
 ([fe80::5548:cbd8:43cd:aa3d%5]) with mapi id 15.20.4150.013; Thu, 13 May 2021
 20:40:30 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Phil Sutter <phil@nwl.cc>, Pablo Neira Ayuso <pablo@netfilter.org>
CC:     "'netfilter-devel@vger.kernel.org'" <netfilter-devel@vger.kernel.org>,
        "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Subject: RE: netfilter: iptables-restore: setsockopt(3, SOL_IP,
 IPT_SO_SET_REPLACE, "security...", ...) return -EAGAIN
Thread-Topic: netfilter: iptables-restore: setsockopt(3, SOL_IP,
 IPT_SO_SET_REPLACE, "security...", ...) return -EAGAIN
Thread-Index: AddHdN+snMbFwQLHQSmZ6J2vO7HZjQAM7kqQAAUT/wAAAJSsIAAW1uQiAAcE2VA=
Date:   Thu, 13 May 2021 20:40:30 +0000
Message-ID: <MW2PR2101MB0892BE7BAA9D2E57764AD3A3BF519@MW2PR2101MB0892.namprd21.prod.outlook.com>
References: <MW2PR2101MB0892FC0F67BD25661CDCE149BF529@MW2PR2101MB0892.namprd21.prod.outlook.com>
 <MW2PR2101MB0892864684CFDB096E0DBF02BF519@MW2PR2101MB0892.namprd21.prod.outlook.com>
 <MW2PR2101MB08925E481FFFF8AB7A3ACDAFBF519@MW2PR2101MB0892.namprd21.prod.outlook.com>
 <MW2PR2101MB089257F49E8FAA00CDA63A61BF519@MW2PR2101MB0892.namprd21.prod.outlook.com>
 <20210513094047.GA24842@salvia> <20210513170822.GA3673@orbyte.nwl.cc>
In-Reply-To: <20210513170822.GA3673@orbyte.nwl.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=ab94194d-bd58-4b03-b274-b822d68ae7a6;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-05-13T20:29:25Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: nwl.cc; dkim=none (message not signed)
 header.d=none;nwl.cc; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [2601:600:8b00:6b90:d1c4:cc58:b196:9e51]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0da69fca-8ecb-4523-a7d0-08d9164f5979
x-ms-traffictypediagnostic: MW4PR21MB2001:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW4PR21MB2001755209E73A4F720FBD34BF519@MW4PR21MB2001.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6/6HKhdUTRyMDL2mA00dNrfIYuc8C4Ys2Vs7QST99kYNwGQ8yrfDHwIJ0KiZj9JWBDcuyURZGoKGgUAv2IpDUqYj1K3SgtvGRHz9eRlZVN7twsg8hP01g61UyL0In5iwD3Vkr2BJuHS+ScNAVfiIBHVzUKU6xf/n7w900ZljM0vQUEJZHiwTXWHsx2U/c31XZ/1xzYXOqDu7ATRA4YK1INIsThcrNdfItam/51yScG79u86W1vfEcyDRr9Z1zJ0Vimi+BwiP5ku/2/vP7GqLdVoyjD9YMK3N0Nr5iW6c7a5v9kK7NQkT3pOvfl7qUdHQ5KuRp82oLC5h2k3bBJMaNRNC/7rUNKI9AQyf49NtlY02utSaTD19gOGLhNPQadqHGdzuL8loyqpyoOvaDKc4alqtOvHNANfX/CtuCygVehc78WodmvWAx6ctEt/fuuEybTsnW7TG8p3G6FPZnrI5NKE2UnhnsgCnyV10oFmei91REmmdriOOoGI+yu3Xtm8ikoy7byHZw+YM3SMpsycOf97OJJDoyik0Hhsws/qzQKXcSreJTxQebbgrS0NhN5Vf3B5kGkt2kzq+CrbuudBZMnSitV8jphYPXZrhg3w6agE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR2101MB0892.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(478600001)(8676002)(71200400001)(4326008)(76116006)(5660300002)(33656002)(66556008)(64756008)(10290500003)(86362001)(66446008)(66476007)(8936002)(54906003)(15650500001)(122000001)(66946007)(7696005)(2906002)(110136005)(316002)(55016002)(82950400001)(52536014)(82960400001)(8990500004)(38100700002)(83380400001)(6506007)(9686003)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?3FMZuQAT6nBLMsK3cXY4m4f1jBsHHKSXUW1ShTRmeEh2IQSwwxB7TiatGRig?=
 =?us-ascii?Q?EWqfDMRyLFQcG9bvvV1br82w42xoyA0ryvY54zpv4pD/h5jXuagFANXblBx+?=
 =?us-ascii?Q?rEQAoT2DrOa77fIOoASAayy4HMeNlIbACbCsCWDSWGH1gtlv1eKsDI25nVxi?=
 =?us-ascii?Q?aRlO22n2hha3rjVLPWI+ObJVVRvfHj5uFcKHS73l1CXqzVVG+p3EbRuxxBoF?=
 =?us-ascii?Q?lZRcr+7kMSBNIHnjcgDC4x9wl7+ozr/NQ6ABUyPNTg7SUwVDS7d3EkkGpaL/?=
 =?us-ascii?Q?du1W8/K94DqZ7CaYrAU8WK6bodI88yn/PZxwxNluMukb6JWInouklxC86Y0A?=
 =?us-ascii?Q?b3fQR9HC2sHjLxQSMBOR4/Ki4idZtCrMs9h9a4WiXeMV1dY2rp1HbTBN/na6?=
 =?us-ascii?Q?7vLSDDkV4GQRjFhmsglXDozJhm2bt9usrdc5/eN32pmh8erWOwbNjVCiQv3x?=
 =?us-ascii?Q?Dx0orDsHF3hCZZAj6sOi/VIfUSyR3n5NczexR5vcHzYb5mS4VdqBiEfddVde?=
 =?us-ascii?Q?JO1l9odq6rWhsA7Bg5tpz3jilaNRzPWOeSehC0J16kDppkFXuoAZrSzN37mn?=
 =?us-ascii?Q?40OmTcQbfK71I7/sQ1o7EOQgmcqsMDCu7m6ABaYi3yXdT7VfskfFkCOE9g5q?=
 =?us-ascii?Q?PCy8AO059wlvkSRiIcEZt01BCMxmLVDajL2WBFUlPwre3MEQsW1jf2fd6b1f?=
 =?us-ascii?Q?SHkxl5WOaEysxH2Ntq95yDecmR2CFRUiLr//0FMzbdiUx3ziXG+3KFggj86l?=
 =?us-ascii?Q?FjI7b9N50lnAaEGuQeoNYjX5qA+2Q4mD5xd5/vhaZfEcDBVD5YchjlYTSkSh?=
 =?us-ascii?Q?j5bPe1dFwnQW4O1mYNmlM1nLI0o81ygh3wCXwzKSvMDIgzEsJbeiqXw+6NtH?=
 =?us-ascii?Q?/aEN8EKKtEITqbI8o52/yqusWB1bBJn6llvqKiudhkCQp37EjOIf8ISkBy9F?=
 =?us-ascii?Q?Sluvkm3haM4284Ipv/iJQjp55WXL2nl8Z+XJnctZ?=
x-ms-exchange-antispam-messagedata-1: 0iWzbZKV9NcUxp1ToVgFTMQ8006dlhfV3Ob4RO9p8fSmBvxikLxKCC4ckad77i7i5B+3sjCmKLsLY6OPPu+aCC8H+DWG1MPcMXB+ynrqooKSPbwrfJ/p58X/I0dGcL0N5KeNmVyWDKDwOFUUoLEfs2VlAZQ/zzBv4bQSaYO8sqmz/tg9aA3fmBhTprj4aaOZKljHpTkGrHlrjPL9YdUHs/L/xzvZ6Z/bpMeF9F17bbiwK+0brwO6lr6YZAeu4HkVdxKpelYaPF4EBhdVUlwHxMHqFysk6LlWaGzA51LVzs5Ort1atLWwLqihNcjW6ZbMqCXeBogwQTPEjFRj1jdZkTI/Ujh98Oz5t78brbqS16/khCkIKPWk8uRWzg2F8fPa0i20+YjHgLp35x499BZDCu0C
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR2101MB0892.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0da69fca-8ecb-4523-a7d0-08d9164f5979
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2021 20:40:30.8628
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Q1vUfjIpMczRvVvPoj5sYWkBsiCrSqzmWV9ZY2FiLf4S+WT5SovtCrYtyPa67uu8SrKqf/J1cWjCkKrmR7hCyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR21MB2001
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: n0-1@orbyte.nwl.cc <n0-1@orbyte.nwl.cc> On Behalf Of Phil Sutter
> Sent: Thursday, May 13, 2021 10:08 AM
> >
> > There's -w and -W to serialize ruleset updates. You could follow a
> > similar approach from userspace if you don't use iptables userspace
> > binary.
>=20
> My guess is the xtables lock is not effective here, so waiting for it
> probably won't help.

Here iptables-restore v1.6.0 is used, and it does not support the -w and -W
options. :-)

New iptables-restore versions, e.g. 1.8.4-3ubuntu2, do support the -w/-W
options.
=20
> Dexuan, concurrent access is avoided in user space using a file-based
> lock. So if multiple iptables(-restore) processes run in different
> mount-namespaces, they might miss the other's /run/xtables.lock. Another
> option would be if libiptc is used instead of calling iptables, but
> that's more a shot in the dark - I don't know if libiptc doesn't support
> obtaining the xtables lock.
>=20
> > > I think we need a real fix.
> >
> > iptables-nft already fixes this.
>
> nftables (and therefore iptables-nft) implement transactional logic in
> kernel, user space automatically retries if a transaction's commit
> fails.
>=20
> Cheers, Phil

Good to know. Thanks for the explanation!

It sounds like I need to either migrate to iptables-nft/nft or use a retry
workarouond (if iptables-restore-legacy fails due to EAGAIN).

Thanks,
-- Dexuan
