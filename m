Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C2DF6E2F23
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 07:16:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbjDOFQY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Apr 2023 01:16:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjDOFQW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Apr 2023 01:16:22 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 874F34C2D;
        Fri, 14 Apr 2023 22:16:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681535781; x=1713071781;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=CrdZENNvmFOsw0oyDC2EXEBFtTAB2BOlPtseeJs45uQ=;
  b=WBHH8w4TlXnbMaJ5uybM3IZhHLJXfgw0KD57DuGDu/efvmZEOakEut9a
   creqIZLB0FQjTla+H7swge40wTB0vFkD/UneRjN4Z4b5KBzGomyc/M0FF
   EngSX3TkD+qozXJs0yA2CNOIvC1UwJyglMELwXicxvWygWx1Ji8wulIxt
   QhrJ9+hBYdrPYqqApGJB8qne/CvlUhwF7+vXZExSFsQ50e+9CnUVH9iIQ
   37nYiBYt6DyRpbeXoeJ/Z5ZnYFdaigsLc2ybqh1LIDrpMjAPQ/QjDQYsz
   7I5YXoVpXWxsuojEqRTXp+RLid8MNFxAhRvaeLvFJgprczhSfRy01LXvk
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10680"; a="407507112"
X-IronPort-AV: E=Sophos;i="5.99,199,1677571200"; 
   d="scan'208";a="407507112"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2023 22:16:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10680"; a="864428269"
X-IronPort-AV: E=Sophos;i="5.99,199,1677571200"; 
   d="scan'208";a="864428269"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga005.jf.intel.com with ESMTP; 14 Apr 2023 22:16:20 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 14 Apr 2023 22:16:19 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 14 Apr 2023 22:16:19 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.104)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 14 Apr 2023 22:16:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cJlqY28moWvfGZR97rCk/NUgUEqo/ETjS/Ht9Y8VSTxAj7D6YDIXxCKyxkvcTMvkrNVnc3055/bSsut2KFV0f2ExfkXjxyfL2me+xO3LJuV+1WyDxebaGQpRv4buWH1aOXNHeurG+05nHOH29/BxgKrP69WZQxiLI5bjINvXPCzkZI/1j0HosFhx8K8SiqTIXphjqKJlNjKTu17b/dqY3H3GYLcezVqt0KgCOjg73vVY+rPx+4RM5FAVloY0F4DURwuBHCv3fgaFlREqIHCXh4R71A5iv7/i6ZFIwI/JDE7hzSdvWXAI3vBRZavBHoAJmoiXG99SJosb2G/mvUwmdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CrdZENNvmFOsw0oyDC2EXEBFtTAB2BOlPtseeJs45uQ=;
 b=e9s2ynT1HROM9lO9f0GdZSqp76t7ZjDgB4RGPE5KYFLIyGvMX7oVFXqEuSm6mvmnqnjrnUKYpiJSyrvImKy8mLFlkUzEOVpnMyeiO8FpqAfD/QuhSYPVYlao7X9S2h0Mm+wtDiuxVInXrQZ80tZhqmev5zaTFxEUVsIpPPnPdzKuvXbhFFDbUr5oXRGaqvK7AWUII22HeZ+KPQuUTMn/FHRdZfwGRp13zh5NoZdBQGpEEIgRahIVCDg53aM/dbJGV/CmBzkaY/UYyADT4NNJmEKbmKZqJ9BzM7Nic2eX+dhu+wTY2EwtsiKMM3WwQ1Y96Xttgyh5XWYp1kcZBvUpzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW5PR11MB5811.namprd11.prod.outlook.com (2603:10b6:303:198::18)
 by DM4PR11MB8201.namprd11.prod.outlook.com (2603:10b6:8:18a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Sat, 15 Apr
 2023 05:16:12 +0000
Received: from MW5PR11MB5811.namprd11.prod.outlook.com
 ([fe80::dbef:d901:ea07:8e01]) by MW5PR11MB5811.namprd11.prod.outlook.com
 ([fe80::dbef:d901:ea07:8e01%6]) with mapi id 15.20.6298.028; Sat, 15 Apr 2023
 05:16:12 +0000
From:   "Song, Yoong Siang" <yoong.siang.song@intel.com>
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        "Alexander Duyck" <alexanderduyck@fb.com>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "Keller, Jacob E" <jacob.e.keller@intel.com>
CC:     "Brouer, Jesper" <brouer@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "xdp-hints@xdp-project.net" <xdp-hints@xdp-project.net>
Subject: RE: [PATCH net-next v5 2/3] net: stmmac: add Rx HWTS metadata to XDP
 receive pkt
Thread-Topic: [PATCH net-next v5 2/3] net: stmmac: add Rx HWTS metadata to XDP
 receive pkt
Thread-Index: AQHZbpHf9yH0VmKObUq+yhs/+Sgx268rAgEAgADS2FA=
Date:   Sat, 15 Apr 2023 05:16:11 +0000
Message-ID: <MW5PR11MB5811B02733AFE888981B53A3D89E9@MW5PR11MB5811.namprd11.prod.outlook.com>
References: <20230414052651.1871424-1-yoong.siang.song@intel.com>
 <20230414052651.1871424-3-yoong.siang.song@intel.com>
 <d74d570c-3001-4c92-7516-eb20ecb479d7@redhat.com>
In-Reply-To: <d74d570c-3001-4c92-7516-eb20ecb479d7@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW5PR11MB5811:EE_|DM4PR11MB8201:EE_
x-ms-office365-filtering-correlation-id: cbdf847e-f866-4f2e-115f-08db3d70875e
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 70a2OZmxVdTrA00bW5gK1YhA1R2IB0Qv9Mw3KQ/59OBKtKU2vbt73Sr6cFAXQhu074nnAQ2ZH5NwmhJoy/zPqhqlKCnVO7NiUoTXctzDmFQ2TaTrpbpyWN4itD5jYwrpLAI/8+U1P4B8wJMKEzXU6s/9lcBCsofXGm5UAfOpDE6gwRXGJwYm2M5jt7laGNUP3/5bhaFJOijEfuoT9SkhBkhuhfgmwoMNiwHyr8y0WNhtlXh1jQLoGwxVcuNE9sM2hEh/gl8nPOJPmOe+ruc1MpNZ1lxON0HqboAE9crztKENKXupBKskTVVCeS72hXmY3+tZ211LKXiTTWtsmJhZIkkhnTRF35OBdX2AwTy4LhXw0RC02Yt0Nw8X+RFf72mlMr6WFlFc19m8l4QYP19KYOtXcc7e7UgmEWFz1vJRW4DaLuAXurxV++6gexknSSzSC9A0jNgKQIHRUgvWsdd09kamoNjGE+s4xGWe1O/JXh+86Rt5U+rI4jyPC9mj78zhdAnMYqo8YAkAo4dtsRzOj2U/xKrrVyiJYGvEz4z46rGsoE/IxikqGyNX7kjgB6WxivFG82y+Qk6eQzvIb2+eAsdM0JGT+AEBqzKVIJE4ZIsQIinwKWRpszTUwEsYZZbSt4coqIqgILd1yWPPDNinbA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR11MB5811.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(136003)(396003)(39860400002)(376002)(346002)(451199021)(316002)(4326008)(38100700002)(64756008)(66446008)(82960400001)(66556008)(66946007)(76116006)(66476007)(5660300002)(52536014)(7696005)(71200400001)(86362001)(41300700001)(55236004)(54906003)(6636002)(186003)(9686003)(53546011)(6506007)(26005)(38070700005)(2906002)(8676002)(7416002)(8936002)(83380400001)(55016003)(478600001)(33656002)(921005)(122000001)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?T3Y2TVpRZzZJSjQvc0dvcVZTZ1IzeU5MSmhyUVM3TGpWU0FtWS9NU2FrOG5n?=
 =?utf-8?B?Z2NDdCs0cTc2U1hKOXFaL2RRY0J0Yno2ajBmbzBvTDMwTUIvZ1VLSmlzeXBZ?=
 =?utf-8?B?aytwbFJ4ekMwS2xScDZ5Ny9pRmNNLzZNc0RCS3JpRGpIbGFic2V3UGpWTjQx?=
 =?utf-8?B?aS9EeE52QjZoWXFGd3hJdGhrMTVnNzl5TXFwcUF5bWp6UVpFWnlCWjRRRWt5?=
 =?utf-8?B?OG1JVkxNUk5IK24yb25NeFBDLzUrajBtdVZ5K1ZuRzRxZkNsdWtlOFhsQTRr?=
 =?utf-8?B?NmMrSWExbjd6Mk1vM0pPQ2pET09GdUZnbDhOK1VXWGV3RU9NcnF0SUlwTnl3?=
 =?utf-8?B?dnJ3SDVWY2F2RXBCcy84VWlkcDVjZkUralIrQW4wcEFIN0RvOHlQNFlVS1hM?=
 =?utf-8?B?ek1MakFZY05LdDR6WTgwSllGOFFZRmE4Y0ZlL3hxR29GM21WN3IvMFZoMW8w?=
 =?utf-8?B?YlE5V1pyODU4aktDWDhBb0V4VWpxMDVGcmlRakg5YW56Y0ZGdmFUS2I2ZUFj?=
 =?utf-8?B?WmJFK2t3ZFIyMGtUUnhVbXpqcmljam1CTlJpWFVtY3pMTFkxem1EaDZpYnY5?=
 =?utf-8?B?M056YS9KQUxRam8xeDN3bTZqMVl5aTc5R29VczFOWmZUVTI5YnNMMzNaV2xk?=
 =?utf-8?B?U3FEYUF5OVJuMHdHZGR5V1IrNnVTYU9yRnp0OVQrNCtPdk1rRTBreUtXbTJo?=
 =?utf-8?B?eFVOYjg0NTE1Z2VJOTJadGxHaHBOWFZqOGJuMnlZZHc2SlFCTjM4eStIVldh?=
 =?utf-8?B?aHFFMVJrSXJZSXE3a1c4eXVwMDhlUzhZdnlzbTdBTjVlUFprSHpyRjViSkZn?=
 =?utf-8?B?Q1kzbEhvcmVlOXByYmEySUhxQWVyNVlCTXFKcUdHNXc0Z25FU0FEandJYVVZ?=
 =?utf-8?B?eTlqSU9BbnlKaXR6Q1JORFh4NGJrc0lxSTNoaXVrRjF6MnB2dEpkeHBsOW1h?=
 =?utf-8?B?M3FWdU5JUWtyRTBGY2tDMUFiUXpMNWZxU3NtYUUxT25aYTdjVnRQMlcrN2h0?=
 =?utf-8?B?UGFheWphSXJzdVJlREZ2anljRmhsZjJiL1lJbm1lWE9vdjcxeDJVcE1ucFU4?=
 =?utf-8?B?amEyT1I1VERscS9vVmdpcWZUMlMrS3RiWjBybit0YXJVRDJuaCtua2NtM09t?=
 =?utf-8?B?OXVEbHpWVFd0RHNMTWd6UEJybWFsYVJxTTgvNFpsUHNLSmgwZDRLTjRLZUxM?=
 =?utf-8?B?NWdPWHZRZmR4RHAySFY3d0VtUjlCV0wwTGxvK1piNWJGVGFnOERHdlNUclli?=
 =?utf-8?B?UkVzc0cwV2hzb0JDOTh3TFBudW9UeU95cUtBMmZYT2ZiZEY0Qnh5VFlFNFRt?=
 =?utf-8?B?dnlkenlZbThVb1hJVUJQczNEVEIySTZGdDcrQ1phZGtwVDBwRVI5cE84VlRz?=
 =?utf-8?B?cGdhU1dSYnJJYWtCS0RDTlNPcG5JZUE0WFpYeC9oQi9aQUJsVTZCYk1qZEhT?=
 =?utf-8?B?WmZUcElDZW9SbXJsRm8vdmNpSWZMK2lLOUFGcFVhbEFKcS9XMXJpUmFjK3NH?=
 =?utf-8?B?UW0vS0RkNGhNMUxEZERqOC9JaUNYdFB6S0tBR09kWVczcmwrQjZFTHdORFFj?=
 =?utf-8?B?cWhmaWF4bGxwVExNU2p0a1I2OFNJeFZLNEt1dGE2WjVSZ3N3VnppT05aZjFp?=
 =?utf-8?B?eEFqTi9mRGlKY0o0MXBtVEZiK3dGdmZUT2ZKend3RHdQWUtlVENaSnZIeS9K?=
 =?utf-8?B?UnNNTVZpTEZRcTFjZ1ZadGlPWGlEOVBqa0k2VEVORVV6REdFMkM4Z09iZzd0?=
 =?utf-8?B?MW1kcjVRWVNYYWxuREdQTFljcGdEZVJFU2Y4Z1daT3JiR0xXY3RrNWNGa0Ft?=
 =?utf-8?B?RUFmVnB1U3FrNnVscXpMOUxIYkVnb0dWbW5QTnNVYTRCRmhuaEdMbzFpczBR?=
 =?utf-8?B?R1pmbzdXVXNtNXlNMXc4WXhScWpyMnc3TzR5Q0NxZ1VrZlB2d0pDcHZwdEdp?=
 =?utf-8?B?bVdWL1lmUERqOHhSTk1Iamg4c2c4VlBQUmxLcG92VGx5Qmx4L1hQZ1FQZXlE?=
 =?utf-8?B?Tk1YdDQzREg5YVJHenF6OVlNUE9QSEZPMzFVRjYxdFBlVzFEWi9XSkdWUVlQ?=
 =?utf-8?B?TlQ2Q1dydmwrbXNqb0tRYS9YUk5rWnBZVzlJOW1tOURYZ3hTY0RWcmpnQXpn?=
 =?utf-8?Q?4AVji5AMAU9F0gVAaImNlHqtz?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR11MB5811.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cbdf847e-f866-4f2e-115f-08db3d70875e
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2023 05:16:11.9271
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oIFa9zfIKxZg30TsmceYJmN3Ms9F6oqS+FeCxM6Ymutp4TK2QlIkNcH1T2ntxl0HsOIoiv0wdyc8DsZgFh7xJNRTKPJymZvMDEHjT6FaEWQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB8201
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU2F0dXJkYXksIEFwcmlsIDE1LCAyMDIzIDEyOjM5IEFNLCBKZXNwZXIgRGFuZ2FhcmQgQnJv
dWVyIDxqYnJvdWVyQHJlZGhhdC5jb20+IHdyb3RlOg0KPk9uIDE0LzA0LzIwMjMgMDcuMjYsIFNv
bmcgWW9vbmcgU2lhbmcgd3JvdGU6DQo+PiBBZGQgcmVjZWl2ZSBoYXJkd2FyZSB0aW1lc3RhbXAg
bWV0YWRhdGEgc3VwcG9ydCB2aWEga2Z1bmMgdG8gWERQDQo+PiByZWNlaXZlIHBhY2tldHMuDQo+
Pg0KPj4gU3VnZ2VzdGVkLWJ5OiBTdGFuaXNsYXYgRm9taWNoZXYgPHNkZkBnb29nbGUuY29tPg0K
Pj4gU2lnbmVkLW9mZi1ieTogU29uZyBZb29uZyBTaWFuZyA8eW9vbmcuc2lhbmcuc29uZ0BpbnRl
bC5jb20+DQo+PiBBY2tlZC1ieTogU3RhbmlzbGF2IEZvbWljaGV2IDxzZGZAZ29vZ2xlLmNvbT4N
Cj4+IC0tLQ0KPj4gICBkcml2ZXJzL25ldC9ldGhlcm5ldC9zdG1pY3JvL3N0bW1hYy9zdG1tYWMu
aCAgfCAgMyArKw0KPj4gICAuLi4vbmV0L2V0aGVybmV0L3N0bWljcm8vc3RtbWFjL3N0bW1hY19t
YWluLmMgfCA0MCArKysrKysrKysrKysrKysrKystDQo+PiAgIDIgZmlsZXMgY2hhbmdlZCwgNDIg
aW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPj4NCj4+IGRpZmYgLS1naXQgYS9kcml2ZXJz
L25ldC9ldGhlcm5ldC9zdG1pY3JvL3N0bW1hYy9zdG1tYWMuaA0KPj4gYi9kcml2ZXJzL25ldC9l
dGhlcm5ldC9zdG1pY3JvL3N0bW1hYy9zdG1tYWMuaA0KPj4gaW5kZXggYWM4Y2NmODUxNzA4Li44
MjZhYzBlYzg4YzYgMTAwNjQ0DQo+PiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9zdG1pY3Jv
L3N0bW1hYy9zdG1tYWMuaA0KPj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvc3RtaWNyby9z
dG1tYWMvc3RtbWFjLmgNCj4+IEBAIC05NCw2ICs5NCw5IEBAIHN0cnVjdCBzdG1tYWNfcnhfYnVm
ZmVyIHsNCj4+DQo+PiAgIHN0cnVjdCBzdG1tYWNfeGRwX2J1ZmYgew0KPj4gICAJc3RydWN0IHhk
cF9idWZmIHhkcDsNCj4+ICsJc3RydWN0IHN0bW1hY19wcml2ICpwcml2Ow0KPj4gKwlzdHJ1Y3Qg
ZG1hX2Rlc2MgKnA7DQo+PiArCXN0cnVjdCBkbWFfZGVzYyAqbnA7DQo+DQo+SG1tLCBJIGRvbid0
IGxpa2UgdGhlIG5hbWluZyBvZiB0aGUgZGVzY3JpcHRvcnMgYXMgInAiIGFuZCAibnAiLg0KPklm
IHlvdSBpbnNpc3Qgb24gdGhpcyBuYW1pbmcsIGF0IGxlYXN0IHdlIG5lZWQgY29tbWVudHMgZGVz
Y3JpYmluZyB0aGF0IHRoaXMgaXMuDQo+DQo+RG9lcyAiZGVzYyIgYW5kICJuZGVzYyIgbWFrZSBz
ZW5zZT8gICh3aGVyZSAibiIgbWVhbnMgIm5leHQiKQ0KPg0KDQpZdXAsIG1ha2Ugc2Vuc2UgdG8g
aGF2ZSBkZXNjIGFuZCBuZGVzYy4gSSB3aWxsIHVwZGF0ZSB0aGUgbmFtaW5nIGluIFY2Lg0KDQpU
aGFua3MgJiBSZWdhcmRzDQpTaWFuZw0KDQo+PiAgIH07DQo+Pg0KPj4gICBzdHJ1Y3Qgc3RtbWFj
X3J4X3F1ZXVlIHsNCj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9zdG1pY3Jv
L3N0bW1hYy9zdG1tYWNfbWFpbi5jDQo+PiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3N0bWljcm8v
c3RtbWFjL3N0bW1hY19tYWluLmMNCj4+IGluZGV4IDEwYjlmODkxMmJiMi4uNzRmNzhlNTUzN2Ez
IDEwMDY0NA0KPj4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvc3RtaWNyby9zdG1tYWMvc3Rt
bWFjX21haW4uYw0KPj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvc3RtaWNyby9zdG1tYWMv
c3RtbWFjX21haW4uYw0KPj4gQEAgLTUzMTMsMTAgKzUzMTMsMTUgQEAgc3RhdGljIGludCBzdG1t
YWNfcngoc3RydWN0IHN0bW1hY19wcml2ICpwcml2LA0KPj4gaW50IGxpbWl0LCB1MzIgcXVldWUp
DQo+Pg0KPj4gICAJCQl4ZHBfaW5pdF9idWZmKCZjdHgueGRwLCBidWZfc3osICZyeF9xLT54ZHBf
cnhxKTsNCj4+ICAgCQkJeGRwX3ByZXBhcmVfYnVmZigmY3R4LnhkcCwgcGFnZV9hZGRyZXNzKGJ1
Zi0+cGFnZSksDQo+PiAtCQkJCQkgYnVmLT5wYWdlX29mZnNldCwgYnVmMV9sZW4sIGZhbHNlKTsN
Cj4+ICsJCQkJCSBidWYtPnBhZ2Vfb2Zmc2V0LCBidWYxX2xlbiwgdHJ1ZSk7DQo+Pg0KPj4gICAJ
CQlwcmVfbGVuID0gY3R4LnhkcC5kYXRhX2VuZCAtIGN0eC54ZHAuZGF0YV9oYXJkX3N0YXJ0IC0N
Cj4+ICAgCQkJCSAgYnVmLT5wYWdlX29mZnNldDsNCj4+ICsNCj4+ICsJCQljdHgucHJpdiA9IHBy
aXY7DQo+PiArCQkJY3R4LnAgPSBwOw0KPj4gKwkJCWN0eC5ucCA9IG5wOw0KPj4gKw0KPj4gICAJ
CQlza2IgPSBzdG1tYWNfeGRwX3J1bl9wcm9nKHByaXYsICZjdHgueGRwKTsNCj4+ICAgCQkJLyog
RHVlIHhkcF9hZGp1c3RfdGFpbDogRE1BIHN5bmMgZm9yX2RldmljZQ0KPj4gICAJCQkgKiBjb3Zl
ciBtYXggbGVuIENQVSB0b3VjaA0KPj4gQEAgLTcwNjAsNiArNzA2NSwzNyBAQCB2b2lkIHN0bW1h
Y19mcGVfaGFuZHNoYWtlKHN0cnVjdCBzdG1tYWNfcHJpdiAqcHJpdiwgYm9vbCBlbmFibGUpDQo+
PiAgIAl9DQo+PiAgIH0NCj4+DQo+PiArc3RhdGljIGludCBzdG1tYWNfeGRwX3J4X3RpbWVzdGFt
cChjb25zdCBzdHJ1Y3QgeGRwX21kICpfY3R4LCB1NjQNCj4+ICsqdGltZXN0YW1wKSB7DQo+PiAr
CWNvbnN0IHN0cnVjdCBzdG1tYWNfeGRwX2J1ZmYgKmN0eCA9ICh2b2lkICopX2N0eDsNCj4+ICsJ
c3RydWN0IHN0bW1hY19wcml2ICpwcml2ID0gY3R4LT5wcml2Ow0KPj4gKwlzdHJ1Y3QgZG1hX2Rl
c2MgKmRlc2MgPSBjdHgtPnA7DQo+PiArCXN0cnVjdCBkbWFfZGVzYyAqbnAgPSBjdHgtPm5wOw0K
Pj4gKwlzdHJ1Y3QgZG1hX2Rlc2MgKnAgPSBjdHgtPnA7DQo+PiArCXU2NCBucyA9IDA7DQo+PiAr
DQo+PiArCWlmICghcHJpdi0+aHd0c19yeF9lbikNCj4+ICsJCXJldHVybiAtRU5PREFUQTsNCj4+
ICsNCj4+ICsJLyogRm9yIEdNQUM0LCB0aGUgdmFsaWQgdGltZXN0YW1wIGlzIGZyb20gQ1RYIG5l
eHQgZGVzYy4gKi8NCj4+ICsJaWYgKHByaXYtPnBsYXQtPmhhc19nbWFjNCB8fCBwcml2LT5wbGF0
LT5oYXNfeGdtYWMpDQo+PiArCQlkZXNjID0gbnA7DQo+PiArDQo+PiArCS8qIENoZWNrIGlmIHRp
bWVzdGFtcCBpcyBhdmFpbGFibGUgKi8NCj4+ICsJaWYgKHN0bW1hY19nZXRfcnhfdGltZXN0YW1w
X3N0YXR1cyhwcml2LCBwLCBucCwgcHJpdi0+YWR2X3RzKSkgew0KPj4gKwkJc3RtbWFjX2dldF90
aW1lc3RhbXAocHJpdiwgZGVzYywgcHJpdi0+YWR2X3RzLCAmbnMpOw0KPj4gKwkJbnMgLT0gcHJp
di0+cGxhdC0+Y2RjX2Vycm9yX2FkajsNCj4+ICsJCSp0aW1lc3RhbXAgPSBuc190b19rdGltZShu
cyk7DQo+PiArCQlyZXR1cm4gMDsNCj4+ICsJfQ0KPj4gKw0KPj4gKwlyZXR1cm4gLUVOT0RBVEE7
DQo+PiArfQ0KPj4gKw0KPj4gK3N0YXRpYyBjb25zdCBzdHJ1Y3QgeGRwX21ldGFkYXRhX29wcyBz
dG1tYWNfeGRwX21ldGFkYXRhX29wcyA9IHsNCj4+ICsJLnhtb19yeF90aW1lc3RhbXAJCT0gc3Rt
bWFjX3hkcF9yeF90aW1lc3RhbXAsDQo+PiArfTsNCj4+ICsNCj4+ICAgLyoqDQo+PiAgICAqIHN0
bW1hY19kdnJfcHJvYmUNCj4+ICAgICogQGRldmljZTogZGV2aWNlIHBvaW50ZXINCj4+IEBAIC03
MTY3LDYgKzcyMDMsOCBAQCBpbnQgc3RtbWFjX2R2cl9wcm9iZShzdHJ1Y3QgZGV2aWNlICpkZXZp
Y2UsDQo+Pg0KPj4gICAJbmRldi0+bmV0ZGV2X29wcyA9ICZzdG1tYWNfbmV0ZGV2X29wczsNCj4+
DQo+PiArCW5kZXYtPnhkcF9tZXRhZGF0YV9vcHMgPSAmc3RtbWFjX3hkcF9tZXRhZGF0YV9vcHM7
DQo+PiArDQo+PiAgIAluZGV2LT5od19mZWF0dXJlcyA9IE5FVElGX0ZfU0cgfCBORVRJRl9GX0lQ
X0NTVU0gfCBORVRJRl9GX0lQVjZfQ1NVTSB8DQo+PiAgIAkJCSAgICBORVRJRl9GX1JYQ1NVTTsN
Cj4+ICAgCW5kZXYtPnhkcF9mZWF0dXJlcyA9IE5FVERFVl9YRFBfQUNUX0JBU0lDIHwgTkVUREVW
X1hEUF9BQ1RfUkVESVJFQ1QgfA0KDQo=
