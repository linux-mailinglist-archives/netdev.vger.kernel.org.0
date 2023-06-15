Return-Path: <netdev+bounces-11039-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 62AA57313FD
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 11:33:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AEC612816C2
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 09:33:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F9445C8B;
	Thu, 15 Jun 2023 09:33:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 595FB569C
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 09:33:54 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2139.outbound.protection.outlook.com [40.107.94.139])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACB98270B;
	Thu, 15 Jun 2023 02:33:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lzWUT/w3XWOJnS0ZrG9kaUmhJSQYw08mhNekQIUThTqK19kgV0mH/J/x6zy9ZfFwJLJ6NWMfr9tPiurKvSfpMg9Cz5A3cYApGL5SBcREyWutsVTIrSs2+TtEvr0Vv1gPQ0mdOl0TlGLsRoBG8uLQqB2igKLmfsYdOtmQyth1wneN9A7iCZAcNtxgTqAxvV52eEsED+TXFfzqrtcj21grCBBVQU4NO8y5daEGQCbkzVe49XjNQcOYE6TXlpjNTu0QJK196sLfzaBtboo7wJxjC1yOAwOYkhqp3N/wjtTKQCGXUqPAcitc3sY8HaHfcfyqIU1J2UiA+oyYnHoujcRh6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PzD59DSo8iL6da6zXr32QQEa4mI8w+XAFVlwQxvBwoc=;
 b=kMyRCao0mIg0mHLyYoxh1RECxQD9AJfbnDDzAnertlL6hPaeJYn2hMbOF2hanNrfHe8aMibVSPzX0xya9bP3M8fgWs3TqE25+hF2K1XcdEnMpzoLZDsrPDXf3Dt4BgGd4hjan1bFMhAucFzjPNNMoRRYZcuPyMzcv9gpxogmkUsl5MHJbzi+RRHKtE+thtVv/WuI9g9QYR5+QaYSdO/3P2uxuKIX+/5WcJ4ff4XiuxXj81sF3SsgwROJNYC7cf2FiXvUQT5HHcgdFw+ohg+vEhl4ksTKgqhj8WWctVhZnPSSAZXXLwhvcw2ujvfeJTNrUgzOe4AtA+uY3DZDJjrJdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PzD59DSo8iL6da6zXr32QQEa4mI8w+XAFVlwQxvBwoc=;
 b=ANlL1XrlwmIx/10f2+/oh6pGTy5ZXC7V/IayXTJL86hHmpT+PbYbHWM457gQivYo9z+YamioDGVeZzAos+Xjn2Up9WlWgHORsdSWGv6+peTR36LPnOA+oIXu5aHxMpF7Jq0xTjZm8Aqnfa6GyrfMiz+f678zyh5fQKFJkq0xMhA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MN2PR13MB3959.namprd13.prod.outlook.com (2603:10b6:208:24f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Thu, 15 Jun
 2023 09:33:50 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%5]) with mapi id 15.20.6500.025; Thu, 15 Jun 2023
 09:33:49 +0000
Date: Thu, 15 Jun 2023 11:33:41 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Nicolas Cavallari <nicolas.cavallari@green-communications.fr>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Ilan Peer <ilan.peer@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] wifi: mac80211: Remove "Missing iftype sband data/EHT
 cap" spam
Message-ID: <ZIra9Z0L04nBbfJO@corigine.com>
References: <20230614132648.28995-1-nicolas.cavallari@green-communications.fr>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230614132648.28995-1-nicolas.cavallari@green-communications.fr>
X-ClientProxiedBy: AS4P191CA0028.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d9::20) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MN2PR13MB3959:EE_
X-MS-Office365-Filtering-Correlation-Id: a107498e-e8b7-4e1e-11e5-08db6d839fdb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	dj8Vjx304KTY1Ob+E92go7avH13yeyOYUdVlJH+uSg8cNqbl71e7HaXhNde904rCJIF8NtnY/b+uKS3E8mynHyYffYk7o9buxHudS7QHNkTURTPem1MOBD3bzDg57T8AwpwTi87I8x7YYqP/6x3Ht6Bkq54IdC3fQHC5cH9j/h6hCk5fhTeIyGzZhnobq2KTjWSYo/2qbs3rp1LmR85dMSf+O99qbpk3UZ0fMS8QfOU9waGssvLwmaZ7zv+AK/QvTgWc3rtuu34xGyryTgfKi6vpyFXY8yC6wlk7od7tJDK4L/E/KTJ39BCPl7jEWNe87ozwYx7YEDodspw6v+4+gPVSgeBB9B1RZ/1GSRB/vAD1/GLluZFx8FekQp6dkQHOgncVQssNtIxG+rX6rk16s8pxKQqIEYp+T2vV2wUqz9jalDU9T5l+FW4VOM4/uPdsae9i+TggJPmBlYgr77adS8lwn0MTivtdQXzQ6D7HL7GwcYrlr4eLDKarLcRqNWo4kXGI3sxaM6Sip3qWrRDeuqz2uubiCQjjLj+zC0xnIE/cVOGkBErzGU2yzY1MIYcLFV9AGV0kQ5keHAQGqDiXce7SVs2JKOQX+QwlQ+Um6x8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(396003)(366004)(376002)(39840400004)(451199021)(4744005)(478600001)(2906002)(2616005)(6506007)(186003)(6512007)(86362001)(38100700002)(6486002)(6666004)(5660300002)(6916009)(8676002)(8936002)(36756003)(41300700001)(66476007)(66556008)(4326008)(66946007)(316002)(44832011)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?LMXL+JkSsPluWfiXh/aCu4vyZpZNqlCEph2gXju4SWEYUJDBjcKybaKss9NE?=
 =?us-ascii?Q?FBAyclYCIHOaCKe/QOzpXUBokMflo3o8sM++cdsaIPokeR25xPIP4ungZYP5?=
 =?us-ascii?Q?nsNzP4EwniPxG07W3JiDP1B0sTPtwzyiVubyiLFg0A+prjhuo5sNO/AG3+e8?=
 =?us-ascii?Q?Ino1qSw5if6huPoW/8dTvywFKrl4UI4tNjcJRCKIA9imoN5w7LZLK3vAxVo8?=
 =?us-ascii?Q?ymuRFjqjbGWDtAoZKs9WHcY7ctt0stfyy7NqdnvpS3Kr05TD0RMkETRMorgT?=
 =?us-ascii?Q?69t6/f1HhYyYJklwEsxm5JRKOf6R7D0U5MOEH9g+gF8TO8KHAUW++6rEXnpn?=
 =?us-ascii?Q?a3tuwJHsi6acSzhTgX8iI7U88z0zdA3kWZWAee1b2K4JrUA5JnG1gKUM2JAw?=
 =?us-ascii?Q?mpifXwEmjxuEz0L295AhnplRooMfuXibk46nR34T3QTBgY/TLN0wHj1qxU1/?=
 =?us-ascii?Q?+vpPWpu9VSn1y79jmHBOr+OR8hj6xXRCUMYI/JLYKbTtwNvwMDSQeQBo/vQo?=
 =?us-ascii?Q?D6MlbFwfm+gUm7OahwSA9E3M7IZHgnbbOWdSQk+eyOMkolUeOPn52jL3Ei2O?=
 =?us-ascii?Q?rbv7mRMp2QcQG14DPDRSpoFeHvM9KvH8d45EYmyt4NXMFUq8yh0OTGxtSbow?=
 =?us-ascii?Q?ygX+vWdXmh9AwGs6Ru8cbYVi4Dk+QtsHD13BB9Oy3AOTkpNK4oabcusrssai?=
 =?us-ascii?Q?zxri7oIZyCJMSQKj5f8TO9LYJ/rEYZKx8tJuEbAmccxLfEU7W88+ChghvuTx?=
 =?us-ascii?Q?gjJuTxUtyX4P+1JLEy9otPWZW+FUXujToBf7uA4Xh5CIo3dFLyjtizKCd/pB?=
 =?us-ascii?Q?M8fywHX7yrnN2mVoTp9ZOgT4gstgUh0oKhEuFFhbRr1Jl1Y4bQ3bg8De8PZx?=
 =?us-ascii?Q?yscFlAoGsa3PWZCNNS/SgCPZfbVsPy3fWMgNg8rSzvo0Po87Y1XXkkPBpy7D?=
 =?us-ascii?Q?jjpKx0KJ05AHajrOWIp28GwkwTBckMuc+NF+IZJ511G322QIeYYzLWoLvBm2?=
 =?us-ascii?Q?m5U9RXHkT2cWUog75qRfeyFicC8cRJULVYB1QlAkhQrnljup6ad6fbmusO8S?=
 =?us-ascii?Q?EeFW3dXCtuPCMlGqDClbLuHoVttYFBwnf3z8q6SS/Q+YzD7MT7qgDrwlsrk/?=
 =?us-ascii?Q?IZlTC8YdPunCPLyMb/AemPXKhEuGpU2cMJwt8ZkaFcFENP8BZDSug2yDZwfS?=
 =?us-ascii?Q?hVOJUWgHbJ0u5A0bzxmnSEVTMZ346YZIXA99siRLNgJw2RmGFmwPsPOaZl+5?=
 =?us-ascii?Q?gUpLjlmPGSkPB7aBDBNhy2UwES+u6liZbCXjmRyKR71CO+yd0Q0whbpQyKZn?=
 =?us-ascii?Q?utJCiHlB35ELMDETYc0JY2jSOxL5gc5VPhI6Amq8voJ1FHidO4tUdzhItJV1?=
 =?us-ascii?Q?70kigrvgMSpYW0BkaqvYVHjXjUbSzf2XwF1BQxp8ZWF9RZiqNS7zlIheVOSf?=
 =?us-ascii?Q?2ySIiE0qD3+pzCGK88lYpRNWMmAltgEkvNv91PBDd0AgHOeWl13VNKvHowiN?=
 =?us-ascii?Q?Djd11Y3x+zcEnpxRuB0BBmzkbhafpmB9gMHgCwhPmghwPelYFr7zTyHgKa6t?=
 =?us-ascii?Q?pceNQHOz9S8ZWcw6Qbtpep6zGoYMUCAaf5DLhNR7brIJt98vdzcKVRqNU5E7?=
 =?us-ascii?Q?1R3QSCg9RoAEw1rc197FZX6DlNDKjcuruCsqIWb3n3yo57VyRecsyoSvZ5RD?=
 =?us-ascii?Q?EQPYKg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a107498e-e8b7-4e1e-11e5-08db6d839fdb
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2023 09:33:49.6109
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r7P0ETbGmSpRuvsg7kzJ33mdB2ukMUyo7BdyXsKWyUduCwNpodTGQNs2GwgSQVEGoldWQEYwNVzfQNV9XakG7MxMJY3RCNLytT2MeXXYmX4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB3959
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 14, 2023 at 03:26:48PM +0200, Nicolas Cavallari wrote:
> In mesh mode, ieee80211_chandef_he_6ghz_oper() is called by
> mesh_matches_local() for every received mesh beacon.
> 
> On a 6 GHz mesh of a HE-only phy, this spams that the hardware does not
> have EHT capabilities, even if the received mesh beacon does not have an
> EHT element.
> 
> Unlike HE, not supporting EHT in the 6 GHz band is not an error so do
> not print anything in this case.
> 
> Fixes: 5dca295dd767 ("mac80211: Add initial support for EHT and 320 MHz channels")
> 
> Signed-off-by: Nicolas Cavallari <nicolas.cavallari@green-communications.fr>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


