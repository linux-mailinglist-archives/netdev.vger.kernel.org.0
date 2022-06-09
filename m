Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE19A545436
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 20:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345455AbiFISfC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 14:35:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232784AbiFISfB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 14:35:01 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2C6D10D31E;
        Thu,  9 Jun 2022 11:35:00 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 259ITU8K004050;
        Thu, 9 Jun 2022 18:34:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=gM3OL6KRIRVG1K09lhYDxL7mgYKt0/qjwdqi1GfpX/U=;
 b=H/YVs/l8/WCQvYfLDjSFFFAUbXUHC8eYUQHMqWnhXIn4nmYrV778J8f+8nlk90QKiSWj
 me2F8kcdyavS7X23gYUGlBv5wx4qmfxv0mVwI2vAVg/jqfiR3qERQ6JlAYOQWsJ5ja3T
 KaDqvT/eDjzaY7EwypZOKsLT1sa90uVcu+7/3+hZwg3+5X9k1ogNUw+LOiY34rcLVbP9
 j2Y8vEa2tDrr2kmc9lKM0n+uCEl7FihIeA+NcqacpmIZnrzRCPHQW2O3tBrT4lrIBWgS
 JgbSAa2OZoQWaLgBYbTbJvEheBZNT19xf/MDA1SpfKsjLR/7XL4I0YZMK0ENWl5zX657 bA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gfyxsm666-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Jun 2022 18:34:32 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 259IUkuw004965;
        Thu, 9 Jun 2022 18:34:31 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gfwu4xsg8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Jun 2022 18:34:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WRS7nYgIvFh9peL/xl38Kl3xAb6c+VXAPClMna20NZ+avqwPD3fyACnbmBpTDFhZ6pxvsW8iFZnsj/cMDXAF901THyg28SIsZzRmIaGL+2kOx0PPkSH16yTpqtUGj5ZfWuvrI4MYlIfRnTFeT6ManGy7UXEKb9DaX1/mYWLS72LAYox/Gf50T9PXTp5GOLBkqyDbDvCZvgxXWEvLXijI5+5ot+BfTshASzhhclBt34G4Tw7iDdaReHJs7rzbaMrezXPAzhlx/OSwQIZOf0TAux5rsXTf6892pDdYIdJ0Lw9r79BtMb/YvvBXbJjTEGqlc8V807L5D3HFong0UkGdVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gM3OL6KRIRVG1K09lhYDxL7mgYKt0/qjwdqi1GfpX/U=;
 b=KzxLFosigb+riDYJpUBlxcgZei16/tsovdeV71TgsH6OjW6SVz1qmUQPp9DZCg/u7z+YYI30odWSbt+vCRZoiVzNxR7aw/qRvuKz/F6IH4YN3+GzFe397OrOkBIWgxhYa3PQS45SWyzuUgGkt6HTZ9rNCTfY21yw133c55nrCAqrCsm4R4nasab+E+tuMZWIoU78tTue31lfAH88Kwtvj0Ycg0jKTJDICVmEU2HR+f7J+zTVOnslyYfwK2y6ohOM40WxeNr0CYyTOSSdLwRzasZ0BHU7GgvFzRRFymMJOM04ugT1RJTNC8B1QYCfrDHUTZek9Fe/WnnsZ04CS2K4MA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gM3OL6KRIRVG1K09lhYDxL7mgYKt0/qjwdqi1GfpX/U=;
 b=H1tcQr9rYQo2kYrlZgYilNd2V5yjlI47+wRTgYXo6PNfHljli86LaLZW4lkS3gd6SBy/CSj1BoqFaLnjXec+GScdKvCom4RdgITsIiuBjNKu2E7m0m8pFulSQU3eynt4oRCEr9C6LkdstHW/Cm/1gFNt/sobiE+XvI21VJT7hJI=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by SJ0PR10MB4431.namprd10.prod.outlook.com
 (2603:10b6:a03:2dc::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.12; Thu, 9 Jun
 2022 18:34:29 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5020:9b82:5917:40b]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5020:9b82:5917:40b%6]) with mapi id 15.20.5332.013; Thu, 9 Jun 2022
 18:34:29 +0000
Date:   Thu, 9 Jun 2022 21:34:19 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Srivathsan Sivakumar <sri.skumar05@gmail.com>
Cc:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        Coiby Xu <coiby.xu@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: qlge: qlge_main.c: convert do-while loops to
 for loops
Message-ID: <20220609183419.GZ2168@kadam>
References: <YqIOp+cPXNxLAnui@Sassy>
 <20220609152653.GZ2146@kadam>
 <YqInZ/KNEJFN9kNS@Sassy>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YqInZ/KNEJFN9kNS@Sassy>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: MR1P264CA0033.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:2f::20) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e39d59c4-20cf-4cc9-b649-08da4a46b056
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4431:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB44310BB59A4AB25A115477BC8EA79@SJ0PR10MB4431.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PEW8UI4ZoOkMh4pMQXPR0nP1vggW4+bSNvyK7Y7lwrIpVNh3zACat8afqrQhZ8r/+2/ndYjbmIn/HZZEIoGw84EObVUM8x7D+tG2zCPGLK0TTwKQohjpg+iVpG/a6s6e+iJi1Aw0lK3MXzz6Ayz07SoBDegz02ynxHy/nkk79WyeID7WKq21UOI4oQTyWT5jLB1Z6x6c+GfHE7nlHOWMbxxNW02+sEldCXpA5AryRPS/a5rud1oltfNTkvwk5m7Ee1CotI/OA/jph2zr1U+W6KUjCG4dU9Kn9Z9ry4uVMRWpC2zR0resyB+y2eX5SeQa9ptUXIuS4EqPIj+t7gohrIaqWBtCNYUOwSBCEjOtyjNlslBDFZknrWBKZZjJACNUZYQhxCvZj4VQztJqoMT6k5AXMSGi1KtG6AVREkTVEYxBvNzWjaLQh9Z39umKcySGHMp3hAz1avcyodgc0+0WKznpKawO3MAAO/kznuFR0IB6XBXReOeR1OkcD/7CWBiBo0N2eTfJ4pEYLLr+PdFgiO6yixBrN4O1pOGqjs12lzackwbR74AfUE1m4dmedlNAFNLIsfQkbcRZytNVWK7RvHONOgq6W98mSDUX3EjHxiitjOd7z+iC6Du2LLVsOXUXUnRsrc/ivQkc/02/weHAfqs9DvsnoBVzLRibl4zlzao+gRI/6OePYIP4UV/jId+jWbNhFjZxn5Gx0f8T7UnJ0tcxuVjNEerRarYjxTVd0PB7vbtq90iYRv/uy0irydLuKPFWOc7/Uf+emdxD1/InfcBJjXdRdtjGs01fOGNI4LM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(52116002)(6512007)(6666004)(86362001)(6506007)(26005)(6486002)(33656002)(2906002)(44832011)(9686003)(966005)(508600001)(33716001)(83380400001)(8936002)(1076003)(186003)(38100700002)(38350700002)(5660300002)(8676002)(316002)(4326008)(54906003)(6916009)(66476007)(66556008)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KqrsuEwXCLKJmupd8QSea44h1IV64ziIdGm+L5M0k2RaVXRwe38XNWKkvbgA?=
 =?us-ascii?Q?aMiASDeJvyeJYTK0Jr5vgOyEfbgCpiJ92pb63mvoU5z/1j7SLXGCF6oSm3GJ?=
 =?us-ascii?Q?708sjDD6sQ8EBcV/7myP2e8Fie5UvMbJ5gF2V7qC/M57mN5LQGpaySpiwy9P?=
 =?us-ascii?Q?QMHz8+jgVuFwRwYuVE5Nq7B9n4Wre2Cs99tzT+H6pWp4Q+hvNUr+yxl52Kxk?=
 =?us-ascii?Q?DRisDALQx9ASSY7xy/YGbZbzt9v2+I5DcgxaydtlZCxHTd4lGqlQtPD+fHO8?=
 =?us-ascii?Q?+rDvSePw9RgECJ2E3UnX51/SIArZ787BgMeYqUXDCQVtocYDC95hpSOlDXIc?=
 =?us-ascii?Q?tP4Ozrg1oORpOCDHaqGapqu6SnNH+SBs02LJLwXGb8ZAKofRh7Y9ocufssL/?=
 =?us-ascii?Q?zhdqqaaySrPPkGrDPqCouXWIrsFCxyELNJ2wb804K0tbhiwM9Rdz+6XSbtdt?=
 =?us-ascii?Q?1eN/OufiUOdbdWlEvli2qd2I63jVRGbWC8piX+obDJxsD6iG/18nM+YyXoI0?=
 =?us-ascii?Q?vkGLHn6NwmTS8GjoIpp9iGJ/Q+7nM1dSb/VS5BAqSuTjKgCZ4X7mz5DHpaB/?=
 =?us-ascii?Q?12Ha0Nn+vKM7VU4L3d2JNwFVfstaFMfgwn6d89uQxXu1u1s/Q3lLEDmBcmok?=
 =?us-ascii?Q?0gixmm0gob9Pep8rGyEJacH/m8JxAzAkLj2jLPiQpQG2JNmCDIstn73F1M1x?=
 =?us-ascii?Q?Vt1CAGZUPDQEIyzYMHvJs+kBzwNw//u59e9vLpHxB0u+6IXUjVYKYwup6Y5K?=
 =?us-ascii?Q?zCwftsvDEqT77OBzl76LRLHc/otW3E3KTFlfycM9OBKsTh7GOw99iWrO3VKB?=
 =?us-ascii?Q?k9QwGUcS6UtOgF0tUipL2ssN7WsqJLvLGLrI7OX4Tnf4TrVVyR4Yirq9XM8W?=
 =?us-ascii?Q?VyRRtzHtFGbzOU9K+EXrlGUSeaQ7stKcHvgRIGJX/QqiUGnXbWRTMZcIl7v9?=
 =?us-ascii?Q?7vT3CA0YkpPl6jeE99mKim+DmSabK+gXYqUlt3VSYrSCGjDebyvz8QFG6FK9?=
 =?us-ascii?Q?X9MXqnAE6IwNlO9KVg72vwOQlO/zcB75T+TTvSj6TC/EHxntL2eQIKxgJu2S?=
 =?us-ascii?Q?551JOAsRqMeavQSTeXOm9K+lRveI8neRKJPsKVAHjdnHG5Yp71kkDzhrrznW?=
 =?us-ascii?Q?oLtvaBwjzS6YGfilsoIa9lve5rPg7TbedMECZM9MwcJ4MRb4oC5gJmWhUT24?=
 =?us-ascii?Q?FzkEjv8sp3aqtfkuxucurMdvYPyuoWXPvAoFnqtroq47LeUb7P4MxXD18sI1?=
 =?us-ascii?Q?EkR2bll8D06FmJen3/gew6Z80rhBGRzCgpWh3I/9wkV+Dg8GcyLMbpoUUchX?=
 =?us-ascii?Q?an+mCPeGSIJNlT7VQcwwOlLQKxFTb2UV4u9IY8LGwhw9eAZElXEXsBTZJ2Bj?=
 =?us-ascii?Q?bi5FrknyrI5S8qIBj8dQrbT9/4PCHHtsuQpDFNYLJqCljYIoLrkgM1jNDvLC?=
 =?us-ascii?Q?NKn57PT7s+Hi4Wi8ZfQLZwykq0CV/4XJApp5M+UWDoqLm7iXbZII/VZMfY+O?=
 =?us-ascii?Q?eyZpnsokM8O44UvEpHVdhmPxI05O7Z2zhY1cvHkipFUopzXH81dd2jenFBIE?=
 =?us-ascii?Q?Y3X/RUmngnjxiahxA87KJNZXDd2Nr+vszG4/lko1NsSWqhr6NDQnAwUgjVtu?=
 =?us-ascii?Q?b69b0Nv5Cfj1bpMmtZRut8upEtU279VhkoML/HzlamFAr+XUG3jN24SV7NM+?=
 =?us-ascii?Q?Ks6XYH8jZU0wdqpg/h+NE5HuHQUUnDseTJNfW+5B+tcAXVhUbPLDGtopODxf?=
 =?us-ascii?Q?fz8n1+0AuP+I6zFMek/bFPcmmm3/rl4=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e39d59c4-20cf-4cc9-b649-08da4a46b056
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2022 18:34:29.6891
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wLGyUFb6SBTe6+76TXhFiVVGOc1qWM0rAnHWRHU7eEELxDV4mbKyLu++4BDrKcvw2P426WgjPLS05TN1upOuAiaZgFtGMoton/NGtikPO2A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4431
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-09_14:2022-06-09,2022-06-09 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 spamscore=0
 phishscore=0 mlxscore=0 adultscore=0 suspectscore=0 mlxlogscore=840
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206090067
X-Proofpoint-ORIG-GUID: aespcrAil7QYI4fKpFL3JsMthPi8wEqK
X-Proofpoint-GUID: aespcrAil7QYI4fKpFL3JsMthPi8wEqK
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 09, 2022 at 01:01:27PM -0400, Srivathsan Sivakumar wrote:
> On Thu, Jun 09, 2022 at 06:26:53PM +0300, Dan Carpenter wrote:
> > On Thu, Jun 09, 2022 at 11:15:51AM -0400, Srivathsan Sivakumar wrote:
> > > diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
> > > index 8c35d4c4b851..308e8b621185 100644
> > > --- a/drivers/staging/qlge/qlge_main.c
> > > +++ b/drivers/staging/qlge/qlge_main.c
> > > @@ -3006,13 +3006,13 @@ static int qlge_start_rx_ring(struct qlge_adapter *qdev, struct rx_ring *rx_ring
> > >  		cqicb->flags |= FLAGS_LL;	/* Load lbq values */
> > >  		tmp = (u64)rx_ring->lbq.base_dma;
> > >  		base_indirect_ptr = rx_ring->lbq.base_indirect;
> > > -		page_entries = 0;
> > > -		do {
> > > -			*base_indirect_ptr = cpu_to_le64(tmp);
> > > -			tmp += DB_PAGE_SIZE;
> > > -			base_indirect_ptr++;
> > > -			page_entries++;
> > > -		} while (page_entries < MAX_DB_PAGES_PER_BQ(QLGE_BQ_LEN));
> > > +
> > > +		for (page_entries = 0; page_entries <
> > > +			MAX_DB_PAGES_PER_BQ(QLGE_BQ_LEN); page_entries++) {
> > > +				*base_indirect_ptr = cpu_to_le64(tmp);
> > > +				tmp += DB_PAGE_SIZE;
> > > +				base_indirect_ptr++;
> > > +		}
> > 
> > It's better than the original, but wouldn't it be better yet to write
> > something like this (untested):
> > 
> > 		for (i = 0; i <	MAX_DB_PAGES_PER_BQ(QLGE_BQ_LEN); i++)
> > 			base_indirect_ptr[i] = cpu_to_le64(tmp + (i * DB_PAGE_SIZE));
> > 
> > Same with the other as well, obviously.
> > 
> > regards,
> > dan carpenter
> > 
> 
> Hello Dan,
> 
> Thanks for your input
> 
> wouldn't base_indirect_ptr point at a different endian value if tmp is
> added with (i * DB_PAGE_SIZE)?

tmp is cpu endian so we can do math on it.  Then we convert the result
to le64.  This is how it works before and after.  What isn't allowed
(doesn't make sense) is to do math on endian data so "cpu_to_le64(tmp) +
i * DB_PAGE_SIZE" is wrong.

Sparse can detect endian bugs like that:
https://lwn.net/Articles/205624/

regards,
dan carpenter

