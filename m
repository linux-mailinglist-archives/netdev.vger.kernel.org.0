Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91BCD25D0ED
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 07:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbgIDFkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 01:40:05 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:19528 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726032AbgIDFkD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 01:40:03 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0845drJp029585;
        Thu, 3 Sep 2020 22:39:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=i0dBiW4N4z6f8t+KUOULo5u8YyIeJ4NjWoZVZrZmPc0=;
 b=Zloxkv+WrbtQLWwIkGx6aQTKb5cjxlWyEyjVRBU54jbej1e5FUwlMKtwXeY3SO7OdGcv
 QjlA805Yv/9HKxs8OuhF0VtBcQnTAG/JZ/dd7bbfl0461o5s9ul46FcZyJniF5cr/T9B
 +OdD/cX2crMX50p0nQPUU4EehDRbtKrz2hz67ow49vM9zLj+7nulPZHZuplTnzETaobp
 JKSXgxf3sAXPe3tYHS/GeyhCb2a3uApV3D9ok5s/Ump0xVndsg4r1zJeRD/V/MOYlwgi
 Ttv3ez0qkc/DF4vd4D8xBZgbmtKSURwPsvPSx5tMTwOfxb4zZUEijTYpXnM+uzmiyv+o xw== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 337phqg1f0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 03 Sep 2020 22:39:57 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 3 Sep
 2020 22:39:56 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 3 Sep 2020 22:39:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JXG4qP7yJEbSuzwvraYQyeF19gBSq0jCR99+yntVaHLO4TUSvyfjW9pNjWSqwCXhZQY2/FWR+okm1dtGBIZeXeOMOrltO8QPb/RhY3vXTQPZj902MI7WZO2UnCNSyFd7SM5vMRKzHp/iISFm54AZPqQ4DjznunaeoaQezp0qdPoYHlmVbY3XMD4z85d/AfXfgZvxegNE6cK38X+4jp1LP76+71vELr7txTSPRnKg5GJwF+Lse0kuzc2Jd6/IagM28JHYmNsN6JJ5kUdN6+7nuXMY4mwvJDQ1b3zg5SeHhPqU1P0VRb9qXQ3jhoN0KPkQhnNpa8TvL+oNu6ingKd2yQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i0dBiW4N4z6f8t+KUOULo5u8YyIeJ4NjWoZVZrZmPc0=;
 b=GfFuWfxWtaZeRm/HKAlINHsYfLQDSNngwkC9opV1acgF1fMApLn8RAh0hzViGehULxEs3nwVeQ9ARW5G1rynhFXSYNIIWVuCe2nLqWIORj1N5xE/JxZR2TgdXu6KTaONg25lomFqiIMMtff3eD3qAJLWP8aWp6tUVoO+M76i54bzZrph7sAhR6kM2d3G4Tf/wFYGB/2HTu5S1caOiR7bbgflttwn4N7hed8uL/MelIjEGpGhFeMFcRAb/H7XtGRLdxDKNzhnjvX9FhGXdmuitj2+JbfuCjl2LoBibbAk50thEfTTj9QS0VMLvVK7WU5HPsDSVkxMZgzF6zU4cYhE2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i0dBiW4N4z6f8t+KUOULo5u8YyIeJ4NjWoZVZrZmPc0=;
 b=Ulmx1SQztDGArrOT5BGEcdNt3iiQ2HqsHyhKa7TRIPXGlWz9g05tq0ut4SvBJ64bp5zzkPi0oOr6UNaIbS/dnFhGym9R7ts7fqtE6GCw1yDdZiHJgcbomn+WvkyPirKZRYxJPHR9J2YBL0keEvUbvnrE0di0Vdn2dyeDLo1lduo=
Received: from BY5PR18MB3298.namprd18.prod.outlook.com (2603:10b6:a03:1ae::32)
 by BY5PR18MB3202.namprd18.prod.outlook.com (2603:10b6:a03:1ac::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15; Fri, 4 Sep
 2020 05:39:54 +0000
Received: from BY5PR18MB3298.namprd18.prod.outlook.com
 ([fe80::fd34:4df7:842f:51c7]) by BY5PR18MB3298.namprd18.prod.outlook.com
 ([fe80::fd34:4df7:842f:51c7%4]) with mapi id 15.20.3326.025; Fri, 4 Sep 2020
 05:39:54 +0000
From:   Sunil Kovvuri Goutham <sgoutham@marvell.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "sundeep.lkml@gmail.com" <sundeep.lkml@gmail.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>
Subject: RE: [EXT] Re: [net-next PATCH 0/2] Introduce mbox tracepoints for
 Octeontx2
Thread-Topic: [EXT] Re: [net-next PATCH 0/2] Introduce mbox tracepoints for
 Octeontx2
Thread-Index: AQHWgickhZqxv/ypi0Wop/9//E5UfqlX9gtA
Date:   Fri, 4 Sep 2020 05:39:54 +0000
Message-ID: <BY5PR18MB3298899BF15F266144EE8760C62D0@BY5PR18MB3298.namprd18.prod.outlook.com>
References: <1599117498-30145-1-git-send-email-sundeep.lkml@gmail.com>
 <20200903121803.75fb0ade@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200903121803.75fb0ade@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [49.205.243.210]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b40a7434-67fe-493f-1d60-08d85094f38d
x-ms-traffictypediagnostic: BY5PR18MB3202:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR18MB3202AD61F4B35F905E7927E3C62D0@BY5PR18MB3202.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lkZ3gNaZS36l1/YeG8H5k1uMasrA7kVSrCfGY6EUTj3F8r/cTPLYuSdi/dZYNS3U+URxELpgeEbeopDKdW3JpieMDKQM2QiCHJzBeMTIvo4m6mJWgWR8mBORVD0JoQS7MSkrm7eoSJkDi1jmQ7yL6zEGrnsegsLXQnrEupP1odo15tLFM7I+RgdS4Ys72HymolsJDrplH+PpefoWSRX+XS+EgORLk0SmfBtkPJnsaDrFP2K629SxyEHoie9iFWRvvrAmDczgW26bNA/ipkL1wDcZ3xMm3tz2RaO+lwBEy1V1thLikj4L7hSzRP4rx/4FkHMs8pQr5+i1Mf5ZrFmGag==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR18MB3298.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(366004)(376002)(136003)(39860400002)(2906002)(71200400001)(55016002)(64756008)(5660300002)(4326008)(86362001)(66946007)(66476007)(76116006)(53546011)(7696005)(66446008)(83380400001)(33656002)(66556008)(478600001)(52536014)(8936002)(107886003)(186003)(9686003)(8676002)(6506007)(316002)(54906003)(110136005)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: YFQe0g2NgT4DuIt+u3nr1EHljslxkudRSTiwza8YMVmiq900kfSrV9NazazlebuBQnv9jdVLul2B6K6Lp0Y1Crp/IgibBjDLkTpgudlS4ZzPisWaVQeSwEMmpDz6ih+3od/cFti2BamqC9LVPBgAMJ0+iA947sUoGcx7bkYIKYHhkC3BGI2pfSAFCovQqnvx4xXAGg6coaAPrMuTdT6mx/W7h/1Dcri2G8fLDLYCdsmVz6mhs/CbXp6uGaba13UlJwtVYD4RGCf2+U6ympKW0zzFqmkz2GmrLr+QFTY05Pd/M3GDPfAMMZW6YrAWE0tpviz57VN1rVxLCUj3w8hg9cN0dVpwGkPo8lSIJZvn779rxWb37AMSNw2u2EoIJqFB5XJmMJtjUw65EwgvsP6YKEfat0K8onUZuGIb6Pv0EwIvPDLphNN3wbwph+J5fy2jdwfDxxh6mnZt9YLK0WvEVrLL5cjQ/SoEfQZF4pz4QbYLVSUfYp50ggm6eJsEMHpSqzU/f1CzfGXpuSsott8XqdFLD+zYBsmvbIRSRWN/MEY9A2B4ippygTlUdimj1GrZcqQBpPY3i4mbAHzxbk/bS7KxVoAwQtsjcBG3UavdVaDsQSrJa10gO6Yf2F2An45yhK7tjlI8xfmvzUC60YEmKQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR18MB3298.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b40a7434-67fe-493f-1d60-08d85094f38d
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Sep 2020 05:39:54.3519
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bz+/QyqpTj8VxF0KBfrKn2gWoFMr/HbkfD9rx36HDQJHV3+DOS/YS5+WLOw7kvD2PxOnjPs+dQ7GJzsIiYcKFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR18MB3202
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-04_03:2020-09-03,2020-09-04 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Friday, September 4, 2020 12:48 AM
> To: sundeep.lkml@gmail.com
> Cc: davem@davemloft.net; netdev@vger.kernel.org; Sunil Kovvuri Goutham
> <sgoutham@marvell.com>; Subbaraya Sundeep Bhatta
> <sbhatta@marvell.com>
> Subject: [EXT] Re: [net-next PATCH 0/2] Introduce mbox tracepoints for
> Octeontx2
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> On Thu,  3 Sep 2020 12:48:16 +0530 sundeep.lkml@gmail.com wrote:
> > From: Subbaraya Sundeep <sbhatta@marvell.com>
> >
> > This patchset adds tracepoints support for mailbox.
> > In Octeontx2, PFs and VFs need to communicate with AF for allocating
> > and freeing resources. Once all the configuration is done by AF for a
> > PF/VF then packet I/O can happen on PF/VF queues. When an interface is
> > brought up many mailbox messages are sent to AF for initializing
> > queues. Say a VF is brought up then each message is sent to PF and PF
> > forwards to AF and response also traverses from AF to PF and then VF.
> > To aid debugging, tracepoints are added at places where messages are
> > allocated, sent and message interrupts.
> > Below is the trace of one of the messages from VF to AF and AF
> > response back to VF:
>=20
> Could you use the devlink tracepoint? trace_devlink_hwmsg() ?

Thanks for the suggestion.
In our case the mailbox is central to 3 different drivers and there would b=
e a 4th one
once crypto driver is accepted. We cannot add devlink to all of them inorde=
r to use
the devlink trace points.

Thanks,
Sunil.
