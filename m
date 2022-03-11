Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5F374D602D
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 11:54:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348042AbiCKKzd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 05:55:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231485AbiCKKzc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 05:55:32 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FA761B5105;
        Fri, 11 Mar 2022 02:54:28 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22BAokT8005963;
        Fri, 11 Mar 2022 10:54:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=IcY6uXCp3/+iW0CzyQbMpAKcNLHHMfWleig6SiaZscg=;
 b=JekMgv5ivfNWkgs+K8jORjucb0Hty0aY2P6wGnpv94P83Y5hTlWq2Q9UswRB8m55H1HM
 tZxr+6j8+JKXJdkNih8jlP1bJJuk5blJWi3tc3Mwpiwb5/cIhiuy8Vn7PQi4VcoeoLb0
 Js5PZI63UziEabH1eoFBVg30fVRpoTOOkUE44bnE7SzQwoijxSVJCk9y15u3EQT0MEg+
 p69lNEmwyfgblbJdI95y3dFh2GZ/pMzGwT4YkoCFYNY9n/noeT8a9CPJV22klXFyAH+e
 4y1lh0UAu+frayc42xgI0W+AefsH+BSnCq1PTaekqx8MoSjPvCYMOIbgRVjIDaunKKL/ vg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ekyrayk0c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Mar 2022 10:54:10 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22BApJJY123665;
        Fri, 11 Mar 2022 10:54:09 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2172.outbound.protection.outlook.com [104.47.58.172])
        by aserp3020.oracle.com with ESMTP id 3ekyp468sw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Mar 2022 10:54:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kAMmP9qBSy8nnE0NFTF/lXGiu2IAMKrK0i+AkUmTeSkDPTEBJF1T3OrCm0LXB211Vu/2mTUE7Ylo00g+6mPvVSyqtCUlFMxCK/ElrCivFlOLMutnFg5EwGTMuhsktAiUygTvbmEhC10xTCOegz/aosCZq8w9kXfIcGnzgNodBkNqXaH3s5pqoKoAOXDH7ZQAzN/fF5qh4kL4KEiOFGUOyE8Y2e9Oz6BBPXeg2c7DsRcjQ9jib3M8gwbjO8/Pzb/5V4D3AuVGfUz5tPX4cZKQdEHQKMfTVxAA0lJGLuUTAdUhBAg3yUlrkL6GwS21NlnerTk8exEuL5QoQdp6zP0VGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IcY6uXCp3/+iW0CzyQbMpAKcNLHHMfWleig6SiaZscg=;
 b=hYybU3z4hkvHbClk/fJ2dwykR21BoBH9QuG+Cw9jUzwG36SPMLfnr89rPqcVG0+Qk+M9XVPk+HJQtsgI+HDbGzKG2VWXa08UjlArFSM7K3ABXO4ml/4P0kgoBoxIcqcjWM3fs2AWYsOJL8U8s//Hx37PRTlqFpn6HdHEwW/S+9CpQ0VulEHKngMcj4f3dot+vABsLjWJOSSVCEM9ZqLoGZnP58KZwsbh3EPgdJiABOTFIXyUMJHmjjl38o+BJ2CY+OSsJx5LLoW55fLzCipTSFKA6VL0iUhYR7BL8UvOwQSHw+Vwaf43efb0nii/BwUvBSad3upEAXy+W8Sx4J5KVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IcY6uXCp3/+iW0CzyQbMpAKcNLHHMfWleig6SiaZscg=;
 b=iLYZWfFt1MFbqijTsNzJ9yeNtQrYlyZXl5oAbkjh6QhGW6pMvp5xcVIO8Fyzpo2/wGDWzB32tXWzae4pgQddTixzPnGYtQzkgRzkCVz67pc/dUaya+QlyBBdz+BBXp2CPXmCylJp7B265FRdNoEKA2NrO6yZmwrvdnHi1nYugLs=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by BN6PR10MB1620.namprd10.prod.outlook.com
 (2603:10b6:405:7::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.16; Fri, 11 Mar
 2022 10:54:06 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::2c3d:92b5:42b3:c1c5]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::2c3d:92b5:42b3:c1c5%4]) with mapi id 15.20.5061.022; Fri, 11 Mar 2022
 10:54:06 +0000
Date:   Fri, 11 Mar 2022 13:53:44 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Duoming Zhou <duoming@zju.edu.cn>
Cc:     linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jreuter@yaina.de, kuba@kernel.org,
        davem@davemloft.net, ralf@linux-mips.org, thomas@osterried.de
Subject: Re: [PATCH V3] ax25: Fix refcount leaks caused by ax25_cb_del()
Message-ID: <20220311105344.GI3293@kadam>
References: <20220311014624.51117-1-duoming@zju.edu.cn>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220311014624.51117-1-duoming@zju.edu.cn>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: MR2P264CA0163.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:1::26) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ab1ff1b8-6879-499f-ee9e-08da034d7691
X-MS-TrafficTypeDiagnostic: BN6PR10MB1620:EE_
X-Microsoft-Antispam-PRVS: <BN6PR10MB1620179921409415EC30EA288E0C9@BN6PR10MB1620.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yqwHpytemXV50SsFlba9YANYGN/bBMx9xxDjZuOHwQ34yy1pA3cgO9cw7lbDivcXwNPNto0VFVPdQYcaBudOIIFJ3a4ER4lG25mXQWP/7ZP/Fod0rNX0/RGENEpNJQZbWl8uiIwaAMyB73PBULEUK/4JrqG3c6v5LmsQwA7h3T8xkZslQHvsPoKsKr4JUScM51mwXxgLVT3bqRi98C4xaLGvPAtc+LetMzDkFOZdl6qj6qUREeSXLwVqkq3vtBIb0V3Uto/enR0szHml4qZFnnrWY3sFrWfc/q2r+Z67lgl0pwz5PPkHw8gc1HVukK1nDFq9Hct1pOcJjjlj0xyairXt3IJehS/n878cUWdd4Rgsm6A139XszSXGXWJsmXZd1xs8DUhyy0tPiJ+OvEY08tKQi3F3q75Pip7P3n9JzyDMhFVHMF8Ehaf7Y2J9ionK7JlJPd8VnaZIVMVmi5Um69VqB6Kfw8vHYk09XxK0GxztSqTqa31JZOBPrGLk2fZ9gA4i0LmeAPhtmfGaQKIfZ1FUWRRWEq7U8Jt9HBHpkL9AjdG99nSSXcwQ3cnNPuEU71lMCZMgjI+1b0TCU25nBHZjDJA74KzTKfRacVuxxdAjR3t79OOXU0Hsn7khROoBp8N1kWZXpdYMOHNncsEJARBEwmADPDX35bMdZfc2lhwEsBmMxKfJf4VMj1PD+Jxj4CBSDt4MOtZy/3sMsF8JXw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(9686003)(52116002)(6666004)(6512007)(6506007)(508600001)(8936002)(66946007)(66556008)(66476007)(5660300002)(8676002)(33716001)(44832011)(6486002)(4326008)(33656002)(2906002)(316002)(86362001)(6916009)(83380400001)(38350700002)(38100700002)(1076003)(186003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UuAknb4Pm02zh2EmzDjkpB3FNskiKbXSGnD7AzgAL7Cl7cxOwAjJX2ShwsC7?=
 =?us-ascii?Q?cYPqw2XJDZgny+XP8y+9wmz2G803CRsp2geFDN1J7VvFz3ZJka5QywhbFk3y?=
 =?us-ascii?Q?BTfw4bphY70/BfAr6dZss0oEvB5TiNC62bXW3ljNzn4gL1kk33KAXLqNJTGY?=
 =?us-ascii?Q?8ukLKKUbLTeJWnqb9RHrosGIqrKBd60zgfBrDrsh6PG6pF+Ne3//QHBDYXSk?=
 =?us-ascii?Q?osNtVjllqLDNLIh//VOGPAIyXE9uBrGaMr9AB208Df1rEryzd+huUKQ0F0PH?=
 =?us-ascii?Q?7jeS/pY284LqsDk8fko3OwjJbgKCJSCEcTB/ZeZADY6yWQ8L5KRh/WKtnP+1?=
 =?us-ascii?Q?JNQ+bChQPWoZrWDJal2HeTENg48OM50Qmo6LirBotxLkhaK80Sw8GN0Annpe?=
 =?us-ascii?Q?8igGrZzBQZxxxge2wRCsqpY9imNYOgKhQga7kqqwFMQxi+XItvMaAJI9per6?=
 =?us-ascii?Q?erzLZ3rpCL+Jq/wdtJRGylRAO5zvmDWLcpeLPJ2JLN9KNBXmC0/N5BADmD7M?=
 =?us-ascii?Q?vc/e+YDm53jTQYDfIoQMEAn+x7tAxDWbrB3cIN1wjaAAwGJwXdBJ0s791DjS?=
 =?us-ascii?Q?JwnyQs+YLiOqFXYjR8lJapOg90raVX4c30vfw8nZ3H3owxQRPq3XFXvGX0dG?=
 =?us-ascii?Q?2sBxDbqQ5xKHmyYyICznuW4D4BQioCK/A6lCjVADM4REZpZS0aUUFeVus4Ap?=
 =?us-ascii?Q?AG+Swr/sq77ofbrWFSBeBDEH+hduJZcP2olW6j0S/FO08QggqMvRQf6xEiy9?=
 =?us-ascii?Q?BjjJRYxE98ZVVOpr6qScfUPsJiwqLGTz6dCv0VvnVHGWvnaZrCLzDgKQapAL?=
 =?us-ascii?Q?l+T+NE/ZRvtQ8rA91PAKZvabiTOSWld7VCrJqt09vINRrM2z4vLy4oXKmdfb?=
 =?us-ascii?Q?2KezPdbqzx3X8PM86dvpfUGdfroMA06dhhW/rUn0g8TKrVtj1Jo7rVya9K8D?=
 =?us-ascii?Q?bluvrkDA3qk4jrlZeVvLu4G4T9VFXAMN2xSqHrBx32mXytHxqf+Q32TSA5Qv?=
 =?us-ascii?Q?cVcjQRwJoCI7Vh7AF/UTnoKUPg4JhCOmAqI+WTYuET9OYuhwfXFRK0+r895y?=
 =?us-ascii?Q?XcZaaK6ZyRNcJ3NVrqq/s3+jX5nG8vei7S4s6Kvo7xDa6shoZVkGoGqWK36n?=
 =?us-ascii?Q?nJlGjDxZNeachc2Qz7DjupZ61zjiDt2YVPNE3+sJAQaREXtmGu6/HbRuW+m4?=
 =?us-ascii?Q?SLaq0whbJr0nKXS9Pb39eCTIngAncjHGfO6vbzG1GODlvBhiHlJDByf9V1TJ?=
 =?us-ascii?Q?okTE6LWWw1yNOhSCOyaBoWflTqZEjlakvaxmSpnuSucp9mw6/tOOF/d9Stq+?=
 =?us-ascii?Q?jQy2wPU0c0xNRp2NCvTcsIAcmaKEhmvLku7iPff/EtKYm79/l2nrGHx2//EW?=
 =?us-ascii?Q?0nmbDlteYzBj1gbOXUXw9k0uEGgtmn8/TwAcNuVoduwo6oNZiQfylvh3+r/J?=
 =?us-ascii?Q?oR/eS5AcBqYJUAokxcqyYsXhvxhQ9UfM+DmhoxRF4Cshfp6dIbNjJYsKOOtz?=
 =?us-ascii?Q?gjmeIgM+tM8VNzipTIVStNwwbDEDrMBCDKL3482S+Ra0FNZIBp33/zZTAxYl?=
 =?us-ascii?Q?SmTIcYqtcTw+YyHO8ewrieeH1FaHLA8bUHW9pqDNsOMgaB8rzZ1tzb/Jst5W?=
 =?us-ascii?Q?frIU0c8kGf3RQxbSCt8kbeL/CwWUGxErti6DZvO4jjuXymt9+ZqWjls3nUjC?=
 =?us-ascii?Q?UjzhZw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab1ff1b8-6879-499f-ee9e-08da034d7691
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2022 10:54:06.7049
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kgOW842GphL47NHqbgEO1Id7eqtgWhCHERLPs1PK0x+2fHn78Hn8b00+p5Uciik7HFMYVDUoLAjvoNCfMLZmhNyBglh6lCiDeGZgh+PWKS0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1620
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10282 signatures=692556
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 mlxscore=0
 bulkscore=0 mlxlogscore=855 spamscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203110052
X-Proofpoint-GUID: YvQWDhbymeqNcLkoqRCpC-U6jShowyVC
X-Proofpoint-ORIG-GUID: YvQWDhbymeqNcLkoqRCpC-U6jShowyVC
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 11, 2022 at 09:46:24AM +0800, Duoming Zhou wrote:
> This patch adds a flag in ax25_dev in order to prevent reference count
> leaks. If the above condition happens, the "test_bit" condition check
> in ax25_kill_by_device() could pass and the refcounts could be
> decreased properly.
>

Why are you using test_bit()?  Just use booleans.

I am not a networking person but this whole thing feel like adding on
layers of cruft.  If refcounting needs a lot of additional tracking
information then probably the reference counts are not being done in
the correct location.

> diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
> index 6bd09718077..fc564b87acc 100644
> --- a/net/ax25/af_ax25.c
> +++ b/net/ax25/af_ax25.c
> @@ -86,6 +86,7 @@ static void ax25_kill_by_device(struct net_device *dev)
>  again:
>  	ax25_for_each(s, &ax25_list) {
>  		if (s->ax25_dev == ax25_dev) {
> +			set_bit(AX25_DEV_KILL, &ax25_dev->flag);
>  			sk = s->sk;
>  			if (!sk) {
>  				spin_unlock_bh(&ax25_list_lock);

Why can this not be a local variable.

	bool found = false;

	ax25_for_each(s, &ax25_list) {
		if (s->ax25_dev == ax25_dev) {
			found = true;
			...

> @@ -115,6 +116,10 @@ static void ax25_kill_by_device(struct net_device *dev)
>  		}
>  	}
>  	spin_unlock_bh(&ax25_list_lock);
> +	if (!test_bit(AX25_DEV_KILL, &ax25_dev->flag) && test_bit(AX25_DEV_BIND, &ax25_dev->flag)) {

The comments for ax25_kill_by_device() say:

/*
 *      Kill all bound sockets on a dropped device.
 */

So how can test_bit(AX25_DEV_BIND, &ax25_dev->flag) ever be false at
this location?

	if (!found) {
		dev_put_track(ax25_dev->dev, &ax25_dev->dev_tracker);
		ax25_dev_put(ax25_dev);
	}

But even here, my instinct is that if the refcounting is were done in
the correct place we would not need any additional variables.  Is there
no simpler solution?

> diff --git a/net/ax25/ax25_dev.c b/net/ax25/ax25_dev.c
> index d2a244e1c26..9b04d74a1be 100644
> --- a/net/ax25/ax25_dev.c
> +++ b/net/ax25/ax25_dev.c
> @@ -77,6 +77,7 @@ void ax25_dev_device_up(struct net_device *dev)
>  	ax25_dev->values[AX25_VALUES_PACLEN]	= AX25_DEF_PACLEN;
>  	ax25_dev->values[AX25_VALUES_PROTOCOL]  = AX25_DEF_PROTOCOL;
>  	ax25_dev->values[AX25_VALUES_DS_TIMEOUT]= AX25_DEF_DS_TIMEOUT;
> +	ax25_dev->flag = AX25_DEV_INIT;

There is no need for this, it's allocated with kzalloc().

>  
>  #if defined(CONFIG_AX25_DAMA_SLAVE) || defined(CONFIG_AX25_DAMA_MASTER)
>  	ax25_ds_setup_timer(ax25_dev);

regards,
dan carpenter
