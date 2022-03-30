Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66A854EB80C
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 03:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241760AbiC3B64 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 21:58:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241753AbiC3B64 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 21:58:56 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1097181790;
        Tue, 29 Mar 2022 18:57:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648605432; x=1680141432;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=iuMmXF0bNQe1Xj+DzX6bzAAwgBj+1eidK1z/nORUGrA=;
  b=GZ4fiCL0WvyER+3VCo95o/Ac9uXSMa2ntu+Fx8lrYPh5BnfWrKT8yZx4
   Gbilh/MiwOUHB4xOFiF6jtYVYLZ/6xWF3sJAJ7Fb3HuLSiU8SoyxN42KC
   P6tN427vQKKOhWKQs7s7CDyyme972AE0OPBcVC31S+Xmm46hopuMqLljD
   qtfU1eMDSAuwevty1anCA731L6peR1BwyNDtwBdylocBh5QTWsYcF+Ni3
   NumwgrxKeAibxlV9J31VfvdAWfEDN8iGK0Qe/86Vx50nO4ZDxkF9G5OOd
   vftPka8n47aDwwZ45w01NWbNliQCJ+wA7u16SPxvET1utT4PyAXp5a/3k
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10301"; a="241579993"
X-IronPort-AV: E=Sophos;i="5.90,221,1643702400"; 
   d="scan'208";a="241579993"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2022 18:57:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,221,1643702400"; 
   d="scan'208";a="546653111"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga007.jf.intel.com with ESMTP; 29 Mar 2022 18:57:11 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 29 Mar 2022 18:57:11 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 29 Mar 2022 18:57:10 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Tue, 29 Mar 2022 18:57:10 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.107)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Tue, 29 Mar 2022 18:57:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fHDWGhfScYCWuF3CWkMmUtTx9H5bhIJBKtgAx8sFLF00obyxX6H5Gp1s0HIfqnrHc/D0Mpxcm5sJY5UoMiaHRuIz50GVHzUv+H39xKaTbM4UojhwvJSjsE7iV5jZcI+83NPT73+OCv9A3tsudd+CErFaIPES5Kj05mlleqtC/Gjj/4qe4DL2AslEQJmegJOwevdEZhRayPfl+3/CIMT5h9o9/kWwXP6Hp3kiOLKPkX2ogo87Qscas5jQ2H2GazFN90e7oc2pw+Usw2vh6zue08RVlr/Kqmg1KERBbz7yQ+U9Rf+Fdys6A+ePs1Jif1waW2azHKGwbznLlqGsWEpWhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iuMmXF0bNQe1Xj+DzX6bzAAwgBj+1eidK1z/nORUGrA=;
 b=ZlJ4Xtt1y6JVb+GAeRsAzlcw76BPvsTRYnL0zxzrlob+XBKM/TzVBuamLbh8DbeLozaOEAaAKK0doU9liYl/t2YKYvCBQT1X7W/iRVTgAXk6QX4GafQifE6YJP2m2NpIfHQ33T1euvl07FyICo1roR29AKGgqVVtc0uxGvQEU2yEmnFVpiz9+xoeyoAXGVyG06U/di6sbwkSucUJ+fPkK6RBxVfSj4wYLwq3OTZckIYUd977NHhVg7u75dg5j59ihMDFzhMbLVVNPs5xqGxvvuodeaal4/Fg5996oORrzDQeeiT1zGUZCINfuisMFH8Ct0+EW5N/dllw6QzoRAZNiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB5880.namprd11.prod.outlook.com (2603:10b6:510:143::14)
 by BL0PR11MB3268.namprd11.prod.outlook.com (2603:10b6:208:67::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.18; Wed, 30 Mar
 2022 01:57:08 +0000
Received: from PH0PR11MB5880.namprd11.prod.outlook.com
 ([fe80::d90e:5a21:8192:7c54]) by PH0PR11MB5880.namprd11.prod.outlook.com
 ([fe80::d90e:5a21:8192:7c54%7]) with mapi id 15.20.5102.023; Wed, 30 Mar 2022
 01:57:08 +0000
From:   "Zhang, Qiang1" <qiang1.zhang@intel.com>
To:     syzbot <syzbot+4d0ae90a195b269f102d@syzkaller.appspotmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "pfink@christ-es.de" <pfink@christ-es.de>,
        "syzkaller-bugs@googlegroups.com" <syzkaller-bugs@googlegroups.com>,
        "wg@grandegger.com" <wg@grandegger.com>
Subject: RE: [syzbot] memory leak in gs_usb_probe
Thread-Topic: [syzbot] memory leak in gs_usb_probe
Thread-Index: AQHYQ4DV1H7CRbsUNkiTZLs8PGYT1KzXKcOA
Date:   Wed, 30 Mar 2022 01:57:08 +0000
Message-ID: <PH0PR11MB5880D90EDFAA0A190D927914DA1F9@PH0PR11MB5880.namprd11.prod.outlook.com>
References: <000000000000bd6ee505db5cfec6@google.com>
In-Reply-To: <000000000000bd6ee505db5cfec6@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.6.401.20
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3a57432e-4f9b-4827-e89b-08da11f09913
x-ms-traffictypediagnostic: BL0PR11MB3268:EE_
x-microsoft-antispam-prvs: <BL0PR11MB326896FE2C08EED7A81B9804DA1F9@BL0PR11MB3268.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9QEpZjqDSJ74PAzjKl9liAFFq9zfyQHMhtUpPAeyhmhOYeA7vxgKe+ZzSPl93uv+sLVomh8HKadiSaXneR6NZklsdsawwuXKWZriCbnQt0G6BUtHEjEQCR9HTGghNN9IRLCZyxIsq2FfdJl+pCtXaylxnamQqkp1rh66R2RWQamDn6gB6uHexai0KRfNMfDo3Zf8UWivbJOIOIR/GZw7RvvMiJH8KMashMEAe1C1a4E+G7sOrpOlhC6cxJ+C9JhY/bf7U0x3ULJ/JeP1w00CeCCzhmrqzqcnK/tQTKt2Q6m60Fl6MnLYzIHpqAnhUzxV/1tt7g6x3QbUcRvtzsF/treIUKRNuDCWAlG8F7ZfFHhdMkKZE8dLmsR+T5KBuLnlwjInxpVby6BLM0Ft73YeeyQpGPvBaT3gADGrkT4MZ61X/29xIj3sszwx4WDRRsRvlp5f2TUK1z/GY2/2LxQY6rbd7UEPJh3BYMAw9Ri3vUMigNX29bIbaphN2brhV28v+OTv7XzgLf5hojyDzdIkH4xv8ix1IO2a4Jbty4zTe0ZeuW/LeaOfyn9w7XZBATumtp7X74NuCxqf60gScZ1NWQ8ohCHZ6j7MaNvrXxh+0DXpVFwVx/vKHg2wrcNFcJbNyOqn+XjuHyx7WPz58MGCdjWZL0hAxFRE+zXeB54wWoNZdd/iDZLT3amAHvHqRvNfXsnOjgkwy1Qq+Y3IWH6+750RngrpFwUIjn4XmYKGgmjLQ6EQBHnL8Pbqf6LW4iGN+oYyK9obpTJ8RlMABibfkv8oClFpZyV1atgPWPy1Th8TiyAUg89G+oj/8NWE+IHoFUgr3X0z0KYl2OGoGOtlKZ635GOeigfPoa6JkEimeJ/QHfwmKKXjxbDRqnjz2oLoFIKpIqX80U0Xi9zDwFXLxQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5880.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(7696005)(6506007)(8676002)(9686003)(66446008)(71200400001)(86362001)(66476007)(66946007)(64756008)(8936002)(508600001)(316002)(2906002)(966005)(76116006)(110136005)(66556008)(122000001)(921005)(26005)(82960400001)(5660300002)(186003)(55016003)(33656002)(38070700005)(83380400001)(38100700002)(52536014)(7416002)(99710200001)(505234007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RDVLZ0UxZW5Rdit0MWltQlFjalp5eUFrZ2dyOGpqb29KenhTcVk4emZBM2hn?=
 =?utf-8?B?d1pFb2x3bVluZ0JWeThpWDJMbGE4V0xFTmlTYm40UmFoU1U3WFM5RVRlUlNR?=
 =?utf-8?B?S3pPTHhSR3F4N2x5OGloTnNtUlZmbWdHUlJIRFJtVDB5VkpSZkFyaG4vNVpM?=
 =?utf-8?B?WXpTSVlFU29KV3Ntck1zQk90b09wOFNkb1BWd3o3eVRKUjh0V2I0VDZsbW01?=
 =?utf-8?B?ZEJXdFVBK3JmSEJ6aHhUYmRicjBUUWNMSFBESjVNNXVHb09FMUtPY0Z3ZURS?=
 =?utf-8?B?bnBadHVBbFU3VjFxNlRTcVdvZ0lNdHZ5MjJRYWFNSzZqRU85RUZzZTFITVoz?=
 =?utf-8?B?QXpVTXlwSzNYdzZWRXNDZUp0RkgvQzhJaHAvWU9IallyU2FnNjNJaEdyT2pN?=
 =?utf-8?B?WWhzUS9pR0VBWml3Sm14NlJDUXplMU1TbmQ2YUw5Z3dMN2tRVmFkY1k1akY4?=
 =?utf-8?B?VWVYUGNaWWhYSmlsRXYwMzJMelNlZlRITnJic2pXZng3dmRSbnBEQ2tQV0Vi?=
 =?utf-8?B?NDkwM2VFK2FXTDJLN2tDVmRNOWVUazd2Mlp1NWlMVkpDV2ZtMUUwU1VReU1Q?=
 =?utf-8?B?Y2ppbktoSExQZVh2Wjh5UE1aOE55U3JmMkVLSFd6QmV5MUpHd0FESEZRU2c4?=
 =?utf-8?B?Y04xdjIybTFpdy95ZUJRdnJDcmVCYXM4VWRNWmlhclpmZkgvZmVpc1o0bHNW?=
 =?utf-8?B?TENrR1dyem5RWURwU0IxbDVRWHVJSTF4STQvOXNrMkhLRXZFSnlVSEZ2dFh0?=
 =?utf-8?B?WExJeVlDbHZlUVV1N1AwbDdUZjd4NHlubWlvUzVINTBPSXlFT21Telora0JG?=
 =?utf-8?B?RzA2QUoyY1RZeHR0NEtxOGdzajVHaWhDVW54OEVCVTBKQzNORU4xS2lDTDNx?=
 =?utf-8?B?ZnNEL05SSVdEUjNvYjNGd1NVOHdqekdyQUZwcmdZdDljV0VpdUxUc0tBQzFB?=
 =?utf-8?B?a3ZCMWlEVy83VjdGaEdHTDlNdHpWSlBWY295QUQ4TFRtTGhHeENkdm55elk3?=
 =?utf-8?B?aXZISXJJbEd6c0RsVGRCWTFxcEpndjJ5a01yajZVdGkxOWFGR3pNa0hEVVZo?=
 =?utf-8?B?MGVRd2s5VnVFaE8rcGJoSWJxeTBYd2Q4NEthZW81aXVQMFVOOGNtN0Z4RWlt?=
 =?utf-8?B?UXRWOEdHTnN5SE5MelR3c3lTbXVUNFpOWS9ETWpOTlhrVWZReXc2TVNpeGlD?=
 =?utf-8?B?RytZZEc3R0ZQMTQ4enNnQ21SQ1pKaUhGTXZLU1VUUjd2dzJ1N2NHQnV6UXFI?=
 =?utf-8?B?b3RrMUdKTnJxcHVJSW9ONVVLbWxZMWpBYXZGOTMzZTVWWUlHWE1RRnU5RzNk?=
 =?utf-8?B?bTNkRVo5aUVBdlJaa0FDUy9pMVA5QXFWNGxtSlBubm0vNUtReDFuRzlhNEVw?=
 =?utf-8?B?UXNINE5EWkNsbGZFR3pOV25CaDVDRUEwVVlabmVXeHVreU9iMjhnL1VXaHU0?=
 =?utf-8?B?RUJnRXlrWk8yZDZacVR6YUNVUk1sYm12UjNiKzFwbEhRRUU5TWZEQXljaDFE?=
 =?utf-8?B?azdaOG1hYXBsYldCeGlCekZSaUxWSFpLb1dXcFhwbjJwWTJSOC9ueVRLcmlX?=
 =?utf-8?B?TkJXTUxHeHNPemdnbVlZWDlWcFAxZmtBMG1GRlEyNVJWdThnSUhKRFdHT01V?=
 =?utf-8?B?WEFRbzVYaHkxMUNHWjNJdm9SS1dZOEYvTGtWSzZjb3lFOUJEalpyeXQxK05i?=
 =?utf-8?B?ZTVOanJ1N0dpb0VjK0FzaENTVEV2Ukl3TVJ5bitIeGFQOEJXUlVlN1lUYVB2?=
 =?utf-8?B?eGZ5QWJKU3NYekFkTmZjeURCWWR5RlF5cHJiTXV4bjBkWGR4MkRYV2pvbVhk?=
 =?utf-8?B?SnFWeUNpYkV0bFZHYWcxUVczcU9ObWpWK0JQazRLQW54alRKS3hJbXlVZU9r?=
 =?utf-8?B?d0YrWnVtTkYzVnkzQzZEZ1M4N0VEdDZTL0JlU1lsT2pqTmVCNmNZV09VVkgx?=
 =?utf-8?B?eXFQOXZLdEpnN2ZVeTFOMmxOemxzMXg4QmlHN05qZ0hHbFRXY08zN1cxaTdS?=
 =?utf-8?B?QUYya3ZPOGZDdGJmd1pONHVRdDhKaUNPVE9PU3BFWm5FSUNja3BvaGlPRFpP?=
 =?utf-8?B?dnV5cHBEU1l4L3JHd2srTjJKYnBOUG1oTmVJbzUxV1UwYXJ3V29SekJORHc4?=
 =?utf-8?B?L1RSWlVjdFV4SnFkNVNmMnpKWWJlR3Vabm45TmFiMU5tRVJBbnhrbmlueVVM?=
 =?utf-8?B?K0NvMjV0YUx3UHRIYlhUWElaY0hkdlFqVzJubnRqSHNIU1VLUGR2ekdmTmx6?=
 =?utf-8?B?MGxVM0V4bDNjUVFuby9uV1JyYW9YcXdVSjF3R0xKWkVEeEtpYWNWaExCODJN?=
 =?utf-8?B?d0VwVWsxYWR5NG0ySUhNZkdjQUtCMmlpWTI0cFBZcUtxdTh2emdqUT09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5880.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a57432e-4f9b-4827-e89b-08da11f09913
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Mar 2022 01:57:08.3595
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: f/gnalJauCmkQAfM+cFEcuKO1OXQFevCnCanmApFb4AF7Q5NrWISnbPSogdDCYiUVrrFh320SH8G+r+7NLTOYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR11MB3268
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SORTED_RECIPS,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGVsbG8sDQoNCnN5emJvdCBmb3VuZCB0aGUgZm9sbG93aW5nIGlzc3VlIG9uOg0KDQpIRUFEIGNv
bW1pdDogICAgNTJkZWRhOTU1MWEwIE1lcmdlIGJyYW5jaCAnYWtwbScgKHBhdGNoZXMgZnJvbSBB
bmRyZXcpDQpnaXQgdHJlZTogICAgICAgdXBzdHJlYW0NCmNvbnNvbGUgb3V0cHV0OiBodHRwczov
L3N5emthbGxlci5hcHBzcG90LmNvbS94L2xvZy50eHQ/eD0xMmI0NzJkZDcwMDAwMA0Ka2VybmVs
IGNvbmZpZzogIGh0dHBzOi8vc3l6a2FsbGVyLmFwcHNwb3QuY29tL3gvLmNvbmZpZz94PTljYTJh
NjdkZGIyMDAyN2YNCmRhc2hib2FyZCBsaW5rOiBodHRwczovL3N5emthbGxlci5hcHBzcG90LmNv
bS9idWc/ZXh0aWQ9NGQwYWU5MGExOTViMjY5ZjEwMmQNCmNvbXBpbGVyOiAgICAgICBnY2MgKERl
YmlhbiAxMC4yLjEtNikgMTAuMi4xIDIwMjEwMTEwLCBHTlUgbGQgKEdOVSBCaW51dGlscyBmb3Ig
RGViaWFuKSAyLjM1LjINCnN5eiByZXBybzogICAgICBodHRwczovL3N5emthbGxlci5hcHBzcG90
LmNvbS94L3JlcHJvLnN5ej94PTEyZTk2ZTFkNzAwMDAwDQpDIHJlcHJvZHVjZXI6ICAgaHR0cHM6
Ly9zeXprYWxsZXIuYXBwc3BvdC5jb20veC9yZXByby5jP3g9MTJmOGI1MTM3MDAwMDANCg0KSU1Q
T1JUQU5UOiBpZiB5b3UgZml4IHRoZSBpc3N1ZSwgcGxlYXNlIGFkZCB0aGUgZm9sbG93aW5nIHRh
ZyB0byB0aGUgY29tbWl0Og0KUmVwb3J0ZWQtYnk6IHN5emJvdCs0ZDBhZTkwYTE5NWIyNjlmMTAy
ZEBzeXprYWxsZXIuYXBwc3BvdG1haWwuY29tDQoNCkJVRzogbWVtb3J5IGxlYWsNCnVucmVmZXJl
bmNlZCBvYmplY3QgMHhmZmZmODg4MTBlNGZjMzAwIChzaXplIDk2KToNCiAgY29tbSAia3dvcmtl
ci8xOjEiLCBwaWQgMjUsIGppZmZpZXMgNDI5NDk0ODEwMiAoYWdlIDE1LjA4MHMpDQogIGhleCBk
dW1wIChmaXJzdCAzMiBieXRlcyk6DQogICAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAg
MDAgMDAgMDAgMDAgMDAgMDAgIC4uLi4uLi4uLi4uLi4uLi4NCiAgICAwMCAwMCAwMCAwMCAwMCAw
MCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAgLi4uLi4uLi4uLi4uLi4uLg0KICBiYWNr
dHJhY2U6DQogICAgWzxmZmZmZmZmZjg0M2ZjYzA4Pl0ga21hbGxvYyBpbmNsdWRlL2xpbnV4L3Ns
YWIuaDo1ODEgW2lubGluZV0NCiAgICBbPGZmZmZmZmZmODQzZmNjMDg+XSBnc19tYWtlX2NhbmRl
diBkcml2ZXJzL25ldC9jYW4vdXNiL2dzX3VzYi5jOjEwNjUgW2lubGluZV0NCiAgICBbPGZmZmZm
ZmZmODQzZmNjMDg+XSBnc191c2JfcHJvYmUuY29sZCsweDY5ZS8weDhiOCBkcml2ZXJzL25ldC9j
YW4vdXNiL2dzX3VzYi5jOjExOTENCiAgICBbPGZmZmZmZmZmODJkMGE2ODc+XSB1c2JfcHJvYmVf
aW50ZXJmYWNlKzB4MTc3LzB4MzcwIGRyaXZlcnMvdXNiL2NvcmUvZHJpdmVyLmM6Mzk2DQogICAg
WzxmZmZmZmZmZjgyNzEyZDg3Pl0gY2FsbF9kcml2ZXJfcHJvYmUgZHJpdmVycy9iYXNlL2RkLmM6
NTE3IFtpbmxpbmVdDQogICAgWzxmZmZmZmZmZjgyNzEyZDg3Pl0gcmVhbGx5X3Byb2JlLnBhcnQu
MCsweGU3LzB4MzgwIGRyaXZlcnMvYmFzZS9kZC5jOjU5Ng0KICAgIFs8ZmZmZmZmZmY4MjcxMzEy
Yz5dIHJlYWxseV9wcm9iZSBkcml2ZXJzL2Jhc2UvZGQuYzo1NTggW2lubGluZV0NCiAgICBbPGZm
ZmZmZmZmODI3MTMxMmM+XSBfX2RyaXZlcl9wcm9iZV9kZXZpY2UrMHgxMGMvMHgxZTAgZHJpdmVy
cy9iYXNlL2RkLmM6NzU1DQogICAgWzxmZmZmZmZmZjgyNzEzMjJhPl0gZHJpdmVyX3Byb2JlX2Rl
dmljZSsweDJhLzB4MTIwIGRyaXZlcnMvYmFzZS9kZC5jOjc4NQ0KICAgIFs8ZmZmZmZmZmY4Mjcx
M2E5Nj5dIF9fZGV2aWNlX2F0dGFjaF9kcml2ZXIrMHhmNi8weDE0MCBkcml2ZXJzL2Jhc2UvZGQu
Yzo5MDINCiAgICBbPGZmZmZmZmZmODI3MGZjZjc+XSBidXNfZm9yX2VhY2hfZHJ2KzB4YjcvMHgx
MDAgZHJpdmVycy9iYXNlL2J1cy5jOjQyNw0KICAgIFs8ZmZmZmZmZmY4MjcxMzYxMj5dIF9fZGV2
aWNlX2F0dGFjaCsweDEyMi8weDI2MCBkcml2ZXJzL2Jhc2UvZGQuYzo5NzMNCiAgICBbPGZmZmZm
ZmZmODI3MTE5NjY+XSBidXNfcHJvYmVfZGV2aWNlKzB4YzYvMHhlMCBkcml2ZXJzL2Jhc2UvYnVz
LmM6NDg3DQogICAgWzxmZmZmZmZmZjgyNzBkZDRiPl0gZGV2aWNlX2FkZCsweDVmYi8weGRmMCBk
cml2ZXJzL2Jhc2UvY29yZS5jOjM0MDUNCiAgICBbPGZmZmZmZmZmODJkMDdhYzI+XSB1c2Jfc2V0
X2NvbmZpZ3VyYXRpb24rMHg4ZjIvMHhiODAgZHJpdmVycy91c2IvY29yZS9tZXNzYWdlLmM6MjE3
MA0KICAgIFs8ZmZmZmZmZmY4MmQxODFhYz5dIHVzYl9nZW5lcmljX2RyaXZlcl9wcm9iZSsweDhj
LzB4YzAgZHJpdmVycy91c2IvY29yZS9nZW5lcmljLmM6MjM4DQogICAgWzxmZmZmZmZmZjgyZDA5
ZDVjPl0gdXNiX3Byb2JlX2RldmljZSsweDVjLzB4MTQwIGRyaXZlcnMvdXNiL2NvcmUvZHJpdmVy
LmM6MjkzDQogICAgWzxmZmZmZmZmZjgyNzEyZDg3Pl0gY2FsbF9kcml2ZXJfcHJvYmUgZHJpdmVy
cy9iYXNlL2RkLmM6NTE3IFtpbmxpbmVdDQogICAgWzxmZmZmZmZmZjgyNzEyZDg3Pl0gcmVhbGx5
X3Byb2JlLnBhcnQuMCsweGU3LzB4MzgwIGRyaXZlcnMvYmFzZS9kZC5jOjU5Ng0KICAgIFs8ZmZm
ZmZmZmY4MjcxMzEyYz5dIHJlYWxseV9wcm9iZSBkcml2ZXJzL2Jhc2UvZGQuYzo1NTggW2lubGlu
ZV0NCiAgICBbPGZmZmZmZmZmODI3MTMxMmM+XSBfX2RyaXZlcl9wcm9iZV9kZXZpY2UrMHgxMGMv
MHgxZTAgZHJpdmVycy9iYXNlL2RkLmM6NzU1DQogICAgWzxmZmZmZmZmZjgyNzEzMjJhPl0gZHJp
dmVyX3Byb2JlX2RldmljZSsweDJhLzB4MTIwIGRyaXZlcnMvYmFzZS9kZC5jOjc4NQ0KDQpCVUc6
IG1lbW9yeSBsZWFrDQp1bnJlZmVyZW5jZWQgb2JqZWN0IDB4ZmZmZjg4ODEwZTRmYzI4MCAoc2l6
ZSA5Nik6DQogIGNvbW0gImt3b3JrZXIvMToxIiwgcGlkIDI1LCBqaWZmaWVzIDQyOTQ5NDg4MTkg
KGFnZSA3LjkxMHMpDQogIGhleCBkdW1wIChmaXJzdCAzMiBieXRlcyk6DQogICAgMDAgMDAgMDAg
MDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgIC4uLi4uLi4uLi4uLi4uLi4N
CiAgICAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAwMCAgLi4u
Li4uLi4uLi4uLi4uLg0KICBiYWNrdHJhY2U6DQogICAgWzxmZmZmZmZmZjg0M2ZjYzA4Pl0ga21h
bGxvYyBpbmNsdWRlL2xpbnV4L3NsYWIuaDo1ODEgW2lubGluZV0NCiAgICBbPGZmZmZmZmZmODQz
ZmNjMDg+XSBnc19tYWtlX2NhbmRldiBkcml2ZXJzL25ldC9jYW4vdXNiL2dzX3VzYi5jOjEwNjUg
W2lubGluZV0NCiAgICBbPGZmZmZmZmZmODQzZmNjMDg+XSBnc191c2JfcHJvYmUuY29sZCsweDY5
ZS8weDhiOCBkcml2ZXJzL25ldC9jYW4vdXNiL2dzX3VzYi5jOjExOTENCiAgICBbPGZmZmZmZmZm
ODJkMGE2ODc+XSB1c2JfcHJvYmVfaW50ZXJmYWNlKzB4MTc3LzB4MzcwIGRyaXZlcnMvdXNiL2Nv
cmUvZHJpdmVyLmM6Mzk2DQogICAgWzxmZmZmZmZmZjgyNzEyZDg3Pl0gY2FsbF9kcml2ZXJfcHJv
YmUgZHJpdmVycy9iYXNlL2RkLmM6NTE3IFtpbmxpbmVdDQogICAgWzxmZmZmZmZmZjgyNzEyZDg3
Pl0gcmVhbGx5X3Byb2JlLnBhcnQuMCsweGU3LzB4MzgwIGRyaXZlcnMvYmFzZS9kZC5jOjU5Ng0K
ICAgIFs8ZmZmZmZmZmY4MjcxMzEyYz5dIHJlYWxseV9wcm9iZSBkcml2ZXJzL2Jhc2UvZGQuYzo1
NTggW2lubGluZV0NCiAgICBbPGZmZmZmZmZmODI3MTMxMmM+XSBfX2RyaXZlcl9wcm9iZV9kZXZp
Y2UrMHgxMGMvMHgxZTAgZHJpdmVycy9iYXNlL2RkLmM6NzU1DQogICAgWzxmZmZmZmZmZjgyNzEz
MjJhPl0gZHJpdmVyX3Byb2JlX2RldmljZSsweDJhLzB4MTIwIGRyaXZlcnMvYmFzZS9kZC5jOjc4
NQ0KICAgIFs8ZmZmZmZmZmY4MjcxM2E5Nj5dIF9fZGV2aWNlX2F0dGFjaF9kcml2ZXIrMHhmNi8w
eDE0MCBkcml2ZXJzL2Jhc2UvZGQuYzo5MDINCiAgICBbPGZmZmZmZmZmODI3MGZjZjc+XSBidXNf
Zm9yX2VhY2hfZHJ2KzB4YjcvMHgxMDAgZHJpdmVycy9iYXNlL2J1cy5jOjQyNw0KICAgIFs8ZmZm
ZmZmZmY4MjcxMzYxMj5dIF9fZGV2aWNlX2F0dGFjaCsweDEyMi8weDI2MCBkcml2ZXJzL2Jhc2Uv
ZGQuYzo5NzMNCiAgICBbPGZmZmZmZmZmODI3MTE5NjY+XSBidXNfcHJvYmVfZGV2aWNlKzB4YzYv
MHhlMCBkcml2ZXJzL2Jhc2UvYnVzLmM6NDg3DQogICAgWzxmZmZmZmZmZjgyNzBkZDRiPl0gZGV2
aWNlX2FkZCsweDVmYi8weGRmMCBkcml2ZXJzL2Jhc2UvY29yZS5jOjM0MDUNCiAgICBbPGZmZmZm
ZmZmODJkMDdhYzI+XSB1c2Jfc2V0X2NvbmZpZ3VyYXRpb24rMHg4ZjIvMHhiODAgZHJpdmVycy91
c2IvY29yZS9tZXNzYWdlLmM6MjE3MA0KICAgIFs8ZmZmZmZmZmY4MmQxODFhYz5dIHVzYl9nZW5l
cmljX2RyaXZlcl9wcm9iZSsweDhjLzB4YzAgZHJpdmVycy91c2IvY29yZS9nZW5lcmljLmM6MjM4
DQogICAgWzxmZmZmZmZmZjgyZDA5ZDVjPl0gdXNiX3Byb2JlX2RldmljZSsweDVjLzB4MTQwIGRy
aXZlcnMvdXNiL2NvcmUvZHJpdmVyLmM6MjkzDQogICAgWzxmZmZmZmZmZjgyNzEyZDg3Pl0gY2Fs
bF9kcml2ZXJfcHJvYmUgZHJpdmVycy9iYXNlL2RkLmM6NTE3IFtpbmxpbmVdDQogICAgWzxmZmZm
ZmZmZjgyNzEyZDg3Pl0gcmVhbGx5X3Byb2JlLnBhcnQuMCsweGU3LzB4MzgwIGRyaXZlcnMvYmFz
ZS9kZC5jOjU5Ng0KICAgIFs8ZmZmZmZmZmY4MjcxMzEyYz5dIHJlYWxseV9wcm9iZSBkcml2ZXJz
L2Jhc2UvZGQuYzo1NTggW2lubGluZV0NCiAgICBbPGZmZmZmZmZmODI3MTMxMmM+XSBfX2RyaXZl
cl9wcm9iZV9kZXZpY2UrMHgxMGMvMHgxZTAgZHJpdmVycy9iYXNlL2RkLmM6NzU1DQogICAgWzxm
ZmZmZmZmZjgyNzEzMjJhPl0gZHJpdmVyX3Byb2JlX2RldmljZSsweDJhLzB4MTIwIGRyaXZlcnMv
YmFzZS9kZC5jOjc4NQ0KDQoNCiNzeXogdGVzdDogIGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9z
Y20vbGludXgva2VybmVsL2dpdC9uZXh0L2xpbnV4LW5leHQuZ2l0ICBtYXN0ZXINCg0KZGlmZiAt
LWdpdCBhL2RyaXZlcnMvbmV0L2Nhbi91c2IvZ3NfdXNiLmMgYi9kcml2ZXJzL25ldC9jYW4vdXNi
L2dzX3VzYi5jDQppbmRleCA2NzQwOGUzMTYwNjIuLjUyMzRjZmZmODRiOCAxMDA2NDQNCi0tLSBh
L2RyaXZlcnMvbmV0L2Nhbi91c2IvZ3NfdXNiLmMNCisrKyBiL2RyaXZlcnMvbmV0L2Nhbi91c2Iv
Z3NfdXNiLmMNCkBAIC0xMDkyLDYgKzEwOTIsNyBAQCBzdGF0aWMgc3RydWN0IGdzX2NhbiAqZ3Nf
bWFrZV9jYW5kZXYodW5zaWduZWQgaW50IGNoYW5uZWwsDQogICAgICAgICAgICAgICAgZGV2LT5k
YXRhX2J0X2NvbnN0LmJycF9pbmMgPSBsZTMyX3RvX2NwdShidF9jb25zdF9leHRlbmRlZC0+ZGJy
cF9pbmMpOw0KDQogICAgICAgICAgICAgICAgZGV2LT5jYW4uZGF0YV9iaXR0aW1pbmdfY29uc3Qg
PSAmZGV2LT5kYXRhX2J0X2NvbnN0Ow0KKyAgICAgICAgICAgICAgIGtmcmVlKGJ0X2NvbnN0X2V4
dGVuZGVkKTsNCiAgICAgICAgfQ0KDQogICAgICAgIFNFVF9ORVRERVZfREVWKG5ldGRldiwgJmlu
dGYtPmRldik7DQoNCg0KVGhhbmtzLA0KWnFpYW5nDQoNCg0KLS0tDQpUaGlzIHJlcG9ydCBpcyBn
ZW5lcmF0ZWQgYnkgYSBib3QuIEl0IG1heSBjb250YWluIGVycm9ycy4NClNlZSBodHRwczovL2dv
by5nbC90cHNtRUogZm9yIG1vcmUgaW5mb3JtYXRpb24gYWJvdXQgc3l6Ym90Lg0Kc3l6Ym90IGVu
Z2luZWVycyBjYW4gYmUgcmVhY2hlZCBhdCBzeXprYWxsZXJAZ29vZ2xlZ3JvdXBzLmNvbS4NCg0K
c3l6Ym90IHdpbGwga2VlcCB0cmFjayBvZiB0aGlzIGlzc3VlLiBTZWU6DQpodHRwczovL2dvby5n
bC90cHNtRUojc3RhdHVzIGZvciBob3cgdG8gY29tbXVuaWNhdGUgd2l0aCBzeXpib3QuDQpzeXpi
b3QgY2FuIHRlc3QgcGF0Y2hlcyBmb3IgdGhpcyBpc3N1ZSwgZm9yIGRldGFpbHMgc2VlOg0KaHR0
cHM6Ly9nb28uZ2wvdHBzbUVKI3Rlc3RpbmctcGF0Y2hlcw0K
