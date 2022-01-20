Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD3349468C
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 05:45:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358527AbiATEpZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 23:45:25 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:54400 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229952AbiATEpY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 23:45:24 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20K3OD7K029568;
        Wed, 19 Jan 2022 20:45:24 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=2QQJ5EQse34cE4wdZYNoAvYFqoQFEPgpKBrPnmhGl8o=;
 b=GaU27PbjN0OvPd3yIsDKPE6TzLdjTp1Nu/PtPrEql7OzCbhzLvYjQfG0nfcRLtPEhTzK
 tL5kLE97QN5rOQbciUKb2EHtri/WN4ukdFCu47W5XhKAQZoeUnAnE/frF15KfankQrUu
 g7qwdXprePcDAcKiItmJUjT967nEl+rQDKg= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3dpysx09bx-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 19 Jan 2022 20:45:23 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 19 Jan 2022 20:45:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E7zTUH2aZNVKiUWtGPamnWrMMid8f+O5cHR5LOpU49ICKO4Q99wttrs6jcp1RVdYRsSqtl6tA2nnY+Txkg0vorvRmTxTwDa2+VHuxFo+F8j4FOGwa0PuBGisJmJQmc6lESyGem8VRb+UlnBCIMGj7TLtMGQR4qimXDBHR6EdmJLj+FTdtiwgK9UBT6YHkWEXR/Zy7jClHpBxqtiRtuAL5Wh7FZs3Au8z9ddc4sIHRwmuVsAR4hhvsQvhqLVRc+m8ou1VAWvHH0lHhmI9MCYIVlj1rZzojzcDEM7VumRK130+tj7BYfuzTds0rpBa3ocs9y6WXvo4qQxMDZhugW5nyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2QQJ5EQse34cE4wdZYNoAvYFqoQFEPgpKBrPnmhGl8o=;
 b=SxE/ttfvYOPRF5uIWJnjAhqvWtKw2ZOaVAVald9igRg+MJZsz1VS/WVG4E3N6ORsGDXVI4ciIZDgnGIu1cRYO2QPST4B9nxzJINronVNn2u4kE1R6w0Flt6qsw7OW4ZaVFvjLwTxjBPeiWrOQOk73FWl4b8Q7wxbBcQy20abgbO8UPAricpG1HPI1e+FwroTnJB5pGKVzI3lLRXqahdbdVOCw13GS5Oa9Rf6FvZvSXo7Ga85FpXEZ0AH0MfMiB+JPx0/LefumdT/bi0WqvvPh/xJGHsqxWuYUrLzgNSiHuAXp6kXSk9ftaeFBRS4hCVHZfe//7kHrCa8QLn4tP9MDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by PH0PR15MB4544.namprd15.prod.outlook.com (2603:10b6:510:89::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.7; Thu, 20 Jan
 2022 04:45:21 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::1d7e:c02b:ebe1:bf5e]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::1d7e:c02b:ebe1:bf5e%6]) with mapi id 15.20.4888.014; Thu, 20 Jan 2022
 04:45:21 +0000
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
Subject: Re: [PATCH v4 bpf-next 2/7] bpf: use bytes instead of pages for
 bpf_jit_[charge|uncharge]_modmem
Thread-Topic: [PATCH v4 bpf-next 2/7] bpf: use bytes instead of pages for
 bpf_jit_[charge|uncharge]_modmem
Thread-Index: AQHYDYk++Lmpp6R8K0+OfkkKcJGheqxrTDqAgAAJwQA=
Date:   Thu, 20 Jan 2022 04:45:21 +0000
Message-ID: <24FE334F-1867-46A0-BB21-F10551CB1772@fb.com>
References: <20220119230620.3137425-1-song@kernel.org>
 <20220119230620.3137425-3-song@kernel.org>
 <20220120041025.uhg2mgpgl32mnjtq@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20220120041025.uhg2mgpgl32mnjtq@ast-mbp.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a47f9384-0ee2-4fb6-d9e7-08d9dbcfaab6
x-ms-traffictypediagnostic: PH0PR15MB4544:EE_
x-microsoft-antispam-prvs: <PH0PR15MB454404F4DBEA0ACCF8402504B35A9@PH0PR15MB4544.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FfSq8Sc/cxGHSa4T7Iozuj/jRXRiGvg/XXXlmNdMwsdD53T4PwqF7lFXZCl0s2al4pEuJ4juB2H/jCh2kh8xcSNiDRQw2tNQ0cH/fwSOuf4ug6NdsVMP0Kt4KkRSMGxsF4j4ucmWUmxv19m0fLpuywETLGhC2zaS1aQUKBObySVeELfyiqIDiLlWsN+pW9ATZc5VAYsygwEVpeIWXmYzhPz5ZZJruTWDB6zpAKZAM4Lf+WVEKS7/ysRiuMUsQzInWl1eKTMhkbfH9Y0jaMUso0C1J1Nj+/rF6v70uoyoSeC/UBsSswvhK2UamKZku2ZvhLUTLgijNewgMUEEfMcC7bP/eUgGhd22ar2J/FQotM9HbLGZyvQnhTPyx91XFwp4ODmFIEqTO0ddaQ/2A+5qdy31dhcuANxWfuqk9w/dEx0SnXHxDSmAyxVqO86IxPLKA7EZpOXO5Gts/ECSB3ae9siBIDE7NFpwQC2WyEdSXoY0aUm0LdlyunHdzqi/Lma18sL/zLCDvxCpjazkVyhjhwYWQBCsOaHQ5x5s2Z08JfFq8BXPiaFaimJTPKlzir3m5ZcLjO4GsG9FKVBqgdnAtdzeCYNjnGwtehPee4KNwvuATdS43IVqslqeIpPvEiEWEfZuPqMtYu6ffb5JvYIZW7yzY+2/rlPH915GWuJ4hXoHPznPbH2rLIxtiwD/o4AnRta1WWhJ1ME4wRCQeNRrYnXEaX4MHUgGGE1ZRUN2enOceHO4bQXHc5cYrUWnfovP
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(83380400001)(4326008)(186003)(6486002)(2616005)(4744005)(316002)(86362001)(6916009)(53546011)(6506007)(6512007)(38070700005)(2906002)(7416002)(5660300002)(66946007)(8936002)(33656002)(76116006)(122000001)(38100700002)(508600001)(36756003)(66446008)(66556008)(64756008)(91956017)(66476007)(71200400001)(54906003)(8676002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?QfPVwiXLDFhmozbNlYQkp0Y0GO/zRRrVQvgLcOFqjfJGOTsMxYRDFkIgYvvp?=
 =?us-ascii?Q?s0/o2SEEgG5Z/SCWQQ+QHIeW3I36B2JhlIbQ9nQBZUUZMY6KPgMpQB8OgK3f?=
 =?us-ascii?Q?Y+7d4DVhU/r8cSqqZXM4TokTnJwvXVlWqWs3DQgOEndo7MEqVhnjyd6ONhrz?=
 =?us-ascii?Q?jSQMDOrXTQcyjiK5LYyFAYaepq5WA9jfHcrQYM/XEHBbnOiOG6+rC7r1R2aY?=
 =?us-ascii?Q?xTzthSPXIOiKoqBy9XIMtol5X5xixxnv+N5Ij7gZfXiQtGdffDwto6rWv2p2?=
 =?us-ascii?Q?ZBnWozIOCrj9a6JEJiI21qqk9l9JWY2ciqQzZAfy51KLUdB3RnjwsZUcl1VS?=
 =?us-ascii?Q?8r/8GKOEVmG0aMRwOOYoFxGOY2NjNB3xoMQa5fYkhRU1Q5PDdD+yt/RwSV/b?=
 =?us-ascii?Q?mVdcY8Kq4fW1ClZfMwVygqBdidV+3nBu6J6gTiHGi0cGNU7qiHTBA5x4ExCw?=
 =?us-ascii?Q?tojDum9UOa5hPEWZ7D9P8r/wzMSHIUPSLqvlQ2rTTHRBqxo8pvDCBuXC2saM?=
 =?us-ascii?Q?BPaEaS85BDrYGkYpRgv4s+WnXm5iNk8wCXw8bEaC7e90fMgVi7Rz81HvSQTq?=
 =?us-ascii?Q?kWo428dKtLx1IvqJU05gXh3+6W48BqzYflsvOXu65FzqyP7dvBrO3QP/3OOU?=
 =?us-ascii?Q?KLUn2B0y9jT9gcIZeL0D/hXSoshDePzalKbRxncEWMz+U7QwWfevn7nU3vmd?=
 =?us-ascii?Q?v/kGz58Xu28iVos+5RtfdMezXZBLChOsdIKYnAbB2b/P7ZL6B5U7Vy3hly5l?=
 =?us-ascii?Q?/zn+3tINyUEPunUDC3xM16om5DJE8mXZbNRf42Hkn8y+TOD9HIO4lFXZKaLX?=
 =?us-ascii?Q?8RYIdyjlPGdr3DUbyyPqAuw1E30n1gZtpEkvMaoN4JvzkH/zCOqNH6tPFemB?=
 =?us-ascii?Q?gUejb0vETYGMkPDaDLxoFfp4sBb1ekYR60yJWMOolsBQHNEb/GqoNkIvA158?=
 =?us-ascii?Q?ymt8ulaRDqFdUpfToiOZ7iRTIzPUD8XgwZO5MIBqZ/Dq71+Q95DH5qEV2X1e?=
 =?us-ascii?Q?gn3bdEuHgFwTas9dTbDFOEIjBDvZA/LMCHQ50YkRb/dLwJid3/619NRL1682?=
 =?us-ascii?Q?5nSN78ECvndnfJCoUIxgo926SNZLrJmU6rMfgDvozxrE3yaKl6H8ILjACjGn?=
 =?us-ascii?Q?Qig2prvuros4sCE2fTXuht6iWQe8KsWiil9I+9262po+EtIjziI0pUMvsTCc?=
 =?us-ascii?Q?sdDZYTWsTfs8jiLnDOBXyBlkbnU+PADBVfjWuoAIvKmpenJFaTfPggz1ojfw?=
 =?us-ascii?Q?dLhQXNRrarkNPiFM/hCjnLJ0UK01NOlQCNG2SuMTlgbNjvIT+VNdGab6GEuP?=
 =?us-ascii?Q?/d3Y+Ohnfn4tBPFID2bA4XjqnFvmuiVHV7/LzxQk0MD1Jk370y0SBKCoUSM5?=
 =?us-ascii?Q?EbbZR4EE3PevyuZBHVGgOIOTqnV7TGmFkemBouc2ika89zuRLazNaalkkVr6?=
 =?us-ascii?Q?fjwp5HnP8rJCWZQdq7lS9Xdq0staV14WzguPcj5aTn6cU0BOYAzd5i+6zE5q?=
 =?us-ascii?Q?b6VhfAH5aCgoVVyGAPpzuevkSvcjQ4E6I+KhcdlZXVmnQEjgByUD3h7+Z2As?=
 =?us-ascii?Q?jH19+CHQcu3lHlZwi+FbUr2Ea5bk6Pnsf0H4o0Zy1Q5oiKbzj+vsQ7tdF1BE?=
 =?us-ascii?Q?0kFgmbwF79Mvx8KZF1cNm77ZiPb8HVGnCguPqh3yynkmZM1E2kAb3FdGxJgI?=
 =?us-ascii?Q?zZvl4w=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <DE5B177862A31040BA935974E654AC0F@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a47f9384-0ee2-4fb6-d9e7-08d9dbcfaab6
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2022 04:45:21.7678
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EVuwdrBjW/FSw03At5bnIt4Tx80f9S3Ids7tLSRPj8Ahhn4XNXVjMJ2Txpb4OR+LlG1FM+CvUTtDqwotcvxDaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR15MB4544
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: HY99R89wgDksxpY8WCQA62pOsY27CQAm
X-Proofpoint-GUID: HY99R89wgDksxpY8WCQA62pOsY27CQAm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-20_01,2022-01-19_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 priorityscore=1501
 phishscore=0 mlxlogscore=999 suspectscore=0 spamscore=0 clxscore=1015
 bulkscore=0 mlxscore=0 malwarescore=0 lowpriorityscore=0 impostorscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201200025
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jan 19, 2022, at 8:10 PM, Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> 
> On Wed, Jan 19, 2022 at 03:06:15PM -0800, Song Liu wrote:
>> From: Song Liu <songliubraving@fb.com>
>> 
>> This enables sub-page memory charge and allocation.
>> 
>> Signed-off-by: Song Liu <songliubraving@fb.com>
>> 
[...]
>> @@ -808,7 +808,7 @@ int bpf_jit_add_poke_descriptor(struct bpf_prog *prog,
>> 	return slot;
>> }
>> 
>> -static atomic_long_t bpf_jit_current;
>> +static atomic64_t bpf_jit_current;
> 
> I don't understand the motivation for this change.
> bpf_jit_limit is type "long" and it's counting in bytes.
> So why change jit_current to atomic64?
> atomic_long will be fine even on 32-bit arch.
> What did I miss?

Hmm.. I think you are right. I guess I missed the fact that we use
long bpf_jit_limit. Will remove this change in the next version. 

Thanks,
Song
