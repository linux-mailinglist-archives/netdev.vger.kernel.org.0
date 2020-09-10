Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAD3C263D6B
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 08:29:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726963AbgIJG3z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 02:29:55 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:56810 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726642AbgIJG3t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 02:29:49 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08A6PcVE005866;
        Wed, 9 Sep 2020 23:29:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=MsEfWtm/EOHh9HAWmWQBG+21FFgBwcADKRRGEwgjbuM=;
 b=YjZxiVcLJzpHcTHqc3aG4Tv1dDCXLD2cEUSs+j4HX8Z8ang7mCuno9sI69W886gyyLSi
 yfYXrrAIkR97d9PbqcgO3pWYhjcAKkbPqTxBG0lqwV1Zfms6VmxEuDPgf6lCBeIsEFzE
 yQbeOw313RDTV8RxhnOzZw7Svjg2KX7ROpIu9XeiVHDYPYAjnnLvl8/E81wQkPYGG4Ta
 0nv4w+GRUv0q2leRqH17/VukfKo3LZY5GIYyV76b/qndK0ozOJJ9PF2QeldZY02BSHmM
 H6K7gY2uPQit9FRn2v0Ebp0mcZ4k2w6FkN+zr5pTotGRSqKbqe1n85OS+j0LxdlYMd4N Dw== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 33c81q3gy8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 09 Sep 2020 23:29:45 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 9 Sep
 2020 23:29:44 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 9 Sep
 2020 23:29:44 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (104.47.45.54) by
 SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Wed, 9 Sep 2020 23:29:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GLB2XVy4ETehzowXt+LO+H1nrVq64Ae4XCVNYVZWPcI6emmHU0tPghAhWMBTRZ1ROsS7WguZ6XU9fArLWgofgt8vXccYVFNHjZWfKYQdHwFAg09875ZE5cKo5YHEVs6pOU1YBTGX+5f1o3UXavcBOd9Dl72NhqHt5Jt1nidNgoHweRTj4eKEIQa0/fZCkC8oEIRJb6OD0ag6YdGK6SMZ0ngHNtazQ4zTclvGjpHREfj4pd6ycGCgAQjHLMV7d2PGej0MkHbvBcdcFvNWykABdmQo1gvw+tD7aFeG5JB+G/hUj+k6QSJoYRe0aVukC5ybVeNJFcfAxHQp8CYLuGnhFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MsEfWtm/EOHh9HAWmWQBG+21FFgBwcADKRRGEwgjbuM=;
 b=JoKyGxVPsxpomK9k/Gj9npz9GedeYYywrufzz9T5gKXbo4CxB83CrdHHxiT8274AFONSxHEYO+8DXTh6QhQoR1nt/JBXkkA0mpeBoXNISQx1WSvW311O2kCsfyeyhb4fR666vprT03N/QtHvffUNvZZFeCF+jn/MQtgzcRicNyhB5LNHgu1tPnI40YZb9MMrbBIwxF676BjRXJIrttowL1Dfks48a+STDG9OWd0el20Usbr00CZNaBIwk4GiEOek3ZSgulKbol0qK0qBPtgRh/GgCJ0kT5nSahAo0jdZLMBn8Bk3dgJnuZTSXp1onIQu8gyqCAYPLNX6dtkxqOnitw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MsEfWtm/EOHh9HAWmWQBG+21FFgBwcADKRRGEwgjbuM=;
 b=I3jA3TW9WfqMHfa8m5o5tluV7VNrBVYewFXvqzi6KMz36ojdOUtdWnnKzgB1faGbIkIbmzFPqyMNVuVGjh7TtyJ5Clk4O/Wxh2h/uX83p1FDKtV9mXYy1rI+0PIZzt5DlZI2DDWxnM5daQ+O6MqHgkzgt0ovbFmp7btEtpL73sg=
Received: from MN2PR18MB3182.namprd18.prod.outlook.com (2603:10b6:208:163::15)
 by BL0PR18MB2290.namprd18.prod.outlook.com (2603:10b6:207:48::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Thu, 10 Sep
 2020 06:29:42 +0000
Received: from MN2PR18MB3182.namprd18.prod.outlook.com
 ([fe80::b0d9:d41f:16e6:afca]) by MN2PR18MB3182.namprd18.prod.outlook.com
 ([fe80::b0d9:d41f:16e6:afca%3]) with mapi id 15.20.3348.019; Thu, 10 Sep 2020
 06:29:41 +0000
From:   Michal Kalderon <mkalderon@marvell.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Ariel Elior <aelior@marvell.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH rdma-next 0/8] RDMA/qedr: various fixes
Thread-Topic: [EXT] Re: [PATCH rdma-next 0/8] RDMA/qedr: various fixes
Thread-Index: AQHWgUpIjmKYGmZ/YUKmlqredwlHLalguHKAgAC8ZAA=
Date:   Thu, 10 Sep 2020 06:29:41 +0000
Message-ID: <MN2PR18MB318279CF72DE92CE9820D1C8A1270@MN2PR18MB3182.namprd18.prod.outlook.com>
References: <20200902165741.8355-1-michal.kalderon@marvell.com>
 <20200909191501.GA972634@nvidia.com>
In-Reply-To: <20200909191501.GA972634@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [46.116.57.90]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9a63951c-c7bb-4e3f-7649-08d85552e6a0
x-ms-traffictypediagnostic: BL0PR18MB2290:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR18MB2290580A924A7A5C88FA9581A1270@BL0PR18MB2290.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: t9RsnLmxXdAq9vJMA4tq8W7jcWqPAWFf4LjqJa7zjQz/c3fauJZkgv0d7LOKlzZ0LQx9JRwKB8BbIi8V74I0SmJGITHLcl7INcu9/beBBMCU91hTQqJhexdTnc3OclXUNOJdZSieK75bU5IhFTn88VhQBiHRt65SQXVTjszHgj1IHtYwcCCqXBpQBEQjCcMoTWVfNOk0fT3ZdreZuf5XVTP0tB9lHUScrCy/UWWg+qa9NTImLtMfa6yxSNKnH+voHHlxcOH9c8BC5lIL1wcquD7RwYyGk1kh4Ro8Xv3uP0w9izhQtOh7vsHGdn+inDV7WAvvpTvLT7bg50Py7himsA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR18MB3182.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(376002)(136003)(396003)(39860400002)(86362001)(6916009)(8936002)(71200400001)(33656002)(66946007)(64756008)(66446008)(54906003)(66556008)(2906002)(5660300002)(76116006)(55016002)(316002)(66476007)(9686003)(186003)(52536014)(4326008)(26005)(6506007)(8676002)(7696005)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 7bCpd6z/YQSJ4GP9kCtoFm6fdl8PQIm0yDrxGVdQssOtyg1JhT+SlTezuvDsHZKnI5cukh9IBgpd1+RKc1HQWzT/YAFSLWRLcqwG4f0Wd3FsIiW3XoX5DV7vs4jfnkixNxOgm4Qu167omZmscxEQ3wULzV7+R/XQu71Fs3nUIoubCq6mPAlIuQJe/9jpUlZiAa/o0HyGvOSSeKYorcj7j0qG1hu6rySGgXjB/aZWyxtEw7VSpBIkuV1Bth/0pEBplelBtr7Uzc2IRVRAGvZSVnPDN59CGis7pbSjFRHanQu8oKrpEjWfV+uGn/XpEp8cSoeaIQtLwwwBOwljgdyrl1eD57anqq0toYxkbNsjDtXmLiybRa7iCz3AwxN7oqPchVkIAt5J/McCQgo/WoyZZpGfuFPqtmEI5iHsfeNydGqaBZzDXk3dUd9SaQXUAV+vccWFWDkmwh9MwHaSj3c6oMekvR2sjFhinuIBHGD0D36u58IJW3OVMNtBn5pEfS+ovIwR9XEA3V+Xv1DoZMGXuT4TCuvT/HxKcg0GtVm3d+jsxk1XvWRgRU1/bn/zGihE8WWpiuemWuF5YpRYzvRmaIvES7dD4K2BLV33muC835K2xpI/aMdxBoIdQGJO9cVMn7/GuIiaOWruSMw9nwdjlQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR18MB3182.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a63951c-c7bb-4e3f-7649-08d85552e6a0
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Sep 2020 06:29:41.6221
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: X++qUId9fLJMa4O2d6qlrIaplqjmIjuTpVvzOQnt46giGpH3kpHsahkPeyykZhmtl/m9nDbcq/wVu2plbUxIkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR18MB2290
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-10_01:2020-09-10,2020-09-10 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, September 9, 2020 10:15 PM
> On Wed, Sep 02, 2020 at 07:57:33PM +0300, Michal Kalderon wrote:
> > This set addresses several issues that were observed and reproduced on
> > different test and production configurations.
> >
> > Dave, Jason,
> > There is one qede patch which is related to the mtu change notify.
> > This is a small change and required for the qede_rdma.h interface
> > change. Please consider applying this to rdma tree.
>=20
> Ok, it is up to Marvell to ensure no conflicting patches land in net..
Sure, thanks.

>=20
> > Michal Kalderon (8):
> >   RDMA/qedr: Fix qp structure memory leak
> >   RDMA/qedr: Fix doorbell setting
> >   RDMA/qedr: Fix use of uninitialized field
> >   RDMA/qedr: Fix return code if accept is called on a destroyed qp
> >   qede: Notify qedr when mtu has changed
> >   RDMA/qedr: Fix iWARP active mtu display
> >   RDMA/qedr: Fix inline size returned for iWARP
> >   RDMA/qedr: Fix function prototype parameters alignment
>=20
> Applied to rdma for-next, thanks
>=20
> Jason
