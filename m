Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0277358A5D8
	for <lists+netdev@lfdr.de>; Fri,  5 Aug 2022 08:22:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236110AbiHEGWX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 02:22:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230492AbiHEGWW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 02:22:22 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AC515A3D8;
        Thu,  4 Aug 2022 23:22:20 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2752iRAT000931;
        Fri, 5 Aug 2022 06:22:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=TJBXIFFQNVWal0UHct5mUaa7riPi0HAbR54rOpsSXJE=;
 b=eKt2CPiQcrQjs/FKy2oGM4FWFA1UPvGdyeXwJFqnTqS7Oa9Wai2oAeXC0JtJKyEMpl8k
 fAj+9zvBtJIuHKedd/yy4JEAdNSgvLjne+kmZ8dAMU/Fz9uc0wHPd5hNo1R6KADcBuJB
 MwB/KcscjGS08Vgoq0StMaJaoXRFQK2JlYFOkjhcY4pe9j1RvhctssDf/aGFCfo8TceM
 XBqmgYDllm2jC5b/lF+QbZsQN315vMfkxzGS5S2UbJKy6SvRB//UhcpVIkqAYdkJXLlb
 4/DjW/IMAxvGRxDLwascUpARPZENGwSNyBIvh6QBE+iDyzRA08hh/IcoIiue+KdZ0LYr dQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hmu816ud1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Aug 2022 06:22:08 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2755XZ0e014234;
        Fri, 5 Aug 2022 06:22:06 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2046.outbound.protection.outlook.com [104.47.57.46])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hmu353nch-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Aug 2022 06:22:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EfV7dX0kV/6IlRZUswVrnwGTVnHUlmdDF+J/mg8jq5D/MlqO+xRMr55Q8s6zjbIF7IzXQ/Gn1sTjDUwhxsyXAPW9605Gsafo+aoRFxxuhR98p34pAYlFPMmZU56zEFuBeh3JRxJQ2MpVIH+WteY9VqqxarZRRbyT0Smj9pOsYSd+mJojbJJnmULHSz0LAGFGgYWj5QtBjQ08u3impw+r7jv1YoviocYczsydRWA88mRIetgQNjP6wBP9nH3ahjT5ijbJsJZF62yvvcUoFWMuSr+pZQ5yAIbRkZhTVwITr5onWGEQQ16wf3XsFaYTl3Q43Psd5WL1v6P8cpZaZIav/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TJBXIFFQNVWal0UHct5mUaa7riPi0HAbR54rOpsSXJE=;
 b=BH30aOIPOmn2BaPYmqaePCo6SuI/kvj7x7h/8tMScFzlQ916+lzJxTtV0tk5ZFeGNsGPdbZFazAMR7zV7HuiK6xmnEnju+ZG5h7U3YdbwDCqjidInxDhfsnyFchQd8ZSselu5hmVmhQrO0pkqvJJeFWumcC5degA0Ml/GK6ECaqX0AbcA5f9JN3xSfhw/KNWDCl3gi5L68n+yO8SsLxsaOy3/0eu+BTPkejwqEbBG3u2Ttq4XK7+oDs4BoLrFFa5MXCSHTxmITgYYlQceZ0ZfBAm9hz5Z1GgD2wVXDQNM1/OHfFwudT4OJW/y+TRNYit0/3cGj6/Mu2MniYDaj2XuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TJBXIFFQNVWal0UHct5mUaa7riPi0HAbR54rOpsSXJE=;
 b=NnXtYOoHKBw9T45HpW/Y+0VylyW6c1SOKFGwzODVIgbsnb61h6bRPfUNnzkyWWEjR/14wG+Qm6YZvFVLGOGBUvZL9VUhUGiKc1weR7+8vUInVVHZLEqNWhfF/hV+xZaHBYUlkaHdJj9/NqTAaqcMZY/EOziRtjejdGKU5CTMbQQ=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MN2PR10MB4207.namprd10.prod.outlook.com
 (2603:10b6:208:198::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Fri, 5 Aug
 2022 06:22:04 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::209e:de4d:68ea:c026]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::209e:de4d:68ea:c026%3]) with mapi id 15.20.5504.016; Fri, 5 Aug 2022
 06:22:04 +0000
Date:   Fri, 5 Aug 2022 09:21:41 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Tariq Toukan <ttoukan.linux@gmail.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Tariq Toukan <tariqt@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Lama Kayal <lkayal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH net] net/mlx5e: Fix use after free in mlx5e_fs_init()
Message-ID: <20220805062141.GG3438@kadam>
References: <YuvbCRstoxopHi4n@kili>
 <2e33b89a-5387-e68c-a0fb-dec2c54f87e2@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2e33b89a-5387-e68c-a0fb-dec2c54f87e2@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNAP275CA0009.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4c::14)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8ea2fb4d-616e-487c-298a-08da76aad02b
X-MS-TrafficTypeDiagnostic: MN2PR10MB4207:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DGUmgAhcWD452GOQy4nlZBthV7FeEw68rMb71Y1Nl0IbgvUPVaiINfmB6HgAIX7h0RZrfDjX2dQmqwHfLxvoNzT3HH/1ubCvYVGB59aN4KR0+lpxfTnWy4eOVGuKivBnQzv+y7q8yqZYteq9jd/NgOqmOwS+FICkVzulIpHda/lVxjg+lU8zk5+KF+V4Y68cdmAnUbUecoFUFzVTnUjG2WKYW+i+bDFIPSJOflyamcYzT8SGSYsu2759eCkjRT8T5+QPzqBxjl0hX+nISO5N9rv1LnW4TXgwE6OyAwG4M934y5/AlTEBSw6pXBsCYJXL/h+1Vzg82obOBwwD/z7lUcGRtPzTKlhnUJzu0a3IUBw/ieJG0bjDnXEpoRmoUG+I71rJr2FB11KVAIj93gMtmj7CxIAQFiuKmrpmdZC9PHcYxvuqJOsTGxTJ3JaNllh9NAXPMW3319IVI8c3jdXzH9APEDCr95zCtRcVi68zVbBfVCPKwD/Hd00CARYJhWkm6J3yCWCmRr8ybyPqDrKF1WXc0UVGFZbwTHHnppFHhgXdTT2p2oBWTCkrsqZL49zqCaX0Kprno3vut5wnlk6dCuTF2UKlvSVB22tfjmrRygWSasGVuXA6wf0hapPjT83UMHd1savEm8+dkxs9oJJM1rJp6CzdM2NgD8ZZBhAwP39yYonw+ea4RgVAojA14unIYyjQQWQ84sP33TXDKNfUQwAFK6UhqDF+v8ReptKmlcc4w1TuGmktvnH9T31XnZZ5a5DE9vq8dCeINUH2LstkYgVtuAuZutjmAN451/LJFLU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(39860400002)(136003)(396003)(366004)(346002)(376002)(38350700002)(38100700002)(1076003)(186003)(66946007)(8936002)(4326008)(8676002)(5660300002)(66476007)(66556008)(44832011)(7416002)(2906002)(33716001)(41300700001)(6666004)(478600001)(6512007)(9686003)(6486002)(6506007)(26005)(53546011)(54906003)(316002)(6916009)(86362001)(52116002)(33656002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TEDwNT4FuClRWbQjd6JO3l+BNTQMeCLGqTh7iew8Ka38hvHfd1HOwSZjtvqL?=
 =?us-ascii?Q?pHe0x8tzeyuRo4oDbMbHs9eUnFjwpyE4XAWpV6APoLx7rbVmVM6pk3vwskYd?=
 =?us-ascii?Q?Jlrs78p+RrqDg+0JkFxUHJCLu38Rw0CSc+z2YXKGxopAqA6msxZlLrZMcc6w?=
 =?us-ascii?Q?lFmlZVIlqCMZ8/sSePsDEURnLbdUv45ObFb6iAcmwePqMGMocZi1BIP3/XDS?=
 =?us-ascii?Q?nTEaBxqSSl746YZbJDSY5XD+Jqf0S8qd1w0smy0E3lMPctltOqlbDBU023AA?=
 =?us-ascii?Q?MWQB0MDruSTmnVOeizcLufcP7gSvJcR+etyNp6IHF5lTtrv++Hln7hwmq/5w?=
 =?us-ascii?Q?sJa3FIE4Z9/aKP/oaSSAhi4ydZqZ213fcSROD/oLmw8itffla9p53uH9AfCT?=
 =?us-ascii?Q?u+Yz/mpqSAfKkkBy/6dzE1lLaXQkO+2R8EwMFgaQ312w8w78Rd/ozTNdCZuO?=
 =?us-ascii?Q?/4R448OLkCd+ss8H3X3n5FjYIa4W1fnEZuO2sCoRNnSYbu4SxAUlZXErYNHG?=
 =?us-ascii?Q?lgmlRkKD4BA4MZMiCg9lLKol0SDuxzIA4ooNCMqnF5aB9p94DtgQ0MIiGFQG?=
 =?us-ascii?Q?yJXLAd2eIk3Ey6Ttfk1177+RaqLEWPAKNmJMXjpL8AbglNBoDwfgWDc7mu/c?=
 =?us-ascii?Q?A15PHi5kSDeCi1laxnokfWVe7keo45h7gqDcpDS+So/OcZm5p2RPXI896nlV?=
 =?us-ascii?Q?s8XMtZVKK/ELnTv3zJQ5Zah633Is+tHvsIeLp+0c0etd8hotkkEuHw0c+j9P?=
 =?us-ascii?Q?Dkb8wbr4ji8biaANYv2PZepsVjcZ1yTsqUYdoPwgVr7wGmFO8fMu3B03qKWS?=
 =?us-ascii?Q?0HFbuql92NeVp9bfWJntZS53W4wsr8YW1fEkg7C2h5xahn0lrYS7quthm/zF?=
 =?us-ascii?Q?czoDHi9Q3cqrHPjUKv4Uqm76AQUghpd/+CO0Zg4mb/iAWhKKyEO7S9E/LzoD?=
 =?us-ascii?Q?uL8hbz8yRrTcItKj0xbmeWgIopgqpFtUbS6X1xEcx18BeIuoivaLj9/dBYZN?=
 =?us-ascii?Q?arTFx+jeJxTQ3P6bZSJLhs6alYRWBjoWM246EwoVRZskCg4gZUlEafZT/Twn?=
 =?us-ascii?Q?ISw5ZVnbWUtx8RVl8W4OXNBUFCLg4YMzQOnA695yEMny7+7wpq0m4H59ZIp4?=
 =?us-ascii?Q?2WjfMehFsJkLC5AzrCMIuBr2g75y3z9ch6cifHIsI7HAs1S0bXZ/bmOmq9d0?=
 =?us-ascii?Q?H6HZYp/0vGG27pIdfFEkN/GSaSqKLvLJtAa1u5VQH0nkFJ1FRWJ+ZPofFLpD?=
 =?us-ascii?Q?lvxFtHAcVfF/6qgZwFJTYo95EJMTZuZxLG/TJA5DuIRDn8FeSyB971vWPmcg?=
 =?us-ascii?Q?IlpGlUNx3SpStZGNLLiCAn/W0KWnrc8TqoF4pKnC+p55kmlo+xZYEpTKLrks?=
 =?us-ascii?Q?JFXhjm87Nmmy4ST3X2J1zSrfNckb6WFtl5ZW+IPNgPQsTppB01GwVeJ6bk3U?=
 =?us-ascii?Q?DN1Z6ohi8/5eZpL+mBD3gsSB0WhSSsfzhfsvyAy1K1d30eYjWWHIfWlyrJNW?=
 =?us-ascii?Q?rSqOVsTcIRrpNfvTZb0DAh5SQdcOYSVi4Sj6RGu38b2ib0/O0ZqMg3sKXAPb?=
 =?us-ascii?Q?FcO30fggYYqjIv2Ymxc9lBp/WaoY2P5nPCqICyaXAwzOvBqYbsvsLxiXo2cX?=
 =?us-ascii?Q?mg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ea2fb4d-616e-487c-298a-08da76aad02b
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2022 06:22:04.3009
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DiafBC0Kxnax2+VYqTmk//oITSy77Qj/XrMbzcqwgf0vQzQ8DtPCXjw34Jpw6m4BneWII8oDrrE382xdQUYRF+Nqv3idaQ3chqoqFPhK4Oo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4207
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-05_01,2022-08-04_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 phishscore=0
 malwarescore=0 suspectscore=0 spamscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2208050031
X-Proofpoint-ORIG-GUID: k5XDHGCeSFgdBwcf8OTmVBXFpQX42GUh
X-Proofpoint-GUID: k5XDHGCeSFgdBwcf8OTmVBXFpQX42GUh
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 04, 2022 at 06:04:52PM +0300, Tariq Toukan wrote:
> 
> 
> On 8/4/2022 5:43 PM, Dan Carpenter wrote:
> > Call mlx5e_fs_vlan_free(fs) before kvfree(fs).
> > 
> > Fixes: af8bbf730068 ("net/mlx5e: Convert mlx5e_flow_steering member of mlx5e_priv to pointer")
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > ---
> > This applies to net but I never really understand how mellanox patches
> > work...
> > 
> 
> Hi Dan,
> This patch belongs to next kernel (6.0).
> It seems that net-next (or parts of it) is already merged into net as we're
> in the merge window.

Right.  But commit af8bbf730068 was merged by Saeed.  I think that went
through his tree and then pulled into one of the networking trees.  But
sometimes these patches are pulled directly into a networking tree.

I can't remember how it works, but it's somehow my job to remember this
stuff for 200+ *hundred* different friggin git trees and put the tree
name in the subject.  :P  (small rant).

> 
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

Thanks!

regards,
dan carpenter

