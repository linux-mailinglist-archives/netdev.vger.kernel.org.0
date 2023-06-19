Return-Path: <netdev+bounces-12070-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 84A9F735E16
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 22:02:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 94CB61C209BA
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 20:02:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 801C014A8B;
	Mon, 19 Jun 2023 20:02:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 712C91427B
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 20:02:19 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on20713.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5a::713])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BB0BE5C;
	Mon, 19 Jun 2023 13:02:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WrmQwqqZk7y2JA3NDNxpWLttlyAeVDk0i1kwFQKR1EwDejg+w9AVOvHe705fosVeRkQC99XnPulOTCIp/LTx9yvZHXsDJsn3yZSHjGDe+y+QV5E3bbiqPPlsQDVo6cMXHvvzcFahBLUjtrTzbBtHe+PRUtX+l6Davn1EekMqtVKX3eYmLyIWceamaainHpriyZvdOkVKcZJ66Ix7h177yGjDu6HI9f0JbbToSYVfLAWunZLNHx+lXFFfiOX9JPeXHOc7OCrZiNiDjKA4Nh43AkI5YRE0jgjqkcEzBDuQYsnSocHnqt/ysf3CaLGkqUgOOTHo9aNdREa0BfFmghB3jA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CihPLuxxVRpJgE7A2mclgfRPDWjVI7TMDC3d72Zs3YQ=;
 b=YaKCqcRWnpW4p22w1j2jJioKlKoXJqdQP8ezuJeIp6UNH8QkD+9jorm9tmbMIKZ+/Jh2F05KeOX0AQLE3PJmK9gw98yzq+L4uWKc9/BD+p53qhK6S2M9b/lEaZ0J1xFXZi3SfbpFkNtGiUsuD9FRxxh/nZNp40PK3ULkcYmwsHsm8josc4ElKKUcnBlauZRbztz6B4ItM6U7Gj2pte3ANmvJgksFU5EFDUtiQjVjHP4WavCkUgP/Ir5jR3UNCMpncZjPV2KoW046SwVCHzObrhvVgthHpGjxuqK+lzDNJ8ZJfhBCAcFOk7HSh+9OUzqZAJ2PlTo57PbIdBJ0HIZkhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CihPLuxxVRpJgE7A2mclgfRPDWjVI7TMDC3d72Zs3YQ=;
 b=iSEhKzBPHgRxa9rZXtpxZTNU/tSzlAwqNluJPzQMV1p5KZ7n4BJH9dXIPR4nW1qysIP4+jXG8iCqInhUVaacuS3pjnPy/zVNZchR/D4s+aFpeYZdHERALqrB5VSs1zuf3bdQ3TE9vIcJsUE6ouJz0jKQEFoMosIM+s/0MxVKegs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BL3PR13MB5177.namprd13.prod.outlook.com (2603:10b6:208:340::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.37; Mon, 19 Jun
 2023 20:02:15 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%5]) with mapi id 15.20.6500.036; Mon, 19 Jun 2023
 20:02:15 +0000
Date: Mon, 19 Jun 2023 22:02:07 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
	edumazet@google.com
Subject: Re: [PATCH net 08/14] netfilter: nf_tables: reject unbound anonymous
 set before commit phase
Message-ID: <ZJC0PzT27+gFK9zY@corigine.com>
References: <20230619145805.303940-1-pablo@netfilter.org>
 <20230619145805.303940-9-pablo@netfilter.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230619145805.303940-9-pablo@netfilter.org>
X-ClientProxiedBy: AS4P250CA0014.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:5df::17) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BL3PR13MB5177:EE_
X-MS-Office365-Filtering-Correlation-Id: 861c4c3d-d4f1-45f0-dea7-08db710013d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	E8R98haloO/j08Otj0vGcKbFoHqocGYRCB8aT2jPch6hTpQ6Ki/9ZJjE12Itu8CbLuvkkeJ9dm5WKbnVMUMlCtn9715wmOXagSZNd8biQc2+eBQVWFBwftfRnpelFtJHZ7PbqV1Psj6g8FLGqeO9+S420BsXEmb9rOCraYOfvbjapiR3MWv94mxZ6GYbcNge9FCtG1Nihrm+gJ4+clc6mjX7ceUIJkCWXbsbzSzK6+B/jLPlj6yfqttAqmVCDgnvV8r1V0E4oJ1QDj3ra3cJlKS7msdbXQUM84A7C2XkdyLYx0m6oKXtzDP2WYlkP9ylLuX93x/AORCayNBPU+CfPXt3bcUUfW6FAqABi5wNIGH2eaIfDZndvSCCE93wRT31kT4NWpU02+NnFgl7b5oRCHvIVCeoo/b3kVi4LfKRqBNQU7NgvwtTmZdLUui7qjfO4gW5R/8tqYo6UoAPCx4KjKQuxNnxsV0MCThUV2ooqJVoKPLhliPlSVa5vMz/yNDxXpD3r63Zc5tecLKhv3SwaCPouGKmqgofhF1teLFiMgXII9/p8D7BT5lhnGSSMyOPd2/jveshzr+oP9T7SQx9S0ID2g8Nbq/97h+02zNvvnXdBgJIZQDTzC2L6+zVBxyoGXilqps8c0r092FM+EMlZlnRclxojOLiXl6YjXprDfc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(396003)(376002)(346002)(39840400004)(136003)(451199021)(186003)(6666004)(6486002)(86362001)(6506007)(6512007)(478600001)(2616005)(38100700002)(316002)(66946007)(66476007)(66556008)(6916009)(4326008)(83380400001)(41300700001)(5660300002)(44832011)(2906002)(36756003)(8676002)(8936002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?aKjAphVrG8P7Ghc3uyutkrjzlDTvNnteGYVCmjqtywFflqn7vLO8mOH+qp7Y?=
 =?us-ascii?Q?VIy4ua3jjIn6aHijZkvQ+hHs+H4QZPO1hYZKB57UP3kaJ0YAbhPSZGvy0vkR?=
 =?us-ascii?Q?vvdJhyIr0EBNbybjtlNMNkYskpNOXi2Jvd0+jdDc+XMeFFcneCFm1AZzj2UI?=
 =?us-ascii?Q?TyQR8V5mmU8+q5eoljGkCOL+ms1XFEVpePGNeyc2y7EJRc5XN1/TjiW0vJjY?=
 =?us-ascii?Q?sQyoODyGChgOhQjhOMngZGKFTlxDYbE3+nfKDaJDhcSIVCJqMikFvAgtYJj0?=
 =?us-ascii?Q?ajHFwU8f3cg1OiiavGHaI6gYSsukKwNC38Rd7jaYUMe4xrquuymETMpBW1pT?=
 =?us-ascii?Q?u+Vn8cMgjnNMnOguYRh1hkUHzEeIduzfipHfOxPWMjRE+TmWRDJdZMk8QiTu?=
 =?us-ascii?Q?J+CeLdFgxfYAC1oIcW5tmnyl36KzuaYHrQ0ajl+nOeRrBCmeALEYbdVUJcND?=
 =?us-ascii?Q?rperBuYqGx0PZ7r4+B9t2S90nc8Ive7GTldIS8HRS5Yoj4C4lbfsLaZ1nCNQ?=
 =?us-ascii?Q?3oQ6/JXS2wf78bjm4ukiKEamKnJGeoKL1CWhigmNB76cgMZgaz1f+wrvYm2r?=
 =?us-ascii?Q?7mvseCEK3J2pbbHKEj9/9kzDXlH1QseRTAypLO0cYMKlYWwAhMgbFMVyYldy?=
 =?us-ascii?Q?Vy4Idr1mCoKZz8SSpiJ5ULOfj6epVaAmBcbEh82SC3DtTNsVONnZApmyA5vh?=
 =?us-ascii?Q?1DF0KDsfg2ji/26IYdgR6uBF1A3qAgrTvQbulLmqJ2Nw5SiPioEC9/79Iiqw?=
 =?us-ascii?Q?z1YaQzx4Z+M8C47BKBPx8kbGZM8TZFFrcWQgbKK2TWuCFuK7BtFe7TSSC5ec?=
 =?us-ascii?Q?4svj+K90zcX2TYgd1lPVg3Bu9BJb2MGrlczcKALF31knRea6ljwjUILEOdeP?=
 =?us-ascii?Q?CAxf/PqqrBwUEa2k1tIvitFwGx8EnNIJ/WBpQj7i5gf+4ZPcUVzDUDIl1kw/?=
 =?us-ascii?Q?Ces57bs5KTMeE0g+bfJ/Nxy2rHv+17Qvur5fQlHqXoSY1AWq3Bi1F/GZxNoY?=
 =?us-ascii?Q?tl9w06Zbxe9a9rSEt+xjiJBeCTEEXtSLrmHOjVtIkUIW7Nh2lRWvkzVAJLRT?=
 =?us-ascii?Q?H9nzro8XWGTlqIPz2oIHZ+R+fHQEecH3dyHqD2TyJ1b60zZIupfDfp/PjUD+?=
 =?us-ascii?Q?aV+N3qYIWT/ADuI+zdPzMeHEeA7kNt9BRnE0xs71aHVS0MLYIKu72bymurD9?=
 =?us-ascii?Q?cO4em4RMiLc0BbWuhNAcJ/U91yBTTaDFsaEYdl7L0TCYghTyrC98cvjB0X6N?=
 =?us-ascii?Q?CwwKLRWDwG/AO1kcxeR7c4jXUH++xQFUwkjwZMk0yDn23OpilMEcd/uM/F9w?=
 =?us-ascii?Q?4VJZRCtgZ9QwvaeI0HJ6zdM961zQvrfcd82Q9YtIUdsq7CdLLBGmlmDjg7dT?=
 =?us-ascii?Q?b23BHczrQTYbsWah8Rsi9lxLyChdo3aYgKRU4csVIjJqWDGU3g+u1GFRtPC5?=
 =?us-ascii?Q?BnxUzJLL5WQ/Ji8YU3XFzjjbeBS+/ns9N9MJnsC/pc5OuZbvlPUwD5viE6AX?=
 =?us-ascii?Q?zNYDM8rGJW45k8FScI67tbq6R+/qJp4x+KsJbcw/lGSmUO76rn1n3CcA9xUA?=
 =?us-ascii?Q?9jnwH2pecW1NXwa820AymtniiHKaarC6x2RWuO30VwLpkoK6zRBD4WDAcCXJ?=
 =?us-ascii?Q?WKvRSNIcxs5Tqc5mgQfn+K+KKUzysnY44Gkdhq1dsoiTvDjbO8C7RZlj5NhU?=
 =?us-ascii?Q?c/p2xA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 861c4c3d-d4f1-45f0-dea7-08db710013d4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2023 20:02:15.0997
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uYmMIDRakfdAS/pcF/wr/PdpHiwgDCNovZYQ9E1gwphGxWbf8w7KGIKKPa6cTAUO5RLkBaJBwOBKNeoeuJaV87lXfka4zJWtI8YhaBxFvsY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR13MB5177
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 19, 2023 at 04:57:59PM +0200, Pablo Neira Ayuso wrote:
> Add a new list to track set transaction and to check for unbound
> anonymous sets before entering the commit phase.
> 
> Bail out at the end of the transaction handling if an anonymous set
> remains unbound.
> 
> Fixes: 96518518cc41 ("netfilter: add nftables")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  include/net/netfilter/nf_tables.h |  2 ++
>  net/netfilter/nf_tables_api.c     | 35 ++++++++++++++++++++++++++++---
>  2 files changed, 34 insertions(+), 3 deletions(-)
> 
> diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
> index f84b6daea5c4..93fd52139274 100644
> --- a/include/net/netfilter/nf_tables.h
> +++ b/include/net/netfilter/nf_tables.h
> @@ -1580,6 +1580,7 @@ static inline void nft_set_elem_clear_busy(struct nft_set_ext *ext)
>   */
>  struct nft_trans {
>  	struct list_head		list;
> +	struct list_head		binding_list;
>  	int				msg_type;
>  	bool				put_net;
>  	struct nft_ctx			ctx;

Hi Pablo,

at some point it would be good to add binding_list to the
kernel doc for struct nft_trans.

