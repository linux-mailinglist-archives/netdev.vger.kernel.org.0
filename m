Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD4E935D373
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 00:49:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343888AbhDLWtH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 18:49:07 -0400
Received: from mail-mw2nam08on2061.outbound.protection.outlook.com ([40.107.101.61]:44231
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239204AbhDLWtF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 18:49:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CtOhcAOS5XsxCDNdNJcPPioqy71gSewNTFLiyPD5f3iVD9eie3WDAYZQOvmYZUopvWLGBuiQKoLfHSFcoT0VuPPFPLmlxJOihhhQ6L8mFIln/X4gC0NLLmtXQhe8wo/ySY+fC6rH3khq45+EsRWU60RXHY43l17nf1NOW9z7m16WHpSJoigKTQHJqhuS1DtMz5I5Vj1u4Ymd/tRKrpJ6obIoEeF2B5ENsSq89aWnyaBvwQARqq9lfUFBNhvX/fImHTxulphEaewWkL2wCCq3PLo0gxwUB/labngaNgjmk1TIxRwhd4WB/OgCvuna7KFfs1SJhX/ta3H2de9rSY4LIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F+CON4jgvlfwPud8+D8/htfVek+e6ibqemNbiRY9tLQ=;
 b=ENKiJom8bmhBwLLAfiRNZG607bEgI0sLsaO0Vq9uFNNMfHMJq/Rk1LOJX6OauoGkCW3D4dP72/t7NfH+WiiC5sDsJW1/EsK14JOQvxJSdIfAKSh8Uq7qF91jH5DT82ZpRCmk4mug7jT61dmYAyVo3MwTRyJPz4Mm4/BjKoXTS0T17ABMY1uGv7MiMc1xXl7cZdUs451WMZTYwVq1J4fIrhgQoj5e+lLe+cmoxzRF8+Ir8vBQZV/5s4I/ZY1VtBGRkauCuAb0lGX4QW/Pm325SdvIZTISwdQjDzx7PCjSNYpd1EtsP7jMK5TAhPn12tAjJMyZVCu2e7Xga4HWVgs8vQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F+CON4jgvlfwPud8+D8/htfVek+e6ibqemNbiRY9tLQ=;
 b=pmrOCXIjrEnCUAq7wY39L9sAxVYYXkfSbpyq2Rbfkc4jhTioBkgzNyNepIriZk0KNFjAIksyVvGlYl4nn36KGBNy3SiNhiyZs+qQm5vHbjiXxjmxLYHUcG7vFLJQLUFIK0ogYHIKkBUygwHWTrE3ouawZsKgWx2EVGpJfJQxTr/BKMvdzJpPlZnmluaueHpG8j5+KYE+972MgTCOKBNPdWHDWTrdBE6a24i+nIqpWINdTxFHWuxmISX+obtOGtaGKtPHlSZ219Gy0wlrAmKp6lH4vMJvmUMmZa2cL5/x1WPlDjFRz9H2jADYJc+LO4eSEW2f6A1kIYoRK4X/e7qWdA==
Authentication-Results: talpey.com; dkim=none (message not signed)
 header.d=none;talpey.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3116.namprd12.prod.outlook.com (2603:10b6:5:38::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.18; Mon, 12 Apr
 2021 22:48:45 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.4020.022; Mon, 12 Apr 2021
 22:48:45 +0000
Date:   Mon, 12 Apr 2021 19:48:43 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Tom Talpey <tom@talpey.com>
Cc:     Haakon Bugge <haakon.bugge@oracle.com>,
        David Laight <David.Laight@aculab.com>,
        Chuck Lever III <chuck.lever@oracle.com>,
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
Message-ID: <20210412224843.GQ7405@nvidia.com>
References: <C2924F03-11C5-4839-A4F3-36872194EEA8@oracle.com>
 <20210406114952.GH7405@nvidia.com>
 <aeb7334b-edc0-78c2-4adb-92d4a994210d@talpey.com>
 <8A5E83DF-5C08-49CE-8EE3-08DC63135735@oracle.com>
 <4b02d1b2-be0e-0d1d-7ac3-38d32e44e77e@talpey.com>
 <1FA38618-E245-4C53-BF49-6688CA93C660@oracle.com>
 <7b9e7d9c-13d7-0d18-23b4-0d94409c7741@talpey.com>
 <f71b24433f4540f0a13133111a59dab8@AcuMS.aculab.com>
 <880A23A2-F078-42CF-BEE2-30666BCB9B5D@oracle.com>
 <7deadc67-650c-ea15-722b-a1d77d38faba@talpey.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7deadc67-650c-ea15-722b-a1d77d38faba@talpey.com>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: BLAPR03CA0136.namprd03.prod.outlook.com
 (2603:10b6:208:32e::21) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BLAPR03CA0136.namprd03.prod.outlook.com (2603:10b6:208:32e::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Mon, 12 Apr 2021 22:48:44 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lW5MJ-004y9Y-Mm; Mon, 12 Apr 2021 19:48:43 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 24257fb2-64d4-489f-b836-08d8fe052094
X-MS-TrafficTypeDiagnostic: DM6PR12MB3116:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB3116562C312A534C6DE9D7E0C2709@DM6PR12MB3116.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g7P9KU3nuldAskQZ5NHWojS1NZenRIHfOTAm3PVPOCZZY9STDxRTDUwyRZACGwQg1eZmrrlMG8Sfy7W4P5Gej6p2FLED2Wfahwx/EZdupgXBGXn5xOzPAcJ5PuCAV2v/KbV/9Vx/Cm0CFpHzkuNfBSyNPVWJsB4TTS6A3heWGVMGttfFVIN6I8a2Pj/psiEWvO1fqUCQZyblsGfT48H3SXHrrjKiSy0HWTfFUED1fNM3to3JTggGlVHYWkAlGGDxKO7Mf5hZfqcQemON+Po7j0Oc1VtbpD1YNlfwHLH5LgGbAKUL22hoZWtNYscT8Q1rcM+kKRsBfxwIx7nY9Q14UXUDaVWTVkpeOoczfll5bBrgT7lZXORrOzwizwFAq2ovKthF9WiOWPl9CGT1RKy6yDahVNWkF00gNIQJMhQJ0Qx4tF+/I6Li+zu+yjQdeJS9JkbeOnQ7iqh98tsRc7PFuR+X/kh8DZdLeYml4r2MDbggYw7N13kR0YJOWq7D8nfPhdENDy40EvDK2K5pX1RoLaa2v9fwvPRFoGUCQOm0ydAB/2KuAWxliHzxLbRIlbtrldCK/Ww06Hy3bbhTGyCjFOXDM7V26TdYX6HzC4qWCDw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(376002)(39860400002)(366004)(83380400001)(2616005)(2906002)(36756003)(38100700002)(4744005)(186003)(9746002)(1076003)(478600001)(426003)(4326008)(54906003)(86362001)(8676002)(7416002)(316002)(6916009)(66476007)(66556008)(66946007)(26005)(5660300002)(33656002)(8936002)(7406005)(9786002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?WCbyl5YzMwSW1NEK0ld6MqvIqe0liUi21PJaRrSQrLdmGRQ7oFjMxJ9LILNQ?=
 =?us-ascii?Q?RDHSUu/Zx8zEHw0jkj4Q/hbjuY803jvp1/l2yQ46P+CAw37RcNuprLDetAz9?=
 =?us-ascii?Q?sso5b3Ub1obpiLxOFYJjOaDoPPcx5DHqcq70fH57lxlG9Fziv38HEdTbH9cD?=
 =?us-ascii?Q?Lcc46Lfdr2xmL5xIjpgKypfSarjqELSGyRV5dJQJIayEsfhJJ1s8PS2wSoKd?=
 =?us-ascii?Q?afnnvCz5TEZ4/KF5glJPJLVIjHnZCBNUYmIZ4nA8qor9Wlw58h7qI7sa4YOx?=
 =?us-ascii?Q?nlT5A99WIQpgJUanz6pl61QYhnf/6GKEapTMzk+2DMW8rMEuoeyT5B914fMJ?=
 =?us-ascii?Q?+6o/Vp1/kOmy6N0/1PdihnDliM6lTlDXgrsDRN+Yr6h3T4ZwCSEpCLObd1c8?=
 =?us-ascii?Q?Yw75FAV3YFdQ8pHdSqLkBTboI0LKgMY0rUpxZ03sartk3+LJu4+75GmNeZ/P?=
 =?us-ascii?Q?qViHH4bHwvTU9C6eEvGuqgEPWk7R43UI6ZnT5yPdCSDS7qw2Mg/gCj9LaKMU?=
 =?us-ascii?Q?EAdjGmTXpyE3vyPSkKaqAE3eaXwugnfUqASdLRw7Sm3ipMcFJ/v06+Kp2nvn?=
 =?us-ascii?Q?+EuMmqLDlHW5H9hyWaV171ACJLkKwebx4KW8n12muHR4KNndfLBr32dmzqXB?=
 =?us-ascii?Q?GiCbp0H8doY2qlWJWwu399GZ5ISZpwOvPNhFnoZ/Pyp8NJy2r/XGZLHm+n/q?=
 =?us-ascii?Q?U7V3fiEvp6Fa1rRk8eE2hlTNsJMlOTfJng/+7fP5o4JSEnMvtloyzA2apr6v?=
 =?us-ascii?Q?v/0IcLaZTRtY/lJT/L9SNQJnfpL10rgiLnVSXTS2dCoFJN8KJpWs+nfWqk9u?=
 =?us-ascii?Q?z1cF3iL6fqwS052Sbl5cJCX6u8qHPi7UenUWSNX0vwnUWeQ5/Jo2Gb08PV37?=
 =?us-ascii?Q?SDpA6+dYwDJYS5UeTKVw72SQBbEZ1s3rebHjBQJdisE5o+QFVfqqpZOjJYPA?=
 =?us-ascii?Q?z+TpaBSepUwCoLIlYFoF3pmm4jSoIYAQsSdHIZ0yy425JGJEmURC6ciBl1of?=
 =?us-ascii?Q?rzCjvJfLpXWyEOyOXIKomZHZyWAhP/gAdn5FAEr5USxRE77e0AcAmjayjXvO?=
 =?us-ascii?Q?VXCkXsAZKW/CZtZFD+5Xiz3tuXd3toWlAMI7CtrDIkGS+sBineQ2m/Y8HMXK?=
 =?us-ascii?Q?2e+5nPO3927YTUmaePxf6dmFsupsAFXpBAxrQjd55Rtg3v0/w7V5EgdgYZq7?=
 =?us-ascii?Q?lB55RZlvU2vcBUzkTeu1REW//2v945npLtbBGOc/xShQgCqsd2iyRdK+TNCl?=
 =?us-ascii?Q?zwvnjbG9Yala8vozEuLnvFCqZMWtnnqGZbpVGxoQ2cGU/C6nCIrpOWVnJkJZ?=
 =?us-ascii?Q?szHQ3QTSb9EQIc/Gg/vxOMFLOTM3SFFsspFRMIWhvp6bBQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24257fb2-64d4-489f-b836-08d8fe052094
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2021 22:48:45.1232
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Al6kpnEjiA2j2+gOKnQSIm3ZeYc4aVfkBwdu/8xqaPykaW0cKQKRbvGzV4ftxGRx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3116
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 12, 2021 at 04:20:47PM -0400, Tom Talpey wrote:

> So the issue is only in testing all the providers and platforms,
> to be sure this new behavior isn't tickling anything that went
> unnoticed all along, because no RDMA provider ever issued RO.

The mlx5 ethernet driver has run in RO mode for a long time, and it
operates in basically the same way as RDMA. The issues with Haswell
have been worked out there already.

The only open question is if the ULPs have errors in their
implementation, which I don't think we can find out until we apply
this series and people start running their tests aggressively.

Jason
