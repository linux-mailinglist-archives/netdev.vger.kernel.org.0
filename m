Return-Path: <netdev+bounces-3908-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D77D470982A
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 15:25:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 94554281BDB
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 13:25:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63CE7DDC1;
	Fri, 19 May 2023 13:24:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50B1A7C
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 13:24:59 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2095.outbound.protection.outlook.com [40.107.237.95])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39991CE
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 06:24:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Alrhqs53rszTKmMEjOPwDNUY/xfbDsrgfRC4uIuZQ4L2K08IsVgR5u2Gs0Q/0O+2TFy44hzLIxuCXvMkC/9gbi10fTjCgOfYrNnez31LWdppjd4RYnAKaVGJiZYTF7U70KBE7eTBhUkU81C21RN8zQimQ3ue441tNLNy+sT0APAgidCgnzWG20NHvqtKtVXKZiKfd1vJHg5Wr09QmW2949pc7PGUWLqiYDYN+ApL8HUOInmnFqdIaTX1ekqp+xBiajKR+Dpfad4vXezDPy+DNs2tvVuAYRANhGWUHuuS5CfA7byt3NF7EpcxUDcr6mfPgEOQo7qGszxMC2nkayHbIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i3Xy6iiz8kTm4hPHPOK3u/n6hI9kKPw5eQmUxr9otrU=;
 b=AUe0+gUJqEOVG/YG6TKd55uJk6liB62Np+4koMij4K30PYbDggoJTOIX5UP87TmskYAyaHSXEdwh/A4+s/18pQ4w34Ze7CwTf/glrupiSiaS1kKlVwKF8JMPXxOV1f+nltOyqj+P4My//ZsNh9dmdML69w5i8g4lGDBEpZ0KpppWlCHDKBsAwUkHEMKgBdL+50Rsoh85dHoWagpi5Ea12TNJeMOJNI/Qnr1RJ9VxM3/NzwDb8uHth0ev9GB2xCVfrYdDfuzTAKdRT1RGi1z0fqRVGhm0TIq1WUCb9qGbqhuM7oLIa7jpQMc5THucqzhg4afL6P9+ZdPand4HkExIFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i3Xy6iiz8kTm4hPHPOK3u/n6hI9kKPw5eQmUxr9otrU=;
 b=jaD8aptFGoWVOrRey7AX/thLJtdbH0TQFDgPmAa7RnH3zFeG9CQJmOkecfwctrxiG4ivXP7nAN8Ui7J07c5hCnlkw9CNMUpDlRelJEcdTgK5mDPlXYOGnp/6rdupcVOIq8HPiP6VfBIYNORaNTN2f5ec3+KgPWyDVPexqp2zTMA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH0PR13MB5153.namprd13.prod.outlook.com (2603:10b6:610:fa::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.21; Fri, 19 May
 2023 13:24:54 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6411.021; Fri, 19 May 2023
 13:24:53 +0000
Date: Fri, 19 May 2023 15:24:47 +0200
From: Simon Horman <simon.horman@corigine.com>
To: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc: Joyce Ooi <joyce.ooi@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: altera: tse: remove mac_an_restart()
 function
Message-ID: <ZGd4n1jNHbSAQZjH@corigine.com>
References: <E1pzxQ0-0062IU-Ql@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1pzxQ0-0062IU-Ql@rmk-PC.armlinux.org.uk>
X-ClientProxiedBy: AM3PR07CA0119.eurprd07.prod.outlook.com
 (2603:10a6:207:7::29) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH0PR13MB5153:EE_
X-MS-Office365-Filtering-Correlation-Id: 07cc5de3-fc12-4de2-0a6d-08db586c6e98
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	mM43BsT8V05omGhQNITusxyEukphyw+R4ZL1mrVb0i8Qz6+1rbPXCGi7bdKHKeTw/uHP9HEjyz2Idypo2GEPedcZH957rtGcPsX8q6LZ5FJCJpwbb/RrgvGsNRrhEwnRrurr20fRB5YohbgxSIErDW9RNIwJijQq8n+w0G4MMc0UxxCD8OAm4NRkJrOLeQviCAFGxKTJOBsVHDr72q1NU8e2qJT01EqI98qCmJjwmwbKHk1oqotvz9na0sR3RWwLb4CbN7L7NmN5ewDwIW8IuoKt3zb5fa7Bo3QezWWQiOPmcFWfPvOVmLOD7tVlkFxCsxgVVoM8+D7HZzF3oRIY3UjORe40GQK+V9A+RC7PlqjwxSjk74+MPwkNc+xm3KCZR7icOXRCaqk/xhn8boUe0/RRyzZI6HC1hQ/mS6gDjpgFWAhwSxstSlpiJ7kL4tBJHB80ZbifvN+GYsUf2QvQfLXKy/Bdtav9kWZUyIDumyO4SGIXboZZNc+/gJlj4luOGvZNbRlo6RUo5lz43RklG1B5zK3DYq/tTsFskdnQaivEN9x9ZtJSoDfCZLqM+RwijYdjQfHgYJwCFATP8TEASg9riyM22A6l1WVtpkXzOBw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(376002)(136003)(366004)(346002)(396003)(451199021)(86362001)(36756003)(54906003)(316002)(4326008)(66946007)(66556008)(66476007)(478600001)(6666004)(8936002)(8676002)(41300700001)(5660300002)(6486002)(4744005)(2906002)(44832011)(38100700002)(2616005)(6506007)(6512007)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KTkBCfg5KvD72e82itHhiX1JwlFAeIx0ivJMdgcHAbz+AMF+MSHqF8LX86VJ?=
 =?us-ascii?Q?AZJeqJFGK7GIy4AyLwOFo99dxirEFttok1R+x58OWfBdNoHspGVVxjP2fIS0?=
 =?us-ascii?Q?z9DNWyBfahnBP60U/ebdaNoVa8+nGv7jumr6m560JmlzmKA7MpXLHO9kBb4Z?=
 =?us-ascii?Q?IBJ0eGX6PzLqu9q+DZkJ72g9OtnK2eTKWATQFWR3No4dBSnIOEHnF7ZHEWqw?=
 =?us-ascii?Q?EXboponA8MGL/6ROoaRa8rGagnLaEzgjDO73nfP9xqVrhWEtJQtG1sI6XlF2?=
 =?us-ascii?Q?B5JQWQX7evf4QVMu2T0fc+3wUbTVxVRDEdkbdm9tzFWx7xgBmZyP+jqe3ahL?=
 =?us-ascii?Q?c7UqQKUIy+bMdB5b0wNXy0kITuoxpc1JVtw8psMmalv1icmZqev2BEUgENRN?=
 =?us-ascii?Q?XHGZVJVBueq42D2ot2kQtkp2cIq4gO9LnP/PuV++J18Zx9uxshrfYWxNh3V4?=
 =?us-ascii?Q?2LAww/3U78ycLF4ZR1Av6rMBSXK4+V9Ikf06zMYdPkGcdKnPc4BNgSY+/DjP?=
 =?us-ascii?Q?VLUqc74B5xG+SgXbIzJIIAJvITp1dyviSHckB4FaZvgAeO/vpubNKil/pb7F?=
 =?us-ascii?Q?GMoZFhxbiE/UPlBqb+UYrgrDhNPGelJdK0ZZjoKax+HWB/IirVLjBayummXg?=
 =?us-ascii?Q?MX0v/UmCmCIi+wTZKN8PjWiy0CDUsZx9U7mBTEDrKpk9wa+oZcOsR5DnMaGV?=
 =?us-ascii?Q?66L3qHuVGX4ZWX66B5qJ/gNlkwV/KT2pfJ2l8CdGYohaDDHq6HY93pKl4Jk6?=
 =?us-ascii?Q?iHTAy79dR26Goo3dpoWB26woACsSGMz8KnNt0somaEfcLPcr0BRTrq99+/wt?=
 =?us-ascii?Q?nwIBU3ZbSgN2ok+xRRGfLlQRq8JS8GubyHguKPtfoVlFSp7WC8oTvvxg+Eb3?=
 =?us-ascii?Q?u892biCY8GK40RKM0v4gIqifQh3vug9TLDCSFVwZAGnmlymGajFIoYwUXSgi?=
 =?us-ascii?Q?eNCPy24h/pFecPhXy2HcYYYricAST8wZ3Z3N7WaGK+PzZn4817tSvB2nzJxi?=
 =?us-ascii?Q?AaGKLv3GAF8IcxoY0be47rIrCLWEGsSWVZ29Fv9twXrdqenCz5fsqeTyBK/o?=
 =?us-ascii?Q?ZMpjxGTJ9SnS1YKp2Ea6GgSjxaMUjiKq9MORltKAgzuLY6JHKnCd/x9ueAfJ?=
 =?us-ascii?Q?nC7vy/qq18foRfZZTGk2YbwuZMCltsvJRW02DA4gt2G6LKx79FuZNmEfgxYb?=
 =?us-ascii?Q?dVzwBBTtXV2yBInuHdubaZoM4S6lJh00WLpB2ZLMnzGlJw+ixXf6MYgq2wH8?=
 =?us-ascii?Q?5lfCs100DMb88UH0LTaB3QOnI0/sGIBc+n1/7gtRnYrxMFACjNE9XYfd4JbV?=
 =?us-ascii?Q?wUmuA7dJqAk6csNqQXdB6s+4rPzXMTZs3creKsmw/Vl453jltpkHhkIFUcpq?=
 =?us-ascii?Q?xB9ykwD8FMMsUlVD6b4CXC+lnMFL87lHCZwuOQFbXHpgHrhXc/TnmTXq5XuC?=
 =?us-ascii?Q?AcR38M+CcD4PDA5+fQhTAP7LT3tKDZe4I2Hvq7DXfCD0wT0ZsjN5XjrI+qVs?=
 =?us-ascii?Q?R89X94bY1KHqnhUqeqa172YXmPHKxLTZkcOUumWVmaCez3+XZZpGibw9ZJQN?=
 =?us-ascii?Q?rJezOKB96CP3GugMf6iKtjqwU3n8UVS/HfY5wVwRHXd4VblOjfNUrCkY6u40?=
 =?us-ascii?Q?yxGjELg1sMQyCWdmE4ulm5ymZ1v+MZeNPVXSB9QnuHZO0pGkywU+X0FB7uXk?=
 =?us-ascii?Q?TYwriA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07cc5de3-fc12-4de2-0a6d-08db586c6e98
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2023 13:24:53.9444
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HMY1hJA+Z3aW6fZxhHue4S3Yfjq85FXqdrZT+y7RLMC6eTzJ0PUeK1enNs57Ui9zzNV4/wECXHGW+bzqRJtHE1mPv9ZJb0LM/Mh2H7vuaoo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR13MB5153
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 19, 2023 at 11:33:04AM +0100, Russell King (Oracle) wrote:
> The mac_an_restart() method will only be called if the driver sets
> legacy_pre_march2020, which the altera tse driver does not do.
> Therefore, providing a stub is unnecessary.
> 
> Fixes: fef2998203e1 ("net: altera: tse: convert to phylink")
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

