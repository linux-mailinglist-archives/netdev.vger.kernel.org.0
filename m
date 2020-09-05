Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 341A625E51A
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 04:52:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728280AbgIECwa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 22:52:30 -0400
Received: from mga02.intel.com ([134.134.136.20]:10361 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726329AbgIECw3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Sep 2020 22:52:29 -0400
IronPort-SDR: 9rbNK/iTOJYEKHd+KcUERCF0Pksgts8UxVJRBvBgJR07rvtapvkHBU9gRZALG3yUEORYuiOPoo
 wNV6xHmEbToQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9734"; a="145566255"
X-IronPort-AV: E=Sophos;i="5.76,392,1592895600"; 
   d="scan'208";a="145566255"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2020 19:52:28 -0700
IronPort-SDR: XZhlot/3ryxZXnOsBli51gkPG/7/QWHGXAlIS2yGX/0G/ABjkVcEUbuW7a+xYLGtoTWGWlNWsX
 7DSYNWbPLJfA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,392,1592895600"; 
   d="scan'208";a="339978701"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by FMSMGA003.fm.intel.com with ESMTP; 04 Sep 2020 19:52:27 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 4 Sep 2020 19:52:26 -0700
Received: from orsmsx105.amr.corp.intel.com (10.22.225.132) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 4 Sep 2020 19:52:26 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX105.amr.corp.intel.com (10.22.225.132) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 4 Sep 2020 19:52:26 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.104)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Fri, 4 Sep 2020 19:52:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LmKJfJR0S2Q2vXKAABjgGdICzbM9w63QiDo6gTa8rKb9YIaJSWSIusBmwmnk7babi83VmvMzbk0Ovqoa81gCdfUaAD9ZuS8dz6pRRJJjHY7AMWnKwT2m7CxpJ9qG76xHyKCUy8OVDW3cOW+Hr7veYm3XkO3pg6Smlkn/SYR8ef7klkHCtO0JrrXHLMfxP1MjYXBTI6tStl4Ys5ZKVc9O2hAVJqNoJ3ifnshRZDqtefDFbR0EYU5Dgs58lyMu5jYlh+7K22tWK29ZsDgxJJbU6zgigkx5EV6aAaB2pm5JTDQvL4fQTRUNkGoyL4vpfYSSoAChAwTm61Ej+keMxbcl7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0EKusrxbKiFs3c5TYBLjlNICFhALnR8DSDy9WRMk2Oc=;
 b=CbVEmupxe5UffSduF2wOJxvBSxLI0cls+XLgPqdMG6CP+UCRM4Eqx6N5G2baqP3c2Mg7qBuNxqltSjYmV9ymUDetrlIE/oEvPd9Lo1FGMAmTCiJEOK8suKvsgKoS6pE6fjdWMYb5hmboXOh4l2RIynLQYIFclSISOXEDgHutncgT+Lz/bcbcYKrcG0SXQSFoMcpUSV42xHix1s8xFfH/2P8djKHqoHqkbFbvV4f2VaPIUSjeUTZYEdw7GLXs7C2wekuBKvfVsx4m02yGgw4yYdGWQFdR+90xGK2KPoEeStQk123ThXm55tBeTQ6cTeaytX0lJxNnToR+IjA7jc4dvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0EKusrxbKiFs3c5TYBLjlNICFhALnR8DSDy9WRMk2Oc=;
 b=Xp82wJ+IShkBVMGA/yPdq++S7c8zcIUxSdUD9XFMSv4iiIIJUOasYWhRYLH/t+roi4R71W3IfOcDkLAHMgHlnQq/novIwVCKEhA1hlRX4ngI4NB6eIz9G8JJA0xhdtnz1CUZL+QBGgP+xpUr6fJoL9MM9CeU5AslysbJJWscdN0=
Received: from DM6PR11MB2890.namprd11.prod.outlook.com (2603:10b6:5:63::20) by
 DM6PR11MB3322.namprd11.prod.outlook.com (2603:10b6:5:55::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3348.15; Sat, 5 Sep 2020 02:52:24 +0000
Received: from DM6PR11MB2890.namprd11.prod.outlook.com
 ([fe80::25c4:e65e:4d75:f45f]) by DM6PR11MB2890.namprd11.prod.outlook.com
 ([fe80::25c4:e65e:4d75:f45f%7]) with mapi id 15.20.3326.025; Sat, 5 Sep 2020
 02:52:24 +0000
From:   "Brown, Aaron F" <aaron.f.brown@intel.com>
To:     Dinghao Liu <dinghao.liu@zju.edu.cn>, "kjlu@umn.edu" <kjlu@umn.edu>
CC:     "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Jesper Dangaard Brouer" <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: RE: [PATCH] ice: Fix memleak in ice_set_ringparam
Thread-Topic: [PATCH] ice: Fix memleak in ice_set_ringparam
Thread-Index: AQHWfBq134ZnMgvhn0+BpxY5ermW4qlZZvIA
Date:   Sat, 5 Sep 2020 02:52:23 +0000
Message-ID: <DM6PR11MB2890B209C860067C2EF3AC60BC2A0@DM6PR11MB2890.namprd11.prod.outlook.com>
References: <20200827023410.3677-1-dinghao.liu@zju.edu.cn>
In-Reply-To: <20200827023410.3677-1-dinghao.liu@zju.edu.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: zju.edu.cn; dkim=none (message not signed)
 header.d=none;zju.edu.cn; dmarc=none action=none header.from=intel.com;
x-originating-ip: [97.120.215.99]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 21e2543b-e86e-484e-02d6-08d85146b790
x-ms-traffictypediagnostic: DM6PR11MB3322:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB33228C9D63D5BF3F8E10D8C6BC2A0@DM6PR11MB3322.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2582;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: C4hX8P/UY4ss1trXXy8R24pfqEu65tp9ESKRREwPyUzu/5fCSH9z2mnl7Vvec0SJ4DxCSy6kEk9a2grAzYXgCaAMuYZJ/Q3ub+a9Wyo80qwKBVmuJlFdXlrZncD8TCYgzU5YdiaPIcFW7KmeoDr3C5oebsXwnQAj6u3f6UpIT8s5xE+x3eHgu1rsY9ZjrdpYJz6hZjnN2aJTDO4TYEpmzmZ/CLV67gwnlesVX1dbes0kuGBun9/XUvAvTnFK+/eRDqGJGQyJX9dIVeA5EtpQcUgo3iys+vyANlIT+cKmLLh50tK/abRi9RanSHlqEoVDdxGBXFK5BZVMYPtu5dxGdQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2890.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(136003)(346002)(376002)(39860400002)(316002)(83380400001)(54906003)(2906002)(8676002)(55016002)(7696005)(6506007)(7416002)(110136005)(53546011)(86362001)(66946007)(186003)(66476007)(52536014)(33656002)(8936002)(76116006)(478600001)(5660300002)(66446008)(9686003)(4744005)(64756008)(71200400001)(4326008)(26005)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: x5M1m3MVseibNYLqn0ajFxjZgLAk6lyMmuhmpAoUPS3TA2kEwbweX5G3tkItRnubQBL1/vLigqkq26H2s02B7MhpzqD8dyvHqMaeCmfGkJ2JZogsNI/IWPaDKEGmxbzH03laO6tqRFiNYj86cfguORh54S9IGUkVT+a6YCk2D+O48EKj3LpH+cADIfhAzvuEeBSt9ttMOrGWlI14C0EGqcAEzyjAvuIZ2ua65Wt5hGXMPd3t/G6mt8t2q//Y+v734VIalWFjWnSc/X9suAeT1sevinkCllbiSCqn9YMgNVHPjhl1fz8/raI5kL767kp5nuHtK4UKqXrD7GL08RjNRnKAwmHs9KeIDxiN/SqFSDCRhevn+ESBRQYMdBCie1Ow7NY90afSCStge0GMoDJUwVVSc5a8JICfIBvtU3U8V8C3ViVwqWi2wA2Tu0tIsJBrkXHo2lrhFGdhV5tk+bXexUbtFMi6nzypi7paOhPySLguvgGgf3YpmNfGs+LcFbWsYhBMnHuPR9b/krwbVoIEFQbtGz2fJ54PomnHhHSr7nv9pXAjEZ9V1m90g7MqB8VqJQDslmCHQwKh4JyH/aKfJLXTad7JOB74r1ROXSUINDDb5+gEx4MukSYnBJnWk3C3PWbjjEpNh8qRiXKAvyMx/Q==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2890.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21e2543b-e86e-484e-02d6-08d85146b790
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Sep 2020 02:52:23.8286
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YGNYwkQbWtPtqUzbqoZsizLNHG5WUpPpTPui2G+K/jmfPcYrj0pD8TCVFfWJ5+Rnvh7uKsbzVP2EXYUMi7ImkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3322
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Dinghao Liu <dinghao.liu@zju.edu.cn>
> Sent: Wednesday, August 26, 2020 7:34 PM
> To: dinghao.liu@zju.edu.cn; kjlu@umn.edu
> Cc: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>; David S. Miller
> <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>; Alexei
> Starovoitov <ast@kernel.org>; Daniel Borkmann <daniel@iogearbox.net>;
> Jesper Dangaard Brouer <hawk@kernel.org>; John Fastabend
> <john.fastabend@gmail.com>; intel-wired-lan@lists.osuosl.org;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
> bpf@vger.kernel.org
> Subject: [PATCH] ice: Fix memleak in ice_set_ringparam
>=20
> When kcalloc() on rx_rings fails, we should free tx_rings
> and xdp_rings to prevent memleak. Similarly, when
> ice_alloc_rx_bufs() fails, we should free xdp_rings.
>=20
> Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
> ---
>  drivers/net/ethernet/intel/ice/ice_ethtool.c | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)

Tested-by: Aaron Brown <aaron.f.brown@intel.com>

