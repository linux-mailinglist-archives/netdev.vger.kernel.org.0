Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97AEB437C09
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 19:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233757AbhJVRkC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 13:40:02 -0400
Received: from mail-eopbgr10088.outbound.protection.outlook.com ([40.107.1.88]:61121
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231893AbhJVRkC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 13:40:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iGHVlIVvQTUUjHSJqGk9okYPFWJlkuLDroGxrxUn0vgZg3p0TzJ7j0CiDETa/By77iNalWCRL3QSG1Nodu6fHx2wBA4DnH2Nf9aTUZHlZV1RtLeBBgJQRJPACSfD4+C4nP0BG9o9pNOAaKdIlMr6SsEHBDsLR74RgIGodFgbU8HRYkfFczUDRSA4FLrC/qkoPt31E/viXE+Vau4YPECRi5tkcLiZm9X5b0OGp3qOSLVn/pngjA5qNqhFDu6YD4PUYw9lPifaYc2+Cec8CCh6Q+1fvcbBi7hvTunl25sRBou2l1RjbJsXAmYZTaj1eVjlhDatNuWPXqcMDOLA86SwfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YPy9QMXnWRLwdxwQ/73OEX3NcbZZql9+NZuVZOfIa8E=;
 b=by/iB/SkK+Su58flnFbAZ7Ln4ny+WavOnUaJos85+C5vUJapynqYiy5nBlUQtZcX5yzpRsl891XCCnOvNyt1oR44RaaAijJgKrRhYdhVXBqKTpQbyvPac52gd18m48JE2AZGTNwAUHJebkin06bFEkvJZeSquhW8y59JdSb2ClyJ1Qs12q4i/d/ai/oH4ahQA9AtiEvV/GMLX9HbP/I4omyRwzXARu3Cg8WSj6tQOMhkabTQP6eGlrxN39uLZNn1b/rFdlxboWJFr3jZagOvD3MI6A7TTn+/Idr9I+YPN+wpLxhXc2+t8emo47jsu9yh7atPXxO9YBU4okThzXToaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YPy9QMXnWRLwdxwQ/73OEX3NcbZZql9+NZuVZOfIa8E=;
 b=q/Lny6qlWCVFhPC/FhQ5jXPLwUSY3Bscjv7wKelW9yowsUzyUjXV0NwZ8x9HnJ0Q7mn4S4cxGXdkP05zfGqk5Y1coKo5yGwvbvyg0ymtqzgVfQV9DTzPFK8ulj9NRemjP7K+aENyHk8vE8Bxh9OsxPvc5MQXDFNuo9y5OFazqXs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DBBPR03MB5143.eurprd03.prod.outlook.com (2603:10a6:10:db::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Fri, 22 Oct
 2021 17:37:41 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf%6]) with mapi id 15.20.4608.018; Fri, 22 Oct 2021
 17:37:41 +0000
From:   Sean Anderson <sean.anderson@seco.com>
Subject: Re: [PATCH v2 1/2] net: macb: Clean up macb_validate
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Antoine Tenart <atenart@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
References: <20211011165517.2857893-1-sean.anderson@seco.com>
 <163402758460.4280.9175185858026827934@kwain>
 <YWhcEzZzrE5lMxD4@shell.armlinux.org.uk>
 <82025310-10f3-28fd-1b52-2b3969d5f00b@seco.com>
 <YWi4a5Jme5IDSuKE@shell.armlinux.org.uk>
 <95defe0f-542c-b93d-8d66-745130fbe580@seco.com>
 <YWoFAiCRZJGnkBJB@shell.armlinux.org.uk>
 <YW7d+qm/hnTZ80Ar@shell.armlinux.org.uk>
Message-ID: <24d336d7-9c6f-55bc-34dd-ddd796ef8234@seco.com>
Date:   Fri, 22 Oct 2021 13:37:34 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <YW7d+qm/hnTZ80Ar@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1P223CA0021.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:2c4::26) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
Received: from [172.27.1.65] (50.195.82.171) by BL1P223CA0021.NAMP223.PROD.OUTLOOK.COM (2603:10b6:208:2c4::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18 via Frontend Transport; Fri, 22 Oct 2021 17:37:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dc54774f-8c5d-49b8-b051-08d99582a5d6
X-MS-TrafficTypeDiagnostic: DBBPR03MB5143:
X-Microsoft-Antispam-PRVS: <DBBPR03MB51436A4D157F2F85D13D4E3496809@DBBPR03MB5143.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BQSzfK9DwM0CccfaOqWXBpLQbrvZlwxIMl/itt8tXllQh8UvTGxDUrPaaDac+D/PDo2hwVQcanKmrUDSoywHjTG6Y4HqmD0jsehQU1qfafU0vUsOiWkM7k7h1HbYVJwI3VBxgZg4cbNB4xYY7uQCTO7itWVEGFYOYNy34p+88Qx0ir7NZPPRMW/hHO5W7zHveBWF3DrPzVQRAJ8c0Ly8tU7DYXQsFdJoCu2Scx+woDs8zvPibwlxmMZjii24ixv2KS0Ur0xjQyk5+fnWxoMIl0SYePKETsu1onaDeXuPw/2bxcdq9URvrwyiDuyzgoPXUZ8X2AG8LxWXlIMET8DFS5yoGKQvLtRfGcqhVtZyyEExCo7wEe/+fv3gtzsvrmcXaylJQ1GDVZ2m9tds8ldgwDGmiZo2EwJX1wJj90a1xlsK7RF/JO6Fo1vFbQB1HjuGN81fTjUj2RjTZ/sd29bWXcekbPw7mfQroOSrSpPGbGA7AqwoweiHKpaPG5M/qLSasE683o35Zrqs2OSHFqbWftIaw2I2yszCn0u/sEfzG11fYYrEwJZMAxy9B0nF6bumuWxFbHkT0flIM3pp8Eq4R+TRtamOm8BKwdrGnOsQufPqzOh5gX8rYQVQbRed7Yjht/pe3OcttYcs48ZzsTDLQAwpVr94S5U0x6cgVj+mU+yX3x8BT5xpKxtsf/7sYxgmaV/ClQIZMzdUbwwCKaOdhtPC/95/YU94239MGJsx2MPJDt7H6BHy7K6GXQ5E6+neKq+AuRHuz2uaw+AtCszST3jSPl6DNxZHJNzlFD6z2QqmrdShr7hhZTyEQwYDG/VqIb3P0Xqib54VEguo/3vnbtFAG+tetx1+SCghHdxbYq8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(36756003)(6486002)(6916009)(186003)(66946007)(31686004)(26005)(2616005)(956004)(54906003)(6666004)(316002)(83380400001)(16576012)(31696002)(38350700002)(2906002)(53546011)(66556008)(4326008)(8936002)(86362001)(508600001)(44832011)(52116002)(966005)(66476007)(38100700002)(8676002)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?alpvK3NEL3puSUtxTXdLeDJNdVBiblBDMjRzeHVIUldFMFhWbmtyc0krMFQr?=
 =?utf-8?B?VlBZTnRxWS9oSDhUMmxvUERxNHd1OGxVWTAwUTlpTHVWejV5MklGQjQ1c3Js?=
 =?utf-8?B?TmRUcTNaQ1c4cXRoSlhhWlZxSEFvUTU0MW5HQTZDMlRLcVZBNWg5MXZHOVJy?=
 =?utf-8?B?Sk9oV0k2Y1RDRzJ6RzRNSFhXYmdOQWpOUU1rQTR5dnNqTzNGQXhFZG5wajBN?=
 =?utf-8?B?ZjhML0c5NzNMcTdmM0FBK1ZxTmd0Z0laajRZQ1NwVkluRmtrdnRSNStKVFpp?=
 =?utf-8?B?eGE3emNMZUxyb3dtelNjamhqZWhIM0pnQ2h2cnVLMzBxRW51dFNNSVcrYW16?=
 =?utf-8?B?RGdpcXRKK0dtRmNwVUxxTmNuazk0M291eWo2dTgxSlA0UG4zaHp6ajN2QXli?=
 =?utf-8?B?bzNveWR2WXYzVWk5S3MwZGdMZlZKSFlVZmpGVG1zRHl4Q2tIeU9xNFhJYzEr?=
 =?utf-8?B?eElvMTZpeHdORXp0OE5kTUVTbEs0elVuR2hCanpxSGhnVCtZdWRLeUM4MW41?=
 =?utf-8?B?VmY3Q2N6N0pTUWdzWlB5bWlkc294cXJaS2hrUzVVNFBrcEZnMkhHeFBGamhE?=
 =?utf-8?B?UDBkRHFaTlV4dXZ4SWdaOWZialoxWW4wZGdGUFlvYUxYT0tzeFNtakI3aHVM?=
 =?utf-8?B?R0p4V2xCNUVaQzM2UDF4cFpYNnBMMldMclRJdXkzdUZvVllCYXFmU0JCYTN6?=
 =?utf-8?B?Y3BDaDNZNzdaU2RqS2s4TFBQTG43Ynl6RlBITG5OQkRjTDEzQkxCdmZvbDN4?=
 =?utf-8?B?bmZlOWc1MlA0NHNxNGJYbEIwa1FiY3VCWnlPNDFzZmF6eFUwRUdZQTBVZ21v?=
 =?utf-8?B?dXV1NC9XQ00xZVZ6SGhkUm4yVlZPTG1Ta3FrR201THhYaVlrUzlpVm4xTllh?=
 =?utf-8?B?VTZROU85aFJGY09PN2VNWDh5OHRnZDU0VldIdDNhVmEyWlowZ2xySzR6YXM3?=
 =?utf-8?B?Yko0TytJNjRENTNiNWw4NXJKOG9iTnJieUQrWFAzRnIyNUNKUG94Sk9ZUnMx?=
 =?utf-8?B?eGgyWCs3UGgydGI1dlBtamhMRkhDTjk0ejB1bEExVkdHTU1neXpnK2l3bEJu?=
 =?utf-8?B?cGpwd1JJU1lnbnNWRzZSYnYwRXBPV3I1RmdOY01hQWh2N2toalRoNllRMmJN?=
 =?utf-8?B?WW1pQ050SXljc2IwUno1QkxvYTI2Sy9IMjJPWU1SNHB3NjFLRVRmanhtam9a?=
 =?utf-8?B?aUR1SVdDZUJleTNxcWFKaHRyZG9WMmpqSUNuVXEyUzdNNUNvSEkrYlhSbC8y?=
 =?utf-8?B?Y1ZINUhHTm9OeFlodGw2NlMxaTRFZXpKL2lSNTVpb0JsK0NvQ2VJUXV6NzB0?=
 =?utf-8?B?aEZ2SnNJVjhzcjNrOXdtOStRWTZUOHJNL3pYK1dwVVJ4b2hweTRKRlRmL1BL?=
 =?utf-8?B?VXVmQjJRWWxid08zV0JvSHFxWWh5NGIralpsYXJhbTZSZWh0dU1wV3RSZ3h5?=
 =?utf-8?B?VEgzeWtvOTV0c09MKzdJS0F0c1A5MG1iazhsK3BxQzAyZ3JiM0xOT0FudHpZ?=
 =?utf-8?B?SDI5Zm9UY0I0OWFSYXgzdTVZMTlpUllKUGI4RzN5VUprMUNNNnI2TWFVbkVM?=
 =?utf-8?B?RjNQalVsRFZWamk5YmppWXJDd3N5L0pzeU9VMlJHaHZYY3RvakdaYW50T1FJ?=
 =?utf-8?B?dUR6VVVuZXZ6Z3c5T2VidmlDVEx5RE1WZE9NS05vYnh4dTcwM1hHOTlvZWtW?=
 =?utf-8?B?SXV5OXJ2YWx4elBOYmt5VjQvN0NMK1NBL01HZVJnbm5POWpnM0hVb3lsN0pS?=
 =?utf-8?B?NktHc2d4cE51WEdxS3VzeTk0SVBBSDZRL25oM05MQ1FEaE9XMnJHUFMyZnFD?=
 =?utf-8?B?dDM0dmxzbnZvaHpJUDNka3NQMEFEWlVVbVNEaFp1MUV5dFVVTzdIaHBQb0k0?=
 =?utf-8?B?aUF3bkdUZ2IxcEl3UlBsN3NRai9XVVVjUDNVdGJNN24vUmc1dTFsMlNhdXRH?=
 =?utf-8?Q?dwzFW+FumCEOOJn73ws7Chd1lQbg9Fc9?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc54774f-8c5d-49b8-b051-08d99582a5d6
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2021 17:37:41.1662
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sean.anderson@seco.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR03MB5143
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

On 10/19/21 11:02 AM, Russell King (Oracle) wrote:
> On Fri, Oct 15, 2021 at 11:47:30PM +0100, Russell King (Oracle) wrote:
>> I have been working on it but haven't finished the patches yet. There's
>> a few issues that came up with e.g. DSA and mvneta being able to switch
>> between different speeds with some SFP modules that have needed other
>> tweaks.
>
> Okay, have a look at:
>
> http://git.armlinux.org.uk/cgit/linux-arm.git/log/?h=net-queue
>
> and the patches from "net: enetc: remove interface checks in
> enetc_pl_mac_validate ()" down to the "net-merged" branch label.
>
> That set of patches add the supported_interfaces bitmap, uses it for
> validation purposes, converts all but one of the ethernet drivers
> over to using it, and then simplifies the validate() implementations.
>

For "net: phy: add phy_interface_t bitmap support", phylink_or would be
nice as well. I use it when implementing NA support for PCSs.

For "net: sfp: augment SFP parsing with phy_interface_t bitmap",
drivers/net/phy/marvell.c also needs to be converted. This is due to
b697d9d38a5a ("net: phy: marvell: add SFP support for 88E1510") being
added to net-next/master.

(I think you have fixed this in your latest revision)

"net: phylink: use supported_interfaces for phylink validation" looks
good. Though the documentation should be updated. Perhaps something
like

diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index bc4b866cd99b..a911872c12d8 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -134,11 +134,14 @@ struct phylink_mac_ops {
   * based on @state->advertising and/or @state->speed and update
   * @state->interface accordingly. See phylink_helper_basex_speed().
   *
- * When @state->interface is %PHY_INTERFACE_MODE_NA, phylink expects the
- * MAC driver to return all supported link modes.
+ * When @state->interface is %PHY_INTERFACE_MODE_NA, phylink expects the MAC
+ * driver to return all supported link modes. If @config->supported_interfaces
+ * is populated, phylink will handle this, and it is not necessary for
+ * validate() to support %PHY_INTERFACE_MODE_NA.
   *
- * If the @state->interface mode is not supported, then the @supported
- * mask must be cleared.
+ * If the @state->interface mode is not supported, then the @supported mask
+ * must be cleared. If @config->supported_interfaces is populated, validate()
+ * will only be called with values of @state->interfaces present in the bitmap.
   */
  void validate(struct phylink_config *config, unsigned long *supported,
               struct phylink_link_state *state);
--

I think "net: macb: populate supported_interfaces member" is wrong.
Gigabit modes should be predicated on GIGABIT_MODE_AVAILABLE. I know you
leave the check in validate(), but this is the sort of thing which
should be put in supported interfaces. Additionally, SGMII should
depend on PCS. So something like

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index c1f976a79a44..02eff23adcfb 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -880,6 +880,7 @@ static void macb_get_pcs_fixed_state(struct phylink_config *config,
  static int macb_mii_probe(struct net_device *dev)
  {
         struct macb *bp = netdev_priv(dev);
+       unsigned long *supported = bp->phylink_config.supported_interfaces;

         bp->phylink_config.dev = &dev->dev;
         bp->phylink_config.type = PHYLINK_NETDEV;
@@ -889,6 +890,21 @@ static int macb_mii_probe(struct net_device *dev)
                 bp->phylink_config.get_fixed_state = macb_get_pcs_fixed_state;
         }

+       if (bp->caps & MACB_CAPS_HIGH_SPEED &&
+           bp->caps & MACB_CAPS_PCS)
+               __set_bit(PHY_INTERFACE_MODE_10GBASER, supported);
+       if (macb_is_gem(bp) && bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE) {
+               __set_bit(PHY_INTERFACE_MODE_GMII, supported);
+		phy_interface_set_rgmii(supported);
+               if (bp->caps & MACB_CAPS_PCS)
+                       __set_bit(PHY_INTERFACE_MODE_SGMII, supported);
+       }
+       __set_bit(PHY_INTERFACE_MODE_MII, supported);
+       __set_bit(PHY_INTERFACE_MODE_RMII, supported);
+
         bp->phylink = phylink_create(&bp->phylink_config, bp->pdev->dev.fwnode,
                                      bp->phy_interface, &macb_phylink_ops);
         if (IS_ERR(bp->phylink)) {
--

Other than that, the commits in the range you mentioned above looks good
to me. For reference, my working branch with the above changes applied is [1].

[1] https://github.com/sean-anderson-seco/linux/tree/rking

--Sean
