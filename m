Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F173854FE38
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 22:22:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345996AbiFQUV4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 16:21:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238420AbiFQUVz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 16:21:55 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EC6F50071;
        Fri, 17 Jun 2022 13:21:54 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25HI3OBC008985;
        Fri, 17 Jun 2022 13:21:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=facebook;
 bh=BVMRKGFnc5CYubSU4XiwUXknaqcJleODA5SXiPpKbuw=;
 b=DDrRH9fd68WeIC0igup5w5ajqBCfFwZQDdJ2T39yGIUTC2jgf+x7qXRYGrKMaAqPKX3a
 V2bGDjHj0Iiv7K2NtSuEiL+vAq2T4f6p7lGAvI0MO/IjR4iSuIohyFksdQJfpGiCDxOV
 SL9qELkDwhEq5lnAJfxDT8pSThYYKRbv1p4= 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3grjetcur2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Jun 2022 13:21:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X4mjhVbbIoJVZH3GJhWn4sYTU1HyxDIsHJ0rxg9LAiW7UVMsF8ULym4w5GRNU/Ev1FiL9DsHrd1PUAE/JhIY95x9QxqJgZeCnBmTyVA6Grz+75EnOliP5vtzGpo9JUS57SSCoOBsoQAN6INqXZVViAJJ5aMorq+hkrIoVhplgrTjvd30ds8XtOINTyocnAE45qBH7ZxcsMx5VLiAuqpHpCYTdKdh8YbUGlbn7ZdZM2STfCw0SdR6bFeVH2lMgjs+sc3hzhjQbRZS+6zbYgLCxtufi1EMX5g06ZOmV2l+pkMyVnZFJg9R4pFSr/UQWhVcH4bUhSmyIFPgaAekKlgJZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NAql3QIrriE5UqwYtRe14RraEjQn3/3+EAh8vG5v2Bo=;
 b=m6HfzyanVAp24aSCJEsh8A2Oh2e8eDhwnzwn+y2d4rILDPRRWXBIXDUHgKX4XT/+YKr6oa0cDDaiERpkIkGY3ibrRfjjwTSdnbq3nJgjIlrq4cCG6a8tw8q4ajvJXckfAZaQa8uGkJpzUty5C4ZNp5fB9StOaYnWAUWmvxfKRHNcXRqZIz/dJ55qj2fRoH9G6atnrfK7n3AvwRK5BgfsixMigmOdioZ45aQiH/3woRaNNLX7cj4eh4/NLqQP24qwYP478lVpxzHAc5DagtEZzgq9bCAAXmAzuyYIXUnn+qDm1zRV9evuZ4pLruqXysRaaSIdZgly2FdhlLC5gy8NIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4475.namprd15.prod.outlook.com (2603:10b6:303:104::16)
 by SN6PR15MB2352.namprd15.prod.outlook.com (2603:10b6:805:1c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.16; Fri, 17 Jun
 2022 20:21:31 +0000
Received: from MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::3941:25c6:c1cd:5762]) by MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::3941:25c6:c1cd:5762%6]) with mapi id 15.20.5353.017; Fri, 17 Jun 2022
 20:21:31 +0000
Date:   Fri, 17 Jun 2022 13:21:28 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     =?utf-8?Q?J=C3=B6rn-Thorben?= Hinz <jthinz@mailbox.tu-berlin.de>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next v3 1/5] bpf: Allow a TCP CC to write
 sk_pacing_rate and sk_pacing_status
Message-ID: <20220617202128.h5cmcyth4ddspkia@kafai-mbp>
References: <20220614104452.3370148-1-jthinz@mailbox.tu-berlin.de>
 <20220614104452.3370148-2-jthinz@mailbox.tu-berlin.de>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220614104452.3370148-2-jthinz@mailbox.tu-berlin.de>
X-ClientProxiedBy: SJ0PR05CA0032.namprd05.prod.outlook.com
 (2603:10b6:a03:33f::7) To MW4PR15MB4475.namprd15.prod.outlook.com
 (2603:10b6:303:104::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 594d63af-19ba-4a6f-3981-08da509ef76e
X-MS-TrafficTypeDiagnostic: SN6PR15MB2352:EE_
X-Microsoft-Antispam-PRVS: <SN6PR15MB23528A8B8F24BE8D0A6CEF6DD5AF9@SN6PR15MB2352.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 26ngMp2vQ5EKfWTSETDlce8nBD6sHTalLnVxau6l6/z0ptspsJYbPRvCL87aimxIZ8HmlLIecsGpy1rf6flzgaCXpPC4rd3+r51I8XrAV5rxLJ2ap98CDH/iUaX/LRaXxi1qKfj7r+nWaswC1lySI2wnmr5YbuHmexnNz+n9KiH4X958v8yxsM5qctAtlVMvHLgHkTwmAIcIypyTWYxKa9eI5hvAHzNBOFbxoo4WjvzlovVBY6jXWv4dK8ZxGyGzzokeLm2d/PhTKJpLiQTBqtmrBb/NjROIqgcjuIXXF0Fr4b7jTMVS3dAzxUeWbKhMvD7oZILSJFtDjO8k/fTrdLxN1sNNLLb9b3m+ignT1JJCYE9IUN+UUg32aRV7ryHqe0yXRpoEpUQqdiX1Wsn+gFrXWOPneQWq1ghCMIHW2cdzWOohMtsh6UJq5q74eoiitqBOU9tN6TtNZEhv3UPYtsT6Y7BN6aZVgsX1AO6lFsEHdnUl3KA3WBScPZIFZ6dVfsYvW8xIcMMjVISh4xN85BiJrI+V7dyoEFBLJOKN8AHOjV7KQ6Y+se4krh8FjGJIWWTy93Wy2ToWyrvmjRHVdtcHwunQZt/h0ARhLieSYVs+m5z2pOansD8mmsFIyiRvlAtO65yRwqfABsvM/HUj8Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4475.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(366004)(6486002)(83380400001)(8676002)(2906002)(66946007)(4326008)(86362001)(498600001)(66476007)(66556008)(186003)(1076003)(6506007)(6666004)(316002)(6916009)(38100700002)(66574015)(4744005)(52116002)(9686003)(5660300002)(54906003)(8936002)(33716001)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?cnsb+XB9HeZ/Hj9WQm4Y2PvOSeqwUxMKF30mw46i8qW1W2nj+UGFqhIGh6?=
 =?iso-8859-1?Q?LwZDH1aQ7CqsUAtIQRUE/JXGF+sjfUPh0sM+R0rTdBhPA2yt/sVqFR6hHi?=
 =?iso-8859-1?Q?HsSU729D3VYEzCbBVmax57I+cEGQ83f9CFybTZKR7qfpPBF0kkKTnUrdbL?=
 =?iso-8859-1?Q?BIeHq6R05bX69BesIzuYCLdZp/aKKVEBegK50Ah3jxhNRSTEUUT2OhiSpv?=
 =?iso-8859-1?Q?HrxqnqZ/XEtHHGB6kw5X8w5C+SsgLmmebluKXZsoFdP+SZo/uDGxLj6xHT?=
 =?iso-8859-1?Q?3tYkfYzMxFxbtAqyS/uwysol7plRUW7Z6n8EDqX5eJtQcQ6LOKqAI1l3wl?=
 =?iso-8859-1?Q?pcn6yCq4M3OflvsxFcbbiMTCehxzb9gSPvl9ctYffuu0R8QLu9CLAA30AO?=
 =?iso-8859-1?Q?gFLcY61wFj5QR/54M1oPGSjcijc+VOv2a076nm/aHGJV1VVPjx1bEzsGgI?=
 =?iso-8859-1?Q?585JTLR8Iu4ylAolHe06OB+BGGDABvxBDnoBWy9o6n9F9Opz8NqTnI4XKv?=
 =?iso-8859-1?Q?otMHLqu7GJrdNPGmmhL1ZBaNQjKMUbCz+5pRj6SVugVOvDh7LfByQz76my?=
 =?iso-8859-1?Q?DQJZch9HlqMhKpdVZc/Kn2dlqmWXGXhZ2kiVJaesMO4PWFixJGRzPP6OwM?=
 =?iso-8859-1?Q?lg5EPG9xgRXdCGxY01bo/K5BdSMtwmGBbehKAZJj9en12p4ZXsftpMYu9D?=
 =?iso-8859-1?Q?W/4W8IxnuP2hesrXVSINHwKPA8KTSHt9ZxnOLso/ckkl59MAXpD/JbegTP?=
 =?iso-8859-1?Q?LWI09aSJ/ncoKGIuW3Y5fsa8c6vsoLlQIPx5OKKm4GW777eXprKvDR7tZz?=
 =?iso-8859-1?Q?ex1vnM6xHYQvpYPqyWQ8wkzL2XHIb6sn26g/TI83YJ4B1pGSvezHTQaPjt?=
 =?iso-8859-1?Q?7+WxB21JX9k/tjX67+JNOYqEU1yhrH7+JGqOECNBhxfq3onV0VKC6pa6Cs?=
 =?iso-8859-1?Q?pWhgja4miFVP1uMFVW8aALwTcA5kOgENc8fU82126VnhbnJxqb8xqkbDY5?=
 =?iso-8859-1?Q?xloDsu2SkVPlucKQz5NY3D6q2a9vnRq0HlzwbY/y1MtemjKpxGiiYDQht0?=
 =?iso-8859-1?Q?2TOMmdVKKOeuftWELhR3xRpIIACJdOCcAU4X050snGFAbz+3/2UH64iIn0?=
 =?iso-8859-1?Q?g69uXsSU9/5OMookULwwSY8vhdBAlqLImtVowZJRHJdRRea/V09Lx7LZVY?=
 =?iso-8859-1?Q?rvIfnSnLwYBP6sSjGZvTc0EwL1oURj84O21zAqhO5DgRe6lwTJdd8vDfe8?=
 =?iso-8859-1?Q?kcvj6KrJ0ZIdZrpp3sd1/RK3hQmDU7Vc5n3GiRoGqd64eeM9hJiI8xVn+s?=
 =?iso-8859-1?Q?da4DWgxeb9VSI08pezNKaAi+nthcBep2eVBmFHMp83I8xmG4LrpEYF9ymw?=
 =?iso-8859-1?Q?gptFhjGOYI0vmWytqDHA2hKCbmwJMOF+7mlHpXc4/IesgxUMUD3ocKsM4c?=
 =?iso-8859-1?Q?fM+fc/KakHpVfRL5tA4SENZvkYlQ62zGx9vPLLn+ytwDsAd1uHuSH/rYXf?=
 =?iso-8859-1?Q?DTmXH1oNJaqfHNiuhPFboHH7KVapDkKb3KbzQDMkcIcvbs8w8uta2MyfXQ?=
 =?iso-8859-1?Q?PJilmS/9xC/K3bEiW0sRSiTlzVPnHOH+MfHrL6VYuHtlOoIyDA1dMAT82H?=
 =?iso-8859-1?Q?dsIqOilyxherSJ2FeM2MQlAe+QeUkVoBODBFt5Gih9ot97HS9zepeh4ilZ?=
 =?iso-8859-1?Q?T732zy1EtS+XVSbDsle9Ct2HeD5LCtFc9za2C71AF9w+97l13kr5nrDqn7?=
 =?iso-8859-1?Q?R62Ygmc/1oN0NmU7HQoGZiuEqVDcvH1xmBmY46up4BoDD5yn4jndhF35/U?=
 =?iso-8859-1?Q?dDbDpveguoWkLuQoSFHS99h4i+bwypE=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 594d63af-19ba-4a6f-3981-08da509ef76e
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4475.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2022 20:21:31.4004
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /hs8YiOPwgCw/7uIapm8qKOU6oOFWE0GZbXzedWQpBnORiIl57tdRWrAvBVrG2Y9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR15MB2352
X-Proofpoint-GUID: Dzjm_ybfPiLo0aUiXJIYpLpecMibMHgN
X-Proofpoint-ORIG-GUID: Dzjm_ybfPiLo0aUiXJIYpLpecMibMHgN
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

On Tue, Jun 14, 2022 at 12:44:48PM +0200, Jörn-Thorben Hinz wrote:
> A CC that implements tcp_congestion_ops.cong_control() should be able to
> control sk_pacing_rate and set sk_pacing_status, since
> tcp_update_pacing_rate() is never called in this case. A built-in CC or
> one from a kernel module is already able to write to both struct sock
> members. For a BPF program, write access has not been allowed, yet.
> 
> Signed-off-by: Jörn-Thorben Hinz <jthinz@mailbox.tu-berlin.de>
Reviewed-by: Martin KaFai Lau <kafai@fb.com>
