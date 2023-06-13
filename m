Return-Path: <netdev+bounces-10292-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 370FB72D9B1
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 08:10:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ED0781C20C0B
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 06:10:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4C6F361;
	Tue, 13 Jun 2023 06:10:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B28E9210C
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 06:10:12 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2109.outbound.protection.outlook.com [40.107.237.109])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E86D18C
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 23:10:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C0QByzz54D5+CaYf5I4tkVnbTNOlewSI6Ylj67lrwaKNqIwVTMrdIP84GM/XZgkSRl8WoNkTuf1+pIMHW+o5RLB7KiQ0wBc1A7lNtXp9UE5Dq59A/1bHRCk5NCcjt25z8Q5jyPWtfDdBs2hJ+e3ejp8siIc7A2wxaw2cvn3aSgqhkLAQx01W+eORr3U6b2PzDliX28oYjMeqrlGZp+59S7Ze9jPR3r/IvMv7OobY5TVd4wpchGX+g6hD5Mu0wW8FaOxpJNZB7XihBG3UJmH/vtVt0Hx0OtCXM0ZyTQp199k+6M0OfXEza2Jhik99bKsTXmS++6HSIQ16fLL/p1VpGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qt2XzfP1o4qtGh7PEnNnlQP6GFbcAMd8H1fh53Tq0nc=;
 b=QPW/0RZWiky8D6OHaelarZ7lVigm3r8jxmuccY+ZBfJoS9KCLzOZv0nVuZftxG828IafYOq7iXRBHl8X+6osnvi9ouL4GdSni29hUMa45re4aiyl1d5kmCg7MLbT9WfcaGxIpxZ+TXpebCo9Qn0kp1daE+d6lmCabWm+ieEeOkDFwO+HQlz09h0kaEraiEjy+Q+4k1OmDG44nC59adnE1q8hw5mJWMR0VWFghTaTSwzDe2LtWbKaa/qGF0cHoDqaR+QVGpmLMtYVRZldMhSJXwImj40pZxgoWQu1l4bE/IRLfQvgBGKG1Gl58xGbyjlbka8chM9h+SWEEGvu/pFVkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qt2XzfP1o4qtGh7PEnNnlQP6GFbcAMd8H1fh53Tq0nc=;
 b=B82bkvB0F/yo53rQ8V+aODXET2WLc5VCMZYbMumueU/RoQMjBeXh1dLbljLGPRXg9tHDrHCJEbSRihUpbb1OVZh2W2xoQw7Myn+4hwpvPPCV1rl0VX8HLFMRjWC7eT8GN8rA5zZpNKMXdTMQMra82DxB0GLqHfkxBXhUW4Xkolw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH0PR13MB4763.namprd13.prod.outlook.com (2603:10b6:610:c8::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Tue, 13 Jun
 2023 06:10:07 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6477.028; Tue, 13 Jun 2023
 06:10:06 +0000
Date: Tue, 13 Jun 2023 08:09:59 +0200
From: Simon Horman <simon.horman@corigine.com>
To: edward.cree@amd.com
Cc: linux-net-drivers@amd.com, davem@davemloft.net, kuba@kernel.org,
	pabeni@redhat.com, edumazet@google.com,
	Edward Cree <ecree.xilinx@gmail.com>, netdev@vger.kernel.org,
	habetsm.xilinx@gmail.com, oe-kbuild-all@lists.linux.dev,
	kernel test robot <lkp@intel.com>
Subject: Re: [PATCH net-next] sfc: do not try to call tc functions when
 CONFIG_SFC_SRIOV=n
Message-ID: <ZIgIN7VqkGytCiKx@corigine.com>
References: <20230612205428.1780-1-edward.cree@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230612205428.1780-1-edward.cree@amd.com>
X-ClientProxiedBy: AM0PR07CA0021.eurprd07.prod.outlook.com
 (2603:10a6:208:ac::34) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH0PR13MB4763:EE_
X-MS-Office365-Filtering-Correlation-Id: a6924184-7c08-4124-9da0-08db6bd4d5b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	/thDfo/ywBLeW2ITUNo1Sn/8Xl7V6eYMRrz54o9bX6UcbD7dOWVgfih5if4m9RNWHddqQ9yFTv8+H61wJfj9HJeChMI58yqh8Wz+IMsBopuugRHjjDuzk8Sac5Ab6cVt0x/b8P2hK9Av3P7ggpiupkj2IwaASmr9pRbDlw8V457rINGJkY9k8ywI8fRiqh3frKP7IwCoUANDOJu+1HvIV4nDTM2lTmE0MlX3SkqjvlpEAyMS6dg8MhLhhJVARXGwnQTH6vgs2gMkHJvp6eeyscbM6TxW54UG8hD1yngJUMXU4CVcG50N1CTVkp3HRrfKoZB+ZViPCRMD/ch/iuYxLJsuQEGm18w2RXXcg6AlUkQDPNkKICh+gtPzkb+usfwdYn5kv9tsFCCgsEf6wriVdU7OT6UfBf9MkIOMyXzpAD/nGh3raINfUlHC84fXF4wLBUNdJif4SiJ28tNn8C2qCnCYRYfXQ9eXmnT/NUptUQn+s03z+fgeRKC2VK4Fu19JeLLJPThti0PiTPwWsN8+Wyzl+jc3JeXSeVIJEyeDd0M=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(39840400004)(396003)(136003)(366004)(451199021)(5660300002)(54906003)(2906002)(66946007)(66556008)(4326008)(6916009)(8936002)(316002)(8676002)(41300700001)(44832011)(7416002)(186003)(66476007)(478600001)(6666004)(966005)(6486002)(6512007)(83380400001)(36756003)(6506007)(2616005)(86362001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xbfS4Fj2YQVkTthE54AvyEcZMuaMICxw54xmq4Jo/d2WfH38lcchUnSYCY5t?=
 =?us-ascii?Q?ZBzyIX+llses9R4EEku57rQ1aFZbuSNudxYsQpDEmiFefyameoN+7bHWKqpx?=
 =?us-ascii?Q?v93X6oF3JiFhhrP0dIJYldB4ub6afxiRSFZ/Xes8nVDgnLt8CwFNs0Uti+VE?=
 =?us-ascii?Q?wegeLY1Tp5UULIfeaynABR/WqbH5/wSAtWFBNnMKyeMCE1HJEIHGcS/BMdzm?=
 =?us-ascii?Q?y0SZOOHN76xJp2jdP25TWNh7ljo66XJOqdy6qdeQKUtb9XN3RcTd6sbru8+a?=
 =?us-ascii?Q?KZYR/QyML1bPvk3KTz98cR2LQ1RgJjkTil+jjHZhYm+wTOMpmU5ZPY3oGAzu?=
 =?us-ascii?Q?yClLZKS9CcI6Ja8WbKNvd7H1wmrX0zb+w8uKwJljJi0QoplAbPNwoKO6tL5M?=
 =?us-ascii?Q?T4gnUlwCVJvp/J8Asl2cp5cuhpxvMGWl4QwRg13Z0y6/njnR1L4OreEl46lg?=
 =?us-ascii?Q?/QfM2oXx+Mb6yFxYWqmaRW51QlrNZfFOzlEfOanvqLedvTzur4pbyJQQrqrN?=
 =?us-ascii?Q?5j0ezbQR+6fE9xvIsrlHqUi05FPfWIwIG/B4q9D7CTuUzn9gEaCXD6b6IWMQ?=
 =?us-ascii?Q?xYi90wBFXeNcCUZg6K4aqXpiKeuXbMlJeHU+S8JWAsZYlG9elJ9rGjhQyM58?=
 =?us-ascii?Q?1iHAYps6jRS/rBfqlKz3zuiTsKmAkgy5qZgmEPgzEhw86UpdYci/8JeHtArp?=
 =?us-ascii?Q?3QPusdBt9ARkQYKIC5sPyyiiRlhoyUODzF4y5/RpBAZNHtS4lpbo2MwFpb8D?=
 =?us-ascii?Q?H9gtcJjhfBkPbghIiUv3BsRfg6sw25lfhCV02fH3rfEtj/h/dFJ9mnNysV4V?=
 =?us-ascii?Q?+nis+y7yBGDxITK2DIwCef4M8vy/t90WIOJgMKHNyKFHA4fsUTkA4NjkXK+y?=
 =?us-ascii?Q?KhhreXTXAX5piYjkD3uOAEQmrwAn7cxXYHBf725DyqmwBQ8B1l7vj/8J9UjI?=
 =?us-ascii?Q?ju3MqCCrIr7kEbBwspY/tESapVkk2jyQhyZ3+qMCvLf4EOdnGRb+4zSxBNBe?=
 =?us-ascii?Q?/aRIojwxx1PTUg3loTd56fimuzRGFzJfwXLl24EI8qrtMhdWtJFxO+WhxY1/?=
 =?us-ascii?Q?JlwxQ8b3UgY+sf/XUulAK2pGs7LPBGxLGc9iDo5weeUbUn4iRksSw2f2D20U?=
 =?us-ascii?Q?RSiMELATH6UMIJ59eAgSE3O2A5n/i0Fl2lvXe3tQguEPvRinsz6D3ZRUAm60?=
 =?us-ascii?Q?kxzsNQL+xfNaj/RZwirEn++Kbfskab1MQHpWGsDjav+gzokcOjLUSuOoOrhZ?=
 =?us-ascii?Q?+MhFEqkIjNRTGbFyILSy1PMafq8ZnABiBJwlMi6mkaVHS+pcJ4uf8BK/yGxU?=
 =?us-ascii?Q?WMic7GWRVwNid0I3o3Rq5y/I5Sgy5iOyoTlA83b+GErUdVC4rcKQ4mvOgt9c?=
 =?us-ascii?Q?G7Y1Fhh95RPBpgZeY+fy7Cdv4TyB8gh4ROxeRjc4zdwPgZmPS8P96A45nDaR?=
 =?us-ascii?Q?uPwZt9ks+pqwxX3wKT6ofaRqyJ3jfJ3clzPbEnoRHvDZoMTYJf9U6A35u2x6?=
 =?us-ascii?Q?cOM9W3kqVBDVmwFh5OdwOzr8jh0QPx+9YA4VEiw1I2xExHz0BnbIOpqAaYeJ?=
 =?us-ascii?Q?vNI4tvy5iwRwFfitxY23k/4xuxA74eDOGCy+s7e7s2TuaD7lJk7rPrVtH7Si?=
 =?us-ascii?Q?R0UeDCIyhTzSMvzuc4Oeg4dNSST+mdZ00EMvEGRIrhR1BWDEeJDEXe4CT6ev?=
 =?us-ascii?Q?gx8vEQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6924184-7c08-4124-9da0-08db6bd4d5b4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2023 06:10:06.7420
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bn7U33tdCl1v8dgu8MaW1+P/WXkcKOv8sHuFBwneoHS1PXsiy1J3rwOKAuVaL90JG7yOfsrlcApGaFlIkUVurz8ki6IffYpSwAlZ+7L43Fk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR13MB4763
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 12, 2023 at 09:54:28PM +0100, edward.cree@amd.com wrote:
> From: Edward Cree <ecree.xilinx@gmail.com>
> 
> Functions efx_tc_netdev_event and efx_tc_netevent_event do not exist
>  in that case as object files tc_bindings.o and tc_encap_actions.o
>  are not built, so the calls to them from ef100_netdev_event and
>  ef100_netevent_event cause link errors.
> Guard the relevant part of ef100_netdev_event with #ifdef, as well as
>  the entire function ef100_netevent_event and the code that registers
>  and unregisters the netevent notifier.
> Also guard the includes of tc_bindings.h and tc_encap_actions.h into
>  ef100_netdev.c, as the symbols from these headers are only available
>  when the corresponding object files are built.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202306102026.ISK5JfUQ-lkp@intel.com/
> Fixes: 7e5e7d800011 ("sfc: neighbour lookup for TC encap action offload")
> Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


