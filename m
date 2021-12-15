Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B14F447508B
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 02:36:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238921AbhLOBgm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 20:36:42 -0500
Received: from mga03.intel.com ([134.134.136.65]:40175 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235037AbhLOBgl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Dec 2021 20:36:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639532201; x=1671068201;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RHKW/3Sv5uBV6hwS+l8kE0iSEMaKBDYoLX7ZnNoKKNA=;
  b=PJvtwubpAcYPbX6lHYLFCzkQE+TMrymayzRdDeL94xO5klUI98i44h7R
   0iGivrpSEzQuj4UX+wJc5kGgbUa6c2cCHTWKLr2CunRz5qv4p7IrI1nr8
   9BLsBCOjj3WQtjrtfPKros8YTyxKhbS5OrTO5alEI2rhgwoZDJWDtOVyk
   CV8FnRIcvN16rSF3HyQxu2F+LwtWGjsJ1xi6jwdBMDO7bmJ4Yoj6Z7Lx9
   E8hQFjfxnWIyG9NugeaYcvYLyETv3d5nOlHeLdMeqVZN1YU195T6H35vP
   BDKbq0g1m9Lj+hnNx0wPxRTVQ/kksWawS26ExjJ3/7U+8f0J0Qp5Bsf1P
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10198"; a="239071995"
X-IronPort-AV: E=Sophos;i="5.88,207,1635231600"; 
   d="scan'208";a="239071995"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2021 17:36:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,207,1635231600"; 
   d="scan'208";a="505595357"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga007.jf.intel.com with ESMTP; 14 Dec 2021 17:36:28 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 14 Dec 2021 17:36:27 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Tue, 14 Dec 2021 17:36:27 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.176)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Tue, 14 Dec 2021 17:36:26 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JmO9OwXLO28Bs9ZeuTckGALR3f6DAfN4RPzMqkoX93l7vVMPX8gu40KPupuB//NOtuc14k+EJbHjbl1hQ14g81dRoPQ3IcYwe7AfV0GybEr7FFRH3Q1NW4PkAsGKsLjTmcHq/Lb0TULbJkqvoTd/ITNrFSEv7i3bOxc1bUTma5xZluCPt3Ov0a8+zq0BDmKxjno/GE0okg5QuGl381qNi/1BgEEdN/kIi0OUFaEgNNLuinLoCKZZhXsj8LHm5VfV0/OFoGIaJeeG65SceWaxtiljGGL104NNNYMuSvTo/J/wGgZ3FqAonwZEFMDhhsiqj51x/Rc3X2SpCjcO+v+XkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rn4U3rzCA7Kfn2AHuI3C7w8ZnPkQHXRE3SMGmOnofh8=;
 b=dGt5P/530VbGe21KsamZdKPNIQ8+GD+9QkdjWz9BQB97g5WEk3J2zEwJrc5I46DtQhqQ/nv0I1CW3ro+iFii8kXuJ3NfccnHdMCeswsjMj3rY3TxdZClpcmmb8eZrdxrENPz7rslTcLKJQiXPTKaL8Jk6CR34s9bVzxaIaM0NR5b1ogisvWYW/I1YqpEazMdVATnnTGgRpKaH9rB1gD7sp3NwOlqYTzQ3QwapyQKSy7mmBE4QIJk4bOcorpBAhmRomnu3nM6200ORAO6/MtdnR8tiD4dbUj7mQN/j9VWY4J/32wH5QTQkSvIiN2k6PIPataSJTHR03Xtfqlnmx2Edg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rn4U3rzCA7Kfn2AHuI3C7w8ZnPkQHXRE3SMGmOnofh8=;
 b=iMTcmHA1wTUWKnvnjIpACDDcd8Fg2fh40yvaI9d5voASE54Bu0afIX7dqAGDg9iFcxYACvk9qyOGhpkYnw7xHCGjOFydU4QuFA8zSSjq3OebwrIPyWL7kz4jGOhiS3GhA9EL26apF7BpNTOZM8j/NtMghPVCq/kSYBkQuq8eJ1s=
Received: from PH0PR11MB4792.namprd11.prod.outlook.com (2603:10b6:510:32::11)
 by PH0PR11MB4808.namprd11.prod.outlook.com (2603:10b6:510:39::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Wed, 15 Dec
 2021 01:36:23 +0000
Received: from PH0PR11MB4792.namprd11.prod.outlook.com
 ([fe80::a8e2:9065:84e2:2420]) by PH0PR11MB4792.namprd11.prod.outlook.com
 ([fe80::a8e2:9065:84e2:2420%3]) with mapi id 15.20.4778.018; Wed, 15 Dec 2021
 01:36:23 +0000
From:   "Zhou, Jie2X" <jie2x.zhou@intel.com>
To:     David Ahern <dsahern@gmail.com>,
        "lizhijian@fujitsu.com" <lizhijian@fujitsu.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "shuah@kernel.org" <shuah@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Li, ZhijianX" <zhijianx.li@intel.com>,
        "Li, Philip" <philip.li@intel.com>,
        "Ma, XinjianX" <xinjianx.ma@intel.com>
Subject: Re: [PATCH v2] selftests: net: Correct case name
Thread-Topic: [PATCH v2] selftests: net: Correct case name
Thread-Index: AQHX5yRnUK/BJh/89kydkZMBcbubD6wmkpQAgAFimACAAAaFAIAACCMAgAfI97eAABNpAIAAW4vqgABqmwCAAjMnDw==
Date:   Wed, 15 Dec 2021 01:36:23 +0000
Message-ID: <PH0PR11MB479298A68681810EE3C03637C5769@PH0PR11MB4792.namprd11.prod.outlook.com>
References: <20211202022841.23248-1-lizhijian@cn.fujitsu.com>
 <bbb91e78-018f-c09c-47db-119010c810c2@fujitsu.com>
 <41a78a37-6136-ba45-d8fa-c7af4ee772b9@gmail.com>
 <4d92af7d-5a84-4a5d-fd98-37f969ac4c23@fujitsu.com>
 <8e3bb197-3f56-a9a7-b75d-4a6343276ec7@gmail.com>
 <PH0PR11MB47925643B3A60192AAD18D7AC5749@PH0PR11MB4792.namprd11.prod.outlook.com>
 <65ca2349-5d11-93fb-d9d3-22ff87fe7533@gmail.com>
 <PH0PR11MB4792C379D6C64BE6BA0ECED8C5749@PH0PR11MB4792.namprd11.prod.outlook.com>
 <56ae3614-f666-4eed-cfee-e2dc7b7eb169@gmail.com>
In-Reply-To: <56ae3614-f666-4eed-cfee-e2dc7b7eb169@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: 77cc69cf-e131-4852-60f5-4b31ede70605
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: be1598f5-b595-4d6b-9bca-08d9bf6b4dc3
x-ms-traffictypediagnostic: PH0PR11MB4808:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <PH0PR11MB4808F1CA1EB4655C64F00938C5769@PH0PR11MB4808.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:111;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: euwa1E0sqlMPxEg2g7DkZOW5JsYt2UKbRJ7Etpn+wTvaKVX9qSUiDOep7FIQGg33DF6xXzq04hKUHnP+rztdm9JWsRm63Q0P6Whc6HbToaamGVupzyxxk6IQ8sOp2Dhy2avKocZIcIZkh+C/UOrZQQNV6l3hgZlHSzX7KBFev1q7UfyD6i8CB7tNG7IusNmSMokjWlnnYzOa0sCaWNDQhjs5O7THhN9QJdmRDfxevuhNQ0OiD8mCM/VHnIQiD5HVknjPoRo8bHNP+9Ca8QIs7uYBeGce2A8FNqdRVmaNzvQ6NnyDPzqMHmqyaoOjEs0xSNXL9YDvNeziD5tkAuGz9mbJho/njFqnrVhJd9fZiCaoZJDV8i47gS1qvODmzRqHAff2pHbWf23/9Q4sGZyBD/49JmViPHXFsM96d94ux4KasjBd5ezyqHGAopT5ELOQKbRrTcr3vbvCWi8HYkPCJJc2cp4M7SEiDIGI4RI1OMcvLEhBlzHG7ejOKyKtggJYsdD38ysQ0SX8L5bXxDGpa3LO+UNn2szN0uL1D4vYvoG9yVQJfxgpayFZ4jV4xs7aObB5CQA+W0B5qUVm8RGkNIMcJis0Orbf4bTVBOnRWFkz8y3dpEfmIyCLDCFGUtSmQPOs+We4BVRZsLmNSnyYhPLfVnoS/WAuFkQgnE0GJ7sR/xQwwTyy0W1AlQ6E9Nnb9TIYsCky4Q+M99cssfQLDOXD53N0Q2zdhLT8GVStzn8+YXWGDHm14PjA1c99f210z7jhadtHenG+F8kMCigZioayudqw+4NvgfujAUbVkm0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4792.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(122000001)(8676002)(26005)(86362001)(316002)(83380400001)(38100700002)(76116006)(91956017)(5660300002)(33656002)(53546011)(7696005)(110136005)(54906003)(966005)(6506007)(38070700005)(66946007)(4326008)(107886003)(82960400001)(71200400001)(186003)(2906002)(8936002)(508600001)(55016003)(9686003)(66446008)(52536014)(66476007)(64756008)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?v79LP3qOHKp439I3qojiWJdQpNoJm4jX3GvvffrMi4WsliZ9HlXIiofbrFVn?=
 =?us-ascii?Q?RhLhGWCKn2A8TWRvvYSHFAZlnmFn0K0p8EoSBYre9PBxB5c1K5dLmPV2+Qrj?=
 =?us-ascii?Q?sXa08wEg132Dm6fNG2zkwCqFM3KBUySSxscaIT6P0XumG5ktns3/7kpcYdk/?=
 =?us-ascii?Q?I7mc/xZvcGCK3rLVgQaGeGoVvXx0TzHb0T4DRWcE+fSusMxD9YWQMPBQCrz0?=
 =?us-ascii?Q?kpaaD9D4K6hfIyty970/Aq1i7zN5VeoWUqszVLyiSOgPESMm97f+v8zdv7mq?=
 =?us-ascii?Q?VFliodeQafCHJZPFkvpyyMCY02k37kUckpAJXeGnROpWidt0MW6dwAErD1iO?=
 =?us-ascii?Q?1MXEicW5mqttBKqowxRPaf3Z6D079iAnRL+z6hTmd72EPMMHuUfB/PB2hhh5?=
 =?us-ascii?Q?lZ4R0hZJqvRMAp9MdNxDNCEhyc8btumTxZcz/X7tZOYFZis4ka9NteBLym8S?=
 =?us-ascii?Q?a49PI847DYrRw/kYnDo1qOi1CDTZqyzk8rw9+0DXZN3RIx4Zv6qHwu224gE8?=
 =?us-ascii?Q?xps6RSTHPQ9okE5V3rL+6tfrsx6z0uaLylZXkVMI4KpDFjU/p5ROtesZm1L1?=
 =?us-ascii?Q?nEchWVrO/hZ95sc8fzAOfY0fOmAFmWLFONIONDChrltx73FxZDPhfKZ13/XA?=
 =?us-ascii?Q?YpmjHD2DK+RnNDi8g8tZr5C6gbh2g19XHMREAozFwhWv9u149hT6lbUqyWPU?=
 =?us-ascii?Q?1FztaKKeBmJgsL7Xdkw/yxbn8zZAw96O1K/XYBWq15jmiLfkCVq7n00Bihf1?=
 =?us-ascii?Q?zBvg5A7blOpTrgFBzBCeybnshU7RT5NNrX3L7ouzoVDqjZ+eKSirq2EAtiJF?=
 =?us-ascii?Q?cjWJf3/1erzwDD44vE1+n6up7RrheUTdmk2cYWEE3geVWarbRbISb/Czwg6I?=
 =?us-ascii?Q?E3U1NLvAPxZbgR43JzA77Zst3Y0jfkB2eryXaytXkAxICcim7GNCQgVWfRcB?=
 =?us-ascii?Q?Uf6Z+ehkKs6TJYoYraCTExNZwksRChw7qEy/aHuQ77u8h8BEWGaHaPBv1Z3y?=
 =?us-ascii?Q?maZ//GHxjd0D4iZ/jaGUyrBS4ft/du+DS8z2SY+Yo66qdQAWATM+laPAcQNU?=
 =?us-ascii?Q?nf7lPLQwU1Yz1FxwfZ1lMXHAY54L7kX8D3wu4WnKGr8moTYtRAFoPOlNdVpN?=
 =?us-ascii?Q?mNXCbv715DqfGaPVPWh9MqWdEE4LFk0GFkqo9cKlxyXuV3L6oFDrTPhLXghU?=
 =?us-ascii?Q?iTiMqp6XAivUu8Rr+05aFzPdjgTl5OACgNAKtK1fetAx4wLUd8xwDjccZdfZ?=
 =?us-ascii?Q?RhyG4lv4iJJFNhWvVeAxh7MzjrIBaNXlWhMITBHAK28vYnIsHq2wQZULfzw/?=
 =?us-ascii?Q?MlTQmn8mdIYjpn58GfZzXEuD5SjEiKdJ8HFJH8O7Ijv1ehr+gjZ6TitYt44O?=
 =?us-ascii?Q?hY3tHBOIAa35dmTbGIO+f9yKrKMAT37Mz5OwTW69JxvJJ9mqRyDcvn7ndZfg?=
 =?us-ascii?Q?ra019nTpTvLxSzO3RCO2CgRoLDr9a81AznCNxGMr2M0Uwr16BzRe3Oh3tbfJ?=
 =?us-ascii?Q?lGIcW4LcZeZUaqT4HVfHrUov6PAi7GXr9lHTXgiz/fcwbWyU1lIFurxv25Tk?=
 =?us-ascii?Q?DJ1uWoNCWccc7uKSP1/Mvoeo7Dsi6BZLM3MzXfaWCuMDyEso8Sr/+I51h9F+?=
 =?us-ascii?Q?sQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4792.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be1598f5-b595-4d6b-9bca-08d9bf6b4dc3
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Dec 2021 01:36:23.5054
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TPPYtxe2CiPupipFBydMY7foNwe/ZPkOC0cTO/rBXgPM0g7zv9oTX5zDc1XjNDniBYI5xqUmS+SAUSeNK8F1Ow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4808
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hi,

  I try to test the "selftests: Fix raw socket bind tests with VRF" patch.
  https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=
=3D0f108ae44520

  But the TEST: Raw socket bind to local address - ns-A IP  which used to b=
e passed became failed.

best regards,

________________________________________
From: David Ahern <dsahern@gmail.com>
Sent: Monday, December 13, 2021 11:58 PM
To: Zhou, Jie2X; lizhijian@fujitsu.com; davem@davemloft.net; kuba@kernel.or=
g; shuah@kernel.org
Cc: netdev@vger.kernel.org; linux-kselftest@vger.kernel.org; linux-kernel@v=
ger.kernel.org; Li, ZhijianX; Li, Philip; Ma, XinjianX
Subject: Re: [PATCH v2] selftests: net: Correct case name

On 12/13/21 2:44 AM, Zhou, Jie2X wrote:
> hi,
>
>> After the last round of patches all tests but 2 pass with the 5.16.0-rc3
>> kernel (net-next based) and ubuntu 20.04 OS.
>> The 2 failures are due local pings and to bugs in 'ping' - it removes
>> the device bind by calling setsockopt with an "" arg.
>
> The failed testcase command is nettest not ping.
> COMMAND: ip netns exec ns-A nettest -s -R -P icmp -l 172.16.1.1 -b
> TEST: Raw socket bind to local address - ns-A IP                         =
     [FAIL]
>
> It failed because it return 0.
> But the patch expected return 1.
>
> May be the patch should expected 0 return value for  ${NSA_IP}.
> And expected 1 return value for  ${VRF_IP}.
>
> diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/se=
lftests/net/fcnal-test.sh
> index dd7437dd2680b..4340477863d36 100755
> --- a/tools/testing/selftests/net/fcnal-test.sh
> +++ b/tools/testing/selftests/net/fcnal-test.sh
> @@ -1810,8 +1810,9 @@ ipv4_addr_bind_vrf()
>         for a in ${NSA_IP} ${VRF_IP}
>         do
>                 log_start
> +               show_hint "Socket not bound to VRF, but address is in VRF=
"
>                 run_cmd nettest -s -R -P icmp -l ${a} -b
> -               log_test_addr ${a} $? 0 "Raw socket bind to local address=
"
> +               log_test_addr ${a} $? 1 "Raw socket bind to local address=
"
>
>                 log_start
>                 run_cmd nettest -s -R -P icmp -l ${a} -I ${NSA_DEV} -b
>

apply *all* patches.

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=
=3D0f108ae44520

