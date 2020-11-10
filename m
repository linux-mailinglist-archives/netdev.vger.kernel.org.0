Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A01FD2AD651
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 13:33:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730299AbgKJMdz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 07:33:55 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:22108 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730150AbgKJMdv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 07:33:51 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AACQ32b028234;
        Tue, 10 Nov 2020 04:33:45 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pfpt0220; bh=k3++OXqhUuJiU5OT24E548p6n9GGhIW0x0A4sEQeFR4=;
 b=HRqRRHcbLCMNBFTQwzZpn3ot3mhpNP6IWPO3/dsX1UvmEJbdS/vZQMLOvSS+etCneANn
 J+Sq56K9VWZJoKDXQBeEBamBhdclnSXk5dGpHRSOoHNHDppj8z3sERlTWcpuDqDoZa0F
 iMy6vKfF6zjWi8S9y4PAqdDVIFnKYMwXCL7Zlimux1pOACSwi2L4caCcseHLnmCs/UKm
 Nja0mO2uw+s2zW8ytOzQmAdrnSIf0DutE7f1i8vUlgOLYSJyGIcjyAtQ8+XWDKFqVj+7
 rt6m/F4Pt5NzdWNDDdZbkSWWxPeOYd3CxRdtI5eAvhqpp7kRm+9r6jD6GzWavOcvz55T tw== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 34nuyshjua-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 10 Nov 2020 04:33:45 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 10 Nov
 2020 04:33:43 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 10 Nov
 2020 04:33:43 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.171)
 by SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Tue, 10 Nov 2020 04:33:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gAsUL+qamELHXt4t+hkXdAb53L5oV2icttS4FP6jjfB9lts3hkusQq7Q/heVop399yROXv6SSkv04N5hSxl5XAgAr5gJpzMe7JdV3Plb2RkrsDWsDo75YVATfhagVJUXgrAhT4eOrJnhNQvC39NXhYlGEb+h4fKEQ1/5XYRgTcihtjDGHdVw7EM3Nd41i0euNZ563FZCr2IkMo6fBb3QC/lnsk+EfGXE+imq+iR9xsz5BW6qVS8KONvTgc+8qyXeH+RexrY34ikyfPp61UbfJhzzHXthFa6gp2qsnToHfdIjZRP4yJkZOIbguaQdOiVBrRwSkSa+h23j/CWyItMwUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k3++OXqhUuJiU5OT24E548p6n9GGhIW0x0A4sEQeFR4=;
 b=Vp0NyJKy4lR9bRRm/adzYyDADHFX9lKr8kgnKd0Lpd1b0xtC1fE0PQ/LqlKjFSm+vFu06gHT/j2IuT05lQ/4+bnajk+DZOMYftL0Z83Vjp754ZgYNtnZtNDvl/Px21MKA43M/OXW8JghOEGrYOwY9pU9ZYALS5UFELVD99sxQVboZzxN/mpEYm4Qz1YJ9hjf0T308R16I504M1VSAUfCbQby7gRGYVSH2HSsoyQclbve6UAaFnzK6w+0sYrAlU9yTjXYDCxjcgvHs1OdxXFiEDG15gbtNpvJ5ox9KTZDnn/UDRgY/l7iaLBubGzrQvWjLdNff+FW0W9puTrl0nsLDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k3++OXqhUuJiU5OT24E548p6n9GGhIW0x0A4sEQeFR4=;
 b=aMbYzwwcrGN1iwImkh4Krld59eLlyxiNvcsRBxr4bl4V5hfPdlrtbjKXJIM6L4oi3ia3bEO+vrNstxau++oqdX0JofAL6OuGepS4aufGbKfBi66TXnSX8v6OXTdoFYiYLnKlSSQ3WyS9xu9US/Xi12jPl4iiGomuPWNPqrhm10c=
Received: from DM6PR18MB3388.namprd18.prod.outlook.com (2603:10b6:5:1cc::13)
 by DM6PR18MB3635.namprd18.prod.outlook.com (2603:10b6:5:2a2::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21; Tue, 10 Nov
 2020 12:33:40 +0000
Received: from DM6PR18MB3388.namprd18.prod.outlook.com
 ([fe80::78b1:3636:9aaa:adb6]) by DM6PR18MB3388.namprd18.prod.outlook.com
 ([fe80::78b1:3636:9aaa:adb6%6]) with mapi id 15.20.3541.022; Tue, 10 Nov 2020
 12:33:40 +0000
From:   Manish Chopra <manishc@marvell.com>
To:     "talgi@mellanox.com" <talgi@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: net DIM (Dynamic interrupt moderation) queries
Thread-Topic: net DIM (Dynamic interrupt moderation) queries
Thread-Index: Ada3WkGbfiyBmiG9TaSsOWWQxRwhDw==
Date:   Tue, 10 Nov 2020 12:33:40 +0000
Message-ID: <DM6PR18MB3388B832ECEBF1E6D9C28DF4ABE90@DM6PR18MB3388.namprd18.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [2405:205:1003:3528:81f3:b10c:7256:3f65]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5c321164-1381-4c99-ca1d-08d88574dadd
x-ms-traffictypediagnostic: DM6PR18MB3635:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR18MB3635D0C0887B25482E1CABA4ABE90@DM6PR18MB3635.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CAz0x/ubjJpmcFpQEJ2W9Nth2zdFBHaSr+e0Io1IuZ6R+pZMf3P2xW2KL8wM3uBqHQesvWfyJ+pk2q9yrdCAUjN44e/IPl+0yh63k6mgpZTl7mrtmYhusqRVKmlG1maZRdhA3pLEDVc//CfW6d41cpfEpAu1eViaVjBlX4qDMre6mTSuKsfEmf7LkrwO9l2LAxScXH2UBADWPC1RnDDuub8hp4G/Oi8buOSnCVPJl7SwGglIBSLqZYIrmNWYbaMAOoH0x18BwNOs7pSzwOqDIi/Y7oro4+54bzGS8f+DYMhj5o3aYCKegJE0UptE4uTVh+Ikj3QS7Ld5/O1dIrXYsg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR18MB3388.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(366004)(376002)(39860400002)(346002)(54906003)(55016002)(5660300002)(66946007)(186003)(66446008)(52536014)(6916009)(107886003)(4326008)(86362001)(71200400001)(8676002)(6506007)(2906002)(7696005)(8936002)(33656002)(76116006)(316002)(478600001)(9686003)(64756008)(66556008)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?XxZEMFmdcHLrUAbAGXpV0mQHuOcDaNvRA7j9BGA5McQM/+idEJWeom1JAMiB?=
 =?us-ascii?Q?hG1FT2aLnMQ/6KVlRx6Ok3ORstVUUZTHXlWcW3IXRlLQQ0OR2z5pbS6mpw30?=
 =?us-ascii?Q?vY87rcYcAEew39PUZ8wniIstNWyiaWAnV1bkHRc2ZDOQgbt6Kusa1ML+zoMB?=
 =?us-ascii?Q?3mmWy2HQGcicJ+BQe8T/0TLqlfq1UI90pEVw7Ar3ssmSkorRJC0PHyGLSPex?=
 =?us-ascii?Q?PyMqoPkcNTgVVV3/OR/94kDRW7vqbrHier3aJbD+2rqW4UkgSylActmIfjxs?=
 =?us-ascii?Q?2t4MSkv/jNhQfdgeVglmMYunSDArY6EvqE6jlqTDUoKUPv2qcHWFQ9NGhzXz?=
 =?us-ascii?Q?YyGIULOQ/pdb2NfIyn9nFZpIi3xyqNeOM/3WYtzjdDA0nMPnwb9xQnLluQdl?=
 =?us-ascii?Q?XEuTptiRzmD6GkiAjw62PRVtCbRn/OpV7fs16IO9MN+9m5scpa1GjC97G3V6?=
 =?us-ascii?Q?Ezz5xwjuh5qbuLDjKNymKFXHyIhjEq4rK7yMND/5e4+glijyXS9G3K4YuRQP?=
 =?us-ascii?Q?QJ/NisbLBJbVMwwiq+UK2pkSK6mQU3mZ6oVuvmYLERKjxIKky0Kbm+jbfHKl?=
 =?us-ascii?Q?beDTeKwdaUyoKJjiq1BqBCS/6e5RCO5s+cyyT9ARFOb2dypruD4RUHb625ue?=
 =?us-ascii?Q?vCFV2QMqOC0kyAlh4WAbJ03BlIewZdq6HYWdXhDLxdvR+5QqmYNyR1B6u2lf?=
 =?us-ascii?Q?lolu8s+MlqaSpjbuizUQpaHBXpSrQvzplFs1OIS+YkN9XTfVnGMsL4z4Zc72?=
 =?us-ascii?Q?ozVZDJVBiW2lMp6yF+UkGBxf2CmYrvbWzj+BpFYm+iHD+Y90Civ+VXqUysz9?=
 =?us-ascii?Q?dx/9B/tX+lBXtBX9pb9BdggjCaBdus9jFXMT16FCLWDShUqFTl44hX0z0RLL?=
 =?us-ascii?Q?OUUfmO8TaMkfyRYvXTsfi7IY68o5Z+pdbbzzw/VNSje4boAiiOEXEzfLaMyJ?=
 =?us-ascii?Q?1Ofu9EmAebutRK0vc1CeEw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR18MB3388.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c321164-1381-4c99-ca1d-08d88574dadd
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Nov 2020 12:33:40.5665
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oaSma6TfJAbdVQHezuaCjPs0CNLYA5MLdEmcJ1giXqw4SILJpnl1GqUK9sn9Dqn32oZRaLJtiIf1BeZI24K2+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR18MB3635
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-10_05:2020-11-10,2020-11-10 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Tal,

I looked through the documentation but some of the things were not cleared,=
 so I am looking for some fine details on this topic if you could help plea=
se -

Q1- 	In general, can this feature be problematic or not useful if device on=
ly support time based moderation but does not support packets count based m=
oderation ?
	IOW, does DIM strictly demands for devices to support both time based and =
packets count based moderation ?

Q2- 	What is DIM mode actually (DIM_CQ_PERIOD_MODE_START_FROM_EQE and DIM_C=
Q_PERIOD_MODE_START_FROM_CQE) ?
	Document mentions that one of them is used for timer reset, but unsure wha=
t exactly it is ? By looking at the code, it seems it just differs from pro=
file values.
	How do I get to know that which one should be used or could be benefitted =
in general by the drivers and in what circumstances ?

Q3- 	I started with using DIM_CQ_PERIOD_MODE_START_FROM_EQE with our driver=
s (drivers/net/ethernet/qlogic/qede) and our device only supports
	time based moderation but does not support packets based moderation, our d=
river simply updating data-path interrupts as an event counts, rcv_bytes an=
d
	rcv_pkts through the DIM api in NAPI poll routine, I was experiencing some=
 strange behaviors - (unsure if they are expected)

	a. When simply running constant PING flood from peer (ping <ip> -f), I was=
 seeing that DIM causing the driver to change the
	    usec moderation values (1,8,..) quite frequently, it did not make stab=
le moderation configuration although it was steady PING flood,
	    same was observed with single TCP connection too (with TCP it wasn't t=
hat frequent but it kept on changing over the time, still not stable config=
uration on const TCP stream)

	b. With TCP, I could see that DIM causing driver to use higher usec values=
 (compared to PING flood), but strangely when stopping TCP stream and runni=
ng PING
	    back, it did not reduce the moderation values back (I would have expec=
ted that PING after TCP would reduce the moderation value)

# uname -r
5.5.0-rc2net-next

Regards,
Manish
