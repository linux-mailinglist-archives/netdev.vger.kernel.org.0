Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FB5336B5FD
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 17:42:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234094AbhDZPnB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 11:43:01 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:55478 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233736AbhDZPnA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 11:43:00 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13QFdVFU002782;
        Mon, 26 Apr 2021 08:41:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=+2MiL/XW0fxvBmv0tosG61PqwG8MY1wF8p+T3wnEKRw=;
 b=mMCIomVrS9Mx+SmHnbKaks0DW0rVVmZZL7M/1DLrKNNcsD9gfn1hjZiHX4MwoAzI15bF
 zxNE2RrOeUD+YDD+sxgU+2coO73S6dWEL1ZXjb/5gsWQt9hjAlmG/WNrYwGSs9OEabwZ
 CRgHvqNYkFAwtjBAeQPb0vSSe3X9JTi1an0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 38531qx5t2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 26 Apr 2021 08:41:58 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 26 Apr 2021 08:41:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EoorbLepniH8VArik/DVfm5Fr1yNAj2L2Pw2NXl/j8e7y1uRln0AB9St5BQ/E3hRm73gq9CtllEHTC5PnRyLTppbe76i1e/l6rNSQXkfn6HpMqnJtF02V0KMyXwyS75M5JJXSXUKf+l2HLp6zBFgTfS5SMbPClazkn3xKTBQg105Nz0EfLyHJnmmzxPZ7vW1OvYxtA1AZMMCzlWTtQT/D8382V1UObJEzICoA9TaG0d246RK/trQ7yzgP2CN9/EAPBpXBgv5rI45wQBtrvjfPDC9EI9rUd0iX2Xr5GY/9tlj4vbACvQ84wpw0+kCb6lANfbtBpHRlIy6QPuk9P/n+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XJaxVBXudi6SUVZ+92kOvw3eeIKmfcRY7TGpscNb6fI=;
 b=junrhYpt7QTYb6MESyt+bNXl7/o6hslz+EoGbeOjxz2nbbPn9cb+4pZ9Gmc/xXzHoy+zZNKdf/Kjy3JNe2O9gj7haX4JboKuZqh8SWj4XigTdROr5CJJb6GdIGMNdjZfSTOHC2tsBUD9J91ZzECT8AMDfiNeCBsSmo4YSVCh0v83xVITTKSsC11KsqaRQkYLxn1XuMJj0a+4PIReFtQyeaBANokQKflRXLwshPVRQ2oe4hAndoexiiBubbbm5cYY8aPB4htsP+1uBT2N2nEffyEyBYnRV0MTn3dLpQlrYxKZwpJSghRumnAAN8I3ZT+S/pCUO8h+BtpqvKtqCRIzyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SN6PR1501MB1968.namprd15.prod.outlook.com (2603:10b6:805:e::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Mon, 26 Apr
 2021 15:41:55 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912%3]) with mapi id 15.20.4065.027; Mon, 26 Apr 2021
 15:41:55 +0000
Subject: Re: linux-next failing build due to missing cubictcp_state symbol
To:     =?UTF-8?Q?Michal_Such=c3=a1nek?= <msuchanek@suse.de>
CC:     <linux-kernel@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
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
        <bpf@vger.kernel.org>, Jiri Olsa <jolsa@kernel.org>
References: <20210423130530.GA6564@kitsune.suse.cz>
 <316e86f9-35cc-36b0-1594-00a09631c736@fb.com>
 <20210423175528.GF6564@kitsune.suse.cz>
 <20210425111545.GL15381@kitsune.suse.cz>
 <20210426113215.GM15381@kitsune.suse.cz>
 <20210426121220.GN15381@kitsune.suse.cz>
 <20210426121401.GO15381@kitsune.suse.cz>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <49f84147-bf32-dc59-48e0-f89241cf6264@fb.com>
Date:   Mon, 26 Apr 2021 08:41:49 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
In-Reply-To: <20210426121401.GO15381@kitsune.suse.cz>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [2620:10d:c090:400::5:e445]
X-ClientProxiedBy: MWHPR10CA0023.namprd10.prod.outlook.com (2603:10b6:301::33)
 To SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e1::12ae] (2620:10d:c090:400::5:e445) by MWHPR10CA0023.namprd10.prod.outlook.com (2603:10b6:301::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Mon, 26 Apr 2021 15:41:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 79162493-eba7-4184-0768-08d908c9d1d7
X-MS-TrafficTypeDiagnostic: SN6PR1501MB1968:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR1501MB196860BAA6B5782E41DD63A6D3429@SN6PR1501MB1968.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0YEg3OY8lySlFw4hkJ8K8pLdJ1dILkzclJtJ5F7YRPyQvdjKZrKlcFTRTeB4VbOENdHk80EqFy9wmg17PC4zcxOhDoVHbRXqJiCDvmfjmvvbe73n9TgP6poqz4oHIq2uyx+lqpNcjf40bDvwT+wLzEx18isWCPmBp/CLyOSTHbPQHAwyke8107MH6lfk5tUCHVcqZ0auzRB7jrxQ8g3v3wpv48+pUlatG/YIxCdoinXLYsIiIyJKVhEFwUan8DwDtwpTdAhUkFevp1aq7kGjGE/pXFDMvAM+UIrn8nHu8pFSaFc5QEfSAMlLDhbPbAjp/Dv7F8zo3oYhhyjeme2sCWA4AEN+OKm2eTl+jTXG37U15NM/xWWKqh09vdwr8/50ZCtquqPz4WPOtSZzbMSras52Zzmr0kxIQRYKkY/zPoHpsG1nngKHfROf/DNr4uT7fAD03cXxORaHMcWqCqISo+klrvF4dt66tNBNAJ7vqlDwFCnSGTlbKY3p/WEQ0Z1UrACehkElthJ9qshIgoe6kYOun7gawCFNtYJH8YoBKAzFoqa3vCYTNQmsUgLJRLtF/byIVjTlU4Brk/sqleww5zZyTl5ds1p8J7AxJKaOxcy3UuJ1rv0LPu2x0ZfIDJD4audyMR/JCmqX+bI2gzo6mvewVRBzao5WFpZl+vEkonMpMEpHeL0rQ5pXvxHfARHR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(136003)(376002)(396003)(346002)(52116002)(6486002)(66574015)(38100700002)(36756003)(6916009)(478600001)(66946007)(83380400001)(2906002)(316002)(2616005)(6666004)(31686004)(16526019)(53546011)(7416002)(54906003)(4326008)(5660300002)(186003)(66556008)(66476007)(8676002)(8936002)(31696002)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?Windows-1252?Q?QJ521ipC5RaaWgjyI0A08CUR6/6Aw+MccD/cUEDikIhmSkx9nAgVMPxB?=
 =?Windows-1252?Q?W45SGYZhp7pHRU+pJjNVmk8WduUoU5vNXomuaC7M9P517I29q/XDZLbM?=
 =?Windows-1252?Q?Rqjjdv2RNYXhiDzo24m/vEDV+NSIbORSgezdGEFUf+8iJujzf2KbUtd4?=
 =?Windows-1252?Q?xh6NLF88kVg+3UZxfw2kP+zczgbxXTwk3QKXrUCUVHOym6yecP6p0rvh?=
 =?Windows-1252?Q?xP7cBN+AB3svOJJvvCLFMwqON7ddDp7R3S2IAimhqyTQ3hyoMcy+PgZe?=
 =?Windows-1252?Q?LLN4sjGruPKvUH1p7r8FbsJqEUBRUqoUzncgI6aspwagfwliz0MOVgW8?=
 =?Windows-1252?Q?GFTc19ilMH2x9eQHVbqZk9/stDFrDTPCCMQWwzWumiGnxOZlyT1SctBT?=
 =?Windows-1252?Q?z7HAphV3st0ttLkTT562o+W5tZRhgp/FVY/0uILrMQ6PZd30NuU3G3xT?=
 =?Windows-1252?Q?c5cEGiK3LcN7lYPdQ533lWcOBxr5fNRKtuy86j2XSdcXkvGQY0yNaO+y?=
 =?Windows-1252?Q?z+DOmYptonAl3f6G/y+L3lwgdCtnDa8d4GCUI7by9wdTDHTITxb+0mUx?=
 =?Windows-1252?Q?NW+H4E1JaYGp0bQtK76XdIQmINjkjuwilc5/5BW+f3GYciVRRDaYFRA0?=
 =?Windows-1252?Q?RptOquRTOtDLJH9Nd05Ex9jF0RCAKNTGXvq31uYfYBzoadTZXq0afxb5?=
 =?Windows-1252?Q?hVoDfLz9w5AEKoKIGtphpiJnYDg+FdgIuGDMkD2fzxLOlp2bI1pILYN0?=
 =?Windows-1252?Q?Dm6xcnzesmI1Ms/YtCOg7zIF3hp0WzUNHFlHGNF9ydRdrSFrvqMtorfs?=
 =?Windows-1252?Q?pRxh9CzEs1JRTjnL5udMfh1q6R7dY1F/62/wiFZ7obv6eBu/VCZguqBx?=
 =?Windows-1252?Q?QSNIQIiQ7aG+5/0fZJwOX2/cn1+rKDOxdmvn8egAdlJagQsaXOaYQmSO?=
 =?Windows-1252?Q?jeaICRYuGAxlZEWoOAmwFLIDV3XJFZCXBvBEb8rPQj4oAqezvrvC+Wdc?=
 =?Windows-1252?Q?u76AIzkRPwDx7fS4Un1Xy1HTC3pcQA/CZDt9Bkrd5myUOXD9lvVW3th7?=
 =?Windows-1252?Q?RAqIvBFEcVxUTHWqH/ex4XMganvAhA+9DIN2AN4/7QCVbAfu9PQ5ncsY?=
 =?Windows-1252?Q?QEaJDuObl9c3ogRd13rGpBnxUtCtRZyk9WT/73efh1fX+U7ON3DQOR+W?=
 =?Windows-1252?Q?LYLK6bLlvjgQuH0HZzKMvT44x19HYzhNXaQrUhEHEQe8uQ2pN7X5/cYq?=
 =?Windows-1252?Q?i9hXn4e9HMDStsBQAWs6fSC6mQCUbq0neXO9HEuMC+Pk06D70saxmuZe?=
 =?Windows-1252?Q?/CSe6lXGx6DxYMwEXqo4kdIZulrBYKdXNk6kaH9EalIuFTYNoPis/BPl?=
 =?Windows-1252?Q?idS3gH68Bg2KjwdrKM31s+MhWyiRm9K+01H3kevNIXmD5PigXCADhHaW?=
 =?Windows-1252?Q?AeRryguEnjLyYIBwff/q2A=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 79162493-eba7-4184-0768-08d908c9d1d7
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2021 15:41:55.3793
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fB1XVK2f2leNHHoIysERS0q+U18BlGwlqlLD1PSbhuWrrHV10cBrnCxSJPQwpARH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR1501MB1968
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: hr46-LU1I-LxLs3aU98qa4Yek_q6hN-t
X-Proofpoint-GUID: hr46-LU1I-LxLs3aU98qa4Yek_q6hN-t
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-26_07:2021-04-26,2021-04-26 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 bulkscore=0 phishscore=0 clxscore=1015 spamscore=0 suspectscore=0
 mlxscore=0 mlxlogscore=927 impostorscore=0 priorityscore=1501 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104260121
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/26/21 5:14 AM, Michal Suchánek wrote:
> On Mon, Apr 26, 2021 at 02:12:20PM +0200, Michal Suchánek wrote:
>> On Mon, Apr 26, 2021 at 01:32:15PM +0200, Michal Suchánek wrote:
>>> On Sun, Apr 25, 2021 at 01:15:45PM +0200, Michal Suchánek wrote:
>>>> On Fri, Apr 23, 2021 at 07:55:28PM +0200, Michal Suchánek wrote:
>>>>> On Fri, Apr 23, 2021 at 07:41:29AM -0700, Yonghong Song wrote:
>>>>>>
>>>>>>
>>>>>> On 4/23/21 6:05 AM, Michal Suchánek wrote:
>>>>>>> Hello,
>>>>>>>
>>>>>>> I see this build error in linux-next (config attached).
>>>>>>>
>>>>>>> [ 4939s]   LD      vmlinux
>>>>>>> [ 4959s]   BTFIDS  vmlinux
>>>>>>> [ 4959s] FAILED unresolved symbol cubictcp_state
>>>>>>> [ 4960s] make[1]: ***
>>>>>>> [/home/abuild/rpmbuild/BUILD/kernel-vanilla-5.12~rc8.next.20210422/linux-5.12-rc8-next-20210422/Makefile:1277:
>>>>>>> vmlinux] Error 255
>>>>>>> [ 4960s] make: *** [../Makefile:222: __sub-make] Error 2
>>>>>>
>>>>>> Looks like you have DYNAMIC_FTRACE config option enabled already.
>>>>>> Could you try a later version of pahole?
>>>>>
>>>>> Is this requireent new?
>>>>>
>>>>> I have pahole 1.20, and master does build without problems.
>>>>>
>>>>> If newer version is needed can a check be added?
>>>>
>>>> With dwarves 1.21 some architectures are fixed and some report other
>>>> missing symbol. Definitely an improvenent.
>>>>
>>>> I see some new type support was added so it makes sense if that type is
>>>> used the new dwarves are needed.
>>>
>>> Ok, here is the current failure with dwarves 1.21 on 5.12:
>>>
>>> [ 2548s]   LD      vmlinux
>>> [ 2557s]   BTFIDS  vmlinux
>>> [ 2557s] FAILED unresolved symbol vfs_truncate
>>> [ 2558s] make[1]: ***
>>> [/home/abuild/rpmbuild/BUILD/kernel-kvmsmall-5.12.0/linux-5.12/Makefile:1213:
>>> vmlinux] Error 255

This is PPC64, from attached config:
   CONFIG_PPC64=y
I don't have environment to cross-compile for PPC64.
Jiri, could you take a look? Thanks!

>>>
>>> Any idea where this one is coming from?
>> Attaching a complete config
>>>
>>> Thanks
>>>
>>> Michal
