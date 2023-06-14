Return-Path: <netdev+bounces-10648-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8292172F897
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 11:02:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B45A01C20C23
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 09:02:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6106B53A2;
	Wed, 14 Jun 2023 09:01:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 539C17FC
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 09:01:59 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2102.outbound.protection.outlook.com [40.107.92.102])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B56A310E9;
	Wed, 14 Jun 2023 02:01:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FhXBu6EOo9MMo8x7FX7fuuEo5L009vlH8ySJK00o388x9lqnN0KScjClFGfq8COSl0M2I6neQD5QjggIupm/2U+1h+8zxszNp+9C6DrS6yRkXIC1rHrAmxL1mgyUVTZllgqdGL3kz74WzoYxcAN6Shxyp/MkSiiUkIx+27WcL6oYcDg/nZuyBqu8uG+eM7SFW/HbxXhyYxkhcjVVpM6kO3HL5OKI11szjBEdNGYZqk5VS/EnycxXrebkQw2TvnFx+j0XvJcdIBWD6ikugY3/2zooaZFSJCKIYmWS7iw/lOpPWyqroRgOfYInkLuKCCWgzu7r/CKXfPqjNepX/2+SOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/h0bCkoWXxu/UAMmskfJKVChZ9tu93wf7Jxvw5MQqV4=;
 b=Na/gLHjawTAINMbP4tSUzxQHsMyKA53JxK4KZx50Y/36Ove9BY1PelMAmAltwoO1jKldUuyldEuTEisfClJIMQjLc/RfvGgXSUCDc+PX4cfKQOv68FhimkzimE1zAITn4U0/xt4w/gnjsVJu04r5oIjPqEqS9u/5bUNaS/WszzHZHnpwL/wV7lg/JoI+XvQc8ss7KqrAipA/JAXW6sS2Uv3NkrAJpH7vOW191ibQJtjrpvFkTuhJ49JRg2vfCyKCO0YeN44y1O9J4/ebzR5RJhXcUQ+GztAAFKmfAmzC0sRWNZIigMRNnMUfWAjPXXwo9T/rowSQLKWGR4aFK54qvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/h0bCkoWXxu/UAMmskfJKVChZ9tu93wf7Jxvw5MQqV4=;
 b=M1//v96Vt1Dfptj8IvLsta7Rjgq+dXsUVx0i6dj3nk8BJwcUeR4/DQPu3hhY21eyzdjxyvA+AQsj3Cb4xmvMRTG6bRNsfwHLIelj3dXeZHsRnCzq/1mupbMv4GGG5+zXP3JmCajHNb0NAF6sNJonutq5rLkXeweoeAnFCorP+Ls=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DS7PR13MB4704.namprd13.prod.outlook.com (2603:10b6:5:3ab::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.37; Wed, 14 Jun
 2023 09:01:50 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6477.028; Wed, 14 Jun 2023
 09:01:50 +0000
Date: Wed, 14 Jun 2023 11:01:44 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Miller <davem@davemloft.net>, Networking <netdev@vger.kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the net-next tree
Message-ID: <ZImB+FRreBp8CE3w@corigine.com>
References: <20230613164639.164b2991@canb.auug.org.au>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230613164639.164b2991@canb.auug.org.au>
X-ClientProxiedBy: AM0PR02CA0157.eurprd02.prod.outlook.com
 (2603:10a6:20b:28d::24) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DS7PR13MB4704:EE_
X-MS-Office365-Filtering-Correlation-Id: 76f581b0-2fd0-43d5-a378-08db6cb5fd98
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	svcesgVCKvxQpFXtve9WkJqyWEuRGrbBSK0QHqDKiLvrhH0CSDnU/pjzMvmhSlZERabptRvLhztQTcfRgY2rqPGDZfgNPhLIHoFFjwv1VuQD/Y+JR8kb74TIIKBJI7oSjlEolqeTqsAGR4nZ3fkUK7wh0iVsejKZcXd5nDoDaOkRQFPWlt91L0bok5V3Zia47JZek0Oqrv9OWYOnkkILRo+gFq/VSPR6MkHFpd9tNUNEeMrj3+ohp7G33fVrqLDe8luwDl/PAJuWGV3z4MokzAafJ+Bm8Tm2vZBapAGKgmT8isSOSrisUTiln+Vrq2uOJwBfBtpRhq/0dndrolLdOdmmitmc3aryvpT1SA4R+Av4WM3Djk56MZam2FFVHVgFJhK5fQ3DN43umffZdq3gPjNqpj2EL0HjBppF5iwmzCuxq8xsfW2HtlumdzIhv47ldStwuSrocgRoY2MWUuleazJ+aLxvp/9pVZ6aRJtcE52eBRzcU+SpmgK3wajpHP4HrUIhDwpXyxW6Tkaaq0kLSJMA52GqwDG9bWMo3s7j8a/sn7d6mT/NDv15VIz7AZTRu18q0rW9QhZIwxrzpKDDcf6654oqkh95yQluXgg5KTbTpB+oGqIHZncC4ZMVzWCGTExgPUK62Ikcdn3FMqs1r5y9AR54ErSltAN7BNGk4eA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39830400003)(376002)(396003)(346002)(136003)(451199021)(83380400001)(5660300002)(186003)(6506007)(44832011)(2906002)(2616005)(41300700001)(6512007)(8936002)(8676002)(6486002)(316002)(54906003)(53546011)(6666004)(36756003)(478600001)(38100700002)(4326008)(86362001)(66556008)(66946007)(6916009)(66476007)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cjYOD1dNPemo6QvmGHHAL/AE04PfoeZsRyifGxC4X0ZwRcalbzbGMd2OweGh?=
 =?us-ascii?Q?63yRNpSC3IbWR3kFvRzQ5S7wVA1IldJwA22i/ZL8GE13S1ny8zFVTY+dAaD2?=
 =?us-ascii?Q?w5Kt7I0/eO9iXLeIaM34OrSoqGQhsFPmyGZeRJBaJEMzphuujKb72VjDlI4e?=
 =?us-ascii?Q?hdFLJKNkVHvI3WtbLz7w6fgmpKzhRM8m8o3mbuOJeVhC7okYUsOaj3ezBTlp?=
 =?us-ascii?Q?ucoCH7GiLUUnpH8WwF1iDL4cMa5O9Sl6e6cHjZ/NW85UTvDFxVqupVyYDbrA?=
 =?us-ascii?Q?7xxBQ87bAKpbQ58vRZlc7lq+UKQs3we3f4kWYA5z42zfVi88NY7NHRVUj8gD?=
 =?us-ascii?Q?7lsypshVVsRKtVg2iL962vb8shypRhgSY+50S+DygMZgRfFS7DvY/JNU1ET2?=
 =?us-ascii?Q?pf69yOlpMrXhMQGQ4ly7kanjYzcGIMB8gaD68z7Gxq7RyWNXKKkt617wgtVZ?=
 =?us-ascii?Q?pkHWiinJX+DTpGIyG12qs6bAM4pj1mDYLJt809jr1tXGHQVajeXua1zF2phY?=
 =?us-ascii?Q?if8D4+W5LAoDfEgOGKBfQmoxlAO31dCV8wsfUOQa28yRxQvxbA72vpd0C0Cv?=
 =?us-ascii?Q?+vsdf/6Ekm08+NCK4xsdJ4Kf5cAGKSfSSV+SjPEnL37TauWxtR19S2zYl6mo?=
 =?us-ascii?Q?JucvGK81+qVr+CHV7XP+RRn3mBSNf9ilSsrmQNg5bDFYkq3KCyVst9BR/HHR?=
 =?us-ascii?Q?VDZN43oY2r4Zmwn9KZtwUviUGONPCB73Kb7Ylz+N5XAzETWxZa0hxx2bKok6?=
 =?us-ascii?Q?YOrZ38djqyLU2uw9JkI6yimmrX2/XGK0dibCcifqCUPTrCxIteVDZ5QuIO4y?=
 =?us-ascii?Q?yjUgxzn9KJcUyvHL/Ictkft5F7GqCzN8DaH105jFqY4kK0ThUoufaOvxCekO?=
 =?us-ascii?Q?lrVYaef/f+gkhE5wMjIYqKbPh89yLc+FIYYrWfdj0Oe8VqDePI8t7CqDbk9j?=
 =?us-ascii?Q?387kbmQJ4FMM9LZx+Vu6S74CeXx6zTzgWTbVVEb5cH7u5pvzuIKAv+uhokw+?=
 =?us-ascii?Q?hnJt92XBR59ugYZYzIIRIY2IZ9HI6K3sHoO6ib3uLm6MxYHkuRS5Xrvd62tD?=
 =?us-ascii?Q?GcRbvM+itLSGMU/AHQCaTF/klmbCwstthn8ZwNkdHbvonpslSAWN3yyrIAhT?=
 =?us-ascii?Q?2dwup6X0THVkfMon9JqGJ/k8+DIiR8ZqeLXTtI9J9/z+BMT/0GCEBuXz2j4m?=
 =?us-ascii?Q?eMkL5Prk/M64izEVg/gjsUtuxpArf4kvk25OWXX4rbPaN1Ri1DtgmQftwxpj?=
 =?us-ascii?Q?l9lfMg1upBPLV2jAq36F075okK2vCD6oxedJfajmUFZ1G3vi9UciXZGZillY?=
 =?us-ascii?Q?dToTzGq2/xjpJHfOwuo+dc09keZ5/KBL4g+N14V7sxrT8Uddp1zOX6pusgzF?=
 =?us-ascii?Q?U1bud8K1rBWrAvlAiyuVZ/tSVZ+1g3upJS0ppW2MwbWwPkM2OKRIEAaGm7GR?=
 =?us-ascii?Q?7Qxw3pfS+y7J40CN7j5fZZ9TbgE/aLDqPe5M15v/K3GkT2xF5u1eM315UVTK?=
 =?us-ascii?Q?g+SAtr6sdkjKWfS0RTjCb/S+PEph8v2XJFxWj4gVoNp7mZYGY1fAf8N45JNc?=
 =?us-ascii?Q?bgOxC5eMBZFZHrkJ3vAo8OGbufON3oO7uWsvp0heZ7AFU5IgJryHWvyw4omB?=
 =?us-ascii?Q?fFgdT1TogI/rktYuETZ8vy6ePaVzi1Jj9v6HMN+6crb31KGWFk3/AOEyBq2M?=
 =?us-ascii?Q?qWTWEg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76f581b0-2fd0-43d5-a378-08db6cb5fd98
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2023 09:01:50.4312
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2KTSMea7zGXwrCyMCCccUS/4jpQotfWp+J6dIdF83Xe2ofqL/nSX7YPfTvl9Q7L/lHMU8/NYZO+ECZnzLaHHOoS2ELr1dSY3midDZ4Af6xo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR13MB4704
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 13, 2023 at 04:46:39PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the net-next tree, today's linux-next build (sparc64
> defconfig) failed like this:
> 
> drivers/net/ethernet/sun/sunvnet_common.c: In function 'vnet_handle_offloads':
> drivers/net/ethernet/sun/sunvnet_common.c:1277:16: error: implicit declaration of function 'skb_gso_segment'; did you mean 'skb_gso_reset'? [-Werror=implicit-function-declaration]
>  1277 |         segs = skb_gso_segment(skb, dev->features & ~NETIF_F_TSO);
>       |                ^~~~~~~~~~~~~~~
>       |                skb_gso_reset
> drivers/net/ethernet/sun/sunvnet_common.c:1277:14: warning: assignment to 'struct sk_buff *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
>  1277 |         segs = skb_gso_segment(skb, dev->features & ~NETIF_F_TSO);
>       |              ^
> 
> Caused by commit
> 
>   d457a0e329b0 ("net: move gso declarations and functions to their own files")
> 
> I have applied the following patch for today.
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Tue, 13 Jun 2023 16:38:10 +1000
> Subject: [PATCH] Fix a sparc64 use of the gso functions
> 
> This was missed when they were moved.
> 
> Fixes: d457a0e329b0 ("net: move gso declarations and functions to their own files")
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

Thanks Stephen,

I agree that this is a correct fix.

I've tried to conduct an audit of the symbols changed in the above
mentioned patch and confirm that compilation is successful.
Your patch addresses the only failure I uncovered during that activity.

Sorry for not doing this before the patch hit net-next.

Reviewed-by: Simon Horman <simon.horman@corigine.com>

> ---
>  drivers/net/ethernet/sun/sunvnet_common.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/sun/sunvnet_common.c b/drivers/net/ethernet/sun/sunvnet_common.c
> index a6211b95ed17..3525d5c0d694 100644
> --- a/drivers/net/ethernet/sun/sunvnet_common.c
> +++ b/drivers/net/ethernet/sun/sunvnet_common.c
> @@ -25,6 +25,7 @@
>  #endif
>  
>  #include <net/ip.h>
> +#include <net/gso.h>
>  #include <net/icmp.h>
>  #include <net/route.h>
>  
> -- 
> 2.39.2
> 
> -- 
> Cheers,
> Stephen Rothwell



