Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A73153EB87
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 19:09:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235775AbiFFLvW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 07:51:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235764AbiFFLvQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 07:51:16 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C939B27C270;
        Mon,  6 Jun 2022 04:51:14 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 256BfFDH028887;
        Mon, 6 Jun 2022 11:51:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=KKeWb9XGndknSZs6IoOtMf7NJugw7lr2Xl640+sx3Aw=;
 b=SsZh/Bg3uOasDV/Twg1SO1FaNPl8IqbWFA4zqBwHjPEritWrng6IX6gOJrYqMTr3PQ0g
 A2ly/SVYg6yBL8FwkUGNDtK7Rqw51gtwJNyLRMEnTBuSyo9RQFpr28YJ77ziu4Ln69W2
 VW8A1zV3ybhDEs+Tfk/p7npdLpFPjxX4zkwKM55aD4MOYE79eLoIB6jxe4Fwcgtg/XcV
 CzdbUlO5Gz3zo1IVZVjKDflGbFLCgEB4Dtc+8MvJ66WRn+I9Y7JjmgFFvJPZY6zlqHjO
 DJsvTBt5amKsC84RFkcCUSyepy/9cOy04vpBQebknEwWQfjIeKsilIqnmtb/+tLyTqqH yw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gfyxsay83-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Jun 2022 11:51:10 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 256BkO9P031660;
        Mon, 6 Jun 2022 11:51:09 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2174.outbound.protection.outlook.com [104.47.73.174])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gfwu1cdde-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Jun 2022 11:51:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S/yorS6bCu1kOowBNPecjk/OCoSEOmDn/QsRBYxzF4JzFN0C7Gj12mipyKH+xX7AIf2Y3VqpusaV6rKoEpX1ylc3Y4wFKo2FoxYqf5P9s+ul9NGXG1/4pX2aM2cNX3ejtOUyt0DfmZA/QSpDJFKB9/kHCLvBsM4meqUlI/PMtqoDb+mH5yHaavL3B8I8A+n4wmTcAPLau7pNArM2owIYET7FiWh0xh16Xu8RolMwPzaPGjC5hztKP7iqOLaS5pMBygAX1ge1WVqi8SDAlWLx3pxo/n9q6MsioK4kZTd6XzkKwBGg6sRXyaMJ7eZlIE+yWDMGTuG1RPJ/nubY2jeJvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KKeWb9XGndknSZs6IoOtMf7NJugw7lr2Xl640+sx3Aw=;
 b=MZvNOzAoWQv70tUPs15eIUBtvz8RoJyft77pjIYSwuBECZ1Y+8rQE/ceebXkUbOXE6MICiYmnGwCXyJF/ncwb4IcMuuuFgQW/CWYkxKsSOxYBuFYOiErK08h/TI/wFP41FgLQtpdjKRzL2uYHkrHNdNIA0T595qvHKDyYIcdbAbKWpfgmpzZy3gg2xWfTmDOlLxYb4lptcOTBNXBirjxb1zP+rBkVcKlDQurNv22GTwtko8ADk7m5Pd3AfcOikI6TuKjIDe2xc3CTIdhDBeGEyDb/5Ghm0yp5wpnTN8peSY4RBvRzVuOY2PkLxSXk6lpE74pjxGVk4W+fTxlDzaxng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KKeWb9XGndknSZs6IoOtMf7NJugw7lr2Xl640+sx3Aw=;
 b=is3UYJYgzrhF1wnCmvzb6N2+u5nyAH3FSHplWGKPgtVRXO+b/N6z7h7N+O9ZIPYrIMEYDMxBMvjjC3N1hzeWADblWNgYulJwyVzqhX8ppQizhhHQWFRNei6UFVRXhpeZVW2YuhbGCXDtdC/4feNEg+YZcol4FcNICOjglEYKNAk=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CH0PR10MB5180.namprd10.prod.outlook.com
 (2603:10b6:610:db::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.12; Mon, 6 Jun
 2022 11:51:08 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5020:9b82:5917:40b]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5020:9b82:5917:40b%6]) with mapi id 15.20.5314.019; Mon, 6 Jun 2022
 11:51:07 +0000
Date:   Mon, 6 Jun 2022 14:50:59 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Peter Lafreniere <pjlafren@mtu.edu>
Cc:     linux-hams@vger.kernel.org, ralf@linux-mips.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] ax25: use GFP_KERNEL over GFP_ATOMIC where possible
Message-ID: <20220606115058.GV2146@kadam>
References: <20220602112138.8200-1-pjlafren@mtu.edu>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220602112138.8200-1-pjlafren@mtu.edu>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: MR1P264CA0158.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:54::18) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dccdf8bf-d3d4-435a-75e4-08da47b2d7d7
X-MS-TrafficTypeDiagnostic: CH0PR10MB5180:EE_
X-Microsoft-Antispam-PRVS: <CH0PR10MB5180363EBB2B6EAB7D67A18C8EA29@CH0PR10MB5180.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bO6mWvcXXFtN7YY17jlrLY5SZi0djdzc0pdP4opnmXPXVRJNnRwapjh2eqiRFEJikJ1TCbK/OSjU9hw/xK/1E5DF54DJfZSIIYl9V2UcTr5oS91AaLqnwpcRShECTeQhpgtyUTGEIfQl3AMbwQvEM/fZ5PcQ+VBwPIMCJ89oN8HSceAdSKDfHfqdLrnp9HqvzK+FFkJ21O7r5238/93n3yH8TUkTlbC628EbwznolWVFaRwWSamK6VmzZAaT67xXvYqfF/qSsVet90m3io4PnA7DF23pltSrahoPAWjsaR98j8Bxc8sGswgchmCT4SsmEj3UKDjDDr6LtJC2o9NKCJ22EolPdvHPOS0GMoMCoNXOh0t12DwqfgzhHcV+MN8S/Tu1XlxtZOOIakF2VLeEACO68pjEzVyHZojHdjcwprVtmn3ed6s5cJ5+LJqIROaKMbTWPOlupkVxpiEsql5MNIrD8iOfTr+4G8JNvnqvpuj+ImfV3Vjo61/8JVLmJI2eJ643lyMWLNfpAl8coVH8CH9uK7GCGI9wV3Pcdkd85/vcGVTXJhNNWvKoHHnrzB4SBGEmpm4W/+eWPxMhYimTPds6PpwMDArTc5h3ISocTkoWKOyoaVPvvuRvxUK8l75p+Es4dlCP6i0Ob6DvsgNZkddmN15DVdKXFDcO9Xeadpp/y0l/qTeZ1JU0nzxyeBCzuICHqV9Q5JIagieCiOns+w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(8936002)(83380400001)(6506007)(66946007)(66556008)(9686003)(186003)(38100700002)(1076003)(44832011)(6666004)(508600001)(6512007)(26005)(5660300002)(38350700002)(6486002)(4326008)(8676002)(316002)(66476007)(2906002)(6916009)(86362001)(33656002)(52116002)(33716001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yiExGJ/Hv8oZZQ62JvYBTu3x5Cp23EJHjwSgbMvxKukljtBKLkjaFP02W5Ho?=
 =?us-ascii?Q?l75uJfevJdQKVjIWuEwuCYoHwodue5qNu8TUy670B/XFR0oE7ei41ZwCRWVA?=
 =?us-ascii?Q?dNYiQA0GVyF0c/Vi5R5kqjJSUgDD/U8fpg4GWCIYuzCoe/3DT8cOXHEd8eFJ?=
 =?us-ascii?Q?MrTD0kkFx8uePxKbH4Q6HJ8YXuoj0JEr/yGX36rXTTPt9SS8I6OGNHBrvZRx?=
 =?us-ascii?Q?qWiXVY8f1LZAbA2sTGHIfulzxGLjKqCF71xedzTBXM0v0OEUFB+Olih2XDoD?=
 =?us-ascii?Q?YG8ZyHiVPtOgLuQKgYwcq4HBqX19iVGtaGvmQmhojgZDaJJnCuoSqvlnbzub?=
 =?us-ascii?Q?k3ZbGyU31FWlRG7zp00QC1gAvB5g7hvw2/qb2H0IeM4+4lz5gq3sHZJByDxD?=
 =?us-ascii?Q?iG1FZEh9mCE9GkWayP4DTzjlLZqEmMh19NNTspbf7JGzUd4Gfu6fYsxZ7SNm?=
 =?us-ascii?Q?ZSk7kuPShP+FDQ34tVQSLPe1w8oBtnyGU+OOuaeIMvH9C5Ek5iwu0z0lrV4b?=
 =?us-ascii?Q?0CBIl1gpb+fs2J9A9kcETXTxD6m+J7AVkqE7moUL2RuL8O1YdGA9slS/6kDs?=
 =?us-ascii?Q?TSrz9jXgQm9Ql/65RJDXe2X7NJ39SQXCDFyd1c+t5Ni5v2BTEXC9tfZxM5Gp?=
 =?us-ascii?Q?CyiicG1EHD43JGynLcoj5zA8jVyhzugifsjITIXAY6dmhlgCRGfaxIlLLm0c?=
 =?us-ascii?Q?lfIo6/XPH5CWnSS6LTyoUY6XOu317vfJEylt2i4anig2iNAs9VHEbp2+EC6f?=
 =?us-ascii?Q?jO6yizwXaLLKvJYRg8548CG8VTrUsQRIjRBaceS3mMoFayPv7T7v0zfZRhgu?=
 =?us-ascii?Q?c8jFk5WLuFRU2AwDfSUshn/Vh5eHsKB0qUi/7pv0vcwss+fG64THbvmC9a38?=
 =?us-ascii?Q?O8br9jDQzlHRF+T84M8ZCzUf/CmPiVzMlCH5DEQbLmsKSVz2o1zOAxcZ3RU2?=
 =?us-ascii?Q?1dLCXo44jSYJIAQ3ciJWzxh8QXe7nbZ76Ddzqf8Iz5amOGVcp0eZZ4uRrYML?=
 =?us-ascii?Q?0hSAQ7kPLoVh4Hr9H74if1/b7HDQCS7+LPhlHxn8QN7bHGW8C+FYRiJNowm8?=
 =?us-ascii?Q?iTYYf/Q36/YNLVhVukhF/Y/sMcj+LZeeLTZ7OmGvCKn2CV8b9OoU2EdtXSHD?=
 =?us-ascii?Q?YSnPsIqkEoWoM2jb9I5Z70W26n5DMJTKLYxp3WaQ7N+OFvYhlthKKvWSHAAQ?=
 =?us-ascii?Q?EA7g4w5uy05TwFQQtckEINoqt8U4w9DenhSQlrYNEPcAY+BMJ0dbm6IGvtJq?=
 =?us-ascii?Q?EXSgGWfE+AV061WcBVVLYg2hlJ2x0+sgwKtA9Eq6nCEVvzQDozSrPQz/DzrM?=
 =?us-ascii?Q?OW9TCtcnaDDEtoErGmG+JGvfYlLamu2eHhgzKFh50DKEFx5FgwoOyARqjTkF?=
 =?us-ascii?Q?iS8gvzZX1cIISllsNHAJ7K/HfoWdryM0oRAHE9DVrl83gtryFihM4/sk1zY0?=
 =?us-ascii?Q?Wgty5FT3k2fNYKjUSR40cOUJJUaiqtWbnaI4Iw5YOjGNX0OD6yYY7SahSn1U?=
 =?us-ascii?Q?JXTncSitajHAECooOhbplY6Rg9gYUdt6GBn4zMO9FE9Oi9RMjz+bUl0m5bAz?=
 =?us-ascii?Q?cKBz0+O2Bo9fEW+ajk+tuHUknx/OCV4hYxl7HJ8x7mFi177R+rGQy50uYZNn?=
 =?us-ascii?Q?hwFy2l/Y7bBo/7kx3vd34AN5iDDCCQAgEFgndmP66V4iLfkZH1XYSJQL/YAP?=
 =?us-ascii?Q?Gzp1h+6raaS+zwTC7sFZCoGSm73fVIFDhrdkBZyO1Ew56lo86cMSWP6TevoH?=
 =?us-ascii?Q?j7B/PbWOaJODNb8ifzkSmqTYSjvC/Lw=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dccdf8bf-d3d4-435a-75e4-08da47b2d7d7
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2022 11:51:07.9194
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AjiSzj5LVHKmTRh9vmA/kaDYVKTxmAtZGmQ4Wl+ZMLsVlXteDEkqoPWqM2txGxZuwd/4b3jUpcfVFSOuC5ix6sjAWtgLyHqV37ALeTPEbME=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5180
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-06_04:2022-06-02,2022-06-06 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 spamscore=0
 phishscore=0 mlxscore=0 adultscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206060054
X-Proofpoint-ORIG-GUID: OzhG0uPYga4QYW-xbq2vw3zGF4YvzLgn
X-Proofpoint-GUID: OzhG0uPYga4QYW-xbq2vw3zGF4YvzLgn
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 02, 2022 at 07:21:38AM -0400, Peter Lafreniere wrote:
>  net/ax25/ax25_dev.c   | 4 ++--
>  net/ax25/ax25_route.c | 4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/net/ax25/ax25_dev.c b/net/ax25/ax25_dev.c
> index d2a244e1c260..b264904980a8 100644
> --- a/net/ax25/ax25_dev.c
> +++ b/net/ax25/ax25_dev.c
> @@ -52,7 +52,7 @@ void ax25_dev_device_up(struct net_device *dev)
>  {
>  	ax25_dev *ax25_dev;
>  
> -	if ((ax25_dev = kzalloc(sizeof(*ax25_dev), GFP_ATOMIC)) == NULL) {
> +	if ((ax25_dev = kzalloc(sizeof(*ax25_dev), GFP_KERNEL)) == NULL) {
>  		printk(KERN_ERR "AX.25: ax25_dev_device_up - out of memory\n");
>  		return;
>  	}
> @@ -60,7 +60,7 @@ void ax25_dev_device_up(struct net_device *dev)
>  	refcount_set(&ax25_dev->refcount, 1);
>  	dev->ax25_ptr     = ax25_dev;
>  	ax25_dev->dev     = dev;
> -	dev_hold_track(dev, &ax25_dev->dev_tracker, GFP_ATOMIC);
> +	dev_hold_track(dev, &ax25_dev->dev_tracker, GFP_KERNEL);
>  	ax25_dev->forward = NULL;
>  
>  	ax25_dev->values[AX25_VALUES_IPDEFMODE] = AX25_DEF_IPDEFMODE;

These two are fine.

> diff --git a/net/ax25/ax25_route.c b/net/ax25/ax25_route.c
> index b7c4d656a94b..c77b848ccfc7 100644
> --- a/net/ax25/ax25_route.c
> +++ b/net/ax25/ax25_route.c
> @@ -91,7 +91,7 @@ static int __must_check ax25_rt_add(struct ax25_routes_struct *route)
>  			kfree(ax25_rt->digipeat);
>  			ax25_rt->digipeat = NULL;
>  			if (route->digi_count != 0) {
> -				if ((ax25_rt->digipeat = kmalloc(sizeof(ax25_digi), GFP_ATOMIC)) == NULL) {
> +				if ((ax25_rt->digipeat = kmalloc(sizeof(ax25_digi), GFP_KERNEL)) == NULL) {
>  					write_unlock_bh(&ax25_route_lock);

This write lock means it has to be GFP_ATOMIC.

>  					ax25_dev_put(ax25_dev);
>  					return -ENOMEM;
> @@ -110,7 +110,7 @@ static int __must_check ax25_rt_add(struct ax25_routes_struct *route)
>  		ax25_rt = ax25_rt->next;
>  	}
>  
> -	if ((ax25_rt = kmalloc(sizeof(ax25_route), GFP_ATOMIC)) == NULL) {
> +	if ((ax25_rt = kmalloc(sizeof(ax25_route), GFP_KERNEL)) == NULL) {
>  		write_unlock_bh(&ax25_route_lock);

This change is buggy as well.

>  		ax25_dev_put(ax25_dev);
>  		return -ENOMEM;

regards,
dan carpenter
