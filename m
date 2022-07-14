Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CE41574103
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 03:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231234AbiGNBnH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 21:43:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229763AbiGNBnF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 21:43:05 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69E802251A;
        Wed, 13 Jul 2022 18:43:04 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26DICfsE009044;
        Wed, 13 Jul 2022 18:43:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=0LcmYG4EfZTDybzcqdCw79XoM9S6jh7lhqA5uJt761I=;
 b=NT0aMf9pdSPbu467Mf5pw7zgffPYBBYHJegxnyNznA7mDWFscjSnnnAfFOOQuDrdF7Og
 XAtJTFdsTnmZQq9ChJpJ2WASxYatSbxl4WZYkdAlc0mwnwy7gPtE565LdqJwRRrF7s3w
 ObAxGoEFrW1mz8dAaYSY11bPqdqVIYHzACM= 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3h9h5f880x-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jul 2022 18:43:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UcuZuvzt086sSC9aeHytlqG3WRIb3QE8FYyykkKjP+yk9C8MZQbDZTG5M9xzjYLb1IXsecFGMXaIE16nDMTBMQFg5U/c9m289VSxiaI/o8QxOWtakc4XW7wADBlF2aGxW67rz57Q0CEwEoyv3cp9ixNYJW5fsPCBGsdPFWsB1DBEjCBAGlHqonPHVBaRhJLBNmjfZ35Bcr6+W5COOXmCWfqZYvplyBJrWqy2vEdC5fsHjID4kozgMejladx3UWkxRKw11gss+0M93SrZlCSdlQoczAekM8s3399ONbPQFOn1bk0XDF3DDSc/I++c2fQJdRYFDhiymjICrL8x+mxmsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0LcmYG4EfZTDybzcqdCw79XoM9S6jh7lhqA5uJt761I=;
 b=bRfIBagLXLdlmsNw0OHIWCRYLzplrmq3nq/C5TRZda2F9nYHPGDKAHrA9leo/wgXlHYWjuJkbfbOajk01rA+nBeyHaJCw+SvQBwFVKT6SUFOOPRdJbr45SFx4QtAYvugzHQJR29BYW7u9uHa0RO27W/bIxjE3KGcwgp3Mds47/csvJ/bf6pFqpe8EBwgorcnkePVielK/td4ybjnvaZ+gpDi7m30f2g6iFDFMnhmhJve2Lg5iFTd7bBzKuAocPjEZfIuvz6/DcvlOCN6xebrjIOT2Ecf+esPKbAGdhsEUcDhS+BnHuirFvjkirGmcWTH6xd+FefUaCqy26Ze1zV/TA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by BL0PR1501MB2052.namprd15.prod.outlook.com (2603:10b6:207:1b::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.26; Thu, 14 Jul
 2022 01:42:59 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::5de3:3999:66df:42d1]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::5de3:3999:66df:42d1%4]) with mapi id 15.20.5438.012; Thu, 14 Jul 2022
 01:42:59 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Steven Rostedt <rostedt@goodmis.org>
CC:     Song Liu <song@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "jolsa@kernel.org" <jolsa@kernel.org>,
        "mhiramat@kernel.org" <mhiramat@kernel.org>
Subject: Re: [PATCH v2 bpf-next 1/5] ftrace: allow customized flags for
 ftrace_direct_multi ftrace_ops
Thread-Topic: [PATCH v2 bpf-next 1/5] ftrace: allow customized flags for
 ftrace_direct_multi ftrace_ops
Thread-Index: AQHYdriN/yOd0MaY7kCCLNeAHt/+qa19MFsAgAAO2fGAAAd7gIAAEfYA
Date:   Thu, 14 Jul 2022 01:42:59 +0000
Message-ID: <C2FCCC9B-5F7D-4BBF-8410-67EA79166909@fb.com>
References: <20220602193706.2607681-1-song@kernel.org>
 <20220602193706.2607681-2-song@kernel.org>
 <20220713191846.18b05b43@gandalf.local.home>
 <0029EF24-6508-4011-B365-3E2175F9FEAB@fb.com>
 <20220713203841.76d66245@rorschach.local.home>
In-Reply-To: <20220713203841.76d66245@rorschach.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.100.31)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5685112e-0306-439b-7256-08da653a2ee8
x-ms-traffictypediagnostic: BL0PR1501MB2052:EE_
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SLGm4thwzMzwm6UQfRGJv2LcE0ry09XlsvK1s7pZENyKVaXL2bhlNvtpvMINL+ARQmnKAD396WzY6C0M904C62Z4B3JGJAFyPg1nfxl1DknmKRpzebCjFi8gQ+1tdeDPF08Usyoxx9HJyx5FmJrpJUwUq1ffL5Tu3itlScRXrkSwuFsAtPUyCh1D0YmLjIPl5drmLXrsElG/fdW9Ewlmb+AtsNlpDl5ri5csS4swfpKSVb86dBBtOPmv2Ot4q/6/ZbI7DMb+bvtkq/wsF3qlQvF5eJnO1CxIlg3DbYaFluWUFZuiNZ8+oabgEwXZYKjxtVyHdns68sM+cqV+aWEGx4sCfyNdhQnmPU7DDi/oTlcMD4KYbU80fSiBKLUTrtwjOyBLSoY8z25B5wwFvg94M3MzpSUXBc0ZsOR8ekE2XQd/5X5TynP4E+Fm1jTCtr+fYCx3B1MIzSENxqArwqTLiR6oRGlU3YtmlNeK8un0rDkM/YDbcpBR24LXTYb5bQ8xdVqVU5pV8Ej3kh/Kf7mCC5XDX9rPkKQUKSem1/1xkrC/3OLr0PMuYJ03Q56MK0WGc0YuWOYeAq+WnU6OCMN4P045WCMa24RZ7Krvy4d2zrYT+DWFKD6LcVYRwE7rVFHo0FAC+mS1RSGgZp/clCL+HO9LFoeZeNRzH6nG9Rr/HhwLfylAzfNNbOVbHObpqX+Cnxi9l4QqongkopksH+CFZO0GsDZ/eY72eoun9JuvNh0AAFglQky5AEhpdTmdleD6s5bH8++guRRbzfV7g8we2gtmR0O1wmxD8cIRYk+imyG031h9kxDrFr2P0+2G2D8HSmxckblVnQYMt4EQnwW0wBq258ZPMzhTCQa63LaPv08=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(396003)(366004)(39860400002)(136003)(346002)(6486002)(83380400001)(71200400001)(66946007)(6506007)(6916009)(38070700005)(66476007)(4326008)(76116006)(8676002)(66556008)(66446008)(64756008)(122000001)(91956017)(54906003)(2616005)(478600001)(186003)(86362001)(316002)(33656002)(8936002)(36756003)(38100700002)(6512007)(53546011)(41300700001)(2906002)(7416002)(5660300002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?QUHselXhsC2XjkLGSds8dVEVFRo2JLxOGymCbL7ZH+itcUIZGRcdPzB1wPPB?=
 =?us-ascii?Q?+oVzh3zyQ30Md5zBNV0wzLulu3nXjGD9D4Ww/5STrQe6NPPBC0M3nuYZ6nre?=
 =?us-ascii?Q?1UnlvzsFaTyXanrRfsfAoOz9u2KP9espxpPXVkRrG/7ivMyfxCOxf0qnUhXp?=
 =?us-ascii?Q?KttaQJGJvngxNp/vqGILnhu76yLyYQIvxddmRE6aN4BL2RBoytpgsD5uGp0D?=
 =?us-ascii?Q?nABTqdavdEMjd0uDqt98OqsKmAVTEx0ZpnuF7UGMy2gBZZL8omGh2c0O8zmL?=
 =?us-ascii?Q?xjqCpNVaN/qLBWt3FTVIq0WRQG6wfCY8hRY5nrASsEk/J0Ug7FysShOFARFy?=
 =?us-ascii?Q?zznq6R+1I+ct/VY5mzLaPAkphy1POldP5HcMLA5m8Ag5DMe9K2upmVPFHEDX?=
 =?us-ascii?Q?y6zfmU/vdxc3jFeokyftJh0ak56OB2MC/qOn0v5MpA3ZE2mh9LdpzdIS7RSM?=
 =?us-ascii?Q?kT7ScKUNwFETAYpC2Z/kekify3BI7EAQBxvTnxvFiO0EfPwdXrtsJj8AC5kx?=
 =?us-ascii?Q?wVppUQoLpxuo76AmtqewnZTIYJwQ/zukZQ0es6M5mZF1yi0QmsByE5UMADvQ?=
 =?us-ascii?Q?01M17JgRFBA5NsYsnwkUyb9kwipav7uihtjYg1g+PXCfltS/ZJiRojLLzLO5?=
 =?us-ascii?Q?GFlDYqxKxmfeTdyLgQx7nO7qxVMKKBWh3Tkw4+DYAzqfQ62aZBi6lsaBeneY?=
 =?us-ascii?Q?uHGPmjku4yioVaIUy8D6rsQmkW8dMQ0o+YS3qGsKi9HWJ1LTEhKjfAyQPMaS?=
 =?us-ascii?Q?zt7Yh39P2bl+afOm+SR/4WlA2oTVwb1ePyjxc8K1oPPXAQvk8HYSkxbpoiFB?=
 =?us-ascii?Q?WG3Ddi/8IEEj8xBv+w5PFDiQlvsNTrjjrL/wWeac8xozHjMkVIsQCwtbsbXP?=
 =?us-ascii?Q?dkqajpPB7fQzqed8dU0bpcCQ1/Yhdhs/mAdaG4qVT28ytAwzq7QlWOAUM6cB?=
 =?us-ascii?Q?9EQfc6f6UB+1mjwB1N9R7DQg3SlmQOKnEQd2Ycxwnsp27f1zdaAD21629RLP?=
 =?us-ascii?Q?f2d3efaMNVqIl9ijWFBCK61mwAnBkbU/+Qjw/nybuZlNcJz5It3lMGaMuHpt?=
 =?us-ascii?Q?Bd3b+JvFmD5gTeSfZukA+Yj6RV9te+ZtRFoydmZvKx6xaYTqe1P1SsmgFMsv?=
 =?us-ascii?Q?ZQlIQ+l5zF1z5pcKC3c1X995vK/LYUoTQ/VvrjYiA7MgcfdJvMVLUtfpGtO1?=
 =?us-ascii?Q?ztzC80k7CY1nJWf+YTcyjIKSiuY3FrcosKrk6z65jOsdtzFeITIGURxQLZSO?=
 =?us-ascii?Q?cO8rgvF01DVH/rke/y/AhnLrCMJMobwoCWKSo70Ut8tDCmleWN7VX/51z/HI?=
 =?us-ascii?Q?V69LgiNVmiYtJJ8+6WGb5xEbvyxINPIykIuEWW225AKtNfDuzUXN8kql1RnP?=
 =?us-ascii?Q?YkjoOBv/pJA10f/5p+aTT1jjmq30Qs6BEMY/fdmEqNMAesJCP6oMliH0R/xV?=
 =?us-ascii?Q?2Dzl/ekwgwfXl4681huksUiPT8a/IT0hm67FjPK2K2gWykSSeirXBeB/p3Na?=
 =?us-ascii?Q?I3kPeDVywN/bOwD97Wz5cueMKE0gX2V6VvbfTiIOhjOsPkFh/zwfemNQNqxo?=
 =?us-ascii?Q?xJ+/yLt4udMcPNOh1rnm/CZuFtk9QgTbMP6PsmjMid1ITVj60jvve7jNVj78?=
 =?us-ascii?Q?W6LRfU3MASRuxdYtSqXlsB0=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F1C6D3841DA5214389D01B411B0CB64D@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5685112e-0306-439b-7256-08da653a2ee8
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jul 2022 01:42:59.5371
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 80rK0SkkvF2aQEVqBSvBFyuUJsnnKArkHSD6VF33ffYCvdO++/0jwNG21bL19dm3T5Bl4YYL5bfSjSyq4w/N5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR1501MB2052
X-Proofpoint-ORIG-GUID: lc3_UUzc1igA2FwR5vSHMWkC4MihMcWK
X-Proofpoint-GUID: lc3_UUzc1igA2FwR5vSHMWkC4MihMcWK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-13_13,2022-07-13_03,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jul 13, 2022, at 5:38 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> On Thu, 14 Jul 2022 00:11:53 +0000
> Song Liu <songliubraving@fb.com> wrote:
> 
>>> That is, can we register a direct function with this function and pick a
>>> function with IPMODIFY already attached?  
>> 
>> Yes, if the direct function follows regs->ip, it works. 
>> 
>> For example, BPF trampoline with only fentry calls will just work with only this patch.
> 
> I replied with my thoughts on this to patch 3, but I disagree with this.
> 
> ftrace has no idea if the direct trampoline modifies the IP or not.
> ftrace must assume that it does, and the management should be done in
> the infrastructure.
> 
> As I replied to patch 3, here's my thoughts.
> 
> DIRECT is treated as though it changes the IP. If you register it to a
> function that has an IPMODIFY already set to it, it will call the
> ops->ops_func() asking if the ops can use SHARED_IPMODIFY (which means
> a DIRECT can be shared with IPMODIFY). If it can, then it returns true,
> and the SHARED_IPMODIFY is set *by ftrace*. The user of the ftrace APIs
> should not have to manage this. It should be managed by the ftrace
> infrastructure.

Hmm... I don't think this gonna work. 

First, two IPMODIFY ftrace ops cannot work together on the same kernel 
function. So there won't be a ops with both IPMODIFY and SHARE_IPMODIFY. 

non-direct ops without IPMODIFY can already share with IPMODIFY ops.
Only direct ops need SHARE_IPMODIFY flag, and it means "I can share with 
another ops with IPMODIFY". So there will be different flavors of 
direct ops:

  1. w/ IPMODIFY, w/o SHARE_IPMODIFY;
  2. w/o IPMODIFY, w/o SHARE_IPMODIFY;
  3. w/o IPMODIFY, w/ SHARE_IPMODIFY. 

#1 can never work on the same function with another IPMODIFY ops, and 
we don't plan to make it work. #2 does not work with another IPMODIFY 
ops. And #3 works with another IPMODIFY ops. 

The owner of the direct trampoline uses these flags to tell ftrace 
infrastructure the property of this trampoline. 

BPF trampolines with only fentry calls are #3 direct ops. BPF 
trampolines with fexit or fmod_ret calls will be #2 trampoline by 
default, but it is also possible to generate #3 trampoline for it.
 
BPF side will try to register #2 trampoline, If ftrace detects another 
IPMODIFY ops on the same function, it will let BPF trampoline know 
with -EAGAIN from register_ftrace_direct_multi(). Then, BPF side will 
regenerate a #3 trampoline and register it again. 

I know this somehow changes the policy with direct ops, but it is the
only way this can work, AFAICT. 

Does this make sense? Did I miss something?

Thanks,
Song
