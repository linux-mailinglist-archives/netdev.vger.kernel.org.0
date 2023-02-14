Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02B70696B5B
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 18:23:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232426AbjBNRXI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 12:23:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231824AbjBNRXH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 12:23:07 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AFCC2D67;
        Tue, 14 Feb 2023 09:23:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676395385; x=1707931385;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0c76YTQ055RLiojQ0rjIETDheMsHJah/4ypZ8Rgpvjc=;
  b=lwNm3dn/38Xa9XcV3/cxdePpgxoVXGoQTWJGtoEj+4Dp5581L1AbKysI
   +oD6cbQuhZqaCmUSMgco/hgmN+yWERA7kLQxKMzFBVzt7jZ66/3LeHFby
   XUfUXyQuq2FtswxJIyroSbYXIKc1xnAt0nN8l7lhnTG8R5y+1Bsla/YLB
   YcnIcEyzkOzT1oSw2nXyMwbAeN1jS+I7roFYy7cecAz/6+vCbPYJvY19v
   ogkmt2XmzbaMBa7VQrnCfM3I7aLYXBkhfXgbWVeCC+SezbKeZDtbZQQ9C
   cD5QgHt2o8MQyuD8wkS74n0fgmjMvp095/wUmxq2ETqJ7pquL0oQ3NeEo
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="331211958"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="331211958"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 09:23:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="619139616"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="619139616"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga003.jf.intel.com with ESMTP; 14 Feb 2023 09:23:04 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 09:23:04 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 09:23:03 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 14 Feb 2023 09:23:03 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.49) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 14 Feb 2023 09:23:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UecM9hKodsaTCTSm+dGdj1LCQBGgbt3KmATFKUeJrRnCkPkOuKGkO728WHqjKSPniIwEQBI4tN0Kezu8Xq5OHBzA4TsAsDs7fiB3DttLr8bAYgbE5OTJFRf7krW0rmc9Cvnj94DTrd9+rfBzS93o1NwMZyGbctOMgUKX3zKD6+dMiqBOb2kRd7t7qrIJk8G0M/DIgpRFQmZBBslN9THI1rDC4u/u7qdQvrhCm9tMGEbsXGDGv8CKITFxPD1b0beb1xZDixWICSN73WWv64SVig0GCdQz4QE1tPEmVgujHGmOPcoLSa0mOvi1qpSXnXWoHKhklDs1hMjYKBX0+r5RcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gXLBGmTTcm8Wpb6PehehtKet6BiVhoAjnxiBQhBj0Kc=;
 b=nEqc08kYs5PcPXdTUBc2QLMWqg2spNUZ4j76q/GwVvsUjAFmDW0X/6N7XX+tBHQ92WNbCz5nUCaoMhlvXj7uvyPBtQ/maWPAauAtJdx3VG20YjEFd2vpRk9PK2+hLcJaBKFy+AgpZNqk9zSdbPOXdxWv32cBdnP8vPzLRgFJt0pcwuGkG7YR4/AlPB8VuXdF1ecgBazYNFP3SZdD7mLkFVXADeNjtLqehVyv629StRcJoWMxishvi/bIhhkkMor7YQxj6T6oeHFlSCdIrhOSXDxPtT18z/3rKyaEJT9fLPQQENGvs9IaZrttoMWqCVeJBWH29Rubd/hPHPi/W70iQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by DM6PR11MB4705.namprd11.prod.outlook.com (2603:10b6:5:2a9::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Tue, 14 Feb
 2023 17:23:01 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6086.024; Tue, 14 Feb 2023
 17:23:01 +0000
Message-ID: <1c1439f4-b5d5-ba59-97a7-e2edeb879fa3@intel.com>
Date:   Tue, 14 Feb 2023 18:21:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH] wifi: mac80211: avoid u32_encode_bits() warning
Content-Language: en-US
To:     Arnd Bergmann <arnd@kernel.org>
CC:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Felix Fietkau <nbd@nbd.name>,
        Alexander Wetzel <alexander@wetzel-home.de>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>,
        Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20230214132025.1532147-1-arnd@kernel.org>
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
In-Reply-To: <20230214132025.1532147-1-arnd@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0133.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:94::20) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|DM6PR11MB4705:EE_
X-MS-Office365-Filtering-Correlation-Id: 98ab2dc4-7d12-4688-5f0e-08db0eb01f66
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: boPyzhLQhWtj4lVh0H5nkXC8K8/5IBsKE5SnJGe+wMHUbpiXemj58QZey1x5qDmPglLJM7nrnJYW0QWsZGT7cgMoKYgwMQR5vt+DwhmZSZYSPFKBSN7/2K7faVwSq8Pp49QMhJP8LSJ28yt9CfngOK8VVCaoPBX81tNh8w1FhLc8HBw4CXG1wGkfb4qbO8pX0wkVZQF39L9E0xPFTWUPPUlTNlI8J+N3Ppnf6TiKrzDU62X+MU8zGfDa9sD3G0xrynnLQ0eMongJRt4BDXj5exvtNyUx2FdcZ1QgEJGRL2kLEF9tjiMTDe7fL09mivDM+2MIXPMMdDVKRRuW6brhkb2E4dPAFUD7uOClvE9lmHiRd/SwjGsQmVk4VXCJmSafKjQ8DSKdePWzG186nlX2t3rQWCcfeU/PX452qSggWBDruCKJpy0AS0tsLScbBie9ufYQcjblY+hO8ZQbnHdIYYRMI+3RacLESqqeOp0D8YJY2+IB+XY67TY9G6TqbAUcBinINofOW+pDY9i274UR7Piy+FdhSzi/qwno398+ator5ePKq6qX0RvMFSuWJscbUBK6iGFnjqTDSJsSE/0tuJaXVmnnYE4JXO1Dutm9gNFwxtDGkqYa7Na9f7A2xSkkMhtNRxDcvy4s3SFID4hyFRLGASk0MEAEsFPZVlvjFdGIQ3cHFF/vOs/p5ZZS9pT9vHPlTWIAHw8ptqEzFb6QEbwSuX/KOaZwNsRUNN6PRgk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(136003)(396003)(39860400002)(366004)(346002)(451199018)(2906002)(6666004)(31686004)(8936002)(7416002)(41300700001)(66946007)(66556008)(4326008)(6916009)(66476007)(8676002)(5660300002)(316002)(54906003)(83380400001)(6506007)(478600001)(6486002)(26005)(186003)(36756003)(6512007)(86362001)(2616005)(82960400001)(31696002)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RGRWT0ZVc3JBYUlxdExMRG5GQ2VTV1NzLzRmMmV2WHptU1Z4Vis5ZktwbVR2?=
 =?utf-8?B?a3N0bnV3VzdTVHlQckxWbnVKZnpQdnlOS0lrN09leWwzTGp0NGVqY1ZiQVBQ?=
 =?utf-8?B?VDhxYkloQ1U1KzRZTExQVndoOFVBUkVIVWlmZk9GcGJxTGFJdjRsMExDU3hz?=
 =?utf-8?B?UEpvanMreFNkNGNvODl3MVBHNVFPVC9WUVFSbEtNek5YWHF1cnlORGMreEJM?=
 =?utf-8?B?cHRXVm1TbWlyckxCZWtVc0RlbUkwak1ZNlFLUW9zV0hKYTJ4d2hrN3lMN0RH?=
 =?utf-8?B?dlhickJNaERidFRKTFZiaWorU1h3VVhscXdoNXg0S1VHQk1ObDJuaGhldjZz?=
 =?utf-8?B?YmVoVHR3WFNBVmJSb3J4Mnk2c3FWYXVrRjN3dHhieU9PcFAyQlpLU2cybnlC?=
 =?utf-8?B?cUg2OStnZU1ocXBPaG5teU5NdmFTT3B5WGtiZ3RoRHFhSnNaOXJiWjdIMHdK?=
 =?utf-8?B?NEw2Vm5lSEVYTXpPWDlFTlJVM2pVUnlMa3hTZVB6UlVoZUYrYWRoRndJajJj?=
 =?utf-8?B?d0owT1dtQXlhZnJEUTJoZUo0OElJUGtRNlZ5OTd5L0Nac2FWWWU2OFlVOU5P?=
 =?utf-8?B?MnFPNnk1SGN2R0NpNUEzR0E0ZlNJaGFzRExiWm5uSlpPNlJsblhoREZPM2xZ?=
 =?utf-8?B?cFQwQXJENVFIVXg3YVBIMEZzajlYc2dSUStlYkUvKzFvNFFqZDN6K3VhdklG?=
 =?utf-8?B?T0NWSElSQmJ5UlVMeitUaW9oWlVScFpXWHhPN3ZnbGc1TVRzV0hndEd4Rkti?=
 =?utf-8?B?eHk0eVJJUjVuMGlaU3IwQ3dGeGM3bVBnd09TckRueHRFSWpNakk3RjhLZVBo?=
 =?utf-8?B?aFFOZmI2QTdRQ1NFbmMvaVJhRUNzeGNHSDBVZW8xeWYwYldRUEVjaTRuc3hX?=
 =?utf-8?B?NkFuL3FjUC9odnowZVRHZFp5eUc5ZDNpQlNaYWV5eU5hUkF5QXJuTGI4djBz?=
 =?utf-8?B?MCt6Y3dTWlhuWVZqL1ZrWVdIODRnNTdwbDBBTzJhWVh1M0lEa0V2WDJvc2I0?=
 =?utf-8?B?eTFRUk9FQUVCVnRVUENCVTV2Q01WaXNXaHU3bk8rb1hZQ0VPQWRGUjRKS1Iv?=
 =?utf-8?B?UEFOWWI5SjJPM3gxVVZWUDhDY2hBSk1RTFhsM0k2OWxXSXJGUnJpYkE2Sk9l?=
 =?utf-8?B?QmJ0Y3B1U2FYTFdjNHo2VXZHRVl3WjV5MEh2d1NGU0VxRENQUEJLbzJSbU5y?=
 =?utf-8?B?OHVPTDhlM2c1cHljUU5FOVp5UnNPWWx1YzBQN2xDN3JvdEd5b2tHTFZlWUlR?=
 =?utf-8?B?dXpTOUNFdllXZFpDRDdONzlrVG9Ua2xtS1NkREtmNlJ1Si9YaHJxTzcwdkZR?=
 =?utf-8?B?YjRjM05uZ1duY0JqYzdsU2RoYWRwcnhZRXVVTzBBNUdjZUthVjJhRXZCT2NO?=
 =?utf-8?B?Zkh1KzJrNG91bGdVWTFiZkVjaEMvRVFZZm4xZi9YT2pEK1ZoYlNkREV1UDEr?=
 =?utf-8?B?R3BZODNPWi9QcTVJMU1uZzhLQXhkeTRnUjR5M0JLQUhaNzVUY3dxeGpIclRF?=
 =?utf-8?B?eHB2SFFPVG5ORlRSU29UQk04bnVsTnpZK2Vpc09naWY1c2tQU0VuOEJheEwz?=
 =?utf-8?B?enFPTFNKdVJnNkVldlY5ZzNVY0JOUktLSCtXbXd4b2xEVHhDVDlxUFR3aFZ1?=
 =?utf-8?B?eTJxRjMyU2hSMXlVTExRM0dqZGRNNjZxWWpQRVdqZkJmVFpZZEpaMElYYWdu?=
 =?utf-8?B?VVFFNVF6NTlrSUtzWE1VNWR4YzA1NWRJRTBXYmxzZXFhamR5cE81ci9udERS?=
 =?utf-8?B?QVNacWVvM3NmWVU5UktiNVZPYjBCN3hxREU0Mit6aVBmT1ViVjFBVHRIVjUw?=
 =?utf-8?B?b05mVk82Q0U2Zk92NjB2Z1ZVK2FUODZXYldiTW9zRERkcjhKL3drbkNxVHNG?=
 =?utf-8?B?ZS9tMDl6N2UxalZxOXhmYUJiMUdlL3hXaWgxNExxa1ZMSnNNK3BEbHdYeWlx?=
 =?utf-8?B?RUdwMC9pUng4TjNVYnJML2pEWS9lRHUySURiWmRoMHZPUGdud245UzQ4SGp1?=
 =?utf-8?B?eFIvNGdKRXp1UFAwSU5ZbU1pTzJjb2ZSTlBoYy81eW1qZzlXalZubzFpcTJS?=
 =?utf-8?B?L0dQUldEbWdCYWJJU3UvdVB5VGswM05hcmNXSkVvZWpIMTZrd2h5TXNqamRM?=
 =?utf-8?B?ckJsWWIwMGZ6THpwV215alJtVUxZeU9zS3lzWmZsQnBtRjZxeFpFVEpzWi9Y?=
 =?utf-8?B?L0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 98ab2dc4-7d12-4688-5f0e-08db0eb01f66
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2023 17:23:01.0486
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zQNqfY15GwvQxpOx47Hvxez38FZi0JKmr2TNvH6yL4EdVBjqYRaOzwvNRGSTb1ef6fWaZA9ki7vJvFqcDzxIoomEMI3WZ2DPAnDWP2zAMNE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4705
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@kernel.org>
Date: Tue, 14 Feb 2023 14:20:21 +0100

> From: Arnd Bergmann <arnd@arndb.de>
> 
> gcc-9 triggers a false-postive warning in ieee80211_mlo_multicast_tx()
> for u32_encode_bits(ffs(links) - 1, ...), since ffs() can return zero
> on an empty bitmask, and the negative argument to u32_encode_bits()
> is then out of range:
> 
> In file included from include/linux/ieee80211.h:21,
>                  from include/net/cfg80211.h:23,
>                  from net/mac80211/tx.c:23:
> In function 'u32_encode_bits',
>     inlined from 'ieee80211_mlo_multicast_tx' at net/mac80211/tx.c:4437:17,
>     inlined from 'ieee80211_subif_start_xmit' at net/mac80211/tx.c:4485:3:
> include/linux/bitfield.h:177:3: error: call to '__field_overflow' declared with attribute error: value doesn't fit into mask
>   177 |   __field_overflow();     \
>       |   ^~~~~~~~~~~~~~~~~~
> include/linux/bitfield.h:197:2: note: in expansion of macro '____MAKE_OP'
>   197 |  ____MAKE_OP(u##size,u##size,,)
>       |  ^~~~~~~~~~~
> include/linux/bitfield.h:200:1: note: in expansion of macro '__MAKE_OP'
>   200 | __MAKE_OP(32)
>       | ^~~~~~~~~
> 
> Newer compiler versions do not cause problems with the zero argument
> because they do not consider this a __builtin_constant_p().
> It's also harmless since the hweight16() check already guarantees
> that this cannot be 0.
> 
> Replace the ffs() with an equivalent find_first_bit() check that
> matches the later for_each_set_bit() style and avoids the warning.
> 
> Fixes: 963d0e8d08d9 ("wifi: mac80211: optionally implement MLO multicast TX")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  net/mac80211/tx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> index defe97a31724..118648af979c 100644
> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -4434,7 +4434,7 @@ static void ieee80211_mlo_multicast_tx(struct net_device *dev,
>  	u32 ctrl_flags = IEEE80211_TX_CTRL_MCAST_MLO_FIRST_TX;
>  
>  	if (hweight16(links) == 1) {
> -		ctrl_flags |= u32_encode_bits(ffs(links) - 1,
> +		ctrl_flags |= u32_encode_bits(find_first_bit(&links, 16) - 1,

Uff, IIRC find_first_bit() matches __ffs() calling convention, not ffs()
one. They're off-by-one from each other, which means you need to drop
this `- 1`.
As this branch happens only when hweight is 1 => @links has a bit set,
it's safe to just use __ffs() here directly, but up to you.
find_first_bit() is fine, too, since it will be optimized out to __ffs()
at the end in this case.

>  					      IEEE80211_TX_CTRL_MLO_LINK);
>  
>  		__ieee80211_subif_start_xmit(skb, sdata->dev, 0, ctrl_flags,
Thanks,
Olek
