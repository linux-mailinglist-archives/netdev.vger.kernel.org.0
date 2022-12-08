Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 194266465E9
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 01:35:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbiLHAfI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 19:35:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiLHAfH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 19:35:07 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5259F8D668;
        Wed,  7 Dec 2022 16:35:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670459706; x=1701995706;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=iiHIBz3u5HMMUUFOdwoYKuKEZOl/jRCjJFiMGpuP0Zk=;
  b=GalejjEuYrnW1ygvXn1ItA0wIkNhLnScmP6VWCx5GiFX0L9N330KkLgV
   +AytzA5IdfBQ6iCCbe/vNmqjiGTGDpu9TXPfXVFTFbVms8oQHg/GpeDfh
   aJ9cRfvFzK64LDIZgoNivP3MM5sj4aA/BVJmbxAISNYsfArZmp7JgclHG
   ZAmRDT0ND5zZS6tIkjbPAGvvG3sMvFu1KldBPgLUm6kbQOmzvMxiLUvr6
   BpV4saIisg8lBgQhBkpdItVj/1hw3zme2BJ51vjH3SPXDlSXf3kJpTN3r
   MoCp6uSSB8ip6OdMEZbgSNeznm3/xlZPgbo8fD1efV1+ShKftuadbjSG4
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="379204676"
X-IronPort-AV: E=Sophos;i="5.96,226,1665471600"; 
   d="scan'208";a="379204676"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2022 16:35:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="640437295"
X-IronPort-AV: E=Sophos;i="5.96,226,1665471600"; 
   d="scan'208";a="640437295"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga007.jf.intel.com with ESMTP; 07 Dec 2022 16:35:04 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 7 Dec 2022 16:35:04 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 7 Dec 2022 16:35:04 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.174)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 7 Dec 2022 16:35:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EgIGRRAtxY8NepwRmmED+Nle6rd46Dd4xOvQX7+TUWVlXXINFSWp1UQKOFgF0BVMbcKQyCu4DnOFNHJeem2V+AlEVOeH+iszbFZdR6AOBIvLXbdqybLR2VdGAXEb+PFZFSLkjSeuXtLquKTrv3h66lEFSFdbGFEJj6bOIz+xy2jdD1Oq+qWONn51nTYAMV00a+vJ3PPpJivRhx/YvW8tnT8ixzKouqPDy12PzV4XgRbWRCWmEozgebCv3eRT4bqlKD5Xl+uZnZw96aGN8qJqnIBeDhiLwQbzijnVVDEtjO/NvwmN4eGrbM9HENEDkltzmyH6n/tTpvgbY17oVgWz5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lDh6uz10oR0Ir0QnBG5lyUfJNHKea45RKGVSF6HDH2A=;
 b=YVK3V+pUCsR6beTvfKvp0/3/XQMbQBIMVMfMs4tLZ2IRFwEVc+hpILGcNv6sLngZzgwkH8E8iFmgfG5PGigvsq3YW1DTgez5jm4zRfU3x3Vx4sOACWUkKV/RrgM4izY96J4WpdBScpDkwht2VU8QfZCVnZLkz2EHuoLRdbyhH5Or8I/eMOhaPDzblt59pWyJBByYva9eZbjqxhnPlP3cUdjT9weVK+lAjZGYo09tpi9TgGunyusE5ldC2zDf2nqHhJF8+OFhKBoV7+XlizaG+SMkBCktyjZNeEsjlph3TrUK68I1EnbPbrkak48PbqSVCc9KiSL4mc8epdgCdbZARg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) by
 CY5PR11MB6510.namprd11.prod.outlook.com (2603:10b6:930:42::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.14; Thu, 8 Dec 2022 00:35:02 +0000
Received: from DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::5006:f262:3103:f080]) by DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::5006:f262:3103:f080%7]) with mapi id 15.20.5880.014; Thu, 8 Dec 2022
 00:35:02 +0000
From:   "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
To:     Jiri Pirko <jiri@resnulli.us>
CC:     Vadim Fedorenko <vfedorenko@novek.ru>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vadim Fedorenko <vadfed@fb.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>
Subject: RE: [RFC PATCH v4 4/4] ptp_ocp: implement DPLL ops
Thread-Topic: [RFC PATCH v4 4/4] ptp_ocp: implement DPLL ops
Thread-Index: AQHZBDry/jNi33oty0uFzAsT01mIf65XaZgAgAMHnuCAAB8XgIAAHepggAAdVQCAB9lZoA==
Date:   Thu, 8 Dec 2022 00:35:02 +0000
Message-ID: <DM6PR11MB4657F675331EB623C52656F69B1D9@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20221129213724.10119-1-vfedorenko@novek.ru>
 <20221129213724.10119-5-vfedorenko@novek.ru> <Y4dPaHx1kT3A80n/@nanopsycho>
 <DM6PR11MB4657D9753412AD9DEE7FAB7D9B179@DM6PR11MB4657.namprd11.prod.outlook.com>
 <Y4n0H9BbzaX5pCpQ@nanopsycho>
 <DM6PR11MB465721310114ECA13F556E8A9B179@DM6PR11MB4657.namprd11.prod.outlook.com>
 <Y4ol0o5Gpe8ZgAas@nanopsycho>
In-Reply-To: <Y4ol0o5Gpe8ZgAas@nanopsycho>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4657:EE_|CY5PR11MB6510:EE_
x-ms-office365-filtering-correlation-id: 6514793d-2e2e-463e-cf9c-08dad8b40b51
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5QgaZECsvJ020S6IXPdZRVPTKPJINl4uECyqSBk4KSryl8RBFg4dEbeLkU/P8lW1tKK7vU5woR71bx+02KXFu7qiSwV2vUA6NLqndW8aug/jjqEhDnzsQ3RVa7wbGlFmS4i3mxElJTRjy7ibXkJenyVagu7QvKTZY2QYXrUmBXa5Vh87dl1YDr2i2IQW5UvQb3tz5ota4Uzk4DEWv+8dtzCOUc4/KOtbIZFts/5YndSkEDxcGmdwUg7WWdySm7bC0xyv7XExOr0shVlsIaG47vU1zDvvIoHgW7Tje0w4ROb5VUB0ZvHUAoFHXt759twBSyjc3pg8zlATa9AEd/qHf5LpwmW+/SST8eElTUyLgAp5S6hWyryIz5bwULSKP7mBOQ6RA5x6pcnUXnHV2uksecygI1dwJ3z8Eb55J+VS5ISb9nBsCKD/aTntdOZaKU5WMPtUBS6dUPMe9XRiEiZu2j8BVHOA4lNmLo6vywVOIeq2eS1ieUMwh13mZLo3JxjFd3kX8adJf6vo7scS+HxJNyJmRGXI3I2BUOj59Ux8RkfDgmN96C6kka/ffps/d7n6AxIgvPldJsOnJEVGvtYGWMW14gGCEGFjQTeNBSDb+Y+VNPsH2qVkqFoiOgZKBwMUeVsMb02CP9/ceD5nZgUr9HEzOcRmgNPeWFaHU6VDPesoM8W6zO7+iAyqzg3pZBLVBUzH6Ic6CPB2LgtQv8nlSw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(396003)(346002)(39860400002)(366004)(451199015)(52536014)(8936002)(9686003)(186003)(5660300002)(6916009)(54906003)(83380400001)(86362001)(33656002)(41300700001)(26005)(2906002)(478600001)(76116006)(38070700005)(8676002)(71200400001)(4326008)(316002)(66446008)(82960400001)(38100700002)(7696005)(66476007)(122000001)(55016003)(64756008)(6506007)(66946007)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?RxZ2PcKe28fuIZM2BnUveO8Q46iqwVkRnf/sbb9n7Ym3+hnLGReZdijsDRBu?=
 =?us-ascii?Q?xkDQCYHTEqG/EnRxDwHm8F8TcvTrMggjYioVM+PtpRs30erxOOj6/+oB8F8z?=
 =?us-ascii?Q?pT/dbW0TNEi59Rh/QzZI8QaDbywYpQpa6cMXbu/8k1M9OnuZmc6Ln6JOY5nH?=
 =?us-ascii?Q?gQm1gyrla48tAkDmP1t9o1EEWJ/bAk8KTFwJuX4yGWo1xhXB99NNzhwLDzID?=
 =?us-ascii?Q?mMPQYDMKrk8ZhMF+gj6WHtRjZjEEFeJ74K/XY9TCmkE4JJryivBVjB9okV1y?=
 =?us-ascii?Q?8WthXmNkb9XujOTydwnR8PuSRChPyIC0XzSdPSCNl+PeRRnOyxBAqA3xR9DY?=
 =?us-ascii?Q?0An726uS8KpORUIL8O+rl8KWhksG63vuKh/+3/DB1CpS0BRk7kY6KiMqj0jy?=
 =?us-ascii?Q?t8LymjvXaOnYwupIPHnwQoI8zwmEUcjWqgOlCZuH+S7LYG2/Ud+5rHXzOJOd?=
 =?us-ascii?Q?3HpPxmEL+Nk4+6MAg8AxXwwPj8xTjdKiCxbs0/Y6DTtk+wX7Bib+KogLoxLV?=
 =?us-ascii?Q?EPKogN1GgZX79riKxLvAEEYAHwShgIeUjwKDZO31bOP69SSBS+Tk3Aaml1TC?=
 =?us-ascii?Q?JjhVbcZQ58fx4X611XX3cwFgH90Iu7tLKGnZ3rBYZsameVlXeRBImFZdEidp?=
 =?us-ascii?Q?sdMkkomdqkHlVQ59sdh1Yz6zDn0rn3mry3kOjuJ9ex58f5gQDQLnqE8+/moQ?=
 =?us-ascii?Q?a6Z5TVmyPO9upfl3XiNoXS/HFoEvsHf4otguiGulm1rq0iljufXqF74lKHlR?=
 =?us-ascii?Q?cmFDO2AEjcpQL5wmceBOMAqFzC8hj8g+4fc/sLzX1Fp+367jhjfOG4EREIO1?=
 =?us-ascii?Q?bv9UGtZ2rr/ofrNyw9GfIXoPSkF9sy2y/hCPDk5jy7RkYdC8viONDvMx/ULz?=
 =?us-ascii?Q?VoaVXiGKPvqu8dMahvtQstD+3adzi9egECRdMiLgwAvKqjRRDoLLkUzj+vdU?=
 =?us-ascii?Q?dA5kCknuEzP6JmqA5CoZJSDWpSYB/fzMXYmCVK9+aAyZEajtad+QycImppmZ?=
 =?us-ascii?Q?v0fPxx1GoxEw9FHLAC0E9RhaicobAShfUVHyHgoBJTWMJjzNXdTBVvF0Ul/T?=
 =?us-ascii?Q?hnqpgcxG2Ezcd6hnUXhiQ40InzU1XL1z5qBp5sHCSgmd2jd1GRTmpUL3nZzS?=
 =?us-ascii?Q?l0is8Ub0gSIITTSQz1C5mVlIMeTgWuydaPBjcfJa2knPWqG71H3ZJRzEgd+X?=
 =?us-ascii?Q?18I54dfBV71hcgyrpZOiR8Pkc7HSpscdP2IrfLmPP3OlPnDQvH4D8Z3Wl59V?=
 =?us-ascii?Q?D2IDRtei8+50iu/Y8Igof6eIK1++mFjyzoGtvoZO3KenLKqym3QQ+5mlXVkj?=
 =?us-ascii?Q?UkyGhBws5UnHYInf8NssV29D2OIjqhB5SZ6FrGemDRVjybDgMkYHj1cyXP/n?=
 =?us-ascii?Q?mq1aGyApeFenUQGliI87pxFbpCn7TLbhioyY19R+OmBs8buSGktt1B+LeVrB?=
 =?us-ascii?Q?eJ2AGHs9BWjPSJ9nFTiBhAtpTQUxqsz7EDFazvho50Ctx4Iy36TQWCNboZKD?=
 =?us-ascii?Q?INTdSHlsok8hvj7xXTTvwmwM5K3e/gXRBVJFEtgRk19WaCZCCad9NYNgJ0vM?=
 =?us-ascii?Q?+ddCY6pdESL+Oevxu4fIhQLMhtFPkzas9GUnB7t/OnCqjGgRipz/q9DAhnIk?=
 =?us-ascii?Q?5Q=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6514793d-2e2e-463e-cf9c-08dad8b40b51
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Dec 2022 00:35:02.1657
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZxFNBP0CyzQ7MuP4LrZns4APT1EeYbPMAf//BuANnUg/8OlaFE0xYE5W6TTZ6M46r8gdNGlI3H4DhowiOReOSt2peDMuHmSukq56k8ZFSN0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6510
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>From: Jiri Pirko <jiri@resnulli.us>
>Sent: Friday, December 2, 2022 5:21 PM
>
>Fri, Dec 02, 2022 at 03:39:17PM CET, arkadiusz.kubalewski@intel.com wrote:
>>>From: Jiri Pirko <jiri@resnulli.us>
>>>Sent: Friday, December 2, 2022 1:49 PM
>>>
>>>Fri, Dec 02, 2022 at 12:27:32PM CET, arkadiusz.kubalewski@intel.com
>wrote:
>>>>>From: Jiri Pirko <jiri@resnulli.us>
>>>>>Sent: Wednesday, November 30, 2022 1:41 PM
>>>>>
>>>>>Tue, Nov 29, 2022 at 10:37:24PM CET, vfedorenko@novek.ru wrote:
>>>>>>From: Vadim Fedorenko <vadfed@fb.com>
>>>
>>>[...]
>>>
>>>
>>>>>>+static int ptp_ocp_dpll_get_attr(struct dpll_device *dpll, struct
>>>>>dpll_attr *attr)
>>>>>>+{
>>>>>>+	struct ptp_ocp *bp =3D (struct ptp_ocp *)dpll_priv(dpll);
>>>>>>+	int sync;
>>>>>>+
>>>>>>+	sync =3D ioread32(&bp->reg->status) & OCP_STATUS_IN_SYNC;
>>>>>>+	dpll_attr_lock_status_set(attr, sync ? DPLL_LOCK_STATUS_LOCKED
>:
>>>>>DPLL_LOCK_STATUS_UNLOCKED);
>>>>>
>>>>>get,set,confuse. This attr thing sucks, sorry :/
>>>>
>>>>Once again, I feel obligated to add some explanations :)
>>>>
>>>>getter is ops called by dpll subsystem, it requires data, so here value
>>>>shall be set for the caller, right?
>>>>Also have explained the reason why this attr struct and functions are
>>>>done this way in the response to cover letter concerns.
>>>
>>>Okay, I will react there.
>>
>>Thanks!
>>
>>>
>>>
>>>>
>>>>>
>>>>>
>>>>>>+
>>>>>>+	return 0;
>>>>>>+}
>>>>>>+
>>>>>>+static int ptp_ocp_dpll_pin_get_attr(struct dpll_device *dpll,
>>>>>>+struct
>>>>>dpll_pin *pin,
>>>>>>+				     struct dpll_pin_attr *attr) {
>>>>>>+	dpll_pin_attr_type_set(attr, DPLL_PIN_TYPE_EXT);
>>>>>
>>>>>This is exactly what I was talking about in the cover letter. This is
>>>>>const, should be put into static struct and passed to
>>>>>dpll_device_alloc().
>>>>
>>>>Actually this type or some other parameters might change in the
>>>>run-time,
>>>
>>>No. This should not change.
>>>If the pin is SyncE port, it's that for all lifetime of pin. It cannot
>turn
>>>to be a EXT/SMA connector all of the sudden. This should be definitelly
>>>fixed, it's a device topology.
>>>
>>>Can you explain the exact scenario when the change of personality of pin
>>>can happen? Perhaps I'm missing something.
>>>
>>
>>Our device is not capable of doing this type of switch, but why to assume
>>that some other HW would not? As I understand generic dpll subsystem must
>not
>>be tied to any HW, and you proposal makes it exactly tied to our
>approaches.
>>As Vadim requested to have possibility to change pin between source/outpu=
t
>>"states" this seems also possible that some HW might have multiple types
>>possible.
>
>How? How do you physically change from EXT connector to SyncE port? That
>does not make sense. Topology is given. Let's go back to Earth here.
>

I suppose by using some kind of hardware fuse/signal selector controlled by
firmware/driver. Don't think it is out of space, just depends on hardware.

>
>>I don't get why "all of the sudden", DPLLA_PIN_TYPE_SUPPORTED can have
>multiple
>>values, which means that the user can pick one of those with set command.
>>Then if HW supports it could redirect signals/setup things accordingly.
>
>We have to stritly distinguis between things that are given, wired-up,
>static and things that could be configured.
>

This is supposed to be generic interface, right?
What you insist on, is to hardcode most of it in software, which means that
hardware designs would have to follow possibilities given by the software.

>
>>
>>>
>>>
>>>>depends on the device, it is up to the driver how it will handle any
>>>>getter, if driver knows it won't change it could also have some static
>>>>member and copy the data with: dpll_pin_attr_copy(...);
>>>>
>>>>>
>>>>>
>>>>>>+	return 0;
>>>>>>+}
>>>>>>+
>>>>>>+static struct dpll_device_ops dpll_ops =3D {
>>>>>>+	.get	=3D ptp_ocp_dpll_get_attr,
>>>>>>+};
>>>>>>+
>>>>>>+static struct dpll_pin_ops dpll_pin_ops =3D {
>>>>>>+	.get	=3D ptp_ocp_dpll_pin_get_attr,
>>>>>>+};
>>>>>>+
>>>>>> static int
>>>>>> ptp_ocp_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>>>>>> {
>>>>>>+	const u8 dpll_cookie[DPLL_COOKIE_LEN] =3D { "OCP" };
>>>>>>+	char pin_desc[PIN_DESC_LEN];
>>>>>> 	struct devlink *devlink;
>>>>>>+	struct dpll_pin *pin;
>>>>>> 	struct ptp_ocp *bp;
>>>>>>-	int err;
>>>>>>+	int err, i;
>>>>>>
>>>>>> 	devlink =3D devlink_alloc(&ptp_ocp_devlink_ops, sizeof(*bp),
>&pdev-
>>>>>>dev);
>>>>>> 	if (!devlink) {
>>>>>>@@ -4230,6 +4263,20 @@ ptp_ocp_probe(struct pci_dev *pdev, const
>>>>>>struct
>>>>>pci_device_id *id)
>>>>>>
>>>>>> 	ptp_ocp_info(bp);
>>>>>> 	devlink_register(devlink);
>>>>>>+
>>>>>>+	bp->dpll =3D dpll_device_alloc(&dpll_ops, DPLL_TYPE_PPS,
>dpll_cookie,
>>>>>pdev->bus->number, bp, &pdev->dev);
>>>>>>+	if (!bp->dpll) {
>>>>>>+		dev_err(&pdev->dev, "dpll_device_alloc failed\n");
>>>>>>+		goto out;
>>>>>>+	}
>>>>>>+	dpll_device_register(bp->dpll);
>>>>>
>>>>>You still have the 2 step init process. I believe it would be better
>>>>>to just have dpll_device_create/destroy() to do it in one shot.
>>>>
>>>>For me either is ok, but due to pins alloc/register as explained below
>>>>I would leave it as it is.
>>>
>>>Please don't, it has no value. Just adds unnecesary code. Have it nice
>and
>>>simple.
>>>
>>
>>Actually this comment relates to the other commit, could we keep comments
>>in the threads they belong to please, this would be much easier to track.
>>But yeah sure, if there is no strong opinion on that we could change it.
>
>Ok.
>
>
>>
>>>
>>>>
>>>>>
>>>>>
>>>>>>+
>>>>>>+	for (i =3D 0; i < 4; i++) {
>>>>>>+		snprintf(pin_desc, PIN_DESC_LEN, "sma%d", i + 1);
>>>>>>+		pin =3D dpll_pin_alloc(pin_desc, PIN_DESC_LEN);
>>>>>>+		dpll_pin_register(bp->dpll, pin, &dpll_pin_ops, bp);
>>>>>
>>>>>Same here, no point of having 2 step init.
>>>>
>>>>The alloc of a pin is not required if the pin already exist and would
>>>>be just registered with another dpll.
>>>
>>>Please don't. Have a pin created on a single DPLL. Why you make things
>>>compitated here? I don't follow.
>>
>>Tried to explain on the cover-letter thread, let's discuss there please.
>
>Ok.
>
>
>>
>>>
>>>
>>>>Once we decide to entirely drop shared pins idea this could be probably
>>>>done, although other kernel code usually use this twostep approach?
>>>
>>>No, it does not. It's is used whatever fits on the individual usecase.
>>
>>Similar to above, no strong opinion here from me, for shared pin it is
>>certainly useful.
>>
>>>
>>>
>>>>
>>>>>
>>>>>
>>>>>>+	}
>>>>>>+
>>>>>> 	return 0;
>>>>>
>>>>>
>>>>>Btw, did you consider having dpll instance here as and auxdev? It
>>>>>would be suitable I believe. It is quite simple to do it. See
>>>>>following patch as an example:
>>>>
>>>>I haven't think about it, definetly gonna take a look to see if there
>>>>any benefits in ice.
>>>
>>>Please do. The proper separation and bus/device modelling is at least on=
e
>>>of the benefits. The other one is that all dpll drivers would happily
>live
>>>in drivers/dpll/ side by side.
>>>
>>
>>Well, makes sense, but still need to take a closer look on that.
>>I could do that on ice-driver part, don't feel strong enough yet to
>introduce
>
>Sure Ice should be ready.
>
>
>>Changes here in ptp_ocp.
>
>I think that Vadim said he is going to look at that during the call. My
>commit introducing this to mlxsw is a nice and simple example how this
>could be done in ptp_ocp.
>

Yes, though first need to find a bit of time for it :S

Thank you,
Arkadiusz

>
>>
>>Thank you,
>>Arkadiusz
>>
>>>
>>>
>>>>
>>>>Thanks,
>>>>Arkadiusz
>>>>
>>>>>
>>>>>commit bd02fd76d1909637c95e8ef13e7fd1e748af910d
>>>>>Author: Jiri Pirko <jiri@nvidia.com>
>>>>>Date:   Mon Jul 25 10:29:17 2022 +0200
>>>>>
>>>>>    mlxsw: core_linecards: Introduce per line card auxiliary device
>>>>>
>>>>>
>>>>>
>>>>>
>>>>>>
>>>>>> out:
>>>>>>@@ -4247,6 +4294,8 @@ ptp_ocp_remove(struct pci_dev *pdev)
>>>>>> 	struct ptp_ocp *bp =3D pci_get_drvdata(pdev);
>>>>>> 	struct devlink *devlink =3D priv_to_devlink(bp);
>>>>>>
>>>>>>+	dpll_device_unregister(bp->dpll);
>>>>>>+	dpll_device_free(bp->dpll);
>>>>>> 	devlink_unregister(devlink);
>>>>>> 	ptp_ocp_detach(bp);
>>>>>> 	pci_disable_device(pdev);
>>>>>>--
>>>>>>2.27.0
>>>>>>
