Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE0394B14BE
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 18:58:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245420AbiBJR5S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 12:57:18 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245415AbiBJR5Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 12:57:16 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B4CA1A8;
        Thu, 10 Feb 2022 09:57:14 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21AHVwbi013360;
        Thu, 10 Feb 2022 17:56:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=oHVQtcRVEBRhV8J2beeLNC7Hwr6ccNb65yPca//xNhE=;
 b=UtlW2ra2FDjc4lYsO00gX8CWy++h4mnypl7s3tJAbR9vMnM1T695CLovjt8PE4ZbTMR6
 laZq0UOpHMLQWc56iG/uCCN3pda7mdZ11/+GXOhtmt21Xw//rlOv/fbwpdjM/VzgsJVf
 pJlRJWrpaOrkpWVBmXSU++b92WE7citGPyG8WCtXgCTmX9QnfsCiXLxbzOSqu9OAz7TA
 MI4ODh5tLyPMcrlkdkzAKelfiYFgYWYpzVmm2zXamVm+EylTCV9Nsail0fPuG7z21emd
 OGkfn0PviPiGgrsnuoRcx+i5rI95LQVeQLZD4B+PxIWAukXjc/bmha6bMB5qmusuqzlI Rg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e368u1v0x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Feb 2022 17:56:31 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21AHffWg080905;
        Thu, 10 Feb 2022 17:56:30 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by aserp3020.oracle.com with ESMTP id 3e1h2at5se-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Feb 2022 17:56:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y6+2kZ+pFLIX7+3X3LQ+4tVIMPZuqoOsfgohOuPr7JMAW+wVGkKJxJhJthKb9x3P5QS7Ovh/DiMBHXfhwwz5yDIplex1wH07h+CZOvK2u+dJWBzkiDAApgmk/7f9Z1ciBJk3Bj4tCfzXaBI3c36plEP1e67q43wFRxibpdJiDXIZu0I0Gc+26fAT/AQy4ayrcPZopOuJ6zTvuPjs2cUbO5HWTUQ5ZrCsb6MX7F2nNpph6zMxwvsUWPqHS4RlCpApDnuWLlrz3hVh6EP2eOqiO+QVhNyc11Dh8RqPmV33jAONv9Pb7qBIws5CyPxWK6PBR+QBRu2QC2g2/Ic0b7INjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oHVQtcRVEBRhV8J2beeLNC7Hwr6ccNb65yPca//xNhE=;
 b=jXpcfBl3E6Qg7w7gqpf24Q0Fd9zvq5tfIH7IP6JZH5pnOaQyfDXWXaIXKa+jz736Iw6N4mscEaMDasOU1mTiLTkQuCsie3K8DzTmwgp0qaJceGdFY9aclEkvCCGAChSssYmwI0+/WtB/Z9LrsozyjfsiHGARAF6R1TXfhUEhgoOwlV0GAQxUrlB1dk5XXhZRJ8lTueLB0bnzBicC0Js5fTJWWCtudYzrhEq2ActYUrX2ovCXKu71yiISOtDc4NHJnxfyf+jS8IVUxCQVh0z0q5/7rUS++XRJ1Mup8dC8Fl2YNTBaqRG2HcSvkMAh1yNEYp7iAk4dhOeCRUS4LTGNgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oHVQtcRVEBRhV8J2beeLNC7Hwr6ccNb65yPca//xNhE=;
 b=wGU/pycrVoxtuwFJJUTUbrg54uqTQu/kwfM5hQ9nEuPFbozVehS9SvWAqED/dcrq3JK2w5tFbDA1BVnW6uNxTj/UU6FIshFLXI/Q0axthy4uzqwEm5fu2UDC/EhMgIV+WkQEdO/IOWpPmhHRjJ72gp2doGgkFolRoEmbZ5VU71w=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by BYAPR10MB2582.namprd10.prod.outlook.com
 (2603:10b6:a02:ae::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Thu, 10 Feb
 2022 17:56:27 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::e5a5:8f49:7ec4:b7b8]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::e5a5:8f49:7ec4:b7b8%5]) with mapi id 15.20.4951.018; Thu, 10 Feb 2022
 17:56:27 +0000
Date:   Thu, 10 Feb 2022 20:56:03 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, Willy Tarreau <w@1wt.eu>,
        syzbot <syzbot+11421fbbff99b989670e@syzkaller.appspotmail.com>,
        akpm@linux-foundation.org, Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        bpf <bpf@vger.kernel.org>, David Miller <davem@davemloft.net>,
        fgheet255t@gmail.com, Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        mudongliangabcd@gmail.com, Netdev <netdev@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs@googlegroups.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Yonghong Song <yhs@fb.com>
Subject: Re: [syzbot] WARNING: kmalloc bug in xdp_umem_create (2)
Message-ID: <20220210175603.GL1951@kadam>
References: <000000000000a3571605d27817b5@google.com>
 <0000000000001f60ef05d7a3c6ad@google.com>
 <20220210081125.GA4616@1wt.eu>
 <359ee592-747f-8610-4180-5e1d2aba1b77@iogearbox.net>
 <CAJ+HfNjeapa=2Ue19L3EWF8z5vxFB0k2QO_LuBu4Meqs0=AE4Q@mail.gmail.com>
 <20220210174507.GK1951@kadam>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220210174507.GK1951@kadam>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNAP275CA0070.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4f::18)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c0c5ca2f-7469-4f51-58cc-08d9ecbea90c
X-MS-TrafficTypeDiagnostic: BYAPR10MB2582:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB2582A3D37659352A7DD19B548E2F9@BYAPR10MB2582.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:751;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JcU+cc0hmHp35r/OLh1VGFvvQXu+2XNpjmMJvMV5Xi4mD+4m5aNHMUBBTKMb9J2+aYVx7UajSuDswcO17/wO0XRjrmAobWQNrmjtt42H7RaWGxrKxOFMr7uVACuQj+axhrzW6LgjVez/s/5kVyIKSbRNDz2itA+gupaW/0GrxIf2ZPlsvViN0S+tN//vjJjZPbNfjIAEE15WvmAVbCDGHuUMpw6XUzJe/zoPLSXumtJt851re5A1RKw9wMKWnVtKBW+MJft4Z/rnXXorsuE/4Kwh3nX7Ltcgpw5FHMKQdLHQVxFqw0QMASyGfHkA9jxPXgCevAXuVuZZNrdakZuiq6Xsl5o7GPmmEtM6mSk4s/BwFW9GPTLlVZoTxXCM6ul4KJGVg408XQ/AmrE04E91FM3rhTbW+ixhugl6TBQCySfBMzfkHQZc/IIrXJxjef9V6GfPX6/jgBYcedpHe7INEQL2k+BcNgU2GQE8wwxbiL3pUGKgdkXpIkpR8UsFXLTY+VkCTXjtrk06RN0+JSouq0MxoiBKeUyDPxT9wtWlyylQTk10kOCaKgBZsncmrpgNICVguOnFbL4Cmof6UloS+ZIF1ZFXpZk1NBj4lTKUbkyf4sX0iadM5jFeAunhzm59E+qkuSirsdhyBnQgUFdnioHwjYf2Ww/pWjV3QPDU6WS/L6Xo4RahRKgOfXJLyBdiKrMA2cc+KBETnwYRK/Oyvw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(38100700002)(9686003)(6512007)(2906002)(5660300002)(26005)(186003)(1076003)(7416002)(38350700002)(44832011)(4326008)(86362001)(316002)(54906003)(6916009)(6486002)(8676002)(6506007)(558084003)(33716001)(33656002)(66476007)(66556008)(66946007)(6666004)(52116002)(508600001)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3kYYMZXqnzPqGzblpIx5MTQn9u5RuzT/3SP+SInibXQhcLyozxCxNGwcaoHS?=
 =?us-ascii?Q?HPcuvjCNmVB7KSZJcNVpid0tzrkokH0cXrD44yDXDPBHS9NXXc32r6V4tA9R?=
 =?us-ascii?Q?zLR4ch9dq5EIGU/HZNp1nNZ5CxuR+/qOjsTs2ViwlIxoK3a/vFk4hu2ZhGNc?=
 =?us-ascii?Q?f+baasWUAA82u0kulaRMdeuJOn+uZBwrCFaiFYuINMzwzOVbqZW1PLebByL9?=
 =?us-ascii?Q?s9mRjFkcZhfM72DE80tTHS+hm6x2eSR/1NOY1t8qx1y01tB0mdWu5UlCz7JI?=
 =?us-ascii?Q?LHb/VfXnz3vZlAPG18g69MBhGZsjwBSwahalrHzMuZfGzgSb19ajMckJs6Nt?=
 =?us-ascii?Q?yA0D5Qer6qSZTJ1QeF/zrzZTROMbIruQxFWn2cInBXJxdAnbyQ8UOPXq24o+?=
 =?us-ascii?Q?rQ4evJ+ahTdy+w0000TqwAr3vlpR65rvinjtDaMOsmlk1KPMjfcTKXamSInk?=
 =?us-ascii?Q?iP1AUU3wb4fuklqyRD2NielhZJhfZju2//Wb7iYQp5rI6MMtYSblb8TqaQoa?=
 =?us-ascii?Q?JiVgmMcrsx+9vdpqtNllAjbA0JiEUdzv+Oo9UVNJcjNxjkbDQCT4BNFcUFQj?=
 =?us-ascii?Q?qyTbU230t2fyoM1AL2r+4t1bTMi2OncJDAhmR5t6VQfbxlFAp2Y7XrrLS4q+?=
 =?us-ascii?Q?4eyXHoKnYAi0SZv7FIAhX569xRQcTK3DvKmdUnoTBkMBaOoZ+xq6Yn4HSrTG?=
 =?us-ascii?Q?b+8+AqVRmORoYeKuu7hmrvq38zWWHjdzKV5kzEdNNfimqdT2PHCuVpn2Wyhf?=
 =?us-ascii?Q?5b2yJV7CeSIB8VoFfOcoEzb7f3ztkttnOycOiL7J47mhQP3aTkgi8s60Nfz7?=
 =?us-ascii?Q?YWUu+95gyc1VB/48rCG0aM8MI1Nxo/XqI1r3bTJAe2+bISvXjD2C5l1PsBNN?=
 =?us-ascii?Q?TsE8FDv80r8aimziaYWm778kFmWhmKs1Y40C3rX424Ts0E8cIZh39UcBnMON?=
 =?us-ascii?Q?ZDwGwDgqXOfb3322Tn1oT/G9XEtq+Xry1mGyi92MTlUW7Snta3gunMC3dyEJ?=
 =?us-ascii?Q?nHpUr7VimSa+v2gix2xtAVrXiPdgwkFCcb3XDJW1ec9M0cASmZxhVcqOA5C3?=
 =?us-ascii?Q?Zlx+nohYPw0asPN9ai8I95mw7upjrkO4CsKE3OZsxbzweuDx2NmAQimwTkjI?=
 =?us-ascii?Q?qaIF/P5Rm5VK3Z97kUp/hSPIcrBFa/t/vnO9xn3fA/7zx4zWxqka63NNlM+5?=
 =?us-ascii?Q?3Mr+Fh2Ni143efqSqiXk6KsH6/2h8qjQ1P2be8hJ7sOpJekbCWFNaI5aqmla?=
 =?us-ascii?Q?+G8LtGTsVzoIb3jmApHMLnqWo37YG0S6lcX/MkAW7vXEHtMsrQUivpqZSQDl?=
 =?us-ascii?Q?xOBZpu/aJ2SIw5lnap5HW8egHl0MbkkB0oBT3fX/B3i37flFyPm9jEf4HwvW?=
 =?us-ascii?Q?Or2aJarN1gutwHhnhtLVoZXxgsA2fWwG8jJTA/O7bm/I4QYuMETVEqsyrSp0?=
 =?us-ascii?Q?fte3u7brObY1mjr2t25CRWqGVv+uxtyZk7PaY2zrxjrEh7B6iNGUZMJYSwCE?=
 =?us-ascii?Q?qDFj6cyehG4HTYzVG+zWHFBcTuxsAPowjDwpzx+oR7SH/yXOgTMF9RsSIIXz?=
 =?us-ascii?Q?IWa9EpLiPgNaFElVwqIpq4Zm0txIwey2B6I7wZmfp8xwv4VmUqFQ4lZHaFx1?=
 =?us-ascii?Q?csz5djswhGkZnxzRAcwDl4ZQfYa9q9gIbxlUt+02YPlsOH1IUgXI9kEyvSQy?=
 =?us-ascii?Q?592lxA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0c5ca2f-7469-4f51-58cc-08d9ecbea90c
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2022 17:56:27.5610
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jtFKk6pYhAnGSPD+zy/qqwy0Tt/Z1xd/dhPlJR1b68f6ZajdbahbhrYKEid+sMKDVWr0iulDf55dm5Wr+xhvtvsTdUafmxSjJdSFPQuwFPk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2582
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10254 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 bulkscore=0
 phishscore=0 malwarescore=0 mlxlogscore=852 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202100094
X-Proofpoint-ORIG-GUID: dTQJ89Qm3EFlpr-lhVmN5GG6WluMXEcr
X-Proofpoint-GUID: dTQJ89Qm3EFlpr-lhVmN5GG6WluMXEcr
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 10, 2022 at 08:45:08PM +0300, Dan Carpenter wrote:
> Is it normally going to huge?  You could call vmalloc() instead of
> kvmalloc().

Wait that would make the allocation succeed...  We don't want that.
That was a dumb idea.  Forget I said that.

regards,
dan carpenter

