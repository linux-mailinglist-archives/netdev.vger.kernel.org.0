Return-Path: <netdev+bounces-11142-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DF9F1731B3B
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 16:24:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8A95F28128F
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 14:24:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB2E2171DF;
	Thu, 15 Jun 2023 14:24:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B737A171BE
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 14:24:08 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2105.outbound.protection.outlook.com [40.107.244.105])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FC01270E;
	Thu, 15 Jun 2023 07:24:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=egB0/J2Y4nEy5SxgPMa8SKKEb/nqDdBUufVD8rkKmqcDBxz5jtvg4OC/4xZKPqgW3kwNamNaD/8RyF+QX9ucDuhwTvvFe2LlYL7vBn4MY7ebgOkPdqtNZ4PgkQfwJz3/ZXA/CY5JCjTAAn3LmA3oL5TmKDkrBlo5+1FhQ7Gvo8nRhxpMrJrHXkOQzvW9J0h5BQeBfL5djyycTiHl+i5h08FeW920rl3R8W7Mxz2yVvYVyC7LGlr9AGS6zXOD2+iz/L+gbkLUw24qK2bJOBe68iYMm2qi1isYj/Z5EK0a0LmshKw67cfaqH7I8iKDoEeiSl9ezlG31J/SonvNy2WWrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=07tmuNyTZWfxJI7qUN2AQb3q1IETxYg9I8GITJ+a7po=;
 b=YPgUz29dlYxrNz3xUBOTU4qozKtiAo+1a1ZiPoSUT2OEFDnDlNUr5Vrg0nDMLpFS7WvUIPPIYZGha4n1GuvuWLm6NVWh98Pq9x0TtvVrv+mei2vzI6igak3iK2SN14TzHE45Du7mm6uvP9W6VFQQwqkiDUYot/vkaUIohliScoCNbcUF+Wke5k4gNTEw9mj+Q58OoCHRDPyM2/Fd6y1xLXM5aGhwt0Lq9IWuiq/lQzszH0DC0W+j1dX1DuWCxFrBLGjTbbfQ6o9MGZlIAhyG2zE5c4R25yWEgY9ErYGHh+s1mkYEee4SgFeclTxXsMDkdstaeGli4W+p24gzxkNO8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=07tmuNyTZWfxJI7qUN2AQb3q1IETxYg9I8GITJ+a7po=;
 b=i/+HqGe89TU8Jckv+Cg0MTUnU4OTbGcY4UFZrRXv8peNgfaU0g59sT3od5W/1CXrHhPbhB695VHc1RpXME52PrXv7fI8T8dNbdVv1cPEnzn3K8cljmgQ2sRjUt5Uk6TdwiTxW2ohWbpvW13W/uYHvyThLvVHQ+EPJsPLWZz2rQ8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB6019.namprd13.prod.outlook.com (2603:10b6:510:fc::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.25; Thu, 15 Jun
 2023 14:24:02 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%5]) with mapi id 15.20.6500.025; Thu, 15 Jun 2023
 14:24:02 +0000
Date: Thu, 15 Jun 2023 16:23:55 +0200
From: Simon Horman <simon.horman@corigine.com>
To: carlos.fernandez@technica-engineering.de
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: macsec SCI assignment for ES = 0
Message-ID: <ZIse+5VepvY5dXN0@corigine.com>
References: <20230615111315.6072-1-carlos.fernandez@technica-engineering.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230615111315.6072-1-carlos.fernandez@technica-engineering.de>
X-ClientProxiedBy: AS4P251CA0018.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d3::10) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB6019:EE_
X-MS-Office365-Filtering-Correlation-Id: f8394ea8-64a4-4818-53bb-08db6dac2acb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	2gh4sB/Vyv9Cq10/ZDPj6orRYk9d7MToySoqL7KBjZpSzZs1wt+XXYRtvdPNH6Kn1cXXsrublfJdOUxjlwpsopPkz/I49E8xcBgJJV+erM6xEJop5RsoIFKvQthL17wDdZLVf03ZRIhtcYwPo61uGwNzNwGiI1iqVoHVfWZkCJ9lr7FbIPMRd8y+Ey7m+exd5qwrZMF+ge/SvIdvKpQzvT7EYl4FVWEQ12K3YcOF7EpVjwyASkYWI3Dldnib0Buy39C30Tc9Ihzgp4kqItHTwin6uzHxOmJyxB1GFQEvgQN4NZznZa746E4ZRyEnifK15GRQapyt/9SxRe5Vbk23gA+PLV46regs+v1EMYcJ/6lDJtnHUSXOSbEDbT7Y9lp3fOqhrp1nvyZVm5KjPfJxWK8MO9cQzaqQqQliz+cad68ktGa1P9Neai9VB7iwc51Qac3EigSuuOfZer9vhTVrBJxTSSMufQxKunTXUknZpzRyKPdl6nikXzGtOIZNMPIvXGj91F357/G1dr5lliy1Im4rRhO0m5zMkl3PEy3Cu39pxjLd50+AIppXqZKo2Vc8v6eSr0Pxj+7WS4BV6sdHLOjj6YOmchTb1FcVtQ6qO8oD/zD1P6Xc58KCk3Us4H7IEtHv0Bp0fEgMPfgDe3Jk8lqmNdx7mXJo09DSEwU+MlQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(366004)(346002)(39840400004)(136003)(376002)(451199021)(5660300002)(478600001)(8936002)(41300700001)(316002)(8676002)(6486002)(6506007)(44832011)(186003)(4326008)(6916009)(66946007)(66556008)(66476007)(6666004)(6512007)(2616005)(2906002)(83380400001)(38100700002)(86362001)(36756003)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?r0Z/RL0Wexwj7Q2NyiHmK4EbZ7kqT0LizCBbAA2EEp4q5dmVnv1OfJW5JRsu?=
 =?us-ascii?Q?29d3CWy2HGnsQE630bdHyY/aARJxWwg3I3X4a2ahRVIJ8hvub60OxpZUPWXa?=
 =?us-ascii?Q?yRfDlTL9lb16sZgbNO8v2EPYEAXqmRTpLTr8BUP2rj1F4YzHKZoIWkGGMewx?=
 =?us-ascii?Q?aq0NT5uAKXl/pyQtxkP+JKjeZ/eEYfBD/SeP2yMP5sLizDdDcGKLacz/VCN6?=
 =?us-ascii?Q?c2Un5CVrFSpXqE7Vy0AiKS7T/gFCDUjPvNIS1JCnUEhNbA2MxwWA+GgyKh7s?=
 =?us-ascii?Q?Dgscs3YHaw3mDaS+XEk8wiT28HTuUeQQ7ExqrMK6zHdKQYI8WtWdrp5aet6u?=
 =?us-ascii?Q?GqKLJ9k3LdZvO0gHNNIiTlS82ZrZKA8C7XS6Fh6pn6KhQf4SF79lWdSvVIUb?=
 =?us-ascii?Q?bVQfhUys4rB7EEIC+HKN0uzSTtP6rtmUK/J3oFVjigZoPZNmsvgbkQChgVRu?=
 =?us-ascii?Q?oD/I7tQMHolkW2798JIOP2bIOqFNJYHOmUSXnjDV0MF4b1mdOsNqbiy7IdDV?=
 =?us-ascii?Q?+/UmpRArWgAyNtsHwOSyGZX4thmw97BN0kElzF9vAPBW8L5LyQbyOiGaqj3R?=
 =?us-ascii?Q?NDQ8g6CPQonbbHvi8CiQFyndr26NVXSG2gSC2LceJWDpU0coPIbKGpe0bRUQ?=
 =?us-ascii?Q?L7s5Y+IAxfxYuLpNTZbNSQUfIocZvQd+aGMjyI5k192PRZTunwpZv4FiE5bA?=
 =?us-ascii?Q?GD9r4mHxGAAp6s+FU/YRn5QNb8VF4pRZ+hzAdv/ZkmKSlDtRMQxxnEzGmrxI?=
 =?us-ascii?Q?DmSZckCHtsqrSq+56e7R4H5vXP7WG1rkTKVC1Z13XXSzXurQDxljW6KB1JWc?=
 =?us-ascii?Q?AOtDtidfaprYvzqywuEAYAdeeKJG9rAS0vlUR68Pbw1554A3S5G8QeDQD4Qe?=
 =?us-ascii?Q?GtwToXqwRa/3kZTPrjhtZJHuHMAthlsRY/rOihj8K79gHbcpZl1AwmygzpcR?=
 =?us-ascii?Q?hMp9bz7UlJv+WVauCxv29wUdiw1PWjhMt/NmRrzBFTaL71jrzvghorZsMOKZ?=
 =?us-ascii?Q?82h9/Bq4kL5fOr3wzyIUJ0n/lJZgiaWUGPTxm2E13UojrLa9liBUMYnQLbKW?=
 =?us-ascii?Q?jKeS0OSBNGi4KBewRllrXp5lpzv9Voaoqxryv2SCnOlCdYwcCHv0Bjof8t+a?=
 =?us-ascii?Q?fhSPB84MUlgHzsJp0m3Acf8aFuYoLDyuqP6Npmq6tZve92W92+vQ+PtFl4zJ?=
 =?us-ascii?Q?R/3p54TpVgjDyT400T1efktXqyTSrsGrqeb1yHrc68ciUatm5bF4Nx/tsFT+?=
 =?us-ascii?Q?xsfkShrqUh2Fw6U9QZ6nwItnXQu4Zs2Xi5FiQjcBSRQBKaB0fPJ1EbZStjj8?=
 =?us-ascii?Q?AZ9TjEQ0dXMupc41e5kZf+LlskeeIvZTCVrNTL+7Gra4L6ygxNZ3jZvH/xzC?=
 =?us-ascii?Q?9DT9gdQG7tIrdHjpflERXOXwK/6ebK6D4XnQ7vr96cOzbvFvktmfc/kKloes?=
 =?us-ascii?Q?0o9gSYU35aDrVaO+Rq2KH7JVEw6raqcWr23EzGv0vJtNBjfJbsSTJ1q6vb/N?=
 =?us-ascii?Q?a1bNNoWTBMGV0WbVGgV5dVIMHTn7B4G8tcT5SoMd7dBmxhnFC68vNIGLyEi/?=
 =?us-ascii?Q?XXID9agROQjolsmwOMB7aWUoSHrFP/3MOn9CGnbMHb3Y5S60rr+xx9TzObZT?=
 =?us-ascii?Q?Gb+ny+I1dB4bP/YeMgkQZu8abGgW3cXBiCy3W6ApkvLWfbjtoNgbEisLfzVf?=
 =?us-ascii?Q?4VG3Jw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8394ea8-64a4-4818-53bb-08db6dac2acb
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2023 14:24:02.4496
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3kBgRq+jc/KstIJvGH9RfgaabTJjyNE+B6bsBi5uAh7cE9JzjtzluM6gP87i/8tpbC8Ose4t45w1ijDDqjZFhbTmSAVKewmUok9UZbS++L8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB6019
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 15, 2023 at 01:13:15PM +0200, carlos.fernandez@technica-engineering.de wrote:
> From: Carlos Fernandez <carlos.fernandez@technica-engineering.de>
> 
> According to 802.1AE standard, when ES and SC flags in TCI are zero, used
> SCI should be the current active SC_RX. Current kernel does not implement
> it and uses the header MAC address.
> 
> Without this patch, when ES = 0 (using a bridge or switch), header MAC
> will not fit the SCI and MACSec frames will be discarted.
> 
> Signed-off-by: Carlos Fernandez <carlos.fernandez@technica-engineering.de>

Hi Carlos,

some feedback from my side.

> ---
>  drivers/net/macsec.c | 28 ++++++++++++++++++++++------
>  1 file changed, 22 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
> index 3427993f94f7..ea9b15d555f4 100644
> --- a/drivers/net/macsec.c
> +++ b/drivers/net/macsec.c
> @@ -256,16 +256,32 @@ static sci_t make_sci(const u8 *addr, __be16 port)
>  	return sci;
>  }
>  
> -static sci_t macsec_frame_sci(struct macsec_eth_header *hdr, bool sci_present)
> +static sci_t macsec_frame_sci(struct macsec_eth_header *hdr, bool sci_present,
> +		struct macsec_rxh_data *rxd)

The indentation of the line above should be such that it aligns with the
inside of the parentheses on the previous line.

static sci_t macsec_frame_sci(struct macsec_eth_header *hdr, bool sci_present,
			      struct macsec_rxh_data *rxd)

>  {
> +	struct macsec_dev *macsec_device;
>  	sci_t sci;
> -
> +	/* SC = 1*/
>  	if (sci_present)
>  		memcpy(&sci, hdr->secure_channel_id,
> -		       sizeof(hdr->secure_channel_id));
> -	else
> +				sizeof(hdr->secure_channel_id));
> +	/* SC = 0; ES = 0*/
> +	else if (0 == (hdr->tci_an & (MACSEC_TCI_ES | MACSEC_TCI_SC))) {
> +		list_for_each_entry_rcu(macsec_device, &rxd->secys, secys) {
> +			struct macsec_rx_sc *rx_sc;
> +			struct macsec_secy *secy = &macsec_device->secy;

For new networking code, please use reverse xmas tree order - longest line
to shortest - for local variable declarations.

			struct macsec_secy *secy = &macsec_device->secy;
			struct macsec_rx_sc *rx_sc;

> +
> +			for_each_rxsc(secy, rx_sc) {
> +				rx_sc = rx_sc ? macsec_rxsc_get(rx_sc) : NULL;
> +				if (rx_sc && rx_sc->active) {
> +					sci = rx_sc->sci;
> +					return sci;
> +				}

I wonder if this can be more succinctly written as:

				if (rx_sc && rx_sc->active)
					return rx_sc->sci;

> +			}
> +		}
> +	} else {
>  		sci = make_sci(hdr->eth.h_source, MACSEC_PORT_ES);
> -
> +	}
>  	return sci;
>  }

clang-16 complains, as I understand things, that if
the else if condition is met above, but sci is not returned from
within it, then sci is uninitialised here.

Perhaps that cannot happen.
But perhaps it would be better guard against it somehow?

 drivers/net/macsec.c:270:3: warning: variable 'sci' is used uninitialized whenever 'for' loop exits because its condition is false [-Wsometimes-uninitialized]
                 list_for_each_entry_rcu(macsec_device, &rxd->secys, secys) {
                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 ./include/linux/rculist.h:392:3: note: expanded from macro 'list_for_each_entry_rcu'
                 &pos->member != (head);                                 \
                 ^~~~~~~~~~~~~~~~~~~~~~
 drivers/net/macsec.c:285:9: note: uninitialized use occurs here
         return sci;
                ^~~
 drivers/net/macsec.c:270:3: note: remove the condition if it is always true
                 list_for_each_entry_rcu(macsec_device, &rxd->secys, secys) {
                 ^
 ./include/linux/rculist.h:392:3: note: expanded from macro 'list_for_each_entry_rcu'
                 &pos->member != (head);                                 \
                 ^
 drivers/net/macsec.c:263:11: note: initialize the variable 'sci' to silence this warning
         sci_t sci;
                  ^
                   = 0

...

