Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E233A54A2E0
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 01:46:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230470AbiFMXpF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 19:45:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230299AbiFMXpC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 19:45:02 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ABD532EC6;
        Mon, 13 Jun 2022 16:45:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655163900; x=1686699900;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=OrDXkeYGsIxu5zfzQD2y3EWqjPos1mdcXdD5gdZTRmU=;
  b=AMHOTEVne2gng4ps1X4QxiL/YGd7E3d4OduBznPYszoxa0uwlWMup9DK
   jtBDQYmvt3H1jv1/ynLMxiTNHZIOmzk6lEw/5N0+NvvSeoi0x1stHGnJd
   mccNwD+kxAINwp2irmFm2gv6/tKT8/zmYuo5Qp7/WJj9cQjm3m6LNpeTu
   YluyvuW+C+HajjKol/tvpqM6EfJ/lzsZmbEAJT3CKmIiMhCnKr1BjUKTG
   QDJ+szWNE9vX+We9ZPuufd2FzpD2ymHIOnaE6vt6wFknOXPvvXZZHbMRy
   vGj+71VulK76yv6XrkQoSNCySPQJ/LxobZ+GZ/vQShieDMRE9qCkEkHnu
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10377"; a="342414796"
X-IronPort-AV: E=Sophos;i="5.91,298,1647327600"; 
   d="scan'208";a="342414796"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2022 16:44:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,298,1647327600"; 
   d="scan'208";a="712229974"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga004.jf.intel.com with ESMTP; 13 Jun 2022 16:44:39 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 13 Jun 2022 16:44:38 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Mon, 13 Jun 2022 16:44:38 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.107)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Mon, 13 Jun 2022 16:44:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lT/X/dX29kYctSWa3xYa4ncn62DwGXde8C42KW3VJKiXVa5a3Urt2ZvvKxXpwvEmGwxx59F7Lfix/QyBCUBETWC/1HlTN0g/xilZ955GXh8p090ZyMrS7OEKQkIAFAxsBBADMnHKzd+fJL1nW2HLqCYAhI9hH88tLyz7xH3yq0ojrSm6eLTkr8YMJeGLLiYynL62OYQRwXSehShGDDSBInQ3nhMIQJv8wS1D9vSu7TJUnYaWzfTTvnf8+AiMJdrWojRYjFdRWaqKbHimgALrOe3aeH+C7BLsT1xb9cRVEJJZa+Lvm2qRoSDkGxhnzSEdJayaQvYZc5Jjy/79xNek9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VKYkUYAbZvM3WYfAhxe72yFkwCH8Tq+b2mOjrzj7tlo=;
 b=Yt5T2z4nH9CimnHZcuOUaKpd4Y7KcehGgYVxapwewA35qSO/pthxS0fboPLatjwcJyk7OAKk6f+lFSo9hLFBjfSD2CSOHsiRa14HjIA9yunXKdvZJsuQF+fhyNwbvy7dEW+05LIfiQM9GwDuJy/8F6jFQFzcM9tbl9sLZ5L2yOxXmu/+NQ4y/c84VotxBCYEyxDYeMAiBt74Vt1/hiELG53+DVnjEpRxlrSsoHncWLa/WWOnI6DgVwQBwM9txbavpbu1W/IDZ7HP4qARWd6xB2FFVzl/e996Q7T4a8HRyc4NvAPU5/5N9RYnknO95TEPnqgGcYh8ch4vQf5+ORYYuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM4PR11MB6095.namprd11.prod.outlook.com (2603:10b6:8:aa::14) by
 SN6PR11MB2703.namprd11.prod.outlook.com (2603:10b6:805:59::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5332.13; Mon, 13 Jun 2022 23:44:36 +0000
Received: from DM4PR11MB6095.namprd11.prod.outlook.com
 ([fe80::40e5:e77a:f307:cbb3]) by DM4PR11MB6095.namprd11.prod.outlook.com
 ([fe80::40e5:e77a:f307:cbb3%4]) with mapi id 15.20.5314.019; Mon, 13 Jun 2022
 23:44:36 +0000
From:   "Ong, Boon Leong" <boon.leong.ong@intel.com>
To:     Russell King <linux@armlinux.org.uk>
CC:     Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "Maxime Coquelin" <mcoquelin.stm32@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Riva, Emilio" <emilio.riva@ericsson.com>
Subject: RE: [PATCH net-next v2 3/6] net: pcs: xpcs: add CL37 1000BASE-X AN
 support
Thread-Topic: [PATCH net-next v2 3/6] net: pcs: xpcs: add CL37 1000BASE-X AN
 support
Thread-Index: AQHYfHsNtxdkwbZkPUWW5A1p+pyTZq1IPfaAgAS+HpA=
Date:   Mon, 13 Jun 2022 23:44:35 +0000
Message-ID: <DM4PR11MB609568BF8AE50B4506C6A3CDCAAB9@DM4PR11MB6095.namprd11.prod.outlook.com>
References: <20220610032941.113690-1-boon.leong.ong@intel.com>
 <20220610032941.113690-4-boon.leong.ong@intel.com>
 <YqLyP6ezO3C9Fe4t@shell.armlinux.org.uk>
In-Reply-To: <YqLyP6ezO3C9Fe4t@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.6.500.17
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 235cab11-4446-443f-4089-08da4d96ac75
x-ms-traffictypediagnostic: SN6PR11MB2703:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <SN6PR11MB27037428E4064C3B374F4684CAAB9@SN6PR11MB2703.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6qKrFTlyyb8rWLKcRgMLaRAzMqcoPSFZ+/Oh6wJY50dnqmuD/D+MVBgfmp1rrO5xvyZgtDxI/OQrtrpstEieNZTRaZz+ZQP66XHPTxNT93rdUjCb6o4dBz7/F2mcd1rySynwqmeJ73EeFY9bixY6zY//t6h7cbPpzu/RcmO+h/ReiBlKK2na6BvJ/4+7JpAo5kMWIZE78BE0qNIGivGYONUJ7p9O7m6KFOXim+Mr67P873V1rsi3wU04QytkZXEwk4lAc6zDbxSnqt8TLLWkGnViYZZfj2PTxB8uUqaTma9PlzoEwh2THv3OXvbPJ+64V3kksb/gjGnDoEzo0NvdckVW5ZTIe8bteZT3UXdRt5TQzF3EkeBQSND2+qii4OlkPiHsUK4zY7tWeDz2G6x/OtjOhO2eiry1YYDgdTE4PVXY45rJH8AdaCShe8sAQHj64cA9Qc8Xn+RdvjsXy/RI+/K5fLjUZUX+ZY89crcWWWFHeqBPuTQE5Yx167eFliUNOQ1kw01yYTfPEC+GbKJvfcmHnNrMdXkTZuiGzHBtfKm7eiWLwa9lVr7Jzdy9/QRAoSJY32rjdJDruHJ9dmYEE+mb7WCCEb0nbhIDcOgIgAtLl2TYoNjK4t8fNLdZGu47YB70tct6qqqwtqJpkisvcOZ5qMRlD841zBKJb99FPRsXJLpIor2g1zzNCoLn+WikEu8q69PxglJ4gU8guhoDJ1p7iRVCn9j+Ma6KMvpCiL32ewmvXYcub2hXl1ZX9pYyvW7lZ7X/kAZpvDuncFJUO57GDi0UlSf8JV/5L380ql8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6095.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(966005)(38070700005)(86362001)(8676002)(4326008)(7696005)(52536014)(5660300002)(64756008)(6506007)(66946007)(54906003)(66476007)(66446008)(6916009)(9686003)(66556008)(76116006)(26005)(316002)(7416002)(8936002)(508600001)(55016003)(82960400001)(2906002)(38100700002)(33656002)(71200400001)(186003)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?cEHRc63x45iUDQetgBcG2kEdDyA0cgWXSZti4kA7yjUU2R56mcFiRipt1n+V?=
 =?us-ascii?Q?R8oRPUiSKkGtswAuTx8PJhTCdm41yn7seqYYbPMP9tqe3pu2rK0Rv60VEyt1?=
 =?us-ascii?Q?Yivo/RooQ+JhRqL0zDwkrI5cumx63VriwpO5eIgOf5dOKHca2T0p6h9oe4Zw?=
 =?us-ascii?Q?4Q7ZoZ6V4KnxCAWoyKe8bVdMv4AughEd/QQ4QlDAy1zGoMMa9jnQmhhn1hpf?=
 =?us-ascii?Q?6vJyynm92GMv0abVztmbVIsNWvGluH4mq9QFyYjWOlpnFdZDBF0hmlo5o6Tq?=
 =?us-ascii?Q?P9HNEkh2zUTe7EHW870WXui4hCZAYC1kR7UeIroipkbw1T11jeXEpzoL2v/L?=
 =?us-ascii?Q?FufhOnnH7PqB8qNPI1Xlm9KaBLKUMK1JXfWF+szmIEhQXYweXYwMZZ6matVN?=
 =?us-ascii?Q?9QhKDhLraKiY3JHm7m8eEnHV/tQFUw0D4eCWNwzoLzhYLbxFpxzmLubzrFoL?=
 =?us-ascii?Q?0Danl/oC/AYSxAYx2/zlpFV8k2gcwfwTfJMAEXs1kcKtcbOpalmGjugqQX66?=
 =?us-ascii?Q?Mxd7xbQ+YIXpPJIUCR/X0Ra8b5F22UsO8En+/pbNi7Lmqp+sRyKW5zuACF5V?=
 =?us-ascii?Q?adgeiJTsyxWx218QibjmttXMHAUCe2tSst/gU2khjLm7UX2oY95e7TjCUM0l?=
 =?us-ascii?Q?69q7XYD06/4+4+HThvpvpM+2iPM4RB6dsTZ93W/YzhgxIMXAUJbwDuKRH6mg?=
 =?us-ascii?Q?yDDnITe3AcQ08LWdDCrjyaTVBqzczkQEqAbBcBl53o72tNtTd9402Fy8eOQ3?=
 =?us-ascii?Q?TtmwBDfizZv9hBag1ejDoTQi4lcatlIjPtMU7eECC5L2nfpTJ9Vnp2t3MdvI?=
 =?us-ascii?Q?2idCA0dZzelD+E/11HGD4clrWRz+17gJPKpP5VwFMohkNsPVEmN6UFixnfJt?=
 =?us-ascii?Q?xC7Z4jO9vuxDu+EEio76c8h9Tui27fyFSWzIJzdlxPnHfQPCEvgMQJgECA8g?=
 =?us-ascii?Q?CJ3gDXIgw7Bk0ENaXYHxLtNZN9oN8Ppy1Z/svlBHPOK/oub+48A0vkHORJOn?=
 =?us-ascii?Q?XR6KmNE6YwGAXkytBQJmzcjVLJ8VD6gI1p1RmAZhdCeQD1BHtMBYATjB4dA0?=
 =?us-ascii?Q?MQPGDpsQSCF3IjH+rq/TqjKxqqpCGo1vY/YEjSeNkx5pV0RWc+MbUdsVAHp4?=
 =?us-ascii?Q?foKR9wP555ujIaXgUpnn7a6PSBa6xC6DCUL9XH4M+ScBKD3BMwvhn38ZNpD9?=
 =?us-ascii?Q?qyJnN/n1q3q5xbR1B3bL39GZfsUa+K7gi1DrFFratvhTRLBS6Rpn/YptiX/0?=
 =?us-ascii?Q?6Qe9/P+bbUFkfQzP7c6dGFOPJTxWFDczYOqY29frZ0Ob2gefpeTlLmeeNnTN?=
 =?us-ascii?Q?1EDchP2PtKFfCwrV8ZS8lkPpQqd71Q9OWhIKbnTkmPj53SaMAXTtiLxp0zhm?=
 =?us-ascii?Q?99gnokhM+qus6ptK1srLzWFwBE90KWutIxFlS/V+aKQjoC7eAiYCZc7GzdCw?=
 =?us-ascii?Q?iWx31+lInKYHcYxPHudxf5AuDMeaxs2iQ42PnzfWYtBftO4HRA3w2I2+yWJi?=
 =?us-ascii?Q?KBGE58uQ7updZ+4PriuTkLF7oXTlsmRzAGafEDtFHto54fOFw51EE830vVU7?=
 =?us-ascii?Q?aL2ZF+qm2ow12H9au3KgHEptNnBEeJttJIkRjA7W7aml6kwPc4QDOBWbP/KB?=
 =?us-ascii?Q?FLCW0Tup+8I5/xpafhfISNkmnN2HyylWqVlfZpOnlniuDZ7wBbkVw6F2ElL0?=
 =?us-ascii?Q?xNcMGwwd4Sjysk1lIlK2wkI0iG76DXu6lOwtrvuPqrQ8Mrq0C5mXXD+hnvu4?=
 =?us-ascii?Q?G9P5mH6Cnw8baURP4CcuTYaeeSPbwVI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6095.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 235cab11-4446-443f-4089-08da4d96ac75
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2022 23:44:35.9676
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HLXTmtuDQKDyNjP/o2JPf8S3+W0boz0kUAcXcQ4PDCVkAkLRA2HiNnD2YoF0qLUpAFaVzze1a638rOJB2FN9O27xNKxPkw1Onxjj30byTJk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2703
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> +static int xpcs_get_state_c37_1000basex(struct dw_xpcs *xpcs,
>> +					struct phylink_link_state *state)
>> +{
>> +	int lpa, adv;
>> +	int ret;
>> +
>> +	if (state->an_enabled) {
>> +		/* Reset link state */
>> +		state->link =3D false;
>> +
>> +		lpa =3D xpcs_read(xpcs, MDIO_MMD_VEND2, MII_LPA);
>> +		if (lpa < 0 || lpa & LPA_RFAULT)
>> +			return lpa;
>> +
>> +		adv =3D xpcs_read(xpcs, MDIO_MMD_VEND2, MII_ADVERTISE);
>> +		if (adv < 0)
>> +			return adv;
>> +
>> +		if (lpa & ADVERTISE_1000XFULL &&
>> +		    adv & ADVERTISE_1000XFULL) {
>> +			state->link =3D true;
>> +			state->speed =3D SPEED_1000;
>> +			state->duplex =3D DUPLEX_FULL;
>> +		}
>
>phylink_mii_c22_pcs_decode_state() is your friend here, will implement
>this correctly, and will set lp_advertising correctly as well.
Thank for the suggestion. I will change it accordingly to use
phylink_mii_c22_pcs_decode_state()

>
>> +
>> +		/* Clear CL37 AN complete status */
>> +		ret =3D xpcs_write(xpcs, MDIO_MMD_VEND2,
>DW_VR_MII_AN_INTR_STS, 0);
>> +		if (ret < 0)
>> +			return ret;
>
>Why do you need to clear the interrupt status here? This function will
>be called from a work queue sometime later after an interrupt has fired.
>It will also be called at random times when userspace enquires what the
>link parameters are, so clearing the interrupt here can result in lost
>link changes.
Thanks for pointing it. Ya, it is unnecessary.

>
>> +static void xpcs_link_up_1000basex(struct dw_xpcs *xpcs, int speed,
>> +				   int duplex)
>> +{
>> +	int val, ret;
>> +
>> +	switch (speed) {
>> +	case SPEED_1000:
>> +		val =3D BMCR_SPEED1000;
>> +		break;
>> +	case SPEED_100:
>> +	case SPEED_10:
>> +	default:
>> +		pr_err("%s: speed =3D %d\n", __func__, speed);
>> +		return;
>> +	}
>> +
>> +	if (duplex =3D=3D DUPLEX_FULL)
>> +		val |=3D BMCR_FULLDPLX;
>> +	else
>> +		pr_err("%s: half duplex not supported\n", __func__);
>> +
>> +	ret =3D xpcs_write(xpcs, MDIO_MMD_VEND2, MDIO_CTRL1, val);
>> +	if (ret)
>> +		pr_err("%s: xpcs_write returned %pe\n", __func__,
>ERR_PTR(ret));
>
>Does this need to be done even when AN is enabled?
Thanks. Ya, it does not need. Will fix.=20


>
>--
>RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
>FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
