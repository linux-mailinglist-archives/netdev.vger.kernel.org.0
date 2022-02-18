Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 539D14BB8D3
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 13:04:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234863AbiBRMEd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 07:04:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232329AbiBRMEb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 07:04:31 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E18921E1A;
        Fri, 18 Feb 2022 04:04:14 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21IAR9pA012876;
        Fri, 18 Feb 2022 12:04:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=VORmXRm/C/bHZNSgGTho6cWg3rhX086W+oYQTjaKFfg=;
 b=BaO+w0WQ2TV2k6wcBCzQnpS+im1vx+3KbENoZSgeUmGJuaOVGrJkMcrahUoItsNm26mt
 Y7tr07/24YabwvAZHRbw7+GLSpW4vJfQeW6i4A1rkTO05sJOtTAaIaawjhU2PvvzBKiD
 F6yzCsgX4FW7Wn18gaeq8Xbrdbr4EUBP4zkmNaM7HGfeLucanshUaoApvONQbtpnKh9I
 b8yvZTebCUuqiw/oaV06ulWLVEyaAydA168zy6URzajrNgIhD9DHjLJGZisHliZrMhdd
 tiWO+JbabqOFHu/VKloUrgnItN1GDzSipk9CbTuU8vFFCEFctR5Lh8oepcL5KHxy336K 7A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e8nb3rtgb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Feb 2022 12:04:08 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21IC0GYO052249;
        Fri, 18 Feb 2022 12:04:07 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
        by aserp3020.oracle.com with ESMTP id 3e8nvv6a1n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Feb 2022 12:04:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CEK8Q/LMBdmuPlEfuRw6i3YDmFT62efFdtkT2MHY+Oci2Z4wK34SLA77vgUh/0dCIJTqmEK/F+ml6JEROo2SXkaXofGfqkvFF6s3Bzu+CtYpU6srnGbrV/4cV+PSZrLbRK+NUhufDwvNuCp8Df0LjMQPlH5ZzFYe+tQoTwZblRtiGUzzMvJ7kuEPo3TrNeYYO9hi15HtszfwRuJSz9jCdNBP+NZGkcFUU0pYzj2kBZ+Ht9ZTYZM4OAeYo98OcbgdKRzCMg+adPobevMj/Z99tZjWijgk9vXAofQNC7dzoE0Ve6pv9I36WS6lgr1TfUMbwbHjjv/5IcL1dSBSNL0CEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VORmXRm/C/bHZNSgGTho6cWg3rhX086W+oYQTjaKFfg=;
 b=E9swgtmUNn9IYX2PqlrkKZ9PARAfwQUykHE4dSG24JbveWSkNiRuH2NLd8Ts2aLJTXcy+Tpaj4MeB4stPEcuXP4PYp/EhAlXsm6R9qa3gtvP+wr+OidXlpLPJfj37wiIFd8IxcWkojGQpKb3elt51jk2lD+LBg18u0lEjYqnR/ziFDSHp41rVlUt58/P/9osFjr6sX+NWXiX9yrS2q3/m9MELObFtqSdeyHEBAbT/SGgbLf8FBJd3NOYw3kXgKhE7R1LLu+MSzG0TqyDbuUFk2oowDUkg/nLV9pqwR8E2AT9GvB54O5G8K+hctQKI3KCbG1XrA7WKQexX5in+fBY2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VORmXRm/C/bHZNSgGTho6cWg3rhX086W+oYQTjaKFfg=;
 b=Ngk53lFpLJkbjdKmA/17euiIcHsAXiUX0zkJ1Iqchwgzf6ukPFEAWjdAXVI8QCCxepabWhcR+wN0lOoqTHwDBmDIikmmbkjmsils1inuEdfJU1GKrc8jQrNmuSkkAm0yeqblm322Fd9Nhy9BWtORuBtQZUOmO8H4TmZ+xJRdC8Q=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by BN0PR10MB4824.namprd10.prod.outlook.com
 (2603:10b6:408:121::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.14; Fri, 18 Feb
 2022 12:04:05 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::2c3d:92b5:42b3:c1c5]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::2c3d:92b5:42b3:c1c5%3]) with mapi id 15.20.4975.019; Fri, 18 Feb 2022
 12:04:05 +0000
Date:   Fri, 18 Feb 2022 15:03:44 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Hangyu Hua <hbh25y@gmail.com>
Cc:     manishc@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        coiby.xu@gmail.com, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: qlge: add unregister_netdev in qlge_probe
Message-ID: <20220218120344.GH2407@kadam>
References: <20220218081130.45670-1-hbh25y@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220218081130.45670-1-hbh25y@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JN2P275CA0045.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:2::33)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 340cb458-5946-42b3-c3cb-08d9f2d6c269
X-MS-TrafficTypeDiagnostic: BN0PR10MB4824:EE_
X-Microsoft-Antispam-PRVS: <BN0PR10MB4824415610B367BC8B85B1FD8E379@BN0PR10MB4824.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F4CqLQg5E0AUFVU8zCsugh2QuC+ItNbyCs9+nFMPhYRJTTL+GdusfA2cUMWdbmm6Rxmv0w9z6J9OrMMMYSUTJgHEXpWDZO4DbKQ8weJwh4LkpUq3VtlOh6IH6ICOZaJB6Cr0uuqTF8Mbi+SxZrRKnFkZuwZ9BTMoN4lJIEda2ynEcVYGRIYNSfLtfBEnq7+SizkySF1YBgug3vjRMBFVfgSiZod+dfGaCqNE95OgcHtu0AT/OTrhuXfcSSIAKXnQw2oNvyCvfJLjVR9nVsJl4ggjUIaPC0bqBUB7wZZW3+LXjaTAAIDy+aGlmWBmmQnLNAT+K3v81bJjjRdCjmZVHtF7MW1Zy42k7K7OaxvCBLHwjKoHTJhbTssw/uYde9PNC+ikvgQftXj+C/8bD9GA/RsquzLgX++Eg7n2ijZehKmdostO020O0WDLHQS4qBHxGu4/RHi1jL7M2CvueoD6nm/nuofSMK5v+2hz45R8DdxdaOUXmhEOqFGVUR0LWu06ydKg24ByJ/a7mVTQyMfHlsMqHr4AHHSou8m6wsMSlCjPP0KRST/N/TsrBsmAsmGasaNxcSWZaXcxVXhyZhjPZvwr0GRvANR5bDJs7jUdFYgUJB+IOjrOxsIowOIHyEFRQZeq7pjuDU93Ro39T7aZgUfjT2vHebcATS5Bclhiy6/kDLWPpgGuuR/+BTtca5olUm93eh2ZdCriEb06vbIOCg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(1076003)(33656002)(66476007)(66946007)(83380400001)(44832011)(4326008)(38100700002)(38350700002)(8936002)(86362001)(8676002)(5660300002)(66556008)(2906002)(316002)(508600001)(52116002)(6506007)(6916009)(33716001)(9686003)(6512007)(6666004)(6486002)(186003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hBkfix7/YPdCU9dgNzjhThCJgC2NLHD445bfzYXXalSzBFQMWlQw7fBInVu6?=
 =?us-ascii?Q?PUM63AHLtsvZzpNtLRxENlEGl0l7qCDk2Dz5LnNExF8JlTAiFh7o59XvBHu1?=
 =?us-ascii?Q?lIDinw8517lqC7X7I5BSZ+2sZGtdZPp3/QnH3DD6B/FbsL94UkXGTJ4p9BoK?=
 =?us-ascii?Q?97KoahWmn4xHyENgoazb0RgbSSgrtFtAnLd8c8q4OfEobGu5+dZRMtDSIRik?=
 =?us-ascii?Q?aHhatoWIwZkvehnMkfaL8iztd7FT3iu041f+RdgLe9qjFizf1VA8kvUkM7mO?=
 =?us-ascii?Q?kVvm4qcyw+c/hWPctVU5kbZVMXd7YffSYo8C3MRwIihRXR253rqdDFTEsv6V?=
 =?us-ascii?Q?nLKU5kXWDffint1OM8kZjqePPnlYJ4aR+VtH1AiIxxHml+srb/L8jr08aOPV?=
 =?us-ascii?Q?LA8xXt40zx8CFUCirjPH2p0SXygq9sfpLyjLmnlrvXzd1YqeC6mwi0xhT42y?=
 =?us-ascii?Q?3SSaHNNlgVhP4VX0xlyYRFSoFcuFTm8d4gtdwCWi2SKt+Lz4doxVJjGajSyK?=
 =?us-ascii?Q?iBAnnEx6vNAxqwtswNIcNbGC8dufVrsVpAjeorFN42Nd9RKiOq7HAjzkmoWb?=
 =?us-ascii?Q?4c89RxeNz/3s/nZ1j7Z58R8Icn2a8Fs9udy3roXCsc6DcOqfh5wkM6iINSzg?=
 =?us-ascii?Q?C3zj5J0Jf1rHAwrVvQQTZw9EUklcU36IkOjI7mNvQ65U2tIHafCf7G/EBfj9?=
 =?us-ascii?Q?PjRkzo/XY5cZgJ3tcAsUrxh0Q1F7Hw08sF+TN4piyDvFb3pyxNRxHFT/F1mW?=
 =?us-ascii?Q?S5O0QM0o2E8rqb1BHgtF+2Q5R6+FrwFvQqN0IxUxwbvTNVEtgyxqy6LkemNJ?=
 =?us-ascii?Q?hhnXCWV8kiSVtQvV6AcLU4Qcx56g24f4+tSkVBGDoQAz0dHEknjM4qkEkB3q?=
 =?us-ascii?Q?S7ZtdHPn/Af0wgvw3hqrvgO/4g1mbLKXV22csBRPBKHNx/ijCRDwZ+xicXvh?=
 =?us-ascii?Q?FT7wv2REhsBCJItb9ks+thMZj+Ekz3RMf6s9B1Nyxa5PIs2RFLj0BhYodaBI?=
 =?us-ascii?Q?o/w2OX362ZJxwShfTFj5PkQSrcs1/Ur2cCa8LcKDAnTJcDSMtdQ73U+7dO4k?=
 =?us-ascii?Q?N5aPrWfjAcocrR6JX5KC8af1MZ/lTKNBaSYTJtZRFSzMrgQmhA/hQk07gqfV?=
 =?us-ascii?Q?kKL5oUQTp987NTQ7LVL9UN/tBtVDKnOKN+gamdOwCWHXJlNIBNsV+dfr6Y/R?=
 =?us-ascii?Q?dMK3OMO3iQ2OWRr4E6WZTR+1OQUkhsH+yT78cnZ+gRBcvnQtyz9zOxn66TRB?=
 =?us-ascii?Q?IzjuCuHAZAKKQd8EbwESMGGny72nCSJg6aJbOJ66osxuc3tvbJlaWMQuCTiD?=
 =?us-ascii?Q?q7C2KXiFPd1Y/Gp8R0QsPOZnTMCu1Bn0n9LZ7Nd+2C4HZlp25lmLa+8/2YBL?=
 =?us-ascii?Q?dsQssXzGd+GSIEc6f3+CdXRV1bsRVD6oY0pBoZStyY44NiFXie7+1b9jIhay?=
 =?us-ascii?Q?FwcQMquHFBy8UizbsRffFk5bQAuVkiaq+ZeWxrC4nl9m6DS14c6LLyuN0Gvc?=
 =?us-ascii?Q?7o8KUJ/0iEntw+w6arIy9wXxU7pUS8nDRVOERGPv9X66ADx3Y8TSVvZtryQn?=
 =?us-ascii?Q?h1F6o0P8gGiqRotxPk8pBNiePJpgKSD1s+pg7dN7WDwTziwbmX5EEOP1EbeB?=
 =?us-ascii?Q?nb03a1WIpuYomzCfMpuG2QxuLMvWm6nLdhnFV9tNknw1BflZZoN4GNjRUkEU?=
 =?us-ascii?Q?2MDIaw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 340cb458-5946-42b3-c3cb-08d9f2d6c269
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2022 12:04:05.0926
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XU9w+v1Xjx17XeEJ87xE2EPrBHrnJywbQ/OFm8Jx4nIIwBXwm23iwpD10q2mp+7EnkMnE8zTDEtmkv69tCG3DDOAg5QwUTA1wpwZEPQ+poY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4824
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10261 signatures=677564
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202180078
X-Proofpoint-GUID: 9HEm23XwEcT85uKrV-kFtuNQPdL4ickS
X-Proofpoint-ORIG-GUID: 9HEm23XwEcT85uKrV-kFtuNQPdL4ickS
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 18, 2022 at 04:11:30PM +0800, Hangyu Hua wrote:
> unregister_netdev need to be called when register_netdev succeeds
> qlge_health_create_reporters fails.
> 

1) Add a Fixes tag:

Fixes: d8827ae8e22b ("staging: qlge: deal with the case that devlink_health_reporter_create fails")

> Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
> ---
>  drivers/staging/qlge/qlge_main.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
> index 9873bb2a9ee4..0a199c6d77a1 100644
> --- a/drivers/staging/qlge/qlge_main.c
> +++ b/drivers/staging/qlge/qlge_main.c
> @@ -4611,8 +4611,10 @@ static int qlge_probe(struct pci_dev *pdev,
>  	}
>  
>  	err = qlge_health_create_reporters(qdev);
> -	if (err)
> +	if (err) {
> +		unregister_netdev(ndev);
>  		goto netdev_free;
> +	}

2) Use a goto to unwind.  3) Release the other pdev stuff as well.
4)  Clean up the error handling for register_netdev() by using a goto
as well.

	err = register_netdev(ndev);
	if (err) {
		dev_err(&pdev->dev, "net device registration failed.\n");
		goto cleanup_pdev;
	}

	err = qlge_health_create_reporters(qdev);
	if (err)
		goto unregister_netdev;

	...

	return 0;

unregister_netdev:
	unregister_netdev(ndev);
cleanup_pdev:
	qlge_release_all(pdev);
	pci_disable_device(pdev);
netdev_free:
	free_netdev(ndev);
devlink_free:
	devlink_free(devlink);

	return ret;

regards,
dan carpenter

