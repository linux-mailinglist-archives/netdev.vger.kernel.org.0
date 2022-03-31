Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D05C24ED0E5
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 02:31:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352103AbiCaAdi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 20:33:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233372AbiCaAdg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 20:33:36 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D59CD3525A;
        Wed, 30 Mar 2022 17:31:49 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 22UJlo0S015593;
        Wed, 30 Mar 2022 17:31:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=BJ9qP2xVmMBKBQw1W6oXgck/ZALaGDEZYL0xhP8LadE=;
 b=XG4Yc6zSPr/DkTBRUMu6FT7LOCKSbUiWJDKoiSGmstTe7hapC0PN9AVBwydnA8zQ07Kr
 getaapcbiwxvgQ6CSWdcl+ijz5MqQyppOguwkNDPJmn/4tSBJf6z9wBFqS4FvIud/ANR
 OOJVQelEb4YuO7xCurdsOY/c6tKGH3U04VI= 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
        by m0001303.ppops.net (PPS) with ESMTPS id 3f4wp09mud-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Mar 2022 17:31:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mpD3JixaoIGOUplgeOjEH3ne54TRhNqoZNO9QFiha58/dEfOoHL3GVotHw9x1L6Oyyp4FWKIWN6tSBNaa1e4BxCGLtGperpFzo7g2gznqcGwPKk76XMuIuaxFe1ZqTkxHMO6uEONRCz3Uas5/POQK6pylU2FOY/LFoU3qD66fvLCtcYMU9QZUo2+5pwuZvgSnrSSTU1/rGkXG+iuy++WKo9Rmx7u+7YlvktnFpXwl2hZYPA95ljDXnCZYGgtGKu1O1AbFZ4oD/DMiOEQVjfw88lKdtIoyCUDdtGoQXM6RCu5eWpf1gvBc1MXYNZkcHkE5uv36e9BQasQWl5BOTusuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rheATOyJQw5Is7hmsVYFy7WuxQfjFw5FuylUsXwvm4A=;
 b=XwUbRd/iMjx+NfSrks/O1iWBUYJT1zgA7Wbi+4UNHDjeNuv6nfXLZ9uNqvwCkes3jV+KYFMvt+2FDVf/NNZIdcSkdboVe/pR5ePSiD3AuZHMruL1oknRB92by5Jk7jCQ0cDfOMJrJqbtgeqo4KgtZrFXIXiSafF9t6s1AJBKE6FtanGmxVlxGqPo5sMe5bOv/szng5Z7wREttcw2r3dItjtjKL7mrxpXjFoQprr0vVIUN3ofOOZ/8EVO4/HchohaI7cr25S8vtRddtKD+BhMdNmhWfUBGtThnPY3ASxs5JwV5Qbw/MGDzM7KpxwkZNjtK84KddIb8LnUTUGJHB6aEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from PH0PR15MB5117.namprd15.prod.outlook.com (2603:10b6:510:c4::8)
 by SA1PR15MB4840.namprd15.prod.outlook.com (2603:10b6:806:1e3::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.26; Thu, 31 Mar
 2022 00:31:46 +0000
Received: from PH0PR15MB5117.namprd15.prod.outlook.com
 ([fe80::e487:483c:b214:c999]) by PH0PR15MB5117.namprd15.prod.outlook.com
 ([fe80::e487:483c:b214:c999%3]) with mapi id 15.20.5123.021; Thu, 31 Mar 2022
 00:31:46 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Thomas Gleixner <tglx@linutronix.de>
CC:     Song Liu <song@kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        "rick.p.edgecombe@intel.com" <rick.p.edgecombe@intel.com>
Subject: Re: [PATCH bpf 4/4] bpf: use __vmalloc_node_range() with
 VM_TRY_HUGE_VMAP for bpf_prog_pack
Thread-Topic: [PATCH bpf 4/4] bpf: use __vmalloc_node_range() with
 VM_TRY_HUGE_VMAP for bpf_prog_pack
Thread-Index: AQHYRIsaNKIlMxZI+0WsYL7lTyfQPazYm3oAgAAI1oA=
Date:   Thu, 31 Mar 2022 00:31:46 +0000
Message-ID: <90BE2D77-DA7B-461C-94BD-A6BBB5775E12@fb.com>
References: <20220330225642.1163897-1-song@kernel.org>
 <20220330225642.1163897-5-song@kernel.org> <87r16jm1o7.ffs@tglx>
In-Reply-To: <87r16jm1o7.ffs@tglx>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.60.0.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 78cb6ff9-00e0-41e8-018a-08da12add6ad
x-ms-traffictypediagnostic: SA1PR15MB4840:EE_
x-microsoft-antispam-prvs: <SA1PR15MB4840C6A59B1D04B08250F839B3E19@SA1PR15MB4840.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wKdW09Rfo8RtcQk3a4O/1CMmnBpspuQ9+5rbORSXDV8lULSztTWDTnRn78cgsr+zSR3x37Y1KB1qBeXEJJ8Wx5OBzgYINfY+iytS8+EVWtkmIQg6vTAsjtyOkHYrMxOX+lK4VwrnNQwTlBnycXKa1w4IlQAxPSbSqNorSJAOi4s5rYbsHRymGIrp3fWwDfQQJ+U1oISQtleiKKmIeR7JAqOvpy3Bnpeqh2+MdSld+EDqs4N3b9Mwgxlq7ma/Nnnz4tAIqTtIqUO15vO2OKmAiVcltwj8nCi9lFB3jd0x6gHlAwYKB8+pD7b0pmoDLBnuz2QFoor17uoHJluTwg9bdlgx8rJs1efGGqsSkhqBIuZQOY6/YnmRSSkbN+fL5n7rJMGSD64vzF6+Y5xFXzkKXtUMU0CGqqyE6Tc7R1kb1mudatelXqW+GMEw5KnJxgTcaY+WNGFxwmFaE+6gzjgxJ7uw1zATKBsiF2LX9ghRRC5Dhpt1muFqVKUWlGe0w7LHioQVgHD+8XZBCz5O5FddpQFwXxmFYuyCxLhWt3pHNAlcxZj5gFSHscux511hkCDAuRS7lWB2UYoYXufI6WpzDs9RaJ1BYGhD4IvImrX0bKxmVHfuzNuw9AOkg82q78iVB/Y6ZyLhElK2gbHPC9oCZHJm86LilA8/ua9LGkq8fBTSEDNFJ1jc9UZ1AKXlevo9PRX0EtzFtQGV4LFCEjZ2xYINvdMb7Q9146qWZJEt/lEJ2tXd/K4N2g5yJ5h1DBq34RqEJZZBfhTrWMkDDNYi9g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR15MB5117.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(54906003)(2906002)(38070700005)(64756008)(66946007)(66556008)(66446008)(8676002)(8936002)(76116006)(316002)(66476007)(4326008)(38100700002)(122000001)(6916009)(71200400001)(86362001)(5660300002)(6486002)(508600001)(6512007)(2616005)(53546011)(186003)(36756003)(4744005)(7416002)(6506007)(33656002)(14583001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?JApi0Ka5Lwtd6qkjODu56MKXq+px5O8mTnrPjzXw524M7JC930f1MVQYT2Ti?=
 =?us-ascii?Q?U8YPWy2WZoWBmHPwjHs2wxylNA74aM0K9KVK0BiNgKPe3sVM/40IRoAOLoN1?=
 =?us-ascii?Q?RPQQeFOnuckzOP+PlHsNxnYnaIfgjdaeEXdcKvN/Us8tSuMDyEQwYY1rb/fM?=
 =?us-ascii?Q?YuDVcpjmPjNqZay2GG9RgeSCCfYTLmt8ht7ujk1wKcN5l81V5Y42S4EkXIll?=
 =?us-ascii?Q?cEMLt2gGRwOoPUGrUPkOJT948v9Npt2Wg9pAg+cNC/+76T0isId4p/iYK973?=
 =?us-ascii?Q?pg7YsXAic85MeinZJpfJmKyrfCeizzlg8JoJejHxSR+nD/fAExUcxKphwHA0?=
 =?us-ascii?Q?HlhBVkDwuf15V+6OrjIfBS8cZgtm3HolKzHCJNbujceyiwi0BHhsBVfgcSp8?=
 =?us-ascii?Q?qyHQ/qZ3ziwgb72VHx3dftgNIpkp+bf9c7C/HWln1YLow2/1/39aiV0NLbq5?=
 =?us-ascii?Q?0RRiij7m+Jj8HfSiofKQxxlrDto+mfJyIbQLn8nKOeFSgOjRqR4IA87mCZCg?=
 =?us-ascii?Q?A6IllE9OOxmIrOI1YP8jSLUcvztja7CsHJRZPVL0Nt0MmHGtAKZly07XuGxB?=
 =?us-ascii?Q?OzKtDXjCGPs6iLOHpCMt9u7o1TTi/8bwWOmhYEBPerKmnAGghbf1CYE2Wle+?=
 =?us-ascii?Q?4nIGBKPIDurPLXrv44XdZWwBhzDybJAwv7E0LeQ3srmyu7rgkfrbl1vCGATS?=
 =?us-ascii?Q?7YA/hXChoTwV3jnR4O1OA+m8/NBk6AJSo9C/407StnI8A/A1ry34ZQQ202F/?=
 =?us-ascii?Q?NP/j55lNqXHXZFa5X73kmNNHiPsy71+zrFPu5jwM90HZWTOhnN1RNojjKnEY?=
 =?us-ascii?Q?6LtWgH9+cIJWkQNAJLFycshvQKkCo5/JMKTcfylYsyiRxv3oehJ0zCUiLJG4?=
 =?us-ascii?Q?Z8vLbZQOnZObPt8b/NH9mzQAxgpuhf0mKhG4/D2cJWOTsuXWOhnwZuAT34qz?=
 =?us-ascii?Q?RrDRSANUgsEOGkMR/ytS5AJKAhB/goCQubl3/fFTH0aL8A9//IgcmpMiYwu+?=
 =?us-ascii?Q?KXGxS4v+BC4Fi5VmABLXJGsvqgPZ+9/FHjISbWKn8BqiPXVkeiKxdbg7N/I/?=
 =?us-ascii?Q?3uYmBTpsv54mrNhGik3pgTdx2bNCjhhoaTixwhkGcS4Ujjv3Y3rzm41jMmwT?=
 =?us-ascii?Q?1RK0ljvwT+3CDMeKOFmcUk5Rpnp1ekxcC5nW5KsFoZBOS4yBoz56+XMZLU8I?=
 =?us-ascii?Q?LxKCvVnGZQGmHIDnluSroEceyKdikUE4YewdmpsEQce96awDY4epeDT4W8nS?=
 =?us-ascii?Q?9ZNnxJixiZY4599Vp3jDrGSPEtukrmEbVv+28y+xirE8TzkNBQPSbQljDxRu?=
 =?us-ascii?Q?leLsstNWWV2S4z4OmFEDlH0pDwa6IdlkWKsiEE9FH+/s5q85d6RiqxpQAXDW?=
 =?us-ascii?Q?qYT30L5z8xAAvs+75+uMPwhnOF3bHeah7R+3XtRB+++zD0au0ieoZ0hSXcUM?=
 =?us-ascii?Q?f3GzQsQNpIPF3I6kP5fCs7juF/hHWon1Wii86R14B/92f3uIK8GUDvZum0VU?=
 =?us-ascii?Q?No9wMoeG2s6N5fbBCLggutirELzmV3d7blME2zv4NKG9sBKCh2n3Jgfj9Vsp?=
 =?us-ascii?Q?bVIVp81nBqn+KpEonMp/xKRnyjdSOyPwh/tvTguW6BcmNg7fjVYmQY5WCA08?=
 =?us-ascii?Q?+ALvggO4dZTSzWjMY1EaXorEbCT6YxtKKh5Z10gLtLQi9BUUkIZTXm+wJ9nk?=
 =?us-ascii?Q?0TUrThe8lQpDQ5zG19AM+doIRDLKUT/Vc17h6RoT0zx/DXTU6OgiUuXnIDHZ?=
 =?us-ascii?Q?BZMboeTJ+/DMqvgU3+WUmF+herjajBYG9dBb103ASgsIChXNAroy?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <83700D99E248C948AA35BF81BEFBBD69@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR15MB5117.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78cb6ff9-00e0-41e8-018a-08da12add6ad
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2022 00:31:46.5401
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7ojFqwtgu9uCsWqIXSlqLcCSXmf67v/e9rFq+7vgrKbdfCfm2Z4wLAJNrzgldTA6BAutdI8LmjMWqdgFPAAbVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4840
X-Proofpoint-ORIG-GUID: GPCPhRribpg6mmUvT-6xot-SmBr7iJK9
X-Proofpoint-GUID: GPCPhRribpg6mmUvT-6xot-SmBr7iJK9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-30_06,2022-03-30_01,2022-02-23_01
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Mar 30, 2022, at 5:00 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> On Wed, Mar 30 2022 at 15:56, Song Liu wrote:
>> We cannot yet savely enable HAVE_ARCH_HUGE_VMAP for all vmalloc in X86_64.
>> Let bpf_prog_pack to call __vmalloc_node_range() with VM_TRY_HUGE_VMAP
>> directly.
> 
> Again, this changelog lacks any form of reasoning and justification.
> 
> Aside of that there is absolutely nothing x86_64 specific in the patch.
> 
> You might know all the details behind this change today, but will you be
> able to make sense of the above half a year from now?
> 
> Even if you can, then anyone else is left in the dark.
> 
> Thanks,
> 
>        tglx


I will provide more information in the next version.

Thanks,
Song
