Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30BF7681544
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 16:40:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235834AbjA3PkH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 10:40:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235970AbjA3Pjt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 10:39:49 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 957D23CE39;
        Mon, 30 Jan 2023 07:39:47 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30UASoVT018742;
        Mon, 30 Jan 2023 15:38:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=pHdj0eQNiSeWs553ZRuhWkuqKsoAAy48cfEpLgeWA7I=;
 b=e4ewwPN/eHJlIuHYuG9m3jnpvZg0oB8GjQaNU7GeOsB7G3uFcdJzTLVXOiCuSkyUIBxE
 FTsDxjMedVQ/qgT2A6d9ilfWol8B+sfRYXmjF77Rw3JO4BImS/Xo/VHoc9UEoGhoP0lf
 E5b1JmqeGs38RBD99E8P66mSQ9QobnsUdbOtINWVpu94tuMwpEHUGm2ToBGqHQsdT2Od
 Bg6sEbJTS6UqE7zcYmSanzlXg6TtJXzq1Z2Ma3zlas3A0MuC646PKTKKAM8rTofSob5N
 PiujseDFzADwwOv3jup4+bsabz63a/ZRWpEUv6r15Xtf7+1xP0R9Eq3nNMSiyP645Cpx Kw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ncvqwu6vj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Jan 2023 15:38:07 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30UEAqY7019060;
        Mon, 30 Jan 2023 15:38:06 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3nct54ggp6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Jan 2023 15:38:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hoNkATKxxNL/oNVx3Igj5vwI7fh3bXMpYQIvwOUcPRyMnvgVU3xj2FAaYIEYaTTParbX/dPXT7s1TKOy/eF/7XqM4+JpRy8od0kq4wXHKkk+LteHULVU4r18OO7THkjRMBWNXoHf8mYOnBCQnEgMG+BltmOAy8kjtLnAq7QnjQBUrLp9dilC+WpoU7B6ZY93BjtfY1oN56FEU4fbAkeTqHwEb0hBIwnM6WdonCzKvLmW6Ve9SG/PZXLyJUn57VgxZWHA/3t4Se+PAR7WIxuYSSKTBt7J28qkorKhNpMdGelbC9rFa1eEMjnZwCw7CYoRRHkJYk01sFcKDY0+4DMJ4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pHdj0eQNiSeWs553ZRuhWkuqKsoAAy48cfEpLgeWA7I=;
 b=RKcUN0s2yHqeRsmfLZjptC3mjUwibeW+d9xBhKt1rb2EhWKN1nxYIY1txp6CjfzK7SX/mpH5R9Rk+ebpFNryKP12cFYMy6xoQjoMIiq64Dq758xracDsUeZE9BZytf5mMpTqszCP3YmMgJgXMTbzVHyp4Qd35XAlgaDtqv+GoQdk1rSn9XoUut6iynQJl1NPekC+cwCa5F5XVxDy4NldtNwq0p4+v4qqEFKkMCH+hMOWIkJqQbEdBfjdHZhtnfTzyZQdbNZdZ5HVwtzjMKP/pWeKmQiixRXHaPKnwDDbiPUe22gRMU9Nklqx/YPQb5W7smOJ/vEjtNGR00Xsg94Dng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pHdj0eQNiSeWs553ZRuhWkuqKsoAAy48cfEpLgeWA7I=;
 b=Vgu7MnxuaZkjjKHzDEi44hNPfb6gPJiLSKJDvCgqaBlscnCFQ+2xjwpgkRMCBSWxxZjDVnjME2ECaQ2jqhlEJmQrsrMG3BB4l8ljvX3eUSOYH0vw0Fdzn+nWFwkTzCctaPHrlqLUtnjVFTevw9i7vGlOBjf41wzRLfgkd3Jgcho=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by MN2PR10MB4384.namprd10.prod.outlook.com (2603:10b6:208:198::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.20; Mon, 30 Jan
 2023 15:38:03 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::96a2:2d53:eb8c:b5ed]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::96a2:2d53:eb8c:b5ed%6]) with mapi id 15.20.6064.021; Mon, 30 Jan 2023
 15:38:03 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
CC:     Jens Axboe <axboe@kernel.dk>, Ilya Dryomov <idryomov@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Minchan Kim <minchan@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        Xiubo Li <xiubli@redhat.com>, Steve French <sfrench@samba.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna@kernel.org>,
        Mike Marshall <hubcap@omnibond.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        "linux-afs@lists.infradead.org" <linux-afs@lists.infradead.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        "devel@lists.orangefs.org" <devel@lists.orangefs.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 21/23] sunrpc: use bvec_set_page to initialize bvecs
Thread-Topic: [PATCH 21/23] sunrpc: use bvec_set_page to initialize bvecs
Thread-Index: AQHZNIyUSOlbtInNyUq9LayrYx5l/q63GJMA
Date:   Mon, 30 Jan 2023 15:38:03 +0000
Message-ID: <D83CAEAB-94AB-458B-B6EE-34AB61F5B9DC@oracle.com>
References: <20230130092157.1759539-1-hch@lst.de>
 <20230130092157.1759539-22-hch@lst.de>
In-Reply-To: <20230130092157.1759539-22-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|MN2PR10MB4384:EE_
x-ms-office365-filtering-correlation-id: 685ee1b7-b1f7-4a65-770a-08db02d7f9ac
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JiSJwAZzlqkR3uKxuLP+5kZ6rf5KcISnwhlEd8b3X0pI856v5rk8klafbyhh5NK6cdslOcKz2olEj4B6uuQCWKLIJxsAT3NODOfiO4SkW1IB/xJREhn7za1olrZHLWZ/TKKltFLO8yfDjtN5u7i8PGdrnNCB797gQ8d7CMuEXm2D5ULqveDtfNx8kQbO5SceHoirTMGSZptS4CDFb8NKH6IGC50ZQhksaTr7sJkkVt0cFmciThW0sqR6Gihqhme1WmJfEPotLxHUXRnz0B1WAvH7TEeMJfiGvKl+Vn4B+7JV4R59FpW/LwAFKSMDlmReiUUzIIsuZX6es/8PiCa+bcgMaWK0Z4hpvoRrwbKRFFTKYF/ch6sSEtIoQs30fkSq+skWP0jjp4uvZXteroM5lGHbdoatWxhtVW/cAW/U9NmSAl5IYQxO9X+gQKLttS/MIqOkYXXO6/CuJweSdX2zElQG8r/3PXCJlEkiCNOPlxzADBVTzHzHLcMn8V9H+iFuddkTxMUtm1fSrJ+0i7VWOsD2ThZAfFGyWD9X9V3vtSil9ieWyoLGzlt3TLH2GTi5cHK9NMhQSbn3cJrwst8rwrRcu8WWflmGPVe2yvnSLY0mgpbA7/0T1Q1g1u/jylwsez3WaQGV3uWs6iQI8hC2yCQopcq863yVwCrlc60KTO73JXoUfbPtrVm+MVVG/z3xp8h/Nu+tWIsmey5eCLWBgusOtHLnZwVRHiArW2pW+bY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(39860400002)(376002)(136003)(346002)(396003)(451199018)(41300700001)(86362001)(83380400001)(33656002)(2616005)(38100700002)(38070700005)(122000001)(316002)(6916009)(36756003)(54906003)(4326008)(64756008)(8676002)(66446008)(66946007)(91956017)(66556008)(76116006)(6506007)(53546011)(6486002)(26005)(71200400001)(186003)(6512007)(478600001)(66476007)(7406005)(2906002)(8936002)(7416002)(5660300002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ZiFahZYf8giEphbRZLr47ECfPurtLiatxMGflwXHFwVib9k24j4Tg5EZHyqj?=
 =?us-ascii?Q?L2Hg7GJH9gE6UZF1yMuZfHAPghIhHV85RwqGR6cMpr5PClWLlUsQIceWfwfS?=
 =?us-ascii?Q?+UXt5NCAlO0qEIxRz8zQ+4iNM2jJEniYE9fPNrW65Ud1qZM9ppJk18xuUvuH?=
 =?us-ascii?Q?uTTsLE9BV30KHbaZIaZMUAKgvD7dDj9pEmgHsnJti+WvN9LA9C+egmAwMMfD?=
 =?us-ascii?Q?x95SZNiONp9DoLFc/a1xY2FGDQ9L/4H1GDyLgmP+OtIlviH6pPHe1dIpZCqa?=
 =?us-ascii?Q?njlZZ4dBfrMAH1T8HhlXAJopcEQMUyWC9npvNFP9uJ47meiUi3QAEE51c3Td?=
 =?us-ascii?Q?IWJbdcZz+678LqK9AgME9l/PYyGucKBb8LtCymBM6RDqlN89Re7qX7fmpwui?=
 =?us-ascii?Q?KbOZQ2nOJxjTNzHdMwB+MddbAQS5EdalN6Dh9L+2YoMkyW0xBHpAcYm7nDaN?=
 =?us-ascii?Q?35NIJIElhHNwPgN0xQJvgjnpYKka1D8Q4YlWWq+77urzsdmY8kIiHNbhfyHC?=
 =?us-ascii?Q?f4Twce7AUdskgegMjc4Ys5JiP2rnLhH1SKFm1j0nNfDjYc9Aq+Txd5GVfPyZ?=
 =?us-ascii?Q?QfSuiiMt/ObhI79LyxSLbPY9jOWdR1XtN2lxzOE5fAZrtoJuQoszQrRzp6CU?=
 =?us-ascii?Q?cEF//r0Rc/ZFqaWG2uB1py99a7OV6jl8ux/U5GxEuX05Raw8TuCusurzS0mM?=
 =?us-ascii?Q?ZHD3F63HqWQninVCSlgaxt3wB46jhiYUdKeKP/41SqYyT3Wx1ErPGFxEl8/m?=
 =?us-ascii?Q?QFUvPmSQi/EduuBaiMNo/Wc4T+gPdffOYHl96ZeszCUpC0Ky+Z1i2As24Agc?=
 =?us-ascii?Q?pNbQYuporKuDYnncp2jzqGQNC28TBE3410WeXJLNhZynu6AyZA/uMZOutkhi?=
 =?us-ascii?Q?UBpbEe+XksxYl3tcBbJ2Oj7Y9O6gRr8acVqE+6JEe1er0tk5ppt66+n+gmYC?=
 =?us-ascii?Q?FxwPTX8J/oftwNHOv7ygiIW7tfrQjMZ8MEyLUchIZlIEjbxSJeC1/FKHO2BY?=
 =?us-ascii?Q?u/1qrZStuDWxqQ9Y+J7Z3GShN32Aa87mgWkZAwOYBcLy1Hko2+bw5IvqtxEx?=
 =?us-ascii?Q?D6efgsyYCiC7x4ZkrCANUehgvvPxJYCtDW+u0PIZvtgdjpRV5MKFFbyx1Yyf?=
 =?us-ascii?Q?h9Uu5/uw0rnmNHeqGDIAqsbMWWbFt/Z94aX0ThGJBZgBl/iCJoYMw9HxUWd5?=
 =?us-ascii?Q?X53z0Op3kHnCMhNfL7uW4FhdkkCZEImJUn/8IOxYHumWlPdXK53+HgnMBPl6?=
 =?us-ascii?Q?cJJoQF83lX5YKxJPScIKnudXIavjfGgu2Eh5LTZWVrBvRqOldyd/tKCJORqJ?=
 =?us-ascii?Q?gYhw5xnfvsfqgMXzQhJ9Flgc6dVeJLU7KtSTpPJVUIMHtDcwfKht7Gs2anLR?=
 =?us-ascii?Q?87oP6uBjbJPbVZJSyG4/TZ/wkVD2xw3D+GxjJQ2G5f/STt4dGOTgexWHyaNi?=
 =?us-ascii?Q?3lqEFiWBfjsRh2vcEyVGBPIIGCg2P+faPF/1O0X1VHGMPkNTZbpm1ufGy526?=
 =?us-ascii?Q?Jdl/kv8zvcx3uvp7Lg2Qtr2eKmw4xeeVTl8BHQyRILwSjSKJ0xHY/CrJSKoy?=
 =?us-ascii?Q?u/qPTbZMKOF3mdBsT2OZALDjFqSouN3tx8raaJnSKQSIHsmau7xelFJvAtOI?=
 =?us-ascii?Q?Ow=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <33D1E9863DCC624A861B99A24FB1791D@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?rV9SCR8BOJ1Ianjh7LLEPqq58xHz7TyjHCkRzV53lk+Nj2mSz13ndMobpl6V?=
 =?us-ascii?Q?RfezTjUwsLqZ0DthP8kjaoNIltBFCWsMvj2AC8BhA1g9uFSsw3XZTH9ddPnN?=
 =?us-ascii?Q?Mx0B2leNFX8Y7OQ3vAuYcc9OPPGn2qxhLFMa/9bVDvwA1fiOTCX7Ag0sYjjx?=
 =?us-ascii?Q?OZ4wYoLx5g+P9mSZXhyu/ZJ1Dzb/WDVySERrIxSrKwx3WgWj1ko+5/YmyvBO?=
 =?us-ascii?Q?OyWcilFZ+p9/HEfe5PLOWe4BvVo5Z5XuuajxkDoT4g/Zu0q1TJVyqKeQOSJY?=
 =?us-ascii?Q?w/JyNfTLHOdNSl6SdI5/vHYd7Pwp8SK9I/x006xS+xpKvb5/jeltZBr/MpNg?=
 =?us-ascii?Q?TfAkWQeZXtAr8krQeLZ20CgW8wZ8kyuQAoZjSL4vWdFZYeNgdVBzPQ4gY88R?=
 =?us-ascii?Q?fdDvdaeW0egMvSatymCGdh6+wJ3V1BVS/yQVKpknWNNzqdfZxDwro9dQSqi/?=
 =?us-ascii?Q?KbiMOkFxw2iNu7O/1LEaygmPmRzDkwK+GP6m7g1EEMKZz9uaLBCSp8krY0tt?=
 =?us-ascii?Q?PehRZ6cmzaWkMvqeodtOGzo246EQGDaW64O5WAhzr1m675a7Hu505EIRv+nP?=
 =?us-ascii?Q?27ZDfoOrFO2Ax5yCP0D1bIJODQHdmZskvZWo4ukjjNVfCP9EObgvt80VTiCK?=
 =?us-ascii?Q?Gj5WeoRKmEFDLHj0CxEfzFC1RUft08M+o2Ilil6gZmWNWA+FI43yezTY5X8t?=
 =?us-ascii?Q?LWjQwS/FTvbuqEIfCRAu9iYxgZVWdbnPle6JvnJ9ws/grt/RhVY+SyfU7S+L?=
 =?us-ascii?Q?BhsnnX9qF/TlRQBFxPgp/jkwghL4ETaVgfw0hVTlBYfTkG7dhvsZFMIlvmya?=
 =?us-ascii?Q?BNwtzCQp8AqSgPF89qsuS55mgn0rDtF58mbYsy2HBGx92ziPwUIBzQEvC1/8?=
 =?us-ascii?Q?4aO6zKXV6dDyRTypmetUidJn4P795QXiClN2PB4dSRDQV9qr/PtgDb9lH87Q?=
 =?us-ascii?Q?h1PnGd2icS+9qZ1DxDJi0A4VkBZqE3psIrt06PGVlwDqHDLVDiH9TOFApogI?=
 =?us-ascii?Q?eDNzqWxZPgHTBDtitFNsQsrCsziJYZ7ZH5GiviFR73X+5CDF+DxFGQyS+4Wf?=
 =?us-ascii?Q?+WZ+Dxb0OHPCb3t5Cai1PofPFgd2T1kL98pb5GPyNf1jhi9ebGwJ4mz2RHpK?=
 =?us-ascii?Q?iMkUX3gw3Z/eL8AGwipd7ll6wzLhq3mAYhnH6lZOBe6FmHi82z9XWlZCDW/q?=
 =?us-ascii?Q?0Cjht9OPLNL8xWJUCBhPFq4jEaDcLnM1XR448Jr9mqBMrRz+A63Jzse5ufBV?=
 =?us-ascii?Q?CvxJC1Zpg+8NYiuiCyL/FmQe4AAaAGDTCBMMEr22gq8D5V/0Ao23FJuM97r9?=
 =?us-ascii?Q?RDeN1cPQ4nhKrVxqehojYo55MiplZVQefrou8MibfqsOODRtj2x1h//cQg0+?=
 =?us-ascii?Q?AnrnljDLIeF9u5rE+NLBOdgKJhdTV/+2XScdHam9UqdjCcazfU3f9VjaiqRv?=
 =?us-ascii?Q?we+4MlRAmNK22phfxOQxK9zZq7g1V13WgtHT488NjI6Pra5E9hHazrRv50QZ?=
 =?us-ascii?Q?5U8rZP5aDusAHo0=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 685ee1b7-b1f7-4a65-770a-08db02d7f9ac
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jan 2023 15:38:03.1861
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: G1o4jixfP6t9gjD6DsUwBGBT4DVUXfup2YnHh7QATGQ6ppA0DrxlxDROTyEBWTTELk4KhqSupIuf1CxMvrz8AQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4384
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-30_14,2023-01-30_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 mlxscore=0 spamscore=0 phishscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301300152
X-Proofpoint-ORIG-GUID: vn5_Eaugsne7jR2x5W9KW1OXNONb69nt
X-Proofpoint-GUID: vn5_Eaugsne7jR2x5W9KW1OXNONb69nt
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jan 30, 2023, at 4:21 AM, Christoph Hellwig <hch@lst.de> wrote:
>=20
> Use the bvec_set_page helper to initialize bvecs.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Chuck Lever <chuck.lever@oracle.com>


> ---
> net/sunrpc/svcsock.c | 7 ++-----
> net/sunrpc/xdr.c     | 5 ++---
> 2 files changed, 4 insertions(+), 8 deletions(-)
>=20
> diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
> index 815baf308236a9..91252adcae4696 100644
> --- a/net/sunrpc/svcsock.c
> +++ b/net/sunrpc/svcsock.c
> @@ -252,11 +252,8 @@ static ssize_t svc_tcp_read_msg(struct svc_rqst *rqs=
tp, size_t buflen,
>=20
> 	clear_bit(XPT_DATA, &svsk->sk_xprt.xpt_flags);
>=20
> -	for (i =3D 0, t =3D 0; t < buflen; i++, t +=3D PAGE_SIZE) {
> -		bvec[i].bv_page =3D rqstp->rq_pages[i];
> -		bvec[i].bv_len =3D PAGE_SIZE;
> -		bvec[i].bv_offset =3D 0;
> -	}
> +	for (i =3D 0, t =3D 0; t < buflen; i++, t +=3D PAGE_SIZE)
> +		bvec_set_page(&bvec[i], rqstp->rq_pages[i], PAGE_SIZE, 0);
> 	rqstp->rq_respages =3D &rqstp->rq_pages[i];
> 	rqstp->rq_next_page =3D rqstp->rq_respages + 1;
>=20
> diff --git a/net/sunrpc/xdr.c b/net/sunrpc/xdr.c
> index f7767bf224069f..afe7ec02d23229 100644
> --- a/net/sunrpc/xdr.c
> +++ b/net/sunrpc/xdr.c
> @@ -150,9 +150,8 @@ xdr_alloc_bvec(struct xdr_buf *buf, gfp_t gfp)
> 		if (!buf->bvec)
> 			return -ENOMEM;
> 		for (i =3D 0; i < n; i++) {
> -			buf->bvec[i].bv_page =3D buf->pages[i];
> -			buf->bvec[i].bv_len =3D PAGE_SIZE;
> -			buf->bvec[i].bv_offset =3D 0;
> +			bvec_set_page(&buf->bvec[i], buf->pages[i], PAGE_SIZE,
> +				      0);
> 		}
> 	}
> 	return 0;
> --=20
> 2.39.0
>=20

--
Chuck Lever



