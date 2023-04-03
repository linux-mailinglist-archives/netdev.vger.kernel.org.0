Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DBED6D41DE
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 12:21:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231928AbjDCKVk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 06:21:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbjDCKVb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 06:21:31 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B5E4198B;
        Mon,  3 Apr 2023 03:21:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680517288; x=1712053288;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=N1XsIflIcW5Nqcpb0uBKrbb/4hd2/GHFUwIBfVqAMrw=;
  b=LsLG1HfIasaymONad7w6VPC7hEgUwNIS6626SuS3+aW6pSyGWrTA6DaW
   Nrb1LpsgsjFfyibQzntnRjBk6yxvZ1R31jPV+CJDCuVikSMH6EwlYwVr8
   GVqkawpSyJrWLdBRVLGaPg7TOcaxfao2PPjsI+AzeprTQvQao1Ysm+0Bw
   +1rMJW7pt9PTBS+Cv7OQG0xqogL3eoJFqlQJWlU2MVsAvc34TPmJljFPd
   d1KHZl1DORDII7vF3bM/jerRPiFNfw0UZDTfCqzk7BGs1LMPywFcmp5pH
   t/zg0Q4bHBDJwYtnQWrDaBeOLdWXe8xfLQmWvTgmJBRPDi/IZDQHAJYsR
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10668"; a="325861389"
X-IronPort-AV: E=Sophos;i="5.98,314,1673942400"; 
   d="scan'208";a="325861389"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2023 03:21:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10668"; a="809794044"
X-IronPort-AV: E=Sophos;i="5.98,314,1673942400"; 
   d="scan'208";a="809794044"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga004.jf.intel.com with ESMTP; 03 Apr 2023 03:21:27 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 3 Apr 2023 03:21:27 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 3 Apr 2023 03:21:27 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 3 Apr 2023 03:21:27 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.49) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 3 Apr 2023 03:21:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d3Gz+LUeT7gb7Nx5p5NgP4Q5XlOV9Igr8ZDJhY0qzVothnPYBeIxN3CIaNQgXZlqv0Ai5gyGYGGIF76N3VhgsODrGdmq4KV6iPMB6TGSPL9AIuR3pcT9CXoi/BkNQmOa7OuvfqTnOZh64vfkDOHvr6ppPvMk8LsmcdjDW7uZaLohKkgj/P4pC9pFKEs3Fy8vPbURUJXHOUiOoB8v9/zArmsxYDmvdnLqlmWOxEjstsq+lQxnGXz8TuUwmshaSEDeyV4QJQExHd8DH1g8XlqO6Z9g3fD8IIVe4LUrEO92W8Wi2+YQEYMivX9pkGPOLsTpyR4ittrp4Yh4JqtVjR5eiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SXEaLYQNWA3wc0hApeNhnwCYweyQUsg01EdpJFbcydo=;
 b=lS35TSogbuOaVFCjhlJQ2YI59rAA9eU/fqA4rQ7NWdUkghQ517txW28UT4Iyj8NY1cW02rXqhvmJm4Ker77dtfyArjShRz5qLRaSPFPwc8rNjgAjuiq5WKO9gRjzjQlO86kQFogE/XwT32AVEiXcwCom4gSUX29/0YOGDK9pT9KrWeeH2SNnzutmaJNPrpgtanCJGeLoCnlb7JNPtQwMqgeVooNzF1wMuI8MXWBmJ4/ZHkdpmNQJZOJTLTPA6Xm6UgfezDyPomqjTHoVIJU3gOgbrEm33LPQyusySiSd4h796Bfl+skesArOa+U4NMjMrESPx8CNApbOgrGdrDXfrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) by
 PH7PR11MB7963.namprd11.prod.outlook.com (2603:10b6:510:246::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Mon, 3 Apr
 2023 10:21:24 +0000
Received: from DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::f829:c44d:af33:e2c8]) by DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::f829:c44d:af33:e2c8%4]) with mapi id 15.20.6254.033; Mon, 3 Apr 2023
 10:21:24 +0000
From:   "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
To:     Jiri Pirko <jiri@resnulli.us>, Vadim Fedorenko <vadfed@meta.com>
CC:     Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Vadim Fedorenko <vadim.fedorenko@linux.dev>,
        poros <poros@redhat.com>, mschmidt <mschmidt@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>
Subject: RE: [PATCH RFC v6 3/6] dpll: documentation on DPLL subsystem
 interface
Thread-Topic: [PATCH RFC v6 3/6] dpll: documentation on DPLL subsystem
 interface
Thread-Index: AQHZVIpnHLcQhYk8TUaWsBJuqa19SK76dxmAgB8LwLA=
Date:   Mon, 3 Apr 2023 10:21:23 +0000
Message-ID: <DM6PR11MB4657F10667E70EF7F71E155E9B929@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20230312022807.278528-1-vadfed@meta.com>
 <20230312022807.278528-4-vadfed@meta.com> <ZBCddQzjRHvYifzi@nanopsycho>
In-Reply-To: <ZBCddQzjRHvYifzi@nanopsycho>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4657:EE_|PH7PR11MB7963:EE_
x-ms-office365-filtering-correlation-id: 3c1b7e11-5141-443d-8407-08db342d2d24
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3XiUjfKJi1WgDQbw/Svf+zPXrAgPiYbMsVUeDPbSZTSMKlIM06u3uPFGQGvNPCyxPG3+UqVP+248sGFz/CW3i6SBrY7oLzimu1Fj7ki+UBialhOBqK9CNKPaf/oEg5Aixok/4L28V2b04ZAe0rzDkh2jMEJvMpl8x2ZdjafmVmX4HJ148ciK/ea8ek/3hP7iS5oCjWwkj59EGsjaI1ynxWlMt/53HuPQhxy4S1PmzqbXf+bB5a4bkuTB21GxpTP0jxK6TLrygTnzGLYN6Gl4qwFoJnNsQFAsS7+QrPDriK6bEyRLpuKP7HLjLbZ0M11yuQSKsi2G+Es8J1mFwAwCpe5ar6GZ4J6wTt6zriy6jzG8MYVOBJdQkgi9/S4gUO8cWaBFRK3fK+8Qb6g4lI4cNvxwzZr0THpQ74c1vAGWDDKMXyUlc7kdmQ3xFlSqcSITJTGXUeeJyAI9lO43YXoikrl2+JX0TeINeGb74w+VuEMqlM4gigYYn8HqrXcRPu15QOrTS4EKD7SHxYIi2UzlhO7p7p/mMKX8yc0EkNxdhuV4mFwXqJVhyMxcPKO0POnUxmGrMCwT2ycKt2j3Nexx/Kufdjb8HdaQDAelZPqvE5U5JtJXknjG6y+eU3g19mTD
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(39860400002)(376002)(396003)(366004)(136003)(451199021)(55016003)(4326008)(76116006)(8676002)(66946007)(66476007)(66446008)(64756008)(66556008)(478600001)(41300700001)(110136005)(316002)(54906003)(8936002)(30864003)(7416002)(5660300002)(122000001)(82960400001)(38100700002)(52536014)(186003)(83380400001)(7696005)(71200400001)(9686003)(6506007)(26005)(86362001)(33656002)(2906002)(38070700005)(66899021)(579004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Hy6CqWBnQn4pKX0Qvq0nzLbol9lTsqNxSi4J0SDbrz44nKs3mikEaQgvryBX?=
 =?us-ascii?Q?23zxizN//vMSmyn4HI159tkJyPLztYINFOEa16a/1P2bHdFwGaGiQH1SMHO0?=
 =?us-ascii?Q?I/6gn/TFfc9IxwtTNFC8BQsCcGllylDKq5UHVcoJfwuZgMNHQKQe16N2VCZX?=
 =?us-ascii?Q?HSNY7hdG86PbWInHawVUW1CcTj0xhSaaWa1LDj71F2Y2nvQb4BKkaPloQlV7?=
 =?us-ascii?Q?CwYMMNjzP6RkmM4V0eiyEZLTbphFyja8qlK5a3WFRSaLx3u/fetUd4a4DQ85?=
 =?us-ascii?Q?iXARMeST32a9X2BGfGmXLxCRm6wSKyaBhQ/KTKd9R+nEyaJdBbrkI2S4z17/?=
 =?us-ascii?Q?wKjDqD2OANEW3zBWB0zmqIMHMprt2AKd8Ug2cqKjRhx7qVop5uDglfeCB+bw?=
 =?us-ascii?Q?b/1i1f7DDJ9tcr6+Po5RFKaRfgGnW/EW168vRy27E5Wt8o1rPOMoTFoh6QwU?=
 =?us-ascii?Q?1ifHoLqExqluM+uLXpC4Lwna+nEdbxeBijDcUQV/TlrSstwdd13MeT6nZYJJ?=
 =?us-ascii?Q?zobKmPkW8R6lV1xRafe9UDrAjineGQgJvnAMN6fKcbM24e2tarFAuIdFjhA9?=
 =?us-ascii?Q?XWTFbmaYBQyoFnKmOF+fmfjoTAFOOjDq2zhddRjva/h4yVPfT+43Qo6O3Usc?=
 =?us-ascii?Q?Wk8pZYDRcMySHAM7WfWFy7CZXRkwVAeyP6TkA4ch3FqmBH/AhgZ/21pP4nvB?=
 =?us-ascii?Q?nuHx+NuqOil0QALeYq5BpW1L9rWqyqPsRKjKrUGh3aE4p0OwfCcud+el5A5V?=
 =?us-ascii?Q?DZ2b4kJ5gk6i6uoJMSvMaK0tBD6CIk2uKQF1wd+gKNl+3g3MT9PV+m01htBw?=
 =?us-ascii?Q?95/LQqir1JFwGJXBX72SubPU82pwTJIL3D631GtrMg2C/fjiIAw8Cb1pWJKr?=
 =?us-ascii?Q?AqCC+Z3FKq15c27SXgWszD/VTXUzLX0Sv0IuBYyCzml1FRVrX3OBA3o783VO?=
 =?us-ascii?Q?T0fuDwCT9I20tzQ3Zy3nvLC/OqwArg/VoanOD7MMYdVuStGNYb1WbLMyfHA+?=
 =?us-ascii?Q?NWextekIcpz4XHSogaDC5q7hqdc1Z0LN2+wbsQqeoB5WcZLUMZLUl+U5+O1J?=
 =?us-ascii?Q?0EGv4ls88CmNCITSRSWyMdEeMAJk9V8jo0T/062gXiao93Gwl0ABj5WCUEKF?=
 =?us-ascii?Q?KDi9v2//phkBMWIvMbE1+RcxGKp23lVFQJzKHDldwE5meei78UL/qGx0jshr?=
 =?us-ascii?Q?8gXjWxF4jcGD4DW85xHliy1xwYjKoZJlKw0GryUs1M015rnR3c+bwPa+QNGo?=
 =?us-ascii?Q?OlbSsSR3HaeSN2HYApLFPFNn9DyMaEcUcSTGDgmLGOq1/XF4wbMuWGIZCzkf?=
 =?us-ascii?Q?xylWu+gKHZDkOzlr6cD3XRky7JLIJwh7R2s6fGCyQ0b6pP68i++hjPL3x5zW?=
 =?us-ascii?Q?mXGFlKkH3T9rNt3qOIQKrovxxSs7D7r5znDNycUCVWNyLRP88z1hfKPz4hFg?=
 =?us-ascii?Q?Nj5z0WPlmlM9hr6CSSy/R8KuVTHmgHFYHbkxQx2q2mDjX8BZ4O4pxO/z8J/o?=
 =?us-ascii?Q?ZVmApkRipMEnP6I0PsRS6Qkb2WSBJWXcJGSC/YeMWIO4wo3QhGRDNhzoio9O?=
 =?us-ascii?Q?jYR4zAtNW2bjvquKFrC6EHJ0H/V/QdxRGjtp7OHJ0DMiVd2TUO/WITiYnxwO?=
 =?us-ascii?Q?Uw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c1b7e11-5141-443d-8407-08db342d2d24
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Apr 2023 10:21:23.8267
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fphiUhKzrRLabIZHr5MDeqCp+IqVDYR97/WzwMENRiSNP9W0KZuLINNenBMFA/NnRYCjGN85Qbrdk8aJfHCFytQdrVXaAxU1Nnb2k7rWMjo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7963
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>From: Jiri Pirko <jiri@resnulli.us>
>Sent: Tuesday, March 14, 2023 5:15 PM
>
>Sun, Mar 12, 2023 at 03:28:04AM CET, vadfed@meta.com wrote:
>>Add documentation explaining common netlink interface to configure DPLL
>>devices and monitoring events. Common way to implement DPLL device in
>>a driver is also covered.
>>
>>Signed-off-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
>>Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
>>---
>> Documentation/networking/dpll.rst  | 347 +++++++++++++++++++++++++++++
>> Documentation/networking/index.rst |   1 +
>> 2 files changed, 348 insertions(+)
>> create mode 100644 Documentation/networking/dpll.rst
>>
>>diff --git a/Documentation/networking/dpll.rst
>>b/Documentation/networking/dpll.rst
>>new file mode 100644
>>index 000000000000..25cd81edc73c
>>--- /dev/null
>>+++ b/Documentation/networking/dpll.rst
>>@@ -0,0 +1,347 @@
>>+.. SPDX-License-Identifier: GPL-2.0
>>+
>>+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
>>+The Linux kernel DPLL subsystem
>>+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
>>+
>>+
>>+The main purpose of DPLL subsystem is to provide general interface
>>+to configure devices that use any kind of Digital PLL and could use
>>+different sources of signal to synchronize to as well as different
>>+types of outputs.
>>+The main interface is NETLINK_GENERIC based protocol with an event
>>+monitoring multicast group defined.
>>+
>>+
>>+Dpll object
>
>rather perhaps "Device object"?
>

Sure, fixed.

>
>>+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>+Single dpll device object means single Digital PLL circuit and bunch of
>>+pins connected with it.
>>+It provides its capablities and current status to the user in response
>
>Which capabilities you have in mind. There is CAPs for pins, but I see
>none for device.
>

Ok, changed "capabilities" to "supported working modes".

>
>>+to the `do` request of netlink command ``DPLL_CMD_DEVICE_GET`` and list
>>+of dplls registered in the subsystem with `dump` netlink request of same
>>+command.
>>+Requesting configuration of dpll device is done with `do` request of
>>+netlink ``DPLL_CMD_DEVICE_SET`` command.
>>+
>>+
>>+Pin object
>>+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>+A pin is amorphic object which represents either input or output, it
>
>In the code and UAPI you use terms "source" and "output". Please align
>to that.
>

Sure, fixed.

>
>>+could be internal component of the device, as well as externaly
>>+connected.
>>+The number of pins per dpll vary, but usually multiple pins shall be
>>+provided for a single dpll device.
>>+Pin's properities and capabilities are provided to the user in response
>
>s/properities/properties/
>

Thanks, fixed.

>There is more provided, like "status" for example.
>

Makes sense, fixed.

>
>>+to `do` request of netlink ``DPLL_CMD_PIN_GET`` command.
>>+It is also possible to list all the pins that were registered either
>>+with dpll or different pin with `dump` request of ``DPLL_CMD_PIN_GET``
>
>I don't follow. Dump of DPLL_CMD_PIN_GET just dumps always all the pins
>in the system. Am I missing something?
>

Yes you are right, rephrased to make it clearer.

>
>>+command.
>>+Configuration of a pin can be changed by `do` request of netlink
>>+``DPLL_CMD_PIN_SET`` command.
>>+
>>+
>>+Shared pins
>>+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>+Pin can be shared by multiple dpll devices. Where configuration on one
>>+pin can alter multiple dplls (i.e. PIN_FREQUENCY, PIN_DIRECTION),
>>+or configure just one pin-dpll pair (i.e. PIN_PRIO, PIN_STATE).
>
>Perhaps this can be extended to something like this:
>
>A single pin object can be registered to multiple dpll devices.
>Then there are two groups of configuration knobs:
>1) Set on a pin - the configuration affects all dpll devices pin is
>   registered to. (i.e. PIN_FREQUENCY, PIN_DIRECTION),
>2) Set on a pin-dpll tuple - the configuration affects only selected
>   dpll device. (i.e. PIN_PRIO, PIN_STATE).
>
>

Makes sense, fixed.

>>+
>>+
>>+MUX-type pins
>>+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>+A pin can be MUX-type, which aggregates child pins and serves as pin
>>+multiplexer. One or more pins are attached to MUX-type instead of being
>>+directly connected to a dpll device.
>
>Perhaps you can say "registered" in stead of "connected" and "attached"
>so this is aligned with the function names?
>

Makes sense, fixed.

>
>>+Pins registered with a MUX-type provides user with additional nested
>
>s/provides/provide/
>

Sure, fixed.
=20
>
>>+attribute ``DPLL_A_PIN_PARENT`` for each parrent they were registered
>
>s/parrent/parent/
>
>I'm confused. Can one pin be registered to multiple parents? How is that
>supposed to be working?
>


As we have agreed, MUXed pins can have multiple parents.
In our case:
/tools/net/ynl/cli.py --spec Documentation/netlink/specs/dpll.yaml=20
--do pin-get --json '{"id": 0, "pin-idx":13}'
{'pin': [{'device': [{'bus-name': 'pci', 'dev-name': '0000:21:00.0_0',
'id': 0},
                     {'bus-name': 'pci',
                      'dev-name': '0000:21:00.0_1',
                      'id': 1}],
          'pin-description': '0000:21:00.0',
          'pin-direction': {'doc': 'pin used as a source of a signal',
                            'name': 'source'},
          'pin-idx': 13,
          'pin-parent': [{'pin-parent-idx': 2,
                          'pin-state': {'doc': 'pin disconnected',
                                        'name': 'disconnected'}},
                         {'pin-parent-idx': 3,
                          'pin-state': {'doc': 'pin disconnected',
                                        'name': 'disconnected'}}],
          'pin-rclk-device': '0000:21:00.0',
          'pin-type': {'doc': "ethernet port PHY's recovered clock",
                       'name': 'synce-eth-port'}}]}


I will add some more information and the example.

>
>>+with.
>>+Only one child pin can provide it's signal to the parent MUX-type pin at
>>+a time, the selection is done with requesting change of child pin state
>>+to ``DPLL_PIN_STATE_CONNECTED`` and providing a target MUX-type pin
>>+index value in ``DPLL_A_PARENT_PIN_IDX``
>>+
>>+
>>+Pin priority
>>+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>+Some devices might offer a capability of automatic pin selection mode.
>
>Tell the enum value.
>

Sure, fixed.

>
>>+Usually such automatic selection is offloaded to the hardware,
>>+which means only pins directly connected to the dpll are capable of
>>+automatic source pin selection.
>>+In automatic selection mode, the user cannot manually select a source
>>+pin for the device, instead the user shall provide all directly
>>+connected pins with a priority ``DPLL_A_PIN_PRIO``, the device would
>>+pick a highest priority valid signal and connect with it.
>>+Child pin of MUX-type are not capable of automatic source pin selection,
>
>s/are not/is not/
>

Thanks, fixed.

>
>>+in order to configure a source of a MUX-type pin the user still needs
>>+to request desired pin state.
>
>Perhaps emphasize that this is the state of the child?
>

Makes sense, fixed.

>
>>+
>>+
>>+Configuration commands group
>>+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
>>+
>>+Configuration commands are used to get or dump information about
>>+registered DPLL devices (and pins), as well as set configuration of
>>+device or pins. As DPLL device could not be abstract and reflects real
>>+hardware, there is no way to add new DPLL device via netlink from user
>>+space and each device should be registered by it's driver.
>>+
>>+All netlink commands require ``GENL_ADMIN_PERM``. This is to prevent
>>+any spamming/D.o.S. from unauthorized userspace applications.
>>+
>>+List of command with possible attributes
>>+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>+
>>+All constants identifying command types use ``DPLL_CMD_`` prefix and
>>+suffix according to command purpose. All attributes use ``DPLL_A_``
>>+prefix and suffix according to attribute purpose:
>>+
>>+  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>+  ``DEVICE_GET``                command to get device info or dump list
>>+                                of available devices
>>+    ``ID``                      attr internal dpll device ID
>>+    ``DEV_NAME``                attr dpll device name
>>+    ``BUS_NAME``                attr dpll device bus name
>>+    ``MODE``                    attr selection mode
>>+    ``MODE_SUPPORTED``          attr available selection modes
>>+    ``SOURCE_PIN_IDX``          attr index of currently selected source
>>+    ``LOCK_STATUS``             attr internal frequency-lock status
>>+    ``TEMP``                    attr device temperature information
>>+    ``CLOCK_ID``                attr Unique Clock Identifier (EUI-64),
>>+                                as defined by the IEEE 1588 standard
>>+    ``TYPE``                    attr type or purpose of dpll device
>>+  ``DEVICE_SET``                command to set dpll device configuration
>>+    ``ID``                      attr internal dpll device index
>>+    ``NAME``                    attr dpll device name (not required if
>>+                                dpll device index was provided)
>>+    ``MODE``                    attr selection mode to configure
>>+  ``PIN_GET``                   command to get pin info or dump list of
>>+                                available pins
>>+    ``DEVICE``                  nest attr for each dpll device pin is
>>+                                connected with
>
>Ah, now I understand what this is about. Didn't occur to me from the
>netlink UAPI :/
>

It's like assembling furniture without the manual :)

>
>>+      ``ID``                    attr internal dpll device ID
>>+      ``DEV_NAME``              attr dpll device name
>>+      ``BUS_NAME``              attr dpll device bus name
>>+      ``PIN_PRIO``              attr priority of pin on the dpll device
>>+      ``PIN_STATE``             attr state of pin on the dpll device
>>+    ``PIN_IDX``                 attr index of a pin on the dpll device
>>+    ``PIN_DESCRIPTION``         attr description provided by driver
>>+    ``PIN_TYPE``                attr type of a pin
>>+    ``PIN_DIRECTION``           attr direction of a pin
>>+    ``PIN_FREQUENCY``           attr current frequency of a pin
>>+    ``PIN_FREQUENCY_SUPPORTED`` attr provides supported frequencies
>>+    ``PIN_ANY_FREQUENCY_MIN``   attr minimum value of frequency in case
>>+                                pin/dpll supports any frequency
>>+    ``PIN_ANY_FREQUENCY_MAX``   attr maximum value of frequency in case
>>+                                pin/dpll supports any frequency
>>+    ``PIN_PARENT``              nest attr for each MUX-type parent, that
>>+                                pin is connected with
>>+      ``PIN_PARENT_IDX``        attr index of a parent pin on the dpll
>>+                                device
>>+      ``PIN_STATE``             attr state of a pin on parent pin
>>+    ``PIN_RCLK_DEVICE``         attr name of a device, where pin
>>+                                recovers clock signal from
>>+    ``PIN_DPLL_CAPS``           attr bitmask of pin-dpll capabilities
>>+
>>+  ``PIN_SET``                   command to set pins configuration
>>+    ``ID``                      attr internal dpll device index
>>+    ``BUS_NAME``                attr dpll device name (not required if
>>+                                dpll device ID was provided)
>>+    ``DEV_NAME``                attr dpll device name (not required if
>>+                                dpll device ID was provided)
>>+    ``PIN_IDX``                 attr index of a pin on the dpll device
>>+    ``PIN_DIRECTION``           attr direction to be set
>>+    ``PIN_FREQUENCY``           attr frequency to be set
>>+    ``PIN_PRIO``                attr pin priority to be set
>>+    ``PIN_STATE``               attr pin state to be set
>>+    ``PIN_PRIO``                attr pin priority to be set
>
>I think it would be good to emhasize which attribute is valid in which
>combination, meaning alone, dpll needs to be specified, parent pin needs
>to be specified
>

I agree, we need to do something like it.

>
>>+    ``PIN_PARENT_IDX``          attr if provided state is to be set with
>>+                                parent pin instead of with dpll device
>>+
>>+Netlink dump requests
>>+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>+
>>+The ``DEVICE_GET`` and ``PIN_GET`` commands are capable of dump type
>>+netlink requests. Possible response message attributes for netlink dump
>>+requests:
>>+
>>+  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>+  ``PIN_GET``                     command to dump pins
>
>Maintain the order and start with DEVICE_GET
>

Sure, fixed.

>
>
>>+    ``PIN``                       attr nested type contains single pin
>>+      ``DEVICE``                  nest attr for each dpll device pin is
>>+                                  connected with
>>+        ``ID``                    attr internal dpll device ID
>>+        ``DEV_NAME``              attr dpll device name
>>+        ``BUS_NAME``              attr dpll device bus name
>>+      ``PIN_IDX``                 attr index of dumped pin (on dplls)
>>+      ``PIN_DESCRIPTION``         description of a pin provided by drive=
r
>>+      ``PIN_TYPE``                attr value of pin type
>>+      ``PIN_FREQUENCY``           attr current frequency of a pin
>>+      ``PIN_FREQUENCY_SUPPORTED`` attr provides supported frequencies
>>+      ``PIN_RCLK_DEVICE``         attr name of a device, where pin
>>+                                  recovers clock signal from
>>+      ``PIN_DIRECTION``           attr direction of a pin
>>+      ``PIN_PARENT``              nest attr for each MUX-type parent,
>>+                                  that pin is connected with
>>+        ``PIN_PARENT_IDX``        attr index of a parent pin on the dpll
>>+                                  device
>>+        ``PIN_STATE``             attr state of a pin on parent pin
>>+
>>+  ``DEVICE_GET``                  command to dump dplls
>>+    ``DEVICE``                    attr nested type contatin a single
>>+                                  dpll device
>>+      ``ID``                      attr internal dpll device ID
>>+      ``DEV_NAME``                attr dpll device name
>>+      ``BUS_NAME``                attr dpll device bus name
>
>Hmm, why you need to repeat this for dump? Just say the message format
>is the same as for DO and you are done with it.
>

Yeah. Fixed.

>
>>+
>>+
>>+Dpll device level configuration pre-defined enums
>>+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>+
>>+For all below enum names used for configuration of dpll device use
>>+the ``DPLL_`` prefix.
>>+
>>+Values for ``DPLL_A_LOCK_STATUS`` attribute:
>>+
>>+  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>+  ``LOCK_STATUS_UNLOCKED``      DPLL is in freerun, not locked to any
>>+                                source pin
>>+  ``LOCK_STATUS_CALIBRATING``   DPLL device calibrates to lock to the
>>+                                source pin signal
>>+  ``LOCK_STATUS_LOCKED``        DPLL device is locked to the source
>>+                                pin frequency
>>+  ``LOCK_STATUS_HOLDOVER``      DPLL device lost a lock, using its
>>+                                frequency holdover capabilities
>>+
>>+Values for ``DPLL_A_MODE`` attribute:
>>+
>>+  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>+  ``MODE_FORCED``     source pin is force-selected by setting pin
>>+                      state to ``DPLL_PIN_STATE_CONNECTED`` on a dpll
>>+  ``MODE_AUTOMATIC``  source pin is auto selected according to
>>+                      configured pin priorities and source signal
>>+                      validity
>>+  ``MODE_HOLDOVER``   force holdover mode of DPLL
>>+  ``MODE_FREERUN``    DPLL is driven by supplied system clock without
>>+                      holdover capabilities
>>+  ``MODE_NCO``        similar to FREERUN, with possibility to
>>+                      numerically control frequency offset
>>+
>>+Values for ``DPLL_A_TYPE`` attribute:
>>+
>>+  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>+  ``TYPE_PPS``  DPLL used to provide pulse-per-second output
>>+  ``TYPE_EEC``  DPLL used to drive ethernet equipment clock
>>+
>>+
>>+
>>+Pin level configuration pre-defined enums
>>+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>+
>>+For all below enum names used for configuration of pin use the
>>+``DPLL_PIN`` prefix.
>>+
>>+Values for ``DPLL_A_PIN_STATE`` attribute:
>>+
>>+  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>+  ``STATE_CONNECTED``     Pin connected to a dpll or parent pin
>>+  ``STATE_DISCONNECTED``  Pin disconnected from dpll or parent pin
>>+
>>+Values for ``DPLL_A_PIN_DIRECTION`` attribute:
>>+
>>+  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
>>+  ``DIRECTION_SOURCE``    Pin used as a source of signal
>>+  ``DIRECTION_OUTPUT``    Pin used to output signal
>>+
>>+Values for ``DPLL_A_PIN_TYPE`` attributes:
>>+
>>+  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>+  ``TYPE_MUX``             MUX type pin, connected pins shall have
>>+                           their own types
>>+  ``TYPE_EXT``             External pin
>>+  ``TYPE_SYNCE_ETH_PORT``  SyncE on Ethernet port
>>+  ``TYPE_INT_OSCILLATOR``  Internal Oscillator (i.e. Holdover with
>>+                           Atomic Clock as a Source)
>>+  ``TYPE_GNSS``            GNSS 1PPS source
>>+
>>+Values for ``DPLL_A_PIN_DPLL_CAPS`` attributes:
>>+
>>+  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>+  ``CAPS_DIRECTION_CAN_CHANGE`` Bit present if direction can change
>>+  ``CAPS_PRIORITY_CAN_CHANGE``  Bit present if priority can change
>>+  ``CAPS_STATE_CAN_CHANGE``     Bit present if state can change
>>+
>>+
>>+Notifications
>>+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>+
>>+DPLL device can provide notifications regarding status changes of the
>>+device, i.e. lock status changes, source/output type changes or alarms.
>>+This is the multicast group that is used to notify user-space apps via
>>+netlink socket: ``DPLL_MCGRP_MONITOR``
>>+
>>+Notifications messages (attrbiutes use ``DPLL_A`` prefix):
>>+
>>+  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>+  ``EVENT_DEVICE_CREATE``   event value new DPLL device was created
>>+    ``ID``                  attr internal dpll device ID
>>+    ``DEV_NAME``            attr dpll device name
>>+    ``BUS_NAME``            attr dpll device bus name
>>+  ``EVENT_DEVICE_DELETE``   event value DPLL device was deleted
>>+    ``ID``                  attr dpll device index
>>+  ``EVENT_DEVICE_CHANGE``   event value DPLL device attribute has
>>+                            changed
>>+    ``ID``                  attr modified dpll device ID
>>+    ``PIN_IDX``             attr the modified pin index
>>+
>>+Device change event shall consiste of the attribute and the value that
>>+has changed.
>>+
>>+
>>+Device driver implementation
>>+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
>>+
>>+Device is allocated by ``dpll_device_get`` call. Second call with the
>>+same arguments doesn't create new object but provides pointer to
>>+previously created device for given arguments, it also increase refcount
>>+of that object.
>>+Device is deallocated by ``dpll_device_put`` call, which first decreases
>>+the refcount, once refcount is cleared the object is destroyed.
>>+
>>+Device should implement set of operations and register device via
>>+``dpll_device_register`` at which point it becomes available to the
>>+users. Only one driver can register a dpll device within dpll subsytem.
>
>"Driver instance". Btw, I need to change it for mlx5. I will try to
>implement it in coming days.
>

Sure, fixed.

>
>>+Multiple driver instances can obtain reference to it with
>>+``dpll_device_get``.
>>+
>>+The pins are allocated separately with ``dpll_pin_get``, it works
>>+similarly to ``dpll_device_get``. Creates object and the for each call
>>+with the same arguments the object refcount increases.
>>+
>>+Once DPLL device is created, allocated pin can be registered with it
>
>In this text, you use "dpll", "Dpll", "DPLL". Could you unify?
>

Sure, fixed.

>
>
>>+with 2 different methods, always providing implemented pin callbacks,
>>+and private data pointer for calling them:
>>+``dpll_pin_register`` - simple registration with a dpll device.
>>+``dpll_pin_on_pin_register`` - register pin with another MUX type pin.
>>+
>>+For different instances of a device driver requiring to find already
>>+registered DPLL (i.e. to connect its pins to id) use ``dpll_device_get``
>
>s/to id/to it/
>

Thanks, fixed.

>
>>+to obtain proper dpll device pointer.
>>+
>>+The name od DPLL device is generated based on registerer provided device
>
>s/name od/name of/

Thanks, fixed.

>
>
>>+struct pointer and dev_driver_id value.
>>+Name is in format: ``%s_%u`` witch arguments:
>>+``dev_name(struct device *)`` - syscall on parent device struct
>>+``dev_driver_idx``            - registerer given id
>>+
>>+Notifications of adding or removing DPLL devices are created within
>>+subsystem itself.
>>+Notifications about registering/deregistering pins are also invoked by
>>+the subsystem.
>>+Notifications about dpll status changes shall be requested by device
>>+driver with ``dpll_device_notify`` corresponding attribute as a reason.
>>+
>>+There is no strict requirement to implement all the operations for
>>+each device, every operation handler is checked for existence and
>>+ENOTSUPP is returned in case of absence of specific handler.
>
>Not sure internal implementation details are necessary. Just say that
>driver is free to implement a set of ops it supports, leave the rest not
>implemented.
>

Hmm, actually this sentence is not true.
Some commands are required - as we WARN about them...
I will list them there.


Thank you,
Arkadiusz
>
>>+
>>diff --git a/Documentation/networking/index.rst
>b/Documentation/networking/index.rst
>>index 4ddcae33c336..6eb83a47cc2d 100644
>>--- a/Documentation/networking/index.rst
>>+++ b/Documentation/networking/index.rst
>>@@ -17,6 +17,7 @@ Contents:
>>    dsa/index
>>    devlink/index
>>    caif/index
>>+   dpll
>>    ethtool-netlink
>>    ieee802154
>>    j1939
>>--
>>2.34.1
>>
