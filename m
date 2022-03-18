Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E54864DD566
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 08:46:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233266AbiCRHrB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 03:47:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233276AbiCRHq5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 03:46:57 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB4CC1F6369;
        Fri, 18 Mar 2022 00:45:36 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22I35vmQ015494;
        Fri, 18 Mar 2022 07:45:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=lewefU/nMD/roNPvEaZXHBKe4XAe8Yz3nBqg3pguDko=;
 b=r9vhMJt2bv2sKUgqPi5cejAk6RwshNAKkW7EZGTK31I547XjTA6dKsA+ORj1NjrmozBO
 qdnH++gSojptMATTxEN10chZQ4UWg63jGdUtBD50iqXniEi+ypbCmBZaVz3Cb75H0B77
 LpKCybOHrr9wSlSs71iYWgQ4PmSUCAKH9P8NqupgZeMan/4ZHYzqZx/Bjr48Jqjmv5Sz
 vTaigrFNgN1TwgUcybuaq2RGEWXMbnbejIvVkvIYn4MSHTCqxgbuDHD7H6ueDukd8sXr
 FN3kxhVKO/7c0VSSFAYDkxo/f5WWLBLOFO7kymVZ1eRqT7N/3x3cNFDs7Z/gY8VvPUJ0 IA== 
Received: from aserp3030.oracle.com ([141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3et60rubwy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Mar 2022 07:45:33 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22I7fjxq110178;
        Fri, 18 Mar 2022 07:45:32 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2106.outbound.protection.outlook.com [104.47.55.106])
        by aserp3030.oracle.com with ESMTP id 3et64u3fxm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Mar 2022 07:45:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ScGoauKxNqf/+BzCZBUoKyYx8h3sTy9QWcdLPrxjwO2jxhK+18m48nGIyXeYOgzzpVjbnfjCJfIW+ZH9896iF2jtk2+UqalHX2JCwV9V2EyH2vaBTIpTl1iUX9m3xLnuSvL7wiorv9+ReSSpQ/COMnuiIn0EXTXn6czCAVih3x9INZhvBKTdcssRXBaTLY1KKBx5Xwcr0nUNih2nUV1PCmTCGQn8d3LbFZkYMpZYNsqa5n07n4LuQsNhtEV6NS5qudDLE707XmV3VEJ+LXsTfuEpwdWwMqoefw+NfK6kstJ7EK0D+nMExPpElbhFVaralJCje8v8P4a4E/1wmNIbBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lewefU/nMD/roNPvEaZXHBKe4XAe8Yz3nBqg3pguDko=;
 b=bb6aszBUR1wtc/vG9upR5grAx23S3oRthcymRfwGpeYeVFTrSH2f5DQ9Am2l9tJHvY4f8Cb9OhzwWy80vA9KtWzhGOAEmiXazJeLHYzKq0rYN9QrlydJKtgZlpOydhnfP0I1TT/rha8K1eaCsbD6g3o1AkCATGgsj25grJBxyQPdMvSiSXj7SEGuxBdhbOpnc0KCSo+AX986zvlY+bYn+WQXaWr/r9x3C6PTAe66T84QPUvRlyVmvaH5wWPcAnC6TwHTsjsNEIodJeERbxKY4uoqljqlNWcfENlpLMmwsEM66rjuwXajZQnopWZDn2RTQtdzCei8bfu9fCVwFOuuYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lewefU/nMD/roNPvEaZXHBKe4XAe8Yz3nBqg3pguDko=;
 b=Z1dN3aTMOxrr0yh+MT+wYXolkiCznanWCldU4iU50sKhowwRk3UKtr8Wp+AGAY87FZ/I3VMzCwEvGgjOEBzWJdLmmc5F/nXhizga7j8+TKSdZa3vxCpse0HreGcWokvWR+3F0rFz4X3Bz4VGgkN4O1jZeSC8PlQpDXxLZDAqf6s=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CY4PR10MB1671.namprd10.prod.outlook.com
 (2603:10b6:910:8::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.26; Fri, 18 Mar
 2022 07:45:30 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::2c3d:92b5:42b3:c1c5]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::2c3d:92b5:42b3:c1c5%4]) with mapi id 15.20.5081.017; Fri, 18 Mar 2022
 07:45:30 +0000
Date:   Fri, 18 Mar 2022 10:45:04 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] ptp: ocp: fix sprintf overflow in
 ptp_ocp_verify()
Message-ID: <20220318074504.GD3293@kadam>
References: <20220317075957.GF25237@kili>
 <20220317170449.qxcf4yi4rzlgbwzu@bsd-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220317170449.qxcf4yi4rzlgbwzu@bsd-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNAP275CA0004.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4c::9)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aedbf7ed-d600-40c5-92cb-08da08b34645
X-MS-TrafficTypeDiagnostic: CY4PR10MB1671:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB1671359B593657929669FDE58E139@CY4PR10MB1671.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4fUR750lxwHuMPKKw09Ifq0TboBEXvwecULf9lPoTONn4eZk53CEHiGPAyXPveBHbhg/35pIh0x/1HSgoddp8c1mFHo14RV8PwCTFcKHxlrB8NCBo1SSKMyKHaoUKtYoOXUVFNNyFWCnjSl24wgETfxITGe6LZhsn5MWw2j+RIuSDF6GpkP/W1iHtkiEJG5yTd4w+vfjuooe8/7XmaDLo2UKTxceuR1DxksX44s36Lft8UGS4N14fNgQcEZMBCcz70B/Jy4ZuZ2tFFoE+VGYonuqW9Nyaq9CLzKZKSaeGTtLfThZ/W6UmehK0wM3F7SVKTe8J0AXCuefrl9cqicBSEN6C2tVvxz586Rp24GO+XZ66uOyJ9PrqbWj4c8GLcwIjLVpDtL1HlP+RUvA0xq283qvE9aEee1D5yx5iwPTwzybWUDZWKfTMDZXPwbuQoN528iFTtL4N4/KSC0+Bje9Tc8U/0B8Hgpsw851fPeHE5vo3yV607j4Du7gAZEYG421IA1aeU3HtYCesWeJmRJHL8yQrP8c3R2XvuMlUJJP6NquIRTAPCz8j4/X3HBcAUkzmlXpwgMQkK3PQhu5J4ut6jo3anmdn+QBH2QBDFFX1IC/qpbHMkltrZtpIB44TpzUvc3bwgvnqdlZ3lRCZsRTQpeYepk/NBHqY1bTSyivgAb5HxfhR01NcWORbCNKY05KKR6dhtYTZgWHOpWiQJSGMg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(6512007)(9686003)(6486002)(66946007)(66556008)(66476007)(4326008)(33656002)(6916009)(33716001)(508600001)(6666004)(8676002)(52116002)(6506007)(8936002)(5660300002)(44832011)(316002)(54906003)(38100700002)(26005)(38350700002)(1076003)(4744005)(186003)(86362001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nSKVlvwnkqS6NOP2YGb0kq6ok9UN1iKiAQbpvh0aC+bq2mQQAaqBpBux3fKX?=
 =?us-ascii?Q?hYVLayBvXzRNdRiZXzhfHoOjdiTn7592JkF6hKGuzTpYHuxz4Of3Q9eXU3lY?=
 =?us-ascii?Q?4uDeSbboit1AxyZHWlbhIa62DpMIxJZBLNXHWdb276NmgsMIy1BAl7Qog+ao?=
 =?us-ascii?Q?9j/ieExHtx6PmCdvOAJP9jn6w6HNfqGj3TtQofRpx6mXbpRPpB3CBUB6xHyv?=
 =?us-ascii?Q?Iz4tgmA4Uffy+9sTaELU9+SSV6HWxeI6R2jBKRRF+MBjTPUEJcSN9K/SvZGx?=
 =?us-ascii?Q?XG8NxcL4Bc8WebDHvobIvwk/a4Bwu8VKLcY0rusWIYI+GqX1bodLSiDngezy?=
 =?us-ascii?Q?3JhdZA4dLVxw8TBhkOAl9ZLy+5ftDpnZza4sKFxYodB3XP9d4uOi0rQzeXm1?=
 =?us-ascii?Q?YSAfUC7PGaM8cMom9Ukfzk0mrU9q/a61kWO5J5kDst7yTt3dG+GPFl8Qaaig?=
 =?us-ascii?Q?EMp/fH4trcFYsIf4ezfGWLfa+XnWwrVWHK+9r1rZuB0PZyobPmAwC20bQm1a?=
 =?us-ascii?Q?t6CLrBn/1yE88h2BhRUiiXIvpL9TsPORgV9JMDATtVRoDIUg/3reBUuqw/cO?=
 =?us-ascii?Q?iOy0ILte842gUWeIjJR+/OEm/oztwXKgwDnxzeCLP+Fgk4ilMhPUHghEUwlx?=
 =?us-ascii?Q?tNbAQto2reyZuaHM9/PzwP3U+uWDpkeDzAVbyq/cosCs3EGqCb7Pr+g+4h/m?=
 =?us-ascii?Q?LrJ4mhLWfTmWVs4quCmO2fnqUmS9sB8OSgR6jdMXJGQ9TIt33jAocHHzPP7F?=
 =?us-ascii?Q?eFIXQJmqwHRXSDI0YaXS3+aCLEt4G+WMYAbEwC1b/TFyPp2SrRD46q2zBhYw?=
 =?us-ascii?Q?X+EmU6mk5uy1PHKq0doI2kqDW7GHfSmf3VM+1IdXuF2MoXc2FoCemjEn3bIR?=
 =?us-ascii?Q?Cq9UB3Ai+A/P/qc7nlDtsmXU3vuxtXTNC+tpHAr85d2z/v2sfjB2QFP2754d?=
 =?us-ascii?Q?V/gvgTxWRuy4PGha9bWmhbg2sY0iE08Kq3SP5XMiwdRYW8RBMkfqqlvrgP9I?=
 =?us-ascii?Q?U+dwLC+DdlN8xomSnUlV72Km34Dky3noLdG+RHEG6t6781QxHWh+b9tgX2ii?=
 =?us-ascii?Q?pm/KP7EgO5E6B54ou0F3pDnRz3LrsbfWu6be+noXTDV39sJ7rCZWl6285SgE?=
 =?us-ascii?Q?k+VsJmsDetiqvHFVWMNHnDB48T83FAYL+H3nvfvJBSDgmKjIZTsIbaN7PJJj?=
 =?us-ascii?Q?fZlSgWszKK64lUeIMDMOJP72n9eGMfti4zWSWMbhbkif3LZv61oNkv4fzzkM?=
 =?us-ascii?Q?qWSOz+j/WNmraJh1cuafCyfEEahfhmbBMWFvYCQ8wgUShgQOhTtwGnURlfZb?=
 =?us-ascii?Q?L9/JWmoMKlzBzW09tQAb+huYGQ8V4xtosdR/skLs4hc2GqTgttuAsRfkGUWk?=
 =?us-ascii?Q?7JGdZXSJFuuRknfe6Xmt72GcTFf4KZS3EsR1XAeeCwGwFTAdTQQ4GaPCnWkZ?=
 =?us-ascii?Q?PbDuXIpaAm1pP1Ld982OLFgkZ6jSgqRMe9jFmfsW0RU9vbZOJcsWJw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aedbf7ed-d600-40c5-92cb-08da08b34645
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2022 07:45:29.9510
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3fgWcWiNL8ftIxhOYY+cZw+Px5pMaptDeUjcTetROL2abXHR6KUOQ6SjBSRfDqV+iBdfpcpp7JzWhTKVS6DkpDmbc/7wTCqWzRouQXBJv2Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1671
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10289 signatures=693715
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 phishscore=0
 suspectscore=0 mlxscore=0 adultscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203180040
X-Proofpoint-ORIG-GUID: PMF1R2NYfYPYRpzThynZKScihLw2MWJB
X-Proofpoint-GUID: PMF1R2NYfYPYRpzThynZKScihLw2MWJB
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 17, 2022 at 10:04:49AM -0700, Jonathan Lemon wrote:
> On Thu, Mar 17, 2022 at 10:59:57AM +0300, Dan Carpenter wrote:
> > The "chan" value comes from the user via sysfs.  A large like UINT_MAX
> > could overflow the buffer by three bytes.  Make the buffer larger and
> > use snprintf() instead of sprintf().
> > 
> > Fixes: 1aa66a3a135a ("ptp: ocp: Program the signal generators via PTP_CLK_REQ_PEROUT")
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> This needs to be respun to catch up with the last patch.

Thanks.  It turns out you can't actually trigger this bug.  Still using
snprintf() is better so I will resend.

regards,
dan carpenter

