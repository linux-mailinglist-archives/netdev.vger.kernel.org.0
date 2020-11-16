Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA6FA2B51AA
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 20:57:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730823AbgKPTzh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 14:55:37 -0500
Received: from mga18.intel.com ([134.134.136.126]:52817 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726575AbgKPTzh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 14:55:37 -0500
IronPort-SDR: thzdlrE38s7l1rFsbuLV8ulwygdALbR8LDG3yWFjjFrIoNHyU73G8lvxv56jRbwawSENNaUOuN
 qHD1DvfAhklg==
X-IronPort-AV: E=McAfee;i="6000,8403,9807"; a="158582256"
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="158582256"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 11:55:27 -0800
IronPort-SDR: mycAAE0x/NgP2yD3vwwCl7A0n3beOJfg7Un/QscHpx4HTj6n8d9ZMk+q89n5g04AR9PXTSgDyO
 CdCPLFalTTGg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="430263803"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by fmsmga001.fm.intel.com with ESMTP; 16 Nov 2020 11:55:26 -0800
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 16 Nov 2020 11:55:25 -0800
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 16 Nov 2020 11:55:25 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 16 Nov 2020 11:55:25 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.170)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Mon, 16 Nov 2020 11:55:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ilSXnjY+7SYfWGUO7USnwWcnXL2jren4ab/+xJZqLYm09qrrsL7dUE2gYXH9xGLhrOKjy36DRF4IHQzp1oe8TbOboc79b4K25m63pvnAtDYqbmAH2OoKLK1wnixQz6hTKCkz42/uVxiFQzk/obnzcX2O6JJx3+u+fAM16lOvolnF8PWF5h0chGl+dS0kSkwx+6TB22QhLzVo0s8qOO5HL976e9ub0BKuCUA03dO6HrpyP6qj+QDTHph067bWYn9POWsZ7ma3zSIiRQbXZwUfNun9nSIhlLgANu2j2Kkl3j9SiB33cfm92x1yL8YCOmGEwgVPCiWxys8Q1Gn/Kw1AlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yGnvdSqNQG19X1kgXvU4UPd5wmRPPuhu1rC5lYoE0yk=;
 b=OzdQjZnDOJpc8/VUhSPHKkwoKJnu8poTyVGNupn6kQIQhbNFnzYrWlVC91hCk0KY4GLTAahVN9jApXG3xWc9S/iExzgFmK/Eh6rVfUuk6qPf/9f6aVeP3A7LjKYbnGXj6gofdWdST76Q0KlEVn9FElOla7VNFMPXqGOZ5nCD3eaSSNwjBw+w/8IGNBNXSDfko9meRSWRPU4k+xyIIIgK9E9ztqq8Kd0hMpvz6kYYre+Oy6ANb43vXLXm1eITNqD2xBCDq4fEjnrC51zRMZh9MqJrSkAt2eCZ/NqnGZ2+L+sXedALscMkqwiIEN0IvCrb/oz02XiJhNFbYwUD2LewRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yGnvdSqNQG19X1kgXvU4UPd5wmRPPuhu1rC5lYoE0yk=;
 b=ROOtrXPVXm8MWE8jdw0d8zCJmsGVI2VTh+c4GlTDB814eXgyLvZnLfCWF99tA+TUL1DaaSbXiggzOjvxuu3GNHTfkthswKTXVs2bp9YrB7jAdfc+TWJztC2ErJRFDUf5K7VFKYTQxT/lba4Pa3EYQzNeOeP8bCXOjhBSJWayPYc=
Received: from SN6PR11MB2751.namprd11.prod.outlook.com (2603:10b6:805:63::21)
 by SN6PR11MB2589.namprd11.prod.outlook.com (2603:10b6:805:53::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.22; Mon, 16 Nov
 2020 19:55:15 +0000
Received: from SN6PR11MB2751.namprd11.prod.outlook.com
 ([fe80::9036:edb4:2dba:2eaa]) by SN6PR11MB2751.namprd11.prod.outlook.com
 ([fe80::9036:edb4:2dba:2eaa%7]) with mapi id 15.20.3564.028; Mon, 16 Nov 2020
 19:55:15 +0000
From:   "Allan, Bruce W" <bruce.w.allan@intel.com>
To:     Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        "Starovoitov, Alexei" <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        open list <linux-kernel@vger.kernel.org>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "jeyu@kernel.org" <jeyu@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: RE: [PATCH v4 bpf-next 3/5] kbuild: build kernel module BTFs if BTF
 is enabled and pahole supports it
Thread-Topic: [PATCH v4 bpf-next 3/5] kbuild: build kernel module BTFs if BTF
 is enabled and pahole supports it
Thread-Index: AQHWt8cxfXnADugwHkCEjLA2hSU/rKnLJ4Tw
Date:   Mon, 16 Nov 2020 19:55:15 +0000
Message-ID: <SN6PR11MB2751CF60B28D5788B0C15B5AB5E30@SN6PR11MB2751.namprd11.prod.outlook.com>
References: <20201110011932.3201430-1-andrii@kernel.org>
 <20201110011932.3201430-4-andrii@kernel.org>
 <B51AA745-00B6-4F2A-A7F0-461E845C8414@fb.com>
In-Reply-To: <B51AA745-00B6-4F2A-A7F0-461E845C8414@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: fb.com; dkim=none (message not signed)
 header.d=none;fb.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [71.238.28.190]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ac283336-20d4-4142-75e6-08d88a6989b4
x-ms-traffictypediagnostic: SN6PR11MB2589:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB2589270AE8A8ED1AB928E3A0B5E30@SN6PR11MB2589.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:272;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: h7ObyTw9Y7ItNIux9B59GRx8DbT37CQ/cg9JXON7aQBMHNYW9Qhw/gsTFgQFkvKHCGIwKLyC0FGwUBBlc/5EZ6VJ6KMqKXm6J5CEbmJny4d0+ZvxsSsWZUYI1SLlsksjZKNoZ3RQ149qdGYpbQgh8ms7o5LHMQC+EKB65ie+zK823c5JiTXSVnH0wij75U2ER2yQw3ujqavdZIjXQoMrOdKrZhPUigyOWulrxpcJEpraWRxdBEc5Diy6InGCaagH7p0Kz2bFRy5jPXdGXfnN7DWvU31nzi9ZKXr+yBVd4kqu3gnDS6kthkj0p+GMVJya
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2751.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(346002)(376002)(366004)(396003)(66476007)(83380400001)(53546011)(54906003)(7696005)(52536014)(110136005)(66446008)(33656002)(86362001)(2906002)(7416002)(55016002)(9686003)(8936002)(186003)(66556008)(26005)(5660300002)(8676002)(76116006)(66946007)(64756008)(71200400001)(316002)(4326008)(478600001)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 6726/BdNJuE+gGuuIdS2625lhgFi8zOmdRrJQyg7IYpEoQAQMXTr4cuAIF1ZatL+qRnr2VGI6h05eqxlIAMDyhpWihSgjDQ7xjlIUf7w3kh2JnFDAyB+gqvoVqR5/dkAVMal/7/hc55CBm4/o947i60dPkSx8Zryzd30+dmSDDq1PDUxRAKmrC4ENz68VNtPfFZhJMDvO05AjmomtuAvDCaNGcMaZJAZI6XuP5t+9wPMSdWuMEUkHeESoLdto17cexHt01t5t20xRKYXBkSP6+mcXeFvrDEQpYB6SQlXnqiknHJO8NHCpcetycC9VRPWqhJDjRZRX0e4QYZFpm1OHVfJNg+p6U2xpGDN5TKKC5uqaDEfJXrgcyF8LLKyxuDxNav+H87P/EGitqFA7EByGwTBaGk+wLHLhGM8iqium4Ne6w/N1amhwqgzKDzZm1H99wF8zoYyA3bIYorJVlQEDHkHEs8Ya6IcIDUHS9FUJAxtqSNKZxgglLy52jfFqbqAsagCqQF7utVlQeJ5EJoRtJVJckmdnuWELqAeNHx+HK3nJr1tFnfJ6PoCuIgquqvOb2tVc3nlU1GGpy3PttOzufuV8MGZ1yuSQCcYJ4KT/hPpxhdUSRqctEPypaj8AJqLSyUO1XABawnBpel0xeQM8A==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2751.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac283336-20d4-4142-75e6-08d88a6989b4
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Nov 2020 19:55:15.8130
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: e5tU8yixrAvTMWK77RCXOXrOoGDhBY80hfA7c2YIgp7CtocY72NR45SMhSzpXbsYapTNmGd1xvNlIjyvz6zRXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2589
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Song Liu <songliubraving@fb.com>
> Sent: Tuesday, November 10, 2020 5:05 PM
> To: Andrii Nakryiko <andrii@kernel.org>
> Cc: bpf <bpf@vger.kernel.org>; Networking <netdev@vger.kernel.org>;
> Starovoitov, Alexei <ast@fb.com>; Daniel Borkmann <daniel@iogearbox.net>;
> Kernel Team <Kernel-team@fb.com>; open list <linux-
> kernel@vger.kernel.org>; rafael@kernel.org; jeyu@kernel.org; Arnaldo
> Carvalho de Melo <acme@redhat.com>; Greg Kroah-Hartman
> <gregkh@linuxfoundation.org>; Masahiro Yamada
> <yamada.masahiro@socionext.com>
> Subject: Re: [PATCH v4 bpf-next 3/5] kbuild: build kernel module BTFs if =
BTF is
> enabled and pahole supports it
>=20
>=20
>=20
> > On Nov 9, 2020, at 5:19 PM, Andrii Nakryiko <andrii@kernel.org> wrote:
>=20
> [...]
>=20
> > SPLIT BTF
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > $ for f in $(find . -name '*.ko'); do size -A -d $f | grep BTF | awk '{=
print $2}';
> done | awk '{ s +=3D $1 } END { print s }'
> > 5194047
> >
> > $ for f in $(find . -name '*.ko'); do printf "%s %d\n" $f $(size -A -d =
$f | grep
> BTF | awk '{print $2}'); done | sort -nr -k2 | head -n10
> > ./drivers/gpu/drm/i915/i915.ko 293206
> > ./drivers/gpu/drm/radeon/radeon.ko 282103
> > ./fs/xfs/xfs.ko 222150
> > ./drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.ko 198503
> > ./drivers/infiniband/hw/mlx5/mlx5_ib.ko 198356
> > ./drivers/net/ethernet/broadcom/bnx2x/bnx2x.ko 113444
> > ./fs/cifs/cifs.ko 109379
> > ./arch/x86/kvm/kvm.ko 100225
> > ./drivers/gpu/drm/drm.ko 94827
> > ./drivers/infiniband/core/ib_core.ko 91188
> >
> > Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
> > Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
>=20
> Acked-by: Song Liu <songliubraving@fb.com>

This change, commit 5f9ae91f7c0d ("kbuild: Build kernel module BTFs if BTF =
is enabled and pahole
supports it") currently in net-next, linux-next, etc. breaks the use-case o=
f compiling only a specific
kernel module (both in-tree and out-of-tree, e.g. 'make M=3Ddrivers/net/eth=
ernet/intel/ice') after
first doing a 'make modules_prepare'.  Previously, that use-case would resu=
lt in a warning noting
"Symbol info of vmlinux is missing. Unresolved symbol check will be entirel=
y skipped" but now it
errors out after noting "No rule to make target 'vmlinux', needed by '<...>=
.ko'.  Stop."

Is that intentional?

Thanks,
Bruce.
