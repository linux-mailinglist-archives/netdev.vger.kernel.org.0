Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6405316338C
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 21:55:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbgBRUzB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 15:55:01 -0500
Received: from alln-iport-6.cisco.com ([173.37.142.93]:59652 "EHLO
        alln-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726380AbgBRUzA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 15:55:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=1420; q=dns/txt; s=iport;
  t=1582059299; x=1583268899;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=qHGSPJYUWaP3FHLyCY4CRIua/3sd1BrFgdBFnK41Yx4=;
  b=UqlUUDJl1uJxnjC9xL884FwsRxshEsCXqbp0MB9QnnRN3xFAweXYOP1E
   gjRi2r+fTFbApzBUSSBXzB2KuxPS8scQrAl+7l4i4RA38YFqAPov5Q9GC
   GtNLEqs1XtzxhwGLYkVpOVd9/+yEOpRyKSCkICzgy4K9JEMYoecJ+O3Bx
   0=;
IronPort-PHdr: =?us-ascii?q?9a23=3AYqPi3RF8biwuZc8osM4l0Z1GYnJ96bzpIg4Y7I?=
 =?us-ascii?q?YmgLtSc6Oluo7vJ1Hb+e4z1Q3SRYuO7fVChqKWqK3mVWEaqbe5+HEZON0pNV?=
 =?us-ascii?q?cejNkO2QkpAcqLE0r+efLjaS03GNtLfFRk5Hq8d0NSHZW2ag=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0BJAABBTkxe/4UNJK1mHAEBAQEBBwE?=
 =?us-ascii?q?BEQEEBAEBgWcHAQELAYFTUAWBRCAECyoKh1ADhFqGH4JfjxaIe4EugSQDVAk?=
 =?us-ascii?q?BAQEMAQEtAgQBAYRAAoIDJDQJDgIDDQEBBQEBAQIBBQRthTcMhWYBAQEBAxI?=
 =?us-ascii?q?oBgEBNwEPAgEIDgYBAwkVEA8jJQIEDgUihU8DLgECol4CgTmIYoIngn8BAQW?=
 =?us-ascii?q?FJxiCDAmBOAGMIxqBQT+EJD6ES4NCgiywDgqCO5ZNKA6bGC2KW4FrnTgCBAI?=
 =?us-ascii?q?EBQIOAQEFgVI5gVhwFYMnUBgNjh0HewGCcIpTdIEpjSOBDQGBDwEB?=
X-IronPort-AV: E=Sophos;i="5.70,457,1574121600"; 
   d="scan'208";a="454746104"
Received: from alln-core-11.cisco.com ([173.36.13.133])
  by alln-iport-6.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 18 Feb 2020 20:54:59 +0000
Received: from XCH-RCD-002.cisco.com (xch-rcd-002.cisco.com [173.37.102.12])
        by alln-core-11.cisco.com (8.15.2/8.15.2) with ESMTPS id 01IKsxsl002766
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Tue, 18 Feb 2020 20:54:59 GMT
Received: from xhs-aln-003.cisco.com (173.37.135.120) by XCH-RCD-002.cisco.com
 (173.37.102.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 18 Feb
 2020 14:54:58 -0600
Received: from xhs-rtp-001.cisco.com (64.101.210.228) by xhs-aln-003.cisco.com
 (173.37.135.120) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 18 Feb
 2020 14:54:57 -0600
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (64.101.32.56) by
 xhs-rtp-001.cisco.com (64.101.210.228) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 18 Feb 2020 15:54:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dsnqm1lb/fj6IPrIexfJ98zZ1a33i4BRNAK59fkLc3CTEu+nbYom5Ctek/B8M42VLj+3HBX/Zzv1NdrZZYt4BZbfsUCV41ri7oGPCZNemxydm/hD5d+6aVScoyGYtNSWUlWIxdeW9UKHO7DDIlvvMpePrGlohV4Mj29bUaNQz6Ej+9mRu8i+6PLZQfQ2ULjO3HT+2w2kcEaPA5dN9bJFEb1gHTa/gF6uVLxnwaMiLwN8yQNHrKeNYncRJZ1Vjm+qSaWn94+Wly8lPsUIXC2xL/8wiJ7IHtOtl2W7QmQfzgQyxi5PJJS1E3JUhEkpnrxJ3PZRQL1zTCavz930sX4VUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qHGSPJYUWaP3FHLyCY4CRIua/3sd1BrFgdBFnK41Yx4=;
 b=X5SRpm4VST2vMBGGcwfDvX3oyX6KYo6MJLiGsucRXZZQ5F2lcz/Vx8XXE8OUJIhnl06xxz6NnfcwjgASxkADwASI5mD/mwnWxlPyH3wFe8TQDEjNhhTPH5POb2L8I8rACIDcrbvwU75nbTV1HvLablsE+u4D6n8QXO8RiBzCWPjrtWbUBI+Ud+L3xdGyaToO9HEdH86jmJwp24kWTp9mVKBsWcFlspOfefioopk+v8vF3AGwk4qUC98Cl6TpWozI65em9zNI7PDjKg6kkNfE0f0/Q8Ae35Ccvj1glHzWTD8l3HIK0YeAUKCLL5ogLKI2KOKBlYuGWjbSt3RsPheRHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qHGSPJYUWaP3FHLyCY4CRIua/3sd1BrFgdBFnK41Yx4=;
 b=zswTTHb8s6by5x0imvoDTv6XURTPPMm1SiwDsE6Fsogw7kdi0AC/W4mWNMKy+SlBwPn8np8/lfHnB9pG+SBopVidMc5Wi8pFyipn72EuNWWczxf7/T4aqipz8ZvVYQDBSG1Q6cQQxaaBLdrG4XkapnVRVS/NRy+ZiaYO6hv9vJA=
Received: from BYAPR11MB3205.namprd11.prod.outlook.com (20.177.187.32) by
 BYAPR11MB2552.namprd11.prod.outlook.com (52.135.227.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2750.17; Tue, 18 Feb 2020 20:54:56 +0000
Received: from BYAPR11MB3205.namprd11.prod.outlook.com
 ([fe80::89a6:9355:e6ba:832]) by BYAPR11MB3205.namprd11.prod.outlook.com
 ([fe80::89a6:9355:e6ba:832%7]) with mapi id 15.20.2729.032; Tue, 18 Feb 2020
 20:54:56 +0000
From:   "Daniel Walker (danielwa)" <danielwa@cisco.com>
To:     David Miller <davem@davemloft.net>
CC:     "zbr@ioremap.net" <zbr@ioremap.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers: connector: cn_proc: allow limiting certain
 messages
Thread-Topic: [PATCH] drivers: connector: cn_proc: allow limiting certain
 messages
Thread-Index: AQHV5p2t0fDeU99AI0q9taXpnYkWBg==
Date:   Tue, 18 Feb 2020 20:54:56 +0000
Message-ID: <20200218205441.GA24043@zorba>
References: <20200217175209.GM24152@zorba>
 <20200217.185235.495219494110132658.davem@davemloft.net>
 <20200218163030.GR24152@zorba>
 <20200218.123546.666027846950664712.davem@davemloft.net>
In-Reply-To: <20200218.123546.666027846950664712.davem@davemloft.net>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=danielwa@cisco.com; 
x-originating-ip: [128.107.241.188]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 035703d4-1127-467a-d0a5-08d7b4b4cfb1
x-ms-traffictypediagnostic: BYAPR11MB2552:
x-microsoft-antispam-prvs: <BYAPR11MB25522F1636E564EEBA346C56DD110@BYAPR11MB2552.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 031763BCAF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(7916004)(376002)(396003)(136003)(366004)(346002)(39860400002)(189003)(199004)(6506007)(81166006)(54906003)(15650500001)(186003)(26005)(316002)(81156014)(71200400001)(8936002)(6486002)(2906002)(5660300002)(86362001)(33656002)(6916009)(4326008)(1076003)(66446008)(6512007)(9686003)(66556008)(33716001)(66946007)(64756008)(478600001)(66476007)(76116006)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB2552;H:BYAPR11MB3205.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cisco.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8V6a/tJGAn0OGbQ0GvAzfkYqb0JHknMU+B6esBno4XPTxtObwJgfDhrsVMwqknZfcoRdg/6SpU9GEYCnmdYYw1QavP0nYfuRlM5iT63vKOGYq7tOsPSNSoQCm3zhThbAC652P/fmLdK1HgsEMEDq06nMmWinoWOfGhVDXS3L8DEjCmQd/25lFAiEFTLh+ebY/hYtheMGiTtWCmBX7MQczWBAn0H1GdBolqrW3EVx21/op8wIVmPi1CCeNDiHDeRRrovuToYR+NluOO7eHVIfQD+zMqfFfQZulmgebMgPTBVepBeQJ+ozZ2c5aAuLpLN4FZu8bOdWWpT+EXtc3vVp9OQfK5li5Js3Sleh8w+d3Soo+Nyn5IyiNoMrApwRLzlhf/oY4KejcYMg8SUfOe302gXn5fOb4bwqEF6WM0I0HuIOARSLGF44kmorhinYDmPq
x-ms-exchange-antispam-messagedata: TLBOgxvftujjv/RNloohRbX8mP8NKCrdobw9CYx+dqYsFxs5mihs8GxkyyMKcTKXEGnRShFnfc3MOkn6qpG3eBb7dioGubIYMhHAjkz7h34PRPom/PexZ3xKrBHO6x02Ne9HIgaD9DcqtJG6DMF6rw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B9CAB0FFB9ED6447B9838954E29F7DEF@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 035703d4-1127-467a-d0a5-08d7b4b4cfb1
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Feb 2020 20:54:56.5745
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mygS3wEShQe8jbY6PCyk9pNpcasDnxYP+i2z+sJPJbUT7Swgb+M8qDL4DOpeYATb753J7w2+QlraaSb6s96vpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2552
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.37.102.12, xch-rcd-002.cisco.com
X-Outbound-Node: alln-core-11.cisco.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 18, 2020 at 12:35:46PM -0800, David Miller wrote:
> From: "Daniel Walker (danielwa)" <danielwa@cisco.com>
> Date: Tue, 18 Feb 2020 16:30:36 +0000
>=20
> > It's multicast and essentially broadcast messages .. So everyone gets e=
very
> > message, and once it's on it's likely it won't be turned off. Given tha=
t, It seems
> > appropriate that the system administrator has control of what messages =
if any
> > are sent, and it should effect all listening for messages.
> >=20
> > I think I would agree with you if this was unicast, and each listener c=
ould tailor
> > what messages they want to get. However, this interface isn't that, and=
 it would
> > be considerable work to convert to that.
>=20
> You filter at recvmsg() on the specific socket, multicast or not, I
> don't understand what the issue is.

Cisco tried something like this (I don't know if it was exactly what your r=
eferring to),
and it was messy and fairly complicated for a simple interface. In fact it =
was
the first thing I suggested for Cisco.

I'm not sure why Connector has to supply an exact set of messages, one coul=
d
just make a whole new kernel module hooked into netlink sending a different
subset of connector messages. The interface eats up CPU and slows the
system if it's sending messages your just going to ignore. I'm sure the
filtering would also slows down the system.

Daniel=
