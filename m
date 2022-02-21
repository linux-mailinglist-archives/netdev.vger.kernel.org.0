Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A58554BE2A8
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 18:55:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354916AbiBUK2j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 05:28:39 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354687AbiBUK2b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 05:28:31 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CEF843498;
        Mon, 21 Feb 2022 01:50:16 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21L9UF6w003786;
        Mon, 21 Feb 2022 09:49:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=mqV9ioEpGUM+nr2aOQEq72cJGl+emxart9ZqqmOtsdw=;
 b=Jj+8vrrXxxHZfH/e7XaLDB7bpRNt8q/1HUE+iwFepj8nmB3/TYHzAMYtLmldxygvUuDY
 RBqCSTVHTrElkekivW+5Flg0HT7zlw+M3NY8ggcBA/9BtKQ8em5HrQEDLELNBn+bAe5+
 qaNrk4vFNTLAqk6h5ANXDrlgGRZhDFSVeDPbFT5nIXz/3ugNnLV0RLEitUO/A7+/du9n
 S4S3jfliGpUIUMayDBK5JNivfwDebIfoSZoL/1qN6Ji/zxSn3jr1+hboFea7cNfJ4sjj
 5YvfHZ/LMaREOy8rGRM+Z+F/WKwGbJFsSN6XmD+m1dPmudtlHp579BU8e00Kg1Vkr40u zg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3eas3v3kkx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Feb 2022 09:49:35 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21L9eUG2123313;
        Mon, 21 Feb 2022 09:49:22 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by userp3020.oracle.com with ESMTP id 3eat0k9su6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Feb 2022 09:49:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HmmwkHjYX0OjOUk3WWgsxRBvGueqBBJPyR7qK//RbKGAdXO9kugaofSMoZBHKzysl3jtYDPJMwRcy4AtPn4kEJYKMgtZyXwLpt8WNtPgus7lcu/oihGZN8eVkoThe7IBPssivUymOw/VPXso/T/XaMk09ZijU01YXRwxdxgABVgCOfnxJrUtMu7/pdd+fh9uTj66ysnhZP2+FNLZRMaPb2S2pox/6xgVXo68qZXEaiV0WicrzRKxHVaOVhPZeIqliayrHloofxODVIEi1KXwwzeaiWPwxZlSsjSkQSfO6XNyx9GDkXZJ9neQabJm3YCc2ZOIF8Tqz7j+T+XHSKhmGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mqV9ioEpGUM+nr2aOQEq72cJGl+emxart9ZqqmOtsdw=;
 b=T7IiN5RvJaADsOCOY6ANoeczxbbjWnNW5f8xgrIhvtiUs9MMLNr+mZ0o/vLt3q1YgiWS+5sd+RZhFBCOu24NU+2c8QfV4K7k+r4gmJbZmbwcLedbSTUO8+msaqfL2KQq0YIllhmY2NZye6asIjUxJ3DBGjDJ68fKA77HAGKQVBmNl/d19xxaVYKzAyyBCjQ/QCURaEoCJNU7+0d6KIxTGD9RGqvN366huQ3xAePRIsLJ0ehYQJfIGYZ/bpBk6LLt9Rshyj4k06mmdRwrIf4QGh6F45Vm1vyu4m5SATR3F6BT3I+aUTwTSMgyi8RNG0k1nkUliWVeayrOMUx0+Tlv/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mqV9ioEpGUM+nr2aOQEq72cJGl+emxart9ZqqmOtsdw=;
 b=VU/TElN8Eru553IHzS45zGXpVrsjDuYxA9ybPud/0pAXiqlfu5ZfF8RLdIdiMbJr9syyfItCbx6ACnkh0cR7LaPhgoRi8ie3VwFOok5+INCZzKIFsLG30uXiw0dda2R1b1gqs3F4PBaeiwq02dg4njlTDdnGAPds7tHEblKpkQE=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by BN0PR10MB5093.namprd10.prod.outlook.com
 (2603:10b6:408:12d::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Mon, 21 Feb
 2022 09:49:20 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::2c3d:92b5:42b3:c1c5]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::2c3d:92b5:42b3:c1c5%4]) with mapi id 15.20.4995.027; Mon, 21 Feb 2022
 09:49:19 +0000
Date:   Mon, 21 Feb 2022 12:48:58 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Hangyu Hua <hbh25y@gmail.com>
Cc:     manishc@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        coiby.xu@gmail.com, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] staging: qlge: add unregister_netdev in qlge_probe
Message-ID: <20220221094858.GA3965@kadam>
References: <20220221022312.9101-1-hbh25y@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220221022312.9101-1-hbh25y@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNXP275CA0007.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:19::19)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5c8f6adf-7131-453d-9cf4-08d9f51f6e08
X-MS-TrafficTypeDiagnostic: BN0PR10MB5093:EE_
X-Microsoft-Antispam-PRVS: <BN0PR10MB50937F08BA3492A8A33559F68E3A9@BN0PR10MB5093.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N75UdJr193GszQNLpNYaHwYkWMoGEjyIZiVngiTxrF37PZOUFvJ6aREptqXD1G61/VnZ8Ug2KkdVZbyhA5vL98fqviiAQPI9u3g8R5XiBa5uz0L2n+cienWU+m/ZIPTV69njk08uptAuwQmGRSF/hRq4a64oBazCpMqqvwCdnqsuo93yRpUgY3xV+glwrwBiXgCoc0prw1wlH4fSEZadtSqc+abyGwgNq71qk6Qo0dHMkWPQhd/YrjG3cvlKQ46iFrQ7p0gaZ2YfbjdS1Wf2gCvbQywIZG7Y/bdNRlR7CK3xVJ1R2tcovGovWr8vPPc2jwkPkXaOS5eEKsUsio9OiNnNFRoYi9nv1PM6ftj31dXGwMDYMkdumZuVMJgfwmIRAgm0uho71/ZrSOZRc+mNy46YFfntji2w5TW6xneDmZiDJAGWPSjkcZW1HZwBKrDFtCa29LQtt/5iNPnZD8/G7d0SLqGC/xjMQ6rRkV5bo2WvqzKJQSN4oGp5hZAMotolakmUUNqz63gzjDqyYCu5gHwd6UEwqD7QyLOhZG66rwe+h+FCMxeKor9E3tAxgvS6T06/zpKu4qOoMT+aMSs7s4VXy8wokubL94Tbc7PeL/eYmV1y9ufkCSnCT/o+GiAA5jGvVKF+yU6wJyrc/Kgyqft8sWtvuAJTRK9DpocS24a9tvsN1N8HyJkCXGBBiBHiEI18tuuhXsj5ntm28PY28A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(558084003)(33716001)(33656002)(6916009)(316002)(4326008)(66946007)(1076003)(2906002)(66556008)(66476007)(6506007)(9686003)(6512007)(38350700002)(6486002)(508600001)(44832011)(38100700002)(6666004)(5660300002)(8676002)(186003)(86362001)(26005)(8936002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Q3Wl00BVrY4b4KGH2z8eQTotmMTUEOERRNCMIL8ofgIVQwIfbliuyZKp/8c6?=
 =?us-ascii?Q?l3WEGeZuaKGty3jVK7awXhnOpgPPmi5QSWmOhf9UwOGvGnuzt6UispWGYM+D?=
 =?us-ascii?Q?UrC+axVuY1AUXy1SdH0eHIvmuJ+2q7mjzBf7j3aIrOaha2CT5IsvsVV/Ln3o?=
 =?us-ascii?Q?q0JzUWZJGqMnsqhLeJ6PO0kjVS2h3R3iAmpVW4m4TPnD45tOzopuHdyY82mN?=
 =?us-ascii?Q?bXrpp3tQqRk7D8wK6lY8ustYdrrDXiytCNAUEmFSmPj9VxfB3cxohCK9Jspc?=
 =?us-ascii?Q?TcsGjn8wyXnEoutLnNlNMblkOF3DI003W5EBRWlN25HSihzksjWY7QrxWPv+?=
 =?us-ascii?Q?gefHUK5mrnYwKnLhbc6imI15ZDL8H2OXnkuR2EkjopgdZRcPQUMJQB69QW+Q?=
 =?us-ascii?Q?IvrwVgPpoqZM9bvas4anDZ9EElmOlfAlfUBR7cBUaa/P7k3K9mCgkVD3y9xF?=
 =?us-ascii?Q?sG7Mhn9F5FGLvj2AKuE7p4Dq/8p1iiaa8TfYU+wYf7sPLbrTU1VMYzj8/j5C?=
 =?us-ascii?Q?YsQFu8Tp/mDnSByfc3NcndJiHAZ+acmzQMYqn2v3Fa5+RNanbWlE7GsLr4bL?=
 =?us-ascii?Q?s/ooIRnhQtQL4iaYfuu8nhSU4fCjCfjOXe9FYofyLF8DjbDcdteG1Y1PtKDH?=
 =?us-ascii?Q?Apzqf6Q7qfUXvFc2+iZWyM0f7g5kv7iXlCOjQKj//iNR8VOAXzsrgqQuSaa0?=
 =?us-ascii?Q?SWWHbyjEeCdyh0S+e5F47ZNcAQFA5FCUfH3AmUdN2NVAZ+6AEeohL8D0J3o/?=
 =?us-ascii?Q?7H4LcfnYRm6w7y8r744za2Fy/PIRxovJXazcrQwgqeanZG1JwzF9dMjJtXYk?=
 =?us-ascii?Q?fs1btqGxTmUezknpAlPIbsABcgS03y/YdwUKCQwXxJY+apsghNIRqjkhGPmA?=
 =?us-ascii?Q?rMVF2RaORrcVBgjnDFd+G7rtypdZ54eDSPU/G+cE2su6dEZK/jpsIOoh62e+?=
 =?us-ascii?Q?+DYQ4Mf4enRK01QHCWGLreL8a+gj+s4mmKSPnOULzsLCfMl/2WZeqRkzA6Pk?=
 =?us-ascii?Q?7vUJK6CbRxgafJiDBSgC5Ujd4s/pALATK1GynN7Idf6rr9NBb0ch85cZxSOn?=
 =?us-ascii?Q?4t2S+i1z/QXmkBpzZFv7+Q0zVjGIoq/HuNrJtBxFoufdv4FcS9uvPHFRWO+n?=
 =?us-ascii?Q?YqbCrWqniD4T7TqfYn5nebyF5d36/VgJTCnipD4UmnaHHvQ0v2nHnvG5eUUF?=
 =?us-ascii?Q?oH1XyzL568TcDFjuR/df5WczujPcf+EEQAmyBbIjWrEQVIeFlI4E+FRKmyP4?=
 =?us-ascii?Q?Ld+VIi6/MbpS4gm8KycJ2FNCM2iuGL7zM1wV+ew1X2YRJ0NFGAbK1yvPBda+?=
 =?us-ascii?Q?OiHSEpuOmVv5KgBbRGWSjZj88F3gDTVvg6yxvB35Uc7dQ/HgfxQ4zeqjJas2?=
 =?us-ascii?Q?aFPPTTuXTpxim15k7t1NKjDayUSy+VNc2ZwkBC0LD27wA52bE5Jw3PtnKFPt?=
 =?us-ascii?Q?+Lkybiex9P7h9ySgRLZ9OgrNiHdBxXIGd+VHduCAhEaOwp55htQ6A53hyRZI?=
 =?us-ascii?Q?h1gaUCyx54JKDO4BCkjfezNJlBVOZCwmHPpL8kh+W4nYEqRTwJY9v/ExH6nS?=
 =?us-ascii?Q?fTvtGtjk1ZwpYwWjuo2VMNbENJZOeYqCMsNeBKPriLEptawkCH/OrEKYQEd9?=
 =?us-ascii?Q?J77/XrKow29kP09w4go+T1jKoiWrssYDgF42Y5eUIQwtxxv5XvGIqOlmUzYK?=
 =?us-ascii?Q?3BpmMQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c8f6adf-7131-453d-9cf4-08d9f51f6e08
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2022 09:49:19.1453
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ecf94l1VKyPaNiKEObTYE5Ew+nG5AQpWEZC3TEPaH4rTBwXoKxJJwmTNYuIu2Zte3YKIbYb3ARts7URbByxWmSFlRIhBbVM4UXkvTdf+oAA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5093
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10264 signatures=677614
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 spamscore=0
 mlxscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202210057
X-Proofpoint-GUID: DkR8M-TwjWUHhaD78xZBzeLFImoKte2U
X-Proofpoint-ORIG-GUID: DkR8M-TwjWUHhaD78xZBzeLFImoKte2U
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 21, 2022 at 10:23:12AM +0800, Hangyu Hua wrote:
> unregister_netdev need to be called when register_netdev succeeds
> qlge_health_create_reporters fails.
> 
> Signed-off-by: Hangyu Hua <hbh25y@gmail.com>

Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>

regards,
dan carpenter

