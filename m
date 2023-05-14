Return-Path: <netdev+bounces-2413-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E020701C53
	for <lists+netdev@lfdr.de>; Sun, 14 May 2023 10:29:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BAE6C2811FA
	for <lists+netdev@lfdr.de>; Sun, 14 May 2023 08:29:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94F721FC4;
	Sun, 14 May 2023 08:29:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8375BED1
	for <netdev@vger.kernel.org>; Sun, 14 May 2023 08:29:26 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2126.outbound.protection.outlook.com [40.107.243.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20BCB2137;
	Sun, 14 May 2023 01:29:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W53IsKKf/VkQTm3C7prGWwHkb99u58+PdL1DbBpChiY3RK2z3fWTaai4Yv4v4wiERxDZLrAfgS0PGItrsgOqWq2eKK26y2vvlfTqGsAiwUcWasUkZq1fRORO3QgH89byR+k7Fcxbeual6DdZLQDhCel39p1RPTLFlyiOLFc1GZKpxlBKER6p/l/GNKNCBr5u3UlQABIOBAW2BVDajh1+i+kx/Be+MFOs7hFr8naAw/uka1PHYSnKv+DVATy83nZ4Fz/e142Iw9awPqpLoaFctbkgBS63E0QIo6B9qR9rE/PHYTMe8c2ieoh9XR5SpbuORteZY05g+a3ZDMsGD/2log==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1gjZSh/VffQ++xleaa8OZXZ2yjqEHP7YRRJJkEg6UFE=;
 b=PiM+dIouRbbLRF1M4pwcNujMOfbIQ0uT2OpQl70dTdU5whVgsL5tzVWyM1+Ll0t3EaoekBECqhae7pF4T9GsygvYYHs2u1oK36bUNTu9ViKG9u6rY7Zc0ohbCpGsIuRzxC7nAEsEQMCUebaLuYq8zEdC+3jxYijK+GxNqQDxE9F5/BwxMWlkRd2a8dmg7fC75mG5PgXtqRyFwVS9h63AJzUn/ZYZnBksgX3pu/d7bvCjeEb/SI8dbQR9OBEchqzBz2SY/b0rOo53lEEHCDZBZ3L8sT0+aTDO48kr17cx1GJmGd68HaXIFwcLFzrKcoN8xQa33Rh91wTn3/09r6ZOlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1gjZSh/VffQ++xleaa8OZXZ2yjqEHP7YRRJJkEg6UFE=;
 b=RdyYoGOXtgn6mRDwKSkh+cFiw4FhX6T9qKtUa5N7gBFc4Qoyf0BOH1R8NHcGAdhEknFuZEuBkFhaiZXU8goDWBbwfwMeN4FpajZEYexzG93SAFjU+QW0LQm3fJuDMbAKkndOU6PXwOqHaKbZa61TvyEIAskUuN7S5m3SFOESTFk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY5PR13MB3858.namprd13.prod.outlook.com (2603:10b6:a03:21b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.29; Sun, 14 May
 2023 08:29:21 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.029; Sun, 14 May 2023
 08:29:21 +0000
Date: Sun, 14 May 2023 10:29:12 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Thierry Escande <thierry.escande@collabora.com>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nfx: llcp: fix possible use of uninitialized variable in
 nfc_llcp_send_connect()
Message-ID: <ZGCb2CNcEDtDtPRR@corigine.com>
References: <20230513114938.179085-1-krzysztof.kozlowski@linaro.org>
 <06bba9db-25ff-a82b-803a-f9ae0519d293@linaro.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <06bba9db-25ff-a82b-803a-f9ae0519d293@linaro.org>
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
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY5PR13MB3858:EE_
X-MS-Office365-Filtering-Correlation-Id: d281976a-0ed9-4a3b-d7fc-08db545550c2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	IDDGAOTEzttxPYqy9nXGg89d90mwM5x0PZmtU4cbjpdVcr2Jw9aZcfM9ghPWYDiLJOoeKKIo4ZTGt05PMNd/OcNaNR7+J9llkazH7FarfSnec329AlY/F9yF3+4IQITUlAWEZ1AqZrQ6IjxfcJABAAyzzUlSljfff0f4/ZwBGd2jHGozQXqA4rarHQ/iGfTATisK29/wR8S2iFlLwou2hj+riOUiCfXxKXhnVqXlgxK5ipMiAX/Jnw73bmbHlrnkAxPDQzH/cDjhFJu2Pg/R9pbWRxaoPKXzJHfEYtNrbd3y2kkENrYPPs/MXTbUJ2l+irXP+CvcW2IAD6nwEF+aW45QS+ltPj7xxKj6CzMLWd9uDWvFKKWmOv5Dmf8O8Pj8H0F4lD/GZY+FgArRp4x/h8SxcFZpl5Xyebd6zDGMuAbJUAbtwa/gNOEOVVNP1YawzpKSuHsHcI8RzJPIMP5wWIiGRMCsWO9Sq2n20jsWk5/9U2mlA2gGCEDt+CpXdEubZPkdDet6VdLFqj5vQuzEgJqna3iukDZQ7+AS/5NRSzGPOwHmfIiyq4xJ53yM2zw2
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(366004)(376002)(39830400003)(136003)(451199021)(478600001)(66476007)(66556008)(66946007)(6486002)(6666004)(36756003)(54906003)(316002)(4326008)(86362001)(6916009)(186003)(2616005)(38100700002)(41300700001)(5660300002)(6506007)(6512007)(8676002)(2906002)(4744005)(8936002)(44832011)(53546011)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?roRQdfaowWt9+daHXHjL2F4tujrWPvN/kqYJ9vvv6cOie89s/xSHE6H4m85Y?=
 =?us-ascii?Q?kq+THsPIPMZTr9h7e2a0wlmqt0H9AzCmB1RHvD4e3ODtryQTDPda6Y3ZVnNb?=
 =?us-ascii?Q?zLzP/wLTT46OZtMKyE1fzlueZZ0Z0eEcgAdWb9b3hR7FV66kHzB1FwdPQ1DI?=
 =?us-ascii?Q?CwodGXdvjEEsnhqF6Fecv8iQBaKvqr1bBWH9P3LUFDIzEnODBGfAh9oo+P8W?=
 =?us-ascii?Q?hkKF49Qq6aVYfMyO/HUPfecvR1AnC8DXQHxO9OvdWZEw4+GTVVFlUTiVXBoG?=
 =?us-ascii?Q?W9rYl55ACVmeG1zVWwXBaja7mgmKhi5oJBZN9NpcOvBSpcdyIcnP6hXo7GqQ?=
 =?us-ascii?Q?MHYel0fuDjQ0Ebydwm7/9+Q9i9JtVzLU5gylBUlv3zJJPWqETbmFCQ1UQmre?=
 =?us-ascii?Q?sLiT2PrQJF0Hhzsv88SGeJha435Zxiu45HxKXwMqgvf0D0zQu0bblCQVhYEL?=
 =?us-ascii?Q?+UmCuiSVakReM0DKsGHAzl93wZs7BhzXZ6TT7oGgK/HfPDoV5cFDBquo5tRL?=
 =?us-ascii?Q?/QvWs2ADFZg46s4Yu0ze1jeahmgmcVRqSETsdlEL+xaohm0sIX4COSVloMEb?=
 =?us-ascii?Q?h1o3HI/M556XsaZBmnIwTQUM9jFY2UwNs+i6xfconOqL7ESvBQIHLvG2Jq2t?=
 =?us-ascii?Q?J5Lr57GlNOVL07bM4noW3iGbcKn4xhzq2hNGxSY+s9GQydcT3bjroO5YhQEt?=
 =?us-ascii?Q?xBtmH32oYjkpFvRX13+NB1apNlZ9Liv7UIEXS1PvVV/s0didOvmSOSmL9sbL?=
 =?us-ascii?Q?fBDwMk+ZCytxqcKfIqgtXGTO7u8UkSD/KeXtlCbcbY7NbRVR60nk5ihwyIru?=
 =?us-ascii?Q?Fzg99pobqbat7aGbWSF3wwgurVMHhk1blYhALOaszfEiPPKRO3myvfKIB7hq?=
 =?us-ascii?Q?V6FP8fSrwY7YABq/LXoTcxdENqTjCFDDC68Hz7PWprf65ELt3FvRyEcDb7Rm?=
 =?us-ascii?Q?5eXJorHuGBIm35gPuvw4rcncXz9i+3q5zWSRummoi4fb6ZVs17jBR2AWcI8s?=
 =?us-ascii?Q?ETgnphTMLA9W96BSu7L0ge7SWSlcVHyOhsBFgVdmZXNxY8gjgg/Pyy6j0L68?=
 =?us-ascii?Q?wTF+usIXgQdVg3DzKjKFv6J8Z240OnzeB6rKM4GzKy+/sFlXl9VsPVE+wvcG?=
 =?us-ascii?Q?dir2q1TMuID1n3bFQ9O6/QVYK/1yAox14r+ujAbeYxnlksHiXiNlBCJ9mHqn?=
 =?us-ascii?Q?bP/+1WaF2Akar8cm3352m+6njwoY+yGGTX57UP9E27hIM46siDwK9vIqhMJU?=
 =?us-ascii?Q?wcHY+3lIdtIqCINlxfS2QUw7DFY8SQ69iSx5zWFF5dbRFkXEwlCCTnr7JqT9?=
 =?us-ascii?Q?gCmD/UyPR2JXbA0mD+Q+5UQyLnYf2Fa2HaXTGs5lSAJ7lVzMNTYMCjRg+LwO?=
 =?us-ascii?Q?XpNXGndcIepV1SPNjyaSNFomgABY5+sFqauXfEeXQKdGPvozGn9Ye/IDKxLd?=
 =?us-ascii?Q?dx/gGHpjfmi7rZsLnUmFQrASTum2mgrl0X5vEGEj3m4+pgzUbabkXPkxNHEd?=
 =?us-ascii?Q?TfJH1s8BiC/UPGFOSjz8fjAU1llg+0b5A2dPlzPj+v7bUWnOJASHhZIvEgXQ?=
 =?us-ascii?Q?WGhNJ0C+LZQ+50Gwc5uEK2p0UIi2Ui0gYu8UalWi6J69s+Js51AtvgSTHqPR?=
 =?us-ascii?Q?9CljALwQix9Mlz7sKDQJfqjKZXvqJXh8/SibZZNGp/YfpVKf3yFqnghtdvdS?=
 =?us-ascii?Q?pBHWIA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d281976a-0ed9-4a3b-d7fc-08db545550c2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2023 08:29:21.1540
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RJZV0Ukru1T61/dS3/+DVlaX2hIGBkyFM4oGIx5czYx3XGjtZsl6YL7YG+Uf/q7UISWK7V98k7O8QGogPTguBm/Rj751/gqCMd8QY04RhCs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR13MB3858
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sat, May 13, 2023 at 01:51:12PM +0200, Krzysztof Kozlowski wrote:
> On 13/05/2023 13:49, Krzysztof Kozlowski wrote:
> > If sock->service_name is NULL, the local variable
> > service_name_tlv_length will not be assigned by nfc_llcp_build_tlv(),
> > later leading to using value frmo the stack.  Smatch warning:
> > 
> >   net/nfc/llcp_commands.c:442 nfc_llcp_send_connect() error: uninitialized symbol 'service_name_tlv_length'.
> 
> Eh, typo in subject prefix. V2 in shortly...

Also, s/frmo/from/

And please consider moving local variables towards reverse xmas tree -
longest line to shortest - order for networking code.

