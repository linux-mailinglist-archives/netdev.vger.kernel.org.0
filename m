Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEEAA3694F9
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 16:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242722AbhDWOmo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 10:42:44 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:1838 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231604AbhDWOmn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 10:42:43 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13NEW52p011679;
        Fri, 23 Apr 2021 07:41:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=g4Z4iyQyc/klZqUUgg6LIYHN218oYy+RJHaDZb9Gt1s=;
 b=W1cPja0Zb5Dcztxc7aFRRA5IiSyxdEefTTGehVJfFnMIlUw962UUuZZbg7yAHGtlrHwz
 kAyEGywqzkBP8yENMb4R3fXpXbXNxFAjcdU7WIwkJkNNc+CUyvnYDBPvXki84STVYGkk
 We5SlI7efVTbxUW5lMJ5vZWkuM8UKCM3osg= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3831kj1g6p-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 23 Apr 2021 07:41:37 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 23 Apr 2021 07:41:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mEiJfhCoLLiPBiA6oLJtraiPBlvE2OxoWJhpUNAwoidrz31ANMBIkWYVq1ulygGL8cPo8IKH6AhHfIpAPpWSE3MRaWDLIJuA636P6gGJ9A7Y1i8lbmy3ERBQ/fqQ83tzR/r0lPak0qLWrovbit5Qs52WXLKG7iUIst6PkzTjuKb/s7N96420PgPwDqarRXMGBKFQZNHAWJBHWizfZKU0Ab3dX921lw7i89rEpwfaj/zshkmps5+UDbguBIUx6fvr2XZPDcPj6+I5WghMNC3oEJMixk9DmWG/93woXSeMuhzgDIvmMMApOLad2O7fPSzT7Gh7kDgFN4nzscKZLfcggg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mK3K01bN0KegTRpFyxGLZMZWNmjfOG/iBno9wUlTRtA=;
 b=StmQ95Gd5AFpSdyZBMDnruIFMyCnPLtrpC8c/OcyS/hswIm+GcYlS3dHR7Eyv3Sxsl17lzROIvY2rtBkJGN5p5nU2BraTeKESp7NT6r4E4f3/RCACVowXvcTuDrGnkOanuawVnv2JaNio0BDRruUswl8yoeCfhvN1r9gTF/5VNtf8G25btmSAxRZmL2inXBMvWowPASVW1tzor/+q5Fx7bu/zAeENt+2irw/V54jdUlNne8BFrplcJJYtJ7mkNvorp9IJZSh41+WprJ85lhmGPVec/oSsM2oal8rEDgrnqIiNsu4i4zR7Y+C25RJ6TsEZKkyprpeZUUmxBe78AljeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SN7PR15MB4222.namprd15.prod.outlook.com (2603:10b6:806:101::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.22; Fri, 23 Apr
 2021 14:41:33 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912%3]) with mapi id 15.20.4065.025; Fri, 23 Apr 2021
 14:41:33 +0000
Subject: Re: linux-next failing build due to missing cubictcp_state symbol
To:     =?UTF-8?Q?Michal_Such=c3=a1nek?= <msuchanek@suse.de>,
        <linux-kernel@vger.kernel.org>
CC:     Martin KaFai Lau <kafai@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
References: <20210423130530.GA6564@kitsune.suse.cz>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <316e86f9-35cc-36b0-1594-00a09631c736@fb.com>
Date:   Fri, 23 Apr 2021 07:41:29 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
In-Reply-To: <20210423130530.GA6564@kitsune.suse.cz>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [2620:10d:c090:400::5:bc07]
X-ClientProxiedBy: MWHPR03CA0008.namprd03.prod.outlook.com
 (2603:10b6:300:117::18) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e8::17f2] (2620:10d:c090:400::5:bc07) by MWHPR03CA0008.namprd03.prod.outlook.com (2603:10b6:300:117::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Fri, 23 Apr 2021 14:41:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 14616bdc-dec2-44b4-537a-08d90665e3b0
X-MS-TrafficTypeDiagnostic: SN7PR15MB4222:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN7PR15MB4222E8C4E7425A560059AA51D3459@SN7PR15MB4222.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:370;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Lg1lmLhdEHer4tfwe8CTpAE0LmlPdxyFrjuLVr3NHqInQtQiWGk5qaE0Dz7XlW1NA+Rds6ZNPHQej+tQlRowJ37kXLBZKAJTrbT3aUifCEJZEjI4i2Vqqb0xkxsAkl5itpsfeZf0X9qMRXF/qJ61kNvmwJYnMna3sJZUXRU+d2C+iWznlUiaVmaZVFysV64UPKkVWX2QLbVsm3u/nUkmrQ6zSnqvFlee+zKcAex9GchSLFJvPnClmNapFr2QZYfZldVDMZRoI7OoF+nh9/bHiNbKixQlZncXFl38bj03rXYF4oRkDn22jdmhSg/FpOBXa07iGmaFvP+jFKpCEmcvZOJQDCDW4xEDbhwS/P05SKnZ/1da2zEmuTBkatwyggueIUNMGvN5j1VO3hDyFqEQY5iGQivqqpw55EoxjB031LVyKEnu5ziNikg4ICyCWM4XW+mYam5zP75UUxJh2hXA5AXjiwA5fI0p0hHL76Jv4y8XoxiKFWDN0JcEfW/P6IrHeeaSIV8YQ4SRvzp6JhinMp+gzq8fEZeLQSwWJ5aE0M+rT6OlhL0C7wL//DYiysns4SzBkmAJIXZzHXGOFcq8x7cMXb+6MpqfmK+tHWyR9CyJs1LwIvmVSJ1b9+JISjw5MMk/naCPpFaRQPyQ+A4aAYW8hEOSxoNBTeyeWnjnCxKHMXCzT6UBLAOfSkN78i9b
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(39860400002)(366004)(136003)(346002)(8936002)(54906003)(478600001)(38100700002)(52116002)(66946007)(66556008)(66476007)(8676002)(36756003)(186003)(31696002)(16526019)(6486002)(5660300002)(316002)(83380400001)(31686004)(53546011)(4744005)(7416002)(2616005)(86362001)(4326008)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?Windows-1252?Q?ZZpp5MrKH7WUACx9tqc4nylfzkkQg9ExZroqVPJsiY6pIBJ+rXPVvi5G?=
 =?Windows-1252?Q?eNYOf8WfQfKw/b5Vi+oyPOhr8L6wVCJgZ6SMrL+trSO+V9ukSvVqiVlq?=
 =?Windows-1252?Q?vmwbFz2AxtLVFKg2JNruXw8IQNKci3f+LZp5+5uOgbDtTqm1UAMPIwlO?=
 =?Windows-1252?Q?rwOl7At15sGdn03bWY4flgel9sOcbdJmkMoetEsq4awV1ofVBN3IjgEr?=
 =?Windows-1252?Q?YHGLuBb2YNZ0HhM1MMOAfWWGERWfWBsj+8dC6DIvbW7Bz99eDQ/522NO?=
 =?Windows-1252?Q?EuOE3vDLJ3EUn0vap2WFbK0xT0o66Q+W6pUexF8Bx/yABGjF+NSMLf+e?=
 =?Windows-1252?Q?I6LOzrQPBvxVFzcEqJdb7CX4CcoOfmWU8qPKhzmlbNzgglLaHVs6xWpF?=
 =?Windows-1252?Q?MRKe/ynvFjoFHfh/VFB0OcqmkWoYJ8Iaytn+xxdxR/tZ0BUyRkP/Pam+?=
 =?Windows-1252?Q?miTsKan2qBH5hnbZyFZtC1ccsYS0BRg0L7qwwrYKpwY9dv+v/3bpMBmY?=
 =?Windows-1252?Q?wo1oUnNcrXd+azY0jyX2oZd7laoc3Kgp5HywJxUNjfDQJpt7LyidOTP+?=
 =?Windows-1252?Q?jOiYwtEH6idyIW5MEkU0besLepCmFA/APMjSNM7bj/+bOy38DJFRwCD8?=
 =?Windows-1252?Q?0wEOqb91FR0XXvxa+S/Q4y55iinOsOkSgnLeLUPCKOtqLr25kKCNeEtC?=
 =?Windows-1252?Q?VyG7GNYbFd83wKSO4Q9mYpDH0U+MMfDaNSoMCfupQc4tiuPHS82zda+B?=
 =?Windows-1252?Q?RvOjIECH//vT2fFfXTLBCT6yCEix75DA9yClmiioTqhIQDx70wrQg/qk?=
 =?Windows-1252?Q?Pee+AySLJzxFn/X7PdLHgpDYUnNcJO+tMnsPdk4LD1LMfaVs9UBuXEhr?=
 =?Windows-1252?Q?DFVa6QK1iOZi4BCIJ2Zv459iMYg1X9nz4628qKR2vmh0j7tK+KepTm9X?=
 =?Windows-1252?Q?eje6b7wZaXLGn2aX8WdeCT8DNDvnjeQe5wUPenbnqT1qfqYlO2bRQt8O?=
 =?Windows-1252?Q?QDBTrDS703igBQ0WkbJt0jcnsmr1+ktXznW/Uxwz0IwJDUTvPgiU+qlh?=
 =?Windows-1252?Q?OOdJtLDPYo61/IS8tkuaAEzDBkF1nW2Wl9ZbHk2j4DGDDdAb1FsVDI+g?=
 =?Windows-1252?Q?rzlIdcGeM/w0qNsgNgI7xw36nPs6Ci9LQiSI4/n10EhfxA5+J38ajNNx?=
 =?Windows-1252?Q?Ry5D0oQFTHTaR06lsDsgp/e+aJN51NtEYO6SAww4hTKqYVpqY14BSO6n?=
 =?Windows-1252?Q?qBVBofanaIU0cZgPs5T5zg8lCDNxn5gOjl5icyVIopy6dcNz4To1xi4z?=
 =?Windows-1252?Q?O68nH1SAMY5Sy2tnPWxl7On5rn6uZtq6fQHq3j0zSDpjlkvQzyrC0krW?=
 =?Windows-1252?Q?a49zglsPUw6lhV2KI2NrT/3qjjRodwqfL3oEhLBZFW11nFUiKeWdXFMC?=
 =?Windows-1252?Q?ZvmN+BzPYM1a/4nMZn6NSC7QPv8980uwpiV8cOhcyJ8=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 14616bdc-dec2-44b4-537a-08d90665e3b0
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2021 14:41:33.4371
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1zmrgmgKP9tO58QP6KPftPyms0otD8jzsSDshvqqDcjje9+dswFq+VmJnfEBv3SW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR15MB4222
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: vNQo9Y3C6oKtZNYrkjBcZy1hWlutptNo
X-Proofpoint-GUID: vNQo9Y3C6oKtZNYrkjBcZy1hWlutptNo
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-23_07:2021-04-23,2021-04-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 phishscore=0 malwarescore=0 bulkscore=0 adultscore=0 clxscore=1011
 suspectscore=0 lowpriorityscore=0 impostorscore=0 mlxscore=0
 mlxlogscore=999 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104060000 definitions=main-2104230095
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/23/21 6:05 AM, Michal Suchánek wrote:
> Hello,
> 
> I see this build error in linux-next (config attached).
> 
> [ 4939s]   LD      vmlinux
> [ 4959s]   BTFIDS  vmlinux
> [ 4959s] FAILED unresolved symbol cubictcp_state
> [ 4960s] make[1]: ***
> [/home/abuild/rpmbuild/BUILD/kernel-vanilla-5.12~rc8.next.20210422/linux-5.12-rc8-next-20210422/Makefile:1277:
> vmlinux] Error 255
> [ 4960s] make: *** [../Makefile:222: __sub-make] Error 2

Looks like you have DYNAMIC_FTRACE config option enabled already.
Could you try a later version of pahole?
