Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ADBB442EF1
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 14:15:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231419AbhKBNRo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 09:17:44 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:11738 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229530AbhKBNRo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 09:17:44 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A2BdXG1001204;
        Tue, 2 Nov 2021 13:15:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=p1Hjh1KxvIxLUMyz4XCnuaijiM1fRwAKZTISkYoeX80=;
 b=KJcK6Jl1TeRjI86YWlMZ/A1NC0A2ew2I+2TivSO7C6UgVSeqsnkJqVmYILH9YR6ah4q2
 OAA+vXuyAIiuxMK0ImQcrkbjlxF5dnhpYFcPzbjM31iLMkEWXUrldstzfCEzvHWByybS
 oD5qRaurUKpH3tuT7DKZiKCYUE4JgFo7rybgDKeX1kugqu3pLKeAYA1kEnJG5bjqAe/2
 cuDKcjU6W5yN/RnHxdd5JGAAihjgEtnwcCUfQkU1azou/tqSgRNHr+3mDBs4RgZYznfZ
 7xamvPy5wqD+QDB2+t7Fc0JsznDoaQPIkPePoirxL8ADm0uBmxZpb67KQbyYVYpEtTF0 XA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c290gy6bq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Nov 2021 13:15:04 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A2D6HNd065946;
        Tue, 2 Nov 2021 13:15:00 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
        by userp3020.oracle.com with ESMTP id 3c1khtfgr8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Nov 2021 13:15:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oUGUkA1z4/2EaHBy5WM3jxnbewG1UWpV4p+hE1VImFSvcdeLFyY7b64nPBcppLEUC0UTVLe1ExGEwPC8QnFnCBgbs3ttbZm4Dqa259FMHMfsYgQNLT1FDJENnxn/YH6rFKoqORaNzbkzFn17Oq2/WHBHxH4ljVxJ4pK++oRioVIMMWVCNo2oLb2fvO0ihQylrd5aeFigyeg5deRg38u7+Z4gGiOSJBalo4/oxVmzTZFoJWn4ubuZmorQmSFn1j5hSiJzaQbHP97eScHqRgMC8C0P+KSUMWybBmQaykOMhySi6GU6AhJ/hzFMEFvSMyfRvTkyWbik5A3y1IWS/X8AUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p1Hjh1KxvIxLUMyz4XCnuaijiM1fRwAKZTISkYoeX80=;
 b=oIgtkby/NxSFrxKWzdMVroOJl1IDdXP26Hu8VWCPsFRQnqhYW3Szw5CusOCcLtvO8e39cIbc8QELu+srmaLGv0FI9uMqLq+AoCdMMWQPuTIkal7V4lc+Zm4lCpmDMQVwPktS4xQZkT/t+eguXEDu2vxB43nLoFSGkuzYixCOku24uIWNC2UMVK/l4SwnvNfAbTK6cqtrK05/X2jlYliMc4wwYA094h1jbzngEwxHUniaWrx+1CvC1wgO+ZxbSQ3SDMGyt5gEeGeolpOlMLqGNv7sy6X7MtnOx84NcZdWCeDzfKM27x0+GGItZltfGiUmX/yN3pJzMMpt3icPedhVow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p1Hjh1KxvIxLUMyz4XCnuaijiM1fRwAKZTISkYoeX80=;
 b=CppbD8rdBfuhCBx89C1nTc65xZotF7LyGw/pzOmeWNUSwt8Utd6iRXe/xgT3FdNqwlbuwqVIsj5kYN712bnFpt+REUiVXcFWv+Juq85ckdwlEwmvC38dnihg34e98dCN5PdY2Dz6v9Zx5f5nKFDndAGr709Dww5ort8rTutYt8M=
Authentication-Results: realtek.com; dkim=none (message not signed)
 header.d=none;realtek.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1293.namprd10.prod.outlook.com
 (2603:10b6:300:21::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14; Tue, 2 Nov
 2021 13:14:58 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9%5]) with mapi id 15.20.4649.020; Tue, 2 Nov 2021
 13:14:58 +0000
Date:   Tue, 2 Nov 2021 16:14:37 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Pkshih <pkshih@realtek.com>
Cc:     Colin King <colin.king@canonical.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][next] rtw89: Fix potential dereference of the null
 pointer sta
Message-ID: <20211102131437.GF2794@kadam>
References: <20211015154530.34356-1-colin.king@canonical.com>
 <9cc681c217a449519aee524b35e6b6bc@realtek.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9cc681c217a449519aee524b35e6b6bc@realtek.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNAP275CA0031.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4d::7)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kadam (62.8.83.22) by JNAP275CA0031.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4d::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.17 via Frontend Transport; Tue, 2 Nov 2021 13:14:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7e84c056-8847-4eb5-bf5f-08d99e02c4a9
X-MS-TrafficTypeDiagnostic: MWHPR10MB1293:
X-Microsoft-Antispam-PRVS: <MWHPR10MB12936103411C36997FEA433B8E8B9@MWHPR10MB1293.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wdtFkjlqyng/kt98ZTNu1RqvMlUDjkHuB03LO4MnWT8p+jSLUc7xrKul9RXxaKU3QafLo9B9NGfHe6YY8kKI8oGoub+YLAPo4ryMMP8T3h9IvDdTP+eZEc4TzO/aT52i4l7EjXDOX9SvZmBsOUspnrkKheYf5Edq4MLf3jvjUymgGiNvXivdm8Z/O6cQFwQRGMS/QnE0ARaQGAg9NZSgfpOF8c6bcNNB/gLrMQZpdU09nkwgljV/eYdBIctrh2mgn/G5i98/8+OYH+H5stHVfdZzOiB1kUlbZZ56deM6dCt7V1APghhmG3Q/keIQWw4AMoV8w9OBmszhwb8NOLpfPIpRgUSucLCIRl/y0f4H3pDtDAj8IgnSczO8Nuk5RC+KqRrDHtC7xVUGvLAfFSe1oOcyUN6j9Ty6HThSmazPNA1twCfT0hpInLPzRSqDNLiI3hQb9ben0tzO0GH5t0Nm7OXeRv881wJEh+D9qweKNwvfdmOPaR6eZlv13t1Nu4xc3ROtj3XeXrlhjcNleLZ/3O4awuHmm2sOaWRlIy1nKASfeo5rudyWSVQ2hNdBPAL9FDUBCidv0Almmq7bs5cCqALGokBb1LrfaX/04fipZFJGAjq77zAb77pOjB1VBzk4Z+X49YbGP010HGvp5VIke2nhJFOD1EDprw5mS7ABsCuHIhe9GzOg0/42UNM1UGY6Pl+pEZSNuc2O/ayycCo+CQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(83380400001)(53546011)(9576002)(5660300002)(6916009)(316002)(44832011)(26005)(2906002)(4326008)(1076003)(508600001)(66946007)(6496006)(33716001)(186003)(55016002)(9686003)(33656002)(38350700002)(38100700002)(956004)(8676002)(86362001)(52116002)(8936002)(54906003)(6666004)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pGFt3MucKYLE1Xw1yEK+Tt9KThbU1sVUKyhBUNnfq1pAKxisHJhBlC+PFf2W?=
 =?us-ascii?Q?U4lQBVBmEMF307LGU9jkaBSwxxh2y+KdKYXswZBObZsiSfNEerinqi7K5Yy3?=
 =?us-ascii?Q?30u9JS818pp0SOTN2zi7LQ+0+dVmbxPJQqK8LDRRcvglkIZ9hkBmaRIONpbA?=
 =?us-ascii?Q?DMHn4mMVzRdBSnWt6v3tUC3VAPAAwFSFO0fcdIHbjsrSiDbeVYXx67ECPbGn?=
 =?us-ascii?Q?y7dSHk9iJp4QozDOZWGix3s1VKePgCPk/Nxiwb2dYGY8rLSh4fOCnuJ7fRj6?=
 =?us-ascii?Q?Z6XSCRBS2qfk7U7CgMloYva7XxOqYpGYVtZ3xfIEgikTIECD3lDuYHfxp0oY?=
 =?us-ascii?Q?9r3q7eMectyq8cTufLuvTurXN5umEpd23AKgT68EQKbg6dOcDLXupj3F7Yts?=
 =?us-ascii?Q?68hVNpchEAS8DmjGc8QEfuUwFqqFG8CNFOXkC9GWQkxo+9i9QJ9tMbbKoyr4?=
 =?us-ascii?Q?eJ0/CBpgiRDqay0JI0ugAEeDY/uEf1Wja3TssaVoa0eEiNNxlbA2vDpKEVep?=
 =?us-ascii?Q?PAMcFlNhcZbF+71TkphvfRwelbz0J7g8kxbohxb+Sd9u3NzlIWqC1i7aG49E?=
 =?us-ascii?Q?PyseoYx1c8QX1iVE+XkTOqxm+UQiYlBVokX0WKL6gHfuv1aXVxZmAXBR/wzs?=
 =?us-ascii?Q?HLsI9Chtd0iiz70nIp2Bd3HwNkz5xt4cad2gLt6rjJi8AWUUoznzgx1Pdcwb?=
 =?us-ascii?Q?JoIeIX2RWzgySPOtLPO2RKo2yWmrpQKVxoVZE92pPpbf69sAUzf25dWzcgvM?=
 =?us-ascii?Q?BWvFNIR6fYPc3f3bHM6vJYHJyrrtZ/dirH04l/aLBUt3FoVo7ScZkESqUVj6?=
 =?us-ascii?Q?FxIyShv4Fq2SK+N2YpAaCpWwIQvJJkvvUFREo+Nxxd4dEO765J8hMcP8rm/3?=
 =?us-ascii?Q?Plb+uQYSCrExAuajyT3MAL/AENZwU+bTBA1K1w3h1n5VogFB0y+V7rfjxCeN?=
 =?us-ascii?Q?ejtV4YgJ7dbeMqPucCUIZ9UBmW16itNUIRbVd5Fve3ZMjtPewzpOvgIepRZR?=
 =?us-ascii?Q?MWPtNLuoudb2H4ziKVClFWvBsMPlA5mS0nHuMJwU/1daNcsuxmgZkY3gL/Eu?=
 =?us-ascii?Q?mKI7jrqomt8kfr8m1EEGAt1V6cr4qjNSOILi9G/y5RnAA0ItHwQdwIJ5xBME?=
 =?us-ascii?Q?+T1jmYkFeDKu0dPSTVq62sZxCX6xQ9dwXQlsqFXX91Cp1uYOj78OkJYlUgWn?=
 =?us-ascii?Q?RuQ64BB3OKxf/94gVnI3crDvAuFvTeUJrRy8iD+/bUC4QXAzB6ME9jDBfJkv?=
 =?us-ascii?Q?826lsaYvZ76HDKaGJw+9/cyo0oDN3lO/0MDNx0AfyYI/hy+qFhjl9QmtWrwP?=
 =?us-ascii?Q?Aey39Anv+heyI2fs81Ellz/9ZPodGayWh4iQSerhnP0O0aJAkroTl/ThJ2vK?=
 =?us-ascii?Q?+2Rn56aVzSoj93ORc14CSyM2WU8LeJkxBNeq8ak49arnDHUZ+UFaRw1xYpyo?=
 =?us-ascii?Q?dQ/kHW7xVXPmxE0q+M8TgTHOSsgm9cyEJZqL1Gsx/9mZgZcrgFSlCaLSVNpF?=
 =?us-ascii?Q?0NXlmJbuNcWbyTRF0K0RZ/gINjNLGZ186+Tu8nP7iCVVtUEJds9vOjoo1THC?=
 =?us-ascii?Q?Pakahw16NHCCiBUtLVkp1szs4ST/qICSQfLMw4ocqzq/3AQfiLWouXYsmP+Q?=
 =?us-ascii?Q?gOExL9eyJCepGl/7lWH78OioRMBXBA5NKCFBWI4PgSDzX4vXibZy1bMlpFlI?=
 =?us-ascii?Q?lkjOQA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e84c056-8847-4eb5-bf5f-08d99e02c4a9
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2021 13:14:58.1624
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6cdua+6liv1Aa7K1Z9zEOOBAn/skmVL2/bZtkPEUN8KMwi1o6zQTS255e/36uBZfqaqoh+R6H2i9LHgegYEdA7qnD33xczDSPOkMVIJAcxs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1293
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10155 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 bulkscore=0
 spamscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111020078
X-Proofpoint-GUID: qimgQJgpo6_vgn3B9A9vzJnTn5i56Eim
X-Proofpoint-ORIG-GUID: qimgQJgpo6_vgn3B9A9vzJnTn5i56Eim
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 18, 2021 at 03:35:28AM +0000, Pkshih wrote:
> 
> > -----Original Message-----
> > From: Colin King <colin.king@canonical.com>
> > Sent: Friday, October 15, 2021 11:46 PM
> > To: Kalle Valo <kvalo@codeaurora.org>; David S . Miller <davem@davemloft.net>; Jakub Kicinski
> > <kuba@kernel.org>; Pkshih <pkshih@realtek.com>; linux-wireless@vger.kernel.org;
> > netdev@vger.kernel.org
> > Cc: kernel-janitors@vger.kernel.org; linux-kernel@vger.kernel.org
> > Subject: [PATCH][next] rtw89: Fix potential dereference of the null pointer sta
> > 
> > From: Colin Ian King <colin.king@canonical.com>
> > 
> > The pointer rtwsta is dereferencing pointer sta before sta is
> > being null checked, so there is a potential null pointer deference
> > issue that may occur. Fix this by only assigning rtwsta after sta
> > has been null checked. Add in a null pointer check on rtwsta before
> > dereferencing it too.
> > 
> > Fixes: e3ec7017f6a2 ("rtw89: add Realtek 802.11ax driver")
> > Addresses-Coverity: ("Dereference before null check")
> > Signed-off-by: Colin Ian King <colin.king@canonical.com>
> > ---
> >  drivers/net/wireless/realtek/rtw89/core.c | 9 +++++++--
> >  1 file changed, 7 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/realtek/rtw89/core.c
> > b/drivers/net/wireless/realtek/rtw89/core.c
> > index 06fb6e5b1b37..26f52a25f545 100644
> > --- a/drivers/net/wireless/realtek/rtw89/core.c
> > +++ b/drivers/net/wireless/realtek/rtw89/core.c
> > @@ -1534,9 +1534,14 @@ static bool rtw89_core_txq_agg_wait(struct rtw89_dev *rtwdev,
> >  {
> >  	struct rtw89_txq *rtwtxq = (struct rtw89_txq *)txq->drv_priv;
> >  	struct ieee80211_sta *sta = txq->sta;
> > -	struct rtw89_sta *rtwsta = (struct rtw89_sta *)sta->drv_priv;
> 
> 'sta->drv_priv' is only a pointer, we don't really dereference the
> data right here, so I think this is safe. More, compiler can optimize
> this instruction that reorder it to the place just right before using.
> So, it seems like a false alarm.

The warning is about "sta" not "sta->priv".  It's not a false positive.

I have heard discussions about compilers trying to work around these
bugs by re-ordering the code.  Is that an option in GCC?  It's not
something we should rely on, but I'm just curious if it exists in
released versions.

regards,
dan carpenter
