Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5518A563ED1
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 08:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231616AbiGBGY0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jul 2022 02:24:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiGBGYZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jul 2022 02:24:25 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F843205E1;
        Fri,  1 Jul 2022 23:24:24 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 2621nZAa031676;
        Fri, 1 Jul 2022 23:24:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=OXSHWATaN4f+H3C1t4DFwvL4RC8s044cpPw+FNkySo4=;
 b=URw1cz3mt6Cf9B1r+3B4h6eQoWewvzf/YsrC1CnyVXwXrWZsg5Rd4l0TgtLKUDz9KZbV
 uEPXoFjwohYd/Yhysvzy22N0Z8jHf9kINOkHM4ki5sYSky2KdIB+MYRH4K5VV+9lC4Oi
 GCLixc6hi7uNfHplXfB31/y+pHOxKy1/qI4= 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by m0089730.ppops.net (PPS) with ESMTPS id 3h195adafc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Jul 2022 23:24:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iJl63N/TQT1x5hYb3AsIt/kNPRt6G7tTMx2nTeiwyJP3vBMsCtmHWvP8zxOlWck/z0uouZ76g8XpqNgbXbQi5I/zXOfNFzSLasVq1Wb+s5GJct1xUVAM6nSGCJYPPpkh92eubZg0KaDPOjsN8MeUN98SlJMiZt3t8WUSSWrF1x3vhBI2fN2NTVbLKwS/iuwjeYCrusydqLlAFE5Ovd4uu9SW9MggELD2ZCvgiWBFaOqhlynkbanrhccrcjOLtb3zBkmLxFIRD0uW6eEFlUQviYv48oKAyvccX8DDFA2MahX7h0XOb9GC+qOv0blirlyxZHZFQKd+ByDl56SK+sTP3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OXSHWATaN4f+H3C1t4DFwvL4RC8s044cpPw+FNkySo4=;
 b=ciA11MHnG+3o7lGQVE8vFTnO3UTzTp2960U6o4zA43fEkp2ez+EGvCYAGZmPo7zDKKqBeo9KK3n4ivLcBEQdD8aYlwxGXw82sG4UvsjssIy3iE/7tTdKdwQQPPGuR4LBV6tpFofXOPzLIJCsprnuVp4PjJJ0FgJyYZgpqOzrW76pgjJVarCqi4YOEnwOeX2/Dj2fsVp5YtA+TT7LodtdAPHMkr5B4pHpK/CyGAMQzR4a0mDklHoRD6yOeOXO8jLFlhueta2ng62OUdLlRUYLdDcHHxeR6hQh7R5ZzwrN9m8gIqj1/7Tnj3RfTQ37iC9mGSWSVizuoIqv/kw4J4Hbiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from DM5PR1501MB2055.namprd15.prod.outlook.com (2603:10b6:4:a1::13)
 by BYAPR15MB2373.namprd15.prod.outlook.com (2603:10b6:a02:92::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Sat, 2 Jul
 2022 06:24:08 +0000
Received: from DM5PR1501MB2055.namprd15.prod.outlook.com
 ([fe80::acda:cdec:5c2f:af77]) by DM5PR1501MB2055.namprd15.prod.outlook.com
 ([fe80::acda:cdec:5c2f:af77%7]) with mapi id 15.20.5395.017; Sat, 2 Jul 2022
 06:24:08 +0000
Message-ID: <e765f097-f865-9253-f471-9d219a8b5f12@fb.com>
Date:   Fri, 1 Jul 2022 23:24:05 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH bpf-next] bpftool: Rename "bpftool feature list" into "...
 feature list_builtins"
Content-Language: en-US
To:     Quentin Monnet <quentin@isovalent.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
References: <20220701093805.16920-1-quentin@isovalent.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20220701093805.16920-1-quentin@isovalent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR08CA0039.namprd08.prod.outlook.com
 (2603:10b6:a03:117::16) To DM5PR1501MB2055.namprd15.prod.outlook.com
 (2603:10b6:4:a1::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3d300faf-a0ce-4541-506e-08da5bf3787f
X-MS-TrafficTypeDiagnostic: BYAPR15MB2373:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 04cTKapNwGGHx+qFtd5sldk/GP7w+uSnLRWSM1aO+q1atVlo3AKkoBilci2F0YLy2+8YJg3Pn08OhcUbWSzkfTU2gnZEa3LNfhmScdTMxoD5NoEB13RN896Q4y1z3WVeAERNRdpTqwDBQjs3q11xIym3NY/jSZsL7GjEvZH3PPS5LhoGSzUy/m5SeV4YbDWwVZQciT6AsxCNsGJaFT74K+oXsa/dEuESwLxZ62fyFg5KyeA21RJEZn6qQaXby16cmsYTENTVWB0zaC72YJmLbnt+LDiS0HuOgEFpgpAET9OGrxZqazHWc84gTgEp+qcAXyp6Y6YhS4SiuHPNnFo4kofeSK4i15fKMcnoiMABHSnUwlRKusjBkvG+V/Gwclyf4tKxXdJPQYDaqAb8U8FOiE0vJosWY5i2F3+5ZFyE5udDpaok0M6B4lJQtsKAVtVuA/K9RTQNO4muPYnsWRJE/ufrlkwqvERnd0/I7wqjqDXiI0zMbVCtucGRb996jdpomFYluCjiYnu7Ne3N8m2e4uSNRLzKsrK1mUSWj2d6VtecBA6nME0paw9e33ljPzeUssW46W7pDH7eu9+OsqLSttfIh3lidvhxr8/NyifObhsxyIL1wjJkXeJcoSBMWu2QhC3RNuzzfW6GOC8S18aD+I/dMGUkXEvt9S72fb/aBszCjOTi18bbPr41tAHZfdupsDAD9wKvjxT/ByeG0MxOSk94HVrW9xqNbFiN9c5We1Ltci72HbDKYSNJ5lHHAo71cuXtzEnka6IFtb4OUyytXR4GgV7V6pU47dxpZeueH9sKHiXOeCgEK9OvTj1JD/ahkdqwIWlbtZ9rT0FprenHvgH/+LHvO+sD/gg5PT8jm8E=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1501MB2055.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(346002)(366004)(136003)(39860400002)(376002)(478600001)(6486002)(41300700001)(316002)(6666004)(31686004)(6506007)(36756003)(6512007)(186003)(110136005)(53546011)(54906003)(83380400001)(2616005)(2906002)(8936002)(8676002)(4326008)(66946007)(66556008)(5660300002)(66476007)(4744005)(86362001)(31696002)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bElBYnc1MFFLejQ0UlZNcWdDMlFUaCtSeXNtTU1ZN2thcFZaVytJY3hqZFpY?=
 =?utf-8?B?RlhJbWhMUmhjNTd6ait5QlJZTHB4aElESlJaYXUrQ1FNWFI3dnVmUkZFa0Mr?=
 =?utf-8?B?eEl5UjQyK3hWcmtFTUZhSyttRHNQTzhMUEowdnJvTE1URmJFdUs2YndjM3A1?=
 =?utf-8?B?NVBTSjF3YW5YelJKWVlGZnR3cDRubUo1aEowK0dsTEVhMTVIdjhhQThGVFJu?=
 =?utf-8?B?Mm43ZlAxWHNvUkpiNHREVEJkaDM2NU5XSS9KbjJRb2w4ODNrelgxWjF3UzBJ?=
 =?utf-8?B?L0ZWc21kT01OcDRPQWxyL3hhRjJxaWxSTldOaWtqN2FxcEFITko3SWtwRFpO?=
 =?utf-8?B?RERnR2RtNTNvSFRhK1F0NC9BRDRhaVJ6YjArakRVR3o4TUFiWTZabU5uRnZ3?=
 =?utf-8?B?VDg0V2huSkJ4WElJOVAwV3gvbmplVmx6eVpJc0ZkUkcwQURsc3AxNC9BVmFF?=
 =?utf-8?B?L05hK1RkaHdqemlrMndEYXdKeGt6VWhab3MyQlkyY1k0elNReEFmM3NwOE80?=
 =?utf-8?B?bkEvNkhlS0haSDM5T2FYclplak9LL1lXTG1VZVBpZWVtKzY1MHZ4L3VjQnJh?=
 =?utf-8?B?MEVmejBEU2k1TUFHcGpjVFU2YXVNT2FTOVNsRDJsUTk2WDFrNkEyOUxrVXR2?=
 =?utf-8?B?eVZLMkEzeDFEdHRzNGVIc2RlNU9TbXBvMUluK2xrMEtGbkQ0SlA5UnIzSlg2?=
 =?utf-8?B?OGRYZDFuU2krZ3BPakl3aUd5TjdqMVpodG8zV3AzdWdYbEcwZFNZanJWL1FV?=
 =?utf-8?B?VkZ2YmVVblpIY1NuYVgvcXZIN2R3N20zV0Zyb3ovUnRCTmxyS0NGYnlSU2hP?=
 =?utf-8?B?M0JFS1lpZWU4dS9ORnAzd2hJVFpQdVlzYnRrR1hsM2ZZYk1VTFgwRlg2WkpY?=
 =?utf-8?B?TTN1d2xYTzFvVGI1TTdDeHh5YUhvOEJLYWdwTVNOZTVtZ3RINmdEVUZZYkNS?=
 =?utf-8?B?Z04zREg5dnRKb1BHVUdBZFNxTUVXaTExd2p0UnhXSUFKMFlhV3VQMnVpMVRp?=
 =?utf-8?B?b1UrdFlKa0NGUWFKTGJkUVZmTlFiUDVmMS9RTXcwL0Z3bE5qUU9Qem5pbEFX?=
 =?utf-8?B?WFc5R2c4SENNT0lXd1F1aDAzVU9tNkpySkNaLyt0Vy95Qk1LU1hFYitnMVNN?=
 =?utf-8?B?amNabTF5czJxbExDQkRUVDJCY2JTd3JDanJyRFltdnZyRzhKZStNV0FsU3BE?=
 =?utf-8?B?NHlZWjRjYXlhSUo5VEVpcU9jOHMrVVF5VmpWS1MwVXMxY0w1K1lLNkREZVF5?=
 =?utf-8?B?RkoyT1NKUllvR2Q4OHc4bDJwWWdFQlY0eEd0Q09WY3BGQTJaNHRzdHBmTkcw?=
 =?utf-8?B?VVNCS3VWVkNzUHdrN2VNZG9mSmNpUFYzb3BPbzBFbTJmWjZqTkx4OTFLWVNx?=
 =?utf-8?B?RHJIc0c1SGJXVDVkZ1RvdU5lNGFveG85dTVUdkh3UElsc1FJWnhHZksvRXMr?=
 =?utf-8?B?S25lKzI3aXZqSUlDUGROQ24wN244Q1pIc2FIOExycTZMUGJXeCt1ZUtjd0N5?=
 =?utf-8?B?K2dSMDcydyszaldpWmJxSGhlUGU5NGIxM1FJcjM2L3Fpd0Z5SFNnd1N0Y000?=
 =?utf-8?B?VElGdWNNMWpFZXFKWng4ZS9taG1uR3FYZjA0QVBZWmMzWGpJL0FYbUp0TWNr?=
 =?utf-8?B?VUYyVHNuM0hLSGdjV1NCc3VHSkxGdlJ5TkFMUjVaQnlVZ2RobGx4eUVZNzBL?=
 =?utf-8?B?NjNQNmxBQU41MWVjbk1vRlpRRUVwUWR1U2FPdVhNT1M0YWJDdUVPMytpcGlx?=
 =?utf-8?B?QWV4dnkrR3dUeWhVUU1FNUl3eGtrRlV4Nk1ZNlhJVHVFTHEyMk9YcUlNU01o?=
 =?utf-8?B?enpRcWhnYnpHWlJrVzF2WVJqbG4wV1Blc2Yxa2pkSXUyTGNHbHV4OVQ3Q3RT?=
 =?utf-8?B?QWlvWUVzbC9SSXNPUGZJSHlMM0lzZjhyblgrNjN0dmMvU0tTUm84aXJOS3A3?=
 =?utf-8?B?NmRwSnNZTVNMbzRlNW9na3dWSlZWNWx4aC9rUWJJVmZVcEx2bG0vNXJ3dkZp?=
 =?utf-8?B?M0RWOVhlU1R4UVViTFRBZDBpWWIvWXFjZzF5YWFqTjZjWWJKVmgrd2dXSmZq?=
 =?utf-8?B?bGNUTENqNUdpS1N1dWErT1p1R1NsY1Y0c2wwL1F6bDFxZ05La3c4bThmRzdw?=
 =?utf-8?B?czQ4cVRYQWRuVkl6dWJqTnFmdXl6cVF6MnJ3TE1mWjNTTHlmR3lxZGxhbU1i?=
 =?utf-8?B?cVE9PQ==?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d300faf-a0ce-4541-506e-08da5bf3787f
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1501MB2055.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2022 06:24:08.4699
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Tunlv+RpTxm2GjX6/PVgXDd5m5kjxAxIaJzk/wD0N0FCxOdGvS/GkqIQizeGFvWW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2373
X-Proofpoint-GUID: daIeKGWEW_PZq5ByVvWHw3-R93GuKlbo
X-Proofpoint-ORIG-GUID: daIeKGWEW_PZq5ByVvWHw3-R93GuKlbo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-02_05,2022-06-28_01,2022-06-22_01
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/1/22 2:38 AM, Quentin Monnet wrote:
> To make it more explicit that the features listed with "bpftool feature
> list" are known to bpftool, but not necessary available on the system
> (as opposed to the probed features), rename the "feature list" command
> into "feature list_builtins".
> 
> Note that "bpftool feature list" still works as before given that we
> recognise arguments from their prefixes; but the real name of the
> subcommand, in particular as displayed in the man page or the
> interactive help, will now include "_builtins".
> 
> Since we update the bash completion accordingly, let's also take this
> chance to redirect error output to /dev/null in the completion script,
> to avoid displaying unexpected error messages when users attempt to
> tab-complete.
> 
> Suggested-by: Daniel Borkmann <daniel@iogearbox.net>
> Signed-off-by: Quentin Monnet <quentin@isovalent.com>

Acked-by: Yonghong Song <yhs@fb.com>
