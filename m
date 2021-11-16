Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3205453C6E
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 23:57:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232135AbhKPW7v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 17:59:51 -0500
Received: from mail-vi1eur05on2054.outbound.protection.outlook.com ([40.107.21.54]:36480
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230411AbhKPW7u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 17:59:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YB9nVjgLrW6vVqayT/6SZt0XrlSEL/imI/7/9hWNwYEk1AtjlZV+APk84iuvMRe4x/5F4jayV5a3U3itkNbg1okZnf8RQCOtK06LzWhfhHgKoTcIrx7KQ1LhfCrXXugwgWesxcvVpeQmIqjCFcnqDudjJNc5WcaPWXX1Jpy+TBvQYVvKIG3nhpuOOsqH8/XNeyQ07qMXxjaCpjflcV0upPM/m13OWki4adf6AxtWeGRTctpbGeoyRMQxzEDUa8mI7YpIUS9JslMYNOwxSXKammhwjEyBQAZb0HiBslb2eIEJVif0qJAQlehqhKkQ7V1KXlrGV0woksaGvvs4S1vZrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uR4oRg9WRsyXMeGI4An8xlM8u5Ic/U6SiBvv/VDuXD4=;
 b=R7cwLpOQTBxtlevavLg4D/Dj6tMyrl36wOlzpS1H27XPyE0HEnUL/GvZ0gNGptlKRmMgH1QsiSbBVxMzJGB5NYparyEwUYjNZQ3xB9UZFSjpaB38DmISDVfgFsrvw4LOybSTHWx4eCzDvhA7876J4WZtZYKZ0ukYsXgS8FtVZuG+7AXfihBEJVbXyzGztGW8tyX++1LD7KuX6ok7i1jvAnQcg4c9UiLarlQK+IAUzDAE3KkrUwkbKIqBdd79TYiqyJhmWBJ7BlFMAR/TddjYfI7yI17aF10LIqVIe8wJzk7S51YFfWeFfEGdqhAmAbyCAk56A4guDzKF7I9vYwaoyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uR4oRg9WRsyXMeGI4An8xlM8u5Ic/U6SiBvv/VDuXD4=;
 b=kYQBgcF01P4ilTLmXVIuaL199/gZL4VRiuDNQdmyQLOh9COETGEtpmbg6W0hAnYLpOu1wRZS7lKJuiurp9SCbWAeYRV/PCgTwF5DpG4fKnUAOzMBCWc6klOLg7AGYGGf4/YNwsmcigICj29bpoagKv8WnvF+AgrxpXnCdH7jS1c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DB8PR03MB5674.eurprd03.prod.outlook.com (2603:10a6:10:10e::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.16; Tue, 16 Nov
 2021 22:56:49 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf%6]) with mapi id 15.20.4669.021; Tue, 16 Nov 2021
 22:56:49 +0000
From:   Sean Anderson <sean.anderson@seco.com>
Subject: Re: [net-next PATCH v6] net: macb: Fix several edge cases in validate
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Parshuram Thombare <pthombar@cadence.com>,
        Antoine Tenart <atenart@kernel.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Milind Parab <mparab@cadence.com>
References: <20211112190400.1937855-1-sean.anderson@seco.com>
 <YZKOdibmws3vlMUh@shell.armlinux.org.uk>
Message-ID: <684f843f-e5a7-e894-d2cc-3a79a22faf36@seco.com>
Date:   Tue, 16 Nov 2021 17:56:43 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <YZKOdibmws3vlMUh@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR11CA0022.namprd11.prod.outlook.com
 (2603:10b6:208:23b::27) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
Received: from [172.27.1.65] (50.195.82.171) by MN2PR11CA0022.namprd11.prod.outlook.com (2603:10b6:208:23b::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27 via Frontend Transport; Tue, 16 Nov 2021 22:56:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7abc7348-b291-4718-3ff3-08d9a9545f22
X-MS-TrafficTypeDiagnostic: DB8PR03MB5674:
X-Microsoft-Antispam-PRVS: <DB8PR03MB5674FB41A4BCCD9F30E3F6BC96999@DB8PR03MB5674.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l5tNzFV5pWck1DS3c27MEcG1HXfMoZbGyEYGnn84bJjcGoo6PNRrJ1v4fDHDRkG+7T3JaCWMHFi8C6prhR8X+Mz9TnUtBDSFV7cNBTVTEk6j1e2+YiWs/OewRBuIre2IQkjJWSjGUL9a+XzIjG/QUvJo6rq9TaGAFR2cx6dYnpvpEAuzpazj87NXEA3Iin+GJU0xJFXGGcR72KbbiibYekN/fcrK9i9niDfjGDZ6ElXz5jxxMCGrHkvckhnfBW/KyYM6rAyMMJEOEOmCcGpU/UYe7oRONp9Mn/e9zXzAvDFdozeU89rE/VmRWn3Z2jYk/dDsDdl8eHitqJsaUuHfmUVPB8rvUOn1NbHU1rKeCyUvZgFsfhxeN2ToFZNGD+gPZ+yErVCFq64Igd4vHimB5YNNmyuIXjoSktqfYEp8WeOVV4ouw3tfDZwbv42gA1PDugGWBOlUtqmzoFEZvtED3Rz9m3zbrMm3DuS5ZgbkEEQoLOYf9cTV5LL7+pO+/gQBnvMYhh3WZ4xalvEx7uArGvpMW5cATMUN1sV3w0b1Fu/XPF6f79psT1PhRUWu8d9tp92Q2T2OX2dgjImd8bh7Atp1eHfirZszZxikLjsevYDjS2HVhryoaOziFrMFmhaZzsPdOWymZYJEuhk4ivJNx9JfMYv0APUcV+Vp0NQ3dtoFPsrRj/Qv9r3VB09zvN5fivVDVKOHHMfc82ub/NZTQ9OQnyDHncHojYb/ElE/QL0N2XIBL8zc7hqhV0wzKV5IC161zwxcfDxpvqE4+r3u7Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(186003)(6666004)(4326008)(8676002)(36756003)(508600001)(86362001)(8936002)(26005)(6486002)(52116002)(66476007)(5660300002)(2616005)(83380400001)(66946007)(54906003)(316002)(6916009)(16576012)(2906002)(31686004)(44832011)(38350700002)(38100700002)(53546011)(31696002)(66556008)(956004)(15650500001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZjBXRjJtQzdJZUVJYjlaTFFqVm4rOEl6dWZkWkdwZDNxelRNeWdwd2FuNlhz?=
 =?utf-8?B?ODFlazJOT3BLY251WFc1VkhEYThQazBjT3M3UkIyazFzY0dyNUt4OU5JYTVH?=
 =?utf-8?B?WXF5LytSOWZqejZwOC9DbjRZTFJGVHV6dWJXakpFcWRVZ2plMmF6bXM1ZWla?=
 =?utf-8?B?OENqNGhkWFl0YXFkbFBDSDhLcmRXUVhkbXdvVDdHdThnc2VXRTNRMlVNUFBU?=
 =?utf-8?B?WDhCRXpjd2ZvaW1HNUxWelFweHpuRmdYVEVQdHhRUGZ3Z0hWNERNeTRwVVc0?=
 =?utf-8?B?ZXhZY1BZK3VpN0YrVXVrY0RYcUlaaTYxdDlmd2JSK3MvaHpHTHg4NW5GVWxC?=
 =?utf-8?B?SWwrdW9MU1JTZVovZmkwdDZLQUFJUURtK0FWUm01K2dnb3VMRC95ditoZnhr?=
 =?utf-8?B?T0RYVWFjVjk1RU1BcU8yTTB0eElLeWJna2ttUmNoa3NBbkU3ajFZNmNicXZj?=
 =?utf-8?B?Y2dEeDJoQnhINGNKcmJCOUc4Z0FqNkxPc2NVM2xramJiQkY2dlJSS3paQnVy?=
 =?utf-8?B?R1VlZE9sTGVMc1gxb3FzMUE5WGpOUTUxeHBhQngzK1pMN0x6aTV4aFUyaW5x?=
 =?utf-8?B?U216bnZUZWhEL2x3Qi9hUGtkY0Vxck95WWhHVW0yaGVLS3lRVWlOdnkrVDlh?=
 =?utf-8?B?V0NEZE40TWZVcnd6emNMZ0FFbnlTYllVNkJSVmlndmx6YVgwenRpa0RFU0Ir?=
 =?utf-8?B?bTVTVUszbDZCWG50NXdINThTek5naVlkTCszUURmeGpicGdFR3pScWpiRkxZ?=
 =?utf-8?B?dW9wQWIxcElCVS9nK01VekNBcVk4dmlYRS9tdklLeW9pa3FIcU5IZjlpUHhP?=
 =?utf-8?B?WVd2R3hDWXhTU0RZQy9yOVpDanIvY0o0bERMSnJkQmNhYVF3SXlLNjlWbXlt?=
 =?utf-8?B?dEtCL1YxWlFiRitRcHgxU1ROZ2o5VUtIdTRudUNjVlFFSTJXaDVaNHpYSnpt?=
 =?utf-8?B?YS80UUI1Zy9QbzRDWXVJV0tXb3psVDBMUWhwOGtPWkV2UGJHMzJ0bGZUWGNh?=
 =?utf-8?B?Lzl6TkxBNlBaa21FWmJVLytsRkZLckowbUloQnJoMVB6VDh1OUYxVi9NYWRp?=
 =?utf-8?B?K1Y1T08zaVZJT2NWNi95ZEtpS09TQWpQeFFGdTd0OW9rbktCcGVSNGZVWGtp?=
 =?utf-8?B?azBrTXVyRVlxblh2cEZ5SGdIUkduZ0tabWdaaVZCWndRM2h5dHNETGgvdDVi?=
 =?utf-8?B?WGJCSGliQU52UlZISHRCZ0lhR2tHY1dSVVhRam1jVDkvL0RGZHBkQXJyU3Ur?=
 =?utf-8?B?L1ZPZDJYLzBGMW50NUNGb2JGZy9VSU4wOG12VzhpaFIzc09vdDZpTzhHdTdP?=
 =?utf-8?B?cVlQUUF5Mm9VTHhtdTlrMENFOFk3RVVrcWcxR2Fqd3hKU0p4ekhUbTBUMFpN?=
 =?utf-8?B?dlpORmRDU0lHZmFSSVNRQk5vYkVPNy9kY0VXVDB5akdUcXlhUWZMbFNsUHR4?=
 =?utf-8?B?bUpFaVBHcHk0eG0vQWV0VWNxRzlzU2Rjb1lMMld6MjRjNTdOOTI2K2F2b1BM?=
 =?utf-8?B?dEEwQkhUK2swcERRN1BqRG5VTXZLUlg0akcxZGkxaCtiT1hJellCVitYMGlm?=
 =?utf-8?B?N3NOWlpxMFlweUQxSk14ZGJxSDJLWHc2S3J0bzZoSHZGSitKOWJjbWgwNytR?=
 =?utf-8?B?RmpxTkttTEZQY0duT2UrVktOaTk2eEtwaXJkRWVHQkI3QlpWWXRpRUpiMXdw?=
 =?utf-8?B?Y1B1VWczMWNMZERTRXBZMXZteFM0b1lLelNrRndZcGFlOUNhRjJ0bzAzcjMy?=
 =?utf-8?B?MjErNHo5TnJzN1lIUzJoZ3MwUDZGSVpPTEJsZkpYS211QzdtRUxXTnZaL3NJ?=
 =?utf-8?B?Qjl5VjUxS0FMYlY3MFIxdjI1Tm83ZitaNDlweEp1eGt1MHFjYUpzeVArVllF?=
 =?utf-8?B?eVU2Qi9BTmY3VmN0M3VjRUQ5TmNnbzgvTU1RTXJBSzhaSTlOU0RsamhuVzM5?=
 =?utf-8?B?SGZ2blFuSHU4SjJJR1BrNTlHSllyQlFxTnNFV0JJbFZQVlJBdUkzVjZJM0dQ?=
 =?utf-8?B?QnZ1UXBWS2NCT0FIUUpzcTQwbTIzYUFiY3gwZHVqZm1iTXpzU3BqbU02K2ov?=
 =?utf-8?B?MzdjOEs5L3dyNlVXL3I2OGh0OGVnMjd2djExdk0xSXRQUUU3V25OS1VuTm83?=
 =?utf-8?B?c0JUREVYRm92TmYrdW1pSkIvd2lXZDloazVIYWF2RlFoWnJ4elNlQjhIeW1x?=
 =?utf-8?Q?TEc5WSuSg2CLTe5ZFLBoj+Y=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7abc7348-b291-4718-3ff3-08d9a9545f22
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2021 22:56:48.9425
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AlfjdTFw/+ca7uk2tPT0u9FzayQoRy5B+0Rs5JCh68x9yyF7ARksInPf4t0vWARLDTpKGkm2zLs2VM6skkxVTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR03MB5674
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

On 11/15/21 11:44 AM, Russell King (Oracle) wrote:
>
> Thanks - this looks good to me.
>
> Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
>
> I've added it to my tree as I have patches that follow on which
> entirely eliminate macb_validate(), replacing it with the generic
> implementation that was merged into net-next today.

I have a few questions/comments about your tree (and pl in general).
This is not particularly relevant to the above patch, but this is as
good a place as any to ask.

What is the intent for the supported link modes in validate()? The docs
say

> Note that the PHY may be able to transform from one connection
> technology to another, so, eg, don't clear 1000BaseX just
> because the MAC is unable to BaseX mode. This is more about
> clearing unsupported speeds and duplex settings. The port modes
> should not be cleared; phylink_set_port_modes() will help with this.

But this is not how validate() has been/is currently implemented in many
drivers. In 34ae2c09d46a ("net: phylink: add generic validate
implementation"), it appears you are hewing closer to the documented
purpose (e.g. MAC_1000FD selects all the full-duplex 1G link modes).
Should new code try to stick to the above documentation?

Of course, the above leaves me quite confused about where the best place
is to let the PCS have a say about what things are supported, and (as
discussed below) whether it can support such a thing. The general
perspective taken in existing drivers seems to be that PCSs are
integrated with the MAC. This is in contrast to the IEEE specs, which
take the pespective that the PCS is a part of the PHY. It's unclear to
me what stance the above documentation takes.

Consider the Xilinx 1G PCS. This PCS supports 1000BASE-X and SGMII, but
only at full duplex. This caveat already rules out a completely
bitmap-based solution (as phylink_get_linkmodes thinks that both of
those interfaces are always full-duplex). There are also config options
which (either as a feature or a consequence) disable SPEED_10 SGMII or
autonegotiation (although I don't plan on supporting either of those).
The "easiest" solution is simply to provide two callbacks like

	void pcs_set_modes(struct phylink_pcs *pcs, ulong *supported,
			   phy_interface_t interface);
	bool pcs_mode_supported(struct phylink_pcs *pcs,
				phy_interface_t interface, int speed,
				int duplex);

perhaps with some generic substitutes. The former would need to be
called from mac_validate, and the latter from mac_select_pcs/
mac_prepare. This design is rather averse to genericization, so perhaps
you have some suggestion?

On the subject of PCS selection, mac_select_pcs should supply the whole
state. This is because the interface alone is insufficient to determine
which PCS to select. For example, a PCS which supports full duplex but
not half duplex should not be selected if the config specifies half
duplex. Additionally, it should also support a selection of "no pcs".
Otherwise MACs which (optionally!) have PCSs will fail to configure. We
should not fail when no PCS has yet been selected or when there is no
PCS at all in some hardware configuration.  Further, why do we have this
callback in the first place? Why don't we have drivers just do this in
prepare()?

--Sean
