Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED7A14B727B
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 17:42:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240999AbiBOPvP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 10:51:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241015AbiBOPvO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 10:51:14 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 165B527144;
        Tue, 15 Feb 2022 07:51:04 -0800 (PST)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21F7gPVG023429;
        Tue, 15 Feb 2022 07:50:35 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=5a1yTrZYQ+RAsU/DM1BZ/xM4uzULZkxiiZFJCEvh+mI=;
 b=oD3CthVJYS3LueljedvrBMuH0w0xIk8xBHnLWinHfhMJGDaNJ2AWbzf4fWGV/tpgiD62
 lfX4AzBl4TaADDRhIVxR+ducZfa7xlUJIS/PG1oxHLql8RgfGVckQdTNYiiyAdHpfG0j
 F9+PrFs3nOyvgNk0z+HCMwqE1vIYl/OKLj0= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3e825s49ra-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 15 Feb 2022 07:50:35 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 15 Feb 2022 07:50:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f0YxzbpHswiU6oE/YSW/70QTQ1deHcoeTia3tvGW/jpHWGM8L94n25roeM8sBlc4s7zUmdTL4F89ld+C0ou2bv7ez/GhdrPK/ZVQECbcRKaM3/Yj/mtcbCvPheY28iEeWTU0YokRQY4Wu0YZIRi7STjz/80kfrP6zFVv7yLjHRcnzZ3J00QBNsRlIiJ30mt+qkIcp0Qo093cbvOOQuo0q2k18nNX/5ap+cbNXwOLdbny7aFEcwPMPGTrwB2rV3G8J2OpNGgOmUC3HS6FkmfZSTHPUA9u+MoVrk5TNuMt/Msd0EcK/SbSDrz5hE2BnawqSdRSf9FvJR1/6Xn6oq06zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5a1yTrZYQ+RAsU/DM1BZ/xM4uzULZkxiiZFJCEvh+mI=;
 b=LBGBK1sK/lCfVx7XnhLLqdmvvJKijatxM1exHdF7k3Qg8t+rFdMR5CFuoYENY343f4A+a65cIJCU4bSJBtlV9wsDT8QPHJEei1NPZCC3EIvlOEkLp8nnq9tedx/Jeut5CcGB50bfrTZ1YivC5UgzRHwAu+iHsuufIk+ihG/95dUmFB9cesP2JPJOyPeu4Tnsy1ogrbf6djSbUO+nPz6vqJgNOaCbcRMdXTEMD+pLiBjCXYgYbskZeat4vMOwV0UjARbxxUOzm85oHZ2bgYB0RhC8IyG2uaOfAZgfNjbFlvCJw90STANfr2yuA/TaMSkjKkkw0NG/3m8Ex2c/B1MifQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by BYAPR15MB3046.namprd15.prod.outlook.com (2603:10b6:a03:fa::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.15; Tue, 15 Feb
 2022 15:50:31 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::91dd:facd:e7a5:a8d1]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::91dd:facd:e7a5:a8d1%3]) with mapi id 15.20.4975.015; Tue, 15 Feb 2022
 15:50:31 +0000
Message-ID: <4e303892-5bee-76ca-a5c9-05cd53ffb945@fb.com>
Date:   Tue, 15 Feb 2022 07:50:27 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Subject: Re: [PATCH bpf-next v4] bpf: reject kfunc calls that overflow
 insn->imm
Content-Language: en-US
To:     Hou Tao <houtao1@huawei.com>, Alexei Starovoitov <ast@kernel.org>
CC:     Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
References: <20220215065732.3179408-1-houtao1@huawei.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20220215065732.3179408-1-houtao1@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CO2PR04CA0182.namprd04.prod.outlook.com
 (2603:10b6:104:5::12) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b7179b6d-30ab-40c6-6b07-08d9f09ae542
X-MS-TrafficTypeDiagnostic: BYAPR15MB3046:EE_
X-Microsoft-Antispam-PRVS: <BYAPR15MB3046A628EC1469B9B0942ED5D3349@BYAPR15MB3046.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2089;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iAKyve7Znvw2cXCxzWvT3O4Vr32uLrNViRa7BstZHBpwVeT+8jnf9hKJzXW6B5nA/eX30lmTH3nIA+mhBHFviyDzQzdACJlu1Vn1YMSDu8x0EKHFHhmyIhoJXbwVNJd3Utj7oPx86H/8KlQrKQXq9e1cvXty5FQUN9fB1jwseZyBMmSKam9fCY8CW8QS8fRLaMHDfW88DsHwbQWRvNLSxcwfHMFxjRFZ98Z6EbFh4DYbYDnvmpjzr7wuccdycmFbVwcGHgEJvAja5Pviq5joQSu504thgvfn3vvXRbd7/bvm06CkJsOjMeDhE34Chcf8Nf1oYHegIz1E7tYsKfeHh5YVurf89lueCFe8JfGT/4k/kPj6GVO3E4d3GIApsfkENjFBOs0NsbjPleTRKZfyZUA+3hgb7eMDV0HBoosM/kRBdMR/0Yq79x/SdQpSXGcyD9LQfqVTMCI3lre2Qjt3q0hpBwnyL5k2kcKsaH5sh0AJk4wl67SiLD3Y990htlAc3FhLyPEtI1Ta7MB6p7YHudyDmbyk5acRyScSejtG/pqAYzY8MBCm4WmUCRJ/XS6kQRqtwuokmwn+FK3ADkg7h7/vXFwF1d4yzuYLOIneAVl1psFTFadYb70lc6w9WrhCHXwV4qCUijZykNz2dy/CrEtFxWVEjpbeQFFo3LuyrHS8y6UOq4mCjXvq9VurTMzhk7BZg02nAkb8KbDeLD8JLpnF6N7GeDwPNU/VsdlVgoJ1czX4EdsveFlEEFPhvo5M
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(54906003)(110136005)(316002)(2906002)(31696002)(8936002)(7416002)(86362001)(4326008)(5660300002)(4744005)(38100700002)(8676002)(66476007)(66556008)(66946007)(53546011)(6512007)(52116002)(31686004)(36756003)(6506007)(6666004)(2616005)(186003)(6486002)(508600001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ck1yYlRZR0FvM1NUTSt3T3lrM09ld2VDazBSbGZDK0JSdzZPYUhUcVQzYjB5?=
 =?utf-8?B?eFZZS2J5WDlMeTRVNmJxRm54NVV5eUplU1pOTTlFQlV2T3VOaUQxV0c1RDNU?=
 =?utf-8?B?bmdTbDdGaTZLY2hVUzB2SnVIZW9sSTdUWFFxQ2xMOUtya3ZnWWRueFI2cDFW?=
 =?utf-8?B?bXUrLy95REJ1RlpsVWY0U2dKbXNxVWZINDE4TjRKOWF6bkdKS3pEdjYvN0s1?=
 =?utf-8?B?dUw0djkvd0tXOHlxcE5NaFMrRkYrd1l5cW53aDNEYXVyNEM4bHBiQmxNYnY3?=
 =?utf-8?B?K00rTFlFUDRIaU8yU2ZuS2tiUXBOT3JjVXBqQ2R3OTRPQzRRN3llblg0aWQr?=
 =?utf-8?B?TVlid3FXK3JLeTdHdmFrVllFamFOSDVPRjlyMUVYUUNzSmVwTHgxNllVUFgw?=
 =?utf-8?B?SkUvT3pWQ1QrV0NvaXkvQ3JCS1hGZm9XcEhzakZsQjl1Q2JVNlFmZDRRNFJp?=
 =?utf-8?B?QVRBOTdCNVUvWHJseERpOUFDTnRXQWZrMzRWUTEvaEZrdUFUVm1rK3J2NzBO?=
 =?utf-8?B?TVZxUmo3UWdhNTFRWGF2VFdna252Uk9MUnJ2cEQ1UkR0Wm5SMU96bEVGUlNI?=
 =?utf-8?B?V25DOGs0QUprWG83SHpzRjRhVzhBbWRnR0duRXV2NkFYUWRXNEQwczBJUWQ0?=
 =?utf-8?B?T0lJV2xBTjVGRVBLV0NTTVRqVXhGTEFYT2djUmZjVzZOWGtFY2pIZmRPRlpK?=
 =?utf-8?B?aExLdmcyR3RpRFF6bnFHNUVZa2VWdlh4RW9lWFgrQ0szaDEzODJFMnFkVUFk?=
 =?utf-8?B?VWpnYWtZZUpFdXhHSFZaVTRoUTJoYXExcHhPTWsrRHdHaUkwUGZyczVNOVlx?=
 =?utf-8?B?SEVHbUpwODJSZmJ5eDZDekV4eC9xN2FmWjFSb3Q5N3pHSHIwVG9rb09aUkZs?=
 =?utf-8?B?VEJWMExEcWYwMDR0VEtIOGhoMzJ3SmV0L1VZU2xXRHNrbnJtS0dSYkwwSFFq?=
 =?utf-8?B?QzdIb0hKem0vQXZGVkpXZnEydWxPU3lFaDN5Y0pocnJnRWxjMW1UVDYxeVoy?=
 =?utf-8?B?MElPdzVsSm4wT0x2ay9vOXlsSnM4MjdacFFYcUtiVFRHeFA3VnZCN0hoYzlR?=
 =?utf-8?B?MVJOWFdoOUxFWURmb2dWM2haOW5zWjBHdDg5Wmo1UzFOQlFaZzhVakJkTERT?=
 =?utf-8?B?RnAvM2M3RFVDQXA2T1lCSjYydnFFNmMvMUNEL2tvbkswSDFuOEE4RzdLWlVU?=
 =?utf-8?B?OWxIY3RvQXpZVndzbzVEdmtzYW9sVTV0UEdtVHY1dHc4eG91d21lS3hYUjd2?=
 =?utf-8?B?cjI5UHY1V0Mwd3VMVVdVU3hzVUJrck53alVqakExNUVYLzBKdEVXTGV2ME9u?=
 =?utf-8?B?SDcrMDdsSlhzVzBDeVgvU2RwMnQzN2trWG5qdG9HT3FDdlUyREk5TGJndDlv?=
 =?utf-8?B?b01zUFUrZXhneHorQmpvYXhvc1lRT0tYN1RiZUJEUUE5WkpRd0Z4dDRxSERU?=
 =?utf-8?B?ZlZFV1RTaFB1T282TmdyaDRXdmFYZStCVjZhblRUaTVuNEhsRUltaFBtVFJp?=
 =?utf-8?B?NHNaY2VCZXNObGNMTnBPTmhLWHJHdzY1eC9qbzJVS1dGWWVWY0d3bDk1MDZH?=
 =?utf-8?B?NERVcFRJTnIvVmppT0xPNTJKc0oyb0x3R3lPZmExS1ZTMG1FZ2cwdmdMTlMx?=
 =?utf-8?B?bnlqQlI0WG5NUURKQjc4dEpEN05oemxHS2krekRlV2NsU3VjUHZ1ZjFNQmR6?=
 =?utf-8?B?dFY1K2xEbTFzTmZQWm1zdGNKNm0wWnBFSk5XR2ErOWpHSndDQW5ncHlDNE0x?=
 =?utf-8?B?c010Uk9PSGZWOFdIRS8vSVJoY3lhNS9PTmtEWTdJd2VlbC9hd0JUaG9kdW9B?=
 =?utf-8?B?bE03cGQ2bHkwaTNNMjdKOWFQRHBuVVpDc2I3SnBlV2hadWQzdnd1bFV6REZn?=
 =?utf-8?B?eklmUS9oV25SZTBIRzBCV0FNalo3YjZ2Y2lrUStSUkpmbmFkTUFSbWxNNVdw?=
 =?utf-8?B?TjRLUW54TnZMbWYzenVTL2FMK2hCZkYrUFpPVk1XMnZrUTMzcHlFRWFaQjli?=
 =?utf-8?B?OFlUa3B0WVJ4S1FQS1hUYkhVT1VqSkdHck9lZndtRFl5c3NnL1EwWGs2LzhO?=
 =?utf-8?B?Mzd2dEVYZm51am5tUk9FMXgxTDNNdWJISzZYd1A1MzdFNFNBQjFuQlJvY1pW?=
 =?utf-8?B?dytKcXFGWDNmaG5Wb2J4ZEpEdmtNeCtXK3pSNDJWcFVFbS9lcldxenlnSjVR?=
 =?utf-8?B?QUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b7179b6d-30ab-40c6-6b07-08d9f09ae542
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2022 15:50:31.3163
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hs7kz7Lk2FprkXmQ4AdaDutbAn0pL6XoMbWI9U0RCgQ3tn2WtV9XbU5JnfOIYbGg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3046
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: 3ApGqCxpq8Yn5xc795ssxr6Rk-Up2DMA
X-Proofpoint-ORIG-GUID: 3ApGqCxpq8Yn5xc795ssxr6Rk-Up2DMA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-15_04,2022-02-14_04,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 malwarescore=0
 spamscore=0 clxscore=1015 adultscore=0 mlxlogscore=785 suspectscore=0
 bulkscore=0 lowpriorityscore=0 impostorscore=0 mlxscore=0
 priorityscore=1501 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2202150093
X-FB-Internal: deliver
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/14/22 10:57 PM, Hou Tao wrote:
> Now kfunc call uses s32 to represent the offset between the address of
> kfunc and __bpf_call_base, but it doesn't check whether or not s32 will
> be overflowed. The overflow is possible when kfunc is in module and the
> offset between module and kernel is greater than 2GB. Take arm64 as an
> example, before commit b2eed9b58811 ("arm64/kernel: kaslr: reduce module
> randomization range to 2 GB"), the offset between module symbol and
> __bpf_call_base will in 4GB range due to KASLR and may overflow s32.
> 
> So add an extra checking to reject these invalid kfunc calls.
> 
> Signed-off-by: Hou Tao <houtao1@huawei.com>

Acked-by: Yonghong Song <yhs@fb.com>
