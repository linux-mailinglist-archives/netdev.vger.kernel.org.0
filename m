Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C2F454FF4F
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 23:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234249AbiFQVXC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 17:23:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230245AbiFQVXB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 17:23:01 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB2A535ABD;
        Fri, 17 Jun 2022 14:23:00 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 25HH4IDI012853;
        Fri, 17 Jun 2022 14:22:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=facebook;
 bh=NytdUnVwItDG8OZ2u9glOihtYcC4m3s+RwhbsQ/7ckE=;
 b=dtW72yfe79htZfK5TDRG0kbh/TklLPJ+tAXwX724viWvNXMQrx5685r5qYAxcUd6y8kP
 bdBMDZ+GEDB9oT1HFchF6Y3Q5WuOgQye7biSd7vYLgmhye5URQbT9bCZKTUcg/QCKVKs
 b+WQbQeUp1+gp36rMLz7bQCP+yulmH/a9ME= 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by m0001303.ppops.net (PPS) with ESMTPS id 3grkew4vbd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Jun 2022 14:22:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XO6JUaBRB3c58dlZgLxOYc0xz7DAZLvnAbdm5d0nRZ1aY1GSRyBX4fzNTZ/v+UQNlmd6z5RzRt8Ry2JHLOdNANWneCR/CLvcic5eQdRBxuSUrf9piDqFqI7SX20+AnI1oHT3h/1V4CRu4GxzgQ5ngAjXQEzoxnlDUN+KkXZDRah8Wl2WZaqxk1DSHBitM9CPvLJB5a8H6u2zPYHe0B9rKesdB6hP97docFi7bKq/izBFpzsN7n7ygZa/W9cDJGE/q1XYNquOpugUBQxzcgwCSaZW9MLbwbDQ7CRaH4worrLqX/FotMQgq84ghImmh15Nzzhbirrt+Hu8gyqh4qpOew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+RcsO8G99mLeh2NxpMo7b60msB3MFWh1cmM1s7RgMsA=;
 b=V8Cowc+g+NTer4Sio0vNY3oBV04FUJY6KZ1dP4lvp/c7uSJQuhDsmGSqUN/eoB/YQGiOBq3GOEx1uquwBHOB+d11TqzwQMHhRU8JPdtOxwlFkaJmR6QWHTPN/wfIxeC/29gHC4o1GXln+u3laRlQ1fwj6oqfJhbmzOuHxhef2OpI8UL0FHlKEwXs3CfbCYLkG3xrHGbXv7X1MDp6dUYaL51t8E4P0BIlFsih4UDuvLBW9jndh4F7hpaSISV4AZQbWqSczRIpTeg7Qh+Gl9k2ynw8xyzXWU9Bk9uCBZ85oz/7vNuMryxIVJ+y5mF8HmPZgHWy8TnAK0WfN8UuuYncRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4475.namprd15.prod.outlook.com (2603:10b6:303:104::16)
 by BY5PR15MB3602.namprd15.prod.outlook.com (2603:10b6:a03:1f8::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.16; Fri, 17 Jun
 2022 21:22:33 +0000
Received: from MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::3941:25c6:c1cd:5762]) by MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::3941:25c6:c1cd:5762%6]) with mapi id 15.20.5353.017; Fri, 17 Jun 2022
 21:22:33 +0000
Date:   Fri, 17 Jun 2022 14:22:31 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     =?utf-8?Q?J=C3=B6rn-Thorben?= Hinz <jthinz@mailbox.tu-berlin.de>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next v3 5/5] selftests/bpf: Test a BPF CC
 implementing the unsupported get_info()
Message-ID: <20220617212231.j4yqjmbqmj5dtqpc@kafai-mbp>
References: <20220614104452.3370148-1-jthinz@mailbox.tu-berlin.de>
 <20220614104452.3370148-6-jthinz@mailbox.tu-berlin.de>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220614104452.3370148-6-jthinz@mailbox.tu-berlin.de>
X-ClientProxiedBy: BY5PR17CA0022.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::35) To MW4PR15MB4475.namprd15.prod.outlook.com
 (2603:10b6:303:104::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5057a06d-ae82-4762-ee77-08da50a77e50
X-MS-TrafficTypeDiagnostic: BY5PR15MB3602:EE_
X-Microsoft-Antispam-PRVS: <BY5PR15MB3602019B9E7A18D9664A48CCD5AF9@BY5PR15MB3602.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ohLKdgKCKwgR2c62RlvUY43PmcvamjLaz7CgQZAZEnGe1VigoixdPpLF0zuL84l+w8Fwsie1PkPw36hNa60Gx4e3AAOfSdjk7B6PVKu1YRiGg7i5phfBEpxzNTxXXtv/ieMYTr6diCt2Ag/g5BgCIM8S+82rJrAkx8rDH58TjkUskIsiQQ4BL3DSiMebU9oQusUkRfjR2JKPapX3dG2T/BuMHjbe6rpvXnBDYI9AOCjJHh/haFmy38eCoYgILDy4/J2MDRB/jNUyVansxI2dC51nvd0lS4eZpy2NPjhyEOKixronXtDZVI3JhUfoy6A24Nv5BcnpSyehg3HyOPoXPz36bAdUmFgQ+4KarJUlXB+LMy5/DC0WfFPxbN9pApX+oSlanuB+M2f/07b3LKdNdboZAWglCPtIF+CJA1g4CwHSgN3o6YLauuGGJ51IPV7sSBZYFXwfrOw99SMNK9mg6wLssvrHBk95KAAzDr9VH2DDJ3ofQTtsoqodbCB9ut0GjL5wJgfG7CzB6Op/rC9YATkq1U9Worz4XVjvwf6QA+AfZq0w+KDNywbPU0qLAWWlqnHeHeULz9ATd90Oew0E9K9sruPYvMVyQ8t1SuARA3Tjd8J6a2W3hG9V9l4QIhMSNHSqlAk3aeVdeTueHHgQZA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4475.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(366004)(2906002)(316002)(54906003)(4326008)(66476007)(66556008)(66946007)(4744005)(8936002)(33716001)(6916009)(8676002)(5660300002)(86362001)(6506007)(52116002)(9686003)(6486002)(498600001)(83380400001)(38100700002)(186003)(6512007)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?86ePZEU/1xaDbhm5AS2aAxD/5g51SShuwuK1jG2g5mo2G8k5zBNtjQm0Te?=
 =?iso-8859-1?Q?30C8bpCo4N7zVvhvWC9mW2rSisbSWS+icAolXoWG9UGYQaCNmF6WKyi9EL?=
 =?iso-8859-1?Q?SgS8hXFzm4z84LXJX8UnUA8DP27Ol/yjiLrHrjPg2JZdF0YdoJL7Vx05DB?=
 =?iso-8859-1?Q?JyGRjXJ/bD99cxZASNHkVA8tDn41Z/JgcYyBQVXEliOuayYIblJD4IMPE/?=
 =?iso-8859-1?Q?Pq95l8RZJ4xiFBD2Ck1PcxGb9O8OECeFkhVTeDhsglgEUMhzuWTHaeOda3?=
 =?iso-8859-1?Q?z7ZNBYT3CFGodS3O31iVSBPwgmdBvQcxAbCDPL5LVmrSCygEIiuWm9AzSg?=
 =?iso-8859-1?Q?8w+3uUjD2K+LvUmQloBfMcBKX+zkTamFYCjgUBjvt9L8/zDgyhv/iqcrKw?=
 =?iso-8859-1?Q?13Zam6F2NmjHZ1yovAgvDYX5tjmG1TBK5mWWdCpT7lYqqq9fXLTLkExa1W?=
 =?iso-8859-1?Q?xT5zKaPEo3+sGqT8foHLHy4qX/yTBEJ2ujLe1/k0R+8tsj729cc/62nR1X?=
 =?iso-8859-1?Q?5t13MIiMcrHfBkJ9w1CwHLcL9SOgisB1ogaXFFPEJkJgN+y3QfPRcG7MSg?=
 =?iso-8859-1?Q?YpXxwUUzXh+PC6+PTcGo2WedgytrFlNjdunGvL3T3kuB8efc7xfFV1dF+0?=
 =?iso-8859-1?Q?U2ElazoONwXm6J27Kwxy/oOG4omRA8zuPlZTuri15SlVW7h/UiWfxVuX9c?=
 =?iso-8859-1?Q?ou4BLPkehI8MTNkhvUq6XBwE2JIafTR0OuDj5I7A/cpoulAFHTPrj8Nl6J?=
 =?iso-8859-1?Q?KmIuIxazQzi31iAj6U3jHm5AVhdcHByQVT58ulo/aARwPXg2ps3PF25khg?=
 =?iso-8859-1?Q?Z0BwmZSMehzIPOI+ZuJObt+PyRQZk3lluWsOs/3PIvyltYyklnDTHnmHJ/?=
 =?iso-8859-1?Q?nxT5LpJcGMyxMmdPlOMKotTwu/1lqg/fbvkYojDlldqfviCq+5Wat+I6P4?=
 =?iso-8859-1?Q?y5X8gE+bZx0ryM9c/NDQp3X13bQ0kayOQMV43VHj5Q/DPazx/3hSgYotzD?=
 =?iso-8859-1?Q?lem6akafKHl+iGL8HtDynfYFiAEiKZOgvGPpHZwoZED5cfnzw/6uy0QR4v?=
 =?iso-8859-1?Q?5+BwNfe/pa0PQqGgRS5XaRBOXKzKH+s7zGov8mG3D8ntaDcuZ/t2jU6Fe6?=
 =?iso-8859-1?Q?0wJsw6W5d/c1w5hNJettaqA7mflYzoN8rlZVbGFT6u+N1p0lGYoseky3mt?=
 =?iso-8859-1?Q?ScpdjB6ld0TnDmQHoQmm7sejxc15WH24C+fabMJMEecnapHDpbOHVTHEmE?=
 =?iso-8859-1?Q?edQAXLhi8XfeHr8BySGbks314M8mqV7qNykE4dY1rRB1UzQqfJ2SWxkFsL?=
 =?iso-8859-1?Q?CIc3Hs+x7Yv2wrXdDUo5UA7RW/k7q4h2JL5nCfAGaoF29wMA7zXRlX072s?=
 =?iso-8859-1?Q?pIJ6Eyz1j42nX7G9TZbFj92hXIOuWrkQlowunwKV6Rw3LfnzQgmfKPPoO9?=
 =?iso-8859-1?Q?uX++tZzANURkB5v9IfDLyKi+93nOEYQmXenO4X2rTieE4jLrKn/OSyuyAK?=
 =?iso-8859-1?Q?lqvnTCwQNultIOKVBC7Ye+Qh/cv+UHPpjZY8ANXd9zxW7MYo7VARFtUhBw?=
 =?iso-8859-1?Q?XnUxaz7w0gDSa91p5DG/qQ6p9zlsDeiABjjzfKlEiYO5ClQLvE+C+AJwkt?=
 =?iso-8859-1?Q?Rnpdpo0oi/GWgdMF9lwxdFZ4tr+1JFnwDJ4YL0B9XB1ZQy7UGT68iYUucW?=
 =?iso-8859-1?Q?KDl0rgEvw9BnqCqtjOJy62Pn6gPfjpuWfGQOfvFGouMfksvePa0ie4tvst?=
 =?iso-8859-1?Q?lMynZK0yrtvCSkiFJzG5lmxhYG1Cr5WlfWdH6OphDjczgW5fDdaW1W9glt?=
 =?iso-8859-1?Q?Bc0vaeM6KFkH1WHTj46tIBWuQYIcw1k=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5057a06d-ae82-4762-ee77-08da50a77e50
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4475.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2022 21:22:33.6277
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ixuj2tjRNdwd9h926T7Xt7E+IdQMLbEdX8GLs351/PT4kO/M9cmGDW66nnYJWHsy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3602
X-Proofpoint-ORIG-GUID: p2VumNON0u6zDs3aJf-_h7a3gqxJAA7x
X-Proofpoint-GUID: p2VumNON0u6zDs3aJf-_h7a3gqxJAA7x
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-17_14,2022-06-17_01,2022-02-23_01
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 14, 2022 at 12:44:52PM +0200, Jörn-Thorben Hinz wrote:
> Test whether a TCP CC implemented in BPF providing get_info() is
> rejected correctly. get_info() is unsupported in a BPF CC. The check for
> required functions in a BPF CC has moved, this test ensures unsupported
> functions are still rejected correctly.
> 
> Signed-off-by: Jörn-Thorben Hinz <jthinz@mailbox.tu-berlin.de>
Reviewed-by: Martin KaFai Lau <kafai@fb.com>
