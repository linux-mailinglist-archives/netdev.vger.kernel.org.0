Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2469B57692D
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 23:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbiGOVs1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 17:48:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbiGOVs0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 17:48:26 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7E032B1B5;
        Fri, 15 Jul 2022 14:48:24 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 26FKnFIk019290;
        Fri, 15 Jul 2022 14:48:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=bLWrf8NckqkOH3ff5fbO72oLBi0rpsYfx/C++5HHg2Q=;
 b=pKA3SvzcDvsCtnMD3jA6oZdi/Hh3kOrQbCiyySo4utRAxGCAd++rIfb1JSb8fc96ZFJv
 AJ2YYp6mzZYCxqlVCYcuKgk0ufShvnSmJslSw5K1xsrLKhnqbRg8pIdKbN4VaVfBkoBP
 fmBsA+cfZIRlvJUgr2QhBSRSevp/2GKBIww= 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by m0001303.ppops.net (PPS) with ESMTPS id 3hamy3sxun-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 Jul 2022 14:48:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jLlmDFO9SZpaN2BiojDjS+mVEyqEgQX368AYWmHunhTa6wIGrL7RoDGdBruTx1zb0fYN2ZTsTSi8BDqFNUFEYEAm/9WNMCAW+RzSf4ouw+LLZ5+j56XIuYs+CTmC4RcgAmeYLaM/2RctDr5V/5f1ZGf30tQx4NpXkgdlH+1LH+V7MnvAJ0R0fm+Ak2rDSxWkz39n+zq0NQxmFoqG2F3VbbnVi3pIjElatwrBoN2UtMhSs1uXkx1/N+McgCZB1S2DU9GPX1jgYjUGYB9OeRISmgHX6t7ZYUyrsOc4pFwMkhTDM3COzQRIPBbsBFewJQhExdwagFcSAptY3V/XbgNlXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bLWrf8NckqkOH3ff5fbO72oLBi0rpsYfx/C++5HHg2Q=;
 b=YlmA4NK5BPnr0ExwUVutakex+ZWQCVKdejU9bubsHbYceJJlLxlHQPNW1miCNIRFIjKC9WxlGczkY8ikpkleEh0bhnTjr/2rJx1ykL6EIntJ5IiTH6Wxcb4PBriCIRzrZEtC9QyGnqVDOX92mwOevsDesT/ERuTLsjHYgwwLq/eQwomaa4TG+s1JNKoIyPPWydDr+zDrrxmF3mehlbQ4BVXZkpJXsE/2K7Oe3g7Kg80BmILKZGTxYiR9jsoBHCcBOlqAMMfRCLuQ8/smvA+DRLYflSAaGKA0wAJ6dacxNU0gJ+PIMtDHIkHWvxiZueTsLWvRai6arg10PsLV2uk2FA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by DM6PR15MB4108.namprd15.prod.outlook.com (2603:10b6:5:c4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.19; Fri, 15 Jul
 2022 21:48:21 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::5de3:3999:66df:42d1]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::5de3:3999:66df:42d1%4]) with mapi id 15.20.5438.014; Fri, 15 Jul 2022
 21:48:21 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Steven Rostedt <rostedt@goodmis.org>
CC:     Song Liu <song@kernel.org>, Networking <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "jolsa@kernel.org" <jolsa@kernel.org>,
        "mhiramat@kernel.org" <mhiramat@kernel.org>
Subject: Re: [PATCH v2 bpf-next 3/5] ftrace: introduce
 FTRACE_OPS_FL_SHARE_IPMODIFY
Thread-Topic: [PATCH v2 bpf-next 3/5] ftrace: introduce
 FTRACE_OPS_FL_SHARE_IPMODIFY
Thread-Index: AQHYdrjyXTiiEgEgK0K1BTZfHuJgSq19RUuAgAGMyICAAAmfgIAAFU+AgAALzACAAADvgIAA+XEAgAAY+YCAAApDAIAAAwqAgAAGIYCAABLcgIAABVAA
Date:   Fri, 15 Jul 2022 21:48:21 +0000
Message-ID: <019DBB19-E3BC-4EB5-8D96-DB1D0E10FD73@fb.com>
References: <20220602193706.2607681-1-song@kernel.org>
 <20220602193706.2607681-4-song@kernel.org>
 <20220713203343.4997eb71@rorschach.local.home>
 <AA1D9833-DF67-4AFD-815C-DD89AB57B3A2@fb.com>
 <20220714204817.2889e280@rorschach.local.home>
 <6A7EF1C7-471B-4652-99C1-87C72C223C59@fb.com>
 <20220714224646.62d49e36@rorschach.local.home>
 <170BE89A-101C-4B25-A664-5E47A902DB83@fb.com>
 <0CE9BF90-B8CE-40F6-A431-459936157B78@fb.com>
 <20220715151217.141dc98f@gandalf.local.home>
 <0EB34157-8BCA-47FC-B78F-AA8FE45A1707@fb.com>
 <20220715155953.4fb692e2@gandalf.local.home>
 <6271DEDF-F585-4A3B-90BF-BA2EB76DDC01@fb.com>
 <20220715172919.76d60b47@gandalf.local.home>
In-Reply-To: <20220715172919.76d60b47@gandalf.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.100.31)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3526a9d3-3763-46ff-fd4d-08da66abbc52
x-ms-traffictypediagnostic: DM6PR15MB4108:EE_
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 610S/48XTLGFYx1EdrFnH+jnunfAj8sdw4V9xDK3xQCUaYGDACiSwFHIHDMHKHs9q56Qx/lR32lOMH9m5wceFNKN8GZdhDwiKtXjhkkPBZ9s4Hu+Zo38EVrqUj1kgg0a6cy99tKqy52uJ1PruDBC6rUBNZWx1BzuqZmIb1HLqND3plF8DuwHJFrmFR0Hanh6VMCIYoKHqw/YGiNc/zncggbDmpk71Z5zfSShqx4U8MjUlY8LC4nU3S48NY+x7Lj6YlNHsXOfXwLjBt5YqVLqPD3ycXL3vs2qHK9BF6dhJhZ/twExNGdWnL6eh6mREAjmBb+3SPrKiJJpGCGY/7eOUc5gpPHGE29QNyYe9xtUG81mpiuJrjvG/k0DAtt4jmxOYhZlUF54PLETrbB3E5iHCYWI8Wyhw+6ycn7TubQKSwuIVLtQgcwhKTUc3l5DXz8cTk0AyjUPj7iGjgLajrqjunQUq0DWMn/sqtBGKwT7KQpN6KmD8gmSltR5l0KNk61xpNW2v3NoUmfplPCeD0I6FQsBynmYix4g18ntf2PS4JCY94BgLJcZe1BL75ZoDLe0NxI05SbQi0aMaEU8UGz+jwkf5V8KWndvoYWrtMDTzPLK35YgRmA/+/aDd1C7kum2X8LeomhDu/gvhE8PqhbD1w7QuBemUwI/hNmUnIgIBf8HPs9yORWZawt0A/VRDiPuMduDo8hJt2Eyl/tX0XjSb1oyBs5iGjhatYLJR5v6kyJgYU+dYNZ8Ee8IXG6KjVUfMiM4MvdDz8hX4Kg52p2uS7o9QDpZ/dvBaP/1R1+mqJ4FVsUarkkUM+G07jI53F/brFT/Uv6bW5yLEZrY3Dgv08dxMJWPr4EFGfOk5Emtnv8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(39860400002)(346002)(376002)(396003)(136003)(33656002)(38070700005)(86362001)(38100700002)(122000001)(6486002)(7416002)(478600001)(316002)(5660300002)(8936002)(71200400001)(64756008)(66556008)(91956017)(66476007)(4326008)(76116006)(66446008)(66946007)(6916009)(54906003)(8676002)(186003)(83380400001)(53546011)(6506007)(41300700001)(6512007)(2906002)(2616005)(36756003)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?TK+s+q5sQXvukRDJOc6Q/YHRbox7YITYX5guaKTDbZZ1SvFvETaNBnlSoe7E?=
 =?us-ascii?Q?1aEvLizAFldKzULiHKsIpA03ElnJJZCYTFjBC3g360gJZFeSHb92herBzR3Q?=
 =?us-ascii?Q?/f3LUYgSneO4wqxuzMnyqjcKhaFWnuA5Y/3GJm738aaPNo8gwnCB2sMP3waz?=
 =?us-ascii?Q?CA+lNcjF7/ekSjhUeceLGSUsDySG0S6V5BDhX/oGnoEKS5qD9xyredxynBnm?=
 =?us-ascii?Q?mC38oX2vHpw5biqvNuTh6PvM8H+cXBpFOuvFZAni4kqq2HFD/NLzAGP7+dcj?=
 =?us-ascii?Q?v1/dpGGVgEMTEL8Z4b9fv+EoSzRJ8j6rVlPARf6dcrlbmeJvb1jeR9qnKsYn?=
 =?us-ascii?Q?R6NfkCldNuZ+70s9q4c46iDyCHKtr8qfampjEQWV9t+p3jiKYoO/eBICuhMW?=
 =?us-ascii?Q?vZFQXrTdEdwk7LqGI5+WBkT1Xwi1ViWfMjRXXTFQcdp71yJoH4D8jkBuJme/?=
 =?us-ascii?Q?XgseT4I4v4QA1BTX8SrNPcNDrW8iCFNQH5iT8J+odWjCguh1BUmMDcIA9Mxw?=
 =?us-ascii?Q?E9nw8MWqPxXQ/mz/BtUYB406+JlRjPjbY8eezCgfU9ll2irZTaGMpag5Em1S?=
 =?us-ascii?Q?UAofzUeVJ7XMcjvog0tGIDQUORXwLD+9mMjqyNhaXdRzD9rx0nmgfV8M4pTU?=
 =?us-ascii?Q?VQti2CDBgblV+dT+FHfn+JIga/G8y7lwoUHZr8UCRRU+e/sy3tPECZLDWmlc?=
 =?us-ascii?Q?qwmNSFDxeaTIQa8Te1hP9O6twtayAz1SxY0VWEBLjU2zBxNthyEo7GjbIsOT?=
 =?us-ascii?Q?a4UyRxs2xZZ+WhtHtWBpaQbNqLoq63glVWokXVAlEGWziEOhSumr94e0EuLx?=
 =?us-ascii?Q?d5lDHq6nNHgMH8dJL/VHH5Eo+qDZQHvd9ULXEDJ0hQbGVmZ+kNIf9uNqQlCp?=
 =?us-ascii?Q?tOukRwypMEqY21GndhLwh+MZ5HZEC/RSq6cojiQiAXKCnAM8bvZJmAqIzxC+?=
 =?us-ascii?Q?BZvFZnMGbvmvWrgUHlPuUgx7Rvf2URG94dc1BuSEcZBjjFPkABXu4itEQsqr?=
 =?us-ascii?Q?a+ajblvuif6C0YNCRIQnMFMgi63sWlnpCPWGX0jPzBwfnsnQO5kln0ftZkW4?=
 =?us-ascii?Q?AbPMWYPpffw163jLJdv4DdAWqMwtNmn5j0gC2NvRJ+srKIXbtXJErSqdDjqJ?=
 =?us-ascii?Q?JRhZdBM5J8bhlB/AQaHZf3E7MheXF3oEAaTClHsQTWy0SokqGoSFEAOZRVBL?=
 =?us-ascii?Q?65P97CiJo5Tn9vw8P7PSxW9Mxj7IclecdM/mXvQV9KtliWCKCh7Bm8GODZSi?=
 =?us-ascii?Q?DaMBMQKDner3t84E+Mwgri7Q7yyUWLeU7zgFwP/fEH2am7qlHGUqKbGDNRj2?=
 =?us-ascii?Q?0qPmxnXnf8wE0IA92yt4dDiCHZZW6a30vaCV+/NTpycK5gsmmL7wvWsdp3ed?=
 =?us-ascii?Q?yfu8abcGo8O2sNh2G6VHsUStrJCeTLX1cXJTsse354xSGUal86IYe+84IqV8?=
 =?us-ascii?Q?R6+cOsPSQ8rvI6iN+OQO49lOGKea/HaAbzzpgBZLV10ci26H+FQ+f0v9Oa8M?=
 =?us-ascii?Q?cnp/IjCtERQPFZkGqbLMwEe2Yn8h8udqoJ8XKSKZPBbmJWvxNXVtlrsIdN9K?=
 =?us-ascii?Q?TK6EsC3nWcAG21vpCxeSSfP94ItN9baFwhqi2GyAufmBXSDBuE92agLYbLmT?=
 =?us-ascii?Q?1olq0NHzzrVjgskAVS74KFQ=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <059D47723E1E304F9E2DD502439AD0EF@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3526a9d3-3763-46ff-fd4d-08da66abbc52
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2022 21:48:21.1029
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: M6el7DDxsSQhtdOiDlyiBeZIRAqRvOhy0I9h7glF5AlIrCKwHihk2Gpz/CoEqMlb0oFcTgJQIspskrozYm04IA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB4108
X-Proofpoint-GUID: Clsp_b-GmQKhro8je_01aZpF8Zj8LUUw
X-Proofpoint-ORIG-GUID: Clsp_b-GmQKhro8je_01aZpF8Zj8LUUw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-15_13,2022-07-15_01,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jul 15, 2022, at 2:29 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> On Fri, 15 Jul 2022 20:21:49 +0000
> Song Liu <songliubraving@fb.com> wrote:
> 
>>>>> Wouldn't this need to be done anyway if BPF was first and live kernel
>>>>> patching needed the update? An -EAGAIN would not suffice.    
>>>> 
>>>> prepare_direct_functions_for_ipmodify handles BPF-first-livepatch-later
>>>> case. The benefit of prepare_direct_functions_for_ipmodify() is that it 
>>>> holds direct_mutex before ftrace_lock, and keeps holding it if necessary. 
>>>> This is enough to make sure we don't need the wash-rinse-repeat. 
>>>> 
>>>> OTOH, if we wait until __ftrace_hash_update_ipmodify(), we already hold
>>>> ftrace_lock, but not direct_mutex. To make changes to bpf trampoline, we
>>>> have to unlock ftrace_lock and lock direct_mutex to avoid deadlock. 
>>>> However, this means we will need the wash-rinse-repeat.   
>> 
>> What do you think about the prepare_direct_functions_for_ipmodify() 
>> approach? If this is not ideal, maybe we can simplify it so that it only
>> holds direct_mutex (when necessary). The benefit is that we are sure
>> direct_mutex is already held in __ftrace_hash_update_ipmodify(). However, 
>> I think it is not safe to unlock ftrace_lock in __ftrace_hash_update_ipmodify(). 
>> We can get parallel do_for_each_ftrace_rec(), which is dangerous, no? 
> 
> I'm fine with it. But one nit on the logic:
> 
>> int register_ftrace_function(struct ftrace_ops *ops)
>> +	__releases(&direct_mutex)
>> {
>> +	bool direct_mutex_locked;
>> 	int ret;
>> 
>> 	ftrace_ops_init(ops);
>> 
>> +	ret = prepare_direct_functions_for_ipmodify(ops);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	direct_mutex_locked = ret == 1;
>> +
> 
> Please make the above:
> 
> 	if (ret < 0)
> 		return ret;
> 	else if (ret == 1)
> 		direct_mutex_locked = true;
> 
> It's much easier to read that way.

Thanks for the clarification! 

Song

