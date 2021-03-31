Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F34E13500CD
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 15:00:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235710AbhCaM7j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 08:59:39 -0400
Received: from mga07.intel.com ([134.134.136.100]:16914 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235470AbhCaM7T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 08:59:19 -0400
IronPort-SDR: GmbACinaiy/WXhe+b/gKJcLLKAUziiIbQWuJMGu0Qmb88MQg/7dTGtFdwCzOV9ktrW6mJfZasN
 YCDh3m2BLV4g==
X-IronPort-AV: E=McAfee;i="6000,8403,9939"; a="255983952"
X-IronPort-AV: E=Sophos;i="5.81,293,1610438400"; 
   d="scan'208";a="255983952"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2021 05:59:18 -0700
IronPort-SDR: UzZAM0ilnrkGSQR/7K5JLgv9egMEBBs5Cm0b/TrlWrp+jc4tE3+7a0sV+Ibr8qafIbAKQtDj0y
 QNggCc5D1cHQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,293,1610438400"; 
   d="scan'208";a="418665771"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga008.jf.intel.com with ESMTP; 31 Mar 2021 05:59:17 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 31 Mar 2021 05:59:17 -0700
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 31 Mar 2021 05:59:17 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Wed, 31 Mar 2021 05:59:17 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Wed, 31 Mar 2021 05:59:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nHSoUUOLrNdhLSIP2c2ndI8fhLdBzaPOBkokJUOe5KXgaWL+DHEjoJFc+lONzRw42uEmCiKwQYvYKsZQbEUOAMTZPlFIneuVmKrXkqafshIUTdPzhNdVDqbkfcyJKLnARS3IDpJ7hQkbNiMuhwnfabU6a6bEbRt/ufzTGIC+9e95f8bZLaOqRgR30jnZyAYvbeVQAxTd5M/vTVez3fGHxJ5vZEoUwQUp6oXa6wSyCU7Fzk07K+kvc9Oemd33WtCCfxkw90x91HFc3PmyuQ51mTP2Q4koX7xeoLzHwtXq7egRF4yi+qyveg1McRTw1lMv4CFwRM6VfwZXv/ZhcPcA0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P5CK8lkU8TKmI3TGEnxC9AwlgnbXO3VF79NgFbgh8co=;
 b=PyfzWKoIRLIfYC+Yp1Tm2XAkrFKlZUMBOX603QNNNQO5a5ciisOkoJneD9siQJUIJHUWzxN1HMxejhzRjFxCBF87+RBqtNJV75Vg7AmGu9j9idBv3su/Xty1oE3PowZsBmktPmq7Rlk6kWunzHSr8TCPX9xt3yhxmkay7SUSw8X+jSofME2QurVjzGrScnb9Ij1EsKeK4ukkx8UTlFJNCOj0rIhgVuYLOc9QCwQ+rEGgNAIJOZbRNbXEXK5TVzBpFHwAY5rvQsdIE0OtHpG+FcBlH1cSnbwQIXQ1sSGIayKkk9zFKIDtazpAWyn7QpuYuI3GXC5/Gy6ajzGFnyaW/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P5CK8lkU8TKmI3TGEnxC9AwlgnbXO3VF79NgFbgh8co=;
 b=licOYVMqETEP2pnCQn0vzobTzOh1j+/L3ugZICYJzwBqs0nrnNzk+UbUh2aJb7uw71qWoJkoCY0QYy2ZTloqTkg/W/cO73/VlhVC2D73bcQVnYC+nPjU+eEvbPQEcfq+dA0xPQ8JcoC7XnwFew8Z4nKD/r1la9gUev5CReJmYsM=
Received: from DM6PR11MB2780.namprd11.prod.outlook.com (2603:10b6:5:c8::19) by
 DM6PR11MB3082.namprd11.prod.outlook.com (2603:10b6:5:6b::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3977.24; Wed, 31 Mar 2021 12:59:16 +0000
Received: from DM6PR11MB2780.namprd11.prod.outlook.com
 ([fe80::dcb3:eed0:98d1:c864]) by DM6PR11MB2780.namprd11.prod.outlook.com
 ([fe80::dcb3:eed0:98d1:c864%7]) with mapi id 15.20.3977.033; Wed, 31 Mar 2021
 12:59:15 +0000
From:   "Ong, Boon Leong" <boon.leong.ong@intel.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        "John Fastabend" <john.fastabend@gmail.com>,
        Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net 1/1] xdp: fix xdp_return_frame() kernel BUG throw for
 page_pool memory model
Thread-Topic: [PATCH net 1/1] xdp: fix xdp_return_frame() kernel BUG throw for
 page_pool memory model
Thread-Index: AQHXJHEOQ1UR0FYQdU+G2gLgxz+tfaqbEBiAgAMBx3A=
Date:   Wed, 31 Mar 2021 12:59:15 +0000
Message-ID: <DM6PR11MB278069E8594DF5ABFB0FA8ADCA7C9@DM6PR11MB2780.namprd11.prod.outlook.com>
References: <20210329080039.32753-1-boon.leong.ong@intel.com>
 <20210329170209.6db77c3d@carbon>
In-Reply-To: <20210329170209.6db77c3d@carbon>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.5.1.3
dlp-reaction: no-action
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [42.189.169.167]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 20416b0f-c957-4294-0899-08d8f444ca1f
x-ms-traffictypediagnostic: DM6PR11MB3082:
x-microsoft-antispam-prvs: <DM6PR11MB30825303B7F7555384DBFC00CA7C9@DM6PR11MB3082.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9vMeF9Bisgu+6FC0JfDqj0RpiVkxG8tatKIONKNGoroeFvWo5z5QFMLmqpnCHV5Mg0lwoESWiXbH88SdsNCWUEdsUqH62jJJ+l5vqkZI9grE5Zpp7LB6wI4OM6yfGNwnyChgfbAbJ5TPIDBtT0uRcDPBdDb/3wYeDpBV8oIQtg29K/7L3Fy8+F8n7Jt2Fpq+SnKEsixdOrJcAGIohPj5awimpo38FvE2g2z3EwI/60MutJHxROpiXCVgmBs2dHe9Cqtc3wfb8e2WwcnfmvUXuXQDsFX4LBVslQr3u+9uGw4VMTYAvuQCnV8wiB4JNYFVuf6YJvnFjSEHJmNwtYxVDtP/44Wj8xzeWDWa3VC1RvU5UI3/sy6kv7FsXR+pzZXQvCN/xYKCpmlHy48EFCF5IWWiLH904XzMXHdDKUa8SME0WWuX5Oxz3+n1+/m9oZyLCXvZ+E8AdYI/hw/zZCnmbc/OtiAHOT9YN59EAOE8UBystvefOeCmlgFgA85SGqo83j4XUhvBp3LEpGGCAIlSNNzaxa+kg7XhArHK0j4RAPFoKWgXilvIfD59AYt9qKvlLRBJHOq/mEwNYGmnYC/fikkkML9O8Ts3NF1EQo/Yx2+d9gcWy7OQK6S2xD1Tt4QN+deMoqfRwc65SCxMmYHUAcQm/vZKZru57Lz0ltj237k=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(39860400002)(366004)(346002)(376002)(66476007)(64756008)(66556008)(71200400001)(66446008)(8936002)(66946007)(76116006)(33656002)(7416002)(8676002)(6506007)(55016002)(6916009)(2906002)(9686003)(478600001)(7696005)(52536014)(4744005)(4326008)(38100700001)(5660300002)(316002)(54906003)(86362001)(26005)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?hzW7OWbtkdbqUSqakh3yoE6Nk6JL9GvYOuGoUgZ9pnvgHm6ZVsbyaIfbNczY?=
 =?us-ascii?Q?UtGU8PYn3po4AqeyWlZ3tq4Qf5ofq+YA+FfKYTjlaXM53mRnOFBdQoIGLm/h?=
 =?us-ascii?Q?fszHYIj4Hq5fADS0dr1ND0mImYnX6/O0H0PeHVnCYun2bSNioJRcxYIXwxaa?=
 =?us-ascii?Q?KT2BBz1NOEbcgXjw+xXTtduv3UhNLnbsle/ClB8j1UwMwe+t+gTFsLK9zydX?=
 =?us-ascii?Q?CrzbJA03jb3mdhWjoAHfvkvUM/YeAbEgdkzbdsFdtV0pbX/d5kFj7MWb6K9y?=
 =?us-ascii?Q?YQEXh50gpxy2ndVjD8O654LhA4l5yens2HA3FSWdteyJihC+B1owYvpaJaDh?=
 =?us-ascii?Q?H0IkduL1TYokUhacLt7ZSpVY1C9YRLAGZjFvfhDG/2rTMdXHYhdtUbNRgdGs?=
 =?us-ascii?Q?2tRuJ1g3AcKbtJcyIPDIoOA3pyPwRjSSb8y6AVOiaO3CLkmGfPMXLtIORBGe?=
 =?us-ascii?Q?xGw25R8d5yUBe+10ZDfp/sNKt9hz5ODLAleSmvVP2dc2fD7pWQ+OD9bC3O0f?=
 =?us-ascii?Q?siQF76vPK/oLRm/Xi12OThnAldswDvKtIJ6L2viNsKXi8SRP1GyrVFtu3bWW?=
 =?us-ascii?Q?a1vWmNojvi2W+Xb/HHfR7y/H+K+xepDT/0OJdZYI0y8XK8QGRPpcZ1dav0Vm?=
 =?us-ascii?Q?ox7D+JNZcM/6VO1E07nJfcifQlW92VyFUauCC4tvtbGQg4poTzZGAGo6a9Gd?=
 =?us-ascii?Q?YOdJ/UhkqCuHcgj9jqT6JVJ4uwpmNhsnjQHxfJXNqLY//UuA5Y1CIHIC5zTQ?=
 =?us-ascii?Q?LDqJi48/ehkA0Jwpdq79lQ281GEjWRFQp5AQdbEFu1OgElOpu8CcrmPE9Yu9?=
 =?us-ascii?Q?FAxnayv5RL/5GCwbjt5iSYKGfuGtnY7g0/jjJt31DfsKSJCqAdweQy0U+VRJ?=
 =?us-ascii?Q?x0gNxhRyve57Wbpr7l98uDRCAkoyeUNiPXuerWfwBPdXlRFPxhS+irSShyUt?=
 =?us-ascii?Q?fiMLTMJMdCdIohTr84Y+yQzKRPmF8kXj96doFqp0N0UuIGpbtW0bG4gRKop0?=
 =?us-ascii?Q?jF1wZWoU5UISUv8XzmyybrBwkmllXn4/SWlYfNjRdolXJo1BcmvWTBJhtjk6?=
 =?us-ascii?Q?c6+saItMZBodYMBTC+oQFatfPjLVvo4SHYTsX6E2AFrztIMM3SinmLQUDzv9?=
 =?us-ascii?Q?SS3/agSmeCb2+l9LlDTireg+XJPOtQjNVUWWJwR+P0TzNCcn6wd7WN/cZhma?=
 =?us-ascii?Q?EVS2tMDE+oGY2CVsN2OT8Coypg3HTYFKTK5Hzg3yzWxUxUeE4S7Q8W9FFjEQ?=
 =?us-ascii?Q?jouESfMFedUwLuhIPFtbEL0IMBLkOysJc6vU45rf8i+n6kH5EZSbwnOhjkkh?=
 =?us-ascii?Q?ue0WFvCkQViRRsfmTFxQU1Wh?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20416b0f-c957-4294-0899-08d8f444ca1f
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2021 12:59:15.8200
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0mqRrvgD5HkASowaZhKsLFHgFaZgMJp2PsAgbNdeBKyJOGJjlouNSZBrtZ96O5OniitUuc146K5WTWBrGanFFFqKR6+AUBrH7hFFz1/qw8E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3082
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> diff --git a/net/core/xdp.c b/net/core/xdp.c
>> index 05354976c1fc..4eaa28972af2 100644
>> --- a/net/core/xdp.c
>> +++ b/net/core/xdp.c
>> @@ -350,7 +350,8 @@ static void __xdp_return(void *data, struct
>xdp_mem_info *mem, bool napi_direct,
>>  		/* mem->id is valid, checked in
>xdp_rxq_info_reg_mem_model() */
>>  		xa =3D rhashtable_lookup(mem_id_ht, &mem->id,
>mem_id_rht_params);
>>  		page =3D virt_to_head_page(data);
>> -		napi_direct &=3D !xdp_return_frame_no_direct();
>> +		if (napi_direct)
>> +			napi_direct &=3D !xdp_return_frame_no_direct();
>
>if (napi_direct && xdp_return_frame_no_direct())
>	napi_direct =3D false;
>
>I wonder if this code would be easier to understand?
>
Ya, I think this is more readable. Thanks.  =20
I will send v2.=20
