Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4741A25D8A2
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 14:29:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730239AbgIDM3Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 08:29:24 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:30746 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730143AbgIDM3U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 08:29:20 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 084CSVql021666;
        Fri, 4 Sep 2020 05:29:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=ewHqkRV6pF1QkPYuiIuoETToVrMjJRc3AHcDljndpTs=;
 b=X4K6BP0bKpfqKeYtFoFCQRGZRdrNt4nHdz+xBnTR1PbcPXNyHBA75w8vbv73IRvHWv+w
 ELrA8jTag89yguBpSp9dnRVIalRRAdnNwPoMTSgaqIntmzdsIr90D6mBLWXAADFjYgZq
 Wg1XmO3UzFOKHXn6uTCBrfsuKP0oIumI/Cp40D0VuOoWOfN4lGZzTzbJdFwvxpNHk4UE
 FmI0TXCmwaQX/wmOgZGg8aDKoEKGUqPp6d43rFn4tTNmteoPtGLMXvUrWIcef3ta6FeP
 noXnznuTvAYZTq4gIKojkeftNWc1N64ZR6qzUYwYw+asonJvZkk3OUFtSzbKooe2je2I uQ== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 337phqhk53-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 04 Sep 2020 05:29:09 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 4 Sep
 2020 05:29:08 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 4 Sep
 2020 05:29:07 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.105)
 by SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Fri, 4 Sep 2020 05:29:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CYCTuAabcOgU/fE7G5KldIZZ3tpTbmwbeugTkOx4xfyjE+lXlVpepGF5nph1zKkRNmPvLh167SL4xVpa0eLfq3jV0vChnDq5ydwa2YoCqM9IiwAcTxQ6RYye0MBqMcBNtClUcVVhVGKb3HsOHaln3NjgQNACsrVUdT1UB49EDWlwVEj6yD5Q8CWWhkmWsHRaioETSvY42hZMvsa902cnuQwg6nP9LHWaDStObALR8kmNO9+8x8A36Nhek6Ct21m5Ys4nD/HmWbyNM1naDGmgOBw3Snj8ejoJ63u7RxDttTNLcJc81pLxZRT5XLd+bbEVs4AQJWq140DxiArnGdephg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ewHqkRV6pF1QkPYuiIuoETToVrMjJRc3AHcDljndpTs=;
 b=Y8avjfVmmUcKq8EtMpXeL+i9X+GHRdvQ389OkWdNv3bE1xv0zhasL6rrFoNUpnQTtXtL2io4FDg98FczVGhaRP338EkTA+VevMHAK7ool4RTBbNdDo/jpY76mxMLeHHTOoz6bLfbqDmqZ/AuXyYulBJndQprtRE0FPUl7zj6KLn4s3rI1BV7uO973RkQJdhOCen4vVm7tycL0tC8UiOitnhzi7ajg0q3Y8vphMV9kWDUoIEmzRHJrhLRKcA2mylv4EwYh4+vnyPlXRKmCURmG53H6QiYAkLWwxEg3hzdv8DIkkfe7xRL6/mKjgBl5z7t3s0i75/emFLR8IPUoqBC4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ewHqkRV6pF1QkPYuiIuoETToVrMjJRc3AHcDljndpTs=;
 b=W6+wdeeRE7Ogr75GVBtp81wBuncmN223YLlQfCJahkwH5BFw5QL/rGFIRL8dfBXlqOa6VEgoOtmTDfVQYWO+QHxj+CuV1kYb7hBzcuAxMtGPy43Xix8cObT988pAio9KkNT8FNOBxZDGEn17KJbSLWT4pDwVx46a5Gnzli0VB2E=
Received: from BY5PR18MB3298.namprd18.prod.outlook.com (2603:10b6:a03:1ae::32)
 by BYAPR18MB2423.namprd18.prod.outlook.com (2603:10b6:a03:132::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15; Fri, 4 Sep
 2020 12:29:04 +0000
Received: from BY5PR18MB3298.namprd18.prod.outlook.com
 ([fe80::fd34:4df7:842f:51c7]) by BY5PR18MB3298.namprd18.prod.outlook.com
 ([fe80::fd34:4df7:842f:51c7%4]) with mapi id 15.20.3326.025; Fri, 4 Sep 2020
 12:29:04 +0000
From:   Sunil Kovvuri Goutham <sgoutham@marvell.com>
To:     Jiri Pirko <jiri@resnulli.us>
CC:     Jakub Kicinski <kuba@kernel.org>,
        "sundeep.lkml@gmail.com" <sundeep.lkml@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>
Subject: RE: [EXT] Re: [net-next PATCH 0/2] Introduce mbox tracepoints for
 Octeontx2
Thread-Topic: [EXT] Re: [net-next PATCH 0/2] Introduce mbox tracepoints for
 Octeontx2
Thread-Index: AQHWgickhZqxv/ypi0Wop/9//E5UfqlX9gtAgAAyzoCAAAHrkIAAOfQAgAADSzA=
Date:   Fri, 4 Sep 2020 12:29:04 +0000
Message-ID: <BY5PR18MB3298C4C84704BCE864133C33C62D0@BY5PR18MB3298.namprd18.prod.outlook.com>
References: <1599117498-30145-1-git-send-email-sundeep.lkml@gmail.com>
 <20200903121803.75fb0ade@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <BY5PR18MB3298899BF15F266144EE8760C62D0@BY5PR18MB3298.namprd18.prod.outlook.com>
 <20200904083709.GF2997@nanopsycho.orion>
 <BY5PR18MB3298EB53D2F869D64D7F534DC62D0@BY5PR18MB3298.namprd18.prod.outlook.com>
 <20200904121126.GI2997@nanopsycho.orion>
In-Reply-To: <20200904121126.GI2997@nanopsycho.orion>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: resnulli.us; dkim=none (message not signed)
 header.d=none;resnulli.us; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [49.205.243.210]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 94121a6e-c816-4ea6-cadf-08d850ce1c8e
x-ms-traffictypediagnostic: BYAPR18MB2423:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR18MB2423080A4F058DD5BBC12A77C62D0@BYAPR18MB2423.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1850;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Xgsf/XG07UyphJ6/2IyvzqU0rBgaFhay5P9dUaE2HMBVThhz0RcAd1nO1Z+zFEnuzEVV7keVDD6u6Kcgiy2c9VEubDo5mdDASJA6LE4XRYecQXsbYvbYYRDjLWwhmc7eJk8pQBXHCQVPEhWxctKxoqmW+5Ya9YwD2Q6Z3QH5cfwVpps4w/TS9z61pDu1xyxNXWpJbHfi18igTa3PXVH0htmiXI5JKE5BI55m0ZmYs/VNcCdN2o0rNkKj05VgVgCbl3dHCIMNO+Bvwzr8sYPnzD1StJ5o+F+xU53AR1KhlrRn4YsNvEmaYlDQfrnfm4d8CYMUu2AFeuviwaZTjGk6bg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR18MB3298.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(366004)(346002)(376002)(136003)(107886003)(4326008)(9686003)(6916009)(55016002)(83380400001)(33656002)(66946007)(52536014)(8676002)(5660300002)(8936002)(2906002)(53546011)(186003)(6506007)(86362001)(316002)(71200400001)(7696005)(478600001)(26005)(66446008)(54906003)(76116006)(64756008)(66556008)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: FxiTqtm9MTUhxzpuA8opBjQmHnAYyTcMv/Hm8bto6ifsgbA5FgM6nUnsUjZvuQVec8rXUDRkbVlozoFkjKQh/F74vB1YDBcoKdTMJLM97VRRsWAPMJKd95gdGpLsYLFCG73HBE72iLDalmHiQHQxZYSp28KoLm3+MDnHhDXHQaCSl6kQsJodTJqX06Poe3GB4KK8WKB2b9p3l8ftuOD0nBCssnZ46EAvb54V0vmZG6qSqVpB2NE4kHOE/+fRsqdLw69oMcD03Ee2LLDBgjXQ5+pCIA+gbpbY3fjjwucmwXdAGvRgch3Gc/U5LUmoFB8f9w1fyYSPyzD28DilrFPe5VdIafSzmXC+CB0qBJcRZJESrzJwpq3a/UMcbGuLUf1lk7CER+eMvInmRXqmOlWK0e8Cxux3mjXDO/8iB/FqPEAap9inomQ8py9PtpT8pq362iN9eo2c3pzLQk13u03iw/iKoSXdet2lKnAYCzlorrHu4RhfiLKAVmGkFRYfAd7YvGKrNWzjz0F05dD2kYVFGMbgXcnLkVe/AdQ3YgUQNN1sOQ9QgekyMwbIgVQrKtl6v/EK5ZOtGTkykTVRfzdyAFWdPGsXtVu8rkO8ohQqqft9vb7FEvNvp0zyl3XQ0+3IaBlCPjelNF/EyDZ6SYQvpA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR18MB3298.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94121a6e-c816-4ea6-cadf-08d850ce1c8e
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Sep 2020 12:29:04.4041
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ee3FS69v9m8YQAR0DvhAPpi9/kF7VlwXl911G1vVssRCdjfGwND5xElo6EVUaUomXG5o1wgobQ2S90G0gaGoag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2423
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-04_06:2020-09-04,2020-09-04 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jiri Pirko <jiri@resnulli.us>
> Sent: Friday, September 4, 2020 5:41 PM
> To: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> Cc: Jakub Kicinski <kuba@kernel.org>; sundeep.lkml@gmail.com;
> davem@davemloft.net; netdev@vger.kernel.org; Subbaraya Sundeep
> Bhatta <sbhatta@marvell.com>
> Subject: Re: [EXT] Re: [net-next PATCH 0/2] Introduce mbox tracepoints fo=
r
> Octeontx2
>=20
> Fri, Sep 04, 2020 at 10:49:45AM CEST, sgoutham@marvell.com wrote:
> >
> >
> >> -----Original Message-----
> >> From: Jiri Pirko <jiri@resnulli.us>
> >> Sent: Friday, September 4, 2020 2:07 PM
> >> To: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> >> Cc: Jakub Kicinski <kuba@kernel.org>; sundeep.lkml@gmail.com;
> >> davem@davemloft.net; netdev@vger.kernel.org; Subbaraya Sundeep
> Bhatta
> >> <sbhatta@marvell.com>
> >> Subject: Re: [EXT] Re: [net-next PATCH 0/2] Introduce mbox
> >> tracepoints for
> >> Octeontx2
> >>
> >> Fri, Sep 04, 2020 at 07:39:54AM CEST, sgoutham@marvell.com wrote:
> >> >
> >> >
> >> >> -----Original Message-----
> >> >> From: Jakub Kicinski <kuba@kernel.org>
> >> >> Sent: Friday, September 4, 2020 12:48 AM
> >> >> To: sundeep.lkml@gmail.com
> >> >> Cc: davem@davemloft.net; netdev@vger.kernel.org; Sunil Kovvuri
> >> >> Goutham <sgoutham@marvell.com>; Subbaraya Sundeep Bhatta
> >> >> <sbhatta@marvell.com>
> >> >> Subject: [EXT] Re: [net-next PATCH 0/2] Introduce mbox tracepoints
> >> >> for
> >> >> Octeontx2
> >> >>
> >> >> External Email
> >> >>
> >> >> ------------------------------------------------------------------
> >> >> ---
> >> >> - On Thu,  3 Sep 2020 12:48:16 +0530 sundeep.lkml@gmail.com wrote:
> >> >> > From: Subbaraya Sundeep <sbhatta@marvell.com>
> >> >> >
> >> >> > This patchset adds tracepoints support for mailbox.
> >> >> > In Octeontx2, PFs and VFs need to communicate with AF for
> >> >> > allocating and freeing resources. Once all the configuration is
> >> >> > done by AF for a PF/VF then packet I/O can happen on PF/VF
> queues.
> >> >> > When an interface is brought up many mailbox messages are sent
> >> >> > to AF for initializing queues. Say a VF is brought up then each
> >> >> > message is sent to PF and PF forwards to AF and response also
> >> >> > traverses
> >> from AF to PF and then VF.
> >> >> > To aid debugging, tracepoints are added at places where messages
> >> >> > are allocated, sent and message interrupts.
> >> >> > Below is the trace of one of the messages from VF to AF and AF
> >> >> > response back to VF:
> >> >>
> >> >> Could you use the devlink tracepoint? trace_devlink_hwmsg() ?
> >> >
> >> >Thanks for the suggestion.
> >> >In our case the mailbox is central to 3 different drivers and there
> >> >would be a 4th one once crypto driver is accepted. We cannot add
> >> >devlink to all of them inorder to use the devlink trace points.
> >>
> >> I guess you have 1 pci device, right? Devlink instance is created per
> >> pci device.
> >>
> >
> >No, there are 3 drivers registering to 3 PCI device IDs and there can
> >be many instances of the same devices. So there can be 10's of instances=
 of
> AF, PF and VFs.
>=20
> So you can still have per-pci device devlink instance and use the tracepo=
int
> Jakub suggested.
>=20

Two things
- As I mentioned above, there is a Crypto driver which uses the same mbox A=
PIs
  which is in the process of upstreaming. There also we would need trace po=
ints.
  Not sure registering to devlink just for the sake of tracepoint is proper=
.=20

- The devlink trace message is like this

   TRACE_EVENT(devlink_hwmsg,
     . . .
        TP_printk("bus_name=3D%s dev_name=3D%s driver_name=3D%s incoming=3D=
%d type=3D%lu buf=3D0x[%*phD] len=3D%zu",
                  __get_str(bus_name), __get_str(dev_name),
                  __get_str(driver_name), __entry->incoming, __entry->type,
                  (int) __entry->len, __get_dynamic_array(buf), __entry->le=
n)
   );

   Whatever debug message we want as output doesn't fit into this.

Thanks,
Sunil.=20
