Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC78439885D
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 13:27:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232068AbhFBL32 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 07:29:28 -0400
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:3418 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232527AbhFBL2v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 07:28:51 -0400
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 152BKevg011143;
        Wed, 2 Jun 2021 04:26:16 -0700
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2175.outbound.protection.outlook.com [104.47.73.175])
        by mx0a-0064b401.pphosted.com with ESMTP id 38ww8v8byp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Jun 2021 04:26:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X6KIgxwj2M9/FXhCK7EJonlZF1WFafcHWRIUfzklpSgw/vSHSwphXWO8Zame4CnMN207XG/0u7Aj83w7XDasU8OMKFZ7ZUOBkojQK4zMlg34XjUUFW9FZbqTq2E6Ov7FnrzP+e75eOuW+dwqHmpLyC+AzqtLt+0lIkcyQQY+UnAdr4gfcOn1Tj3lH/6TfGMmdLVg5hkxbrIEpI9sBchuO0l/UKOqyBaCQ2bA8MUAS58JaPXySjvXQMOL3qS7szHB9uIDpC9kBnz05n5uj7okv8SUqK2p58HIcQqxoOOxIOo69hCKSE5saEYDoia+xIzxqGhNi8yfnslgImR0rx5YFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UQ4To3v4UW0NyhcVR+1mvWNqXPVPvwx0m4AhbmB+GUE=;
 b=k+fSzqSu9KyCPgehrm1EzlcCb7Y2Io8Rzbyd+0iTVJeHvtRQF9Pjaf2vFvhRpvbDDNcZFSf60xGxi8yzxPY8/ODPhhzSvbc4pkPxMW9Jc5sSr7uhmIjEeyewFB36whQNvUqn17l9mJfXv94D4DvTi230h5FEjPvnJ+TI+AUTFo7i8U3oik5pFLRf1uiXNK89oJeuANivTy3Ff1Ol3SkhuilRYZYU7AF4RmWRg+HQSe8aZ2B/BYnFLGz/5KC2w9hW5aywR8QLmDLCO1CWvIMa6O4PvuoUQM6culEs6wCXcMKUamZZv57ep7uyr+JA0GDZHw+JGhFryCzP5mQur18nKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UQ4To3v4UW0NyhcVR+1mvWNqXPVPvwx0m4AhbmB+GUE=;
 b=RnnPVw4OXI/TfPUk1pOrkTgTrMK4MF5cA+8XK8rUv2rXnz3Xr2jrFjyisTfjqN5EEx/gkRSIIae9GPeaAvYGJWEwryxgxN3K+lYPbm8vCfQq1UHuTilu3wVVpmfnIPcA5WigPPdRXtr9y0x7IfU+5br9aWrVkSgGnjUexVjpbPQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from BY5PR11MB4241.namprd11.prod.outlook.com (2603:10b6:a03:1ca::13)
 by BY5PR11MB4103.namprd11.prod.outlook.com (2603:10b6:a03:18c::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.21; Wed, 2 Jun
 2021 11:26:13 +0000
Received: from BY5PR11MB4241.namprd11.prod.outlook.com
 ([fe80::34b3:17c2:b1ad:286c]) by BY5PR11MB4241.namprd11.prod.outlook.com
 ([fe80::34b3:17c2:b1ad:286c%5]) with mapi id 15.20.4173.030; Wed, 2 Jun 2021
 11:26:13 +0000
Subject: Re: [PATCH 1/1] bpf: avoid unnecessary IPI in bpf_flush_icache
To:     Will Deacon <will@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     ast@kernel.org, zlim.lnx@gmail.com, catalin.marinas@arm.com,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20210601150625.37419-1-yanfei.xu@windriver.com>
 <20210601150625.37419-2-yanfei.xu@windriver.com>
 <56cc1e25-25c3-a3da-64e3-8a1c539d685b@iogearbox.net>
 <20210601174114.GA29130@willie-the-truck>
From:   "Xu, Yanfei" <yanfei.xu@windriver.com>
Message-ID: <7637dcdf-12b4-2861-3c76-f8a8e240a05e@windriver.com>
Date:   Wed, 2 Jun 2021 19:26:03 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20210601174114.GA29130@willie-the-truck>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [60.247.85.82]
X-ClientProxiedBy: HK0PR01CA0056.apcprd01.prod.exchangelabs.com
 (2603:1096:203:a6::20) To BY5PR11MB4241.namprd11.prod.outlook.com
 (2603:10b6:a03:1ca::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [128.224.162.160] (60.247.85.82) by HK0PR01CA0056.apcprd01.prod.exchangelabs.com (2603:1096:203:a6::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Wed, 2 Jun 2021 11:26:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ffc924ff-b4c4-44d6-7d8b-08d925b93abc
X-MS-TrafficTypeDiagnostic: BY5PR11MB4103:
X-Microsoft-Antispam-PRVS: <BY5PR11MB41037B527E472ABDDDE999F2E43D9@BY5PR11MB4103.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bvWMZY+UTghlY+QNk9fX9N2DGVcswfTcAzbTXnl6eC6+FhGbqkoluuy9LVFm7OkEEiW2P/6/8f6k0sxpY262mx12EtvwoFWkgs+2RkXiuLsKyBsXBvDilz/xutMXKrTafBcaJlkbOSYb7k/wwL+5DMs70HAmZfDqeTYcZPwamL9JQOLzMLbjsZts5kP9PXTgVk8nEBkeQY0VOV5UHWDY0EDByVDMem7pbzmPSjrI0l1X8mAOFwz0AoHpAEtVxCVyPODM4/iSBeoQEbFZAQl7SDHtPHFAIuQlxAjRM9ZgjmZnQ5PvmUW3EnsugkDXRhDA3U9WkKlkS/6lXjdk9oT9GJQ0LK9URlyKw4lxvey0EPXsVRGkvOlcZprNjhUAQvVSfqw5DtsWffutB9OAE9vSZvxtenBT18lUxrEowa+WILYe6VQbmcyj9Ole0C1oB4c6OGqJEDiOtFgz3DLQBAu1lZzq1CAxNigDvBRYSf/7cE1k9Sr8hpitZs38ZhBvJhaHAPfiPO/jc6eRRHjqRvVJ+tVTffphOjX8RYG1/azcSS9xtfLiw1kmoPPafrrvIMaPLjRDwrnvV4+845Rc+dcC8k96JNRVROWIaFwbC/pFOzS0WPmIWjFIi42jrIwqDQGHuWcO1IwpP/qJTXkKJ1WscXfPoBwzJtq+pGowCZ90bZ8j+4Gz6773CSAQVZKDPzKk/wqX6iZWCdYewTuMs5D2gA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4241.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(136003)(366004)(39850400004)(346002)(38100700002)(31696002)(38350700002)(4744005)(2906002)(66556008)(66476007)(31686004)(6706004)(6486002)(186003)(86362001)(36756003)(7416002)(16526019)(16576012)(6666004)(4326008)(8676002)(110136005)(5660300002)(8936002)(52116002)(956004)(2616005)(26005)(66946007)(478600001)(316002)(53546011)(78286007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?K1NIZm40d09LREMvVkJRYjFaMXZwdGVnenNGVnlETDhEa0VhUTArQ05MTTNv?=
 =?utf-8?B?SEswUkNRa01nWHBHblgyTmlNdk1GRWtyQzhMTkx1TTNMdHhKclhUeEZ0Njlq?=
 =?utf-8?B?cEx4a3NxbTh2SEtMWnVSSld6UThvL2NMaWUzYVpKZTdUNnd5cmFzVjF1L3dM?=
 =?utf-8?B?U2t3NDlybWwrTjF2aDgzQzduVEEwN2thWXpTUzAvNlFPVjJsWXJTVTE2TjU5?=
 =?utf-8?B?bTc0T0pSek0wRE5DQnlPQ1dJOVF3SWQvT0szekRUQ2krK2wySnRaaTMvcFVM?=
 =?utf-8?B?dHBXbjRIOXhHTHlGUzFMMkYrcXJGYVJ6OEhRUFdmUGpWRjZOWUtaUEkySUZD?=
 =?utf-8?B?bFBVeHZXMmFvRkhGVk94VFdEMSt5SkRDRzdMMUpxZEtXNnZCaENSM3NWbWs4?=
 =?utf-8?B?ZzF0RDcrZ3N6YURwN09YVXBYM2l2dXpod3JGeGoxTjVMK2lKTEVWUHhoTGFQ?=
 =?utf-8?B?LzdxeVN3b2g1UjE0WGl2K2xmNzRObTZQYVpuSG1OcWJMZnNqb0NHUHh6a0Zl?=
 =?utf-8?B?azh2V24xd1ArQktnNkJlNlF5NG93bVVOZDV2R09YbXFsdktKYlBYL3hGdWVa?=
 =?utf-8?B?RTVQWVpmcVErcnhhckY5UVdMaldGSkt2RUNQNmM3ZWFmS2dtZXMzYVg0YzdT?=
 =?utf-8?B?Tm9Da1JsTE9Kc1d3VkU3Uk1BMEwybkVMSFQ2RkZmZTRKUTFOY0FMZU5HTTJX?=
 =?utf-8?B?NjNSSml5SGJvQSt2ckdDTFFFMXhKTk95TVkwa3prQlBGK2FoU2d5WEFiUDJw?=
 =?utf-8?B?eVBNWHpzbVVQbHhVN0ZWTDNaL2g2alZSQzZGWE5TdTJkYS9jbG5lN20wMUtV?=
 =?utf-8?B?OXNsUFVlSkg4WW1ENWhNcHBDc3RCTHpqUGNlWko4cVYrcEdLcGJFTXJRd1dT?=
 =?utf-8?B?RzdXalBkZU9CdVNYSGhHcFBkYWhBRDk2MTZCc3VHOWNvcm5CK3JGcFhJTkkw?=
 =?utf-8?B?VlMvSFZYUUV1aUJBam9YVWV2V2NsWXhiVllaZEgxSkxTUzRGdWZUeGwrYW9p?=
 =?utf-8?B?OU1pUEtpN1pmQzJJRVVXWWJma3VkdnVzdDVKemFMTHpjUmp2Q0FSNmJpdEo2?=
 =?utf-8?B?bWQwN3kxbGJYTzluR3Z5Q3c0cXJHWnRja2NndUt1VFU2aGc2ZDhsTXUrVXd3?=
 =?utf-8?B?d0djREtSaW5nZUh3TDhtS0QrMFpLWjZ4b2FFRS82a2NEek5jVlZ3MGROUlBQ?=
 =?utf-8?B?MWgreDlFbWVJK0JrU1dvaVU5M1gybmxFTmlZekhPemtSZlRWNzNCbVN0U1JZ?=
 =?utf-8?B?ZGxLd2l4bk5mK0pxRUxtalhkdnhBMmJ6emFIRFRGZ1FUY2p6ZDY3RXdSZk5y?=
 =?utf-8?B?OG1ya0swVnBhTnRReWZLanJRV1BBSHlYWE80ZUNiVFdRNmFaZU5KQi8yMkZ5?=
 =?utf-8?B?QVJnTzVqNTh4NVVpRzIxSGhTU29qei90M2N4SmZEMlRRYWFzSG1WMU9mUWhR?=
 =?utf-8?B?NjdkWjdBWGYvcmpVTWl2QXcwbVFvakRsR0ZuWnNrK1RRSTRDQS85QnpPYnhI?=
 =?utf-8?B?ajc3cTVYQ0xPUFBlRG4rL1RnNW1qdFJ5VG5CbStBMUkyWER5ODR5UmJlOWdZ?=
 =?utf-8?B?QWR3TVE2RkRyclRHN0owM1BFOHB4R2pBanJnd3dmMTBqLyt3NDN5N1lXb3lS?=
 =?utf-8?B?c3NBY3NONXFlK3o0dXE4QU03M001d1VYd3VzVXpsNlRvT1NVeTN6cFl5UXdy?=
 =?utf-8?B?amRrYjNGamFkMjhTaFR4R2Y3MENwZlV5Zy9aZHJHbks3dm1YVG5WZnpaUzZH?=
 =?utf-8?Q?bpNROBdbhEayxfdmhql4ondWv3K9Dl8brlaDhUR?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ffc924ff-b4c4-44d6-7d8b-08d925b93abc
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB4241.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 11:26:13.6583
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h7fUqaWXuarIqbXy6C3iiMBjCtx/No015pJOhx3oArfGQ67hmkfQ1+cDV7ltmA7PCTmLWUCfXmBO0Inwh7bnhg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4103
X-Proofpoint-GUID: URAxstFfMxT3UrD2nhLmQdkXXofw8kHy
X-Proofpoint-ORIG-GUID: URAxstFfMxT3UrD2nhLmQdkXXofw8kHy
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-02_06:2021-06-02,2021-06-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 bulkscore=0 lowpriorityscore=0
 spamscore=0 impostorscore=0 adultscore=0 priorityscore=1501 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106020072
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/2/21 1:41 AM, Will Deacon wrote:
> [Please note: This e-mail is from an EXTERNAL e-mail address]
> 
> On Tue, Jun 01, 2021 at 07:20:04PM +0200, Daniel Borkmann wrote:
>> On 6/1/21 5:06 PM, Yanfei Xu wrote:
>>> It's no need to trigger IPI for keeping pipeline fresh in bpf case.
>>
>> This needs a more concrete explanation/analysis on "why it is safe" to do so
>> rather than just saying that it is not needed.
> 
> Agreed. You need to show how the executing thread ends up going through a
> context synchronizing operation before jumping to the generated code if
> the IPI here is removed.

This patch came out with I looked through ftrace codes. Ftrace modify
the text code and don't send IPI in aarch64_insn_patch_text_nosync(). I
mistakenly thought the bpf is same with ftrace.

But now I'm still not sure why the ftrace don't need the IPI to go
through context synchronizing, maybe the worst situation is omit a
tracing event?

Thanks,
Yanfei

> 
> Will
> 
