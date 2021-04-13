Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C531435E857
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 23:34:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243520AbhDMVd6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 17:33:58 -0400
Received: from mga09.intel.com ([134.134.136.24]:27185 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230247AbhDMVdz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 17:33:55 -0400
IronPort-SDR: 9B8hNyZPHet4vKfDe/Olr6q56o4FVx++38mbSwfq8TlBqSsiL2Nx11ba5zSYdzU4/+jtIH1ZcY
 yNIOCQX013Ig==
X-IronPort-AV: E=McAfee;i="6200,9189,9953"; a="194616613"
X-IronPort-AV: E=Sophos;i="5.82,220,1613462400"; 
   d="scan'208";a="194616613"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2021 14:33:35 -0700
IronPort-SDR: uWwFLGQTAYKeaMt97OS8jhqfbu7YoLLp991/raMTzw/nfTgf1qCTL1oSFXggQ85Rixx26VfEdB
 dq/epV0Eg76g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,220,1613462400"; 
   d="scan'208";a="383443698"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga006.jf.intel.com with ESMTP; 13 Apr 2021 14:33:34 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 13 Apr 2021 14:33:02 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Tue, 13 Apr 2021 14:33:02 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Tue, 13 Apr 2021 14:33:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XWRDs7CUZTPrSIV3RAPQSxtsdNIbrttB+y0OtugOCx49noX23xR/+EN38el6wkAld8OGsADvkDVgpsqnQaw0TBfUjnMGkLmu11qMcXMdUhtqR1h/s9WQpLnjXvd2TyVNVxM/9EkfeED47+bwlECpnWQQgb/kccwUhJk9ScaHcMirKyHrGN5icMQzCi9RBRya2XkX1jbLE89nI7xoWjLXoHrkIJIUsmqevXeFMaC5i1coN+Zqnrf/xIXH1tsEPGWcAyXZkVrz3k1MpMoC8a7Zo7c5TJINv/A/7GQzILGJxJ7nY/5iyO5GGLJNEh1IwVJ06z5PZdoCl89Z8beRu2md8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4kApV0wN89+Csf19VapG+XygrdJEsq+4eAc3DE0q3SU=;
 b=nuE0CCqTdEOaa7Z5CCU/CHnZfusrsevyALVy8/R19y4gE2FKK0eYtKmXZkJTPlkX5yqBKJx5w988JrtUHbxirfbBR2mSB1+bMDC4YC7FGPQj/oQnpJcJnflhykTN1bDANeELDaj8PSw6zZIgznO5OB/6AKWx5Mnwk6NPKjs9rdnswEIpAECLfQW7zqQxLGR4KyZZ61M8DUlUoM+oGZX6RJFzOoUN4tFIkvVF6vlXIJxzA8QEZ16jf69d9QudRjyYe15ggKjqmtcCYaqhZ9TZgmp3WXDoJ9oCEygm26gLW5d9RtZnLFGyteU8BVgxg2x4pUHocQ/rswxKkd57a/0aCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4kApV0wN89+Csf19VapG+XygrdJEsq+4eAc3DE0q3SU=;
 b=IiLrqLdbzjdU1tjSXWGAoNCCyRu2Wpp5Dog6vd4x1krv+Q80J+r5ivKDNJVHXlzKNrhgixSM99qOwtxBncz2YyWDf6vQAE26v5ZmATM46qY4uM1vaAaLRyrQY1bNEO9eLzJpeOQzRHqRrgcdRFAgV+8Gx1Qsbe+IY/cfL00uZ+0=
Received: from MN2PR11MB4664.namprd11.prod.outlook.com (2603:10b6:208:26e::24)
 by MN2PR11MB4663.namprd11.prod.outlook.com (2603:10b6:208:26f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.22; Tue, 13 Apr
 2021 21:33:00 +0000
Received: from MN2PR11MB4664.namprd11.prod.outlook.com
 ([fe80::60b5:a75a:74d4:bc1d]) by MN2PR11MB4664.namprd11.prod.outlook.com
 ([fe80::60b5:a75a:74d4:bc1d%7]) with mapi id 15.20.4020.022; Tue, 13 Apr 2021
 21:33:00 +0000
From:   "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
To:     xiao <534535881@qq.com>, "xiao33522@qq.com" <xiao33522@qq.com>,
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
Thread-Index: AQHXLUs+VWmh6nM5fUSVYn6hAWVkL6qsfJ4wgAU6zQCAAUX2AA==
Date:   Tue, 13 Apr 2021 21:33:00 +0000
Message-ID: <MN2PR11MB466465F88C02C85A4A45202F9B4F9@MN2PR11MB4664.namprd11.prod.outlook.com>
References: <tencent_A3F0B1FAA65495EB2220B5B72EB6E5AF1B07@qq.com>
 <DM6PR11MB4657EB5A8040E7D5A9CB155E9B739@DM6PR11MB4657.namprd11.prod.outlook.com>
 <tencent_AAC300E9BCF5B21D7C99816BD69FA56E5D0A@qq.com>
In-Reply-To: <tencent_AAC300E9BCF5B21D7C99816BD69FA56E5D0A@qq.com>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: qq.com; dkim=none (message not signed)
 header.d=none;qq.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [5.173.168.12]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ea53712b-3c54-4e0a-94d4-08d8fec3b650
x-ms-traffictypediagnostic: MN2PR11MB4663:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB46634CE46FAC333A62C4A71B9B4F9@MN2PR11MB4663.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: B0oYyO7meAxz5eUSTMMtGs5hODXF6vuNFdMERfmn0w64MZSsA3OV7A8KU18lhjESOIQWgVNddzmRwoCB8w2L+43NhmbUl2QS9DYUp7ZjpQNDPA3zxCnmGm3xJ2qVn0pixSGWZRVXIKWTwEavYqIu1UCNN0tsW74DRpi/D2+Bs5Icf8CTU1hPvwGeuFGFC7sM5XLHBsNaxiU2qU8W59uLpycxnfOtATOpR2fx3E4NxnAyq+atCqkz2T7fUdZmLX40MYfJ4LHtNBFqgQ3+as+NFHY2ZY9QlSuQ6bcg/zRErpLib5cpiR9kYqJ6tk/MCQ27vKWTqGqqbVt1BRRpxQXUXmfJnCsI4KjE/5uBHO4CYUUZAnfrkGtz+xILWCaXQ0uwPgDh7IxxUSO9bLsaplQtHtT3z8s/glKEVnddWEF7PSDXXr9+LO9auYmBbgeoZMo+LrQXukJmFUZpCOJEoVRLCy4FluNb1M9hc/Mu6GBowyis8FUPqpm931pIq19ierPiJ1ZcQSLjyumZ0lhfo17Ur+kJx72Bu1NXbSoiWODYWaLmLqAdTNUUxygIEZYZxgCJZN2ThIeT3UL7G6XsVbaVFiyx8TmvIWsgWCilWKeYwwxO5JWx3xwRbCcMC4eIYyD4aNp4hKeEIPlcw54VJhz2A/D6j9M556gDlipBftuZx0Nh8SHkzh1Nbys0B3SDBYfe
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4664.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(346002)(39860400002)(136003)(376002)(71200400001)(64756008)(66556008)(66476007)(122000001)(7696005)(8676002)(8936002)(66446008)(316002)(186003)(33656002)(55016002)(52536014)(86362001)(478600001)(110136005)(26005)(9686003)(6506007)(54906003)(76116006)(5660300002)(4326008)(66946007)(66574015)(53546011)(966005)(2906002)(38100700002)(6636002)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?iso-8859-2?Q?r/6YnEoGqcI1GfeQH8zokpBELazm+xZVy/CmNyH2AgjYTBMGG2Vq0i6PTs?=
 =?iso-8859-2?Q?twfdwl6wrKBoERksFuXCkaVSvYlu/xantWNji4wr/+WALjIyijxmSxt9MU?=
 =?iso-8859-2?Q?Y4AlNHOxOswjVZFrhsbfuYj9CqefegB2cSTxs/6+Gwnw7iOFZAFkrDJgbH?=
 =?iso-8859-2?Q?U4BAzdj+xv1RBsNFroH3gh2n/cXflYE7rXNHxOrNP6k3PxohK7OrhJEAld?=
 =?iso-8859-2?Q?qx4PxHHoc0NCxxeJ9/V+aIwC2aXxzErvdrYfyUCVYkXGe0ZThttmDsIs4A?=
 =?iso-8859-2?Q?l7lQyOy2eUe/xVYY7GYyMaoCbims6hiSB/ZSoXZbuM7MRnGybLxXfdLgV8?=
 =?iso-8859-2?Q?30vB9zLmOJEBcq4tAasaGdwsTD4FRYmXCexdljjltq4Vmmh10rNyQARA6E?=
 =?iso-8859-2?Q?XzUgGSdhDwRIcl3Lve3+wsdugaCCtlDPuhog5Fhu+8/O+LqtvDska6ZnUA?=
 =?iso-8859-2?Q?XeKMNsR9Elm+DvXQCkWqGzZ2j+6Zm6oJRG4ATqRAPM7NwW0MfB9v57CjJL?=
 =?iso-8859-2?Q?crFxlopORDarU+NjzMgjOrPdfB1LRjNT3ZR7Z9kbu3trQMRAsL/x8rCvqI?=
 =?iso-8859-2?Q?g+sN1IUUpt71mBPnioMSh4+zYzCBDW+Sq+3h92OkPBBwL0Y8vKLW93krPk?=
 =?iso-8859-2?Q?40IZftxGiFnKSfaApCTnDY93h+mzr+aJjums2510MFYy2zPN9C5vPnxtQm?=
 =?iso-8859-2?Q?iKfk7TTWFwDF80FduHx1qe2RxFIYWTKFzLZ98vFJuj5zCAW9KOeRlUMZtS?=
 =?iso-8859-2?Q?J1r2HXVwK5knt9DUc6EpK3ISe7vUI38j0gQTYLA9mx1MQYEd7U06ExpitZ?=
 =?iso-8859-2?Q?H8YaWElnrAsFZkH/4LB27Hv3UdrO1FYL9/bz5F5QfZTTZUu36O+NkAHTPN?=
 =?iso-8859-2?Q?LOvLj9l0nBmF7qQ4M0pkxb5P+D98l32T4r1ZMZbFZ7SSBRj96jMNrhtZ/I?=
 =?iso-8859-2?Q?etH13LAD7oxNCg6lihd3g3zQPREj9sUEggie/HRqDU2Fd5rT/bCwwEsgaD?=
 =?iso-8859-2?Q?7AuCxYmFy40zZ4+c3hrm04UQe+XQUgesCtmTZF2Qlrefzo0WnPEf1Ig5J9?=
 =?iso-8859-2?Q?vJpqkj3LgMuv/odMN7pGu4btlttJRnGAHQIwvfUQQDvO3mF+3uSR0HePAV?=
 =?iso-8859-2?Q?RRIce3joCiwluga1rQqwEj3/45efHke72tw3llzlpsuhP4hVvsiLaVm0tU?=
 =?iso-8859-2?Q?9Ztww+16mqyoSZQsoKMHwE2I7jk9lVfFvy685esBdPnGJk9alI8xI/bZ01?=
 =?iso-8859-2?Q?3ufWgFW7PY4C9P+gHijYxOXJl9ztFcV/wZ2QbgP7aWbXaWF9PvtwL/obJK?=
 =?iso-8859-2?Q?jWtAOQgccU1IXKhSllnBtGoPTfGHkIzDQdV0tpqmS0zqSUE=3D?=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB4664.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea53712b-3c54-4e0a-94d4-08d8fec3b650
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Apr 2021 21:33:00.3269
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: j8fp9sShfpTZvP74jVEvc6/s8ujMZOnzuGvOKlu0wzJyxBon4DNd2vaxS6chWB/AEQu2oth2jbcNXNzJkjYniSiDVlYgKgsT1x3Kzo7n3p8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4663
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>On 4/10/21 2:12 AM, Kubalewski, Arkadiusz wrote:
>>> -----Original Message-----
>>> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of=
 xiao33522@qq.com
>>> Sent: pi=B1tek, 9 kwietnia 2021 11:18
>>> To: Brandeburg, Jesse <jesse.brandeburg@intel.com>; Nguyen, Anthony L <=
anthony.l.nguyen@intel.com>
>>> Cc: netdev@vger.kernel.org; xiaolinkui <xiaolinkui@kylinos.cn>; linux-k=
ernel@vger.kernel.org; intel-wired-lan@lists.osuosl.org; kuba@kernel.org; d=
avem@davemloft.net
>>> Subject: [Intel-wired-lan] [PATCH] i40e: The state of phy may not be co=
rrect during power-on
>>>
>>> From: xiaolinkui <xiaolinkui@kylinos.cn>
>>>
>>> Sometimes the power on state of the x710 network card indicator is not =
right, and the indicator shows orange. At this time, the network card speed=
 is Gigabit.
>> By "power on state" you mean that it happens after power-up of the serve=
r?
>Yes, it means that sometimes the boot state of the server is still in=20
>the BIOS boot stage, and the network card indicator is wrong(orange=20
>indicator).
>

I am still confused a little bit, at that point (before proper link is esta=
blished)
the NIC is supposed to be in so called pxe-mode. Which allows for some basi=
c
functionality. I wonder are you sure it happens "sometimes"? I would say th=
is
behavior is expected after each Power-Off-Reset of the host.

>>
>>> After entering the system, check the network card status through the et=
htool command as follows:
>>>
>>> [root@localhost ~]# ethtool enp132s0f0
>>> Settings for enp132s0f0:
>>> 	Supported ports: [ FIBRE ]
>>> 	Supported link modes:   1000baseX/Full
>>> 	                        10000baseSR/Full
>>> 	Supported pause frame use: Symmetric
>>> 	Supports auto-negotiation: Yes
>>> 	Supported FEC modes: Not reported
>>> 	Advertised link modes:  1000baseX/Full
>>> 	                        10000baseSR/Full
>>> 	Advertised pause frame use: No
>>> 	Advertised auto-negotiation: Yes
>>> 	Advertised FEC modes: Not reported
>>> 	Speed: 1000Mb/s
>>> 	Duplex: Full
>>> 	Port: FIBRE
>>> 	PHYAD: 0
>>> 	Transceiver: internal
>>> 	Auto-negotiation: off
>>> 	Supports Wake-on: d
>>> 	Wake-on: d
>>> 	Current message level: 0x00000007 (7)
>>> 			       drv probe link
>>> 	Link detected: yes
>>>
>>> We can see that the speed is 1000Mb/s.
>>>
>>> If you unplug and plug in the optical cable, it can be restored to 10g.
>>> After this operation, the rate is as follows:
>>>
>>> [root@localhost ~]# ethtool enp132s0f0
>>> Settings for enp132s0f0:
>>>         Supported ports: [ FIBRE ]
>>>         Supported link modes:   1000baseX/Full
>>>                                 10000baseSR/Full
>>>         Supported pause frame use: Symmetric
>>>         Supports auto-negotiation: Yes
>>>         Supported FEC modes: Not reported
>>>         Advertised link modes:  1000baseX/Full
>>>                                 10000baseSR/Full
>>>         Advertised pause frame use: No
>>>         Advertised auto-negotiation: Yes
>>>         Advertised FEC modes: Not reported
>>>         Speed: 10000Mb/s
>>>         Duplex: Full
>>>         Port: FIBRE
>>>         PHYAD: 0
>>>         Transceiver: internal
>>>         Auto-negotiation: off
>>>         Supports Wake-on: d
>>>         Wake-on: d
>>>         Current message level: 0x00000007 (7)
>>>                                drv probe link
>>>         Link detected: yes
>>>
>>> Calling i40e_aq_set_link_restart_an can also achieve this function.
>>> So we need to do a reset operation for the network card when the networ=
k card status is abnormal.
>> Can't say much about the root cause of the issue right now,
>> but I don't think it is good idea for the fix.
>> This leads to braking existing link each time
>> i40e_aq_get_link_info is called on 1 Gigabit PHY.
>> For example 'ethtool -m <dev>' does that.
>>
>> Have you tried reloading the driver?
>> Thanks!
> I tried to unload the driver again and then load the driver, but it didn'=
t work.If I pull the fiber optic cable off and plug it in, it can be recove=
red from 1000Mb/s to 10000Mb/s.
>

Well, it is at least strange for me.

Since on driver load there is already a call to:
	i40e_aq_set_link_restart_an(hw, true, NULL);
Although, in order to be called you need to have up to date Firmware of=20
your NIC. Maybe this is the case? Have you tried to update NVM of the NIC?

Another way would be to use link-down-on-close feature.
First enable link-down-on-close private flag, and then
perform link-down and link-up on the port.

Anyway I don't think this patch is fixing anything, it looks like a workaro=
und
that hides actual problem.

Thanks

>>> Signed-off-by: xiaolinkui <xiaolinkui@kylinos.cn>
>>> ---
>>> drivers/net/ethernet/intel/i40e/i40e_common.c | 4 ++++
>>> 1 file changed, 4 insertions(+)
>>>
>>> diff --git a/drivers/net/ethernet/intel/i40e/i40e_common.c b/drivers/ne=
t/ethernet/intel/i40e/i40e_common.c
>>> index ec19e18305ec..dde0224776ac 100644
>>> --- a/drivers/net/ethernet/intel/i40e/i40e_common.c
>>> +++ b/drivers/net/ethernet/intel/i40e/i40e_common.c
>>> @@ -1866,6 +1866,10 @@ i40e_status i40e_aq_get_link_info(struct i40e_hw=
 *hw,
>>> 	hw_link_info->max_frame_size =3D le16_to_cpu(resp->max_frame_size);
>>> 	hw_link_info->pacing =3D resp->config & I40E_AQ_CONFIG_PACING_MASK;
>>>
>>> +	if (hw_link_info->phy_type =3D=3D I40E_PHY_TYPE_1000BASE_SX &&
>>> +	    hw->mac.type =3D=3D I40E_MAC_XL710)
>>> +		i40e_aq_set_link_restart_an(hw, true, NULL);
>>> +
>>> 	/* update fc info */
>>> 	tx_pause =3D !!(resp->an_info & I40E_AQ_LINK_PAUSE_TX);
>>> 	rx_pause =3D !!(resp->an_info & I40E_AQ_LINK_PAUSE_RX);
>>> --
>>> 2.17.1
>>>
>>> _______________________________________________
>>> Intel-wired-lan mailing list
>>> Intel-wired-lan@osuosl.org
>>> https://lists.osuosl.org/mailman/listinfo/intel-wired-lan
>>>

