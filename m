Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 825D962F68B
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 14:46:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235226AbiKRNqh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 08:46:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235225AbiKRNqf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 08:46:35 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6EFD786C0
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 05:46:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668779194; x=1700315194;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=bZh5ppbAQGs2bxgjGopW9VcoIpnvt6+0fw2Q1ZIt0F8=;
  b=kVThxqK1CLTu1XqFmKyzAtUrPKHkbSco1w17oSoMfhALW9EySSP9aCOw
   PSfVa5qIcWsCGOLndKAfUUV8NabHoPx2EyKAX+LZOeFcB2e5jQODMW6aJ
   XXWt8k0/qx7cresgwQWl3+9XCb9TCpYkxztmMlLZZHtdQmXWbwsFvdEAR
   8IkOyKcn2/NjETXKfXYcimBRfPyzAWnE79ibLYDZ9WK6+F9vTsf9r3X5B
   NlzQmUzUWgGrhDzrNHWhDRSpvanN6EkSGVivjMdyKi9ZfSfUZhs+iG5Zr
   hAxGOUjtx9qZjJf6uOPuGNTIFXhuZLcH/qgcA072ZLcJjJotBbghOZmRi
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10535"; a="311840135"
X-IronPort-AV: E=Sophos;i="5.96,174,1665471600"; 
   d="scan'208";a="311840135"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2022 05:46:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10535"; a="640214583"
X-IronPort-AV: E=Sophos;i="5.96,174,1665471600"; 
   d="scan'208";a="640214583"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga002.jf.intel.com with ESMTP; 18 Nov 2022 05:46:34 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 18 Nov 2022 05:46:33 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 18 Nov 2022 05:46:32 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Fri, 18 Nov 2022 05:46:32 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.172)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Fri, 18 Nov 2022 05:46:31 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DfExSG9s4uqh9zuuwYqBAza3frQfm2ebvGfwjA9KGpb9ixQly7jcK1iAfMG4XTObQUb53aAE4HrGP06hHw1HRj62c3FVSi2nYXRcKupz9h0iyFzmdPg9xc+b0JpCVvltCW3dGfA8613Cn1CJERuIF2nHsGVNTdCPtHZpxe5/m5PD9sZzdIWhBplzmv67nJFD6/9Fy+g2PSqHfBMWLw/qyqbGW0/NeUXaUfypHy0Zb+J9bPrNxLDYQwHwaZRMuLsQUWT6Ly2PzPd6kiqGZRwOFJy4shleuCNnX/Ti8Rol1qxlHVMFdbftTCbLXPJke5G8Xon3fYECPhtXOaURSn3x6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iBxcgBzXCdHHeywGREo3m2hwoA5Xc7MCtImuWlVOamg=;
 b=oBn8/P3nLh+qJmgL0vbdSvRnLY3e3jUYH8DWifjcwScaGPBDYWjt3IUESwlECzVNLxHdmqQwT3zoC/P80TiUKZFVw25i62s/JeiP0RTidWNXpC3/M5Lj8MQYeRvDFDPyhW2Pl5BF8aZY38+1klPDM2Or8YJN/Y97h2r6f3t1dR0grvd102cMbmZfhQAWZoDK0EW1K4m4KR7RESYdDJ/2NEUE4l3pyA0pbiH5LczaHlLOCqKd7izAS31eL3Ft+BE/ZQKtiHixaZe5QqeQO0gOwM9Vp5nk2WLPmz3aGVgsMLD3tumhwkYWW4Kps/4BMa27Tmq56uFJk9NzPsBdf7o09Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5621.namprd11.prod.outlook.com (2603:10b6:8:38::14) by
 CY5PR11MB6440.namprd11.prod.outlook.com (2603:10b6:930:33::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5813.20; Fri, 18 Nov 2022 13:46:30 +0000
Received: from DM8PR11MB5621.namprd11.prod.outlook.com
 ([fe80::9f29:9c7a:f6fb:912a]) by DM8PR11MB5621.namprd11.prod.outlook.com
 ([fe80::9f29:9c7a:f6fb:912a%7]) with mapi id 15.20.5813.018; Fri, 18 Nov 2022
 13:46:29 +0000
From:   "Jankowski, Konrad0" <konrad0.jankowski@intel.com>
To:     Stefan Assmann <sassmann@kpanic.de>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Piotrowski, Patryk" <patryk.piotrowski@intel.com>
Subject: RE: [Intel-wired-lan] [PATCH net] iavf: remove INITIAL_MAC_SET to
 allow gARP to work properly
Thread-Topic: [Intel-wired-lan] [PATCH net] iavf: remove INITIAL_MAC_SET to
 allow gARP to work properly
Thread-Index: AQHY9Q7tfDtGCwjgxEu290DsQRvSp65Evh5A
Date:   Fri, 18 Nov 2022 13:46:29 +0000
Message-ID: <DM8PR11MB56217910435DF828FC14A4CEAB099@DM8PR11MB5621.namprd11.prod.outlook.com>
References: <20221110141444.1308237-1-sassmann@kpanic.de>
In-Reply-To: <20221110141444.1308237-1-sassmann@kpanic.de>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5621:EE_|CY5PR11MB6440:EE_
x-ms-office365-filtering-correlation-id: 62388435-8f50-4b7c-f5ef-08dac96b4bf3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eYnE7dofZrmohBstVamUNCAbxusx3o+tliI8SFJnVPmPpiCAWwAFBo1pBcJYZazXwBT+tteRUFTd5hKpyB2nHbnBsK2DU4fo7MpI0o16VsQvVOW3Pha/V0Z6JRGn/w/PZ2ebdAYDoCgum9dRcEtTOHPdz9guEm1tKfxZAtCX6U3IAzAWnRj4HW2yYjMgsInxGhHd6e3Clo66fehCuDypT0WYLkv2L4tn1qBVGm5olmQmkhcfgjnTvHtkQAU1X9pyiCutiIDQ2G66lt5x27je+ThIhJBJxyojC8YDsy3/Q9vf7Yp47qzpRCPyrhG8RXfqpumYYn1e81tkQm4G41/Xh6p9xGTyQ9kfOfBj9K1UB7fTUu+4voRUJQzx5vUyccv99mW3yR42EUVGXJRjxd2b91Nof+5Cv810EUXjzbvBiD/BDbBMFtzQpXYelACwad5r4YVvzznBhTfcZUvPj4GO7hQHe93U3S8Rj5/G4+m3n775i90FXbhtv2+5/eta/zTrRnniu/q9CiAJxdgDsv1SCx9ZeWId8o50rNLATvu9sPzBrUJ/7jh1R56r7ZiK0ej8jmU9YXm1D++L7ME1TfcTdqleFrhDXD+p+pnMTSJw2NW5BP5xoycJh4RVIVMLDkaZnzPsa5vugGpAaLPL0VwwGI9tEgvd8nidN4swS4bts9sXxdrdYGJKKOrvY44DL3J+YSn1jicHwoHO+rTek0JMLw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5621.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(376002)(346002)(136003)(39860400002)(451199015)(55016003)(86362001)(33656002)(38100700002)(122000001)(82960400001)(38070700005)(110136005)(66446008)(53546011)(71200400001)(7696005)(107886003)(6506007)(316002)(9686003)(54906003)(2906002)(41300700001)(478600001)(83380400001)(66556008)(66476007)(64756008)(76116006)(26005)(66946007)(8936002)(5660300002)(52536014)(8676002)(4326008)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?UAYC8S+g9JwKx+3v8EXGC2Mjc701WKGqgS5Jsp27+wInVQ34u3FSVUZ4/iWr?=
 =?us-ascii?Q?s0ErH18mQVnMzT34o+8s9R/camOR7AsVERaeoafTqxcBJ1h2wu9R6mC10WWH?=
 =?us-ascii?Q?9RI5mW+c6VZSiFKS6N7W59nUwZvqp7UgMoO3ibdv6iHbvXovMNMTaR1OFx1Q?=
 =?us-ascii?Q?ggoSCmp/Ud7zFWBMJuZPvykSbof4O4SazyKPejt440HBrGDReVfdE+qAQgPF?=
 =?us-ascii?Q?C5hWRvpr52KOB+XjxNrvlM0iX3zDpFxUSMawc6Aig99f5iWg9JL7n6bq9z0+?=
 =?us-ascii?Q?I4wWQA4KWxdHenau03F7BSPkRUAuRqjp4i4eG2jWwwbv78MGDmOU/DJtTyVd?=
 =?us-ascii?Q?WdsvvEKOBCb+zRxtigvnGZOXpmy05rWrgi7hIl2PrypvIYEfGwCLRoMg6Hb0?=
 =?us-ascii?Q?A5Kkdg3Kf4h2DP4qprCvorOCcmbDHOdt4vCJ9lYF1vZsStUOUMijWQODMTP2?=
 =?us-ascii?Q?AfWQnGPuLfDjo6VyrbAw24p6966vnoF22ArgCyuu7HF7VzPqudV0TjdGqcha?=
 =?us-ascii?Q?GcCzsyGvCsBlZfwqMLTL7UhvRoZOSfEGc+knCmHsR4vQvhO9Kefg0wvb9pZS?=
 =?us-ascii?Q?Ka5V4eAmpFG5hIaOJ74Yyk5qg0gtAmMk8JrA7u8UMVzYRLSCYMQETyoQGB8U?=
 =?us-ascii?Q?y9HVPfafPhtuW9sqvo3bck0W0rCayWzUQAD9NZkx5jjB2XR3eeZOBU4045Ps?=
 =?us-ascii?Q?f0BiynJnb/r3NtHpN4E44G+/BHtOeX3VUCojSOv+DEq4hn+G9FZXD1C/DY9T?=
 =?us-ascii?Q?vgFF9ZRl/SzC2lqhTjmP6PJeJP3ZZasTn7A2qEuDqJ1M2VQiJLHqko4ZEo+C?=
 =?us-ascii?Q?+R7ZDvVnUN/KuXQj21W05LqZpeo0BYz5oZklodyBAnoZ1qXNQDErMvwA1vo+?=
 =?us-ascii?Q?Yp5opYX1lEddJkFYTdvD1dI7STStpIrJsng9tZF6BKAZzuIlH6HO2OzCDaX5?=
 =?us-ascii?Q?dUGW8a4ycuaASfZPxU3pfmvv4uRQyybGlWSDPrTTF+5D72GcINAG+pqOomlU?=
 =?us-ascii?Q?GE249rfrwwvhHusOs9zFG4BaV2XGBmOQdYWbBlavAsU+LqY+Dmd22vj4eD+P?=
 =?us-ascii?Q?F1t1LwLWZGUfLQHOHzQdywR7T1xhHTg8SWqI/jcej115R60ZyDQ/l5Qs4+vO?=
 =?us-ascii?Q?aWKe0TXP5d8Eq7VyCI9mJnpqyxtw3jVLirPCz7zh1VV5zPk5PcsTdE/kZQ9E?=
 =?us-ascii?Q?K1Ph7/qYEzOL3CGhLui54SNxXGYgfzR+7cXJ+CWVsnQc7NwnMr72/VrIU/ZR?=
 =?us-ascii?Q?G5t6Tq+lvS/AsUnfE1st0VeT2Wr92Kui51jrESpT9FARYjDM2XGNM2P6EH/Y?=
 =?us-ascii?Q?yIZX7Y+On45D9vO6RsjaRWEWXYF7v4gFinVddw9hhgU9US5aq0h2ZFm+o0fZ?=
 =?us-ascii?Q?hPX4Qi1M7bx4itbf9UicYBQPql0TKHetebuW4PBWsjUrcLbTcgediGXmH0cn?=
 =?us-ascii?Q?jC08Ww7B7CLfYtMHwHAjc6R4Lib2IsZ+mYz7LnMbowrGOIE1LTP+4r1BrvEK?=
 =?us-ascii?Q?6NL6x9qXTM52QE/bNWv/TTlRhqUmKJtvM6fdntSwthwEEVmjQwyMh6Bqs/th?=
 =?us-ascii?Q?MAiu5ndYh8GjZuqQhQhZiQ8XgamzI+20C5ZNF75ZQg01BKvzV1iqRFMf6/RN?=
 =?us-ascii?Q?VQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR11MB5621.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62388435-8f50-4b7c-f5ef-08dac96b4bf3
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2022 13:46:29.8997
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2eCKF/NdCD16WuPXI3vwHgZFbeotAZAjU9V3Z32Cqkdtns2fgkGTrla+OQUjA2sTeo0zYtmiYXzVPJDKV3py5aNhywbBk4VE1k5b0oyzYzY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6440
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of S=
tefan
> Assmann
> Sent: Thursday, November 10, 2022 3:15 PM
> To: intel-wired-lan@lists.osuosl.org
> Cc: netdev@vger.kernel.org; Piotrowski, Patryk <patryk.piotrowski@intel.c=
om>;
> sassmann@kpanic.de
> Subject: [Intel-wired-lan] [PATCH net] iavf: remove INITIAL_MAC_SET to al=
low
> gARP to work properly
>=20
> IAVF_FLAG_INITIAL_MAC_SET prevents waiting on iavf_is_mac_set_handled()
> the first time the MAC is set. This breaks gratuitous ARP because the MAC
> address has not been updated yet when the gARP packet is sent out.
>=20
> Current behaviour:
> $ echo 1 > /sys/class/net/ens4f0/device/sriov_numvfs
> iavf 0000:88:02.0: MAC address: ee:04:19:14:ec:ea $ ip addr add 192.168.1=
.1/24
> dev ens4f0v0 $ ip link set dev ens4f0v0 up $ echo 1 >
> /proc/sys/net/ipv4/conf/ens4f0v0/arp_notify
> $ ip link set ens4f0v0 addr 00:11:22:33:44:55
> 07:23:41.676611 ee:04:19:14:ec:ea > ff:ff:ff:ff:ff:ff, ethertype ARP (0x0=
806),
> length 42: Request who-has 192.168.1.1 tell 192.168.1.1, length 28
>=20
> With IAVF_FLAG_INITIAL_MAC_SET removed:
> $ echo 1 > /sys/class/net/ens4f0/device/sriov_numvfs
> iavf 0000:88:02.0: MAC address: 3e:8a:16:a2:37:6d $ ip addr add 192.168.1=
.1/24
> dev ens4f0v0 $ ip link set dev ens4f0v0 up $ echo 1 >
> /proc/sys/net/ipv4/conf/ens4f0v0/arp_notify
> $ ip link set ens4f0v0 addr 00:11:22:33:44:55
> 07:28:01.836608 00:11:22:33:44:55 > ff:ff:ff:ff:ff:ff, ethertype ARP (0x0=
806),
> length 42: Request who-has 192.168.1.1 tell 192.168.1.1, length 28
>=20
> Fixes: 35a2443d0910 ("iavf: Add waiting for response from PF in set mac")
> Signed-off-by: Stefan Assmann <sassmann@kpanic.de>
> ---
>  drivers/net/ethernet/intel/iavf/iavf.h      | 1 -
>  drivers/net/ethernet/intel/iavf/iavf_main.c | 8 --------
>  2 files changed, 9 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/intel/iavf/iavf.h
> b/drivers/net/ethernet/intel/iavf/iavf.h
> index 3f6187c16424..0d1bab4ac1b0 100644
> --- a/drivers/net/ethernet/intel/iavf/iavf.h
> +++ b/drivers/net/ethernet/intel/iavf/iavf.h

Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
