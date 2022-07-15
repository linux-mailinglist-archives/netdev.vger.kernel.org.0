Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 049C7575E8F
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 11:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232400AbiGOJ3P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 05:29:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233196AbiGOJ3I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 05:29:08 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2152DE0B4;
        Fri, 15 Jul 2022 02:29:07 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26F8uvZ3032725;
        Fri, 15 Jul 2022 09:29:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=6gE3/fXkJ6NAmmI2bqocoPJ7CdZyJU8KIo2RZRPHN9w=;
 b=kmlCyXzYQOEw1zVl66wOnn807FVsUz2B8N7tahF0H31NOPDqFr3S0H/IxaLGxYxDksEu
 4NZ4SYYHPsp6FpkFtYoMJzWRDBrGEdZ3EMZQ77uEv2gFVXEnUceKDCN8zLQdyLreA83f
 9Xav+mBI+BPcWE8YtG3h7AaLXmr6A8CBToOB3TDu+tAyFvV00jnsZs9Z9qDy9Z4lLN60
 6oOs3vamYv/6VSLFyLLacssIsQ7UcBTIUxsXzcHTXwJ2ocDGnvyHPS7Wytz1fK29/gpY
 eK+wlTQj11USm/RbiBlCduQjTQ5QU/ZJ55vl5kQqTJllLsl8zONt0gByYuLzFyy3L3lq xg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3h71r1ewx6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Jul 2022 09:28:59 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 26F9Aic1005970;
        Fri, 15 Jul 2022 09:28:59 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2040.outbound.protection.outlook.com [104.47.51.40])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3h7046gg33-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Jul 2022 09:28:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JYAr1eLsJPQQJqMApNXHJvGsRdPfk6WMK9k4QO4pW5o8iYUjWPvV2d/3xJIGF6Ne+dMzHMZaBoYYsW/bknjNPlmdfnAPrANnrdubhzbybXyX538ztZw/kRCYMD5xbvJFXHdDkTmV/78OeCjHokPpQXAi8iehgYgHzeuPn1zYOExJAswSPgeNpw7gxW287DoQ4UVav7BpHe8CB8CD0NHMR2uT2/EhdwYeG3+qPRDO7D27yvoBfOzhpxgayQG8eQWHyLC7I9m1+uSW93g/uMjjiwL1yZ3HbdEn9QyrFr2Y9foUFWlsshod1z7WyY7Bi/DmljkqmHpLOifTQYgkq8UPIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6gE3/fXkJ6NAmmI2bqocoPJ7CdZyJU8KIo2RZRPHN9w=;
 b=j8LHnOlNbtYVO+s5aoe1vHK2mUf6QCfajxnTvqIVeTvxXtScz9rtaSnpQuFasMnPYBHsUqpqjJ7a7GAK5tPYvm1/smM2Qust4oJumVFQVnsWHqL3q3Pe5hSOLfKEIiCK3sdWOiR/cIzgAh9QRB22QjT2zLis4AekD/NydKsXgx2WUCmQFAFjaghKM4JLanTx2pFJzROb8D4J8G8+WRhsJQh9N5CPe3NGpNQcRAkUuw3ElYvirKTGX2xBHT17wd96hlZInLJYaz2DsWBBeGRT9YPgAin8tJ7b/gbOGLTfZSKd4He5JVqvPPjbAMntRL4rzUfhlH5tRoovTUBS381L3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6gE3/fXkJ6NAmmI2bqocoPJ7CdZyJU8KIo2RZRPHN9w=;
 b=Fm3mvhcMKzcvINLrvKEPtEJ+61uUdUzRTjQGttUJBb0DHCbqf+fpYmJvwKAVM7t/F5sjd7P+HNwZTHfUoYS3WiZ4bKR3ArwwIO64GwfPncgL3iSlX7GOIP4P2oNNlDNX39Fd3jA3bMb5YBGWtxOvkfeOVvYB+JH1qj4WSZubJQA=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CY4PR10MB1318.namprd10.prod.outlook.com
 (2603:10b6:903:29::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.15; Fri, 15 Jul
 2022 09:28:57 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5020:9b82:5917:40b]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5020:9b82:5917:40b%6]) with mapi id 15.20.5438.014; Fri, 15 Jul 2022
 09:28:57 +0000
Date:   Fri, 15 Jul 2022 12:28:47 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     binyi <dantengknight@gmail.com>
Cc:     Joe Perches <joe@perches.com>, Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com, Coiby Xu <coiby.xu@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] staging: qlge: Fix indentation issue under long for
 loop
Message-ID: <20220715092847.GU2316@kadam>
References: <20220710210418.GA148412@cloud-MacBookPro>
 <20220712134610.GO2338@kadam>
 <1d6fd2b271dfa0514ccb914c032e362bc4f669fa.camel@perches.com>
 <20220715060457.GA2928@cloud-MacBookPro>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220715060457.GA2928@cloud-MacBookPro>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: MR2P264CA0098.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:33::14) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9001cd0b-6e40-4fec-8a45-08da66447151
X-MS-TrafficTypeDiagnostic: CY4PR10MB1318:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eSBMqCB0M8Kkv5PEQ1N4ErD37QDNhwdImfz14bzfOQpEVekzpWPjAQRVMjL0uaS4pMdpsUwqCiLqVA3cHDLDJaNlt5aivuvTc/0Z9IMKnfLJnexh5Fn3RCBDABZrP2tST5Fslx5FDX8Qu9cIk5ii6GSbqZ6/6KqHa2dDq1i817HpJWnVhXDVbdqrsQdJ3J8fH+pnlsTK2yBFghQMDtT/j+/sjtgz5dDaL9L7c4SXJoumQV/Mvf8VRnQBidEZ595VpnE7bHjalF+9u2KBUw4YwVlaCBiQZbzNyrNgRx2+oI+Nd21dF46cfOKMKku375DKGZA4YS797Rqa8oQResgZpleGNqpFhxQjyQ6KIcD1Z3z412m61SEkdIi3c6k9sYHUVU1rFT6XUOOgklnHRQzwu71a/foHDB+fAEev+kTtgmLk6ITndyRMWpM2Yk7Tel85wg7fGqM18QNAQHH2QKshwPnctPa624p1tn96tCRDIN6Cg/Cnf0HW69u4fHCiLDuk8mlSVdRTb2Ce64yfwaH5spS0pmGY9FSJweM1URKctpuI1ftN+Cy5mYQaSxVkmPbUXne0Uk+fS5wFGcmafxoDFGKcB5bx7upe+H8izbdCwwOeuEYPjgRiKEK5amjLZnKXQAOFoHZYdVqh4Ifh9vQZKUxuYU4TnfsfV+h40MsxycNHCm35mKFf/THP/UuX326SkTer8nGjo4c+xFuTvorGAGkzqWGePQYMDQqjGFoIQzFBiWI14KeR5D4edA3D7t7ynWg4gTEhwQBYhRC4jGwudTtPNkn8bg2nnq6gCiB8Z9zRpalmn3JW2JW306VPNnSn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(396003)(376002)(136003)(39860400002)(366004)(346002)(8936002)(5660300002)(33656002)(2906002)(6916009)(54906003)(86362001)(66946007)(66476007)(4326008)(8676002)(33716001)(44832011)(66556008)(316002)(6506007)(1076003)(52116002)(6512007)(26005)(478600001)(9686003)(41300700001)(6666004)(6486002)(186003)(83380400001)(38100700002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SjZkZ39o0zjxqWc6G9Q3Q6VfKIMWCVrpUS8VBTDTjuMoX6GPYX3dsMhZCl/g?=
 =?us-ascii?Q?yO7YN0/ca9zgXKTVAakxnowWNAfg0VtXesV7EHNKQmxH7esafxkWBnXj//ut?=
 =?us-ascii?Q?mRa/K1zpTafow7enJ+AhrWuDCdp5e2TviJ0QpddKX/hkmOmDNDjNw+ynBDHc?=
 =?us-ascii?Q?R0k2qVPJgEAvtnKqH1bpSozFNXVisxQIqoFwyZbvoNIok9tGxoDLKQlWiCyF?=
 =?us-ascii?Q?KqSN9RNtvCY9sw9kRB55HvFImDNijiIETuAkbVsxWQFG145Y/Zsxq20eDDNg?=
 =?us-ascii?Q?AxZsM6bRRW1hWM+m83ES1PIsP8nkNWpSX9LYr72X7H6yLScF2d5MnupecPer?=
 =?us-ascii?Q?URpwJXSTLt2hfxpqO/gy4rsti82AAUhFVPUK/4hWJaTLSDxvKvC37wl0kLVr?=
 =?us-ascii?Q?qss7N01Jx30p3XELb7D2G2TeDUIfafCJoj6BCMrFT+JGk5HOPP+c2NYU836E?=
 =?us-ascii?Q?2HhPGNfhExAdBTsle2JFk9ul7RfBcuk6wngsjlBnegzermZi8hEjzaU9S3a4?=
 =?us-ascii?Q?3u2EPQ5M5YRVwVIxC4F4CQ3XHwRSjhA0+6gd/puf0oJT//zZuAmCePSCc2vm?=
 =?us-ascii?Q?oc6yFPUNR0n2tw8sMajSP9J9O1NGM363yjRkEaSJvfLqmDHwDEQG+cvc1oWS?=
 =?us-ascii?Q?X0IdTgxnr2wEs4bqpEovIlwHBvrHDmy4L/Zx5S6A/0dKo3rYCsIuZ+xCvzkR?=
 =?us-ascii?Q?pYro3O/doiFhAUi6+FLeekseH83FoIXUCtId4JQiwk+t4ACCbge4x//WZwva?=
 =?us-ascii?Q?YVIEFgHtKZhC4mKnrumcSGlbpwSUVUxJZ5e9IJziON+eQUfdfIcSQBIQWp/T?=
 =?us-ascii?Q?YtohaJZeL24agP6lUdfxpysiCvSnFdNHmNIjma5K6BbqfNccueEdyH4NT7yV?=
 =?us-ascii?Q?Aml1Yils7V8YJS9jzkru+v7hwzmHJmgInUYD0TRD/giDKyKbnq6WO1drQYEI?=
 =?us-ascii?Q?VAqoV0a2Yc9RdhUWW/k725PTNTwZZqIx0cYtcZ7wh2khma+coSR5LI2+uGt6?=
 =?us-ascii?Q?dbOJz8qX2LVmCQxZ/VELMuvNSyTBa1JGkKDsciWJHImYtryK8cigft3rROXl?=
 =?us-ascii?Q?cursahMQsCPEiyvSC85/m/iQ7MmgZVhMp07WgSMVzxqiVrnQpChT27VHQB0S?=
 =?us-ascii?Q?8HacKx2yXRop4/4DUMoAAkaH+z/7YKdiShRxW4EUxHWRzBcX5E0650GBU20s?=
 =?us-ascii?Q?n3YXHTwK51cNs8JpVcUHn06F6ZDdGQ20zTpYU2YqeZDTnaVt40sSXhjW3jUP?=
 =?us-ascii?Q?DHblvuptqllsFh1TmGalKsoiSQ4CUPF6X3ehaYoGpxiIgb6S2T1cmzshbgP/?=
 =?us-ascii?Q?z+VKxLyVF3RJYNQepAe4QIKJeqlknMRfOvc0V8b9uPt+z39pLbJFjnhDfevM?=
 =?us-ascii?Q?dFmHt9RPqPCNFIZ6kMXQefmqhfG8pN1jye8/AoG2spIXOyzcSEuqdJcs4kY4?=
 =?us-ascii?Q?tZrRX0Be4E+R95hIXMl5gCL6/K/qix6d3K7O94nytshhSO75rYq59B3BZL9D?=
 =?us-ascii?Q?3suGwrploedyBp2ZrcZeJFZAlaLRK81dvKAS8psa1tVC/yzmwSXRjraaBo9H?=
 =?us-ascii?Q?yKa33Qaxk5VBav9tCmjrB7IFjIqbRcmGJ6Qk/uUbUpGcBXz+mn++m7VKF1VC?=
 =?us-ascii?Q?JQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9001cd0b-6e40-4fec-8a45-08da66447151
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2022 09:28:57.5074
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: losszNnB+osTZfwz72IUV2neQsZnUIp+DoXJkFrIXbtWhCzvHYTENbX3t+SGXvikkuc/C999OPESC8uV9tdFgKnr4z5qWSgM5jCaK3UOYmM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1318
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-07-15_03:2022-07-14,2022-07-15 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 mlxlogscore=895 suspectscore=0 adultscore=0 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207150040
X-Proofpoint-ORIG-GUID: GTzj75gADcHa4YHr4QgrSK2XCy0x9NBF
X-Proofpoint-GUID: GTzj75gADcHa4YHr4QgrSK2XCy0x9NBF
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 14, 2022 at 11:04:57PM -0700, binyi wrote:
> On Tue, Jul 12, 2022 at 07:14:55AM -0700, Joe Perches wrote:
> > On Tue, 2022-07-12 at 16:46 +0300, Dan Carpenter wrote:
> > > > @@ -3007,10 +3007,12 @@ static int qlge_start_rx_ring(struct qlge_adapter *qdev, struct rx_ring *rx_ring
> > > >  		tmp = (u64)rx_ring->lbq.base_dma;
> > > >  		base_indirect_ptr = rx_ring->lbq.base_indirect;
> > > >  
> > > > -		for (page_entries = 0; page_entries <
> > > > -			MAX_DB_PAGES_PER_BQ(QLGE_BQ_LEN); page_entries++)
> > > > -				base_indirect_ptr[page_entries] =
> > > > -					cpu_to_le64(tmp + (page_entries * DB_PAGE_SIZE));
> > > > +		for (page_entries = 0;
> > > > +		     page_entries < MAX_DB_PAGES_PER_BQ(QLGE_BQ_LEN);
> > > > +		     page_entries++) {
> > > > +			base_indirect_ptr[page_entries] = cpu_to_le64(tmp);
> > > > +			tmp += DB_PAGE_SIZE;
> > > 
> > > I've previously said that using "int i;" is clearer here.  You would
> > > kind of expect "page_entries" to be the number of entries, so it's kind
> > > of misleading.  In other words, it's not just harmless wordiness and
> > > needless exposition, it's actively bad.
> > 
> > Likely true.
> > 
> 
> I agree it could be misleading. But if "page_entries" is in the for loop I
> would assume it's some kind of index variable, and still it provides some
> information (page entry) for the index, probably page_entry_idx could be
> better name but still makes the for loop a very long one. I guess I would
> leave it be.

It does not "provide some information".  That's what I was trying to
explain.  It's the opposite of information.  Information is good. No
information is neutral.  But anti-information is bad.

Like there are so many times in life where you listen to someone and you
think you are learning something but you end up stupider than before.
They have done studies on TV news where it can make you less informed
than people who don't watch it.  And other studies say if you stop
watching TV news for even a month then your brain starts to heal.

I don't really care about one line of code, but what I'm trying to say
is learn to recognize anti-information and delete it.  Comments for
example are often useless.

regards,
dan carpenter

