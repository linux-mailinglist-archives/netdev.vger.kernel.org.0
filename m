Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A9524D47AD
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 14:05:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242174AbiCJNGo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 08:06:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232049AbiCJNGn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 08:06:43 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 663BF14891C;
        Thu, 10 Mar 2022 05:05:41 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22AA8bv1002644;
        Thu, 10 Mar 2022 13:05:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=1kHZYehAREvDVGmPYHLTPxvX7nD62cl/SnzRNkFuTx8=;
 b=HBoNeJil5eTg0ZYHfZdD7jDtmuJeTCfgIveTW+j2VQ+ymsEDhP0IK6do0FakhhsFawUG
 m0RgZrmYB9/nV1XD3g9CHWcDQUUt5B8AXpW/OsoEs+On9+m37rFfiWg1mzJRvWt72E8J
 HBcEp5XRz5YB42WiMBZb1osQWVTiNhEA+Tq6zPWWedkRMsy5Py39DW7Ih8llUy4M1vlM
 5V4wq3Kq6Bb4PAs3Zd4eLIk2TRjvYv3XVTP4yhrJU9WYv2gN1rPiB4wJ7LUb8HhJMNVy
 zIZ5ocOGs4vpSvgzNQ7XFqwKnk15Eb6IIp69iBfE+G5KFfItW/qnlBaOG5qxmu9mVi/J Lg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ekx9cn05j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Mar 2022 13:05:25 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22ACvRmd193376;
        Thu, 10 Mar 2022 13:05:24 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by aserp3020.oracle.com with ESMTP id 3ekyp3jju9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Mar 2022 13:05:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dgoecPprB0T730rKG79BmyhkGC/J+YQF7lArW5ev5y/160iohgT6lYSPXrZOBZ8Np/epg18rpZ7qKQLSAmcwNF1fJzzBVIUwNGptOtXQW58s19rxntMFnEIaS9Qoik6Id3xFNntEE1JQWDEKiB6+B9anvLjucpN57mh/1QMdku+Hz0wbEl7fJuNVb185G8CbGNreoqpnxRq/EXCMI39qQrlfI/19PROGWFe7PbfHOmZhhZPmchMfDmcxZ0EGurzZX43iMt716BP3FKJq8z++A9lyOld7cultuocaOVJA94vcUWFtkrAyeJG1n7rwH51wwAANH6chLzIevmb3eRJJ+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1kHZYehAREvDVGmPYHLTPxvX7nD62cl/SnzRNkFuTx8=;
 b=CtcaqTEg/K5tE0zrVKfmOmWnl0w2C8mcyEtGOMtGOoqd7dILD6uBtvUgwwHnRtnWmeVkbZgtLfAFzLoQaFh66rlBMcMH4woK/oSa2sc9ljkzZf8zt3tZ5LPrBcU3Kr3XtdmAedi2dfkhmXNWJIe9yWYX7qp966p5tzVAoNbVpTWzEsXUc1iq9Xk2k5LtpcQlgx4SW2Snx82j4r0d6MycjgF4j+twvncppTlYGZKc770BKkxnpodG+FCBR4F3K82UJsEbPH0lJ5oMuWNfsJ/4O6vxMCzVajcae1YWtP2qSyfRFyJv9jkPF7U/f6oM9JyY1DR8eWsZVOubfe141hiE9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1kHZYehAREvDVGmPYHLTPxvX7nD62cl/SnzRNkFuTx8=;
 b=qZ4rl24RBInWYVP5WdDQMgpo9nke5VXOUJ6HW/4rRkQvjGrpXaCLd5NZWRmqdx77mVdpxy4upvairIHoZ9GlLrhhMFXV5RU6vtwIF2GJ4oRIQSlW0hIcfKK3Foy/OunRPdfpXMTYDf5yKWf52teb1jhcreWOMhw/U2wkm/RncYQ=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by BN6PR10MB1267.namprd10.prod.outlook.com
 (2603:10b6:405:e::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.22; Thu, 10 Mar
 2022 13:05:21 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::2c3d:92b5:42b3:c1c5]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::2c3d:92b5:42b3:c1c5%4]) with mapi id 15.20.5061.022; Thu, 10 Mar 2022
 13:05:20 +0000
Date:   Thu, 10 Mar 2022 16:05:08 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Duoming Zhou <duoming@zju.edu.cn>
Cc:     linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jreuter@yaina.de, kuba@kernel.org,
        davem@davemloft.net, ralf@linux-mips.org, thomas@osterried.de
Subject: Re: [PATCH] ax25: Fix memory leaks caused by ax25_cb_del()
Message-ID: <20220310130508.GG3315@kadam>
References: <20220309150608.112090-1-duoming@zju.edu.cn>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220309150608.112090-1-duoming@zju.edu.cn>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: MR2P264CA0081.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:32::21) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4f45cd72-eacd-421a-f6c9-08da0296a139
X-MS-TrafficTypeDiagnostic: BN6PR10MB1267:EE_
X-Microsoft-Antispam-PRVS: <BN6PR10MB12679D00CEA499F5D5A2B1A68E0B9@BN6PR10MB1267.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: it6fZGyevkMOoXG3WDxlSpq7v3Obz1fumhrG45IDI3fnt0FVMSYDN7+R9ESXhGpSnsoy8mGcg3xdpW4uvHfvf1z/AN0fX0yl40Tpq3lSyklxT5lF7uOxeOIw3c4OVYjRqgy5IddPu8yUpa/bzfDCKw4RxStFqWuEB3L/iHDbSrv8mBY93hf0YChMuhhnzoD68kb5mRV21xPml9TfwcqA6rrNRI6JhSB/uUAHyFGOisbxPetlluZHdr5WXLnxzLi4mbmr6/jQDJpoiJJ2WhXC98xPII7jztc+8SsUnyQm5B5BZ+y+CjEKRSI0DrQ8FqtPSlPafKy3JJ5bKfgskriCJvL+3Jo3dCHxhQjJCcTtnjGPlmLzBX1HzL3oBSKXypgmG5G9ti9+6fJTxIAbI7jnRlv9PceadM2GodaMHJGX49Gl95DL0vo9ctyYFfJWFICDcjVPn5DRWSu63O2NLb1d3EpwzIpscSmyZoc9QPQ0rSeaK3tL9sU5Y/tuhpqSDNMDwfLJGtChIu4yDibZB7p+jd4zQ2I7rhafh83+9WE4EK+WkvHMymCVdXnuAe1hTu+UhXJN5OfIg3geTdttafCCE1yjuGb1GG+nmAEjiQJiHC+qY4SLCbmeTDtfIFqepR0nM6BAz1VzV7ul+8sV8c7Xga8TsXEOWiiYGIaS8RlwoFi7fH8QRJJK0/uUlrxSKknzKxX06QZB2WUwMAwk8Kzb1Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(33656002)(6916009)(2906002)(86362001)(6506007)(52116002)(6486002)(6666004)(9686003)(1076003)(6512007)(26005)(186003)(508600001)(66476007)(66556008)(4326008)(316002)(83380400001)(33716001)(66946007)(8676002)(44832011)(4744005)(5660300002)(38350700002)(38100700002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?k/mk5PKMUoeXL6AqsCYsHpnLqextYvqVoMDXOlrgUEM9tQ6ViX+rUZwIQU8h?=
 =?us-ascii?Q?YxVfpMsmO6piMm2DEMP5iDft/4wTvyWIrd+ZNcnKg9RGx65+PkOcC0gKwp1Q?=
 =?us-ascii?Q?dwRLwvojV/fvjxR+yDBF0Y8IkkciiiQ2NFb16MQi31FuVEhcy/A+qWoKkbeX?=
 =?us-ascii?Q?HitmP2OME7A3gAoIIKX9u1Ag+DPRu0KmFpRq8/Z5EuZtspZovdAeAD1KkRBf?=
 =?us-ascii?Q?FAYGGyOPYnAq8BqRP/kVu7fPeHqWgUcJ9yELdjla6l9AOCT5ebbRKZITJmEb?=
 =?us-ascii?Q?mLqXZ2ik61/TkP9y1oHiApMx87pzdzOb8o18Fb5lFz4FEqE9M2BxkocaW4nO?=
 =?us-ascii?Q?rRsW+h+FoBSzK/7696LuNUmUDgDsC9S7fwL2NaYQIs0QY8Kshm3p3pvio3Ur?=
 =?us-ascii?Q?F8bl+o83nLmqTVGI/QyQ2yhHjVv0/BC5MQCwHrJx2K+uyuJT5RVq5mEzybrO?=
 =?us-ascii?Q?6gagqR0kaMDZb5K0gAEe3AZM00HVV1i7X5N0R6lxKrV64p82I68g3ZDZBzZR?=
 =?us-ascii?Q?N7h8JbyW13W0yd+AnmVOoglFskV6zQO9sJBoFe9/1IGY6KwlfkjuUo6cvBYI?=
 =?us-ascii?Q?hk9auGGe31RzwWh0V/SdcsZsE/nGmHI35GKuSM+ViAofD8ZhwqKdFQXeoUMt?=
 =?us-ascii?Q?y4IwzJoOH7Zey101YoZ9JlujfpmRSrny45kTiqjfPUjhpN0fZ5gneGdkxbrg?=
 =?us-ascii?Q?6FTIG3bpL3SFyTUCVoGtyOWNh8+MSq/Vec5XRCSRFGQcZdnenIwl569+SFAl?=
 =?us-ascii?Q?Fw/N0/2qRwps3NQV83OXBjqX/23i5uob4qsaHZte+7/cpmKySPh48+OENRqO?=
 =?us-ascii?Q?Y5MQJuvZDCXRB3pqD7sWjBnnyvCUKkUj3ApaXhfxgo/79bFA4kXVKiabASOO?=
 =?us-ascii?Q?pQGXEOx/Vw5ZqabkJcIlJaGFjSGxcl7t6IQ4yS2u9YE3kzu4mN5Y8UAF78j/?=
 =?us-ascii?Q?Q2/yaIIW6Q8RkKRH57STborOEn3084H/m/YZD/ICzGeyeaLqCUzYn9o/w29X?=
 =?us-ascii?Q?Mf8vulshsQnDc3b88irYwP0y1fxAzA6qc9fEvxbbe5jXEXw4h0qGBYF9zLRM?=
 =?us-ascii?Q?oYHY6X+TdAcWKBrx1XetZ+sCp1g5hqcOBIKujD6k1cdyziH3QotObi2OX5Y6?=
 =?us-ascii?Q?K07TJhz0fhmR828tB/iytAlVNf8Ia4J5G4Pj2h6xlr2nRMU2TAfPf/87hTn+?=
 =?us-ascii?Q?TTJUcdWeP46H7vzs8D/IwawQAyxA7vlUN+eX9+qx0sbsQoomWFNv6gp+ywhH?=
 =?us-ascii?Q?G8ZZCxXlxUhe+c6VpDjqokrrqBuERHZTPD5hDpEiXxir6Z+skfgrqt9oEpE8?=
 =?us-ascii?Q?R8XmxcfB8KRGWvQDmXtpnj9OvWM13xhNNL8UsIS7ogBrilNgHvp0neAWpQ6U?=
 =?us-ascii?Q?vq2E2D9Tzdm76+ZNrw1R0pnY2WyIr3Zts2MgAIlxNjB6Xw5CyvUtWmU2Bb9I?=
 =?us-ascii?Q?XGB8LhfHmCNlfSzme6KL5XuTQ+CUwY4ZUgUaMN6xVHWZtmvqaOtrEw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f45cd72-eacd-421a-f6c9-08da0296a139
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2022 13:05:20.8219
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9ivBKn5fAN1z362v3Yfj+LtfpmPrs9okSH+16nrp999nt16Dpqa8Z5aSa4dnthaeCs44INKpBDBX20PWwcoXU+AEPCIRyM6akJT5zKmlueg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1267
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10281 signatures=692062
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 mlxscore=0
 bulkscore=0 mlxlogscore=783 spamscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203100070
X-Proofpoint-ORIG-GUID: Zb-0hcgPqm4KD0dxDnN9uTUF52M7Mrg0
X-Proofpoint-GUID: Zb-0hcgPqm4KD0dxDnN9uTUF52M7Mrg0
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a very frustrating patch because you make a lot of unnecessary
white space changes and you didn't run checkpatch on your patch.

The whole approach feels like the wrong thing...

I have read your commit message, but I don't understand why we can't
just use normal refcounting.  It sounds like there is a layering
violation somewhere?

Even if we go with this approach ->kill_flag and ->bind_flag should be
booleans.  It makes no sense to have a unsigned long where only BIT(2)
can be set.

regards,
dan carpenter

