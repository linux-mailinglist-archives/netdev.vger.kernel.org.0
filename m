Return-Path: <netdev+bounces-3720-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 10F5B708698
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 19:18:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DFA991C2117C
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 17:17:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8DA1261EF;
	Thu, 18 May 2023 17:17:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1AF518C15
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 17:17:56 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2111.outbound.protection.outlook.com [40.107.94.111])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AD60E40;
	Thu, 18 May 2023 10:17:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VWFiop35koH54geE09wMlSkkhuzy6EO0jUQf6jSW/LIlYQP44kzHNaO1HI+t0jjyiHxI/jmd/iB2znkbLN4edjSAxMcgB/UWzgPcMrfhiULSE4WMoEhHjv1p/Ll6cGVZZDOJbocrN5GP980BEPKl8D0GZvtt9AL51+OAMWainXM9nNLlXVvaFqTXjxdPSbg5YAGGrX5hDhx7ZO2HkHFz8KVzKLorNTf3sgcLqlXnNeDjnvBoMmSV7athRFpoNRoCqYw5xJHbpWSO8aWEuWzdDkuHbHD4z/s7sipY39fAzvhcSho7+aaMMM61F/Py4SrrPfGXXGOVPSIva7xQ6PctzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6/WgPp+EDvQlMSOXyi4rEdTMvAt6ar3TqDZrm4jAcZs=;
 b=HbbDTHMrldPN8AI/azA0AVqnW5J3FgJO5BP8Sxclk9q8pvNufNRNVcordvQq6zCwaBlgPr6gNnVn7E1NigpuUftd237JJmsU405u+tATczszB8Asi9iRvuk6P+jJdYoBkY1FEZDV6qiZbFCEJHx7TCy39oR+SpTZCFJ6mg52w0BrHAcb6cKi8yXGxVYE13lfBlqhjyUM+houLQAub814ZerBq7Ih/Gy/r2GU5ZzKR0ISwuovBlUnFQGbu4WNk7Ig6S5d7FuJgxltq4F6/TP6CpW9EVzIaUf/xOyUKcXFHgP/E9SzsbS5hyQoaGm1kgxf4f0fi8++FozR9l+82bzrHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6/WgPp+EDvQlMSOXyi4rEdTMvAt6ar3TqDZrm4jAcZs=;
 b=KhQ+3Y90UdIAT5r4tK+yoEpLnjmfBL4F22LTZ//1BpwKbGBWdBWTuLWwMeUYFDFqH3CGEzZTq/1pToz451jr7f+9Z8EF5wMNibJkmbS97RscCLZViQw/FBdtr/S56/GwqFpSohZPIPT0LBT16ZBBl7yWnLH7mtyB2VQVn5diVws=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ2PR13MB6118.namprd13.prod.outlook.com (2603:10b6:a03:4f5::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.27; Thu, 18 May
 2023 17:17:52 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6411.019; Thu, 18 May 2023
 17:17:52 +0000
Date: Thu, 18 May 2023 19:17:45 +0200
From: Simon Horman <simon.horman@corigine.com>
To: wei.fang@nxp.com
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, Frank.Li@freescale.com, shenwei.wang@nxp.com,
	xiaoning.wang@nxp.com, netdev@vger.kernel.org, linux-imx@nxp.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: fec: remove useless fec_enet_reset_skb()
Message-ID: <ZGZduVeDx9TvlToT@corigine.com>
References: <20230518130016.1615671-1-wei.fang@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230518130016.1615671-1-wei.fang@nxp.com>
X-ClientProxiedBy: AM0PR02CA0113.eurprd02.prod.outlook.com
 (2603:10a6:20b:28c::10) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ2PR13MB6118:EE_
X-MS-Office365-Filtering-Correlation-Id: d780a7e3-9fb0-47a3-2035-08db57c3d008
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	PGXxYEUVx2BnMt2V5VXgfNLbPxPvgCf8oGMRsmHsC1qzzlj7auWfNTCm94/cdJyx7idGUevQ8neN31pV58I0w0jItRNinm6PzKThbyLh+WTchCDheJMtbomXTslTW2Vn5cz0Hl03doSA7E0vloskzal3XBb+hYA7wh4Ruj3+uyT9rYF3qdG9Tx7xJBfgaOLeOr+UCsLlBqkglar2T97xFU9tmAamqYEelRVqfxubQ2I1lKrSHOKp3bR4w39/bHY96151mW0H56j/Y24cuSbBcs5OkRCGwsti7kAYnLAiuKT39dafCo3fzeqPFpntV40DEiuPLjlgX3CRj2ZqRm15Lbg/31ohMMGnaSi9rul96hgpYN0Mo4q7tkypiMVZT67/jLN7+3Y+XTm39Tm/i7+25Pn5+LLLdhtOSRyyzwnw/svaAgPn6JWOeyFDF+5AJsRPq9p4A+criZFygP3EvyuwVbqlc2GFa9T4FfkqvtrKMiLoVq/Tv5nOcuXXcFUMaCpzBZHtNTxUvRyhYbBSzMlCllUXiNi0haIbdku+k3BPY2cTEfhPPVnYPzKMnq2OLVZI
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(366004)(346002)(376002)(39840400004)(451199021)(66476007)(6486002)(478600001)(6666004)(66946007)(66556008)(44832011)(36756003)(86362001)(41300700001)(4326008)(316002)(38100700002)(5660300002)(6506007)(8676002)(8936002)(186003)(4744005)(6916009)(2616005)(6512007)(7416002)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?NHlOS/bz8RUzNE7LN0UwkSJ4twRPsfcHohc+37wfMyicdmdhvJAjwUyHepmA?=
 =?us-ascii?Q?EsYJeUGHClY3Wy9jWhEWsRZ4PP7ulNQLImsaVHDIQdQcusOY2C1D6bVwgjsj?=
 =?us-ascii?Q?id7SNFtrSo7y3YiuADj9FA7LeNI1gg4VPYMiqeisR8WW3NUfsETR+Hw99DTd?=
 =?us-ascii?Q?r7/Qs8jKXIM4NGE4QCJH89BK0saRoOh+F1n/WU3oW2as4KW6hSZkF4iV0EEV?=
 =?us-ascii?Q?rIUEALPXzChW7kM8/j/C2pl0eePv2D+mCiVusb2ZLA264+VpPUrIc08iJoBD?=
 =?us-ascii?Q?SUz3KaYkZSqijQYiqqaRgJESqfo3pYzMne5Qgxycm/84Tlo+B6fX4PbVeiE6?=
 =?us-ascii?Q?zPZXUlnqIaYYm6QTEVnzGfcwyEqaJl8BIhsQG2D66AHdj4E1/WPe8L2jihj8?=
 =?us-ascii?Q?YXsqsUom0sYYb8lQEVgciwdmQO0I5MIK58+WNW57YlZdaoTV32ELqfr7Bxt+?=
 =?us-ascii?Q?kJt0kxki8JsjyTBn5eFCxtOnFwRyBWrGH1I8Ee0W5Dl5JKg253GvytbtW2EJ?=
 =?us-ascii?Q?Vv9PhdelDEzP0ycF8GlLF5gWf1R9HwziSBH/Bp0mdW2RfoA0JFV4I0RU4+H2?=
 =?us-ascii?Q?xOI8BXFq03qXNAYpkApVMc+wMFdggwVLhiq9+1OSGxs8qdCrwEobwfcrs3sj?=
 =?us-ascii?Q?rqFF/BYmHITgBUcATUE+UOaJFJtQXphYrstVCoei+8FmGNa7hq5t+pYCS3u+?=
 =?us-ascii?Q?EXJU1K0VNP9M58DxgLrzWvCi1KG2+GCS6scQCGOzFJeNqCADdilOLYzFNYqk?=
 =?us-ascii?Q?8b5vCFUezqFqiUhYRZJzv8X5rRSWs+NW5lKtz4WKRECE61QlrtCGK1vR+L/V?=
 =?us-ascii?Q?GAtpn1WOqI27IhVdzfEHuIY6H6WccFCKJy/N6UcpYQHkLfA6rcFqQp51Qytg?=
 =?us-ascii?Q?VKb5X8Et0ZM68F1Wp3E0YYDuMJIHNakMcs5i9GfKZvHukbVGitlGq960+okw?=
 =?us-ascii?Q?GtWe4rA3NRXE7wFiX278yTDJf/fYsWzr9JD5lEZFHIDLr00iXs6ktYj0m2ru?=
 =?us-ascii?Q?cHmm/hViyU+pLOe3i0qJdnUKKuWTYkwjX10PYMdJE6ca+elmXfNXIyFtkAEm?=
 =?us-ascii?Q?CxgK4yF3TYoa2u0KpKy6zRQNdF3jPDCvprbuhx4CXB5WaDMIzp8bRcz9673L?=
 =?us-ascii?Q?psbajzjIr1cUYGKGlFWaf+9yBA81L+Kz1Mw9+orTKG1whFhod2I6BIK6Q0Tb?=
 =?us-ascii?Q?HSXZtOpZWO8vba7K/cHcLcXAhVPnhMJt5RYWykKU7sNY9sf7WEu8emvT7iT0?=
 =?us-ascii?Q?rqTO98aPPqASpjU0v8ZRuv8d4mUvKERnF1RBnZbWcB+lBkQjVVS478CkFOJC?=
 =?us-ascii?Q?w/MF8XjRKaoIQo/nOhO8ja6K/qK9eQ9l8Eb52EX8Oaq3VNVBIlbA22nKu1sn?=
 =?us-ascii?Q?pBZN43QpF58cKIh9OPMyfqjYYk+7aNcnzyBni6pS8rbB75uvo36E22W/z2nP?=
 =?us-ascii?Q?ZX3/2syL9BORk/nwoGOcsh9XI1AxIdW06It4Cf77zKOGF6VX10z0dEb3OW6T?=
 =?us-ascii?Q?E/I4dGTF7ZnpcjU90aA3nTsQObuo0hGUhb+IIZh+KqPuYG/e6Pf3E4oJSwsr?=
 =?us-ascii?Q?xNDVmQzA69xXrGe+iBwSj9Ik0fPkJXHaRI4sQYHQ8fjV4SgJMSfrxlfh63Hf?=
 =?us-ascii?Q?OD7YZGwwF3Dw+FdWICH5oV0vaVnsTcBf/RvzpR/YXl71TsfacyNJ4uST+Rsc?=
 =?us-ascii?Q?vqdokQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d780a7e3-9fb0-47a3-2035-08db57c3d008
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2023 17:17:52.5151
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: upkhjqLe9HPXzaoB8JKTGxP3DdNrMywXbsT/e4nq4RkXPVdr2szPDdPYhdDGzmrcdVfhkS0Fl6W8Pn78JawfMkIVS5a+rcLI7g/933dip24=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR13MB6118
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 18, 2023 at 09:00:16PM +0800, wei.fang@nxp.com wrote:
> From: Wei Fang <wei.fang@nxp.com>
> 
> This patch is a cleanup for fec driver. The fec_enet_reset_skb()
> is used to free skb buffers for tx queues and is only invoked in
> fec_restart(). However, fec_enet_bd_init() also resets skb buffers
> and is invoked in fec_restart() too. So fec_enet_reset_skb() is
> redundant and useless.
> 
> Fixes: 59d0f7465644 ("net: fec: init multi queue date structure")
> Signed-off-by: Wei Fang <wei.fang@nxp.com>

Hi Wei Fang,

this change looks fine to me.
But it feels much more like a cleanup than a fix to me:
what user-visible problem is it fixing?

If so, I suggest targeting against net-next without the fixes tag.

