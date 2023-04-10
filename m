Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F1FD6DC7D5
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 16:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbjDJO3X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 10:29:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbjDJO3W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 10:29:22 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 666664C35
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 07:29:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MQxNJ9B8vB//KvYpozAuADRtbBhs0j0f56NmsbSBIwD/GakeJVk4Cpk8NW36xKo0u4Efb27obClEXoKvAk0hvXjcFiDv4xtfrKvZVe8xEKF7A4qH42QKYhcLgaSF5N74Samn4n5MiRNjK1Cq54t/pIG0iHNXt6EWVm8elRrWR7ox2ZLMrHwxKXfRTI+BQyu1yZDH7n7uU0CgdVQrISjm1AgP57eLjSGyEHlcsKoKJWpR+ZryoGvS5T3zA5K9KqVNI4ihX1OITr82d5jsdlPtx7UmFTmDe2r0VetlfC538h9rujEwVu6BCwBQZA+7IFU/6WMu1LnPFADjkLL5d7Ozuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YFwaMEFy1hxzgD9+7nS1nq51L1nLvp25PXa4lQXRENk=;
 b=D2LHKFhZcj7gjW8RxJ+hb3v1RXpfCyf55H8YT2J/+NyQYQT+C1CLUiRuTKlmaiOH2/4u5WNpcH3uHw+cuzAj7DmLKXAtH49sCXL7686JS9ip/d5HhtaYrDYAV+P/Bbgihogm3658Falms2jt9X967A/FVwceHWAsQyKWoaT6vI+6fL2rnPfeC9prsMlztP69ziznVbNrRK+GX3PxJ58QR6k9ZsqjIRlo+paL0a/GqVuL56GYy1F4uAaOKwgB8k1URmSTqxw2pP5BmMqoVaJ+KwB+KIgb/rcaXycFuyJNkAjykijclP+zP7GeSxg/1ViON6qb/Md0NOyDIHp8TIhMnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YFwaMEFy1hxzgD9+7nS1nq51L1nLvp25PXa4lQXRENk=;
 b=syJdSoZuNMPNWcQbI97GwV8fe2igv90SyU9B2vvAXydsaLK7QdTavmDjVLvZW2pqV/z9xjbWkLZ7IFidgIAcx5mcIOGWsEsMasuleR74rDLGO7WBSi+Yubpw7NzeG7PpUQg7+InXTvkePtI4wi7S8Wn5WhdVrBOXxc9Xxy8uK5k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ0PR13MB5689.namprd13.prod.outlook.com (2603:10b6:a03:404::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.36; Mon, 10 Apr
 2023 14:29:16 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169%5]) with mapi id 15.20.6277.038; Mon, 10 Apr 2023
 14:29:16 +0000
Date:   Mon, 10 Apr 2023 16:29:09 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Raed Salem <raeds@nvidia.com>, Emeel Hakim <ehakim@nvidia.com>
Subject: Re: [PATCH net-next 09/10] net/mlx5e: Create IPsec table with tunnel
 support only when encap is disabled
Message-ID: <ZDQdNV+SRG6EVYlJ@corigine.com>
References: <cover.1681106636.git.leonro@nvidia.com>
 <ee971aa614d3264c9fe88eb77a6f61687a3ff363.1681106636.git.leonro@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ee971aa614d3264c9fe88eb77a6f61687a3ff363.1681106636.git.leonro@nvidia.com>
X-ClientProxiedBy: AM3PR07CA0059.eurprd07.prod.outlook.com
 (2603:10a6:207:4::17) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ0PR13MB5689:EE_
X-MS-Office365-Filtering-Correlation-Id: 95e52a09-93cb-4e1a-333c-08db39cff687
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sPt0NIMt9ObUtXsreiHDCk+h5BprD/SeMj7HWaZYv9qrGMdIPrFrkbXGTLG60KR51TnzACpJyE0OUYv1lj2eTU+FEjFpFTkroDT7nZxtq89/aG/NtiIr489MyqMfCDJotMX6P0A0XnGtErLTkt8lcOuq2Nt02GR4tHYgMLk7jpxgOdcpYPuVsD48sP18r3kwdr5ReclKpZBXNu3iy72CcK6Iu8B/Y4Jj+QtQbojeBOQEgqh5/N1By0XDPOX0CJ0swddnvNlW5Nu3c7yNoDFx9NCq73IMQwtfhWubcc4LYEOo01hXzyZalh6fDrVsdkU62dbkoCevP+E2ifMtByUBU++zL9UIUVhdPtgKf89zEfuUDxHsl/AGHdg7zOpKSKEk36R1anfJSEflAsyNUFHyp3l4N8LWkRHowCuOVT+f1WgJDKHcozeYpj/HFdQ5shvTArb3LJMN/BUMNv0ePnqEdpdAUJ04rU4RrspO3o3WZSIE3l1efaz0L/11fZrqQW35AxG/lmVfxdh4Zxsde8CxgPDj03pPvM8fBxl5TMJY07QBZtgU5Ngtm1zVw9eOyJMdG7IbjFXOWcSK3zAXFq6oK5MWy/BFh8f1sbe0LgIXlnXHYeBTVUDNvFmr7zJgeF3LszoAqJnBbXgKJfh8Fd9X043EAvtP4LEkrZYsDPP/Avo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(396003)(136003)(366004)(39840400004)(451199021)(478600001)(6666004)(54906003)(316002)(6512007)(6506007)(186003)(6486002)(2906002)(44832011)(66476007)(5660300002)(66946007)(66556008)(41300700001)(8936002)(8676002)(4326008)(7416002)(6916009)(38100700002)(86362001)(36756003)(83380400001)(2616005)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?a3V/FFU2M4O8I6onnybMllW9xmjsTpHfKGIGXoMiW9VYSdm3rAQ73LQz8qjP?=
 =?us-ascii?Q?tVppsBwn0mvR8Kru3fSZD5ZeQJXyoKxYUTnGuIXN+9+EdZAXWfXGNDLq0iVr?=
 =?us-ascii?Q?kbTIqHNOFr8GiX8t1T8j/AM1VggIh/UznutgkYr4jk/K5/6dbbptVBGc4d6+?=
 =?us-ascii?Q?Wux7TZfSkOKV6O3oSc6N5N7ZIibNElX5eSKrd36RGq3hUiyo0HKnuNxgeCCU?=
 =?us-ascii?Q?NyAUV4yz6StZePj/bAN/Q6D0IYdchK6SHeHCKGAkRmUb1KlMeIUFH1Ya65j/?=
 =?us-ascii?Q?tiBaRA7pw6XfFXpIE+Zp3G+5KBjiFrn8RjLPo2o01YAN4BuiyjDRAbKO5JXB?=
 =?us-ascii?Q?B/byN4j2hhbNwm6I5mwzaeXn6O2n1ZghifH7NHAGJ0lS/4+prPuhoe4Qr3hR?=
 =?us-ascii?Q?Z/lfTHHcZ5I+CwSboe/t9y6NoSTqMv7u8tBCETBIAHu9iaaa+Y51cjs522O0?=
 =?us-ascii?Q?Md6AqNc3uLLiLcRMlUwBIHIFTHXrlipLDCAxdlUDq4F8dTS6Kl2pYiQYg4uy?=
 =?us-ascii?Q?//vS0Xa51rg6AgZIJo/HyrDP2Q1PYOWEPWFwlLadi7cALghZSxjb3oO9Q3F1?=
 =?us-ascii?Q?INb3aEm3Dq7QjFcD9KbqyIR4/rlFCJ3FwnEbEhYOilAA52JBP2g0bEmLBSRs?=
 =?us-ascii?Q?UXFsWz5iIVareXcqiQWkzdoNLGzvh+s8c0XJdLou0uyJ5ML8rgDaALiZi4b/?=
 =?us-ascii?Q?C3K2sn1S1NXCmb9MuG7PEuuSCC5T7S++bRrNBqKHV3Ecx2l4UBTX7g/FKgSL?=
 =?us-ascii?Q?Rcs5c1zCL0+kWRRpQqVACm/OK5CRbwApNHOpK00QadjObnPc8b0T/Mi0YBts?=
 =?us-ascii?Q?+U4A0QW1Kx7MviXbXNoq2IalyzJLHxiEZfMJh9fHY5679Vpz3gQkV91smNfL?=
 =?us-ascii?Q?viONdZnvqLftrd0IA+UCQ1KVReY5aUUoLE0j7K+o5KGb1Q790JekNByHuVfE?=
 =?us-ascii?Q?NWLjVmuoy0RRtq5zSmHQwBrBMBRWTBS/KpgafwQZ65SDWZ2YdHrOewwH6j5W?=
 =?us-ascii?Q?GajwXr4iMGNV5Ohdb8B7V8CCJbpfLudWVEPAOsh+l1/5hgdeX3GQBUPuSwyO?=
 =?us-ascii?Q?8NVWJDydNWYVdTfe6MvinG8kRgZohQ3Le382BOO3k+LzFra9ywZGEyMDn6uL?=
 =?us-ascii?Q?ryQrKAYPicFvkdExbkJOy4sIKlc8d8tCLq67Mv4bVaDbtXD85nU4/YKQjfki?=
 =?us-ascii?Q?c1/2l0vwJCUqqw+2znwEBlE/75O36+8lmnuNx9aqgSC23XWlg1QnnVml+okC?=
 =?us-ascii?Q?rUK4XTtz1n4BnS9QX/9TIvKYVfUEWZKvzzUFGH077V4mm1JaX5+ayrjOg9xY?=
 =?us-ascii?Q?kH/FxpimLLmrvjGFH59U5ZJaMx3CbWFuziDyh9KBt0Sw+Gnpu4tsC5xQIwsF?=
 =?us-ascii?Q?c31f0JVLztIhnubEB7Di0zp4iZHe34yw4S8kVIAu6NIDnJKhW5j9SejXqzey?=
 =?us-ascii?Q?dP//kiSiEV7ewJmoBSyGPR+a+QauEk/gpo32RsjVO2SOWg4pZ5EC6mZcI9Bl?=
 =?us-ascii?Q?1BAW5PRD3dj1aHA+lJGgVf1bq7+eeBIdSCb+6cjGysX4QVL2dS6LO1iZu++q?=
 =?us-ascii?Q?zQc7BhWAb8EpNSXsPnofY8wLLhq0Dq4bX1p1eoexgBh7bYLBJc6+QnDuyhmV?=
 =?us-ascii?Q?lLLPWRVlKaRkjeXHt18F21vWUhI3kdnXQI2KcsEzHfKv6MjW0UPSb8JlSCUZ?=
 =?us-ascii?Q?vHEjKw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95e52a09-93cb-4e1a-333c-08db39cff687
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2023 14:29:16.2053
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5SwQI98xlTe5llF6B0DzUJurbm7gaNmA90v70XMaHoGQjdrun/7huanl4dtZSi7pXunaAf8EPMVeDfYTZzejv0Q+LIzNygxAG4g4vvkmUa8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB5689
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 10, 2023 at 09:19:11AM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Current hardware doesn't support double encapsulation which is
> happening when IPsec packet offload tunnel mode is configured
> together with eswitch encap option.
> 
> Any user attempt to add new SA/policy after he/she sets encap mode, will
> generate the following FW syndrome:
> 
>  mlx5_core 0000:08:00.0: mlx5_cmd_out_err:803:(pid 1904): CREATE_FLOW_TABLE(0x930) op_mod(0x0) failed,
>  status bad parameter(0x3), syndrome (0xa43321), err(-22)
> 
> Make sure that we block encap changes before creating flow steering tables.
> This is applicable only for packet offload in tunnel mode, while packet
> offload in transport mode and crypto offload, don't have such limitation
> as they don't perform encapsulation.
> 
> Reviewed-by: Raed Salem <raeds@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Hi Raed and Leon,

some minor feedback from me below.

> ---
>  .../mellanox/mlx5/core/en_accel/ipsec.c       |  7 ++++
>  .../mellanox/mlx5/core/en_accel/ipsec.h       |  1 +
>  .../mellanox/mlx5/core/en_accel/ipsec_fs.c    | 33 +++++++++++++++++--
>  3 files changed, 38 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
> index b64281fd4142..e95004ac7a20 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
> @@ -668,6 +668,13 @@ static int mlx5e_xfrm_add_state(struct xfrm_state *x,
>  	if (err)
>  		goto err_hw_ctx;
>  
> +	if (x->props.mode == XFRM_MODE_TUNNEL &&
> +	    x->xso.type == XFRM_DEV_OFFLOAD_PACKET &&
> +	    !mlx5e_ipsec_fs_tunnel_enabled(sa_entry)) {
> +		NL_SET_ERR_MSG_MOD(extack, "Packet offload tunnel mode is disabled due to encap settings");
> +		goto err_add_rule;

The err_add_rule will return err.
But err is zero here.
Perhaps it should be set to an negative error code?

Flagged by Smatch as:

drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c:753 mlx5e_xfrm_free_state() error: we previously assumed 'sa_entry->work' could be null (see line 744)

> +	}
> +
>  	/* We use *_bh() variant because xfrm_timer_handler(), which runs
>  	 * in softirq context, can reach our state delete logic and we need
>  	 * xa_erase_bh() there.

...
