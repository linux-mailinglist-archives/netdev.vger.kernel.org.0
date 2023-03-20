Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D1DB6C1D2B
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 18:05:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233262AbjCTRFY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 13:05:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233410AbjCTRFF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 13:05:05 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on20711.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eab::711])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FBE22E80A;
        Mon, 20 Mar 2023 09:59:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lbYH2ihsTSmIFe7WmpGemfJnEP+xGifzSU2Fimsd+FJ5U599CQuhl+OyEVhzMGkcOVy/gESyh4cYergKWT9RD2MMiiqr6AOSDt5X6VKgsC9CGV02jus8x7PXmIDqXkph8p7UcB8F2CxUtUsgEivYwl67Ze/4nMqqgRuiMasHJipf8KRI6ExQvZVY4nzexxswPoYwAEYDPDD20OGYmXGp9GRgQtespDS/wlauopbRyvf66XJTlzIHxunB1n71Myv7M4whxLMIbU0yul6vRQd9/OPfPLe4mWA2R0H4d/FA8y+faFXizSXcgUo3uw/5v0AHOIyxyI0GxH08UHJ/PIIygA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xJGKaXs5KM35c/K7WivJBL+maK8RKWUKpvckDoFP1no=;
 b=ZmCa1+yAKXH+BUH9/3KFo59NYasdKRvYLXpUm7rgG9Y7uBjB89VxO006JXjpEY23rMyYqggSGxzTgv2/euHHwOvSdLW8QAEfp74PhH68zw9q+TgRkbW4/0xmXqMG7RxIGrl/5xEpKA3wXf/3BUO4uklL57EyBM6qcNsP7qQ0c6u+k7xq8aMr8m9Wp584v5AWLPCwD+/u4MA1lXbtrn5qaQ6C/XjKT7P2XtDblvwkcV11fJsxAS3EguRDHEmpBEkSKerBy3U8yVb0E+PYgqBsHgWcpAr0WVAwUm/xiPwMFFJacUlFShcpDDkbayJ8yEvBa4TIlllU4YFyjZ3JA13HuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xJGKaXs5KM35c/K7WivJBL+maK8RKWUKpvckDoFP1no=;
 b=hptFlP+lIi/+nWNqfTQqi+tSTgJpIimiSpO/ipJz42OpwfCoWrTdGNeE2eQFjXL9dowd7wo/NiYjcYyLRm6E/XIVJErrbHHjvsxWBTNw2STxbWGI+nlHtOxo+k2g6P0s0USoRWTlosstaYxvewmMi6utzabgxGHGLLixfLSDUBc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5543.namprd13.prod.outlook.com (2603:10b6:510:12a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Mon, 20 Mar
 2023 16:49:27 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.037; Mon, 20 Mar 2023
 16:49:27 +0000
Date:   Mon, 20 Mar 2023 17:49:08 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Jia-Ju Bai <baijiaju1990@gmail.com>,
        Jia-Ju Bai <baijiaju@buaa.edu.cn>
Cc:     johannes@sipsolutions.net, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: mac80211: Add NULL checks for sta->sdata
Message-ID: <ZBiOhAJswYcAo8kv@corigine.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230320133809.2448047-1-baijiaju@buaa.edu.cn>
 <20230320133601.2443821-1-baijiaju1990@gmail.com>
 <20230320133644.2445321-1-baijiaju1990@gmail.com>
 <20230320133533.2442889-1-baijiaju1990@gmail.com>
X-ClientProxiedBy: AM4PR07CA0003.eurprd07.prod.outlook.com
 (2603:10a6:205:1::16) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5543:EE_
X-MS-Office365-Filtering-Correlation-Id: 10baa27f-eb4b-4cbf-eff8-08db296310fb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T8+CnEoMaIf56dczmO/d0ou0p6/cPuJwfXGiWGubUjs1yP94c1t3uOqWipeUXvP1PMP9Jslv2JVhvw3/hSD25JNGZmxaxk30HTpWgbcl6QE0YfsaQoy9+pWLN7WfyGn1ylAriFgviXQ52Os6Hkur+oHG7d9/lW0eHNeDZBTYPoLc9usJmwrIsw6bP0nPwMyPjOT4KEV41vY5IdMLRmk5hvWWGPGqrpx9y27OxZqlaWIQ9ovG8/yEAyCfIDgUIcc3ad7/fhUneffAJmIb+RVFSOeGqvWYwPJE3aIG/L8u0KgPrar+e5c0LlvKzg383JAkfPKBwJsaEOBMdDDdcGSmBkkskD96z1WXknUj06FIs8GhfvU2gZH5fRMDzxjIq59gaM8PI2WnIflL5szT5X5YmK0e0uV8qyQEY953soFIcmNQxjCHmABtsvvrdetkbCJ6HrN0xRM+L55Ef20tMvBfCtCUNtiRn0MyvfEh6FURa3pRS6BF/o0WWdX4hRZXUFvjLKl8WKxSc8zaQKfvJE6yGha8vYNpRJjbbdwWB7lmrVEXAgvu/O93yTA22WhDaqgOpMVW85leZ3yPBY7pwbxo/SZp2jZ9HUXuXa9yEar7Nmif0MLE0vyOX1ToBil3ciAtfED/zdVHwe4M4FkOXKZy3iwfcf6czsnuYAY3NyPUHqt5nIl8KkiM3xkZFN1ispXT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39830400003)(136003)(366004)(396003)(376002)(346002)(451199018)(38100700002)(2906002)(2616005)(478600001)(316002)(110136005)(66476007)(186003)(66556008)(8676002)(66946007)(6506007)(83380400001)(36756003)(86362001)(6512007)(4326008)(7416002)(44832011)(41300700001)(6666004)(5660300002)(8936002)(966005)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ij+JXBpRgs1M/smaYRoianOK8vcMBO4GUyMH0qoHiMQISme8wrru5BnFtl8w?=
 =?us-ascii?Q?JJtK5j0uW3x2J3DAa641QAVqtQEqFJYVg6Z0s4aPr22WwzVD1dEfcvsFPsiv?=
 =?us-ascii?Q?M5gqz5jOLvlIDmPzN4oev5crjTym3AXTlsxQNW3zWScjvoCZdIGWs2EP526F?=
 =?us-ascii?Q?LREyCeavy6M/XeJdq+qU6bMnK4cXZlMkz+TjkZ4H5xYKwAXGKfhbcAYT3rW2?=
 =?us-ascii?Q?/hYlJeWeF+pLae4QstqLosl0jseR+oRKJrw7QUaq51VJ8X4bb+wMmgR1izKo?=
 =?us-ascii?Q?M1WA+odHVaKTeTy2HDyRH9qgBOg9qB/oicQjgRg/PZGBEIr1HJxiMNP8gBj5?=
 =?us-ascii?Q?4o1xONbTrmRFqrYv8O0fy/x2b01DPZ3ocFDjJBwTBcTwt6/54PzT4Okx3anC?=
 =?us-ascii?Q?yTlPdFSjI+WyQgtd3SXC06w2LrOVNOsb99JAacTcgZOjh+bHH7Zbri7VcHK9?=
 =?us-ascii?Q?6xdzaoIidjOIJl8/hXu4JMfucIxxt/uWOHNeIaiy1L1Z2ACwS/vJ64HzVpcn?=
 =?us-ascii?Q?UHCMfjw2zQFr+4+fhIiAgkfFEQUZzW9S2ozzBG5aRdlvLd7Do1yP4pEg7rCC?=
 =?us-ascii?Q?au/iOG4e3+W1ek6YJDFF0scv5dHnE2x+1txfFn8J1dJWzGHtZnfTxO8X6Phc?=
 =?us-ascii?Q?EbR3+a7DoNuMOcsZ8xeCB3ILyELADPxapkYDRiedrPaUHUIpV9km/7zRuUdS?=
 =?us-ascii?Q?IFM65gEjuRgS8C4tSeYLVrRB4Hffr2SoYc7b8Af+iQ1p5RL7Vi1zuKRZO/b6?=
 =?us-ascii?Q?6E5U2P9YprHz13ug8GB/AIaC/isLQkX7jqnJ3lc9c6rwe+ksI8gSVVnJsWeF?=
 =?us-ascii?Q?AJADQB2Jc9MlxBcLV8r5zj/lyjfqrzzv8D2KYMQJAZ1i2hDDL215h76a05f/?=
 =?us-ascii?Q?vLyW4Gx0LPK4trqsz6bQ9vnOyGG/IQttTVHAZV3sJtbd6T7wlemEIH5Pqhfw?=
 =?us-ascii?Q?hVOTV5doWclcCndZm6Bp2GKWKeRRZd9xI36hdHy5PHLHGejx51z5Sa7HzjqX?=
 =?us-ascii?Q?BLlGJQoXMg4QXbqLjJOSMWjAplF7k5HwyeDw4VAtMiXr2PwKDdHo/csppZvw?=
 =?us-ascii?Q?aIkSfvc+MtBLNS8DS8J4nBcqO3RhHV0uSdWJ0hQOQ5u/FkmXBs1Aq9TWwE/o?=
 =?us-ascii?Q?oQtJPMlHUA7c1A4dYexc0Q/+mmlmSW6tWErDbLQl39ss5osEuq0sIQgDHMNc?=
 =?us-ascii?Q?Tx+wGlUbw236XU8ymspwfAfhhFlVNcQSwKwS3TnuHqi6jW75IAkh49kp81Bf?=
 =?us-ascii?Q?xnlIrm9mL2gugIkM/oAhqAQIRGdkElS8x81UjKL0lXzVNPzlJ0PaIMRSLXgQ?=
 =?us-ascii?Q?Zgd77t81pMPuf+2sPA/yFS4oNfK1NOtcghfEKFJww2HQu64U8/WTBNChJbEl?=
 =?us-ascii?Q?IId/7k2iyrdrHVDgcT+kxUQq/+fUDbWF3va8VaXQUYHg86lV3M1sFvKHbdrj?=
 =?us-ascii?Q?ppm9wS+UubMgrnd/MXH/6Ohns5FjSpwyw9OIimQtJcwZgOho2z659gf9+rJ2?=
 =?us-ascii?Q?5rPw39gPPpDav4gtRajsei1Fci2s9X4BKZnV0rFEaIR7eCd05UxJ3BuFkC5d?=
 =?us-ascii?Q?yBWfQ+J4eccPn0FoZ9GCSG+6Yon1ljgg/IHvBDxZYe7oDRZp37l+5Jrh1p0p?=
 =?us-ascii?Q?V/KKj3iFdFIEKjupinNwgKdA6Dq5GohD5qrdlIu9doVV2tly96Xz36FIsk50?=
 =?us-ascii?Q?N0kzow=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10baa27f-eb4b-4cbf-eff8-08db296310fb
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2023 16:49:27.3066
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /taM2GhzdJp6e6ZWebV5r9cy/XrjT+SBx63gQv+Rt3XbImI1VpklU+NKH1yR4Y1V+0P+f6Pa34Sf50kICNp3jq5FjxBZakud67AqJCumESA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5543
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 20, 2023 at 09:35:33PM +0800, Jia-Ju Bai wrote:
> In a previous commit 69403bad97aa, sta->sdata can be NULL, and thus it
> should be checked before being used.

Please run checkpatch on this patch, and correct the commit description
style.

./scripts/checkpatch.pl -g HEAD
ERROR: Please use git commit description style 'commit <12+ chars of sha1> ("<title line>")' - ie: 'commit 69403bad97aa ("wifi: mac80211: sdata can be NULL during AMPDU start")'
#6:
In a previous commit 69403bad97aa, sta->sdata can be NULL, and thus it

> 
> However, in the same call stack, sta->sdata is also used in the
> following functions:
> 
> ieee80211_ba_session_work()
>   ___ieee80211_stop_rx_ba_session(sta)
>     ht_dbg(sta->sdata, ...); -> No check
>     sdata_info(sta->sdata, ...); -> No check
>     ieee80211_send_delba(sta->sdata, ...) -> No check
>   ___ieee80211_start_rx_ba_session(sta)
>     ht_dbg(sta->sdata, ...); -> No check
>     ht_dbg_ratelimited(sta->sdata, ...); -> No check
>   ieee80211_tx_ba_session_handle_start(sta)
>     sdata = sta->sdata; if (!sdata) -> Add check by previous commit
>   ___ieee80211_stop_tx_ba_session(sdata)
>     ht_dbg(sta->sdata, ...); -> No check
>   ieee80211_start_tx_ba_cb(sdata)
>     sdata = sta->sdata; local = sdata->local -> No check
>   ieee80211_stop_tx_ba_cb(sdata)
>     ht_dbg(sta->sdata, ...); -> No check

I wonder if it would be better to teach ht_* do do nothing
if the first argument is NULL.

Also, are these theoretical bugs?
Or something that has been observed?
And has a reproducer?

> Thus, to avoid possible null-pointer dereferences, the related checks
> should be added.
> 
> These results are reported by a static tool designed by myself.
> 
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
> Reported-by: TOTE Robot <baijiaju@buaa.edu.cn>

I see 4 copies of this patch in a few minutes.
As per the FAQ [1], please leave at least 24h between posts of a patch.

[1] https://www.kernel.org/doc/html/latest/process/maintainer-netdev.html
