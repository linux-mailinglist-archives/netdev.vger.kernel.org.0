Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0547167ED18
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 19:13:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234559AbjA0SNL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 13:13:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234013AbjA0SNI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 13:13:08 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1513184;
        Fri, 27 Jan 2023 10:12:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674843175; x=1706379175;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=aMRjPazvMCY2nNEhamv2p1YbESxeoNkuhCd5mdsP4aI=;
  b=VfPlHMQG6/+4jHRK82VtacfMhaQcnDmXcxh+PAZV2sulYIMzTcNm1Awi
   PLBPup4Lseupmv7YYxWciF4+OwaOG2ZF7ejYS9Z5m2qXyv4s9yMM+bObf
   M2aYS01PlVEhPytEJa+u8wYYsxo5RWC+i/JXCy20gukxTEzqvrOmwmfCc
   p40QuTHqm2hMjC82rxQbIfI+lyd4QeQDob8ix3JiBO9wmfcz5J8TwCtug
   kOp2rsnkI+LmzHftQokbY2djkCYi4ccRn7/9lWNZajzHyabDRVFIZVOJo
   7eOspsOCkqWMbQRa9krUc9oOpw6Jr/D6JiekYvFsbpCZ8KnvUW2Wohv66
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10603"; a="306800257"
X-IronPort-AV: E=Sophos;i="5.97,251,1669104000"; 
   d="scan'208";a="306800257"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2023 10:12:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10603"; a="908756564"
X-IronPort-AV: E=Sophos;i="5.97,251,1669104000"; 
   d="scan'208";a="908756564"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga006.fm.intel.com with ESMTP; 27 Jan 2023 10:12:54 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 27 Jan 2023 10:12:53 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 27 Jan 2023 10:12:53 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.176)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 27 Jan 2023 10:12:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UG7/3mbOfWqugDPqMnxtMKE8vvq1/cfFpgWCBhWp7YQkbKIyqe9GFUTK7+dyNRC3EBafHQ1dzT9ssRM221GK+6PTgtRjVK0HEUBpDWiefv+zJaFmOUDC0SsoFV+AYEoNIoYyFVkQKuVZPVSOUndCgEPmbSf9/VDRseW6QwGEgRomciv5yOWsPT+y+CwCHfW2PWUewvfktNg3YcH+YxpidlFfJKlhK84xr4NUFOniVYxH0SH3BMwrYPtOEEaNZ59ZhUcd8n7R1p/POEx3YVJ0Qv36FsvWbhiAoME7d2acGdoguJGFyXQuXVLqWZKMT2DpRF+2Whq4N+BI+PbASeiyLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T0auT7hKCyDBEuqgC7jJCejqE6ZdbQYVw8MVF9QYNk8=;
 b=cGK2l1HZa5+10Y1HOJyO/A5psqcaEBLUXhVVvKIHeB0RFwf+oUH7HvMc2fYtFJrkUfByYw7mxloYwCw/lgiLyQ8CUBvMbkMMi/zEf4M+06Pw0uLvuwf0BJhXd9thAF99q1FHvf4mPwXh+i5o5YpuMyJnC89b+1z8adCenwKDXmK6tiAlHq6CwGuQ3zFcegb6pRTfFbBw1q7BF4uL7izNaZ32ORdFxHcX/pF0PdhN/6mCZOE6IU5/W4pkJqGUeg7nwmoxCJRMwodWjnq+4DcTqJA0EjXPZotDwTVYdvXUx6VfJrcyorTRVAUYUpcRykJ55ZF0v+XhxygZLTDgklXLrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) by
 MN0PR11MB5986.namprd11.prod.outlook.com (2603:10b6:208:371::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Fri, 27 Jan
 2023 18:12:49 +0000
Received: from DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::9c46:2880:3985:6f89]) by DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::9c46:2880:3985:6f89%4]) with mapi id 15.20.6043.025; Fri, 27 Jan 2023
 18:12:49 +0000
From:   "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
To:     Jiri Pirko <jiri@resnulli.us>, Vadim Fedorenko <vadfed@meta.com>
CC:     Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>,
        "Olech, Milena" <milena.olech@intel.com>,
        "Michalik, Michal" <michal.michalik@intel.com>
Subject: RE: [RFC PATCH v5 1/4] dpll: Add DPLL framework base functions
Thread-Topic: [RFC PATCH v5 1/4] dpll: Add DPLL framework base functions
Thread-Index: AQHZKp4K9cfIHTE4HkioJShQwVs1zK6l/jqAgAFJyQCAC1iK4A==
Date:   Fri, 27 Jan 2023 18:12:48 +0000
Message-ID: <DM6PR11MB46578F9EF0B6A8697F47EE9D9BCC9@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20230117180051.2983639-1-vadfed@meta.com>
 <20230117180051.2983639-2-vadfed@meta.com> <Y8l63RF8DQz3i0LY@nanopsycho>
 <Y8qPgj9BFsbFKhwx@nanopsycho>
In-Reply-To: <Y8qPgj9BFsbFKhwx@nanopsycho>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4657:EE_|MN0PR11MB5986:EE_
x-ms-office365-filtering-correlation-id: 710b806b-274b-4fb9-3819-08db00921912
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2Z6qB0jig3Md1w+3XbY4k2jTlsOHOXmCtgpHpKDSWG24Mi5hLj6RdrLUbQyKBnXahhF0PlnQRK9eFoYWy7RjM5TxEDv8trKmvZELR9iu14lVQAzrjBpBTz0a77NkSlbZGSWXHfgSEBWXSTGRbDV0pKfRUEt6I1tG4TNmRTkuFthsLMRlgEF9SNxkPKChrEkf/r+fTGjiVng9TDszxuUwBbK1wl0xjsZexQoBkpqAktJqN+O2+BUOPzFi1Hf6trtfb+t7RxouxYnlBB7oQqltE9vddEAsF17nPN/AOxL1QXs48CRed0Ybw7i6ozg8R9vAWRYBbwydssdMlcJXbSTZmrkPFASqsL0QasAKxCgRLXjF973mtTki/VhN0Y2WnTg19cr4Nwu3qqliXn1UO5+OgaWmkAnCh1ZfcfxA4rIoxgkZGnuPeW2wLEyquyd5ccaYnA6NO57ODtn4NWDnxL+0t7kDWCiYBc6LeYHEPgl/6L3drqe59rWNgCVIHGVIRGxCz0IdoIH/D+oPd/Y3I3GEgpGul/HHEufRIAhma6eki0GxuQ3oQJxllYjxeJTJFBqlpmW9A4ImjPCaBRkY/gTlTxr/bEkuT7K9SCaSApAbp0TJWpwimI4KD1KFwch8tkI4BfMx+RagGYCnoLGMxkbM5qCDdNNMf11l1HJOsEom3KYNKi8T69z6oXl8xAwE8ewwbALrsTcUK/wQQ397uzw70Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(366004)(39860400002)(396003)(376002)(346002)(451199018)(8676002)(71200400001)(33656002)(7696005)(54906003)(55016003)(38100700002)(122000001)(9686003)(38070700005)(110136005)(26005)(83380400001)(86362001)(186003)(478600001)(107886003)(6506007)(82960400001)(316002)(52536014)(64756008)(8936002)(66446008)(66476007)(66556008)(5660300002)(4326008)(2906002)(76116006)(66946007)(41300700001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?1xebtVoOgIQZaGeQ4/Nd+aYt3gaih/f7aBKYS0FMSY9i+Bl8zVAvbDEMh0hv?=
 =?us-ascii?Q?Y36r8nvzrtgeAPKUnqSYUlPb8pBgwdgZY/l7+2FiagHuzChl4nG7AN2szdN3?=
 =?us-ascii?Q?4jj7SKF807pOVlSDitEsn/c8ZZgxiRLBLbPC8vBN0Wr7WDWCSWXV7irJiuYA?=
 =?us-ascii?Q?ayYpjhPQ6rM3HWavoSAuQaZAWyA9TitG1dtVZhHFMJT2V3eesDMjmBggtq/N?=
 =?us-ascii?Q?PPpJkJLHiUXRg0klOSud1i9+GVrq+4s7vuVr/VSxGOPLE2qeWMx1CTxM3krx?=
 =?us-ascii?Q?ppJlF8RMU0l+oEVQABaPodlYljOr++XtLTZ0p8V4yCIQuIPstjha4xjq9FzL?=
 =?us-ascii?Q?So+aHjP+j7LQzlodnjQNtpfBWL9cz1gFHHUWHH9Q+V8m9VbkM4aLwwSKudcy?=
 =?us-ascii?Q?SSNmcxTQgqPe2fKzId95pkUGeGGk0GaVsP4soHd5BLtedkaHpgEzjO324IBQ?=
 =?us-ascii?Q?4VD5k/RUd5DyjSVP4d1fcQMOVZlLiq9KKkTFIHSPwCtcZidgRku6prdCmccA?=
 =?us-ascii?Q?+JyC8pNhCCIABLUIIMNoiw9ls/EDHck+9r4teQhf8S/euKWJ+a9v3eehnry4?=
 =?us-ascii?Q?P2JIIuhC17WIcTueqOWFSIKNXzf5YaFbWf+v20mh0Y0bEqcyfIdjby/jhckZ?=
 =?us-ascii?Q?M4tm4+ZZZPFU/IetskkIg3ooaNl8eJ8mCL/85a2GIw58Kl5Lx0agY47eFO9F?=
 =?us-ascii?Q?fAo704TEe8dcGKkFn6uBOKOEu2mFQ8yQfWbDVsjPEOMnx9xhRsUrrdAh4rDi?=
 =?us-ascii?Q?24OwYRRHj1/JCR6rY/xSpIF3ZZ3QZ1muf5W7PUGaYDDBwAHPLdYasxJ1P3ux?=
 =?us-ascii?Q?w5P63JWgQlx1oHdGVoju9XsDOGx+o+9OuthQdIU4RxJcIubCEX/uRguQo2HT?=
 =?us-ascii?Q?nJbxDt/+s0+zj5IJGztIzqiXto01a9JwMhTmQzClWO8FXC69r/3mfmrRoN5K?=
 =?us-ascii?Q?iTCQEYelgt6dMXdt+Il0FUSl0Q0eq1w71DcV97y1dzYPbJSeUEP5xZFlWuXG?=
 =?us-ascii?Q?gX45yfsGywJFTqinTXVFL0ZNFuzfRKrsbXHrMZhCkwtiaW41PQ+zNGFzp0qE?=
 =?us-ascii?Q?tZMk5wFX2RqOCAiYNgz5GzbOTfH2gr77iM7/L7cQXIFeKOisymIT4qiNY1RY?=
 =?us-ascii?Q?G33JlVNTjs1r9RV3KadlIGQ9XSH6jaJHdl8EpljMAn1+mfPly9eTYK96RIzt?=
 =?us-ascii?Q?DsnU/h6pb5AC/0S8UZNbRllGlZA0CX7IAhEn5uXOa+tg3JAKBcMwxzDb6e40?=
 =?us-ascii?Q?1mXMEbIHJgmaXt3Uwxg3Yf/EBZAYlwUXJj4giuSzkotdOzhAxF7ZrjCFNKUQ?=
 =?us-ascii?Q?K92G/4NN8jCR8pdNyGNBk5OSrpqpaThQaK7rZwPdq9S4gfU17Vb7DL1WwsW6?=
 =?us-ascii?Q?c59eskTtgKVFLB4z7mNZ6hLW156pcXAi50Hiza/y3v2Hj6J+oIXnqDYQVS9I?=
 =?us-ascii?Q?2N4Lcp4IgcYK0+iiHbX/uWebhj3YhM4mcPwf5Qo3VArGwd/8o6daTPhIxzEF?=
 =?us-ascii?Q?2QFHIRddxmeEv7+NNe16Mww8wOFBdVn5UeqtA9bPFnNXnB2rBmPTIPBeXOm/?=
 =?us-ascii?Q?4GJJ8pr3fRd638LTrZ/H40lOay7lzIuYaV63t0BUsfbR0gkZnsRcCQxCsbaM?=
 =?us-ascii?Q?uA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 710b806b-274b-4fb9-3819-08db00921912
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jan 2023 18:12:48.8438
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ezge0j/HEiA+WM3IJkqwbGyTmN8Sx0Nu+GrcUiVrxZ7/3HCip135MzJiBvu72D6lvnLK5Nk+p/jRiTYNDWdC3IPM6fvBCGWXC/7FJyLJpDM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB5986
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>From: Jiri Pirko <jiri@resnulli.us>
>Sent: Friday, January 20, 2023 1:57 PM
>
>Thu, Jan 19, 2023 at 06:16:13PM CET, jiri@resnulli.us wrote:
>>Tue, Jan 17, 2023 at 07:00:48PM CET, vadfed@meta.com wrote:
>
>[...]
>
>
>>>+/**
>>>+ * dpll_cmd - Commands supported by the dpll generic netlink family
>>>+ *
>>>+ * @DPLL_CMD_UNSPEC - invalid message type
>>>+ * @DPLL_CMD_DEVICE_GET - Get list of dpll devices (dump) or attributes
>>of
>>>+ *	single dpll device and it's pins
>>>+ * @DPLL_CMD_DEVICE_SET - Set attributes for a dpll
>>>+ * @DPLL_CMD_PIN_SET - Set attributes for a pin
>>>+ **/
>>>+enum dpll_cmd {
>>>+	DPLL_CMD_UNSPEC,
>>>+	DPLL_CMD_DEVICE_GET,
>>>+	DPLL_CMD_DEVICE_SET,
>>>+	DPLL_CMD_PIN_SET,
>>
>>Have pin get to get list of pins, then you can have 1:1 mapping to
>>events and loose the enum dpll_event_change. This is the usual way to do
>>stuff. Events have the same cmd and message format as get.
>
>I was thinking about that a bit more.
>1) There is 1:n relationship between PIN and DPLL(s).
>2) The pin configuration is independent on DPLL, with an
>   exeption of PRIO.
>

DPLL configuration is dependant on PIN configuration.
If the pin is configured with a frequency/mode all of dplls connected with =
it
shall know about it.

>Therefore as I suggested in the reply to this patch, the pin should be
>separate entity, allocated and having ops unrelated to DPLL. It is just
>registered to the DPLLs that are using the pin.
>

Don't mind having them as separated entities (as they are already separated=
 in
kernel space, allocated separately and registered with dpll/s as needed).
You might also remember that first version had the "global" list of pins, w=
hich
was removed due to the comments. For having get/dump pins command it would =
be
better to fallback to that approach, with global XA of pins in dpll_core.c.

>The pin ops should not have dpll pointer as arg, again with exception of
>PRIO.
>

Sure, probably with this approach we could remove dpll pointer for global-p=
in
attributes.

>DPLL_CMD_DEVICE_GET should not contain pins at all.
>
>There should be DPLL_CMD_PIN_GET added which can dump and will be used
>to get the list of pins in the system.
>- if DPLL handle is passed to DPLL_CMD_PIN_GET, it will dump only pins
>  related to the specified DPLL.
>

Sure, we agreed on that already.

>DPLL_CMD_PIN_GET message will contain pin-specific attrs and will have a
>list of connected DPLLs:
>       DPLLA_PIN_IDX
>       DPLLA_PIN_DESCRIPTION
>       DPLLA_PIN_TYPE
>       DPLLA_PIN_SIGNAL_TYPE
>       DPLLA_PIN_SIGNAL_TYPE_SUPPORTED
>       DPLLA_PIN_CUSTOM_FREQ
>       DPLLA_PIN_MODE
>       DPLLA_PIN_MODE_SUPPORTED
>       DPLLA_PIN_PARENT_IDX
>       DPLLA_PIN_DPLL    (nested)
>          DPLLA_DPLL_HANDLE   "dpll_0"
>          DPLLA_PIN_PRIO    1
>       DPLLA_PIN_DPLL    (nested)
>          DPLLA_DPLL_HANDLE   "dpll_1"
>          DPLLA_PIN_PRIO    2
>
>Please take the names lightly. My point is to show 2 nests for 2
>DPLLS connected, on each the pin has different prio.
>
>Does this make sense?
>

Seems good, I guess dpll referenced by giving their bus/name, as below.

>One issue to be solved is the pin indexing. As pin would be separate
>entity, the indexing would be global and therefore not predictable. We
>would have to figure it out differntly. Pehaps something like this:
>
>$ dpll dev show
>pci/0000:08:00.0: dpll 1             first dpll on 0000:08:00.0
>pci/0000:08:00.0: dpll 2             second dpll on the same pci device
>pci/0000:09:00.0: dpll 1             first dpll on 0000:09:00.0
>pci/0000:09:00.0: dpll 2             second dpll on the same pci device
>
>$ dpll pin show
>pci/0000:08:00.0: pin 1 desc SOMELABEL_A
>  dpll 1:                          This refers to DPLL 1 on the same pci
>device
>    prio 80
>  dpll 2:                          This refers to DPLL 2 on the same pci
>device
>    prio 100
>pci/0000:08:00.0: pin 2 desc SOMELABEL_B
>  dpll 1:
>    prio 80
>  dpll 2:
>    prio 100
>pci/0000:08:00.0: pin 3 desc SOMELABEL_C
>  dpll 1:
>    prio 80
>  dpll 2:
>    prio 100
>pci/0000:08:00.0: pin 4 desc SOMELABEL_D
>  dpll 1:
>    prio 80
>  dpll 2:
>    prio 100
>pci/0000:09:00.0: pin 1 desc SOMEOTHERLABEL_A
>  dpll 1:
>    prio 80
>  dpll 2:
>    prio 100
>pci/0000:09:00.0: pin 2 desc SOMEOTHERLABEL_B
>  dpll 1:
>    prio 80
>  dpll 2:
>    prio 100
>pci/0000:09:00.0: pin 3 desc SOMEOTHERLABEL_C
>  dpll 1:
>    prio 80
>  dpll 2:
>    prio 100
>pci/0000:09:00.0: pin 4 desc SOMEOTHERLABEL_C
>  dpll 1:
>    prio 80
>  dpll 2:
>    prio 100
>
>Note there are 2 groups of pins, one for each pci device.
>
>Setting some attribute command would looks like:
>To set DPLL mode:
>$ dpll dev set pci/0000:08:00.0 dpll 1 mode freerun
>   netlink:
>   DPLL_CMD_DEVICE_SET
>      DPLLA_BUS_NAME "pci"
>      DPLLA_DEV_NAME "0000:08:00.0"
>      DPLLA_DPLL_INDEX 1
>      DPLLA_DPLL_MODE 3
>
>$ dpll dev set pci/0000:08:00.0 dpll 2 mode automatic
>
>
>To set signal frequency in HZ:
>$ dpll pin set pci/0000:08:00.0 pin 3 frequency 10000000
>   netlink:
>   DPLL_CMD_PIN_SET
>      DPLLA_BUS_NAME "pci"
>      DPLLA_DEV_NAME "0000:08:00.0"
>      DPLLA_PIN_INDEX 3
>      DPLLA_PIN_FREQUENCY 10000000
>
>$ dpll pin set pci/0000:08:00.0 pin 1 frequency 1
>
>
>To set individual of one pin for 2 DPLLs:
>$ dpll pin set pci/0000:08:00.0 pin 1 dpll 1 prio 40
>   netlink:
>   DPLL_CMD_PIN_SET
>      DPLLA_BUS_NAME "pci"
>      DPLLA_DEV_NAME "0000:08:00.0"
>      DPLLA_PIN_INDEX 1
>      DPLLA_DPLL_INDEX 1
>      DPLLA_PIN_PRIO 40
>
>$ dpll pin set pci/0000:08:00.0 pin 1 dpll 2 prio 80
>
>
>Isn't this neat?
>
>
>[...]

Seems so.

As I suggested in other response on this thread, the best solution for
pin index, would be IMHO to allow registering driver assign index to a pin.
This would also solve/simplify sharing the pins. As the other driver would
just pass that index to register it with second dpll.

Also all dplls shall have the possibility to be notified that a pin which w=
as
registered with them has changed (except prio which is set only for single
dpll, and for prio only one callback shall be invoked).
This is because not all dplls which are sharing pins will be controlled by =
the
same FW/driver instance.
Currently for registering a pin with second dpll, the caller passes another
set of callback ops, which is then held in dpll_pin_ref - for all dplls whi=
ch
were registered with the pin. But as this is not always needed (i.e. same
instance controlling all dplls and pins), thus kernel module can pass ops=
=3DNULL
when registering a pin with second dpll, efectively executing only one call=
back
per pin.

Will try to have it done in next version.

Thanks,
Arkadiusz
