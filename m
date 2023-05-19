Return-Path: <netdev+bounces-3889-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2AD217096AE
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 13:40:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AFA8B1C21253
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 11:40:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A4878C08;
	Fri, 19 May 2023 11:40:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 486C98BFA
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 11:40:03 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3A09E5F;
	Fri, 19 May 2023 04:39:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gm/XPrBXweTRLH6IKECWXh/RZ3Q7XlK/TJ3EgxqLeu8yvbDlaHh9v1ibtM2Z4XADs9sOEaEVjUlhyN5V8NLzuiXCrgbuVkAQTCzBg2lzORN7GEIvsvW2IXrTa6AwiZPoZ1zGAPVA8+b0pW3DnQRwe1ricNywEn56p6XHOte/7UEb5v69yxxUxFJhXyc27u21fV4wSSnoMrf+Z7rm6RK4ygzvjTbFszJNwzxyohaCfx28Pl2e7mTLQLBLtsiFLDzNi5amWPCsk6Bo7HKFUx4heCnZGg8Z+TCLW95lQR/ddBLC2v9T9OdG//ag1bDT4n2tjKJnzDeyjef2VPyL/owjUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qapKFUgBzUVsbPNYmeSAzFfDVRpAHBge4ZS/diC7aNg=;
 b=npJ0bxgnHkpQzCLyJ3I3wd53ExURNu4QSUdPtQTpsu2+zaFZHS0+GUfS9urH8iEeZyIE9wClNuB3wD6rXqGx017OAkmB1zot7G2c1RWD62dLyfU1tpAy2xOVWwFadTSwUcesrrWWla6BHeXVtnYJBCpZOrlcsKck43WHA6GAplZ+8rjm2xBrW0PvRL8B//3cPSuVOBK1mbD+dN+GLBDP4AxbTUDCq+E20Sa03/WMjJDR0YEkVynOOPk4pak2r/rR8MDKGbb4+fhutxr/rcUPLOXLFkla7mUwpF5f9DCedLgrY/jTNuMu2TASIbQMoNo5djGZrTz3GzDVh66BY8xAsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qapKFUgBzUVsbPNYmeSAzFfDVRpAHBge4ZS/diC7aNg=;
 b=gjdHhsqHTM/apL8Fy9ERldejSSRFkZ6Bwg70cAdbrfoM0YAug1GK7QI0oZfqlNSDmEp/9wyd0hTI1clo7ZEBcEZUxVrStFM7h2StTXtPsk0Ef+9wEpCIIRytwOd0E7iScVMOIVN5V9Z6d0AcrW15MpLr7fK5gG9MSyV8ag9cxtg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5975.namprd13.prod.outlook.com (2603:10b6:510:16e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.21; Fri, 19 May
 2023 11:39:54 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6411.021; Fri, 19 May 2023
 11:39:54 +0000
Date: Fri, 19 May 2023 13:39:47 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Min-Hua Chen <minhuadotchen@gmail.com>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Jose Abreu <joabreu@synopsys.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>, netdev@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: stmmac: compare p->des0 and p->des1 with __le32
 type values
Message-ID: <ZGdgA9jMLJOi1W1+@corigine.com>
References: <20230519112509.40973-1-minhuadotchen@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230519112509.40973-1-minhuadotchen@gmail.com>
X-ClientProxiedBy: AM4PR0302CA0001.eurprd03.prod.outlook.com
 (2603:10a6:205:2::14) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5975:EE_
X-MS-Office365-Filtering-Correlation-Id: fa93d8d1-3527-4641-9283-08db585dc3d7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	kv8H9rbbPu5NegBL0X1qa//ppS/d6licP9C3FCN4Kcr9lwqnDXB81ark4cTIpioF3O/QBtvvJrqBwBjV9T0JmyNTYtzqLdlwB8NpzTX9OHYiPyuNOzVRdryGUxlsjuOtkhP0r9OLGSliI5nezGMoYA811Wh2R0CTOiFcIDGgtjL2DiIr4tC0RUedd8GC3k9IX+e1cXiMP0fwKA20jYCKssaKQf+/pl/7KyI9GVbH+tIDuaUXZ/jzcLf03RP+4S7EdBvllehrs6WpTJ4fYvPCfuy3QR/iVM8X4ItYgtaTS0/JRTxIKkzLiLnjXA1yvvbjzetjRedajxZ30D5uklO4YZONUPAKDKDpWJg7DWBKHsbhxMFtzqBh1LFa1RAHL0NE9a9NQbffdC33v6d5pq/vGyF/WTmBuvZz5x1pLq3NZyPH+uY0Pq1nguVG5RIculBVcOjbnPcD9DIEsYToyGn0mG7qPeG2S7nRQR0wD1B6JWME3qSd5a9bhBcBG0TNCO7Nhjy2DvYrVTJBrUd+scYvtkbtURhAP0QAVfSNRGldnCWfhY8UTCHLn5DnTu5sZUruc0cKZmBCUuWsRRr00ytUYZ/5dR5Ii/z5YbK/xrMZeCQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(346002)(376002)(396003)(39840400004)(136003)(451199021)(38100700002)(36756003)(86362001)(316002)(2616005)(54906003)(66946007)(6916009)(4326008)(66476007)(66556008)(83380400001)(8936002)(8676002)(5660300002)(44832011)(7416002)(6506007)(6666004)(6512007)(6486002)(186003)(478600001)(2906002)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?I8FKtEC3V3LJUn7wGE1//yN+w41vx9rzHhWatoMlyjMGCkSl9W7pSLS5Seu7?=
 =?us-ascii?Q?AXqPJbwIcRnwhuWGpqZ/fWavW99BXC/udVZ3sLbZUH94D1NNR9qKeUcXkKZa?=
 =?us-ascii?Q?nTsWDPuTSgJ1/jp9GuyP/jsz1fjFS7D1B1RRUvCxFXn32By5BSJToaqnf41I?=
 =?us-ascii?Q?OI/MLpyt5dAAa2l5b+YCTVsaT1cuVXZmz3pZz4IeKW69GI0EDj8zLIlie8un?=
 =?us-ascii?Q?L/GY93BBii0uq7a68SQ8LmPGSnMno2gSDoDH7/P3TEMf1S9CcEg0Ow5417Ir?=
 =?us-ascii?Q?sank/8OZKgkh7gXnRaZ18GalmOv0+7CJZMcVyrqVRyMA9EBvbtH1jpSBE2Hi?=
 =?us-ascii?Q?B/Yjc9qXEPHa6ThY/BjyZBaB0tB43KeJ3JYqCK7IpsoahDV98QH/TCMqr/tY?=
 =?us-ascii?Q?HdEX3QRB5uLwMmiXTJ7lpFEqwHrfHtTDy1obHgBfW+fQVo9tsiqR4jx0Q1Tc?=
 =?us-ascii?Q?yxVJ1Zy3OyIePG/vZBwtdQk0quXz9wHhjCTHX5jPBUo6Va5z58/9uiIMpHoG?=
 =?us-ascii?Q?ADMA6mTaVLdssFcXRCv3VTEeair8ltd271VOBx0gCCXL4FiIh6WEqLVsI0YL?=
 =?us-ascii?Q?qjbW7b2aWo3fspUhDzMh8Z/qJFq3UVrh79NZEn4h5bVRVSeU4RF8nRPVqoVe?=
 =?us-ascii?Q?wykaw/iG7unO+IqCr9zQRMa4LwLVTgQG0l3VRZGUu//kGMXNRVX+gYCfkICI?=
 =?us-ascii?Q?45oyBbnMmptvYHFHq7sSnaixO96nNqo8AyV8onHQbqGfhJMWWTBgOjAwChyR?=
 =?us-ascii?Q?8jeFi72UL5t2HcSlnIh+itaP72V/UPbpNcaI35cxRToDo60uRK2CDEZO3SpJ?=
 =?us-ascii?Q?RSoNobO1iV/G7sYi+/qjxbCbUQRH70rEJ/YKF5p5RCLokmyxu9mg2/zJf4Kc?=
 =?us-ascii?Q?zi75NxfIqqS1RgvUQCeZIGYmFqyF9hPfXv4ZQdg7kQ6p50ANdcKVTJo+JMhN?=
 =?us-ascii?Q?52gwcsIxwjVThW+PQ0HFIAoYdZQDJxfHq8A3vG9OxGD3rKqxhxQjafdNk+6J?=
 =?us-ascii?Q?LJQYzsT6hwUVKzvHpueAHrUOWlzl04gnpteNSajUB41uif55D8O0MFC35zeI?=
 =?us-ascii?Q?xcfF3BhbDrSXlIglE1HFNYpiBhVxH6DfJT92DjkTq5QGcRRisPhz9KrcABtD?=
 =?us-ascii?Q?6N8JtSdGzfAxFJEf4pd8ehdrZ9KJy7LBPA6l6YeDLVCDb0nip0hEEf95usq7?=
 =?us-ascii?Q?J5s4+ZyJGLproM5Sys/jFMkO0oX/ODIEGQ4ofQC/uoEqyvYDCaPg6Ce29RWn?=
 =?us-ascii?Q?fH2w9jzQDsLlRKtvsTTCI7g1Jco0H4VI9XJqFKVvxGtic7OQPR1IE4PyQzLw?=
 =?us-ascii?Q?YeEWDGtd5bW+BSEAwctH7Xa6/j9qEURrExaqX70CVgN8K8Ak41fu8M2cRCcD?=
 =?us-ascii?Q?3MfxW3Lt1h0nFL1VMwaYqWW7mbsR5kxxNKUyHiV54xi+s+rhaVgjkUCoEjGz?=
 =?us-ascii?Q?KzuRT8/MIxjTJjzoncQ2eVZrrOu55vUk8BtLzxWEBIUDoHyY6HJpbyqhfx9n?=
 =?us-ascii?Q?czrat24S7Qz+wm2/wEPF7fFLKhk0Z7FtAvCuc7NF5dEC9/glgy9S4vanUH5b?=
 =?us-ascii?Q?3bIvqGtFHhB6JOgM5Z2QxblP7a7SauAMMgEyFh0gNpG8VSd+p+WJEk++1UcP?=
 =?us-ascii?Q?jrM1/83I6hFtucfzuX1e7dd9WvLj65DXsn4a+JfHTEtwDXoA0wAdCshAbKc4?=
 =?us-ascii?Q?keeSeg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa93d8d1-3527-4641-9283-08db585dc3d7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2023 11:39:54.4842
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O7VakYQDjbnn4irfpEyGRMxVqaeCpzwYMQGTgjkKqQeNQjzmbO8wIHSqVN5RyLkGKV2YZfiF2sf9C+7/BSmiOKIphTQl89vJJ2bnh6oRtPI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5975
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 19, 2023 at 07:25:08PM +0800, Min-Hua Chen wrote:
> Use cpu_to_le32 to convert the constants to __le32 type
> before comparing them with p->des0 and p->des1 (they are __le32 type)
> and to fix following sparse warnings:
> 
> drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c:110:23: sparse: warning: restricted __le32 degrades to integer
> drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c:110:50: sparse: warning: restricted __le32 degrades to integer
> 
> Signed-off-by: Min-Hua Chen <minhuadotchen@gmail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

> ---
>  drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c
> index 13c347ee8be9..eefbeea04964 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c
> @@ -107,7 +107,8 @@ static int dwxgmac2_rx_check_timestamp(void *desc)
>  	ts_valid = !(rdes3 & XGMAC_RDES3_TSD) && (rdes3 & XGMAC_RDES3_TSA);
>  
>  	if (likely(desc_valid && ts_valid)) {
> -		if ((p->des0 == 0xffffffff) && (p->des1 == 0xffffffff))
> +		if ((p->des0 == cpu_to_le32(0xffffffff)) &&
> +		    (p->des1 == cpu_to_le32(0xffffffff)))

nit: Sorry for not noticing this in v1.
     There are unnecessary parentheses (both before and after this change).

