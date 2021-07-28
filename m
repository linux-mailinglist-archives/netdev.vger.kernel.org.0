Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A1D03D8A73
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 11:15:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235621AbhG1JPU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 05:15:20 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:31660 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234164AbhG1JPS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 05:15:18 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16S97xeI005207;
        Wed, 28 Jul 2021 09:15:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=uBRkjZlYYDdNoPUkRuEzqVKzc7bNfow3yblGbH0Iges=;
 b=GSN/EeQnigVzJEPHLDoe0ClZcdu/pDlXYTrmFNW59i3Y7W/eHakdCmFhyijvkfU3CH7J
 x77bINh7kzN/ZcxRqE3gu2UTOlkK0iBqxgMP76dPUqUx9LXDvPtAkrsmcPGxNAXGWVDM
 TUolt/9pntxEXKOkaq4k7wU4GWl98jFaq/9ePMLB4aWSzM38H1uaAsoAkhsUONB9ZwDA
 BT42fmhm0vu37wk4TeFj/FKRvATdzDHF9PcWeuVPC5ubK0jTbsYr0O17ay/RrpjPAbFw
 2jrzG/N+E3M2dIWCMakXEXqLxIsgjcbFrJRYysX92feIDnD0kv7cE+ZYl8eCbUykhD3y bg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2020-01-29;
 bh=uBRkjZlYYDdNoPUkRuEzqVKzc7bNfow3yblGbH0Iges=;
 b=TUiif95btzJzW5aGKMP7Bdwoc0F/4weZvEqxD5vcxMrQjh1hUMebAC5gckFkgzJ/PXCO
 YzIsYo9Bl1SOLXJVLbX5bmDzbucPSd5O7wzEaNgstpuu2ZS54iSWx+iRWgOuYf0LiTSm
 Lxr4OeM7glaxsJk23oI+oILVlt/H1PXua++NyqZY6spTdF8xz9YgtWE8KSo7y4f7LqNT
 GjNDd/A2TwUNRTlVKR6t2MkZlb7u7wRMSw8GHWe4/t9E/1ngpQB/OfxYGGzxqlPIBlyh
 /C8hvw3fbdvmqH5DR/yyPLjDrj+qroFvzHRZcfiqSyRkj392UYtGzT/7ex8cJYSvmHAA ZA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a234w42fp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Jul 2021 09:15:05 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16S9Ao2p175307;
        Wed, 28 Jul 2021 09:15:03 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
        by userp3020.oracle.com with ESMTP id 3a234x8t9u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Jul 2021 09:15:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kSGY/Qj41ok6AYmd/xEfGamtJbqR13TXaEpCWWxiDzfIxH2NMMh2GpEjc5d586DZS8tDMAX9fy2njdWiPmMuz9xSuslc8+Jcd05tIWPFK25AoxGGzekhYfmTm9nfIWDFb5wFjR7VsUE/etIVMv+cKM1ba1uV3Jaa9R8n0lTTkstGCn/sHY1wDNhyFQQTrBg79i3mxOl3SZ86DfdSAx2Ryg6rn0UkT114dO0/Sbvsf0Tl0p0uglJGAQckttyJQfVRGQXyUbIRAirtenoCv/7H6Cp0LuDEM3AywE6Qwl4YHony+xVibdRyuK9rCII1xSzWJu4/VXguI1e7aziqSgl0kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uBRkjZlYYDdNoPUkRuEzqVKzc7bNfow3yblGbH0Iges=;
 b=OkCEFw4MVktfAQzUKZXIgvuF1eUSt8fHUDU2e9ylwjHgj/gXKEIzbkv+Ij46e/Y6NhwTA0OjnIJF6xxbO8rDPA07Uz/KHB4RdCt33yVtfcj28fne2ks9NV1FCtDNfGSR5xDJox/DexclxvqB5zWosRwwSOVgyra7tH50yDV+PkPnwBshL8vLw4PnWEqFOter539+mhu7iHDENJVpYloyo0sLHR7mxxQrV0cytzNE44l/BXAwb2Zh/sIG41o7N58iCDhb8G250hrOr/I/xWW80TfA04FVDdmXHXuNnHkhbLOA9VANMVcuIkwL0O1L3BaH2o5BprQkwVXzjAqfcfV/WA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uBRkjZlYYDdNoPUkRuEzqVKzc7bNfow3yblGbH0Iges=;
 b=Pge/R+y3xcAEkFoIbmaQiD1vz+7B4uHim8vMFlbdSFah/+lRVZKmL93dnXem8jZjkRm7D3pGngUOQb0gYhvowBM4BfXOjEfVZlL+eetCeuGNsKayY0Ufkg8PwkBUYBbk0IXznexyDNKxWZOmCOOJGHrx68mtUKZd5I2X12y49/8=
Authentication-Results: suse.cz; dkim=none (message not signed)
 header.d=none;suse.cz; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CO1PR10MB4658.namprd10.prod.outlook.com
 (2603:10b6:303:91::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18; Wed, 28 Jul
 2021 09:15:01 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268%7]) with mapi id 15.20.4352.032; Wed, 28 Jul 2021
 09:15:01 +0000
Date:   Wed, 28 Jul 2021 12:14:35 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     dsterba@suse.cz, Kees Cook <keescook@chromium.org>,
        linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Keith Packard <keithpac@amazon.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com,
        nborisov@suse.com
Subject: Re: [PATCH 01/64] media: omap3isp: Extract struct group for memcpy()
 region
Message-ID: <20210728091434.GQ1931@kadam>
References: <20210727205855.411487-1-keescook@chromium.org>
 <20210727205855.411487-2-keescook@chromium.org>
 <20210728085921.GV5047@twin.jikos.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210728085921.GV5047@twin.jikos.cz>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JN2P275CA0010.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:3::22)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kadam (102.222.70.252) by JN2P275CA0010.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:3::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Wed, 28 Jul 2021 09:14:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ec38b362-f2b6-493e-a258-08d951a82d82
X-MS-TrafficTypeDiagnostic: CO1PR10MB4658:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO1PR10MB46586EC97129754A6558351A8EEA9@CO1PR10MB4658.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VTNQgm/gYV57+vJtysoLh7qJb8Klrvu4qt09jCbAoJe110dvBpkeHmrn4UmoVB9qY1BY+trljrQ1XFNAe70CYGOnzhXwNYWGEBqi2PxgscgvcwBm3yUwpcSYpeD3ehL8llJ4HbRHf5u9Rm4O/A7w9Tx31tctNg2L8JnblevQ5eDmvIQymdsXh4/txvZ7mD8KNfAhMRZz3YeDUAUp+8cBPuyNu58GxoN23CT0qVJQhLVm52+XkAi2oPiXY3ATC5sUK2tgYTzbJqY9MwWGvs6FZ+yrAPSJp71gyzAaawJizzxHvoTYMi4s6ts1r+CWVsHScW/m3+ol8yMoRT8jwxo2CmNiu1Aflmrkvp/dkDrMAWX1NbIxFiUlVMzoEOiz+NgfUv2LhDbqFQpyQAgiAyKJ0Jdq5YXNQFq7HVO3xHDklNuGenWcl7YwPhz+2IPRXtzWu8zLkdlC2ReTVEk9y2etobrqdzMeX/nQOYMw48U9vDct1KYWKb7ROejPW8kNdEQFuEELSPxBqS+Vz6gU4FquwrPdPei/Y4V4uBlVfJlmsMx8maPQ+3HWYxL3SRiATHK0O3qZEQXkWMYxaK+AnDyOU1WeBs8zFtTfCeQbLL/AnviBrw6Ntgul8+sigmgriQVh+/nj06m+nHpjGzTf0yZ9w2dOS5iLt+xKbDhACpeudKW6L6c8vRWXUOgLM86qICZyY/NQOAu2xB/xFBaPZcpWB6iXrXGy/koGD79h7Skcj64AUaKDOowpSoV47bI1QRaEVXy01WBLfdjeSZHBN5Ibl8n4l2EE3CT4H0mAgKYXqIEDx19/AtkjXYWoce14kzFsVSIPWpP+TaDXAamkkOsaVA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(376002)(366004)(346002)(136003)(83380400001)(6496006)(52116002)(921005)(55016002)(33716001)(38350700002)(38100700002)(5660300002)(9686003)(186003)(316002)(44832011)(26005)(66556008)(966005)(66946007)(1076003)(33656002)(66476007)(2906002)(7416002)(86362001)(956004)(478600001)(110136005)(9576002)(6666004)(8676002)(8936002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eb7RhCFZJReG7kmLF16WNYdTXU5OHR2xELDlhxaol3Dv0pfh7Rwrom5t2U2F?=
 =?us-ascii?Q?JiAE99XQ2EVTalby6i93Qmw73AVkqJVsKX/OyRQXAnZGFEanVJECuaPiDKyu?=
 =?us-ascii?Q?j8nVom4ASpGxaFClMrdNNch2P0BzGaijcpQ72Mf+f9PGR9rQn+7+b+qysCLx?=
 =?us-ascii?Q?etC4MebBPbdqaJkkmjep1gG9I1fUvsABTDvs3ja7mM0PpfPzOfpk8A37W6vC?=
 =?us-ascii?Q?455QMBcM+YUKFc8FFYpseV9uIMW+9bmzq59HqdnNwhFDvYJlmVu3pV3W4PAe?=
 =?us-ascii?Q?s7oWuEqND1MR13FtRN287tygud2Oo3LjiVp2IDi9L0itj1MfBv9OTRN7ZDAm?=
 =?us-ascii?Q?+y64a7e3ZKONe7wYQQMmJfS3ZuqvqgecdWtCWsPXkPmIDiDpVbZZRGQsRjIP?=
 =?us-ascii?Q?FcUVX2Z5H7/etXy3GIuI7vPCrL2A7L/3GM30E+OMaDcY1P0Ne1J3pdxoidun?=
 =?us-ascii?Q?l1WE1ILTjyVWa2jOd88msucQjHSY4jMeQVCtU4cTuzwDk7J/oWz3gbZE9v9S?=
 =?us-ascii?Q?pU/gBrZyjl+FBNo0QPd8EqUOmLNqUUkmgBK8XX6v9ty1+i0SyGmcAAWe/h8G?=
 =?us-ascii?Q?Bl+6eIL9MqOD32AsBHE27dgztr1Jm9IwQK/yISlf5EYlgu2VL4iEEACQo+Ko?=
 =?us-ascii?Q?l0WUsiDYu3PW/ht4rPTLuVV6wVA/OfPhj8ojKak1051XeaZU0hi6PDayeG90?=
 =?us-ascii?Q?+DRxXXOAwWkxMv+WPZ1CVZiAGjSOOyLqZ6X92F7vl9KWucmyEd2aRjEa16Ks?=
 =?us-ascii?Q?iYmuTf6qNuYi7dRwaEQFJUooSHN0tN7o0x2imAQKwOhQIq3N43l3eTCtbXeY?=
 =?us-ascii?Q?Lril4DpIs4ecHnNLKfONhwCvpXFoxy0IP014IRecsMpQLZHwJ2M5vDHSKWkz?=
 =?us-ascii?Q?i3dts7mYrxMEWwV0GvlBMVT/Hl7wkwr4pq+h609+qcmEOY0RSkdvBHi2vvIu?=
 =?us-ascii?Q?oV9/duiw6iLb1t56jUzxI5TcDVDOX4UW5EAU98UhOdRRwZAh9Y2e7TbtjsrF?=
 =?us-ascii?Q?xDJuwUdIpN72NMd8CCAZHR1kAGZid5K89qCDGc1ABWb3xYWbqfu0ucqrdvnr?=
 =?us-ascii?Q?wfYnH1opGUcqYusTzMPDADeFON3tUOf8PXAVsYGyLzpmPIoXmgOsWCuZNCcK?=
 =?us-ascii?Q?LHUjfU0AMIte4coO35TRHJyiTkyFlZ7aBlgX96Tlduy1D6/UKXARNc2OsMi8?=
 =?us-ascii?Q?LVzHOZEziWbiFkEqCitl+zreLHPoIPvInXesWjogPv68c6PUTR+jBcttPyeq?=
 =?us-ascii?Q?DTp7QxuvfK+HilaS+4i9VYu/SucD1PYiedl8rTh+6TtoHiTcYUJaaxVVDbfk?=
 =?us-ascii?Q?mH4MXuXseKwqIBXy0hMyxDPW?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec38b362-f2b6-493e-a258-08d951a82d82
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2021 09:15:01.5463
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R72i7g9/I8+mtCoWZ/KaOn1hrwjy7rjPecVR5Qgmmv8+g9Kz6MdcuMzv2+2xkIb6dMCJ/fLC2Sa25fpn5QrCf6WXCy3mHRHvgu3nI7VRto8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4658
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10058 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 phishscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107280052
X-Proofpoint-ORIG-GUID: O0u9XEyhEFqXzFqrr0nJzm6p2-mprUK7
X-Proofpoint-GUID: O0u9XEyhEFqXzFqrr0nJzm6p2-mprUK7
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 28, 2021 at 10:59:22AM +0200, David Sterba wrote:
> >  drivers/media/platform/omap3isp/ispstat.c |  5 +--
> >  include/uapi/linux/omap3isp.h             | 44 +++++++++++++++++------
> >  2 files changed, 36 insertions(+), 13 deletions(-)
> > 
> > diff --git a/drivers/media/platform/omap3isp/ispstat.c b/drivers/media/platform/omap3isp/ispstat.c
> > index 5b9b57f4d9bf..ea8222fed38e 100644
> > --- a/drivers/media/platform/omap3isp/ispstat.c
> > +++ b/drivers/media/platform/omap3isp/ispstat.c
> > @@ -512,7 +512,7 @@ int omap3isp_stat_request_statistics(struct ispstat *stat,
> >  int omap3isp_stat_request_statistics_time32(struct ispstat *stat,
> >  					struct omap3isp_stat_data_time32 *data)
> >  {
> > -	struct omap3isp_stat_data data64;
> > +	struct omap3isp_stat_data data64 = { };
> 
> Should this be { 0 } ?
> 
> We've seen patches trying to switch from { 0 } to {  } but the answer
> was that { 0 } is supposed to be used,
> http://www.ex-parrot.com/~chris/random/initialise.html
> 
> (from https://lore.kernel.org/lkml/fbddb15a-6e46-3f21-23ba-b18f66e3448a@suse.com/)

In the kernel we don't care about portability so much.  Use the = { }
GCC extension.  If the first member of the struct is a pointer then
Sparse will complain about = { 0 }.

I had a patch to make checkpatch.pl complain about = { 0 }; but my
system died and I haven't transfered my postponed messages to the new
system...

regards,
dan carpenter
