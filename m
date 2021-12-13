Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C7D9472341
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 09:53:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233328AbhLMIxl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 03:53:41 -0500
Received: from mga06.intel.com ([134.134.136.31]:53183 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231589AbhLMIxk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Dec 2021 03:53:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639385620; x=1670921620;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wVUopDsj3dSa/yT0GpAvx0d3g57fgfsXDFhpKxU3zOY=;
  b=EPjwmatn7Q9XxDVqa5JnhmMdydmpc73sv+TF/v3Ss1SA4ChxXyeKa02I
   VsUb/B0e29fzDva2n3GpXbMXzCXg6Y3YGyprdc3DFFg2ENNCFQy5rE0Q2
   os8rV8j6Bm5bzf6AHpBJRUy2emjhNxrSsymBXChun7Ha0Jr7ydZYzglkD
   8JQ6VQHRrAewiFTXrQygAJkIgbQ03Xw6ivKiKzAHTqXRyHSDIm03U7OOo
   cElvEIze3NAoAPcrW13Z6QCxuDViuOY4PUIxKX3QAP1VqnsJzpub53bXh
   8fMoGyc6pAOcL3DAtvh08KkIOfXhDHN5wtKP/9PJx9Tlce4GQu+YerqrJ
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10196"; a="299473475"
X-IronPort-AV: E=Sophos;i="5.88,202,1635231600"; 
   d="scan'208";a="299473475"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2021 00:53:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,202,1635231600"; 
   d="scan'208";a="754215676"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by fmsmga005.fm.intel.com with ESMTP; 13 Dec 2021 00:53:39 -0800
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 13 Dec 2021 00:53:39 -0800
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 13 Dec 2021 00:53:38 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Mon, 13 Dec 2021 00:53:38 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Mon, 13 Dec 2021 00:53:38 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i+Qgjn7jEC59yK7F+4KyTWjWb948v865tw6alpuww2U0zf/0YGYFbIadOj+wH8/Uuaz2AS8DLA8wmp+Z/Z22HVBw0kIbaNFKqeBQVs5uaNEnyoR6EfBjTzYJ4h/KM0snbeQMp1ywzmswnn5AG7vFtzsiWZTpirU0pHRhkpGmremhuF0qk0ba6zIYSKv5EWfcQWztCOB2Drp/bXIn9Zd5BfpWm4wKKRH761l8qmNdJ0vATJkdWFO/cTI2BXNgVkS2ieLyBe818J3eu8MdcBqTKTFnOve1setN1+8rNqd2QY4nQNDEJyC8kJrIYV7iguj/rBHa9L6n3/u6XjJcWlm7qQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wVUopDsj3dSa/yT0GpAvx0d3g57fgfsXDFhpKxU3zOY=;
 b=izLNubcE9Ohc5RqGF/+n8l4n9spl5WZFMzPSkQdhwePHqgXit3odWtS5+oymd6ddMz71q5k7MJtnBZjTTIPwPLDC7mBqpQ1w1kNk/OgIUXsa588W2lqQ3Cb7OWwSeVoIDzfDfdrnff6gYVeqQ8d6oabVBhGMinXzgmOqBkyqMyEC+M5pkUQWfWWMJxshobbhochsE7JS/Y16zjq7XJLn4exxWZJRP7U5MVu6Tvdf8V/+lqFSAEgECbPhHrCinaujwyGEBRbxDDfYIwVBTkyvohRI6d/HyC10QN58ah6laRGvV1VfGyK/gaXK3U1cjxx93XEHkGnOCg6WY9G7oEIFKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wVUopDsj3dSa/yT0GpAvx0d3g57fgfsXDFhpKxU3zOY=;
 b=IYjSp8hbPNuez8Xb3IskoJofsq/4ovqygaPUlH9Mw5WGTlfS0fySciLqE2ElHS4F/wiImsE7MExp2us8Skl/Sz8wMzaQpE2MhfHR/+imYz/7JdaQbJELrz20i5qR3XG50Afh/poVs+7Iqg/gW/7eeXpJmWVX4zWA5ylyV0+mZWE=
Received: from MW5PR11MB5812.namprd11.prod.outlook.com (2603:10b6:303:193::14)
 by MWHPR1101MB2096.namprd11.prod.outlook.com (2603:10b6:301:58::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Mon, 13 Dec
 2021 08:53:36 +0000
Received: from MW5PR11MB5812.namprd11.prod.outlook.com
 ([fe80::1127:5635:26df:eca9]) by MW5PR11MB5812.namprd11.prod.outlook.com
 ([fe80::1127:5635:26df:eca9%8]) with mapi id 15.20.4755.021; Mon, 13 Dec 2021
 08:53:36 +0000
From:   "Machnikowski, Maciej" <maciej.machnikowski@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "Byagowi, Ahmad" <abyagowi@fb.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "idosch@idosch.org" <idosch@idosch.org>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "saeed@kernel.org" <saeed@kernel.org>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "petrm@nvidia.com" <petrm@nvidia.com>,
        Vadim Fedorenko <vfedorenko@novek.ru>
Subject: RE: [PATCH v5 net-next 0/4] Add ethtool interface for RClocks
Thread-Topic: [PATCH v5 net-next 0/4] Add ethtool interface for RClocks
Thread-Index: AQHX7c5gIm8QXL1ZEECyYOKvL6PbZKwr5xQAgAQ7AEA=
Date:   Mon, 13 Dec 2021 08:53:36 +0000
Message-ID: <MW5PR11MB58126A8F6466A8EAD1293D5EEA749@MW5PR11MB5812.namprd11.prod.outlook.com>
References: <20211210134550.1195182-1-maciej.machnikowski@intel.com>
 <20211210081654.233a41b6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211210081654.233a41b6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f53f3676-b646-4a7c-2b7f-08d9be160ce2
x-ms-traffictypediagnostic: MWHPR1101MB2096:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <MWHPR1101MB20964EFCFD3FD80F294C112EEA749@MWHPR1101MB2096.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xjBZzDGcqFRpHroriqr7sm4oDmXo0xIAgoIYBEwJ5lkedRtq+ulbPJmTgY0A9YWOwsnQ6gIphvVXwScQjlz9H9hOS+ZHAAWWg9On2XUkUsIOUS3mY/7wOGVdx09GmnZByPUni9EgaiEMwacvaRIDSVzXJLO1c11XGXSnEiQXdFmBkuaL/TDqKvzAKK7P6FvlBy8qCJstvzTrdiT2eWSL6O+t3Qy8lEu+dCIw7Vxyo6Vsty6l7Cl4xsdh3ZHV0Wkrt01VmL/8FO5ux5E95MshwCUk6pTCJ9b6Ez8Frl6PnNhyoJ5H0D7MfeVroeEAHzDMFj+KnaGy9Qj77uKYO0951rtMrKKGj27rD3F0aaJIjOiKyFbvxr1C6Pp3yrMOpoPtOYCGrBIQgZsEuBrLREmG1nFryjI3gWumlLjKRgA5X8hD0iH4bKtHBR6Kj4PpXRVfaqvVc0G5LtdgQWISJwKxQFPfXJK1X9c9BzUu+22Tgix1xRAJfEPDcABDDHRpjGvws289ZlBkZ48/jaOHlPoKbIAkBvosIvmpM7BkUVVIj1yKGvdVD0vdY0YBbwD/DhbLTqygNuUFMj2wqJdVpi+c8Z6aFu8OVDZyD3oTdxPpP1/5zM05jTJ/if5gpLdCBHcOJyBJO2EBkaLhadnIJrpc9xbZeNS1IMHYl43DyvHEq9DWJUXHV+qytLLJkDzZyQt+ct3jdoze+n1d80afl+nkvg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR11MB5812.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(53546011)(6506007)(71200400001)(38070700005)(54906003)(26005)(83380400001)(7696005)(86362001)(6916009)(8676002)(4326008)(316002)(8936002)(66556008)(66946007)(5660300002)(64756008)(76116006)(9686003)(508600001)(82960400001)(52536014)(186003)(38100700002)(33656002)(2906002)(66446008)(55016003)(7416002)(66476007)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ZxhqMDDdiRjW+3Et81zlwafXuY0SYhO4kYbCmx0jMRAz8e8iSJHs+g6w+4L8?=
 =?us-ascii?Q?9jlEOXdWVCF3m2qwEVU5sPROnjLXEmk9j0AWu6xOITod18Fj21/CG0n9F3ZL?=
 =?us-ascii?Q?P4ZBDic9eX/sWw8qEUUkJ84F9QXMTO779ASez8/gfk+5UZ+d5PhBHGB9TfJe?=
 =?us-ascii?Q?+ECd+aIXrE15jAWqLbQUx4kaytJfnnCs/sN8Z8if7JtRyUQGSOlAQYICcJpQ?=
 =?us-ascii?Q?C7RQNHZDf1dqyOvhCnTvBry7A/Sg+y2m3ebi1jmplbJy46hlIxFTnRnTSyFT?=
 =?us-ascii?Q?PQ6vIbET6fkbVthHkVP50Zqf3v3iYHNw3o5CubzG3quD2NA04DuPZW2izGIt?=
 =?us-ascii?Q?cVBcQzycyamXI09G/3g0da0bZXCz5/cmOaXDVgnUoiVDswnkkgvK5gtwjFsD?=
 =?us-ascii?Q?28MFC2A4c6p3G/F3XRgSsVXXzrfr1UaOsnkcvUK8zu8U+Dmz3GQ8c5PuRSu2?=
 =?us-ascii?Q?vG+Yw6KhNzBbYZU9cp+ZcYqcYuU/6qT8suJon4BkluQTdSpNEHYymOB4sBeN?=
 =?us-ascii?Q?IOe3IOZo6f9oXo4e34ZjZd6XqWWZrL8dmXt+PyqsDs3qPlBg73gGyZeMMz7f?=
 =?us-ascii?Q?xuolrJ6/dIZ9baoQTtArp0Il/11eBe/P9jnYZiACvFWTw7BBwO2XuUl1BWOL?=
 =?us-ascii?Q?Hgl/y5YRsOXIJXNZnae8hfYesgOSbm6mvP1xEi2LbnqWmr+M/Aep2suy6XUL?=
 =?us-ascii?Q?CZr0IAAzFAHHGIw+C3RAsoE0iG8tXakIkPo6uEbT/tbvJ2BMNeb2B+bbcAxV?=
 =?us-ascii?Q?r+orDgUJU+Jkht1E8XA1eu9Q1BzQ8jI5MycxGSPRVegDc2Uh+/A4lTzlBjDD?=
 =?us-ascii?Q?SA7XJFedF63a9woyMu+Zvy0gpvtYXNsRM8Xb6pQFHBoaZ/SvpPuWxgVfxVa/?=
 =?us-ascii?Q?pXs/wxZdR4gHGYcG9SCWBbcsmTKvrqjICusdodC6ldm+WUWv9cT2+Smfbrs4?=
 =?us-ascii?Q?y3lzPL6q4XUcb4Tamw+MrleGYK1C8JD3NfoDdo3tZn8//BXx9Bb2bm7HqJq9?=
 =?us-ascii?Q?2vowFZlv7dVEXaB2kcgrJOl44wIzH/jPBpDfGDwR4dvXp2efdt2//sI9sMHs?=
 =?us-ascii?Q?IVFLvIt1FfLYsuIhJgmOxCM6JHXuLVyLTM/8SXcOdJb4R3BQgrZimy1aGI0L?=
 =?us-ascii?Q?hAEvtQRHlGM1c4mH1VKHJvT+CPCoalrU8CUEQWN9B7ea9tR7Ge/u0y31GtWs?=
 =?us-ascii?Q?PPWJLGRpkuwmxcDkl/pg0CmWg+Zsu3/cxMv8+IKDiSpQBohRIr0R04eNL8tL?=
 =?us-ascii?Q?wf9uiMrOZb3vshyCI8ypcdVW+85maMQmsPv8gODgtzt7OwMsBNHArjWD5oGH?=
 =?us-ascii?Q?zlGm3amNJc1rHhUojuIEgLib1+rf17vGe9ryETzSHW5IXSpXN34LD8vIXvwA?=
 =?us-ascii?Q?5xj7jxRLjLOzCVZKrrA41Pi5ulmPQFG0mHgnTSSmp2jojQHXRHb0q11Jr/Bt?=
 =?us-ascii?Q?sCGBBgv5L87q2NoPghc124grzJ6aH6VbUwTSe5Irly/7xdhSSCkhF4+a3bo6?=
 =?us-ascii?Q?6WwF+r9iHUIx4CZnMFK0YtZ0ucROeO8DqUZd5J2VK6UhMLNq2dL5zXq4JaVf?=
 =?us-ascii?Q?896K//9FtqD1eXMacCV787xMPEY6vt6TEpg3JctqXBI/TTw/p0cJidQhLt7K?=
 =?us-ascii?Q?G+NdU+xjjOOFfWkrVygAmeYw0P0I5lN2rDu8UrrhhWVP4vLgp/fQ2N1j7pg2?=
 =?us-ascii?Q?2aZudw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR11MB5812.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f53f3676-b646-4a7c-2b7f-08d9be160ce2
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Dec 2021 08:53:36.2948
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sDQv7jZbIUdix51FUcdmhFmRufAYQA1KDmkcZNmYYQ2bWbTHDzleMoifxWcQA8L5jeJhFQfjpN7+qnhJ0HoOvW2QQ/dfK4sKYaoAaygKEbU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1101MB2096
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Friday, December 10, 2021 5:17 PM
> To: Machnikowski, Maciej <maciej.machnikowski@intel.com>
> Cc: netdev@vger.kernel.org; intel-wired-lan@lists.osuosl.org; Kubalewski,
> Arkadiusz <arkadiusz.kubalewski@intel.com>; richardcochran@gmail.com;
> Byagowi, Ahmad <abyagowi@fb.com>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; davem@davemloft.net; linux-
> kselftest@vger.kernel.org; idosch@idosch.org; mkubecek@suse.cz;
> saeed@kernel.org; michael.chan@broadcom.com; petrm@nvidia.com;
> Vadim Fedorenko <vfedorenko@novek.ru>
> Subject: Re: [PATCH v5 net-next 0/4] Add ethtool interface for RClocks
>=20
> On Fri, 10 Dec 2021 14:45:46 +0100 Maciej Machnikowski wrote:
> > Synchronous Ethernet networks use a physical layer clock to syntonize
> > the frequency across different network elements.
> >
> > Basic SyncE node defined in the ITU-T G.8264 consist of an Ethernet
> > Equipment Clock (EEC) and have the ability to synchronize to reference
> > frequency sources.
> >
> > This patch series is a prerequisite for EEC object and adds ability
> > to enable recovered clocks in the physical layer of the netdev object.
> > Recovered clocks can be used as one of the reference signal by the EEC.
> >
> > Further work is required to add the DPLL subsystem, link it to the
> > netdev object and create API to read the EEC DPLL state.
>=20
> You missed CCing Vadim. I guess Ccing the right people may be right up
> there with naming things as the hardest things in SW development..
>=20
> Anyway, Vadim - do you have an ETA on the first chunk of the PLL work?

Sounds about right :) thanks for adding Vadim!
