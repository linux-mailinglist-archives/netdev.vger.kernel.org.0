Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E30EA3A04AD
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 21:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234467AbhFHTxo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 15:53:44 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:35706 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234404AbhFHTxm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 15:53:42 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 158JfTbQ003868;
        Tue, 8 Jun 2021 12:51:28 -0700
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-0016f401.pphosted.com with ESMTP id 39266gjhbt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Jun 2021 12:51:27 -0700
Received: from m0045849.ppops.net (m0045849.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 158JpRXv022288;
        Tue, 8 Jun 2021 12:51:27 -0700
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2044.outbound.protection.outlook.com [104.47.56.44])
        by mx0a-0016f401.pphosted.com with ESMTP id 39266gjhbr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Jun 2021 12:51:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aAWwTmjW7VpHYFabUAWuQK4Pby0gDeiN3xaFftzEEop4iAFnz0let7K3eQQrLPuIgVupA2CV/cU9hl3xQcwdLys9fceHeYpVZVE7sb8DSJKpJOZsX6NCZFASLOhV21twbkYql0ZY/cvjcMkCafdRcsi3G3092z6MhPO87O12qBNSBfQcA/8m67kyYvf07wGjXHDgdXj1haRWEMYZR+EfObIO2Ezz3QzXJkyL7DPAF7PYr+fuNcWmX7i8Ru34aYKMDy8jcdA8PwfP8ySDewp4wooRJesGv5Zl9O67cpHnIUsCRM7M3yDGSpimTJzIlrQ6UQjjb0VY08XgwatPSkEUiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SM16kkDTuBEvV3WzpK3nJ6A/10pgi8v+73QwKUvUPZg=;
 b=mvu/dC6xvMcQ0BKaafvkixqFhSBT0QBpVc/8e5u8ywYVa7ChZYKYybQ8a1wL7bUaMqs551GA5w2lu2rARq/nOjls4iztsPzGCPtBTElWLDOK1agnd0ZejxQXBA91orhyFtPUvgv7ZyZiJBOU7b4jC++bPnYrXVM/2bOfwktSoi949BdPblMEfWtVQiYO4FgpNDAlVr/FrgAHO44b7sNb+jlEOP+/YOVSMm+EoUcMrQteZOcuckkxRhCyMU46bDsyW7/IHql2iPXQInGPmeZX2G4VY+0yDnQwkEtpNUkpxC3Czoh4u02zVJotpfI4B2xhmtxiF/SvOrGDkgPGJPEFnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SM16kkDTuBEvV3WzpK3nJ6A/10pgi8v+73QwKUvUPZg=;
 b=K8cFJcG9fRhmIKky4/4YUORGcFOAeJ0YLvEhsT6AsJYoceo/I0YEPXLMU0QHPiqjxZDywU6HR+TgmrQzA5JMNgHYIDRe07R30Ot6EbNIvqSGI73bI7T0L2nrNg2c4jxL1Fu78AFC3Mj3Wp/uMpIHF9MtDDGfP87/peu1bmvZGrA=
Received: from SJ0PR18MB3882.namprd18.prod.outlook.com (2603:10b6:a03:2c8::13)
 by BYAPR18MB2759.namprd18.prod.outlook.com (2603:10b6:a03:10b::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.25; Tue, 8 Jun
 2021 19:51:25 +0000
Received: from SJ0PR18MB3882.namprd18.prod.outlook.com
 ([fe80::419a:6920:f49:3ece]) by SJ0PR18MB3882.namprd18.prod.outlook.com
 ([fe80::419a:6920:f49:3ece%8]) with mapi id 15.20.4195.030; Tue, 8 Jun 2021
 19:51:25 +0000
From:   Shai Malin <smalin@marvell.com>
To:     Keith Busch <kbusch@kernel.org>, David Miller <davem@davemloft.net>
CC:     "hch@lst.de" <hch@lst.de>,
        "geert@linux-m68k.org" <geert@linux-m68k.org>,
        "axboe@fb.com" <axboe@fb.com>,
        "sagi@grimberg.me" <sagi@grimberg.me>,
        Omkar Kulkarni <okulkarni@marvell.com>,
        "hare@suse.de" <hare@suse.de>,
        Dean Balandin <dbalandin@marvell.com>,
        "himanshu.madhani@oracle.com" <himanshu.madhani@oracle.com>,
        "pmladek@suse.com" <pmladek@suse.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "malin1024@gmail.com" <malin1024@gmail.com>
Subject: Re: please drop the nvme code from net-next
Thread-Topic: please drop the nvme code from net-next
Thread-Index: AddcnzAdEpx+aAPyQ+iYPM8zs/0YYQ==
Date:   Tue, 8 Jun 2021 19:51:25 +0000
Message-ID: <SJ0PR18MB3882C20793EA35A3E8DAE300CC379@SJ0PR18MB3882.namprd18.prod.outlook.com>
Accept-Language: he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [79.181.162.86]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c68be878-d6e0-469a-80e0-08d92ab6cc90
x-ms-traffictypediagnostic: BYAPR18MB2759:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR18MB2759671F560ECE2C40CF4AEACC379@BYAPR18MB2759.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Y96pSY/4qbQZErSx27N3CS01/T8jHXpiuc+p9mvW0YWXmi9pcmcUX7+6BtDUxlfachDxom5gjMYMU2b8OMUbyZ6xVOWiVGeqR1xoyjahpp+k3jnKtNB4tEd8ZRrIHQW+yuHZAUCQoedMrzHa+SuGgHb9gGxMjGa2XX3INeqzstXMMAes7cCm7Gj0AwKNmTA0+5EljegttdK1Mm+H0v0aCWmNxCzV6OsS0FiEQh7Vn+J+bjd2MRxqzI+3C4JNlr3YVaQZO2ccWYvMVEGn7Jd1rIwMB3NnFEclLRmpllvHQ3VZfPuFPWoX5U/MSH8UsHxFUGB0Hv72VazOkV3QEOgcLD9jexWrHxq0mCsT+PRJVgg4Hxux79w0VP0KoUdDRqi105AorsfUjuWS0DrgeVoYoflpqknUQnqm9W9okE6Y100GBxRVDNrg2HjSPNIyw3exIFzZ4Izr6Nq/EWZR0t+aKVeSOMnyyLZsp6OLgTfmFUS6VVG7jVdHsljTvHeTWE99g9/VZGqlC38Uv1EzMbzO8k1tYPzvg+D5o2XHbouIOlc6k21YEYkZElnGBGdCG2qz03qHCqn8l2qCj7E+5MCVbF72ZFjAcxLrY0S1ksy7TZ4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR18MB3882.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(396003)(136003)(346002)(376002)(33656002)(4326008)(6506007)(316002)(76116006)(66476007)(38100700002)(4744005)(9686003)(7416002)(86362001)(7696005)(52536014)(5660300002)(8676002)(71200400001)(54906003)(8936002)(55016002)(110136005)(478600001)(26005)(66556008)(64756008)(122000001)(66446008)(186003)(2906002)(66946007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?WHb64UQQHjKxdvwPjd5GYJizO8esGzwyTzIuUfGjMbrr0fKr09cHyFCYZUi+?=
 =?us-ascii?Q?CNdXqeWDwQexLZ6ixyTRQXuvsmMeswVKiKBKVfKYsu/79uNMe+xV8ymB24U+?=
 =?us-ascii?Q?Ex/BBBEDKMIJhyF7Ne27DTXtH07mPy3du1z1U8D8rjZq8seYHlqCEZvNeDdr?=
 =?us-ascii?Q?S9TgVHyQfFsGHgjUzRu+epmXZ5abNBRcIV4rpIrNVtA/pvCgBIGU6iU2oIyE?=
 =?us-ascii?Q?REjuou45Fhc5bUJj7ryWkNtNOk/8kGwyNfbx3nWc01GdoWv+oUV8IpE6gHOD?=
 =?us-ascii?Q?iR5N3bcUrcV2zBQRxGlfqMxZ9HVkOCVbAiwZNPF20zEaD4CUdwr97U5Plksv?=
 =?us-ascii?Q?ZylrwDKBSNVTzv66ROc9LS40h1OrPNnYOn7BrBK7O0+Zo+kHuMvUHn3A8zl7?=
 =?us-ascii?Q?VH6OtkUPft0FTKYaS9z7OeK30ElAFuqVz4YDAK5/ivJacUV3rrlqi+0L2glV?=
 =?us-ascii?Q?8AhDKQmsPZNS72rIwuFN5XevJdJdhM3FnQXgUOfB5GX5Fws2t8nWpMp2zZvP?=
 =?us-ascii?Q?7CsG9i2CmrlCMWc+SMCl+rTWzlMNhEm/bCFUBtLz4tLz6698VMJ6wLr3YUP7?=
 =?us-ascii?Q?DaaWI2uF632r4YN1grLCfkVYoKLsImEFVEAYzgbDwMQF0QpSVnqBbgKW1mJm?=
 =?us-ascii?Q?8WLPhc4HWl4v++3qgyfZDUL8FLMQEbXvXOMX8RJqiZDdtE38ATSAC5aR7lVv?=
 =?us-ascii?Q?BbuYOo23yDmpS+NGpTNkbwEdWavViBCYjBvgrYLoCWMpX70J6veieNgxkSel?=
 =?us-ascii?Q?bF+vObXziJPHZp5tuEoKhqh2qtA2Q6ZgaOFGNcr23WHkpG4WHtoTaAmI4Ku+?=
 =?us-ascii?Q?c1+XAjxCCgK5aaEgjTtPkkqfMvPySQly+u1znVLQOSVp5YPpVSJcDp+/7Mlq?=
 =?us-ascii?Q?xA6mmGS1mB728AQPSnyEYxYnYpwgWUkaRVmOYizDEaFoYF012rKpPe4CP1jo?=
 =?us-ascii?Q?CUh5XrYrpuwVDx/U4nVsWcLWQEROWuxxRzH2SVq2y8FbGp7rG/AMGuxv6HBD?=
 =?us-ascii?Q?5grxIn1x1P724t2g8rRDnfL3+ZGmJHISTa2iNIipZGwqCkbZFs6/fjfQHywS?=
 =?us-ascii?Q?b17uLNA9Tiupz/gjRzjfTcFWjRwiufVabpG9yOqhXmIYLu57fntOwdhpgKSI?=
 =?us-ascii?Q?nAfPnMFE4iFJJC4OzXkN3qnxWDPMFuZWNrlVb8rW5h+KtGV2kCNJEpJkJmJU?=
 =?us-ascii?Q?EOwkOWiz1xObw+zZaxEOSRfP4MBRgs1qLtbqtRDAudmefG7SKsvBvytju8RG?=
 =?us-ascii?Q?fHD4jRY0dzJ+xW7gPHLtAirmZUu67RWyAEJn4dKSylzny0T99eoLc8khPhGI?=
 =?us-ascii?Q?Y2LmOlDbQCmgdn6AipH+ywBO?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR18MB3882.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c68be878-d6e0-469a-80e0-08d92ab6cc90
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jun 2021 19:51:25.3604
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aKLMqnKllI/rok74WeOXwQlqSUdps6RB8+XGExv7jn9dd+mgr3SgdjxV2n5WB6XmnuzJecjvFD57CTttPuym5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2759
X-Proofpoint-ORIG-GUID: GIwFNgMknXPlT6HppI9XoFBQuIzzBoz7
X-Proofpoint-GUID: CMeGWyAKWMRrunhRAfiCuHYLWNnLw-S7
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-08_14:2021-06-04,2021-06-08 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Tue, Jun 08, 2021 at 10:41:00PM -0700, Keith Busch wrote:
> On Tue, Jun 08, 2021 at 12:08:39PM -0700, David Miller wrote:
> > From: Christoph Hellwig <hch@lst.de>
> > Date: Tue, 8 Jun 2021 15:43:03 +0200
> >
> > > please drop the nvme-offload code from net-next.  Code for drivers/nv=
me/
> > > needs ACKs from us nvme maintainers and for something this significan=
t
> > > also needs to go through the NVMe tree.  And this code is not ready y=
et.
> >
> > Please send me a revert, and I will apply it, thank you.
> >
> > It's tricky because at least one driver uses the new interfaces.
>=20
> Shouldn't whoever merged un-ACK'ed patches from a different subsystem
> get to own the tricky revert?

Dave, we will provide a revert patch.
