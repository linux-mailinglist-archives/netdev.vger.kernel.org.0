Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D57194C9C7A
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 05:35:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239428AbiCBEfu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 23:35:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233909AbiCBEft (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 23:35:49 -0500
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2094.outbound.protection.outlook.com [40.107.114.94])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F2E6AD13F;
        Tue,  1 Mar 2022 20:35:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m+641727fmDiEWxAi/1LR5gfI2hsoe2wS1Ba642yHtNhHZ4hecQoaEU7QLWIZqUvxXv7kbYiGbpJRe+7P9/QLpkdYkzVzr7EtfS11V6povCtCIZUBVjB2NBtubC0BpBf58fPOZxb/9mZs+NZ6sSipQKjRI1/t9KSiMkQr4N9ytxeeV4G/xqTL8zbC+uOCT3ZIfKaMWNlaDlSjuLBBI/CD3ypGo1vrLKOXoS1EIJFXheYrpw4ChQU+y56wIM+WPhA4ii0+BAsoeLN2Tc4saijYal/T2XIpZ0jeXmky8goKU1u+eGR2YNq4+mzl31NyZlsU1wiewaCdf9KFvraizLbdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ghUsDS2U8QaAoVhG1Z1USY+nwFW+fGTAxNF9wpYSWoI=;
 b=QReEMCAMKtGSmaMYXLpdzESQRGCJKu05BrRtSYTcgVkn5NMTbfb1qClDjSSW2fLcVKLcu4xseDsD5Qom2w/e6kOdyaWUs4EMJAMYTzIDMb6h9olEFsc3XKy42tgCbCdFVZ35FzkXbae8tsX/vTit+fXQyh+2kYwKyxN+MFG6/irZiMt3ShhrGXNfjdPlbRW/aZzgwWCInRrALxDdiF2eij0i2srlykp7eXc+Ue+sqPY6qYevgZ35U9ymaTd+GL8+MVvJmeoddwh67uSE+yL7g5QnTK8u+mySjLSWcbrUXQngZAcNg3ulEgwSh3/46AOB2qTeB2dQhPssfgmkRst4Ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ghUsDS2U8QaAoVhG1Z1USY+nwFW+fGTAxNF9wpYSWoI=;
 b=BR4DhjSlNe8Ytdst4I4JehMJNqd6e7iGrnjGvrpUS23XLWB7b61SaIGYMMowQyzMVTuYoIVbOoIUyTmzUZ/qxGQoIr10+TMlxK2I0jucCe4KlyCkx//O2nqXc/jJU4V/TaHnhED8WumTtK17+zVIYjKVp4Fq1zuMPovEPfmwhe8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
Received: from OS3PR01MB8426.jpnprd01.prod.outlook.com (2603:1096:604:194::10)
 by TYAPR01MB5900.jpnprd01.prod.outlook.com (2603:1096:404:8058::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.24; Wed, 2 Mar
 2022 04:35:03 +0000
Received: from OS3PR01MB8426.jpnprd01.prod.outlook.com
 ([fe80::7c4e:286f:81:97ac]) by OS3PR01MB8426.jpnprd01.prod.outlook.com
 ([fe80::7c4e:286f:81:97ac%3]) with mapi id 15.20.5038.014; Wed, 2 Mar 2022
 04:35:03 +0000
Message-ID: <877d9dx98p.wl-kuninori.morimoto.gx@renesas.com>
From:   Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc:     broonie@kernel.org, lgirdwood@gmail.com, perex@perex.cz,
        tiwai@suse.com, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, f.suligoi@asem.it,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH v2] ASoC: fsi: Add check for clk_enable
In-Reply-To: <20220302030900.46341-1-jiasheng@iscas.ac.cn>
References: <20220302030900.46341-1-jiasheng@iscas.ac.cn>
User-Agent: Wanderlust/2.15.9 Emacs/26.3 Mule/6.0
Content-Type: text/plain; charset=US-ASCII
Date:   Wed, 2 Mar 2022 04:35:02 +0000
X-ClientProxiedBy: TYAPR01CA0127.jpnprd01.prod.outlook.com
 (2603:1096:404:2d::19) To OS3PR01MB8426.jpnprd01.prod.outlook.com
 (2603:1096:604:194::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1ca3e4fd-9f35-4b90-2f26-08d9fc0604e7
X-MS-TrafficTypeDiagnostic: TYAPR01MB5900:EE_
X-Microsoft-Antispam-PRVS: <TYAPR01MB5900C758D7B427BB9FA5115BD4039@TYAPR01MB5900.jpnprd01.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cV1FcqY3LWwKUurlYuJmnatBMrPIDnhZ1gylWL1P7AbSeLXb+iwugHtKOIFHEq9l0K5GtQaJzPoC1LeMZrw2BOvxOZByCGFkQG0n4bhUUKa7gCVt+1/kitm6bhu3CubjSjMHzI9jMJ8xBJqlmOOKS6+x3t0hU3M8gX4tinY5g/4z+idK1RH3e5vsYIyMJwz3zMIYwXBoOBeqZxZkek4RC+xgl/eS/O03RGBOpOnbH6IyKGiBJHElFm+ok6a+ipVwGJWYX3SpuF0d8bUESiQE/3OP2Dierga7VUl6pWmpUK2VoUs+QrpOxDvcHOJgE6XyymYFdAitpOrMSpmVN1WYoSoY4bAVq1VHAkZ1ynRlaqMunx1H95DpyLMK4lGHtNQdAYqzeN/F3hQOJTUmk/qdMdBP08imcD2uELRcj2uqH/bT1SK6Gz5Oab03BvWV+SNnG4VJTMMtgAI9XQJNMvj4kysQolgyxXkNlnfaJ/qP3/2xjvPdi0HuiXLE46Npc7wiV2nDFIRlcfuhHP6htxf++MDLf7Qw/OYLxMJcUgckdKP3UuKBZqD1ZBa0Cp58bXVvaNNhCm2lhHf/R1OByHs2kyX8Ud1ZxWUseE8ewYigv7wiINMRgjqTvX5vYtete2b3Tw938EXaWVx9LKTI9Xz3dcYrnu5alj0LGgsHzCgKKNYTKeaunata44eeOMT5WSan
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS3PR01MB8426.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(316002)(6486002)(38350700002)(6506007)(6916009)(52116002)(36756003)(7416002)(83380400001)(508600001)(2906002)(4744005)(66946007)(5660300002)(2616005)(8936002)(6512007)(26005)(4326008)(186003)(86362001)(66556008)(66476007)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pGKo+b8Beho2N7HgsLHSt9DQsV8dxkycjlkhkZbU38+RTAao5UVjPvEM/BSP?=
 =?us-ascii?Q?OsJZCkkEXSe+/Qhs1uC57EvJAE8lEtE+Sbd78jp9F8os0+Pyt2a3JS1GgcKI?=
 =?us-ascii?Q?IDeMPtP8qf7GnsTbGxFL96OdUwxHFE5vm+N63hezSpwzHsbTZp8MhymcUKNr?=
 =?us-ascii?Q?iwcw/HcTQXJkXtDSVC/qedGwgp6HsFXpSert2Kk1lTIKnARytK4h4b7d+BxB?=
 =?us-ascii?Q?VCZD0AN+c3ruG2IsB5QcOplKwD73VLgEDXv0PG18l2B50LSPaC/rOFQkI/Ku?=
 =?us-ascii?Q?+ZX+1zNijBBCgjdfxHRjN3VPvX/dWqj9hqD1BHzF637LADLWkxnECV9epKjt?=
 =?us-ascii?Q?UQNPZaPP05VtmL3GSDlnsDl7rZ4c3jVgJHRyx8lGYrCRqPLvx+lzDZWd1hNF?=
 =?us-ascii?Q?l40cX/1b2Fqe8AnUidWBSsnU7n+FWxene+gKcTfX9rLBNOgRxsq4uxSGd7bx?=
 =?us-ascii?Q?R4R5NfsNenOJOVQNqJIUp/datI8MNwWWwKmdBnRELNgHYpKFfnCrN4DulJXl?=
 =?us-ascii?Q?apf7m6AKPjyT9XdL7RYjtncXD0877dlwbhMEOARQplcfg5eWMmFvzE1vnJj5?=
 =?us-ascii?Q?WR/VubY6DZr4bX5g6WFLulTJtGhAIDNhGh46Tp6JvQdWFYalYMiSCLABRoxF?=
 =?us-ascii?Q?zkasQX2WT6PxUYPzCZu93Pc215rZ6Ul9ABA1nmib32XX1dXFqpukr63QWrB1?=
 =?us-ascii?Q?TjGxkufKEoTedLFE6eXtmzHzrZXwbVsPasBMBi9vTj5VoMPQUEdYzny4zDOk?=
 =?us-ascii?Q?9ntOwywpSUdCEujDKmw+7Ddcc9NTiL+IVtiaAL4610iH6o8JkLiXrh9NAwot?=
 =?us-ascii?Q?ntHIEKW+77Uw5CkS7/Y303fA5hEHNVXxmn7iokafxVtFYA0rAhsL3aABQmXr?=
 =?us-ascii?Q?M6qH2Wjfby8vyJSU6s/5rZ4JFwWnO0xxfSXU66GPP8QId5Knqt2AQfTRpPhM?=
 =?us-ascii?Q?KCbQCai3UcqOwOLp6qVKy9to0LtFgU9QxlpTjTcr5VQMWFmIDbZtkLhpwJLh?=
 =?us-ascii?Q?NNYfmoHfn56QrnVnNCfhL5p1jCEsVAt1/ywPeD6Lukyx4+jBwzeSgSzQlYxl?=
 =?us-ascii?Q?zoi5s2BKGnBoMXocB/oa6Ec+bzq04ZjHcCEBajH7iXzAQ3cs5hvRMtrADeNs?=
 =?us-ascii?Q?2C7kYXucOEdpQquSwK0It9O3Q7u+M4E8oLYQacKG0WDlTVJylb+CDbHGn0/8?=
 =?us-ascii?Q?h7J9LNqy3b4AUM6WdJens87yf/77mSwlkhAtWcEFJzmQ8d9G/nk0sWd8uG/B?=
 =?us-ascii?Q?jdg4+6bOYqgx5zKvwKejcMu9cb148q/wBTZZyBd+wTWQCTwQkB/HddakkIOS?=
 =?us-ascii?Q?dBdMwTS9mwYO+KtEaqhgHDvcGWC8EuLIqopx9EYdRZXEGli020p+nv3558iY?=
 =?us-ascii?Q?n0OscIYS1j9ZkB77UCr0J2HjaROifv5Oq6T9yoo9K5KK2I1l2I8pTsFELlBG?=
 =?us-ascii?Q?0k8hTk8KxiDqdavTGiZnwr6OFT2DUqni/Ytadt33LNAr119ThyaC8IY0qI/K?=
 =?us-ascii?Q?VY/ToIR/Z4pKr1S3WIWd+yArQ8iA+Aa/8P9cxInmQLuIKuRZmzsciQOVj8C0?=
 =?us-ascii?Q?D02ATqscfYo9TbI87Ctda4k7SZJR5XbyDgD7qI0HrlZSw+jQTVddg7r3Jm8X?=
 =?us-ascii?Q?oz1f4rVWn+GwU/J9D7yebvJ1xuM4DJAmGRNDIABy6ppZgW0l3N7KcV7sqY2O?=
 =?us-ascii?Q?IdH1W563SNxorEmqD2MiVqDkS8S3PLjiDfwHk/4n8rAVs/jRoaoErzKhYkAr?=
 =?us-ascii?Q?rdhvgNArUA=3D=3D?=
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ca3e4fd-9f35-4b90-2f26-08d9fc0604e7
X-MS-Exchange-CrossTenant-AuthSource: OS3PR01MB8426.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2022 04:35:03.3929
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jog+pAlvVy57xJsVPahaR/O44CYBrzJjmWDR6MXPxnpf7V8nBKIpX5DnP3LMaZjsW3t6azD+2bbBzHSzpDwcuN2QBxNQ7cDTF3hcJR9XpQeEfO6WPMTAHu27oysp6zlq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB5900
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi Jiasheng

Thank you for your patch

> As the potential failure of the clk_enable(),
> it should be better to check it and return error
> if fails.
> 
> Fixes: ab6f6d85210c ("ASoC: fsi: add master clock control functions")
> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
(snip)
> +		if (ret)
> +			goto err;
> +		ret = clk_enable(clock->ick);
> +		if (ret)
> +			goto disable_xck;
> +		ret = clk_enable(clock->div);
> +		if (ret)
> +			goto disable_ick;
>
>  		clock->count++;
>  	}
>  
>  	return ret;
> +
> +disable_xck:
> +	clk_disable(clock->xck);
> +disable_ick:
> +	clk_disable(clock->ick);
> +err:
> +	return ret;
>  }

I think disable_ick() / disable_xck() order are inverted ?

Thank you for your help !!

Best regards
---
Kuninori Morimoto
