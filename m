Return-Path: <netdev+bounces-4296-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B385670BEC7
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 14:53:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8E7A71C20A6F
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 12:53:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C69C9134C8;
	Mon, 22 May 2023 12:53:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B26D2BA53
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 12:53:21 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2132.outbound.protection.outlook.com [40.107.94.132])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9E2BC2;
	Mon, 22 May 2023 05:53:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mfsIxsnQmsJltEHLClaw+zQcsNISs55k4xZBiGzDxm+CFsdwqSW7E5kmBRDUh3ztSDlYNSPCXK7Shyzc6oBftXNvQ0pw7Or/c6My3ADK7UQhEBNH5+bqBEG57g9i+iBubwwp3QfRhg6+V++49u9cBYY6Qk0To3BgLI1ohShQiMYq4ylym6HoOZTV7g6TZW8HNEeRwDwEBD9FR1HDVGqFXDRqZCSib7DDl3x5iQrCA2oGEVlpUtlwm8GFaGFDihzCYt50Vwf55Gp8O9pnnS5GNaumylzfEneLMTo4/xHmIb/zTY4aPVsSv5AocJx6l1Lq0U4zwQ8aOcE+WX0I2ixWtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kedk47ZjYCJH12Yxn1zS88NJWtRFSksB+6xpX9piTf0=;
 b=oAMMj8FB7E7Il20l3m5vhJd3fpHJLy8SYKfIYbXucGZqsM6LJ2i9h1/6nuCJcABkF9CFKuD77ydW4EyoCPxw2iiflYllK3CwR+P4aRBDlE0dDuUj/WSVrQWv+5JIiw8KYWLtmWpKo3M2QXXsvmA2XRC2RjZRRQA7gk1en0a4Sfo2QMkNncCORLjiGde3qBOT9YXLgAS5iMK+gH94KjsoQQS6YrmcaG4SH0EfWIMLlEwv+Uhcjqk/Fl1u8zMZmaLt2oOnD1E/htOlKXagr3Z0dGS/joRCtOqsa3VarBhnq6XyGtWg0l2/rxqpeOXmaiK0eUEjdx8y+HLwVSX5/sxnqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kedk47ZjYCJH12Yxn1zS88NJWtRFSksB+6xpX9piTf0=;
 b=W+zJLe2D+/eA/Um63UpVzFFbPNhSzEfuwp8gSkVZesQXlSCxEzcMpurftj3PDXcIIh4vHseVmUbdXymaKKb1VyuWRn0jvYLPIXqJ8KCHmG353EqLtR/Zs/AYJv1vQZuIowaRDW0xKntCjpMvJev4JEqQBoVL4btux5hxug7LpWE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW5PR13MB5631.namprd13.prod.outlook.com (2603:10b6:303:196::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Mon, 22 May
 2023 12:53:15 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6411.028; Mon, 22 May 2023
 12:53:15 +0000
Date: Mon, 22 May 2023 14:53:09 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Abel Wu <wuyun.abel@bytedance.com>
Cc: "David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Glauber Costa <glommer@parallels.com>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/4] sock: Consider memcg pressure when raising sockmem
Message-ID: <ZGtltclEH1ZTBp8a@corigine.com>
References: <20230522070122.6727-1-wuyun.abel@bytedance.com>
 <20230522070122.6727-4-wuyun.abel@bytedance.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230522070122.6727-4-wuyun.abel@bytedance.com>
X-ClientProxiedBy: AM0PR01CA0174.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:aa::43) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW5PR13MB5631:EE_
X-MS-Office365-Filtering-Correlation-Id: 05afa5b5-5f7f-46cf-d1f5-08db5ac38200
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	VRmohmEJyP3hO8E99PLm+b085cH7PFlc3WupnsVRKCw9rd2gsgrdjgGQxhdAkUuhxBwMHCFHatP04XkWhO24gzwuguY0pvtJlbte3GFQD6cyohyNwX0Q95ERdKANIT0eaKSXrqx+U2yJ3KN8+kN+wy64mS3PgD9NtCjejoHzhTct9lWuHYCf6p85zU27aJe45lg/N0Q8zDJCPbdO9A9Q/qCmnXKOTyIsgXHGw25AawSoAq1xroe7nFGaQHTA6hH4dPuMwxIiFnKd1qQ7bsMHHg09dN3Z8MwcbtCMFpj5YVi6nex+6KvpAPNoPE7Eeit0uYEPbR9SQ751fgHInMi9fLL2ziVMlGUqjKZkVF+pvAQQZX7yQ+jpWn9gsVsq1XEgwmaTDRn7bZQsbjcSInW2zPFThXQGcHcGQhbtrmlRH9cB67mb9iYtYnN6uIn3pYxnFfAhQ7F3Bo1DtgYenw7nSeYGLARVHdhy/Wp3yC7CPO34Zh/nZ9ChDZUwb2R3ZcTuAq3I4/MrUFu+MQl6tHXm1mvTiRZzHR5cNmdBP0BJIajNzaPzLYNNla9+6yaEhbjE
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39840400004)(346002)(396003)(136003)(376002)(451199021)(2906002)(5660300002)(83380400001)(44832011)(8676002)(8936002)(41300700001)(66946007)(66476007)(4326008)(66556008)(6916009)(54906003)(316002)(36756003)(6666004)(6486002)(478600001)(2616005)(6512007)(6506007)(86362001)(186003)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zIHbYUTzF7fTDlEMsWOa9pLI3R5Co142LsHuMayCEJQ3EeLbI8ORtV8SQLRW?=
 =?us-ascii?Q?6VK7wWrhK1iB9JTDlpn+6cMFfrsw9f4f63/9L4uw/cjU6HK00h2BzUJIzuoh?=
 =?us-ascii?Q?u/BXjztR7fCerrkWVHg9FDd+AVv7WytHqL11/w4368wLJKEYOBAFc9e/qv6c?=
 =?us-ascii?Q?yR/MWFCtpkaDpnxbbsox5IyGRI9K6TZ0kZPDJTf2wyapIfqeus5P66ntBS4e?=
 =?us-ascii?Q?jESWlt7if42GdSF4kwPqFlWLTEruzbIitccpqLeGVURPrvUdnVXPD/xuVPph?=
 =?us-ascii?Q?ZvW8D8LaJb0BJaMAGOOR7JER2tR6S5Kh92x+7eoMp3JzYKkIJG/dm3V29Mcb?=
 =?us-ascii?Q?yP0HZWGxvyAQ+b6785OFa0uFMLOFYL3afvJVKaOuc6P0NyD0KNNuPtVXvNfe?=
 =?us-ascii?Q?+fvaaO7Cv/K5rQfriKrfJItaSSBnWpQ7RTVCpVCkwBlbwS9IcJ2axLdYhXSs?=
 =?us-ascii?Q?JmZhfH2Lc7AWJod9OfLAoFzIqACJjGZPzZYibqmZoteChAQwJlCptZp2CN9q?=
 =?us-ascii?Q?SBA2FVrttORMQglITdpB9UaiUDCxeYK2w1CFnrFHglUZ/qbo74IBMPEcxvbn?=
 =?us-ascii?Q?sYbujx/nmzSpNxzMfbKeEcFHzHBmB2QCJLRq86n+NDkWxAj3rvBvZnIO2OXY?=
 =?us-ascii?Q?cYvSwzHTY2pDf2q5zbwacK4G9tOsedJaQy/ILPvux+VhgMH0QzrpEB7wTBXc?=
 =?us-ascii?Q?iMfSfyBV2nZemuXHSUyOBmoN4S5e3AfoiUKg5ESBTDBajtK2b+hiJ0nrqLLl?=
 =?us-ascii?Q?cUwQBhydf2vehkgDHiZPKYP+lJQj6eMgYxZluiPNILdqIqtER+PKuavtHH8d?=
 =?us-ascii?Q?Y0Z5ybA4LejYtOnBSKN2rYAohe03cnZdMjisyqpPNq+jfQjN3qUmQSsWch3I?=
 =?us-ascii?Q?p4ND3lVETBx0YlelNqbY8gtDZufwf5J022di4jK1WHmp7LskqTQjaS7wPVpo?=
 =?us-ascii?Q?wygOIPj1obuPZu4twRWmQtmHHiPZJNiV7PnYeRXBsomARxXcmCT+JmOOFLfl?=
 =?us-ascii?Q?0Ad2EufR+sGTdSB12W3yv2CjxipadlTb5qX0zJdAIppTruG0YSXRXDrEgt50?=
 =?us-ascii?Q?ED4fQlo/P8i9rb88RMWJv1EPBO0zTMs9pbWJn+5Dha8tfLNO6neNwp7I/w0Z?=
 =?us-ascii?Q?5be8v1ic+00GgofO+4dAzvBvkTYlqI9lBiwFoEvjNr1l9BW2Pe88i2lAZP2z?=
 =?us-ascii?Q?NmXJqkUfeCrN2+z3HP333u9a+7eujCNhM9h8m/hk2Osl0FjeBa/4L+IPEwuP?=
 =?us-ascii?Q?il3CWbh88RYMqtOfMmnb8VdgALLhfpWcW8EvwpSksytXrewSHU11RHBnlh1w?=
 =?us-ascii?Q?SB99cEyGSdXdenjzOLgoPSNv4Z8wVQxFB5sRwVZIxbWX5+OS7AGd7j076Bnr?=
 =?us-ascii?Q?pLx0i1dSSc3MSnXHu/XIKJ5yHtCvt62/BAZvNaoKmrSOBLm8yH7yAFrPh30p?=
 =?us-ascii?Q?UF6notAJldL9NNCTaPVMVHrEUCv4yeDOjYTJnvrUIwXnxh9rKXm5Gm9a4xVe?=
 =?us-ascii?Q?nvKcqr/KJUfVriZ1Ii4zdl2FBIj06nHyThev5slKBaiuCj6Dw/I1eYK4aIZ4?=
 =?us-ascii?Q?MYFxJpmdXj14lBIoX0dX2AgbcIK0BKCPejTPIenKNZzyequ8cvTZ0scOOZRA?=
 =?us-ascii?Q?JyxhMMQ/08uMpDda9zjBxXTMIR/zV1nQV9baVj2x1fnw0hssAt4M6+rPQ6jK?=
 =?us-ascii?Q?8D0FPw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05afa5b5-5f7f-46cf-d1f5-08db5ac38200
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2023 12:53:15.0642
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n08YOnLVSf26hCZfR7ACG7g9yVSSMmi4tzkahqpag2cALM8wbjNCVAENZQhu7+QSMtI2G6As7815kxNsJCZfen4hyEO7O8rwKjUmabmvY9I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR13MB5631
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 22, 2023 at 03:01:21PM +0800, Abel Wu wrote:
> For now __sk_mem_raise_allocated() mainly considers global socket
> memory pressure and allows to raise if no global pressure observed,
> including the sockets whose memcgs are in pressure, which might
> result in longer memcg memstall.
> 
> So take net-memcg's pressure into consideration when allocating
> socket memory to alleviate long tail latencies.
> 
> Signed-off-by: Abel Wu <wuyun.abel@bytedance.com>
> ---
>  net/core/sock.c | 23 ++++++++++++++++-------
>  1 file changed, 16 insertions(+), 7 deletions(-)
> 
> diff --git a/net/core/sock.c b/net/core/sock.c
> index 801df091e37a..7641d64293af 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -2977,21 +2977,30 @@ int __sk_mem_raise_allocated(struct sock *sk, int size, int amt, int kind)
>  {
>  	bool memcg_charge = mem_cgroup_sockets_enabled && sk->sk_memcg;
>  	struct proto *prot = sk->sk_prot;
> -	bool charged = true;
> +	bool charged = true, pressured = false;
>  	long allocated;

Please preserve reverse xmas tree - longest line to shortest -
for local variables in neworking code.

...

-- 
pw-bot: cr


