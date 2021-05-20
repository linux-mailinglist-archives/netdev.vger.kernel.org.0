Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D04B638B45B
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 18:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234013AbhETQhd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 12:37:33 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:10884 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231761AbhETQhc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 12:37:32 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14KGSkhK028474;
        Thu, 20 May 2021 09:35:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=5MmAF7R9yk5HKFXkxe8QskTpmnEH2dLBVfFm+dc9gsY=;
 b=V36XMPxkDikN0hSIF23wO2Zf/59p5gO3Z56U4ygRjCaU2YtWqCe8B9xkiPc1CN22bzz9
 vkRxaz4Ym9QDqE26aYUcWWsZVxp1MEP0IIYkg9NhsLa68qlEY3r/hurRTRKsSe6zMCci
 chdJlx++sXywzfmTFMDi7odoC9V8VAtxTa0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 38n979nw8p-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 20 May 2021 09:35:52 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 20 May 2021 09:35:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b6Eab/ZryEcJFyfXwHk+9brOZnALiaE2x+oCRJtyzJbIgu4GuVOjBlQGVIwV2H0lS8BXxNVGgxugDF9jhioOQcXEC0YDQ2aolvOoFcD+xCeiMja8E2hWX/vDmTCIaTiUUuB7Q8gcGSz7ZUAVuyBMJ2K4e/eqQvsdUEh3Am75ls3HcGaWAiJ0T3j4a1FyLPE3WVYGVwhjdkQ5/LUoQlqwJx2xfYw2wjqEoBeEhPKXb/ChaDSBLETaLRBgeCxjMIIigC8lT4sUvdXtmVz9EpZAIKyjiV5V/aiirS811w51TmGc8q8H5+OWgiVlbcvp2M/pN1MLlW0CSg2l1rOUXEAmiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5MmAF7R9yk5HKFXkxe8QskTpmnEH2dLBVfFm+dc9gsY=;
 b=QE1+gFjR6v4Tul5FIPdmf1ioQgLY+3vP6Ci4npSV5HEtAEPCPNl7dXvpMI0c4VLi+NesuPvnYAmJfUZeQ0vltlgFmQQK//wcMQ7Kjq6hyXMznjaYO/0yDM86+mv3Zp9XM4+R+eHemKwh6L0OJu1XNkG5ePQmkdDKmdRShJNZZ4YhohiXGdy3VbiZwSTeJ7at6v7HPDDMT2PEpvFMUVNi+EbrxInViDBZR5MieweRJoBYQEkXbOPeOxiYUgGeQ1vIYwEFhfzKg2TFNVybjjBBNOzPnFtXfPDWYI4DcVAD5TXEyoF1srI50r/sZ3QmLI2Y3ADposOPOmtCtKpCE6/4nQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BY3PR15MB4882.namprd15.prod.outlook.com (2603:10b6:a03:3c1::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25; Thu, 20 May
 2021 16:35:46 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::38d3:cc71:bca8:dd2a]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::38d3:cc71:bca8:dd2a%5]) with mapi id 15.20.4129.033; Thu, 20 May 2021
 16:35:45 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Dmitrii Banshchikov <me@ubique.spb.ru>
CC:     Song Liu <song@kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, Andrey Ignatov <rdna@fb.com>
Subject: Re: [PATCH bpf-next 02/11] bpfilter: Add logging facility
Thread-Topic: [PATCH bpf-next 02/11] bpfilter: Add logging facility
Thread-Index: AQHXS2955Y81kbvm3E6M0qT0RiTrzqrrEv6AgADj54CAAJ6XAA==
Date:   Thu, 20 May 2021 16:35:45 +0000
Message-ID: <681F9A5A-63F0-432A-B188-CF4FC11AF2A8@fb.com>
References: <20210517225308.720677-1-me@ubique.spb.ru>
 <20210517225308.720677-3-me@ubique.spb.ru>
 <CAPhsuW4osuNOagPRwUB30tk3V=ECANktt9jzb+NK1mqOamouSQ@mail.gmail.com>
 <20210520070807.cpmloff4urdsifuy@amnesia>
In-Reply-To: <20210520070807.cpmloff4urdsifuy@amnesia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.80.0.2.43)
authentication-results: ubique.spb.ru; dkim=none (message not signed)
 header.d=none;ubique.spb.ru; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:fa93]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4b8bc7c8-dfe2-49ad-7aef-08d91bad5172
x-ms-traffictypediagnostic: BY3PR15MB4882:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY3PR15MB48824C7A6939D57BB4676C68B32A9@BY3PR15MB4882.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WwsL8aCPbYNnMyeJQmOmRLW7DQn4fttKBR0t9iJ5P70NIvQZOeKjPQ69wwjynRRn823jqYlLAfmWNnWk1C8tQZaEOivXUvN1igfhbaFP7qfBRIxE3/UA+wqCmQ+mgqtU7X5m9eE3It2uVGGy6iMxkSUkIgnkPVGhfY/ERa4CaryY4dMb+Gov1G1oNaMxGFJAsxFZFThFbx2MFqYgXxUrF+HaaaUoLXbkrrkFSg5qnrLFcHR0pmB+eXVtCyMUMPgr1SymtzdXqpOemz2ZslHSE95tkYshGmv6tslWx9MVgskHfIT8foqpZrnlYo72OG//y6Mwl81wT9qWV2H3pXEQdWimKA3muWWi4ylI72KaIqzNjZbNm4scSBj6AVhMRNvwTMdSoy7h4GuFMBN6Wfsv/cmZFk6WpmANXiI/umFDPJWlQ+0hRNNdUuQOFjdcZwgkJ/xBtUuOQLTfkvwxTkzYbooiRPvTSktIyU9pUb/DqhkpQRhIgRC3pSDv2BmaEKNgPOIT0spToiWuYWOrHDqHrf57ENzH0r6cR9rd1xYOpqPgXoofM2xGc0+sKHGbll1K5Da4/hhL45BA5/o6mqeoJugEdlK+fyrGfMK/nbmBwQWiqWrk1inyRq6wd+UhV0DiUnPxYLJlQ296P/qJ2V1za40hMjuEK9Qeyu9NGKZwwaQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(136003)(39860400002)(396003)(376002)(38100700002)(53546011)(6506007)(86362001)(5660300002)(186003)(4326008)(8676002)(66476007)(122000001)(66946007)(316002)(54906003)(66446008)(2616005)(36756003)(8936002)(71200400001)(91956017)(478600001)(66556008)(64756008)(6512007)(7416002)(2906002)(83380400001)(6486002)(6916009)(33656002)(76116006)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?MaUcpNEqlfcxiTTRfMccJxRwWZtHv84xAyAjDAOwuZlzTgt6lLx+Kynt0xOw?=
 =?us-ascii?Q?z7FQE3zTvBEFkCOOZ0R8+po3/HNolwCinY0L8EV2WXmU95uXSp61EgFUnxra?=
 =?us-ascii?Q?Vlv7XrJGk6l/5+dr8C3GS7czrUH4K4zVW2OpXsuVeiTiKhdy6qJFvBMh2NeY?=
 =?us-ascii?Q?awU/T7ieclMpQFfioKCGEzZPhJ6IzxjspLLj9+t4ApxiCgTewxIlg2RBRvW/?=
 =?us-ascii?Q?NVTNZ5aYwl0o+ULp+bYLuqDTOmhMt8RygCkv1jYDIPNRbCQeplpdWJkXmI8z?=
 =?us-ascii?Q?XikL6eQJ17RVMivRl7VBgtCcX3Pvmw+t8Ws1wNGlAxlIDSRU0kAyoMxvjHLn?=
 =?us-ascii?Q?/2R2KkyEPlqJqwr0a6PbuftYNHwIfRt21asRhP4LhnoRxdU8DikD9ZdnXtxs?=
 =?us-ascii?Q?ykfsltl5PgHQ5GF6SVcZ0+DeqsH4bWXLz2W5c2ntJ9xYUuvdo39hmy+FDBbP?=
 =?us-ascii?Q?kX349BqrcC+/Adsk20arp6421qK/Ar60bn8pG1gd60LO6b76mW4xZjJZe9yh?=
 =?us-ascii?Q?xdNay6Dqx5NdYC2yr+iopZw3ppj/CanFaOccuLOsM9LBruH+zscTnGM6gCMC?=
 =?us-ascii?Q?/HjO/uyDs8+2Obs4OII4vBngHVVK9e8U9I+GGk/r/wDgivDmDmQs4iukIWwX?=
 =?us-ascii?Q?nbmYmoI6s8+vWWFDrseIpfQI2qGM9O/WL1BDsrSoSaiMJot9rSz2RhxP3Dw4?=
 =?us-ascii?Q?ybV0kYsRuEaSSgAWzvRV/jFprRTwL49rsLz2XzlbomMmmQUP2s5Jlc4kqK/H?=
 =?us-ascii?Q?dFccdFZrdGIXfbJtdROlzcZ6IYnGtuKcSVkjseZ6oDMIyWa3DtsB0D6utUdZ?=
 =?us-ascii?Q?m3tjNVIzfILLaUXnCMUtlhxUn3z13j8lhSVOAgAL53+Ry/E63RZB7pl1b9zJ?=
 =?us-ascii?Q?nSIZBXtkHYiBeoSRl62IddXx3t5ZXarjMyWI49+NtbJIrcovPAgz2SgGQoLm?=
 =?us-ascii?Q?MZQI2pF3NMGkWcZu1+R1RDj/tL6T8VcQfqM/kUNddQ5xAZQPEgHNI9XdpK3V?=
 =?us-ascii?Q?cn4z+warR2sz2zCpsFmDHG8/+oO6vWERPuZBtbEg5i3XtVFR4AO03yrIaVCr?=
 =?us-ascii?Q?yvE3ysPyErta3T2NYXIZJoThVMMCnuagf1mIHmPAmxOcEqlNBa/q+1k4YHgF?=
 =?us-ascii?Q?f1B23VT2E2H4Zs8BKwIvfDYFpAFDh88JhhY0kRJspPZGO4pLS1a36aI87uMg?=
 =?us-ascii?Q?puZfO6Hm4iuc6rT9SQi8aBMIaPb6sDd1M7LaVuncbqe06ZQSu6DFqSAXgSdW?=
 =?us-ascii?Q?KsV9Qvod8XyLwdKUY1I62+rwnQrcW8EFaPD9nwQLI0FT2T4OfEG1Bpjz+izV?=
 =?us-ascii?Q?uF2qmGebfUJkUQ7zFsZZckp36r2G5vX3X71S8X/jJP2NNAhHKeFLBEHU0ACF?=
 =?us-ascii?Q?trCvFa8=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D61B3AEAAF391841AE7D1A65D7ACA9D4@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b8bc7c8-dfe2-49ad-7aef-08d91bad5172
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2021 16:35:45.6916
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mV8loN9NHgwIzBTxOGu2z0NkiYEydVTPuYeWBa0n4vFwXmVTHSr5GmJv4CTvKBjAMJmszCgbsaU+ngBGpdWnog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR15MB4882
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: QPOunLBxdlCGjvgIglXDbXbsEyVodQPJ
X-Proofpoint-GUID: QPOunLBxdlCGjvgIglXDbXbsEyVodQPJ
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-20_04:2021-05-20,2021-05-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 phishscore=0
 mlxlogscore=926 impostorscore=0 lowpriorityscore=0 adultscore=0
 malwarescore=0 suspectscore=0 clxscore=1015 priorityscore=1501 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105200107
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On May 20, 2021, at 12:08 AM, Dmitrii Banshchikov <me@ubique.spb.ru> wrot=
e:
>=20
> On Wed, May 19, 2021 at 10:32:25AM -0700, Song Liu wrote:
>> On Tue, May 18, 2021 at 11:05 PM Dmitrii Banshchikov <me@ubique.spb.ru> =
wrote:
>>>=20
>>> There are three logging levels for messages: FATAL, NOTICE and DEBUG.
>>> When a message is logged with FATAL level it results in bpfilter
>>> usermode helper termination.
>>=20
>> Could you please explain why we choose to have 3 levels? Will we need
>> more levels,
>> like WARNING, ERROR, etc.?
>=20
>=20
> I found that I need one level for development - to trace what
> goes rignt and wrong. At the same time as those messages go to
> dmesg this level is too verbose to be used under normal
> circumstances. That is why another level is introduced. And the
> last one exists to verify invariants or error condintions from
> which there is no right way to recover and they result in
> bpfilter termination.

/dev/kmsg supports specifying priority of the message. Like:

   echo '<4> This message have priority of 4' > /dev/kmsg

Therefore, with proper priority settings, we can have more levels safely.
Does this make sense?

Thanks,
Song

[...]

