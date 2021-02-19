Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFC0B320051
	for <lists+netdev@lfdr.de>; Fri, 19 Feb 2021 22:30:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbhBSV3b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Feb 2021 16:29:31 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:21376 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229553AbhBSV31 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Feb 2021 16:29:27 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11JLPPkL013547;
        Fri, 19 Feb 2021 13:28:23 -0800
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 36sesvxepq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 19 Feb 2021 13:28:22 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 19 Feb
 2021 13:28:20 -0800
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (104.47.38.55) by
 DC5-EXCH01.marvell.com (10.69.176.38) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Fri, 19 Feb 2021 13:28:20 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iKfJgWpEsTC+GokmcAYV0YOlEWtnEgJ1wXm40kqGC2975DjBKeoUQdFW73wjcpfUnamBPP6thSMGBpnOxODRVXdijujuugoYGMN68w66Q8aRpImpxuSNrE3ElW6QK3l7FpKOMuLRoOda5Xm32KoZ56MPxkXqe95nwLrxuusQgm+bzJd25rZfE9IcwORBLyG06DMTf5is2sFApHqtRXWUHKt/QPkoHEvF0bcM1oVewS5xNR6wTeIWoScgkrlxTiEZpCpMBH5EO2Qd2lhx5MjZowUuO6hkI4alrwUFYMHCxvPz1c8b3oUPAKH0o7WiHjEtZ8m9CXEjNp0fq54J2u3W2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M8UsqOLMUEBay2ibyo2epcHp594EJFZ9/EYd4yen6zE=;
 b=KwK2eEsCgmJPTeLiGjRpmDnEczB5qSdoMjUTAndFuIAEb2MfcZY7lvh9wtQvpyC4gbAmCKpSjvxG7JRp1iDUAiAF6+AIa7/u88ojl4DqCGi3Jy4klTr8bzAj8iAhLGXDe1LXOcfGBpCQUC1AuqZxSK5ilLGYFz2+n97tpmJDufFiv/tD0hdVv3mqwK2Er/LFpdnKftwkDxpW2O+LWvuZoSu6IayselQzTOwQgYIJITfQQBYIg+JZHE1btoFZxK1lmmJsG9yrnvUBbovtSqGRLVB8021OL502XOXrq06oAoCTW8cauuzo6Cn5mSj5S+XVGfmaY1Rci6OlZWgbydnJxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M8UsqOLMUEBay2ibyo2epcHp594EJFZ9/EYd4yen6zE=;
 b=qxETcfz8TwQw8EXvmZnDgd6z8Zjm4A5cJ+HukPnXTV3qFZy8PmIcj4QpJhxKJBRzLFkMV0zqGMgnsJZEyfaXjFwTuHOvTPWDORyp8Wi2JR1RGOl0wsfWUCqoJswmuIN6V3mTLepbK7691n0z+j0ZBdNIjL0V8GhY43nj5UQ3LHA=
Received: from SJ0PR18MB3978.namprd18.prod.outlook.com (2603:10b6:a03:2e0::15)
 by BYAPR18MB2519.namprd18.prod.outlook.com (2603:10b6:a03:136::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.29; Fri, 19 Feb
 2021 21:28:19 +0000
Received: from SJ0PR18MB3978.namprd18.prod.outlook.com
 ([fe80::bc54:e0f7:35a4:7897]) by SJ0PR18MB3978.namprd18.prod.outlook.com
 ([fe80::bc54:e0f7:35a4:7897%7]) with mapi id 15.20.3846.043; Fri, 19 Feb 2021
 21:28:19 +0000
From:   Ariel Elior <aelior@marvell.com>
To:     "hch@lst.de" <hch@lst.de>, Shai Malin <smalin@marvell.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "sagi@grimberg.me" <sagi@grimberg.me>,
        "axboe@fb.com" <axboe@fb.com>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Erik.Smith@dell.com" <Erik.Smith@dell.com>,
        "Douglas.Farley@dell.com" <Douglas.Farley@dell.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        "Prabhakar Kushwaha" <pkushwaha@marvell.com>,
        Nikolay Assa <nassa@marvell.com>,
        "malin1024@gmail.com" <malin1024@gmail.com>
Subject: RE: [EXT] Re: [RFC PATCH v3 00/11] NVMeTCP Offload ULP and QEDN
 Device Driver
Thread-Topic: [EXT] Re: [RFC PATCH v3 00/11] NVMeTCP Offload ULP and QEDN
 Device Driver
Thread-Index: AQHW/Xzy2DGKCj+t5UqXWoihA0pW+6peT2yAgAD0VYCAAM2K8A==
Date:   Fri, 19 Feb 2021 21:28:18 +0000
Message-ID: <SJ0PR18MB397807DB5295C9D39D93DF8EC4849@SJ0PR18MB3978.namprd18.prod.outlook.com>
References: <20210207181324.11429-1-smalin@marvell.com>
 <PH0PR18MB3845E15A62826C9B5A520628CC859@PH0PR18MB3845.namprd18.prod.outlook.com>
 <20210219091237.GA4036@lst.de>
In-Reply-To: <20210219091237.GA4036@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [212.199.69.2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6517cfc1-8933-4268-43d8-08d8d51d46d7
x-ms-traffictypediagnostic: BYAPR18MB2519:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR18MB25197744AC2C9257CF4E68B2C4849@BYAPR18MB2519.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fqZfJJEAktPtWu0KU+fmhVYEJtInX6pBwwoKMwHgWgOSBwJZxpv+lcMQwJrcdzlH0ty+51cN1okhA/B7xEiyZhwYiZkov8kySn8E0m8aXFyBchYT0r1U2K3me5WZoxYa0MJL4Lt5B+jykHNlVO7d1PhXV2Q96hUwp/gi0dgGuMNKjEpQkqfnSJkoXbJ7Uyp9Eo4Efnf5DgQPuq26efViLug/lmS9WfypBaqsxh2woySu/bjMj8GC9zOYA1AvVPZobzcf19PTkCa1ilMBSZf4VoUP3/8flezkukiYM97Vg/A8oCfXUFXWN2mBK+hk/amQubqwjlyFW9sq+56JeapNlZpDy7kcuMUd3U6VeDgqSZ6eHbuz0b0spA+zBjILqdu9i0AYN7PU5bOMu+YeVhraSH4cTd1vdtJdAMPlLfjNBL39ksvoviqKMjAw4mbrLHh+iVkupekvCsTLTXxqfBK6KexPzx+cXu4cj4zueKLTCF95aPFWlNXQwZfWDiBExosNfHkhGQ7CgA7dfg876f+iYw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR18MB3978.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(366004)(396003)(346002)(376002)(110136005)(54906003)(7696005)(316002)(186003)(6506007)(33656002)(64756008)(66446008)(55016002)(66476007)(8676002)(52536014)(5660300002)(7416002)(9686003)(4326008)(26005)(66556008)(86362001)(71200400001)(6636002)(76116006)(66946007)(2906002)(478600001)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 222491Q2Ybaq1HTH/wdkNEQh2R9hsJEpLPDoFb5PQVaUC7rZUM2r52eQ9PC1s53LyIVpRSyeYf0YfG9mpCuy8TddQH/JoEtg4NFZFM+Me6jBzoSUl32Aj0oXWcrDXn0tuisbi7scCeQ6Tq+20O/CnHhyLC/DNttoW95FEY9YFSzvjPHGG1bt+NRzHfQUprxhzstIqh227JU3ZHCWCyaF019OpHfu+IauB0TAbIwdd1qVog48e/nG7zq6xrXADvdRlyddBP603z56yJk1H6f8Ee4qwyqK+bolg5N7NmJD5/c3+kVn6Hj84QJSFjYDDHeNDG9IhXdq0waxKsmhvWyYAYEM9RhRx7vHzwMHMwCvi6MsCpzHk0DIMYvqhbk/AOTjovfuaDaPHgA5NLA9gYY1jQd9u8WceECHhyPuKVXyLIkoYLHxxw4ZWxek8WeH7sfIuju1QBvnbYCErPX+lesij/FI1uZcR+cTMOxbGqPPMrJdcKWnWGrsZZfpjsGlF677MlHoR660Wlf+W+rJHAC2gTI7eIVBN3nyadgAM0g+pdur2IGIqgF9r27I68LMpsn3g/s2wJ9xo1sKryLLvUXMH3bI5CrJ513fjedbeZJn8BzpbGej3E5+DaD0WihVmekPHW7XXRSt17mnyC9zbkBX47ftlE2MRmK4HHlvd8mZ66EStYjItrqo1CbcO8bKilbMR7pgqQxnsgVe7I6jv29I+7nPX5IgvYWYYeyAdWbjkxQ=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR18MB3978.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6517cfc1-8933-4268-43d8-08d8d51d46d7
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Feb 2021 21:28:19.0742
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h1g86xpHRV0dfu1r+1qzXdPH92j4XfSTcfF7dlsQBznKKzLaeAGMjA5TcnZYZ051wJHjEHhHDn87eeLmRVFUPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2519
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-19_08:2021-02-18,2021-02-19 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Thu, Feb 18, 2021 at 06:38:07PM +0000, Shai Malin wrote:
> > So, as there are no more comments / questions, we understand the
> > direction is acceptable and will proceed to the full series.
>=20
> I do not think we should support offloads at all, and certainly not onces
> requiring extra drivers.  Those drivers have caused unbelivable pain for =
iSCSI
> and we should not repeat that mistake.

Hi Christoph,

We are fully aware of the challenges the iSCSI offload faced - I was there =
too
(in bnx2i and qedi). In our mind the heart of that hardship was the iSCSI u=
io
design, essentially a thin alternative networking stack, which led to no en=
d of
compatibility challenges.

But we were also there for RoCE and iWARP (TCP based) RDMA offloads where a
different approach was used, working with the networking stack instead of a=
round
it. We feel this is a much better approach, and this is what we are attempt=
ing
to implement here.

For this reason exactly we designed this offload to be completely seemless.
There is no alternate user stack - we plug in directly into the networking
stack and there are zero changes to the regular nvme-tcp.

We are just adding a new transport alongside it, which interacts with the
networking stack when needed, and leaves it alone most of the time. Our
intention is to completely own the maintenance of the new transport, includ=
ing
any compatibility requirements, and have purposefully designed it to be
streamlined in this aspect.

Protocol offload is at the core of our technology, and our device offloads =
RoCE,
iWARP, iSCSI and FCoE, all already in upstream drivers (qedr, qedi and qedf
respectively).

We are especially excited about NVMeTCP offload as it brings huge benefits:
RDMA-like latency, tremendous cpu utilization reduction and the reliability=
 of
TCP.

We would be more than happy to incorporate any feedback you may have on the
design, in how to make it more robust and correct. We are aware of other wo=
rk
being done in creating special types of offloaded queue, and could model ou=
r
design similarly, although our thinking was that this would be more intrusi=
ve to
regular nvme over tcp. In our original submission of the RFC we were not ad=
ding
a ULP driver, only our own vendor driver, but Sagi pointed us in the direct=
ion
of a vendor agnostic ulp layer, which made a lot of sense to us and we thin=
k is
a good approach.

Thanks,
Ariel
