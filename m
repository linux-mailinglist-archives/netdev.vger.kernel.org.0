Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE7374D6A16
	for <lists+netdev@lfdr.de>; Sat, 12 Mar 2022 00:26:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbiCKXHP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 18:07:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229868AbiCKXHO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 18:07:14 -0500
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6997610DA49;
        Fri, 11 Mar 2022 15:06:09 -0800 (PST)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 22BICE39026795;
        Fri, 11 Mar 2022 15:06:08 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=+Kjp7Z4DbSWqbCpfqIebrnTI8uLKTcJqL1e4sbTKBl8=;
 b=eMMAQVTTsoKSq4fJ7aaThnQcqGj555FjWE6XYoRt8r6Owk1Mv1EcKIWULzed8FA0khJ2
 ffR7KNLXUB9jINbJIj28BvgY5R5TndfDpLbB1Br+XFb1+C+YSwHB1PfHTLU7k8/IOUnI
 Xv+EX4m8TS4OljDKR2N/XrR6rFu81R3zMpc= 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by m0001303.ppops.net (PPS) with ESMTPS id 3eqj1ece8e-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Mar 2022 15:06:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y1Y3Pl4wzD+auC/Me6iHuBQEdNp7mWdcW1UvN+OMNE4E7cU0XyWEoL6K7AOxMi43Q6hQ1ptltevD/w6SGm6rC/eAxRIE0+SErGvxsvDXoq42IHAz4xGRRXifISALPM1eFdVCeJsAjd0c4QwwaRJQMBuY1u3GapuxKyrQ1eT9Z36AWIKq5e9oH5jD9SWBUu7miwRVjNTQwaZLIWkFzPZbrYUkxrParmuM4DLH8XUGt3UQZX5N+/Ye8FDxXIn3nJ7cWc4y98ir+qGIcpwfd64wyY58Dx/xgvXFhMA7ty7BSODCG5XRnh4peFnGHBJ3vQnmZiICb0B3J2Psu3yOS2UGEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+Kjp7Z4DbSWqbCpfqIebrnTI8uLKTcJqL1e4sbTKBl8=;
 b=bkXmXoN2npRbVlS4tbiyojp0TQTCAxQ7HiunNh72NQqa2LDe6mXC2YG1P+D1JpY94R+uhvKXvmn7S8OQ1b1tSQAqAT6l7jpFPTh+9dEmB4V8r/iM1DqN/qRS7CDC+RKVZPw8ANnDNnxX1wJLMbnQfqFu06yYrVD/UrhaDz8Mc/TwQwRWd3+V2zIXd7Wcq/efgz4yAOOdbDvrALxWJwHUAZGvS+hKrR1dJ17PwoBjKB0X2eSwIbYtV1CnlggIm491UBKPcIhwpLlyCC2yg99Kj+bH+8SyONAtDK1uq56y6TX55fUcIlRk/m/IN74EKyOkLvw6KH5OVAYHPgJGnZWiaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by DM6PR15MB3925.namprd15.prod.outlook.com (2603:10b6:5:2bc::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.22; Fri, 11 Mar
 2022 23:06:05 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::7da4:795a:91b8:fa54]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::7da4:795a:91b8:fa54%7]) with mapi id 15.20.5061.022; Fri, 11 Mar 2022
 23:06:05 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Song Liu <song@kernel.org>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "edumazet@google.com" <edumazet@google.com>
Subject: Re: [PATCH v3 bpf-next] bpf: select proper size for bpf_prog_pack
Thread-Topic: [PATCH v3 bpf-next] bpf: select proper size for bpf_prog_pack
Thread-Index: AQHYM+Sz/hYoTurA9kmmpvPwSLQOKKy60WGA
Date:   Fri, 11 Mar 2022 23:06:05 +0000
Message-ID: <F9126AE6-B59E-41A0-A9AA-F5B8499FF0B4@fb.com>
References: <20220309183523.3308210-1-song@kernel.org>
In-Reply-To: <20220309183523.3308210-1-song@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.60.0.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f974378f-45e3-4afa-aa67-08da03b3b8a6
x-ms-traffictypediagnostic: DM6PR15MB3925:EE_
x-microsoft-antispam-prvs: <DM6PR15MB3925A08649C78D3DF6FE5EC1B30C9@DM6PR15MB3925.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: E2KwRYtDxAwWoDsUdvb69WPPesdBxtq3oLrgOasmbXNFkFkbNEu+lSkNZbSK/3w9GvZBIqSCLIjkpsDtmMePMz8DLbw9YlIwars9Zh6ruEGpY2eyIKYHDfzfIbUzl5sXA4eYojwwAjJKR494ke2yU3DNg6kCQajpsmlMxfF5i1FF6DXP5HqyT5zlejyH9U1RpQCZ2vc3Ys1erQiNVa7EtA1EgvRaBUmF9N8dsLfyE/hYZPFi9VepPENzZ8a3Rr6kuJtpk0t6vf33bcdKHeRxjguf1YODe4EEj0TFnhIVSbw8XD4qmhAIpW+JDGvS9eOBKL0PZRz4w0FmYm5iSRNUGdO0jkP60umOwHkj57dSp1PGBbMW5l1A8DtB9e/YjCOw1IFlGiXUuo7lR8s/BTNNoLLmW7yi2zuU6KJuGO6yg+j3iTR996KkzPIVf/stGmYvdwmA1/szACZaBzOWowcoszWDCk7zPr5tXBcWrF10uEUdOLycerqu8zND2TxOCX7LEW2ERF4/ALIJFIvG6fEo1X7ETT6Yd8tisCmdRWnRkuqfk5eTT68ihqGmq84SUq1mn0NGab6p9DmxgcQpf5yuNAvrbfCHvDTgJ/P9p69V0DNNNhJWr1gMGVGxerVHhO8Kf83/vi+bgvUyXqDxHTgGryh4hucRJp7zXSS9raHaKkd4W9GpUxTsaRLmedzpbvdjfYcJ0px9PL/QVlvIGv6+L8K+BmHDHBXyhTvEEoKDiHy0Jb1RQ3pQTVcbiBoIx6mfAMyttyQQPsNFoliE90Mj2+3FZr/Us/+dXk0Wgf8A0Y0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(76116006)(91956017)(316002)(6486002)(38100700002)(71200400001)(508600001)(66556008)(83380400001)(36756003)(186003)(33656002)(2616005)(122000001)(2906002)(66476007)(64756008)(53546011)(5660300002)(66446008)(4744005)(66946007)(38070700005)(8676002)(4326008)(6506007)(8936002)(6512007)(54906003)(6916009)(86362001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ZeuD46ug3QBVLiZVZ1moVhu1usqm0ofYoPfF9Y+1xHthT7vZ4CIiuvX/KMQt?=
 =?us-ascii?Q?EBzpUgzL7ap4GEVhA1in+d7xcX+LsBIiXoc0iHWb+vUy6l5yBpLnuW3hBmMV?=
 =?us-ascii?Q?Ou58l0jXdi2bZxBhd91sOUnydPBHCkUTH3XOQJ4W8OSOBnGzSK5N3rpMHwj1?=
 =?us-ascii?Q?QSBRSDGp3ybkNZ3uYFDHWUTb/lke+8wsdr4KOeWgw3JOcqSz9HID2MwasHuS?=
 =?us-ascii?Q?W+xDw9rZUH/rjix2PtpZxGVbrjcPvcUu1Nm5hNpHdeoGu4J4uU0KudU2fuMG?=
 =?us-ascii?Q?/XIxW2jHiItou4QLPXS7vQ1cgMYl9386DnAN49hnvsL/Any8mLHH+4BZ+uUK?=
 =?us-ascii?Q?EuuRH7f52Fv7rd8elhBu6NEDKbeDHQMisG96P0LLcFSgDeZtUMkpoq2Ayt98?=
 =?us-ascii?Q?YvshjCNcZdy9AD54GlRSQM31eTbA8weM8lXg0caMPgiwEiTP3t1mYIMv35V9?=
 =?us-ascii?Q?nh1VgWBSft31mbq9hJq6gq9o04NZVP0q31qaceoOl/+oKjY0/Zj4lAqLSN2N?=
 =?us-ascii?Q?TiZSPFx1GMNF8podNc0yn+G/n5cBVOtc39IOF/xyxFUW9CywwfmAS1LQtxyH?=
 =?us-ascii?Q?Vh0wLLMiJOh2FY+aGWKmGv8iRXD1k6CAPHeTMZzI0Uh1BHl1PDPbBwbJ9emu?=
 =?us-ascii?Q?rUFuIcTbnuoh3HQvxDMC3r8ef4vR2JMKsmYcvf5wv8Niw0GOycPTeNGx6p4K?=
 =?us-ascii?Q?OmzYU0JqLt48C1elkeNOCHkmfYKlIhM04LcHL61FuSpkTUAAaz87K29Lh5Wa?=
 =?us-ascii?Q?99fIlZZ1Xdpw/j3oh11/CDx6BPDVkEXsp5VRqjzTeJJgmkzPhzAwJ77dh21s?=
 =?us-ascii?Q?8hKDnQXQ0rv2tSSirK11CBEstwl0DRQwO55ZYg+UISUj5Q5u21lKhW4H4UoY?=
 =?us-ascii?Q?lPR5M6Z5PDZAuBs0mNH89ZCgBLUkIDOjnk8e/Bpw+vXSrhflREP4x/dpSJsr?=
 =?us-ascii?Q?G834LBt+efjXpmHKmNTERhS3cKH5OPFIl/3fYQ05nOFn+EZZ1Otc//wBqJTU?=
 =?us-ascii?Q?XO7dl3dmf1hfcKValfne0uRv6szq8WDRXiBwOotfIrAX88QkTgYdpxBMop43?=
 =?us-ascii?Q?8NF0k5KPhO091jsZFoYJwgudhOC5X/A8UhpW2LR8JpWH/WsEYcPbZVMWCcPi?=
 =?us-ascii?Q?mvQ2JyRh9TwXWn1/uWRuu0v9RLoyzruK1qO/3BnkH76MvhgdXzEGopah38JC?=
 =?us-ascii?Q?CtXOASghb+wKTT2tz59Oy/6PkLr8kB2ie5lYnS5qBA7CAmgJT2VQaIzTqTX1?=
 =?us-ascii?Q?PNeXnQVtLfibhSavso9r1m4tapBAt+t+NA1UCFa1deV1HdjM4QkPLx8o5zlC?=
 =?us-ascii?Q?Cgfn6oR3OjUEcVc7e1tEE8HzyYyyk2fT+yZBj3c0BnO2GXwak9roZW9Tn+hT?=
 =?us-ascii?Q?q+cfqePSokNjGbwbQyYD+Cw3WIbbPUYfwq8AxbEm0pHgg4RsrgLQgYPrXPQr?=
 =?us-ascii?Q?Umig9cFgvNmQaZxAv601oP5GYyudyywAiRxscTFnxR29/Zsi1/O8OaXWzdCy?=
 =?us-ascii?Q?CnnIcra6wjQ+V6k=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F069D4EE98C4DE4AB3B26DB51C9D5010@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f974378f-45e3-4afa-aa67-08da03b3b8a6
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Mar 2022 23:06:05.7525
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4SW9rjs6Gscqtgqp5cGIGZfPSG70v1eY4ReCwNDLsqE0eE3X9lnUuNJT3Xm/LU9Q3CBO5qFx7IFq+hsZsIs1Ug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB3925
X-Proofpoint-GUID: zQ5DwjAdczcVxBwbCmtMN1dtBM-gEDXK
X-Proofpoint-ORIG-GUID: zQ5DwjAdczcVxBwbCmtMN1dtBM-gEDXK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-11_10,2022-03-11_02,2022-02-23_01
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Mar 9, 2022, at 10:35 AM, Song Liu <song@kernel.org> wrote:
> 
> Using HPAGE_PMD_SIZE as the size for bpf_prog_pack is not ideal in some
> cases. Specifically, for NUMA systems, __vmalloc_node_range requires
> PMD_SIZE * num_online_nodes() to allocate huge pages. Also, if the system
> does not support huge pages (i.e., with cmdline option nohugevmalloc), it
> is better to use PAGE_SIZE packs.
> 
> Add logic to select proper size for bpf_prog_pack. This solution is not
> ideal, as it makes assumption about the behavior of module_alloc and
> __vmalloc_node_range. However, it appears to be the easiest solution as
> it doesn't require changes in module_alloc and vmalloc code.
> 
> Fixes: 57631054fae6 ("bpf: Introduce bpf_prog_pack allocator")
> Signed-off-by: Song Liu <song@kernel.org>

sigh... this is tricky:

# CONFIG_MMU is not set

Will fix this in v5. 

Song

