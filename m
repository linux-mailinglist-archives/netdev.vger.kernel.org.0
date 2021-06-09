Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4682B3A13F5
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 14:14:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239731AbhFIMP7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 08:15:59 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:7154 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231610AbhFIMP5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 08:15:57 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 159CAkhs032325;
        Wed, 9 Jun 2021 05:13:45 -0700
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-0016f401.pphosted.com with ESMTP id 392uesgft7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Jun 2021 05:13:45 -0700
Received: from m0045849.ppops.net (m0045849.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 159CDiQu005393;
        Wed, 9 Jun 2021 05:13:44 -0700
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by mx0a-0016f401.pphosted.com with ESMTP id 392uesgft4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Jun 2021 05:13:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NCxvcOlIgQ6CStGKIf7ozy/2RZF5pOm59tMvXn2Q9e0HP4LuqhLS9aHubQO/83fFTxk1vOPb13zAAC5O7oEWgGNw+WxgCmNTUu8ch0RXu3tzvLMldkZquO6J0FypzOn/+6rmnqPvUFh8FANmnUuX0IY661eAny3B1uW4PsOWnYm1xTz2TycpSOiw6gy6WdvXcbH0yrxM9HKo1jjNjoj04fhFB4Kur/+D00Xp6FBPVwP6eeszRIsEE7b16w8VyjE7W3RE+S/pGvtlpXCkeNkPjHd1j2DzOZJDY1EDNzJ9evvscRGCIl4/fpusGFDtKAK/S2IcdEZCc1KKTbpsXNC0sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zgb1Xy5eSseIkUqaPlIDjB8QkfS1YFeCpCRvL6NaI3k=;
 b=DYBuSaZRujh9lL9W/e6EtkWHwlLpF7cEm34LihRRP2bamqpm83yzh+X2BExPXTfgRSTkhFI63qIb49FoL9yo7nDKlBrWR/3yr9I4e+AjpwacQsiSAeO1WtsdYib4RUkfue2HnlHUfALnR+QWMxIQi3CO18W6aHVRpbxzVMvMR9YjPQBI6nr2vM4qGD4moASzkFHMf51+3LXE9ApC/X8COnjENb4y+GqFi3lZzMyJB65HB75ZZ4Tva7iakCYtO0KvItMZSI9RAQqCfLHX4zOGaFPK9KPhPTzX2NVjGLkS68dP0B/eC84Y6nu1boua8gxdhWPUYZWilVE/sn+gx/TRkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zgb1Xy5eSseIkUqaPlIDjB8QkfS1YFeCpCRvL6NaI3k=;
 b=oc5mqm0imzb77Rmthz4T2k7ZtE74cFqe2SCLo0aXiewSogc37L28hgTP52Cb2f2n7nIvDiWdGo28ST+ynfhyooJ09AZrvrSt1Hl2qaBO/bbArgMZUy0JW4xmcFG6oyioGqG2QXFu4vjADVa4EvljiCY7mDNX0CKSc9Omxy48m18=
Received: from SJ0PR18MB3882.namprd18.prod.outlook.com (2603:10b6:a03:2c8::13)
 by BYAPR18MB2613.namprd18.prod.outlook.com (2603:10b6:a03:135::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20; Wed, 9 Jun
 2021 12:13:41 +0000
Received: from SJ0PR18MB3882.namprd18.prod.outlook.com
 ([fe80::419a:6920:f49:3ece]) by SJ0PR18MB3882.namprd18.prod.outlook.com
 ([fe80::419a:6920:f49:3ece%8]) with mapi id 15.20.4195.030; Wed, 9 Jun 2021
 12:13:41 +0000
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
        "malin1024@gmail.com" <malin1024@gmail.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Prabhakar Kushwaha <pkushwaha@marvell.com>
Subject: RE: please drop the nvme code from net-next
Thread-Topic: please drop the nvme code from net-next
Thread-Index: AddcnzAdEpx+aAPyQ+iYPM8zs/0YYQAfkM3A
Date:   Wed, 9 Jun 2021 12:13:41 +0000
Message-ID: <SJ0PR18MB3882585CE0FE3340D37A8399CC369@SJ0PR18MB3882.namprd18.prod.outlook.com>
References: <SJ0PR18MB3882C20793EA35A3E8DAE300CC379@SJ0PR18MB3882.namprd18.prod.outlook.com>
In-Reply-To: <SJ0PR18MB3882C20793EA35A3E8DAE300CC379@SJ0PR18MB3882.namprd18.prod.outlook.com>
Accept-Language: he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [79.181.162.86]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a753df2b-00a6-431b-eb77-08d92b400540
x-ms-traffictypediagnostic: BYAPR18MB2613:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR18MB2613BCF0719E1BC2C2F82D9FCC369@BYAPR18MB2613.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qKFvZ7H0LwZmvgOLGUrMbYQFUt9Q0EyNnQjZpUmHg8bN7EAoJNHXN86/3dOAYSGk1+RYpUIPSkABhDA+mTVQwcxFOy/nvdxNedGHN5imMCjxiudqZFzyIkQYoDutuWlY/96khkFtOFfc0qALyabyP20Oo/JuHhNhi2fj0fxprAMuMNRDz05MIQOM8Kq0BB+2cf2bG4A/yqQj/pc16mJvMGVRZaGAuoxH/4Fo4EaFRROD10yLkz5ToFE4vuLRuxoykPJp/OKwZyNThUrdghE5yFR5qPCzknrm7RdfSFxpSYaEV78llIiLyTFnuhtb+tuL2NwijGJ3jGYvgs8iJqGzWYje8YqJ9oLiqGaWC5NxlmLlIcWF5BHDv8Fps1zbe5n68+X2EOiGI+LgZCoF8s7iEA5n5TKvtmpP3G/9Y+7mjXd+FW0hudZzKPGZfgnjQuFWqTeQfHUdTQfD1IVjkJxii1aFCq68RI/NHzL6kPrt1NcuiNcz9imQ541n4cYp7i7tjSoPZco1qXm/MnkWub+QjigsshG9KAtQ1+GCiRCNWSdv3zGZy6OF3LuEcFFI0rgdti0DhJFC7cCWinPkCe5v5qzUhDvnk44udBvxQOrbYmjaTFYh5goslHyBznHEbg18GLo+Tgz5u07NyIpJg4kTKwLT7daYIrM2X6yAv7f+e0hSoeqS4sgzPchTCLP3TU6aqUERp+CGzTgPpOKvUSgKELVmMaEZb89V5MXFNSv9lwM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR18MB3882.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(366004)(376002)(136003)(346002)(6506007)(54906003)(8676002)(4326008)(110136005)(8936002)(107886003)(478600001)(33656002)(186003)(316002)(26005)(55016002)(5660300002)(71200400001)(7416002)(9686003)(122000001)(38100700002)(66946007)(86362001)(52536014)(66556008)(76116006)(66476007)(66446008)(64756008)(2906002)(7696005)(4744005)(966005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?A/QKCij+zrz0k1Iehhz8nUT0eDRAsJGe2dYemW8ey48G2jotPcnQHA/zh7zF?=
 =?us-ascii?Q?ByioS6JCFUZR5rnlaz2jMwn7cAre0OJUKx2U2zOxU0ShD+BlFxdznNJemux0?=
 =?us-ascii?Q?jfJ3S+53qoEg5KGWeLXqz0KT0ID1UB0Xs+E3IBvcgBUZlxYsiRgkXP0KgYZq?=
 =?us-ascii?Q?uXBoWhYhW53wzQKpCGILKvKQZR+wMRkWnlIlhJX6wgu4uF80aZ8X7yj7vKZN?=
 =?us-ascii?Q?m/ig464FLbqqCOpe9Cpj+731nTZ0ZXs5OgEY/MzfbJGhfZAb5lyRIc8DP0LU?=
 =?us-ascii?Q?4YQn/hAYHv1CB1kvJB5Uu+DgRxbHCZSqbQwYddOfKj5LAAeS4EpcYTo/se+O?=
 =?us-ascii?Q?caCul2S1ZGfUHOKMro/TaS7e7GEHG3HaW4lBhWJoU7GAo9e+6tNYSgWZ2Zfr?=
 =?us-ascii?Q?+rbnrFj023qpJqIfP1VTG3xvx2fpA+n/QxTgvZ7XAWveQDD9kUsJDPFiBLcC?=
 =?us-ascii?Q?SsXvsTBl0IdWUSiecOqOIqPJ8zOV2O+a8K8bNTCOeRGvjctCI5S/gYKoNUZx?=
 =?us-ascii?Q?VMBZun5IHxoVRUHJXkH8GUNUHIR4S4wkouvifkfzrz9r+m/3kRUSyMYKT621?=
 =?us-ascii?Q?VDhv64IxInXs6TCy+Vq8X49ITqCTlcMrEPiOtXA5002CZ+j+tSiIe3XjTkta?=
 =?us-ascii?Q?MRMI1unTUY0s7eeCJeEEEpQXiooii0hSG0wtHpvodbr6zmW8C527fJllxoKx?=
 =?us-ascii?Q?z9yhhfDSjWrMTLObhYtreCIxYxH+fOYJtZJ9nzOPH1LdAzd5ga/e/FkUX2r2?=
 =?us-ascii?Q?dUTgRTsS8FYREn5O3Y/KvZCm/r5koNllY2GysLRFSnhNYb2upUzaszin4o7Q?=
 =?us-ascii?Q?ibDaIuuyZUEVa1+2pvRfVlKynyjn3N+auwXne0A67PcYX1eHLqbVbLyVRagr?=
 =?us-ascii?Q?IcZYplr0ocpc9Rs/jdtJOYgLNctB92mRPOvqkAB5xvcBPMPCqDSJdi3MXWtv?=
 =?us-ascii?Q?L8r45JFV8bat02C2jEVjq1BvY5xdCFSwgUZbHvSV63IwOJ0M50d3vqUm1KO2?=
 =?us-ascii?Q?/3lUqNJg1tq9pvukpgmuNz6rWCEYoV+EXypGFbtj15iqhgvdexSbPaKY1VQT?=
 =?us-ascii?Q?/P1GR6mT6L9hfGMBB0wxF0yIvkhYDibaV5eImqPfO9Ld64oDkMhwpB8i1QUQ?=
 =?us-ascii?Q?vylZRitbw/921ajpX7hovCBZa5R7QbFhXWV/meLLu+aFCCCv4VhhyXe6kYhe?=
 =?us-ascii?Q?VeLwjwad+09WlpHgG6kB6pbDh/Wqx+Os+LwJF/RqMZ/VHrxcdSs/R7MRv8tj?=
 =?us-ascii?Q?9eJjQxdYpIaK2YIJXQ6BL5dfR0xFnM6sSFsUKRAW/AEy0XL2W/wiYOclrzhW?=
 =?us-ascii?Q?7thmOjOE5zc5I60DpSv1C3XK?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR18MB3882.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a753df2b-00a6-431b-eb77-08d92b400540
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jun 2021 12:13:41.4343
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: U9MLhfbHVah5VPz7sU3hF65nMpQBhmS/DE9jf2t5eAzJBqmwwp2Y41sOdLWCSS9YBHGkLAAmsHSFIEWEiBAy0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2613
X-Proofpoint-GUID: r80Dl2gd0UhMxAiGXCIttMI_N2zNSs6c
X-Proofpoint-ORIG-GUID: CV0T4epK4WdKrNr1xkgx7ADZr3VMTpn0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-09_04:2021-06-04,2021-06-09 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 08, 2021 at 10:51:00PM +0200, Shai Malin wrote:
> On Tue, Jun 08, 2021 at 10:41:00PM -0700, Keith Busch wrote:
> > On Tue, Jun 08, 2021 at 12:08:39PM -0700, David Miller wrote:
> > > From: Christoph Hellwig <hch@lst.de>
> > > Date: Tue, 8 Jun 2021 15:43:03 +0200
> > >
> > > > please drop the nvme-offload code from net-next.  Code for drivers/=
nvme/
> > > > needs ACKs from us nvme maintainers and for something this signific=
ant
> > > > also needs to go through the NVMe tree.  And this code is not ready=
 yet.
> > >
> > > Please send me a revert, and I will apply it, thank you.
> > >
> > > It's tricky because at least one driver uses the new interfaces.
> >
> > Shouldn't whoever merged un-ACK'ed patches from a different subsystem
> > get to own the tricky revert?
>=20
> Dave, we will provide a revert patch.

The revert patch was sent to net-next.
https://lore.kernel.org/netdev/20210609104918.10329-1-smalin@marvell.com/
