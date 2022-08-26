Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE21B5A26F3
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 13:37:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232774AbiHZLhE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 07:37:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbiHZLhC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 07:37:02 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33CF0DB7D1
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 04:37:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661513821; x=1693049821;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vLure8hJ6KPW8cxv1yKj3kvTI2ahTJbOMPaV25w/4Kc=;
  b=bnerPixF4vj8BKxcRIjtZFMEyqZPDCdYZPVk2VQn4Cy/wl+2F818PK6o
   u0HnpAxJMazETGXWAtoOLf76cwfg6vxtzNEM27n2NxpeN7BiYM05+POd2
   B20XPLKMjQFoHEaOwQD7ctDV7QpLrPJmOUnMjVLWFba40Vfw2O+f6WjH9
   GYmKwnSGfGxg1F6ebBC1uGEZMWXvee0yjpuOz2ZbtC8ZDm2KlSRt1eqQl
   FpHfZgjCXR7e9k/T4BuosPlbzOyJanwPedCzdcaxE4qGPbc+RkrROMdUd
   och3xMIfLgL5CNPYY7PvAWXSILfmNSyDZQRhd5jGdIPJuKzx/C2BW8+0A
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10450"; a="292066191"
X-IronPort-AV: E=Sophos;i="5.93,265,1654585200"; 
   d="scan'208";a="292066191"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2022 04:36:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,265,1654585200"; 
   d="scan'208";a="587272090"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga006.jf.intel.com with ESMTP; 26 Aug 2022 04:36:58 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 26 Aug 2022 04:36:57 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 26 Aug 2022 04:36:57 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Fri, 26 Aug 2022 04:36:57 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Fri, 26 Aug 2022 04:36:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gHYCVtKodUdnz0GwXPBqjxY6cigVK5M8l31Xh8Eq4Ro6Cn63c/kxs9fn0QMlcHsgF5Xcw7tFwuYjKVk19c9t7FNu0nhqSqOwxB1Ap3lqzNNqxoF3sMxnXbZiX7U6B+2j82Ul52S/luqrF4rH/vSdmXX8S/3Btvj6Yh34GDk/PNXmlv7Or1IVLLsP+0x4Rr4rp8GfrBTGJFsRoQzPfiGedqrQNfOKtJkhzc+uk/kvK88kn8DeXEL5no4UCYokcPzazkE6jF8wp/EMxHoqyHFE9cUEQMxSqz1oys0/jJf48hkPgWqYEE8TKpnUGNM5kEa2KP+gDt6Slz3avT8Z2qDDIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ozGqHMv3wiBq+U53FypqXHCKJt/m0OZNFmamYdXwnUk=;
 b=kVvP3IbKDDsyBz4XUVmsF3sgD175CdfuJqTcvKuYT6q2dHCQjzdIDL5s1s8C3nGS6ZAbp5S6wCCzdKuJyuBS9JO8Xm0UthMVbGj89Mvt10HrTg4n9m4s0POVr/eYU/tuPJcZN9oDSvZpKcwRzTtyVDv0/BePC9pT9u99a5uuspXLO5SF65+M91TF3j3zP0OlixPA/1T2TZ2DRP/GlFFw4Kc18l/foGCZuWDbD6KEUaE+ljkCiI2qS5z5njFbNtYO51I1EK93k8+M8UeChTdoYBg8yaQEqmK962vcEhOnvt+z/w/FZKRHHDdZ7NVpZEwYnyb6vk7/Fm5qmWqWnemeLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB5776.namprd11.prod.outlook.com (2603:10b6:303:183::9)
 by BYAPR11MB3622.namprd11.prod.outlook.com (2603:10b6:a03:fe::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.18; Fri, 26 Aug
 2022 11:36:55 +0000
Received: from MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::545c:d283:fbee:973b]) by MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::545c:d283:fbee:973b%6]) with mapi id 15.20.5566.015; Fri, 26 Aug 2022
 11:36:55 +0000
From:   "Drewek, Wojciech" <wojciech.drewek@intel.com>
To:     Jiri Pirko <jiri@resnulli.us>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Lobakin, Alexandr" <alexandr.lobakin@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "marcin.szycik@linux.intel.com" <marcin.szycik@linux.intel.com>,
        "michal.swiatkowski@linux.intel.com" 
        <michal.swiatkowski@linux.intel.com>,
        "kurt@linutronix.de" <kurt@linutronix.de>,
        "boris.sukholitko@broadcom.com" <boris.sukholitko@broadcom.com>,
        "vladbu@nvidia.com" <vladbu@nvidia.com>,
        "komachi.yoshiki@gmail.com" <komachi.yoshiki@gmail.com>,
        "paulb@nvidia.com" <paulb@nvidia.com>,
        "baowen.zheng@corigine.com" <baowen.zheng@corigine.com>,
        "louis.peens@corigine.com" <louis.peens@corigine.com>,
        "simon.horman@corigine.com" <simon.horman@corigine.com>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "maksym.glubokiy@plvision.eu" <maksym.glubokiy@plvision.eu>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "jchapman@katalix.com" <jchapman@katalix.com>,
        "gnault@redhat.com" <gnault@redhat.com>
Subject: RE: [RFC PATCH net-next 0/5] ice: L2TPv3 offload support
Thread-Topic: [RFC PATCH net-next 0/5] ice: L2TPv3 offload support
Thread-Index: AQHYuT1EGbXS/DMrpk2b1r4Lo3Z3HK3BCpnw
Date:   Fri, 26 Aug 2022 11:36:55 +0000
Message-ID: <MW4PR11MB5776E6C92351788A0E55B6CBFD759@MW4PR11MB5776.namprd11.prod.outlook.com>
References: <20220826110059.119927-1-wojciech.drewek@intel.com>
 <YwircDhHhOfqdHy/@nanopsycho>
In-Reply-To: <YwircDhHhOfqdHy/@nanopsycho>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.500.17
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f2a30efe-5b4c-4ab0-0982-08da87574729
x-ms-traffictypediagnostic: BYAPR11MB3622:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KBx9TcNZxowzKYVSAlJyYVBgDe04cRWiCPv7Z/eiZq0fm05TXHkfCiLJxBBBsQnby8Wc0HMSWvxkMh/YdUpd5ZNaJdQKBX+W3jxWcBbrSdJG1Mqmbr1C+9Wru/0IjIAIr0lhMLRjPuJlCQYPXVPK1dWd3NPDV2raT3jRZ3ToSk3B1F9wn7v67TQ0qK5+6D4peKiV0GSrw5ai10Ybr7TaCiB9Gr2rKxVyLeHnchF2DKxLrIUHS/IDH+dQum/i58RxsrcuEEdy690/XMemi1DTeDo+1yWQB7JF392833/pav/GtCWvmhotE0acj96tq711yS/L6cG4fao0opi78h/tsXmd3NImJfQtZQiMI8v5NppfmjmG8/XHn4tEPC1QyA7SB4FdlGrI/G39sPt7qG+PlnpNPZIMMUGc1iTpte9vQa7bXvxgwVCqKHSkirX5wT147z3NQAoopsG+JSf9YVVMDmqTTRNGVeDMgn5VzngJ5WnOaZGQlzN6yk63UuF/4j0bLrAYRhDuakOi5IlGAa4wLuOc5FrlH6vRnv9kHFv0Ftf9DxbyjuZATZUTE8OKZXyH0wXbKgO2eooPZv4To1PpU42nD+W5jazBKd3TPG3XryGhCBnRhFJA3nHzM9pNec1xnDf3hWCv7hpqGTe/tJdWUp0KjP0Dqn6b7YHKMGrPZHxHM/TUBVKjohuKUnxR03At0wSPaOqSORoOjJ76BJEArISsPILy1FX/V96++2kdu+ZQjexrAujDwsUPlJNLyDphJ7hKxlC622dZjdhxHqLn9oprZTOSuJnz3f1qR0mIBq8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB5776.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(396003)(136003)(366004)(346002)(376002)(66946007)(83380400001)(64756008)(52536014)(7416002)(8936002)(478600001)(4326008)(66476007)(76116006)(8676002)(66556008)(5660300002)(9686003)(33656002)(53546011)(41300700001)(26005)(122000001)(7696005)(966005)(71200400001)(186003)(55016003)(66446008)(6506007)(2906002)(86362001)(82960400001)(38070700005)(54906003)(316002)(6916009)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-2?Q?NtNKjtD6GUlPWPTaPsZpEG+vvgS7xblS9OKAN8SKzAKeGYGcMkFTOHm69A?=
 =?iso-8859-2?Q?g6EpMfVxwdcPkbMR8SEgoC+Ggkd/aKWgnlV9Nxdp4XndH/x/n+k4x7uMlg?=
 =?iso-8859-2?Q?k6+tHXC45BS8YgmX8paNTCkxAhqGT+Po76xgGZkcAZtXTdOqnG4SzKkbq6?=
 =?iso-8859-2?Q?3CCdSAuC/8BX6lfTjwjAWRht6Yx5wftxEIhurltTXMgVs7M7fmOlpyXIYa?=
 =?iso-8859-2?Q?v3UzyXU0NJw5DLQIWHSmjMvXHh71iDx9G/qiFl2G794dKKThlj9yH62wg9?=
 =?iso-8859-2?Q?mP5Xi5M94bD7jU2ycbmvZmKHAsdpTRaNQoN2wf7YqqLfvwcWoEkAyVb4AL?=
 =?iso-8859-2?Q?fUaUTxsKoFizRHT1MoY0AgnB50gmhr2uiuN0cWu1KddKKvDFiVVkE0NS13?=
 =?iso-8859-2?Q?VwV8FEo8KaXVqtiBVCCuScqJelw8UoyLNR6iGKIEEWNoKuoJRgk7XSPK7Q?=
 =?iso-8859-2?Q?S4L8Us+RWvFfn7yfWBKep2fXB5e1qU80p3qXPC/+qOmtBSP/t+o8HhgkJh?=
 =?iso-8859-2?Q?LCPq8SkCoPcCe6mSwbFEDoBDIS3g/i60P2onG86pKJ3CAbK5Z7QtGE88Z3?=
 =?iso-8859-2?Q?SYqwsm9RkeA2FV9c2llyskbX8D0NEOzutpaxfqKdUXRARLxC6dn/tbI7LU?=
 =?iso-8859-2?Q?Sune6Gw+/X0ydOH2SjSVuBo3+1cQPAsmbGsPsPlDU3GZ2eEo7DsfJ+j3Fd?=
 =?iso-8859-2?Q?RCOZDNC8P1fAzldkeeGT+11i+aE/bhhcsFvOel632XEdNM3J0p1dwwt3qF?=
 =?iso-8859-2?Q?UmxYvTqNxXc2/YeuGmyoI3KfveLwqTkoJXOIDDGnuV5Qzzb9JWunyswN9v?=
 =?iso-8859-2?Q?jexHj15UOhX++eII1JEIPQiRhpc5p4iZy3khRjXyFc3X6PI3aJNEI7/8QZ?=
 =?iso-8859-2?Q?OLIWUuPPbbaNQdjHW3nw6zzXBc4uZZVrLbrYFLI1o302ZbRtgLTWELPs7H?=
 =?iso-8859-2?Q?Ju6t/LKIqkomxxzfMDih/ssiWItrOEqSV1xTb3vLVvuS+1MOHgmm7/Wb7L?=
 =?iso-8859-2?Q?La0Ho8hz3o8In/UFKdP755iytvqqCjIY7x862oIupiPZyEj8GpllBclKco?=
 =?iso-8859-2?Q?t4Fku0U6zaugoJsgjlWP/0mvWj/tfWR4O1LEEl1GPGKVq+KORW8emXE1OV?=
 =?iso-8859-2?Q?jsZItb0Hy0YMoYEfSf5sOxOnn/YLbeZL5R9TeJ77sEliT04EYIVDmYEqry?=
 =?iso-8859-2?Q?75R2hDTEmI0ucVStqFQkpVsICJH4fYkt4C9rJ1VzUP48S1yqNx4DlfI/ow?=
 =?iso-8859-2?Q?te0lTsaFp4ev77NUKCrhViENqxCCFFX2xvZtCZVcJM74pFgJ0BXN9skgDq?=
 =?iso-8859-2?Q?7bDK3BTpobFbyVYiR1e8kvvFV7PORP5/LSGED4TnMRcOwUFNOFRVcN4hF3?=
 =?iso-8859-2?Q?1/Az+ttQNjPBbC1neb1ZX+jkerlPJ1TijfOLVUVd21sxa7Yx2nfmpPLrL6?=
 =?iso-8859-2?Q?bd7ipssPqrpCkGjuwkdcQLQkQE/mV5DwzVbq9RcLFVdm/E8Ps8EdyazS5M?=
 =?iso-8859-2?Q?CHgsxzkYtjVsYTVxMfpKGztxTxvl+k+9n8cj8fbQAGdmfLoNczUttHj+s8?=
 =?iso-8859-2?Q?NEyKex/0MqzIqlJSF6IYpjb7ICz3aH21jtyfLmtW+/Tdw6clYH3tJf4IHX?=
 =?iso-8859-2?Q?n4b0Ffu6lhEjjH1d98fWtvJ+E8Bui1cV/8?=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB5776.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2a30efe-5b4c-4ab0-0982-08da87574729
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2022 11:36:55.1498
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: csjt+IJ9grLDtlkPpCR5YetJH0rqYqg+13tlqlPV936ZfhWJN5q+VnS+zDJQxKoSgh3XDiRv9YnSodb5z11FdbiMrIm9nhi1pJzaQgCbqCI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3622
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jiri Pirko <jiri@resnulli.us>
> Sent: pi=B1tek, 26 sierpnia 2022 13:16
> To: Drewek, Wojciech <wojciech.drewek@intel.com>
> Cc: netdev@vger.kernel.org; Lobakin, Alexandr <alexandr.lobakin@intel.com=
>; Brandeburg, Jesse <jesse.brandeburg@intel.com>;
> Nguyen, Anthony L <anthony.l.nguyen@intel.com>; davem@davemloft.net; edum=
azet@google.com; kuba@kernel.org;
> pabeni@redhat.com; jhs@mojatatu.com; xiyou.wangcong@gmail.com; marcin.szy=
cik@linux.intel.com;
> michal.swiatkowski@linux.intel.com; kurt@linutronix.de; boris.sukholitko@=
broadcom.com; vladbu@nvidia.com;
> komachi.yoshiki@gmail.com; paulb@nvidia.com; baowen.zheng@corigine.com; l=
ouis.peens@corigine.com;
> simon.horman@corigine.com; pablo@netfilter.org; maksym.glubokiy@plvision.=
eu; intel-wired-lan@lists.osuosl.org;
> jchapman@katalix.com; gnault@redhat.com
> Subject: Re: [RFC PATCH net-next 0/5] ice: L2TPv3 offload support
>=20
> Fri, Aug 26, 2022 at 01:00:54PM CEST, wojciech.drewek@intel.com wrote:
> >Add support for dissecting L2TPv3 session id in flow dissector. Add supp=
ort
> >for this field in tc-flower and support offloading L2TPv3. Finally, add
> >support for hardware offload of L2TPv3 packets based on session id in
> >switchdev mode in ice driver.
> >
> >Example filter:
> >  # tc filter add dev $PF1 ingress prio 1 protocol ip \
> >      flower \
> >        ip_proto l2tp \
> >        l2tpv3_sid 1234 \
> >        skip_sw \
> >      action mirred egress redirect dev $VF1_PR
> >
> >Changes in iproute2 are required to use the new fields.
> >
> >ICE COMMS DDP package is required to create a filter in ice.
>=20
> I don't understand what do you mean by this. Could you please explain
> what this mysterious "ICE COMMS DDP package" is? Do I understand it
> correctly that without it, the solution would not work?

Sorry, I'll include more precise description in the next version.
DDP (Dynamic Device Personalization) is a firmware package that contains de=
finitions
protocol's headers and packets. It allows you  to add support for the new p=
rotocol to the
NIC card without rebooting.  If the DDP package does not support L2TPv3 the=
n hw offload=20
will not work, however sw offload will still work.

More info on DDP:
https://www.intel.com/content/www/us/en/architecture-and-technology/etherne=
t/dynamic-device-personalization-brief.html

>=20
> >
> >Marcin Szycik (1):
> >  ice: Add L2TPv3 hardware offload support
> >
> >Wojciech Drewek (4):
> >  uapi: move IPPROTO_L2TP to in.h
> >  flow_dissector: Add L2TPv3 dissectors
> >  net/sched: flower: Add L2TPv3 filter
> >  flow_offload: Introduce flow_match_l2tpv3
> >
> > .../ethernet/intel/ice/ice_protocol_type.h    |  8 +++
> > drivers/net/ethernet/intel/ice/ice_switch.c   | 70 ++++++++++++++++++-
> > drivers/net/ethernet/intel/ice/ice_tc_lib.c   | 27 ++++++-
> > drivers/net/ethernet/intel/ice/ice_tc_lib.h   |  6 ++
> > include/net/flow_dissector.h                  |  9 +++
> > include/net/flow_offload.h                    |  6 ++
> > include/uapi/linux/in.h                       |  2 +
> > include/uapi/linux/l2tp.h                     |  2 -
> > include/uapi/linux/pkt_cls.h                  |  2 +
> > net/core/flow_dissector.c                     | 28 ++++++++
> > net/core/flow_offload.c                       |  7 ++
> > net/sched/cls_flower.c                        | 16 +++++
> > 12 files changed, 179 insertions(+), 4 deletions(-)
> >
> >--
> >2.31.1
> >
