Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6487553EA2C
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 19:09:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240902AbiFFPgN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 11:36:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241087AbiFFPfP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 11:35:15 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89E1544A1F;
        Mon,  6 Jun 2022 08:35:14 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 255Le4us003305;
        Mon, 6 Jun 2022 08:35:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=Cnwin2cjc97pDkSnxlS+eY+DvnDoqfdq3eWtkjS1lTI=;
 b=jjsZJ0mmlms50Zzinc2nNRpnUo3Vd/ozKDFXebJo2SA3oBzM23/oAmOV820IHCjHy7qU
 k9RlaB+Ma666lwuje9a1BC/pGMknnbqQRzIRBYPzqy1099Fxf3jKCTjPXRfPotATQH9W
 laApXijL+3sd7c+aluT/U30WzdgkHdsTVvM= 
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2042.outbound.protection.outlook.com [104.47.74.42])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gg4wx8tas-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Jun 2022 08:35:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fLz1hEjZt4DlpIU8OAiBYf0gieau/hLdwQHjFark2IrSxNlkR5zeFiOcSsOqjYX5cpj65Bc/HEZb7SSG9X08rCZqd0lVA556y6csJSVlnQUfMT0d26wxFguUEUtIPbdnpqTT8IKOvIDhIWWFAqOK6949CII4gMLFR27oZy9Dmy5HsrHMXWb8Eg/AqBgvMhGl8yZlPm4faFYUdTK484rY/Vmgukw1uMvyEicrupta8bNFsnt+Qzt2USqBhBO6G3gONStdYlleMOIdwcTsHBdOndlu/H/hZglCgM+e/jQt6Bn+iwjuY5RVMofi9KY1pCiorKupV8O7eCZNfdpNWbTyhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cnwin2cjc97pDkSnxlS+eY+DvnDoqfdq3eWtkjS1lTI=;
 b=nALPcflrb9/75eacmwvzP2iF15taMi5ZDAMChDPeTM8VEt4nHS/fjje+oQdkpCt81k2uBcvc7GuM65b/WuWEHTUt+ACnoJHs0z5/9ZbjG38b397YoscN3KJ2/QiT9xeNcYye7+iMG3N8JQgQx89HFeVNQ9Z+t/y9eEQrbP77qStanvMiQV99+qfg4k02HZxJyZSW/He5UcRpBvtwYdb1rI7cJHtVxXP56QCTojMS5lADkyM/9b8++Jw7bTrV/JAmxsbBSTK3VGO3dthUivMY01yuPiZhXZM7R0Ma5LNM6lVb3XJND0nf8PQwTfr2cTp0NCvlI/JfJXzcnl+WbjE2UA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA1PR15MB5300.namprd15.prod.outlook.com (2603:10b6:806:23f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.15; Mon, 6 Jun
 2022 15:35:11 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::b9ad:f353:17ee:7be3]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::b9ad:f353:17ee:7be3%6]) with mapi id 15.20.5314.019; Mon, 6 Jun 2022
 15:35:10 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Jiri Olsa <olsajiri@gmail.com>
CC:     Song Liu <song@kernel.org>, Networking <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "mhiramat@kernel.org" <mhiramat@kernel.org>
Subject: Re: [PATCH v2 bpf-next 3/5] ftrace: introduce
 FTRACE_OPS_FL_SHARE_IPMODIFY
Thread-Topic: [PATCH v2 bpf-next 3/5] ftrace: introduce
 FTRACE_OPS_FL_SHARE_IPMODIFY
Thread-Index: AQHYdrjyXTiiEgEgK0K1BTZfHuJgSq1CDwUAgAB5i4A=
Date:   Mon, 6 Jun 2022 15:35:10 +0000
Message-ID: <CD3C77CC-8F99-4DF0-A7AF-25D70A99A4A6@fb.com>
References: <20220602193706.2607681-1-song@kernel.org>
 <20220602193706.2607681-4-song@kernel.org> <Yp24uOldsVIm7Fid@krava>
In-Reply-To: <Yp24uOldsVIm7Fid@krava>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.80.82.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 08576c19-05da-4c94-7cad-08da47d2247a
x-ms-traffictypediagnostic: SA1PR15MB5300:EE_
x-microsoft-antispam-prvs: <SA1PR15MB5300E9C2EAA9ADFFBEA3436CB3A29@SA1PR15MB5300.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YJ/rHPp9ohVL3BEIHwCnbTa8zCs+/mhrdCXH2cMm0nt/p/he4JnrD2+fK2jPR2WG+qqruHqk2zSWXGRbRMs+JAzpMZ33Jxg9n6ZU+ITwOSXt6q51W8dO/ELNQuZxQwFhqHEjxnXLhd34ddU9L0H5ihtSOP1rNxGNen06k8zEV0ghjWcWlJZG5jTZNXUhR2uU5lDfi2dYZ3CSu7BP24o0c3CR2ePuadF98tN3+CsvCgp46aJteA4ApFmOqiHq97zjlvLh1fUDFg8gNA6letqRIXW7UYyB0fVaNY9BwP/j35nFEPVf1/AgJaJOrhJtcKMEOkteNfnjltQSm5Bx7PaVT58RHepLV7NVdMuP9UtY8RJ8CinE8uW7qNZ9H7yulXruTgSUZ1cij1vXDzC7Cjb1zMu4C/nuNtTLQ/cuAzL7B2WU7rBAr7nUGt3cKgwf1Vvdi/myltNaXwz1fDoso/CQBSD2WL+I9pcgZ6Z2UVx89poTcKV+UK1kwCOCkHoyK7BRjOYc4Nk4cNAnS4h7Aah+CCOvZ65gnZDahkwmM3NRhW1FmtrGZQyEnGMVnGIlSJJdRZrKd2oEamGVMiK9fvCrIaqpXGfNWbD/M6dr2GtrhIXL/0Fd77wD/tC9+tA2696B2GeFZO4sqPhze+4K0V5JU+S5ABuy20NRXwBkNeKrjy5IXhFsaPloif05ZE3xyGLFaiZ/l6xce4je12/GIhBawcN33RFJiSog13cHreNAYfCPQoE/Pvf92LNuxnSUTdmC
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(6916009)(186003)(66556008)(8676002)(122000001)(91956017)(4326008)(33656002)(76116006)(66476007)(66946007)(54906003)(316002)(38070700005)(38100700002)(53546011)(6506007)(8936002)(83380400001)(2616005)(66446008)(5660300002)(6512007)(86362001)(64756008)(71200400001)(6486002)(7416002)(36756003)(508600001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?2jKNA5onM0Xq7Kuv8sY/vwkfrNxs8eD8Hst/2av8ZLO5Lda9jtmOLUM2lQd+?=
 =?us-ascii?Q?v/Uxz2qHqI9LiIZE2nvyN/Rdiu6yVCovanuEz6ZJHJCRtaHCaprkNSZyg9SQ?=
 =?us-ascii?Q?f71wzoPkv9cyycmg4bnN8GjGTjQIdlLW4lemsoqFUQGUSlQqyptiJUcad2KT?=
 =?us-ascii?Q?Zz5dawOcLIB+q7T8Kwq0UABeUvS8BiDs167GlBaw+88g2JG7BXcfkSYzkTiV?=
 =?us-ascii?Q?4RpTwRAxIJmm0FiPJK7QPE35FAKuwChw+5JmDHFuthK6xy/HTesiYVpH9mqN?=
 =?us-ascii?Q?zxrxw2eHYMTZ19Q9j/Ccc+NDrbcxErTt42AUjcSyyHq1rN2BaMUqZtguxydW?=
 =?us-ascii?Q?Fbbm0Q+PMxZ89aklwX9PaeDh9msTJgQUSTZmtPbQCbepprcE/ovd8z5COpvH?=
 =?us-ascii?Q?S51UhY4Mxvo4GFtZ+sYNdxdlA87XLJOWuxSTdV3KO3lHW+xe9cZCWSc7mISg?=
 =?us-ascii?Q?Cbc+ACXc8oIGidtWQ+2p8fSOWd/ufyt0aJyvdKrRJ6xbQg3Wk/HPW4ZLUbHK?=
 =?us-ascii?Q?PpZdlz5e1SViGafQJkFpjDWQNhWgXFbu+DOobX9XBhpmR433jEpIVkfnyrZ7?=
 =?us-ascii?Q?/Ks1unmjCtkCKruhfT80K4UFUerEpZm9p7n3csqSUvELNMeqWpdAI9eyLGtv?=
 =?us-ascii?Q?S41zqHMHg/aVDP07l199250jO9VaynA/pCzWt/S4HpYaAV6EQ3jn/E+dLO4F?=
 =?us-ascii?Q?UjaLPsPYRD5CSAiPD0iUf7dA9q2LAK8zTniY4nqjF+WBZgIaU9i5ZziqcfgE?=
 =?us-ascii?Q?1mHPDedwSwjQ37HWmZo11UWW1GBotgcIIyIFhBlkWU94xDVK/hNc3rnMxWAy?=
 =?us-ascii?Q?v1r704zIkGbtOXH+HQmaP/4Lpz0kpr8Bq3Nr6ku3DZP0KOF0vMWrLxIFaaF7?=
 =?us-ascii?Q?ETTK7ZeqOlXKvBj4nOE3MtRkNwEW/AgSUOqVI8NjQWN14TjXze1sACIyWsfp?=
 =?us-ascii?Q?wl3GqS8J+BMRcn6FyOjeXro0RgjNBVpcUgXokFTIIt6XrPWFN6E3uO/GLvgI?=
 =?us-ascii?Q?4c4YPI5+QPCRMV5tewsnDORBTdicychykvJsIbSG8o+G4eNLt5ODs0zC5bNV?=
 =?us-ascii?Q?m8xQg/bLq0FvM614VdHSjMBcCVYBx4Sm4GLdVKe3lYWH0tfO2yM0bdjRApFO?=
 =?us-ascii?Q?ZL+WLz9AZSwFAEzMxTNXsy1eby7EO6ZNdn0XEjPWZVHDt9VSYYIkoCm7cAvc?=
 =?us-ascii?Q?alV1jiQ9eMCe/6sAik1KHhIEIAA93LnXtC1u3PXDkpMtd4ExG+1g8vBI6DwM?=
 =?us-ascii?Q?lJ07ObYs8QXHgCAvABbgE7cdGMVAHm/DHgrgLbLDXF0DPBF4WS8ox1rQAv16?=
 =?us-ascii?Q?JvgzPNiv0eG5AafMsrQJ/TbK0MgKn5kRqwE19ME/vWPKJsx9X3/BFwrtmZQ3?=
 =?us-ascii?Q?gbq1de26aVFmzpoklHTpjj4rLjNHjv6N320LM3zNVBit7B4g0plyYzQidBjw?=
 =?us-ascii?Q?9x5sT8kQn/oILfdp3HWy6DlxbHMJC+YrkCmns4AbTtD1XSSPEm4SRTTRPfxd?=
 =?us-ascii?Q?kYFY6pTlnlyB5C73rsJoYPmcoPhRIjYAYfkAd6tDU9WM5WUMG3sAnFtHHLoh?=
 =?us-ascii?Q?i9RazTBh4UqafLpP3Z77LctKpqkd1hJ1dtnU1S6e0B1LqsMW6nRxJLSiYQoc?=
 =?us-ascii?Q?/5UAYWV49pgko0VkP6msJ2TWWhasrkZyqiiOr+GR8fqi2UmddvgEz2+WurgZ?=
 =?us-ascii?Q?RBeCQrDpBVv0piEjTSw6kUZkRPexw4Wsu3HyVJHUvxBLdwDxZshNIn3pLrtX?=
 =?us-ascii?Q?16Si/FCJuMKd7ez6p0fAp4zqjR+xKHomuSaJ7ahstSH4MY4fI7Oq?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7F81AFE034A5194292EAF65868D0935E@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08576c19-05da-4c94-7cad-08da47d2247a
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2022 15:35:10.6901
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dNie8V2KXC8DDiFYxhlI4ihW3DQQVPyoSC6LVGcUovLRIN2Lx99Pe5vKl/4rpCEAAJBZ9F+HiJiakjaaQzyu8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5300
X-Proofpoint-ORIG-GUID: Xy1KrGxMyh3j75zY4K3Zs1mIB6x5ccp-
X-Proofpoint-GUID: Xy1KrGxMyh3j75zY4K3Zs1mIB6x5ccp-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-06_04,2022-06-03_01,2022-02-23_01
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jun 6, 2022, at 1:20 AM, Jiri Olsa <olsajiri@gmail.com> wrote:
> 
> On Thu, Jun 02, 2022 at 12:37:04PM -0700, Song Liu wrote:
>> live patch and BPF trampoline (kfunc/kretfunc in bpftrace) are important
>> features for modern systems. Currently, it is not possible to use live
>> patch and BPF trampoline on the same kernel function at the same time.
>> This is because of the resitriction that only one ftrace_ops with flag
>> FTRACE_OPS_FL_IPMODIFY on the same kernel function.
> 
> is it hard to make live patch test? would be great to have
> selftest for this, or at least sample module that does that,
> there are already sample modules for direct interface

It is possible, but a little tricky. I can add some when selftests or
samples in later version. 

> 
>> 
>> BPF trampoline uses direct ftrace_ops, which assumes IPMODIFY. However,
>> not all direct ftrace_ops would overwrite the actual function. This means
>> it is possible to have a non-IPMODIFY direct ftrace_ops to share the same
>> kernel function with an IPMODIFY ftrace_ops.
>> 
>> Introduce FTRACE_OPS_FL_SHARE_IPMODIFY, which allows the direct ftrace_ops
>> to share with IPMODIFY ftrace_ops. With FTRACE_OPS_FL_SHARE_IPMODIFY flag
>> set, the direct ftrace_ops would call the target function picked by the
>> IPMODIFY ftrace_ops.
>> 
>> Comment "IPMODIFY, DIRECT, and SHARE_IPMODIFY" in include/linux/ftrace.h
>> contains more information about how SHARE_IPMODIFY interacts with IPMODIFY
>> and DIRECT flags.
>> 
>> Signed-off-by: Song Liu <song@kernel.org>
>> 

[...]

>> +static int prepare_direct_functions_for_ipmodify(struct ftrace_ops *ops)
>> +	__acquires(&direct_mutex)
>> +{
>> +	struct ftrace_func_entry *entry;
>> +	struct ftrace_hash *hash;
>> +	struct ftrace_ops *op;
>> +	int size, i, ret;
>> +
>> +	if (!(ops->flags & FTRACE_OPS_FL_IPMODIFY) ||
>> +	    (ops->flags & FTRACE_OPS_FL_DIRECT))
>> +		return 0;
>> +
>> +	mutex_lock(&direct_mutex);
>> +
>> +	hash = ops->func_hash->filter_hash;
>> +	size = 1 << hash->size_bits;
>> +	for (i = 0; i < size; i++) {
>> +		hlist_for_each_entry(entry, &hash->buckets[i], hlist) {
>> +			unsigned long ip = entry->ip;
>> +			bool found_op = false;
>> +
>> +			mutex_lock(&ftrace_lock);
>> +			do_for_each_ftrace_op(op, ftrace_ops_list) {
> 
> would it be better to iterate direct_functions hash instead?
> all the registered direct functions should be there
> 
> hm maybe you would not have the 'op' then..

Yeah, we need ftrace_ops here. 

> 
>> +				if (!(op->flags & FTRACE_OPS_FL_DIRECT))
>> +					continue;
>> +				if (op->flags & FTRACE_OPS_FL_SHARE_IPMODIFY)
>> +					break;
>> +				if (ops_references_ip(op, ip)) {
>> +					found_op = true;
>> +					break;
>> +				}
>> +			} while_for_each_ftrace_op(op);
>> +			mutex_unlock(&ftrace_lock);
> 
> so the 'op' can't go away because it's direct and we hold direct_mutex
> even though we unlocked ftrace_lock, right?

Yep, we need to hold direct_mutex here. 

> 
>> +
>> +			if (found_op) {
>> +				if (!op->ops_func) {
>> +					ret = -EBUSY;
>> +					goto err_out;
>> +				}
>> +				ret = op->ops_func(op, FTRACE_OPS_CMD_ENABLE_SHARE_IPMODIFY);
> 
> I did not find call with FTRACE_OPS_CMD_DISABLE_SHARE_IPMODIFY flag

We don't have it yet, and I think we probably don't really need it. 
AFAICT, unloading live patch is not a common operation. So not 
recovering the performance of !SHARE_IPMODIFY should be acceptable
in those cases. That said, I can add that path if we think it is
important. 

Thanks,
Song

[...]

