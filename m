Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAC7141AD64
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 12:55:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240332AbhI1K5g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 06:57:36 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:14014 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240318AbhI1K5f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 06:57:35 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18SAjdsH015661;
        Tue, 28 Sep 2021 10:55:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=H70XNq2Kdd9u4yTTZqDG01pREmcP5JQJo+qSUUPplEk=;
 b=bXWD0itNTRVUhZW2w5x2zEkaDBNl/gHi2aOM0jkevXO8qBrUks1+QIyZCj9AKxraUNbP
 1zK9Qbe2DH72hzB+Q71KvPGGAJGssmJY1hSvAV8stUXkmSrhXdZaME4i6Pb7kjFzTrz1
 7LAAAC/SYdir7MJy3cNWN1fW0HPyPMaDv8/BITdfdzD6Jmqik9PD9v4Lxg1GnBWs1NQM
 qRnmRV2o5Df+KQAF4n+FnwctRzmM5R8upmXI1odgS3HLfAKNbU6oeZgEx+T7l7S3xKg7
 oiRrSPxTN19ZvQTYJEYDHz9PnBXTKLaWirdLRQolPuuY/rpY1Hu7ilS65j4yPw2wkVrG Dw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bbexcyhqp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Sep 2021 10:55:44 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18SAYZfK165159;
        Tue, 28 Sep 2021 10:55:42 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2106.outbound.protection.outlook.com [104.47.55.106])
        by userp3020.oracle.com with ESMTP id 3badhsjbe1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Sep 2021 10:55:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nDFZrAiZB4PWHZL/RBDFk2L0nonYeAc2i/waVjD+Q9Y2WDoY2q+S5FWPuNYb1e19oyO7LfTSCf0AT5XszoRiXIjxQ4bd5AQVJAQPYkGey+yF/ftoV3jVO99CwlRm6Y2GUVegIHuLDsgPIIv//DLDpHYw+KRzeSocqcrYxYqhKNowSmXxq23QqWtdR3XdpX+7X6HAg5z0rpgKjI4jHwYqUTBwey7nL6Mp2MFjrmiyjkfl/5V+5BnQBFR+mEjQKTFNG+MXNQXZ3Hvfzjso4s2lLgBta1zQ9eXA22kmL8w9wxGVXBDPxs2l9dqAQYO1a9t8OwF75k1N7YlryllLtuf3+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=H70XNq2Kdd9u4yTTZqDG01pREmcP5JQJo+qSUUPplEk=;
 b=XFQyhwckAhm09hqfjo+mfIqEb4UQ1Xgqh6TBeA5m86L+UC5WYdTbapDuh0DjvFgq3zhuf08SLUhbAqNVomJ9zAqdfxwuCOo375MbhJLyW0aem70kqoYPL4QWMvSIlaaq16ccEwuCjzdXJIBGUV7OHPYxCxqwyxaN1kmhE8zbCtOtrlO6l1+LGusUpO1k+5BVgw3d5xZo7shEc7QeQz8IGo4/0qD7bj2joEagyMJc21GIwAaHOW5nkmdzKQ+SJwdp0ImhYufUeLQu9jrggiQnz5f/yExgUGt2t2BAKxJxgGn1B80ozI23BC7NFW2DAzGZhYlukybIZGJrZyq9810I5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H70XNq2Kdd9u4yTTZqDG01pREmcP5JQJo+qSUUPplEk=;
 b=gaIFmNHdrWgyZ+0BwRa2rnLvW2zQFHajSQfadmsWRxIGPwyEZ0WyPsRGsVZPh8M1B2EGCLhn+2Mp8CrF/ZvNxmR2OIJKY4XoOtevxwATR0fFJ+SVbFNEoVnA0smY6K/MV5sqpx7uD6F+XmhLHMmzn1QwdE61Z8yPWHIwUG3x30o=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CO6PR10MB5459.namprd10.prod.outlook.com
 (2603:10b6:5:359::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Tue, 28 Sep
 2021 10:55:40 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9%5]) with mapi id 15.20.4544.021; Tue, 28 Sep 2021
 10:55:40 +0000
Date:   Tue, 28 Sep 2021 13:55:22 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     Yanfei Xu <yanfei.xu@windriver.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, p.zabel@pengutronix.de,
        syzbot+398e7dc692ddbbb4cfec@syzkaller.appspotmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Dongliang Mu <mudongliangabcd@gmail.com>
Subject: Re: [PATCH] net: mdiobus: Fix memory leak in __mdiobus_register
Message-ID: <20210928105522.GK2083@kadam>
References: <20210926045313.2267655-1-yanfei.xu@windriver.com>
 <20210928085549.GA6559@kili>
 <20210928092657.GI2048@kadam>
 <6f90fa0f-6d3b-0ca7-e894-eb971b3b69fa@gmail.com>
 <20210928103908.GJ2048@kadam>
 <63b18426-c39e-d898-08fb-8bfd05b7be9e@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63b18426-c39e-d898-08fb-8bfd05b7be9e@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNAP275CA0017.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4c::22)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kadam (62.8.83.99) by JNAP275CA0017.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4c::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Tue, 28 Sep 2021 10:55:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ed6582af-7761-4889-106a-08d9826e8285
X-MS-TrafficTypeDiagnostic: CO6PR10MB5459:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO6PR10MB54592B2C73076E4B30BB26958EA89@CO6PR10MB5459.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BnO9T8eQFYRaAJuPqovVsAgv5eBF0RKgdOVatZ4ohmsQlCUXKaWm/6FVTRj1e3BssCbFiP3BN7f5uaXxaitNd4IqMgveTTxDoaNT01pAw438XEymLp/8/4FoM8LQLqUt54aqqIqlHELpps1WKNqSyOGsnlPJ+/wIn4wrrRk6xYh2sghs18DYTtbbiF+GWDxs7m1n5RK4/PYizFxraXr4e2JZGLm9kFV/QyaHr2hZKy2V898HEHZtmSOrNL2/7bDSKLKO2V3IrITJPc9zFfbEZJrPH/ZoZDtG6ZFYKGZ1rE96Jr4eIET5vsV5JMtKWg48lNtgMj1nk+RTdgEn0SkMweuVRuNsaNSyQ1XZyaVRyWR8Quy+oEXoAkVTO+MSJuyHDgN7S1Axctc6etDO7oy9/uM1Es/aFcGAjpq2xyxbxQMmhrP+xVycy9QPPpwvuSF/gKPC3unQvjeCS5N5KZQX1ppPiT1X5a7B0sskuzqxhfJIfHhNuvCy39Ze/GOE/7Qti2Cf3Bi12/galrcaQi7xScHW6Pt0rhDxq+LVCv4/GsocCBaXZ8IGKqNe06ckZ+IPu5nb5RAPWwr0jMT3J8Je9mvUtah6/BpNvkFEB2dao2xjC17jC8/ecsbIYMRPpXUHdl8nuzGgwuZz8j10kj8Jj74SqJTYSrX0bDd6Uoioe+B5hjn0KYVq2xnFeXqyGyj6Y7tjDjacySTlPguCJiXZJw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(38100700002)(4744005)(9576002)(956004)(55016002)(86362001)(33716001)(5660300002)(508600001)(38350700002)(1076003)(44832011)(53546011)(9686003)(26005)(66946007)(66476007)(4326008)(66556008)(8936002)(7416002)(52116002)(2906002)(6666004)(54906003)(6496006)(186003)(8676002)(33656002)(316002)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Cb4PunW/tojL34HbiethJgg6BeS8VrAc6IhOcZezo6KKYwFEczJSdSjwz+YC?=
 =?us-ascii?Q?DwX7glGTi+m/1/E7ziZZHpSe+dZWrkM4ZH/dEYA+bE0LZAaPX+FZauC8qq27?=
 =?us-ascii?Q?ayc6gI3gt6kxC0cHoYUhuim1U+Z4S4QfHo8E/dVOk3Jx/v5fIDfcGWipYNzr?=
 =?us-ascii?Q?3oDhn4RW7SSSddS9+q9wm9tY6w6kT5kwfBYyGraAxnwHciXaX/e4Y7W5lmuq?=
 =?us-ascii?Q?srqdV3ghFcGDZS1zcVJAbUzm9y82waXj6J/OgyVvTmwr0TO/qTK7fZW2x3UH?=
 =?us-ascii?Q?1WaGbDcHTG/O5TY7Wqi4OOjPovH/izYnkh2fCLeAELTu+TEE5Y681FbbYXIn?=
 =?us-ascii?Q?sA8RrRtNuIjwuutDzzq9WrjE0Opost++Y9OAUYpcPnzdKU4Sr/lnscAG7XPR?=
 =?us-ascii?Q?W28dil28KQ1Gsx/u2+FvqLeA/yf4PAIVOSPXXzcGedG3TTlPlG80kfN5pVr/?=
 =?us-ascii?Q?blV08IYtlYLZK0lU7Va1phm0Wj0JRDCcXL3pNk9Te4t5TcUNDRZycs+s+OD0?=
 =?us-ascii?Q?hDFnhfzsI+59bUeSH7mUjjKATPR/6FZbIQHU46B1G3I0UxHUNl/BxLyhqLJZ?=
 =?us-ascii?Q?yjquOmEWt4tyXQ5jgl8/I0Nx7k2AOy4dSPmcUXVbM6iG47PkpozvvUbWgL6F?=
 =?us-ascii?Q?Ob+2+IzW7IY/Ht01O0plQ0sF1U0Ug2ru+X53ZjOlkUJ8g/mO/pD4w91sUfIu?=
 =?us-ascii?Q?5tjtVI3sy1mwyjFtp/1QfKRfZJ/7iT0BQVQx93mi8KFIbOvGzXELV2Dy9e9K?=
 =?us-ascii?Q?TkSR0cK55y5i0qdfFtGWSqGX9qJVe6CHrMzlXzDizufRrRqmLRfIWgaXcLes?=
 =?us-ascii?Q?YzmnK1/pur6I9msy7Y2l21kunuoDkORjEohrk7AwZeJUQCWgFS/JqgF2GfaD?=
 =?us-ascii?Q?yss80X203jN6y6gVarPmVU+cMsSP6vnAUa08hfWekczGwoKFSAshpPitPAwh?=
 =?us-ascii?Q?taGlnVdbH1Y/iK1qsE/iNnMc1ifqlr5xRyOCD72pZG+WFNcHopdWZysgPi0E?=
 =?us-ascii?Q?n/8pnLaMurwh10z1H1/SKKCgtIE0Qam1orYtxrXE2p7uxE6S8KLoID3bD2wI?=
 =?us-ascii?Q?GjAig5mBxk0oYHMhBwI1g1b/z2BXrWcsXK57OfPTS+WHb6XkeDD+dySUeG+D?=
 =?us-ascii?Q?5e3Y32oQLBUSI2CW4uGcLk0tegY2JgBJwZazyB9lCJGjtu6SeubgWeCYkwzG?=
 =?us-ascii?Q?OJnILfHkV8h5pvCrDVfzhZyyVVlO+Hnr3nNrXwMSbck/rEuIQK4bRhCZYhMX?=
 =?us-ascii?Q?lpjkjq8tGZlhzDCyYcYPMp8NxSnpGggfWctlzMyQCnWLpMIWVy2fsLhw5J+D?=
 =?us-ascii?Q?gKFuSdRWclKa5Zp+nEm+xiZI?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed6582af-7761-4889-106a-08d9826e8285
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2021 10:55:39.9386
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OwIcY9059Wd5V8UkxuZvanELBgJ++8F/LoujFdRiCN888XkYzcUfPB0YMTe1kXU7yJkR5+ginXMVb385T2xJtGROpZr62VS7XmS+winKdDk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5459
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10120 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 malwarescore=0 spamscore=0 adultscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=854 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109280061
X-Proofpoint-ORIG-GUID: 8ibkMS8gXB7EKvf1eN7RvAOwPNXFz2FG
X-Proofpoint-GUID: 8ibkMS8gXB7EKvf1eN7RvAOwPNXFz2FG
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 28, 2021 at 01:46:56PM +0300, Pavel Skripkin wrote:
> On 9/28/21 13:39, Dan Carpenter wrote:
> > No, the syzbot link was correct.
> > 
> 
> Link is correct, but Yanfei's patch does not fix this bug. Syzbot reported
> leak, that you described below, not the Yanfei one.
> 

I promise you that Yanfei's link was correct.  That bug was in
__devm_mdiobus_register().  It's a totally separate issue.

regards,
dan carpenter

