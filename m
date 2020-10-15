Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B02A28ECE9
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 08:04:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728864AbgJOGEX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 02:04:23 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:39284 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727397AbgJOGEX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 02:04:23 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09F6429N009717;
        Wed, 14 Oct 2020 23:04:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : from : to : cc
 : references : message-id : date : in-reply-to : mime-version :
 content-type : content-transfer-encoding; s=facebook;
 bh=39gX/YXMbMZX9pPr1CyczT4O7B12sld6NyoN+0iBIpk=;
 b=JmHyKIIJWxaDvXJDu9fP0rKBrViXu+wzT4c7HhwCZd7OQxdXg4hbstNcxMLK/tuPQUhM
 BEGwnajJYOOh0DkByZXKfw/OoeDuCQWiDls07fTEd7z94jtNk3PT90KM/me8Pyz3MWMk
 e0MZyyiA+Q3E0dDJ58jk4s85FWSoEMYgfE4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 345e3rja9b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 14 Oct 2020 23:04:07 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 14 Oct 2020 23:04:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K3qNtr1zFkPvlbi851XFLd1i0bt3VF3fWrcISwQNynN2bjOErP3H2+eKpgrO4tsmkZEJvBv43aVBSqP1Ids/D2noNd5vRV1CsJvVs/q8v9jZpqd04QqDcRxjNp3uMNyeFA2PoiN3B61IFojwvjmH2FGh1djxJ/+VWlWE4x42ukGN3bVttJrhguvLEH2cJr3vBl9XL+GB1XegAiZjPof5kNc4MZRVYjD/aqHDAgRXY/1+9bybx4h9VwypiRvKjMkCUZn5CfRl/fO6IbeVpuybXLTMtA9M1/dgwJJjGZ+sKI6Fu4jZhnNy3E4lBwP33Bb/5TzwXqgc9gPeLZaYjA+8OA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=39gX/YXMbMZX9pPr1CyczT4O7B12sld6NyoN+0iBIpk=;
 b=YosEGCr2Hv5NrhJUPJkzXI4ZWCZp8FA9ATD3S5Xs4gyMH1NaIRzK1wLMkleUzAM8YMFGMLNUWunRMYXNnAl2i8QIM+nJYX2pU9okG10jjRJMVNuYtM9f745U3j5DpsOY2ROSzK9ewLYZ1wk0Ro7BChxrhDdIpSDMfwHPo11dWSMaRLZWPp202WdOUyeUFg84SG5LiFrD+Nz4kvjwAJudaih0wZo+R2gRkmoupTNoTw8msnM/pyrenZM9fve5uwtt7JwURCWcJNBRVewqFOzHAZE4Ep74JR2UAAe1ylbfs0MqeyzkSpB50E3HtdqH+dO0GwiwwavtgjWaqxZkiRtLZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=39gX/YXMbMZX9pPr1CyczT4O7B12sld6NyoN+0iBIpk=;
 b=bm19N8EO8ZZJvtP2qkSJMrbNyi9iAABs2eh4dsDhoYx46h8cpyT7YmeSxjC2Su7VmWl+H51FpMDH9LDJdBZdhhshiJb+NQTX4FbvfEnk3Z2eEsd1B0OZtuAVR57kms31xJYXy8LVSwSuvu2CwMDUuoXPwXnPq/aUS4PG9c3N5so=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2837.namprd15.prod.outlook.com (2603:10b6:a03:f9::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.22; Thu, 15 Oct
 2020 05:48:55 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8887:dd68:f497:ea42]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8887:dd68:f497:ea42%3]) with mapi id 15.20.3455.030; Thu, 15 Oct 2020
 05:48:55 +0000
Subject: Re: [PATCH bpf-next] bpf: Fix register equivalence tracking.
From:   Yonghong Song <yhs@fb.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <john.fastabend@gmail.com>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <kernel-team@fb.com>
References: <20201014175608.1416-1-alexei.starovoitov@gmail.com>
 <4ec07471-5d8c-5aba-1f0e-65fe61c4d298@fb.com>
Message-ID: <0bfcf40e-7739-5435-7b83-33eda64d74d9@fb.com>
Date:   Wed, 14 Oct 2020 22:48:51 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
In-Reply-To: <4ec07471-5d8c-5aba-1f0e-65fe61c4d298@fb.com>
Content-Language: en-US
X-Originating-IP: [2620:10d:c091:480::1:2a8a]
X-ClientProxiedBy: MN2PR19CA0004.namprd19.prod.outlook.com
 (2603:10b6:208:178::17) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c0a8:11c9::138b] (2620:10d:c091:480::1:2a8a) by MN2PR19CA0004.namprd19.prod.outlook.com (2603:10b6:208:178::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20 via Frontend Transport; Thu, 15 Oct 2020 05:48:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c9081637-b944-4748-3c9c-08d870ce010d
X-MS-TrafficTypeDiagnostic: BYAPR15MB2837:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB28377A7E1C278F6DC2081874D3020@BYAPR15MB2837.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ut4yeGky24/MIH/ootA2GIX/VpSgey8EVQR7zApBhH0KSSRNZnIluEgIWf+Yw+oN2DlsGCGv89SJX2yFOkkPW+UuZ5g3B+m9lOaHMOZfBha0wJnfpcr1mnX8IhLfC4JStkmYCWoGVxzRnroWVNEFT+hnxixfCk0Zbz/XobCVEWggPy77MK9D1UdoibPONbU5hk2A4zIa5pKg8ZuvCWn7Ejcd262NwMyYDSvvQ95H30qyMQmgdLdSsLTBJF17LpxA/B6I1uvsbx9ZqtVpA5HLPwRImbmiXubi3AnFU5vfwG7QHBJB7w7O0V6POsUFCfYKBWsB8tUoLnOges6LXKDAGOH2TUQRrAYa6igs2PPONOeaKhXK2cwVbQZJ1WDz7fVK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(376002)(136003)(366004)(39860400002)(478600001)(53546011)(6486002)(8676002)(2906002)(8936002)(4326008)(5660300002)(52116002)(186003)(66946007)(66556008)(66476007)(31696002)(31686004)(6666004)(36756003)(316002)(2616005)(86362001)(16526019)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: bu7oZNA0UBCu/OSLfsz2sjO4C4DT55ipDEaZsIZ2NMYEgefevmBH0sLGX/lNBWEKO0di/0DEV5iSAA5uxTeoEErIo8oCMRQ+NdswDQV7fPIZP7eX3ThVGpdaEJY3DlYLAwHmeYWz7FlbSG0gAKXXeJCSd+3zRgvI5lzaUedaOYRCIeXs/Hud5NfaNce9KXYEmzLr+VnmuvqVWcwxYHabpFeW8aGL5xhZtbZIEaIcQ34RpDb36styMls3Z2KvFFVC1tKa7VK9JwT7jJmKNTjM6elo3de6wacir0MezxyMAzUo9OhXRYeO6imeKRSGcN9p8SzeRFp7UkNkyOIE2wgruh33tVGWiPjpT3eJ16oYeHxuk904joWfSeT+2heWxUrTCqw2vvdnpw4qj9OlpOPEhsoapbuvnSBL1vAhcGtmMWiJAYASV7sMDHCbpbBfBQ/DrGFntmCTnK17NLrTXNFvEqJC9s8dJ4QIIM4qFJ9aIU20O4Eh07VLctuzbxbjlmwulxJDF+DZMWBdOKck0cXcVph5Sqf+LSHvtxJSUvdtoI7KUOgcSVAhwY6ukDzydzffjZhf8ZShpfPStpx9XceLq7Kp4w6021oyt6Oy8py36JGSsp7uK81c/xYI3Gb/9HyTkF8qZenwCb/uXYqGtPic06N/n6DiOmUO0ZcD0atC43Q=
X-MS-Exchange-CrossTenant-Network-Message-Id: c9081637-b944-4748-3c9c-08d870ce010d
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2020 05:48:55.7413
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lOdUeXaeITMDKZTNpJciTujJbFbyFfYzEXpZu6jnCnqVlz2OfZOLxKPiQ4hVgC0V
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2837
X-OriginatorOrg: fb.com
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-15_03:2020-10-14,2020-10-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 adultscore=0 spamscore=0 mlxlogscore=999 lowpriorityscore=0 clxscore=1015
 suspectscore=0 mlxscore=0 bulkscore=0 phishscore=0 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010150044
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/14/20 10:46 PM, Yonghong Song wrote:
> 
> 
> On 10/14/20 10:56 AM, Alexei Starovoitov wrote:
>> From: Alexei Starovoitov <ast@kernel.org>
>>
>> The 64-bit JEQ/JNE handling in reg_set_min_max() was clearing reg->id 
>> in either
>> true or false branch. In the case 'if (reg->id)' check was done on the 
>> other
>> branch the counter part register would have reg->id == 0 when called into
>> find_equal_scalars(). In such case the helper would incorrectly 
>> identify other
>> registers with id == 0 as equivalent and propagate the state incorrectly.
>> Fix it by preserving ID across reg_set_min_max().
>> In other words any kind of comparison operator on the scalar register
>> should preserve its ID to recognize:
>> r1 = r2
>> if (r1 == 20) {
>>    #1 here both r1 and r2 == 20
>> } else if (r2 < 20) {
>>    #2 here both r1 and r2 < 20
>> }
>>
>> The patch is addressing #1 case. The #2 was working correctly already.
>>
>> Fixes: 75748837b7e5 ("bpf: Propagate scalar ranges through register 
>> assignments.")
>> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> 
> This fixed an issue appeared in our production system where packets may
> be incorrectly dropped.
> 
> Test-by: Yonghong Song <yhs@fb.com>
Sorry for typo, it should be:
   Tested-by: Yonghong Song <yhs@fb.com>
