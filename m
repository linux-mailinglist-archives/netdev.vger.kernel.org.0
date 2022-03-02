Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C0F74CAB7D
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 18:24:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243772AbiCBRZe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 12:25:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233594AbiCBRZd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 12:25:33 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D7D7CA313;
        Wed,  2 Mar 2022 09:24:50 -0800 (PST)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 222EqvrI021281;
        Wed, 2 Mar 2022 09:24:50 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=f8ZG16TZncATxn93lOqqM050dx/pBw2zazkUNOvjBR4=;
 b=EaYew4D/zgOY9aAvkDHqUclvbDBRitnx4pV6Z5xUwhqYk0yqBQo3/cvlPLazQwv5pF6P
 6X9HpVW+loGBfjtkYl8D5ImM9kZ+n/+QuHTBW529QZOSuayMdWhv5JgyKiDI9tIRNlRM
 77bixwFWb6t0GRi8OSDGww8jfXlQiGS1DE0= 
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2047.outbound.protection.outlook.com [104.47.51.47])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3ejaqws586-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Mar 2022 09:24:49 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gPP14g90Prx/11W1+4BJyu7nWhRSn4donTavXW5u6Vuwip2D9ZblflvJ53yiiOOU3xTnyOiQwz3zILKN32WmzzXhGPD3AXmuys3CxZ/i5BC32KsfilMgRS7eVrz7VxtM2tE2Tg6nz6VRvCYICWax4dykIQOx8+PLrLFoRTAHTMGti3f9G0dwIPyuGMTnXEPHgS1IBncJCbWxZYo/R3F6P9tudIJ0F1lgdse54XEqpP6kkb3R+VYNQptypJwci/dCjSa4fat2AMwuzENtn6V9YVxNATEUbYaoOAlblUlsHP4QbmVmsjrYtYKq0X5ytfPI/zY/HkFebjshKYHHsjgF1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f8ZG16TZncATxn93lOqqM050dx/pBw2zazkUNOvjBR4=;
 b=Xlz+1oKd9ApeY53tpwApVYL4hYxe1NwIDtudIPzCqpEWCh43MZfW+WLbJjT9hyVcRtHIL/a3zI8F0Jqy7NN/j0Kj11v8NJ/v5euv3iaPKFOtjwunkxoY7CD8UqyRn+l83MIp9RAPtRL8X8n6QzR4lkgeOSQnw+if+DuDZluc0P2f8jO7hY5PfYcxWnma2OVC1GBzpVhYBUEGSRpoA/UTff9UO9MmQWEzO5TO4p09HJQrzmbBrDrm+KeoiDyv951fsSFTqugUeDRACovqgrK+cn+If5lMa7FXZisblK5p6PbT4HiS54il4/indFycOFphfo2bD1SlEV6ZllwFckQ3CQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by MN2PR15MB2640.namprd15.prod.outlook.com (2603:10b6:208:12d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.25; Wed, 2 Mar
 2022 17:24:44 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::7da4:795a:91b8:fa54]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::7da4:795a:91b8:fa54%7]) with mapi id 15.20.5038.014; Wed, 2 Mar 2022
 17:24:44 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Yonghong Song <yhs@fb.com>
CC:     Song Liu <song@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>, Kui-Feng Lee <kuifeng@fb.com>
Subject: Re: [PATCH bpf-next 2/2] bpf, x86: set header->size properly before
 freeing it
Thread-Topic: [PATCH bpf-next 2/2] bpf, x86: set header->size properly before
 freeing it
Thread-Index: AQHYLc6n8kvYfnXc6USIhZM3zMX4Yayrrh+AgACrFAA=
Date:   Wed, 2 Mar 2022 17:24:44 +0000
Message-ID: <3CC742A6-36B9-4D8D-B801-9700660C9E6B@fb.com>
References: <20220302004339.3932356-1-song@kernel.org>
 <20220302004339.3932356-3-song@kernel.org>
 <dceb436d-76f3-208f-3f68-d7d614259360@fb.com>
In-Reply-To: <dceb436d-76f3-208f-3f68-d7d614259360@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.60.0.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 38f45d73-7a92-4d5b-86be-08d9fc718b4a
x-ms-traffictypediagnostic: MN2PR15MB2640:EE_
x-microsoft-antispam-prvs: <MN2PR15MB2640B4314B4C79175E95BE0AB3039@MN2PR15MB2640.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: l3usoTfCya1aUgf9393cEJ+23jMpVwOVZ4yk9IvhbR6klpYGoPK96m08/n3C7/matpvoDGQ7HAC5V3uHBK/Es0aPbW2EVmz1vmBK5N6DG1q1jVFo+65fLVCGqdZoEdjlEmOeb8ixzs1/f1VIc1uIfcbZbOhhngayzCF3597zJy1YWRmeqRjA4GyNlXZ1UaTDT6laV5+ZcwpBM4B8vMMd9lULYfbRg9qn62w2IsamELKPQjXMLQ7PGnKHbdIbSk8a+x/+GWemQU0WeiWOWbse6L063haElwHBO1zUGU5BLlXrYaXjfNhwiH03f0Y3l1uSgzNgCJmU9KRid+4I1u84FarN+jdgFkp5ut9r9/EMJ6lf12cteggbmnqQkztWFHuTo7I6939IUAshEEr3lQ5USAwpk1MALyI+oLj7sbO53NwIWwEf3okLT1rctuT6Lvvj9DKNvbiyeK2yMVWfiw3/trg1BnXnKF1Wab8B/5CZwLXz31SGzjBtDARL9xujbFHX8RMg8C7E+oeWQ8dTeFL3+zEIsxqKVdaDSPq9FFyS6UrukDyttqe7ypDV0s1cKgkHJBExhDrxdpRa7aHWLtRDIhCr0FR+ybYQQf9sOnJ/tLVthFUmtspmi59T1teFXzGfwaFBztTgrvnucTxRD5rKb9D52vBbhvKMszLyV+aka30QRsJpaDVgchOevDRGO/xrunWHFSftXUNBui7218VHsTlY0iggg9+sR1514DUnRXCGq2rMxD02s7Vp5Or96D4C
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(86362001)(54906003)(6506007)(37006003)(508600001)(6486002)(36756003)(33656002)(6636002)(71200400001)(122000001)(6512007)(38070700005)(38100700002)(316002)(53546011)(186003)(91956017)(66946007)(2616005)(64756008)(66446008)(2906002)(66476007)(66556008)(76116006)(6862004)(5660300002)(8676002)(4326008)(8936002)(83380400001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?GRabdqGAf//MlYtBb27x1gJkhXOQSBNtx4wO69noaG1q3vzBIF2fWHxAkOiK?=
 =?us-ascii?Q?hBnvWj/ujYdeYzzKvxhkXACFs9lvsKHjTHUNVYXERkE5X+sOr5DEA8bgYcGn?=
 =?us-ascii?Q?gFAjmMtZ8lUCAW2TNwsEeHqr77TqwjQMGB6qV9nXf+E/JKF8liesF9YPGZnx?=
 =?us-ascii?Q?Vf8RW8vI8f5gGHt04iEqlKtcrjzKv3S8F28HkDSygAQsAVwo5YMfKx39zZxJ?=
 =?us-ascii?Q?H9/lVjwB7u1+XjYhAyYJ2iHfjuEdf1hFTdBPtK9B7o24OZkIiYRvH36B+7ik?=
 =?us-ascii?Q?FWtRsnem9XESMnXIELjFLltStl922NnGnYEdCH+EemogStvghvptqfU+M4Cb?=
 =?us-ascii?Q?cw7DapWMEC0Y5si6jYztd3fOQTY4BJf2C6DvnZB87es0MsrGSAwQYU2MKTeG?=
 =?us-ascii?Q?UW7V5zWU4g68bOCBV4ANLqb81bWvfVhp6hdLr9dViOwaxJJFIk1GjKPHxyaJ?=
 =?us-ascii?Q?+RWljbPunf0BmiQQAAY53EPcv9tZEL+9QtUa976KSQ0wnDRAaq7unJsJ803u?=
 =?us-ascii?Q?FrRVDzdywrLiiugAnd3FcHvCjfN6hvdexfp5fECcOw0o/LoVkjNm98Hjhrpg?=
 =?us-ascii?Q?BQ3BXdtswGlTysZ99m55Ceu9t9XOQ22Lf+56SxpNUgheC/ZiBDZXl1Ox1o3z?=
 =?us-ascii?Q?zvNP7tZxrMkrqIwcngpDYwE+RK8nuF3ZiXbfct9fc46Y+opEs8B5O5H05R7O?=
 =?us-ascii?Q?/Df9pw/sGAY7xt10Yua2OJv91GqUEkBYy9jPmHFJi3NT/nxf73CO1VSexfsR?=
 =?us-ascii?Q?apQ/sBH6k2GticG89pZVZ6eq1e8W9M2TTpG65VOAmckD+bSjGFuaqb3TM7mj?=
 =?us-ascii?Q?KFKJcPZyFNswhaSbRQYuciIY9LQmBslXd8WvuoRGR+kcVZowiSzxykxbTsjM?=
 =?us-ascii?Q?zJxVUw6+7RAHWKKu1nQJmXSGhhq5PCr/FM/T8ZYjxEfwQRqErPc43Bhqj3/v?=
 =?us-ascii?Q?+ZlSkMqoIXY7uH2i/S/HvNW0w5JXkpuXWSrAVNQpAHiVz+kfkAm4YbcdlToj?=
 =?us-ascii?Q?L0IJDz4bLZ6g0MNs6NdKsb1paojmPPijqWK5qV5eXhHzMkkKx4BVkQ5IWK03?=
 =?us-ascii?Q?AiWQPVqGvDzsjYeSTFSpQFI3N31vbWnqgTLvQp8qKDPgIy/6dbK/GqsWB4Mg?=
 =?us-ascii?Q?XpnRhNW98Vm3jZF7NoFsV67wVUW08oL5sB/Ppb0yrkVC+/jcyw9PJbk4lx5H?=
 =?us-ascii?Q?SoJ4g8kceO1LSkAtOK2RMhG3ZleRe/y869sBE0HpoTwwJ0x34ioFQJcCLuAx?=
 =?us-ascii?Q?klO3Ujez8J9B72KNdVgL4jqEuU4/RmLtBuci2Y03QL+UKT6X5gq2lJ2Ji3lO?=
 =?us-ascii?Q?YbeoCbdVO4L2qdlnRvvg5KkPdWK+AgaLYUQprMTh2kFXMxCrrCRc/31GX64W?=
 =?us-ascii?Q?gIsWrHyBqHSryWkLfVKgCwFJoDZ0xJMk3JgTMuh5PQT/v9PBvQ4qpxANvXXC?=
 =?us-ascii?Q?vnDuikZBywSp7RcQYx9q8jhl4+7laQLqL1yqUerDc6aCKuVHtPfTAfimRbZy?=
 =?us-ascii?Q?/kB8J7Pkl6M5xjaIozxCVbaF0+jR2g9MTRORkUtxPGVcxLK9GFH+hXwDIwAS?=
 =?us-ascii?Q?fa8tP93f2ob8xBDy9uLiNFdDlitm6lkP1Qw8+sNZsMOB+xbkgBo99CKmHGzj?=
 =?us-ascii?Q?+utdnTn7cwoAEQp+UixbcqltZcPi2Ep8oBe5CdxP/zNBioBVsC/2iP5PJ+mV?=
 =?us-ascii?Q?0m2uUg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C36223AD22A48144B920F108E838F738@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38f45d73-7a92-4d5b-86be-08d9fc718b4a
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Mar 2022 17:24:44.7119
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /N4k6yDwn69ZF77fFC5/YcMOF1b6DO5SyTB0I6wNMMVJd+hqkdmsQFv01YQ5ImYn8OJfgVunZrj6tPu8w+s0ng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB2640
X-Proofpoint-GUID: 6b6_xxZ74dxF08eLiasfch4CMKgWxRAn
X-Proofpoint-ORIG-GUID: 6b6_xxZ74dxF08eLiasfch4CMKgWxRAn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-02_12,2022-02-26_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 impostorscore=0
 malwarescore=0 clxscore=1015 priorityscore=1501 bulkscore=0 spamscore=0
 mlxlogscore=917 suspectscore=0 adultscore=0 lowpriorityscore=0
 phishscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2203020076
X-FB-Internal: deliver
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Mar 1, 2022, at 11:12 PM, Yonghong Song <yhs@fb.com> wrote:
> 
> 
> 
> On 3/1/22 4:43 PM, Song Liu wrote:
>> On do_jit failure path, the header is freed by bpf_jit_binary_pack_free.
>> While bpf_jit_binary_pack_free doesn't require proper ro_header->size,
>> bpf_prog_pack_free still uses it. Set header->size in bpf_int_jit_compile
>> before calling bpf_jit_binary_pack_free.
>> Fixes: 1022a5498f6f ("bpf, x86_64: Use bpf_jit_binary_pack_alloc")
>> Fixes: 33c9805860e5 ("bpf: Introduce bpf_jit_binary_pack_[alloc|finalize|free]")
>> Reported-by: Kui-Feng Lee <kuifeng@fb.com>
>> Signed-off-by: Song Liu <song@kernel.org>
> 
> LGTM with a nit below related to comments.
> 
> Acked-by: Yonghong Song <yhs@fb.com>
> 
>> ---
>>  arch/x86/net/bpf_jit_comp.c | 6 +++++-
>>  kernel/bpf/core.c           | 7 ++++---
>>  2 files changed, 9 insertions(+), 4 deletions(-)
>> diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
>> index c7db0fe4de2f..b923d81ff6f9 100644
>> --- a/arch/x86/net/bpf_jit_comp.c
>> +++ b/arch/x86/net/bpf_jit_comp.c
>> @@ -2330,8 +2330,12 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
>>  		if (proglen <= 0) {
>>  out_image:
>>  			image = NULL;
>> -			if (header)
>> +			if (header) {
>> +				/* set header->size for bpf_arch_text_copy */
> 
> This comment is confusing. Setting header->size is not for bpf_arch_text_copy. Probably you mean 'by bpf_arch_text_copy?
> I think this comment is not necessary.

I meant to say set header->size for bpf_jit_binary_pack_free(). I guess it is
not really necessary. Let me remove it. 

> 
>> +				bpf_arch_text_copy(&header->size, &rw_header->size,
>> +						   sizeof(rw_header->size));
>>  				bpf_jit_binary_pack_free(header, rw_header);
>> +			}
>>  			prog = orig_prog;
>>  			goto out_addrs;
>>  		}
>> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
>> index ebb0193d07f0..da587e4619e0 100644
>> --- a/kernel/bpf/core.c
>> +++ b/kernel/bpf/core.c
>> @@ -1112,13 +1112,14 @@ int bpf_jit_binary_pack_finalize(struct bpf_prog *prog,
>>   *   1) when the program is freed after;
>>   *   2) when the JIT engine fails (before bpf_jit_binary_pack_finalize).
>>   * For case 2), we need to free both the RO memory and the RW buffer.
>> - * Also, ro_header->size in 2) is not properly set yet, so rw_header->size
>> - * is used for uncharge.
>> + *
>> + * If bpf_jit_binary_pack_free is called before _finalize (jit error),
> 
> Do you mean bpf_jit_binary_pack_free() is called before calling
> bpf_jit_binary_pack_finalize()? This seems not the case.

Now I see this is a little confusing. Let me rephrase it in v2. 

Thanks,
Song

> 
>> + * it is necessary to set ro_header->size properly before freeing it.
>>   */
>>  void bpf_jit_binary_pack_free(struct bpf_binary_header *ro_header,
>>  			      struct bpf_binary_header *rw_header)
>>  {
>> -	u32 size = rw_header ? rw_header->size : ro_header->size;
>> +	u32 size = ro_header->size;
>>    	bpf_prog_pack_free(ro_header);
>>  	kvfree(rw_header);

