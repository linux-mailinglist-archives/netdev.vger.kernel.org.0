Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA7B352B1E6
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 07:36:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbiERFeE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 01:34:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230285AbiERFeD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 01:34:03 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 467001FCC5;
        Tue, 17 May 2022 22:34:02 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24I2q7vj008006;
        Wed, 18 May 2022 05:33:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=q2xPT9aYNv3n8ZfbCyQkPK3lG0v/KfOw17OG2y43ouA=;
 b=m7uLu5rHfY8fxJpDHyzKyuOqmmW0Ny6EHmRVB/x513qyb1WTp33Fe54ZtGsaBtg5BKCQ
 +IX8N7iqqcgIScOEAflvWkE/JZqWS4XW2CrNY/cRP5wha5b5UI7zr+YkzFfIM3KQAvss
 iA/7ysLuGlwKT9ftZYAIOpCT5XGFR2dGTn2cUD3Y02tCzhCJaXam9MY3gAQuGqiaIsRp
 UIUYbXSvMzD5Ln2DERS1/Gbq68JZUKbDkNRiL0QI9tXLnvE9qrIZAe6A0uMYkhLoCqWT
 MdLTceqD0iT0r017R3KOquOlYhGgbWpMkwif76nKg34fqiLPeHZit2B04iDi0Tg9aF1t dg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g22uc7yes-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 May 2022 05:33:49 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24I5FnkY008093;
        Wed, 18 May 2022 05:33:48 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g37cpyryf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 May 2022 05:33:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PO8GXSGgjmBjv2RPjIj18tJNVmZSEvGfWlRB9p892mlshsIcTvOOEPfaD/UR4vtFwdGjhLwHCXIHoxAsoYSkn9FnoCKx2FOJ0Pjpi/rZT0PAxwvdO5g7EZvj0Yil/KYDc0ore6B8weM3gIQIX4d9H58iRzd9jRQyqgpyIVwyowjfDuzP4lmCw/4tlm8fnoQVwqQ2jkurUWKKCODCcO5lpG00X94NS8cNZRaB92AsFQhcVeAPziV60+JUuwFgmXHKiaPAJjVwp7mzH+qNlipFTVcGdef3H4hXtXyhckMXugCfbEv4y4UALxHtj9fIvwpSwGPLdB9W1tEpS3vaTriQIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q2xPT9aYNv3n8ZfbCyQkPK3lG0v/KfOw17OG2y43ouA=;
 b=OIBb2l2jBJeWMhkNZ1/mF3iFgoY7/hsv30j9ErYRD5fHnroQPQz0QSB+DCClBF+hwQwGdAvttJ8QgrKB9kmIhuB9uvDd+YJhW/3/yoX1FrLQkB+g1/sfDUUwqFHUxcyekGy8OMEGxfk7ykhgRcHPVAnacdtj9pcvBpAXMACq4rRtnQs17LpctoWE4ewX6yHs2Vz7l5e+WSql+Cba4/e6YwHGUyLAqs4hp10uLTpjhixZ2+nOXfZryfMPn6Ft2QtV35xN+szxtAh0rbW4VDIjjmnDq/PXvLKAJndsF1wKffdveLXW0XLThwtWS10fI7fHzDUxdPqNAdzXCi2MCxZkQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q2xPT9aYNv3n8ZfbCyQkPK3lG0v/KfOw17OG2y43ouA=;
 b=GzDNTQkee64OF8KMru4t2v5RbbRd1PrQiYeDrRAkjLT871SYUe/eZqOxk5RlfAjw2c/OqpjqQrrNorwxEFw616Ev9J9ey94bBPuXZH0rjPkJzirQAFIiTWxhxtBv2TBZbvI4kyxzvGSwPFJqGGMqIAaCyCC7rZNGxiZU8JIL8xw=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by DM6PR10MB3851.namprd10.prod.outlook.com
 (2603:10b6:5:1fb::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.17; Wed, 18 May
 2022 05:33:46 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::86f:81ba:9951:5a7e]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::86f:81ba:9951:5a7e%2]) with mapi id 15.20.5273.014; Wed, 18 May 2022
 05:33:46 +0000
Date:   Wed, 18 May 2022 08:33:24 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     vburru@marvell.com, aayarekar@marvell.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        sburla@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v2 0/2] octeon_ep: Fix the error handling path of
 octep_request_irqs()
Message-ID: <20220518053324.GP4009@kadam>
References: <cover.1652819974.git.christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1652819974.git.christophe.jaillet@wanadoo.fr>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JN2P275CA0012.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:3::24)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 887f7cee-3dfe-4e64-af4a-08da388ffa1f
X-MS-TrafficTypeDiagnostic: DM6PR10MB3851:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB3851A3AB13B38C8E654AEC258ED19@DM6PR10MB3851.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PQmNOeqt8oWhLKTtCOuLw40NnPk5hyJyy63wlORjbKhQooSAOU6HMJ/zSClYChbOLsZVKs0HdvolA0bsRQKBL7iJbefZwgJy0aYxExCzos/lZWr7G2iVgHEPwXp2KWbvYPjKfy4tHK0W2XGF0tcLKL7uhPjWSxg7ZTICqfU34TqsBXT22ctqjJ6DIgSjqXeavswOvGz71EpyABP/98obZhJiOR2kd/2lfVdgFx4cpvz2sFwxX0NzB9VLby4EhymJBjT5QWhS9Jg89JrVc/+MiO4qChUHFmNRCwh2O5PbfONp2L7GPnyOVrvEQ1WAOSqYsvcswr/tQbRLK30KuBgUnmjN7qZZq4lcFZEYwl9a2lRhu2pkqLbd+7LPEd0bUGu9Mt972EE/cu/kUFp+YKZlEZXaTS7QI3RbIK4FVE5W4Oww98rpHh9mWkaHgL4CmbS1agbo5wpRUybI9l1s29Ivmg3MlD9mCLdOHkMn7iz1BShIwsYroHceyjDbM2VQk7iszgsjNcqnmlitaEIXvZl4ByHTuFD8Wm9oYUtBdRJpT7V7olk7Ltam3HFCpxjN0hxlBAqfpTYVjvoxN/8lNhyDM4vxTAn9+4qu4S4pa9Ip5I6mhuvSZwjAcnchSnEY7TkBaGqxoh99KOLmiwjizUN/T2PguYzxYwBtgxRnyhyLLfnRs27UEH8ohxIbHL7bcd/FDc0Pp1I52Gx/wEkGOcHJbg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(6666004)(6512007)(316002)(6486002)(52116002)(558084003)(9686003)(6506007)(2906002)(66556008)(86362001)(33716001)(8936002)(508600001)(26005)(66946007)(4326008)(66476007)(6916009)(186003)(1076003)(4270600006)(33656002)(38100700002)(44832011)(7416002)(38350700002)(5660300002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hxffkY1A7xD67+LfJHMaAxdZdA+/7vthedvsCMm6PbRA5dUw7h5aGMX8xdXB?=
 =?us-ascii?Q?XmRnNUSCK4j0qFf/CBknnkRoIX76oc73R57dGUNY/f9CEy4KwxszDHugJ4Z/?=
 =?us-ascii?Q?lXvMDNC+o5UvydSXxcPzI3dy6eR6n+g3peEwxvGJ+ttfyn0fxWwAJWCvACNj?=
 =?us-ascii?Q?DKcT1yhdksmNSpMztxs2LqjoCwOfd7AqcLOtYGw8KGBkKTDYxkiHdbvmBM9u?=
 =?us-ascii?Q?dUY8mLp7tM9bMxXmw+3WKT9kkNAfH0FCsQhKL20vf0g3Q8hFMOU5hAFYlSvW?=
 =?us-ascii?Q?aPj6rfiEGmzno/xakci2t/R2zIDXmH9AGo9J7vZYVDxllVbfkPYfHHZeiCcN?=
 =?us-ascii?Q?JCbUhZ/wnFCnBu0xHeqFXchhJnnuWy5rqStpZKm5KzR5Fidnesa+BccKt4yS?=
 =?us-ascii?Q?TMzE38lgr2jqYEFVOUpQ1AvYIdNU7oXLnP3WUF9I86RiRAI8y4WkfaVZhESa?=
 =?us-ascii?Q?8t4zI9/6JDgXRX9Sn9MWVH7+XLtvePaTh49Mdx9qp9JnN5zg40vlSLhFv8i7?=
 =?us-ascii?Q?Y/weTqXvfumOn4Qjj3/j/3nTWpzrrfJRmPw0BTgvC0ZXF1Jzqj6e/c2uguF7?=
 =?us-ascii?Q?bmCBG3uOHXcoaLd/lz+lgZkTg3OUyi7oAcZ88vjruhLHAHipCFFgLajPKsn4?=
 =?us-ascii?Q?fF+56ssG1cvDnQhSnLIginDk79fUHhkWYzIhHYJBlWq/NkBSnLHCAbqZWAhQ?=
 =?us-ascii?Q?Ul7D5ZR8RLoNeHlHz/xTlH+SfTimhD/jzgZGle2MX8G5Zcq3Pc1kr1j/SOlX?=
 =?us-ascii?Q?ZooHr+bj4xWb7un4w1NOpJ1iI9f5EFnQo99L9/l9PTPDO+LRKGgKfVbk+UvY?=
 =?us-ascii?Q?nX4MdLgKSB/61/l62do93Y9/TF94or9WnTgkAG4/m6b1qCq1vmNCPhhTyKjY?=
 =?us-ascii?Q?kJn+PWeKvy0YJOACLJIZIMK1k8kBUdTejCJ7ClaIOctQ1w88ZcDSquCi3WQB?=
 =?us-ascii?Q?vE4e5IY1xJCn+kHTnBpHIoiXZKWlYdGAqIbtV+uKwG2oc/RMLQxHKwRrkMgx?=
 =?us-ascii?Q?Bswsa2pOTBLFm5Eq8ozNCyK908b3o6zPdWNXwjGqV2FHJmGH1n+Vli9tuu0B?=
 =?us-ascii?Q?/p+5Wd3Jfqle6Rg0YMqhuHmf7HUjyWHOtVZCtrY0q7BBLTqbO1X6jSmjhydd?=
 =?us-ascii?Q?ptuWtGBYHAjuPEbR1IPk4KmKDKjX8WQeId15hIP6v5fhufZXEU7gnBEtdfiu?=
 =?us-ascii?Q?J0m5pAYX78nEKGPoAXQIKZ1Yaymxko37LrM3DKzznGwNKS98brRIUllwrIWz?=
 =?us-ascii?Q?wGTO4EyELwRqzRhkFgBCpKAjuES2iYnizU7T12H7WAGA2yhiLNkbtb5W0Nrc?=
 =?us-ascii?Q?6KWpt3jGeZNwM14zUftkK8jx1p987IWu4NBSI9jqvUMAhRJ4sc84BNa0EQfL?=
 =?us-ascii?Q?sEq+F4iCROQcRG5dHpBCw1TOH0Ok9oh9PKrOsNHOiJKgBOdAZIjxF2GThmlt?=
 =?us-ascii?Q?W4CQPtIHj//REEJtnxYliF+9EO4dLkMGgIcRqi0awO5DIOYO7F1+NadpPjkX?=
 =?us-ascii?Q?c0dilaVYTmXasYPbDqxlzox3K3iUzc8DTz3KafbsMXbVG8JkfiUF4u5gSdrQ?=
 =?us-ascii?Q?PLAUXxs5jBlI4/wt5VxPno63xqzruX9y4rxCCXLlcwhIi2sRl6VQEsHFiomL?=
 =?us-ascii?Q?WL9LPK2HThcCZfu7RtSQiKSR2wn7+n5v89UYsQKI23+9r7fkpydCCRklEMT7?=
 =?us-ascii?Q?BfQkI7ZAlLWlUjBKq+KWPXBueB0OHV6IoCT6PIaZNjhsCUeDd12ci7iNrcCs?=
 =?us-ascii?Q?3KP2skTjS3lN70eKkzUzmX3ohEdPHR4=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 887f7cee-3dfe-4e64-af4a-08da388ffa1f
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 05:33:45.9517
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7lO3r4TST8VqXyH4CmhOsFNmp5s+RlxPhUYlrL8NPM/rJeWZpXpF5A5YGIfIMPtigv1UwLBhOv2/Ejw3F7rqHU5lA00RJ55IPL0/MOGh2uk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3851
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-18_01:2022-05-17,2022-05-18 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 phishscore=0 bulkscore=0 mlxlogscore=999 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205180031
X-Proofpoint-GUID: DWCajL8HPT6a1OINHSpAyxetpb4_y5T5
X-Proofpoint-ORIG-GUID: DWCajL8HPT6a1OINHSpAyxetpb4_y5T5
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks!

Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>

regards,
dan carpenter

