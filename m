Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FBAB389CD7
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 06:55:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbhETE41 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 00:56:27 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:32074 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229470AbhETE40 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 00:56:26 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14K4nMAo025580;
        Wed, 19 May 2021 21:54:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=l5+WZA5DrKXGkx5EdU/5RbHuREHxZ4K8i9Uykb0O63U=;
 b=gc1Lfo8jlD8/0VYdJkR7rQ/8wc4lk7LwFERYi9SKEdNmp17mUtCR7a1RBTDauIefadI7
 Gu3lUMpmIKbE/dXEXLGrJpzJpy1o2dRPiYdLVHBY06vPIeYC5uIChsEWrVO4ko++2azg
 9Y7oFJxvs0cop+0E2CTLd/8J99qg48mw4aA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 38ndsw0u57-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 19 May 2021 21:54:50 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 19 May 2021 21:54:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iH9kK6u3XEt764lBwFubMxBXq6cj9c8HYXd+0gQq5q7KBGx8x0eeSKmmrR/hPdygF7EUtQY7VQMrV5NdtHaYYut+GgduKInthDcf+kPZ+130UY2mFIGFvcqvAIDAq/gmAi5WjVHQwtDZF9jQeeEp/SftgdC0QFM2rxwfSt8h44r3uU3n2dyc+Z+H6KrncAgQZRpa1flb+Wd3XSOcDbG/4dGGdLFfwJfqLiBM7Lr9DZoe6q0DWFGxaCUxYZO7JoVmpwccayAz84i7UJAKAcVMqO42P8lC6WAjZ/anucQawdPiv3z0pxzNEL9+iMd4bWVPevsuB04VopwnTje8c1jITA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xk6L279sH5jxlv1Z9Mc6kAMmwj7JQLilY5oXw91CE7Y=;
 b=TGAGlNTYklpC8oxAgveZL9q3VWa5p+x1dKFwY10xI4hNH6l7TpH35flcUakm6aqglLAWG0Csshne0zzSn9V09iCN1gI86odNrYFZp0prU71bn9Q7qIVsKCwxLbUVDkHwrnwQQmeJJhybL/9RepGT7mdG15gqjSmamUhqDJ/8OwrKdEcFgGqKguqIcbdvTFnpI27h6RFQJErNxV64+VSDp1X7heFVVRWipfhAzT0jojLIb16Hp/wsfmsatzYBQ+tiau1YcJajPToKD/7CcWxqbFLgR9PJwa/XOXDMUdh+o8CkOEuQFgX6fJR1atjU7qTnw+DN3y9rbXEcOuGtQVI+zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2775.namprd15.prod.outlook.com (2603:10b6:a03:15a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.28; Thu, 20 May
 2021 04:54:46 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::38d3:cc71:bca8:dd2a]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::38d3:cc71:bca8:dd2a%5]) with mapi id 15.20.4129.033; Thu, 20 May 2021
 04:54:46 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Dmitrii Banshchikov <me@ubique.spb.ru>
CC:     "open list:BPF (Safe dynamic programs and tools)" 
        <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        "Yonghong Song" <yhs@fb.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrey Ignatov <rdna@fb.com>
Subject: Re: [PATCH bpf-next 00/11] bpfilter
Thread-Topic: [PATCH bpf-next 00/11] bpfilter
Thread-Index: AQHXS2+BfiCEtb8dTUOLdshZKTKHZKrr0aKA
Date:   Thu, 20 May 2021 04:54:45 +0000
Message-ID: <7312CC5D-510B-4BFD-8099-BB754FBE9CDF@fb.com>
References: <20210517225308.720677-1-me@ubique.spb.ru>
In-Reply-To: <20210517225308.720677-1-me@ubique.spb.ru>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.80.0.2.43)
authentication-results: ubique.spb.ru; dkim=none (message not signed)
 header.d=none;ubique.spb.ru; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:fa93]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d484a440-3154-4c6e-fab5-08d91b4b63cf
x-ms-traffictypediagnostic: BYAPR15MB2775:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB2775E589F5C53A2839077FF9B32A9@BYAPR15MB2775.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZWR8LZM0jAN4FwHpGrJjU9O0HVPM1iyhxHsanD7jSA/oun3mYmQc7jkPulL/XgEfcY8u4+mGAFfDYpwvSXftEHXJT8pVIJHUmDhG0QWY0IzWvkxyf+jkivjaa1gkYl21vNrXCrGR9kgvvivdFL9+/RijKETqmXI1ccdTxBYhPIDDzwWvrzBh1Sv4JsuHd/VwkcsRsDe1bvQ3ZzNkTgxH2Y8a0RVsV64Q/En0vpTr6WpjpV65cllWdgKgCFsADB/WyBab7Ekisihg9vA1cpbCLtIjYv4SmYq7XTUXkWJqZ8Xp2rHQhHyJHkg3neqKN2+yqXy1WX6Y55/3UyQLJxmvtWmkWhFdC47DfUWFjfMJx02oYFXy2l4DawHji0WBoHK++qaqzk06ljDeiS2f8NazVaRKzVhSOEREfqpmKcPlzAQ64JRETFSdHUWlsv6KJozOoZBweZ8c6YEwfRyOBR1mLMALaMLkeWF8uYmyWm08OaCcy4Mq4Y7kj80hY7C2uNUY2OWcuOUg4LchDhnw4/kUwjSywdV2YjRv2DZoBeYyxy0EonosS6jREscvUVLgXLGHxYvXTaDEGGKLKg7+vOEkGWf0pccBbSJypV5GQo3wTdeUVLNGQ8FZCP/Ms9gvnjpb8mjMNeJ/ByyqPgFsPGN0nKobGkMEUb2EYuJiEAr+gP1Fqe+jqNsYEGIALTLPuwFuQDk5RAfI5AxVQ8UYpHgTloyMqoOM3k4OMjh7OnCEvZJT3S+6hXUFN1/Zg3xFDreeH+PjZOvBBnDao16ZAdjNrQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(39850400004)(366004)(136003)(6512007)(33656002)(66946007)(38100700002)(54906003)(8936002)(316002)(91956017)(66476007)(66556008)(76116006)(6486002)(64756008)(66446008)(2616005)(122000001)(8676002)(36756003)(966005)(86362001)(478600001)(6916009)(4326008)(71200400001)(83380400001)(5660300002)(4744005)(186003)(2906002)(6506007)(53546011)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?1Q7FOgaYVkifg4lASwU7ipmXdh1dg5oP4M/2CdlvHnWFSsOOLHihwRg0K4BF?=
 =?us-ascii?Q?XEYcpG8CVoSpSEDLmiw//TRxA20ABMO9oZbi0wCRbudNyC4M6iGQt1ZKTzPP?=
 =?us-ascii?Q?zTqLNv8Ro4RyeR/dnq+F44HmG8fz/cj8ePgO4Y8FOmjF0/ua5zOqKEZcU8sD?=
 =?us-ascii?Q?KJnQwKKdVVAuycCywFB8yHf8ZJX+lW3NXayhqgBD2Kb8DMai4zAycdilutiZ?=
 =?us-ascii?Q?gAwOb6yHj+jk7cUKaRAG2ppnAAlEiu17JcKkCNZ8wqw42OaZuTFZPBVaqz6p?=
 =?us-ascii?Q?3iiznPjz1TWhlYkyMjvxuUu1NRuYahMwvkwhXhoujqY0oej8DqcsGExQaSVa?=
 =?us-ascii?Q?sOR0ifjvY5LcYPb7aitwYAQKec3lvKi+bPPYJs47zOt0J8rghyjWivQvfO8h?=
 =?us-ascii?Q?F7JSNsh9hpTj1v57AfWOv1rBfOlIA+az0wPmrmN/EZgizdC7vJXCTGQ1b3lh?=
 =?us-ascii?Q?WMqDCWCxzsiETXhKoUJaqP7XteGC2meHeC8vfydiPXY6D0oMB1Sfa1NDg/fj?=
 =?us-ascii?Q?IGnoHumNLEm0WR0GWfPiBS+W7t1xomknht1CTe7Zn9wQ0x46FMlbr7dTo6Kj?=
 =?us-ascii?Q?YQEEeuJiuz1PEaXk0MT33gH3k888Cz/ub8w8jDmekfJjgXdhqMtt1xl67cs4?=
 =?us-ascii?Q?ZCzTMZd5tF0JAyZAm6FwJ/FsbvQJFeG5fbPO4YiDRjv86veO4l9yzMkTIfnq?=
 =?us-ascii?Q?hkI7lTagDk2jv7PCBC6I1lvnJSg9fUw2D/TvBn3IlolEQn45O7xxP9/1RMsQ?=
 =?us-ascii?Q?jC3LcGrlYi+WGvi6sKegOLWiEsbE2xtAmOGJ7Ry9s5NE3YhMjVEAd2GXgUT6?=
 =?us-ascii?Q?T8Eiqe9aDlAe0XJmYRH1cyq8gvsuigHggRsnfhLooU5IG/z+Iuuq7cD8lBa+?=
 =?us-ascii?Q?SuP2mWCt+lz3VQcn3rPgpXUbKdILphZN0BmXIJDnN7ngYpQmZj8+BJQ3nX0V?=
 =?us-ascii?Q?xWXu0Ud9Xh4Dede+4H1BRNdourqmyKn0qVIBZ8pPtiXddIcky9NCixbRBA5H?=
 =?us-ascii?Q?xgekZGx+hoNQhA8H+ni80OYrfgRN7Ys9oKThZ+k+q51sPUGpKF1j9ER0wpso?=
 =?us-ascii?Q?bgrJqZPhxhPrae/lxttC2S+EiwaDbBee13OLKeMQHb49F+5HQNcVoBLpz9/I?=
 =?us-ascii?Q?XldmJ45TMfello7GAtq8PMx60maq/j8OrJ0nhMI72EGZPYyXK9LFQbvhJy8K?=
 =?us-ascii?Q?bPYqhQaV+Y0RVhNkxFQg/LzFKeeU7MxjFYqjh5fUpmWbacbLONQxf9o/gA3m?=
 =?us-ascii?Q?PuLbpe7hbVzCsKTvBwi7jE9NR8d5uybxXAqkJsWgyaBdkEqFZEchRRWszQFt?=
 =?us-ascii?Q?9BQRpclvQVhd/eVFV0MI462mFPty+EGacA+I5ggg/b7kI3ET6JfcMWCRtLzb?=
 =?us-ascii?Q?wC72To0=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <63952C7903FD19499E607DBD70E8B936@namprd15.prod.outlook.com>
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d484a440-3154-4c6e-fab5-08d91b4b63cf
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2021 04:54:45.9508
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IDYZCunwL10F3LFAe4Y+knUQVNPQu8Q9RJNGqg/7bEXfkCXCFpPd3ivNy5Ybl7cadrf2RvFEv90VsZg8fgc4TA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2775
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: fmkYUi293XeLXa91LCp2kWWf1MfX-2Ji
X-Proofpoint-GUID: fmkYUi293XeLXa91LCp2kWWf1MfX-2Ji
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-19_10:2021-05-19,2021-05-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 suspectscore=0
 spamscore=0 phishscore=0 priorityscore=1501 adultscore=0 bulkscore=0
 impostorscore=0 clxscore=1015 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105200038
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On May 17, 2021, at 3:52 PM, Dmitrii Banshchikov <me@ubique.spb.ru> wrote:
>=20
> The patchset is based on the patches from David S. Miller [1] and Daniel
> Borkmann [2].
>=20
> The main goal of the patchset is to prepare bpfilter for iptables'
> configuration blob parsing and code generation.
>=20
> The patchset introduces data structures and code for matches, targets, ru=
les
> and tables.
>=20
> It seems inconvenient to continue to use the same blob internally in bpfi=
lter
> in parts other than the blob parsing. That is why a superstructure with n=
ative
> types is introduced. It provides a more convenient way to iterate over th=
e blob
> and limit the crazy structs widespread in the bpfilter code.
>=20

[...]

>=20
>=20
> 1. https://lore.kernel.org/patchwork/patch/902785/

[1] used bpfilter_ prefix on struct definitions, like "struct bpfilter_targ=
et"
I think we should do the same in this version. (Or were there discussions on
removing the prefix?).=20

Thanks,
Song

[...]

