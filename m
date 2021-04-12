Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1EFC35D072
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 20:35:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245062AbhDLSfe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 14:35:34 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:36960 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236921AbhDLSfa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 14:35:30 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13CIEcqe169540;
        Mon, 12 Apr 2021 18:33:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=l90oDEErNEJuUz2JM736PZtQvVILLA9E/YPjjnlazoU=;
 b=LX30JjkuVSLya7f6hwPrW9hHIefA/ioOypb8PsAl8UdiZEYoC8Ym7kdOIBBW9nBbNfEP
 8GMO0Tq+pQmZuN9wU4SSFLU/vgyVYEw89bMOnd1CNxeZGQEWi7zZqKM6GZO0azctxRDi
 zszcVzB2Y21Q7eNNfizBXvbtmd4REk8C+g538nEIi8woTqs5kDzSaQPLCZI+MmRooMWD
 UBqe9JHmeVZQhc90aYh+6U4bE764L9fcInIrRbgKuvrXNB+KeiALg1vWVFfDVd2ISAqR
 PT1CHCIOkXA3h0XAJiyT8wvctkN7Tjy2EKs6AJUpsLNHI+dx1QqiZVp6TjJSbb21dkiv fA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 37u3ymcp33-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Apr 2021 18:33:00 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13CIFbSU003222;
        Mon, 12 Apr 2021 18:32:59 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
        by aserp3020.oracle.com with ESMTP id 37unwxqjff-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Apr 2021 18:32:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ABkmMVDflYarmLJ3eX0XVXqF26kDRAs1/HMeDbDy2SIgpAEHAj2mP2DC5TTpRPSbNCQ3zEeZZ+xreKX7xfs7ybhBVavGYaqh8K4/xS6LSj2lqVP4+ML9ulv8/lecM6atwCBU6uw1xyVdJWcD8jgR03GPW7YW1AQuMAeiGeF88UmaFHY2wE2Y0E2pzkb8xcgEmdVZj0IEmlhsyZ2rxOeXl/h03BZ04qJYrbOf4KSSBctGJnS7EnE4qszvGOD27At2TA2Tz4RRRMXtb7Fsy8m9uQ/kBc2r1d6BWDOwX40Ch7EbTOghWv4HNPzftx9zr8/3iSoxNoUwj7lAv4DPJFVhQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l90oDEErNEJuUz2JM736PZtQvVILLA9E/YPjjnlazoU=;
 b=YNx/jDcaiWPCcHhxnck8GC5pmWFPMm8hfpzh9DyLiD6S5At2X/cGlqhEm6ZVstm3VIhYz9Et7iipbB9oeMGTiTbUu6fWInrcMxu435NdiDho+82HFqKWLcVQS2ZpT/BdwkQnXT/kzp9shiXzRqx+6BTXLTrP5hmZgRMBUcTSMbJ/skDY3wQ7HqQF7GcG+v32q7IB5c35RKmwecY5dJijdjtbpRqmwNgCynvew06NPXokp8XTb6U+wHmciQXCAwJtwrtowps9fZ9t8UBZ1sB3qix7KLkOWzymzVqZ8cLvmXvgrMIRswSr5SSButQyvv6I2V6tpCILInNYysq695MMlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l90oDEErNEJuUz2JM736PZtQvVILLA9E/YPjjnlazoU=;
 b=c8LjHTjKNwiD/L3E+FB61mUIAq2BkL8VTqjojua65iY+zJ6K1+Uxoq5SOajSd92c9TwAtjjFVHq03L/YPZ4T20vTbT0XYDoY2AQfAHnowNS3j4kpY4NGA1loE9PWY2F78nTd5WiROajYs/k2KGMhxvcZe2zqIminqM6+GvsIZ7o=
Received: from CY4PR10MB1989.namprd10.prod.outlook.com (2603:10b6:903:11a::12)
 by CY4PR10MB1832.namprd10.prod.outlook.com (2603:10b6:903:123::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16; Mon, 12 Apr
 2021 18:32:50 +0000
Received: from CY4PR10MB1989.namprd10.prod.outlook.com
 ([fe80::ad28:97d2:76cf:3fa5]) by CY4PR10MB1989.namprd10.prod.outlook.com
 ([fe80::ad28:97d2:76cf:3fa5%11]) with mapi id 15.20.4020.022; Mon, 12 Apr
 2021 18:32:50 +0000
From:   Haakon Bugge <haakon.bugge@oracle.com>
To:     David Laight <David.Laight@aculab.com>
CC:     Tom Talpey <tom@talpey.com>,
        Chuck Lever III <chuck.lever@oracle.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Adit Ranadive <aditr@vmware.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Ariel Elior <aelior@marvell.com>,
        Avihai Horon <avihaih@nvidia.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Devesh Sharma <devesh.sharma@broadcom.com>,
        Faisal Latif <faisal.latif@intel.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Bruce Fields <bfields@fieldses.org>, Jens Axboe <axboe@fb.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Keith Busch <kbusch@kernel.org>, Lijun Ou <oulijun@huawei.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        OFED mailing list <linux-rdma@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        Max Gurtovoy <maxg@mellanox.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        "Md. Haris Iqbal" <haris.iqbal@ionos.com>,
        Michael Guralnik <michaelgur@nvidia.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>,
        Linux-Net <netdev@vger.kernel.org>,
        Potnuri Bharat Teja <bharat@chelsio.com>,
        "rds-devel@oss.oracle.com" <rds-devel@oss.oracle.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
        Steve French <sfrench@samba.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        VMware PV-Drivers <pv-drivers@vmware.com>,
        Weihang Li <liweihang@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>
Subject: Re: [PATCH rdma-next 00/10] Enable relaxed ordering for ULPs
Thread-Topic: [PATCH rdma-next 00/10] Enable relaxed ordering for ULPs
Thread-Index: AQHXKdv4VwXly9yLzUySAd7Scm0t5aql7vqAgABr9YCAADwJgIAAyzgAgATit4CAAAVvAIAADRqAgAAPN4CAABbxgIABSgQAgAN5JQA=
Date:   Mon, 12 Apr 2021 18:32:49 +0000
Message-ID: <880A23A2-F078-42CF-BEE2-30666BCB9B5D@oracle.com>
References: <20210405052404.213889-1-leon@kernel.org>
 <20210405134115.GA22346@lst.de> <20210405200739.GB7405@nvidia.com>
 <C2924F03-11C5-4839-A4F3-36872194EEA8@oracle.com>
 <20210406114952.GH7405@nvidia.com>
 <aeb7334b-edc0-78c2-4adb-92d4a994210d@talpey.com>
 <8A5E83DF-5C08-49CE-8EE3-08DC63135735@oracle.com>
 <4b02d1b2-be0e-0d1d-7ac3-38d32e44e77e@talpey.com>
 <1FA38618-E245-4C53-BF49-6688CA93C660@oracle.com>
 <7b9e7d9c-13d7-0d18-23b4-0d94409c7741@talpey.com>
 <f71b24433f4540f0a13133111a59dab8@AcuMS.aculab.com>
In-Reply-To: <f71b24433f4540f0a13133111a59dab8@AcuMS.aculab.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.60.0.2.21)
authentication-results: aculab.com; dkim=none (message not signed)
 header.d=none;aculab.com; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [51.175.204.144]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b57a4837-25e0-4789-5080-08d8fde16077
x-ms-traffictypediagnostic: CY4PR10MB1832:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR10MB1832C7C64C714A917CD60958FD709@CY4PR10MB1832.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CP6CGNff3W6FcHEy9e4M7EGaHs9IOODs+up7plg9iXs89IVKbt9QhXSGzneeti5dE4mSmgrM6Jaz0nvC9bISZhLAkWr0YRMhv24nzQJHZBQZ+vj7eQicMmwPnXM8mReu+9nEw602Xc9DH0eDUBgs7RuIVXISg72zGgDbTKjGwjQShvyxBFvk1NWaYZ1p8LwC7ZL7Xm9qo6KWfLd4RBzFDjLvhp8s8yzmVR8hOKPs1aSOU/preVV4vsq/reT6SoKoRVTBZz8TQ8Avy+cFsiCi0iFTvrZhZ3stcy6KoQkBEJaPWAf7e3CFT7IwWSaxFcoiNiwDaf/NAGo6m+SrLECXBRuofh0t8DFqCao77uFi+ZJBk6zbVJSB84skuv68Qgf4Rc3JJQ74Te8MsVKqYoGBHd8VPtU9SZaL3rBRgYRPe/esNAu3zLuVSl8bZvc9vZvdho7zcHJ3TUx7ONhd9946GV4JylI0Its0mhg3kpFquN1vW74XFzC3bjkEHWLkmAZbvPK4V+RqxmCbR7SzklluvQk7sBmyCn3iwbE89u4BoEWHdEiEDp0thnVgetTdbUQSCnxntJ1aMnUhO7hIcA9H2zt8EaclDmXTllPImEq/Er0oLSeabuZhG93Qjs+BkPEG3JWZa9jtjurEx8QV14U+uKcnkR4IIoMx5QG2GWe/lBU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR10MB1989.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(346002)(136003)(366004)(39860400002)(38100700002)(33656002)(44832011)(2616005)(7406005)(36756003)(8936002)(76116006)(91956017)(7366002)(6506007)(66446008)(64756008)(66476007)(66946007)(6512007)(53546011)(478600001)(66556008)(5660300002)(71200400001)(26005)(2906002)(186003)(66574015)(54906003)(316002)(83380400001)(86362001)(4326008)(6486002)(8676002)(7416002)(6916009)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?N3NxeENmS3Q1YnMweWFFR0t0MEFWalN1eXRSemFBSWZWOStFcDV0UkMzZUpX?=
 =?utf-8?B?UURjZHFpSFQ2N28xNmxDYW53aCtad01WQ2VLRnhpSlZpcE80bXo1emZtOEhX?=
 =?utf-8?B?ZDYwWWxneTFiWHdScmFvSUpHMnJodHF4S3orVURydFQ1dkUxQUdWYUMyNWRT?=
 =?utf-8?B?K0htc2dzV3E3M21uM2FuSzNkazFtQkZaNHJkbzNXNDlpN1FkdHc2bFU1bXc3?=
 =?utf-8?B?bjlGeEpwSzR1M3l6ZWtCZHlBTXZmb1JKVmhtR1JvOGVLU3AwSUcrTzNjaC9t?=
 =?utf-8?B?ckR1K3lGOCtjWmV3bnB6d3FhVGVhWW5VNzI0YVdFK3VnNVUxR2lPVkQ3ZTl5?=
 =?utf-8?B?Vkk5MjVMV1VEY001Z0pNZHp1Qno0dHdpVFZPcmhQM1BZdTdYdFRCN1UvaUZJ?=
 =?utf-8?B?cXdPcVpnSUNDOXdlUTFOSUZKRlNoYkY1WENMZ01JaTRpWHVLSXNUYjhXSDFn?=
 =?utf-8?B?TitRaiswOWhiYWtIRXdneGVKQ1QyVTl2Nmx4N1k4c1NWTVNIby9nTmpVMHBN?=
 =?utf-8?B?Z01IMGorYnpWaHpySDN6MWRlZnZzWFZWQkd1eHZsN2phM0pBdDgwTTcwNXRs?=
 =?utf-8?B?TFVYQzZxbHlPYmtZNXI2ZXlxMS9tZThJV1FBZmI0bFAvckNZZlBraUJWU1NN?=
 =?utf-8?B?Z0I3eC8zVUZpVmNLUUNWcGNFMzBTd0RkVzY2Q2RoWGNTeGFpRFVHWFRoaXVs?=
 =?utf-8?B?NHZSSnMzKzhhbGx5c0FZWlpkazRJRnRjTVFlQ20rbFN4WSs2allJdVhGVk94?=
 =?utf-8?B?L3p5VEg5dXVTL3pwYmJnUTJKSHlBQk9tWngzRVVyNWpmVkoyWUtYV2RHcjRq?=
 =?utf-8?B?M0pqNWdCZUJPejhFMnpIN1dYbEd3azNydWxSMlVnQlZCNnNGQkRUYW9DVDAv?=
 =?utf-8?B?RmNpcmNORDJTT0tCeW9CZFdvWDRzVmppNHVmTHdEUFIrNzhKdHU5Z3o2Umdx?=
 =?utf-8?B?OEVKNWw4dmhGV0NZakdadGM2d25MbUprZkdNbXgrYzlTeWtsRDdtMzRvVzdl?=
 =?utf-8?B?RHo0WFVuRHdTVys4cFc3SXJJZUgycit3aEk1SGJqN3FCTWFPNEF2ZTJKcUFR?=
 =?utf-8?B?azdSTzByc1U2VGRkbnVoMlVRNW9xMnBxVzRsSGs2a2w5Um5iM0k5QjlpZkx5?=
 =?utf-8?B?K25hUnRGc0tET3ZnMHhJUDJWS29ncXNRTlZMTExJVVI4QWduNm1xRmFCb0VP?=
 =?utf-8?B?SjRpajVsT2xRNTFvSDdKTnduUDYrZ0NYTTA2UWNYQTZSNDE3bTBNd0RzdEZT?=
 =?utf-8?B?MjR4TndpQXMyVC9ScVhlWXQyZ2VJbExmWWJrUTY0cWJlcXRaUFkvcEFtbmZv?=
 =?utf-8?B?Yk1mZGVwYzhsejNmcG53NDI5dE1Cb2RRRmoxM2xzYjZDNWlrUDM0bi9OalFv?=
 =?utf-8?B?dHFobFl6ckRQMzhMNmNHYnJLc2dBdTdvdjNqKzRaWEEyVnNQMjQxZCt0ME1Q?=
 =?utf-8?B?K2lSaHFMOVM5NUlMQnpQSVFuWHEwSmg0eDJONHdEbWdtRXBxTkM4bU9SRG9E?=
 =?utf-8?B?YmV0c0NiWkIxOTdzODJpeFpSUzY3cmFRbEs1b0w1QzV1SExnbHlhY2lNNWFl?=
 =?utf-8?B?cG1xMXhXN3hGbnhZOUlKSTl5UHhmSnZTMlphWmw0M05jN1lGUkFvaEZGR2xr?=
 =?utf-8?B?djFUdVYxSDROeFZINGY1OWxQSnNTY1hGTHNKbHZZTSt2VFNBSzMwVStzRFpE?=
 =?utf-8?B?SzdLbmU0dFhFVnFEc212cWJFN1RuclBCMkVidXJHcGFjRGtjMDZ6U1VnVkpu?=
 =?utf-8?B?OEV6K1ZwQXJoaFg4YWRTaXl2OXVxc1pQMSsxY3NxUlFUOHhqekdmTGlEdjk3?=
 =?utf-8?B?MVM4K3c1bHVjVE5HL3JQdz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E52A7077E701AE4A964D7A8BDCF2A8BC@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR10MB1989.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b57a4837-25e0-4789-5080-08d8fde16077
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2021 18:32:49.8577
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JLwYwdFYQ/X5f/xt9n6WFUBlkw7pPD3IiUanH4emnV3Jdzwd+nauEYPyX3LMxFy6iTv17AElG0OaGn6j0Eyq+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1832
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9952 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 malwarescore=0 adultscore=0 bulkscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104120117
X-Proofpoint-GUID: RLYABIgkHxwBP7YpiFiZsDbG6k3pOEzq
X-Proofpoint-ORIG-GUID: RLYABIgkHxwBP7YpiFiZsDbG6k3pOEzq
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9952 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=0 malwarescore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104120117
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gT24gMTAgQXByIDIwMjEsIGF0IDE1OjMwLCBEYXZpZCBMYWlnaHQgPERhdmlkLkxhaWdo
dEBhY3VsYWIuY29tPiB3cm90ZToNCj4gDQo+IEZyb206IFRvbSBUYWxwZXkNCj4+IFNlbnQ6IDA5
IEFwcmlsIDIwMjEgMTg6NDkNCj4+IE9uIDQvOS8yMDIxIDEyOjI3IFBNLCBIYWFrb24gQnVnZ2Ug
d3JvdGU6DQo+Pj4gDQo+Pj4gDQo+Pj4+IE9uIDkgQXByIDIwMjEsIGF0IDE3OjMyLCBUb20gVGFs
cGV5IDx0b21AdGFscGV5LmNvbT4gd3JvdGU6DQo+Pj4+IA0KPj4+PiBPbiA0LzkvMjAyMSAxMDo0
NSBBTSwgQ2h1Y2sgTGV2ZXIgSUlJIHdyb3RlOg0KPj4+Pj4+IE9uIEFwciA5LCAyMDIxLCBhdCAx
MDoyNiBBTSwgVG9tIFRhbHBleSA8dG9tQHRhbHBleS5jb20+IHdyb3RlOg0KPj4+Pj4+IA0KPj4+
Pj4+IE9uIDQvNi8yMDIxIDc6NDkgQU0sIEphc29uIEd1bnRob3JwZSB3cm90ZToNCj4+Pj4+Pj4g
T24gTW9uLCBBcHIgMDUsIDIwMjEgYXQgMTE6NDI6MzFQTSArMDAwMCwgQ2h1Y2sgTGV2ZXIgSUlJ
IHdyb3RlOg0KPj4+Pj4+PiANCj4+Pj4+Pj4+IFdlIG5lZWQgdG8gZ2V0IGEgYmV0dGVyIGlkZWEg
d2hhdCBjb3JyZWN0bmVzcyB0ZXN0aW5nIGhhcyBiZWVuIGRvbmUsDQo+Pj4+Pj4+PiBhbmQgd2hl
dGhlciBwb3NpdGl2ZSBjb3JyZWN0bmVzcyB0ZXN0aW5nIHJlc3VsdHMgY2FuIGJlIHJlcGxpY2F0
ZWQNCj4+Pj4+Pj4+IG9uIGEgdmFyaWV0eSBvZiBwbGF0Zm9ybXMuDQo+Pj4+Pj4+IFJPIGhhcyBi
ZWVuIHJvbGxpbmcgb3V0IHNsb3dseSBvbiBtbHg1IG92ZXIgYSBmZXcgeWVhcnMgYW5kIHN0b3Jh
Z2UNCj4+Pj4+Pj4gVUxQcyBhcmUgdGhlIGxhc3QgdG8gY2hhbmdlLiBlZyB0aGUgbWx4NSBldGhl
cm5ldCBkcml2ZXIgaGFzIGhhZCBSTw0KPj4+Pj4+PiB0dXJuZWQgb24gZm9yIGEgbG9uZyB0aW1l
LCB1c2Vyc3BhY2UgSFBDIGFwcGxpY2F0aW9ucyBoYXZlIGJlZW4gdXNpbmcNCj4+Pj4+Pj4gaXQg
Zm9yIGEgd2hpbGUgbm93IHRvby4NCj4+Pj4+PiANCj4+Pj4+PiBJJ2QgbG92ZSB0byBzZWUgUk8g
YmUgdXNlZCBtb3JlLCBpdCB3YXMgYWx3YXlzIHNvbWV0aGluZyB0aGUgUkRNQQ0KPj4+Pj4+IHNw
ZWNzIHN1cHBvcnRlZCBhbmQgY2FyZWZ1bGx5IGFyY2hpdGVjdGVkIGZvci4gTXkgb25seSBjb25j
ZXJuIGlzDQo+Pj4+Pj4gdGhhdCBpdCdzIGRpZmZpY3VsdCB0byBnZXQgcmlnaHQsIGVzcGVjaWFs
bHkgd2hlbiB0aGUgcGxhdGZvcm1zDQo+Pj4+Pj4gaGF2ZSBiZWVuIHJ1bm5pbmcgc3RyaWN0bHkt
b3JkZXJlZCBmb3Igc28gbG9uZy4gVGhlIFVMUHMgbmVlZA0KPj4+Pj4+IHRlc3RpbmcsIGFuZCBh
IGxvdCBvZiBpdC4NCj4+Pj4+PiANCj4+Pj4+Pj4gV2Uga25vdyB0aGVyZSBhcmUgcGxhdGZvcm1z
IHdpdGggYnJva2VuIFJPIGltcGxlbWVudGF0aW9ucyAobGlrZQ0KPj4+Pj4+PiBIYXN3ZWxsKSBi
dXQgdGhlIGtlcm5lbCBpcyBzdXBwb3NlZCB0byBnbG9iYWxseSB0dXJuIG9mZiBSTyBvbiBhbGwN
Cj4+Pj4+Pj4gdGhvc2UgY2FzZXMuIEknZCBiZSBhIGJpdCBzdXJwcmlzZWQgaWYgd2UgZGlzY292
ZXIgYW55IG1vcmUgZnJvbSB0aGlzDQo+Pj4+Pj4+IHNlcmllcy4NCj4+Pj4+Pj4gT24gdGhlIG90
aGVyIGhhbmQgdGhlcmUgYXJlIHBsYXRmb3JtcyB0aGF0IGdldCBodWdlIHNwZWVkIHVwcyBmcm9t
DQo+Pj4+Pj4+IHR1cm5pbmcgdGhpcyBvbiwgQU1EIGlzIG9uZSBleGFtcGxlLCB0aGVyZSBhcmUg
YSBidW5jaCBpbiB0aGUgQVJNDQo+Pj4+Pj4+IHdvcmxkIHRvby4NCj4+Pj4+PiANCj4+Pj4+PiBN
eSBiZWxpZWYgaXMgdGhhdCB0aGUgYmlnZ2VzdCByaXNrIGlzIGZyb20gc2l0dWF0aW9ucyB3aGVy
ZSBjb21wbGV0aW9ucw0KPj4+Pj4+IGFyZSBiYXRjaGVkLCBhbmQgdGhlcmVmb3JlIHBvbGxpbmcg
aXMgdXNlZCB0byBkZXRlY3QgdGhlbSB3aXRob3V0DQo+Pj4+Pj4gaW50ZXJydXB0cyAod2hpY2gg
ZXhwbGljaXRseSkuIFRoZSBSTyBwaXBlbGluZSB3aWxsIGNvbXBsZXRlbHkgcmVvcmRlcg0KPj4+
Pj4+IERNQSB3cml0ZXMsIGFuZCBjb25zdW1lcnMgd2hpY2ggaW5mZXIgb3JkZXJpbmcgZnJvbSBt
ZW1vcnkgY29udGVudHMgbWF5DQo+Pj4+Pj4gYnJlYWsuIFRoaXMgY2FuIGV2ZW4gYXBwbHkgd2l0
aGluIHRoZSBwcm92aWRlciBjb2RlLCB3aGljaCBtYXkgYXR0ZW1wdA0KPj4+Pj4+IHRvIHBvbGwg
V1IgYW5kIENRIHN0cnVjdHVyZXMsIGFuZCBiZSB0cmlwcGVkIHVwLg0KPj4+Pj4gWW91IGFyZSBy
ZWZlcnJpbmcgc3BlY2lmaWNhbGx5IHRvIFJQQy9SRE1BIGRlcGVuZGluZyBvbiBSZWNlaXZlDQo+
Pj4+PiBjb21wbGV0aW9ucyB0byBndWFyYW50ZWUgdGhhdCBwcmV2aW91cyBSRE1BIFdyaXRlcyBo
YXZlIGJlZW4NCj4+Pj4+IHJldGlyZWQ/IE9yIGlzIHRoZXJlIGEgcGFydGljdWxhciBpbXBsZW1l
bnRhdGlvbiBwcmFjdGljZSBpbg0KPj4+Pj4gdGhlIExpbnV4IFJQQy9SRE1BIGNvZGUgdGhhdCB3
b3JyaWVzIHlvdT8NCj4+Pj4gDQo+Pj4+IE5vdGhpbmcgaW4gdGhlIFJQQy9SRE1BIGNvZGUsIHdo
aWNoIGlzIElNTyBjb3JyZWN0LiBUaGUgd29ycnksIHdoaWNoDQo+Pj4+IGlzIGhvcGVmdWxseSB1
bmZvdW5kZWQsIGlzIHRoYXQgdGhlIFJPIHBpcGVsaW5lIG1pZ2h0IG5vdCBoYXZlIGZsdXNoZWQN
Cj4+Pj4gd2hlbiBhIGNvbXBsZXRpb24gaXMgcG9zdGVkICphZnRlciogcG9zdGluZyBhbiBpbnRl
cnJ1cHQuDQo+Pj4+IA0KPj4+PiBTb21ldGhpbmcgbGlrZSB0aGlzLi4uDQo+Pj4+IA0KPj4+PiBS
RE1BIFdyaXRlIGFycml2ZXMNCj4+Pj4gCVBDSWUgUk8gV3JpdGUgZm9yIGRhdGENCj4+Pj4gCVBD
SWUgUk8gV3JpdGUgZm9yIGRhdGENCj4+Pj4gCS4uLg0KPj4+PiBSRE1BIFdyaXRlIGFycml2ZXMN
Cj4+Pj4gCVBDSWUgUk8gV3JpdGUgZm9yIGRhdGENCj4+Pj4gCS4uLg0KPj4+PiBSRE1BIFNlbmQg
YXJyaXZlcw0KPj4+PiAJUENJZSBSTyBXcml0ZSBmb3IgcmVjZWl2ZSBkYXRhDQo+Pj4+IAlQQ0ll
IFJPIFdyaXRlIGZvciByZWNlaXZlIGRlc2NyaXB0b3INCj4+PiANCj4+PiBEbyB5b3UgbWVhbiB0
aGUgV3JpdGUgb2YgdGhlIENRRT8gSXQgaGFzIHRvIGJlIFN0cm9uZ2x5IE9yZGVyZWQgZm9yIGEg
Y29ycmVjdCBpbXBsZW1lbnRhdGlvbi4gVGhlbg0KPj4gaXQgd2lsbCBzaHVyZSBwcmlvciB3cml0
dGVuIFJPIGRhdGUgaGFzIGdsb2JhbCB2aXNpYmlsaXR5IHdoZW4gdGhlIENRRSBjYW4gYmUgb2Jz
ZXJ2ZWQuDQo+PiANCj4+IEkgd2Fzbid0IGF3YXJlIHRoYXQgYSBzdHJvbmdseS1vcmRlcmVkIFBD
SWUgV3JpdGUgd2lsbCBlbnN1cmUgdGhhdA0KPj4gcHJpb3IgcmVsYXhlZC1vcmRlcmVkIHdyaXRl
cyB3ZW50IGZpcnN0LiBJZiB0aGF0J3MgdGhlIGNhc2UsIEknbQ0KPj4gZmluZSB3aXRoIGl0IC0g
YXMgbG9uZyBhcyB0aGUgcHJvdmlkZXJzIGFyZSBjb3JyZWN0bHkgY29kZWQhIQ0KDQpUaGUgUENJ
ZSBzcGVjIChUYWJsZSBPcmRlcmluZyBSdWxlcyBTdW1tYXJ5KSBpcyBxdWl0ZSBjbGVhciBoZXJl
IChBIFBvc3RlZCByZXF1ZXN0IGlzIE1lbW9yeSBXcml0ZSBSZXF1ZXN0IGluIHRoaXMgY29udGV4
dCk6DQoNCglBIFBvc3RlZCBSZXF1ZXN0IG11c3Qgbm90IHBhc3MgYW5vdGhlciBQb3N0ZWQgUmVx
dWVzdCB1bmxlc3MgQTJiIGFwcGxpZXMuDQoNCglBMmI6IEEgUG9zdGVkIFJlcXVlc3Qgd2l0aCBS
TyBTZXQgaXMgcGVybWl0dGVkIHRvIHBhc3MgYW5vdGhlciBQb3N0ZWQgUmVxdWVzdC4NCg0KDQpU
aHhzLCBIw6Vrb24NCg0KPiANCj4gSSByZW1lbWJlciB0cnlpbmcgdG8gcmVhZCB0aGUgcmVsZXZh
bnQgc2VjdGlvbiBvZiB0aGUgUENJZSBzcGVjLg0KPiAoUG9zc2libHkgaW4gYSBib29rIHRoYXQg
d2FzIHRyeWluZyB0byBtYWtlIGl0IGVhc2llciB0byB1bmRlcnN0YW5kISkNCj4gSXQgaXMgYWJv
dXQgYXMgY2xlYXIgYXMgbXVkLg0KPiANCj4gSSBwcmVzdW1lIHRoaXMgaXMgYWxsIGFib3V0IGFs
bG93aW5nIFBDSWUgdGFyZ2V0cyAoZWcgZXRoZXJuZXQgY2FyZHMpDQo+IHRvIHVzZSByZWxheGVk
IG9yZGVyaW5nIG9uIHdyaXRlIHJlcXVlc3RzIHRvIGhvc3QgbWVtb3J5Lg0KPiBBbmQgdGhhdCBz
dWNoIHdyaXRlcyBjYW4gYmUgY29tcGxldGVkIG91dCBvZiBvcmRlcj8NCj4gDQo+IEl0IGlzbid0
IGVudGlyZWx5IGNsZWFyIHRoYXQgeW91IGFyZW4ndCB0YWxraW5nIG9mIGxldHRpbmcgdGhlDQo+
IGNwdSBkbyAncmVsYXhlZCBvcmRlcicgd3JpdGVzIHRvIFBDSWUgdGFyZ2V0cyENCj4gDQo+IEZv
ciBhIHR5cGljYWwgZXRoZXJuZXQgZHJpdmVyIHRoZSByZWNlaXZlIGludGVycnVwdCBqdXN0IG1l
YW5zDQo+ICdnbyBhbmQgbG9vayBhdCB0aGUgcmVjZWl2ZSBkZXNjcmlwdG9yIHJpbmcnLg0KPiBT
byB0aGVyZSBpcyBhbiBhYnNvbHV0ZSByZXF1aXJlbWVudCB0aGF0IHRoZSB3cml0ZXMgZm9yIGRh
dGENCj4gYnVmZmVyIGNvbXBsZXRlIGJlZm9yZSB0aGUgd3JpdGUgdG8gdGhlIHJlY2VpdmUgZGVz
Y3JpcHRvci4NCj4gVGhlcmUgaXMgbm8gcmVxdWlyZW1lbnQgZm9yIHRoZSBpbnRlcnJ1cHQgKHJl
cXVlc3RlZCBhZnRlciB0aGUNCj4gZGVzY3JpcHRvciB3cml0ZSkgdG8gaGF2ZSBiZWVuIHNlZW4g
YnkgdGhlIGNwdS4NCj4gDQo+IFF1aXRlIG9mdGVuIHRoZSBkcml2ZXIgd2lsbCBmaW5kIHRoZSAn
cmVjZWl2ZSBjb21wbGV0ZScNCj4gZGVzY3JpcHRvciB3aGVuIHByb2Nlc3NpbmcgZnJhbWVzIGZy
b20gYW4gZWFybGllciBpbnRlcnJ1cHQNCj4gKGFuZCBub3RoaW5nIHRvIGRvIGluIHJlc3BvbnNl
IHRvIHRoZSBpbnRlcnJ1cHQgaXRzZWxmKS4NCj4gDQo+IFNvIHRoZSB3cml0ZSB0byB0aGUgcmVj
ZWl2ZSBkZXNjcmlwdG9yIHdvdWxkIGhhdmUgdG8gaGF2ZSBSTyBjbGVhcg0KPiB0byBlbnN1cmUg
dGhhdCBhbGwgdGhlIGJ1ZmZlciB3cml0ZXMgY29tcGxldGUgZmlyc3QuDQo+IA0KPiAoVGhlIGZ1
cnRoZXN0IEkndmUgZ290IGludG8gUENJZSBpbnRlcm5hbHMgd2FzIGZpeGluZyB0aGUgYnVnDQo+
IGluIHNvbWUgdmVuZG9yLXN1cHBsaWVkIEZQR0EgbG9naWMgdGhhdCBmYWlsZWQgdG8gY29ycmVj
dGx5DQo+IGhhbmRsZSBtdWx0aXBsZSBkYXRhIFRMUCByZXNwb25zZXMgdG8gYSBzaW5nbGUgcmVh
ZCBUTFAuDQo+IEZvcnR1bmF0ZWx5IGl0IHdhc24ndCBpbiB0aGUgaGFyZC1JUCBiaXQuKQ0KPiAN
Cj4gCURhdmlkDQo+IA0KPiAtDQo+IFJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxl
eSBSb2FkLCBNb3VudCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KPiBSZWdpc3Ry
YXRpb24gTm86IDEzOTczODYgKFdhbGVzKQ0KDQo=
