Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC8B76C2150
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 20:25:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbjCTTZk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 15:25:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbjCTTYo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 15:24:44 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D192E41B50
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 12:17:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679339822; x=1710875822;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Hl0hA2b2D4oPzK8T3949cFI7bYAQwOuWUxpD7UNAIao=;
  b=lmTrAPbb+gEhCztnT7NHeGW37xQrW+w/9rDkg3myNgsRw9ZP3UevEFBY
   Pfj16EGzYG+C/Jd8lsy4WR5hOKK3zSYeQGgBdg7Q6hNDFZQ3ZfTnxXSOV
   WY7T7BI8K32E/GJhPLF4LIY5c7Kw9IL0JSQOOdpDRGQ6P3FOJBlmIFZmS
   yc3cEcIS/zNN1fYXoK9BNsVLMZD5VqHoKuTgSQ4TjEy+8Gu7j+I3z9Ql8
   vllMzEbFAl0Tx3u+IO4He7JSnOXXYnHTl7JVcd1ISXAi/o5yPL1FGVj45
   lVQIhkmCkJdp7Ss02xmvVEh6AZfWGhWwHyAO/ISBBUEltnCNrA7pf9d7/
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="338781948"
X-IronPort-AV: E=Sophos;i="5.98,276,1673942400"; 
   d="scan'208";a="338781948"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2023 12:14:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="713666857"
X-IronPort-AV: E=Sophos;i="5.98,276,1673942400"; 
   d="scan'208";a="713666857"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga001.jf.intel.com with ESMTP; 20 Mar 2023 12:14:45 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 20 Mar 2023 12:14:42 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 20 Mar 2023 12:14:42 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.109)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 20 Mar 2023 12:14:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DPoFzvMVUst235szerI/i+gHffKr/yLFQ4UhXws0MrE2FT7rLq58Y/fx1ShAFuczJqdLCt2N9pdfNlms+HJ9w5OE5bo6rQOQmXvSU5TMGieycyAlpTNlAB1u83RsIqldMpKh/SIf1ehiOvZ25UH9RO/jhnJHZq5AgJ014dphUMC88COAxZP+yjJELD9znX+51P2uSsbMQ/wgXhtlJFhhygsxrkssxtt8nuL2tofuJGL26Yb0i91sOwmtlUQ1fFDwtmFRNdey732W+0fE0FGG1UXWoIIuYMYmiecNnh468YmE6PKiUn2CnV9dtS2r5M74uvsp/sMZtMnrIYCKIpzgig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hl0hA2b2D4oPzK8T3949cFI7bYAQwOuWUxpD7UNAIao=;
 b=DTdIA+wpy852YRlwlPsZpa+6zozP90LubjKh2UDauTFfxh9DRJrEAtJtFkBCExw/jddmUl8nVd+iStldkaViF3Wqc4bkLM1Mn/MTCEEwOj5btYtbR2txgOm9oZ7Pk960VhA+7RgdObxKtLEFc3yyQAwQNKk40dKFLrAeaofi7ymaoRpO99BsDMhkM7DzckgJzA+3gUBqsOdSH5+Ea2F10+dh1VZxX3DLm3wQ9yqQdfWkyOih+DnTzUXaNyJpjUqPOGcD+NJJCQyi4FfbmfwgqQb/qkB2gzUOrjNbjDZg835QMOCvqPYb7X+JkylCveHswYebBMvsbTSU6CUeeIOvJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN6PR11MB4177.namprd11.prod.outlook.com (2603:10b6:405:83::31)
 by PH8PR11MB6610.namprd11.prod.outlook.com (2603:10b6:510:1cd::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Mon, 20 Mar
 2023 19:14:40 +0000
Received: from BN6PR11MB4177.namprd11.prod.outlook.com
 ([fe80::d4fb:c4c1:d85f:c8dc]) by BN6PR11MB4177.namprd11.prod.outlook.com
 ([fe80::d4fb:c4c1:d85f:c8dc%7]) with mapi id 15.20.6178.037; Mon, 20 Mar 2023
 19:14:36 +0000
From:   "Michalik, Michal" <michal.michalik@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
Subject: RE: [PATCH net v2] tools: ynl: Add missing types to encode/decode
Thread-Topic: [PATCH net v2] tools: ynl: Add missing types to encode/decode
Thread-Index: AQHZVzb583upM6gHck+8bIbecnjK9q781WiAgAc6npA=
Date:   Mon, 20 Mar 2023 19:14:36 +0000
Message-ID: <BN6PR11MB4177DBAC7674FB5321D6F63AE3809@BN6PR11MB4177.namprd11.prod.outlook.com>
References: <20230315120852.19314-1-michal.michalik@intel.com>
 <20230315214357.74396015@kernel.org>
In-Reply-To: <20230315214357.74396015@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN6PR11MB4177:EE_|PH8PR11MB6610:EE_
x-ms-office365-filtering-correlation-id: 1cbb6269-c14d-4f6d-9201-08db29775847
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iFYic339WKXreDN3LFynYpr3cQILVNNI5R/4I9FCyX6To3a6IB99FxqG1ffqFOuq7rlH+X7mtTP20lS5wZek6N4Yc+d0FOnQj8Y6pmYlBT7/uwB3UvuW2tpAXa9d4pbFLh02o/iuDYQYwoXFG8MtOdOdRgKdx5aLNT1Z+fMSaD3gE7RUmTj13XneNMIg+fqEcfkDPZ1T94oFwSruNZDsr0TeBaQiCnt5FlKXlVHimbWVVU6uX2w2hdZShlz48s+tOI3WP6P0FjXaTPTgOygj2YSub8QiCAAyB9tE7Nm4+61SCtpVYLFBZaetRLN2VIZ/ft4DG28leEdlXLENPx19VQggU71X2Mxagtaw9LZ7rZuFC5pm+VZBH9y9rVRf2CnnjRVdn6wYE3n2RiAUtNVNeX+lxrah90FdcfUUavxXIW5bTvXDifULlqNny0a9LJAo5Zrz8gwJcn5NrqGgU9fQ6vzpj55p5Vrocp2aLQo+UdIo+IR/p8ee8tFjPjGM1FFc7Jfy2CQFpaAhsz+Qc77JUwOzqL3CJhWbiWYONexXRh0y0oQzxGkN+AM/+nYo7DDpAfMCGdz57WAAcZfrNkiDIagvDfwmqP0Nn6dcdskBdJhRMVx1BNIpEpOeAWjtFJjuESdb/fkFJIP7xiYzQhNaGbpYg1qmPmQjuRQVHaDTNnN2Rg0nkXwDyYHnD8+pVPsL
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB4177.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(39860400002)(366004)(346002)(136003)(396003)(451199018)(52536014)(66476007)(54906003)(478600001)(8676002)(6916009)(76116006)(66946007)(66556008)(66446008)(64756008)(83380400001)(316002)(41300700001)(107886003)(966005)(2906002)(4326008)(7696005)(71200400001)(9686003)(26005)(6506007)(186003)(122000001)(82960400001)(86362001)(38070700005)(5660300002)(8936002)(55016003)(38100700002)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?OssSPAFQvJBAz6v4Fy3LvSkYeSXFDB/IFxA96EWxoJS2h3S60jKte+x7JMGz?=
 =?us-ascii?Q?UPhmNyYQW7SWVGwklmD4ELBRyBuuaT3MKUECUwomMeKPDFK0S7Uc3ntXb+yn?=
 =?us-ascii?Q?F9jaooUQ+aX3fOySNci3N0WgmtdYTCXcNd3gMrHXFBgUkXTCGFs4N0NtUs1k?=
 =?us-ascii?Q?Xm2xvr+Qi1G1U6NHRkdfeeczIN6LZ5gtUKiFoHPZcqVcbM5SQrfceUfiKmg1?=
 =?us-ascii?Q?n7bD4H2KAKJDINyKe/I19AJ2zh6eULhi0o34/vjgzLcNVi2qonybf+XyS+N4?=
 =?us-ascii?Q?zwqcpHDUx0xCpmJCj+D0ZvQ/TgMYn5067+/ayi9FeW/3Z9Cr1q26MsvQ9T9s?=
 =?us-ascii?Q?netvzxc9PKdGw4icRME81WwXMvnRssrYntYgZY3x9wL7K5uUgh9OS+KJ1Pin?=
 =?us-ascii?Q?EoC7eKr7VSmLOMqR4d87rQFwZD3xFcWg000NuJX/cRxlGeKWa9G4gb+ejrao?=
 =?us-ascii?Q?sThbZNNy/YWbkLAwiaSJ70EbSEyRqEIe3tn8rsKjEgT7Pq2CyQv3qE+hh/Wh?=
 =?us-ascii?Q?S6QrLOc7P8JTIhZ+ftHyuS50IQsNTxaN844zfntrbK5fxVM1qCpCGuQ3wIGU?=
 =?us-ascii?Q?ewMigWoSBugb5JlyaC27we5AZaRnRqvDUgbIu15YNvQ/fQ3J29UqvUSXepFG?=
 =?us-ascii?Q?kXFkousr/ucO0CDwEAMlkL+guCCOh5eZ55PFFVjCtiEf28J6PFwP9+sFFOFY?=
 =?us-ascii?Q?aAoyhW4WoJtWsM5KWNjDONwm2swE9hE0kAjvBITc/SWqUvr96ChUXq0XEF13?=
 =?us-ascii?Q?TeOwOMQjhrvxRq9tIEpxg72AsOt+3ilY5LSP1rnv49dksjFjV6Pv5m/k3LoK?=
 =?us-ascii?Q?pTCyaa+CvQExKGDSJyAW+IW4CBv+vLDzvKc013f4UplfMH3+eZmUwT0I16/q?=
 =?us-ascii?Q?v2dS4UDVrzzFRf7CA4vlOFCcCOSyvIxEqt8Jk9r4/RCLhgBeL5wGh71tCHf5?=
 =?us-ascii?Q?7zIVCoLLmGIiuO6I2BDTwRCtGpaIXGqpsvurVuD7J1NWEFNKSMwwj8TfcVhF?=
 =?us-ascii?Q?dNBws1SvXFKF+cWCBjuqJZDjJgVPn4udXUMStmqjDXA/xB5SeTdpxdzuGI7L?=
 =?us-ascii?Q?mMsAnRE3Jk7CfCbB9boGLJUZyL4F+RyfLJbnEMYM8/N5Gga1UcvIabCBVhe3?=
 =?us-ascii?Q?fdLkNFGEPWW8hx4M/sikDARvly7Me11+fqlaq1hVu+R9hE1evJtbTj8zHXaH?=
 =?us-ascii?Q?gihPgYgdPMsbiDJHDs9HaoPVg3TNZSinfBvLcm+7g5JKUdv33XWwRtuf+qDW?=
 =?us-ascii?Q?/1BSmKR6dl+Tec8NG/ne8oppZhrSDdhHeOEQPuoz7A3A7xeY8lRjZRGQlrH7?=
 =?us-ascii?Q?1bIi1NFf1D5Q+a4WVS2JH0gmxaXyoSQVA/5aD/HM3qYsbrCI+wtdRby9FD26?=
 =?us-ascii?Q?Mq9qcnyadpOaqmdu+RPBlPL2IeP5HMTCK/nw8BfTlWKR5VWBL9Smq7KJNNQq?=
 =?us-ascii?Q?YcpNju71MF/sv/Btq8+X7iNXkDlsK2KVJX+o2o5bWAiZQYLA8tCUm38puzOw?=
 =?us-ascii?Q?n20yuxUbP+c6beLqcty/eWVsOWd2+PkAR7ptp9BYyAKNHxiFj/xaMWXTctjT?=
 =?us-ascii?Q?ChkN3ZzBpv70QR0libMh1m2E1GFowibMXeQW2lNyh+fFmZl2Y5WrnuzP397o?=
 =?us-ascii?Q?Gg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB4177.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cbb6269-c14d-4f6d-9201-08db29775847
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Mar 2023 19:14:36.1364
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cjqgXp/Q0zIao09lBW9ShCFzNUrN5AysZzU0soirwLUI4jc+V/THtyvAq7jdLSb28Xo1yu3/4elP0nF8QI1VIxA4BuluXBOd7RHsBo7YUhs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6610
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>=20
Sent: Thursday, March 16, 2023 5:44 AM
>=20
> On Wed, 15 Mar 2023 13:08:52 +0100 Michal Michalik wrote:
>> While testing the tool I noticed we miss the u16 type on payload create.
>> On the code inspection it turned out we miss also u8 and u64 - add them.
>>=20
>> We also miss the decoding of u16 despite the fact `NlAttr` class
>> supports it - add it.
>=20
> Do we have any spec upstream which needs these?
> The patch looks good, but I think net-next is good enough?
>=20

Yes, I faced this issue while testing the tool for the DPLL interface
upstream efforts: (needed only u16, but fixed all missing)
https://lore.kernel.org/netdev/20230312022807.278528-4-vadfed@meta.com/T/

I agree - net-next should be sufficient, I will change the tree and
resend it.

>> Fixes: e4b48ed460d3 ("tools: ynl: add a completely generic client")
>> Signed-off-by: Michal Michalik <michal.michalik@intel.com>
>>=20
>> ---
>=20
> Please make sure there's no empty lines between the tags and the ---
> separator, it confuses the scripts.
>=20

Ohh - please excuse me, I was not aware of that. I will keep that in mind.
