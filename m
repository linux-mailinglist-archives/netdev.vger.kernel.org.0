Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EBE13EBEC0
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 01:27:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235718AbhHMX1z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 19:27:55 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:44308 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235330AbhHMX1y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 19:27:54 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17DNEgnt000531;
        Fri, 13 Aug 2021 16:27:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=nW/sljCTJTz52oZkslJtEtWB+p3fRfe1ux5I5HMSgbE=;
 b=gXz4MRf8labAlD2yU//bL12f0R9WsO6UrSYnj8Jre5mBDh0xaRjQia8Arz+I/sDMSKHZ
 xDcmI/eWKX1pUIhN4/sdYK46AACIDW+lsssyzEookQOJSq9jyicZ9t4wNprz4gPLnZmr
 TKI1LlKQRm8KKG6lkbR37Ljx+15xAyWq8do= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3adyxbgsba-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 13 Aug 2021 16:27:12 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 13 Aug 2021 16:27:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=miCV4HqQBKOuBaTTnruuLLd9SZEdzT8JPGdNOiyfeSEzpDmtczCaja0Y/mghBVn1fQmKbCVAZWRXpOuXGoiUbKg6HLDVF+sjMYXscx+W5nct7ZybiBF7+bB4GRV5tcfxKKDNhXWv5GgXWu4fWqy8zBqQQVlcknprHeQw2q+ju+lO41ojXloEPcxIijCagXSKm+L1dXLsFjRxYSsRXRoIhVXTt/NoOmx/67KipFbxYDrjAyVxqtY6rlauHbzKR7L/LM40PEJk33n5rrwgNHpVGbz8fQlwABIno5wXm8kAy4kCDV390/6R5mt0i7BpzvE0P63kCy0rE6LLd+Zg0+QgWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nW/sljCTJTz52oZkslJtEtWB+p3fRfe1ux5I5HMSgbE=;
 b=V91AFOAByCPUPU9Le6Ac9ujvyVEMDDc04/uh3TssqYPXvfeK3EUYvgdR3rVLtIvbFrBmjlFZ0oDR7ecxZjBXbBHvV8St6wmLdDLWSC62E6iEaH8lBfCYT1Vp9LM5jVDTY9lFWZYnO1EV2hUoNdljrTDvM3YXqsImLImSeNWwqywNa07uEPTB11cTtXrJmsWqHkZKQx0jq4Ja+iEDNACA0CwRe3pLfWD6mMhtbd3stIJCjpS8SSwpCECFgmWGc5DhxfqaOkUHXUXYYCsP/q9S4r35FAD3m21C7tvvjSB15hUz7VTd3N2bqHWxE6KXC5Bk2IUUP9lpsvZVySMl45kTEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SN6PR15MB2302.namprd15.prod.outlook.com (2603:10b6:805:19::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.15; Fri, 13 Aug
 2021 23:27:09 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::293f:b717:a8a9:a48f]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::293f:b717:a8a9:a48f%4]) with mapi id 15.20.4415.019; Fri, 13 Aug 2021
 23:27:09 +0000
Date:   Fri, 13 Aug 2021 16:27:07 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <andrii@kernel.org>
Subject: Re: [PATCH bpf-next v3 0/2] bpf: Allow bpf_get_netns_cookie in
 BPF_PROG_TYPE_CGROUP_SOCKOPT
Message-ID: <20210813232707.kk5l5ksirbgtr6pc@kafai-mbp>
References: <20210813230530.333779-1-sdf@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210813230530.333779-1-sdf@google.com>
X-ClientProxiedBy: SJ0PR13CA0148.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::33) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:e0ad) by SJ0PR13CA0148.namprd13.prod.outlook.com (2603:10b6:a03:2c6::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.9 via Frontend Transport; Fri, 13 Aug 2021 23:27:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 95beb225-fb08-40be-9a8d-08d95eb1df33
X-MS-TrafficTypeDiagnostic: SN6PR15MB2302:
X-Microsoft-Antispam-PRVS: <SN6PR15MB2302673322605EEB68394CFAD5FA9@SN6PR15MB2302.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Mt9AFTXD3330qlG78WN6hykE8jd2zX02dPGV9gjQmG6Z7AFRIAm2YkrxehHsIJsZusIt7Wy9qqz4XJCtZBMLt04HnXbyazT0VSYN+IZvUYUvd2O/47Bkybn1YHBEjwLgx7V6Nryv0fdTQuIgBE8vVFigNWM1Vctej4h+k1gdMJXYdSQvUcp2+I79TGN5G5TXatF4WBFtM8tzk9JJS/tzX2JdNcZSkPSB1sOuxPkO1iqixwH4ew1nIHKu3katvabLsr+YUGi4y3rsxIIPoCYw0mKsu8gLMPlGXr70wGsbrwYj9c9oD67c3p1+xJqxDqK2+dQHXQSW/q6+TO65wSuqQEVoKEoYSr0rilmdtoAY9sNcmN/MiJq/DEhAH/sEtIiOOifpHkoQYZQNfF8v8OGXUnsBNEy8u7zwgyRhMgg74bv3F9FjH4x2GTvmLsS6XDDykAlTWSAZFxJkIZMh/O92N+FYIJwql9lN/i9MHei2TtnpmMUS/tBFqD80Bii9tyuTo/iTnT252lUNVzzcAi1APrdHYTJ0DRMPSMVP01WPj362T5+rY4thMbIf4Lx3s5RTIPUaBdgWyqv+xFGYvww3nDXr+zJU9TBlx6OJfzxmZuhp50dx8wOM9THdWQTYhn7GnQEq/rCna8RJLuYy3gTHIg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(376002)(346002)(396003)(136003)(8936002)(52116002)(6496006)(6916009)(2906002)(4326008)(33716001)(8676002)(86362001)(83380400001)(316002)(38100700002)(5660300002)(1076003)(186003)(9686003)(478600001)(4744005)(66556008)(66946007)(55016002)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?83foHMVnKIgYBafx8v1fW63G/0mauk6slU3lFNOP8AMjr8QegfkNRwRY/qcQ?=
 =?us-ascii?Q?G4r+JvBZ8bUWf348KYBEICMpK5Vv6XAQukW1rwlHNlfg20GYdiGLANLo0447?=
 =?us-ascii?Q?dBWOBStY4xkOo+H8v6kfUkQ1RxZxaNypqB94GJNDUjeUjSvTT7F9clO4x2kL?=
 =?us-ascii?Q?+kWYKSqfjOd1vsu2s6MI04ngVNU/EmrAGjKOBP5sEzI9ZT/BsofNv5vDzfR7?=
 =?us-ascii?Q?NigHUicz+YDka+dpQzdy8cX28v8ZIf7werffWIh3aYMD6VzhP/ZPAE254HYX?=
 =?us-ascii?Q?fVSitpA2ZDO8wD1Tef6eyUKX1jnMqQgEG5Pz6k+xdWNTb7HIa2fw92OtXMfE?=
 =?us-ascii?Q?a5QrUAUcvisuG/hletf9vM0jwUwy02bRwBsBdlQVtxu3tNmiheZbC+2oM//g?=
 =?us-ascii?Q?hCR4Jq2sD6itfii/VLdfqMXsxkeVEclYxImdrqeAR217iedDHtnXycdaG520?=
 =?us-ascii?Q?YiWZOhWhFUrpLEkoz4vAzBTgmkIoRDRgo8CJJQuDq+9yPaW755IxBwMRGRTo?=
 =?us-ascii?Q?2aGt+hR8Siy3Bn9SatYDbNbyr7HDFZ70oNtXRJlQlYUop3EONkLCrlGDYpUw?=
 =?us-ascii?Q?c5OEKB5Io5uv9vI06DeZPffvqkc32PzclUmr6nS0vrBiBOUQkgG6M8rUiCVY?=
 =?us-ascii?Q?YJzyTBYhpa9LKH71nnZHjiJXN5bNOJxHZb9EAdxJTOXnRKvD4e22pBVLIyJE?=
 =?us-ascii?Q?U3tJW5nZRyEWecf84BWWJjcGJO5fOH7PZGtsuOMo0rRgBB78o3VBUSI0/Wza?=
 =?us-ascii?Q?y1aMXzUfFMy8/KW4AJlvzt4JBgO8Zx+E3B0PPplZb1vfkTbC3bm9u+hT6uvv?=
 =?us-ascii?Q?WNuNCf+WQVK4S8c6YisfWljgIQRFpMdkOKKfwN8N2jtUHswJV9JNLRkr8HSF?=
 =?us-ascii?Q?TXZTiAT3QH1Q+8NhefcoctOZpM8l/3d9TOd5gSfCzAVjDwnn/R8USsCVtwlC?=
 =?us-ascii?Q?vNU0D4cLCTQAVuXswHx+MLo/yLaWJ0SqhP4AOCd79SRWAyvFJMJuoWXeEyh1?=
 =?us-ascii?Q?5K3vMTmpYtTj1M10E2fmPC9jGCSphf1vaUh97PhWJpHLo0OtgMKBx3OeY6Dw?=
 =?us-ascii?Q?PpfYGRZD9IR4KczM4HxdwFDLN2jhyi+aLHMcOzvSY0hFhOk/Xh2DSrsSp81H?=
 =?us-ascii?Q?SuTJE0bCWe65f+vT4SM4mUnO+qwajhmJJOWZbVoMo9FWs1+uw7abwsE8KK82?=
 =?us-ascii?Q?pIXpZNbUyz06nNhy7VjRbbI+6mXXX08Ao8YEBOI54F6C2KwTzFLjdZRWxr20?=
 =?us-ascii?Q?Oe4ZfZ8HHC/P4rL/Ictm57V5TC2wHoOYTt1Zav7Joa4nUTs6fIY+rffpbpMg?=
 =?us-ascii?Q?+MleJ+Cel/GkYtg0vEVoEmv5eYTJgrS3OM9D0PBI9vSSaA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 95beb225-fb08-40be-9a8d-08d95eb1df33
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2021 23:27:09.7166
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A4J5/ikN61i0woXokqaPVmhW3YP5gLW6DUvRW+1ypbobHLbTMaCbr4pUQ2bh4FOO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR15MB2302
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: yHeNZJzEi4HFTvW-0rn0uiXl-M3uOmnm
X-Proofpoint-GUID: yHeNZJzEi4HFTvW-0rn0uiXl-M3uOmnm
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-13_09:2021-08-13,2021-08-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=484
 clxscore=1015 impostorscore=0 priorityscore=1501 bulkscore=0
 suspectscore=0 phishscore=0 malwarescore=0 mlxscore=0 lowpriorityscore=0
 adultscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108130138
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 13, 2021 at 04:05:28PM -0700, Stanislav Fomichev wrote:
> We'd like to be able to identify netns from setsockopt hooks
> to be able to do the enforcement of some options only in the
> "initial" netns (to give users the ability to create clear/isolated
> sandboxes if needed without any enforcement by doing unshare(net)).
> 
> v3:
> - remove extra 'ctx->skb == NULL' check (Martin KaFai Lau)
> - rework test to make sure the helper is really called, not just
>   verified
Acked-by: Martin KaFai Lau <kafai@fb.com>
