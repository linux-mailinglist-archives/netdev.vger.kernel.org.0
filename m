Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF470472735
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 11:00:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239998AbhLMJ7K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 04:59:10 -0500
Received: from mga06.intel.com ([134.134.136.31]:56774 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235565AbhLMJzo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Dec 2021 04:55:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639389343; x=1670925343;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=y27sD+nq4gV85cCJ/RWsugRgnAMukEk0DcfDiK2cmY8=;
  b=LkoiQ0dbzIWswgO2ixIfm5p1fgbP6qklrObABfXhjqs/gwhuPSOsMKEK
   RhWIAmqlf6wo4qSkrSy4Rdn/MTAtmi0cZQI6fyyroL6vk4y6t9HWLy/YA
   7R5wKww6qxfWF9GgCLpCph59XG4eV5Pnpbkx4+i9CXvSmhpoycoHjfEcg
   Lc8EtuAZxiIU4sje+zwuxZyRqzIfDX1pzQAcuw/2imQ52vdNTggAau6FO
   zEeXQNHymw1aRhzTTCoqiSE2c6SKhO/T8JcttmoFViq+8JWt0Vx7C1hUV
   8ja2hJwqJi+vCmsYHr4JA3QaUh71uHuShCHfFujpoQOcL9toH19fOm37f
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10196"; a="299482377"
X-IronPort-AV: E=Sophos;i="5.88,202,1635231600"; 
   d="scan'208";a="299482377"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2021 01:44:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,202,1635231600"; 
   d="scan'208";a="582868342"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga004.fm.intel.com with ESMTP; 13 Dec 2021 01:44:17 -0800
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 13 Dec 2021 01:44:17 -0800
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 13 Dec 2021 01:44:17 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Mon, 13 Dec 2021 01:44:17 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.107)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Mon, 13 Dec 2021 01:44:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eqTMjSKRym/GbDw/fswAm7pVoo6n3vz+mKczISY/m9loK3uG1sFGriWmq290d8b+7XcH3CXiLSn5+izmo7qDx6LAncUfLf+oK13EkyysxYA2U5mTkRrpG/7DvS+p5cajZph1LtgawRXfZnwqAwy8HB37ebzyIe8Xj/W5Xe4qsjYzzzH/y6CrJndIgzKDP5CiiOKVJLpo8OtlZ42E9brfC9FwA38GfTDE8TO3q3k+7ZN4IsYzQxvzKYXPhvj7kARWWRqHWNO6s3ZHsnBtm+QayU9RdEHENFbOVkCgh93qqRtXMeCAHKT4ewqSxhasqTIf05upkzF8wsIhuef2zYN3cA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O7CuGpoEggptY42j6GSgT32Gbc1BS41aV8pN55EfkI4=;
 b=ROMxZMzI43F8ywGpp8BN+2DMX61QfTvwykZHlemXBLYpPyt6sAynK+zq8AIci9WcJhq37PkGuH7AUDFbTWG7jf/TnAACc/Nc7VzH0h3ohRBsj2vL/MTkJtWlmsI5smrLE5vmLSati1r4Td3c+kL3bhO1Va23Dkpvc2sykLaTXbZSH1/P35exFLK3b1ez6lPUHvAW/PnRiwajE/FxSM0U/L5du4JCD5yIW240bTsJHZa4bC6o+ekAdNkkTdPjPxAj4f4vc9IL3x7WF9rmiYfQ5TTd6CUG+QYTlwcLUhPAFHicKQCIWMo32js/jsXZlSjFJOuXy3bw9tmz4tAMQjh4lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O7CuGpoEggptY42j6GSgT32Gbc1BS41aV8pN55EfkI4=;
 b=zQrN/I1B/pxsRXlUZhe6xIJRumj35xBuCWDYsP3PpQld6QRpNt7/Tv6tXyp1rXu+m5Rg/ggwRk7k0vQnaaqycNKkZ5UaasteFE9g3JP7HhDpOZp1kCnkXTSURwzbEpR7eX1zmDrjGK3atSlIcAMXbs/qrvg9BxCaI1BJwwcLHTI=
Received: from PH0PR11MB4792.namprd11.prod.outlook.com (2603:10b6:510:32::11)
 by PH0PR11MB4789.namprd11.prod.outlook.com (2603:10b6:510:38::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Mon, 13 Dec
 2021 09:44:12 +0000
Received: from PH0PR11MB4792.namprd11.prod.outlook.com
 ([fe80::a8e2:9065:84e2:2420]) by PH0PR11MB4792.namprd11.prod.outlook.com
 ([fe80::a8e2:9065:84e2:2420%3]) with mapi id 15.20.4778.017; Mon, 13 Dec 2021
 09:44:11 +0000
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
Thread-Index: AQHX5yRnUK/BJh/89kydkZMBcbubD6wmkpQAgAFimACAAAaFAIAACCMAgAfI97eAABNpAIAAW4vq
Date:   Mon, 13 Dec 2021 09:44:11 +0000
Message-ID: <PH0PR11MB4792C379D6C64BE6BA0ECED8C5749@PH0PR11MB4792.namprd11.prod.outlook.com>
References: <20211202022841.23248-1-lizhijian@cn.fujitsu.com>
 <bbb91e78-018f-c09c-47db-119010c810c2@fujitsu.com>
 <41a78a37-6136-ba45-d8fa-c7af4ee772b9@gmail.com>
 <4d92af7d-5a84-4a5d-fd98-37f969ac4c23@fujitsu.com>
 <8e3bb197-3f56-a9a7-b75d-4a6343276ec7@gmail.com>
 <PH0PR11MB47925643B3A60192AAD18D7AC5749@PH0PR11MB4792.namprd11.prod.outlook.com>
 <65ca2349-5d11-93fb-d9d3-22ff87fe7533@gmail.com>
In-Reply-To: <65ca2349-5d11-93fb-d9d3-22ff87fe7533@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: b5b77509-21d5-0de4-7abe-3ad3b17b1c5c
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 88ee63e8-0e40-45d0-e6fc-08d9be1d1e34
x-ms-traffictypediagnostic: PH0PR11MB4789:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <PH0PR11MB478956ADBF3BE2CDE0F6C68FC5749@PH0PR11MB4789.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:187;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vjgHbjXIQ2YAVfBU3jteUJbB8wMUshml3yrJOm8mgKqWa+ey/gLeE6hYAtGs7D5lgtegZopGN188t4g7x1uaXjhXMehzKXlXwk0SvmXgoo4x+rDETl4OcvmTcUqhZJDkQVDb4M9ipvHNl5yK4PwnVZQx91U1CZfA5frIGIYOkmXVEKyZczH1Hfp1/pdMImY6lTfNGG2xJEKtWga6khOf86cc1mY8S1A840/NpgeWKJkGVsvj6ahCauW9eaIl9RFO59TGwglOPM8TPpTgtFo2iWPPO3NWWe1i1ri5CpB9GZGk420Iyl4hGJt/UGWK4/4omtLdel3HU0qXY+WoH/EsLeeI3vYgpL4VOHN1OavCmocxMvSo9TaVe0uuMqIC8x3ZrUbPUm7Q+V9ef2Fh4CKcKFs9IWW+JtIpu/R7ypCW0i/OKs85cEuC3uDchDKih07CPr//luLp+hFg92kBEF7gnS0MgmKMcm6RQ07GXQvK/dSDaURonFHorXo/hKbz3A6VvSCi+ZIaNVWn1KRD1Agm5qVjjKWc3iI5h2qKI/WDpDD3a4qOpx6Y00RWwDXX/mn0ds59zrjJqkCjG0eJs5zl56u+1kqyZnYFurnxQEbcU32i6ugu2QAp0TYZxn9qZ8aCDx+8Ig/n+baLRNZL1OrwqqGRYp9QVy7mX/SM+PLxqckOguPJ68clXqEK392ENuSGxP2sS+zWzuXd+OkfvJHPOYiC2I29J62Tz6sR9D1FbFfwmwV3XfS2Lu/W/nQ8XWfFODejkG0/T6jFDqgkp462wB7XySG60OQInY83BQvh3wE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4792.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66556008)(66446008)(54906003)(33656002)(64756008)(110136005)(6506007)(66476007)(76116006)(55016003)(71200400001)(316002)(53546011)(91956017)(5660300002)(8676002)(26005)(66946007)(966005)(508600001)(186003)(4326008)(107886003)(82960400001)(52536014)(38070700005)(86362001)(38100700002)(2906002)(122000001)(8936002)(7696005)(9686003)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?pim1QZWXY6xq3fRiPi6e8ck204aOwOf43pTS4F9KRym49WjDuDsuQht1aAWv?=
 =?us-ascii?Q?a0JLQ6A+S481D3aveEMm9MgBHns9kDPsk4a+VSG56GV+NqAqLJ0HCNkpNAKC?=
 =?us-ascii?Q?UCBkvuNFWuLWejNZHXMd28NEwmFGFSB2xIPq+8ikD84ydfAmd+sjij8ceP79?=
 =?us-ascii?Q?qFtkb4OiYVcZKyN7qRhPkpNKY+pBs9jjgUjCH/ko8fa+2M5SLRLjJbASmWV8?=
 =?us-ascii?Q?qen3vED0imd79Kro+Tdhr8VcFAeBWDYCo4eqpY9cLS1hjrz5MNRCaBrSwdNV?=
 =?us-ascii?Q?Uc8ZBRTW3jYJtUqt5fXtpxZedpAxUTFhqJ10257N0VYs/b8+OHQCP3nAueTD?=
 =?us-ascii?Q?VLpCXhSiAuvP4OsvNPEjVRyfVmk4WFJgcTbherax4ZG724sKMKtmUKyFp4tp?=
 =?us-ascii?Q?2ZMmQOWgdin4gvxwYu50PxxnbJ3a7WNpgwDrReMAMdPgX379st6a9CvA1BCX?=
 =?us-ascii?Q?mNghKrGai7RNcGUGbssfeC+L17BCFQoo+3AUX52SMfn7XDsDxzEb9VctDU+C?=
 =?us-ascii?Q?mteZ7fH1hwQkzIcnAE/1DOoYwMruA29kIdxVZD0AIV+X9DfbIWCPVo+IKe+E?=
 =?us-ascii?Q?UoO5E4mHuruZ/gO0XmpsOcDiYnlhUayxHOxfaJUqJ2FEGwQV+d58IM/+2qIw?=
 =?us-ascii?Q?3d7hggNO4T3gTHIYow4kwlHsesSdC0gzTMskiCKnNM2P7HDkdYB+tEr6kFV4?=
 =?us-ascii?Q?j1sSyT1H+Dber3plofbjfxMuWbAdJbgqH8+2gEXgjTd7ue1ZK93z/ZzyZg2C?=
 =?us-ascii?Q?bC15egcWjONOLPutN4R5szKdBFYYrQwV6CKtnsivGspwvMwV6Bt6WUGhT7lG?=
 =?us-ascii?Q?Rr7qaDCWcskAMmgzgggS16W2xkZ3WaQbetghOvfuPc8ktgTdXnm6U0U9kBsx?=
 =?us-ascii?Q?5zaAH/R/pSbExs6Mf99CTlk7lP5EhSDR1oMVXrIQ1OcsAecF1Vgz1+/h11mL?=
 =?us-ascii?Q?TKtwrokpPewfPsTN8orwN5BrMD77fYgbRKempHHri+sM5OE46wutOWpGxxXt?=
 =?us-ascii?Q?EduRNp+aYLlLP3tqT2WM3ziBCiVryMGpsSxnwT5ph/X06/6JeC+HZU0TuVPx?=
 =?us-ascii?Q?KWx6isikUPzMbzOQ7hAFowYzJlSAWCscYm5uvxpLz9VxfotmHsk4N/EqUUPB?=
 =?us-ascii?Q?Fa3lkavmiByIBXcXMZw8w6v32XYM7/tnjxOhTqo0DZeTotN39OGmYuKx/76C?=
 =?us-ascii?Q?zjqlMSZcG4IJ1c1ZkbLM/vgwQLmFqCyZppdcsRdWo1fS+aI2OWjqG3rDgFYg?=
 =?us-ascii?Q?maTlo9Jw16H98tBMHFn7LKXjr394MOQ6EByfoz3kq/sYKRUB3iJSRk4pKTsb?=
 =?us-ascii?Q?8blOV9wEEQASG5hJjMb8Vb3DozKlJ5frOlOItUwPMP6AfSIBtOZ4FmOVkREd?=
 =?us-ascii?Q?ZXZKPYNPXX/upxVZrJBHpIVso6jp9mbbe+wwksWBqhXTQlIVNGtQiGH0ggeJ?=
 =?us-ascii?Q?OaJorqw5BGectx7ASFVsA1NZlljWVAHqVKap3gsuGzUQRdqDgST9J3SV485V?=
 =?us-ascii?Q?Mh6ICNCIpclTfCgUxxgZprIuw6PwORLaoa2ehnmNcRzaiFJJHsNiie96oiVm?=
 =?us-ascii?Q?mhEfle5to7C+PPXugmHB8yPPyf/VTbwRn4EOXTybl1xA5kBAqdkLP+cCjzA0?=
 =?us-ascii?Q?HA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4792.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88ee63e8-0e40-45d0-e6fc-08d9be1d1e34
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Dec 2021 09:44:11.8673
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0i+sGDKAKTgXHgni+hGLbMm1cB7ez26byfKmVH62n6FuX5sZm1DXtdXWTgqg0ErXbi5VLsCiZuosjLg9cKJo+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4789
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hi,

>After the last round of patches all tests but 2 pass with the 5.16.0-rc3
>kernel (net-next based) and ubuntu 20.04 OS.
>The 2 failures are due local pings and to bugs in 'ping' - it removes
>the device bind by calling setsockopt with an "" arg.

The failed testcase command is nettest not ping.
COMMAND: ip netns exec ns-A nettest -s -R -P icmp -l 172.16.1.1 -b
TEST: Raw socket bind to local address - ns-A IP                           =
   [FAIL]

It failed because it return 0.
But the patch expected return 1.

May be the patch should expected 0 return value for  ${NSA_IP}.
And expected 1 return value for  ${VRF_IP}.

diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/self=
tests/net/fcnal-test.sh
index dd7437dd2680b..4340477863d36 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -1810,8 +1810,9 @@ ipv4_addr_bind_vrf()
        for a in ${NSA_IP} ${VRF_IP}
        do
                log_start
+               show_hint "Socket not bound to VRF, but address is in VRF"
                run_cmd nettest -s -R -P icmp -l ${a} -b
-               log_test_addr ${a} $? 0 "Raw socket bind to local address"
+               log_test_addr ${a} $? 1 "Raw socket bind to local address"

                log_start
                run_cmd nettest -s -R -P icmp -l ${a} -I ${NSA_DEV} -b

best regards,

________________________________________
From: David Ahern <dsahern@gmail.com>
Sent: Monday, December 13, 2021 12:09 PM
To: Zhou, Jie2X; lizhijian@fujitsu.com; davem@davemloft.net; kuba@kernel.or=
g; shuah@kernel.org
Cc: netdev@vger.kernel.org; linux-kselftest@vger.kernel.org; linux-kernel@v=
ger.kernel.org; Li, ZhijianX; Li, Philip; Ma, XinjianX
Subject: Re: [PATCH v2] selftests: net: Correct case name

On 12/12/21 8:08 PM, Zhou, Jie2X wrote:
> hi,
>
> I try to apply the "selftests: Fix raw socket bind tests with VRF" patch.
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=
=3D0f108ae44520
>
> And found that following changes.
> TEST: Raw socket bind to local address - ns-A IP                         =
     [ OK ]
> =3D> TEST: Raw socket bind to local address - ns-A IP                    =
          [FAIL]
> TEST: Raw socket bind to local address - VRF IP                          =
     [FAIL]
> =3D> TEST: Raw socket bind to local address - VRF IP                     =
          [ OK ]
>

After the last round of patches all tests but 2 pass with the 5.16.0-rc3
kernel (net-next based) and ubuntu 20.04 OS.

The 2 failures are due local pings and to bugs in 'ping' - it removes
the device bind by calling setsockopt with an "" arg.
