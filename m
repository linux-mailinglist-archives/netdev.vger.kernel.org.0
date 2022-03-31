Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E8C34ED101
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 02:47:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346997AbiCaAsi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 20:48:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233530AbiCaAsh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 20:48:37 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5B5956227;
        Wed, 30 Mar 2022 17:46:50 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22UHKW7I015516;
        Wed, 30 Mar 2022 17:46:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=meOAzCeUHxTRiKEqC4xulVwQbbSg4J1dApVPCokI90o=;
 b=SJAfYUiqathFTzUs3siL1V8sqR7mvscPJ6/izn0U6KIiLhXqzBd7qOj53Rz9Hb/2ZWVY
 lbyux91VSrUFRNIMmbcSPZZsx7Ke+K+4mGN3XNc1cRswcWzw6CjhPUUnizmkZO74L+G8
 e2J9aIern8sX9kIlowP6UShenVFMkhHrRBE= 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2107.outbound.protection.outlook.com [104.47.58.107])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3f4ksh65sy-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Mar 2022 17:46:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b52X/Rdlp6Z9W+nh7La6yoNxjQrB9aDZsIyRRG4YYZyHkvo/IpCynUaKCSYfaOIZ4jPZQjGijuMgKrkqAOTBYfS8cDC9F3t+VUGw6zdeFYhMtUwPaNEu9P6eQRJFJ2Lp5V1jxshEhA8L8aVULkqiH7g29leC3W8l+XtroKG5oa2z8h87cj8EGoPaNMwAvWjrugPLCn0vnZoRLdm+Y1rUN8A210E9cVOuz39sr2TaQl/89xk6znAuxKjOnC4H1QIwxjU8lYmuMKLfp8EymhtWhmIuw1qI5wKP1uoT/WiKKu3T+gGXVm81jmtZeRf+otiUmiy6YKpvUKq+m1cl6vWSzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=meOAzCeUHxTRiKEqC4xulVwQbbSg4J1dApVPCokI90o=;
 b=ZtC7cKv/AS9/asbIoVzJSqn2zllYJWbVjg4HEiblIa0TuP4/heUBrR59O9O1E9ILyyTugHEC6vPbCUz/5zDDLeF0oGcqb7e+XS046z738nnndS70F+NfLkYFalIdIpufi3c9SFNPsMXChlBBMR6L6J/pFhccPeTCjdELHunb1a9kC7BoRqGeduqfgX/3ZUDu1GB/OqA2VaNU7Z0KQK05qN9WGviGVyQGqnf7rnzGK+JrwdjDXLuV0evl2QooprTOYX89q0hyBng+UG/0xOxbaQc0YOOF8klTh+fQUQFiA9Tk4oSVylJgohIl2cbHncYJr6w3IQBpJW3rErR+6/+EMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from PH0PR15MB5117.namprd15.prod.outlook.com (2603:10b6:510:c4::8)
 by BN6PR15MB1812.namprd15.prod.outlook.com (2603:10b6:405:5a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.20; Thu, 31 Mar
 2022 00:46:47 +0000
Received: from PH0PR15MB5117.namprd15.prod.outlook.com
 ([fe80::e487:483c:b214:c999]) by PH0PR15MB5117.namprd15.prod.outlook.com
 ([fe80::e487:483c:b214:c999%3]) with mapi id 15.20.5123.021; Thu, 31 Mar 2022
 00:46:47 +0000
From:   Song Liu <songliubraving@fb.com>
To:     "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "song@kernel.org" <song@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "pmenzel@molgen.mpg.de" <pmenzel@molgen.mpg.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "ast@kernel.org" <ast@kernel.org>
Subject: Re: [PATCH bpf 0/4] introduce HAVE_ARCH_HUGE_VMALLOC_FLAG for
 bpf_prog_pack
Thread-Topic: [PATCH bpf 0/4] introduce HAVE_ARCH_HUGE_VMALLOC_FLAG for
 bpf_prog_pack
Thread-Index: AQHYRIo6ffSmNDMip0KdC6K8yX1qc6zYnJuAgAAL6QA=
Date:   Thu, 31 Mar 2022 00:46:47 +0000
Message-ID: <92027664-4817-47CE-B008-8AFD94947B02@fb.com>
References: <20220330225642.1163897-1-song@kernel.org>
 <5ef891091337e2d36b29b1410f7f92c21b52d968.camel@intel.com>
In-Reply-To: <5ef891091337e2d36b29b1410f7f92c21b52d968.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.60.0.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: db10a85b-bbc7-4d97-5680-08da12afef96
x-ms-traffictypediagnostic: BN6PR15MB1812:EE_
x-microsoft-antispam-prvs: <BN6PR15MB1812534245E4C3ECC363B2A6B3E19@BN6PR15MB1812.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /M1iE3DgRaQEXU6h1nJ3jx0tMrCILG/2rV5qmFzt0EbF4rCjigF1g0Jxvd9GWAqNPyfoheITElwaVdE+PmEvH8wAbwdnJJZqb28E7KOXsSxeDKFD7Bdl8rN9+YzQRoHtRprwWYOl4p7csFCNYT6r/VBXj0vT5wUGnIAeVNR2x4jnD/xLgr3RG0dQAS04mZ0PcBQNFBgaEqb0NMkNpvLXePSqGqaGUfXrN93yWyh7hx7vR0eTcfywM1vDGHnq0ROex1mJq7aFo1K+rHMGgdtOqdURR2H0apNVSF8UbyIvtf9beQl3S91JZ0mx70++rU1UzGLWN/0X1mNfr4wwC3Dp3Cq62pNBQKipaYKzvVHFPCGb/CDGO4Tz1/J5oBarbV0baT3cGhAGGEKMmbW0rYMZFATxq8sv+21zbuF1IVI1V4Fy9SDeoidir4cEAESHAR+3j3G7Unx5JQ2ncMibwtKnFr7YcJC9Qi5z5c7k4yH+VD74lnEzBkZCx6WWjN6PiAlzRsqKZ2ppmC5jJgsEhYQ6j3FmSH4bMdJnfgDAFDmgX5PFaCdh5x41WCtkSiDUROaHEifUcG3t+48bQ6c8a0pwKcHJKDjH+E6FKNKNsvA752nymziivOwwniicH4S9GGPFE//LhI2q4IfUJTp/fSCgS/9on8fhaAY1sq+BBYlq0m8X0B0Xfu93lkcdJCOym9iuojyuq5Y5dApczM8v/fONHEfQtrEFBN1kTz1pC0unC8pIt7URyqk4BgZT1ryh5wjB+WKL0xkeDm1ejnuLbwGmt6xNRWTcxWz7dXK7qN1sfEVvQJEU6c45XJFfI4JHn8PF3OdrQryF4x1f3n8AvxjAEeZgDSuhiF5MaN6SZ9+ltXk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR15MB5117.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6512007)(36756003)(6506007)(53546011)(186003)(2616005)(38100700002)(122000001)(508600001)(966005)(2906002)(6486002)(38070700005)(71200400001)(8936002)(4326008)(7416002)(66476007)(66946007)(64756008)(66446008)(66556008)(5660300002)(76116006)(54906003)(6916009)(86362001)(316002)(33656002)(8676002)(14583001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?i0lkPgZyjyrI6KpFrriS+E8YChRp3HTggDt0hPikAfF6cHvwg/K21x7ByQNe?=
 =?us-ascii?Q?Hqk7vAnT3zRopcMdogmi0IaX3SdlqJjGfgqxbVKfzv5FasR/4asZGg3rDWml?=
 =?us-ascii?Q?pwibxRl129+WMBxLhUCKxhlBh0H9ozCJ1HTJGy77lKlKP5eLKTU/hBCwY9fW?=
 =?us-ascii?Q?D/kv1YfdNDicI8M6l7qda4keCkTNpxZqQXvK3HbxD3ovFY1IKFD2MzGoFYxn?=
 =?us-ascii?Q?C7kvavjtdtOOeSmUliv8ekhhFGazHdLcKTnY1J+3fMH59mtp3/RHTqH1yckE?=
 =?us-ascii?Q?6Z9UDnLHZNQ4wTlNS/m1ctIqAa8Oh7HNREeWXYaStl4TnjJ5NHIo6joOEqF7?=
 =?us-ascii?Q?FBVaD0SOCZE4Pt0uBfDEVZnXrkrGtDlhQznJua9RpN4TIcZ9aBwAHaGMYUK2?=
 =?us-ascii?Q?OlH3wWCw4NpnL3ud1jq7Q2mOn2x2rxf4ttzsH7nnUyLVx6a54XTGOTpnnNk6?=
 =?us-ascii?Q?U0FWHhzQy6Ld9os3WUpp7fzworf9d6i4nutBH5hmcK3Vs4zqGQS1TXd4koqc?=
 =?us-ascii?Q?fRs78hNDwRMujj4bi1uXzVhXY43PKYcozcM+VUjpWkpxzXcSUQ7NG1Ului9G?=
 =?us-ascii?Q?sLud4H0EplOro3hBqPJyhr3lxbHvkb7xgEO8bdwqsxV3IwF8/hd4Ll/RU34X?=
 =?us-ascii?Q?+pjApBlClDJhbTY3ohB8CtgleFGPL8GOpMzbSksA2Arj6NDsjwYLmQqaL3Hp?=
 =?us-ascii?Q?+dHjztmpwn/lJA/8zsKFXU/xeMhxbOdhx2RXOstVEFZwVTK+lXaDzJZVehxV?=
 =?us-ascii?Q?nVBd2ym5eAfghRdOBixwLacWlrN/mKjDFxIC+JjFVjKYHC+1v1yY6jKb8zua?=
 =?us-ascii?Q?x6q5g3OBz3dJZuopVa2v3VzuCTuoyA9vNqc91dtYjR44opGPcg7ZPzDzOWEq?=
 =?us-ascii?Q?ErRFyODt9etivBMMsoNYYxQ9JFP2EsYN9MfM/rmM94N+03aY0D4Jb5dNe/aj?=
 =?us-ascii?Q?g34vyMb8Ovsg7paEPcfn0jVxvfzK8Istec80AEcXK1FHaMOg3e8P8jQ6UKdq?=
 =?us-ascii?Q?HCXPmHV5mkcsyBFoJ4aeUoG+tCKzic0QJ6P0htvPsLmZ60MSpwkqap+UYoxa?=
 =?us-ascii?Q?5zmOrX249q9peYk0dRnJ2f1jN7u8tGzwwp4aayMdS4UjeVvzlmIGmrWgRE3Q?=
 =?us-ascii?Q?MYH+EYrcLvnQX567LHiC6OoY0UnNbN1KJcAePi2B7ccrddpXvZR1eKNnn+Ny?=
 =?us-ascii?Q?Zjp4/YssjwA0lKeImApI+db5gDkqFfkhfDF/qivcNNk8mQ4COwi2m3107p6o?=
 =?us-ascii?Q?PXbPyTXdq7kKbhtH0pMwuo3Z4uaMAVNYsbJKKzIKv1e7np4lRM1+uwsu0TfL?=
 =?us-ascii?Q?B4aDAMJI2SKKb1IUFRGMJaGi5eC4h98fCk+yoBxsAEFKjLqi0XwLRRsh0YAg?=
 =?us-ascii?Q?nrbN4Uw+H1zcWChv5ULxfxw0E9HPjE5RS5iZGxcHfFNWCTSK5JR4Pm5aIjo2?=
 =?us-ascii?Q?OkH+X5XQXsXUYe4vTHCUgiLU897UWdm8RlyCni8Tzn77ki1VcuR3x0C4E57N?=
 =?us-ascii?Q?VDE8KXkNk3ebBpwFRRo7XX77QLPZDeK9ZuXYyd+f1t8lDkyaUtJqNqRpM9Dl?=
 =?us-ascii?Q?TUHAP+i1buDUC4ygo0ANZQbbgvPwOg3N8sGWYOh+2eDY/tFe8Ks7NzyW8GsS?=
 =?us-ascii?Q?Hn6Sp3CQkqUyqldUnDwxppBJ4NWBt/takZGZA3Yz32Gr2kayWYb5Ht2SgGRn?=
 =?us-ascii?Q?xMy/xp2rCEltExC6XqK6oV9y7EWJ7W6wz1U4Owdp/AoHOEDdAi8EugUlQbZr?=
 =?us-ascii?Q?L4juWnKdhNQWjn+m7R2uIt6JE+O7vA9PttT3TcUSexUi/wIDtCpH?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D00F75F5D09D8040A84A8B0351FB41FA@namprd15.prod.outlook.com>
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR15MB5117.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db10a85b-bbc7-4d97-5680-08da12afef96
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2022 00:46:47.3748
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GCjDaR9kibqRIWHXs+DNaLpRFjyZBeO7WEbzOn+7x6+uZX7HXNAMPpqU2o31EL3NnSI38CIaZmpQX9r0lVmT7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR15MB1812
X-Proofpoint-GUID: j5nuxeSCk2vAqaWwF9J3JBlnn8tnWHAK
X-Proofpoint-ORIG-GUID: j5nuxeSCk2vAqaWwF9J3JBlnn8tnWHAK
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-30_06,2022-03-30_01,2022-02-23_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Mar 30, 2022, at 5:04 PM, Edgecombe, Rick P <rick.p.edgecombe@intel.com> wrote:
> 
> On Wed, 2022-03-30 at 15:56 -0700, Song Liu wrote:
>> [1] 
>> https://lore.kernel.org/lkml/5bd16e2c06a2df357400556c6ae01bb5d3c5c32a.camel@intel.com/
> 
> The issues I brought up around VM_FLUSH_RESET_PERMS are not fixed in
> this series. And I think the solution I proposed is kind of wonky with
> respect to hibernate. So I think maybe hibernate should be fixed to not
> impose restrictions on the direct map, so the wonkiness is not needed.
> But then this "fixes" series becomes quite extensive.
> 
> I wonder, why not just push the patch 1 here, then re-enable this thing
> when it is all properly fixed up. It looked like your code could handle
> the allocation not actually getting large pages.

Only shipping patch 1 should eliminate the issues. But that will also
reduce the benefit in iTLB efficiency (I don't know by how much yet.)

> 
> Another solution that would keep large pages but still need fixing up
> later: Just don't use VM_FLUSH_RESET_PERMS for now. Call
> set_memory_nx() and then set_memory_rw() on the module space address
> before vfree(). This will clean up everything that's needed with
> respect to direct map permissions. Have vmalloc warn if is sees
> VM_FLUSH_RESET_PERMS and huge pages together.

Do you mean we should remove set_vm_flush_reset_perms() from 
alloc_new_pack() and do set_memory_nx() and set_memory_rw() before
we call vfree() in bpf_prog_pack_free()? If this works, I would prefer
we go with this way. 

Thanks,
Song

