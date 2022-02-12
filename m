Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 513164B326C
	for <lists+netdev@lfdr.de>; Sat, 12 Feb 2022 02:23:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354537AbiBLBXK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 20:23:10 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242868AbiBLBXI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 20:23:08 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87E59C7C;
        Fri, 11 Feb 2022 17:23:06 -0800 (PST)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21BLIiNZ030206;
        Fri, 11 Feb 2022 17:23:06 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=DlvTY+XDMqCuuwrbXNdUdq65WjRYyBSJLpoud41UwVg=;
 b=Nql7dXna7Pz9StPO9BIgbNiZR2is25ARVLxDGxNwbVmNhoOrIEMh1J4RHOOToxymeMlN
 w4aoyL+qZA2L2tfmxlETLj0Y0ZVYaDmZvSw4YOdEXnU5wTJoigSontiPZMVhkBwlpT1B
 64XVnyxHcxLCXjxeMc0/QZdoxp1RoI/+13k= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3e5sv73y92-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 11 Feb 2022 17:23:06 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 11 Feb 2022 17:23:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MnrRoSZW+IhJpB5csfAF2TjMarhfiq2sDcR6Sp6mVP0aXR4R5BYELo6acDORTKIlq/H+ewmNf3tri4Cm86Ft20FKWHthYrUOhGuQtL6myH//JT3WWngK/YA9h/eAtgQPty0ncqwMw+DoOjsHdKRLPEjLd5l1m0G13AAK33ABGad1syNgqU6mH+gPesaebyS6UKmKEvcXL/oybpM4ml+z5ROAwti1CLHw13yykL1Qdnz10v3g1Ar3VWVQ24CubqhROAZJPjk32PtGKWMMdHy7e/6Zu9Tr7hRrOlz5eRQarnool/LPE9xzSZuQJ+BTqqsuK8GFgulYK/y54BYZImPj5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DlvTY+XDMqCuuwrbXNdUdq65WjRYyBSJLpoud41UwVg=;
 b=KO1CmhRMutxIlWBr5mVYSv30aVTWmmo7lWMDdSl8rT75Ox4CMkYbz5Ym6OvLEDZ4pz/GAiOFt+1A3ve7IJsdj0LB8TB+myVdBv9ycALu48cEWd0oDqXKaYArytwOy/RwT+gpQXX/OPLfIeVHmNenrQcbPAL0eJE1/G4YpZ3+ZwnpumHm7U6Z5VgaAKB1XSx/F/YFpubj2G0fMoBVCy2IIg9bUrg4DRdXUXRnytl7rik4wwL0UE+rLkivCO11xB0W7ZfoD0gY5XJcaQiRX8YslV6+co4Y9vyrXerfbPvK2aS7+B82a4i5gIZChcHBeKw4ktXkSS/Ah4pGeQN2fyl+iQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by PH0PR15MB4879.namprd15.prod.outlook.com (2603:10b6:510:c2::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Sat, 12 Feb
 2022 01:23:02 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::cd7f:351f:8939:596e]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::cd7f:351f:8939:596e%5]) with mapi id 15.20.4951.018; Sat, 12 Feb 2022
 01:23:02 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Song Liu <song@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>
Subject: Re: [PATCH bpf-next] bpf: fix bpf_prog_pack build for ppc64_defconfig
Thread-Topic: [PATCH bpf-next] bpf: fix bpf_prog_pack build for
 ppc64_defconfig
Thread-Index: AQHYHum5xVx9M8aMAEqPkaJ6z2JMFqyPB7YAgAAYmwA=
Date:   Sat, 12 Feb 2022 01:23:02 +0000
Message-ID: <F2E05E9F-6E11-4441-99FC-21AE5017B45E@fb.com>
References: <20220211014915.2403508-1-song@kernel.org>
 <20220211155456.0195575a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220211155456.0195575a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2d31627c-4902-4c2e-b6d0-08d9edc63688
x-ms-traffictypediagnostic: PH0PR15MB4879:EE_
x-microsoft-antispam-prvs: <PH0PR15MB48794BBEF1040613E76F7F73B3319@PH0PR15MB4879.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aEgC4T9sRI6Pf9f/XZJ9TiZjoOOOaBX/rtoerFCVKGmUJ7L62XpUmqxO4xG2KI1WzegszIL10b185MgHMJdnnTv/BRta10YVKJloZAEOI4FbPd1PmtjkoT5SCLcquM1EdAT50F4sCvW0pA6z8yjFQg13oBK4TUmpFzGuQ04DhNHwJh3g0E+MmHL8xDomQ+nvfUKBzBH7Zk8gmfplM7CR3yKV6yo5qvWRIskOIm3N3FI8cqxiOT0Z42UZqOKTJmPrCeMAzDxyrcAYo4vuGgo7bl9da2oLHOR6ce/U3s1hntckXrZTgFUNSlVhbdvW7kyZhTEdqGWI7yEIeH3QH1DyqgpbKgRT4MKgSeS/uEFAH1bj5ZHQtaBh62xjEqJAv8MP9HhG6/WNeA/L1KP53HA0CipWzEgFS0csEUh6Vh78dyaEOD9o+ZgigrgYsHZ8w09rwV9pqDFxZw3cjABx4ljU2MMBD1D8vMuelAImz5pjLRxjh/OQQ+nXzuoXY5hNzyzx1cXI36XSZs2UvcSEw2biDNUydml9oilU69YyzGFckmLdN00AtXfbN6Qg5iqGh8HWO3xyAW89zZh8peQurG1YpDfy+lEzGd7R03GCZC8odAIWI0P0Z6qm4vB28Aj+3yvLjvQl+BcL2LWHV2VhjJZUAHeRtXIWon9PKj7i9kQ8V7kpAapFYDOU4v4hasi46YPn0tL9+9dBKYiWAZCVrRmOzaT772U+1bBVbA7CTujUNPDXJZt7LE0gs3HgdD1QO2BB
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38070700005)(8676002)(4326008)(2906002)(33656002)(66446008)(5660300002)(76116006)(53546011)(71200400001)(2616005)(66946007)(64756008)(91956017)(66476007)(66556008)(38100700002)(36756003)(8936002)(186003)(316002)(122000001)(6916009)(54906003)(508600001)(6486002)(83380400001)(6506007)(86362001)(6512007)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?gR/3WH+g3EAZa9NJrO/ayE72k4YB+fCg9QV4ojo6L8+2t7CxwJWVfZRn83F7?=
 =?us-ascii?Q?QiXkQs8EZXhTzgnyGQjgfNyEJ9vK8fLdU6ON2JTS/hYvxGmI1zFLdsP82V9x?=
 =?us-ascii?Q?gBfeUbKTpeDLXM/9qJRCt5T8n+CIhg12jPRSbHrDDQDEKGzhYh6/hK5hXDGW?=
 =?us-ascii?Q?0SC0VtzBmHFYN03bnimcUXXQWRgzJDVL8p06AOouwt2w7ryUApD5byM2dliJ?=
 =?us-ascii?Q?rbM/5I2eHTdr71thPt3+2OFGKaBcMcb8KRBr/QFoFkAHp+ev6jqDqIly4eRx?=
 =?us-ascii?Q?+w/3xIcz2lDDoSCGZcs3QT1NApBVNBFHG6dTNuZNEm5atstmBOORrHvOipx1?=
 =?us-ascii?Q?sQtfEyGPHUPgJP/0Bfajw5+vgKcWHMV6AW87Mv7fHyVa8l1T8vHU4sdBevNM?=
 =?us-ascii?Q?Xn+mBJuPqzD01/KZPhSty/xfKCmXt+psKOhzEE3/UTcXfUf7IIOTHkc4s/Ao?=
 =?us-ascii?Q?ibmK5bH0T9MACCCdm195ZIoYUYY3JahT6uOdlxeqGhzpevV/3CfWsEW/XhaK?=
 =?us-ascii?Q?yua333fPncdmnFkpoJB2szSd/2z3qbO+Kbuo4ZvHA8gpfy9ALD3LvLUabpLb?=
 =?us-ascii?Q?crLksDtzgASsQGuMiSt7J/yL46Vb8mkGYnDSqoeYSsnpkqS3HKBDtGbQ2FPv?=
 =?us-ascii?Q?Rd4JZ7jFi2pE77RP+SZ4+EjyCUsO9NQr7NhNQaHem/CW9Xtv/tFeTUdY7lhW?=
 =?us-ascii?Q?I9K7OZZHEiDWxiVNWcuWU/929QqSg+y2YhHSXvSinURmyFJzpVUkb5ldZE3Y?=
 =?us-ascii?Q?Ky/ZRyteyR0ZxTvLlUofaZYvR0hcvyw4X5EhAHhS7sRGgPu5HvF+mWBBUvXA?=
 =?us-ascii?Q?FR+izXok2O0Rs4mSvGOA408UAPk7vTsYX/J8m8Uvw+xOT+mIbCkyNerEYdDr?=
 =?us-ascii?Q?Y8FmlJF2r7NABXlTlDdtYs9OOX+WFcaIGQoMIGI1jleP7Y8WeWWSAXCkKhTI?=
 =?us-ascii?Q?keMIpBPy8B3dvatwU3zBgJppHyU6ZPfG1B0aDMrJvM5mOFHCmUJ/WCGuWSPW?=
 =?us-ascii?Q?HILKpeml/xCrQ2nZdtUzTclggJMCif6CdBut5z/YaUvY8G+prjNJOsixLpQI?=
 =?us-ascii?Q?H+CTKcYki8T/4+sh44PENfC9kp4PIF4JVHl4bkJcucOiqDL/AjL+2Janj4zU?=
 =?us-ascii?Q?ZOrUUJHrn+4ik2E8yUfMhJDOOIxV6FYIjJatbKsS5m3ymc9vLxU+LDScCZMy?=
 =?us-ascii?Q?xs9DZojgPb/g4R0IxJGFlAlinIkMP1VZNyFgNlTR4asGNnDIrABbAhPM7Yt8?=
 =?us-ascii?Q?28vKKI/iHzvHBSpEKnGzxjllJE4bpwFrvE7Hi2NQXN2yqD1i8nl1VD4dqcuZ?=
 =?us-ascii?Q?e/9HeKZXkbAnaEpfA18VJ5yE5E+vqi6UALjP0vSyX1B0ElRHELX6/I+SWGWn?=
 =?us-ascii?Q?dKeGOkXpcy0E6XZoztl/b5UIPzbfXdnuySvFAb7kb+PIozsaBUdZeahcJDZN?=
 =?us-ascii?Q?mWQtsUIrbSMlKytTbNc9hkd0HP3U17JFlDPQRdwPx/kar1LullemIL2HUiVx?=
 =?us-ascii?Q?pxFR98iOHSB5S9cRdvgeeazr9jY2Fi4SGoQq2SHTy+0PrAiHZn77pcm4t9/4?=
 =?us-ascii?Q?TbU7b9jaHJC3r/0u7zRLgevDo+vuRsTEDQLAplZpf+3K3MEK+L1ncdOps6M+?=
 =?us-ascii?Q?ebW6UfbAcZUI09jlgxzjItEO9wCz4sFytk5JiAN8ZZKu2olM7v4O4jVJNJG0?=
 =?us-ascii?Q?4rzvrw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E7C048DCDD8EBA41A44291381691FED8@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d31627c-4902-4c2e-b6d0-08d9edc63688
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Feb 2022 01:23:02.3091
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: k/dJtXlxk5lN/dCfmxqzJVSy9syrjabJAj9S6isZfCwp+hd3pLIDaVJ63xJkxd2ELV2QEuRhdAsnJJHlEmXATQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR15MB4879
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: sm5IzQ1-hcgu6Y-WaZjKfgIbZSlRJYU1
X-Proofpoint-ORIG-GUID: sm5IzQ1-hcgu6Y-WaZjKfgIbZSlRJYU1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-11_05,2022-02-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 suspectscore=0
 adultscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999 clxscore=1015
 phishscore=0 lowpriorityscore=0 spamscore=0 mlxscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202120005
X-FB-Internal: deliver
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Feb 11, 2022, at 3:54 PM, Jakub Kicinski <kuba@kernel.org> wrote:
> 
> On Thu, 10 Feb 2022 17:49:15 -0800 Song Liu wrote:
>> bpf_prog_pack causes build error with powerpc ppc64_defconfig:
>> 
>> kernel/bpf/core.c:830:23: error: variably modified 'bitmap' at file scope
>>  830 |         unsigned long bitmap[BITS_TO_LONGS(BPF_PROG_CHUNK_COUNT)];
>>      |                       ^~~~~~
> 
> No idea what this error means but...
v2 (which has applied to bpf-next) has more information about this. 
Basically, BPF_PROG_CHUNK_COUNT contains a global variable for ppc. 

> 
>> Fix it by turning bitmap into a 0-length array.
>> 
>> Fixes: 57631054fae6 ("bpf: Introduce bpf_prog_pack allocator")
>> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
>> Signed-off-by: Song Liu <song@kernel.org>
>> ---
>> kernel/bpf/core.c | 4 ++--
>> 1 file changed, 2 insertions(+), 2 deletions(-)
>> 
>> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
>> index 42d96549a804..44623c9b5bb1 100644
>> --- a/kernel/bpf/core.c
>> +++ b/kernel/bpf/core.c
>> @@ -827,7 +827,7 @@ int bpf_jit_add_poke_descriptor(struct bpf_prog *prog,
>> struct bpf_prog_pack {
>> 	struct list_head list;
>> 	void *ptr;
>> -	unsigned long bitmap[BITS_TO_LONGS(BPF_PROG_CHUNK_COUNT)];
>> +	unsigned long bitmap[];
> 
> This is really asking to be DECLARE_BITMAP(), does that fix the issue?

I am afraid DECLARE_BITMAP() will hit the same error here. 

> 
>> };
>> 
>> #define BPF_PROG_MAX_PACK_PROG_SIZE	BPF_PROG_PACK_SIZE
>> @@ -840,7 +840,7 @@ static struct bpf_prog_pack *alloc_new_pack(void)
>> {
>> 	struct bpf_prog_pack *pack;
>> 
>> -	pack = kzalloc(sizeof(*pack), GFP_KERNEL);
>> +	pack = kzalloc(sizeof(*pack) + BITS_TO_BYTES(BPF_PROG_CHUNK_COUNT), GFP_KERNEL);
> 
> Otherwise you may want to use struct_size(pack, bitmap, BITS...).
> One of the bots will soon send us a patch to do that.

Since v2 has applied to bpf-next, I will send another follow-up patch to
use struct_size, unless some bot get it first. 

Thanks,
Song

