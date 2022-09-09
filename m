Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B9EF5B32FF
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 11:13:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232086AbiIIJMJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 05:12:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231181AbiIIJME (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 05:12:04 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8115B4456A;
        Fri,  9 Sep 2022 02:12:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662714721; x=1694250721;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ICOjvMSnAyQp1+UzTZIbwDzSCH7+m2r3HbFszR2Q9mc=;
  b=A+dnV8qjcjed9CIAijWjzNQeEeOO8JprG9JSApFQ1O+V89JKJgj0tDur
   kg4HiOkVSinZQzrCiN89081e9adQSo9Bh2GYOqGffM2I1qs6n1gwv+1dO
   JL80k6eUHbUrv6Wa6XOE8adPCLm+0WWWrlNcEmZWFCb5ZSgjKLYrF0TU0
   YC2IJQDYAy2/AUUHfywAqW6FaHwrFw04HnXqXWeIkoLKotrc2R6gqiYwS
   4BjiYAQyonXxQGa6tNFtVs/1NCkSzX/t2qqp0Bs0PTXo8JBE0et+FN/ff
   4+GUeVsSPH1LjfhSqkOks5O4SUDVXUiFEYPh1VOXEjvHIGOGJYHO2jjbb
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10464"; a="323640085"
X-IronPort-AV: E=Sophos;i="5.93,302,1654585200"; 
   d="scan'208";a="323640085"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2022 02:12:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,302,1654585200"; 
   d="scan'208";a="610999970"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga007.jf.intel.com with ESMTP; 09 Sep 2022 02:12:00 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 9 Sep 2022 02:11:59 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 9 Sep 2022 02:11:59 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Fri, 9 Sep 2022 02:11:58 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.107)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Fri, 9 Sep 2022 02:11:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WNDQ5fFcgXfP5xD42vWiotohU4Cewb7ifNvkueyeXdwoxxyKHrCXLy9qhWRBhqse81alm/nIZ2CuPfdb69Vzn7HlZHRXmaO7UfmBre3n+WW0JxV7Qotizx5yGweFVJcQsDzpFQYv/WoJoK8sf8AkhCffgEJsh9zB0iCN2jq6xV4rFjCvJX165gxfJDeiB/gOGVSJ1YmCm6ZuFeKTks1C6pKoIReJhyI0FOchS8iYI2zeH8i5nQohOuyV9HMWxSLxIM+MWOKQTekU7cuieriFR/w8oJFK21zQMTIHBfFlKYmtKvzn98hk9XoWNOIvFXJi5m2xtF9vf0t0i8npuKNPog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ICOjvMSnAyQp1+UzTZIbwDzSCH7+m2r3HbFszR2Q9mc=;
 b=G3ZJ2bDsYHwo7Ugk1N/pddo8Dggfp0j5R58XMQ2j63olj4XXulx3VPCvQq/UL6mL8GFFffzXnpP1mjiWbwiPTZ22hyo+cxjSletpAMvwM3qE60X+CLLBQGLys60AYHIzHDY09fykriJCO+tdfEXWuKCORFU/tEvDaxzA4mAyPAfUupSP+xUzxxfPhOA2/Ym7W2Qj7PcL+JMrSvZ/qR6z4rTMsmH13+W0ALa/XNDkinkyOCfnQl9kYlEBdei6jCs2kePbqfAKQBecYQdXRtyaH7KJHsMevGYGRT/LziQ+2nAFWvakVniXCbJbDieWJuzK3lY1jRspwBErKWxtT+7Mlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CY4PR11MB1320.namprd11.prod.outlook.com (2603:10b6:903:2b::21)
 by CO1PR11MB4881.namprd11.prod.outlook.com (2603:10b6:303:91::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.20; Fri, 9 Sep
 2022 09:11:53 +0000
Received: from CY4PR11MB1320.namprd11.prod.outlook.com
 ([fe80::e0f0:b1f6:4bed:a539]) by CY4PR11MB1320.namprd11.prod.outlook.com
 ([fe80::e0f0:b1f6:4bed:a539%6]) with mapi id 15.20.5588.012; Fri, 9 Sep 2022
 09:11:53 +0000
From:   "Zhou, Jie2X" <jie2x.zhou@intel.com>
To:     Ido Schimmel <idosch@idosch.org>
CC:     "kuba@kernel.org" <kuba@kernel.org>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "mykolal@fb.com" <mykolal@fb.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "martin.lau@linux.dev" <martin.lau@linux.dev>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Li, Philip" <philip.li@intel.com>,
        "petrm@nvidia.com" <petrm@nvidia.com>
Subject: Re: test ./tools/testing/selftests/bpf/test_offload.py failed
Thread-Topic: test ./tools/testing/selftests/bpf/test_offload.py failed
Thread-Index: AQHYwnlSjM265E4AkkyO/WHWFY8XLa3ThXiAgAAjUx6AAHpSgIAAuFligAA2swCAABSnx4AABzYAgAGjqpA=
Date:   Fri, 9 Sep 2022 09:11:52 +0000
Message-ID: <CY4PR11MB13207E3356E486DDAD3676FAC5439@CY4PR11MB1320.namprd11.prod.outlook.com>
References: <20220907051657.55597-1-jie2x.zhou@intel.com>
 <Yxg9r37w1Wg3mvxy@shredder>
 <CY4PR11MB1320E553043DC1D67B5E7D56C5419@CY4PR11MB1320.namprd11.prod.outlook.com>
 <YxjB7RZvVrKxJ4ec@shredder>
 <CY4PR11MB132098D8E47E38FD945E6398C5409@CY4PR11MB1320.namprd11.prod.outlook.com>
 <YxmKdBVkNCPF4Kob@shredder>
 <CY4PR11MB1320BB40A48D230A1A196318C5409@CY4PR11MB1320.namprd11.prod.outlook.com>
 <Yxmh1PBj2BRsArD+@shredder>
In-Reply-To: <Yxmh1PBj2BRsArD+@shredder>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bf968b34-f71d-45b6-ec6f-08da92435600
x-ms-traffictypediagnostic: CO1PR11MB4881:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FPd0HCSo/sGbBROXHjm1ufHOv0DHSRJhzG3DbUYhszzWEgCUVoZsoWLXXK0QqGmJ9KvM4NBjuJvEWJeJo8g/xqT20k6UIZZzhW2utiwcj2dLwPyg3qkOavinmnJysm7OZM++fJ8B/XzVusCFT4iuZ2RhNBJ1S7ZPvmQZ5i6NvKAQ94RwZjNO7ZHNmzsmpsRqK2DIqA6v+BKU3VUYMpWK5PpAxs2e78ODQX7p0nq8RYa+foyGZa1Joyfwe/FOlU4ZnAnV2MSb9iYM5rlIU8DmCiS/Da9TqqxWsaaQJVfz7nUUisxPOZ50V1SkwW8eQtySAbXFX1BOAZOfGQ0qhNsMWa5FtNH92MmpdWQMF5imPDfDvc0ZSCOTmezehqgRieBOmSTmKedSw6M0LkTXlWu/nB9fT135uvaNV2v1Bl+ndrkJpKIao7WfEDM4AGlcDcqJ72BmfLfSJqYxqqpuLmDi5Gp0IrkIc9fSk42v9HcSC6DmiYr2lLnFRWl5p/igKHe2f40RqtOr7ZDwYvk6mU/dUycJ+Tk/InF9azJebOnlPZna3kTfDXFauMPse+CBP40Jf1hUfJ64jmpCJC08tAJD791diTaetL2UF/0lGXliNz5wIeKO/IgbhTFMlym0yoz2XNVIagf13xR5ogxKGFvRXkbUpdBkDyLFJmPoksQLUfS+lYld+4ZdK2KMLXL2a6PaixQvtHFn/0JO1b/5cPnN64yEW8qLKygpIvHGJ9EfstQg4fh96Y12GoSsUM0FyFy1e/+BwSuie14d9SFRRS/A16Tg3x0g22/aKUlbInkPUeY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR11MB1320.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(39860400002)(396003)(346002)(136003)(366004)(316002)(6916009)(54906003)(82960400001)(8676002)(8936002)(7416002)(38070700005)(52536014)(5660300002)(122000001)(91956017)(4326008)(38100700002)(76116006)(55016003)(66446008)(64756008)(66556008)(66476007)(66946007)(41300700001)(83380400001)(478600001)(7696005)(9686003)(26005)(6506007)(53546011)(186003)(71200400001)(2906002)(86362001)(33656002)(579124003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?IMrbBfmN1j2ZEYBEhmzW6b2aHa6dWcvP3EMHJCmAYhAcBXEenYW5BsqGrkXe?=
 =?us-ascii?Q?UH5EjyjdFhA4TkFXcXTJ9dxFAZ+u1CSVKqil5ltZGCRgdvgV9zhoTELH16R5?=
 =?us-ascii?Q?prW29WEv+DaBr8CK6F0A0Nbi52lSDKWT2YIpm/f4pJWpB9eUD48bDyNItP9J?=
 =?us-ascii?Q?d8urhstJm7lbgWCdTszCfHQmrZn6LIWDdaMWLLN2H2iL8eX6TQwxtdXxbB3h?=
 =?us-ascii?Q?FYEoP5w5/WR3zS/n6nMH7ESQ4DDHxpy8GmWGmgd7gFCK+Ra1hBD3zDqdvMFA?=
 =?us-ascii?Q?jbF5eq2Rdz8ZAnV7/OCydCPK2FZsWiXnbyIMBebJkkXtGeUXaSuvxfxv0rDb?=
 =?us-ascii?Q?/vOU7mtM83QnUNfArxWyFzxb6MZSMI9HOd87PnwrMRiPXmFIHNHpIK5v9x3c?=
 =?us-ascii?Q?UZwAPx3IEjUVHLJSm3SUfxqORPZms/fbF+oB7uaqI/VslPNMf5x68i2mlrpY?=
 =?us-ascii?Q?xyoefp5Vd8Cl2X51qaUmmzEIuq4hiKhVpeaK8NmjX07NTwMtredHgcFnfP+p?=
 =?us-ascii?Q?xvaq9rH+fVmokHbEED4CVVAfJZ5irDOTAo3Dy9C3mKnk6W6lgdAyzpa+VBWs?=
 =?us-ascii?Q?DAnymBLW1LEa617/l2/2TsnL8JusylUo0u0Jfk4A4m/2OIP5iPcI88vjggXX?=
 =?us-ascii?Q?Dn/ThioYtr3XNRbYIssRMtrjvd2Li/q6Lu4VkIaVlICMdF7r2NUiZcFS9Jtd?=
 =?us-ascii?Q?MCYPsB4FNd3yPnqmLXvB9RBwwLy74I9J3QLRs8wUlU8CNg9ks1vWtx5UkAGp?=
 =?us-ascii?Q?jRr2cIKBw+NoElAWIkWr2c/fno7FOsrn7XgzVxkq0cJxVwsAerKO6YVICNwu?=
 =?us-ascii?Q?6BCl+gDWcOplxhSopwiO7uVugLpkLLztudV6tGt9fSh8PjXekijgkWtJwPrS?=
 =?us-ascii?Q?i4yuQthzcAXmfk4ZJeMHtiJHIvM8Yv/RGHgaimzGsJKbb601YMuIbI043TQL?=
 =?us-ascii?Q?Yu67Wryy/ynqUnxQu91/F/DibnUoSnvmfd38+/UJfarkJsIxpzbQbRA1sFxF?=
 =?us-ascii?Q?KhROzR28zFbpWqGqfqSj1/konwci9lh6UJKPoQmP7MbUf25VzT5MhamzgDpm?=
 =?us-ascii?Q?caoFJP8clfh7cTN5n22VbkZnHJxjnFn/aqnz7KfgWfZkuZt1NWs/hv9fuRzs?=
 =?us-ascii?Q?nLeYI/ZRedwmIlb9EF0KaPVaooriWH4kyHXn8d0Mygb8xFtUb26I6/Gu1+sx?=
 =?us-ascii?Q?5Zk6Q68vkEcFVxMZMiEZ66h08Rj/XKvkM5lunO73v0v5A5yeqVxucpv2ub3T?=
 =?us-ascii?Q?97RRjLIRvTUVtpeKO8RNTxG1YwLu1fQGbzjFZt2xqTaINwjHk2qDq+iQnfxb?=
 =?us-ascii?Q?vejL478ukapN/53Tt0O5hoPIfVGYZep581PSmrTSEssWBqlExgsOt1TYez/Q?=
 =?us-ascii?Q?7z2UQqN/NWJ/rTxzA1tP4czlLJTayjMVxD9U428og+6M/Ps3Bn/0FVg8kt2P?=
 =?us-ascii?Q?O5niYb0zAfmbVrp1jI2ERZFdTGgclrHznfYfZQ9E+IHsMPYiiAEIF6BEsm9z?=
 =?us-ascii?Q?MV2SM4Qy9ppdFDRvLyt8ZL3yPpLW6Vp/3pO+LOGepHR46vqGB1X8R6SbXgr3?=
 =?us-ascii?Q?ksy0hm/RB3oA89lpmK5K8ehmeTeDULHl3ulfp6OB?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR11MB1320.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf968b34-f71d-45b6-ec6f-08da92435600
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2022 09:11:52.9243
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TKWx/6uUgQhc/gFGDrJwhANYUB6XviKmLB+yrjKrflD2eMO3Js+mMLn1APmJg77Sqwj+rS4pg0zS54RRxSfMOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4881
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hi ido,

After apply your kernel patch and bpf test patch.
The test result is OK.

Test destruction of generic XDP...
Test TC non-offloaded...
Test TC non-offloaded isn't getting bound...
Test TC offloads are off by default...
Test TC offload by default...
......
Test loading program with maps...
Test bpftool bound info reporting (own ns)...
Test bpftool bound info reporting (other ns)...
Test bpftool bound info reporting (remote ns)...
Test bpftool bound info reporting (back to own ns)...
Test bpftool bound info reporting (removed dev)...
Test map update (no flags)...
Test map update (exists)...
Test map update (noexist)...
Test map dump...
Test map getnext...
Test map delete (htab)...
Test map delete (array)...
Test map remove...
Test map creation fail path...
Test multi-dev ASIC program reuse...
Test multi-dev ASIC cross-dev replace...
Test multi-dev ASIC cross-dev install...
Test multi-dev ASIC cross-dev map reuse...
Test multi-dev ASIC cross-dev destruction...
Test multi-dev ASIC cross-dev destruction - move...
Test multi-dev ASIC cross-dev destruction - orphaned...
test_offload.py: OK

best regards,

________________________________________
From: Ido Schimmel <idosch@idosch.org>
Sent: Thursday, September 8, 2022 4:03 PM
To: Zhou, Jie2X
Cc: kuba@kernel.org; andrii@kernel.org; mykolal@fb.com; ast@kernel.org; dan=
iel@iogearbox.net; martin.lau@linux.dev; davem@davemloft.net; hawk@kernel.o=
rg; netdev@vger.kernel.org; bpf@vger.kernel.org; linux-kselftest@vger.kerne=
l.org; linux-kernel@vger.kernel.org; Li, Philip; petrm@nvidia.com
Subject: Re: test ./tools/testing/selftests/bpf/test_offload.py failed

On Thu, Sep 08, 2022 at 07:44:06AM +0000, Zhou, Jie2X wrote:
> About netdevsim patch ([2]), do you commit it to kernel mail list?

Yes, I will send it to 'net'. Can I add your Tested-by tag?
