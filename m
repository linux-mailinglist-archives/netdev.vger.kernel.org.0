Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C35D045A816
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 17:36:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236314AbhKWQj2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 11:39:28 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:45208 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233389AbhKWQjW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 11:39:22 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1ANAMvtN005580;
        Tue, 23 Nov 2021 08:35:55 -0800
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2176.outbound.protection.outlook.com [104.47.73.176])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3cgug529dk-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Nov 2021 08:35:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hE7MgM4rM85o4Btd4ZWw/+2eY41E4dgmG/G5vCKCfs0ZRoddXb2n4hiQOkUmPLTRDDwr4EnK89WAd9csMMHfmRtNLiITf/ig2LsYZrbgL+vBaKh3Os8DqL0J/bW6cmm5XtMNEzfs50badmIbNOhM2kDUn3+XOex3T9+24bFhh0abQ6O1remIqxFB5pVfXesKVGo8iimCLhkshreMhtaUPOCIR5L5BX3+hAN9GIeMwf8SQrKHOYKZveN7hbVaEkos9EcIfvIirA34a/mv8Vrnf3Ly8X3ynEN0nHiqrkI23x5K1QjHXnvxNhuqpGhf/cole57gVlxVVp8YqgWmza97GA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4j9EK+RnwpGy5p90uICWTM1W5uQkfGFaCqtgaQzMO0A=;
 b=Dz3Q+1O0aCJCGQHjWjshKaATI3FNaXQaZxbr3O7nNF2AFOsUSmmOdQ1xLOsQ+YhWWyR82WpjsGyj7xzrQ0rdllqzO0HUuiBdOrGuqhC9oLgt8VzWB7WmCjhuDTq3Z5zxOGCTn646i/uiUaj8K1zK8pPHNWkHKFCZCQjiY0s7HMAm3ig/zOoRDh5kSa3+qLqRxj8UW1Czr4EB87dy7isU8TcBtuBZ53F9SjT8T15gYu4SHKNC/AOocmQRUPceMXxYLF2I2DyYPw61mJsb98wHtyecJ+mv83r8ApttLJ1yAjuqF/n/iCJcTzsroJU80XwMEUbiIaR0vPWWi/CvieoXEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4j9EK+RnwpGy5p90uICWTM1W5uQkfGFaCqtgaQzMO0A=;
 b=BkKfQu3n6kZhNaqCsjGyk0FKnYC9DjnY+XK0lACukwEFSuo1OYlZ39+vIP/a/uDNGh2/42fgeQNzOIQKtWI9E+9dPHCBEQmoaCd9xV7gr7UXk7/pWwKL9mZE4PSRM91DBAWZz4W5T65LFxuILAn/RkrfhZ7CdOLVhjvqemBGMx4=
Received: from SJ0PR18MB4009.namprd18.prod.outlook.com (2603:10b6:a03:2eb::24)
 by BY5PR18MB3427.namprd18.prod.outlook.com (2603:10b6:a03:195::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21; Tue, 23 Nov
 2021 16:35:51 +0000
Received: from SJ0PR18MB4009.namprd18.prod.outlook.com
 ([fe80::f5d7:4f64:40f1:2c31]) by SJ0PR18MB4009.namprd18.prod.outlook.com
 ([fe80::f5d7:4f64:40f1:2c31%5]) with mapi id 15.20.4713.026; Tue, 23 Nov 2021
 16:35:51 +0000
From:   "Volodymyr Mytnyk [C]" <vmytnyk@marvell.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paul Blakey <paulb@mellanox.com>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "coreteam@netfilter.org" <coreteam@netfilter.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net v2 RESEND] netfilter: fix conntrack flows stuck issue
 on cleanup.
Thread-Topic: [PATCH net v2 RESEND] netfilter: fix conntrack flows stuck issue
 on cleanup.
Thread-Index: AQHX4IgtTXkn6umzxUSR7vyg3u+6CA==
Date:   Tue, 23 Nov 2021 16:35:51 +0000
Message-ID: <SJ0PR18MB4009934E6C87505AD1A7349FB2609@SJ0PR18MB4009.namprd18.prod.outlook.com>
References: <1635931896-27539-1-git-send-email-volodymyr.mytnyk@plvision.eu>
 <YZbNFaKUHaCIYdRK@salvia>
In-Reply-To: <YZbNFaKUHaCIYdRK@salvia>
Accept-Language: en-GB, uk-UA, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: 4f3cb7ec-2b60-b943-c6ff-3cbf7e1d4c39
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d8144871-6775-480b-e3f0-08d9ae9f5004
x-ms-traffictypediagnostic: BY5PR18MB3427:
x-ld-processed: 70e1fb47-1155-421d-87fc-2e58f638b6e0,ExtAddr
x-microsoft-antispam-prvs: <BY5PR18MB342738F30C0739AE4B084B49B2609@BY5PR18MB3427.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wP2EwaGa56piSwYRawUZuod90cK7MnP5gEtGFuU45PpuxnBLhF3A2aAzBMLZNH+4lJYlsX16Kbht7AZGoJLQRV2TEZxeKG2zdNloJXxxGdCSNLhSg6lXylimxnpXKKOfNPLXzCETLQdPT/I3Lpg8/tSYyosNvvedsT2KsDCaabrplMJ8sabhgILZaGNhMVDsK7cPu1RGRGd7RX/l2IePYN68PIeQg4l1LvQTFhTyUg1rpwJBdZWpV9UP1u3aWc5uNC6kgc1umsgsvbYNMVORJeyubrA+oQonVcHOfQt7PQwfhd0n35Ql4jV+FJKsdGqQOxRXhelv1mBslTVmDDn6IyP8zktMPTvlipxNevXBbLDS+fZWETKQjmgz/v9RNVCBzg/nNisPjNeI4YamO4NLhZkEw4dRf6dSjL3SKBKoSLa76BySXi4KYFAgIUQoBje+dVjlWKYF6QDCXV1Sn/VF3Gt+6PJD+3+YlUrd4+QJ0+E1ZfGEC83nIIgew3x+YRsNYq+JUez93vCs0kgMtByoO0wy0ix2cb3kHUu4NGzsaKUi6JPDg6Hx790oJdEeqGdxHYvP6uoMSlmLYIUmdEmkZQEkfjwJoTo6nuU861bb+zrMOHTUBGmE/Bges8H6q7iDYqbCF5DJYXI6QuoSRoGMSXbsZK+F9ubs8MctrlArsJm88INItNKxkUCvyIZRHdjnGIa45A2dFw+GmIjCD3WKPg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR18MB4009.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(122000001)(38100700002)(8676002)(86362001)(33656002)(66446008)(6916009)(71200400001)(8936002)(55016003)(26005)(9686003)(4326008)(186003)(38070700005)(6506007)(7696005)(52536014)(5660300002)(316002)(508600001)(66946007)(66476007)(66556008)(64756008)(2906002)(54906003)(76116006)(83380400001)(7416002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?hyPOOC2xUv4T1FjLe0ySx9tdohuFfZ5Q4GVDitL0Kn6nmDe3vK7w8o78J0?=
 =?iso-8859-1?Q?lz2kqZm5tDN//jtjYijhRBBuKtPTXfuFY7E6MGuPb2kfCH+P00YStEbreu?=
 =?iso-8859-1?Q?curoi6hYgjZcOp63ojuEhuGii6saf8e6VTRMXUyQHMh3oxFprCWRvzDzt9?=
 =?iso-8859-1?Q?fdGBHq3afvMByFA5Pugf+fHm/9Ue/VevWA8AmQYFtcti9NxzeBNWVuy5Nx?=
 =?iso-8859-1?Q?T8DEYOTNLazi6g5T4JYyObOcZc0JlcsYBim8pVmBiQ7yGntcmQev/UUDf4?=
 =?iso-8859-1?Q?xA2JxaLupyR40rIKUSMRImr1kWvzR3pFt3EUs/7mrdiHKTfMniMqErc21I?=
 =?iso-8859-1?Q?apX7T51IZ0TCQkITnZjNC/njsSwd6tBoVyc/oERHkQLaHofx4Mze7XRGc6?=
 =?iso-8859-1?Q?qNZHHcCMbWyKyv12bGGh9jVD1GesWu9s1cESpumEtxyV2NrZ69w+oqwEEG?=
 =?iso-8859-1?Q?zDaEwnUm0V1yExpunPtX0q3w/FwYX8b99V49Uk2UB42ZMWZjkCElrFcvPa?=
 =?iso-8859-1?Q?3WlgKSJyOScgDa42Wck0cVauRqvGDN/HduYZbfBjBfPetIUn8YepkoJtWk?=
 =?iso-8859-1?Q?6Gude1JBxC5yk9GVIZZYehiehmIhlHY9iijOsVGBc6ECNAeaeM7xJdFx+B?=
 =?iso-8859-1?Q?sgahnBK+X1kOJYnOBZk4G52mfm8ErsVEHWrztnqTDyMS7R85bxzfXq+u7h?=
 =?iso-8859-1?Q?E+Z9N1aNOvph6LIXkC4dq1T6wkE9ruh7eYxc9N25DAq2ZBDVw5xe/y1OMT?=
 =?iso-8859-1?Q?c9CUOYClQtkFSpHrteTeTtZR5mCie5cb5McXV7Ru/ugO5Xw0DIGbDeOvlH?=
 =?iso-8859-1?Q?eiBbjL5/F0oC6BMnbFec2S0iGFqCY5pEI8C5lTCmMpodYYcMzAe3EiSLgR?=
 =?iso-8859-1?Q?imaETEE4cndZxfOqdyKg/Ur0zcFrHIS35oBxc6BGT4AXEDqwKC5W03CKj2?=
 =?iso-8859-1?Q?0UYXhsLi1MMblvxCjWrcdXIGP7xP5pd/R9xeZWSznm5RdywMVgn6WGr1fg?=
 =?iso-8859-1?Q?tJs+5D75JjDG0B6KuG0Dy+rZeWlpCXVbNgmAT8hEsMPAjfDiwOb9vl1oQZ?=
 =?iso-8859-1?Q?ecI2nxsXc/nyV/AFP1y3oUjm/RlXuH5tFfEqL7qd4pIRQ8hXi0MBJA/Td2?=
 =?iso-8859-1?Q?qN07fVr//a6wmqoRIiooZ5zYAlcIOAGviCOqHKoNchhuu4r1dicM0wI3u+?=
 =?iso-8859-1?Q?CW6bMPndsvmHXk29kJ3FHBHmj7HEYYkheRT0OKu944VMN/znD5NHW3QB5X?=
 =?iso-8859-1?Q?i+FCKst2x62q6xRng/ie5g/CoWLKuaQE4lrh+almnB9mnXAzUTIGzmYNhb?=
 =?iso-8859-1?Q?Wlph2t9wVwHmkeCpe/EtGyzmWmoA8Y6D8fRkfbgrH0BMYYClExbebt6g5P?=
 =?iso-8859-1?Q?eAsWlR/FY32wD7lWxNM3Z6UOkcLQ0J6Pz0fy1eQmvLycWNZZ8hoVM144rB?=
 =?iso-8859-1?Q?W53WF6d6q31uqhFHfLqbgNKPh5hajMnf1rdMjpxuH2ntWmv3a97UQ8h/U7?=
 =?iso-8859-1?Q?9vTnx0nsQJthJq3weJguBzmpnBy+zmwDfcn5CVP1N82gDUhjn4dDpSCiEj?=
 =?iso-8859-1?Q?jeJVO/ueKDLN7o8QPJ1MlZMtYOv8HIAtH/3mwKScRxIy0L0cHtW8znaAvv?=
 =?iso-8859-1?Q?ZBDwJAC+ExqyUhz1U6iux8c1YSKioeXzA2+dh9CmTLUdkokpztrz2laQ?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR18MB4009.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8144871-6775-480b-e3f0-08d9ae9f5004
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2021 16:35:51.3175
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9T47MF9fJ2am7eRmK3WyxVPZllxdOYBPAr2Kcaop39c4S46nMbL3PFi4trGl6yoI+iupbKtliM8q7N/0vdDKZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR18MB3427
X-Proofpoint-GUID: uSOm7euXi6T3FbsqRsbnIjvUlvvnLpJk
X-Proofpoint-ORIG-GUID: uSOm7euXi6T3FbsqRsbnIjvUlvvnLpJk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-23_05,2021-11-23_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hi,=0A=
> =0A=
> On Wed, Nov 03, 2021 at 11:31:36AM +0200, Volodymyr Mytnyk wrote:=0A=
> > From: Volodymyr Mytnyk <vmytnyk@marvell.com>=0A=
> > =0A=
> > On busy system with big number (few thousands) of HW offloaded flows, i=
t=0A=
> > is possible to hit the situation, where some of the conntack flows are=
=0A=
> > stuck in conntrack table (as offloaded) and cannot be removed by user.=
=0A=
> > =0A=
> > This behaviour happens if user has configured conntack using tc sub-sys=
tem,=0A=
> > offloaded those flows for HW and then deleted tc configuration from Lin=
ux=0A=
> > system by deleting the tc qdiscs.=0A=
> > =0A=
> > When qdiscs are removed, the nf_flow_table_free() is called to do the=
=0A=
> > cleanup of HW offloaded flows in conntrack table.=0A=
> > =0A=
> > ...=0A=
> > process_one_work=0A=
> >   tcf_ct_flow_table_cleanup_work()=0A=
> >     nf_flow_table_free()=0A=
> > =0A=
> > The nf_flow_table_free() does the following things:=0A=
> > =0A=
> >   1. cancels gc workqueue=0A=
> >   2. marks all flows as teardown=0A=
> >   3. executes nf_flow_offload_gc_step() once for each flow to=0A=
> >      trigger correct teardown flow procedure (e.g., allocate=0A=
> >      work to delete the HW flow and marks the flow as "dying").=0A=
> >   4. waits for all scheduled flow offload works to be finished.=0A=
> >   5. executes nf_flow_offload_gc_step() once for each flow to=0A=
> >      trigger the deleting of flows.=0A=
> > =0A=
> > Root cause:=0A=
> > =0A=
> > In step 3, nf_flow_offload_gc_step() expects to move flow to "dying"=0A=
> > state by using nf_flow_offload_del() and deletes the flow in next=0A=
> > nf_flow_offload_gc_step() iteration. But, if flow is in "pending" state=
=0A=
> > for some reason (e.g., reading HW stats), it will not be moved to=0A=
> > "dying" state as expected by nf_flow_offload_gc_step() and will not=0A=
> > be marked as "dead" for delition.=0A=
> > =0A=
> > In step 5, nf_flow_offload_gc_step() assumes that all flows marked=0A=
> > as "dead" and will be deleted by this call, but this is not true since=
=0A=
> > the state was not set diring previous nf_flow_offload_gc_step()=0A=
> > call.=0A=
> > =0A=
> > It issue causes some of the flows to get stuck in connection tracking=
=0A=
> > system or not release properly.=0A=
> > =0A=
> > To fix this problem, add nf_flow_table_offload_flush() call between 2 &=
 3=0A=
> > step, to make sure no other flow offload works will be in "pending" sta=
te=0A=
> > during step 3.=0A=
> =0A=
> Thanks for the detailed report.=0A=
> =0A=
> I'm attaching two patches, the first one is a preparation patch. The=0A=
> second patch flushes the pending work, then it sets the teardown flag=0A=
> to all flows in the flowtable and it forces a garbage collector run to=0A=
> queue work to remove the flows from hardware, then it flushes this new=0A=
> pending work and (finally) it forces another garbage collector run to=0A=
> remove the entry from the software flowtable. Compile-tested only.=0A=
=0A=
Hi Pablo,=0A=
=0A=
	Thanks for reviewing the changes and problem investigation.=0A=
=0A=
I will check the provided patches and will back to you.=0A=
=0A=
Regards,=0A=
  Volodymyr=
