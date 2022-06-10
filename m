Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31D67545C1E
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 08:12:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244076AbiFJGMc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 02:12:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242949AbiFJGMb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 02:12:31 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A81F222ABED;
        Thu,  9 Jun 2022 23:12:30 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25A0s9sa002868;
        Fri, 10 Jun 2022 06:12:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=wxlhFpjHeAjYUsX/OfUTOXFaUReck4gLxPdbQ3ifknU=;
 b=xDopmWOCyFsOGhWXnx0wmGbEe4HZOlLrmrvh57SpwPBaqCIf5dhw2JR9k9Pc0UDVsoOY
 uDwYMqNlst1lamyH2E0hts0H4xNg3YG97UsZA5vzWSkd43pAbtkTpUzLRLwivgc4Fzrb
 A5G8Yxkd70RiCE9dpeFRFUx3uUq+4LxXry4eznL3V2UMX7ci6WZpDe682MgnW9bDDTTp
 omx3orClr3UbTS7bMz/1ynCt3wb4LsnmXzUO/CU+cb+0wfOTM1OcQI/BOIxM4CDpbXEh
 FdddK3GxKa3Qmc5gROFyYxhBXqzINHSnVxDQZQ44gseN4V90ERPHneB/ln9/kNoQ7E8j 1Q== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gfyxsn1e2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Jun 2022 06:12:24 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25A6AZJY017914;
        Fri, 10 Jun 2022 06:12:23 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gfwu60j8u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Jun 2022 06:12:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m0HHATCQY2COvNWbcDejChunropy1TbXRulrsnL7G1WmusSWzP8cCSaWadV+eP0+3i+3AJJ5l1Yxk6i0bUQuxidnAWqSblCSNJ9kzQXFkN1ByXSUS1jccRWLOqYcD11JTUTKiP0Mbmd+MabAFrIPER+UHji1riU2giMjQ7vVPp3l22cjoWyOLQvLSIXErAqTEx6p/hHt8I9y7AHzCNFukaT2ubuu7KDkjUTWuWhzOa/DXvp4fGglbpKCnMAmAWJHeqV50JklLxkAC4UGcY7JNEGCd+6Y88Yus6xzlXQGWqtmPET37ZoCeBS/H7+CunK3w11e2MExtKWwY0xWhOBltw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wxlhFpjHeAjYUsX/OfUTOXFaUReck4gLxPdbQ3ifknU=;
 b=OvvHXgYFgqMJFgNXv7EHOka8vlvmWGUpRmJ9x3alCm5QEZTl0eCNapQRN8QIrpOrBFLlkcxbEdIRTAEmg1VZlpPxZcE3YQf2U/MI4QsGqDTkysyIlWWx8snEeOQw/qTWw7rYwZL97DU1NFk/gNfdpNYMtzk/9yhnognGFJnzUTNins04UUH1kZcEpvqeDSpoIeDo/fYK82sgKLhFsXe0SzvHrZpGOiRu9Qedbr+AMeEqvUI1ieW+9W1TPdTF9fSKJpox37FnDeIqkUbDlkBsHqtM1RVf90HLP223EiP5rqs1yE7u0U1zJpVG3uG8S0ifmG6Ke314wkzb+78s0gDTxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wxlhFpjHeAjYUsX/OfUTOXFaUReck4gLxPdbQ3ifknU=;
 b=h+T4RJ8NsztJhhkpJGaYG9lTufo8IID2Vd04/GVdm6knCCH82OB4v0PJ2aStBlCkhmqdMnYmCreR2k8OggM8a6kjcgGM8L7RX6iUlEbysw93xkp+8+MgUH2tMI1EehCrIDD9m9AxHNTSPqxfUGNMUlfAe6dGq+EXKYBr9iu84+M=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by BN6PR1001MB2147.namprd10.prod.outlook.com
 (2603:10b6:405:2e::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.18; Fri, 10 Jun
 2022 06:12:21 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5020:9b82:5917:40b]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5020:9b82:5917:40b%6]) with mapi id 15.20.5332.013; Fri, 10 Jun 2022
 06:12:21 +0000
Date:   Fri, 10 Jun 2022 09:12:10 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Srivathsan Sivakumar <sri.skumar05@gmail.com>
Cc:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        Coiby Xu <coiby.xu@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] staging: qlge: qlge_main.c: rewrite do-while loops
 into more compact for loops
Message-ID: <20220610061210.GA2168@kadam>
References: <YqJcLwUQorZQOrkd@Sassy>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YqJcLwUQorZQOrkd@Sassy>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: MR1P264CA0026.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:2f::13) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eb2150ee-26fb-4ff0-12ec-08da4aa82db6
X-MS-TrafficTypeDiagnostic: BN6PR1001MB2147:EE_
X-Microsoft-Antispam-PRVS: <BN6PR1001MB21474FD04E80292E6A4197FE8EA69@BN6PR1001MB2147.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KbBfigHwpHlzQZyM3j+eje0BaW4WJ2nVXqJJ/xFgCjzbKSFTTJvlSi3rZ84cP/pEn3g3OVcdm0vAA5rj//t6PXDdPleUTiYvJ8OSQFYRVVuAEUuoYm1Bz7vrqbUHzdTKun9HTg0I9wHFCSbnMnXfHOFNbl9LoZ6GPaori8LkO5LrUEfmxKupa2dOUDcN04GOVCf4G0yQfI4jeb1/oaJaI2aFLTizOciBuCboWJSjRgljZ2OJNcnkAN9CSNHiA7agysgYfutkXo40HCf9wiXRYAXraKkppTYWpYpq/LiFo95O0gfdmpGJnWJvOISkdQ6XMqNMs3SbkzgCBYGCXRu0c5t3JUwQuzuEsgd2yRAg1plsWvnzSeKDFMs503bDlBegt10vUSF8ZccSQUaeUt4BYqn30M0Ex+JfMOgoyfBvXOpnXQEA2OyefRo/eJYJA8Ol1lTTFfOiiW6NoOPHt6NNYiE/EnvLwEa8bFSQxbGLb8qETkBAI3LXujBqPtb2af8jNEtiAazKiu3R57gNuHnmnkEFdVPKH+xVW02ZUeutULJNsJGEejU2Ai7AFMXt2DlWfoaSbAbBHyuVfEhdkIC8ttdXxomzI6SwP/2YdvEzfg6YZf0R0IssdKGfi7BrOYRMT+7622jlZh7/hfsdEvrRkvaEfuMRbHU9l4kZVmGRYpRznCb3M+R0l98ycRdI6qDBTlR0nScKttXeTYmELyVOZA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(8676002)(26005)(38100700002)(33656002)(38350700002)(2906002)(9686003)(5660300002)(6512007)(8936002)(1076003)(52116002)(86362001)(186003)(44832011)(6666004)(508600001)(4744005)(33716001)(6506007)(316002)(6486002)(66556008)(66946007)(66476007)(54906003)(6916009)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?g27WVfxkZCLxV686nK80OA8ialOeA/r5V+vqQz0Jq0wh76+26MLFK/+VysIg?=
 =?us-ascii?Q?xBq+ZTcu8WqJ8qNw6wpE+kpj3mxgozGUZ//WfpzOboihTslMMWm8cOzVpTCV?=
 =?us-ascii?Q?5UdMNCHeH14ZFPiFICFQbXu6VKaKeoiniSPEk2c8fZ6cUZS7S1cbvg5vo8bA?=
 =?us-ascii?Q?srGpgsF7b4LldtDhd27IvTRP52hND5sehJHVtM5gL9P+q0BdS4O3eyPJcAS8?=
 =?us-ascii?Q?LeHxmiyQyM93tobsaZiE38QnTCgOhHa6vpPGsiD5s2h9l9iqkbFyjEY/uwOR?=
 =?us-ascii?Q?86HvSDZYtxc00QYsgw9cl9Pp9c0JYkWmJKnkEfMARrZ5qEcyeCfqzk4MQwkQ?=
 =?us-ascii?Q?0r3yfhTV7BjZpcGUM9mmeJP32kjlzLBLvdPb7ps8dT8tG76s1tqQ6cuAfelN?=
 =?us-ascii?Q?xURfaSvzMFcUv9pDhiLNTvXaPRjAUSWzeTG+FyEmSwR8rkLzeAfW/th9kmyu?=
 =?us-ascii?Q?H4eDzFPWENvOjKJk2u8kGJai2obmNMgi7kDDKPTiRjSqybwZEswhfnc+2tXW?=
 =?us-ascii?Q?aFIxnr9m3xLOak0Bf2gvbki1UWyQxN6LjCzdjt/5alP8Ok2yfg03ESkGeF+I?=
 =?us-ascii?Q?zI2gr+S+7WevCL3y2XTpaQmEbUq2XkiPCAop0wtCI7avMecvaz86XAoCzs5D?=
 =?us-ascii?Q?rhw/vjO1I6FxZfkSgne4dwR0XKllWfecauoeCz9KOfRKh8J4T6xFuPTz/V+O?=
 =?us-ascii?Q?oy+/okdKS+mJblS7YNlMbGH/NHLFV9KwIt/1EEBq8rFmc/DCIiMdaeDfB23H?=
 =?us-ascii?Q?8gZlp9I9A8hqZmckm4it4wNvAN6S2mdHownPL7CxW719AvI4B1g4E8HsvjQh?=
 =?us-ascii?Q?aVS+ynKt0n0sK6pygEoYeB0CHLct22uQfHdof5ZQnWvGrHfgSdGRgTkLgAdT?=
 =?us-ascii?Q?EEHQ4QtAjlnlIjjDCHwG8sVXZ1zAdWBIyokztfW9qB/LnU7decSqQOwQ9WF/?=
 =?us-ascii?Q?W/acA80S45BFAzrKS0H7tgHvODheE0YW7eZ8EalyvzBzesgHLaxf6JaPF2nk?=
 =?us-ascii?Q?R5yrdT18bCpFmYDZN4yzdD4Bd+imwxNa4qHuRL8nPN8euNQZJwSMnJMZcjKI?=
 =?us-ascii?Q?T1drtb+5K4sCSSYFw2tV54RWnlyADdZiFZCl+zVwK3hD7Ovh8BZ0Tm3MobiD?=
 =?us-ascii?Q?wBmbe6YTaZ/bKAZF0eIRDTL8MSkYXZUBCGLvtpOTrU65tSRZDLowsfzfMalE?=
 =?us-ascii?Q?NMJNFOl11P0AqHNyZW6E4y06EenSslP4klBfDe5t0h72ZfAGkqsLIqFTGD5S?=
 =?us-ascii?Q?q1P2xevzB3xDkr80H5VWA08/vz9I6BCSvrwddJGc5k4RJl8aOojRpVKZv40m?=
 =?us-ascii?Q?2EM+qGi5ct8CJDxzz7VMVqratz6QgfflhKNtgbXrB7WRMJe7XTh0WhOuaGZE?=
 =?us-ascii?Q?7oAsgEVsf8bUj+GNDpyNvwV+3UvuSzOji3sRQJ0MXLRz8uQnbjS0pQXwtrMs?=
 =?us-ascii?Q?UNqKeM9CYgLVoj2tKVX6UJAztO3cDPQsPNtMLPJz7PRyWj9WS5VvuOIV/968?=
 =?us-ascii?Q?UsAdfFR7kKeA9bwY8v+68oIaIOQPQnvFCOklQZ9Yvd8FZoBHhkl1h7kUa0nA?=
 =?us-ascii?Q?o5Wz2IML/FkMEHjaVU0Dt+uow5L3LpSpu04DdvpmmrPAU1hug5mbknsO3/Yw?=
 =?us-ascii?Q?ZL8ZQYA5tmV95a2I+AppFWQUBYD2dmDwEDVev8ba+SGKdD2BExP8zmo4OTwH?=
 =?us-ascii?Q?vGDFxh0yampHcRw5/81WCjFIXuNpZ2dFNWS89gGJAKVYkudp8sgJ1Hv34x3V?=
 =?us-ascii?Q?A1/4K4myoKnx6wtM1ylL16iTtrIpBac=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb2150ee-26fb-4ff0-12ec-08da4aa82db6
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2022 06:12:21.2120
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aCJ0S0ksCnmOx/4h/MYxK3T6APTxmZsur3ZvI5Wodah/Rdik8bEyTICuaZzJ6rfo9usa4hYDkFXTAt5lilcFfRgwtad1ou91mpUrMMMdQIA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1001MB2147
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-10_02:2022-06-09,2022-06-10 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 phishscore=0 adultscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206100021
X-Proofpoint-ORIG-GUID: Jnuostz8Ff-NjmHqr3eiRLvf6Bm6YofY
X-Proofpoint-GUID: Jnuostz8Ff-NjmHqr3eiRLvf6Bm6YofY
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 09, 2022 at 04:46:39PM -0400, Srivathsan Sivakumar wrote:
> simplify do-while loops into for loops
> 
> Signed-off-by: Srivathsan Sivakumar <sri.skumar05@gmail.com>
> ---
> Changes in v2:
>  - Rewrite for loops more compactly

Thanks!

Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>

regards,
dan carpenter

