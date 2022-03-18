Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD51B4DD237
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 02:02:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231340AbiCRBD2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 21:03:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231314AbiCRBD1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 21:03:27 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A0E52571BF;
        Thu, 17 Mar 2022 18:02:10 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22I0uYP3002563;
        Thu, 17 Mar 2022 18:01:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=Ti1n7lbjmlVdh2m7IoPCHO9+ChuiKV6JsLZZCjdDxlU=;
 b=DlAwK1yVrFWsSFJRgL6rQQA5rp5qwWXakghITIlcyroas2yA3QMMH+5FmFwCqiQoT5vt
 5hPaullsGRjmywAnNpc25YwYZ6PziSlgM1buPOCb+hoSA6AEWNRoA3ETfvozroh42/U8
 /dbaoqAcu2M2nR+EO63nJgWwEtBw+lltJ5k= 
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2049.outbound.protection.outlook.com [104.47.51.49])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3evfyx00td-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Mar 2022 18:01:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DKs0uGWIrGqZW3YJLsPyo2icfQePJ51FuNhXwRP4KI5/4o6knzo/bIZWMV60FkFgmXQbtvOfTIgnjZeqCVaV0p/oAEWR3nhIroe6wUfhc1Q7IQNrwfKHmrhNH3BsUCxzpqWTJMTcxyz0CE5YBUtOXpqRQOgA8IViAjecjnfrY34SDoTMpvkgikKOLHwQ7UHL6LbPOIqxO+SRabeANGAKF8PYCmrLuzSiYJJNe9Gj1XF6YOfRNFB8xIekH0jC/jsVwSvcRkN8g7k6dJinUrQFqPTmc8AFESC0PrHQdr9mbrmYgfPILfWXiI9bstlx1qhRmGBpMQwkyfJGYf58+pOofA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ti1n7lbjmlVdh2m7IoPCHO9+ChuiKV6JsLZZCjdDxlU=;
 b=gZOOBVrmYymGzJP6lR4belUJm5Ymwmtzl3AOX3uGiTKOw/u/cPyBZjdCYL2f8ya/WrKDokrjZkjSKu3bOs/3GMk6bke4jhhiDRlpOt+eoRRa1l/bgwaQwK+JHZs4VJM2iyc/jcXFyLOZRYp0qokLVlQ/5v77h3DxKUWiUhsi4qowqNA0PniTQu2NTRj07CqRpGVP5wukMMjgUot8180zVyvh3SS+CUfYLPrRmhtQLwbqltw1xUnNb9xoGVp1MPfzpB3ZdiDuK1bHUM6Q7bIu+NaZxPo3pPy26Mtmd2vtlNui6zsjf/oeRsWAqYGam7bLeX1b0krIhZp50QLC+L5VVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SA1PR15MB4548.namprd15.prod.outlook.com (2603:10b6:806:19b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.17; Fri, 18 Mar
 2022 01:01:53 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::708c:84b0:641f:e7ca]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::708c:84b0:641f:e7ca%3]) with mapi id 15.20.5081.017; Fri, 18 Mar 2022
 01:01:53 +0000
Date:   Thu, 17 Mar 2022 18:01:48 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        kernel-team@cloudflare.com, Ilya Leoshkevich <iii@linux.ibm.com>
Subject: Re: [PATCH bpf-next v3 0/4] Fixes for sock_fields selftests
Message-ID: <20220318010148.6dju4zlx2omhmje4@kafai-mbp.dhcp.thefacebook.com>
References: <20220317113920.1068535-1-jakub@cloudflare.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220317113920.1068535-1-jakub@cloudflare.com>
X-ClientProxiedBy: MWHPR18CA0027.namprd18.prod.outlook.com
 (2603:10b6:320:31::13) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 76f48774-aeab-40bd-4a1a-08da087ae362
X-MS-TrafficTypeDiagnostic: SA1PR15MB4548:EE_
X-Microsoft-Antispam-PRVS: <SA1PR15MB4548A4C67A7B8E4FB92E878FD5139@SA1PR15MB4548.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0O6Ix342pyLkAq6dpDoZlF1bUAPlGnUgqtSVqYkGpTmSRqcvjGzAnJPIlVLp8/wf02deZkwz2xlUunGWJGanfSXPwGA2JyLtLyuqMnICFCt136axw1eRMP+BDhsAGkMQVUyJlDsMnkkIva+SMpu9UwD8em6CUDQPvU0/oekXrWAcHyt8s7DSCpv56/URhK7Gf4p8uYTpz+nF2AdfHUsIAOdgzSn3oCPaSYwSrjbEltfLseXKoeakTSMV1vcZ3xir3e57mvHqAAIMc/PEMw2Hlh7FYIL8whrMKVdh+Ul/aDevuiLsZnbwAo6VjUTr3HZHOFTBkqyCtYyev+GZ/rEQWlDYZDV5+HEc6ROEnuOr9L09Ns3oQpjFKYjZBidTfgwfQxRcbExzZe4RInz+ic56IYpua660b8XUzDCmR5dSyOaGGxWSDPEZPdM1c4LULTU/MFupc1RKjXAOwg4glSzzeYFnQAY5XoKyOmCXqjYEmnS9EVX2nd0+fDqCO3bmsyfObKW/oGsDMwaRgIf+FJ0pJnSw+hsCUfjFjkZFWHVX8PgqCqVa/AM4E3HHBmevNPrfSW8bjul5IbUouDzm5qtay+48YTUvFAPRLJ76qy2G8uJV/uaDR7DpXQSkUGPxRaOR68JKwcokdSFRBL/iiYviL58nu8+/YvZR0OVACCJK0kL3SeyRCfXOaHUDxwzY9GqgHotWtNG9CvRSeaOIDcYJoVKhOgoh5LYRYxwZDOR7qXU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6916009)(54906003)(66946007)(4326008)(186003)(8676002)(66476007)(6506007)(66556008)(6666004)(6512007)(9686003)(52116002)(1076003)(316002)(38100700002)(6486002)(86362001)(966005)(508600001)(4744005)(8936002)(2906002)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4vmOzVD7iYh/HeO5Niw5vusHI9tqIAzOMcOUtQ878nmpTLEpGMyzRW4CpaDS?=
 =?us-ascii?Q?SLN30PsXiaZh4DK+zEWmpDpFkOGuBuigdi414/HY/QN/hqhwPC1ErF0hR8LT?=
 =?us-ascii?Q?aD1xOG1E3uqPUuY4wKgeyCiSnORQdv7xjGwGmvyvnrqMTgCzDlNVVJX3+/1+?=
 =?us-ascii?Q?8M7RlunC2W6dx1CorkY1GQFBjz2GKbW3oEnWZx7TRBn5WYz9gokdLLcWyn/Z?=
 =?us-ascii?Q?/MKHsH3hZB6HiLBjb+HTDD/YgnL0q4kXAF2jRfDAJFQishaCYVEENDID+Epw?=
 =?us-ascii?Q?kxdNmiuA62gEsk1Ia+QwQ+uSQGXp06kyaExvG/WaAUbRKLpbe3332KR7wvsE?=
 =?us-ascii?Q?ZEV3qGuTsZSvKPD53b0DIsARPbEqoie+YbSK2+OL9FAyo8y/tq7+GqHGmWPp?=
 =?us-ascii?Q?/c96qqzprKR/dpi85Eg8zwmdeRGB/6fFLopDjc4kPW5XKXILSiR1Ds1UAMar?=
 =?us-ascii?Q?/7fX2kGX0ad5Luo5ITlHCjAJ4cC+kiDnUAuYGX4TuOQMcaV8csE/lMiCj5Yi?=
 =?us-ascii?Q?6bcP+UY5BGk202F/sepzKBHymZiWUCOUS0TkdhfzU/mf24gockLZy6maJ+1d?=
 =?us-ascii?Q?1yieNjL81y6WcOUXgy0vkKHKhp13ZtM5BmXqJNZQIaTw0ILqcoEZPyQDBgE+?=
 =?us-ascii?Q?VL4HGaAZODUTu5pB0EGQgBVVdcyHEmBUb/RtZb36KZbvtUcz8EMusj3rfPG2?=
 =?us-ascii?Q?3DvIMxBQcMkt1WbNoE7X8PrK1d+fqprhiilu41LdYg5IyHmEAEgFpDz/irps?=
 =?us-ascii?Q?vdk6NrH+vro+fYRYS4DONDPakhdZywTPtg1fEPsXugOrTA/yd2py2qUXuZb7?=
 =?us-ascii?Q?w//G9iB5hEn8+3q6u4qgPAKRD4uiF4xQ5Aj7xlMg+rtjeuIhRs/5Ps224TZ+?=
 =?us-ascii?Q?9FhFU3V9MxA4tx8OApsUV+xco+KBHb1OcBNPjwqObw6jHvFX+EZE0+2dbj7a?=
 =?us-ascii?Q?YaX2XNuUWUrdoa9AFQPOf0WW6of5qG48SgRpWcybajhCzdGSzmlg5lDsNe7l?=
 =?us-ascii?Q?gBh6eUU3lcazEev28ZZdtd4ZsP5wMNHagCAkb81Kt57C0hmt86Gp/gw1zqff?=
 =?us-ascii?Q?ZuMqARrK1Ky2cyb269GZn4CmJH7fvH9mAaKUzLiaFcryobcLOthuHyjFom4R?=
 =?us-ascii?Q?nbp+UW8tRtACkYMi609SUu0HT1oKtPsml756ghw7OX/zC9SSoAGvqRxY9zh0?=
 =?us-ascii?Q?WeuKKLJh4S80GwXIn7YvAYlUmlf9p5qSHv+7PmTziCWFG2hmyTrOHmTm6lAc?=
 =?us-ascii?Q?0m9Sj8VP/3Kzjn99McBCERHMnIxqFq0xfm8IStzSzlQ9OOatRm5pYPAYmUtu?=
 =?us-ascii?Q?5tgv4wq15JFh2Zr4+JQxHdC7UiM397uPi7CpabpuHs7pO2yxgndSHXdZcUaH?=
 =?us-ascii?Q?L0gT2VcnHLrNPAJd0it38Iipb4oHeZpHGSs8fO2f3o3aBBwECVfBHdm8o3d1?=
 =?us-ascii?Q?3KHQJ4/wg5AUMX9VwqCMQBMrMBccjsb04dqcfZ86XCGQF02VwLX6oQ=3D=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76f48774-aeab-40bd-4a1a-08da087ae362
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2022 01:01:53.0247
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eyaDKf+c3nElP6bhf54DWbl7/3fpA58aLJuoqK7h3u1VnTOVicmXIIoep5hAeYIw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4548
X-Proofpoint-ORIG-GUID: kgA-j8pIo7SbPuWOeJlJUrpje0l0-WoF
X-Proofpoint-GUID: kgA-j8pIo7SbPuWOeJlJUrpje0l0-WoF
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-17_07,2022-03-15_01,2022-02-23_01
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 17, 2022 at 12:39:16PM +0100, Jakub Sitnicki wrote:
> I think we have reached a consensus [1] on how the test for the 4-byte load from
> bpf_sock->dst_port and bpf_sk_lookup->remote_port should look, so here goes v3.
> 
> I will submit a separate set of patches for bpf_sk_lookup->remote_port tests.
> 
> 
> This series has been tested on x86_64 and s390 on top of recent bpf-next -
> ad13baf45691 ("selftests/bpf: Test subprog jit when toggle bpf_jit_harden
> repeatedly").
> 
> [1] https://lore.kernel.org/bpf/87k0cwxkzs.fsf@cloudflare.com/
> 
> v2 -> v3:
> - Split what was previously patch 2 which was doing two things
> - Use BPF_TCP_* constants (Martin)
> - Treat the result of 4-byte load from dst_port as a 16-bit value (Martin)
> - Typo fixup and some rewording in patch 4 description
Thanks for your work on this and reached a resolution with the remote_port !

Acked-by: Martin KaFai Lau <kafai@fb.com>
