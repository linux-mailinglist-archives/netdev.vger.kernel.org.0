Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74C3D65D4C5
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 14:56:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233373AbjADN4i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 08:56:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239419AbjADN42 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 08:56:28 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2042.outbound.protection.outlook.com [40.107.93.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AE5320F;
        Wed,  4 Jan 2023 05:56:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TrWMDY0D83l0nLshGo/55yMpdz3324sJIhlRQvQ1iKgMFCxoKAMdDsWzRC06SUF8vZC1LxXLqpDROGgWbvxq8tl39v82RxMjuv6087ymu/um/g8jUYLiRyiNo1CRGGBJf4zjgAkDUDrcApS7rw/zdd6pR+McedTjPB5yT8Q7ggZClHDk+EYkBzU6qHLylZ4datHxHCdNd7I1K2P85t8wlKuH6VvnF78tONYXyyiJ2MM2j1Ia0xg+GBohqzPrEIHvnqOyX4Um4O0OfqUr9+tvW5V/1SuQRrGJFRqqUJSZiR9XEOa80ShrgfDq74xieUVYx1YSywwMA9PClPJqdQkebw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2Q76c67yPs/m7IWcdahWbvgmrWNnaDKHcAhs+KW4vTY=;
 b=GvWYWn5mFqK+AfutQuOWJNLsIwL00xfEtRp6vP6Zf4g6g9XjYbv7xOq+a/3s+PuAjcP408T8Rorf42dGQO9BjTS1OYoPIxIbsjQB87MKx2YWUuVOyRy/qP10DHpaOH3hipOF6ZmkQ5WYsaK1+xohUpmrJ0061zMayUqxgNGNquBYyLMuni3ubvUKJdZkb1NJ30skLZ+Krg3N+ayPaIJ0+ZN0hL553D0ci2XdGPHXqhHctzgq788UcmvkWoM/AtzBULG+vT+7VAEjrVeBZA+Exk1s0La3+v+gpaBP5zfEUayf42dkBuNKkdyQXgG9abv/86cHCIyawAZWy9EMD0Vc0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Q76c67yPs/m7IWcdahWbvgmrWNnaDKHcAhs+KW4vTY=;
 b=P7prayNH0um6EsfW55PH0NEK46Zja0rNt3sBAjowALdsXiQN7JDJYbIJcGagO80izg3gmIdVB9CTZbcJh8ng+0vw3+EMIEWhsXA4owUqR96iIAPKt37DcDzreeAj6LYYXYiziwRMHaXqX95s39kxg1S7PD6gQgpwZ9ZzWvea2BkQvJfa7yPEyaDx5wzDNQGGTzPpwg9M/uDEV03jgJOmLM2tRFjZrUCRNN/PWleu5aqgCsX1Dzl9jzRUh0QneGHCIxJB3+IoHYNvaI/bsYojwXH1le85PAkUeke8yvNJAH3+6hkVXi7/9EAgMdwizmqbeu2HgGABqLnvegwj9mpymA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA0PR12MB8421.namprd12.prod.outlook.com (2603:10b6:208:40f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Wed, 4 Jan
 2023 13:56:23 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.5944.019; Wed, 4 Jan 2023
 13:56:22 +0000
Date:   Wed, 4 Jan 2023 09:56:21 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Or Har-Toov <ohartoov@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-rdma@vger.kernel.org,
        Michael Guralnik <michaelgur@nvidia.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH rdma-next 4/4] RDMA/mlx5: Use query_special_contexts for
 mkeys
Message-ID: <Y7WFhXk6UhGulLKi@nvidia.com>
References: <cover.1672819469.git.leonro@nvidia.com>
 <4c58f1aa2e9664b90ecdc478aef12213816cf1b7.1672819469.git.leonro@nvidia.com>
 <Y7V5CtJmorEc4u93@nvidia.com>
 <Y7V6otdhR5vJ1nPy@unreal>
 <Y7V7Zmnldy81lRIO@nvidia.com>
 <Y7WFTULBGZ1WczxV@unreal>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7WFTULBGZ1WczxV@unreal>
X-ClientProxiedBy: BL0PR02CA0131.namprd02.prod.outlook.com
 (2603:10b6:208:35::36) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA0PR12MB8421:EE_
X-MS-Office365-Filtering-Correlation-Id: f57872c2-bee7-413a-7b1e-08daee5b76ad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GceHl9uDia6kUuaPtprTGEcgGqp3ejqdJPUxsqNBlDsOFfO9+hgNKYAF3n+siknVdccGJ4VrIG9Ccr9nrwRITMlRqAAU6ROniFXEpeeZlgArXIN2L7O20QYUV6/uFZRkSNL6Qq9BRADE2JFKIXqxdw1AprIaW0TGqeQOBKdGaDn/OtQErEbROBU9c3Kk6iB25mF1+yC5EyFLg4CDkhOC8TkLXI3qYrzllFF5rrAi4F8ANc3EIEuIVgIATZefAHzdeHEncdVmM5BPX9PLIly2ROUz57+0Np/r3AzLMxxWJ10Xdx17hqRkhwVkZ8iGz4aUlk6rtTdokEd5vqgaHHNaq+iB9yDBG9ciY/4kXOvw8sLCgjz3NWGZ+SMPtWg9Smy1gRJghDDbbXWwBu7Hy/nXjXMQozGHIzAROLCjP/XlNiNAmOUiMN8+aKg9jqGtrPmOAOKpr1uC80HZ7p8QW98Ck62iuChwjztjxT9KJmSWCeEM1ec+nawKnbC7rcG45rMKXHqeL/wlfWsvhp8VmD/74GrmI6/7iRoJDGtz+DzlnT/uSlB/kYfOt/QCjh8/3Jw9hW4ag5N5SIT3HVck3+rzzs+qL9efoQzk1TdDyooJPioXMfswtsdArHdSfOqWthUP0IR3m/zO46ZhJ+o4v8/50A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(376002)(39860400002)(396003)(346002)(136003)(451199015)(6512007)(6916009)(107886003)(316002)(186003)(26005)(66556008)(54906003)(4326008)(2616005)(66476007)(66946007)(6486002)(6506007)(8676002)(478600001)(8936002)(5660300002)(41300700001)(2906002)(38100700002)(36756003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3N7Ax8kux1Yr6TXqPNXeaqA50DUeXeoN2LlI6c7OuNxmBhCHSMzcJFZYFILc?=
 =?us-ascii?Q?VWek1AacER/o78nkfTqfRNJswKY/4E5d4GzvJSmSnm/zBstHNfJmr7s2WB9O?=
 =?us-ascii?Q?Cx+BwzN2tNfw7M9aBVm7bWf4eZnu5mlx/rF/FmigNazVDNPljn3LS+g1vAs8?=
 =?us-ascii?Q?o0DwCsO5VjlyUzB518OXinybQrb36jIjhnVVn7qYc6fv6unGwpwWXjhd20cU?=
 =?us-ascii?Q?0HNjw6OT6WYF9aNwFXalxajlDIjDIgQ0DyRJ8UTadw/BZfmI1Pj4RHf3c4Pj?=
 =?us-ascii?Q?yEY+3AGEIOpXwWX3Q7cWMSMhgn39htb59hjXF9fixemOjpISWONFkadFzc/b?=
 =?us-ascii?Q?hl5xDZN6/hKb+3EfziF5DCzvJq7vMEy0ckXyBHcdrchZYhFEqibXkhu/u/+F?=
 =?us-ascii?Q?4XZMqUUJKM1P7gLFqzB+cDXBsP73BBPevLV8bSdltTY9FJRU0mkF8629IQ8e?=
 =?us-ascii?Q?52c6UsaifG8I8raGkvgz5HPXKvo0O8PQuQxamvNgNZsXHHgq/JcaOtIq5cX3?=
 =?us-ascii?Q?RIZDMHZ+MpUBgX53+7qM32Pks58gyVUtZ5iM/L3+He7Ie827cEsKoXAkiWP/?=
 =?us-ascii?Q?XVVinfayCIXMG+sffCYBfUA2YLSw82xyGxBgQuTEYK3qfhUeuYQjMOi0w009?=
 =?us-ascii?Q?+Fcx1VQuIbUbQBrIiiMvDTn1ntmongeWTrbArX4BZwdIRwIFcxKhKwKhBK2h?=
 =?us-ascii?Q?3Awj5KzaSlScF/EmuUKkq8vzd3Okiu5joNRPmHoJDaN3T0tkFJEAbXEXWCYE?=
 =?us-ascii?Q?Urp4DJ7bVPa7n3Icw3a/oBCDfej68AHCK/roD02j/4VOdjl78LQeWXBDWZ8B?=
 =?us-ascii?Q?ZDOsb0ocmsQs0zik4qPVLpGzKWbkPFip9frDx6KTobEy3uq55gWaMCLTUzvA?=
 =?us-ascii?Q?37rFLPI027D3F2vwExffnnZqP6lFd4mn7dCig6sR03YxGKZn3yza+sgEXnHI?=
 =?us-ascii?Q?XV7ARt7RHEbgFmaaaMf+1tz7SjdkLhdkyuxQMhppcsoIVT2M+I+xbAWj6Bm/?=
 =?us-ascii?Q?/Uo6hQUmk8OTffFxL+QxFrw/SpOv+9hG9aje2UfxvjCfxddcSmE7xmvswbKG?=
 =?us-ascii?Q?cSu12sWOrSXTAVqsH8fGHK6+LHOQAFJXlMoXMju1/VSTo6tGOSKFAY25janF?=
 =?us-ascii?Q?yfnemlG+aCUYMb0Cr9BuDdydcUAZzVPjDru/lK3QASM+hehu9djJeqU+ENDS?=
 =?us-ascii?Q?yrc41JNsZC+xBNkSpwLRdp71gTafidFImKWzIlFZdoRx8pVklMLd//lCjVzP?=
 =?us-ascii?Q?Bss4Bky0sT5MrZo1kHrys2255jz8xBEV8kereNcCz4KKstH0yIj0YLyJ9d+E?=
 =?us-ascii?Q?1eVQGIHVc7LvVWbOw5wivm9NHo/DapMFo8KLDgFcGGVxBgwzWT6KyzAzI9Xz?=
 =?us-ascii?Q?E0Tx4UNoaQ8QI623FD+ZSoBwxAN42894aSk9UV09BpBO6D/1HiNCPj7bnQn4?=
 =?us-ascii?Q?DFqcHYYux9PIjoJzOCupliJnDDeg9m8R/ZKzYIWLtkYT1MA/b47yB+oYDI2z?=
 =?us-ascii?Q?wxV2l7ywx3+RaMKfZsoyrV/Wi3iSiBgA+Z4U3bOzEPiL3/JMXmFJ/FMnZpW7?=
 =?us-ascii?Q?5+2k4hSKVhgSIEb5uXYkBOjvX/LijL21FADPh7DH?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f57872c2-bee7-413a-7b1e-08daee5b76ad
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2023 13:56:22.8423
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mI2nLvufec6VfLLKA2EAEoUdccj9BsUSANPagSNPIN1ApvTBo39OirohewMaGCVG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8421
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 04, 2023 at 03:55:25PM +0200, Leon Romanovsky wrote:
> On Wed, Jan 04, 2023 at 09:13:10AM -0400, Jason Gunthorpe wrote:
> > On Wed, Jan 04, 2023 at 03:09:54PM +0200, Leon Romanovsky wrote:
> > > On Wed, Jan 04, 2023 at 09:03:06AM -0400, Jason Gunthorpe wrote:
> > > > On Wed, Jan 04, 2023 at 10:11:25AM +0200, Leon Romanovsky wrote:
> > > > > -int mlx5_cmd_null_mkey(struct mlx5_core_dev *dev, u32 *null_mkey)
> > > > > -{
> > > > > -	u32 out[MLX5_ST_SZ_DW(query_special_contexts_out)] = {};
> > > > > -	u32 in[MLX5_ST_SZ_DW(query_special_contexts_in)] = {};
> > > > > -	int err;
> > > > > +	err = mlx5_cmd_exec_inout(dev->mdev, query_special_contexts, in, out);
> > > > > +	if (err)
> > > > > +		return err;
> > > > >  
> > > > > -	MLX5_SET(query_special_contexts_in, in, opcode,
> > > > > -		 MLX5_CMD_OP_QUERY_SPECIAL_CONTEXTS);
> > > > > -	err = mlx5_cmd_exec_inout(dev, query_special_contexts, in, out);
> > > > > -	if (!err)
> > > > > -		*null_mkey = MLX5_GET(query_special_contexts_out, out,
> > > > > -				      null_mkey);
> > > > > -	return err;
> > > > > +	if (MLX5_CAP_GEN(dev->mdev, dump_fill_mkey))
> > > > > +		dev->mkeys.dump_fill_mkey = MLX5_GET(query_special_contexts_out,
> > > > > +						     out, dump_fill_mkey);
> > > > > +
> > > > > +	if (MLX5_CAP_GEN(dev->mdev, null_mkey))
> > > > > +		dev->mkeys.null_mkey = cpu_to_be32(
> > > > > +			MLX5_GET(query_special_contexts_out, out, null_mkey));
> > > > > +
> > > > > +	if (MLX5_CAP_GEN(dev->mdev, terminate_scatter_list_mkey)) {
> > > > > +		dev->mkeys.terminate_scatter_list_mkey =
> > > > > +			cpu_to_be32(MLX5_GET(query_special_contexts_out, out,
> > > > > +					     terminate_scatter_list_mkey));
> > > > > +		return 0;
> > > > > +	}
> > > > > +	dev->mkeys.terminate_scatter_list_mkey =
> > > > > +		MLX5_TERMINATE_SCATTER_LIST_LKEY;
> > > > 
> > > > This is already stored in the core dev, why are you recalculating it
> > > > here?
> > > 
> > > It is not recalculating but setting default value. In core dev, we will
> > > have value only if MLX5_CAP_GEN(dev->mdev, terminate_scatter_list_mkey)
> > > is true.
> > 
> > No, it has the identical code:
> > 
> > +static int mlx5_get_terminate_scatter_list_mkey(struct mlx5_core_dev *dev)
> > +{
> > +       if (MLX5_CAP_GEN(dev, terminate_scatter_list_mkey)) {
> > +               dev->terminate_scatter_list_mkey =
> > +                       cpu_to_be32(MLX5_GET(query_special_contexts_out, out,
> > +                                            terminate_scatter_list_mkey));
> > +               return 0;
> > +       }
> > +       dev->terminate_scatter_list_mkey = MLX5_TERMINATE_SCATTER_LIST_LKEY;
> 
> Ahh, you are talking about that.
> terminate_scatter_list_mkey is part of an output from MLX5_CMD_OP_QUERY_SPECIAL_CONTEXTS,
> which is needed to get other mkeys. So instead of doing special logic
> for the terminate_scatter_list_mkey, we decided to use same pattern as
> for other mkeys, which don't belong to core.

Regardless, don't duplicate the code and maybe don't even duplicate
the storage of the terminate_scatter_list_mkey

Jason
