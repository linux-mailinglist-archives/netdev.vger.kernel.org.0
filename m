Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3FDC64BB9D
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 19:08:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236507AbiLMSIi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 13:08:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236479AbiLMSIa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 13:08:30 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F3C7248E2;
        Tue, 13 Dec 2022 10:08:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670954900; x=1702490900;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=w4/NiVdq0hnfPpxluaxToUUvgQ/HUAkzY3UAhH4lhTk=;
  b=TIFXhvpsRTwZaUsA6OmbdV5j5FHzT5J1QsvwXnIACzTkSkWgbJA9gMIK
   9uNnv2lZDLUfm+NvRoQJ26Uv2FK2FNSIiZEDfpDUM/8ECyflWH1S/mpLM
   WqOrj4ZxEvrmjbBrmK8zt1Kix8lVRjB7o8vevuZVST6BLHWA3NJCqhfPM
   DPZXWLBmrUqslSG7EvMngsCJ1wiCJnFbxiM/4RjxnJ+lT6PNPpCmjDwoy
   gP4b4WzBkuf45JHfBWWe7Tp56BdzZmr8+8aUmmFMQBr4ZNYlC6DL8l72z
   ICjE7BdwhPIhcfX5SX8x76cxosGDUJYjCfOAoXX61Z6/b4KhIPkKQOhu4
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10560"; a="315837468"
X-IronPort-AV: E=Sophos;i="5.96,242,1665471600"; 
   d="scan'208";a="315837468"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2022 10:08:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10560"; a="893990344"
X-IronPort-AV: E=Sophos;i="5.96,242,1665471600"; 
   d="scan'208";a="893990344"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga006.fm.intel.com with ESMTP; 13 Dec 2022 10:08:16 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 13 Dec 2022 10:08:15 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 13 Dec 2022 10:08:15 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 13 Dec 2022 10:08:15 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.103)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 13 Dec 2022 10:08:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c0LLDArGA3e6CNdwGg4SIFrjrd55IjIEbE4DcqyA2XPwY/aSR1mC4kDTrnYP0+5K6Zxy3mDxqOZTJlje6ALSEazT0FxE2hlpUUu02Dqc8IHhLFYHO5oi5p53PZ3m3kbBZR4ngts5BujzNRfK+0Tjo71nrN3vgaFVBYyDEhdn1CF5h2iuDa+8EEfaxQqnQXHyMZctZVJ9+bu1pRw6bepgGUH3SbKEOwGHHCn1qoK/ESxJjT88HAidMVqlJFIy8FVZvW1sj4Mf7Uli6OulEQOA6D20YT7qe6BP5G+G7eWZ/slNuxoX5SbEcpQNjzOOUB2qK+GLdgdi3WEpCl7B5zT0Rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HlMMaRoK/EEuOTVvuJUmmfOUrfuFG8ryM4NbfcCwHB4=;
 b=WhCbvJB4raxz3GsAQGVQuoHwhNSw1G5DfX/WzE1Blu0sXxnNGA+y0rPRuhgVbI/K4fGEdpmgTeGTiO4/pFkPR6Cnyau5d+pPPoJ57b5JU4naaaKOMHq6Uau627RjgXaQWjfpimvgBtWO8limbwspZNKsFEk5ye1cbR5O8fn0sB/9rRHlODhpG5KUbp4s9Jb45hYg9vtoHJ3zBSOx4WqQ9+BQHbfNv8+8E6dPy3is7T8ihNx1ztrMppFoDBri6snxyU7AmGCrN/k/yD+Tg+nQO+kdw7auhjETsrEQkcjLSqALnQMSaB1GkKywBqgW0FrncxPss0zVQZPa7OiUYh890Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) by
 SN7PR11MB7417.namprd11.prod.outlook.com (2603:10b6:806:345::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Tue, 13 Dec
 2022 18:08:13 +0000
Received: from DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::5006:f262:3103:f080]) by DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::5006:f262:3103:f080%7]) with mapi id 15.20.5880.019; Tue, 13 Dec 2022
 18:08:13 +0000
From:   "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
To:     Jiri Pirko <jiri@resnulli.us>, Jakub Kicinski <kuba@kernel.org>
CC:     Vadim Fedorenko <vfedorenko@novek.ru>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vadim Fedorenko <vadfed@fb.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>,
        "Olech, Milena" <milena.olech@intel.com>,
        "Michalik, Michal" <michal.michalik@intel.com>
Subject: RE: [RFC PATCH v4 2/4] dpll: Add DPLL framework base functions
Thread-Topic: [RFC PATCH v4 2/4] dpll: Add DPLL framework base functions
Thread-Index: AQHZBDrzHhOO6jCKv0uW33ic8hB1f65Xq5eAgALEiZCAAB2ugIAAIBXAgAAcNoCAANvPAIADe0QAgADnMoCAAI61gIAAkGKAgAFKswCAAD/6gIAA/5sAgACHnYCAAAPKAIAACOOAgAETGICAAHKBAIAEiX0AgAHYJvA=
Date:   Tue, 13 Dec 2022 18:08:13 +0000
Message-ID: <DM6PR11MB46577F9AB422103140778D529BE39@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <Y48CS98KYCMJS9uM@nanopsycho> <20221206092705.108ded86@kernel.org>
 <Y5CQ0qddxuUQg8R8@nanopsycho> <20221207085941.3b56bc8c@kernel.org>
 <Y5Gc6E+mpWeVSBL7@nanopsycho> <20221208081955.335ca36c@kernel.org>
 <Y5IR2MzXfqgFXGHW@nanopsycho> <20221208090517.643277e8@kernel.org>
 <Y5MAEQ74trsNFQQc@nanopsycho> <20221209081942.565bc422@kernel.org>
 <Y5cucrZjsMgZcHDf@nanopsycho>
In-Reply-To: <Y5cucrZjsMgZcHDf@nanopsycho>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4657:EE_|SN7PR11MB7417:EE_
x-ms-office365-filtering-correlation-id: 5fc88a11-bba5-46d4-17fc-08dadd35003b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CsI+wWcKvpn/yRZ9vpHMpDV65OodS8L7F2vgB5FINt8+LsufkwdIquhV9Gj0tTgg598gQzxXls1Nuf3L/6Jtp6TPPOjjzbpJjpto4ntevuEE2BJcBYaRHfFh5Cnrj2axILY/wcg5NwGgG7tRiVsjvNjH2+fnOwce1gfdSpaWlkjfFme3nHQ2yvt+OndFfo+P92YpZ20X6NVDrC9GSoT3HeSjXXwABoGhnEjRl+Ou08OEwBMtKWPZUFOID98o858sAeDZfH+bRkxsWZ8pDhMui9TZZyCg/lJWXBLqPq983dNa64GpOs1/vgJK8Z46Ff3ngmoR7MjH7+sjFASFBkeIYj0ReFYLX1T14vIN96xJhPeK+EEDNassA+ZXScWF5Vk4poibQxkdcuzkFO/xx9qssfX90KfSLJ5q9THFIjlM/jvQYuWJWUSqsTe1jv7tS0phqckGSQ+IQ36pQnF0YXSz9eMvt2CrOQT9507OEljxymOeCE6+yn8i5eBEQK6gFskuTT37V3B3lgKI7QmEuGtJwJzTqobgBVuirD9NswGgO/f6FTSrEyi0gWu5Tqy1hyBv/Co5DKQhdt7vt1h8bJNOcgLJI1oxa6MtebW3pe6OWUU6VyGl/XHRVrlgBpBaOvcSE0Vgx2kIcU+qRrnwhs2F4iKcdJOCrJIvXEPq9RhoPx5RJZLYgPtvvufqYZtb8sGiK2Nl7ZqW3fsYYTLtSUdPTg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(39860400002)(136003)(346002)(366004)(451199015)(83380400001)(71200400001)(38070700005)(55016003)(86362001)(478600001)(7696005)(26005)(82960400001)(38100700002)(186003)(6506007)(122000001)(4326008)(8676002)(64756008)(66556008)(66476007)(107886003)(66946007)(33656002)(9686003)(5660300002)(2906002)(54906003)(52536014)(316002)(41300700001)(66446008)(8936002)(76116006)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?HoOjJWG7+Tisb4PzGutcZjTaTXx6Kc4gMu4bHbVRGdW41spYh0BZYvmYSb5A?=
 =?us-ascii?Q?n+4XQLOXq6tsL80jMKjmXDHm0u/0I27ytY2DYhizndt2gRQjPqnELzx+7iPr?=
 =?us-ascii?Q?qKjKCBY4FY8Hf3c/jgJA8VHLqgSgO5Dw4ZBVBnPPQdZDcvhS8IKStgL44nAb?=
 =?us-ascii?Q?3Hn3d7HnE1w+psLpYNB8LvJthQwdI9ZcRh9+1FwrnOcNY+l95a0ufcdtijEF?=
 =?us-ascii?Q?sredsiw18xqMSXxvmslEGd9h1vkafvV6hDnztlyi6oNQLNkC/ZqhscRozAWN?=
 =?us-ascii?Q?2ro6BMj7AkCTXrWPw720taa9QNl/ZCDYokraKT+hEEhknseoH5zpA3fe1y0y?=
 =?us-ascii?Q?vXGt3uPlhtag9AM2TXrSHy3u6P9Y/LinAJF0dRpMXbT+7lLlX3ayGiIHgeRq?=
 =?us-ascii?Q?1pBZvvon56ORhU3KT/c3g1ueesmgPXHgSweMuJ6D3rKTW3X5QKLMfOIZYrHJ?=
 =?us-ascii?Q?oIEQq9BxOa9SXqsbRfXzEHAfECDIpWb11w9VMv34zDHv81wHKobjnMciSp5X?=
 =?us-ascii?Q?w/3TYuUln22AgDLuaT5EufbnHc5KPejsT/zh/vjqY+mM5P4sDEk+dq3mdORJ?=
 =?us-ascii?Q?fEH3l2DCGvy6DrJrbuwMN8WWxxmA70wkkdNMhZD2TqvWPXz7E5qX9M/RviAF?=
 =?us-ascii?Q?AuBasslK4hc2tRQXFhJHildx7pRD+X/bvdtGuq0SsqNKzJwf5qJfSNavxPAm?=
 =?us-ascii?Q?5rT8Z1NN4JlCy/8jVuqb7vI03foU7eH1eagG9DMha5SpAX3Sd3ELAX0uVN+V?=
 =?us-ascii?Q?LrcvmEp8jSHiLYH2S18k3wf26+1v65Jvhzz1atD5GRnl/Hp7sZqdcb+v7vIw?=
 =?us-ascii?Q?RTXfjtiJwW4LphHZYoMCCcE2UCULBXSJZMdVH1ypPJj9zOePd49icQvGhinL?=
 =?us-ascii?Q?HvLWVZ4Stow8FzAMjL+GDBJbZOIxbfVS6qrvT40gD9yAPzEEuW8hvTQw/xEF?=
 =?us-ascii?Q?IJcH84dBEWsxVFyFEq+QL1z+BEcXJbdR06Yf+elCNkWwi4jxcGMm6yzADsHO?=
 =?us-ascii?Q?MQgg6ZpnnjNmg/LImCPVKJ+EC8jgjTPAK04Am/jHo5LKystI/F50b3kXg05c?=
 =?us-ascii?Q?lldwx6J7mRGkjt5u0+wD3jjyKes7fB+V6miUDOGxS1yDOq4zTuGX55ljRapd?=
 =?us-ascii?Q?uE3inqNMW4nwipsCCt0dY3Ylt6fSc0Hx5SVNbBplLATvK4MgdzSoUSSpgPgd?=
 =?us-ascii?Q?hv54L38r5vrEVL5Xz8cCBEFdzMrDRnanttbfGD9jQkxwZXLZo2ek967MIbEq?=
 =?us-ascii?Q?hX2mej5UlVAt/rTuJU95Pnb18+P64q/cozYjqpFL/KtMdgYTE2UfL0prbPB3?=
 =?us-ascii?Q?LZawO14+FgCCnZlFvv/WEMaICRzFmFFgueKchFP8ExPTk/jWEEUsxWPOpgNR?=
 =?us-ascii?Q?940sbOSxDXhu6nAsldZk2fmDmUZetEE8lgvQu7y+bqZd7MwaFrRR+foF1lC2?=
 =?us-ascii?Q?pePiBEn/KbHhAA0JJYXJZM2E3psodnaTU/7YkkmHkl10o7ph5mwky2+sm9RD?=
 =?us-ascii?Q?JOknIn9PA6u/feBNJ/99GZmoQZ+kynhlRxStyxuPbJUiytaELewCjXXdZpFG?=
 =?us-ascii?Q?snpmkBQVjysHEv/9ks+Ens0fdukC4txNkSJbIh5U9nvbDJICat8syrFyAOqp?=
 =?us-ascii?Q?Cw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fc88a11-bba5-46d4-17fc-08dadd35003b
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Dec 2022 18:08:13.2912
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: duXcVmI78QB4uz14ohjXj52t5RVt57sB/C7rv1jbxdxgzyaPEJ37hAVbK8OpNpCB7hKkZcwKruxhoQiCjN7nHmuYM//+bTJPeXXRG0PUN2c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7417
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>From: Jiri Pirko <jiri@resnulli.us>
>Sent: Monday, December 12, 2022 2:37 PM
>To: Jakub Kicinski <kuba@kernel.org>
>
>Fri, Dec 09, 2022 at 05:19:42PM CET, kuba@kernel.org wrote:
>>On Fri, 9 Dec 2022 10:29:53 +0100 Jiri Pirko wrote:
>>> Thu, Dec 08, 2022 at 06:05:17PM CET, kuba@kernel.org wrote:
>>> >On Thu, 8 Dec 2022 17:33:28 +0100 Jiri Pirko wrote:
>>> >> For any synce pin manipulation over dpll netlink, we can use the
>>> >> netns check of the linked netdev. This is the netns aware leg of
>>> >> the dpll, it should be checked for.
>>> >
>>> >The OCP card is an atomic clock, it does not have any networking.
>>>
>>> Sure, so why it has to be netns aware if it has nothing to do with
>>> networking?
>>
>>That's a larger question, IDK if broadening the scope of the discussion
>>will help us reach a conclusion.
>>
>>The patchset as is uses network namespaces for permissions:
>>
>>+		.flags	=3D GENL_UNS_ADMIN_PERM,
>
>Yeah, I wonder if just GENL_ADMIN_PERM wuldn't be more suitable here...
>
>
>>
>>so that's what I'm commenting on - aligning visibility of objects with
>>already used permissions.
>>
>>> >> I can't imagine practically havind the whole dpll instance netns
>aware.
>>> >> Omitting the fact that it really has no meaning for non-synce
>>> >> pins, what would be the behaviour when for example pin 1 is in
>>> >> netns a, pin 2 in netns b and dpll itself in netns c?
>>> >
>>> >To be clear I don't think it's a bad idea in general, I've done the
>>> >same thing for my WIP PSP patches. But we already have one device
>>> >without netdevs, hence I thought maybe devlink. So maybe we do the
>>> >same thing with devlink? I mean - allow multiple devlink instances
>>> >to be linked and require caps on any of them?
>>>
>>> I read this 5 times, I'm lost, don't understand what you mean :/
>>
>>Sorry I was replying to both paragraphs here, sorry.
>>What I thought you suggested is we scope the DPLL to whatever the
>>linked netdevs are scoped to? If netns has any of the netdevs attached
>>to the DPLL then it can see the DPLL and control it as well.
>
>Okay, that would make sense.
>GENL_UNS_ADMIN_PERM | GENL_UNS_ADMIN_PERM then.
>

I guess a typo here? Shall be: 'GENL_UNS_ADMIN_PERM | GENL_ADMIN_PERM'?
Going to:
- apply those bits for all the dpll netlink commands,
- remove DPLLA_NETIFINDEX,
- leave pin DPLLA_PIN_NETIFINDEX as is.

Or I have missed something?

Thanks,
Arkadiusz

>>
>>What I was saying is some DPLL have no netdevs. So we can do the same
>>thing with devlinks. Let the driver link the DPLL to one or more
>>devlink instances, and if any of the devlink instances is in current
>>netns then you can see the DPLL.
>
>I don't think that would be needed to pull devlink into the picture.
>If not netdev is linked to dpll, GENL_ADMIN_PERM would apply.

