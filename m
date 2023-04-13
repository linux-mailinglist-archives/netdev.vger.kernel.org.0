Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63B436E0F19
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 15:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231310AbjDMNps (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 09:45:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231211AbjDMNpc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 09:45:32 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC334B44A;
        Thu, 13 Apr 2023 06:44:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681393493; x=1712929493;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=KxxEPlU2/GpXQN7ePcEQZMNuqId2Sz13OwtZrosQQSU=;
  b=KyDZ+FRwAOaGID4mb9Bdwk0xD9m1nBe6MkqarKTFmCyvu46ehQJMMpm0
   BLQV4jNUoalJt43I3yu1lP3Q5i9HuqIUtHHZvazxIDoi+6gRVWn35e7fe
   I+Gk9fcrZQOcMyQPuRhHOBajN6o6heUE3aMxQthw2AC5ZSZijNHhuMWQX
   ZduLU7U6yZOBYHCN0vSMCGvpf39rKcg/ApeKSPXBY6rTJP6CyYP7UpFnf
   9C8uI831A01XpdL5lpfYCdRW8STrNF4wjtT6lgrsWlu9qpJeuePvxHyin
   mpoe4PQMKGXVdNWj6hFwZfIEz99BjB21UiGugO8YzANnPeJIgHUFTOCyl
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="430471558"
X-IronPort-AV: E=Sophos;i="5.99,193,1677571200"; 
   d="scan'208";a="430471558"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2023 06:43:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="639669963"
X-IronPort-AV: E=Sophos;i="5.99,193,1677571200"; 
   d="scan'208";a="639669963"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga003.jf.intel.com with ESMTP; 13 Apr 2023 06:43:55 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 13 Apr 2023 06:43:55 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 13 Apr 2023 06:43:55 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 13 Apr 2023 06:43:55 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.40) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 13 Apr 2023 06:43:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MrenhII4w3Q6VrvpdDJxCH18x4jnitvHfq2uNyOVWFWYCIIb5Nn+MLHlcXmL5zeJreFdklmtnpH/S75SkiwwGVk2mUYVGqDfcbLKVi5nKewG3aqRp8sOeXD4jZNt4eGKwwx6bk3uEHvg1EfHeBUbUQUmu7iSeXo1WOti5e1CTZ9XpFYWeakLG9FD3Ao5j/LMVr16ajYiV5Z4dY+rwTH9zMJyYyvRhJU3evKh/h1N85300TpmuMxJZoN4AsrVE1/Rkfa4YfZgsCzDkVAWUQC3VVSXTsriT7T/hEnoavUHt8xe9161JZvGASYveWsVD/ZGoYFSQP0LSPAqCTOwUKFrYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZfYzvBHpQaWDLvRi9YMzOzDmcgA5CjJFA6/hUOGIAnk=;
 b=TnedY5+x4MTKBYeDIcyd0DEcogw3Ffi6XtAIzseuJ0uQ6LnL4mqFdbfeOI8qFFiI4jZSABBry2l6WkRqY2f+3zO6fi+6mrED8K2wFUfUILVg/fcAi4PMsCKCv3gxkA1d1BQb3LKsIoWjZcWK/A4KY6HwKfPDNwMWqc9P89UVUfte3ZieM+GU8IFxMMi2tLx+022A1gW5Qqp/QLnhROawqDUKS6PJokmM5M12bYTP95eYIc/vEesr0of1CA0sYgglqtRUfe8GFuekPXonPEjhmeLHXjAatVr/0Ml64g8EeBd82+/TR7ThKLAXnZGdK1B//sQm2vKSiL42OWmxERWv5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) by
 SA3PR11MB8118.namprd11.prod.outlook.com (2603:10b6:806:2f1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Thu, 13 Apr
 2023 13:43:53 +0000
Received: from DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::f829:c44d:af33:e2c8]) by DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::f829:c44d:af33:e2c8%4]) with mapi id 15.20.6298.030; Thu, 13 Apr 2023
 13:43:52 +0000
From:   "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "jiri@resnulli.us" <jiri@resnulli.us>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Subject: RE: [RFC PATCH v1] ice: add CGU info to devlink info callback
Thread-Topic: [RFC PATCH v1] ice: add CGU info to devlink info callback
Thread-Index: AQHZbURL//7N1kf7H06LoNzMTKXBn68ol1EAgACoMpA=
Date:   Thu, 13 Apr 2023 13:43:52 +0000
Message-ID: <DM6PR11MB46577E14FE17ADA6D1E74E789B989@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20230412133811.2518336-1-arkadiusz.kubalewski@intel.com>
 <20230412203500.36fb7c36@kernel.org>
In-Reply-To: <20230412203500.36fb7c36@kernel.org>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4657:EE_|SA3PR11MB8118:EE_
x-ms-office365-filtering-correlation-id: 4e724ec1-0654-4d66-5744-08db3c251e7c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tMzxMQvCHdaRzaF12tUpylcE4bmC/A3iODEtX/UyDSaGMV6F69rotxJx38Ww+F/E1dkB6Az8ax32nszXEbgHvQRjoEUYElGr5FfQZXcLqEP6XMF6g1JS13wLdxqHHXXSv0qrIjoN41dNKbq8ksuzaXY/Jl+2+W0Tom0tnlxDM24F+7GTT+nwFiu71VcxvlGpiOx8kcZSmolVxWi9laLOSgX8+22XT5nvxumaM/N/7t89CNJ+PDQyIgY2CV3Z7JERtuBTwlrWzEMqxmfbqdc1sc+9+yKw1eHvr/TvmbAUL8+C4NcPXoQFnE2RcGw71RLS0t5Ziar7KMxJurDiB9QnZacz6B5yMFZjyPdVIpcWqvR/QBMBvNY9jpH3EsWYTS+hBrsk+GTRBJmZQe02g4wlIZOkOl/ANrpgV83dI4xLwJUSVj4ZCxkMYLnJ2ppXCss0bJe0OHWNVpAFsBhL/MFmY+ukRqLcRU+M6gEkMj0+dMG64JDn2/IRbw0jTDjcdVrC96oQ+KCc6sjTCd02BS5AfDFnXyNnV6WrxMF5D1AzY1uRaeal1LhyXhngUFH+cyR/XIcYV6izClw1TF3jDWnEBuQ2WxP+YY+pTr8ZM/+qQAUArmkF8jFviM26cat+29t3
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(376002)(346002)(396003)(39860400002)(366004)(451199021)(478600001)(33656002)(54906003)(38070700005)(7416002)(82960400001)(52536014)(5660300002)(8936002)(8676002)(64756008)(66446008)(76116006)(4326008)(66476007)(66946007)(6916009)(66556008)(122000001)(316002)(2906002)(38100700002)(55016003)(7696005)(41300700001)(6506007)(9686003)(26005)(83380400001)(186003)(86362001)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?uBUQZ+OGATfGJVfHOVIgCMWlToDB1Cawo5F10j7gykg2CG8tz1SpWkYOBW6Q?=
 =?us-ascii?Q?uMlqyPV2PisGTxw8T7PoRiIzliaP5I9CX3QFXhdMpb+j6qldBhV38Jb/z7C3?=
 =?us-ascii?Q?PX0hECER6SrQ/ID9ZwTdXvyzGnlGWd2817vtSQZyaxSZ8p7LtkTj/I7fHDW7?=
 =?us-ascii?Q?OYgmoUjN5i6fyusdmkIVTWqDPUGBI7/CaO5ow09OKTD6l4sD2pM2tBcb1FwK?=
 =?us-ascii?Q?XcR3ROReXyfudQsOngALA/tH1lKff7U5z+WFW0efZeiE1QK9cIpIZwHmOkj2?=
 =?us-ascii?Q?v9tVbkMC8O34sb2YwDmsnNAFW05vW0xCQYQ77yhZx++MEhm/MGoWqunSRpoG?=
 =?us-ascii?Q?FrKD9CW4R1VadMpD4SK6joGq0mDfyhC2l0GhqHxpawFEN9F+E1ytd27R9MYo?=
 =?us-ascii?Q?zxyuxIeR8Mtz1TyAknDPjZgiNvMful8r+/TH33kisuwr5R7ZgksX6xWdmyhb?=
 =?us-ascii?Q?eZfvQ1BokHslxETcdrRnoBh7wnWZhtrmg7hK+SdatYB88JWY34UTC8XKR/zB?=
 =?us-ascii?Q?bG2OZEAz3MOFyMTiZoRXgr3C7ykHjysmiCrTFNtc6AZ6sm5J015iouN8q97v?=
 =?us-ascii?Q?BacNDQZicdR05EzNYCvrH+3JwY8bRO456x2t/jSg/naixlvMk6fluyl8S6yW?=
 =?us-ascii?Q?Ewwmb/CSJPzy+3DXkVlXzAl5m7k21H6iOsNi64yUfYO8JXne8SdSc7mQmNDg?=
 =?us-ascii?Q?v0hftvOVtq6dLj6V9HNJQIdlr47QjDwcULVirmWOcs/7WK3qITFj+3/T8ghO?=
 =?us-ascii?Q?5cw2JMsQJ/xR8+WgDmNqBrwUdzQ8P1IQJkfZlwlDnfSCqsj5A4WDyI2N/P/u?=
 =?us-ascii?Q?sRaLd7mUWtjdLVHX3bPYHpiE31Ge/sFMlnlL7nYJaePfoZ8Vj/iFHuz8TsJ5?=
 =?us-ascii?Q?SlbrjI2ApZm4FXDlbmQXV0qBVn+LJUXE45gw9B7PPCLhdu7gXEU/KuWpLkZd?=
 =?us-ascii?Q?cPoGVMXEbR7QtizBv7Mhob5D+O3PC5SeQkevOhmI7LcraJ/FgGWmys/E6X7i?=
 =?us-ascii?Q?PD5M/doowmK5u4iTYOaByO4RMA9KF8T7ngIPXvl/MJPXhcqGtgHsj0G6UHRF?=
 =?us-ascii?Q?c4jrcq9jPAgrPtn6bRSTRycMPxlJjT5JM97iasdFwWSdzgROdtGt0geKHwkT?=
 =?us-ascii?Q?9KZYS/U1baAPSYfJZl8LZvnDVEK9ZeRBkIQBHrWePrayZg6u0GH7/jxeYnNX?=
 =?us-ascii?Q?fn78jL2NOGIderjHhys5yzb9HzSec4y6omh0xWZhj0K3G4VAtiY2Xawacbwj?=
 =?us-ascii?Q?TYXwDx7xhlnbC0xbJ0qTyUqjXViuDZCXtYz6etANc5xVCmLBObf/ZX7c3x5f?=
 =?us-ascii?Q?0MpuGZKaZNdi8SrhXrMy0qc9lr9+zVARSd5U56oJAhJ01GHUdSEmDuxVnls0?=
 =?us-ascii?Q?ouu2njPmD3/7I4jCT2s8Pyg0yx0xos4mNtMvdwIBJjPQLKg3nc8bgL7GzMqz?=
 =?us-ascii?Q?jDbUlgYX3ZKL/HDOmWUk/9RXQMxKEhC9gyX1FAmpwWKan1heDR9ZbY2VNqbt?=
 =?us-ascii?Q?blFUxlvlh83fH/lir/ym5h0+vu+IK2IEgqhs5sMV1kiH6ij0BRJR8yR7wIGY?=
 =?us-ascii?Q?5wkOyYlrvl0It2my3yY3YaXt0sr6blaufP83K4H0sOYle3dZUr2+32uUI1Jd?=
 =?us-ascii?Q?/Q=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e724ec1-0654-4d66-5744-08db3c251e7c
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Apr 2023 13:43:52.5901
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UVsSGCjZKUgJXoByPHEH6+QZ+TI8Ur88Ck78xLToOpTT8BY4PB7s5dPtnKyF+s/bMbJx254dhsja3NgYNOvZ8UCo/28Cy7Kf/g1koK4N6s0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB8118
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>From: Jakub Kicinski <kuba@kernel.org>
>Sent: Thursday, April 13, 2023 5:35 AM
>
>On Wed, 12 Apr 2023 15:38:11 +0200 Arkadiusz Kubalewski wrote:
>> If Clock Generation Unit and dplls are present on NIC board user shall
>> know its details.
>> Provide the devlink info callback with a new:
>> - fixed type object `cgu.id` - hardware variant of onboard CGU
>> - running type object `fw.cgu` - CGU firmware version
>> - running type object `fw.cgu.build` - CGU configuration build version
>>
>> These information shall be known for debugging purposes.
>>
>> Test (on NIC board with CGU)
>> $ devlink dev info <bus_name>/<dev_name> | grep cgu
>>         cgu.id 8032
>>         fw.cgu 6021
>>         fw.cgu.build 0x1030001
>>
>> Test (on NIC board without CGU)
>> $ devlink dev info <bus_name>/<dev_name> | grep cgu -c
>> 0
>>
>> Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
>
>Is it flashed together with the rest of the FW components of the NIC?
>Or the update method is different?

Right now there is no mechanics for CGU firmware update at all, this is why=
 I
mention that this is for now mostly for debugging purposes.
There are already some works ongoing to have CGU FW update possible, first =
with
Intel's nvmupdate packages and tools. But, for Linux we probably also gonna
need to support update through devlink, at least this seems right thing to =
do,
as there is already possibility to update NIC firmware with devlink.

Thank you!
Arkadiusz
