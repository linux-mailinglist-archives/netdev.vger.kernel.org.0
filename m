Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAE41162ABB
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 17:35:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbgBRQfA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 11:35:00 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:50184 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726403AbgBRQfA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 11:35:00 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01IGPubm028884;
        Tue, 18 Feb 2020 08:34:41 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=8/4gOYKri87PQAvEaG7shEOGsl2sj+gq/tmiQH6h+Gg=;
 b=o45iIGvrHbYPdAns7+t0PoK4m/R+Ob60irf/J38gssTwwe5S4/goth4uML85HLZPeqYt
 bbrnGjl4TITiCOaOespLwciTcRvZnr1qFNiqtKrNOM4gaJiZsqLYGh5dUV92xzCuUDXV
 PDC9+cmGSsCjC/TlhODujw9R5h//ODEVdGg= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2y713w1vm7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 18 Feb 2020 08:34:41 -0800
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Tue, 18 Feb 2020 08:34:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T7Ezi5y1KR6anbynw1pCvDp68VBPuqtGEtwmQiJlSI2+G2AGv5JTEjdP9Plvoe9gltrAGuwe1n1LUle7bWaF5FaXmDm6tXZmI+P6Ib9X1mwqBLYLHXhofxDxYZb4+ECbRbEDhTKFfQs9zOvrEReHMvYf3Q14xmYSW9E3/k0FwNRi4DtTftF5ij+l4ufp0zlk/IfYNBi8T8BAqaT0MRXPOcP/vHkvgNzdigx25/H+tiC/drhNx5T4j3QCbDNer9yCagM9boIrFu85xbOkAfITOG0nQhKgvsqxQPaYEg191OvRNitnKZuK/AbJyBGCxa67v9iOE7WRNEVGiFKqsAIVmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8/4gOYKri87PQAvEaG7shEOGsl2sj+gq/tmiQH6h+Gg=;
 b=fbAmeL0LpnQFLjOQpGBXr7gs03uWlXw2ZO+25PMKWHL8wTyYBbNMoKejMVEIh3foL/5tP90zL0ZVtROTIoIq0bdwN/WTZzVZZpZByTf0TGVvCGiIsEomASF1Lzmv03AYsenc62F2lwo8kjoetHwGnqgCCKZZS8U1CObCmHhDqPsi+CFEo42hBPDvYotXda9xf2EvykwRq6aGp0UNvD+cxJcUAeLkpQo/7OZThPvedmERFnvUS+ezMvCpzRo1GKaeUMvW4xBZhmWZT9sRV8I/UPROaM0ycySE1gpQcbt0PfLoMmrpTxMOEr2gTGwyKZZdCs4PnfU+OjUezp0v+6VqIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8/4gOYKri87PQAvEaG7shEOGsl2sj+gq/tmiQH6h+Gg=;
 b=LHxKzFoeOgSbi0BBgfpb9niI1h0cSpbrPevZr5id+jai4HClpVd2ZlG5o7hjyHG3i4X5YwFHMhFnzlyA0tfOLW5+I8Se7/xjTTsWlTdxZkP62onSsMaEfHc0bOCyMajOkutB1GWxVSdNU3lIUObwZQvn2vhisIbyQU7URthp0XM=
Received: from DM6PR15MB3001.namprd15.prod.outlook.com (20.178.231.16) by
 DM6PR15MB3354.namprd15.prod.outlook.com (20.179.52.97) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.22; Tue, 18 Feb 2020 16:34:39 +0000
Received: from DM6PR15MB3001.namprd15.prod.outlook.com
 ([fe80::294e:884:76fd:743c]) by DM6PR15MB3001.namprd15.prod.outlook.com
 ([fe80::294e:884:76fd:743c%4]) with mapi id 15.20.2729.032; Tue, 18 Feb 2020
 16:34:39 +0000
Subject: Re: [PATCH bpf] bpf: Do not grab the bucket spinlock by default on
 htab batch ops
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Brian Vazquez <brianvv@google.com>,
        Brian Vazquez <brianvv.kernel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
References: <20200214224302.229920-1-brianvv@google.com>
 <8ac06749-491f-9a77-3899-641b4f40afe2@fb.com>
 <63fa17bf-a109-65c1-6cc5-581dd84fc93b@iogearbox.net>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <c8a8d5ca-9b97-68dc-4483-926fd6bddc95@fb.com>
Date:   Tue, 18 Feb 2020 08:34:36 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
In-Reply-To: <63fa17bf-a109-65c1-6cc5-581dd84fc93b@iogearbox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CO2PR05CA0082.namprd05.prod.outlook.com
 (2603:10b6:102:2::50) To DM6PR15MB3001.namprd15.prod.outlook.com
 (2603:10b6:5:13c::16)
MIME-Version: 1.0
Received: from macbook-pro-52.dhcp.thefacebook.com (2620:10d:c090:500::5:fd19) by CO2PR05CA0082.namprd05.prod.outlook.com (2603:10b6:102:2::50) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.6 via Frontend Transport; Tue, 18 Feb 2020 16:34:38 +0000
X-Originating-IP: [2620:10d:c090:500::5:fd19]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 79618f12-1b5a-4663-f908-08d7b49072ed
X-MS-TrafficTypeDiagnostic: DM6PR15MB3354:
X-Microsoft-Antispam-PRVS: <DM6PR15MB3354680E1E5C6795BFFFCD3AD3110@DM6PR15MB3354.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 031763BCAF
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(346002)(39860400002)(376002)(396003)(136003)(366004)(199004)(189003)(66946007)(478600001)(16526019)(186003)(4326008)(53546011)(5660300002)(6506007)(52116002)(31686004)(86362001)(66556008)(66476007)(2616005)(81156014)(81166006)(8676002)(8936002)(316002)(110136005)(36756003)(31696002)(2906002)(6486002)(6512007)(19627235002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR15MB3354;H:DM6PR15MB3001.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fczdOg8jTvc12lajNisnGHu2AUg8E6GaFSbD4BAqGyWHJOg2lJ2PntgR5LwD3XbpWnRS0Li/m9/8cmd0N0H6GSQpp7vFp92cdlk1S6FLjsVTMI1Ob30RjJcoz+jk2ChTUPUpnSfN2tksNBbvPyDBtsm8ZP5/kpQLcismbmUC4JibUEWUXjoJ/Ni6Ad2POZW7RWsT6UwuGpkKt3Afi6qIUiyQOU+PCwLFkcrnBbwks0bcIAuOybqDDsp9Ed5SFBQYnMCWl1/InFSsroMBH0S/zdV2hp1Ksa9ULLIUMJ+zn8QviMDOJNtumnPKEUCLFVClnUBrAIhqaTuBGPMp7sl7xxTNpTYS8S8bUBRUgxTGsVrIf+XkTfgWXhSQBJdysJIlC01WkdjDV2kr8MsOGEfRBmeeNo4Aaj0dsV8WvEOeuGA2D5HNB6tlxqHwG84V3V/P
X-MS-Exchange-AntiSpam-MessageData: xGO+ZSeKPtquNCUtR/jVoRYix4bFzyt5BZn8tiK5wjRitkQV1PqhVJMKh5YchCWn5CW4XkXuMDXkkWuGu1gKLdrQOjzlf0qrMeEXk8NGFsrIscUTMCF0jCBA+vq9DzGCC8s2UcuGlJE8ydKqf2bTmgvcCjZwHRKtduV8OVENFPh9kGefgIiA2eweFq+XJSKg
X-MS-Exchange-CrossTenant-Network-Message-Id: 79618f12-1b5a-4663-f908-08d7b49072ed
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2020 16:34:39.3582
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3j2o0nneNHq5F4baGGepmJyIJ4Gaq8lvl7Wj1BiA/xwshxaGuEhrz5p06o6v/NJu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB3354
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-18_04:2020-02-18,2020-02-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 malwarescore=0 lowpriorityscore=0 impostorscore=0 spamscore=0
 priorityscore=1501 bulkscore=0 phishscore=0 clxscore=1015 suspectscore=0
 mlxscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002180121
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/18/20 7:56 AM, Daniel Borkmann wrote:
> On 2/18/20 4:43 PM, Yonghong Song wrote:
>> On 2/14/20 2:43 PM, Brian Vazquez wrote:
>>> Grabbing the spinlock for every bucket even if it's empty, was causing
>>> significant perfomance cost when traversing htab maps that have only a
>>> few entries. This patch addresses the issue by checking first the
>>> bucket_cnt, if the bucket has some entries then we go and grab the
>>> spinlock and proceed with the batching.
>>>
>>> Tested with a htab of size 50K and different value of populated entries.
>>>
>>> Before:
>>>    Benchmark             Time(ns)        CPU(ns)
>>>    ---------------------------------------------
>>>    BM_DumpHashMap/1       2759655        2752033
>>>    BM_DumpHashMap/10      2933722        2930825
>>>    BM_DumpHashMap/200     3171680        3170265
>>>    BM_DumpHashMap/500     3639607        3635511
>>>    BM_DumpHashMap/1000    4369008        4364981
>>>    BM_DumpHashMap/5k     11171919       11134028
>>>    BM_DumpHashMap/20k    69150080       69033496
>>>    BM_DumpHashMap/39k   190501036      190226162
>>>
>>> After:
>>>    Benchmark             Time(ns)        CPU(ns)
>>>    ---------------------------------------------
>>>    BM_DumpHashMap/1        202707         200109
>>>    BM_DumpHashMap/10       213441         210569
>>>    BM_DumpHashMap/200      478641         472350
>>>    BM_DumpHashMap/500      980061         967102
>>>    BM_DumpHashMap/1000    1863835        1839575
>>>    BM_DumpHashMap/5k      8961836        8902540
>>>    BM_DumpHashMap/20k    69761497       69322756
>>>    BM_DumpHashMap/39k   187437830      186551111
>>>
>>> Fixes: 057996380a42 ("bpf: Add batch ops to all htab bpf map")
>>> Cc: Yonghong Song <yhs@fb.com>
>>> Signed-off-by: Brian Vazquez <brianvv@google.com>
>>
>> Acked-by: Yonghong Song <yhs@fb.com>
> 
> I must probably be missing something, but how is this safe? Presume we
> traverse in the walk with bucket_cnt = 0. Meanwhile a different CPU added
> entries to this bucket since not locked. Same reader on the other CPU with
> bucket_cnt = 0 then starts to traverse the second
> hlist_nulls_for_each_entry_safe() unlocked e.g. deleting entries?

Thanks for pointing this out. Yes, you are correct. If bucket_cnt is 0
and buck->lock is not held, we should skip the
    hlist_nulls_for_each_entry_safe(l, n, head, hash_node) {
       ...
    }
as another cpu may traverse the bucket in parallel by adding/deleting 
the elements.
