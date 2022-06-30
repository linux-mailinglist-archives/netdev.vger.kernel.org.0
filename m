Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B96B2561FC5
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 17:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236241AbiF3P4i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 11:56:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236237AbiF3P4g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 11:56:36 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80040.outbound.protection.outlook.com [40.107.8.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 455FB3B294;
        Thu, 30 Jun 2022 08:56:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b9e4bJBkZMYL3e6KMMOqMPQe4VZj+2fzyTZTDLT4WXFp5p807WpYDG+QSaNh+rbndiFsA27Rz5qEAqC/A9060hwbuPDpMH3QMovtbdwn1rBAbmnP3xPsHDvaw6sbF8hDq3u89WnHcaB+kWvyOMjurbnNkkQpiiEGPXZTvYIktyUyuXuKBeslKANM0RWyXWVNpxqa4TYZ3t7f6CeE0qP1A7Dt+K+94by2iTPq8FTr0zeW/H4UWgqRQr+s/sLgl6feOJ7r33RzS1rtMO3npVIs/IWATJfTBX2BpISOGQdZRVU1xp5u3oILIbDzd6aj78BMn6n9WU9iDt940BM07dMF0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WZAH148o2Zry9k6//GXiYBs/Ww1oJJSyfe35kXtedAI=;
 b=kXlrO30vUTSTP4DOzK/VEgGLGhCQU5DjZtxZpeD2Br7gmfXhrg66a6WEnGqC4gN0ZxwvM3JobPS36RxXWrOESC7LFwNh2siV0ZV0kATXD1ns7KskJGT1vGliDF3uigc6Zjttp0afC/Ho0IjbmTf1q4HIrjxVVDklGai5caSsS0FzAmjJehcDq6Lnh8XY/aHazixeRfQaiMsVbkYoYxQBcP2hLf5FBiG4TWDfbb+hvK84yp3AlojCstusdqa1KZB3sY3GyqNhPJDfBm0mGlcnOa6n9xzlPlfd2FdbCYoIlTxG0FyDtgERfLRJMOrkxvx+vBWTfT3kkUixEaNYEhDGKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WZAH148o2Zry9k6//GXiYBs/Ww1oJJSyfe35kXtedAI=;
 b=f0NaEpZoQDqRerDAwnPZ8hPW20z76ZMGptFZgrB3JKDVO9UxNHNiZoxfx/XnembhtvBghFEdUnEmXT8UnbwsrZ4Qa3f+3j+he6eX9cQX7k/ethUYLrbi48WcUt/QcKKrSjP9weEEko2JyCO001gwmWMWII/eCAedOMFVwoJ3TpOxLfjCagFIxPhj8ILUg2/gWFJf3F2YkwjURyA2OuPsvW91/GMUYgpjpt557DOK63WDPNE/ltRCTOQENeJ3xERDOpwcEdH/zcBIAQOnVkT7t/KLfWh3tD1noJ+l8TNQjv8nakJS4PPE3OUshCDWmhkJ1MJJUs8HMmv3ogFjeKgzPw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com (2603:10a6:803:c5::12)
 by AM6PR03MB5861.eurprd03.prod.outlook.com (2603:10a6:20b:e2::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Thu, 30 Jun
 2022 15:56:33 +0000
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::40:718d:349b:b3bb]) by VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::40:718d:349b:b3bb%7]) with mapi id 15.20.5395.014; Thu, 30 Jun 2022
 15:56:32 +0000
Subject: Re: [PATCH net-next v2 31/35] [RFT] net: dpaa: Convert to phylink
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        linux-arm-kernel@lists.infradead.org,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org
References: <20220628221404.1444200-1-sean.anderson@seco.com>
 <20220628221404.1444200-32-sean.anderson@seco.com>
 <YrxlS7wvgUtg9+y0@shell.armlinux.org.uk>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <c219be52-a847-6f9a-5c1e-e46f1578eccd@seco.com>
Date:   Thu, 30 Jun 2022 11:56:27 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <YrxlS7wvgUtg9+y0@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0004.namprd13.prod.outlook.com
 (2603:10b6:208:256::9) To VI1PR03MB4973.eurprd03.prod.outlook.com
 (2603:10a6:803:c5::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7c6a5a43-e86d-4075-3709-08da5ab11a96
X-MS-TrafficTypeDiagnostic: AM6PR03MB5861:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i2QsfCFy0HHMhgYTflcCwSnl4iRiuJnz8tKqKUjmhjOuOK7k4HNgSusJNJLsCkEXj6puZFQo/6Tj5yYkA/KG0J1WQ1z/lBR4tH2+hAHluTIc6p1tC9LVT4dXNa/qsRrJzw2EfspAZEjEpiZivZqBG81+q1cptpLpusXmMwQFGdM4YtwkNKsOFtPJr2lOC96VK1GdZwanl2ZCkU/0ChIrnLq67F5tzNBfRKLe07NITmGSx9P+MYR8wFATg+El5fcjXFzsmdy9Ib94RTNwMA5kotuwhkEEal8L8AM+ZFXlP6RRS18uLKMq+zEbavqLzLdi2K0YEr3IHQ1ndSWQ+p9s+YUjtcGth3caSMhuNuJAwGcyUxhaEkG7cTmlZmHv1eb6TlvNYBgpv+mZMexOWXO3ujFv29fDCuqHXGmopTdIZMHnkVULafAA+7+dpT2/dkCy12+0eQtEqHG80DMuVUm5mqodXGNKyOIFxGdxANlXL3tMTHr0Af39EucEIid6VpVOtAslwX9CIeWxOzmAhsfVpXSwwt0KhZc4/mFppKQduPc8qsTj+1jsmsjOX1/yeVzWOlicbKlUYcDBMKO+PmwDk/hRQl1st5Q6fbvxcJhwxN1SNPS86LRiKeGOXLKrblic6qwFYKHREBaMq7GB6xQaJlSd0AtAzrn0v1pqO7kp/JjSnnAK3XnAnGgNrVUQh5ZG/6XxNssyaVnpZaCrU7RbeRxmgi3Kvk9YdPFRPCLqDy5Yj/uX7fhxbsBTudqTu8vf+5qLG84N2/wWKvAcexywiC2ih63PchThgjEPaxWDE00D2VHltUqtIFWoilStHWEsJuFayiFKhKao5iDjcCBf5+ObsmOmrijSYjNGK9BkAA5G7YnvkGSGbidP+Y99Dv2e
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB4973.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(136003)(376002)(346002)(39850400004)(396003)(53546011)(2616005)(52116002)(6512007)(38100700002)(5660300002)(186003)(38350700002)(6506007)(26005)(83380400001)(2906002)(8936002)(44832011)(66946007)(4326008)(6486002)(41300700001)(6666004)(66476007)(6916009)(54906003)(316002)(66556008)(31696002)(8676002)(31686004)(86362001)(478600001)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QzFkNHE1cm5NWFRNQ09oRFB5dzk4bXN1Si9CdmgyTjlQTDV0d0wxRmRQemt5?=
 =?utf-8?B?SVlaSWgxeXRIS012YSs2L21lUjF5SjFPRHZXek00K3RGaktySXR0RUNyNGJ0?=
 =?utf-8?B?UkdyUnR2MGovaVlWSVNCNWo1K2wwQklMdTNMRjM1L1FaUnFGbDI0d1Z4QkJo?=
 =?utf-8?B?MlgxYjVJRmZ1VEE0WFM1dG1mVmE3M3VNeDJhNVNyTlBncnBCdnZzeFRXcVJX?=
 =?utf-8?B?WE1rbU1FcVowc25KMmtJL3JZM1VUT3UyMXJVYXBydnlXYTZoZjNhOGVCZitW?=
 =?utf-8?B?VlJZSHB3VVlRQzNBZjRuYzQvKzZxdWJzeldPcVl5TndUOTcybnRpSjVMVDZY?=
 =?utf-8?B?emc0ZDI5QnhQK25IVFFXVVFNRmRTVm9OS2VETG1HQ05NOUNNVlVCWFBoenJJ?=
 =?utf-8?B?VDJpaHppUXhVUE1QcmJWbG9nQnc1SDZ6NzdPcGRlTWtIbnhVUW0xUFBzcStv?=
 =?utf-8?B?V01nZlhRV3VYNDNyYUJJREZsYVJ4a1ZEZUpFc0I3VHlZVTZ3R1l1N0Z1WFNL?=
 =?utf-8?B?QnhDTjhiOFp5U0NNWTg5d0I4eEhHSlo0aU9LbnNhbmlBVC9CUzBvRTFFYjBD?=
 =?utf-8?B?ZXQzNlF2cGlTeWhweEo0YmN2UnU1U21na216MjV0aVc5ZXB3c1NqYkJlRGdu?=
 =?utf-8?B?WjRqRU9wV0E4TWhvSG5Hd3ZkMlNxNGJqMXZPZVRKeTVDeHJQS3pNMW1BclNP?=
 =?utf-8?B?elpVRkhQQVBTbXRtL0w1N0tvWTdqZkhTTWVUbHlod1NSRkpVSDNzRW95cEQz?=
 =?utf-8?B?V0pvWmVHeXpiUkt6bW0wc0FpYmhhMGx5d1F2TnpobnZleUdMUENXUFI2K0JZ?=
 =?utf-8?B?WUQ0bFNFTTVWOExxUnRLeGNVa3hhc0dYUEg5UnhZOTRYTmdzR0hVZVROM3Y3?=
 =?utf-8?B?Tkt1aUdRQzN4WmlzckZPMTIxMDIwSFZLeU5rY2xlMmxoTThpQ255ZnQ2Syts?=
 =?utf-8?B?T2lPK1FyQ0J0cVpGeEE5REhBbzV3VHdzU3BvUmxTSDRtNkh5aVlnYjFHbm1y?=
 =?utf-8?B?eHNMaDF6cm9WbCsxNjd4QVcxODYyN21iSVdMc3ROMzFGaVNIR1Q5bjJiVUxn?=
 =?utf-8?B?UWhVRzB4YkVIL1FIL01Sc1BMd2h2YXFvWGxPZDJ3YUpHZGNVbWVxS1RoRmRq?=
 =?utf-8?B?ZTl0MG81WUhONnoweUJJaXdSK0NNZE1OWkJ4VWgrbkNOQ0RvK1VlbEo1Mkdw?=
 =?utf-8?B?MkMzSjU2ZmlnMG54b2k4b01Tbis4aklKeWxjaTRJRGtyZTVvNWkxRGRiSkJG?=
 =?utf-8?B?Q1I5VXMydXRkdFQxMDM3MHp1Smd5UndmbDlwMjM5ZSt1MzUxMUxOYUowdGp3?=
 =?utf-8?B?OXo4OGJBc1AweWUxRllFdHcxeGN1ellwZW42K3B2YVM0Q2Y0enNibGpQc0E5?=
 =?utf-8?B?S3RhZUYycmRqRWRmSnBwVHdaSG9KTm1QaG1oTHBlSU51ZS83UlBGYlBGb010?=
 =?utf-8?B?K0N1b25XSWdPVjhEa284T0lhbmhNd2ZkL3dEQ3A5RjMrbGRVT1dNclNwWlZM?=
 =?utf-8?B?MnQ2YitDZGZpekNGK2puNXl3alNSTzJOL3QwNmhDOTZRaHFCVFlHVzhZMU5k?=
 =?utf-8?B?SnBpbGwxRml4ZWU5MHFYenJpZ21ORW8wVEZTdElJK0YzN1NkZnM3QXBhdU90?=
 =?utf-8?B?NXU1Mzc5RGxZWENBNFRDdCt6dmpmYzRieFVvelJYbytLNzNxbG5tSGlLRkhF?=
 =?utf-8?B?NjFMbm9SM3pKWUdoTW55VitLTlFsaWVhTFMzdlU1TlExajJ0MTAyYVlTOGY3?=
 =?utf-8?B?Yld6VVNMRG1kVVBiY2k3aXY0czFsTWJKZllOOERZZE5SR3d4ajNybnFYeWVP?=
 =?utf-8?B?bTQxNnRoRnhaSU80QXZMaUMyQ2lkcjgxcHROa3RMUkR6a0JPOHBJTzR0OEpX?=
 =?utf-8?B?a1RrdkJUcXVLR28rNitVREpXdDBiY2wrbXgzbDE2RElmZlR4OXBLcGpDakNO?=
 =?utf-8?B?WVEzQitUWldQTXZVa2ZrY1RyUmlFMXVxRHY5N0ZVNFBFcE54R1pOZUY2MXhP?=
 =?utf-8?B?aFc4enhPTXhkajNidFdrN05VU3FBYVQ0THg3NEJaaFc0dDhFQzNkYXQ0NzBh?=
 =?utf-8?B?UGdMcjdCS2s1NDF3a3ZEbXIzSVY5NHV0ZVJuVUpLR2NLOEduaGRQWEVNeXVB?=
 =?utf-8?B?YnVxY0JMTzYyd1JYbEZZWG04M3ZYUjNUKy9ibUE1R0VlM2R5UEFVSUxJamVt?=
 =?utf-8?B?a0E9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c6a5a43-e86d-4075-3709-08da5ab11a96
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB4973.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2022 15:56:32.9047
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wC8INIAsIyAZwhWEAxjfZ38MgAWSZt/J5pyQzL2ZAYE0mww+diSayMO4VKuPCKrrsKq9R2VlEu9GLf43ke3mxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR03MB5861
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

On 6/29/22 10:44 AM, Russell King (Oracle) wrote:
> On Tue, Jun 28, 2022 at 06:14:00PM -0400, Sean Anderson wrote:
>> +static void dtsec_mac_config(struct phylink_config *config, unsigned int mode,
>> +			     const struct phylink_link_state *state)
>> +{
>> +	struct mac_device *mac_dev = fman_config_to_mac(config);
>> +	struct dtsec_regs __iomem *regs = mac_dev->fman_mac->regs;
>> +	u32 tmp;
>> +
>> +	switch (state->interface) {
>> +	case PHY_INTERFACE_MODE_RMII:
>> +		tmp = DTSEC_ECNTRL_RMM;
>> +		break;
>> +	case PHY_INTERFACE_MODE_RGMII:
>> +	case PHY_INTERFACE_MODE_RGMII_ID:
>> +	case PHY_INTERFACE_MODE_RGMII_RXID:
>> +	case PHY_INTERFACE_MODE_RGMII_TXID:
>> +		tmp = DTSEC_ECNTRL_GMIIM | DTSEC_ECNTRL_RPM;
>> +		break;
>> +	case PHY_INTERFACE_MODE_SGMII:
>> +	case PHY_INTERFACE_MODE_1000BASEX:
>> +	case PHY_INTERFACE_MODE_2500BASEX:
>> +		tmp = DTSEC_ECNTRL_TBIM | DTSEC_ECNTRL_SGMIIM;
>> +		break;
>> +	default:
>> +		dev_warn(mac_dev->dev, "cannot configure dTSEC for %s\n",
>> +			 phy_modes(state->interface));
>> +	}
>> +
>> +	if (state->speed == SPEED_100)
>> +		tmp |= DTSEC_ECNTRL_R100M;
> 
> Please do not refer to state->speed here, it is meaningless. What are
> you trying to achieve here?

Well, it's part of ECNTRL, so I figured I might as well set it all at once.

> It looks like the old dtsec_adjust_link() used to set/clear this when
> the link comes up - so can it be moved to dtsec_link_up() ?

Sure.

---

I forgot to mention this in the commit description, but I touched on this
in our previous discussion: do you have a suggestion for the Aquantia stuff
in dpaa_phy_init? There's no direct access to the phy any more, so it's
harder to bodge it and say "we must enable flow control for this phy".

--Sean
