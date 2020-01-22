Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77F78145943
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 17:03:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726232AbgAVQDM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 11:03:12 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:49796 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725802AbgAVQDM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 11:03:12 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00MFkPun013702;
        Wed, 22 Jan 2020 08:03:08 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=MyqnLFW3whCEC8O+o/1S8PztiVouufW4DJu6d0i22g8=;
 b=YKMsApi9ufINHO4iybLjvxphG4K39augkbsg+ztLmRYi+1sSinkDQzYpaSbaK3ZQGnVs
 lQrhNVsYQykoj9k3NLqIcNMO/eKIB+LAzTjNL48q4iSgevBRWHDYUjxypeS2IWzdR5JP
 AXq943ln3UmuFwty7L1vRd3NYvF1OJwzSektYIvNUMpxATqvSFFkDrwQWSzNSZCauFCt
 WS+x1mnyH6xQ1bpmkFtUtM9z+Nvcox8MnzeUTCjZoRT0OoOX5DsflpbP28uGZoqbNDCk
 ayaPX5QF5/4Akpba74YVgc2G1SU4H3jxf8shV4uIG73L0gluF2BC4iVXPm1pGnp652iJ QQ== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 2xm2dt7na6-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 22 Jan 2020 08:03:08 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 22 Jan
 2020 08:03:06 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.45) by
 SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Wed, 22 Jan 2020 08:03:05 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oZg2x1sxUxPntVCyr1rAoZmPI7YbBctai6eOQNa7DsLXLrK8d9QqL+DXMZ/z1f4SXqW7BK1aR3u/RT9KE1RTzk+2Nc5g4GlwsuYL/Jt6P3PKEJS78XrQZC4AOoRpECQYnjG5UIhyfXHkPkqfrdIr+3hNFoA2nWXC1yre90bf4+PQGmP2tvXJWQHnbas0NGenV/f9AvD6vgb90gBmm6wmiCDQiTcUSiQflaeoJSB/Sv02evFq3y0vexhn1XUWXtbYWTrVszVnvgpcwhitMu28VdYXJ6+E3YaLM6ZUsRkjtPuoszEExYgHpNvM/GVemi0stfM6BS3ug3YwLLVlc6osow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MyqnLFW3whCEC8O+o/1S8PztiVouufW4DJu6d0i22g8=;
 b=VfJ7jL3uXHAvbFLkjzhHIStejX4yqqZPKXu+iCMxCmc1tjv0kcON4cA3OTq2G2yGr/mhPsDWgTruL8DMplXSRyHewjh7+mtpZOkvzMIljDl8fwfcbLvS4iqRrnZF5T5nWDyaXtcCw7Zoxcg+vCqNZChjbQ8Jbs6VFBJIARgN3i2fDQD505S9FqeXQJXWSWgpjmeAyDttpPZZaMRFqdoxRDdb5gRC0072+cJzU7nu9wvFJFpIfqp8enwCRmJpwxul8Qt1uTfVE2JcPY10GVhowYxBqpAm6r9lzMxvD05E+PjAE7d1ZvO4LOSI5IteTxTZ8IEXBul3503TPEeSXrHSuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MyqnLFW3whCEC8O+o/1S8PztiVouufW4DJu6d0i22g8=;
 b=hLsKr5jtD94Zabm9XCAa6/B2+oF3nqS8rK1dml8ICqETi/22Vzpl5q4/PEkXyn8eKPoAgIPkCFPJuNmxCnmAmZ3zj6Dh4erwA0L/7HhzTeif2aar++7yrxAoZfL1gPW9SFRDZLTOTJwzZejYZ+rIGR4sH/S/PjdOG5Zm3oyuxDA=
Received: from MN2PR18MB3182.namprd18.prod.outlook.com (10.255.236.143) by
 MN2PR18MB3341.namprd18.prod.outlook.com (10.255.238.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.23; Wed, 22 Jan 2020 16:03:04 +0000
Received: from MN2PR18MB3182.namprd18.prod.outlook.com
 ([fe80::703e:1571:8bb7:5f8f]) by MN2PR18MB3182.namprd18.prod.outlook.com
 ([fe80::703e:1571:8bb7:5f8f%6]) with mapi id 15.20.2644.027; Wed, 22 Jan 2020
 16:03:04 +0000
From:   Michal Kalderon <mkalderon@marvell.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Ariel Elior <aelior@marvell.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH net-next 13/14] qed: FW 8.42.2.0 debug features
Thread-Topic: [PATCH net-next 13/14] qed: FW 8.42.2.0 debug features
Thread-Index: AQHV0ThpeYgDXoJ9UkGGsegwjBX5+6f21fUAgAACP4A=
Date:   Wed, 22 Jan 2020 16:03:04 +0000
Message-ID: <MN2PR18MB3182F7A15298B22C7CC5B64FA10C0@MN2PR18MB3182.namprd18.prod.outlook.com>
References: <20200122152627.14903-1-michal.kalderon@marvell.com>
        <20200122152627.14903-14-michal.kalderon@marvell.com>
 <20200122075416.608979b2@cakuba>
In-Reply-To: <20200122075416.608979b2@cakuba>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [199.203.130.254]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f4cd5c16-d4f3-4969-b13b-08d79f549052
x-ms-traffictypediagnostic: MN2PR18MB3341:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR18MB3341A856D6B6A6649E61D6C5A10C0@MN2PR18MB3341.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 029097202E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(366004)(136003)(396003)(39850400004)(346002)(199004)(189003)(6506007)(33656002)(5660300002)(7696005)(316002)(54906003)(26005)(6916009)(4744005)(8676002)(186003)(2906002)(71200400001)(478600001)(4326008)(81156014)(81166006)(66556008)(66946007)(64756008)(66476007)(66446008)(55016002)(76116006)(52536014)(9686003)(86362001)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB3341;H:MN2PR18MB3182.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8nPRpS4Et7OOwjBIAaz8khsOqvCtGtVKTZ8zP4pTdQIBMmo3MXNEwgFqmYpSxMc1mHXB9yT6hasLv65tc+yK8CsPRKr//9M05zkvZUWnTKn3qEhIvEHFnYIefryO4w4fo1JkvHrYR88AvpxdS20fRaXDRdFitRz1D5HN6NEDn8QbXeldUGTs5oFHLdxoJTVmZ337CMkxklIz4cqEhAMvtrQBppgEgl3q15rGHtzgdXhVObSXDFvc4xBnpBeQ5BW0CxViRs08vX3k+NSh6M2tyFwdrYVFv3JAfazzulnaUCLrNk815rFVtM6QmkZN4+Xzq/BEvUKKHfR3f17Kr2QOhWK39U3GNkSPFstiR49udvTF/nwtxCqqLogd8n1nxkUrt+E0LDjHB5+d8PbwHateDby0pNPORXr6ZCGLbKrbjNwDnP79qV9O7ySOoxWen6d+
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: f4cd5c16-d4f3-4969-b13b-08d79f549052
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jan 2020 16:03:04.1963
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: i3rFt+CL7yV6Pz6Ep08PwqHQMLrbO48+Sc3PNF2FBDiecb/m7TKegzRbvF+F40VhJDBYM8Y9ojk216Sdd1LYbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB3341
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-17_05:2020-01-16,2020-01-17 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: linux-rdma-owner@vger.kernel.org <linux-rdma-
> owner@vger.kernel.org> On Behalf Of Jakub Kicinski
>=20
> On Wed, 22 Jan 2020 17:26:26 +0200, Michal Kalderon wrote:
> > Add to debug dump more information on the platform it was collected
> > from (kernel version, epoch, pci func, path id).
>=20
> Kernel version and epoch don't belong in _device_ debug dump.
This is actually very useful when customers provide us with a debug-dump us=
ing the ethtool-d option.=20
We can immediately verify the linux kernel version used.
