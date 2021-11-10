Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 932AF44BDE7
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 10:37:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbhKJJkC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 04:40:02 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:28376 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229456AbhKJJkB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 04:40:01 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AA9TaXi023588;
        Wed, 10 Nov 2021 09:37:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=9VXKP3ulrpHVQbwEFytiQd9WsoQo2ZwDTaH5acrzaDk=;
 b=D7txOktbNWt+e12XUqYCk13RekRaAFw870rPFgQfH4Z8xbKQ9tcBf7fQ4SxizQF6ogzG
 Hg2lhgIimRZbuBoBAG0se6gBani+l56Objww6vABXvArkNFXycaG2qvfpAE8tjqk0Fmt
 Gn3V2rg2hKveSeiPNkByCSyKFp72VIYfMNX4dUJsb1+GpTFrjZOomUJf77LeITbxnaEa
 YlYXhNAyaNRhdh2wasCC+v8JgD7xoJrumgbq6vZFQ/HCq+fmAza0X4nu2U+oL5X+PZwQ
 RnOlHUp4bZ0y4yTpbG3Cc+Chfb0tDE/xJ+mkaH1jxD3p1T9HJ9zQo1iK8uJtFVGhBDrn FA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c7yq7bkf8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Nov 2021 09:37:05 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AA9UheF180728;
        Wed, 10 Nov 2021 09:37:03 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2042.outbound.protection.outlook.com [104.47.51.42])
        by userp3020.oracle.com with ESMTP id 3c63fucs2k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Nov 2021 09:37:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CojH70AGC0mBlz9kPlv7NFgeM0SHM2Y2gKU/DUhvibu7fmJpQ8qIhIiRYPg3R9XCIvcwmaRwfGV5s2jTKnRq0tmHUiECl9rwGZRlc8gtLFPS/tIuxLFcakVZj/czHldpWrZ152V9rzPn7tzpqcc5V/FuhlsrCwgLZJmi+v7wGLQIJECSTtrJ4J7PrCURVFzY/v8R8HUfvJTQek22B4j5EPEkMvHbarnlm0tbhkiSkC+NxSmPYv9d/22zOxAD5c4+yaD84wBJpn1FNexlAKep5wMkzUOvPjQFlpxEHU4xoaTDYouy2AljAK+lZ6S2DDGbyLaKHuC8W8Riy/ZpEB1hig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9VXKP3ulrpHVQbwEFytiQd9WsoQo2ZwDTaH5acrzaDk=;
 b=gCUtbI9zX030McFfhffuoCbrFXjEQQMZ7WrATwTcjNrWr/5w7xMVvgogwNCYqmnQ+lvXxA4m8iszDwp81w02Of10jY8DnFJeWe3H0wNoM4XaxjRsBb1xAZRezU9D4VyvhbPcO/uZPRqCcLLo0+/hWq8ADZMtVXD+RDukvbF76a+sVWRFBX/73X/oH4xglq84MO9amowQ8kQd+NYNgy405mjs9mU5vogtxkQul1QpPdTU3+FAt+IpYZ48LmGAXUjF44+ath2yQa+8H9ou9VPN8AEvXDgVYxe5/gDxVEFZfW0yRGSeqeQ9IUP2uzTuWbIHk+2e0S3dhG8WAnyGTbNMhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9VXKP3ulrpHVQbwEFytiQd9WsoQo2ZwDTaH5acrzaDk=;
 b=YaM1MVr4CNKBhhBq4J4pdqHXnEKrNmvKCK6vRzC7WTMp0S8oWqxk8qWVNPqg7lpJHRQX8Vl3bmYPyyhTI9o14Vi4y4Bt5ZVgjHv3nE7LikrrMF+zolBQH551fTC5zgTST7SnMJtWIxVgZseJKzFMydpcBmzeOgstHJE0vq4KLRM=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MW4PR10MB5752.namprd10.prod.outlook.com
 (2603:10b6:303:18d::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.15; Wed, 10 Nov
 2021 09:37:01 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9%5]) with mapi id 15.20.4690.016; Wed, 10 Nov 2021
 09:37:00 +0000
Date:   Wed, 10 Nov 2021 12:36:39 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     Jakub Pawlak <jakub.pawlak@intel.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        intel-wired-lan@lists.osuosl.org,
        "David S. Miller" <davem@davemloft.net>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Mateusz Palczewski <mateusz.palczewski@intel.com>
Subject: Re: [Intel-wired-lan] [PATCH net] iavf: missing unlocks in
 iavf_watchdog_task()
Message-ID: <20211110093639.GN2026@kadam>
References: <20211110081350.GI5176@kili>
 <89022668-5c63-bf19-a768-6bef2a3be3b0@molgen.mpg.de>
 <20211110090557.GL2001@kadam>
 <38c47f1b-f153-6c79-2ec5-ed4332c52f6c@molgen.mpg.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38c47f1b-f153-6c79-2ec5-ed4332c52f6c@molgen.mpg.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNXP275CA0004.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:19::16)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kadam (102.222.70.114) by JNXP275CA0004.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:19::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11 via Frontend Transport; Wed, 10 Nov 2021 09:36:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 75ca557c-4a28-4d3b-b4a7-08d9a42da546
X-MS-TrafficTypeDiagnostic: MW4PR10MB5752:
X-Microsoft-Antispam-PRVS: <MW4PR10MB57522BB9DA7B65768642D2B28E939@MW4PR10MB5752.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EXA00PjjjBmN0apeqhvlkFiux9saDGpCCxcdctIAdnyX5ay0Xf1yhCKizFid3IgjCh+izhoJZlACzYe9WbO7DtD6gCviSQlPxrKxdgqjyDfqteCufYaUinmvlXDk0rjerEz0EkOBHURuEpmfIMJ07GUL3SOTZJ2dwCK18D0KaQiM1+BYOBX0TLtAxfqh50fOAwBF8t5U8hhvSMKtcZ3nKHnTkkAIb7o1c7wAqq6p7ZKQdfiOfjRlne6oydV47lE3OZsZK8EteH2UksTrsZj2Ln9TCno4AXWX8S+SCmtn480Cckr/WnxLy0JOrEL3dz5JCVl8/mZWZ2d85tvFr3E2m0GIMRD+EEi2cxR5c1tUnb/LSX9+kE8m3OomdLYJjPJJXiMh7RN2HEFD5BFV6Liw/J8hjs/n31veQ2ZuQt9EgLWeH675zCVEP3fG8UHuL4kYrhtGlx95eknDJNCt+68ZAmTa9+kogVRmNXyJeWzUuC+wuIUykK8JcKHKxuYpZpGfjnWhzckzXfc7uIbeMgUCvpy2j4LLJzVGP2WyW1dWNJUy+3N/aNc4vJiWCSQzyJt++bHcb5X14gkj+ggp4XqmwTEjoOHqDrPCRJKYDFsq3gQq7WKbwfrUhcl2O8bRFPVvzPcbqgFTjd4Sdc8jQul9HEnoPerWfu/R0XDeccDSBDaSslGvkD/N8Lfhb7noUgRhwq6PfO+FeISdHocdV054eA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(44832011)(38100700002)(9686003)(956004)(558084003)(4326008)(1076003)(66476007)(316002)(66556008)(33716001)(38350700002)(6666004)(8936002)(33656002)(55016002)(26005)(86362001)(508600001)(5660300002)(52116002)(66946007)(9576002)(8676002)(2906002)(6496006)(6916009)(54906003)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CAH6/DLpacRofoX4RaPbjH7qjg1aaRg3aaKPY940v3Tp+CR36AM46KAneExD?=
 =?us-ascii?Q?H2bkJ+55SYp9WYxQKAm/LQZ7RJlvk2B29OXCS9iXlyMjaCYizUCCb6iFAnAi?=
 =?us-ascii?Q?blYUEbv4vNr0Kh/Uy0feKzy2W069nJanaLPwJhGxI2OyT20bzJ9tMExAtK2c?=
 =?us-ascii?Q?bfmpQXGXOeArmtO7hp4FI9HiJqGZcQECMUrq7J+b0qu7H/v4wV/kBOgQEXSN?=
 =?us-ascii?Q?vDi0gvBoxTV3cuAYMpesb17WPkqcwT32RxWZroEwzh3GCpgBnmZqWer8V5b8?=
 =?us-ascii?Q?xtdzM4XsFUW1Zoq8+8yDLhmOc1gydkqi763tVDlkjcZyDv87JLca57b4paDq?=
 =?us-ascii?Q?ipMYh5fKadnuWL4L2wBlk1Wq5/aSAwInDHoE5Gnoqu3r30Z87Dlmo7OuXpDB?=
 =?us-ascii?Q?9h3FAUD76AE4mClvw7pDeJVVLYerXGjfxoqPNv2+Z9XcW5kO3mHq6DigCYQ5?=
 =?us-ascii?Q?HvrbczM81Y/8Vv26PVWde+G8bN71fV7peEmY+nDzAZjA5E32gI+BhnbM8vV2?=
 =?us-ascii?Q?p86FvGbQuOyS6tnJvZrC3O+0mHnNg3DHoFZWqtk2/rEwBonZBPDKpKbvRmjD?=
 =?us-ascii?Q?REIecQzrJ5SzZPakuj+IkNGO9muNHZkRbNL7DybXdZqdg0sUklM/tWHLeaOM?=
 =?us-ascii?Q?PKNBo6nnMZw/dLcHRAZgzS7ZR+L1ymTd9A3/sGnnoy3s46qcjXCc02USh9hl?=
 =?us-ascii?Q?evlpfW/uRrxsEdFgzPFKEjtaZlrS9oSanh0NRsivzY5QcgySCS+XQWSkZ1op?=
 =?us-ascii?Q?6Rn19dIhiNpQWGOg/QXNtn7vMit9+x2qUmqC2oeX1OyK1YinYOz/rtcTJ3eN?=
 =?us-ascii?Q?1ny4Z2cjFASCUVFOVXCiQKgxt4DCDQfwfAXBNwTFp/NGw9PDZLMa8avIH5DK?=
 =?us-ascii?Q?/7YWmLSS6AVYQt7WHtnEsRfCMFlvgDPQNasGLSRWWm2S5p9vfzZTZIlAP4Jx?=
 =?us-ascii?Q?jdIhwb273YVMoN2D5pDAayLJbyQJOcvgjYT12bt9u5g1d/6QZkIr1rZYisD6?=
 =?us-ascii?Q?SrX9Nj4pIqAl/IsuA1DiwkJfI6z28Km6SrALK+SvUtmYsuGZVCaV/yx8OS+/?=
 =?us-ascii?Q?V0gT1se+SB1d+7jiOZXTuURncpg0MoXzB7U2RHVCjh48HoHZ6omA5jvg4qWc?=
 =?us-ascii?Q?Vwk4OmF4ZEkuu0pUZviHXbSWmHivbHPldEvstQhTLBMXAZiVPNgnrXuF6MMF?=
 =?us-ascii?Q?KC4XlyVj9a7zmWK3/ZwWxt61OMOBHN8xM7k7WYVYgdi4AzngomwKu+A2m+4c?=
 =?us-ascii?Q?wUKNsmPvYIEtQ0I1QYb0jYHj+Pd+tO0sNNUwiU/+NEXFiWKhLM9NMh3f2NjN?=
 =?us-ascii?Q?RFPHXghlU8FCYbgtwPFQlkXt8yztuWHAOQb8OD4krSWSuv0ndU6Zi+NxN7Ei?=
 =?us-ascii?Q?AD2nKauQbmfs4QSLZathbAUJvI/uVUVRMwecpGgq4uImOmNlQHGfo1iu3NvZ?=
 =?us-ascii?Q?s8xX9ZaLPh+SXczwzBkkOj3Tb2Q82qqI5exif7vno7GIw+oJ2EQJcacs55Fr?=
 =?us-ascii?Q?MVSJIF7+8ZXzyaYQDWEPLAvsDhwqU3Qnko+uy+FIu5YLB/6e0BNeMpfTGv29?=
 =?us-ascii?Q?ashPxqUF2nIUhyvMEDWp01Wdtlm07+DyBVzgr0MQWACeg7xLOupKJnESh2z8?=
 =?us-ascii?Q?+YSlIN378+8RPoeQ3SUARtJs7t0sGNAgGq2uEq5Nuny5KOk7kmysDUyrAOSK?=
 =?us-ascii?Q?dyWs4HtJ2GVIiEfbBkPUCzOxe2I=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75ca557c-4a28-4d3b-b4a7-08d9a42da546
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2021 09:37:00.4462
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8YYYivjRq6f2i5iWThsCAuxNUhZKyZM6l+xhreH9cM6Hp96bGSCxO6U3dodIbzPcZPwcmefnf0EyB5JlG+D1HU/Uhpmq29Eyzv3pFVqUjIU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5752
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10163 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=958 spamscore=0 mlxscore=0
 bulkscore=0 phishscore=0 suspectscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111100051
X-Proofpoint-GUID: VGoGwqJlhOsJZi1TaXItFRYqz5erigSh
X-Proofpoint-ORIG-GUID: VGoGwqJlhOsJZi1TaXItFRYqz5erigSh
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yep.  Thanks.  I know.  I'm just trying to discourage those kind of
review comments.

regards,
dan carpenter

