Return-Path: <netdev+bounces-7148-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2505F71EE94
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 18:18:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7AA401C20ACF
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 16:18:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88CAE42500;
	Thu,  1 Jun 2023 16:18:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 768EB22D77
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 16:18:25 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2123.outbound.protection.outlook.com [40.107.243.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21436134;
	Thu,  1 Jun 2023 09:18:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aup9D5FDrgG3Idr5HW3EmB+WCznv5oK3EMgEarnJOIWlaOnv7oyJYewtywZl6hF6nBxzsfCuxoJdXGkAnVzFlq8HqlIvBXEZ8ymDHxZsm+BSa/jHeI7BeboAsW4QeIenYxMW2VwH83/PYjz6AkNEOPimd3chOfIm+rFehXMZHd/z39dczF++yqTJH6GB8Ux7gtkiMYE6OzpSIJxwp+E46fMCQCr79esLuBwJAyO+Bj6iDoMXoapPNa/X9LuiLY7u2NU0pDAJOZ3JgSKtBb1L/zkOqzWCkL0/vtNQmUbvN2o97R22YouJ1/HaBoSqgjovsZRWxfwv0jHUUYfV3bkLNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zY4+RM0Mq4uPOBwV5oIH4AlS6ylnMJatc4VxUI8CVrc=;
 b=ZG7ZAe27ifSqO0SP9GD2PYjFetac6fE5Mre9l7FPef4WAoUDYJSVB4GC7wtQJ/szGreEazoMzrgznOiGA5dLJY7YG0ayeeKQ05RRfDhDNOCzFYre5HEquOg5rFL/wE1xhgB6nszQxWRtytAPtP0Bda1dmL60KJtOZqOaHn1PNhxSHg+kheSmTKmqiJgvOsik/9KNJeyLq+mvyjx2Z1iH1j1AFqTdZlu4Mxn177XgfQ7ZnOMqzazufcY2IjnJmtFImIMT3QAJWng0pOOnW6wBQxBm2BesU8nmpZP4EJ7fK5ufR5s8G5npw4fVWsDYvPRCeiXA7IuLHMo5NfHZ0jkviA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zY4+RM0Mq4uPOBwV5oIH4AlS6ylnMJatc4VxUI8CVrc=;
 b=Gv7tgqCZ7XLtH0e41CnQQOyl9crmhBchlpkpQDXanQGcUiTs9ogBo03GKy2crmI+/XtbqZBDow5Tbh4VxJmUQ1jRKYfF3kRxgl3a2HqPWrH1626CrY0oPUV1EeijEFKgAiyeOkQ37oBHeQIOQwk7240OF0KBFwTo613LJZJpnZE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO3PR13MB5783.namprd13.prod.outlook.com (2603:10b6:303:166::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Thu, 1 Jun
 2023 16:18:22 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6433.024; Thu, 1 Jun 2023
 16:18:22 +0000
Date: Thu, 1 Jun 2023 18:18:15 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc: Kalle Valo <kvalo@kernel.org>, "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH net-next 3/4] ath10k: Convert to platform remove callback
 returning void
Message-ID: <ZHjEx9i+D0Ppco5P@corigine.com>
References: <20230601082556.2738446-1-u.kleine-koenig@pengutronix.de>
 <20230601082556.2738446-4-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230601082556.2738446-4-u.kleine-koenig@pengutronix.de>
X-ClientProxiedBy: AM4PR0501CA0059.eurprd05.prod.outlook.com
 (2603:10a6:200:68::27) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO3PR13MB5783:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a0a86d9-0b17-4ef7-8c00-08db62bbd1c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	o4LbjyJzckmkerxXOIh34oeJZY3vcL1XTQE4hK4RNeZ4GySQGWuKvmczIWxwkWLwG4qFUr03+gzoxV0dxpBWOXo3tIKqBvoWJW08hgYslnHpP9Pa0svjuPo9KbUb8J2//FWWsLAeghXqZy6W4+dTLrV/cwn3KsrkDl0qmDJlWQXY9xMwghMqu6u60e+RRIkAd3Fe3YfABrX105Gd20NDxPvvDTpyLyGJulDYKLDyM58bB6U6tj+F794CMtNVnbsTzImN7UjusIxbzLLMkkfH28Zun9cxQdnCBZJwPY2gvOHl85nsrCv+UMvIQzNOWZpPAVaRoGMrI/oLs8dwPOlg0/HxnpEcLfUYKrQq0AX2IOPMGtqEjM14BlC4tiE9oRVDwW5Pni9qkVaMHqs/ZseeZVavIDhIAiK2maLisvaDy+5TxgfCkrLy0NSjIR+A6wzvYzMuxbY+CMfvMT7YWKHZ7xycB0UZo4epsuZbvWxzH8sIVQkiRwIe+JTa4eMS9sWsJ7mqfAigcFc/R6rxIqKkrijYnoCVFs2dFhhCu2Jgz2gYUTR+oDpVdQHHce7t7xyqnlMd3ilJvMBkqs8lXHwgRkpzqgNw1WKYIU8DQ3jKoiQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(366004)(396003)(136003)(39840400004)(451199021)(7416002)(4744005)(44832011)(186003)(2906002)(2616005)(6512007)(6506007)(5660300002)(478600001)(54906003)(8936002)(8676002)(26005)(38100700002)(4326008)(86362001)(41300700001)(6486002)(316002)(66556008)(6666004)(36756003)(66946007)(66476007)(6916009)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VlBUUVBiZmlFSWNtdWNvSGI2YThjbWE0MG1KWkhGL2lwdTk3RENlOFk4bE1q?=
 =?utf-8?B?ZVlTb3RZVW8wTmVTTXVBQWRnRVRIdkIyeTdvc2VOTVFTWEtWOVJmeG5SeXBE?=
 =?utf-8?B?TlpxRjlFSjlPdWw0V29vSGdtYWl2Ri9sOTU2Y0VkNmNEQlkxY0NsQ2lOR3BK?=
 =?utf-8?B?b0NxSlVySzUycUl1Rzk0RlhNMFZyM1RuRExxT2wrTklpbGRLbXNFeklJU2Vz?=
 =?utf-8?B?Wk9hRDhrelAyeExPRFFNWDduQWxtN0htbmIwTUlNVzFqbTV2V1F3T3VKSnY4?=
 =?utf-8?B?UWU0MW03K3ptemxNQWVZVzFiZm1ndlZKY2hKNWlONTBWM2o2TS9JdzFaL0JW?=
 =?utf-8?B?ZU9idCt1a2xlSkVFaXlXZlFuYStsUjB2aHRwK3ltZ0JWY3VRV0VrNkM3dGpS?=
 =?utf-8?B?R1I4T2FOMUlUT0pNbE1MRUhxVG40Si9ocDNJZGIzZEhMUE1GbDdNWitadmpa?=
 =?utf-8?B?Z2N6TE53bTFPUjZta3BOS3JoVDNoTXhpRDhqYXJadTJkSTZNY0FtZCtGZms3?=
 =?utf-8?B?eVJBbjVoOE5VRWdKc0RDbjFEeCt6ZUNVQk5Ocm1nTlR6MEUwVm1CUkxXb3lU?=
 =?utf-8?B?b081VVRXa2lWYXJCbHpwYTBnckYvS214L1VraGdYNGVOTEZNZTRCbnNJM0N0?=
 =?utf-8?B?U0Q2WmhwRDkxQ1hCMnVkamIzUS9OQ1o5NGd1andTNXloM2w1bXRiZ0Fpa3hk?=
 =?utf-8?B?TStkQjNUNTl3amcxbE4wR3FUM3dyaGVmR0pKdHNzdkFtd0VVcXBOVHlvQndi?=
 =?utf-8?B?eXU4M3VaZHZabCtVM1l0YlFFbmZmT3pjTmVtWnRUeTJYYVV1ZVJDNjNwMzVu?=
 =?utf-8?B?NkVFNjhxRThqSEdBa05ONkE1ZXZjUjlQMHpBTlYyMnFFOEtpT0xSdldNNVY5?=
 =?utf-8?B?VWNERDE4ZDBaSG1ub1dxK2llN0JqU0tMajJObWdQOTN5eFEwUXhjdmRDQjNy?=
 =?utf-8?B?VDZTQXorWStsRVZzOWsrMGE5UXpDRU5QSVZVcC9ZZXcvUnZ4cmVDa2lMaUpC?=
 =?utf-8?B?bDZlbDQvdWIwNTA1VGp1dnBQaUh0TC8yYmlEc28zS1NBVU9ON05RMUtUcVJw?=
 =?utf-8?B?NGpkbXFFV25zSWVoS1d3S1Q0YjBSb2YyRFl6cmtQd09pMEZvdTZTdm9xdnZq?=
 =?utf-8?B?NUFoSVl3VkZxZ3NFRjI5cGh6SEZSQkNZNktQMC9icC91dC9zVTJpTG1idllw?=
 =?utf-8?B?RkhSL0pYOUh1NFlyNEcxSjNvOG9MSkI2MmFEK1cxQzRITjRmK1dNS0FHY3BT?=
 =?utf-8?B?WVArKzJSeTFvNmlsOE9BbFArV2VaQ0VOSlNzbDhVcnk1Q2FaUityL3Y1ZkNO?=
 =?utf-8?B?aFFwMU1PeGNnTExZTmVqWkhwd3djUWwrSkhZM3JzRHJ3WTVWTzJENmthSDlB?=
 =?utf-8?B?WE9KeGh1SWFPZVFsdzg3MGpRZUw0U3hLVlk5Z0d1ZXd3TVdZTjlIWkFzRDAr?=
 =?utf-8?B?b0ZSN3h3MlFVbjRFaHJQc0F5TXVWdGRkdUhpY1FjWXFkRy9md1krRU9tbjE0?=
 =?utf-8?B?MFY5WUc2RHZzTnVTQlNOdmg1WFZHTkJ1Z09mamQrNFM3TDZiN29MNTRFSkpo?=
 =?utf-8?B?UnRkRWowL3FteUVLY1hhT0pDVEhWL2E3WC83Tjk4UVV6VkJoWjcySDVyTkZU?=
 =?utf-8?B?bVBOL0lDZ0RpTGRSUzFBYnpmZWpjN01hc3ZsZTMxZXFRQnRRQU8yZ2dhNC9j?=
 =?utf-8?B?Rk8wQVJ6ejBDVWE2THRCVGoxZGxKSVZsMzczWFJHTDB2MHhzMmhLcWNlMzlG?=
 =?utf-8?B?MlJSTjdSclZZc3diNlhqYVZPR2VtT1hlUy83NElzQTBOMi9ZRWY4b0c0Y0RD?=
 =?utf-8?B?azFBOThxL2NIZ28rTSszd1l1UkpaaFFOQnJneE1PNzZEeVRQT1lmQzZtak5J?=
 =?utf-8?B?MjJkKzR1M2hWTFdta2xVZDYzOWV0SnJONCtjaHlPZGFodCs4VGZwZWpybEhu?=
 =?utf-8?B?aS9wa0MrSWhoc2pFUGltaUJuTC9tbnU2MU83UmgvL0lkSVIxSy9Kb3NzRVIw?=
 =?utf-8?B?VkY1NVZteHh5YWgxbFA1NitCcW0xRkdQeFF4YzErMG4wRGhibUY5UXVCMDVr?=
 =?utf-8?B?cGdxcmVFRXFDcjE0ZFF3TTgzQjkwZnVjaGNpUTlRZDVCZDVGOTlGbVN1Tm9V?=
 =?utf-8?B?bHpYVDJWVnpodmFmbzNuaFFxaVZ1Rk1UTlA1aVZaaDJ3UFBJZmVENVo1bmhK?=
 =?utf-8?B?NkE9PQ==?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a0a86d9-0b17-4ef7-8c00-08db62bbd1c4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2023 16:18:22.1985
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /VHV5J9XXXN4Oc2OJGIbQ/jG1LYBqmULcey2kbUwnIu4YAHIXvgkAlLwroZ/TaspUHWHpRuJ9ZRnjxgsHz2b+XtjfX9mQgBbJ9p4W0xw6VE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO3PR13MB5783
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 01, 2023 at 10:25:55AM +0200, Uwe Kleine-König wrote:
> The .remove() callback for a platform driver returns an int which makes
> many driver authors wrongly assume it's possible to do error handling by
> returning an error code. However the value returned is (mostly) ignored
> and this typically results in resource leaks. To improve here there is a
> quest to make the remove callback return void. In the first step of this
> quest all drivers are converted to .remove_new() which already returns
> void.
> 
> Both ath10k platform drivers return zero unconditionally in their remove
> callback, so they can be trivially converted to use .remove_new().
> 
> Also fix on of the more offending whitespace issues in the definition
> of ath10k_snoc_driver.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


