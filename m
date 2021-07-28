Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B249F3D8586
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 03:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234992AbhG1Bki (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 21:40:38 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:47246 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234277AbhG1Bkf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 21:40:35 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16S1bPtP024744;
        Wed, 28 Jul 2021 01:39:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=1b/ToWLe5ZsKDcrVfg9Wv0lpkAnXoV/Mh/ARa967ohI=;
 b=POkUB1F3j6BOxRH9fXpUoPjvzOxxHd38CB9BNXIK5RMn2IaRn6yiw698x6nbD9rClFz6
 2yiulqbuNVyH+ljBmpoSSVBYfW0F0kYi8PVWHft/Dcgc/bkHMbYAgL/LM5v2LObc3e7j
 NCH95ounEpoIyF470k8t++xr1Ti+lS91FBaDO0AiX4kuHf3v3k0tz9V9XsrA862nnZhr
 6+3cN3jLcjiJd2W6ZiSLK9ftNvX2NT6bX7YCxMunT7n8GxklTvssKqxTS9f9gp4klool
 d4B2EM3DA1zWc+JUOSDTDDGUN3OrcHYC/RsvPb6g9ps0HaKb5+9QIFueWOc8GsE1u5Vi 7w== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=1b/ToWLe5ZsKDcrVfg9Wv0lpkAnXoV/Mh/ARa967ohI=;
 b=TaIM3z+TmprIny6P4WB473H/S16umwjgM5caTw+8YpRwHuGGD475NfNLUePEQf2BjOH2
 F83MihqJJ92wPRsFqB9sFjIl1uxe1B9c2M0FvhcKSN4iXnnD2XxpArPjHfghKzihAHVU
 xcR9UH3/E9CD3IsP6vKmAE4wlnUzGGKl+c1de2ce7N/SFUkdyNjOvel2VeCYyPJ64z1N
 /Or2Es79QTfQwexki6D9M7m/fV1t2ZhKuK9X2l4VGO7JhxBxirsOJqq2vcDePyzG4f3G
 o6FHe866pCyxeQ14eCz5D72nRk5OYZM4UHb09r6ps8HbVZtpzdVj+jHnQqskh2y9TBFm Ew== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a234w39xu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Jul 2021 01:39:45 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16S1Zcnq119937;
        Wed, 28 Jul 2021 01:39:44 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2047.outbound.protection.outlook.com [104.47.51.47])
        by aserp3020.oracle.com with ESMTP id 3a234973ef-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Jul 2021 01:39:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AusEwc7yLH/RdwwRFhwnaqDpfsOMj09n72AH56UmGUV9RaH8i70TAaFexWc/pCOOHdOPQqY4Zu5R2wc9bTA9e+pMtD2rqZ5uuV5itVNsU3jcEXTYZHG7EEeOTSjQG5gQrGYyplTNvcM7aBytAOkqDJYTsNWU/4L2UU4hWxyi0RWRzpQfnyrhsYDhCLLAuDV/RW2eIhYpqslPx0TCKq63TDb+dCPMDO1zGWymweCXcISoiFENLwsm7kS+IVwZ2Hu1wU5c/7tgUrNbe7MOx4ka2RzIWIyw4WCD6PKcfkfNWBbDvh9qAodVvO+sO2699yHL1pWwTlCQngtNb9Ajdyfe/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1b/ToWLe5ZsKDcrVfg9Wv0lpkAnXoV/Mh/ARa967ohI=;
 b=kSbkCOVIDNXwfZCzjOuIyMazFsP/SNMvhLQRtf2Llsjzr0QlMgIcRTHeyYp5SOCA7PYbAoRwwu3DFWLS/3Uy3CK35hG079A0pUjW6orLci80Q00eqpt8tpibtWTJwlozk9Ai+4Qxz+cYO9SIquGA1gP38o4cezIesFKpXMoXNELuO6XWKWBxmv+1p8BMNWxLP8iHAshm0bXf0Da2kNDUu+C9jAkA9CiYsFL8pIyc1SLOHECYnR4pQOhH9rQW+MeFP9LnoydcMMEAsvuaVVv04hooZrtM0QY/2NBufnxG6KOPyCxT/4LMSPW18EIWcI/AOQF3yMPKTS1j0dsseOJ1BQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1b/ToWLe5ZsKDcrVfg9Wv0lpkAnXoV/Mh/ARa967ohI=;
 b=nhFIzZ9rluVEx2pE5U0d+pHll7Y3osB4TR7GPpKStepYbpoeh5d9TLwoBwNHYa4oJc9cdfsQw7xcmErvFOB3Y9KMbb+UscDAihyCtp/qL7rKQ+6suikYz3xGn42HhJqgTkpjz52+ToiOP5Rk5j/KwhyG5U1pLo1Uxepp+a3DZkE=
Authentication-Results: chromium.org; dkim=none (message not signed)
 header.d=none;chromium.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5611.namprd10.prod.outlook.com (2603:10b6:510:f9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.29; Wed, 28 Jul
 2021 01:39:42 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1%8]) with mapi id 15.20.4352.031; Wed, 28 Jul 2021
 01:39:42 +0000
To:     Kees Cook <keescook@chromium.org>
Cc:     linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Keith Packard <keithpac@amazon.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com,
        Brian King <brking@linux.vnet.ibm.com>,
        Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: Re: [PATCH 36/64] scsi: ibmvscsi: Avoid multi-field memset()
 overflow by aiming at srp
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq135rzp79c.fsf@ca-mkp.ca.oracle.com>
References: <20210727205855.411487-1-keescook@chromium.org>
        <20210727205855.411487-37-keescook@chromium.org>
Date:   Tue, 27 Jul 2021 21:39:39 -0400
In-Reply-To: <20210727205855.411487-37-keescook@chromium.org> (Kees Cook's
        message of "Tue, 27 Jul 2021 13:58:27 -0700")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0156.namprd05.prod.outlook.com
 (2603:10b6:a03:339::11) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SJ0PR05CA0156.namprd05.prod.outlook.com (2603:10b6:a03:339::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.7 via Frontend Transport; Wed, 28 Jul 2021 01:39:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b4b84a94-9b90-4af0-ea4e-08d95168924f
X-MS-TrafficTypeDiagnostic: PH0PR10MB5611:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB5611B31E113F35653BEE041F8EEA9@PH0PR10MB5611.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mwSZWSPXbj6YMtjU0A4PM4G5u9VxGHrY8ajQ4HLZ00DyB/iDLveE2JFDYpjChGfg3bMNKlLCwRdEM6g/CpMOn/k3hjo8jzU/X22YiZBV/whIw3Gh285LkDuzDKj0gQT8ZXi53fXukBKkb/bxpQUFIfSd0oWbG8VznvcpmKkR/Mu6MLdn93I9q39QeX2Mkq6S7pk56/6ysu84qa9FSB/0LrLkM1uL1LySz1hnNdzFfKrsxNgCf5yVqALDcSchB09oOttc5PWAhr8ge4QRsqMRMQShFPTi500lXp+qJp3IJQu/IGFo70bNVDROeit/0yWyNdLpcY/3eqQ8nScqcohjxnmFSem0BPsKvDqogIqW520Z4yWeVFAL/oXC8EOIqPr5dShWgzdDYRaMAdboHPnSRtw3N0z3Ha9hq46+TGO+vXXXmB2s/t2wLZR2SOLrHTrXJzBhvfD/finHE/oWddM10DlxNVGC/iNWZeuZ/Jahh3rUY710WBPRCrBpkuknqSSD0ELaaMN6dn1LH8GG9k0w0AsGZcUxgLB/hMqV+9XBv2SOArqGug2xpmxTGJzjMW90UUWoKeFLGjFeBkAqsDa1Lk7GIb1FWUb3HZRnCvTo5TvPEiywLXV5IUoXEDugLivVvsYleBNPsNtibJtsUhQr7qWq3YEIef5BnKKvrkRAgTgORdmk6Igf7GU4Z6hDMBH0U+Hb4TV8dZkHdQhyWq6GHQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(39860400002)(136003)(366004)(376002)(956004)(26005)(66476007)(8936002)(478600001)(54906003)(316002)(83380400001)(7416002)(52116002)(8676002)(86362001)(38100700002)(5660300002)(7696005)(38350700002)(36916002)(66946007)(55016002)(6916009)(2906002)(66556008)(186003)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?apY1BskIjLovv0TgaJ+cvE3prbMQWW0iC956EErx57YlD+FyQz6VGAbASD3e?=
 =?us-ascii?Q?f9Dc8GQ73Enz5PB8GFn79oL9qIjTBluc5ahAIlZ4+x34g8+ghdvUrPETioDP?=
 =?us-ascii?Q?2YDtTz+XcsY4yzynKrS0ZkswZy1hyd+1QIQd57+r1w9v0wwpLRNyLCia4IDT?=
 =?us-ascii?Q?xx12zhcToDA675trTWwOM6g7jEkyT5hdDE9F677BJH8MiY9iG/I3OuCg7JUY?=
 =?us-ascii?Q?CzYQMuGSUhJdZxEfSEA4kGR9UZzGD4b2MZ5uCCPVci/IdK3qnuLS/e7+knrS?=
 =?us-ascii?Q?jXSzfS83SQ8/eR+Eg/pRYiwopmE7L32jd8vlO8VQtVgo/sbchRAbs2ZifyUg?=
 =?us-ascii?Q?PgyAoWvwK7EE6vHbwAy7xqjpWMqs7KSNPnjmrkpKAU9nfK7WimqQD9XbniJq?=
 =?us-ascii?Q?ViK3hXDaF5tGyDiPpZx1N7x+IkU1ORNz6jQlzVmTlAtzofjNM1Q4o1JwjANd?=
 =?us-ascii?Q?gClM/hVWuTsFGwsmIL4cqozJmN/8WcaOk4blZS0KWvwgIOCFtXLlZ0xMlRuK?=
 =?us-ascii?Q?CjU5aedOqYJlHQXrpKmy/ltJqOXvS99dLas8RM9ux7AAWEvrWEA+mnTD2bQB?=
 =?us-ascii?Q?MHxnErGLd96XXC63ZGC+QJHwaEsaWmBMrYtrmZtI1jTEAu0yMc1rNYqcbz3G?=
 =?us-ascii?Q?7fO6JM7W0zpMz0q9bAmPVIQq5HuvZ54cTWCRMs29AbGj7kze91ecjR39XIIL?=
 =?us-ascii?Q?67CmY0NMtquVa0X/wjLtNoKiYDARWRguVayd7+P80NF5fnj275alTG8mPu/r?=
 =?us-ascii?Q?YlYs+pAKYTaTXMJum/cPnQ3ckHV7T0WCkaxzzFXGcQTQprKkT3opLTovFnKD?=
 =?us-ascii?Q?m/fTvxRPhVXbaVx2iuyMII1F/61aYrMvPKxyZ5AiJEfzs5rQcCUuo9TJ7diL?=
 =?us-ascii?Q?yYXZEuy8ffpcKewovxGnqJL+1H2CPSJ2q2PyQkdzJEeTzqa68J9CTItjmVR2?=
 =?us-ascii?Q?g9cP3f7IH6gPrvCLQo59damPiosbPeh/Tm926tvocwvPqk/xsVcjmGYOnXBk?=
 =?us-ascii?Q?pzit0tWVBezw8Kjo2dZJMkD0aLoOr5bCVrmIZ2lobhs3VM0cSsHAKY5YJUyP?=
 =?us-ascii?Q?huFnSb94WOe7T+POAPU/mWwatTW/JHNQcTsCvskqENM6cCJY/E8P1tGQ5e1x?=
 =?us-ascii?Q?6YVv7ABfx7GUMrTGw77TzP1ke64lLx16pkTVBb0c6kJQcNEXwtGS+EvZF4pV?=
 =?us-ascii?Q?AvDpBWg6ASrGjXzUVZVXv3pfiXF9cRW0Rtt1S8cMZUoHcMH24FrHeTaUi0GH?=
 =?us-ascii?Q?xt/Lob5BvlgdjaSuTyzjfx2PNKglAu6Engp4bNqrisAXkM4mNk+yFYaNDN+K?=
 =?us-ascii?Q?hG4shKS+fQ911xf2IqeCCVWM?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4b84a94-9b90-4af0-ea4e-08d95168924f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2021 01:39:42.3960
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H71AKo+72HNmaCrINLqrH8MWQAE/oHYGydeil08fJErqiDL0rVgxtOzFSATD7olP+/yyWJv6TC9GuMCbATv2FyQmrqwm04vA2pgIe7wKfSc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5611
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10058 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 suspectscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2107280006
X-Proofpoint-ORIG-GUID: PzoC1ZvBRGce1AdH7qMT0gv5us209nv5
X-Proofpoint-GUID: PzoC1ZvBRGce1AdH7qMT0gv5us209nv5
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Kees,

> In preparation for FORTIFY_SOURCE performing compile-time and run-time
> field bounds checking for memset(), avoid intentionally writing across
> neighboring fields.
>
> Instead of writing beyond the end of evt_struct->iu.srp.cmd, target the
> upper union (evt_struct->iu.srp) instead, as that's what is being wiped.
>
> Signed-off-by: Kees Cook <keescook@chromium.org>

Orthogonal to your change, it wasn't immediately obvious to me that
SRP_MAX_IU_LEN was the correct length to use for an srp_cmd. However, I
traversed the nested unions and it does look OK.

For good measure I copied Tyrel and Brian.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

> ---
>  drivers/scsi/ibmvscsi/ibmvscsi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
> index e6a3eaaa57d9..7e8beb42d2d3 100644
> --- a/drivers/scsi/ibmvscsi/ibmvscsi.c
> +++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
> @@ -1055,8 +1055,8 @@ static int ibmvscsi_queuecommand_lck(struct scsi_cmnd *cmnd,
>  		return SCSI_MLQUEUE_HOST_BUSY;
>  
>  	/* Set up the actual SRP IU */
> +	memset(&evt_struct->iu.srp, 0x00, SRP_MAX_IU_LEN);
>  	srp_cmd = &evt_struct->iu.srp.cmd;
> -	memset(srp_cmd, 0x00, SRP_MAX_IU_LEN);
>  	srp_cmd->opcode = SRP_CMD;
>  	memcpy(srp_cmd->cdb, cmnd->cmnd, sizeof(srp_cmd->cdb));
>  	int_to_scsilun(lun, &srp_cmd->lun);

-- 
Martin K. Petersen	Oracle Linux Engineering
