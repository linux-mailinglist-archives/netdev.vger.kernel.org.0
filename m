Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA34357CFF8
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 17:42:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233081AbiGUPmM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 11:42:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233391AbiGUPlZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 11:41:25 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60042.outbound.protection.outlook.com [40.107.6.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3DA6186F6;
        Thu, 21 Jul 2022 08:38:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i24Cds7m11uvEh/Y5j9FaCILIFpyZzWJ9k03p1ncz6pUwSZVdVNiG/ofYGNwY39XbQoPZjXCzYaikoUy7PNgNs1qkDDZ+7URhsL8zyU2BFtMEYhK92yjuLw3+/fteXmpd/vgRsElt2fnzxEIT8qX60kTWu9c9Qx2H9FUCatAE5iRKQGbwSjQN7mV/cNJQbbEqthnK5SyEqocv+0IXslVt55UjaJgWYdgNnvanU+tA1XsF7MnvqV2TzoTd9aeBcdNurm1j0A8IldNslWqZgfE4aLsxaMfXTRLq9BCkWFF2GWTTMFoj+h5e4eMexvv8R74Ka7hMZLCA+cFw6yilKMCVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ij/vc3U4HkmzDVk/lqea68d+sZfeEA/ia+YbQCg46rQ=;
 b=dXwhiZ8pjV8kxgPoYKgpPy6bRyVorNpOUfsgNi80fjVkrKwYqCPlJBJfr6bLTij6kT7i+bOLOytxnk533N62hIcobBXUlxbBF7K9/NKOWxFVcJFc9CyxCrHRJ5OB7V09VIcDl4Frbj2l6488Hvv2X9smLWcGVav426J1msUaqly/4zdAy3Lb0uvC5W6EyRsdgLPS2KosCv09ZXJJOTUF/PbktAxf5auxRtUETbcLSwSxGMnCTd2kAjdsm3kiOa1iCP+zp7w+pkYactsXc4jupHsh3+VzlAcGNriq45zqP1qa7A5xdybqSAG0I7LDcz2E5Cm9utOPlg3C3v9eJ/Q36w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ij/vc3U4HkmzDVk/lqea68d+sZfeEA/ia+YbQCg46rQ=;
 b=YMU2pWB2otAFY7FwJtGtnx+yDNqvjJOyatjSJOF2Am8zkwMbWF4FnfZM7hcVReA/BDKvO2SkcjzZontYjGtLopsPrp3Zctt80V1ClMPWYdhDq2FbzAG8pWUo1Pmm7f7mh2zwTX143XIvfzSP/x3b4zbskSxUcyWLNEQblQZKPmUEUoyoCjj2uu+08zCyGmGtHdETUOqSPVrtoVmQcy9m6tlpkreTQGaDB1SmYIDlEH7oCZ+8bwHpFUVxNURSXYCB5gP7sPCqp0SC/UlOrg6y8sk9e/GLh4uJxhqGMvANTNH0kTnSSCNXQgARdVShqsyEb2IrlBHA9FZoLcSs2dJSZg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by VI1PR0302MB3280.eurprd03.prod.outlook.com (2603:10a6:803:21::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Thu, 21 Jul
 2022 15:38:10 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b%4]) with mapi id 15.20.5458.018; Thu, 21 Jul 2022
 15:38:10 +0000
Subject: Re: [PATCH net-next v3 39/47] net: fman: memac: Add serdes support
To:     Camelia Alexandra Groza <camelia.groza@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@armlinux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
 <20220715215954.1449214-40-sean.anderson@seco.com>
 <VI1PR04MB58071192E279070C90F81843F2919@VI1PR04MB5807.eurprd04.prod.outlook.com>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <ecc9051b-63dc-131b-9f87-138af7dc88aa@seco.com>
Date:   Thu, 21 Jul 2022 11:38:06 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <VI1PR04MB58071192E279070C90F81843F2919@VI1PR04MB5807.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR02CA0012.namprd02.prod.outlook.com
 (2603:10b6:207:3c::25) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 22030dd9-69b8-45a3-579b-08da6b2f03fc
X-MS-TrafficTypeDiagnostic: VI1PR0302MB3280:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2oI3nFVeLeC7APm+MW/adA5vpUmxcoC0Gk7yWM8ClLJOnyJFHCbdhnym6thIt/2wJO7y7FJ2MuhCKfFbf7r+7RdpC/avQoG037tHGp17PQNyAFb3IHhm8p9lxDLJcQvSDiIGGxG+uhYlvtjs3rIO20jBTzva3+Sqye1apHJcXbeozJFdeITskAlR7zjP1QmG2aMQ8PKHISy0RyhTiUeldVqQLqcqqbNeDrxWsKN+VmMRpv2GAyjgbnmj0Dxlx90JAT7evJdUyclMHphrODdWiEXcPU/ZgcXQroCR/o2myOK5CgfndWNBeUvltIloFBaZeR9x+w22xist0JOjyzEZvO2juTTVNYqJYAoPY3H82p5/WmKpOh/oFe7R3RusraEiDUA/8oy6Y/TySiTUbLU6vNXAIeGLW6yXYj8bnHfJK+CqPq0bINbcZQKIptebEfnH6guChIiuq5/qe5zJ5mY7/vGDMyuYSEm8DuRZASalvidH/QyD3jYiERSnZaTxcImaTNAFxQ09cIWFkPLXkySUkN8JHYGWKTf0WA8a9ryfI+yIb8HzOnSpLGEO2nNlMT4AssSulAxskhSta3J6/n368rUU9m7NIaOvWwG8cdF5ndQlR5HUgzKdEBZDUtT2cA7TCE7YCfeMzjyXUABX+EzlD743q0QZnLPihfzgDaQWX3VZ44DcTTFGWZHWRgVzkMVLrAUCPtghxWwHfg2PWkyTkDTnC5XRLY8TKpD6H6IvSE1k5LAFLIC2z4I/Xtp3n4cGMzL42Adw2KzBG9xwsUgIvuWP3ICxTGQ1nAgjTxWU0wzqcP64yHPbI7G+HhWomHtr+XoLp+nTeeeCa1H15dAOFLjxMp66galYqkmhmmT6NwY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(366004)(396003)(39850400004)(376002)(136003)(38350700002)(6506007)(52116002)(36756003)(53546011)(8936002)(5660300002)(44832011)(6486002)(316002)(26005)(31686004)(478600001)(2616005)(41300700001)(6666004)(6512007)(31696002)(86362001)(83380400001)(186003)(2906002)(110136005)(66556008)(66476007)(8676002)(66946007)(4326008)(38100700002)(54906003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YldETEk4SVh4K29jb0ZhTXFiaGY1WGtxS2dkRmMwcXp4VTlRVEttMWV3RHRz?=
 =?utf-8?B?cTI0azUwRnZhbThjR21UbEsxR2NKbFhOR2ZrZGZmQXgrRklCZ203OUhNWEpE?=
 =?utf-8?B?emVCMkVveVU3Qnd0bkptZHpWNnc4MUtwOTdWZlBSbzk0U0pSanhHZjFSS0pO?=
 =?utf-8?B?eDZTZFYrY29SZ2dBdXNsbGF5bk9QN0pGMk1uS3cwZTRqUGZZbUQwUmZkQXFG?=
 =?utf-8?B?ZzVaZzdPbmMzVUJTVFRCQlo1RjViclJZWVhkbmJhTWcrK2tVNmlqYllYZW5X?=
 =?utf-8?B?Qy92alVTamNOeEhPTzg1UVdjOVg4aDdrOFE3SFhDMXhqSWlMVStXdk5FeHls?=
 =?utf-8?B?ZDdvK1A1d3dCWElhNWJmYXlwU1FucjNFbGNwVG91NjBLalZ1L2RjeVNNLzc5?=
 =?utf-8?B?cnhhelBEY2hyWnVqZjFRdDNPWHM0ZitYcFJwTFZBeWFKRGhhODJ2MkpkRjB5?=
 =?utf-8?B?V3FRSGloeW80T1hQSWNYY1RDaDNSbnlSQkNXVjNvM3h3S0Q4UnhET00wM2Rh?=
 =?utf-8?B?MDhoSkhXYUhVRUxDR2ZleUFoVW4yVWNhOXR4ZnA0emdXS015VzR2S0UyUnkz?=
 =?utf-8?B?YnlyeUdqSVdwRVE1b0VPbUd0dFF1WU1rNHBTZmh4aGM4T0dsZE16SEJ2NkQ4?=
 =?utf-8?B?elJ1SVBwYnluRlBpVFYwQnRIR01hQjZFYzJjZy8yc292NTc5MDBlMlFUM1FK?=
 =?utf-8?B?eElKc0VHbi9OMis3V09QdktEaWZiYVpmT3hsbkwvL1d6QndWNjRiSDAvZFlP?=
 =?utf-8?B?aXhzSGlqbWdTYmRLcGp3STdWUkpMLy9nYXpvRGlKS3V2TUFUeWliNk9NbEs4?=
 =?utf-8?B?QUExUTljU0RNMnFXYTdqMWY2NVB5YklPK0JtKzN3dVRTS3lWVEN2MndyamJB?=
 =?utf-8?B?YjFLUy80QW9JTTZzaFhlcjR2VytDTGx2TnFKYlYwdlFzbDRmQTgzdy9XRFNt?=
 =?utf-8?B?NmtTVkRWbHNXMDZpYWFXb3c0YUpRd29DQjA2S0pyZ2w5MGFTZlE1cE8zYm5H?=
 =?utf-8?B?MkQ4eGNZeHB1c0pjM2gwUWFJTjhUVnFJc0o2M3hYYlpzdCsvcnV4L0g0MGRs?=
 =?utf-8?B?Wk91czlISmFPZ0xSYXhabnl6dXhnNGZCdEJtdTNybzM5UzUwekl0dFNBWDUx?=
 =?utf-8?B?WXM4S1AwYmhRQWk1T3dPbEVCYkZSNlc0VTdDZ2pkWExHenliUldjczA5UGk0?=
 =?utf-8?B?bEpHdUxmbkdMVXhvbVA3SDNTWVNUdHhFcDk0SUxPcWJGc0xpbDZmQ3ZCTkNI?=
 =?utf-8?B?dzNQUHowNkhqVWs1NjY1bWRxRnVyOHNjRjZjUmdCdTI1TzBvdnFQZS9FQzN5?=
 =?utf-8?B?bm1tREYrRUl6bHNzejZDdjRkM0hMdWtNaVM2bzVwZGc4NGhCVFRSSG9GdUkr?=
 =?utf-8?B?KzVlUG5JVUt0ek10Z2hPMmhKYW13UkgxWjlMc0FhTThSbjVTa1lDckFXMVZx?=
 =?utf-8?B?RUFST0wvZEFIY1MzdjZaNFhnampPcTJ1VFRqMW90MUdyMkZDbDRMSVhjL0dJ?=
 =?utf-8?B?UndBMTU3VEdGaFFQdFNIN2c0aVAvblplemhWd28xeFJuU3IwTFpmSkJyd3FY?=
 =?utf-8?B?VHpqSEJxaVJhc2FwQlNaNTdCZkx0T3owSGRDaWU4eHV4OXlMdmR0eDNXQzFF?=
 =?utf-8?B?a1ArdlJCRkRFNWk4Wi9RSGN2OVNBSXcwSnVCejM2L1dLM0ZWYzNyR2g3YXJq?=
 =?utf-8?B?eFpWRm5DMVFjaFpZdUd4UEtXNXp3elBsRkQ2cU56VnlnemQ2d20xYmtrbE5a?=
 =?utf-8?B?VXhFNDhLODJBRXF5RmZJdkp0blIwUmRZdS9mNHo1d1hsMndMek9Ibi9tSHFN?=
 =?utf-8?B?RjNaNWNPRVRydGtZTHZualVWYXNnc2ppbkxhNzRKd2wzRTRvcmtWbXZwU1U3?=
 =?utf-8?B?Z2dkbWswWVg2eHR1T2Y4TFJ1N1dnYXdyUmpxc21WYWY5RWpNN21uN3Q0UUxS?=
 =?utf-8?B?VllZWmNRamZYZC9DMXNKWFlNTHByUDlzbHdvcndQR1k2L0dOQ29Xam5VcVNa?=
 =?utf-8?B?V251WGp2TjB1RG1VSGRLaUtja3Y2NWxQdkFRNUpTaEVUQThnVUUwVmlva29M?=
 =?utf-8?B?V0hQdDNYeU4zWTNKZHFhTGhGbEQwaEV0OHhib0cyc0NYb3lab0M0Z1UrRnI4?=
 =?utf-8?B?Q01xaEY3ZVpIQ3lYdkFuRkEyNjAxN0U3NHpmc2N2VDNxOXVKQ040a0xvSzZZ?=
 =?utf-8?B?WEE9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22030dd9-69b8-45a3-579b-08da6b2f03fc
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2022 15:38:10.7412
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vHK6PSsZNIt8kvEqJDsoD7s1G6deVEprd7KI2sVtXTKYdkvamJ0OVKPSBPvpGlWveeXEhwI72FOpgyJk3vRdTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0302MB3280
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/21/22 9:30 AM, Camelia Alexandra Groza wrote:
>> -----Original Message-----
>> From: Sean Anderson <sean.anderson@seco.com>
>> Sent: Saturday, July 16, 2022 1:00
>> To: David S . Miller <davem@davemloft.net>; Jakub Kicinski
>> <kuba@kernel.org>; Madalin Bucur <madalin.bucur@nxp.com>;
>> netdev@vger.kernel.org
>> Cc: Paolo Abeni <pabeni@redhat.com>; Eric Dumazet
>> <edumazet@google.com>; linux-arm-kernel@lists.infradead.org; Russell
>> King <linux@armlinux.org.uk>; linux-kernel@vger.kernel.org; Sean Anderson
>> <sean.anderson@seco.com>
>> Subject: [PATCH net-next v3 39/47] net: fman: memac: Add serdes support
>> 
>> This adds support for using a serdes which has to be configured. This is
>> primarly in preparation for the next commit, which will then change the
>> serdes mode dynamically.
>> 
>> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
>> ---
>> 
>> (no changes since v1)
>> 
>>  .../net/ethernet/freescale/fman/fman_memac.c  | 48
>> ++++++++++++++++++-
>>  1 file changed, 46 insertions(+), 2 deletions(-)
>> 
>> diff --git a/drivers/net/ethernet/freescale/fman/fman_memac.c
>> b/drivers/net/ethernet/freescale/fman/fman_memac.c
>> index 02b3a0a2d5d1..a62fe860b1d0 100644
>> --- a/drivers/net/ethernet/freescale/fman/fman_memac.c
>> +++ b/drivers/net/ethernet/freescale/fman/fman_memac.c
>> @@ -13,6 +13,7 @@
>>  #include <linux/io.h>
>>  #include <linux/phy.h>
>>  #include <linux/phy_fixed.h>
>> +#include <linux/phy/phy.h>
>>  #include <linux/of_mdio.h>
>> 
>>  /* PCS registers */
>> @@ -324,6 +325,7 @@ struct fman_mac {
>>  	void *fm;
>>  	struct fman_rev_info fm_rev_info;
>>  	bool basex_if;
>> +	struct phy *serdes;
>>  	struct phy_device *pcsphy;
>>  	bool allmulti_enabled;
>>  };
>> @@ -1203,17 +1205,55 @@ int memac_initialization(struct mac_device
>> *mac_dev,
>>  		}
>>  	}
>> 
>> +	memac->serdes = devm_of_phy_get(mac_dev->dev, mac_node,
>> "serdes");
> 
> devm_of_phy_get returns -ENOSYS on PPC builds because CONFIG_GENERIC_PHY isn't
> enabled by default. Please add a dependency.
> 
>> +	if (PTR_ERR(memac->serdes) == -ENODEV) {

I think it is better to add -ENOSYS to the condition here. That way,
the phy subsystem stays optional.

--Sean

>> +		memac->serdes = NULL;
>> +	} else if (IS_ERR(memac->serdes)) {
>> +		err = PTR_ERR(memac->serdes);
>> +		dev_err_probe(mac_dev->dev, err, "could not get
>> serdes\n");
>> +		goto _return_fm_mac_free;
>> +	} else {
>> +		err = phy_init(memac->serdes);
>> +		if (err) {
>> +			dev_err_probe(mac_dev->dev, err,
>> +				      "could not initialize serdes\n");
>> +			goto _return_fm_mac_free;
>> +		}
>> +
>> +		err = phy_power_on(memac->serdes);
>> +		if (err) {
>> +			dev_err_probe(mac_dev->dev, err,
>> +				      "could not power on serdes\n");
>> +			goto _return_phy_exit;
>> +		}
>> +
>> +		if (memac->phy_if == PHY_INTERFACE_MODE_SGMII ||
>> +		    memac->phy_if == PHY_INTERFACE_MODE_1000BASEX ||
>> +		    memac->phy_if == PHY_INTERFACE_MODE_2500BASEX ||
>> +		    memac->phy_if == PHY_INTERFACE_MODE_QSGMII ||
>> +		    memac->phy_if == PHY_INTERFACE_MODE_XGMII) {
>> +			err = phy_set_mode_ext(memac->serdes,
>> PHY_MODE_ETHERNET,
>> +					       memac->phy_if);
>> +			if (err) {
>> +				dev_err_probe(mac_dev->dev, err,
>> +					      "could not set serdes mode
>> to %s\n",
>> +					      phy_modes(memac->phy_if));
>> +				goto _return_phy_power_off;
>> +			}
>> +		}
>> +	}
>> +
>>  	if (!mac_dev->phy_node && of_phy_is_fixed_link(mac_node)) {
>>  		struct phy_device *phy;
>> 
>>  		err = of_phy_register_fixed_link(mac_node);
>>  		if (err)
>> -			goto _return_fm_mac_free;
>> +			goto _return_phy_power_off;
>> 
>>  		fixed_link = kzalloc(sizeof(*fixed_link), GFP_KERNEL);
>>  		if (!fixed_link) {
>>  			err = -ENOMEM;
>> -			goto _return_fm_mac_free;
>> +			goto _return_phy_power_off;
>>  		}
>> 
>>  		mac_dev->phy_node = of_node_get(mac_node);
>> @@ -1242,6 +1282,10 @@ int memac_initialization(struct mac_device
>> *mac_dev,
>> 
>>  	goto _return;
>> 
>> +_return_phy_power_off:
>> +	phy_power_off(memac->serdes);
>> +_return_phy_exit:
>> +	phy_exit(memac->serdes);
>>  _return_fixed_link_free:
>>  	kfree(fixed_link);
> 
> _return_fixed_link_free should execute before _return_phy_power_off and _return_phy_exit
> 
>>  _return_fm_mac_free:
>> --
>> 2.35.1.1320.gc452695387.dirty
> 
