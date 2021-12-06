Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CF16468E2E
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 01:03:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241329AbhLFAGt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Dec 2021 19:06:49 -0500
Received: from mail-bn8nam12on2126.outbound.protection.outlook.com ([40.107.237.126]:19936
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229567AbhLFAGt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Dec 2021 19:06:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UuMbvZ34MHsAQoqeoTBYD50Nwuevxrcpow8zMqEk9q+35ruDV/9bnwwDhOd9emTQnHzUMFMkQqSU9HZ8T/iMT3xFRf2OGX2c5tXO0vb1Rq7t8MUlFfQsnDRsI48nEXUzI82OuaScEm1CeTvouosFjZKDeLmMsVgbYwPY9KneUXQH2b+WAB8ZCpuwdpI7h+VY/u4PrUYly9fOO/uTUsKCDsXUDsYWjWH/66hQs8Pa7LWoOiDy88oRaeLX7PM2o1Py+S1EgSQWZE9IH9zd08ZRwR83YfrintwPiu+fJqjJQ4W8rx57vpDM6/Wpecag8Id59ifzPmS1DHS10fnykrcMTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZLvukhJnbUnFHpUqSQW8AovYuQGauQPOZlBBOSUClgY=;
 b=WSNiW+m4O6CqXzwW5fc5jB5TfeKQpwLHWxooQAsBebC72/bC9fqC3bcLVtyTlRc8TGDrg0C2F8hklHAnPxvcyRGF4bPcP9TsYpN+mAyjF2kLaNBqL8vdiR1g3GWHZSSpi/UwKMfXWFfSXaXlHvhwoCa0DuRRjyaMMlwaF9abj94YPcbYSOdZJeLD7DKeAOJzbC70pPLtRjcQIzYXS8Pk3dCX9N/5jPgFOiG4skQJLR338TGk75WUXKRrJnkGhWEkFeYlFX6PDcRZJwnSVZIXt8HjeEFiMy78BNgSxlxLghTLHDMW9SAQ7wu2+DzRzz5JAwnDKbnu6EnfaV/C4a1FkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZLvukhJnbUnFHpUqSQW8AovYuQGauQPOZlBBOSUClgY=;
 b=Lp74Kmjq09nwFZ0+JIp9PaT/jLo/n2m3H+5AxujXVD2lJPAlgJOGDQ3EaA/5pKSDWGcUb+NXFGLTbmg8tCc+OfJlSws24AggDShKtJ5KP6jAHv5XxPp+ZgvJwQn+HMQveSnr5t788VUXCOsBfWCTZYsRfTJV3sVpt+Gcq+BCeK4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20; Mon, 6 Dec
 2021 00:03:18 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f%5]) with mapi id 15.20.4755.021; Mon, 6 Dec 2021
 00:03:17 +0000
Date:   Sun, 5 Dec 2021 16:03:11 -0800
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "katie.morris@in-advantage.com" <katie.morris@in-advantage.com>
Subject: Re: [RFC v1] mfd: pinctrl: RFC only: add and utilze mfd option in
 pinctrl-ocelot
Message-ID: <20211206000311.GA1094021@euler>
References: <20211203211611.946658-1-colin.foster@in-advantage.com>
 <20211204022037.dkipkk42qet4u7go@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211204022037.dkipkk42qet4u7go@skbuf>
X-ClientProxiedBy: MWHPR22CA0064.namprd22.prod.outlook.com
 (2603:10b6:300:12a::26) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from euler (67.185.175.147) by MWHPR22CA0064.namprd22.prod.outlook.com (2603:10b6:300:12a::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.16 via Frontend Transport; Mon, 6 Dec 2021 00:03:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7b03af21-7769-4d09-eca0-08d9b84bce3e
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:
X-Microsoft-Antispam-PRVS: <MWHPR1001MB2351E784FCB7FD1D77849A33A46D9@MWHPR1001MB2351.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lpVIZ+Qix799pWTPLQy8iUQ3B748Jb2LQ82dPbr3bbjyW3GICOwjcbcC9pe0hm8/+1LP1RlmKp3dXZny5MoR1TtI+MSU2Y8YXsAAu0XgPj3+kxF0rI0axODwj7I/9k9fsdSql2Ilb5gm9UeSw8GDmXNkPkZA8Cc8WZPMKCWQ/x7oH3jgmB8HrEky8GaPijbA4zzzxsJvVcH6MouTubKoAFrLG56YdHR2OG8yeBKPuSaJiXWwxLI6ZUXBI65Q9idgVECB1jsg0m5hyP48LQz/vSPezSBnv5cgC6oT8NShOpUJ32QuLAeZBpLdEylbz9UbNJVF9g0q8BfZrMwP5aJ6BbEf73602EVK6FBhU0nVLihusA+DT/TLCRnI515YnKe64DbuSt81Kcdz/yYU/jo1H2m31cxGOTmAwXYwiXr3xiRypbxoGnztTylisuBtI3tMR4pUEwOgIHfRrEMaxrsbBSXnGrqTsiqzvXfpe2ajnNH8cVkm8VqOhL2UHswoJCzoUrJi/PbUNT8n79bZx9efP+BGcuwlxAO1/Q5n+jcecJOKhCoCTA+Qgwya5KI3vCMD5VaiM3c/3xcTXQchTKMjoPgww4GpbwTeLewtwl9JA9eK5QAIa6Go4LPAyilklLikHbEAh90IK6yQTyd7+I9vaE5cHv17I37kBNrMTEaZHMZwjuh+Ih9DzpdeXRbx9f24vDALv1o7EN9i0D67dlFlCmYNj4SMnqVFcar4bYcphQK7rC3KQms4kEgxHQrpVJ2MVhFidM04LA/Fzxsk5tjojiUvwZexXVBlgY4yADt8ScQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39830400003)(376002)(346002)(366004)(396003)(4326008)(26005)(8936002)(508600001)(54906003)(30864003)(107886003)(8676002)(966005)(83380400001)(9686003)(44832011)(33656002)(66574015)(38350700002)(38100700002)(6666004)(33716001)(6916009)(6496006)(9576002)(1076003)(55016003)(52116002)(2906002)(86362001)(66946007)(186003)(66556008)(66476007)(5660300002)(956004)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cjU3ZUowVDFYMDdzejFXTUp3WHVyVlVIWkhmdVBvN25wL3RSMFlsQk9hS0cw?=
 =?utf-8?B?d1RSck93ODRrbkhwZGdMMGtybytjSUswamVWdllQMTNLaXROK09RYU44QURB?=
 =?utf-8?B?Y2Y5SXRKLzNHelN5SzlOeiszZzNCMnBJS2lYOUlDbUxvZWhtUkhlbDVZS3B1?=
 =?utf-8?B?ZS9DQWxFOXgrbis5SWJPakZCMW9HbnB5WGk4WktFTnBQNXQybG5LM2I2ak5Q?=
 =?utf-8?B?MVBkT0E5TUo2ZkxVYTM0L2dtVGFjaEdta2pOUFQ0OXRneWozckZyLzF0Z0lh?=
 =?utf-8?B?K09WQ085QzA5MXQ5RUNabWZjK21OYk9TaFh6OXFzcENDcFFyamlMcFRKNm01?=
 =?utf-8?B?UkZjQWlxMEhOWGdwdU9icHRmQWVsY1diVDdRa3NIS1ZxVlFFU3J6bGJhaDg1?=
 =?utf-8?B?ai9oSnRRei9XWnFXdzV0WExtYWEyU2RBOU1VKzYrTWJNV0cybWJuRVRiVlBU?=
 =?utf-8?B?b3ZCbmwvMkdUZVFPTk9PbVFuejJMSGhwTjJld0RrZWt1SWlDdmVaWFgzc1NP?=
 =?utf-8?B?SWV1eHd0d2w0TWUzakxUd0lFbDBMc05oVUdoOXVnNmxMUmRJOTgrNHRuSGV5?=
 =?utf-8?B?cUJoRVJTSytLdENoT2hOV2h5TFgzNjNBd3pZUmg3eGlZTnluQXZYNm5ESzls?=
 =?utf-8?B?WTZBaktaRFl3VUcrMFJpMnBKYnFvbnc0cHJ6NGovMWU1cWljRS9YUUJhWERC?=
 =?utf-8?B?VTNzblJIajdjeUZXYTJZZ3hveWJYaEhDUDlWcS9iMWhIQzZ5b3Z4aDUrVE04?=
 =?utf-8?B?eUdvbTdab2ZwWnFyMDk1VVhMME1vZWZmK01XMUlEUmZhVVN0bFMxRzNvOTFs?=
 =?utf-8?B?ZmRpUmdORjl3bTcvbjdnTlcxSFgremEvWkFPa1BKUGFIamZFMDNwL1NOajFV?=
 =?utf-8?B?SVEzN2hPK2FDUEsxdmJuaDEvNVhTRE9qamJOdVpDZmp6OTBTZHBxTjBGS1ZW?=
 =?utf-8?B?clVhSTVjRlNLcGhtMmc1NmFEa2l6T2dLWGlncE9Xa2hHSVR5djVIK29tZVA1?=
 =?utf-8?B?UEhpNjI2MjNiS094YUp4ZWx3M0JRQTdHRnc2NzdDN3lGY3QwOGptMG5TVHBq?=
 =?utf-8?B?UXc2T2UvUm5tMUxxRlVkYWthMGJJQVhYanFwNHVjVnBmZGhNRi9PSmNueHVU?=
 =?utf-8?B?WW9BNFAwQXlaakpmSkRlZnY2cE53cmpWWVlmWWRPdHF1ZGFldVEyeUN0WnJO?=
 =?utf-8?B?aW5CNlFEc0JUL3NZMFFLNGY5akZibndEbUVnVTlsczFxL01lMVE5Rms5M1hG?=
 =?utf-8?B?WVZTQzRhWCtZTFlpZlRJL2tENXQySmwyNjljT0ltNmhoK2VwRWV5emZVNHpa?=
 =?utf-8?B?cmpaZ3VyUVBjSXM1OHNIVm9vK3M4Q0ZPcEo3QWgwcGFtWG9MOGs1ZWFOY2dD?=
 =?utf-8?B?WFhqajJFMUMzd0FyMGlwL0J6Tm9XNXhOYXU2SEFZcy9sVnBFbzBGL3ZNelkr?=
 =?utf-8?B?V0doRlM4ZUdlNEsxbmY3blVuL3UzSkNxQVN3M2c5RjNiY0xtVVpkTGFUUUU1?=
 =?utf-8?B?anQrSklmdDlMSzJESk1YWG1OM2VQMituNTVvTzdWYng2RXJoTlpHMHBDem9V?=
 =?utf-8?B?YUJKSFZ1R0J6NjdIKzY3QUxSeEo0VG1aVGZybUdhQmFsa2JqdS9OUitBSW1Z?=
 =?utf-8?B?b0tIb2V6QytXZk1iM2xGcDM2a2N5MjFWbnNJazM0cHdHbWVYelMrTFZoZWFk?=
 =?utf-8?B?ZC9xK2JVcTd3MEVsTk9pTXA4QW0wVnNETFFNVU1OQTlTV1N0ZHJ6U05YbTdM?=
 =?utf-8?B?L1JyZVBVbTEzRG5Qb0o4L25aVmMwV0xWVkNHcEFQN2NtZTgzR05VVm5XZnFj?=
 =?utf-8?B?VkZlRWhvbEduakdEbnlac1BCck5nY3I2MERDVXZpTXl2S05pVWZGcTFCLzhD?=
 =?utf-8?B?Yk00NGw1WW5FRmJPaHBucGk3RVVHeXlZajRFcSt4NXVkNHhqajBKclZjQXVz?=
 =?utf-8?B?RE04THpsWExiNEJNUDEyaXBCTU9iWnJSK2E2NFZBTWRJYTVmT0RGRDh2Y3Rk?=
 =?utf-8?B?VG80UVVnMjVNMjB0RVJ0SXk5U0Q0dDZRcTVjZzVRM1BaT0FackNHM0sxL2RO?=
 =?utf-8?B?NGtvR09tZjlGR3IzYzJCdTg2b3Y3V2dsM3ZWRm0wekw3TTdsL0pOU2ZSN2dt?=
 =?utf-8?B?UEhPdHN6MU83SlVqa29oamJ3WjJvQ3duQ2pRZk9WSHM4UzlUK2V6bVZqdkJq?=
 =?utf-8?B?K1dGU0hyS2VnQnhSdWsvaTVvZEJVN2lXVUgzMjZuOTlUOU1sS2sxNXRZZDho?=
 =?utf-8?B?eUJMVUNlQ2h2WWRhYUswZGFnL0t3PT0=?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b03af21-7769-4d09-eca0-08d9b84bce3e
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2021 00:03:17.5771
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 13BrfwcQiy2RZg/3NthrLfjyUK9HFAvOGj+fKEU4QVxkEcupAVMw5ggySmNrHhIIHwsGQgJjaehBiYENT71n0UJDLcIT+8kQahoyF+SP7ho=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2351
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 04, 2021 at 02:20:37AM +0000, Vladimir Oltean wrote:
> On Fri, Dec 03, 2021 at 01:16:11PM -0800, Colin Foster wrote:
> > This is a psuedo-commit, but one that tells the complete story of what I'm
> > looking at. During an actual submission this'll be broken up into two
> > commits, but I'd like to get some feedback on whether this is the correct
> > path for me to be going down.
> > 
> > Background:
> > 
> > Microchip has a family of chips - the VSC7511, 7512, 7513, and 7514. The
> > last two have an internal MIPS processor, which are supported by
> > drivers/net/ethernet/mscc/ocelot_*. The former two lack this processor.
> > 
> > All four chips can be configured externally via a number of interfaces:
> > SPI, I2C, PCIe... This is currently not supported and is my end goal.
> > 
> > The networking portion of these chips have been reused in other products as
> > well. These utilize the common code by way of mscc_ocelot_switch_lib and
> > net/dsa/ocelot/*. Specifically the "Felix" driver.
> > 
> > Current status:
> > 
> > I've put out a few RFCs on the "ocelot_spi" driver. It utilizes Felix and
> > invokes much of the network portion of the hardware (VSC7512). It works
> > great! Thanks community :)
> > 
> > There's more hardware that needs to get configured, however. Currently that
> > includes general pin configuration, and an optional serial GPIO expander.
> > The former is supported by drivers/pinctrl/pinctrl-ocelot.c and the latter
> > by drivers/pinctrl/pinctrl-microchip-sgpio.c.
> > 
> > These drivers have been updated to use regmap instead of iomem, but that
> > isn't the complete story. There are two options I know about, and maybe
> > others I don't.
> > 
> > Option 1 - directly hook into the driver:
> > 
> > This was the path that was done in
> > commit b99658452355 ("net: dsa: ocelot: felix: utilize shared mscc-miim
> > driver for indirect MDIO access").
> > This is in the net-next tree. In this case the Seville driver passes in its
> > regmap to the mscc_miim_setup function, which bypasses mscc_miim_probe but
> > allows the same driver to be used.
> > 
> > This was my initial implementation to hook into pinctrl-ocelot and
> > pinctrl-microchip-sgpio. The good thing about this implementation is I have
> > direct control over the order of things happening. For instance, pinctrl
> > might need to be configured before the MDIO bus gets probed.
> > 
> > The bad thing about this implementation is... it doesn't work yet. My
> > memory is fuzzy on this, but I recall noticing that the application of a
> > devicetree pinctrl function happens in the driver probe. I ventured down
> > this path of walking the devicetree, applying pincfg, etc. That was a path
> > to darkness that I have abandoned.
> > 
> > What is functioning is I have debugfs / sysfs control, so I do have the
> > ability to do some runtime testing and verification.
> > 
> > Option 2 - MFD (this "patch")
> > 
> > It really seems like anything in drivers/net/dsa/ should avoid
> > drivers/pinctl, and that MFD is the answer. This adds some complexity to
> > pinctrl-ocelot, and I'm not sure whether that breaks the concept of MFD. So
> > it seems like I'm either doing something unique, or I'm doing something
> > wrong.
> > 
> > I err on the assumption that I'm doing something wrong.
> > 
> > pinctrl-ocelot gets its resources the device tree by way of
> > platform_get_and_ioremap_resource. This driver has been updated to support
> > regmap in the pinctrl tree:
> > commit 076d9e71bcf8 ("pinctrl: ocelot: convert pinctrl to regmap")
> > 
> > The problem comes about when this driver is probed by way of
> > "mfd_add_devices". In an ideal world it seems like this would be handled by
> > resources. MFD adds resources to the device before it gets probed. The
> > probe happens and the driver is happy because platform_get_resource
> > succeeds.
> > 
> > In this scenario the device gets probed, but needs to know how to get its
> > regmap... not its resource. In the "I'm running from an internal chip"
> > scenario, the existing process of "devm_regmap_init_mmio" will suffice. But
> > in the "I'm running from an externally controlled setup via {SPI,I2C,PCIe}"
> > the process needs to be "get me this regmap from my parent". It seems like
> > dev_get_regmap is a perfect candidate for this.
> > 
> > Perhaps there is something I'm missing in the concept of resources /
> > regmaps. But it seems like pinctrl-ocelot needs to know whether it is in an
> > MFD scenario, and that concept didn't exist. Hence the addition of
> > device_is_mfd as part of this patch. Since "device_is_mfd" didn't exist, it
> > feels like I might be breaking the concept of MFD.
> 
> In the possibility that "device_is_mfd()" is not acceptable for the
> pinctrl and mfd maintainers, one other way in which you could solve this
> conundrum, without changing anything in the core, would be to introduce
> a different compatible string for your driver variant, and the
> pinctrl-ocelot driver could figure out based on that whether to request
> a resource or a regmap. I don't see this being done, either, but I
> suppose it could be made to work quite easily. Something like
> "mscc,ocelot-mfd-pinctrl" instead of "mscc,ocelot-pinctrl".

Good point. I'd think either would be fine.

> 
> > 
> > I think this would lend itself to a pretty elegant architecture for the
> > VSC751X externally controlled chips. In a manner similar to
> > drivers/mfd/madera* there would be small drivers handling the prococol
> > layers for SPI, I2C... A core driver would handle the register mappings,
> > and could be gotten by dev_get_regmap. Every sub-device (DSA, pinctrl,
> > other pinctrl, other things I haven't considered yet) could either rely on
> > dev->parent directly, or in this case adjust. I can't imagine a scenario
> > where someone would want pinctrl for the VSC7512 without the DSA side of
> > things... but that would be possible in this architecture that would
> > otherwise not.
> 
> Not pinctrl, but let me try to give you an example which is perhaps
> relevant.
> 
> Earlier this year, Alvin Šipraga dropped a bomb stating that for some
> DSA drivers for switches with embedded PHYs, those PHYs would fall back
> to using the less specific (generic) PHY driver _if_ they are requesting
> interrupts.
> https://lore.kernel.org/netdev/cd0d9c40-d07b-e2ab-b068-d0bcb4685d09@bang-olufsen.dk/
> 
> It was a huge discussion, driver core maintainers got involved,
> restructuring the DSA cross-chip probing design was on the table, the
> PHY library too, yet to my knowledge nothing got resolved, and even if
> it did, it was through the introduction of a hacky flag
> (FWNODE_FLAG_BROKEN_PARENT). I don't remember if that workaround even
> got applied or not.
> 
> "Broken parent"? Why broken?
> 
> See, ocelot is not the only DSA switch SoC that has more stuff going on
> onboard than just the switching fabric. For most other DSA drivers, this
> grew quite organically, from a simple MDIO device driver, to a device
> driver for a switch that also registers many other drivers, and buses,
> from its own probe function. And the OF bindings also grew organically..
> and hierarchically with the switch on top, driving everything (this will
> become important in a minute).
> 
> For example, the Marvell mv88e6xxx driver, or Alvin's rtl8365mb driver.
> These drivers register an internal MDIO bus for their PHYs, and to avoid
> polling those every second, they also register a cascaded irqchip driver.
> A lot of care is taken such that the irqchip driver is registered before
> the internal MDIO bus is, because PHYs on the internal MDIO bus will
> need IRQs. Yet this appeared to be insufficient: on Alvin's system, the
> probing of the PHY driver is attempted as soon as the PHYs were
> discovered on the bus (expected), and immediately refused. Diagnosis?
> -EPROBE_DEFER. What resource were these internal PHYs missing?
> The interrupt parent. But how? The irqchip was registered just before,
> it's there, waiting.
> 
> As it turns out, there is this mechanism called "fw_devlink" (part of
> device links)
> https://www.kernel.org/doc/html/latest/driver-api/device_link.html
> that tries to be helpful and shave off a few hundreds of ms from the
> boot time. To give you an example of the kind of thing it's designed to
> be helpful with: say you have an MDIO-attached DSA switch, which is
> sitting on an MDIO bus that happens to be registered by the DSA master
> itself. Any sane Ethernet driver that has an MDIO bus on its hands will
> first register the MDIO bus, then the net device (because registering
> the net device will expose the possibility for it to connect to the PHY,
> which may be located on its own MDIO bus, which needs to be available).
> So it is natural to assume that this is also what happens inside our
> Ethernet controller that is a DSA master here. So the implication is
> that when the DSA master registers its MDIO bus, the devices on it will
> attempt to probe, and therefore the switch too. The switch driver, and
> DSA, will allocate some resources and finally search for its DSA master
> via of_find_net_device_by_node().
> This will inevitably fail because the DSA master has registered the MDIO
> bus but not the net device (yet), and the switch will have to return
> -EPROBE_DEFER and some CPU cycles have been uselessly wasted.
> Probing will of course be resumed later, and will succeed after the DSA
> master has registered the net device too.
> 
> Where fw_devlink comes into all of this is that it says "you know what,
> I'm not even letting you play. I'm going to infer some relationships
> between struct devices based on firmware node phandles (in this case,
> think of the 'ethernet = <&dsa_master>' that DSA has), and if I detect
> that the supplier of that phandle hasn't finished probing yet, I'll just
> return -EPROBE_DEFER from the device core, not invoking any DSA switch
> probe function at all. I'll call you when your suppliers are ready".
> 
> Reasonable, right?
> 
> Well, back to Alvin. To understand the problem he had (has?), you need
> to better understand the flaws in fw_devlink. This mechanism essentially
> says that if there's a supplier-consumer relationship between two OF
> nodes by way of a phandle, there's also a supplier-consumer relationship
> between the devices that probe on those OF nodes. So it creates device
> links between those devices.
> 
> But the problem is that the DSA switch drivers may not have a separate
> OF node for the interrupt controller, especially since the driver
> writers didn't know any better, ages ago. There aren't dedicated struct
> devices for the separate components like the irqchip, either, other than
> the MDIO device itself, because there aren't any other buses on which
> those other struct devices should exist.  So when the "interrupt-parent"
> phandle gets translated by fw_devlink into a device link relationship,
> that relationship is between the internal PHY (consumer) and none other
> than the switch device itself (supplier).
> So the PHY driver will be blocked with -EPROBE_DEFER from probing,
> because its supplier has not finished probing (of course it didn't,
> that's what it's doing currently). And the supplier (switch) attempts to
> connect to the PHY from its probe path. Since binding the specific PHY
> driver "failed" (-EPROBE_DEFER is still a failure), and the phy_connect()
> call wants things to happen "now", the PHY library says "all right all
> right, here's the generic PHY driver, just shut up". The generic driver
> may or may not be sufficient to bring these internal PHYs up to a
> satisfactory degree of initialization, hence some of the angry replies
> on this topic. Not to mention, no specific PHY driver => no interrupts.
> 
> In the reasonable and unreasonable cases, the mechanism behind
> fw_devlink is the same. Yet in one case it is helpful and in the other
> it is not. The goal is to one day make fw_devlink enabled by default and
> be aware of many supplier/consumer relationships.
> 
> I have brought up this not so distant story because I believe it to be
> indirectly relevant to the design you choose for the vsc7512-spi driver.
> If you keep moving forward with the traditional hierarchical model where
> the DSA driver is the spi_device driver, and this registers whatever
> component of the switch SoC is needed (MDIO bus, irqchip, GPIO, pinctrl
> and whatnot), you will eventually run into Alvin's problem. And don't
> rely on the DSA core, or fw_devlink, "doing something", because there
> isn't something to be done there.
> Instead, I believe that what would produce more future-proof results is
> the mfd model, where the switch, mdiobus, irqchip, gpio, pinctrl drivers
> etc are all flat and located below the bare spi_device driver for the
> switch SoC. This model would inherently avoid the fw_devlink limitations,
> which for good or bad aren't going away, since they're "features not bugs".
> It also allows for the various components of the switch SoC to probe
> independently, as far as I can tell. My belief is that many other DSA
> drivers would benefit from a rewrite using the mfd model. The catch is
> that OF bindings would need to change, which is kind of the point, but
> still undesirable to some. We want a phandle like "interrupt-parent", if
> any, to point laterally between switch SoC components, and not
> vertically, therefore avoiding probing loops.
> 
> So don't feel bad for doing something different, consider yourself a
> trailblazer :)

I'm framing this :)

Thank you very much for this information. I'm interested to hear more
thoughts as well. And I'll again have to read this a few times over to
absorb as much as I can.

I've started venturing down this path, and am already hitting a couple
bumps... and they're bumps I've hit in the existing driver as well.
Basically I couldn't use "ocelot_reg_write" before calling
"dsa_register_switch". That's now a bigger issue with MFD.

So the first thing I'll probably want to do in drivers/mfd/ocelot-spi 
is reset the device. The current implementation of this uses
ocelot_field_write with GCB_SOFT_RST_CHIP_RST, and some SYS registers as
well... I don't think those registers will be needed elsewhere, so can
be defined and limited to ocelot-mfd-core.

As I'm writing this though... that seems like it might be a good thing.
ocelot_switch doesn't need to know about reset registers necessarily. If
there are cases where register addresses need to be shared I'll cross
that bridge when I get to it... but maybe I'll get lucky.

(Sorry - I'm thinking out loud)

One more good thing to come about this separation is that the driver can
be broken up into several patches instead of one huge "here's
everything" commit like my latest RFCs were.

> 
> > 
> > Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> > ---
> >  drivers/mfd/mfd-core.c           | 6 ++++++
> >  drivers/pinctrl/pinctrl-ocelot.c | 7 ++++++-
> >  include/linux/mfd/core.h         | 2 ++
> >  3 files changed, 14 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/mfd/mfd-core.c b/drivers/mfd/mfd-core.c
> > index 684a011a6396..2ba6a692499b 100644
> > --- a/drivers/mfd/mfd-core.c
> > +++ b/drivers/mfd/mfd-core.c
> > @@ -33,6 +33,12 @@ static struct device_type mfd_dev_type = {
> >  	.name	= "mfd_device",
> >  };
> >  
> > +int device_is_mfd(struct platform_device *pdev)
> > +{
> > +	return (!strcmp(pdev->dev.type->name, mfd_dev_type.name));
> > +}
> > +EXPORT_SYMBOL(device_is_mfd);
> > +
> >  int mfd_cell_enable(struct platform_device *pdev)
> >  {
> >  	const struct mfd_cell *cell = mfd_get_cell(pdev);
> > diff --git a/drivers/pinctrl/pinctrl-ocelot.c b/drivers/pinctrl/pinctrl-ocelot.c
> > index 0a36ec8775a3..758fbc225244 100644
> > --- a/drivers/pinctrl/pinctrl-ocelot.c
> > +++ b/drivers/pinctrl/pinctrl-ocelot.c
> > @@ -10,6 +10,7 @@
> >  #include <linux/gpio/driver.h>
> >  #include <linux/interrupt.h>
> >  #include <linux/io.h>
> > +#include <linux/mfd/core.h>
> >  #include <linux/of_device.h>
> >  #include <linux/of_irq.h>
> >  #include <linux/of_platform.h>
> > @@ -1368,7 +1369,11 @@ static int ocelot_pinctrl_probe(struct platform_device *pdev)
> >  
> >  	regmap_config.max_register = OCELOT_GPIO_SD_MAP * info->stride + 15 * 4;
> >  
> > -	info->map = devm_regmap_init_mmio(dev, base, &regmap_config);
> > +	if (device_is_mfd(pdev))
> > +		info->map = dev_get_regmap(dev->parent, "GCB");
> > +	else
> > +		info->map = devm_regmap_init_mmio(dev, base, &regmap_config);
> > +
> >  	if (IS_ERR(info->map)) {
> >  		dev_err(dev, "Failed to create regmap\n");
> >  		return PTR_ERR(info->map);
> > diff --git a/include/linux/mfd/core.h b/include/linux/mfd/core.h
> > index 0bc7cba798a3..9980bcc8456d 100644
> > --- a/include/linux/mfd/core.h
> > +++ b/include/linux/mfd/core.h
> > @@ -123,6 +123,8 @@ struct mfd_cell {
> >  	int			num_parent_supplies;
> >  };
> >  
> > +int device_is_mfd(struct platform_device *pdev);
> > +
> >  /*
> >   * Convenience functions for clients using shared cells.  Refcounting
> >   * happens automatically, with the cell's enable/disable callbacks
> > -- 
> > 2.25.1
> >
