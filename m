Return-Path: <netdev+bounces-3681-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EF75C708539
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 17:43:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5E0B428193F
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 15:43:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0E3B21084;
	Thu, 18 May 2023 15:43:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF1D753A8
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 15:43:31 +0000 (UTC)
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2111.outbound.protection.outlook.com [40.107.95.111])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1617C11C
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 08:43:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PUH+zpBdTJnjTk/DdiEljwsNIMC9nuC3g2amUZhqn6gGhn/g2gT5bK1PlDH5filJ+cVUgdOV3n3Kw0zBfMQChMspdg3ZlU/0m3SyHZy3MEpWMwplsUZq4WFjiiW036YlEdtd08cLdUv2erYeWYuFntNzbo7+tCRQYas4zlD4kx/kJEuAmhp4D5F0Q9+CGVKm9Ijfu5BKj4udfc7vvalI/CtD3yRysArriUnN0Dl6uRbOMwO3lN7ICTJdaeWB49e8qZoWkE0AkiDlbTeINhx2uKlVWEdmW+iEljfYmWaABh0KLro93m9BXWv/pzPiOMxNwzS0y9CNiPDl2bB9qoL+UQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=847JcRu6/nuY+cOREXJRxzFUz3kDY6mrARA0xGa2IrQ=;
 b=DUwwKqkURLuSpuiF/zUNcsr6BPoIgtjE0KowlO/vJvQWS44ZT5nevXMCQW7R0xnXCGI8LCjIjPqmnGqdw4s8GaVjVJLs9blNyWZ4VmpsER1HTFnmOQrjFSKWQ6YWoiXS23SVYG9ZcRAwJ/7Hqb6ecNoY41Zrz2z6Ucrk3jYbwTwF226r6jFgVqacSbQ3B2XObG+mzmaNpMVwd9waWaKiHsL4iPCbToyapbFFJo8uhnxassdj5c6W6irZqW0nj+ir7DlYk6U6raaQw5U8gm8ULmgSD0zcegQOmt6DKKS3XdzYayrulIyoNdJRez1w6LPWCgjU17OujI7c0YewV7BqdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=847JcRu6/nuY+cOREXJRxzFUz3kDY6mrARA0xGa2IrQ=;
 b=VNbRQMAkPvz6QbbLqoo0s+sqEHlW7De8xQZqeuiuqyJbmpivi928PN6yfI/MfjR4RzEfdZNEkODob3gCwItJabxH2y3oz3aP0rTQu9RO4+hI4ZAxYvU0ddmw27MJW/X5UNmOU6LDspDoYSe1J1lxIHritd8wCwzKaP9ajLRrKzA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH3PR13MB6487.namprd13.prod.outlook.com (2603:10b6:610:19d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.6; Thu, 18 May
 2023 15:43:28 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6411.019; Thu, 18 May 2023
 15:43:28 +0000
Date: Thu, 18 May 2023 17:43:21 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
	pabeni@redhat.com, borisp@nvidia.com, john.fastabend@gmail.com,
	tariqt@nvidia.com, Shai Amiram <samiram@nvidia.com>
Subject: Re: [PATCH net 3/7] tls: rx: strp: force mixed decrypted records
 into copy mode
Message-ID: <ZGZHmVq5vZw1yfcB@corigine.com>
References: <20230517015042.1243644-1-kuba@kernel.org>
 <20230517015042.1243644-4-kuba@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230517015042.1243644-4-kuba@kernel.org>
X-ClientProxiedBy: AM8P191CA0008.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:21a::13) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH3PR13MB6487:EE_
X-MS-Office365-Filtering-Correlation-Id: 90d03f96-efef-47f8-6fb3-08db57b69fd6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	jMCCBYr/2uJ5ina8c1ODjZ0i7xTmWKUlhL4qAqKLD50oMDjcEnaYB8R7H3iocQsxKSzqCM0sC7Pa3D+Z8FfWezXPcxcqipicBm76aG3vgJDOOBRqqCdRCN8KIaKX106hA48Wk5zK8FwW7XCqqkYSe47WMPX1xxDFFzXHNss9FLjsMYlmSxuQ60kxUGyarWkGNoJc9dgbnw6wFBMMm2W7R+MC7WU/CjwSCFQK6aV6P/Vr2yRgzdhK5s5NrV8nSo2fKfNUHblw2CiXMLr/aPk50/FNQgAh9ukLDgxRQhgUITcHBEAYi9Q15mijOT6u0XUjsSqj3W3AjKZiIEFpc9Hn76qWDQyjuIJ5utD3sKRBj7Ighyhlf1xiTXaGJ792NfNJkAt+4HpcBsNQBG/j4DMlsxALqEg2Znp7DKihTVMKrmKASmGXWfNx7K1EyQcuw+JOsKX4j5TkNR7RHOCFOvzr8mWGcQs/kF/Pv/Ec3sFdKTaXOD1knRiAkybRNN3TuD/LmuXQHXf/WV/OsJI9D4diPMc+gVyjfkbREHeSqAnv5kcQTnkBXi47v27KgVzqx023
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(39840400004)(366004)(396003)(346002)(451199021)(6486002)(6666004)(6506007)(6512007)(186003)(5660300002)(44832011)(41300700001)(8676002)(8936002)(4326008)(86362001)(6916009)(66476007)(66556008)(38100700002)(66946007)(316002)(2616005)(2906002)(4744005)(36756003)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?971tgGNOxAX3C5JEap4mSO5bN4IDPLfGY5rA6NLDOBfy+b/ikV9Xk9Qs1oF1?=
 =?us-ascii?Q?nLWs/e0Ai2A89/dyD967chbUtkHekmcUCm817edNJ1N82BF2IJPF8ghoC95Z?=
 =?us-ascii?Q?hzRN0o8RC5xswoIpAt7qTB296GXX5Pl7uaMcKfBEZ/tH86Jvnb20DbGPbSp9?=
 =?us-ascii?Q?lzCSSaBKb4bS6wNISDTEwFgUldL5DswoK5hUVeKgsLzGWVV8llQO2eO4PORE?=
 =?us-ascii?Q?lb5etFv1jWfjpshFi+5YdaenmnQbIYwM/fbASbxvTTG2tTiX4TSiGigZqZV6?=
 =?us-ascii?Q?ydtQoJMdCH+tL3Kkz5FlSa3KTLMa11cBagHf9j4kL+wekXw9Aikp6Frcti6M?=
 =?us-ascii?Q?MQk73aI3jYTYMZa1t3mEw5jg6bCyCdmWGYdeoxdQnjYKVdwDjktOztUDJmvm?=
 =?us-ascii?Q?onmIaT0cmhgTNxc7SD89XPL3BAel6z+hNYKmvAeP/qAfq0y/S85exdpGAgpY?=
 =?us-ascii?Q?vNirwbj8zY4abHamD34nhRk60QD726rqm5WNLA28m7J4Plbe6byeLKZF/K3W?=
 =?us-ascii?Q?o0ZxY+Qp5z/tDCB+unzEbHUJ+IzUHngMnkzzcZYEDwA5Qum3I9h2OJ7aBvOB?=
 =?us-ascii?Q?Qmw9MKmmmCUuLpUYZJ/RJJFS19MQvQAAKQQGP5nHNjY3HT/XlEID8larX1tX?=
 =?us-ascii?Q?nflfhUHkjOTkG1BoUIk2INtR2O4rbIIFBOojN522XSEWrZum3GpwlKSJnCAj?=
 =?us-ascii?Q?Fnuo7mEkyyHUR/D8qGjSN/owhYV188Mar3D4PuvHVpCuFxcQ5rDRfLBaMXp+?=
 =?us-ascii?Q?uw4bWDOYhN33pcdqQysIKaVTC/gTG499kDKTBo9+OeX0B6KFBORi9ovVItQ+?=
 =?us-ascii?Q?+w162e75tghbn0EG75LJrgaHzoYe0eGx62f68MCvf2+4gQ15tLXJm+VY5dFI?=
 =?us-ascii?Q?2xe+e6gk922nvhqmdUfQAiO0jFLSGasgEJ8hEXyxnDrBfiSCfbfUPr95LtBy?=
 =?us-ascii?Q?odw92faaHinjvfbFnhTzZJh5MilawkpLt9YHUVFk+UwNDFuGS+w9qoPwUqlY?=
 =?us-ascii?Q?2eLZrMVhjjai4r3kFWcq52hztkVKoaV4l0wVldsf94GY/Hu7T0P4l+54SY68?=
 =?us-ascii?Q?FSzIhbLaDtVDfmbHe6FbZISRWqgkz4rLCr94ZBD7XfygL8Y1/I1bwsF+LZQ1?=
 =?us-ascii?Q?mAo/Y+PEAjk0Z9v7sQ0OW0U54LkbrMTCXXEZqFE+/gR/kgXdYEY+H1/9u5Pk?=
 =?us-ascii?Q?2hhj9G9Q0o0lH50ndoq5mIIIKGzH+e+WKhTey9QRi7t+M+JD9P80VxFl80yN?=
 =?us-ascii?Q?9EU/oN3KpCyXkM6R36itdsbphCJxjG5l1lrm8Pk2FDSkB9ATvAJVudu12ZB2?=
 =?us-ascii?Q?pDN0m8HsOP6fzXqErl/eGjcNBU7qB6kpX5R2FWNcLczLPwW8M6oAhVj3/ZIk?=
 =?us-ascii?Q?6gvlQnfCh66jtQwfvB6sPDcVTy6s9HDE9de24xpfU9AntmjMgFXDKQ11uUaj?=
 =?us-ascii?Q?fcAdOTeWAJRW/c0bL4iB0jR6M6o3zhfykxwKdLtuNbkZtlDsfDgH8C22i08Y?=
 =?us-ascii?Q?doXjuVVecyEOPXOAV9GbvcfNa5uBhb5qoE5k6P6OZO5PWqm16yI3RSWe7Awm?=
 =?us-ascii?Q?2oA+3I7uZbSWGmPw/ffUXtCFNpEqh1flHRtohuo/j/TKdBIYWNWi4Y3xSL+O?=
 =?us-ascii?Q?5zfu9KUz6mWgZR6h0XRH3l8ckroDIkR9dm1K/YzBfPa/QUXiwEsKZ9TjT1FQ?=
 =?us-ascii?Q?sEs5rg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90d03f96-efef-47f8-6fb3-08db57b69fd6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2023 15:43:28.2040
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pqqW7uNRvnK+S6S00qIWDBHCDQ3QtMPp5Egjk7XShxQWydhwgWoVnFXrnbJ2/hPKCDdWMHVXIwqH+hs2m/JwO2uGhhnhpw/lxN6VEJJTsqc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR13MB6487
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 16, 2023 at 06:50:38PM -0700, Jakub Kicinski wrote:
> If a record is partially decrypted we'll have to CoW it, anyway,
> so go into copy mode and allocate a writable skb right away.
> 
> This will make subsequent fix simpler because we won't have to
> teach tls_strp_msg_make_copy() how to copy skbs while preserving
> decrypt status.

Reviewed-by: Simon Horman <simon.horman@corigine.com>


