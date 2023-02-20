Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0FC669C8BF
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 11:37:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231641AbjBTKhv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 05:37:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231445AbjBTKhq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 05:37:46 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 829FB199D6;
        Mon, 20 Feb 2023 02:37:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676889450; x=1708425450;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=bC0R68jB8xggHTeovIdv+iWIKaRfoj2/v9Nj890sEGA=;
  b=mo2B5lGiiktS+7rgHVhOmBEX63WvvGcaEsRq2MxDUfl5lcZzrzXYVMFf
   ZLnJxDYNPGWS6PqSo2ezKAdRga+uRyYWHkjn12sTVNLHqA3pantgkfL2q
   cCQR5Y0x8KUCh+uVlinDiUzqAYyKal2ZwAuz4ybKz9rRgr7NDkWiN0ze5
   uKcVH5vKpVyOKnq0cL/1fA9GG5shba/tURlS7CS2epIDyW3tqPpy8vXKw
   NqihqJZ7qNDkT2DWEvKbphI5mAtWUzuFP9fb1AEndCgJPqB355XSYAGAi
   q2GTDhbhxPfqI1pMF1ngBhhVJk/G7L9mGN8U6UkyHaPQ6e2I+/dAan6u1
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10626"; a="359836254"
X-IronPort-AV: E=Sophos;i="5.97,312,1669104000"; 
   d="scan'208";a="359836254"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2023 02:37:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10626"; a="703662586"
X-IronPort-AV: E=Sophos;i="5.97,312,1669104000"; 
   d="scan'208";a="703662586"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga001.jf.intel.com with ESMTP; 20 Feb 2023 02:37:26 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 20 Feb 2023 02:37:25 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 20 Feb 2023 02:37:25 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.109)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 20 Feb 2023 02:37:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S1ohK1JULXhmK1MU3eLpLqDVW9aQJyuTKTjfykgQEA1YuYatSl5ZIHXxxb1VvLle02TESsFK74RNJGnl52Equx7BfNX4PwzoAf7FgBSmzGFEJPz18hr49KequcpTwmQ9tX0HH3ZqtlpZWSUPjxdAZOglDBGGPVSryGufH4TUlTyYZWtKXHgIt+BrGM6uH1bAnTXK6i+FDMTt2B13gTjRFzw4LFD2qbeG4UQjEWe39oaTBWbHVmlmGDH6c6uUerrvGFWu11DOdBzkmF2qafEHXC8GCHidO50jqPzz3T9FUMZ+0jBZYC9dGAhIw+tV/rYIW7NC9RK6J8gCX8C7ajNvzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bC0R68jB8xggHTeovIdv+iWIKaRfoj2/v9Nj890sEGA=;
 b=Nwyfu3KIdXCdXuvq5o/3lZqm1tMRkETOw2WpYzYia92AXEn+tM4WRNZPyijFqTbU/tFNvxM9FQLUtCvKAmokW9p+R7CZu8KDCI34UcUKAW2dIpb5psTVUZkVMIRXr7COlQDo1Qm8M6PLc7H8+GYUYSyqJef3/2NxA1Km5nm8wbldntB+9ZVOPE0lcAW+rocaUPMCfLj82G8PkI5TRM2amRz3q8CFArefpaEKRINTNaVb6bxzAEsgYqeMVxSanNgj0d3gCNRJyEPzbCm+ZLoqjq28vxeGMunPgqhItlng68Nb3CNVK4EYKNZJ3Kxd4M+rxbRNs9ryJzFqx8kx7GSFlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5987.namprd11.prod.outlook.com (2603:10b6:208:372::8)
 by PH7PR11MB5888.namprd11.prod.outlook.com (2603:10b6:510:137::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20; Mon, 20 Feb
 2023 10:37:21 +0000
Received: from MN0PR11MB5987.namprd11.prod.outlook.com
 ([fe80::81be:e0c7:8c53:8f9c]) by MN0PR11MB5987.namprd11.prod.outlook.com
 ([fe80::81be:e0c7:8c53:8f9c%8]) with mapi id 15.20.6111.019; Mon, 20 Feb 2023
 10:37:21 +0000
From:   "Greenman, Gregory" <gregory.greenman@intel.com>
To:     "rafael@kernel.org" <rafael@kernel.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>
CC:     "bzolnier@gmail.com" <bzolnier@gmail.com>,
        "linux-hwmon@vger.kernel.org" <linux-hwmon@vger.kernel.org>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "orsonzhai@gmail.com" <orsonzhai@gmail.com>,
        "idosch@nvidia.com" <idosch@nvidia.com>,
        "linux-imx@nxp.com" <linux-imx@nxp.com>,
        "mperttunen@nvidia.com" <mperttunen@nvidia.com>,
        "jdelvare@suse.com" <jdelvare@suse.com>,
        "yang.lee@linux.alibaba.com" <yang.lee@linux.alibaba.com>,
        "jernej.skrabec@gmail.com" <jernej.skrabec@gmail.com>,
        "niklas.soderlund@ragnatech.se" <niklas.soderlund@ragnatech.se>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "lenb@kernel.org" <lenb@kernel.org>,
        "lars@metafoo.de" <lars@metafoo.de>,
        "bcm-kernel-feedback-list@broadcom.com" 
        <bcm-kernel-feedback-list@broadcom.com>,
        "anarsoul@gmail.com" <anarsoul@gmail.com>,
        "linux-sunxi@lists.linux.dev" <linux-sunxi@lists.linux.dev>,
        "sbranden@broadcom.com" <sbranden@broadcom.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "heiko@sntech.de" <heiko@sntech.de>,
        "wens@csie.org" <wens@csie.org>,
        "mmayer@broadcom.com" <mmayer@broadcom.com>,
        "Zhang, Rui" <rui.zhang@intel.com>,
        "bchihi@baylibre.com" <bchihi@baylibre.com>,
        "sre@kernel.org" <sre@kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "mhiramat@kernel.org" <mhiramat@kernel.org>,
        "linux-rpi-kernel@lists.infradead.org" 
        <linux-rpi-kernel@lists.infradead.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "zhang.lyra@gmail.com" <zhang.lyra@gmail.com>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "konrad.dybcio@linaro.org" <konrad.dybcio@linaro.org>,
        "j-keerthy@ti.com" <j-keerthy@ti.com>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "support.opensource@diasemi.com" <support.opensource@diasemi.com>,
        "agross@kernel.org" <agross@kernel.org>,
        "zhengyongjun3@huawei.com" <zhengyongjun3@huawei.com>,
        "krzysztof.kozlowski@linaro.org" <krzysztof.kozlowski@linaro.org>,
        "edubezval@gmail.com" <edubezval@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "andersson@kernel.org" <andersson@kernel.org>,
        "neil.armstrong@linaro.org" <neil.armstrong@linaro.org>,
        "jic23@kernel.org" <jic23@kernel.org>,
        "angelogioacchino.delregno@collabora.com" 
        <angelogioacchino.delregno@collabora.com>,
        "tim@linux4.de" <tim@linux4.de>,
        "amitk@kernel.org" <amitk@kernel.org>,
        "hayashi.kunihiko@socionext.com" <hayashi.kunihiko@socionext.com>,
        "thara.gopinath@gmail.com" <thara.gopinath@gmail.com>,
        "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "petrm@nvidia.com" <petrm@nvidia.com>,
        "ye.xingchen@zte.com.cn" <ye.xingchen@zte.com.cn>,
        "linux-rockchip@lists.infradead.org" 
        <linux-rockchip@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "jonathanh@nvidia.com" <jonathanh@nvidia.com>,
        "samuel@sholland.org" <samuel@sholland.org>,
        "daniel@makrotopia.org" <daniel@makrotopia.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "srinivas.pandruvada@linux.intel.com" 
        <srinivas.pandruvada@linux.intel.com>,
        "linux-samsung-soc@vger.kernel.org" 
        <linux-samsung-soc@vger.kernel.org>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "festevam@gmail.com" <festevam@gmail.com>,
        "miquel.raynal@bootlin.com" <miquel.raynal@bootlin.com>,
        "talel@amazon.com" <talel@amazon.com>,
        "tiny.windzz@gmail.com" <tiny.windzz@gmail.com>,
        "rjui@broadcom.com" <rjui@broadcom.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
        "kvalo@kernel.org" <kvalo@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "jiangjian@cdjrlc.com" <jiangjian@cdjrlc.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "ricardo.neri-calderon@linux.intel.com" 
        <ricardo.neri-calderon@linux.intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "stefan.wahren@i2se.com" <stefan.wahren@i2se.com>,
        "rajur@chelsio.com" <rajur@chelsio.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH v1 01/17] thermal/core: Add a thermal zone 'devdata'
 accessor
Thread-Topic: [PATCH v1 01/17] thermal/core: Add a thermal zone 'devdata'
 accessor
Thread-Index: AQHZRG/DdKEiergvlUuJtK/fU+6sHK7XpbuA
Date:   Mon, 20 Feb 2023 10:37:20 +0000
Message-ID: <133207a892e1c8010c7be71e8cff7dc88a42da2a.camel@intel.com>
References: <20230219143657.241542-1-daniel.lezcano@linaro.org>
         <20230219143657.241542-2-daniel.lezcano@linaro.org>
In-Reply-To: <20230219143657.241542-2-daniel.lezcano@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.4 (3.42.4-2.fc35) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5987:EE_|PH7PR11MB5888:EE_
x-ms-office365-filtering-correlation-id: 2d662351-355d-4f6b-2b62-08db132e7202
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2gBAtxA+MJHfZJolvMgol8zc5PZvOT5eDz8vH5IvIxMv5zsOR7uiuCuuhoTDdlA8AhHnjd3cgn0DigVDj2dRhMlfe1Xn26hidlutJroYzeKLO0Q7oNXPNnFFKZb+2lkvHi25ouyx3dZ4Yb4Ahz1o4LGAuzITUIbhEyn0CP/y0HsEglWPtS/p++euP9Ylx1OMja0qk+y3YjEp0msnPMio5/7HKViPHgrzIhSxXRqvh7KDvUoMEBBJSTThIbl5tBg17vsoB+Sn4aKTqOzbvOJYSKLvvx5lCzpwaJH9k1bS+MYmQjLU0NTp30XCEAopJIykumc8zjb3aBOFToeFmciJS0rjJklg3c2CWCJs9TSEzEXfidhIHs7CzGdFasJmwL7mkIyi4Sc0O6gBdBrcDi3BaV/cpgHcOLL1J8VaXndBPGfFCLStWbClIrJubfveY0L5zDSfveVsJCnJ/BbkYadgfA1U/nFdv1B+9GoWl7gepx+YLGkZ60wkX6t5bwPB9JXTA940we7bi+FBeT2dAZBmqmjmmEa3ZfVSf2ScH8c26vDkrwSZiayjvYLVfvRNqQliqXFt0tOhN+M/++NQUknUvHWr7ecbNh6ys5k+07qO9uDfITCUpU5qwycQc6UD7aznXjvj7WaOkP1wLOwys0zVUkhOUYKcUg276FTmMEZcJAoe6S14mrcQQQttKfdgllLJjsRg/yrqaoicWcYWOYzi9w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5987.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(376002)(346002)(396003)(39860400002)(366004)(451199018)(7336002)(7366002)(7406005)(7416002)(5660300002)(8936002)(2906002)(4326008)(8676002)(91956017)(30864003)(76116006)(66556008)(66476007)(66446008)(66946007)(64756008)(66899018)(110136005)(316002)(54906003)(6486002)(478600001)(71200400001)(26005)(186003)(6512007)(41300700001)(6506007)(2616005)(86362001)(122000001)(36756003)(83380400001)(38070700005)(82960400001)(38100700002)(579004)(559001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WHFxcld1dDNycnBhRWxTT09KQmpEcXg1c3hhQmg0SDlsR1k2REd6NXpnQnBJ?=
 =?utf-8?B?OUk0ZDBKcnNKUUk4dDE4cXpFZnJIRmY5YWpudWJNLzFNRmZFZGRRUXhiSktP?=
 =?utf-8?B?bWg4WDZKeUNzQTRnbk52Z0s2ZWluRzRUS0x5OFBmWEpTc1NzRzVnajFPRzFS?=
 =?utf-8?B?dXJ4UXVYZVJOVklyenlVM1lmdGlxVUcxMnkrMDlYZzVXSDkrWjBBS3E4QVE3?=
 =?utf-8?B?RHk1aE1CTmRaYTkrNS9GRFp5RW5BZHNIMzA1MDlGaUZJRStuQlpQbm5PVzJn?=
 =?utf-8?B?Q0ZzWFN0VVZXcE9NUjZnMXRzNHNHWjAxTTFSZ2JZNitJMXdJYzRTL1JyaUFM?=
 =?utf-8?B?UDRFZVJvamlxMnBiQjJRUjZ5OUNxZ0hKOUNOdFlJdWNYaUtsSlc4ZVJ4UG1H?=
 =?utf-8?B?d0hWenQzRmV1alBvRVNBN3RNdDh4UUdTWld4MkJ3MmxkdndrdDlhZnBHTWR0?=
 =?utf-8?B?UVd1VVBna3lZOHlPZ3F1YkNLL3N5dXlETm9Eb0tXMnlVL1U2eXR0RjBONURo?=
 =?utf-8?B?RHJ3cExjYndWVVl4RzZzcDBWa1duUldpSlJjQVZKcHpIVGF4YzY3SEQ5c2hj?=
 =?utf-8?B?VjEvV1dLQ0lEKytvb3Yrem5rYWFSRTROZEtTMWtVMURsOWNPdzVkTHc0TGk5?=
 =?utf-8?B?SFduN0RqU1kyb2pjUmpwR2ZSNmFUKzVTQ1JyTXZYK2FsaXVBMUZQa2xITGFW?=
 =?utf-8?B?YVM3SEREMCtaOWR1ZE1HZnZaWVdzaUJrRjhiWDFTbzZkZnRIWUs4cFZLQVdy?=
 =?utf-8?B?MkJXZndjMDg1Yngyc3hEV0Y0V0U1TVZzZ0pncnZOR1pHMGFnQjRGcFNWRkM0?=
 =?utf-8?B?YjMzTGRydkFKbnk5Z2dyYzJlTjRGSXFsMmNUMVRocGtMV3Frbit4bE5NSk5H?=
 =?utf-8?B?MDFReUMwY1ZTZko4SzJyRmtUdXgwVHJlU01nNWdzR25Vd3RIcVdLUTlHcWNt?=
 =?utf-8?B?dkJ6VW9yOXM2OTBhQlRrOFl5K0pGRDE5bWllaThrYWxCQTc3bFJzWWV6cjVo?=
 =?utf-8?B?OEpsek1IZUwrb05DVjc0NTNoTmx3Z1NkaC82M3lRcTh5TXluNm9aRjUxd0Ja?=
 =?utf-8?B?RXVzRFdqbUU4dGoxY1NKTkdDalpmMVRtNHpTSElRSmExTnFoR3BwWVRnT1NV?=
 =?utf-8?B?Uis1ZjF4S0tLUXZKTTVKQkpIekZtdHFnSjFFQ3lLclp3RVhiellCRjVGQ2JC?=
 =?utf-8?B?MDZ6Nm00djlWTWFLamZaWW9VS1ZuMzVVMll3ZmFHWjhKR0JiM3Q1MUJnQy80?=
 =?utf-8?B?ekl5cUVvYmdwb0hqRUh0aGtCQUl0dHRzbXpucE1QRTdzOURjTy9qTXdJNGJL?=
 =?utf-8?B?Rk1KTjNtUnY3SEtGUW1rYTEzN3BuVzN3a1VLY3ZaN3hvU0QrNFlRNUIwQ2lQ?=
 =?utf-8?B?NlVrdEs5TVZJQnJVQStmc00xTmZUdkpSa0xaaWZrM2QrNzErUEg2dDhwUGwz?=
 =?utf-8?B?Z09Ra2kwL2c1cXFiWlN6bWVoa1QrMEFzK0JIR0cvK3lKRDg1clhaazNJTWJi?=
 =?utf-8?B?Q0VidkRTd25wd09aL09HSGo5N0RZbXBsRUxuZU5SMERMOUlzcklYZ1B0Z2s0?=
 =?utf-8?B?bjFtbEdWeHY1U1ZobWMzSk1YRFQ0Sy94WmZBUEZWSGYxRUFWcDJSeUlzTGJ0?=
 =?utf-8?B?dE9WWkhueFIxcXp6RU5TUFRZSzNCdTRrTHRTbnZ5NDk4Q040UlpEcW95UGJr?=
 =?utf-8?B?eUxDYnFIRXZFa1hWVkFWcDRnd29SbllOakxQV2NsOUpRaTZsZ1M2bnR4ZzFH?=
 =?utf-8?B?S1F3RGtySzJ4WU44QitnSmNlMk9PQXF1Z2V1TkhKcDZFb3QrREFLUGRYWmtk?=
 =?utf-8?B?VWIvamFWNmdKdUFhajBGRHI0WENLU1YyanU1Z29EVDdEYmsybnFpOENsWXFv?=
 =?utf-8?B?UjdXcmNWNXVIRVVUcFlTWHhaZkVzMCtNd29ZWXhhUUwwU1d1RVFSZXN6YzQx?=
 =?utf-8?B?Yk9KcGIxdXhCTldFKzVjQVJybWdUS0s0Qi9VVCtrYWVyd0J4WkxWRnUyUlha?=
 =?utf-8?B?UTVweUQ1d0JPUXJwY0FubFc3NyttaURsUGdFQ1BXczFLaWNmN2dERE5SMXlU?=
 =?utf-8?B?Z2NlTnZwRkQ1N0ZnU1IyWjJ3cUhRVi9sOUs4cGw3eFBONUZhd3JhTnNMWGcz?=
 =?utf-8?B?ekhpSmZSbmtqSHpseFFoZ1E0WFZkcjBTNHlIQmFrSzNmL3R6aENSZVdRZElM?=
 =?utf-8?Q?cMI3kK3a8vOS2rpV4HfxG7k=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8A6485608A134044AD6C073219F624CA@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5987.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d662351-355d-4f6b-2b62-08db132e7202
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Feb 2023 10:37:20.4600
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: omNq8n0BLp2Sfp67rE/6O+Bwayr5BM0mW+Osizr/xjfyTHAz9N1suP4PLZltsSq9CG1VL3GFj6PU7X3aMVzDx+ptBpCPsTFrJDarPX9EYEU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5888
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU3VuLCAyMDIzLTAyLTE5IGF0IDE1OjM2ICswMTAwLCBEYW5pZWwgTGV6Y2FubyB3cm90ZToK
PiBUaGUgdGhlcm1hbCB6b25lIGRldmljZSBzdHJ1Y3R1cmUgaXMgZXhwb3NlZCB0byB0aGUgZGlm
ZmVyZW50IGRyaXZlcnMKPiBhbmQgb2J2aW91c2x5IHRoZXkgYWNjZXNzIHRoZSBpbnRlcm5hbHMg
d2hpbGUgdGhhdCBzaG91bGQgYmUKPiByZXN0cmljdGVkIHRvIHRoZSBjb3JlIHRoZXJtYWwgY29k
ZS4KPiAKPiBJbiBvcmRlciB0byBzZWxmLWVuY2Fwc3VsYXRlIHRoZSB0aGVybWFsIGNvcmUgY29k
ZSwgd2UgbmVlZCB0byBwcmV2ZW50Cj4gdGhlIGRyaXZlcnMgYWNjZXNzaW5nIGRpcmVjdGx5IHRo
ZSB0aGVybWFsIHpvbmUgc3RydWN0dXJlIGFuZCBwcm92aWRlCj4gYWNjZXNzb3IgZnVuY3Rpb25z
IHRvIGRlYWwgd2l0aC4KPiAKPiBQcm92aWRlIGFuIGFjY2Vzc29yIHRvIHRoZSAnZGV2ZGF0YScg
c3RydWN0dXJlIGFuZCBtYWtlIHVzZSBvZiBpdCBpbgo+IHRoZSBkaWZmZXJlbnQgZHJpdmVycy4K
PiAKPiBObyBmdW5jdGlvbmFsIGNoYW5nZXMgaW50ZW5kZWQuCj4gCj4gU2lnbmVkLW9mZi1ieTog
RGFuaWVsIExlemNhbm8gPGRhbmllbC5sZXpjYW5vQGxpbmFyby5vcmc+Cj4gLS0tCj4gwqBkcml2
ZXJzL2FjcGkvdGhlcm1hbC5jwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoCB8IDE2ICsrKysrKysrLS0tLS0tLS0KPiDCoGRyaXZlcnMvYXRhL2FoY2lf
aW14LmPCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
IHzCoCAyICstCj4gwqBkcml2ZXJzL2h3bW9uL2h3bW9uLmPCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgfMKgIDQgKystLQo+IMKgZHJpdmVycy9o
d21vbi9wbWJ1cy9wbWJ1c19jb3JlLmPCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB8
wqAgMiArLQo+IMKgZHJpdmVycy9od21vbi9zY21pLWh3bW9uLmPCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB8wqAgMiArLQo+IMKgZHJpdmVycy9od21vbi9zY3Bp
LWh3bW9uLmPCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB8wqAg
MiArLQo+IMKgZHJpdmVycy9paW8vYWRjL3N1bjRpLWdwYWRjLWlpby5jwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIHzCoCAyICstCj4gwqBkcml2ZXJzL2lucHV0L3RvdWNoc2NyZWVuL3N1
bjRpLXRzLmPCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgfMKgIDIgKy0KPiDCoC4uLi9uZXQvZXRo
ZXJuZXQvY2hlbHNpby9jeGdiNC9jeGdiNF90aGVybWFsLmPCoMKgIHzCoCAyICstCj4gwqAuLi4v
bmV0L2V0aGVybmV0L21lbGxhbm94L21seHN3L2NvcmVfdGhlcm1hbC5jwqDCoCB8IDE0ICsrKysr
KystLS0tLS0tCj4gwqBkcml2ZXJzL25ldC93aXJlbGVzcy9pbnRlbC9pd2x3aWZpL212bS90dC5j
wqDCoMKgwqDCoCB8wqAgNCArKy0tCj4gwqBkcml2ZXJzL3Bvd2VyL3N1cHBseS9wb3dlcl9zdXBw
bHlfY29yZS5jwqDCoMKgwqDCoMKgwqDCoCB8wqAgMiArLQo+IMKgZHJpdmVycy9yZWd1bGF0b3Iv
bWF4ODk3My1yZWd1bGF0b3IuY8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgfMKgIDIgKy0KPiDCoGRy
aXZlcnMvdGhlcm1hbC9hcm1hZGFfdGhlcm1hbC5jwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqAgfMKgIDQgKystLQo+IMKgZHJpdmVycy90aGVybWFsL2Jyb2FkY29tL2JjbTI3MTFfdGhl
cm1hbC5jwqDCoMKgwqDCoMKgIHzCoCAyICstCj4gwqBkcml2ZXJzL3RoZXJtYWwvYnJvYWRjb20v
YmNtMjgzNV90aGVybWFsLmPCoMKgwqDCoMKgwqAgfMKgIDIgKy0KPiDCoGRyaXZlcnMvdGhlcm1h
bC9icm9hZGNvbS9icmNtc3RiX3RoZXJtYWwuY8KgwqDCoMKgwqDCoCB8wqAgNCArKy0tCj4gwqBk
cml2ZXJzL3RoZXJtYWwvYnJvYWRjb20vbnMtdGhlcm1hbC5jwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCB8wqAgMiArLQo+IMKgZHJpdmVycy90aGVybWFsL2Jyb2FkY29tL3NyLXRoZXJtYWwuY8KgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgfMKgIDIgKy0KPiDCoGRyaXZlcnMvdGhlcm1hbC9kYTkwNjItdGhl
cm1hbC5jwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgfMKgIDIgKy0KPiDCoGRyaXZl
cnMvdGhlcm1hbC9kb3ZlX3RoZXJtYWwuY8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCB8wqAgMiArLQo+IMKgZHJpdmVycy90aGVybWFsL2hpc2lfdGhlcm1hbC5jwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHzCoCAyICstCj4gwqBkcml2ZXJzL3RoZXJtYWwv
aW14OG1tX3RoZXJtYWwuY8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHzCoCAyICst
Cj4gwqBkcml2ZXJzL3RoZXJtYWwvaW14X3NjX3RoZXJtYWwuY8KgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIHzCoCAyICstCj4gwqBkcml2ZXJzL3RoZXJtYWwvaW14X3RoZXJtYWwuY8Kg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHzCoCA2ICsrKy0tLQo+IMKgZHJp
dmVycy90aGVybWFsL2ludGVsL2ludGVsX3BjaF90aGVybWFsLmPCoMKgwqDCoMKgwqDCoCB8wqAg
MiArLQo+IMKgZHJpdmVycy90aGVybWFsL2ludGVsL2ludGVsX3NvY19kdHNfaW9zZi5jwqDCoMKg
wqDCoMKgIHwgMTMgKysrKystLS0tLS0tLQo+IMKgZHJpdmVycy90aGVybWFsL2ludGVsL3g4Nl9w
a2dfdGVtcF90aGVybWFsLmPCoMKgwqDCoCB8wqAgNCArKy0tCj4gwqBkcml2ZXJzL3RoZXJtYWwv
azNfYmFuZGdhcC5jwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB8wqAg
MiArLQo+IMKgZHJpdmVycy90aGVybWFsL2szX2o3Mnh4X2JhbmRnYXAuY8KgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgfMKgIDIgKy0KPiDCoGRyaXZlcnMvdGhlcm1hbC9raXJrd29vZF90aGVy
bWFsLmPCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHzCoCAyICstCj4gwqBkcml2ZXJzL3Ro
ZXJtYWwvbWF4Nzc2MjBfdGhlcm1hbC5jwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB8wqAg
MiArLQo+IMKgZHJpdmVycy90aGVybWFsL21lZGlhdGVrL2F1eGFkY190aGVybWFsLmPCoMKgwqDC
oMKgwqDCoCB8wqAgMiArLQo+IMKgZHJpdmVycy90aGVybWFsL21lZGlhdGVrL2x2dHNfdGhlcm1h
bC5jwqDCoMKgwqDCoMKgwqDCoMKgIHzCoCA0ICsrLS0KPiDCoGRyaXZlcnMvdGhlcm1hbC9xY29t
L3Fjb20tc3BtaS1hZGMtdG01LmPCoMKgwqDCoMKgwqDCoMKgIHzCoCA0ICsrLS0KPiDCoGRyaXZl
cnMvdGhlcm1hbC9xY29tL3Fjb20tc3BtaS10ZW1wLWFsYXJtLmPCoMKgwqDCoMKgIHzCoCA0ICsr
LS0KPiDCoGRyaXZlcnMvdGhlcm1hbC9xb3JpcV90aGVybWFsLmPCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIHzCoCAyICstCj4gwqBkcml2ZXJzL3RoZXJtYWwvcmNhcl9nZW4zX3Ro
ZXJtYWwuY8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHzCoCA0ICsrLS0KPiDCoGRyaXZlcnMv
dGhlcm1hbC9yY2FyX3RoZXJtYWwuY8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCB8wqAgMyArLS0KPiDCoGRyaXZlcnMvdGhlcm1hbC9yb2NrY2hpcF90aGVybWFsLmPCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIHzCoCA0ICsrLS0KPiDCoGRyaXZlcnMvdGhlcm1hbC9yemcy
bF90aGVybWFsLmPCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHzCoCAyICstCj4g
wqBkcml2ZXJzL3RoZXJtYWwvc2Ftc3VuZy9leHlub3NfdG11LmPCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqAgfMKgIDQgKystLQo+IMKgZHJpdmVycy90aGVybWFsL3NwZWFyX3RoZXJtYWwuY8KgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgfMKgIDggKysrKy0tLS0KPiDCoGRyaXZlcnMv
dGhlcm1hbC9zcHJkX3RoZXJtYWwuY8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCB8wqAgMiArLQo+IMKgZHJpdmVycy90aGVybWFsL3N1bjhpX3RoZXJtYWwuY8KgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgfMKgIDIgKy0KPiDCoGRyaXZlcnMvdGhlcm1hbC90ZWdy
YS90ZWdyYS1icG1wLXRoZXJtYWwuY8KgwqDCoMKgwqDCoCB8wqAgNiArKysrLS0KPiDCoGRyaXZl
cnMvdGhlcm1hbC90ZWdyYS90ZWdyYTMwLXRzZW5zb3IuY8KgwqDCoMKgwqDCoMKgwqDCoCB8wqAg
NCArKy0tCj4gwqBkcml2ZXJzL3RoZXJtYWwvdGhlcm1hbC1nZW5lcmljLWFkYy5jwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoCB8wqAgMiArLQo+IMKgZHJpdmVycy90aGVybWFsL3RoZXJtYWxfY29yZS5j
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHzCoCA2ICsrKysrKwo+IMKgZHJp
dmVycy90aGVybWFsL3RoZXJtYWxfbW1pby5jwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgIHzCoCAyICstCj4gwqAuLi4vdGhlcm1hbC90aS1zb2MtdGhlcm1hbC90aS10aGVybWFs
LWNvbW1vbi5jwqDCoCB8wqAgNCArKy0tCj4gwqBkcml2ZXJzL3RoZXJtYWwvdW5pcGhpZXJfdGhl
cm1hbC5jwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB8wqAgMiArLQo+IMKgaW5jbHVkZS9s
aW51eC90aGVybWFsLmjCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCB8wqAgMiArKwo+IMKgNTMgZmlsZXMgY2hhbmdlZCwgOTcgaW5zZXJ0aW9ucygrKSwg
OTEgZGVsZXRpb25zKC0pCj4gCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvYWNwaS90aGVybWFsLmMg
Yi9kcml2ZXJzL2FjcGkvdGhlcm1hbC5jCj4gaW5kZXggMGI0Yjg0NGY5ZDRjLi42OWQwZGE2NDU2
ZDUgMTAwNjQ0Cj4gLS0tIGEvZHJpdmVycy9hY3BpL3RoZXJtYWwuYwo+ICsrKyBiL2RyaXZlcnMv
YWNwaS90aGVybWFsLmMKPiBAQCAtNDk4LDcgKzQ5OCw3IEBAIHN0YXRpYyBpbnQgYWNwaV90aGVy
bWFsX2dldF90cmlwX3BvaW50cyhzdHJ1Y3QgYWNwaV90aGVybWFsICp0eikKPiDCoAo+IMKgc3Rh
dGljIGludCB0aGVybWFsX2dldF90ZW1wKHN0cnVjdCB0aGVybWFsX3pvbmVfZGV2aWNlICp0aGVy
bWFsLCBpbnQgKnRlbXApCj4gwqB7Cj4gLcKgwqDCoMKgwqDCoMKgc3RydWN0IGFjcGlfdGhlcm1h
bCAqdHogPSB0aGVybWFsLT5kZXZkYXRhOwo+ICvCoMKgwqDCoMKgwqDCoHN0cnVjdCBhY3BpX3Ro
ZXJtYWwgKnR6ID0gdGhlcm1hbF96b25lX2RldmljZV9nZXRfZGF0YSh0aGVybWFsKTsKPiDCoMKg
wqDCoMKgwqDCoMKgaW50IHJlc3VsdDsKPiDCoAo+IMKgwqDCoMKgwqDCoMKgwqBpZiAoIXR6KQo+
IEBAIC01MTYsNyArNTE2LDcgQEAgc3RhdGljIGludCB0aGVybWFsX2dldF90ZW1wKHN0cnVjdCB0
aGVybWFsX3pvbmVfZGV2aWNlICp0aGVybWFsLCBpbnQgKnRlbXApCj4gwqBzdGF0aWMgaW50IHRo
ZXJtYWxfZ2V0X3RyaXBfdHlwZShzdHJ1Y3QgdGhlcm1hbF96b25lX2RldmljZSAqdGhlcm1hbCwK
PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgIGludCB0cmlwLCBlbnVtIHRoZXJtYWxfdHJpcF90eXBlICp0eXBlKQo+IMKgewo+
IC3CoMKgwqDCoMKgwqDCoHN0cnVjdCBhY3BpX3RoZXJtYWwgKnR6ID0gdGhlcm1hbC0+ZGV2ZGF0
YTsKPiArwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgYWNwaV90aGVybWFsICp0eiA9IHRoZXJtYWxfem9u
ZV9kZXZpY2VfZ2V0X2RhdGEodGhlcm1hbCk7Cj4gwqDCoMKgwqDCoMKgwqDCoGludCBpOwo+IMKg
Cj4gwqDCoMKgwqDCoMKgwqDCoGlmICghdHogfHwgdHJpcCA8IDApCj4gQEAgLTU2MCw3ICs1NjAs
NyBAQCBzdGF0aWMgaW50IHRoZXJtYWxfZ2V0X3RyaXBfdHlwZShzdHJ1Y3QgdGhlcm1hbF96b25l
X2RldmljZSAqdGhlcm1hbCwKPiDCoHN0YXRpYyBpbnQgdGhlcm1hbF9nZXRfdHJpcF90ZW1wKHN0
cnVjdCB0aGVybWFsX3pvbmVfZGV2aWNlICp0aGVybWFsLAo+IMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaW50IHRyaXAsIGlu
dCAqdGVtcCkKPiDCoHsKPiAtwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgYWNwaV90aGVybWFsICp0eiA9
IHRoZXJtYWwtPmRldmRhdGE7Cj4gK8KgwqDCoMKgwqDCoMKgc3RydWN0IGFjcGlfdGhlcm1hbCAq
dHogPSB0aGVybWFsX3pvbmVfZGV2aWNlX2dldF9kYXRhKHRoZXJtYWwpOwo+IMKgwqDCoMKgwqDC
oMKgwqBpbnQgaTsKPiDCoAo+IMKgwqDCoMKgwqDCoMKgwqBpZiAoIXR6IHx8IHRyaXAgPCAwKQo+
IEBAIC02MTMsNyArNjEzLDcgQEAgc3RhdGljIGludCB0aGVybWFsX2dldF90cmlwX3RlbXAoc3Ry
dWN0IHRoZXJtYWxfem9uZV9kZXZpY2UgKnRoZXJtYWwsCj4gwqBzdGF0aWMgaW50IHRoZXJtYWxf
Z2V0X2NyaXRfdGVtcChzdHJ1Y3QgdGhlcm1hbF96b25lX2RldmljZSAqdGhlcm1hbCwKPiDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgaW50ICp0ZW1wZXJhdHVyZSkKPiDCoHsKPiAtwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgYWNwaV90
aGVybWFsICp0eiA9IHRoZXJtYWwtPmRldmRhdGE7Cj4gK8KgwqDCoMKgwqDCoMKgc3RydWN0IGFj
cGlfdGhlcm1hbCAqdHogPSB0aGVybWFsX3pvbmVfZGV2aWNlX2dldF9kYXRhKHRoZXJtYWwpOwo+
IMKgCj4gwqDCoMKgwqDCoMKgwqDCoGlmICh0ei0+dHJpcHMuY3JpdGljYWwuZmxhZ3MudmFsaWQp
IHsKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCp0ZW1wZXJhdHVyZSA9IGRlY2lf
a2VsdmluX3RvX21pbGxpY2Vsc2l1c193aXRoX29mZnNldCgKPiBAQCAtNjI4LDcgKzYyOCw3IEBA
IHN0YXRpYyBpbnQgdGhlcm1hbF9nZXRfY3JpdF90ZW1wKHN0cnVjdCB0aGVybWFsX3pvbmVfZGV2
aWNlICp0aGVybWFsLAo+IMKgc3RhdGljIGludCB0aGVybWFsX2dldF90cmVuZChzdHJ1Y3QgdGhl
cm1hbF96b25lX2RldmljZSAqdGhlcm1hbCwKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBpbnQgdHJpcCwgZW51bSB0aGVybWFsX3RyZW5k
ICp0cmVuZCkKPiDCoHsKPiAtwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgYWNwaV90aGVybWFsICp0eiA9
IHRoZXJtYWwtPmRldmRhdGE7Cj4gK8KgwqDCoMKgwqDCoMKgc3RydWN0IGFjcGlfdGhlcm1hbCAq
dHogPSB0aGVybWFsX3pvbmVfZGV2aWNlX2dldF9kYXRhKHRoZXJtYWwpOwo+IMKgwqDCoMKgwqDC
oMKgwqBlbnVtIHRoZXJtYWxfdHJpcF90eXBlIHR5cGU7Cj4gwqDCoMKgwqDCoMKgwqDCoGludCBp
Owo+IMKgCj4gQEAgLTY3MCw3ICs2NzAsNyBAQCBzdGF0aWMgaW50IHRoZXJtYWxfZ2V0X3RyZW5k
KHN0cnVjdCB0aGVybWFsX3pvbmVfZGV2aWNlICp0aGVybWFsLAo+IMKgCj4gwqBzdGF0aWMgdm9p
ZCBhY3BpX3RoZXJtYWxfem9uZV9kZXZpY2VfaG90KHN0cnVjdCB0aGVybWFsX3pvbmVfZGV2aWNl
ICp0aGVybWFsKQo+IMKgewo+IC3CoMKgwqDCoMKgwqDCoHN0cnVjdCBhY3BpX3RoZXJtYWwgKnR6
ID0gdGhlcm1hbC0+ZGV2ZGF0YTsKPiArwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgYWNwaV90aGVybWFs
ICp0eiA9IHRoZXJtYWxfem9uZV9kZXZpY2VfZ2V0X2RhdGEodGhlcm1hbCk7Cj4gwqAKPiDCoMKg
wqDCoMKgwqDCoMKgYWNwaV9idXNfZ2VuZXJhdGVfbmV0bGlua19ldmVudCh0ei0+ZGV2aWNlLT5w
bnAuZGV2aWNlX2NsYXNzLAo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgZGV2X25hbWUoJnR6LT5k
ZXZpY2UtPmRldiksCj4gQEAgLTY3OSw3ICs2NzksNyBAQCBzdGF0aWMgdm9pZCBhY3BpX3RoZXJt
YWxfem9uZV9kZXZpY2VfaG90KHN0cnVjdCB0aGVybWFsX3pvbmVfZGV2aWNlICp0aGVybWFsKQo+
IMKgCj4gwqBzdGF0aWMgdm9pZCBhY3BpX3RoZXJtYWxfem9uZV9kZXZpY2VfY3JpdGljYWwoc3Ry
dWN0IHRoZXJtYWxfem9uZV9kZXZpY2UgKnRoZXJtYWwpCj4gwqB7Cj4gLcKgwqDCoMKgwqDCoMKg
c3RydWN0IGFjcGlfdGhlcm1hbCAqdHogPSB0aGVybWFsLT5kZXZkYXRhOwo+ICvCoMKgwqDCoMKg
wqDCoHN0cnVjdCBhY3BpX3RoZXJtYWwgKnR6ID0gdGhlcm1hbF96b25lX2RldmljZV9nZXRfZGF0
YSh0aGVybWFsKTsKPiDCoAo+IMKgwqDCoMKgwqDCoMKgwqBhY3BpX2J1c19nZW5lcmF0ZV9uZXRs
aW5rX2V2ZW50KHR6LT5kZXZpY2UtPnBucC5kZXZpY2VfY2xhc3MsCj4gwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqBkZXZfbmFtZSgmdHotPmRldmljZS0+ZGV2KSwKPiBAQCAtNjkzLDcgKzY5Myw3IEBA
IHN0YXRpYyBpbnQgYWNwaV90aGVybWFsX2Nvb2xpbmdfZGV2aWNlX2NiKHN0cnVjdCB0aGVybWFs
X3pvbmVfZGV2aWNlICp0aGVybWFsLAo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgYm9vbCBi
aW5kKQo+IMKgewo+IMKgwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgYWNwaV9kZXZpY2UgKmRldmljZSA9
IGNkZXYtPmRldmRhdGE7Cj4gLcKgwqDCoMKgwqDCoMKgc3RydWN0IGFjcGlfdGhlcm1hbCAqdHog
PSB0aGVybWFsLT5kZXZkYXRhOwo+ICvCoMKgwqDCoMKgwqDCoHN0cnVjdCBhY3BpX3RoZXJtYWwg
KnR6ID0gdGhlcm1hbF96b25lX2RldmljZV9nZXRfZGF0YSh0aGVybWFsKTsKPiDCoMKgwqDCoMKg
wqDCoMKgc3RydWN0IGFjcGlfZGV2aWNlICpkZXY7Cj4gwqDCoMKgwqDCoMKgwqDCoGFjcGlfaGFu
ZGxlIGhhbmRsZTsKPiDCoMKgwqDCoMKgwqDCoMKgaW50IGk7Cj4gZGlmZiAtLWdpdCBhL2RyaXZl
cnMvYXRhL2FoY2lfaW14LmMgYi9kcml2ZXJzL2F0YS9haGNpX2lteC5jCj4gaW5kZXggYTk1MDc2
N2Y3OTQ4Li4wZWY5Mjg1MjhhZWMgMTAwNjQ0Cj4gLS0tIGEvZHJpdmVycy9hdGEvYWhjaV9pbXgu
Ywo+ICsrKyBiL2RyaXZlcnMvYXRhL2FoY2lfaW14LmMKPiBAQCAtNDE4LDcgKzQxOCw3IEBAIHN0
YXRpYyBpbnQgX19zYXRhX2FoY2lfcmVhZF90ZW1wZXJhdHVyZSh2b2lkICpkZXYsIGludCAqdGVt
cCkKPiDCoAo+IMKgc3RhdGljIGludCBzYXRhX2FoY2lfcmVhZF90ZW1wZXJhdHVyZShzdHJ1Y3Qg
dGhlcm1hbF96b25lX2RldmljZSAqdHosIGludCAqdGVtcCkKPiDCoHsKPiAtwqDCoMKgwqDCoMKg
wqByZXR1cm4gX19zYXRhX2FoY2lfcmVhZF90ZW1wZXJhdHVyZSh0ei0+ZGV2ZGF0YSwgdGVtcCk7
Cj4gK8KgwqDCoMKgwqDCoMKgcmV0dXJuIF9fc2F0YV9haGNpX3JlYWRfdGVtcGVyYXR1cmUodGhl
cm1hbF96b25lX2RldmljZV9nZXRfZGF0YSh0eiksIHRlbXApOwo+IMKgfQo+IMKgCj4gwqBzdGF0
aWMgc3NpemVfdCBzYXRhX2FoY2lfc2hvd190ZW1wKHN0cnVjdCBkZXZpY2UgKmRldiwKPiBkaWZm
IC0tZ2l0IGEvZHJpdmVycy9od21vbi9od21vbi5jIGIvZHJpdmVycy9od21vbi9od21vbi5jCj4g
aW5kZXggMzNlZGI1YzAyZjdkLi5iMzM0NzdkMDRjMmIgMTAwNjQ0Cj4gLS0tIGEvZHJpdmVycy9o
d21vbi9od21vbi5jCj4gKysrIGIvZHJpdmVycy9od21vbi9od21vbi5jCj4gQEAgLTE1NCw3ICsx
NTQsNyBAQCBzdGF0aWMgREVGSU5FX0lEQShod21vbl9pZGEpOwo+IMKgI2lmZGVmIENPTkZJR19U
SEVSTUFMX09GCj4gwqBzdGF0aWMgaW50IGh3bW9uX3RoZXJtYWxfZ2V0X3RlbXAoc3RydWN0IHRo
ZXJtYWxfem9uZV9kZXZpY2UgKnR6LCBpbnQgKnRlbXApCj4gwqB7Cj4gLcKgwqDCoMKgwqDCoMKg
c3RydWN0IGh3bW9uX3RoZXJtYWxfZGF0YSAqdGRhdGEgPSB0ei0+ZGV2ZGF0YTsKPiArwqDCoMKg
wqDCoMKgwqBzdHJ1Y3QgaHdtb25fdGhlcm1hbF9kYXRhICp0ZGF0YSA9IHRoZXJtYWxfem9uZV9k
ZXZpY2VfZ2V0X2RhdGEodHopOwo+IMKgwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgaHdtb25fZGV2aWNl
ICpod2RldiA9IHRvX2h3bW9uX2RldmljZSh0ZGF0YS0+ZGV2KTsKPiDCoMKgwqDCoMKgwqDCoMKg
aW50IHJldDsKPiDCoMKgwqDCoMKgwqDCoMKgbG9uZyB0Owo+IEBAIC0xNzEsNyArMTcxLDcgQEAg
c3RhdGljIGludCBod21vbl90aGVybWFsX2dldF90ZW1wKHN0cnVjdCB0aGVybWFsX3pvbmVfZGV2
aWNlICp0eiwgaW50ICp0ZW1wKQo+IMKgCj4gwqBzdGF0aWMgaW50IGh3bW9uX3RoZXJtYWxfc2V0
X3RyaXBzKHN0cnVjdCB0aGVybWFsX3pvbmVfZGV2aWNlICp0eiwgaW50IGxvdywgaW50IGhpZ2gp
Cj4gwqB7Cj4gLcKgwqDCoMKgwqDCoMKgc3RydWN0IGh3bW9uX3RoZXJtYWxfZGF0YSAqdGRhdGEg
PSB0ei0+ZGV2ZGF0YTsKPiArwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgaHdtb25fdGhlcm1hbF9kYXRh
ICp0ZGF0YSA9IHRoZXJtYWxfem9uZV9kZXZpY2VfZ2V0X2RhdGEodHopOwo+IMKgwqDCoMKgwqDC
oMKgwqBzdHJ1Y3QgaHdtb25fZGV2aWNlICpod2RldiA9IHRvX2h3bW9uX2RldmljZSh0ZGF0YS0+
ZGV2KTsKPiDCoMKgwqDCoMKgwqDCoMKgY29uc3Qgc3RydWN0IGh3bW9uX2NoaXBfaW5mbyAqY2hp
cCA9IGh3ZGV2LT5jaGlwOwo+IMKgwqDCoMKgwqDCoMKgwqBjb25zdCBzdHJ1Y3QgaHdtb25fY2hh
bm5lbF9pbmZvICoqaW5mbyA9IGNoaXAtPmluZm87Cj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvaHdt
b24vcG1idXMvcG1idXNfY29yZS5jIGIvZHJpdmVycy9od21vbi9wbWJ1cy9wbWJ1c19jb3JlLmMK
PiBpbmRleCA5NWU5NTc4Mzk3MmEuLjE1OWE4OGFmNjI3NyAxMDA2NDQKPiAtLS0gYS9kcml2ZXJz
L2h3bW9uL3BtYnVzL3BtYnVzX2NvcmUuYwo+ICsrKyBiL2RyaXZlcnMvaHdtb24vcG1idXMvcG1i
dXNfY29yZS5jCj4gQEAgLTEyNzIsNyArMTI3Miw3IEBAIHN0cnVjdCBwbWJ1c190aGVybWFsX2Rh
dGEgewo+IMKgCj4gwqBzdGF0aWMgaW50IHBtYnVzX3RoZXJtYWxfZ2V0X3RlbXAoc3RydWN0IHRo
ZXJtYWxfem9uZV9kZXZpY2UgKnR6LCBpbnQgKnRlbXApCj4gwqB7Cj4gLcKgwqDCoMKgwqDCoMKg
c3RydWN0IHBtYnVzX3RoZXJtYWxfZGF0YSAqdGRhdGEgPSB0ei0+ZGV2ZGF0YTsKPiArwqDCoMKg
wqDCoMKgwqBzdHJ1Y3QgcG1idXNfdGhlcm1hbF9kYXRhICp0ZGF0YSA9IHRoZXJtYWxfem9uZV9k
ZXZpY2VfZ2V0X2RhdGEodHopOwo+IMKgwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgcG1idXNfc2Vuc29y
ICpzZW5zb3IgPSB0ZGF0YS0+c2Vuc29yOwo+IMKgwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgcG1idXNf
ZGF0YSAqcG1idXNfZGF0YSA9IHRkYXRhLT5wbWJ1c19kYXRhOwo+IMKgwqDCoMKgwqDCoMKgwqBz
dHJ1Y3QgaTJjX2NsaWVudCAqY2xpZW50ID0gdG9faTJjX2NsaWVudChwbWJ1c19kYXRhLT5kZXYp
Owo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2h3bW9uL3NjbWktaHdtb24uYyBiL2RyaXZlcnMvaHdt
b24vc2NtaS1od21vbi5jCj4gaW5kZXggZTE5MmYwYzY3MTQ2Li43OTUxYjYwMjZmNDggMTAwNjQ0
Cj4gLS0tIGEvZHJpdmVycy9od21vbi9zY21pLWh3bW9uLmMKPiArKysgYi9kcml2ZXJzL2h3bW9u
L3NjbWktaHdtb24uYwo+IEBAIC0xNDEsNyArMTQxLDcgQEAgc3RhdGljIGludCBzY21pX2h3bW9u
X3RoZXJtYWxfZ2V0X3RlbXAoc3RydWN0IHRoZXJtYWxfem9uZV9kZXZpY2UgKnR6LAo+IMKgewo+
IMKgwqDCoMKgwqDCoMKgwqBpbnQgcmV0Owo+IMKgwqDCoMKgwqDCoMKgwqBsb25nIHZhbHVlOwo+
IC3CoMKgwqDCoMKgwqDCoHN0cnVjdCBzY21pX3RoZXJtYWxfc2Vuc29yICp0aF9zZW5zb3IgPSB0
ei0+ZGV2ZGF0YTsKPiArwqDCoMKgwqDCoMKgwqBzdHJ1Y3Qgc2NtaV90aGVybWFsX3NlbnNvciAq
dGhfc2Vuc29yID0gdGhlcm1hbF96b25lX2RldmljZV9nZXRfZGF0YSh0eik7Cj4gwqAKPiDCoMKg
wqDCoMKgwqDCoMKgcmV0ID0gc2NtaV9od21vbl9yZWFkX3NjYWxlZF92YWx1ZSh0aF9zZW5zb3It
PnBoLCB0aF9zZW5zb3ItPmluZm8sCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICZ2YWx1
ZSk7Cj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvaHdtb24vc2NwaS1od21vbi5jIGIvZHJpdmVycy9o
d21vbi9zY3BpLWh3bW9uLmMKPiBpbmRleCA0ZDc1Mzg1ZjdkNWUuLmVmZTBkZGJjNTI5MyAxMDA2
NDQKPiAtLS0gYS9kcml2ZXJzL2h3bW9uL3NjcGktaHdtb24uYwo+ICsrKyBiL2RyaXZlcnMvaHdt
b24vc2NwaS1od21vbi5jCj4gQEAgLTY0LDcgKzY0LDcgQEAgc3RhdGljIHZvaWQgc2NwaV9zY2Fs
ZV9yZWFkaW5nKHU2NCAqdmFsdWUsIHN0cnVjdCBzZW5zb3JfZGF0YSAqc2Vuc29yKQo+IMKgCj4g
wqBzdGF0aWMgaW50IHNjcGlfcmVhZF90ZW1wKHN0cnVjdCB0aGVybWFsX3pvbmVfZGV2aWNlICp0
eiwgaW50ICp0ZW1wKQo+IMKgewo+IC3CoMKgwqDCoMKgwqDCoHN0cnVjdCBzY3BpX3RoZXJtYWxf
em9uZSAqem9uZSA9IHR6LT5kZXZkYXRhOwo+ICvCoMKgwqDCoMKgwqDCoHN0cnVjdCBzY3BpX3Ro
ZXJtYWxfem9uZSAqem9uZSA9IHRoZXJtYWxfem9uZV9kZXZpY2VfZ2V0X2RhdGEodHopOwo+IMKg
wqDCoMKgwqDCoMKgwqBzdHJ1Y3Qgc2NwaV9zZW5zb3JzICpzY3BpX3NlbnNvcnMgPSB6b25lLT5z
Y3BpX3NlbnNvcnM7Cj4gwqDCoMKgwqDCoMKgwqDCoHN0cnVjdCBzY3BpX29wcyAqc2NwaV9vcHMg
PSBzY3BpX3NlbnNvcnMtPnNjcGlfb3BzOwo+IMKgwqDCoMKgwqDCoMKgwqBzdHJ1Y3Qgc2Vuc29y
X2RhdGEgKnNlbnNvciA9ICZzY3BpX3NlbnNvcnMtPmRhdGFbem9uZS0+c2Vuc29yX2lkXTsKPiBk
aWZmIC0tZ2l0IGEvZHJpdmVycy9paW8vYWRjL3N1bjRpLWdwYWRjLWlpby5jIGIvZHJpdmVycy9p
aW8vYWRjL3N1bjRpLWdwYWRjLWlpby5jCj4gaW5kZXggYTZhZGU3MGRlZGY4Li5lMjRhYzNlZThh
MzUgMTAwNjQ0Cj4gLS0tIGEvZHJpdmVycy9paW8vYWRjL3N1bjRpLWdwYWRjLWlpby5jCj4gKysr
IGIvZHJpdmVycy9paW8vYWRjL3N1bjRpLWdwYWRjLWlpby5jCj4gQEAgLTQxNCw3ICs0MTQsNyBA
QCBzdGF0aWMgaW50IHN1bjRpX2dwYWRjX3J1bnRpbWVfcmVzdW1lKHN0cnVjdCBkZXZpY2UgKmRl
dikKPiDCoAo+IMKgc3RhdGljIGludCBzdW40aV9ncGFkY19nZXRfdGVtcChzdHJ1Y3QgdGhlcm1h
bF96b25lX2RldmljZSAqdHosIGludCAqdGVtcCkKPiDCoHsKPiAtwqDCoMKgwqDCoMKgwqBzdHJ1
Y3Qgc3VuNGlfZ3BhZGNfaWlvICppbmZvID0gdHotPmRldmRhdGE7Cj4gK8KgwqDCoMKgwqDCoMKg
c3RydWN0IHN1bjRpX2dwYWRjX2lpbyAqaW5mbyA9IHRoZXJtYWxfem9uZV9kZXZpY2VfZ2V0X2Rh
dGEodHopOwo+IMKgwqDCoMKgwqDCoMKgwqBpbnQgdmFsLCBzY2FsZSwgb2Zmc2V0Owo+IMKgCj4g
wqDCoMKgwqDCoMKgwqDCoGlmIChzdW40aV9ncGFkY190ZW1wX3JlYWQoaW5mby0+aW5kaW9fZGV2
LCAmdmFsKSkKPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9pbnB1dC90b3VjaHNjcmVlbi9zdW40aS10
cy5jIGIvZHJpdmVycy9pbnB1dC90b3VjaHNjcmVlbi9zdW40aS10cy5jCj4gaW5kZXggNzNlYjhm
ODBiZTZlLi41ZTU0MzRmZmUzOTcgMTAwNjQ0Cj4gLS0tIGEvZHJpdmVycy9pbnB1dC90b3VjaHNj
cmVlbi9zdW40aS10cy5jCj4gKysrIGIvZHJpdmVycy9pbnB1dC90b3VjaHNjcmVlbi9zdW40aS10
cy5jCj4gQEAgLTE5NCw3ICsxOTQsNyBAQCBzdGF0aWMgaW50IHN1bjRpX2dldF90ZW1wKGNvbnN0
IHN0cnVjdCBzdW40aV90c19kYXRhICp0cywgaW50ICp0ZW1wKQo+IMKgCj4gwqBzdGF0aWMgaW50
IHN1bjRpX2dldF90el90ZW1wKHN0cnVjdCB0aGVybWFsX3pvbmVfZGV2aWNlICp0eiwgaW50ICp0
ZW1wKQo+IMKgewo+IC3CoMKgwqDCoMKgwqDCoHJldHVybiBzdW40aV9nZXRfdGVtcCh0ei0+ZGV2
ZGF0YSwgdGVtcCk7Cj4gK8KgwqDCoMKgwqDCoMKgcmV0dXJuIHN1bjRpX2dldF90ZW1wKHRoZXJt
YWxfem9uZV9kZXZpY2VfZ2V0X2RhdGEodHopLCB0ZW1wKTsKPiDCoH0KPiDCoAo+IMKgc3RhdGlj
IGNvbnN0IHN0cnVjdCB0aGVybWFsX3pvbmVfZGV2aWNlX29wcyBzdW40aV90c190el9vcHMgPSB7
Cj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2NoZWxzaW8vY3hnYjQvY3hnYjRf
dGhlcm1hbC5jIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvY2hlbHNpby9jeGdiNC9jeGdiNF90aGVy
bWFsLmMKPiBpbmRleCA5NWUxYjQxNWJhMTMuLjhiMGQzMThmZWVmNCAxMDA2NDQKPiAtLS0gYS9k
cml2ZXJzL25ldC9ldGhlcm5ldC9jaGVsc2lvL2N4Z2I0L2N4Z2I0X3RoZXJtYWwuYwo+ICsrKyBi
L2RyaXZlcnMvbmV0L2V0aGVybmV0L2NoZWxzaW8vY3hnYjQvY3hnYjRfdGhlcm1hbC5jCj4gQEAg
LTEyLDcgKzEyLDcgQEAKPiDCoHN0YXRpYyBpbnQgY3hnYjRfdGhlcm1hbF9nZXRfdGVtcChzdHJ1
Y3QgdGhlcm1hbF96b25lX2RldmljZSAqdHpkZXYsCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGludCAqdGVtcCkKPiDC
oHsKPiAtwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgYWRhcHRlciAqYWRhcCA9IHR6ZGV2LT5kZXZkYXRh
Owo+ICvCoMKgwqDCoMKgwqDCoHN0cnVjdCBhZGFwdGVyICphZGFwID0gdGhlcm1hbF96b25lX2Rl
dmljZV9nZXRfZGF0YSh0emRldik7Cj4gwqDCoMKgwqDCoMKgwqDCoHUzMiBwYXJhbSwgdmFsOwo+
IMKgwqDCoMKgwqDCoMKgwqBpbnQgcmV0Owo+IMKgCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0
L2V0aGVybmV0L21lbGxhbm94L21seHN3L2NvcmVfdGhlcm1hbC5jIGIvZHJpdmVycy9uZXQvZXRo
ZXJuZXQvbWVsbGFub3gvbWx4c3cvY29yZV90aGVybWFsLmMKPiBpbmRleCBjNTI0MGQzOGM5ZGIu
LjIyOGI2ZmZhZWY5OCAxMDA2NDQKPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5v
eC9tbHhzdy9jb3JlX3RoZXJtYWwuYwo+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxh
bm94L21seHN3L2NvcmVfdGhlcm1hbC5jCj4gQEAgLTIwMSw3ICsyMDEsNyBAQCBtbHhzd190aGVy
bWFsX21vZHVsZV90cmlwc191cGRhdGUoc3RydWN0IGRldmljZSAqZGV2LCBzdHJ1Y3QgbWx4c3df
Y29yZSAqY29yZSwKPiDCoHN0YXRpYyBpbnQgbWx4c3dfdGhlcm1hbF9iaW5kKHN0cnVjdCB0aGVy
bWFsX3pvbmVfZGV2aWNlICp0emRldiwKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHN0cnVjdCB0aGVybWFsX2Nvb2xpbmdfZGV2aWNl
ICpjZGV2KQo+IMKgewo+IC3CoMKgwqDCoMKgwqDCoHN0cnVjdCBtbHhzd190aGVybWFsICp0aGVy
bWFsID0gdHpkZXYtPmRldmRhdGE7Cj4gK8KgwqDCoMKgwqDCoMKgc3RydWN0IG1seHN3X3RoZXJt
YWwgKnRoZXJtYWwgPSB0aGVybWFsX3pvbmVfZGV2aWNlX2dldF9kYXRhKHR6ZGV2KTsKPiDCoMKg
wqDCoMKgwqDCoMKgc3RydWN0IGRldmljZSAqZGV2ID0gdGhlcm1hbC0+YnVzX2luZm8tPmRldjsK
PiDCoMKgwqDCoMKgwqDCoMKgaW50IGksIGVycjsKPiDCoAo+IEBAIC0yMjcsNyArMjI3LDcgQEAg
c3RhdGljIGludCBtbHhzd190aGVybWFsX2JpbmQoc3RydWN0IHRoZXJtYWxfem9uZV9kZXZpY2Ug
KnR6ZGV2LAo+IMKgc3RhdGljIGludCBtbHhzd190aGVybWFsX3VuYmluZChzdHJ1Y3QgdGhlcm1h
bF96b25lX2RldmljZSAqdHpkZXYsCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHN0cnVjdCB0aGVybWFsX2Nvb2xpbmdfZGV2
aWNlICpjZGV2KQo+IMKgewo+IC3CoMKgwqDCoMKgwqDCoHN0cnVjdCBtbHhzd190aGVybWFsICp0
aGVybWFsID0gdHpkZXYtPmRldmRhdGE7Cj4gK8KgwqDCoMKgwqDCoMKgc3RydWN0IG1seHN3X3Ro
ZXJtYWwgKnRoZXJtYWwgPSB0aGVybWFsX3pvbmVfZGV2aWNlX2dldF9kYXRhKHR6ZGV2KTsKPiDC
oMKgwqDCoMKgwqDCoMKgc3RydWN0IGRldmljZSAqZGV2ID0gdGhlcm1hbC0+YnVzX2luZm8tPmRl
djsKPiDCoMKgwqDCoMKgwqDCoMKgaW50IGk7Cj4gwqDCoMKgwqDCoMKgwqDCoGludCBlcnI7Cj4g
QEAgLTI0OSw3ICsyNDksNyBAQCBzdGF0aWMgaW50IG1seHN3X3RoZXJtYWxfdW5iaW5kKHN0cnVj
dCB0aGVybWFsX3pvbmVfZGV2aWNlICp0emRldiwKPiDCoHN0YXRpYyBpbnQgbWx4c3dfdGhlcm1h
bF9nZXRfdGVtcChzdHJ1Y3QgdGhlcm1hbF96b25lX2RldmljZSAqdHpkZXYsCj4gwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
IGludCAqcF90ZW1wKQo+IMKgewo+IC3CoMKgwqDCoMKgwqDCoHN0cnVjdCBtbHhzd190aGVybWFs
ICp0aGVybWFsID0gdHpkZXYtPmRldmRhdGE7Cj4gK8KgwqDCoMKgwqDCoMKgc3RydWN0IG1seHN3
X3RoZXJtYWwgKnRoZXJtYWwgPSB0aGVybWFsX3pvbmVfZGV2aWNlX2dldF9kYXRhKHR6ZGV2KTsK
PiDCoMKgwqDCoMKgwqDCoMKgc3RydWN0IGRldmljZSAqZGV2ID0gdGhlcm1hbC0+YnVzX2luZm8t
PmRldjsKPiDCoMKgwqDCoMKgwqDCoMKgY2hhciBtdG1wX3BsW01MWFNXX1JFR19NVE1QX0xFTl07
Cj4gwqDCoMKgwqDCoMKgwqDCoGludCB0ZW1wOwo+IEBAIC0yODEsNyArMjgxLDcgQEAgc3RhdGlj
IHN0cnVjdCB0aGVybWFsX3pvbmVfZGV2aWNlX29wcyBtbHhzd190aGVybWFsX29wcyA9IHsKPiDC
oHN0YXRpYyBpbnQgbWx4c3dfdGhlcm1hbF9tb2R1bGVfYmluZChzdHJ1Y3QgdGhlcm1hbF96b25l
X2RldmljZSAqdHpkZXYsCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHN0cnVjdCB0aGVybWFsX2Nvb2xpbmdf
ZGV2aWNlICpjZGV2KQo+IMKgewo+IC3CoMKgwqDCoMKgwqDCoHN0cnVjdCBtbHhzd190aGVybWFs
X21vZHVsZSAqdHogPSB0emRldi0+ZGV2ZGF0YTsKPiArwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgbWx4
c3dfdGhlcm1hbF9tb2R1bGUgKnR6ID0gdGhlcm1hbF96b25lX2RldmljZV9nZXRfZGF0YSh0emRl
dik7Cj4gwqDCoMKgwqDCoMKgwqDCoHN0cnVjdCBtbHhzd190aGVybWFsICp0aGVybWFsID0gdHot
PnBhcmVudDsKPiDCoMKgwqDCoMKgwqDCoMKgaW50IGksIGosIGVycjsKPiDCoAo+IEBAIC0zMTAs
NyArMzEwLDcgQEAgc3RhdGljIGludCBtbHhzd190aGVybWFsX21vZHVsZV9iaW5kKHN0cnVjdCB0
aGVybWFsX3pvbmVfZGV2aWNlICp0emRldiwKPiDCoHN0YXRpYyBpbnQgbWx4c3dfdGhlcm1hbF9t
b2R1bGVfdW5iaW5kKHN0cnVjdCB0aGVybWFsX3pvbmVfZGV2aWNlICp0emRldiwKPiDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIHN0cnVjdCB0aGVybWFsX2Nvb2xpbmdfZGV2aWNlICpjZGV2KQo+IMKgewo+
IC3CoMKgwqDCoMKgwqDCoHN0cnVjdCBtbHhzd190aGVybWFsX21vZHVsZSAqdHogPSB0emRldi0+
ZGV2ZGF0YTsKPiArwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgbWx4c3dfdGhlcm1hbF9tb2R1bGUgKnR6
ID0gdGhlcm1hbF96b25lX2RldmljZV9nZXRfZGF0YSh0emRldik7Cj4gwqDCoMKgwqDCoMKgwqDC
oHN0cnVjdCBtbHhzd190aGVybWFsICp0aGVybWFsID0gdHotPnBhcmVudDsKPiDCoMKgwqDCoMKg
wqDCoMKgaW50IGk7Cj4gwqDCoMKgwqDCoMKgwqDCoGludCBlcnI7Cj4gQEAgLTM1Niw3ICszNTYs
NyBAQCBtbHhzd190aGVybWFsX21vZHVsZV90ZW1wX2FuZF90aHJlc2hvbGRzX2dldChzdHJ1Y3Qg
bWx4c3dfY29yZSAqY29yZSwKPiDCoHN0YXRpYyBpbnQgbWx4c3dfdGhlcm1hbF9tb2R1bGVfdGVt
cF9nZXQoc3RydWN0IHRoZXJtYWxfem9uZV9kZXZpY2UgKnR6ZGV2LAo+IMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgIGludCAqcF90ZW1wKQo+IMKgewo+IC3CoMKgwqDCoMKgwqDCoHN0cnVjdCBtbHhz
d190aGVybWFsX21vZHVsZSAqdHogPSB0emRldi0+ZGV2ZGF0YTsKPiArwqDCoMKgwqDCoMKgwqBz
dHJ1Y3QgbWx4c3dfdGhlcm1hbF9tb2R1bGUgKnR6ID0gdGhlcm1hbF96b25lX2RldmljZV9nZXRf
ZGF0YSh0emRldik7Cj4gwqDCoMKgwqDCoMKgwqDCoHN0cnVjdCBtbHhzd190aGVybWFsICp0aGVy
bWFsID0gdHotPnBhcmVudDsKPiDCoMKgwqDCoMKgwqDCoMKgaW50IHRlbXAsIGNyaXRfdGVtcCwg
ZW1lcmdfdGVtcDsKPiDCoMKgwqDCoMKgwqDCoMKgc3RydWN0IGRldmljZSAqZGV2Owo+IEBAIC0z
OTEsNyArMzkxLDcgQEAgc3RhdGljIHN0cnVjdCB0aGVybWFsX3pvbmVfZGV2aWNlX29wcyBtbHhz
d190aGVybWFsX21vZHVsZV9vcHMgPSB7Cj4gwqBzdGF0aWMgaW50IG1seHN3X3RoZXJtYWxfZ2Vh
cmJveF90ZW1wX2dldChzdHJ1Y3QgdGhlcm1hbF96b25lX2RldmljZSAqdHpkZXYsCj4gwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCBpbnQgKnBfdGVtcCkKPiDCoHsKPiAtwqDCoMKgwqDCoMKgwqBz
dHJ1Y3QgbWx4c3dfdGhlcm1hbF9tb2R1bGUgKnR6ID0gdHpkZXYtPmRldmRhdGE7Cj4gK8KgwqDC
oMKgwqDCoMKgc3RydWN0IG1seHN3X3RoZXJtYWxfbW9kdWxlICp0eiA9IHRoZXJtYWxfem9uZV9k
ZXZpY2VfZ2V0X2RhdGEodHpkZXYpOwo+IMKgwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgbWx4c3dfdGhl
cm1hbCAqdGhlcm1hbCA9IHR6LT5wYXJlbnQ7Cj4gwqDCoMKgwqDCoMKgwqDCoGNoYXIgbXRtcF9w
bFtNTFhTV19SRUdfTVRNUF9MRU5dOwo+IMKgwqDCoMKgwqDCoMKgwqB1MTYgaW5kZXg7Cj4gZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2ludGVsL2l3bHdpZmkvbXZtL3R0LmMgYi9k
cml2ZXJzL25ldC93aXJlbGVzcy9pbnRlbC9pd2x3aWZpL212bS90dC5jCj4gaW5kZXggMjMyYzIw
MGFmMzhmLi5lZThmZWUyOTEwN2YgMTAwNjQ0Cj4gLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3Mv
aW50ZWwvaXdsd2lmaS9tdm0vdHQuYwo+ICsrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2ludGVs
L2l3bHdpZmkvbXZtL3R0LmMKPiBAQCAtNjE1LDcgKzYxNSw3IEBAIGludCBpd2xfbXZtX3NlbmRf
dGVtcF9yZXBvcnRfdGhzX2NtZChzdHJ1Y3QgaXdsX212bSAqbXZtKQo+IMKgc3RhdGljIGludCBp
d2xfbXZtX3R6b25lX2dldF90ZW1wKHN0cnVjdCB0aGVybWFsX3pvbmVfZGV2aWNlICpkZXZpY2Us
Cj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIGludCAqdGVtcGVyYXR1cmUpCj4gwqB7Cj4gLcKgwqDCoMKgwqDCoMKgc3Ry
dWN0IGl3bF9tdm0gKm12bSA9IChzdHJ1Y3QgaXdsX212bSAqKWRldmljZS0+ZGV2ZGF0YTsKPiAr
wqDCoMKgwqDCoMKgwqBzdHJ1Y3QgaXdsX212bSAqbXZtID0gdGhlcm1hbF96b25lX2RldmljZV9n
ZXRfZGF0YShkZXZpY2UpOwo+IMKgwqDCoMKgwqDCoMKgwqBpbnQgcmV0Owo+IMKgwqDCoMKgwqDC
oMKgwqBpbnQgdGVtcDsKPiDCoAo+IEBAIC02NDEsNyArNjQxLDcgQEAgc3RhdGljIGludCBpd2xf
bXZtX3R6b25lX2dldF90ZW1wKHN0cnVjdCB0aGVybWFsX3pvbmVfZGV2aWNlICpkZXZpY2UsCj4g
wqBzdGF0aWMgaW50IGl3bF9tdm1fdHpvbmVfc2V0X3RyaXBfdGVtcChzdHJ1Y3QgdGhlcm1hbF96
b25lX2RldmljZSAqZGV2aWNlLAo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaW50IHRyaXAsIGludCB0
ZW1wKQo+IMKgewo+IC3CoMKgwqDCoMKgwqDCoHN0cnVjdCBpd2xfbXZtICptdm0gPSAoc3RydWN0
IGl3bF9tdm0gKilkZXZpY2UtPmRldmRhdGE7Cj4gK8KgwqDCoMKgwqDCoMKgc3RydWN0IGl3bF9t
dm0gKm12bSA9IHRoZXJtYWxfem9uZV9kZXZpY2VfZ2V0X2RhdGEoZGV2aWNlKTsKPiDCoMKgwqDC
oMKgwqDCoMKgc3RydWN0IGl3bF9tdm1fdGhlcm1hbF9kZXZpY2UgKnR6b25lOwo+IMKgwqDCoMKg
wqDCoMKgwqBpbnQgcmV0Owo+IMKgCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvcG93ZXIvc3VwcGx5
L3Bvd2VyX3N1cHBseV9jb3JlLmMgYi9kcml2ZXJzL3Bvd2VyL3N1cHBseS9wb3dlcl9zdXBwbHlf
Y29yZS5jCj4gaW5kZXggN2M3OTBjNDFlMmZlLi4xNjZmMGFhY2M3OTcgMTAwNjQ0Cj4gLS0tIGEv
ZHJpdmVycy9wb3dlci9zdXBwbHkvcG93ZXJfc3VwcGx5X2NvcmUuYwo+ICsrKyBiL2RyaXZlcnMv
cG93ZXIvc3VwcGx5L3Bvd2VyX3N1cHBseV9jb3JlLmMKPiBAQCAtMTE0Miw3ICsxMTQyLDcgQEAg
c3RhdGljIGludCBwb3dlcl9zdXBwbHlfcmVhZF90ZW1wKHN0cnVjdCB0aGVybWFsX3pvbmVfZGV2
aWNlICp0emQsCj4gwqDCoMKgwqDCoMKgwqDCoGludCByZXQ7Cj4gwqAKPiDCoMKgwqDCoMKgwqDC
oMKgV0FSTl9PTih0emQgPT0gTlVMTCk7Cj4gLcKgwqDCoMKgwqDCoMKgcHN5ID0gdHpkLT5kZXZk
YXRhOwo+ICvCoMKgwqDCoMKgwqDCoHBzeSA9IHRoZXJtYWxfem9uZV9kZXZpY2VfZ2V0X2RhdGEo
dHpkKTsKPiDCoMKgwqDCoMKgwqDCoMKgcmV0ID0gcG93ZXJfc3VwcGx5X2dldF9wcm9wZXJ0eShw
c3ksIFBPV0VSX1NVUFBMWV9QUk9QX1RFTVAsICZ2YWwpOwo+IMKgwqDCoMKgwqDCoMKgwqBpZiAo
cmV0KQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIHJldDsKPiBkaWZm
IC0tZ2l0IGEvZHJpdmVycy9yZWd1bGF0b3IvbWF4ODk3My1yZWd1bGF0b3IuYyBiL2RyaXZlcnMv
cmVndWxhdG9yL21heDg5NzMtcmVndWxhdG9yLmMKPiBpbmRleCA3ZTAwYTQ1ZGIyNmEuLmNjYWNi
YTY2ZDM2NyAxMDA2NDQKPiAtLS0gYS9kcml2ZXJzL3JlZ3VsYXRvci9tYXg4OTczLXJlZ3VsYXRv
ci5jCj4gKysrIGIvZHJpdmVycy9yZWd1bGF0b3IvbWF4ODk3My1yZWd1bGF0b3IuYwo+IEBAIC00
MzYsNyArNDM2LDcgQEAgc3RhdGljIGludCBtYXg4OTczX2luaXRfZGNkYyhzdHJ1Y3QgbWF4ODk3
M19jaGlwICptYXgsCj4gwqAKPiDCoHN0YXRpYyBpbnQgbWF4ODk3M190aGVybWFsX3JlYWRfdGVt
cChzdHJ1Y3QgdGhlcm1hbF96b25lX2RldmljZSAqdHosIGludCAqdGVtcCkKPiDCoHsKPiAtwqDC
oMKgwqDCoMKgwqBzdHJ1Y3QgbWF4ODk3M19jaGlwICptY2hpcCA9IHR6LT5kZXZkYXRhOwo+ICvC
oMKgwqDCoMKgwqDCoHN0cnVjdCBtYXg4OTczX2NoaXAgKm1jaGlwID0gdGhlcm1hbF96b25lX2Rl
dmljZV9nZXRfZGF0YSh0eik7Cj4gwqDCoMKgwqDCoMKgwqDCoHVuc2lnbmVkIGludCB2YWw7Cj4g
wqDCoMKgwqDCoMKgwqDCoGludCByZXQ7Cj4gwqAKPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy90aGVy
bWFsL2FybWFkYV90aGVybWFsLmMgYi9kcml2ZXJzL3RoZXJtYWwvYXJtYWRhX3RoZXJtYWwuYwo+
IGluZGV4IDJlZmMyMjJhMzc5Yi4uODJkM2UxNWQ1MWY2IDEwMDY0NAo+IC0tLSBhL2RyaXZlcnMv
dGhlcm1hbC9hcm1hZGFfdGhlcm1hbC5jCj4gKysrIGIvZHJpdmVycy90aGVybWFsL2FybWFkYV90
aGVybWFsLmMKPiBAQCAtMzk4LDcgKzM5OCw3IEBAIHN0YXRpYyBpbnQgYXJtYWRhX3JlYWRfc2Vu
c29yKHN0cnVjdCBhcm1hZGFfdGhlcm1hbF9wcml2ICpwcml2LCBpbnQgKnRlbXApCj4gwqBzdGF0
aWMgaW50IGFybWFkYV9nZXRfdGVtcF9sZWdhY3koc3RydWN0IHRoZXJtYWxfem9uZV9kZXZpY2Ug
KnRoZXJtYWwsCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIGludCAqdGVtcCkKPiDCoHsKPiAtwqDCoMKgwqDCoMKgwqBz
dHJ1Y3QgYXJtYWRhX3RoZXJtYWxfcHJpdiAqcHJpdiA9IHRoZXJtYWwtPmRldmRhdGE7Cj4gK8Kg
wqDCoMKgwqDCoMKgc3RydWN0IGFybWFkYV90aGVybWFsX3ByaXYgKnByaXYgPSB0aGVybWFsX3pv
bmVfZGV2aWNlX2dldF9kYXRhKHRoZXJtYWwpOwo+IMKgwqDCoMKgwqDCoMKgwqBpbnQgcmV0Owo+
IMKgCj4gwqDCoMKgwqDCoMKgwqDCoC8qIFZhbGlkIGNoZWNrICovCj4gQEAgLTQyMCw3ICs0MjAs
NyBAQCBzdGF0aWMgc3RydWN0IHRoZXJtYWxfem9uZV9kZXZpY2Vfb3BzIGxlZ2FjeV9vcHMgPSB7
Cj4gwqAKPiDCoHN0YXRpYyBpbnQgYXJtYWRhX2dldF90ZW1wKHN0cnVjdCB0aGVybWFsX3pvbmVf
ZGV2aWNlICp0eiwgaW50ICp0ZW1wKQo+IMKgewo+IC3CoMKgwqDCoMKgwqDCoHN0cnVjdCBhcm1h
ZGFfdGhlcm1hbF9zZW5zb3IgKnNlbnNvciA9IHR6LT5kZXZkYXRhOwo+ICvCoMKgwqDCoMKgwqDC
oHN0cnVjdCBhcm1hZGFfdGhlcm1hbF9zZW5zb3IgKnNlbnNvciA9IHRoZXJtYWxfem9uZV9kZXZp
Y2VfZ2V0X2RhdGEodHopOwo+IMKgwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgYXJtYWRhX3RoZXJtYWxf
cHJpdiAqcHJpdiA9IHNlbnNvci0+cHJpdjsKPiDCoMKgwqDCoMKgwqDCoMKgaW50IHJldDsKPiDC
oAo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3RoZXJtYWwvYnJvYWRjb20vYmNtMjcxMV90aGVybWFs
LmMgYi9kcml2ZXJzL3RoZXJtYWwvYnJvYWRjb20vYmNtMjcxMV90aGVybWFsLmMKPiBpbmRleCAx
Zjg2NTFkMTUxNjAuLjE4YjFhNGQ5ZWNjNyAxMDA2NDQKPiAtLS0gYS9kcml2ZXJzL3RoZXJtYWwv
YnJvYWRjb20vYmNtMjcxMV90aGVybWFsLmMKPiArKysgYi9kcml2ZXJzL3RoZXJtYWwvYnJvYWRj
b20vYmNtMjcxMV90aGVybWFsLmMKPiBAQCAtMzMsNyArMzMsNyBAQCBzdHJ1Y3QgYmNtMjcxMV90
aGVybWFsX3ByaXYgewo+IMKgCj4gwqBzdGF0aWMgaW50IGJjbTI3MTFfZ2V0X3RlbXAoc3RydWN0
IHRoZXJtYWxfem9uZV9kZXZpY2UgKnR6LCBpbnQgKnRlbXApCj4gwqB7Cj4gLcKgwqDCoMKgwqDC
oMKgc3RydWN0IGJjbTI3MTFfdGhlcm1hbF9wcml2ICpwcml2ID0gdHotPmRldmRhdGE7Cj4gK8Kg
wqDCoMKgwqDCoMKgc3RydWN0IGJjbTI3MTFfdGhlcm1hbF9wcml2ICpwcml2ID0gdGhlcm1hbF96
b25lX2RldmljZV9nZXRfZGF0YSh0eik7Cj4gwqDCoMKgwqDCoMKgwqDCoGludCBzbG9wZSA9IHRo
ZXJtYWxfem9uZV9nZXRfc2xvcGUodHopOwo+IMKgwqDCoMKgwqDCoMKgwqBpbnQgb2Zmc2V0ID0g
dGhlcm1hbF96b25lX2dldF9vZmZzZXQodHopOwo+IMKgwqDCoMKgwqDCoMKgwqB1MzIgdmFsOwo+
IGRpZmYgLS1naXQgYS9kcml2ZXJzL3RoZXJtYWwvYnJvYWRjb20vYmNtMjgzNV90aGVybWFsLmMg
Yi9kcml2ZXJzL3RoZXJtYWwvYnJvYWRjb20vYmNtMjgzNV90aGVybWFsLmMKPiBpbmRleCAyMzkx
OGJiNzZhZTYuLmRlMmY1NzM4NjNkYSAxMDA2NDQKPiAtLS0gYS9kcml2ZXJzL3RoZXJtYWwvYnJv
YWRjb20vYmNtMjgzNV90aGVybWFsLmMKPiArKysgYi9kcml2ZXJzL3RoZXJtYWwvYnJvYWRjb20v
YmNtMjgzNV90aGVybWFsLmMKPiBAQCAtOTAsNyArOTAsNyBAQCBzdGF0aWMgaW50IGJjbTI4MzVf
dGhlcm1hbF90ZW1wMmFkYyhpbnQgdGVtcCwgaW50IG9mZnNldCwgaW50IHNsb3BlKQo+IMKgCj4g
wqBzdGF0aWMgaW50IGJjbTI4MzVfdGhlcm1hbF9nZXRfdGVtcChzdHJ1Y3QgdGhlcm1hbF96b25l
X2RldmljZSAqdHosIGludCAqdGVtcCkKPiDCoHsKPiAtwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgYmNt
MjgzNV90aGVybWFsX2RhdGEgKmRhdGEgPSB0ei0+ZGV2ZGF0YTsKPiArwqDCoMKgwqDCoMKgwqBz
dHJ1Y3QgYmNtMjgzNV90aGVybWFsX2RhdGEgKmRhdGEgPSB0aGVybWFsX3pvbmVfZGV2aWNlX2dl
dF9kYXRhKHR6KTsKPiDCoMKgwqDCoMKgwqDCoMKgdTMyIHZhbCA9IHJlYWRsKGRhdGEtPnJlZ3Mg
KyBCQ00yODM1X1RTX1RTRU5TU1RBVCk7Cj4gwqAKPiDCoMKgwqDCoMKgwqDCoMKgaWYgKCEodmFs
ICYgQkNNMjgzNV9UU19UU0VOU1NUQVRfVkFMSUQpKQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Ro
ZXJtYWwvYnJvYWRjb20vYnJjbXN0Yl90aGVybWFsLmMgYi9kcml2ZXJzL3RoZXJtYWwvYnJvYWRj
b20vYnJjbXN0Yl90aGVybWFsLmMKPiBpbmRleCA0ZDAyYzI4MzMxZTMuLjY2OGNkYzE2YjEwOCAx
MDA2NDQKPiAtLS0gYS9kcml2ZXJzL3RoZXJtYWwvYnJvYWRjb20vYnJjbXN0Yl90aGVybWFsLmMK
PiArKysgYi9kcml2ZXJzL3RoZXJtYWwvYnJvYWRjb20vYnJjbXN0Yl90aGVybWFsLmMKPiBAQCAt
MTUyLDcgKzE1Miw3IEBAIHN0YXRpYyBpbmxpbmUgdTMyIGF2c190bW9uX3RlbXBfdG9fY29kZShz
dHJ1Y3QgYnJjbXN0Yl90aGVybWFsX3ByaXYgKnByaXYsCj4gwqAKPiDCoHN0YXRpYyBpbnQgYnJj
bXN0Yl9nZXRfdGVtcChzdHJ1Y3QgdGhlcm1hbF96b25lX2RldmljZSAqdHosIGludCAqdGVtcCkK
PiDCoHsKPiAtwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgYnJjbXN0Yl90aGVybWFsX3ByaXYgKnByaXYg
PSB0ei0+ZGV2ZGF0YTsKPiArwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgYnJjbXN0Yl90aGVybWFsX3By
aXYgKnByaXYgPSB0aGVybWFsX3pvbmVfZGV2aWNlX2dldF9kYXRhKHR6KTsKPiDCoMKgwqDCoMKg
wqDCoMKgdTMyIHZhbDsKPiDCoMKgwqDCoMKgwqDCoMKgbG9uZyB0Owo+IMKgCj4gQEAgLTI2Miw3
ICsyNjIsNyBAQCBzdGF0aWMgaXJxcmV0dXJuX3QgYnJjbXN0Yl90bW9uX2lycV90aHJlYWQoaW50
IGlycSwgdm9pZCAqZGF0YSkKPiDCoAo+IMKgc3RhdGljIGludCBicmNtc3RiX3NldF90cmlwcyhz
dHJ1Y3QgdGhlcm1hbF96b25lX2RldmljZSAqdHosIGludCBsb3csIGludCBoaWdoKQo+IMKgewo+
IC3CoMKgwqDCoMKgwqDCoHN0cnVjdCBicmNtc3RiX3RoZXJtYWxfcHJpdiAqcHJpdiA9IHR6LT5k
ZXZkYXRhOwo+ICvCoMKgwqDCoMKgwqDCoHN0cnVjdCBicmNtc3RiX3RoZXJtYWxfcHJpdiAqcHJp
diA9IHRoZXJtYWxfem9uZV9kZXZpY2VfZ2V0X2RhdGEodHopOwo+IMKgCj4gwqDCoMKgwqDCoMKg
wqDCoGRldl9kYmcocHJpdi0+ZGV2LCAic2V0IHRyaXBzICVkIDwtLT4gJWRcbiIsIGxvdywgaGln
aCk7Cj4gwqAKPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy90aGVybWFsL2Jyb2FkY29tL25zLXRoZXJt
YWwuYyBiL2RyaXZlcnMvdGhlcm1hbC9icm9hZGNvbS9ucy10aGVybWFsLmMKPiBpbmRleCAwN2E4
YTNmNDliZDAuLjk4Mjk2MDE5YWQ0YyAxMDA2NDQKPiAtLS0gYS9kcml2ZXJzL3RoZXJtYWwvYnJv
YWRjb20vbnMtdGhlcm1hbC5jCj4gKysrIGIvZHJpdmVycy90aGVybWFsL2Jyb2FkY29tL25zLXRo
ZXJtYWwuYwo+IEBAIC0xNiw3ICsxNiw3IEBACj4gwqAKPiDCoHN0YXRpYyBpbnQgbnNfdGhlcm1h
bF9nZXRfdGVtcChzdHJ1Y3QgdGhlcm1hbF96b25lX2RldmljZSAqdHosIGludCAqdGVtcCkKPiDC
oHsKPiAtwqDCoMKgwqDCoMKgwqB2b2lkIF9faW9tZW0gKnB2dG1vbiA9IHR6LT5kZXZkYXRhOwo+
ICvCoMKgwqDCoMKgwqDCoHZvaWQgX19pb21lbSAqcHZ0bW9uID0gdGhlcm1hbF96b25lX2Rldmlj
ZV9nZXRfZGF0YSh0eik7Cj4gwqDCoMKgwqDCoMKgwqDCoGludCBvZmZzZXQgPSB0aGVybWFsX3pv
bmVfZ2V0X29mZnNldCh0eik7Cj4gwqDCoMKgwqDCoMKgwqDCoGludCBzbG9wZSA9IHRoZXJtYWxf
em9uZV9nZXRfc2xvcGUodHopOwo+IMKgwqDCoMKgwqDCoMKgwqB1MzIgdmFsOwo+IGRpZmYgLS1n
aXQgYS9kcml2ZXJzL3RoZXJtYWwvYnJvYWRjb20vc3ItdGhlcm1hbC5jIGIvZHJpdmVycy90aGVy
bWFsL2Jyb2FkY29tL3NyLXRoZXJtYWwuYwo+IGluZGV4IDJiOTM1MDI1NDNmZi4uNDJiNDYxMjVm
NDA5IDEwMDY0NAo+IC0tLSBhL2RyaXZlcnMvdGhlcm1hbC9icm9hZGNvbS9zci10aGVybWFsLmMK
PiArKysgYi9kcml2ZXJzL3RoZXJtYWwvYnJvYWRjb20vc3ItdGhlcm1hbC5jCj4gQEAgLTMyLDcg
KzMyLDcgQEAgc3RydWN0IHNyX3RoZXJtYWwgewo+IMKgCj4gwqBzdGF0aWMgaW50IHNyX2dldF90
ZW1wKHN0cnVjdCB0aGVybWFsX3pvbmVfZGV2aWNlICp0eiwgaW50ICp0ZW1wKQo+IMKgewo+IC3C
oMKgwqDCoMKgwqDCoHN0cnVjdCBzcl90bW9uICp0bW9uID0gdHotPmRldmRhdGE7Cj4gK8KgwqDC
oMKgwqDCoMKgc3RydWN0IHNyX3Rtb24gKnRtb24gPSB0aGVybWFsX3pvbmVfZGV2aWNlX2dldF9k
YXRhKHR6KTsKPiDCoMKgwqDCoMKgwqDCoMKgc3RydWN0IHNyX3RoZXJtYWwgKnNyX3RoZXJtYWwg
PSB0bW9uLT5wcml2Owo+IMKgCj4gwqDCoMKgwqDCoMKgwqDCoCp0ZW1wID0gcmVhZGwoc3JfdGhl
cm1hbC0+cmVncyArIFNSX1RNT05fVEVNUF9CQVNFKHRtb24tPnRtb25faWQpKTsKPiBkaWZmIC0t
Z2l0IGEvZHJpdmVycy90aGVybWFsL2RhOTA2Mi10aGVybWFsLmMgYi9kcml2ZXJzL3RoZXJtYWwv
ZGE5MDYyLXRoZXJtYWwuYwo+IGluZGV4IGE4MDVhNjY2NmM0NC4uM2Q5MzdmNzAxZTBiIDEwMDY0
NAo+IC0tLSBhL2RyaXZlcnMvdGhlcm1hbC9kYTkwNjItdGhlcm1hbC5jCj4gKysrIGIvZHJpdmVy
cy90aGVybWFsL2RhOTA2Mi10aGVybWFsLmMKPiBAQCAtMTIzLDcgKzEyMyw3IEBAIHN0YXRpYyBp
cnFyZXR1cm5fdCBkYTkwNjJfdGhlcm1hbF9pcnFfaGFuZGxlcihpbnQgaXJxLCB2b2lkICpkYXRh
KQo+IMKgc3RhdGljIGludCBkYTkwNjJfdGhlcm1hbF9nZXRfdGVtcChzdHJ1Y3QgdGhlcm1hbF96
b25lX2RldmljZSAqeiwKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBpbnQgKnRlbXApCj4gwqB7Cj4gLcKgwqDCoMKg
wqDCoMKgc3RydWN0IGRhOTA2Ml90aGVybWFsICp0aGVybWFsID0gei0+ZGV2ZGF0YTsKPiArwqDC
oMKgwqDCoMKgwqBzdHJ1Y3QgZGE5MDYyX3RoZXJtYWwgKnRoZXJtYWwgPSB0aGVybWFsX3pvbmVf
ZGV2aWNlX2dldF9kYXRhKHopOwo+IMKgCj4gwqDCoMKgwqDCoMKgwqDCoG11dGV4X2xvY2soJnRo
ZXJtYWwtPmxvY2spOwo+IMKgwqDCoMKgwqDCoMKgwqAqdGVtcCA9IHRoZXJtYWwtPnRlbXBlcmF0
dXJlOwo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3RoZXJtYWwvZG92ZV90aGVybWFsLmMgYi9kcml2
ZXJzL3RoZXJtYWwvZG92ZV90aGVybWFsLmMKPiBpbmRleCAwNTY2MjJhNThkMDAuLmVkN2QxMTcz
ZDlmZCAxMDA2NDQKPiAtLS0gYS9kcml2ZXJzL3RoZXJtYWwvZG92ZV90aGVybWFsLmMKPiArKysg
Yi9kcml2ZXJzL3RoZXJtYWwvZG92ZV90aGVybWFsLmMKPiBAQCAtODcsNyArODcsNyBAQCBzdGF0
aWMgaW50IGRvdmVfZ2V0X3RlbXAoc3RydWN0IHRoZXJtYWxfem9uZV9kZXZpY2UgKnRoZXJtYWws
Cj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaW50
ICp0ZW1wKQo+IMKgewo+IMKgwqDCoMKgwqDCoMKgwqB1bnNpZ25lZCBsb25nIHJlZzsKPiAtwqDC
oMKgwqDCoMKgwqBzdHJ1Y3QgZG92ZV90aGVybWFsX3ByaXYgKnByaXYgPSB0aGVybWFsLT5kZXZk
YXRhOwo+ICvCoMKgwqDCoMKgwqDCoHN0cnVjdCBkb3ZlX3RoZXJtYWxfcHJpdiAqcHJpdiA9IHRo
ZXJtYWxfem9uZV9kZXZpY2VfZ2V0X2RhdGEodGhlcm1hbCk7Cj4gwqAKPiDCoMKgwqDCoMKgwqDC
oMKgLyogVmFsaWQgY2hlY2sgKi8KPiDCoMKgwqDCoMKgwqDCoMKgcmVnID0gcmVhZGxfcmVsYXhl
ZChwcml2LT5jb250cm9sICsgUE1VX1RFTVBfRElPRF9DVFJMMV9SRUcpOwo+IGRpZmYgLS1naXQg
YS9kcml2ZXJzL3RoZXJtYWwvaGlzaV90aGVybWFsLmMgYi9kcml2ZXJzL3RoZXJtYWwvaGlzaV90
aGVybWFsLmMKPiBpbmRleCAzMmE3YzNjZjA3M2QuLjA0Mzc1MWU2YTMxZCAxMDA2NDQKPiAtLS0g
YS9kcml2ZXJzL3RoZXJtYWwvaGlzaV90aGVybWFsLmMKPiArKysgYi9kcml2ZXJzL3RoZXJtYWwv
aGlzaV90aGVybWFsLmMKPiBAQCAtNDMxLDcgKzQzMSw3IEBAIHN0YXRpYyBpbnQgaGkzNjYwX3Ro
ZXJtYWxfcHJvYmUoc3RydWN0IGhpc2lfdGhlcm1hbF9kYXRhICpkYXRhKQo+IMKgCj4gwqBzdGF0
aWMgaW50IGhpc2lfdGhlcm1hbF9nZXRfdGVtcChzdHJ1Y3QgdGhlcm1hbF96b25lX2RldmljZSAq
dHosIGludCAqdGVtcCkKPiDCoHsKPiAtwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgaGlzaV90aGVybWFs
X3NlbnNvciAqc2Vuc29yID0gdHotPmRldmRhdGE7Cj4gK8KgwqDCoMKgwqDCoMKgc3RydWN0IGhp
c2lfdGhlcm1hbF9zZW5zb3IgKnNlbnNvciA9IHRoZXJtYWxfem9uZV9kZXZpY2VfZ2V0X2RhdGEo
dHopOwo+IMKgwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgaGlzaV90aGVybWFsX2RhdGEgKmRhdGEgPSBz
ZW5zb3ItPmRhdGE7Cj4gwqAKPiDCoMKgwqDCoMKgwqDCoMKgKnRlbXAgPSBkYXRhLT5vcHMtPmdl
dF90ZW1wKHNlbnNvcik7Cj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdGhlcm1hbC9pbXg4bW1fdGhl
cm1hbC5jIGIvZHJpdmVycy90aGVybWFsL2lteDhtbV90aGVybWFsLmMKPiBpbmRleCA3MmI1ZDZm
MzE5YzEuLjc1MDI0MGY0ZmEzMiAxMDA2NDQKPiAtLS0gYS9kcml2ZXJzL3RoZXJtYWwvaW14OG1t
X3RoZXJtYWwuYwo+ICsrKyBiL2RyaXZlcnMvdGhlcm1hbC9pbXg4bW1fdGhlcm1hbC5jCj4gQEAg
LTE0MSw3ICsxNDEsNyBAQCBzdGF0aWMgaW50IGlteDhtcF90bXVfZ2V0X3RlbXAodm9pZCAqZGF0
YSwgaW50ICp0ZW1wKQo+IMKgCj4gwqBzdGF0aWMgaW50IHRtdV9nZXRfdGVtcChzdHJ1Y3QgdGhl
cm1hbF96b25lX2RldmljZSAqdHosIGludCAqdGVtcCkKPiDCoHsKPiAtwqDCoMKgwqDCoMKgwqBz
dHJ1Y3QgdG11X3NlbnNvciAqc2Vuc29yID0gdHotPmRldmRhdGE7Cj4gK8KgwqDCoMKgwqDCoMKg
c3RydWN0IHRtdV9zZW5zb3IgKnNlbnNvciA9IHRoZXJtYWxfem9uZV9kZXZpY2VfZ2V0X2RhdGEo
dHopOwo+IMKgwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgaW14OG1tX3RtdSAqdG11ID0gc2Vuc29yLT5w
cml2Owo+IMKgCj4gwqDCoMKgwqDCoMKgwqDCoHJldHVybiB0bXUtPnNvY2RhdGEtPmdldF90ZW1w
KHNlbnNvciwgdGVtcCk7Cj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdGhlcm1hbC9pbXhfc2NfdGhl
cm1hbC5jIGIvZHJpdmVycy90aGVybWFsL2lteF9zY190aGVybWFsLmMKPiBpbmRleCBmMzJlNTll
NzQ2MjMuLmNhMTBkNmE2OGYwZiAxMDA2NDQKPiAtLS0gYS9kcml2ZXJzL3RoZXJtYWwvaW14X3Nj
X3RoZXJtYWwuYwo+ICsrKyBiL2RyaXZlcnMvdGhlcm1hbC9pbXhfc2NfdGhlcm1hbC5jCj4gQEAg
LTQ2LDcgKzQ2LDcgQEAgc3RhdGljIGludCBpbXhfc2NfdGhlcm1hbF9nZXRfdGVtcChzdHJ1Y3Qg
dGhlcm1hbF96b25lX2RldmljZSAqdHosIGludCAqdGVtcCkKPiDCoHsKPiDCoMKgwqDCoMKgwqDC
oMKgc3RydWN0IGlteF9zY19tc2dfbWlzY19nZXRfdGVtcCBtc2c7Cj4gwqDCoMKgwqDCoMKgwqDC
oHN0cnVjdCBpbXhfc2NfcnBjX21zZyAqaGRyID0gJm1zZy5oZHI7Cj4gLcKgwqDCoMKgwqDCoMKg
c3RydWN0IGlteF9zY19zZW5zb3IgKnNlbnNvciA9IHR6LT5kZXZkYXRhOwo+ICvCoMKgwqDCoMKg
wqDCoHN0cnVjdCBpbXhfc2Nfc2Vuc29yICpzZW5zb3IgPSB0aGVybWFsX3pvbmVfZGV2aWNlX2dl
dF9kYXRhKHR6KTsKPiDCoMKgwqDCoMKgwqDCoMKgaW50IHJldDsKPiDCoAo+IMKgwqDCoMKgwqDC
oMKgwqBtc2cuZGF0YS5yZXEucmVzb3VyY2VfaWQgPSBzZW5zb3ItPnJlc291cmNlX2lkOwo+IGRp
ZmYgLS1naXQgYS9kcml2ZXJzL3RoZXJtYWwvaW14X3RoZXJtYWwuYyBiL2RyaXZlcnMvdGhlcm1h
bC9pbXhfdGhlcm1hbC5jCj4gaW5kZXggZmIwZDVjYWI3MGFmLi5jM2MxNGNkMjZhZWUgMTAwNjQ0
Cj4gLS0tIGEvZHJpdmVycy90aGVybWFsL2lteF90aGVybWFsLmMKPiArKysgYi9kcml2ZXJzL3Ro
ZXJtYWwvaW14X3RoZXJtYWwuYwo+IEBAIC0yNTIsNyArMjUyLDcgQEAgc3RhdGljIHZvaWQgaW14
X3NldF9hbGFybV90ZW1wKHN0cnVjdCBpbXhfdGhlcm1hbF9kYXRhICpkYXRhLAo+IMKgCj4gwqBz
dGF0aWMgaW50IGlteF9nZXRfdGVtcChzdHJ1Y3QgdGhlcm1hbF96b25lX2RldmljZSAqdHosIGlu
dCAqdGVtcCkKPiDCoHsKPiAtwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgaW14X3RoZXJtYWxfZGF0YSAq
ZGF0YSA9IHR6LT5kZXZkYXRhOwo+ICvCoMKgwqDCoMKgwqDCoHN0cnVjdCBpbXhfdGhlcm1hbF9k
YXRhICpkYXRhID0gdGhlcm1hbF96b25lX2RldmljZV9nZXRfZGF0YSh0eik7Cj4gwqDCoMKgwqDC
oMKgwqDCoGNvbnN0IHN0cnVjdCB0aGVybWFsX3NvY19kYXRhICpzb2NfZGF0YSA9IGRhdGEtPnNv
Y2RhdGE7Cj4gwqDCoMKgwqDCoMKgwqDCoHN0cnVjdCByZWdtYXAgKm1hcCA9IGRhdGEtPnRlbXBt
b247Cj4gwqDCoMKgwqDCoMKgwqDCoHVuc2lnbmVkIGludCBuX21lYXM7Cj4gQEAgLTMxMSw3ICsz
MTEsNyBAQCBzdGF0aWMgaW50IGlteF9nZXRfdGVtcChzdHJ1Y3QgdGhlcm1hbF96b25lX2Rldmlj
ZSAqdHosIGludCAqdGVtcCkKPiDCoHN0YXRpYyBpbnQgaW14X2NoYW5nZV9tb2RlKHN0cnVjdCB0
aGVybWFsX3pvbmVfZGV2aWNlICp0eiwKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIGVudW0gdGhlcm1hbF9kZXZpY2VfbW9kZSBtb2RlKQo+IMKg
ewo+IC3CoMKgwqDCoMKgwqDCoHN0cnVjdCBpbXhfdGhlcm1hbF9kYXRhICpkYXRhID0gdHotPmRl
dmRhdGE7Cj4gK8KgwqDCoMKgwqDCoMKgc3RydWN0IGlteF90aGVybWFsX2RhdGEgKmRhdGEgPSB0
aGVybWFsX3pvbmVfZGV2aWNlX2dldF9kYXRhKHR6KTsKPiDCoAo+IMKgwqDCoMKgwqDCoMKgwqBp
ZiAobW9kZSA9PSBUSEVSTUFMX0RFVklDRV9FTkFCTEVEKSB7Cj4gwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqBwbV9ydW50aW1lX2dldChkYXRhLT5kZXYpOwo+IEBAIC0zNDIsNyArMzQy
LDcgQEAgc3RhdGljIGludCBpbXhfZ2V0X2NyaXRfdGVtcChzdHJ1Y3QgdGhlcm1hbF96b25lX2Rl
dmljZSAqdHosIGludCAqdGVtcCkKPiDCoHN0YXRpYyBpbnQgaW14X3NldF90cmlwX3RlbXAoc3Ry
dWN0IHRoZXJtYWxfem9uZV9kZXZpY2UgKnR6LCBpbnQgdHJpcCwKPiDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBpbnQgdGVtcCkKPiDCoHsK
PiAtwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgaW14X3RoZXJtYWxfZGF0YSAqZGF0YSA9IHR6LT5kZXZk
YXRhOwo+ICvCoMKgwqDCoMKgwqDCoHN0cnVjdCBpbXhfdGhlcm1hbF9kYXRhICpkYXRhID0gdGhl
cm1hbF96b25lX2RldmljZV9nZXRfZGF0YSh0eik7Cj4gwqDCoMKgwqDCoMKgwqDCoGludCByZXQ7
Cj4gwqAKPiDCoMKgwqDCoMKgwqDCoMKgcmV0ID0gcG1fcnVudGltZV9yZXN1bWVfYW5kX2dldChk
YXRhLT5kZXYpOwo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3RoZXJtYWwvaW50ZWwvaW50ZWxfcGNo
X3RoZXJtYWwuYyBiL2RyaXZlcnMvdGhlcm1hbC9pbnRlbC9pbnRlbF9wY2hfdGhlcm1hbC5jCj4g
aW5kZXggYjg1NWQwMzFhODU1Li5lNTNmOGE4YzA2ZTUgMTAwNjQ0Cj4gLS0tIGEvZHJpdmVycy90
aGVybWFsL2ludGVsL2ludGVsX3BjaF90aGVybWFsLmMKPiArKysgYi9kcml2ZXJzL3RoZXJtYWwv
aW50ZWwvaW50ZWxfcGNoX3RoZXJtYWwuYwo+IEBAIC0xMTksNyArMTE5LDcgQEAgc3RhdGljIGlu
dCBwY2hfd3B0X2FkZF9hY3BpX3Bzdl90cmlwKHN0cnVjdCBwY2hfdGhlcm1hbF9kZXZpY2UgKnB0
ZCwgaW50IHRyaXApCj4gwqAKPiDCoHN0YXRpYyBpbnQgcGNoX3RoZXJtYWxfZ2V0X3RlbXAoc3Ry
dWN0IHRoZXJtYWxfem9uZV9kZXZpY2UgKnR6ZCwgaW50ICp0ZW1wKQo+IMKgewo+IC3CoMKgwqDC
oMKgwqDCoHN0cnVjdCBwY2hfdGhlcm1hbF9kZXZpY2UgKnB0ZCA9IHR6ZC0+ZGV2ZGF0YTsKPiAr
wqDCoMKgwqDCoMKgwqBzdHJ1Y3QgcGNoX3RoZXJtYWxfZGV2aWNlICpwdGQgPSB0aGVybWFsX3pv
bmVfZGV2aWNlX2dldF9kYXRhKHR6ZCk7Cj4gwqAKPiDCoMKgwqDCoMKgwqDCoMKgKnRlbXAgPSBH
RVRfV1BUX1RFTVAoV1BUX1RFTVBfVFNSICYgcmVhZHcocHRkLT5od19iYXNlICsgV1BUX1RFTVAp
KTsKPiDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIDA7Cj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdGhl
cm1hbC9pbnRlbC9pbnRlbF9zb2NfZHRzX2lvc2YuYyBiL2RyaXZlcnMvdGhlcm1hbC9pbnRlbC9p
bnRlbF9zb2NfZHRzX2lvc2YuYwo+IGluZGV4IDhjMjZmN2IyMzE2Yi4uZjdkOTk1NzIyZTA0IDEw
MDY0NAo+IC0tLSBhL2RyaXZlcnMvdGhlcm1hbC9pbnRlbC9pbnRlbF9zb2NfZHRzX2lvc2YuYwo+
ICsrKyBiL2RyaXZlcnMvdGhlcm1hbC9pbnRlbC9pbnRlbF9zb2NfZHRzX2lvc2YuYwo+IEBAIC01
NCw3ICs1NCw3IEBAIHN0YXRpYyBpbnQgc3lzX2dldF90cmlwX3RlbXAoc3RydWN0IHRoZXJtYWxf
em9uZV9kZXZpY2UgKnR6ZCwgaW50IHRyaXAsCj4gwqDCoMKgwqDCoMKgwqDCoHN0cnVjdCBpbnRl
bF9zb2NfZHRzX3NlbnNvcl9lbnRyeSAqZHRzOwo+IMKgwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgaW50
ZWxfc29jX2R0c19zZW5zb3JzICpzZW5zb3JzOwo+IMKgCj4gLcKgwqDCoMKgwqDCoMKgZHRzID0g
dHpkLT5kZXZkYXRhOwo+ICvCoMKgwqDCoMKgwqDCoGR0cyA9IHRoZXJtYWxfem9uZV9kZXZpY2Vf
Z2V0X2RhdGEodHpkKTsKPiDCoMKgwqDCoMKgwqDCoMKgc2Vuc29ycyA9IGR0cy0+c2Vuc29yczsK
PiDCoMKgwqDCoMKgwqDCoMKgbXV0ZXhfbG9jaygmc2Vuc29ycy0+ZHRzX3VwZGF0ZV9sb2NrKTsK
PiDCoMKgwqDCoMKgwqDCoMKgc3RhdHVzID0gaW9zZl9tYmlfcmVhZChCVF9NQklfVU5JVF9QTUMs
IE1CSV9SRUdfUkVBRCwKPiBAQCAtMTY4LDcgKzE2OCw3IEBAIHN0YXRpYyBpbnQgdXBkYXRlX3Ry
aXBfdGVtcChzdHJ1Y3QgaW50ZWxfc29jX2R0c19zZW5zb3JfZW50cnkgKmR0cywKPiDCoHN0YXRp
YyBpbnQgc3lzX3NldF90cmlwX3RlbXAoc3RydWN0IHRoZXJtYWxfem9uZV9kZXZpY2UgKnR6ZCwg
aW50IHRyaXAsCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAgaW50IHRlbXApCj4gwqB7Cj4gLcKgwqDCoMKgwqDCoMKgc3RydWN0IGludGVs
X3NvY19kdHNfc2Vuc29yX2VudHJ5ICpkdHMgPSB0emQtPmRldmRhdGE7Cj4gK8KgwqDCoMKgwqDC
oMKgc3RydWN0IGludGVsX3NvY19kdHNfc2Vuc29yX2VudHJ5ICpkdHMgPSB0aGVybWFsX3pvbmVf
ZGV2aWNlX2dldF9kYXRhKHR6ZCk7Cj4gwqDCoMKgwqDCoMKgwqDCoHN0cnVjdCBpbnRlbF9zb2Nf
ZHRzX3NlbnNvcnMgKnNlbnNvcnMgPSBkdHMtPnNlbnNvcnM7Cj4gwqDCoMKgwqDCoMKgwqDCoGlu
dCBzdGF0dXM7Cj4gwqAKPiBAQCAtMTc2LDcgKzE3Niw3IEBAIHN0YXRpYyBpbnQgc3lzX3NldF90
cmlwX3RlbXAoc3RydWN0IHRoZXJtYWxfem9uZV9kZXZpY2UgKnR6ZCwgaW50IHRyaXAsCj4gwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXR1cm4gLUVJTlZBTDsKPiDCoAo+IMKgwqDC
oMKgwqDCoMKgwqBtdXRleF9sb2NrKCZzZW5zb3JzLT5kdHNfdXBkYXRlX2xvY2spOwo+IC3CoMKg
wqDCoMKgwqDCoHN0YXR1cyA9IHVwZGF0ZV90cmlwX3RlbXAodHpkLT5kZXZkYXRhLCB0cmlwLCB0
ZW1wLAo+ICvCoMKgwqDCoMKgwqDCoHN0YXR1cyA9IHVwZGF0ZV90cmlwX3RlbXAoZHRzLCB0cmlw
LCB0ZW1wLAo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCBkdHMtPnRyaXBfdHlwZXNbdHJpcF0pOwo+IMKgwqDCoMKgwqDC
oMKgwqBtdXRleF91bmxvY2soJnNlbnNvcnMtPmR0c191cGRhdGVfbG9jayk7Cj4gwqAKPiBAQCAt
MTg2LDkgKzE4Niw3IEBAIHN0YXRpYyBpbnQgc3lzX3NldF90cmlwX3RlbXAoc3RydWN0IHRoZXJt
YWxfem9uZV9kZXZpY2UgKnR6ZCwgaW50IHRyaXAsCj4gwqBzdGF0aWMgaW50IHN5c19nZXRfdHJp
cF90eXBlKHN0cnVjdCB0aGVybWFsX3pvbmVfZGV2aWNlICp0emQsCj4gwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaW50IHRyaXAsIGVudW0g
dGhlcm1hbF90cmlwX3R5cGUgKnR5cGUpCj4gwqB7Cj4gLcKgwqDCoMKgwqDCoMKgc3RydWN0IGlu
dGVsX3NvY19kdHNfc2Vuc29yX2VudHJ5ICpkdHM7Cj4gLQo+IC3CoMKgwqDCoMKgwqDCoGR0cyA9
IHR6ZC0+ZGV2ZGF0YTsKPiArwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgaW50ZWxfc29jX2R0c19zZW5z
b3JfZW50cnkgKmR0cyA9IHRoZXJtYWxfem9uZV9kZXZpY2VfZ2V0X2RhdGEodHpkKTsKPiDCoAo+
IMKgwqDCoMKgwqDCoMKgwqAqdHlwZSA9IGR0cy0+dHJpcF90eXBlc1t0cmlwXTsKPiDCoAo+IEBA
IC0yMDAsMTEgKzE5OCwxMCBAQCBzdGF0aWMgaW50IHN5c19nZXRfY3Vycl90ZW1wKHN0cnVjdCB0
aGVybWFsX3pvbmVfZGV2aWNlICp0emQsCj4gwqB7Cj4gwqDCoMKgwqDCoMKgwqDCoGludCBzdGF0
dXM7Cj4gwqDCoMKgwqDCoMKgwqDCoHUzMiBvdXQ7Cj4gLcKgwqDCoMKgwqDCoMKgc3RydWN0IGlu
dGVsX3NvY19kdHNfc2Vuc29yX2VudHJ5ICpkdHM7Cj4gK8KgwqDCoMKgwqDCoMKgc3RydWN0IGlu
dGVsX3NvY19kdHNfc2Vuc29yX2VudHJ5ICpkdHMgPSB0aGVybWFsX3pvbmVfZGV2aWNlX2dldF9k
YXRhKHR6ZCk7Cj4gwqDCoMKgwqDCoMKgwqDCoHN0cnVjdCBpbnRlbF9zb2NfZHRzX3NlbnNvcnMg
KnNlbnNvcnM7Cj4gwqDCoMKgwqDCoMKgwqDCoHVuc2lnbmVkIGxvbmcgcmF3Owo+IMKgCj4gLcKg
wqDCoMKgwqDCoMKgZHRzID0gdHpkLT5kZXZkYXRhOwo+IMKgwqDCoMKgwqDCoMKgwqBzZW5zb3Jz
ID0gZHRzLT5zZW5zb3JzOwo+IMKgwqDCoMKgwqDCoMKgwqBzdGF0dXMgPSBpb3NmX21iaV9yZWFk
KEJUX01CSV9VTklUX1BNQywgTUJJX1JFR19SRUFELAo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBTT0NfRFRTX09GRlNFVF9URU1Q
LCAmb3V0KTsKPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy90aGVybWFsL2ludGVsL3g4Nl9wa2dfdGVt
cF90aGVybWFsLmMgYi9kcml2ZXJzL3RoZXJtYWwvaW50ZWwveDg2X3BrZ190ZW1wX3RoZXJtYWwu
Ywo+IGluZGV4IDFjMmRlODQ3NDJkZi4uMjJmMGYyMDZkOGYyIDEwMDY0NAo+IC0tLSBhL2RyaXZl
cnMvdGhlcm1hbC9pbnRlbC94ODZfcGtnX3RlbXBfdGhlcm1hbC5jCj4gKysrIGIvZHJpdmVycy90
aGVybWFsL2ludGVsL3g4Nl9wa2dfdGVtcF90aGVybWFsLmMKPiBAQCAtMTA3LDcgKzEwNyw3IEBA
IHN0YXRpYyBzdHJ1Y3Qgem9uZV9kZXZpY2UgKnBrZ190ZW1wX3RoZXJtYWxfZ2V0X2Rldih1bnNp
Z25lZCBpbnQgY3B1KQo+IMKgCj4gwqBzdGF0aWMgaW50IHN5c19nZXRfY3Vycl90ZW1wKHN0cnVj
dCB0aGVybWFsX3pvbmVfZGV2aWNlICp0emQsIGludCAqdGVtcCkKPiDCoHsKPiAtwqDCoMKgwqDC
oMKgwqBzdHJ1Y3Qgem9uZV9kZXZpY2UgKnpvbmVkZXYgPSB0emQtPmRldmRhdGE7Cj4gK8KgwqDC
oMKgwqDCoMKgc3RydWN0IHpvbmVfZGV2aWNlICp6b25lZGV2ID0gdGhlcm1hbF96b25lX2Rldmlj
ZV9nZXRfZGF0YSh0emQpOwo+IMKgwqDCoMKgwqDCoMKgwqBpbnQgdmFsOwo+IMKgCj4gwqDCoMKg
wqDCoMKgwqDCoHZhbCA9IGludGVsX3RjY19nZXRfdGVtcCh6b25lZGV2LT5jcHUsIHRydWUpOwo+
IEBAIC0xMjIsNyArMTIyLDcgQEAgc3RhdGljIGludCBzeXNfZ2V0X2N1cnJfdGVtcChzdHJ1Y3Qg
dGhlcm1hbF96b25lX2RldmljZSAqdHpkLCBpbnQgKnRlbXApCj4gwqBzdGF0aWMgaW50Cj4gwqBz
eXNfc2V0X3RyaXBfdGVtcChzdHJ1Y3QgdGhlcm1hbF96b25lX2RldmljZSAqdHpkLCBpbnQgdHJp
cCwgaW50IHRlbXApCj4gwqB7Cj4gLcKgwqDCoMKgwqDCoMKgc3RydWN0IHpvbmVfZGV2aWNlICp6
b25lZGV2ID0gdHpkLT5kZXZkYXRhOwo+ICvCoMKgwqDCoMKgwqDCoHN0cnVjdCB6b25lX2Rldmlj
ZSAqem9uZWRldiA9IHRoZXJtYWxfem9uZV9kZXZpY2VfZ2V0X2RhdGEodHpkKTsKPiDCoMKgwqDC
oMKgwqDCoMKgdTMyIGwsIGgsIG1hc2ssIHNoaWZ0LCBpbnRyOwo+IMKgwqDCoMKgwqDCoMKgwqBp
bnQgdGpfbWF4LCByZXQ7Cj4gwqAKPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy90aGVybWFsL2szX2Jh
bmRnYXAuYyBiL2RyaXZlcnMvdGhlcm1hbC9rM19iYW5kZ2FwLmMKPiBpbmRleCAyMmM5YmNiODk5
YzMuLjhjYmQ3MzYxYjQ5MiAxMDA2NDQKPiAtLS0gYS9kcml2ZXJzL3RoZXJtYWwvazNfYmFuZGdh
cC5jCj4gKysrIGIvZHJpdmVycy90aGVybWFsL2szX2JhbmRnYXAuYwo+IEBAIC0xNDEsNyArMTQx
LDcgQEAgc3RhdGljIGludCBrM19iZ3BfcmVhZF90ZW1wKHN0cnVjdCBrM190aGVybWFsX2RhdGEg
KmRldmRhdGEsCj4gwqAKPiDCoHN0YXRpYyBpbnQgazNfdGhlcm1hbF9nZXRfdGVtcChzdHJ1Y3Qg
dGhlcm1hbF96b25lX2RldmljZSAqdHosIGludCAqdGVtcCkKPiDCoHsKPiAtwqDCoMKgwqDCoMKg
wqBzdHJ1Y3QgazNfdGhlcm1hbF9kYXRhICpkYXRhID0gdHotPmRldmRhdGE7Cj4gK8KgwqDCoMKg
wqDCoMKgc3RydWN0IGszX3RoZXJtYWxfZGF0YSAqZGF0YSA9IHRoZXJtYWxfem9uZV9kZXZpY2Vf
Z2V0X2RhdGEodHopOwo+IMKgwqDCoMKgwqDCoMKgwqBpbnQgcmV0ID0gMDsKPiDCoAo+IMKgwqDC
oMKgwqDCoMKgwqByZXQgPSBrM19iZ3BfcmVhZF90ZW1wKGRhdGEsIHRlbXApOwo+IGRpZmYgLS1n
aXQgYS9kcml2ZXJzL3RoZXJtYWwvazNfajcyeHhfYmFuZGdhcC5jIGIvZHJpdmVycy90aGVybWFs
L2szX2o3Mnh4X2JhbmRnYXAuYwo+IGluZGV4IDAzMWVhMTA5MTkwOS4uMzAwYTNmOTg1Nzc2IDEw
MDY0NAo+IC0tLSBhL2RyaXZlcnMvdGhlcm1hbC9rM19qNzJ4eF9iYW5kZ2FwLmMKPiArKysgYi9k
cml2ZXJzL3RoZXJtYWwvazNfajcyeHhfYmFuZGdhcC5jCj4gQEAgLTI0OCw3ICsyNDgsNyBAQCBz
dGF0aWMgaW5saW5lIGludCBrM19iZ3BfcmVhZF90ZW1wKHN0cnVjdCBrM190aGVybWFsX2RhdGEg
KmRldmRhdGEsCj4gwqAvKiBHZXQgdGVtcGVyYXR1cmUgY2FsbGJhY2sgZnVuY3Rpb24gZm9yIHRo
ZXJtYWwgem9uZSAqLwo+IMKgc3RhdGljIGludCBrM190aGVybWFsX2dldF90ZW1wKHN0cnVjdCB0
aGVybWFsX3pvbmVfZGV2aWNlICp0eiwgaW50ICp0ZW1wKQo+IMKgewo+IC3CoMKgwqDCoMKgwqDC
oHJldHVybiBrM19iZ3BfcmVhZF90ZW1wKHR6LT5kZXZkYXRhLCB0ZW1wKTsKPiArwqDCoMKgwqDC
oMKgwqByZXR1cm4gazNfYmdwX3JlYWRfdGVtcCh0aGVybWFsX3pvbmVfZGV2aWNlX2dldF9kYXRh
KHR6KSwgdGVtcCk7Cj4gwqB9Cj4gwqAKPiDCoHN0YXRpYyBjb25zdCBzdHJ1Y3QgdGhlcm1hbF96
b25lX2RldmljZV9vcHMgazNfb2ZfdGhlcm1hbF9vcHMgPSB7Cj4gZGlmZiAtLWdpdCBhL2RyaXZl
cnMvdGhlcm1hbC9raXJrd29vZF90aGVybWFsLmMgYi9kcml2ZXJzL3RoZXJtYWwva2lya3dvb2Rf
dGhlcm1hbC5jCj4gaW5kZXggYmVjN2VjMjBlNzlkLi44ZTM5Yzg3NWJhNTggMTAwNjQ0Cj4gLS0t
IGEvZHJpdmVycy90aGVybWFsL2tpcmt3b29kX3RoZXJtYWwuYwo+ICsrKyBiL2RyaXZlcnMvdGhl
cm1hbC9raXJrd29vZF90aGVybWFsLmMKPiBAQCAtMjcsNyArMjcsNyBAQCBzdGF0aWMgaW50IGtp
cmt3b29kX2dldF90ZW1wKHN0cnVjdCB0aGVybWFsX3pvbmVfZGV2aWNlICp0aGVybWFsLAo+IMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGludCAqdGVt
cCkKPiDCoHsKPiDCoMKgwqDCoMKgwqDCoMKgdW5zaWduZWQgbG9uZyByZWc7Cj4gLcKgwqDCoMKg
wqDCoMKgc3RydWN0IGtpcmt3b29kX3RoZXJtYWxfcHJpdiAqcHJpdiA9IHRoZXJtYWwtPmRldmRh
dGE7Cj4gK8KgwqDCoMKgwqDCoMKgc3RydWN0IGtpcmt3b29kX3RoZXJtYWxfcHJpdiAqcHJpdiA9
IHRoZXJtYWxfem9uZV9kZXZpY2VfZ2V0X2RhdGEodGhlcm1hbCk7Cj4gwqAKPiDCoMKgwqDCoMKg
wqDCoMKgcmVnID0gcmVhZGxfcmVsYXhlZChwcml2LT5zZW5zb3IpOwo+IMKgCj4gZGlmZiAtLWdp
dCBhL2RyaXZlcnMvdGhlcm1hbC9tYXg3NzYyMF90aGVybWFsLmMgYi9kcml2ZXJzL3RoZXJtYWwv
bWF4Nzc2MjBfdGhlcm1hbC5jCj4gaW5kZXggNjQ1MWE1NWViNTgyLi4wNWI2ZTlhMmEyODMgMTAw
NjQ0Cj4gLS0tIGEvZHJpdmVycy90aGVybWFsL21heDc3NjIwX3RoZXJtYWwuYwo+ICsrKyBiL2Ry
aXZlcnMvdGhlcm1hbC9tYXg3NzYyMF90aGVybWFsLmMKPiBAQCAtNDYsNyArNDYsNyBAQCBzdHJ1
Y3QgbWF4Nzc2MjBfdGhlcm1faW5mbyB7Cj4gwqAKPiDCoHN0YXRpYyBpbnQgbWF4Nzc2MjBfdGhl
cm1hbF9yZWFkX3RlbXAoc3RydWN0IHRoZXJtYWxfem9uZV9kZXZpY2UgKnR6LCBpbnQgKnRlbXAp
Cj4gwqB7Cj4gLcKgwqDCoMKgwqDCoMKgc3RydWN0IG1heDc3NjIwX3RoZXJtX2luZm8gKm10aGVy
bSA9IHR6LT5kZXZkYXRhOwo+ICvCoMKgwqDCoMKgwqDCoHN0cnVjdCBtYXg3NzYyMF90aGVybV9p
bmZvICptdGhlcm0gPSB0aGVybWFsX3pvbmVfZGV2aWNlX2dldF9kYXRhKHR6KTsKPiDCoMKgwqDC
oMKgwqDCoMKgdW5zaWduZWQgaW50IHZhbDsKPiDCoMKgwqDCoMKgwqDCoMKgaW50IHJldDsKPiDC
oAo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3RoZXJtYWwvbWVkaWF0ZWsvYXV4YWRjX3RoZXJtYWwu
YyBiL2RyaXZlcnMvdGhlcm1hbC9tZWRpYXRlay9hdXhhZGNfdGhlcm1hbC5jCj4gaW5kZXggYWI3
MzBmOTU1MmQwLi5kN2JmNzI1ZDIyNGIgMTAwNjQ0Cj4gLS0tIGEvZHJpdmVycy90aGVybWFsL21l
ZGlhdGVrL2F1eGFkY190aGVybWFsLmMKPiArKysgYi9kcml2ZXJzL3RoZXJtYWwvbWVkaWF0ZWsv
YXV4YWRjX3RoZXJtYWwuYwo+IEBAIC03NjMsNyArNzYzLDcgQEAgc3RhdGljIGludCBtdGtfdGhl
cm1hbF9iYW5rX3RlbXBlcmF0dXJlKHN0cnVjdCBtdGtfdGhlcm1hbF9iYW5rICpiYW5rKQo+IMKg
Cj4gwqBzdGF0aWMgaW50IG10a19yZWFkX3RlbXAoc3RydWN0IHRoZXJtYWxfem9uZV9kZXZpY2Ug
KnR6LCBpbnQgKnRlbXBlcmF0dXJlKQo+IMKgewo+IC3CoMKgwqDCoMKgwqDCoHN0cnVjdCBtdGtf
dGhlcm1hbCAqbXQgPSB0ei0+ZGV2ZGF0YTsKPiArwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgbXRrX3Ro
ZXJtYWwgKm10ID0gdGhlcm1hbF96b25lX2RldmljZV9nZXRfZGF0YSh0eik7Cj4gwqDCoMKgwqDC
oMKgwqDCoGludCBpOwo+IMKgwqDCoMKgwqDCoMKgwqBpbnQgdGVtcG1heCA9IElOVF9NSU47Cj4g
wqAKPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy90aGVybWFsL21lZGlhdGVrL2x2dHNfdGhlcm1hbC5j
IGIvZHJpdmVycy90aGVybWFsL21lZGlhdGVrL2x2dHNfdGhlcm1hbC5jCj4gaW5kZXggODRiYTY1
YTI3YWNmLi44NmQyODAxODdjODMgMTAwNjQ0Cj4gLS0tIGEvZHJpdmVycy90aGVybWFsL21lZGlh
dGVrL2x2dHNfdGhlcm1hbC5jCj4gKysrIGIvZHJpdmVycy90aGVybWFsL21lZGlhdGVrL2x2dHNf
dGhlcm1hbC5jCj4gQEAgLTI1Miw3ICsyNTIsNyBAQCBzdGF0aWMgdTMyIGx2dHNfdGVtcF90b19y
YXcoaW50IHRlbXBlcmF0dXJlKQo+IMKgCj4gwqBzdGF0aWMgaW50IGx2dHNfZ2V0X3RlbXAoc3Ry
dWN0IHRoZXJtYWxfem9uZV9kZXZpY2UgKnR6LCBpbnQgKnRlbXApCj4gwqB7Cj4gLcKgwqDCoMKg
wqDCoMKgc3RydWN0IGx2dHNfc2Vuc29yICpsdnRzX3NlbnNvciA9IHR6LT5kZXZkYXRhOwo+ICvC
oMKgwqDCoMKgwqDCoHN0cnVjdCBsdnRzX3NlbnNvciAqbHZ0c19zZW5zb3IgPSB0aGVybWFsX3pv
bmVfZGV2aWNlX2dldF9kYXRhKHR6KTsKPiDCoMKgwqDCoMKgwqDCoMKgdm9pZCBfX2lvbWVtICpt
c3IgPSBsdnRzX3NlbnNvci0+bXNyOwo+IMKgwqDCoMKgwqDCoMKgwqB1MzIgdmFsdWU7Cj4gwqAK
PiBAQCAtMjkwLDcgKzI5MCw3IEBAIHN0YXRpYyBpbnQgbHZ0c19nZXRfdGVtcChzdHJ1Y3QgdGhl
cm1hbF96b25lX2RldmljZSAqdHosIGludCAqdGVtcCkKPiDCoAo+IMKgc3RhdGljIGludCBsdnRz
X3NldF90cmlwcyhzdHJ1Y3QgdGhlcm1hbF96b25lX2RldmljZSAqdHosIGludCBsb3csIGludCBo
aWdoKQo+IMKgewo+IC3CoMKgwqDCoMKgwqDCoHN0cnVjdCBsdnRzX3NlbnNvciAqbHZ0c19zZW5z
b3IgPSB0ei0+ZGV2ZGF0YTsKPiArwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgbHZ0c19zZW5zb3IgKmx2
dHNfc2Vuc29yID0gdGhlcm1hbF96b25lX2RldmljZV9nZXRfZGF0YSh0eik7Cj4gwqDCoMKgwqDC
oMKgwqDCoHZvaWQgX19pb21lbSAqYmFzZSA9IGx2dHNfc2Vuc29yLT5iYXNlOwo+IMKgwqDCoMKg
wqDCoMKgwqB1MzIgcmF3X2xvdyA9IGx2dHNfdGVtcF90b19yYXcobG93KTsKPiDCoMKgwqDCoMKg
wqDCoMKgdTMyIHJhd19oaWdoID0gbHZ0c190ZW1wX3RvX3JhdyhoaWdoKTsKPiBkaWZmIC0tZ2l0
IGEvZHJpdmVycy90aGVybWFsL3Fjb20vcWNvbS1zcG1pLWFkYy10bTUuYyBiL2RyaXZlcnMvdGhl
cm1hbC9xY29tL3Fjb20tc3BtaS1hZGMtdG01LmMKPiBpbmRleCAzMTE2NGFkZTJkZDEuLmIwMjY5
ZGFmMTI4YSAxMDA2NDQKPiAtLS0gYS9kcml2ZXJzL3RoZXJtYWwvcWNvbS9xY29tLXNwbWktYWRj
LXRtNS5jCj4gKysrIGIvZHJpdmVycy90aGVybWFsL3Fjb20vcWNvbS1zcG1pLWFkYy10bTUuYwo+
IEBAIC0zNjAsNyArMzYwLDcgQEAgc3RhdGljIGlycXJldHVybl90IGFkY190bTVfZ2VuMl9pc3Io
aW50IGlycSwgdm9pZCAqZGF0YSkKPiDCoAo+IMKgc3RhdGljIGludCBhZGNfdG01X2dldF90ZW1w
KHN0cnVjdCB0aGVybWFsX3pvbmVfZGV2aWNlICp0eiwgaW50ICp0ZW1wKQo+IMKgewo+IC3CoMKg
wqDCoMKgwqDCoHN0cnVjdCBhZGNfdG01X2NoYW5uZWwgKmNoYW5uZWwgPSB0ei0+ZGV2ZGF0YTsK
PiArwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgYWRjX3RtNV9jaGFubmVsICpjaGFubmVsID0gdGhlcm1h
bF96b25lX2RldmljZV9nZXRfZGF0YSh0eik7Cj4gwqDCoMKgwqDCoMKgwqDCoGludCByZXQ7Cj4g
wqAKPiDCoMKgwqDCoMKgwqDCoMKgaWYgKCFjaGFubmVsIHx8ICFjaGFubmVsLT5paW8pCj4gQEAg
LTY0Miw3ICs2NDIsNyBAQCBzdGF0aWMgaW50IGFkY190bTVfZ2VuMl9jb25maWd1cmUoc3RydWN0
IGFkY190bTVfY2hhbm5lbCAqY2hhbm5lbCwgaW50IGxvdywgaW50Cj4gwqAKPiDCoHN0YXRpYyBp
bnQgYWRjX3RtNV9zZXRfdHJpcHMoc3RydWN0IHRoZXJtYWxfem9uZV9kZXZpY2UgKnR6LCBpbnQg
bG93LCBpbnQgaGlnaCkKPiDCoHsKPiAtwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgYWRjX3RtNV9jaGFu
bmVsICpjaGFubmVsID0gdHotPmRldmRhdGE7Cj4gK8KgwqDCoMKgwqDCoMKgc3RydWN0IGFkY190
bTVfY2hhbm5lbCAqY2hhbm5lbCA9IHRoZXJtYWxfem9uZV9kZXZpY2VfZ2V0X2RhdGEodHopOwo+
IMKgwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgYWRjX3RtNV9jaGlwICpjaGlwOwo+IMKgwqDCoMKgwqDC
oMKgwqBpbnQgcmV0Owo+IMKgCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdGhlcm1hbC9xY29tL3Fj
b20tc3BtaS10ZW1wLWFsYXJtLmMgYi9kcml2ZXJzL3RoZXJtYWwvcWNvbS9xY29tLXNwbWktdGVt
cC1hbGFybS5jCj4gaW5kZXggMTAxYzc1ZDBlMTNmLi5jODE3YjAzZGViMDAgMTAwNjQ0Cj4gLS0t
IGEvZHJpdmVycy90aGVybWFsL3Fjb20vcWNvbS1zcG1pLXRlbXAtYWxhcm0uYwo+ICsrKyBiL2Ry
aXZlcnMvdGhlcm1hbC9xY29tL3Fjb20tc3BtaS10ZW1wLWFsYXJtLmMKPiBAQCAtMTg3LDcgKzE4
Nyw3IEBAIHN0YXRpYyBpbnQgcXBucF90bV91cGRhdGVfdGVtcF9ub19hZGMoc3RydWN0IHFwbnBf
dG1fY2hpcCAqY2hpcCkKPiDCoAo+IMKgc3RhdGljIGludCBxcG5wX3RtX2dldF90ZW1wKHN0cnVj
dCB0aGVybWFsX3pvbmVfZGV2aWNlICp0eiwgaW50ICp0ZW1wKQo+IMKgewo+IC3CoMKgwqDCoMKg
wqDCoHN0cnVjdCBxcG5wX3RtX2NoaXAgKmNoaXAgPSB0ei0+ZGV2ZGF0YTsKPiArwqDCoMKgwqDC
oMKgwqBzdHJ1Y3QgcXBucF90bV9jaGlwICpjaGlwID0gdGhlcm1hbF96b25lX2RldmljZV9nZXRf
ZGF0YSh0eik7Cj4gwqDCoMKgwqDCoMKgwqDCoGludCByZXQsIG1pbGlfY2Vsc2l1czsKPiDCoAo+
IMKgwqDCoMKgwqDCoMKgwqBpZiAoIXRlbXApCj4gQEAgLTI2NSw3ICsyNjUsNyBAQCBzdGF0aWMg
aW50IHFwbnBfdG1fdXBkYXRlX2NyaXRpY2FsX3RyaXBfdGVtcChzdHJ1Y3QgcXBucF90bV9jaGlw
ICpjaGlwLAo+IMKgCj4gwqBzdGF0aWMgaW50IHFwbnBfdG1fc2V0X3RyaXBfdGVtcChzdHJ1Y3Qg
dGhlcm1hbF96b25lX2RldmljZSAqdHosIGludCB0cmlwX2lkLCBpbnQgdGVtcCkKPiDCoHsKPiAt
wqDCoMKgwqDCoMKgwqBzdHJ1Y3QgcXBucF90bV9jaGlwICpjaGlwID0gdHotPmRldmRhdGE7Cj4g
K8KgwqDCoMKgwqDCoMKgc3RydWN0IHFwbnBfdG1fY2hpcCAqY2hpcCA9IHRoZXJtYWxfem9uZV9k
ZXZpY2VfZ2V0X2RhdGEodHopOwo+IMKgwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgdGhlcm1hbF90cmlw
IHRyaXA7Cj4gwqDCoMKgwqDCoMKgwqDCoGludCByZXQ7Cj4gwqAKPiBkaWZmIC0tZ2l0IGEvZHJp
dmVycy90aGVybWFsL3FvcmlxX3RoZXJtYWwuYyBiL2RyaXZlcnMvdGhlcm1hbC9xb3JpcV90aGVy
bWFsLmMKPiBpbmRleCA0MzFjMjljMDg5OGEuLjhiNmZlMGM5YWRlMiAxMDA2NDQKPiAtLS0gYS9k
cml2ZXJzL3RoZXJtYWwvcW9yaXFfdGhlcm1hbC5jCj4gKysrIGIvZHJpdmVycy90aGVybWFsL3Fv
cmlxX3RoZXJtYWwuYwo+IEBAIC04Myw3ICs4Myw3IEBAIHN0YXRpYyBzdHJ1Y3QgcW9yaXFfdG11
X2RhdGEgKnFvcmlxX3NlbnNvcl90b19kYXRhKHN0cnVjdCBxb3JpcV9zZW5zb3IgKnMpCj4gwqAK
PiDCoHN0YXRpYyBpbnQgdG11X2dldF90ZW1wKHN0cnVjdCB0aGVybWFsX3pvbmVfZGV2aWNlICp0
eiwgaW50ICp0ZW1wKQo+IMKgewo+IC3CoMKgwqDCoMKgwqDCoHN0cnVjdCBxb3JpcV9zZW5zb3Ig
KnFzZW5zb3IgPSB0ei0+ZGV2ZGF0YTsKPiArwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgcW9yaXFfc2Vu
c29yICpxc2Vuc29yID0gdGhlcm1hbF96b25lX2RldmljZV9nZXRfZGF0YSh0eik7Cj4gwqDCoMKg
wqDCoMKgwqDCoHN0cnVjdCBxb3JpcV90bXVfZGF0YSAqcWRhdGEgPSBxb3JpcV9zZW5zb3JfdG9f
ZGF0YShxc2Vuc29yKTsKPiDCoMKgwqDCoMKgwqDCoMKgdTMyIHZhbDsKPiDCoMKgwqDCoMKgwqDC
oMKgLyoKPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy90aGVybWFsL3JjYXJfZ2VuM190aGVybWFsLmMg
Yi9kcml2ZXJzL3RoZXJtYWwvcmNhcl9nZW4zX3RoZXJtYWwuYwo+IGluZGV4IGQ2YjViNTljNWM1
My4uOGFkNzEzY2I0YmY3IDEwMDY0NAo+IC0tLSBhL2RyaXZlcnMvdGhlcm1hbC9yY2FyX2dlbjNf
dGhlcm1hbC5jCj4gKysrIGIvZHJpdmVycy90aGVybWFsL3JjYXJfZ2VuM190aGVybWFsLmMKPiBA
QCAtMTY3LDcgKzE2Nyw3IEBAIHN0YXRpYyBpbnQgcmNhcl9nZW4zX3RoZXJtYWxfcm91bmQoaW50
IHRlbXApCj4gwqAKPiDCoHN0YXRpYyBpbnQgcmNhcl9nZW4zX3RoZXJtYWxfZ2V0X3RlbXAoc3Ry
dWN0IHRoZXJtYWxfem9uZV9kZXZpY2UgKnR6LCBpbnQgKnRlbXApCj4gwqB7Cj4gLcKgwqDCoMKg
wqDCoMKgc3RydWN0IHJjYXJfZ2VuM190aGVybWFsX3RzYyAqdHNjID0gdHotPmRldmRhdGE7Cj4g
K8KgwqDCoMKgwqDCoMKgc3RydWN0IHJjYXJfZ2VuM190aGVybWFsX3RzYyAqdHNjID0gdGhlcm1h
bF96b25lX2RldmljZV9nZXRfZGF0YSh0eik7Cj4gwqDCoMKgwqDCoMKgwqDCoGludCBtY2Vsc2l1
cywgdmFsOwo+IMKgwqDCoMKgwqDCoMKgwqBpbnQgcmVnOwo+IMKgCj4gQEAgLTIwNiw3ICsyMDYs
NyBAQCBzdGF0aWMgaW50IHJjYXJfZ2VuM190aGVybWFsX21jZWxzaXVzX3RvX3RlbXAoc3RydWN0
IHJjYXJfZ2VuM190aGVybWFsX3RzYyAqdHNjLAo+IMKgCj4gwqBzdGF0aWMgaW50IHJjYXJfZ2Vu
M190aGVybWFsX3NldF90cmlwcyhzdHJ1Y3QgdGhlcm1hbF96b25lX2RldmljZSAqdHosIGludCBs
b3csIGludCBoaWdoKQo+IMKgewo+IC3CoMKgwqDCoMKgwqDCoHN0cnVjdCByY2FyX2dlbjNfdGhl
cm1hbF90c2MgKnRzYyA9IHR6LT5kZXZkYXRhOwo+ICvCoMKgwqDCoMKgwqDCoHN0cnVjdCByY2Fy
X2dlbjNfdGhlcm1hbF90c2MgKnRzYyA9IHRoZXJtYWxfem9uZV9kZXZpY2VfZ2V0X2RhdGEodHop
Owo+IMKgwqDCoMKgwqDCoMKgwqB1MzIgaXJxbXNrID0gMDsKPiDCoAo+IMKgwqDCoMKgwqDCoMKg
wqBpZiAobG93ICE9IC1JTlRfTUFYKSB7Cj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdGhlcm1hbC9y
Y2FyX3RoZXJtYWwuYyBiL2RyaXZlcnMvdGhlcm1hbC9yY2FyX3RoZXJtYWwuYwo+IGluZGV4IDQz
NmY1ZjljZjcyOS4uNTM4ZWQ2NzMxNTg5IDEwMDY0NAo+IC0tLSBhL2RyaXZlcnMvdGhlcm1hbC9y
Y2FyX3RoZXJtYWwuYwo+ICsrKyBiL2RyaXZlcnMvdGhlcm1hbC9yY2FyX3RoZXJtYWwuYwo+IEBA
IC0xMDEsNyArMTAxLDYgQEAgc3RydWN0IHJjYXJfdGhlcm1hbF9wcml2IHsKPiDCoMKgwqDCoMKg
wqDCoMKgbGlzdF9mb3JfZWFjaF9lbnRyeShwb3MsICZjb21tb24tPmhlYWQsIGxpc3QpCj4gwqAK
PiDCoCNkZWZpbmUgTUNFTFNJVVModGVtcCnCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgKCh0ZW1wKSAqIDEwMDApCj4gLSNkZWZpbmUgcmNhcl96b25lX3RvX3ByaXYoem9uZSnCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCgoem9uZSktPmRldmRhdGEpCj4gwqAjZGVmaW5l
IHJjYXJfcHJpdl90b19kZXYocHJpdinCoMKgwqDCoMKgwqDCoMKgwqAoKHByaXYpLT5jb21tb24t
PmRldikKPiDCoCNkZWZpbmUgcmNhcl9oYXNfaXJxX3N1cHBvcnQocHJpdinCoMKgwqDCoMKgKChw
cml2KS0+Y29tbW9uLT5iYXNlKQo+IMKgI2RlZmluZSByY2FyX2lkX3RvX3NoaWZ0KHByaXYpwqDC
oMKgwqDCoMKgwqDCoMKgKChwcml2KS0+aWQgKiA4KQo+IEBAIC0yNzMsNyArMjcyLDcgQEAgc3Rh
dGljIGludCByY2FyX3RoZXJtYWxfZ2V0X2N1cnJlbnRfdGVtcChzdHJ1Y3QgcmNhcl90aGVybWFs
X3ByaXYgKnByaXYsCj4gwqAKPiDCoHN0YXRpYyBpbnQgcmNhcl90aGVybWFsX2dldF90ZW1wKHN0
cnVjdCB0aGVybWFsX3pvbmVfZGV2aWNlICp6b25lLCBpbnQgKnRlbXApCj4gwqB7Cj4gLcKgwqDC
oMKgwqDCoMKgc3RydWN0IHJjYXJfdGhlcm1hbF9wcml2ICpwcml2ID0gcmNhcl96b25lX3RvX3By
aXYoem9uZSk7Cj4gK8KgwqDCoMKgwqDCoMKgc3RydWN0IHJjYXJfdGhlcm1hbF9wcml2ICpwcml2
ID0gdGhlcm1hbF96b25lX2RldmljZV9nZXRfZGF0YSh6b25lKTsKPiDCoAo+IMKgwqDCoMKgwqDC
oMKgwqByZXR1cm4gcmNhcl90aGVybWFsX2dldF9jdXJyZW50X3RlbXAocHJpdiwgdGVtcCk7Cj4g
wqB9Cj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdGhlcm1hbC9yb2NrY2hpcF90aGVybWFsLmMgYi9k
cml2ZXJzL3RoZXJtYWwvcm9ja2NoaXBfdGhlcm1hbC5jCj4gaW5kZXggNGI3YzQzZjM0ZDFhLi5k
YWZiZGJiN2MwYzAgMTAwNjQ0Cj4gLS0tIGEvZHJpdmVycy90aGVybWFsL3JvY2tjaGlwX3RoZXJt
YWwuYwo+ICsrKyBiL2RyaXZlcnMvdGhlcm1hbC9yb2NrY2hpcF90aGVybWFsLmMKPiBAQCAtMTIx
Myw3ICsxMjEzLDcgQEAgc3RhdGljIGlycXJldHVybl90IHJvY2tjaGlwX3RoZXJtYWxfYWxhcm1f
aXJxX3RocmVhZChpbnQgaXJxLCB2b2lkICpkZXYpCj4gwqAKPiDCoHN0YXRpYyBpbnQgcm9ja2No
aXBfdGhlcm1hbF9zZXRfdHJpcHMoc3RydWN0IHRoZXJtYWxfem9uZV9kZXZpY2UgKnR6LCBpbnQg
bG93LCBpbnQgaGlnaCkKPiDCoHsKPiAtwqDCoMKgwqDCoMKgwqBzdHJ1Y3Qgcm9ja2NoaXBfdGhl
cm1hbF9zZW5zb3IgKnNlbnNvciA9IHR6LT5kZXZkYXRhOwo+ICvCoMKgwqDCoMKgwqDCoHN0cnVj
dCByb2NrY2hpcF90aGVybWFsX3NlbnNvciAqc2Vuc29yID0gdGhlcm1hbF96b25lX2RldmljZV9n
ZXRfZGF0YSh0eik7Cj4gwqDCoMKgwqDCoMKgwqDCoHN0cnVjdCByb2NrY2hpcF90aGVybWFsX2Rh
dGEgKnRoZXJtYWwgPSBzZW5zb3ItPnRoZXJtYWw7Cj4gwqDCoMKgwqDCoMKgwqDCoGNvbnN0IHN0
cnVjdCByb2NrY2hpcF90c2FkY19jaGlwICp0c2FkYyA9IHRoZXJtYWwtPmNoaXA7Cj4gwqAKPiBA
QCAtMTIyNiw3ICsxMjI2LDcgQEAgc3RhdGljIGludCByb2NrY2hpcF90aGVybWFsX3NldF90cmlw
cyhzdHJ1Y3QgdGhlcm1hbF96b25lX2RldmljZSAqdHosIGludCBsb3csIGkKPiDCoAo+IMKgc3Rh
dGljIGludCByb2NrY2hpcF90aGVybWFsX2dldF90ZW1wKHN0cnVjdCB0aGVybWFsX3pvbmVfZGV2
aWNlICp0eiwgaW50ICpvdXRfdGVtcCkKPiDCoHsKPiAtwqDCoMKgwqDCoMKgwqBzdHJ1Y3Qgcm9j
a2NoaXBfdGhlcm1hbF9zZW5zb3IgKnNlbnNvciA9IHR6LT5kZXZkYXRhOwo+ICvCoMKgwqDCoMKg
wqDCoHN0cnVjdCByb2NrY2hpcF90aGVybWFsX3NlbnNvciAqc2Vuc29yID0gdGhlcm1hbF96b25l
X2RldmljZV9nZXRfZGF0YSh0eik7Cj4gwqDCoMKgwqDCoMKgwqDCoHN0cnVjdCByb2NrY2hpcF90
aGVybWFsX2RhdGEgKnRoZXJtYWwgPSBzZW5zb3ItPnRoZXJtYWw7Cj4gwqDCoMKgwqDCoMKgwqDC
oGNvbnN0IHN0cnVjdCByb2NrY2hpcF90c2FkY19jaGlwICp0c2FkYyA9IHNlbnNvci0+dGhlcm1h
bC0+Y2hpcDsKPiDCoMKgwqDCoMKgwqDCoMKgaW50IHJldHZhbDsKPiBkaWZmIC0tZ2l0IGEvZHJp
dmVycy90aGVybWFsL3J6ZzJsX3RoZXJtYWwuYyBiL2RyaXZlcnMvdGhlcm1hbC9yemcybF90aGVy
bWFsLmMKPiBpbmRleCAyZTA2NDlmMzg1MDYuLmQzYmEyYTc0ZTQyZCAxMDA2NDQKPiAtLS0gYS9k
cml2ZXJzL3RoZXJtYWwvcnpnMmxfdGhlcm1hbC5jCj4gKysrIGIvZHJpdmVycy90aGVybWFsL3J6
ZzJsX3RoZXJtYWwuYwo+IEBAIC03NSw3ICs3NSw3IEBAIHN0YXRpYyBpbmxpbmUgdm9pZCByemcy
bF90aGVybWFsX3dyaXRlKHN0cnVjdCByemcybF90aGVybWFsX3ByaXYgKnByaXYsIHUzMiByZWcs
Cj4gwqAKPiDCoHN0YXRpYyBpbnQgcnpnMmxfdGhlcm1hbF9nZXRfdGVtcChzdHJ1Y3QgdGhlcm1h
bF96b25lX2RldmljZSAqdHosIGludCAqdGVtcCkKPiDCoHsKPiAtwqDCoMKgwqDCoMKgwqBzdHJ1
Y3QgcnpnMmxfdGhlcm1hbF9wcml2ICpwcml2ID0gdHotPmRldmRhdGE7Cj4gK8KgwqDCoMKgwqDC
oMKgc3RydWN0IHJ6ZzJsX3RoZXJtYWxfcHJpdiAqcHJpdiA9IHRoZXJtYWxfem9uZV9kZXZpY2Vf
Z2V0X2RhdGEodHopOwo+IMKgwqDCoMKgwqDCoMKgwqB1MzIgcmVzdWx0ID0gMCwgZHNlbnNvciwg
dHNfY29kZV9hdmU7Cj4gwqDCoMKgwqDCoMKgwqDCoGludCB2YWwsIGk7Cj4gwqAKPiBkaWZmIC0t
Z2l0IGEvZHJpdmVycy90aGVybWFsL3NhbXN1bmcvZXh5bm9zX3RtdS5jIGIvZHJpdmVycy90aGVy
bWFsL3NhbXN1bmcvZXh5bm9zX3RtdS5jCj4gaW5kZXggNTI3ZDFlYjA2NjNhLi5hMjMwMWUyMzVh
MmIgMTAwNjQ0Cj4gLS0tIGEvZHJpdmVycy90aGVybWFsL3NhbXN1bmcvZXh5bm9zX3RtdS5jCj4g
KysrIGIvZHJpdmVycy90aGVybWFsL3NhbXN1bmcvZXh5bm9zX3RtdS5jCj4gQEAgLTY0NSw3ICs2
NDUsNyBAQCBzdGF0aWMgdm9pZCBleHlub3M3X3RtdV9jb250cm9sKHN0cnVjdCBwbGF0Zm9ybV9k
ZXZpY2UgKnBkZXYsIGJvb2wgb24pCj4gwqAKPiDCoHN0YXRpYyBpbnQgZXh5bm9zX2dldF90ZW1w
KHN0cnVjdCB0aGVybWFsX3pvbmVfZGV2aWNlICp0eiwgaW50ICp0ZW1wKQo+IMKgewo+IC3CoMKg
wqDCoMKgwqDCoHN0cnVjdCBleHlub3NfdG11X2RhdGEgKmRhdGEgPSB0ei0+ZGV2ZGF0YTsKPiAr
wqDCoMKgwqDCoMKgwqBzdHJ1Y3QgZXh5bm9zX3RtdV9kYXRhICpkYXRhID0gdGhlcm1hbF96b25l
X2RldmljZV9nZXRfZGF0YSh0eik7Cj4gwqDCoMKgwqDCoMKgwqDCoGludCB2YWx1ZSwgcmV0ID0g
MDsKPiDCoAo+IMKgwqDCoMKgwqDCoMKgwqBpZiAoIWRhdGEgfHwgIWRhdGEtPnRtdV9yZWFkKQo+
IEBAIC03MjMsNyArNzIzLDcgQEAgc3RhdGljIHZvaWQgZXh5bm9zNDQxMl90bXVfc2V0X2VtdWxh
dGlvbihzdHJ1Y3QgZXh5bm9zX3RtdV9kYXRhICpkYXRhLAo+IMKgCj4gwqBzdGF0aWMgaW50IGV4
eW5vc190bXVfc2V0X2VtdWxhdGlvbihzdHJ1Y3QgdGhlcm1hbF96b25lX2RldmljZSAqdHosIGlu
dCB0ZW1wKQo+IMKgewo+IC3CoMKgwqDCoMKgwqDCoHN0cnVjdCBleHlub3NfdG11X2RhdGEgKmRh
dGEgPSB0ei0+ZGV2ZGF0YTsKPiArwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgZXh5bm9zX3RtdV9kYXRh
ICpkYXRhID0gdGhlcm1hbF96b25lX2RldmljZV9nZXRfZGF0YSh0eik7Cj4gwqDCoMKgwqDCoMKg
wqDCoGludCByZXQgPSAtRUlOVkFMOwo+IMKgCj4gwqDCoMKgwqDCoMKgwqDCoGlmIChkYXRhLT5z
b2MgPT0gU09DX0FSQ0hfRVhZTk9TNDIxMCkKPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy90aGVybWFs
L3NwZWFyX3RoZXJtYWwuYyBiL2RyaXZlcnMvdGhlcm1hbC9zcGVhcl90aGVybWFsLmMKPiBpbmRl
eCA2YTcyMmIxMGQ3MzguLjYyY2Q5MzA1ZWI5YyAxMDA2NDQKPiAtLS0gYS9kcml2ZXJzL3RoZXJt
YWwvc3BlYXJfdGhlcm1hbC5jCj4gKysrIGIvZHJpdmVycy90aGVybWFsL3NwZWFyX3RoZXJtYWwu
Ywo+IEBAIC0zMSw3ICszMSw3IEBAIHN0cnVjdCBzcGVhcl90aGVybWFsX2RldiB7Cj4gwqBzdGF0
aWMgaW5saW5lIGludCB0aGVybWFsX2dldF90ZW1wKHN0cnVjdCB0aGVybWFsX3pvbmVfZGV2aWNl
ICp0aGVybWFsLAo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqBpbnQgKnRlbXApCj4gwqB7Cj4gLcKgwqDCoMKgwqDCoMKgc3Ry
dWN0IHNwZWFyX3RoZXJtYWxfZGV2ICpzdGRldiA9IHRoZXJtYWwtPmRldmRhdGE7Cj4gK8KgwqDC
oMKgwqDCoMKgc3RydWN0IHNwZWFyX3RoZXJtYWxfZGV2ICpzdGRldiA9IHRoZXJtYWxfem9uZV9k
ZXZpY2VfZ2V0X2RhdGEodGhlcm1hbCk7Cj4gwqAKPiDCoMKgwqDCoMKgwqDCoMKgLyoKPiDCoMKg
wqDCoMKgwqDCoMKgICogRGF0YSBhcmUgcmVhZHkgdG8gYmUgcmVhZCBhZnRlciA2MjggdXNlYyBm
cm9tIFBPV0VSRE9XTiBzaWduYWwKPiBAQCAtNDgsNyArNDgsNyBAQCBzdGF0aWMgc3RydWN0IHRo
ZXJtYWxfem9uZV9kZXZpY2Vfb3BzIG9wcyA9IHsKPiDCoHN0YXRpYyBpbnQgX19tYXliZV91bnVz
ZWQgc3BlYXJfdGhlcm1hbF9zdXNwZW5kKHN0cnVjdCBkZXZpY2UgKmRldikKPiDCoHsKPiDCoMKg
wqDCoMKgwqDCoMKgc3RydWN0IHRoZXJtYWxfem9uZV9kZXZpY2UgKnNwZWFyX3RoZXJtYWwgPSBk
ZXZfZ2V0X2RydmRhdGEoZGV2KTsKPiAtwqDCoMKgwqDCoMKgwqBzdHJ1Y3Qgc3BlYXJfdGhlcm1h
bF9kZXYgKnN0ZGV2ID0gc3BlYXJfdGhlcm1hbC0+ZGV2ZGF0YTsKPiArwqDCoMKgwqDCoMKgwqBz
dHJ1Y3Qgc3BlYXJfdGhlcm1hbF9kZXYgKnN0ZGV2ID0gdGhlcm1hbF96b25lX2RldmljZV9nZXRf
ZGF0YShzcGVhcl90aGVybWFsKTsKPiDCoMKgwqDCoMKgwqDCoMKgdW5zaWduZWQgaW50IGFjdHVh
bF9tYXNrID0gMDsKPiDCoAo+IMKgwqDCoMKgwqDCoMKgwqAvKiBEaXNhYmxlIFNQRUFyIFRoZXJt
YWwgU2Vuc29yICovCj4gQEAgLTY0LDcgKzY0LDcgQEAgc3RhdGljIGludCBfX21heWJlX3VudXNl
ZCBzcGVhcl90aGVybWFsX3N1c3BlbmQoc3RydWN0IGRldmljZSAqZGV2KQo+IMKgc3RhdGljIGlu
dCBfX21heWJlX3VudXNlZCBzcGVhcl90aGVybWFsX3Jlc3VtZShzdHJ1Y3QgZGV2aWNlICpkZXYp
Cj4gwqB7Cj4gwqDCoMKgwqDCoMKgwqDCoHN0cnVjdCB0aGVybWFsX3pvbmVfZGV2aWNlICpzcGVh
cl90aGVybWFsID0gZGV2X2dldF9kcnZkYXRhKGRldik7Cj4gLcKgwqDCoMKgwqDCoMKgc3RydWN0
IHNwZWFyX3RoZXJtYWxfZGV2ICpzdGRldiA9IHNwZWFyX3RoZXJtYWwtPmRldmRhdGE7Cj4gK8Kg
wqDCoMKgwqDCoMKgc3RydWN0IHNwZWFyX3RoZXJtYWxfZGV2ICpzdGRldiA9IHRoZXJtYWxfem9u
ZV9kZXZpY2VfZ2V0X2RhdGEoc3BlYXJfdGhlcm1hbCk7Cj4gwqDCoMKgwqDCoMKgwqDCoHVuc2ln
bmVkIGludCBhY3R1YWxfbWFzayA9IDA7Cj4gwqDCoMKgwqDCoMKgwqDCoGludCByZXQgPSAwOwo+
IMKgCj4gQEAgLTE1NCw3ICsxNTQsNyBAQCBzdGF0aWMgaW50IHNwZWFyX3RoZXJtYWxfZXhpdChz
dHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2KQo+IMKgewo+IMKgwqDCoMKgwqDCoMKgwqB1bnNp
Z25lZCBpbnQgYWN0dWFsX21hc2sgPSAwOwo+IMKgwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgdGhlcm1h
bF96b25lX2RldmljZSAqc3BlYXJfdGhlcm1hbCA9IHBsYXRmb3JtX2dldF9kcnZkYXRhKHBkZXYp
Owo+IC3CoMKgwqDCoMKgwqDCoHN0cnVjdCBzcGVhcl90aGVybWFsX2RldiAqc3RkZXYgPSBzcGVh
cl90aGVybWFsLT5kZXZkYXRhOwo+ICvCoMKgwqDCoMKgwqDCoHN0cnVjdCBzcGVhcl90aGVybWFs
X2RldiAqc3RkZXYgPSB0aGVybWFsX3pvbmVfZGV2aWNlX2dldF9kYXRhKHNwZWFyX3RoZXJtYWwp
Owo+IMKgCj4gwqDCoMKgwqDCoMKgwqDCoHRoZXJtYWxfem9uZV9kZXZpY2VfdW5yZWdpc3Rlcihz
cGVhcl90aGVybWFsKTsKPiDCoAo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3RoZXJtYWwvc3ByZF90
aGVybWFsLmMgYi9kcml2ZXJzL3RoZXJtYWwvc3ByZF90aGVybWFsLmMKPiBpbmRleCBhYzg4NDUx
NGYxMTYuLjY5MDc4YTU1ZGMwYyAxMDA2NDQKPiAtLS0gYS9kcml2ZXJzL3RoZXJtYWwvc3ByZF90
aGVybWFsLmMKPiArKysgYi9kcml2ZXJzL3RoZXJtYWwvc3ByZF90aGVybWFsLmMKPiBAQCAtMjA2
LDcgKzIwNiw3IEBAIHN0YXRpYyBpbnQgc3ByZF90aG1fdGVtcF90b19yYXdkYXRhKGludCB0ZW1w
LCBzdHJ1Y3Qgc3ByZF90aGVybWFsX3NlbnNvciAqc2VuKQo+IMKgCj4gwqBzdGF0aWMgaW50IHNw
cmRfdGhtX3JlYWRfdGVtcChzdHJ1Y3QgdGhlcm1hbF96b25lX2RldmljZSAqdHosIGludCAqdGVt
cCkKPiDCoHsKPiAtwqDCoMKgwqDCoMKgwqBzdHJ1Y3Qgc3ByZF90aGVybWFsX3NlbnNvciAqc2Vu
ID0gdHotPmRldmRhdGE7Cj4gK8KgwqDCoMKgwqDCoMKgc3RydWN0IHNwcmRfdGhlcm1hbF9zZW5z
b3IgKnNlbiA9IHRoZXJtYWxfem9uZV9kZXZpY2VfZ2V0X2RhdGEodHopOwo+IMKgwqDCoMKgwqDC
oMKgwqB1MzIgZGF0YTsKPiDCoAo+IMKgwqDCoMKgwqDCoMKgwqBkYXRhID0gcmVhZGwoc2VuLT5k
YXRhLT5iYXNlICsgU1BSRF9USE1fVEVNUChzZW4tPmlkKSkgJgo+IGRpZmYgLS1naXQgYS9kcml2
ZXJzL3RoZXJtYWwvc3VuOGlfdGhlcm1hbC5jIGIvZHJpdmVycy90aGVybWFsL3N1bjhpX3RoZXJt
YWwuYwo+IGluZGV4IDQ5N2JlYWM2M2U1ZC4uMDg1YjdiMGI3YzcyIDEwMDY0NAo+IC0tLSBhL2Ry
aXZlcnMvdGhlcm1hbC9zdW44aV90aGVybWFsLmMKPiArKysgYi9kcml2ZXJzL3RoZXJtYWwvc3Vu
OGlfdGhlcm1hbC5jCj4gQEAgLTExMCw3ICsxMTAsNyBAQCBzdGF0aWMgaW50IHN1bjUwaV9oNV9j
YWxjX3RlbXAoc3RydWN0IHRoc19kZXZpY2UgKnRtZGV2LAo+IMKgCj4gwqBzdGF0aWMgaW50IHN1
bjhpX3Roc19nZXRfdGVtcChzdHJ1Y3QgdGhlcm1hbF96b25lX2RldmljZSAqdHosIGludCAqdGVt
cCkKPiDCoHsKPiAtwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgdHNlbnNvciAqcyA9IHR6LT5kZXZkYXRh
Owo+ICvCoMKgwqDCoMKgwqDCoHN0cnVjdCB0c2Vuc29yICpzID0gdGhlcm1hbF96b25lX2Rldmlj
ZV9nZXRfZGF0YSh0eik7Cj4gwqDCoMKgwqDCoMKgwqDCoHN0cnVjdCB0aHNfZGV2aWNlICp0bWRl
diA9IHMtPnRtZGV2Owo+IMKgwqDCoMKgwqDCoMKgwqBpbnQgdmFsID0gMDsKPiDCoAo+IGRpZmYg
LS1naXQgYS9kcml2ZXJzL3RoZXJtYWwvdGVncmEvdGVncmEtYnBtcC10aGVybWFsLmMgYi9kcml2
ZXJzL3RoZXJtYWwvdGVncmEvdGVncmEtYnBtcC10aGVybWFsLmMKPiBpbmRleCAwYjdhMWExOTQ4
Y2IuLjMxYTY2MGIwMDlmYyAxMDA2NDQKPiAtLS0gYS9kcml2ZXJzL3RoZXJtYWwvdGVncmEvdGVn
cmEtYnBtcC10aGVybWFsLmMKPiArKysgYi9kcml2ZXJzL3RoZXJtYWwvdGVncmEvdGVncmEtYnBt
cC10aGVybWFsLmMKPiBAQCAtNjIsMTIgKzYyLDE0IEBAIHN0YXRpYyBpbnQgX190ZWdyYV9icG1w
X3RoZXJtYWxfZ2V0X3RlbXAoc3RydWN0IHRlZ3JhX2JwbXBfdGhlcm1hbF96b25lICp6b25lLAo+
IMKgCj4gwqBzdGF0aWMgaW50IHRlZ3JhX2JwbXBfdGhlcm1hbF9nZXRfdGVtcChzdHJ1Y3QgdGhl
cm1hbF96b25lX2RldmljZSAqdHosIGludCAqb3V0X3RlbXApCj4gwqB7Cj4gLcKgwqDCoMKgwqDC
oMKgcmV0dXJuIF9fdGVncmFfYnBtcF90aGVybWFsX2dldF90ZW1wKHR6LT5kZXZkYXRhLCBvdXRf
dGVtcCk7Cj4gK8KgwqDCoMKgwqDCoMKgc3RydWN0IHRlZ3JhX2JwbXBfdGhlcm1hbF96b25lICp6
b25lID0gdGhlcm1hbF96b25lX2RldmljZV9nZXRfZGF0YSh0eik7Cj4gK8KgwqDCoMKgwqDCoMKg
Cj4gK8KgwqDCoMKgwqDCoMKgcmV0dXJuIF9fdGVncmFfYnBtcF90aGVybWFsX2dldF90ZW1wKHpv
bmUsIG91dF90ZW1wKTsKPiDCoH0KPiDCoAo+IMKgc3RhdGljIGludCB0ZWdyYV9icG1wX3RoZXJt
YWxfc2V0X3RyaXBzKHN0cnVjdCB0aGVybWFsX3pvbmVfZGV2aWNlICp0eiwgaW50IGxvdywgaW50
IGhpZ2gpCj4gwqB7Cj4gLcKgwqDCoMKgwqDCoMKgc3RydWN0IHRlZ3JhX2JwbXBfdGhlcm1hbF96
b25lICp6b25lID0gdHotPmRldmRhdGE7Cj4gK8KgwqDCoMKgwqDCoMKgc3RydWN0IHRlZ3JhX2Jw
bXBfdGhlcm1hbF96b25lICp6b25lID0gdGhlcm1hbF96b25lX2RldmljZV9nZXRfZGF0YSh0eik7
Cj4gwqDCoMKgwqDCoMKgwqDCoHN0cnVjdCBtcnFfdGhlcm1hbF9ob3N0X3RvX2JwbXBfcmVxdWVz
dCByZXE7Cj4gwqDCoMKgwqDCoMKgwqDCoHN0cnVjdCB0ZWdyYV9icG1wX21lc3NhZ2UgbXNnOwo+
IMKgwqDCoMKgwqDCoMKgwqBpbnQgZXJyOwo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3RoZXJtYWwv
dGVncmEvdGVncmEzMC10c2Vuc29yLmMgYi9kcml2ZXJzL3RoZXJtYWwvdGVncmEvdGVncmEzMC10
c2Vuc29yLmMKPiBpbmRleCBiMzIxOGI3MWI2ZDkuLjUzNzQxM2FjYzZkMiAxMDA2NDQKPiAtLS0g
YS9kcml2ZXJzL3RoZXJtYWwvdGVncmEvdGVncmEzMC10c2Vuc29yLmMKPiArKysgYi9kcml2ZXJz
L3RoZXJtYWwvdGVncmEvdGVncmEzMC10c2Vuc29yLmMKPiBAQCAtMTYwLDcgKzE2MCw3IEBAIHN0
YXRpYyB2b2lkIGRldm1fdGVncmFfdHNlbnNvcl9od19kaXNhYmxlKHZvaWQgKmRhdGEpCj4gwqAK
PiDCoHN0YXRpYyBpbnQgdGVncmFfdHNlbnNvcl9nZXRfdGVtcChzdHJ1Y3QgdGhlcm1hbF96b25l
X2RldmljZSAqdHosIGludCAqdGVtcCkKPiDCoHsKPiAtwqDCoMKgwqDCoMKgwqBjb25zdCBzdHJ1
Y3QgdGVncmFfdHNlbnNvcl9jaGFubmVsICp0c2MgPSB0ei0+ZGV2ZGF0YTsKPiArwqDCoMKgwqDC
oMKgwqBjb25zdCBzdHJ1Y3QgdGVncmFfdHNlbnNvcl9jaGFubmVsICp0c2MgPSB0aGVybWFsX3pv
bmVfZGV2aWNlX2dldF9kYXRhKHR6KTsKPiDCoMKgwqDCoMKgwqDCoMKgY29uc3Qgc3RydWN0IHRl
Z3JhX3RzZW5zb3IgKnRzID0gdHNjLT50czsKPiDCoMKgwqDCoMKgwqDCoMKgaW50IGVyciwgYzEs
IGMyLCBjMywgYzQsIGNvdW50ZXI7Cj4gwqDCoMKgwqDCoMKgwqDCoHUzMiB2YWw7Cj4gQEAgLTIx
OCw3ICsyMTgsNyBAQCBzdGF0aWMgaW50IHRlZ3JhX3RzZW5zb3JfdGVtcF90b19jb3VudGVyKGNv
bnN0IHN0cnVjdCB0ZWdyYV90c2Vuc29yICp0cywgaW50IHRlbQo+IMKgCj4gwqBzdGF0aWMgaW50
IHRlZ3JhX3RzZW5zb3Jfc2V0X3RyaXBzKHN0cnVjdCB0aGVybWFsX3pvbmVfZGV2aWNlICp0eiwg
aW50IGxvdywgaW50IGhpZ2gpCj4gwqB7Cj4gLcKgwqDCoMKgwqDCoMKgY29uc3Qgc3RydWN0IHRl
Z3JhX3RzZW5zb3JfY2hhbm5lbCAqdHNjID0gdHotPmRldmRhdGE7Cj4gK8KgwqDCoMKgwqDCoMKg
Y29uc3Qgc3RydWN0IHRlZ3JhX3RzZW5zb3JfY2hhbm5lbCAqdHNjID0gdGhlcm1hbF96b25lX2Rl
dmljZV9nZXRfZGF0YSh0eik7Cj4gwqDCoMKgwqDCoMKgwqDCoGNvbnN0IHN0cnVjdCB0ZWdyYV90
c2Vuc29yICp0cyA9IHRzYy0+dHM7Cj4gwqDCoMKgwqDCoMKgwqDCoHUzMiB2YWw7Cj4gwqAKPiBk
aWZmIC0tZ2l0IGEvZHJpdmVycy90aGVybWFsL3RoZXJtYWwtZ2VuZXJpYy1hZGMuYyBiL2RyaXZl
cnMvdGhlcm1hbC90aGVybWFsLWdlbmVyaWMtYWRjLmMKPiBpbmRleCAzMjNlMjczZTMyOTguLjhl
MmZmMGRmN2U2NCAxMDA2NDQKPiAtLS0gYS9kcml2ZXJzL3RoZXJtYWwvdGhlcm1hbC1nZW5lcmlj
LWFkYy5jCj4gKysrIGIvZHJpdmVycy90aGVybWFsL3RoZXJtYWwtZ2VuZXJpYy1hZGMuYwo+IEBA
IC01NCw3ICs1NCw3IEBAIHN0YXRpYyBpbnQgZ2FkY190aGVybWFsX2FkY190b190ZW1wKHN0cnVj
dCBnYWRjX3RoZXJtYWxfaW5mbyAqZ3RpLCBpbnQgdmFsKQo+IMKgCj4gwqBzdGF0aWMgaW50IGdh
ZGNfdGhlcm1hbF9nZXRfdGVtcChzdHJ1Y3QgdGhlcm1hbF96b25lX2RldmljZSAqdHosIGludCAq
dGVtcCkKPiDCoHsKPiAtwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgZ2FkY190aGVybWFsX2luZm8gKmd0
aSA9IHR6LT5kZXZkYXRhOwo+ICvCoMKgwqDCoMKgwqDCoHN0cnVjdCBnYWRjX3RoZXJtYWxfaW5m
byAqZ3RpID0gdGhlcm1hbF96b25lX2RldmljZV9nZXRfZGF0YSh0eik7Cj4gwqDCoMKgwqDCoMKg
wqDCoGludCB2YWw7Cj4gwqDCoMKgwqDCoMKgwqDCoGludCByZXQ7Cj4gwqAKPiBkaWZmIC0tZ2l0
IGEvZHJpdmVycy90aGVybWFsL3RoZXJtYWxfY29yZS5jIGIvZHJpdmVycy90aGVybWFsL3RoZXJt
YWxfY29yZS5jCj4gaW5kZXggMDY3NWRmNTRjOGU2Li4wNWU1YTZiZGE2OTUgMTAwNjQ0Cj4gLS0t
IGEvZHJpdmVycy90aGVybWFsL3RoZXJtYWxfY29yZS5jCj4gKysrIGIvZHJpdmVycy90aGVybWFs
L3RoZXJtYWxfY29yZS5jCj4gQEAgLTEzNzgsNiArMTM3OCwxMiBAQCBzdHJ1Y3QgdGhlcm1hbF96
b25lX2RldmljZSAqdGhlcm1hbF96b25lX2RldmljZV9yZWdpc3Rlcihjb25zdCBjaGFyICp0eXBl
LCBpbnQgbgo+IMKgfQo+IMKgRVhQT1JUX1NZTUJPTF9HUEwodGhlcm1hbF96b25lX2RldmljZV9y
ZWdpc3Rlcik7Cj4gwqAKPiArdm9pZCAqdGhlcm1hbF96b25lX2RldmljZV9nZXRfZGF0YShzdHJ1
Y3QgdGhlcm1hbF96b25lX2RldmljZSAqdHpkKQo+ICt7Cj4gK8KgwqDCoMKgwqDCoMKgcmV0dXJu
IHR6ZC0+ZGV2ZGF0YTsKPiArfQo+ICtFWFBPUlRfU1lNQk9MX0dQTCh0aGVybWFsX3pvbmVfZGV2
aWNlX2dldF9kYXRhKTsKPiArCj4gwqAvKioKPiDCoCAqIHRoZXJtYWxfem9uZV9kZXZpY2VfdW5y
ZWdpc3RlciAtIHJlbW92ZXMgdGhlIHJlZ2lzdGVyZWQgdGhlcm1hbCB6b25lIGRldmljZQo+IMKg
ICogQHR6OiB0aGUgdGhlcm1hbCB6b25lIGRldmljZSB0byByZW1vdmUKPiBkaWZmIC0tZ2l0IGEv
ZHJpdmVycy90aGVybWFsL3RoZXJtYWxfbW1pby5jIGIvZHJpdmVycy90aGVybWFsL3RoZXJtYWxf
bW1pby5jCj4gaW5kZXggZWE2MTY3MzEwNjZjLi4wNWE3MDIwNWY4NmYgMTAwNjQ0Cj4gLS0tIGEv
ZHJpdmVycy90aGVybWFsL3RoZXJtYWxfbW1pby5jCj4gKysrIGIvZHJpdmVycy90aGVybWFsL3Ro
ZXJtYWxfbW1pby5jCj4gQEAgLTIzLDcgKzIzLDcgQEAgc3RhdGljIHUzMiB0aGVybWFsX21taW9f
cmVhZGIodm9pZCBfX2lvbWVtICptbWlvX2Jhc2UpCj4gwqBzdGF0aWMgaW50IHRoZXJtYWxfbW1p
b19nZXRfdGVtcGVyYXR1cmUoc3RydWN0IHRoZXJtYWxfem9uZV9kZXZpY2UgKnR6LCBpbnQgKnRl
bXApCj4gwqB7Cj4gwqDCoMKgwqDCoMKgwqDCoGludCB0Owo+IC3CoMKgwqDCoMKgwqDCoHN0cnVj
dCB0aGVybWFsX21taW8gKnNlbnNvciA9IHR6LT5kZXZkYXRhOwo+ICvCoMKgwqDCoMKgwqDCoHN0
cnVjdCB0aGVybWFsX21taW8gKnNlbnNvciA9IHRoZXJtYWxfem9uZV9kZXZpY2VfZ2V0X2RhdGEo
dHopOwo+IMKgCj4gwqDCoMKgwqDCoMKgwqDCoHQgPSBzZW5zb3ItPnJlYWRfbW1pbyhzZW5zb3It
Pm1taW9fYmFzZSkgJiBzZW5zb3ItPm1hc2s7Cj4gwqDCoMKgwqDCoMKgwqDCoHQgKj0gc2Vuc29y
LT5mYWN0b3I7Cj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdGhlcm1hbC90aS1zb2MtdGhlcm1hbC90
aS10aGVybWFsLWNvbW1vbi5jIGIvZHJpdmVycy90aGVybWFsL3RpLXNvYy10aGVybWFsL3RpLXRo
ZXJtYWwtY29tbW9uLmMKPiBpbmRleCA4YTkwNTViZDM3NmUuLjdmNmI3MWQxMWVlZCAxMDA2NDQK
PiAtLS0gYS9kcml2ZXJzL3RoZXJtYWwvdGktc29jLXRoZXJtYWwvdGktdGhlcm1hbC1jb21tb24u
Ywo+ICsrKyBiL2RyaXZlcnMvdGhlcm1hbC90aS1zb2MtdGhlcm1hbC90aS10aGVybWFsLWNvbW1v
bi5jCj4gQEAgLTY4LDcgKzY4LDcgQEAgc3RhdGljIGlubGluZSBpbnQgdGlfdGhlcm1hbF9ob3Rz
cG90X3RlbXBlcmF0dXJlKGludCB0LCBpbnQgcywgaW50IGMpCj4gwqBzdGF0aWMgaW5saW5lIGlu
dCBfX3RpX3RoZXJtYWxfZ2V0X3RlbXAoc3RydWN0IHRoZXJtYWxfem9uZV9kZXZpY2UgKnR6LCBp
bnQgKnRlbXApCj4gwqB7Cj4gwqDCoMKgwqDCoMKgwqDCoHN0cnVjdCB0aGVybWFsX3pvbmVfZGV2
aWNlICpwY2JfdHogPSBOVUxMOwo+IC3CoMKgwqDCoMKgwqDCoHN0cnVjdCB0aV90aGVybWFsX2Rh
dGEgKmRhdGEgPSB0ei0+ZGV2ZGF0YTsKPiArwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgdGlfdGhlcm1h
bF9kYXRhICpkYXRhID0gdGhlcm1hbF96b25lX2RldmljZV9nZXRfZGF0YSh0eik7Cj4gwqDCoMKg
wqDCoMKgwqDCoHN0cnVjdCB0aV9iYW5kZ2FwICpiZ3A7Cj4gwqDCoMKgwqDCoMKgwqDCoGNvbnN0
IHN0cnVjdCB0aV90ZW1wX3NlbnNvciAqczsKPiDCoMKgwqDCoMKgwqDCoMKgaW50IHJldCwgdG1w
LCBzbG9wZSwgY29uc3RhbnQ7Cj4gQEAgLTEwOSw3ICsxMDksNyBAQCBzdGF0aWMgaW5saW5lIGlu
dCBfX3RpX3RoZXJtYWxfZ2V0X3RlbXAoc3RydWN0IHRoZXJtYWxfem9uZV9kZXZpY2UgKnR6LCBp
bnQgKnRlbQo+IMKgCj4gwqBzdGF0aWMgaW50IF9fdGlfdGhlcm1hbF9nZXRfdHJlbmQoc3RydWN0
IHRoZXJtYWxfem9uZV9kZXZpY2UgKnR6LCBpbnQgdHJpcCwgZW51bSB0aGVybWFsX3RyZW5kICp0
cmVuZCkKPiDCoHsKPiAtwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgdGlfdGhlcm1hbF9kYXRhICpkYXRh
ID0gdHotPmRldmRhdGE7Cj4gK8KgwqDCoMKgwqDCoMKgc3RydWN0IHRpX3RoZXJtYWxfZGF0YSAq
ZGF0YSA9IHRoZXJtYWxfem9uZV9kZXZpY2VfZ2V0X2RhdGEodHopOwo+IMKgwqDCoMKgwqDCoMKg
wqBzdHJ1Y3QgdGlfYmFuZGdhcCAqYmdwOwo+IMKgwqDCoMKgwqDCoMKgwqBpbnQgaWQsIHRyLCBy
ZXQgPSAwOwo+IMKgCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdGhlcm1hbC91bmlwaGllcl90aGVy
bWFsLmMgYi9kcml2ZXJzL3RoZXJtYWwvdW5pcGhpZXJfdGhlcm1hbC5jCj4gaW5kZXggNDc4MDE4
NDFiM2Y1Li4yNTI0N2RlNzc4MGMgMTAwNjQ0Cj4gLS0tIGEvZHJpdmVycy90aGVybWFsL3VuaXBo
aWVyX3RoZXJtYWwuYwo+ICsrKyBiL2RyaXZlcnMvdGhlcm1hbC91bmlwaGllcl90aGVybWFsLmMK
PiBAQCAtMTg3LDcgKzE4Nyw3IEBAIHN0YXRpYyB2b2lkIHVuaXBoaWVyX3RtX2Rpc2FibGVfc2Vu
c29yKHN0cnVjdCB1bmlwaGllcl90bV9kZXYgKnRkZXYpCj4gwqAKPiDCoHN0YXRpYyBpbnQgdW5p
cGhpZXJfdG1fZ2V0X3RlbXAoc3RydWN0IHRoZXJtYWxfem9uZV9kZXZpY2UgKnR6LCBpbnQgKm91
dF90ZW1wKQo+IMKgewo+IC3CoMKgwqDCoMKgwqDCoHN0cnVjdCB1bmlwaGllcl90bV9kZXYgKnRk
ZXYgPSB0ei0+ZGV2ZGF0YTsKPiArwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgdW5pcGhpZXJfdG1fZGV2
ICp0ZGV2ID0gdGhlcm1hbF96b25lX2RldmljZV9nZXRfZGF0YSh0eik7Cj4gwqDCoMKgwqDCoMKg
wqDCoHN0cnVjdCByZWdtYXAgKm1hcCA9IHRkZXYtPnJlZ21hcDsKPiDCoMKgwqDCoMKgwqDCoMKg
aW50IHJldDsKPiDCoMKgwqDCoMKgwqDCoMKgdTMyIHRlbXA7Cj4gZGlmZiAtLWdpdCBhL2luY2x1
ZGUvbGludXgvdGhlcm1hbC5oIGIvaW5jbHVkZS9saW51eC90aGVybWFsLmgKPiBpbmRleCAyYmI0
YmYzM2Y0ZjMuLjcyNGI5NTY2MmRhOSAxMDA2NDQKPiAtLS0gYS9pbmNsdWRlL2xpbnV4L3RoZXJt
YWwuaAo+ICsrKyBiL2luY2x1ZGUvbGludXgvdGhlcm1hbC5oCj4gQEAgLTM2NSw2ICszNjUsOCBA
QCB0aGVybWFsX3pvbmVfZGV2aWNlX3JlZ2lzdGVyX3dpdGhfdHJpcHMoY29uc3QgY2hhciAqLCBz
dHJ1Y3QgdGhlcm1hbF90cmlwICosIGludAo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgdm9pZCAq
LCBzdHJ1Y3QgdGhlcm1hbF96b25lX2RldmljZV9vcHMgKiwKPiDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoHN0cnVjdCB0aGVybWFsX3pvbmVfcGFyYW1zICosIGludCwgaW50KTsKPiDCoAo+ICt2b2lk
ICp0aGVybWFsX3pvbmVfZGV2aWNlX2dldF9kYXRhKHN0cnVjdCB0aGVybWFsX3pvbmVfZGV2aWNl
ICp0emQpOwo+ICsKPiDCoGludCB0aGVybWFsX3pvbmVfYmluZF9jb29saW5nX2RldmljZShzdHJ1
Y3QgdGhlcm1hbF96b25lX2RldmljZSAqLCBpbnQsCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHN0cnVjdCB0
aGVybWFsX2Nvb2xpbmdfZGV2aWNlICosCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHVuc2lnbmVkIGxvbmcs
IHVuc2lnbmVkIGxvbmcsCgpGb3IgaXdsd2lmaToKCkFja2VkLWJ5OiBHcmVnb3J5IEdyZWVubWFu
IDxncmVnb3J5LmdyZWVubWFuQGludGVsLmNvbT4KCkdyZWdvcnkKCg==
