Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3E304BDBC3
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 18:41:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355760AbiBULEf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 06:04:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355930AbiBULEQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 06:04:16 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D81B53191C;
        Mon, 21 Feb 2022 02:31:45 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21L9dIlP003629;
        Mon, 21 Feb 2022 10:31:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=5LvdDmSK4lesCN0UiXXknbmCx3I06BJgdd5gvEN8rZ8=;
 b=jmg8R0TWnxVVUesw88kVX5IDWHcGv9nGVwvqCifVI5KdBo5ay3ioTuAZ7gSiFe7elCwn
 WfMQWHUm/0rjbTHPjIWO7o7qmTfumi5ChPKJfJm5eiCmFH5V5a8tscSdtuniLoBzbUl/
 9r+xlOAj0aZ5thpxYRt90dPIE11Ilwe7Td+LJaAzNE6u8rlyOj9ujYPStLZ5StkmB8G7
 1N0glJMiUQKT+Ebw58ItZzVt0QQ1i0EiyoQIyxkB7azI6kpDMST29ReV220wR7LDFCxG
 rYlYqZqAXK5l5M6t+xWqPXdxa60m3fK2vsYHtIWGqEqQmgjxOCy7hyNKnY8DT4r8JLNo kA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3earebkm8f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Feb 2022 10:31:34 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21LAUfug026766;
        Mon, 21 Feb 2022 10:31:33 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
        by aserp3020.oracle.com with ESMTP id 3eb47yh68w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Feb 2022 10:31:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kdXcNclhtH2IQw5u5i8YOQvG6fOgJP9zOo5SZ8klS8g31UoIMczxroH9DEYFQEj08opnTJZdcPLkjp9FYq3ymh/NWZrduLKqZK8A9z5lGdurUz0snCF1TbJeKkhaXVv1bwz9RDzAo+L32QzhUT0P+jdp9qJDcq+IQ+AwfPalg2Hjk2T0caNr0Eo8nvgfEUjQ+mNOE+6c/0EcztZ5zMzr2VUavl5IoY5+mcJwtTBnETzvtnmwfHT9qF3gsKeH24RdLWtz/NRqQP9uL4McWvlgaOdKCmNhlaJNP81Hd9vsfSm2R4RTNMf+D6vVh+5CZN0FI8zoXyYtijx4icHQyiLcyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5LvdDmSK4lesCN0UiXXknbmCx3I06BJgdd5gvEN8rZ8=;
 b=YQIbaH06CwoYUHQJNffFu8Jrk+PJCBp+uU91kYjtZw3C7J2bJJdMqchxIrEzk93iFVffYzcCLgGDOh5EaS3bhhTe1vwthpGLQH35o0KFd4dXZ6CfEFTeMHcaLNTdBP8hLiilfg/vBrcL1l6wXXAGPboX9rBjqk6qpptcWbiGPxKYxMqFu2ARWoGpyRpzd+ayLCgFbVb1BodKrAp06PXT4IIJWYmpsCXxgEgxKv6QBHwsIT7MyGBD87tGyn1rgfXgVVAbnTAEmtNmM/FN8eVQjefpaIHo4cyC78IC4qLej7WWkzRjqmlEXnO2nDFh0HE6/7sjLe6UHcTM3vNaCw2+9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5LvdDmSK4lesCN0UiXXknbmCx3I06BJgdd5gvEN8rZ8=;
 b=ErC6na8ceu+wT0DRtRaZ8v+ZqE/1vJVWfkeOR3P1w7I5BhIBGwzLlPAXuaD8lKqsjMO16Ca07+8JVqWQ/wT4hFSDBpm7oo/VEzQU5zjc56oNj9dFf6MuuoolLEGMWtkngs2d3yMjDsOG+51B8QEl7VwKYrJk6QrMKJSoonecywg=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by BN0PR10MB5302.namprd10.prod.outlook.com
 (2603:10b6:408:117::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Mon, 21 Feb
 2022 10:31:31 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::2c3d:92b5:42b3:c1c5]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::2c3d:92b5:42b3:c1c5%4]) with mapi id 15.20.4995.027; Mon, 21 Feb 2022
 10:31:30 +0000
Date:   Mon, 21 Feb 2022 13:31:15 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Joseph CHAMG <josright123@gmail.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] net: dm9051: Fix use after free in
 dm9051_loop_tx()
Message-ID: <20220221103115.GC3965@kadam>
References: <20220218152730.GA4299@kili>
 <20220218210712.32161490@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220218210712.32161490@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNAP275CA0040.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4e::17)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 154c2f9c-a9d6-476b-b1ea-08d9f52552de
X-MS-TrafficTypeDiagnostic: BN0PR10MB5302:EE_
X-Microsoft-Antispam-PRVS: <BN0PR10MB5302D9A9E7E547C923FE462D8E3A9@BN0PR10MB5302.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GWibXIZPQszVPwUdZZ05X5ErR6//uIKq4P34JkkIV0pSBOk8Hbf5YM8+xWSV+z1ubesO/NJZOdJCHuLAKQJeN7QkWySup6hQK16Yg+yqgOOix7bR2xF6Q3RPHrzHLTSs3ApCcggFL+FNBlyO21/6Lc7ZP+U5UJHmzmJjoCKpqE/WMKMblPacMwwjQZe7VbeTlKNVORGGljMjRYUtkSNOP4/RFd2E1mIPbYBOztM0zbtl5zptd5q/gzs3Bk9DzpVxNShz6oV5WQXplu9Lj/f0/Cto3uls9XfB3c5Pwgpk6S6b1dciERwVxIeaKsWb9f4Qj0NRMz/imPgPDgYVxkejIUwpbpJhfGxNzVS77Oy8zp/M+Sta59/5gVqLiR88yaeb25jsjlsuJB2fd7B5qvBZ98Fb9Oxh71p47Acy8WzevUB4AVt7vo+SWwB6kRnTL47jUBsk2ePYeiss2mdn/WNzCvz4MukVIWn/e9hWJqlLimd9p8yla9NhK6PnZ2pa4a3oAYoAu3H/44p9Dtzw5vnrq+jUZM2xRy/nRV9xjrtiDjaPbZRiwilddnI3GxopZF0+eH38a3uTSyijFIC3LqnqOgqzLRyZE3V+upa36IDUwqKqk5xCS28z+/7fLGhftI0K1sDxp+EPk04TYsRQMjzTdrfsaP+WuT/9X0tdJhy75r2Dxg/VNRuTUfpJu3Ym72lzFvyyA9MfZm61RPC8C2K4PQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(33656002)(316002)(54906003)(6916009)(33716001)(66946007)(1076003)(2906002)(66556008)(66476007)(6506007)(9686003)(6512007)(38350700002)(6486002)(508600001)(38100700002)(5660300002)(4326008)(86362001)(26005)(8936002)(52116002)(44832011)(186003)(8676002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BafviRordpWTR6aspZdvzCXTSseGlrCGz6bG/8EaHvfxvCUa/d9ta33JujoE?=
 =?us-ascii?Q?K8lbEDWz4iUUfTYC0AiwSB62bw16sZYvoXbpUlqsqQEhWfrcfOtVVG63xwIM?=
 =?us-ascii?Q?NqKNYppjOgTxXmJd7G4dZRD1eK6q8sr1SMahnTwBd6R9XWisFv9FuWk8M6Lz?=
 =?us-ascii?Q?JAWx05MLRWE++TNAI5ebng0kkow6tSPjrXcALS5+zAvKWRQ/T2Jwjx7se66m?=
 =?us-ascii?Q?rAV51YCfTEeLybMJjBmau8DBqCRQ01RTIqW7q6Awv8ME4zZwyrhOISKaju/n?=
 =?us-ascii?Q?/DmDaXUjAIf4uPanSoCtsbFngQjmxschHX+DVw++y7casei2Uf8ED+DoEVAl?=
 =?us-ascii?Q?W6/CU/MTPuPjD/02V66HqXvt3nWc9uoWcq5oEkyXF4LUiK3AJ4FVLjs8HeWn?=
 =?us-ascii?Q?viz+lZbY0Mx1gMlW3f4T46BBLit7Ltj7eGzBIGJWtob1ku0CwtSd/GFnf37/?=
 =?us-ascii?Q?9x6vFxf80UVg9fGu4n4Wq4VU5iBPS3G+aNcHxWgLlgAVuegxHziDw/r+EfQa?=
 =?us-ascii?Q?bHvfKrU3h8Ffiu+RkmfGNCSwjGJbka65+x09yr7FwN2Jf2JgwYeYRaAlTQNW?=
 =?us-ascii?Q?uZHs5VDCdWuYJZvIANgTtEndmaSZ559NP33LFhyFtq2RZKmjIvAbWBj9I2N7?=
 =?us-ascii?Q?1Pft1N1sQl3rhQtytx96pihtt+YUQyq5AiJbiQzUYq7O1PCswrb27yv+jveG?=
 =?us-ascii?Q?n0OqmIOhXAVWlG+r5timH1JzvJrtY1sZhvP4d29N6Yl4AFzLFAb7iexZoruB?=
 =?us-ascii?Q?TKSSVPUKFh64dYUEm6tkIgJU1aqoHXmmnHmDqU6uHPa8PpbeWc8iyLAA/LPJ?=
 =?us-ascii?Q?UCD8xlCckmS+nYcIfmkGC4+9tvHtiA7tezGxxqi+7pk+r263pcB3HO/X9bwN?=
 =?us-ascii?Q?XVjcLyyLreALVZE5uJyE5TC0DxRxn4xPrRk2wHcYXJBnlJtzUFRzZ965R143?=
 =?us-ascii?Q?wXNAoZ4uoNwFdhP4vxxiR2Xp3x/cBj/GzGPbPoU1hr5Sf/PJLYo1pvuQKt77?=
 =?us-ascii?Q?WPvTRe6gdOoRVYHrtCNSzSikzGL7ImRDDzmhmAjpzsSXi7Kj9LZrMUs7aFdV?=
 =?us-ascii?Q?hdtJs6ZukABIgRTjZw0vwdpD8wV7YAqTQ47g85kMoTkgCQigH4lpk8c0eXfb?=
 =?us-ascii?Q?k3aLh5PervROtxMUgsGox8vivL8ROuQpcHZt4q6DwOmDfMOrCan/7ZZmXH1R?=
 =?us-ascii?Q?S5Hq+XjpLkhwQ0iHDVKxtKhmuUOvopRhbMCMwDlrxzvXlznXSI+tCLn25ZhV?=
 =?us-ascii?Q?16QBBtdm2JKmQKfb9VPp7iNAZlAtcxQ8JcON0mgbXjFG5u2X0OzGQdImLrk2?=
 =?us-ascii?Q?DL5TdjZ34eJYx9rdicY7UrCkeV8y0Lz8gMxVCvbwCoNUsJVRzp1bUGuS4f/n?=
 =?us-ascii?Q?mOl7bkU7ZYuSJnEuqWMC9voRYiQSPRE7qNs+t/1l5gTqqtjyRGi1Exx55rNW?=
 =?us-ascii?Q?I9rnBG6jmxNjxZRHzmW1pytXrjyoa1tCkwRtM0mgmn13Yb5UvxATDRL6/l7/?=
 =?us-ascii?Q?zNtgvlyXCIogcXuZLBJwKvmPZkz/KNbzVQzmHzDynM/ULy2+7PkDyjlVEZO1?=
 =?us-ascii?Q?1Z/IGJpMnPXcXJD5FcRZE2hMu4AYYALv/qqZk4APBtehiQu/WLDfz4DBqNUT?=
 =?us-ascii?Q?IQMao+5BsKZIRw45Y/80y80JTPGbCXcJDWS7enE+KoXCo/Fbt2vkimytVnSE?=
 =?us-ascii?Q?Epl5eQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 154c2f9c-a9d6-476b-b1ea-08d9f52552de
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2022 10:31:30.7400
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fX2VXAQ/fFkAQwp6iveYi55fCoup3LKigjqzqaSPDyV5taLG4Cmw0WA4ZW/qbhsZ45C/CJYlfC/UADEkMixXWzbTKJJZ0mWFXwRB6Rff9HY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5302
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10264 signatures=677614
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 phishscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202210062
X-Proofpoint-ORIG-GUID: EBDdfl9IbftyD2hrM7gjq_jFNSRYMxrD
X-Proofpoint-GUID: EBDdfl9IbftyD2hrM7gjq_jFNSRYMxrD
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 18, 2022 at 09:07:12PM -0800, Jakub Kicinski wrote:
> On Fri, 18 Feb 2022 18:27:30 +0300 Dan Carpenter wrote:
> > This code dereferences "skb" after calling dev_kfree_skb().
> > 
> > Fixes: 2dc95a4d30ed ("net: Add dm9051 driver")
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> Thanks!  Although..
> 
> > diff --git a/drivers/net/ethernet/davicom/dm9051.c b/drivers/net/ethernet/davicom/dm9051.c
> > index a63d17e669a0..f6b5d2becf5e 100644
> > --- a/drivers/net/ethernet/davicom/dm9051.c
> > +++ b/drivers/net/ethernet/davicom/dm9051.c
> > @@ -850,13 +850,13 @@ static int dm9051_loop_tx(struct board_info *db)
> >  		if (skb) {
> >  			ntx++;
> >  			ret = dm9051_single_tx(db, skb->data, skb->len);
> > +			ndev->stats.tx_bytes += skb->len;
> > +			ndev->stats.tx_packets++;
> >  			dev_kfree_skb(skb);
> >  			if (ret < 0) {
> >  				db->bc.tx_err_counter++;
> >  				return 0;
> >  			}
> > -			ndev->stats.tx_bytes += skb->len;
> > -			ndev->stats.tx_packets++;
> 
> I think the idea was (and it often is with this kind of bugs)
> to count only successful transmissions. Could you re-jig it 
> a little to keep those semantics?

Sure.  Will resend.

regards,
dan carpenter

