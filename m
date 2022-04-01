Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AC404EE643
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 04:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244265AbiDACvZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 22:51:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242572AbiDACvY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 22:51:24 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC10E22B0A;
        Thu, 31 Mar 2022 19:49:35 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22VNFqb1007713;
        Thu, 31 Mar 2022 19:49:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=fXs/sNH6Nz8VNLF4DioBwGDDaKbO/cCj+oFHMqPMEYQ=;
 b=ddPTg6kmhocZwFPDc59uCEQM/CosbNI7VdsyVxAXLZWKyoAIjYh0S6KTt/0WL0hQEFrp
 /V4dDisShmJDWedwm/ARH7zkC30imLcFKuhaw1T8xfucBYv1caGmpMJZfdIVl7p96LFI
 YYmQknzJiEIxR1gSpsUDv+8ZK2Z+UWXcVxA= 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3f5gpcujgd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 31 Mar 2022 19:49:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cV+JkGIzWF9AGpx+M6WgLwAy0SVrlanjgjbbu546Z0UuzCy+zvs2ArpOLH7jotGBqMcswpVJea8nDc4PecXg99St/TMSeMc5v7ldJNyF6vvmbnXvoykh+apeDUh35rTqVn3jOxSdlwgPZvT1t+DrjgMdYQonWInFkdCboDuETrpeDC60tc07p6DQArbJE3iVeQV/Bd9wijxfV8l+RHxwHpyLhCx0JuDcwUhUCI93wC366n/Axav2MBSor5gU1FkL5/R0TWhWTXLpT92iMEqsHfgDunHzTDtVaCPd5TEN0z4LFkjLayVbakxnd/TdVfktIWmi4UfUMI2JDY9W+dDFeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fXs/sNH6Nz8VNLF4DioBwGDDaKbO/cCj+oFHMqPMEYQ=;
 b=XYPpqIrfxKJCCbKbiPMVQOYpWjiQCmq/tuqAspEPfnMNt4N9bWva38xq7ZmpP097QxS4gxHfQZt9piBe1ugoZ0CXusHXAk2+eUdSpfF9BDe77EGnA51lOfbNx1tq4Bly1AOlI2pLHRS4fV1I8/StXAuwX/x70gCZtaQV9Zp00o7awYKz/jgLiEbX0q+0excBw8R12HsQPPTA9GFMJy3IcoCUwDOXpdgUJBxrYPtlOF9eF2G20pYeSKjI5yn541hmAXU4U5dYRQ7rP6kJv0giwSIPQKVbMnO/5E1x3JBK3FPFjSjptEHJPw0SI2/A3uyL2ljXN0fdMQsBB8hF8yZ70w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by BYAPR15MB2759.namprd15.prod.outlook.com (2603:10b6:a03:151::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.25; Fri, 1 Apr
 2022 02:49:15 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::4da5:c3b4:371e:28c2]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::4da5:c3b4:371e:28c2%7]) with mapi id 15.20.5123.021; Fri, 1 Apr 2022
 02:49:15 +0000
Message-ID: <854c30e3-1dc6-fc8c-caee-d4dfffb79c4b@fb.com>
Date:   Thu, 31 Mar 2022 19:49:09 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH] selftests/bpf: Return true/false (not 1/0) from bool
 functions
Content-Language: en-US
To:     Haowen Bai <baihaowen@meizu.com>, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>
Cc:     linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1648779354-14700-1-git-send-email-baihaowen@meizu.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <1648779354-14700-1-git-send-email-baihaowen@meizu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0P220CA0016.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::23) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a2db47df-51c7-44b5-1acf-08da138a3568
X-MS-TrafficTypeDiagnostic: BYAPR15MB2759:EE_
X-Microsoft-Antispam-PRVS: <BYAPR15MB27592F367308A2EF17AA185BD3E09@BYAPR15MB2759.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3jJja1u4ntpSv4aTL5teYlzOms/slHB4LAUomwI2lt11x1/WgtbLdOwwjKwG7p/0iuvPf0zWKMg+LZc+l8xcmYZM8dwxlLYUwUToEKNtpmgGVp/AC3fgjQZCfw1X8HPn8cl/45UOfQgtiZ6wo5MJoqteEfgRzRaI1OOKmIAnDj7mBH+YiKb4ZY82HsqvoZgRTOLu0ELjqRhBJn4A5tN1ZtglNMpwOhSLvirwZLslXWBWRMg37zBjF3WKpfPB5qKo+mINY/fHnJhALJOKoXiGi9UUtDkutZZ5VYFE8x8hFzO+MmCsAlbgaTuxxn2xNMZICwR8rykkKeCU009tB4ArOK6V75CNreCspbEdO32lt/OF2an2yWk3WNwdn8QbHzx97HOP2WByobR2lDHwo9H3wgOxCN1YasGxjloN5jVfLHv/wNDHVwt46uYN3rk2esYDszHA9K8Hei4oFnrdmEurv9gnnWV1wwWbrxlrlwJF2CCa2FisWmFaD94CUKcbnCjLmTc3gALjuJeMUh1pj2ONW6ilAuSgEoeFoIiS3bgYRfyL85R5gblZD7sd9uRBo04biwpHYkKghf6Ddqw981ePvwzowHIRxRbv0vZK1BzQK3g+HN1ZkVxOiCZdZRT9ZJP4rGQtwYNTg0J0cqB9Wbx9B8Gja9QPxV1gRhi0DYh7S+Dfwoj+too9GMDLrqNLGj/AWWm7fTvy36TowDU5+elLdnKmfpBqUYK9UAtixlzg9395tvgbzQj3IGYPvH7/iv+D
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(52116002)(66556008)(66946007)(53546011)(5660300002)(921005)(66476007)(4744005)(31686004)(7416002)(2906002)(38100700002)(36756003)(2616005)(186003)(8676002)(4326008)(110136005)(6486002)(508600001)(31696002)(83380400001)(6506007)(8936002)(6666004)(6512007)(86362001)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?anNWRUhHTFNIRG00NWpiU2xPYWc3SS81aXU5ODQrL2tYeDd3WWU5N2dyalpv?=
 =?utf-8?B?akJSMTlNM3B3cDExUUkxcE11aXJxWVgyWWVGMW9yWXl2RStxRC9mUVRYUUM2?=
 =?utf-8?B?dXVidU9maS9ZN3JOTXN5ZkhHYWpIOXMvWCs1TzhHUkFNelpQMlhDeG5oaVNB?=
 =?utf-8?B?S1Z1OXdpY2trUVFjeDVITXR3dEcxb1FXbWlPK1FvL3pzZmYxVTBNK0lNM0s0?=
 =?utf-8?B?cUdBZE9wUkE0OHp4U2NZY0ZFNUxlcmRjbWZ3aDZLMXkwZmcrZDdOR1Y4VGY2?=
 =?utf-8?B?cWhMK3A1YWlpQTVLSjVlRkFFYXhNV3FMOTk0RUE2V1dGbk1EY2FGMzE2T3Nz?=
 =?utf-8?B?dTZIcHRNSVpYK3lET0FoNHdpQlovcWhZa2FOMXhoUUVDRjVvbEh5M3dBUXNB?=
 =?utf-8?B?eTUwdllOREIzTFZKUml4UGI0ZlJMdHI1Mm8wYTE4VjNMa1RmcXVOT3Exc2Ra?=
 =?utf-8?B?ZEE5NU50a1U0eFc4YS9ZYVRjSTRkYi9uWDd6V1djZ2pTc1VzRThIMVdvU2Fk?=
 =?utf-8?B?U2FKOHcrSEdqVUpIWmx5b05OMFVrdFhQU2JJSFEwazdwc05rSDZBUzEyRkJi?=
 =?utf-8?B?dDgxY0lsQmg1Q3ZwdXVRSjEzSVp0OTV4Y1J5UkFPQlQzWmlYcjdYTFhYYzZH?=
 =?utf-8?B?c0ZGRzZkZ1dxbFl3a09WdStvWkdCWEFzS3dmWWlQWkd2a2ZyRVZoYSs5Tkl5?=
 =?utf-8?B?ekFXdC9relNMTHVlZkFUdGx6SVBtZks4RFRvRS81aUxGYk5pZDIyV2gyNUhn?=
 =?utf-8?B?Wk9hdTY2ZzRHc0hFOU0rUG01OVlXQmdqWUE3cFgvM2JuWU1YQlNjdHMzdTlB?=
 =?utf-8?B?UndOU0lXdmhaWTlvS0xpWTZET3VaS05wQWoxT00wNU9hVmZPNlBaR2Rjemlk?=
 =?utf-8?B?WndOYmMya2FiM2ZMNWdxSFl3Ny9Ma3gxSzJqbFpOdmtOOHhWUkMreTl1emdJ?=
 =?utf-8?B?ZUF2REtiNzJoQ3plYTBMUER2Ni8zMldhOW9TNmFseHA2U2duRUxIZ2M2bDE3?=
 =?utf-8?B?REdJbm0wQVZzS0x2UjNFS2FUeHFYTHZSWWE4cEpnc2tmdDlhUTNqQ3NsbVhC?=
 =?utf-8?B?bVRZNzVPL3NIUE5sZjlvc1VCSVZGS3J1Q3VaZ3o4dUlUQ3VYQi9wdkNhMEJB?=
 =?utf-8?B?b2RXUUlHRlRxZHJXQ3FoV0FCWGZLYVV0QkQ1S3FpQkRLNzhFRXFVNGtvc29l?=
 =?utf-8?B?Szd3TGpRS2pxazZKYVprOEQwZlM4K0lnMkp2bnNWOFI1MHZZSGxkTjRLQUd4?=
 =?utf-8?B?QnV4blVldmVJeXJlTGc4aEYvdllXdnlqemxSV1BZaUV0N3VQUnBXTmZWVjlL?=
 =?utf-8?B?ZGY3c1FNMHFOa0NaempRYjZrU2xWZHZ6eUVXTGxVb0F5WWY1VzljTXdJUmJI?=
 =?utf-8?B?dFl3dHM3N3pxZEpLRllKQlE4bks5K1pCUDBtb0c0bDQ0NGJRYVUwL2xFTUVF?=
 =?utf-8?B?dWhBQ1pIRUwwZEJXUzBweUlUVnJtNnUwVm43ZEROL1dQY3FWRGNoUnozaFJO?=
 =?utf-8?B?NzN6a2dJSXR4WCtWR2xtQ29PM2pqbENHQzRhYTVmRlAvRE5Oekl5SkZOMnQz?=
 =?utf-8?B?azlnNm8zWVF6YVZ2OVhtTUhPazIvYUFiY2x2SmJ3bjNXeEVQemhDdC9ydkVU?=
 =?utf-8?B?UHRMa1ZHdDRrV0xSVi93N25PVnl3VUN5RlRBRkdiU3IwbE9uQkhJanVDQ1RJ?=
 =?utf-8?B?UytxMmJxWUZUbU85YUZyVGpOZzQ4SWtlL2l3VmwzT2t5U01lVDV6azA4R0FB?=
 =?utf-8?B?TG96b2poazNWOUpyK0VRODJWbndTMkZpQmNvRS8xTjlaUGJ5Y3J5bFV4Mmhv?=
 =?utf-8?B?a1Z3d3A4MmJXQ2xCY0hRUVJQZ1pyYzYrMGJoS3dwSTljdjVTTzl5Z1Uwd0JK?=
 =?utf-8?B?WjBuemlieE1IWTA3aUpiU0pJS0NJbHpWNnJ4dWx1dVhuRmxUcGUyOVpGYTVU?=
 =?utf-8?B?VGZTSU4zUzh4WC9pOTFKenlZK3ZkTm9vK2N5L1Z0Y1ZncUtpWGNudGZiTUJ3?=
 =?utf-8?B?R25tMjRWVlV2RzlJckRiL3JwYStrRG5ITU5IdnA4YTRMdStVdHgyczM1c2ZX?=
 =?utf-8?B?eVRvdjVrUE5YaExoazA4S3NzR0ZWalE3MHdRWjltWHduWnhUdFo1RDZXWUxy?=
 =?utf-8?B?Y3FJYVFkS01RNEIzeTVndWJSWkgrNlp5d2Y3b1FUYzl3STFZTFkrK3k3enVu?=
 =?utf-8?B?UzB1TmhJbng4ckUwRFV6N3NscE9Pckw1KzgrdVFDYkNwQUJjdk43QmFvSnFt?=
 =?utf-8?B?eG11TE9HV1BROEdxVTlVRGg0amJSUXY5enRZRUp4SlVYdTZVTEc1OTJ4YlY3?=
 =?utf-8?B?TEtzWktaMzVpS2drbnNxNVFsMStwQW5FQ3hkZldZaDdCejFzTkRuVTQwSC9j?=
 =?utf-8?Q?UDG/ULarXxmI7k8E=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2db47df-51c7-44b5-1acf-08da138a3568
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2022 02:49:15.0338
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: owYR62Zy/JQ423uyCQ2ClTeMnek05t5C0/GrKmbWgchiz8qmwDUd5K4CRuu+50Al
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2759
X-Proofpoint-ORIG-GUID: YM1bE6Czf169Evg8n4k2u0AbqX8AykfC
X-Proofpoint-GUID: YM1bE6Czf169Evg8n4k2u0AbqX8AykfC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-31_06,2022-03-31_01,2022-02-23_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/31/22 7:15 PM, Haowen Bai wrote:
> Return boolean values ("true" or "false") instead of 1 or 0 from bool
> functions.  This fixes the following warnings from coccicheck:
> 
> ./tools/testing/selftests/bpf/progs/test_xdp_noinline.c:567:9-10: WARNING:
> return of 0/1 in function 'get_packet_dst' with return type bool
> ./tools/testing/selftests/bpf/progs/test_l4lb_noinline.c:221:9-10: WARNING:
> return of 0/1 in function 'get_packet_dst' with return type bool
> 
> Signed-off-by: Haowen Bai <baihaowen@meizu.com>

Acked-by: Yonghong Song <yhs@fb.com>
