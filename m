Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 923206BAA29
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 08:56:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231441AbjCOH4s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 03:56:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230516AbjCOH4r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 03:56:47 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2131.outbound.protection.outlook.com [40.107.8.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B093136FD8
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 00:56:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WKkIh+HNoa3zLJgchpfTRlekwh6qJJgzysP/ogNZPB/DIsR5EcP1Z4BYzduKz/aoJWEaD7fk3QWxVcQVZiCFuAxmApkjlz6Ln/GHuTY4ECteerZnWqn54gSz0Af3b95rS35ia71+tmv+53GVq3lovlGhXMjelQGKOP+IPOPPS1ysYsPAGFjuZcaxozSgaaBWzftyZPK3P/dOMPoyxSruOFn/X0RU0sxsOsGvj/y+WTUSKTJQbtyEHWlno5OhREZ4AEexNkM6cJKVNpTbtsDbC6uYjxn0suX8SlaGsxoe/WDOZs8GTh9WOKa6wUmtFu+b4D1RQpm//5XzLmZS0ut+PA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l3RG7A0hBsgh4z6LqkpBjUzE05jT+n3xBnEYNPF21Pc=;
 b=oWAeLhnf6Gs2Z806AciKs5fowrWla+JG8gMaI3H4FSpnq4RrYNzV1IkZ8PK4mpdIzT5te21Gbkb6QH8YidWkUrkCj7GeE6uxxMgNBu2dh1W+BLfQ34ndBN0hE1dj6ko9ToTN6F/zwsdnJWg3vThKV34O81d01SKbYEC/ZaffKRlIzqhj6SanU2XxwTsgKWHaZNzQGhk7BjJx8jQFaxzOTeOP0flKFHvGh2DavivTaOaAhqrCbNzoKJ4dyokh6M/HllM/9ib1anh5woLBdLMvrhyOubZv2slxFJ+30uPGYSUGN20ms+F1DNH6pYGs6RBMlopmFqSPVbKYYyNB6ubw4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l3RG7A0hBsgh4z6LqkpBjUzE05jT+n3xBnEYNPF21Pc=;
 b=Imdz2/KDK/x9qc+ddFKGgDGrRuSeXYl4AqCBOplpO3Lf8C0aEQZ7zDOckqWBulsGpQZJoVTjN0BJjEXs3cnnNntASdNitYavEPEIlA3j4N9NNR/oObUgIXYcelhMEdHVWD+N/tnhLE0JNUq2qkrtipZywiD+DunLoIxfhRMs7PY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=voleatech.de;
Received: from AM9PR05MB8857.eurprd05.prod.outlook.com (2603:10a6:20b:438::20)
 by AM7PR05MB7025.eurprd05.prod.outlook.com (2603:10a6:20b:1a7::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29; Wed, 15 Mar
 2023 07:56:42 +0000
Received: from AM9PR05MB8857.eurprd05.prod.outlook.com
 ([fe80::3fdc:3007:ffee:3c4d]) by AM9PR05MB8857.eurprd05.prod.outlook.com
 ([fe80::3fdc:3007:ffee:3c4d%8]) with mapi id 15.20.6178.029; Wed, 15 Mar 2023
 07:56:42 +0000
Date:   Wed, 15 Mar 2023 08:56:38 +0100
From:   Sven Auhagen <sven.auhagen@voleatech.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "mw@semihalf.com" <mw@semihalf.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "maxime.chevallier@bootlin.com" <maxime.chevallier@bootlin.com>
Subject: Re: [PATCH 1/3] net: mvpp2: classifier flow remove tagged
Message-ID: <20230315075638.x7osulon5zqn7spu@SvensMacbookPro.hq.voleatech.com>
References: <20230311070948.k3jyklkkhnsvngrc@Svens-MacBookPro.local>
 <20230314235853.4dfb1cb6@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230314235853.4dfb1cb6@kernel.org>
X-ClientProxiedBy: FR2P281CA0041.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:92::12) To AM9PR05MB8857.eurprd05.prod.outlook.com
 (2603:10a6:20b:438::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR05MB8857:EE_|AM7PR05MB7025:EE_
X-MS-Office365-Filtering-Correlation-Id: 38414615-ff09-432b-8c8d-08db252ad095
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v8f9W25u+LqPuacap8GHZZpaQzo+ydUH/2w66MQPcmvrHOLKr4myyQzbQdeXVMzAOUqwVEGF//isruMTi68+oLbKtxBwqvJV8M2m4f1MY6VEbKehJ7tjmH95tl2fOpjeMG6dJ1JZ1mGsK8k9eWsLjge+E/Kk4I9NjVMeMLq1xMnTf3SSzlDeLVJYVebwM/thIz0N/mnW6aZayZED4R/6K7WZQpJh0BCSe5uk6IyIxFHMa7P6by4a2PH4Y/AFCCeSnS5oBDqvPKelletx0JzuBYi7yK5y4VTNPdLZ3SQPJEafxcCy4z3SVDH7/2EF+qVWYjAvJL+xqKr/if3QgWGzVGEbbi6cQpNam/Omj720F8DYjr5DBAuXoumcmpNq7PyGE979SfyW20LwLYI/LI51n6HCkXe1bmGVel1HxxfbMqW3yAtzMXfD+U7EP6hK/4w7oF75+af1nXBqZqYHJU94u1P9rrE2QC3XCoaeBJdbFdEckxjzOZ1Z/D28abeWiJuq4Hh4vZgNHXKShOP2eT+OWG6AS04NjCUI7ZEfaPbLKk9qFP+i93/kgJZTKluuQG86CDOZnrfYorC4FedN75J7BNEx2vrfX3s+N18DcqBCkVfBG/Hi1ZxWUsMu2iYm0ZTKCJjbfStos9yEvUtXHwCgPw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR05MB8857.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(39840400004)(396003)(346002)(366004)(136003)(451199018)(8676002)(5660300002)(41300700001)(4326008)(6916009)(2906002)(66476007)(66946007)(66556008)(8936002)(44832011)(478600001)(83380400001)(316002)(54906003)(6486002)(6666004)(6512007)(9686003)(1076003)(26005)(186003)(6506007)(86362001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OvyJ9zJBbqDcCyjU3zTmLLXQoZUQTeltxfo95uyj9jcSCdxwJnsbx3erEMWn?=
 =?us-ascii?Q?WVp8Ux4C2wP0PWpKaS/k6vy5RW3MTSS9Df7jK43j/w3+j/eGxtpzocPHtkfH?=
 =?us-ascii?Q?DSQxxaBNQsuaCHDiCORVcO9idccJY+asNNrxlqwNS2DMvH0gGdJHjB4Ytnd3?=
 =?us-ascii?Q?TCeCRD7rASAaCXKSIVEzP9RrK8RSmYCdBQPyWnC+56ly8hhOEc2+4OGIb8qD?=
 =?us-ascii?Q?E0Y+8BX56qo4B3PsBkaoOqhbLE8t2AFgcuOQBYn+2YKW4wWV7coUY+3p2Xm8?=
 =?us-ascii?Q?JlfH5Q/zZMesdMvYxVE/Ttin5YEvrNaoXYaNXkLvY29Tti251c5FbkOQe6pQ?=
 =?us-ascii?Q?CDmCRFYiHMmLMlREpxaGRiHcD0WIc703VCjmStFk7r4De82lGm8JTKw68CXZ?=
 =?us-ascii?Q?lRuejYJhcdAkjnEYHVgv9/3rmZ0j40Y6/i/K8YZ/ebW2FVTe0fFiSCvOpBSB?=
 =?us-ascii?Q?KHjZG9+St55X8gdEsTy4cjQ//Yjh3v65dDjmyU1Un4aNPUmbxjae0kpNwFRm?=
 =?us-ascii?Q?gUWYl8WptCBpmwOfSr9UKp59Tv1Xj9t0jfjCoXHySIFJEfAfmPOfeiSgtpwa?=
 =?us-ascii?Q?1RHKIu0ywr7yGTrOKcKfPXJhkiNVS6DYYHqKQVaJk10z/eiSslDpgqkkikcW?=
 =?us-ascii?Q?LN/qR42B2Fgg8BhZura/yNTVok+KWnt4lOPMW+fxCwo4lPA7AvKFnF1dNDHu?=
 =?us-ascii?Q?U+aC9yRKFSKw6uHUHAUConBbbb7F/K1jMcM6Ik+i7MxqBgzsYEIraQOZGUDs?=
 =?us-ascii?Q?UcdWPUv1eI+jPxLbQPx6BXfK0FUj/L7jDDU8mKS9p+E8qG44/Jf03OZuF244?=
 =?us-ascii?Q?0XDAFHEj5QwKkqdShnF1B8LUyFDDR4c3QAy3+OQwOkKCdQ8wlVDi74zXM3wU?=
 =?us-ascii?Q?0bNz/bN5sqnqKEj9/rH12AUwznHdsvd+8OH9jjG5GTKqZX0hm706QZm8SYpD?=
 =?us-ascii?Q?C47hSBECfAhpMtSfUxkWatfEiDM14UGThyt9x84zd1SlE4K4ym2AEOMzaXEn?=
 =?us-ascii?Q?EuWrbGvFixnTOf1lJIzpquI3P9SsNUC5pv3j/+UukPjN/s+ptirSAyEgJZ5S?=
 =?us-ascii?Q?zRFnFBDxKy0nEJcJRmRi6Mr2zNl+tGaAe2s25ZDsv2R81WA8iMSxBKTpX1j0?=
 =?us-ascii?Q?piPIidU2xsUMiCTcNG87516j7Sd+bqSLrKDwHelVo66wI1qTd3fjPUlq57cD?=
 =?us-ascii?Q?rYILRAvcJUkdvodEOEuExO+FIJ1xDudh+DJmA0gzXZLariGZphq1A7rS0ZXI?=
 =?us-ascii?Q?DZbfLQpP6vRKt2P+kqvcNicSQeNK2CBAXV5oihFpEXcG9IAHyc0KXGOYxR6Z?=
 =?us-ascii?Q?1gXsx71cuu89lHuM75/esJV51vFmvl7nohH5rf2VUIEnwSgnUkUtXLTpBet8?=
 =?us-ascii?Q?T/roYQKcqpaY7FQqxmjPYq6eJF7XebSuKgrX/SoA2XwdoPwtdV+ZXDfg7fE1?=
 =?us-ascii?Q?4QKlyfhxrhFrftVfSGc47FHA5DI0XNS8TE41VSKZ+1G5xo7Upr6jq1AT0A2T?=
 =?us-ascii?Q?fxK2sHZ9WGyu82/5jy2YhPzXYQ36Nz1T9eOiNXnh4ZpwNPxIKgP2Ut+rdXkL?=
 =?us-ascii?Q?sPYQhRVBoIj+Sq+ZsrOLR0/dx+ZXJnjSRttILSRabwXqElSvAKxsaaOTj/0p?=
 =?us-ascii?Q?9Q=3D=3D?=
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 38414615-ff09-432b-8c8d-08db252ad095
X-MS-Exchange-CrossTenant-AuthSource: AM9PR05MB8857.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 07:56:42.5903
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zEFiDkg3Bhz2m3dNorhc+czcdDmfxwCWYFQ68eHl/IDlqsGmtuXcqGtO1IfqX1pPQU8Zfni5fj4rfH2IooGwkPHnkL0BbkzCt7u+Q+00O1A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR05MB7025
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 07:58:53AM +0100, Jakub Kicinski wrote:
> On Sat, 11 Mar 2023 08:09:48 +0100 Sven Auhagen wrote:
> > The classifier attribute MVPP22_CLS_HEK_TAGGED
> > has no effect in the definition and is filtered out by default.
> 
> filtered out in the code somewhere? 

It is filtered out in mvpp2_port_rss_hash_opts_set in this line:

	hash_opts = flow->supported_hash_opts & requested_opts;

Please see my email to Maxime which explains why the HEK can not use it
in case of a 5 Tuple.

> 
> > Even if it is applied to the classifier, it would discard double
> > or tripple tagged vlans.
> 
> So the MVPP22_CLS_HEK_TAGGED change is a nop?
> 

Yes, it is currently not applied to the classifier.

> > Also add missing IP Fragmentation Flag.
> 
> What's the impact of this change? Seems like it should be a separate
> patch.

I will seperate it out in a new patch.
The classifier should distinguish between fragmented and unfragmented packets.
At the moment this is not correct and all matches are only for unfragmented packets.

