Return-Path: <netdev+bounces-1726-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1416B6FEFC9
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 12:17:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CE8A828177B
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 10:17:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E150E1C778;
	Thu, 11 May 2023 10:17:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBF191C740
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 10:17:44 +0000 (UTC)
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on20704.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e83::704])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E9B9558F
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 03:17:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I2IhDB1PtEGc1cLsdjNtW5BdFCgP0iAQjjPO55P6yo6c83sQcMKKaemJ9yMojjHpGZITtrIgMrCb3p0RlFUNm5PNGieLnSlH5P8KY5d01x3inA5w0rUpsPedWD6RPrtxz3ak/0ru7MGXzVfMz/VvqxjuvQvwDO0kURnn4unp9NOLNQK4Y9ojHbeyVRAjkEa4tuTOMJ0qNQDhBDOTRsLYr87OZF25NXCZcCf8o0G/2+sy8PdehAdq8NxCRaUokV7wO8KzWRN01ojSmH075EXLlyZGwRiUdg1r4OneCeTFun37unXbwl89W1i50HmqpAOa4zCu4WIGtxFAmglARwpGAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KDr1dWlnsfisk2FK8HXlFBngSbvK2IKoDfyHJw86G5o=;
 b=Vd9+YbNGAoZfHjEFQ51Tiad+S11Na8A4KHutnFU6g8eifIwnpEVQZFRJVw9FFV27quXiOwmKOGE7901AmuAxUaSGZ1g1Ni+T11TDjx/6vcHGanVn0p0RpiAIhzGzvwH/5LCgPnV1Wg69LtG+53qPXWjJtFXTRFu3N65D42ap2VnRgH0hpqpp3LLt5xRLH9ElT3osndcsh/WmJhZmhBnq1WJMom+jNLzBijQ3ce4rgeeNDKGMpzCjOA5VcJniUGQ+KhWAay3hYzG91DENhWbTVWqQqmweReCM8gaaAEYTRZJCg3S8t5ErkuCrn6OetscDR6AMMXPX6xN3CWeE710Dvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KDr1dWlnsfisk2FK8HXlFBngSbvK2IKoDfyHJw86G5o=;
 b=DFy7R7nMKStZLkI0zjFbAZ5XUHwkJ04vLjzGjRxX2fsd8g9FlaXzJtwgkiLKIHgcOS6dD77wSAVyv5YLjID+DMhjqzeYGJ+qGmgE2PK32/EeqBeFlb6Wnu4EDYOzNcZEVboYk69wFctGCNoSpOY34sbe0tazY7Xuzc53pkP5814=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN7PR13MB6129.namprd13.prod.outlook.com (2603:10b6:806:32d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.32; Thu, 11 May
 2023 10:17:40 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.020; Thu, 11 May 2023
 10:17:40 +0000
Date: Thu, 11 May 2023 12:17:33 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc: Byungho An <bh74.an@samsung.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH net-next] net: samsung: sxgbe: Make sxgbe_drv_remove()
 return void
Message-ID: <ZFzAvXjpr4t8LLCO@corigine.com>
References: <20230510200247.1534793-1-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230510200247.1534793-1-u.kleine-koenig@pengutronix.de>
X-ClientProxiedBy: AM3PR04CA0128.eurprd04.prod.outlook.com (2603:10a6:207::12)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SN7PR13MB6129:EE_
X-MS-Office365-Filtering-Correlation-Id: 954ea612-d113-40cc-d844-08db5208f39c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	QlCIXund6Ap4eBbiTplrywWNuY5W+8oSucGyH7Eh9cBE0zz/WyzoN0Yii4sGHqcdG+rI0QdcNvdA4F5H72OQir2cwPGn67UFUGlnAgoe85/oxawdgfqPJBvrEC09AAn5VGRsdKfQ3HGYbcHUvAoS7dziaCFtIGCXnNEjyftAV/wo83oL7hxLPbuGNNCcnOraN7GXh/sY3xJk59FNxwJfR5Mom58Xuu2osp+x0ccL3IZ5z3VNZ5SWHgtB76GfclWgZvDHDZ753XOyCICPySUeaIxai5fT4HtvZ7G2aY4nhYd0s91GiFPNZ/Z+kPwMqkDVE1vaz1R8M4goIKXhFcxoRTPx2q2nHwvKX6Ad1lQADjBzKtJ30mOwTSz4XHOOJWTxiE3Q5v/rxts/IZw3bBTIeVxPMsPm+Q/8AR18Ms8LOb0ChCUjtOJAmR6WGI6+dJNOjUmBhY5h7g4LYnFyMcvhg5eeluBUfmz4aQBrPsWyZcx/VHbjnQUzHgN1j/YfmjT7PMFJgYQNMs0QSbj4j1UCiQiwoDv+D4F7ovi7DEHL4n7vSAXG6o1gLb8+9c4qubYcbtKwJsLP1oCLCBhgrS1lZLgMKGb6JGVuBpiBwPG3JtM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(346002)(366004)(39840400004)(396003)(451199021)(66476007)(66556008)(66946007)(38100700002)(54906003)(2616005)(36756003)(86362001)(6512007)(186003)(6666004)(6506007)(6486002)(478600001)(2906002)(44832011)(4744005)(8936002)(8676002)(5660300002)(316002)(4326008)(41300700001)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SkpSeUVXR29CSzFsWitZdFhkWjUyR0E2Y2xDZTZQd2cwSStKZ3o4aU5yUkkr?=
 =?utf-8?B?Z0lYNC8xcFdFOEpsZ2xTYXF5Zi9hZW41a1VoTDhLSXc1OFJGbXBEODBVdEkx?=
 =?utf-8?B?bkNrWjc2MFhUYnUxWWlWMzhrQVNESGE2dW9EMHNsSmRrTmFFa3lVZ2dhbnJV?=
 =?utf-8?B?TUdsWlFtOVBLTEhqN2kvUVNHOE9YNWdaQTl1L3VuajJWaWtnR1BQZDYyWit1?=
 =?utf-8?B?SnJjaHhBRmhFQnV6ZURHRGlmdmJUbzRFNE9PS1lEQmU0NDVhNkIxK1hqcHo2?=
 =?utf-8?B?T0w0TmgwNWptZHpxRzhlUEFCaHZGb01JM05rNDJ3RG8vSWI0aXkyQzVPMDQ5?=
 =?utf-8?B?OUFTTEFlUXRyeWZUd3RqVlJNcU95RjJZMjRScGxZUnNyUFJybGc4Q0QvV2wv?=
 =?utf-8?B?SXN2c2djNFBhUTJWS3AxV3BmbHl3NmdkZnFoTDFsNnAwczFza3o2MXBsUjV2?=
 =?utf-8?B?SzJrWTlTMmh6Z2N1Ti9OSFR1dC81ZzE2MGFWUHdzOXJpem9DazN4K2RvNXF2?=
 =?utf-8?B?OGUyTlJkSFI3S3oveXBIcm45cnJZK0NncForNkRvc2dDLzM1Tndqc0ZRUnR5?=
 =?utf-8?B?aWNoK1ZVdkl4bG9CTjI2d2tFSUtDNUxoaVA1eHR5MGViTUhYekFXQW0vZlFv?=
 =?utf-8?B?VHNYK0Jwb0I1VjNQUURCWTRvZGZMRlZtVzJxOURjS1VhWTgvRm9DQVFLcmQv?=
 =?utf-8?B?bDNqUE91MEk2ZytsVTJHOWt1WG1rZ1VPYWJDRWNsRW9qNFg3MjVONHBQV3RY?=
 =?utf-8?B?U1I2RFF1dVVWUThnZUlEZjFpcDJKYnFsT25sMERkTHhjL2hxNUhxVWlSZ3c2?=
 =?utf-8?B?TzZ1ZGRJQ0xUdkhWS2QxUEc4Ymo1N3ZmU0FJaWwvZnpLVzZUbVRxcWNYUzN3?=
 =?utf-8?B?ViswZTRMamtVVFFZdk9PZUlmOTVyZG91TUpuNHhCN2ZWSDdJUDhTZHJMbFhY?=
 =?utf-8?B?KzlzbWM1VjJzeWpUbXRuRnVOd09rRlVIRjlDUjBtSWhGQnZNeFhIdmJlakNH?=
 =?utf-8?B?OHdXQlNzR29yOUhIcGpDVjI3NDgyWFhaQnkzalNNMytpSVRQNWxzSVFwUUNN?=
 =?utf-8?B?dmlZM1BaT2hEUGlGNE5MOWNJNlcrQjJkS0UzMGljUG1oWlpzVlVvblRkTVor?=
 =?utf-8?B?ZTlzS1RaTHdaZHBOTUxjNENQb2NqRlRDTnFEM1FkRXZPNnR3M2Z6cGlzeXpD?=
 =?utf-8?B?WkIycFR1WjdWb3Q4bFR6RG9pMllsVjlqM0o1dGlLVWt4amswMDVWWW9jVVhE?=
 =?utf-8?B?VStBN0kyZXN1VGlyUmxEbVlka0EwOWhybzEwWC91Nm5VUzhxNnNXbnFkczFh?=
 =?utf-8?B?SW5Pb203UEwxWUk5bHM5T0h0c1JWUFpyZEZoVW9EWHBDSHV6ci9jL2hMUXo0?=
 =?utf-8?B?QkxXRG5qaEJjS1ZVMkRHOWszMW9YemVsZkNpdDdOQk1PWmhqUjNyOEtFa1Jp?=
 =?utf-8?B?ekxlblJQL2gwRG1nSnppUzVpQVJlVTZvRnpvZ21CWVpJbkhuTnFodkFFWUx3?=
 =?utf-8?B?a213ZGc2Vks5NUZNeXYweUhFRitXUzhKTWtzMTJQMjhJeDRjdHlyVFAydG9B?=
 =?utf-8?B?T3l0ZVdlS2t0VUUwS3phM2ZucitGVGxOTytYUWF0YkRsZGpaclVZR3MxRTRF?=
 =?utf-8?B?RjIvNXFOV3pObklYcFA5UTdpYXdhQWh4b0VCRmpQQnFrZ294OHE0YjlUK0Nn?=
 =?utf-8?B?Z1ltdkpWdG1mUGc2QTFVSHBRZGNNTEc2Z0cxUk4vNTFwOTl5bVM4eGtkVVlI?=
 =?utf-8?B?ckUvaWVFM3FhWFFRMDIrSXc1TCtqL0F6OEU5OWpzY0tPWWE4bW92QmFFRk5p?=
 =?utf-8?B?WCs1YmYrc2QyN21jRk9CNmg5aVVkUkM4bG1NVjAxNHhKWmpVRUlRZ2NBODU4?=
 =?utf-8?B?ZFNFa1FnVkNnZ09KQlg1TlZqcktCamZUYnVUZHNvVUw3T1Bpcm5WZm9NZUxu?=
 =?utf-8?B?RUdUVlNtMkFXVU5rYzd5TnlpQmN3OHozOGdHMG9SUmFueVJXQXY0WVZsV0Rh?=
 =?utf-8?B?YXl5MVFmM21DSmZmcG9tR3o4N0s2d0JnbktqNVB6elNoMXRZQkZaOXFGZktI?=
 =?utf-8?B?RW1xYnZDWWF3SDVMSmJxSWl6cjVEVzVwWkcxeSt5S3RJaFlwNml6djdUQUZR?=
 =?utf-8?B?SzJDaFQxUk5vb1ovWW80cm1TMWJMbkIvcE9zVFpLZVkramxqakVadFoxSE1u?=
 =?utf-8?B?VW1yVzNSdmkwa09QQTNWK2xiL09RTjVXTlQwUVRVK3FRSW45OGRZZENwb0VK?=
 =?utf-8?B?Y0k0NjdoTlpHSzZ1Q2FBdXd1NmdRPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 954ea612-d113-40cc-d844-08db5208f39c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2023 10:17:40.5097
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0BfDuGNSpb+d//DevM+7746lkadkT9XrxzCuFnwG0BCQCdRPXDClbYluqAipEav/ndJeGKQgugiSQ9ePhUBy0fWjZbGwgiKUzwe1ZFeBnmg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR13MB6129
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 10, 2023 at 10:02:47PM +0200, Uwe Kleine-König wrote:
> sxgbe_drv_remove() returned zero unconditionally, so it can be converted
> to return void without losing anything. The upside is that it becomes
> more obvious in its callers that there is no error to handle.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


