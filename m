Return-Path: <netdev+bounces-4333-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3309270C1E1
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 17:03:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 696AB281003
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 15:03:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1EB914296;
	Mon, 22 May 2023 15:03:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E9831428D
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 15:03:46 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2138.outbound.protection.outlook.com [40.107.223.138])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E56D010C4;
	Mon, 22 May 2023 08:03:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b6Mm6XNtFzk3RDsvwCqtnGggRC6RD/DikHxDnIhZILudQM8ZSAvmEJ3i5viSsCB9Jw/HRr/ht0j/F1DvJ/XtQGZaCbfxiKv3I0sx3u48gAQpIkLCqVRwQzhoUk4PrddtxdieNNv8wKjOlBrrQyRpqM6jUJ8c3dK9P9FV8KCoGe23KN9TWFkVRasdYYW14Chbiki1L4IQAY/iMSpnVw/eaL2cek3oy4vlhI5sq7quILCW3fz1tVvL8KmqXjkHfsXxifRhGGleusJ1hfDTPaBRV7dR841VOr/V68pSeYd0R2Nys7O9C/pA6Ofxuz/w5IpTsec9W/AmF7YXrLf79Zs1IA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YajzehwOiE+wMqUz72Bfse021I1j/buSrH3pmE7g6r8=;
 b=RMO1iW/PQspwEojzoXJwQIOvcqYS/Agq2+UTZRzhT9fCgafTj380IkwRnPwwKlrCmLh1IGuNCN1xPNhb/2kb89vyMFN45F53/O0PXInKlj+yEmwnB1d83kSWBY73A4yzgPbp+84zG7mxhp/YjgvrtrmWR0ITYYKkkq9k+7MB1Ra49QdSKHz9hlu8OdVo5pTJbzLsLDfGaA6llBYxTdWmGHXJ+jSdUwkNJgg4Tbr4M0jOKqC+axNGCXMJF7yw2cyEhydgNjPaL2qOkyHdrj1AqB2CrGnmT6DJNlFNoGFCf1Agw7Y3ScU+8JEN7l48+PgNZZ/pOtuqvFg7MlAQPgbh5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YajzehwOiE+wMqUz72Bfse021I1j/buSrH3pmE7g6r8=;
 b=N/sOtF8VM5c+iV1keIysn7q36XcvycKzaLQiX4KDMC0hzFAHnXk4892CfuCmGRYrHsCFoB1/n9HlIuy9wsYg4hCs2KbsTY5878gkG7sW2IBX2jvqtilP4mhTtO6ZLwHJtFKGFLwH1OTO9UnxDfWCwLv9rbLoiwMjU7sI4Y4zPwU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB3705.namprd13.prod.outlook.com (2603:10b6:5:24c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Mon, 22 May
 2023 15:02:31 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6411.028; Mon, 22 May 2023
 15:02:30 +0000
Date: Mon, 22 May 2023 17:02:21 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Parthiban Veerasooran <Parthiban.Veerasooran@microchip.com>
Cc: andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, ramon.nordin.rodriguez@ferroamp.se,
	horatiu.vultur@microchip.com, Woojung.Huh@microchip.com,
	Nicolas.Ferre@microchip.com, Thorsten.Kummermehr@microchip.com
Subject: Re: [PATCH net-next v2 6/6] net: phy: microchip_t1s: add support for
 Microchip LAN865x Rev.B0 PHYs
Message-ID: <ZGuD/dqpQl/2wpRY@corigine.com>
References: <20230522113331.36872-1-Parthiban.Veerasooran@microchip.com>
 <20230522113331.36872-7-Parthiban.Veerasooran@microchip.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230522113331.36872-7-Parthiban.Veerasooran@microchip.com>
X-ClientProxiedBy: AS4PR09CA0001.eurprd09.prod.outlook.com
 (2603:10a6:20b:5e0::7) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB3705:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ec88e6e-e8d7-461c-af74-08db5ad590b6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	mZPegTl9Vl1BmnCB+D6K5aVYi0UAJsL3JS2P/G0sLzVvcH768dzduLc14JYk1D+SIWRPH9pgDLvv3pgljmzu1pL7K1cooTqo6kbXiPvFH5U31hJxEzwqmeI01j0NoR44hBIcGpFVyChtNEYQjDMyOj43LfaSRe+IXq/0OhORkToX/VghUEZ77FTx/UgwopJAhFFHVPRnPcNwxXNR9uRCCeQJbOvR+G/6/uMvpHZL4MkoA25P+tn+MZ7VYDjFF3wEc32Bl2wFW2yEr55A+xyJdUIo2CA0XB8S5Wjl5DaBCA1W3zK+FwrXygS2wGiiL43KvvOZQjB1Sr3erA1cFGEajawkQ1drcjPYxHipchk4jHxOIiv8HVq/cm9v4fdQrjsJ2NLorVKhzlYzbtOZRpe+C/aDRagW0uyaBEDEiW9BB/2WylXTs+6LFhI9ML84Q4LuPiCbvCyMwAlCAr/8gbf7dTp6QryXGNoAvQXOaJywkKKpR1EwNjnFfP/aYlRK60OhtYhAtWVi8LWQUVna8KZi8eDMMP806cFM29vkDUfW9eivxkyOhqtyTRgbF6ccE6iUeywwj9uMu5X/h9v9qhYmXYtNmEFA9hfuLGarR57z4uE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(136003)(346002)(366004)(396003)(376002)(451199021)(8676002)(8936002)(5660300002)(7416002)(44832011)(186003)(6512007)(6506007)(83380400001)(86362001)(2616005)(38100700002)(41300700001)(6666004)(6486002)(66476007)(66556008)(66946007)(316002)(6916009)(36756003)(4326008)(478600001)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Z1RZQW5WNGQxTTBQRnVrZUUwSytIdUVjb2NrVHJvVVhjOHhTMlAzZjlLRVpy?=
 =?utf-8?B?N3dJaC9JZWFWdmtRc25kalBJSGdDcGpsZTRiNUF6NkFoQzYrZ0VDUjMxWjIv?=
 =?utf-8?B?WFE3bVpQSXd2RDdSMDdHVmdhVlF0SkZjVHUyMEp1NXRiL1lQMnhLejJ3M01R?=
 =?utf-8?B?eVpzQXRBRysxODB3QXdQdDMxVHRveHIzOUd3ZmluU3R4UnVGYklxa25WOHVP?=
 =?utf-8?B?UkVZd3J5cWI2RjFmUldENTFNbGsxcmg1VVNrd0RCYk14RE51TWYzbEJUV3Bo?=
 =?utf-8?B?Yy81cXpDYU0ya210VUpXaHVFTnJNVWtQeTFaSUxpT2dLNExHclZ2Y0NkNHJi?=
 =?utf-8?B?dzVOL2R3QXZ1amJ5dmlEYjJKWGYwSU0ydHE3cVFyU0hPTDd1VjlNWER1R3pQ?=
 =?utf-8?B?YWRPU0tBYXFUengyWlhwdEpJazQzVllSVDdhdVhxOHN0WjZCS1lmRXRFL2tK?=
 =?utf-8?B?cmllTUo5azJxQzArUk56S3NaejZWYkNPc2NkbHdLTnNTZTlPeExRM2UyNjBE?=
 =?utf-8?B?Nk55c2VTbVRDeEhFVG82TG9wb0w4QTJIQmRaR0ZwWjdNaUI3a0U3dmRKa241?=
 =?utf-8?B?VWpuNytyWHJCbTc4L0swSlJpQStMZ0xBRk9ya0JNMGNIQi9pZ0swdDM0ZzJN?=
 =?utf-8?B?RTFrNk53ZVpGQjN3Q0x6WVYyTjFkdUZqZ2t0bDNuckFaZEdOTWx0YmtCT3h5?=
 =?utf-8?B?T1lrV3RBOFFISVdSZmQ4T04vemh5d3lmMDM2REJFVG1nWmtHRUVVVFU3SWQ4?=
 =?utf-8?B?TytvNERWbmNaUWFiaTJsSDdYUHlyTnZxV1dkY0ZnTUxMR2tuRlhRa1NqOExQ?=
 =?utf-8?B?eUY5d2RpRVpBdmE5MVp6OXVpeEMvbWtTTCtwZjE2TnNreW81TUp3bFpQcWdR?=
 =?utf-8?B?VkF5SHRrTzVmYVFIUXJjSzlxbmhOcmhiVE1aZkFIdFVHZUljeC9Iend2Y3pw?=
 =?utf-8?B?NHVpdjYzNjJRQll3YWFvc1FtMjVITEk3Njl4ZVh4aWhOLzlLNzFsZmJ1SUo1?=
 =?utf-8?B?cHJBNWx5Zlc1RDJJN0haRW5CdzlxRnY4dU9ITi9aWXZxaWQxUXBxYlNTOWd4?=
 =?utf-8?B?Z0F6U0xzem91MitLWHhqUm9GMG45ZU5nbHg2QWl0eU9GYkRxSVFrV0krSENo?=
 =?utf-8?B?aFdReHlZT1o0QkUvdktiS3NCeXUwaUNSenRsZlZySndScW1kRE1aSndUMXBM?=
 =?utf-8?B?NzlzZmw4RFdsdDg2QUtDT2hVeFRHZi9lN0Y3Z3cyblloUXBoOGVMa0hYTm5E?=
 =?utf-8?B?RmxvOHJwV1lBNm5MT0xrU1BlYm03WUkwbHVNcU1TQUlseVo2Vk9SemxvQ01t?=
 =?utf-8?B?M3dVbno0TlpJaFdwem5wMk5UNVJrMlIxT0tzLzNyQUVNdkRZOGJadGMyczlX?=
 =?utf-8?B?TjN6RjhmclBkWWM3aW05SS8zQVdTejJkVmI0Uk1vME1nL3Vob21LSThmNVdv?=
 =?utf-8?B?UnpDODBockxJYnNVR205Yzl0RFlSalB6N3hDYVhSRTM3VWRQVkIxN29mUGp0?=
 =?utf-8?B?Qlo5bGlVNHB1MytRY1cyblJNMlNRenFZK21EOTlaaXFocmVWKzFzbWQzaWpi?=
 =?utf-8?B?NnBnOHFPcDhQQ1NVT0NWQ1AyeTYyYk9nTUtXSmlRY1lrQkpGeHpJNDVYd2ZU?=
 =?utf-8?B?a25NYVBHenIxTDNyOCtqbUhMekhzOGQ4MVhrdzV3YXFkTDU0WHlwZCtHbWFn?=
 =?utf-8?B?Z1BCVURuaWJVeERwSmE4LzFPV3RnWnpCTUhUb1VBdGVoNm5sUmVRODFQLytH?=
 =?utf-8?B?NXVwUXdOeWZNbGRoWHJyb2xsTldKVFRSNnFIdWlvcW1kcHZZWUs1MjhCQVJh?=
 =?utf-8?B?QlJUOVNLQkQxb3hpM3k1T0RuQTNpeVdvbnM0blo4dVdCclJPVVZ6MnVxQStU?=
 =?utf-8?B?NlFab1hmNVZkaklWMEQwTm5YSWxOVFZ1eldPWHBpUVpPMDZLTDVvcUZwYUNh?=
 =?utf-8?B?Rk4rcGZvcURDbVUyaXdhSmUyK3gwdWd6NFljNzEvV0NSclg5bGhjQzU4UjAw?=
 =?utf-8?B?UUJOMkxVbWpaNXVBMFY1aGJqd2dGR3BXQUVia0tyQVIwODQ0WHZtWGlDUmlF?=
 =?utf-8?B?RzFOOVZhb2RaVjJXUWhWUWs5WCtiOEJKSzFmSmNwUEZkVmhJSW05S1JvZ1hh?=
 =?utf-8?B?SXlPdmtLMG0wb2ZZU25hZC9FY0VuV2Z3MHZTM1NvQitFeXlCL2dkL3d1a0RN?=
 =?utf-8?B?NW9wY2RYM3IrNWhQRXRHRTBnZ2hiejVZUDd3UnRpcnBmSW56N1hjbU5VU1FV?=
 =?utf-8?B?QTROMzNWZWd5L08xWThOYTB0eDlnPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ec88e6e-e8d7-461c-af74-08db5ad590b6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2023 15:02:30.8032
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bt6mys/uaCdDlXxB8UU9cGWWZucT5vBcqg/rXQSOOgelEuSbTlWlZqoWyqNZe9GDTkdGeOzxS9ig+oelqyTbGYSZFmdVgdHfx+lwREyOF6Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB3705
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 22, 2023 at 05:03:31PM +0530, Parthiban Veerasooran wrote:
> Add support for the Microchip LAN865x Rev.B0 10BASE-T1S Internal PHYs
> (LAN8650/1). The LAN865x combines a Media Access Controller (MAC) and an
> internal 10BASE-T1S Ethernet PHY to access 10BASE‑T1S networks. As
> LAN867X and LAN865X are using the same function for the read_status,
> rename the function as lan86xx_read_status.
> 
> Signed-off-by: Parthiban Veerasooran <Parthiban.Veerasooran@microchip.com>

Hi Parthiban,

thanks for your patch.
Some minor nits from my side.

...

> +/* This is pulled straigt from AN1760 from 'calulation of offset 1' &
> + * 'calculation of offset 2'
> + */

nit: s/straigt/straight/

> +static int lan865x_generate_cfg_offsets(struct phy_device *phydev, s8 offsets[2])
> +{
> +	const u16 fixup_regs[2] = {0x0004, 0x0008};
> +	int ret;
> +
> +	for (int i = 0; i < ARRAY_SIZE(fixup_regs); i++) {
> +		ret = lan865x_revb0_indirect_read(phydev, fixup_regs[i]);
> +		if (ret < 0)
> +			return ret;
> +		if (ret & BIT(4))
> +			offsets[i] = ret | 0xE0;
> +		else
> +			offsets[i] = ret;
> +	}
> +
> +	return 0;
> +}

...

> +static int lan865x_setup_cfgparam(struct phy_device *phydev)
> +{
> +	u16 cfg_results[5];
> +	u16 cfg_params[ARRAY_SIZE(lan865x_revb0_fixup_cfg_regs)];
> +	s8 offsets[2];
> +	int ret;

nit: Please use reverse xmas tree order - longest line to shortest -
     for local variable declarations in networking code.

...

