Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DB1A494690
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 05:48:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358534AbiATEsU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 23:48:20 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:14984 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229952AbiATEsT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 23:48:19 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20K0eKSR025094;
        Wed, 19 Jan 2022 20:48:19 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=pI2SPcOEm5aQDofrTLFflE/6XR4sJ4PNsmRY9VTGz8w=;
 b=V4HhFl/npjtY/o84OjgzDpjJHH7GMN28ekxhm16dZubxy7qS0vD5+l/Xoj9+nrb+1y8S
 4vxd6GY7tl9qTB7DP6lb5KASW3XqKyGfUGEcGu6jx8JgsoGiPp7PpXXe20WjECSlbHLV
 UjzF7DsAG/MkWtHtgEGJQvnxOCn1ukmdYFU= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3dpad4027c-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 19 Jan 2022 20:48:18 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 19 Jan 2022 20:48:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KR3twBkSkTwyJRUokDJH4/XJ5lTPGXUsuBQPsZvZ2MuhaimJDEi9PEAUjkosF7yp3gZxj9HlS7vffo7vQ96koYfT8eyW5vQxYmSaD7dCtwOvnDispVpUpKmpLAHSOdF0yuGkeUNPOWik9hEiG24S39/UBlLYpOtJ41o0sbuk2VADgldF3CFRrVw+f82FU+YYm31MFN/IvGvCQ8KLkgGfQCuz/O/kKD1a13D0EATGlHL7oF0oMAfmx2skCNb3Lkxkz3hoWdK81B8WdVN1szI+sYvr5V/0YBl4qgNiYWEDeORbs1BR8LAqITAQP4f7AfA8su3ZArkFEYS3cxaGOlSN+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pI2SPcOEm5aQDofrTLFflE/6XR4sJ4PNsmRY9VTGz8w=;
 b=RAjQjiCV4taGWXibrIWtuNgtxD5uGdgbw0uyQ4WWn0Fxn+YelRJ8EbgGVpslEE2FzfARP9v8b8G45Gb5XgPWT5qFlvV7NQA9OlJauhHyhR3KboVILu3Do4Tz3+sh9HxGZWuSr20pLWhSHAUkLu70A7ywxVhExKJ8xjxWIH6PgCw3P57zfs5xxjqHIYuomoWlcX1ZCRm0cFIWqcgz9WuzJ6pwI0UaJSn6cEle9w6pceyBrnjoyQEdnAEbp0IC5KiutlxOCVaKczQL4T+gsI5eJvLPZU5w6LRZetz56kFgNOWPiCUQnKnlIm8yTWUCalYkqWc7npcBV/9ZXyZNpntRMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SN6PR15MB4269.namprd15.prod.outlook.com (2603:10b6:805:eb::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.12; Thu, 20 Jan
 2022 04:48:15 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::1d7e:c02b:ebe1:bf5e]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::1d7e:c02b:ebe1:bf5e%6]) with mapi id 15.20.4888.014; Thu, 20 Jan 2022
 04:48:15 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Song Liu <song@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v4 bpf-next 6/7] bpf: introduce bpf_prog_pack allocator
Thread-Topic: [PATCH v4 bpf-next 6/7] bpf: introduce bpf_prog_pack allocator
Thread-Index: AQHYDYlCsyEKG86ANky3ljsiNA7gyaxrTVOAgAAJeYA=
Date:   Thu, 20 Jan 2022 04:48:15 +0000
Message-ID: <FC0F20F4-8B5A-428A-BA48-3ABC49723327@fb.com>
References: <20220119230620.3137425-1-song@kernel.org>
 <20220119230620.3137425-7-song@kernel.org>
 <20220120041421.ngrxukhb4t6b7tlq@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20220120041421.ngrxukhb4t6b7tlq@ast-mbp.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2892a34b-b1e9-4e49-d938-08d9dbd0127b
x-ms-traffictypediagnostic: SN6PR15MB4269:EE_
x-microsoft-antispam-prvs: <SN6PR15MB42693C980E0776C9176C980BB35A9@SN6PR15MB4269.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mY50duNNSPM1Gn4jo1vo4zRQ6jW6g9+Fk/EbWs6hwZRa/pAjYT9UXr21W4XFXv6Brv+0+thI6sLzKeybukvvSMrBOXWobnD4jt6a80AhX68LlVP1w8+UVIkUESMWu+VtMx7/PSnYniw3coJfQaaGaAFt4BSGH7BvJkCWLbVVj+5VizM4YMrLxO+H88P5FobIn3c9FZJ+76wwEg+I6s7rKLmlgSOBUC6l7YtkKCzcKG2UnmRHaB57tyFm6daNFGALStC/PMGP7qSSqw4f27goa3u5RWmFjdvDjsjkRgWeRHR6Yfg6jczgsGD9TGQuZhL01C3DBbpTthZLsqRMr8Ic9R2neDgdbEORK9NDv1rZVQvcffgqN0N5rb5v4Rh73cjEk7Fm/A1+9rhdA7r5Fkrphgtbj52+SteqRKv+Jd4Nflo4NfxVemXC/oC7pic2xLFlIVzeNN+2/MINucpEongYwWebAV70ppTV1j0VAHE0IOI4BuJxHEkxQ4LOKWdLSlYjQ3KPnWNrZHKUz0iqMoP8nB+B2i8XewyfwvJiUZ1wJLy2qraMyD5/gNR1nmc0hEKRPchaV1ia2IpPMH2vMU6yGLopRi/7xmO99joHFsOcYRutkUikvAt7BulojKfKJTrkBIto/SNZog3JlhsJ9LxpwR2FjSpks+c40Zz0GEp5WseV05PmMAEziUTgGbR0QK9Jsn+rNQQhrwQonsanWc3LQ6WWB08Nl1oWqdMjQ8yv19t1Y/p7N3g20UwMG3OL3anQ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6916009)(186003)(6486002)(36756003)(316002)(54906003)(66556008)(66946007)(4326008)(5660300002)(2616005)(83380400001)(8676002)(33656002)(7416002)(66476007)(71200400001)(508600001)(38070700005)(122000001)(66446008)(38100700002)(76116006)(53546011)(8936002)(6512007)(64756008)(4744005)(6506007)(86362001)(91956017)(2906002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?TgIR0USLwn+H2qNMM+XbFAtZU50h1BkhAC42o1B0VTBTo1OI+OBNkbpUCgAu?=
 =?us-ascii?Q?2WrxUhQDDsziG0Q0kmyMri4DinBQBQASm1dFNVzoBfV+K0D0KWq/azHUt0Xh?=
 =?us-ascii?Q?rQ5NGSJZJtvRQwcgbKxPw7fiEuK8RTk5OHtsiYmzCUkkFT1DTl7M0SBvF1+C?=
 =?us-ascii?Q?MtWyIEkYjhMh3QPqNnsEfDAnDAFABa9+3AxUaPR4bdq4w3cpooM2AIC8lrkc?=
 =?us-ascii?Q?uwWXqpj3zNO7MGY3VGgFzlEYRW0xSRoDH/gRPTE6/GkgKlcHas9/CMhgRWR3?=
 =?us-ascii?Q?hZ3fwzabXFrSDS/xvY7s3U47+CuwyFM3ZRA8YPd8/bfgAZA5YGo/KBOF8jjI?=
 =?us-ascii?Q?s/8Vxe2g7Ve0YTXADhIv0A9bJqq0M4eZoQPe+h7RxHgVrgBnosqGGJ/gXGY+?=
 =?us-ascii?Q?4Jtm593vjiLw5HZ35dLgtyvImgQXC0Zqeoq4FK4i0iNyhlcvtI6HrWiceJHJ?=
 =?us-ascii?Q?4XO4LtuJovanv0+YdA6PJBKH3kpcsOxmIBK5E+i7mI9bB1VkcIe0/15fofZe?=
 =?us-ascii?Q?/x8MXY976pDxIX1HRdGF8F6EtaUlYDoSVGbyAhV2DFiXsbuVwTNcC8Ohw6kf?=
 =?us-ascii?Q?5lyJrOR0HEocPQ2ZDTSUFUy3ixvQraRaLK2eRDxD6gnucc4HSTohpFNhqZg+?=
 =?us-ascii?Q?uV86fc6yX1aBQU7JgVN7xavjxLTpp/x421YCVfluWdXwGj3u6OnH2ObbzgPZ?=
 =?us-ascii?Q?TEq1PYxduUW49YQ5MZIpl8HJfRjPPINmAHgEbGCb7WJByK9dkTNbWvSQY35u?=
 =?us-ascii?Q?xpbLfl/MTjw8M6e0qMt8JprbnXxEIM8WEWDHkFqToqIZL3RY3GCzh+9+oSwD?=
 =?us-ascii?Q?A5jH9mbc5CUQp4DMyZFEN6rTLhYOfbC+AVjq1GDEzypHNWsPuUDTTmJYgemP?=
 =?us-ascii?Q?k7llRVNVVi6b0xBXsonaRsNqafVUK+/wsMo15vxktCFv01djxx75Qci8ywLr?=
 =?us-ascii?Q?JLBKwdI6OAlPUexzbueFDZhmQPIz6iZANkb9h+UirATLgb433SvNFX1c322f?=
 =?us-ascii?Q?9O/7rASUTPxoE5vVtQLPf7Gl9z73yJi7WvzZaikuFjH7qCi6zegw3F0m1Mmk?=
 =?us-ascii?Q?xM3Mk74+mSB7XPaYU4HrGIPh5ivPuWZ4L4/0G2rRS5yEA1m8hTVgDnApl92c?=
 =?us-ascii?Q?wMNSAZoEHMrxT1FpN2c4UpXPbLpCRtqpTHNyfsKOgyBF9iPs+kwa8e83zul6?=
 =?us-ascii?Q?IxYiA3rLXlFPaZHzc2cbiL++S4viFnFM0NsIVak1pgd4iT+YzJGt1WMvRXTB?=
 =?us-ascii?Q?T6W7kJOiZcmzDzoeeoUNuSIiJycNVxB2MgFUJGCC/kfAmjPDr6jRS5ITq51a?=
 =?us-ascii?Q?D8Cw886BNKoOTLGJRpzAThB3xOjPuU9VB4Ql1mHhK5xPv+3kMX8ipU9sMzcC?=
 =?us-ascii?Q?Y7hlvtdvbpbf+M5Xqzxg4gsDdG+BHPF5zF/M1O0Rm0uoJUpYuBPVGBCklUKL?=
 =?us-ascii?Q?QMV5nb3KQlZ7JfFrU6gT1CO6RBskOlUd78ZEEpMZ53Et2Frtj0YMWAhtUJPX?=
 =?us-ascii?Q?Xk4vmY1Qyax0f8hFiwgKfYp/SIFHDJztpXaNCbG6z/RY/ixye6juMHRWCHXj?=
 =?us-ascii?Q?U7/ls6L/uqj0OKIMcrnfZNlvBzUhOpXNkt8k/c5OEb72k5JWFqPFJkihq/mP?=
 =?us-ascii?Q?fCK+Gon6TAj6K1y1P7nGt53/hFYaFfQ8zpIOJVcMfEe7P9efKW1CDShwCokC?=
 =?us-ascii?Q?hB3lyQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A39E899216ACA24BA1182EBEF2B3A2D3@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2892a34b-b1e9-4e49-d938-08d9dbd0127b
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2022 04:48:15.8485
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cXebSHVn+8KR0pXynj0kIcStF7Xf0vcbxh/MlQTlJq9ELV3GHC3xzeVV3Gk7ogNYMLjr90MC5LZIsp5V+s3A3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR15MB4269
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: 73IUG35_htQpU9FQAZq9uOFjBnPp1KDf
X-Proofpoint-ORIG-GUID: 73IUG35_htQpU9FQAZq9uOFjBnPp1KDf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-20_01,2022-01-19_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 impostorscore=0
 adultscore=0 suspectscore=0 priorityscore=1501 mlxscore=0 bulkscore=0
 spamscore=0 clxscore=1015 phishscore=0 malwarescore=0 mlxlogscore=900
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201200025
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jan 19, 2022, at 8:14 PM, Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> 
> On Wed, Jan 19, 2022 at 03:06:19PM -0800, Song Liu wrote:
>> 
>> +/*
>> + * BPF program pack allocator.
>> + *
>> + * Most BPF programs are pretty small. Allocating a hole page for each
>> + * program is sometime a waste. Many small bpf program also adds pressure
>> + * to instruction TLB. To solve this issue, we introduce a BPF program pack
>> + * allocator. The prog_pack allocator uses HPAGE_PMD_SIZE page (2MB on x86)
>> + * to host BPF programs.
>> + */
>> +#define BPF_PROG_PACK_SIZE	HPAGE_PMD_SIZE
>> +#define BPF_PROG_MAX_PACK_PROG_SIZE	HPAGE_PMD_SIZE
> 
> We have a synthetic test with 1M bpf instructions. How did it JIT?
> Are you saying we were lucky that every BPF insn was JITed to <2 bytes x86?
> Did I misread the 2MB limit?

The logic is, if the program is bigger than 2MB, we fall back to use 
module_alloc(). This limitation simplifies the bpf_prog_pack allocator. 

Thanks,
Song
