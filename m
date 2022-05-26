Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B53DA534BFB
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 10:49:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346820AbiEZItr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 04:49:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346802AbiEZItm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 04:49:42 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACD0EC5D8A;
        Thu, 26 May 2022 01:49:40 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24Q6TUP5019140;
        Thu, 26 May 2022 08:49:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=gp8R1iDlNHe3KhfyxbkD7LcxRWOfrk8kRSnvpwqyIN8=;
 b=N6L8IGIQjj70heLtzim+83fHGJYaf7iolQ+j1fHsIMVe6yTX4Z2rs+e9X0OwqP1vXlXY
 vpbzP2AzQAa7brjfiuHpDYiqneAqVKsnuE94DPGZUf/33q5SguvgBrnhibhxXj3ouRYC
 FbZYEjW8YMHpU2r9MjraHLa1aSyfQ1voYzFFXDZ4K7XOJLCACpfXwooPKfsECOE+g4Jg
 9LGFqgrmfFKmQAszdvabOKK41hSdnx52iq27W4+E3IA29qL9MsvSTOIETwVTtv926K19
 C/KrBDAOrEaVcYtpBIlvu2cIgqDjw+hc8GvhJUXldVXJi5jDAZiOCrFKWAnXcOtLOHFK 3A== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g93tavart-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 May 2022 08:49:01 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24Q8gUFi016249;
        Thu, 26 May 2022 08:49:00 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2102.outbound.protection.outlook.com [104.47.70.102])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g93wx4qe4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 May 2022 08:49:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HqnPo4eTIJG1ZN66gA/oAbADwqQ0ro52smLjPdNH93ctAhZaxHY7+fxaRDUQ7Nfagm22JAzTEyv/c7BqJ2LgpdtNXbHtcQ+I2vmR4HjSTMTUURK/wApd9QpzgrkCGzToJmFSoxvgDvhsGaPjnuxdnkYX9Vyu+N7sKFKMh7g+PzVU8TdMTyOaqxLoMCIJ9Auvc5ILBZQL0BEWCJYHwyQ2eFEdvBk9J3Y+eddIvfObi9v1/K9ny8ZA7ASG6CmtobJjZtB9Ze8d8Sij4jz5YKvixSC6ZuJ8UYwuNQNL31/sLVNaAqKyvrAEl8XcDgtyzlo3tLOx5ItE/81DMEv+Fmo0dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gp8R1iDlNHe3KhfyxbkD7LcxRWOfrk8kRSnvpwqyIN8=;
 b=cufX3CyEu4FSJtUWhhDztdshOErtPgv2LHi+IZteqR10kEQQmPgcWfAwu9Rg6EppT29ruvEyezzwJbPZqBkKzHLWYbzHGoSvklmptauLaSbDArbhChaRb7s2sgShz+iT069CpUvqcYzFT0MBz7PuRYppvOiZakR7UiHToJXApX2Of+4R9jyqhqsd0PKsFxLZGL+TZ/QzgX5lEXBy9Jr/ZRsS6yxCnGOCAVloap5B01+a/M0qU2ApE4gWG+pLllPqnLgoAzyAqKkjxJ0qK+bJJhZVqKUapzXWFYmtz8NVoI7gM+LnDEQzulJSY6911dd12mm+8EFCQcrAw87ZRw6x7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gp8R1iDlNHe3KhfyxbkD7LcxRWOfrk8kRSnvpwqyIN8=;
 b=zA7uTSM7vGs6q9/cXznfrrNjkPuYpoq7bTjDA/asYOifQyu+b+jNaKCkSNbJgMZDHqq1xM67r5yMrpAxDZNoQUH604ve84deNRjD8DWaSQdPhzn58wPTelg3getWcycYnRDELdgCvWP1WpZI7sH/HAE6yTQRwJlkWydWrlCGqpo=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MW5PR10MB5763.namprd10.prod.outlook.com
 (2603:10b6:303:19c::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.23; Thu, 26 May
 2022 08:48:58 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::86f:81ba:9951:5a7e]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::86f:81ba:9951:5a7e%2]) with mapi id 15.20.5273.023; Thu, 26 May 2022
 08:48:58 +0000
Date:   Thu, 26 May 2022 11:48:32 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Jessica Clarke <jrtc27@jrtc27.com>,
        kernel test robot <lkp@intel.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-staging@lists.linux.dev, linux-riscv@lists.infradead.org,
        linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-parport@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-mm@kvack.org, linux-fbdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, bpf@vger.kernel.org,
        amd-gfx@lists.freedesktop.org, alsa-devel@alsa-project.org
Subject: Re: [linux-next:master] BUILD REGRESSION
 8cb8311e95e3bb58bd84d6350365f14a718faa6d
Message-ID: <20220526084832.GC2146@kadam>
References: <628ea118.wJYf60YnZco0hs9o%lkp@intel.com>
 <20220525145056.953631743a4c494aabf000dc@linux-foundation.org>
 <F0E25DFF-8256-48FF-8B88-C0E3730A3E5E@jrtc27.com>
 <20220525152006.e87d3fa50aca58fdc1b43b6a@linux-foundation.org>
 <Yo7U8kglHlcvQ0Ri@casper.infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yo7U8kglHlcvQ0Ri@casper.infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNAP275CA0049.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4e::12)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5a8480aa-9787-4c8a-788c-08da3ef49261
X-MS-TrafficTypeDiagnostic: MW5PR10MB5763:EE_
X-Microsoft-Antispam-PRVS: <MW5PR10MB576391773DA5C21D153594AF8ED99@MW5PR10MB5763.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UnbmCcXN+b9yKw5ZKUKBbMf6H9DfeTElBOvndXSm4DAUuxQVbLVzcuMg/VQVMhI4uR1vJr2F4nhcuOld5h8QHl6AWa0aQFKJp/jwfoV7kkCT9m8OWUnxCutWPP8+hkA9DL/tkhyKL5RGdAtSW6XFTuQCSwPGbyNMcbdF7OtFgSLZPDw1guAHgSDAYJvPMUYTFBPyutWHBwGYKZECcoWtMYl5UGnz1XkUy6Mjn0RmMrNYPp1fWG7EErO38RqGzPvPwcB6mBNgEvi3qM+BynK8zFNpVyJFmy0HMfRyFtXr8aslPnlgl55wc3HvGLlw7s8yp3z0Q6IxTDu7ZuHNTGOSMTPUXcJ/XHMJehnocuiVmUoOol1y5zUYOVUq01uD5bwo56ilhNuRGYFtrE8s83gcZQsYCYaEuim6tJ1oTBmupUgLEMNivlgxNr/0VuRZ2GS94LlhzoPsFzQniZEGum6ek3ItKc+tAgVaTReLEIm1cs2EXYpWXpyaGK1Uc0QOwaIt+9s1xvF4Zc3h1nw4NYpGY5F8ay2C6KMWTU9IiDD5wpPt9B3CI78V8m9iRJhJmwbwofLa2I/yjcBzR6xoI7ePgiMO+zLvPDlN4BDf3kYN7ccDRpae5f+cv5hWbdP5nQrCiZk+nWk/F8btCel7BwyQrWMPOzrdC+Ptoy161eCiQY0BrT+kFyhDmjd5AEZE1gsc/ZOOJiGqVeOOmfXOc04KPg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(4326008)(6666004)(6506007)(86362001)(52116002)(66476007)(66946007)(9686003)(8676002)(66556008)(6512007)(26005)(6916009)(6486002)(316002)(44832011)(54906003)(508600001)(38100700002)(38350700002)(1076003)(186003)(83380400001)(2906002)(33656002)(5660300002)(33716001)(8936002)(4744005)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zul1lsNQxRYiON0dY2cqMQzZ54UDTG5679WWQxeHa7rPVVQR64+7MLmsArJ1?=
 =?us-ascii?Q?V8DtoKpFqTyOmZ91wPaLJl0XYq2gCE3rsCsJt9rjh0W+dKB1iTYkND2ZFoq5?=
 =?us-ascii?Q?R8hIxgQTfJmpx3n+ES/ww5L6k4TIQ+T3M/0WUP7l6ZRkT8QxHyToqLj7dTAo?=
 =?us-ascii?Q?3nPPvPPMUGiezucB2KD2+MVxC/Evg2IiTxvhwWIjDL6xjswQm+oYUkd1SB2d?=
 =?us-ascii?Q?DH7SJuT9qyteKKYhrdX+8rBj7eY79DRqQeN7Zw6MIF9y7AsEQtoZgdU0QhbZ?=
 =?us-ascii?Q?mDy+yvismRjwwItx0rFfrBpbl3Q3a3PJn1zetfq/0Fbi4WMgiJ2Kf6CfAoT4?=
 =?us-ascii?Q?lv/LTdC8EWqwQJo//4yO9dMPdsJN+qJFHXf9Ud8s89uQMcVLgwC4k09pqiel?=
 =?us-ascii?Q?TuMb0V2P5AEMoMHP/cQ3xpKWnZoj8jdYa/WAjsDXKi6oK7K/ihSPkRiP4WLa?=
 =?us-ascii?Q?JDdR4Y2YxoHYUaLmgaJQKY8LG8lXr/Ev4DUw7mbPMw9jojttovb8DTwGlJLZ?=
 =?us-ascii?Q?yTAnILfCdCFNQKJfgLQbB4Pvjzu9GOMB+FSZEVt51SeVMcK8g8QTmT3bpBLz?=
 =?us-ascii?Q?zWt9Kn4Iaqwe0q2vGxio5utoblFHgWPhSGxoGf6ZGTcntnYYiqVz5krR17RR?=
 =?us-ascii?Q?ut+hNW8mqMx8E+deOOvkrDophMsqjg6LuDyBdqW7yyX2aX6nrHwb5mQIIe2L?=
 =?us-ascii?Q?9kOhg7NCjtoYfQhvRmY7GKS7VSMwRqJ6c/5hFehiq4RoYiizva4Pb6gPWfjn?=
 =?us-ascii?Q?Oz99vMNK+eObEujmH5TYNVvzOfkSB6247RwonXerDAVP/vUvpTu86gGSONOB?=
 =?us-ascii?Q?j5f21mBYF89zfMQ5VW/alhN4BvfCr2oCs6hEa1iEnBQHF+Nur5ztYpcDlDrv?=
 =?us-ascii?Q?fkE69bHEHs+esn47WDFEgFQZHvlFBnPTa5RAAcH3iSE2YK4YMYNGoYwBlQ33?=
 =?us-ascii?Q?oS1mpB6tXi+gYZCqqqfhhSot8xyNtzqpCxqapSXu/VYFJbcH4c2GYcQJ2UVO?=
 =?us-ascii?Q?/xGuxFJB12ACp6Qiq53iNSrxgMo9hdpsNBb/TIDS3AstLEyNpjvL6OAhG4Cj?=
 =?us-ascii?Q?sPE/tdDbc2Fhi8csgma8+Y9ecWDtkKTJePdgBvd3btpWmFsWiA6FeysPqH4K?=
 =?us-ascii?Q?GH+ll3THcizly2pKPx7+ml56F2+PuNCLeqCdS6ksjfyCkPH6Hso/1rgCTUI2?=
 =?us-ascii?Q?P+y1kdG6H5SIJWzKLFIRA2jj5p5x2GVTNv6aLjpO3cjTBm+txrhoUdDkYQBI?=
 =?us-ascii?Q?4wAuOTp9I56ZRF6l6Icy1c06LD6GX/ayc6ax/8DlINa9HzBzolFoNLdU6w/a?=
 =?us-ascii?Q?iyNYFQvNRWImEflUD+nBby4JhxbWUEDBFXX0EqCXTPhyktPSBDRCUq0OAgBp?=
 =?us-ascii?Q?mhB3vAYCL1UKzpyiLS4i213YgRaexCYLHsAAY8BzeqoW3M+J2cLasSeDmNQ9?=
 =?us-ascii?Q?WBLxjdmVO1tEgppjU2Wgxp41pzE7GS1xCWEitctgPbSvuSJg3Q+gBqwRMXhI?=
 =?us-ascii?Q?fHaC9tVpTktAzFndfnuUZODjQZmH08t/QrVEcRUlUE5chVFCy96qqxmtYNst?=
 =?us-ascii?Q?1xv5idClHjZueKJjxsaWhbAFHEgFRKrsDNgBJR2L0MGC93TOrX+nZSlvqtDg?=
 =?us-ascii?Q?Hlxs0XmIcheOQnEU1HNcE6PlR6hLN6S+74DjafzGCH5w1hwb7dBQcOqs0R98?=
 =?us-ascii?Q?qSV3a0f1casEiywUq/o47EJrZqumk3NTxMndu6HlU2o3cWD77FjftQR6zF4H?=
 =?us-ascii?Q?fo8mtMSFEft462iXQk4LId3Yi2Wdfqw=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a8480aa-9787-4c8a-788c-08da3ef49261
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2022 08:48:58.0774
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F8TVMs3YUkyp6UIcO4oQn/Bj0riPTlCb/HWarErHHzM8QLxw0hYPwul3kslzgCRAHW7ZN5hydZ9iR2tljAPmM0lL/x5F1sRaVlzcL2mThjQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5763
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-26_03:2022-05-25,2022-05-26 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 mlxscore=0
 phishscore=0 spamscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2205260043
X-Proofpoint-GUID: Yeg_fN2H03I3-DgomnM61R0bKPzI993G
X-Proofpoint-ORIG-GUID: Yeg_fN2H03I3-DgomnM61R0bKPzI993G
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 26, 2022 at 02:16:34AM +0100, Matthew Wilcox wrote:
> Bizarre this started showing up now.  The recent patch was:
> 
> -       info->alloced += compound_nr(page);
> -       inode->i_blocks += BLOCKS_PER_PAGE << compound_order(page);
> +       info->alloced += folio_nr_pages(folio);
> +       inode->i_blocks += BLOCKS_PER_PAGE << folio_order(folio);
> 
> so it could tell that compound_order() was small, but folio_order()
> might be large?

The old code also generates a warning on my test system.  Smatch thinks
both compound_order() and folio_order() are 0-255.  I guess because of
the "unsigned char compound_order;" in the struct page.

regards,
dan carpenter

