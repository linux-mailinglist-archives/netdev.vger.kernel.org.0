Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C24F6D5364
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 23:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231788AbjDCVVP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 17:21:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232711AbjDCVVL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 17:21:11 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2079.outbound.protection.outlook.com [40.107.94.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3769049CA
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 14:20:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JG5FSgSPeTzTpVlG6GV1Vz+9Ou9rj/fBNAyXOsgxyutG17u8FKS8bSAQJnjAhWAg/iD4XcY5g/jCO3LQUBDvjsqKm3QiDDhs2FjS40fpsHMhjgW//0q7hWYKTL6LRi2HfQaIBNUBit+QYp9+iIjFW0sGls8oIUZ5FKK+H5YMk1ddKhnd1ct1KvfHmDGFjT1yLBdzlHaMHmO9YaKxl9NS8hZbb7R3/TFHZe/xAUdNH8MAzX7PKJY2Db1eE4YoEYuCNiT/3yLp5YtUf+nJSn2LBeVOMoipQUrETWRHcxyJSIlDpqBErtBrhtEtkpNv05R350UoT75VjPhEw+iESDPemQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bZxu2RY0E/EJ931hUzLmGMVydr9zoWLk2VgTaGhtAT8=;
 b=gtdgbKNufgkberfKsxuatGz9BFY2nKD8EC396krzR1gzs0fIK1hKfe0bNPmu/brinsprdwg0PO35ehGOitdZDeag3DJGx3Y8efOB9KLkF950T32atuqVy+28UzoxeyOdsq00ganGJOQ4d5OrJ/+QqLKDLY50oFs/QrFY6EN+D3e5snVvwhBqVs1NLgrxgeEmC6OFqc9g4LStQnQiStNi3lT2QvtQOZGu7yUJpQaRjuCAbxvJnNMUZIbIQWywiSjx5h3KvtUPQJxu2MDT/W8ifV/B5DO5g9ktqPCwsDwShuQjso3fetzwUtXJ9dBzO+FXTe/L4k1RbEp4H9UL/xHRwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bZxu2RY0E/EJ931hUzLmGMVydr9zoWLk2VgTaGhtAT8=;
 b=XtdlMxtgIPcfuvWVPLx8jby3PYmAXxNRQqGXsUow983y0dWnVY1r1+xVtXkZnYmWnt+C2Ah5bCfP3yaMfEzc/Hck6V3gooS7aKOTt2rWfu4PdZiumE3q7cdmm1TdcyVebUTEAksdSLEDK8M9BnGujbLpi2eCS/O8bLUeXSDofF7Gn8+pGxzqfdf543c92KbO1zYFpSBIMe5/5Q4wFVlSTiD5dM7FIWPSZd9awAJGcXtQns/6pwIaR+tKUBzJgxn6TsD3K+ALiLHHvhqPUxBn1pr6tdvVUmPi90daM4sVUL4fRXwGXoFBU73GyuNPzjolWOYO7Dw66gdecl+iOzuRww==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3127.namprd12.prod.outlook.com (2603:10b6:a03:d8::33)
 by BL3PR12MB6473.namprd12.prod.outlook.com (2603:10b6:208:3b9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.36; Mon, 3 Apr
 2023 21:20:55 +0000
Received: from BYAPR12MB3127.namprd12.prod.outlook.com
 ([fe80::ebc5:c372:d99a:fdb5]) by BYAPR12MB3127.namprd12.prod.outlook.com
 ([fe80::ebc5:c372:d99a:fdb5%5]) with mapi id 15.20.6254.033; Mon, 3 Apr 2023
 21:20:55 +0000
Message-ID: <ac238d6b-8726-8156-3810-6471291dbc7f@nvidia.com>
Date:   Mon, 3 Apr 2023 14:20:53 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.1
Content-Language: en-US
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        andrew@lunn.ch, f.fainelli@gmail.com, mkubecek@suse.cz,
        mlxsw@nvidia.com, idosch@nvidia.com,
        Danielle Ratson <danieller@nvidia.com>
From:   Andy Roulin <aroulin@nvidia.com>
Subject: [PATCH net v2] ethtool: reset #lanes when lanes is omitted
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0077.namprd03.prod.outlook.com
 (2603:10b6:a03:331::22) To BYAPR12MB3127.namprd12.prod.outlook.com
 (2603:10b6:a03:d8::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB3127:EE_|BL3PR12MB6473:EE_
X-MS-Office365-Filtering-Correlation-Id: b22e48da-a58f-43e8-c1fc-08db34894f99
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ezU4zBpoKId43Y4PBdtqYsUyGo+4/WiJJqoH+bmgh+QzAiAZ1pMS++ADZLcbBxv4OyPikaiz8hLbpLUfAWPWtEoOCpwalh/EVrpel9Quh5/5o0L6eZUyMAHwwNYl0DGty6N6U2ofW5hCtuKkrJmkjXE9X2cpbPgOTzY/e0E1ZHKwgaQs0FUhvRyB3FanI2Gl1RF9wCPJoy5vxTFnDJlwJNeS04m5XUPucqJyNu2iYGbPL30XrIVC+BTmphTxYJKlt3E2VfZVBKDtBRkroPm8xAVvk1XgyrrXyoQ3WSovmt1wzQW+EwDinbnFSvZAFaTxAz2bixvGhfVqwKwBcLa+PgsrNSX9TyfiFTnQ6URY/PObAEmDSGbKuWdLLfE+NuGyCSCQYi6IKRjpIL7nSzNzZ0DitniuV0AGzktCow/tcamd8i1aVd5DD9CE9h1t0+byH8edFlFuNvwencHPr3QS9TSswxm15uodods0y0hEdJeEpackbcR6Ln3VKehvHW87ZMlvU+hyb/QHmJnAaXu0m7iRf5YkX0+ni1E9I8Qr5pBBlpnft1jTk03Jcy7htJGVRZHEXe4bLb4jXu9/Vkdk7rIysuD4qTa3YWFYellJv8q2RoWlxy+QXFEVpkYHXD20wRS1Qta3YhRPB7VBnvgjvg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3127.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(376002)(39860400002)(136003)(346002)(396003)(451199021)(31686004)(6486002)(8676002)(6916009)(4326008)(66556008)(66946007)(66476007)(41300700001)(316002)(31696002)(36756003)(86362001)(2616005)(6512007)(6506007)(107886003)(83380400001)(8936002)(2906002)(5660300002)(478600001)(38100700002)(186003)(26005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eUtJcG9lQWJsR0VjdDhZcUg5RVMyZnlaM3BwL3gyd1Z4Z25jQ1J3cytnYlVr?=
 =?utf-8?B?ZEZUOEI5NzlLWjBtZXliOXJCbWxpVEQvOXVXb3ppVDlMMFhWMDA5ZE53SDlI?=
 =?utf-8?B?N3VOVTZlQUtHdDEwTmhtUGdXdVpkeXhSczZ1amw2dytJdEk5ZENRK0YyYkRD?=
 =?utf-8?B?UlpKZjNDdk85UjIza1VQU0N6VUJ5Q2daRVpGTWlTcjF6T25VU1R1VkYxOHVi?=
 =?utf-8?B?d0x2cWhheHc0QmRSZ1JOeHF4aHR5dHVDeFZuMlNuVmVQWC8rK0REcGhVSXZ2?=
 =?utf-8?B?WkFzVkY3OTByL3B2MkltbWkyUGM2V3ptSWFEemtTU1MzWEJxVTdtcy9tWU1O?=
 =?utf-8?B?RFZxUUs2Smg0NUJsbFBIcWNMaWdBS2VpaFJKVCs5dE40RjNKcjgxckc2MkVX?=
 =?utf-8?B?QWVHNXd6aWtjTEdnWDZUWmxPZWVJRDU4SjJ0TWprdzZKM1NlL3grYVZuc0Ju?=
 =?utf-8?B?NnBwa1JpaWhnSkRpT3YrMlpGckZKMklUV2dRU29kdG1OVTVuUFBFS05PK1Jz?=
 =?utf-8?B?NEN6VWFGK3N6cGFqaXZPc0lLbHplZkVDS1lDOVZmODN2cEprOG5hWmFPWW1o?=
 =?utf-8?B?TEtzMzdWckxIZnp1MDNMN3NKL0xJVnQ4T3kzQTB2OXBCWVZ6T0NXd2xNUWtD?=
 =?utf-8?B?SGF3WldZOUJOaHVzN0s1ek1UVU55OTB1RUwwUlE5WDZxOXJHMGYyRWtObVMz?=
 =?utf-8?B?TXJIY1pFblp3bkg1M3k5TDRRV0NVS0dKSnhSTWRCRi9Oemd2NHBQR21tcjZs?=
 =?utf-8?B?bzJ5bnVMUkpCcjFPNDAwVUwvb1dMK2w0ZnZUZUlNSjNXMVhvOTdGNlZWY1Ja?=
 =?utf-8?B?OVk1ZWdMVFNGVDJnaVo1bHFPSndzUUNzd29KUGZ6WFVxM3lkS3pDaUtsVTNV?=
 =?utf-8?B?T0NBcnJMaG1FenN2UDdGU2JETFg3cG5mMEo2ZEdnMW1RZk5YV3RyN0xGNHps?=
 =?utf-8?B?Q3V3azNjY1pSOHVKVUJkUGc5aFljMHV4Q0M2eTQxSkZ4dmpDN3dVU1hCR0pK?=
 =?utf-8?B?STZOR0hoQW5QYzBOZC8xUHFRRGRmWm5iTEhReDZxZmo5QTlDYjQwSnY1RkU3?=
 =?utf-8?B?RmNJV1gwSTVwdWtTSTlRZ3NBWFRrRXdXQVRZSUlMMUhXNkJhRE91QjdJZ25Z?=
 =?utf-8?B?N3NxQi9MSTN6UzhvVjlGVlNtNXZLdjhEcHo2OUF1N3hSUkVYU2p1d2xZNWNZ?=
 =?utf-8?B?eittM29HNE9kOWxIbXNhOUtmc3JnbjI5cWoxaXZjaHVEMnhUUEV4czVFUzNu?=
 =?utf-8?B?TE8vK1BvUm8vUkxzYUtOM2xHM0grQjVCSG5FRGRhYnpZRFBpYkRNN0s4VjFa?=
 =?utf-8?B?UVhIcHpNdEVBc0Z6UWxVM0x3RGI4L21nQmN5cGxZZTdvalF4NW4wc2dPM0Fm?=
 =?utf-8?B?R0VENUE4SFdlWFRsNjQrUmNVM083Q3NtcXZRT3hEMWJ4TmFCZDNlamVFQW1R?=
 =?utf-8?B?Y215R2FvT21mdjdjNDBxQ1VjQ1JiK2RDMmVKd0JyOUJVc0V3dXV0V1o4Y0pY?=
 =?utf-8?B?Ly9ZSnNiTGJvL2w2d2ZtcFluaTdUTm10OTY5YkNxNGtjNWM3cjNVSStCMFAy?=
 =?utf-8?B?STlXYWRWOW53QXR0VVhLUE5ZYVEvUm1FT1d6ME1odWc0T0JIVnhzSjNpL0Fy?=
 =?utf-8?B?R2dJREpGaXM3RVlrNm9MNEZVZUg4enhYMmZ4LzNGZ3A5WVp5VFFCczlRRHNj?=
 =?utf-8?B?cWxpTFdmRWh0THkzYnFkV3JCRGtvZjJyNEtWaGdsZEtMcFQ3cmRnRE1tZTFN?=
 =?utf-8?B?VjVmejZyY3ZrMTE5Z3BMcDdRR3h4QVlrM3J3MTNaSHBOK2h3Qld4VkgxNHZu?=
 =?utf-8?B?SlkwNTUvdXlEeTdoUUZtQWJSb3M5bnBMWkh1aEtZWnZiK3lmdXVXR1B3Yklo?=
 =?utf-8?B?MnJNeFhSbVdnQ01FaER0RzlTRmlkcS9yNGVjeFNWdjQ5S2I1RzRaZE9nR1o1?=
 =?utf-8?B?RVVkTjBtL2hadS94eUhVR1gyUlNZRjY0K2lBS01JbFhtZHEzcXJxdUQwcHo4?=
 =?utf-8?B?allvTVkyK2YxYVVmUlM4NHY0Z3FrWi9qdkwvSEs2TU5CdVdEd1h1a2psdkxB?=
 =?utf-8?B?SEtsU25YLzVkMk1WRlFIOFg2dzZmN01aK3NzaWszNEljWXc3UlpBQy83VWNx?=
 =?utf-8?Q?biz5zUfnb74+yg9bxIm7d+ZSG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b22e48da-a58f-43e8-c1fc-08db34894f99
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3127.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2023 21:20:55.5336
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mTOpvDT5VhYR8yXmY64ewmbfKkHJyILOWn+guXKXIv++OwmLCIg78LhnB2/JxQ6at+er5VeGOPLwk0pvSLtIXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6473
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the number of lanes was forced and then subsequently the user
omits this parameter, the ksettings->lanes is reset. The driver
should then reset the number of lanes to the device's default
for the specified speed.

However, although the ksettings->lanes is set to 0, the mod variable
is not set to true to indicate the driver and userspace should be
notified of the changes.

The consequence is that the same ethtool operation will produce
different results based on the initial state.

If the initial state is:
$ ethtool swp1 | grep -A 3 'Speed: '
        Speed: 500000Mb/s
        Lanes: 2
        Duplex: Full
        Auto-negotiation: on

then executing 'ethtool -s swp1 speed 50000 autoneg off' will yield:
$ ethtool swp1 | grep -A 3 'Speed: '
        Speed: 500000Mb/s
        Lanes: 2
        Duplex: Full
        Auto-negotiation: off

While if the initial state is:
$ ethtool swp1 | grep -A 3 'Speed: '
        Speed: 500000Mb/s
        Lanes: 1
        Duplex: Full
        Auto-negotiation: off

executing the same 'ethtool -s swp1 speed 50000 autoneg off' results in:
$ ethtool swp1 | grep -A 3 'Speed: '
        Speed: 500000Mb/s
        Lanes: 1
        Duplex: Full
        Auto-negotiation: off

This patch fixes this behavior. Omitting lanes will always results in
the driver choosing the default lane width for the chosen speed. In this
scenario, regardless of the initial state, the end state will be, e.g.,

$ ethtool swp1 | grep -A 3 'Speed: '
        Speed: 500000Mb/s
        Lanes: 2
        Duplex: Full
        Auto-negotiation: off

Fixes: 012ce4dd3102 ("ethtool: Extend link modes settings uAPI with lanes")
Signed-off-by: Andy Roulin <aroulin@nvidia.com>
Reviewed-by: Danielle Ratson <danieller@nvidia.com>
---

Notes:
    v2: add before/after examples in the commit message

 net/ethtool/linkmodes.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/ethtool/linkmodes.c b/net/ethtool/linkmodes.c
index fab66c169b9f..20165e07ef90 100644
--- a/net/ethtool/linkmodes.c
+++ b/net/ethtool/linkmodes.c
@@ -270,11 +270,12 @@ static int ethnl_update_linkmodes(struct genl_info *info, struct nlattr **tb,
 					    "lanes configuration not supported by device");
 			return -EOPNOTSUPP;
 		}
-	} else if (!lsettings->autoneg) {
-		/* If autoneg is off and lanes parameter is not passed from user,
-		 * set the lanes parameter to 0.
+	} else if (!lsettings->autoneg && ksettings->lanes) {
+		/* If autoneg is off and lanes parameter is not passed from user but
+		 * it was defined previously then set the lanes parameter to 0.
 		 */
 		ksettings->lanes = 0;
+		*mod = true;
 	}
 
 	ret = ethnl_update_bitset(ksettings->link_modes.advertising,
-- 
2.20.1

