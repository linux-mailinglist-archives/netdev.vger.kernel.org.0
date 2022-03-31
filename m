Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C98014ED0E2
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 02:31:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351443AbiCaAca (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 20:32:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233372AbiCaAc3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 20:32:29 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C592A2DA85;
        Wed, 30 Mar 2022 17:30:42 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22UHKYBV006003;
        Wed, 30 Mar 2022 17:30:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=S0LobyZCxT9s1tEhlUVyYaWyRLMty1+3CTG3qh5Jw6Y=;
 b=BpgVka6OwGZZoOPO4AGkUfcpFpPWNW7x+x+qeph0doPCOtGM91uklbXvCWis6ugcL/UM
 SAjgLnQabbPzrnIj6EkGjqZo8cE88LYI835ZuGFbFcFsqGFw0eLSDX9G2XqimrgKJ37i
 Hh2Vu5SVf6TiZbj853frHxm7P7xuaj69ZG8= 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3f4r984j6p-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Mar 2022 17:30:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lj3yQo9CzxQ7rqjRlvyZEqGWJdNkll3ykAvIVBfe3FnPLmAuERSANoXcKjLCQzm0RqStyV6pt6z1Ku3579KHKCULDDCywD8gI30jJ/QgrVTJm5tqIqxjcyhkm5EuCVs3e3ygOyD1/Sj7Qrcs1Ps0lkyKtaL3xbmdZ4y/d5jnyR7wEI0gWd8/v3g76lCl8eY3uDdYArF15iQ83sf6ZG7InJERpERLGBbWiE4xtTESYFhCJnFZndOUGLwEoBwrYbITTpohRg3sGUDxAW9117nzl0Be/V6fgxpeK6zb4b8K0Zqc0UeoPhUbccvSASARYtNMr2fu+4Bxbi6Urc2MG9DroA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S0LobyZCxT9s1tEhlUVyYaWyRLMty1+3CTG3qh5Jw6Y=;
 b=f0PWVCpn+KQwWOIjDqMOKbkwJycxPx98S08BXY2Fu+2orV8I47s9wZjP8saCeRLooNY7LYdMUpnCyjwwMi+IlimISZlVupU7QPAlcgLDsmAjFfxp/AQCp9+WFqcQMFlMd4UthSmMGn3mtCsh4FCtepBNE6QgZswdthxDFOh3/6XHc441OXZdHUsd2Pj12JhboiYpcVN7PSxqmRvSRDDTuwrD7WzVrHWXGIG0TVCgpBm1F1HGZiJXpsX822kB+AaBpwEVPR/j1Z0uuJIXDrQBwd7YYquRl8M9Z1Exkt3yuTFPWogmvgCpUnhkf+ISkvfRvnzOcmYC/WZOM7wQnB386w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from PH0PR15MB5117.namprd15.prod.outlook.com (2603:10b6:510:c4::8)
 by SA1PR15MB4840.namprd15.prod.outlook.com (2603:10b6:806:1e3::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.26; Thu, 31 Mar
 2022 00:30:40 +0000
Received: from PH0PR15MB5117.namprd15.prod.outlook.com
 ([fe80::e487:483c:b214:c999]) by PH0PR15MB5117.namprd15.prod.outlook.com
 ([fe80::e487:483c:b214:c999%3]) with mapi id 15.20.5123.021; Thu, 31 Mar 2022
 00:30:40 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Thomas Gleixner <tglx@linutronix.de>
CC:     Song Liu <song@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "pmenzel@molgen.mpg.de" <pmenzel@molgen.mpg.de>,
        "rick.p.edgecombe@intel.com" <rick.p.edgecombe@intel.com>
Subject: Re: [PATCH bpf 3/4] x86: select HAVE_ARCH_HUGE_VMALLOC_FLAG for
 X86_64
Thread-Topic: [PATCH bpf 3/4] x86: select HAVE_ARCH_HUGE_VMALLOC_FLAG for
 X86_64
Thread-Index: AQHYRIo9WDUGkE+Iz0SpJuLdkfmnTKzYmggAgAAJ+4A=
Date:   Thu, 31 Mar 2022 00:30:39 +0000
Message-ID: <66367845-0FB5-499A-B0E6-93A3209FE1CE@fb.com>
References: <20220330225642.1163897-1-song@kernel.org>
 <20220330225642.1163897-4-song@kernel.org> <87tubfm1wv.ffs@tglx>
In-Reply-To: <87tubfm1wv.ffs@tglx>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.60.0.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 73760ece-1f87-4f0c-b226-08da12adaef4
x-ms-traffictypediagnostic: SA1PR15MB4840:EE_
x-microsoft-antispam-prvs: <SA1PR15MB4840F7EE3F86B2A99AC6B2C5B3E19@SA1PR15MB4840.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yFwbYpFzQtGFJLcfiTlUmzk6I4c1xuYJIwUidQ/O0rK3dSX2XMSP5VmwHrbf+NCwzJFdgr3iWCmWup1dHvPVMEgGkFqgJCFan1mbrEieQYsR2P/6hSlAnHsYLMDYUJISQQSvFihiKaEjdsa4/UCBzKaNEmFuCVP7gMOCLI+eOa5iVdwDVodlFQhtqZBUk3RRuT+6NcbWwxeA5JgNK8dEAtl2OWRaC6tNE/aD+FS2tUEuGTzaBdhEWjVTIuLlh6Oa2zmzcoi/FTZxF1uHk+jbBvlUV996MFRm4z22qBhDX/NHLUI2ggSLroz+zklP/Ee0U2YIJ7eqaDtXXngAVwc0Yp1AxHYVokVpXdhNZ0gJ4SSfLGQyUuQqNa0wimWlAlxWsfEooeax1A5Q9SRDTw1elx+wZvqx20le9i7k+XWBBCGy72rrlyCt1M6f02SHlGozdkOJyohdlDsRYfG8SQtvWgbvW6rOkCg8Sis5DX7AKA5zs3+jOJ19LAh8qfLblaCEn+1IGOOZnT5k0G90UMn01F8HHWv2EiVKKBg4AHwUYK4RtI5VPFQ8XyFHDjpv4yZles4smLtsv0JxkIi+5z0xZ3QT3mRJVuyFkPgrrw5WjzWCyz9poVmM3hTB6JDfCL2CDy3DRRcQMyaCIlnFpKGIKTj7OVCD7WMGLoiD57bb7JgLkwyYd66e/jCv45cvBudsRKNOpbU0bfeSOYkvrQxwV3YPaYzPhZE9F+3PnkIIB//jD6UvZoQ29vN+wEdRXougqEOLPNpIiglh8NCQzfeHog==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR15MB5117.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(54906003)(2906002)(38070700005)(64756008)(66946007)(66556008)(66446008)(8676002)(8936002)(76116006)(316002)(66476007)(4326008)(38100700002)(122000001)(6916009)(71200400001)(86362001)(5660300002)(6486002)(508600001)(6512007)(83380400001)(2616005)(53546011)(186003)(36756003)(4744005)(7416002)(6506007)(33656002)(14583001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?rAPqznC5etCBB2aBlifnwOhfIhDEM8Um8rSoCI3FecxOSp1qx9ww2BwSstRK?=
 =?us-ascii?Q?ndRMbHiggNEZEZXSdT0opO/ILANxtAllG9s6d0kGy1KwCNNfwUV1OMFSNSvh?=
 =?us-ascii?Q?lm0H5Pw6WlsVex9+yRyDGM009aXwXk4gvCj5cUdw84BzvsJsSLjz2W5JAYqR?=
 =?us-ascii?Q?sAW5DJm0ZoSgHu6VOv8Yy/2WrgdUGi0CHQz1T8wQeVVknTVg9jwkS6UhkAyd?=
 =?us-ascii?Q?uUoXmHXR85YjAs5im0vZohyXprBDvZj6lnrfyupnr+pjUObmW5Hqc6LJM7SH?=
 =?us-ascii?Q?0GGv+S+lvFZzKHT3IJqklufbr4Pl9ARNyOEqdtGgFDfyZUgHxGd2b5lHUAuz?=
 =?us-ascii?Q?WPLu5Tm3/ippgYBE7TgLksvsFJSLD7zP1/R06YsD1Qe6juZE8IV6PTRiHbab?=
 =?us-ascii?Q?UL7kLgjEKpwRJVXQa4riUnN46t7I1zk9ewj6HjoqtqaqKF32OU4qwK9gnrQa?=
 =?us-ascii?Q?l6ptxeTWvtDg45G4CGdY6+LfCSWtNPj5aODghz8M5nAPkelQzWznT6NmEpQo?=
 =?us-ascii?Q?WpUNZETzKwvnZKuwN+rkAvjGHFPCqWktP5GB3Ck9DXBfxDA+q0EU2HJ7qcah?=
 =?us-ascii?Q?De1Z0saj4rtx0F37NWgfnKI/eVzE2P/ax+bxWNEhv1hIpK+yBOZusEB5ohel?=
 =?us-ascii?Q?krJuseg5OuEBGWmKJ6JOQADxRIdtqDvWw5bJr5ecqUYPcdibpjcf41dHVJV3?=
 =?us-ascii?Q?IY5lWDKg5gFFbwuZ5ew7fpxz/62UlHx6+vjXhHjIn0g6INxXINGrPmPlkoWz?=
 =?us-ascii?Q?5n338vEcxCH0aQfV3g3FNG1oQ28V53GQ46zWD73YYBFvYoTO5QtmyeIjNhXh?=
 =?us-ascii?Q?ZkIoS3yusBEt9gn0wsFXDkLHWe25FOrmWSDOBrEeehisoK/HcZIHlVjpBCuW?=
 =?us-ascii?Q?IQomB8sKxh9TAKHhp5dKQ7+wF0D4HyMF8XM4HALJ0d/CfhFd4Kzjl0n3hMJg?=
 =?us-ascii?Q?RTgVpSG2JRpnhuKxSDyqQJoETUnwg+c8S5ZV5YSAigaNezeTt7ldVfRGxcu8?=
 =?us-ascii?Q?cE692ZbHHx1qk0Ox1mB31+IR44sAaRosHYLFW2uQtgufFG/aQ0M4k1op/sRI?=
 =?us-ascii?Q?cg/5fk37uy8bM6olVrPcZd/qYra6n22y/iuQk/4PvDnnbAGwQMVLa8crd9jh?=
 =?us-ascii?Q?ql039eOdfbvxyHDe3PYVBvAmqm2iZMSVLf2c04DtyTdlIHfpziaQAlS76AqV?=
 =?us-ascii?Q?5Io1Ryn5eqRrfFQfsTw2TxPdfd+NxnTALOlpZKBl4C0io/amXZRYMlx46K+9?=
 =?us-ascii?Q?t3vFPAPGxRBtujfDc/18BHbAZGYEvcZHeaHR34PQ2MxphRl7eGhgpFPZApAY?=
 =?us-ascii?Q?C7ulV08Y6g71fmx+8NBjDhtaIRXu7bb5panveLext9SbQCRMqvp4V1jcV8K1?=
 =?us-ascii?Q?xbuwoe0/I69S+3cBsdfazxqO1ySDHS9L2PQ39tdprPBSeCcP3nG25NzxmHOw?=
 =?us-ascii?Q?HPVEXGOq8RVb3o9tPa1z+Em/5+HhZKoxzYAtuQOtRS5OiCCF6bQiD9cWNCKh?=
 =?us-ascii?Q?DIWGWl/fwQKWa6Bz5NMGpZYvW7F3+c3tpb+kSRDkirvy2A9hbE/HuCAEj8VI?=
 =?us-ascii?Q?Ic/LWRG8g3B95wnb1kpvhS/tQJ54QBaJ10tquCLaR+UcPXBEanCUK6ftkdS3?=
 =?us-ascii?Q?xHBy03UQxgOfxDKcuT+o7zffNVPzNlS7XYlWb0asYE7WB1HWAjmdo0sB9i7z?=
 =?us-ascii?Q?/gdsk7U+X6DdZ65eCrTxXe7wZspGpk2gxUNkRmdZPLWNLRpj3FZ8pJA5An+I?=
 =?us-ascii?Q?phwn/TVDEhZmIU0WRvGrht6ylaC8Syf/qRHOfuMWNoJ4vjStOO1k?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E6D2AF23D471154984A642131FAF107A@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR15MB5117.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73760ece-1f87-4f0c-b226-08da12adaef4
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2022 00:30:39.9167
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Xv6WPr8S32NazzZHD7ZKLRABz+CePv708Sbv0zTtPHe7yhDXrVU++OVlOjOQ3bOymyeBoZFUJ8CNrnFDir+hfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4840
X-Proofpoint-ORIG-GUID: R5FC-WnZUts9bgVIy4qbOXzSWrYaO385
X-Proofpoint-GUID: R5FC-WnZUts9bgVIy4qbOXzSWrYaO385
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



> On Mar 30, 2022, at 4:54 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> On Wed, Mar 30 2022 at 15:56, Song Liu wrote:
>> As HAVE_ARCH_HUGE_VMALLOC is not ready for X86_64, enable
>> HAVE_ARCH_HUGE_VMALLOC_FLAG to allow bpf_prog_pack to allocate huge
>> pages.
> 
> Despite HAVE_ARCH_HUGE_VMALLOC being not ready for X86_64 enable it
> nevertheless?

These are two different flags:

HAVE_ARCH_HUGE_VMALLOC allows vmalloc to try to allocate huge pages for
size >= PMD_SIZE, unless it is disabled with nohugeiomap or VM_NO_HUGE_VMAP.

HAVE_ARCH_HUGE_VMALLOC_FLAG allows vmalloc to try to allocate huge pages
for size >= PMD_SIZE, only when the user specifies VM_TRY_HUGE_VMAP. 

Recommendations for better naming will be highly appreciated..

Song


> 
> I assume you wanted to say something like this:
> 
>  The shortcomings of huge vmalloc allocations have been fixed in the
>  memory management core code, so reenable HAVE_ARCH_HUGE_VMALLOC.
> 
> Thanks,
> 
>        tglx

