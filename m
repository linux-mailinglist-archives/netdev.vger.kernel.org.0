Return-Path: <netdev+bounces-11069-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D54D37316BF
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 13:35:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C4D971C20EB7
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 11:35:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45153125C1;
	Thu, 15 Jun 2023 11:35:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 367F811CB2
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 11:35:07 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2132.outbound.protection.outlook.com [40.107.223.132])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18EE4ED
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 04:35:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DB/8Dct16ih75R1M5C7QwFw9tOlKIyVewP1Mlz+92seMUVe35jYuLoAe0OU8Umj01wa5KUenmTN6zkEqup7JeGDvcMt4HdxixZV3tL2ZWCVXH0/bOv/oYUBDVVBSl+0w6V3qxSr7k7Z4euNEdka+ykOspzNXzgpV4TcQHZNDWo6qpWZLQ2Xtp0lKiiisx3Q1B9LEIa22fseyoH9BUxvD7HyfQ8paaqJYCJ4b/VBoN85dPclYBqAp/TYFq2WfX5XHWS4XPr3lo8L3qb/spOG4RDYhiCY2DmypHM/7bp7aESslW6u79lesA1NVFanWPE+JsRLgPnwNj1oO3lrqb+VlXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M4ki0zwxKZzyMiE+nHRYEHFfQU/qBt/ZZBW7tqW8tWQ=;
 b=QnB7e9r+40XvDWAHBzI8WZFLi4GcHLlq7+MLSkn6JTPF8Hm540EID1yRu8jISnnA86PR1S1RQ74dG1EqOxT5xZ8qlN1/i9ScxNR4j8eb5Rp980iOl5rckWHi91Jvy1HdGqBNHSTQ6bOEyolVljTrFv4ZvbHYgy1T5zTxki9fjQ6pu7YjVYX8AGPZbuSxLnKUQmiFJDpmYNgyPUYSKYEuJmvcm1l9rfMZQBoIaMKhxDIE2UZeHMGdIDooHUySeBm1yaZoJADKlWvwWY0bQFc9Mm8mRT8BXMfah4MEzztVJKWdtxG5r69/lMTYOih7yE9s++k0mdcTkunOBlyvi5kLJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M4ki0zwxKZzyMiE+nHRYEHFfQU/qBt/ZZBW7tqW8tWQ=;
 b=DWjwkfyCn0Z2AAshW0t/lxfZt+mGcSmR+8Lo6i9LwXp0/LQG2LNciya5DksC4q7WzLQdvEM/YGd3ckSBwn9qWtZT/JubJn8MY9LI/rN3leKCNrDP16stPVfqeBuEwFFjulvb3x+6WfIaM8haSr2zxwlx+w+88/gLJ2P7jfisbmM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB6267.namprd13.prod.outlook.com (2603:10b6:510:24e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.39; Thu, 15 Jun
 2023 11:35:04 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%5]) with mapi id 15.20.6500.025; Thu, 15 Jun 2023
 11:35:04 +0000
Date: Thu, 15 Jun 2023 13:34:57 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Piotr Gardocki <piotrx.gardocki@intel.com>
Cc: netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
	przemyslaw.kitszel@intel.com, michal.swiatkowski@linux.intel.com,
	pmenzel@molgen.mpg.de, kuba@kernel.org,
	maciej.fijalkowski@intel.com, anthony.l.nguyen@intel.com,
	aleksander.lobakin@intel.com
Subject: Re: [PATCH net-next v3 3/3] ice: remove unnecessary check for old
 MAC == new MAC
Message-ID: <ZIr3YT5cRgpx8+zV@corigine.com>
References: <20230614145302.902301-1-piotrx.gardocki@intel.com>
 <20230614145302.902301-4-piotrx.gardocki@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230614145302.902301-4-piotrx.gardocki@intel.com>
X-ClientProxiedBy: AS4P189CA0031.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:5dd::11) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH7PR13MB6267:EE_
X-MS-Office365-Filtering-Correlation-Id: 134425a2-cd9e-4ba7-3ca8-08db6d949022
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	jDR3IgNIXdGr8v2OVnmw3RHg4eDDcAB/DRMvegp6X3DCx4DfFYdPRB+Qr0EvOpZDBGFU2y4PSbdcP2NEEto5PZaKkTKhiLc+60zeFUlUjAjAXNItWugk9BjQtNGhLmeivZPlDyiIpoEGeTMxzPy1vm9MoExCaGckWF1lEfw9gB+e2Ag67xEUSxtGUBUN1kzQ3HaVxKOE/RdxSB/r0bgJxu2vVRozMq6OJTaAi7jA0TyZhhN7APgnPW8l0LWEOH4W+qyJvydqtnDDYLwYmol6caM8tovBKZ3XoLKG+pDhWebh4skiX9ueP+Tw/vJhFzShj69q7CQkFPOEX65VOlzjXOx6LFrgOTkdhje4lHXKmXBJoCnuFBdxUSAzfQoH3XnP9hvEbw7eqjJ8dMpO6B3XBc3IMvx1MXnTj+8Y0Lqmr0Bg9Zp9vjIKO+ADovhjj5bnFxO7kHm7MKqW0a7YH7IyUqVOsM8ijXtlXE1+7SzXu4Eo7JkO/SZ7ryyLw8Wib12s+dmWpIDTBZ0fCQXgX+vrJXYKeYxGE/mxx/kLJUH+x1HY/QV3nuKFCfOf11lKp+6vSJQPhMP3xq0B3Cxee+76PW3zLdlbFKfDkVw9Y4FBfDBXuBEJL/nYAlP1LpdbGlipNB7tceosuWbIq9vS2FJBTh3thik1613YVOQnLN9agqA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(346002)(136003)(396003)(366004)(376002)(451199021)(66476007)(478600001)(66556008)(6916009)(316002)(66946007)(4326008)(2616005)(86362001)(6666004)(36756003)(6512007)(186003)(6506007)(6486002)(5660300002)(44832011)(7416002)(8676002)(8936002)(4744005)(41300700001)(2906002)(38100700002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wbZQR4VGL6pz0FxgaAWDQKiVmSRzNGveiIEX6QHOjg7Y0IIT1wmsfasGBmtT?=
 =?us-ascii?Q?JN3BlkT8sk7sTUga/U0qg5tUeyw99ww2PMXwY1Cd87UPnfG0hqJYIbTSCrtR?=
 =?us-ascii?Q?MJyNcf/zeNTdV7ArZGpWkK3SPrwqn6Rn+vikDgljbMkyZcRiegCVsJo0qO1/?=
 =?us-ascii?Q?cmEV41Vw06NQkF4tWoxXyVOUvnlkyG4zdG/OAiM26/Zk4rpuy3K4P2Pbt7u3?=
 =?us-ascii?Q?1vMBk6ZcQ43MH9ZYkhjmw3BWymNm81Rmg8Th0P1WpIF1m21oc804HjBWvSKe?=
 =?us-ascii?Q?Rv0IvmJpzN+Rw6hDiQcXwYBWBlkNrdBQrQI3eCkpcBMlqqauJoDoVoM1JkMB?=
 =?us-ascii?Q?ERfVojLmEtIdMvFJ1fD/+P4O4m/NBxs3XJM/B5Zl5tds/CSbz3+R++LhGcYg?=
 =?us-ascii?Q?Lhsel02rUM+TOcFcDni++N3sY5Jkyr1FvmQdCnPp+9+jHuzd01crzruzbIHF?=
 =?us-ascii?Q?BNLgE9yrdGGw1m7XsNwgWaGsqVqbdgGsYn7sIfQzbYAQ9RCfrXcXiRPe8hzm?=
 =?us-ascii?Q?b1TNTJrve9NJdjs3GSQ0CpD0iQmDVgJletVxp/A8FhOMhSA2JmJg/ZiCFgBL?=
 =?us-ascii?Q?xZFvZDEa3LXn6EFtpi6oPzYxOATe2Xz0GqyAkoxaeiLMJVdTHXeHj0qBtmDj?=
 =?us-ascii?Q?+UioNRdHQLTRKWtUtTmz3ZIH7ABa4ImO0zrCyPyne2BrYOYJNphFK+H0YhV1?=
 =?us-ascii?Q?hZYXydazsFn7B93EcI3WhoStDWG8/NyHHJKko5zj6u8suBrym/mxjlR4oDXu?=
 =?us-ascii?Q?BEtrRzXGKbQdsQS38gB1oCDe31MKJxo97dCLbWkF3kmGqYU+DjoF5VNsxCG0?=
 =?us-ascii?Q?JpbwNzArRx7wlgCDhgz7vW4GDIRdHTP5pYtxQskDvWaD1ujjW5wPKaXMFP3Y?=
 =?us-ascii?Q?HpAyf7H1jobhAjjL5mX+rkm/Gvg6pJVBQgSj/XBUA26OwN81fPYSv4aUUzKK?=
 =?us-ascii?Q?3Eeeocqu6Ryfu+4thX7bH1gt6NUYtz4p8Xar8585ijMBDZlGCqZwgrVP4s+C?=
 =?us-ascii?Q?vMGabc5ozoY6e044LuyrnzP7Iyf/wpzc2dBRJnByO91sAqh7mZWWYiAtQt62?=
 =?us-ascii?Q?a7VffWn79NgVjF5yR8txYX7l9bLVcLVi9EREchlAlJJY2JxY6iS7QlKRIpJh?=
 =?us-ascii?Q?z49jmR5j0gYMohQAe0OF1X3QSHXgEH7DLrF7ahrN/aT8CXbXGFbM/WaSzH8R?=
 =?us-ascii?Q?1enu5kAf7O/XxwEC+RH5+GeuM4fs+nHSbd8UTN27XKPEjjmrE5Xhpxl/Hmx8?=
 =?us-ascii?Q?KZV8+eAbGZz7YXpg3RNAAxLwhdOTImVznEC1FL/CePWakpo2rlRuOq1eEjlw?=
 =?us-ascii?Q?6doehGcfvJlx+javDfuQnTEL75FKh2UPUhP4DNj/zibvTMzAKiOUP8iVsNst?=
 =?us-ascii?Q?aJmRxIvtIEl1+tfJWzyRwNlZNX/9eiPQr9S9he9+f6DwvVBCk0oMfc7HN6pA?=
 =?us-ascii?Q?JkCEzZ/SWR2PqSRWgHyuSHLuHL3OLmIWOfEDGoGRdm31/DZEHOqIX/BgRRrB?=
 =?us-ascii?Q?lZXIcllwY/hi0YJ3bry5N4NgYF143qfRzptTgZ9vw896hvM30mReBQ9kounB?=
 =?us-ascii?Q?LmlxnQLv403yWlT0Pv790NrG7F9ioK0aeX+NpgpMkyFAO6R/XMs89m8ryDek?=
 =?us-ascii?Q?8mMEvN+Tf2Dr3uTujN+bKD/CEGxnxYAaEDgL8nXqdOzRHctxL4+yL6oqPv0Q?=
 =?us-ascii?Q?YPC+6g=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 134425a2-cd9e-4ba7-3ca8-08db6d949022
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2023 11:35:04.4973
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hCS4JxuBAdHS8XKXZzN6ws5AHuimdx/oW8BQYy5n3M6SwRkMxUAgxmtl67sc9ed4ZcvHxIniLT2U51Vlw2UTZzbaL379xD8n3GybSqfItz0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB6267
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 14, 2023 at 04:53:02PM +0200, Piotr Gardocki wrote:
> The check has been moved to core. The ndo_set_mac_address callback
> is not being called with new MAC address equal to the old one anymore.
> 
> Signed-off-by: Piotr Gardocki <piotrx.gardocki@intel.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


