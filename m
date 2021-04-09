Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE8535A569
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 20:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234538AbhDISM4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 14:12:56 -0400
Received: from mga12.intel.com ([192.55.52.136]:29971 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234497AbhDISMw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 14:12:52 -0400
IronPort-SDR: 1YrFJpJ8FXpIA10Ak59CwUVifdJUv9nQa7aringYjgGxosk1tOG5QrWsdNdD7Pp0a2FpsdJAxU
 jYMbUjIeSriQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9949"; a="173292329"
X-IronPort-AV: E=Sophos;i="5.82,210,1613462400"; 
   d="scan'208";a="173292329"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2021 11:12:38 -0700
IronPort-SDR: gAdrWIUmR0Xde+gGZqzg1xIgAmJryEsKSYdWjKUCZW9+JbvajE6UNLEYut0PM/AQuG3M0GhMYY
 0X7wKkAdgkzg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,210,1613462400"; 
   d="scan'208";a="459320217"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga001.jf.intel.com with ESMTP; 09 Apr 2021 11:12:38 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Fri, 9 Apr 2021 11:12:37 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Fri, 9 Apr 2021 11:12:37 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Fri, 9 Apr 2021 11:12:37 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.48) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Fri, 9 Apr 2021 11:12:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IZB7DU9LD61Vt1X3KQMScQ01GYc74Qmtahlvgogvo5nPC3D11fKqsTVBKgFMFRCJIQMpgYVw6pLRRT5L9AVh3rZ8NFQhYomCTKaJ0w8h64R87ZG1iXJPgvQ6i1jWTHm4h0C/mYjAHIOIpArQNzw2YuasfCQ33kbU8RuYF2puTaDpfKH6q/dmgVbnYBpRjNaZwmy0mvJdwxH2HkyeNPQ8qslBCODVMBexqTA7CPuACBhm8Jp9SDznaVsBjzKchxJP1qJ4LSRo2r9z2xJHdKygmDrAB/iep7Ig22It+8hJFBy1HlPdPq04KnSY5/wxjXai3v3CMV6kCRbTz0PIQwh7qA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MCjP+l3Am4wJgB+QIz4RpU4TJ6TtYB4+GjaUlogY/f0=;
 b=dqhEDoEYjyempmjDhFqL5fBUicro9m2iBGUWRqhiGXJjnbku6YSnc1s8X0YRieV5mUFbpZKGtrET9QmqaX2XttLlTqa5lQQtgnfZ3KGp/uXX/8G+1qrIoJt+ppnQYNBkOIP+MJCuHi/gmLPc0rrav0OPRUVIc8NvNFCQhpIT8rmXbofnRhMFkvLfFjp6PWlrc6Sp4pLuNcKIw6pVXfUKRRGSHqn2uwuPj7lfUNgAX4bhwc9ma3/w7pHZTyltJCIhfY5waHJP4YYmgLR9CZcYHVzJV5tw3NCx6ZGTS3vGb+FIKwTm7YDWZxIYv4AwA5AehoaVBv5KiuurmadB76llWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MCjP+l3Am4wJgB+QIz4RpU4TJ6TtYB4+GjaUlogY/f0=;
 b=kCml0/ofF3uB5Qxuzj/ajE9+FlUbwbu1yEpbe7f6U/xOJXpkStMMB6WExX5gM1unFU5qdSoh/YY1N8hqo5EuEiETMFImV2u7r8Dqgsu9hyAIp1Ne5qReeLDzCCyYZtB7i1V3r2Ug2mG2FAg6Wm+y4Xb2hhnPLem91G2GxNywWbE=
Received: from DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) by
 DM5PR1101MB2203.namprd11.prod.outlook.com (2603:10b6:4:52::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4020.18; Fri, 9 Apr 2021 18:12:35 +0000
Received: from DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::910e:145d:e2f8:ec57]) by DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::910e:145d:e2f8:ec57%6]) with mapi id 15.20.4020.020; Fri, 9 Apr 2021
 18:12:35 +0000
From:   "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
To:     "xiao33522@qq.com" <xiao33522@qq.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        xiaolinkui <xiaolinkui@kylinos.cn>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [Intel-wired-lan] [PATCH] i40e: The state of phy may not be
 correct during power-on
Thread-Topic: [Intel-wired-lan] [PATCH] i40e: The state of phy may not be
 correct during power-on
Thread-Index: AQHXLUs+VWmh6nM5fUSVYn6hAWVkL6qsfJ4w
Date:   Fri, 9 Apr 2021 18:12:35 +0000
Message-ID: <DM6PR11MB4657EB5A8040E7D5A9CB155E9B739@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <tencent_A3F0B1FAA65495EB2220B5B72EB6E5AF1B07@qq.com>
In-Reply-To: <tencent_A3F0B1FAA65495EB2220B5B72EB6E5AF1B07@qq.com>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.0.76
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: qq.com; dkim=none (message not signed)
 header.d=none;qq.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [83.20.25.208]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bc8dfb80-1918-4e66-3380-08d8fb830d3d
x-ms-traffictypediagnostic: DM5PR1101MB2203:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR1101MB2203D39E6059FD9D39AC1CDB9B739@DM5PR1101MB2203.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2zHUZnRfaYmaJXG3gqoNxfi8LRknrkYQIYVFODfyZqAYFhgm8iY+oEgyJnubObWY+xDr5lUWNBf4r8gCNUM2dk8AKi5LAs5/RaO8hBody2J+Dr62YUAWhP646uFJ+LwnoDOv3U3/RM+SVruGfugxfo1tGSlw5B/gsla7RTZ7KpK69YvzLue1/TSZxcjPgAcJl05hxXktfWH3+UWx06FpEXUP2MoY1ktK6r34oP6tvXbjw/Gi7+XJ6JLbR4SpxKHrMpTfgSKFXdfpuE6eCW2hEddcd30RyXDhvWf4ToEJljqG+BxMMZPDt4TNJoAfFka9wlW+kniJmQRIFpM6CcK+sXqHXij1fNjr5rcxpiTJTc4m0FmKTj+yuyjen7+bmDKx/Ue2BobKhdL6yQBiC3sO/4qc9pd1hUoJpHyfYlYTlxUXkvPmXTgPkpAhXZSNr8QbtsVwLg6EqiLx4pjdg5caojy3PyIEXksfgLZAbLOpaIaounROoMIZveN0KAmQcyJdJFjZvoW2u0uNUFJp/5jbqAG/mMGbXcxYbxe1nLt13xE5Spr9gDQWqa1yTQzSlDZf0xlA56BOn+amhfPRJ9Pzn/3PZQqFc7hgtcoJEYMsFJtMHArPdis897M4PsgCoXbOg4THuzDikA4UgtHEfv239kDndmNuyHr6hLswQMYPBpKayCqFnnBm85R9f4bhYOfDkkeq54Knl5YbCFnLfFe5qHo7C+7aqivtNTXhepQuO/ZvFtUDuPfE+rbvryNp5ruj
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(396003)(39860400002)(346002)(136003)(26005)(2906002)(9686003)(66574015)(38100700001)(33656002)(8936002)(55016002)(86362001)(83380400001)(7696005)(71200400001)(8676002)(478600001)(66446008)(6636002)(316002)(4326008)(66556008)(66476007)(64756008)(5660300002)(76116006)(66946007)(110136005)(186003)(52536014)(6506007)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?iso-8859-2?Q?kEWKhYY4iPHAz+qGbYmSTnhtISELQtIPNXMAa86DftHgcv9YQLh5wAzulY?=
 =?iso-8859-2?Q?d7zEfKzGrFJlEb+v6v3DJQVdPbe5MD8CwDKBSafOOl7YQ92eX0VPzGSrNy?=
 =?iso-8859-2?Q?ZFHjY2XvwvnEsZrD1IT97HynabJTLNGgjCqsr9xd/eZ1LByb+is/sdFQA7?=
 =?iso-8859-2?Q?I5B1GJsBrauVIHKBMYJE7ePV6E2q//DhxtlGYWCTb/B7pXv7LcRxQ+i2MG?=
 =?iso-8859-2?Q?uRav0uiBvlZzVAW2gjXQfbFwB2FetTOiOX37iNoaICepFJmXmHduSvgFRp?=
 =?iso-8859-2?Q?YSZJt6DRNOJMXn9EXhCvKRqyn/Rf+68Fo5ATe8FHcueO7D0IkEmcdKXtVv?=
 =?iso-8859-2?Q?bYRxED/hT/f4spXOAQBS1dqopuEAxMAhN9WoWhPS5X0uL9sGZe2nmK/Hz2?=
 =?iso-8859-2?Q?D9Q2Tge7kogAAklXJ5/YXeO7d47Sdibn3BuU0cA2SIwSQ5Y5g0BAp6ZIjZ?=
 =?iso-8859-2?Q?7B5Tckljt6lGD/GSW+NWC3IpSeU8kPAftmZewNMxMHxERddiDQwlS5i7hf?=
 =?iso-8859-2?Q?4wS6hOHvBiMmX/ThdPrKnbbP7rTx1/vDmhBQkjJ/ZCuxQfzkCzwjKX1d07?=
 =?iso-8859-2?Q?6zC+rG0Vpn8cWYyevltSfcssQML6jo1C8n/MtbqZ3nLfnMiQsVwWR6dCe5?=
 =?iso-8859-2?Q?+Url2gm3YGsEOnd04153nNnfDzJ7MQA7RTR0KCWbh8UMvQu5tIy5VrPTM5?=
 =?iso-8859-2?Q?fdPltXiWQoR+qiqRw850WAavnqt14Ipmdy6B8uTFZ72tzjhFpRlGqeC0kZ?=
 =?iso-8859-2?Q?KGSkE2bYvK70e9ij1I+VBDzqrqdrasSLIpCfZYQ64OcNQtSkLsksDWyO3t?=
 =?iso-8859-2?Q?st7GRbrTTBkUYhiOA0Pk6vQ8Q7OwyOKMmanLZmw07EqdaD199v8syBvoDs?=
 =?iso-8859-2?Q?Dml6LttSMpfIz0laCNXMrDLz3c6QElgJil8GDh3ECK1s5ra2fJ+IXTGjTf?=
 =?iso-8859-2?Q?u4C8tG2jHbdqynlLUl0zXFZxewFpPFelT7d93ccOJevL7CUgxqRQ326dEk?=
 =?iso-8859-2?Q?2CorNlhUGiP/7AlUGgTGDKP3qW5tewm82xOTnFebJW7nfa3VQV+bGRgQMt?=
 =?iso-8859-2?Q?FHztxXglIho6frHV/SsT9T/8dU0Ixq6ExlDBlGzWrd+TF3X5/ZIQ3iOHOQ?=
 =?iso-8859-2?Q?shJVYfpabJgLub02bl6Qjr637TQVYIlZ5oJeqj6ONEXaqOLJ/lDcVY1V8s?=
 =?iso-8859-2?Q?OmeFNBm1lo5xL8KlLIPoZBm01rPwEAN4FygTzIgnP65Nr4R1S/6VLMgjkO?=
 =?iso-8859-2?Q?qm0ZprfF+oiWEZppJhEkelRCJUvs3TSyTrhDBmr7rvnMKoyZn0IhNQDZLp?=
 =?iso-8859-2?Q?wESqRBGCuezvVYb3qKiqDdeqYUEaHOvaGg2yGC5e/k06eNQ=3D?=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc8dfb80-1918-4e66-3380-08d8fb830d3d
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2021 18:12:35.2853
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aAVhqgbumAuv4Io8F7QDexSTndSN63mR5a5MxXbHDJmp4plrxBzd8eprf7/NVkECZhsVZ73ZjE87AQt6NhuRtj0K07OwF0GUORjyA/LAzEI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1101MB2203
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>-----Original Message-----
>From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of xi=
ao33522@qq.com
>Sent: pi=B1tek, 9 kwietnia 2021 11:18
>To: Brandeburg, Jesse <jesse.brandeburg@intel.com>; Nguyen, Anthony L <ant=
hony.l.nguyen@intel.com>
>Cc: netdev@vger.kernel.org; xiaolinkui <xiaolinkui@kylinos.cn>; linux-kern=
el@vger.kernel.org; intel-wired-lan@lists.osuosl.org; kuba@kernel.org; dave=
m@davemloft.net
>Subject: [Intel-wired-lan] [PATCH] i40e: The state of phy may not be corre=
ct during power-on
>
>From: xiaolinkui <xiaolinkui@kylinos.cn>
>
>Sometimes the power on state of the x710 network card indicator is not rig=
ht, and the indicator shows orange. At this time, the network card speed is=
 Gigabit.

By "power on state" you mean that it happens after power-up of the server?

>
>After entering the system, check the network card status through the ethto=
ol command as follows:
>
>[root@localhost ~]# ethtool enp132s0f0
>Settings for enp132s0f0:
>	Supported ports: [ FIBRE ]
>	Supported link modes:   1000baseX/Full
>	                        10000baseSR/Full
>	Supported pause frame use: Symmetric
>	Supports auto-negotiation: Yes
>	Supported FEC modes: Not reported
>	Advertised link modes:  1000baseX/Full
>	                        10000baseSR/Full
>	Advertised pause frame use: No
>	Advertised auto-negotiation: Yes
>	Advertised FEC modes: Not reported
>	Speed: 1000Mb/s
>	Duplex: Full
>	Port: FIBRE
>	PHYAD: 0
>	Transceiver: internal
>	Auto-negotiation: off
>	Supports Wake-on: d
>	Wake-on: d
>	Current message level: 0x00000007 (7)
>			       drv probe link
>	Link detected: yes
>
>We can see that the speed is 1000Mb/s.
>
>If you unplug and plug in the optical cable, it can be restored to 10g.
>After this operation, the rate is as follows:
>
>[root@localhost ~]# ethtool enp132s0f0
>Settings for enp132s0f0:
>        Supported ports: [ FIBRE ]
>        Supported link modes:   1000baseX/Full
>                                10000baseSR/Full
>        Supported pause frame use: Symmetric
>        Supports auto-negotiation: Yes
>        Supported FEC modes: Not reported
>        Advertised link modes:  1000baseX/Full
>                                10000baseSR/Full
>        Advertised pause frame use: No
>        Advertised auto-negotiation: Yes
>        Advertised FEC modes: Not reported
>        Speed: 10000Mb/s
>        Duplex: Full
>        Port: FIBRE
>        PHYAD: 0
>        Transceiver: internal
>        Auto-negotiation: off
>        Supports Wake-on: d
>        Wake-on: d
>        Current message level: 0x00000007 (7)
>                               drv probe link
>        Link detected: yes
>
>Calling i40e_aq_set_link_restart_an can also achieve this function.
>So we need to do a reset operation for the network card when the network c=
ard status is abnormal.

Can't say much about the root cause of the issue right now,
but I don't think it is good idea for the fix.
This leads to braking existing link each time=20
i40e_aq_get_link_info is called on 1 Gigabit PHY.
For example 'ethtool -m <dev>' does that.

Have you tried reloading the driver?
Thanks!

>
>Signed-off-by: xiaolinkui <xiaolinkui@kylinos.cn>
>---
> drivers/net/ethernet/intel/i40e/i40e_common.c | 4 ++++
> 1 file changed, 4 insertions(+)
>
>diff --git a/drivers/net/ethernet/intel/i40e/i40e_common.c b/drivers/net/e=
thernet/intel/i40e/i40e_common.c
>index ec19e18305ec..dde0224776ac 100644
>--- a/drivers/net/ethernet/intel/i40e/i40e_common.c
>+++ b/drivers/net/ethernet/intel/i40e/i40e_common.c
>@@ -1866,6 +1866,10 @@ i40e_status i40e_aq_get_link_info(struct i40e_hw *h=
w,
> 	hw_link_info->max_frame_size =3D le16_to_cpu(resp->max_frame_size);
> 	hw_link_info->pacing =3D resp->config & I40E_AQ_CONFIG_PACING_MASK;
>=20
>+	if (hw_link_info->phy_type =3D=3D I40E_PHY_TYPE_1000BASE_SX &&
>+	    hw->mac.type =3D=3D I40E_MAC_XL710)
>+		i40e_aq_set_link_restart_an(hw, true, NULL);
>+
> 	/* update fc info */
> 	tx_pause =3D !!(resp->an_info & I40E_AQ_LINK_PAUSE_TX);
> 	rx_pause =3D !!(resp->an_info & I40E_AQ_LINK_PAUSE_RX);
>--
>2.17.1
>
>_______________________________________________
>Intel-wired-lan mailing list
>Intel-wired-lan@osuosl.org
>https://lists.osuosl.org/mailman/listinfo/intel-wired-lan
>
