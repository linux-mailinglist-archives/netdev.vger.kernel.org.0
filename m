Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1852F5252E2
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 18:44:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356639AbiELQoh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 12:44:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356633AbiELQoe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 12:44:34 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB9AA263D8C;
        Thu, 12 May 2022 09:44:33 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24CCr0tW016620;
        Thu, 12 May 2022 09:44:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=6MWXY0pv1AhiP58DwuMXdGdLbQXtsXQLA/2vO0UmTDo=;
 b=OqgTtjwc8HoCa+V1iRSzKgJOFQkDGRbsAvl4kRe+g6iNTS6NRPQfJcRHdaGIYKgA7rUR
 pQjSj1tHQEA4nHRb7WqfcCN5UlP5dOTUxz7K8HImR61uVxp1uMdqQ997lalDaHt8z8g5
 besjo8cl1Dzwix+WU1wChFfn/nl1kxvXSTQ= 
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2172.outbound.protection.outlook.com [104.47.73.172])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g12mthpac-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 09:44:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xacg1iHKd0z4jCTjiI9OkhnnQD7zyqLLYF9lbU6vqCljO6tMeOd7T+a/gbC6mRNcJspGN5pJny7ony45kTm4Gossui8LkUUVif0NYGwcVVO5HAFR7V6mK47sWCFUU2ARMFg3BgCmPPbAn8sqGDpYVwEWT7MqK3B3RmUIs46kv7kiVvOGzizuATUU/xL7M9osgQAhAAgJ0IObsUkgZOSqZJYCXKKSjbzbWfm8J65nLDsDIF1WxmPF1FC5zP9IvFEobRwNF2J1gRJvATfick9F+N84kXHNHiJrj0FCa2lG/iCrtoHWejCwaeD0B9BHVc6XZjtJ+eWWPfn3Top1QceQlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6MWXY0pv1AhiP58DwuMXdGdLbQXtsXQLA/2vO0UmTDo=;
 b=IsPHlMHR8re1nDUO9tgakjnFtG9enLKFRA4ghBOhQHzjZaNfexNwJhHRwlblO7xWQ1uxs/pwpWtr50+Emv3s3wqyKPhCLVEyO8AvOdxcubftSNOXsIvOi0jvs5lZleVb7srColSo2bNRQ9EyuPSvWTShem4/ld9WdFHwM8uhkRuUzcvkys09ZtijZeuH/vtzCVQQK0rKnG5OI9tMKvgvmELEZ3rWfHhq8/vLFEEZuCLt9fS2he6pNFEdQ4of9QsoW4vmvHWsZBiwok+jNx+KuEydLewmK0xXDIel0Xm8/+OWS2rCQYyxYjiWADNtnKdvxeXv/ugQxaZDqQI7jrkhCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by MN2PR15MB2942.namprd15.prod.outlook.com (2603:10b6:208:ef::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14; Thu, 12 May
 2022 16:44:30 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::3061:40ff:2ad:33aa]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::3061:40ff:2ad:33aa%4]) with mapi id 15.20.5227.023; Thu, 12 May 2022
 16:44:30 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Wan Jiabing <wanjiabing@vivo.com>
CC:     Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] bpf: simplify if-if to if in
 bpf_kprobe_multi_link_attach
Thread-Topic: [PATCH 2/3] bpf: simplify if-if to if in
 bpf_kprobe_multi_link_attach
Thread-Index: AQHYZgsJjyYtc2p0E0OnrQeTVlfDR60bcwMA
Date:   Thu, 12 May 2022 16:44:30 +0000
Message-ID: <BBEB2EA2-0A6D-402C-B10B-F2EFB3CACD7F@fb.com>
References: <20220512141710.116135-1-wanjiabing@vivo.com>
 <20220512141710.116135-3-wanjiabing@vivo.com>
In-Reply-To: <20220512141710.116135-3-wanjiabing@vivo.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.80.82.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fe60d4ce-a255-474c-e059-08da3436afb9
x-ms-traffictypediagnostic: MN2PR15MB2942:EE_
x-microsoft-antispam-prvs: <MN2PR15MB294245DABB37B7E5C770348EB3CB9@MN2PR15MB2942.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tnmbZJZyNfwxOf90jWlCEOq4XZdD2LelmOx5jcDHjOTHM4/NoXg0x5e1ikP1XYbnwMSWpM2O3Ajx2QPyWg4n2a5jyq+yV/2gXK9jo7c16Ly1wVgMmkELSRayI9ms1fGp6akBNA828l3jiU5m1fKoAVAZqccBjX8IBkI3DXs9R3NdaIJddbX+Mbr7GkB+I01FAa/tI6p1JeAM9fHLKliWRi5YdCfUo+DnmirS7t2WisMi+WL9G2IMQXu/Ij0m1HtsSZtO7EDUTBYnOQ3yW0WqwKlBNkPK1aS0VunU6dHroXZkmabLIA+WkFBEHcVEdBHUFRCX+oEgV3AlGFPrRZ98svwDJ0Wzx7pQBPVgGZ/c5KPPKzYoWr0PacjCOgX+79FakANySHCoKJ5jW9Qm/lPGdThOrcmQnaE9bjq7tQQMzhZfmkgQzTkMqcwH2qxwVgyViiKjxA+PgrAyRtPZAQSU5BQTvSY9LqosFgMeCOjbrdB7YLcPy1Jyv46Bj5qKLWySwZg5hHRt+KfdLXIHIwDOP4K7MkfZccbJwZoeGY4ncE2mcKLCvLlyBFsXvcaHSqOgqxaZS9hnhiVBTsjf9T62zic82SOBAZ3dd+fRcYO4sJBCk54aSd5XxIUO3YiNq021aaMrooCzzQDKxgWk5+EyFyigBesR55vf0sVF1hLdQRC54gR2X+RtIew/Wgc2HC4ZGQv4dTQFKqHzT6UbN0t4RT3GMcMUsnbHzcOt4sKYU2E=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(54906003)(6916009)(6512007)(316002)(2616005)(66556008)(64756008)(8676002)(86362001)(36756003)(66446008)(76116006)(66946007)(91956017)(53546011)(4326008)(6506007)(66476007)(71200400001)(508600001)(5660300002)(186003)(7416002)(83380400001)(33656002)(8936002)(2906002)(38070700005)(38100700002)(6486002)(122000001)(4744005)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?oRBEQBcLpQkacSrr3+1cB9Ganu3o8ywPzJgLACfhr9WuTlTptmh9DhPyx4pa?=
 =?us-ascii?Q?e8WTBKqnnr9jWlV4G9GArOwt0pfsG3rNLEli9IFlbjyey67kFN82sr5pD67X?=
 =?us-ascii?Q?Rytnik/XslBTdoze5YT10Ofpg4eWFRgaTW5bq8AMdsIWmePK8lV9czXmUZG3?=
 =?us-ascii?Q?HHVy5YtIQujmZh9E03Bd0UAiERu+v0pnY5m+9y8k2xt5NRqY0kknrVSEyffN?=
 =?us-ascii?Q?dJI9e9fSX8SC08JUtGoPfI1Lw3R/mRwnb8NqFi9MnJIy34ohitoDDHCkOEKF?=
 =?us-ascii?Q?RQIVSfoVwjf5Ct0OHz3GaPhcwo47pVJKf2bfYXfGKZZF+t7/6oMreakcoUgo?=
 =?us-ascii?Q?ByYVP0DmvJO5AtbdJ/a2l0V41F6Y00M3VSTU+QVQ38mnRwDXt2cE3/H1I5tR?=
 =?us-ascii?Q?0kWZJC1X8lRnqy4nodh6hB9PBAbGNpfYd9zgK0QU4W4uNPMKiJPLYmI0Cp7V?=
 =?us-ascii?Q?1axEvkSJOnbL95+8ddddItiHLbO1JbMFpJ/3H1HNZNGIm3kfXc8hE4e+fiG4?=
 =?us-ascii?Q?9PWCLJ5p1kAxYh2EskMST/XpTXE+RWhhluuS8Ne53Yp3nAoShKmfih2X+v1F?=
 =?us-ascii?Q?L6+3LCRH7J3qiHKaV+fN8X04S8Tcl5dk0nL6XZpeD2ugJrVcluoKMzbQh5Jg?=
 =?us-ascii?Q?FLH+VEoCunkMltjkgYARQ9cJBahZLbIHBX1bOMetv8w+faHvAGfTBTegIiR8?=
 =?us-ascii?Q?jfjDKHP3e1R0jYtiHCA4vKydxT5uq4Gdqgx1zksHIXF5Z0NdSwyMHrAAhFvl?=
 =?us-ascii?Q?JKYym/HhbYfg1pFUpLPYAeY6QgiKbnm814mwDnLuf6cq42vxXq/HyfP929SK?=
 =?us-ascii?Q?94rVbHXveW7sAG51m6kSHwfjA6KxOcVdX8/Pa950gwuRs6fdl4qkuPT0INzA?=
 =?us-ascii?Q?tnbwj4KSkfTyetLVJ2oNjQNoHhycmZ5rCbuzvf1uGynqBYN5kYYTC3Jr/zG+?=
 =?us-ascii?Q?1l/dj1WFtmLvjk3Z0qbWmmM6/x+WKdAZD6ciCxUlxhYEfGRrHYL/34Ycy+Jx?=
 =?us-ascii?Q?+OykPf4TbQpKjVbBe1Hh9FNYhEvyN79KaD4pOSvJVQVzoATgI7gjCR+iuGQ+?=
 =?us-ascii?Q?ezNZ4xnlzzXpdfoSfxUkuPXejuj6Qw2OzmWZcMhtkzp4TKQfmXIrux2yno85?=
 =?us-ascii?Q?x0KsYd5TXc5Tf5c/lJEjkB4gkg/++43pnP3H2h03mnNJshdS9d+j9WtKdQeM?=
 =?us-ascii?Q?tDnxQpRliYeFhyRZytp/GMeWffJjcHMGw8SWX4BpI3jtUxQoGLxxOflIoxah?=
 =?us-ascii?Q?bb2q9T8UGxejjz6ezGMH+GSLnXzmnb+ZwU/EQQxwREwMosVclQNlTZMBVtb+?=
 =?us-ascii?Q?IgxfKNWzaCUMpmk4hm1Na8rA1oYMBG5/gzPL3k7AT0n4GbF+vKcfk5QPqg+6?=
 =?us-ascii?Q?fDapZXeUKUArcV0Mwz+7XBGAzYl6VVVtNi2LmBOdkYFp6INY0ApKKwihD5IV?=
 =?us-ascii?Q?pS/LTU5K3IFsMY9vTyDIlwJcLS1YWPpiewEIdqKDQf2VfUuW4ChnyEXThvM4?=
 =?us-ascii?Q?iyIM2QfoqpvKZ52epjEc9wDErGaZTg/J4H0k8cwkex867Ged3FWJANZHiA0w?=
 =?us-ascii?Q?7p0e/88Hrn5WmYXLahzKqCtcB8Z6UZLoRgZCwvmpggWsNCmSUmceyLS4CIUJ?=
 =?us-ascii?Q?sYTRE177ODvCyjhDoGRGlEKNR/HmRBPQ4SFKhCCFAiEAszmzHRSU7Dye276p?=
 =?us-ascii?Q?jBKdwmDUGbBy8RbOBrJxKPDHXs8vBkVpzqNNIvRsJwL/i79LRpkTnzDwKjjs?=
 =?us-ascii?Q?zHHjJgd+43nKn5bfI995CVhygf4Id/6jWZtVETu0dX+tTF2bZbXr?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <72FBDBAAA4639445B981B2094F23788A@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe60d4ce-a255-474c-e059-08da3436afb9
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 May 2022 16:44:30.7106
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5zki9S5trN6GzfFxsmk6BV+rvyPhtgBeI9yYVDAKFYaJeU9OjDEDdXzP8ZgU0oX97Lp1MTvA8cjFvU4mcD8G3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB2942
X-Proofpoint-GUID: Zk9Q33CSJ_KusP4K0F2L6Gj8KOSytc7q
X-Proofpoint-ORIG-GUID: Zk9Q33CSJ_KusP4K0F2L6Gj8KOSytc7q
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-12_14,2022-05-12_01,2022-02-23_01
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On May 12, 2022, at 7:17 AM, Wan Jiabing <wanjiabing@vivo.com> wrote:
> 
> Simplify double 'if' statements to one 'if' statement.
> 
> Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
> ---
> kernel/trace/bpf_trace.c | 8 +++-----
> 1 file changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index 3a8b69ef9a0d..1b0db8f78dc8 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -2464,11 +2464,9 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
> 	if (!addrs)
> 		return -ENOMEM;
> 
> -	if (uaddrs) {
> -		if (copy_from_user(addrs, uaddrs, size)) {
> -			err = -EFAULT;
> -			goto error_addrs;
> -		}
> +	if (uaddrs && copy_from_user(addrs, uaddrs, size)) {
> +		err = -EFAULT;
> +		goto error_addrs;
> 	} else {
> 		struct user_syms us;

This changed the behavior, no?

For uaddrs != NULL and copy_from_user() == 0 case, we now going into
else clause. Did I misread anything?

Song
