Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE79460C567
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 09:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbiJYHgo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 03:36:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231752AbiJYHgf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 03:36:35 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C482A4863;
        Tue, 25 Oct 2022 00:36:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666683393; x=1698219393;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=NvdOhaG+PSY9eLbGTulsLBkvMBQURwvpgijMojWBU5Q=;
  b=RZoqFgcJti/6qajLtWCsO3Dre+Ca1kwccarugY3bdhJP1DLF++yNztZD
   o42fiq6QrozK1LFTQlTo+ooY8x9mUBsSIxOgGOUtL3hPAe+xkf9IR5HbS
   trMbtuxEIDmPssC2uwhEH9/A3Fn+x/896Jo2BSIgbfltD/nBVc2CqZGCa
   a1F+nOnrhk34Uf5Ksd/0DhKcYu7PNFQR4PMPu9kfoCE7Th+BTSi/P2UTO
   w5yJVccX+Bjn/eHRDatWBwm7DUzr7OuAWMqhhhBcp3dX0TMxIQIIMDuDz
   Gd42ew7oSKvb8Galken1oUzpxeFAa4s24bBfuwPsNhCGQMxwwgHr9CZXg
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10510"; a="290913550"
X-IronPort-AV: E=Sophos;i="5.95,211,1661842800"; 
   d="scan'208";a="290913550"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2022 00:36:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10510"; a="806573908"
X-IronPort-AV: E=Sophos;i="5.95,211,1661842800"; 
   d="scan'208";a="806573908"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga005.jf.intel.com with ESMTP; 25 Oct 2022 00:36:32 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 25 Oct 2022 00:36:32 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 25 Oct 2022 00:36:32 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 25 Oct 2022 00:36:32 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 25 Oct 2022 00:36:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M644rYNgSHdZdga0wAlnWUTps+TNcJzICq3PRfW8vAITpnWW9yU6EtQrLTYvRrWyLeYcLmegtC0ozhUEpxxjaLA+47kpeymDIlU6YVKXXpes28nAg1oDfj/lcLeCDTVXyhJ2hR6uG4ZbWkaju8t06GDEobChuicPF3/3ItbnPP+pYqmFBDq8a/TgEHIQYR/OHaIKfFmxFKnUpPauaI/l9CTWbh9mibbD/kcE/VZz463RQ9t+LnXxQm0ZjnlckNe0b2tcb32w3ZLgPtB5MaIczQbFhjy0QLoU2jBb67Ch7cszdelY0MSGP4JViUV+4VltLmSEUDPNqNqBKVF3VM0l8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NvdOhaG+PSY9eLbGTulsLBkvMBQURwvpgijMojWBU5Q=;
 b=WtEpWeqWQgduqJJsHvN05/4fjNQEcStAKUy9LUrIrNICTfnBBc4CWX/rN2diNYf3vkCep4qktiKgX+Fu7+vmbIG4BmwvcIH7RijfwBsJZYER/c8VgVWuLtWU0m0hs+XiHxbr/ecqnaY4XIe49+uJK81ArutIZMLViZGTq+ByDcXnqEsOcDUE8WSATI5FPeHnKwjQs6KukcvZ7fMEpEh+5ZTWex01li7X65PtSIgayjmTcsoZpbYSBDuZvNDDI1Jk7MHje/HTlkQEWRBFO4MsC6qGVJT10KBDI+MMm9qyXAZScPamW+pH97VyVTttF+KMaRgKcfQACE5cdNHZoDGGWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5370.namprd11.prod.outlook.com (2603:10b6:408:11b::8)
 by DM4PR11MB5358.namprd11.prod.outlook.com (2603:10b6:5:395::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.25; Tue, 25 Oct
 2022 07:36:30 +0000
Received: from BN9PR11MB5370.namprd11.prod.outlook.com
 ([fe80::69e4:d3cf:7cd0:eb05]) by BN9PR11MB5370.namprd11.prod.outlook.com
 ([fe80::69e4:d3cf:7cd0:eb05%6]) with mapi id 15.20.5746.028; Tue, 25 Oct 2022
 07:36:30 +0000
From:   "Chang, Junxiao" <junxiao.chang@intel.com>
To:     Wong Vee Khee <veekhee@gmail.com>
CC:     "Joao.Pinto@synopsys.com" <Joao.Pinto@synopsys.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>
Subject: RE: [PATCH net-next 2/2] net: stmmac: remove duplicate dma queue
 channel macros
Thread-Topic: [PATCH net-next 2/2] net: stmmac: remove duplicate dma queue
 channel macros
Thread-Index: AQHY6EEm7jJPCAgddUeWQcsb4hb4Vq4euBvQ
Date:   Tue, 25 Oct 2022 07:36:30 +0000
Message-ID: <BN9PR11MB53707ADF7BB1AED2202AF758EC319@BN9PR11MB5370.namprd11.prod.outlook.com>
References: <03329169-560C-4319-AEBB-44BFFE959EBC@gmail.com>
In-Reply-To: <03329169-560C-4319-AEBB-44BFFE959EBC@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.500.17
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5370:EE_|DM4PR11MB5358:EE_
x-ms-office365-filtering-correlation-id: 725b3997-d59f-4a17-639f-08dab65ba1ff
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YxixbnlSBhSvlY8yINCqJvwbnaEWv4t6HwaSRoU6vPNnPEkLlVFBcV4YHDyBaVxXIi7r8SP1X2YxOl+WfqCzpu1WJaocA2IgI4oFRbukICMsStHS1bj+Fx9xpaM5yERxJ/btNk1eZM1VGDnamRtB65cHEO9gSk8YxRolkf2+5FPx29Pq5eH7SkTwME5XB13YHntuJ2B1paQt2RYPGjOD+cUHlfpMQmS7NNK1NnZV/sp7lBSHdARVRRMewFhlbpN4ZApf2cy1KTEk6kzQWYBnRy8vgrttXUhGzHNmIpxDfXcvjple4BCTdqvi91fOPWWCT8xo2uRDOdfuZdEc58v2cayfCr614IAvoNcmmrOAmPmZnPapTZBf5XgzzLjl1JP+ffdMv+t7IBksG9UjvX+wKPGq6cvz0X4P1Lp8lO1yRrYGPCsUkHDb5xZHM3HjCTa1fUNTQdKTLUF0IGnR0dpmESGgqBtliPJwwuiJ64c9SSyNXJ//EeXdXs4Jp39ftX5aI5D+9KiMX9i1WRWOKFPkIXmQ9ilxjBr/B0iQDmQcX5gbiMU/0hwS+OvB6CnJGj9jblHw6EDsKhpw7EPH+qFP/zV+sq/WUFJlV1cGCQsGVKiLlHTRXsEpQ2Mvw/asOKESXV2xI+rHX/Qy1Bady5LPqEC5kgPerBiktw7QtZG2Mu5VdnLdO9wp73U7+ac10PPmUQCeph48TbamdkaCY4iYvd5pBI4loZyz9rzcYRG3swWgfcGeolrYwZ2iuNjuQJbOPLXDwP4Bw30C7xD9cWfIhQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(366004)(346002)(136003)(39860400002)(451199015)(6506007)(53546011)(316002)(52536014)(76116006)(26005)(54906003)(4744005)(38070700005)(7416002)(6916009)(33656002)(4326008)(2906002)(86362001)(66556008)(66446008)(8676002)(64756008)(9686003)(8936002)(5660300002)(66946007)(66476007)(41300700001)(122000001)(7696005)(478600001)(83380400001)(55016003)(82960400001)(38100700002)(71200400001)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MXgwK1J6UHdjREFGeExITVZMNHFiVlRRTWI4NEJOZXJqVHR6RHUxS2orVVV2?=
 =?utf-8?B?REw1ZC95NFNlS243dGMvRjgyand2OXJhS1VMZ1EyU1djZVJaUHhSak9SRVRM?=
 =?utf-8?B?b3FQdjNLbVJlUDBFWmIvdDdzVDgzam5JVUpxaGNhckF1UjJtOGx6Y3B1OExz?=
 =?utf-8?B?K3d1V3dBOS9hUU9pdGJGcGNVVzN0eTZsUzM4UlE4TzFlODcvUXFpTk9iZWds?=
 =?utf-8?B?ZXJyRkVBRmNJK1pIZ1RzV3I3dGh4eUQvNS9RM29QYyt1VzMrRU1xQkcza2hp?=
 =?utf-8?B?eHVOTjd6clpkWUJmK0k4NGg5NkJyZGpnRWl6aTFDODNpQVBqczhKVHRkR1Fu?=
 =?utf-8?B?dU5QVjN6dWJyY0w4SnBGa0lCZWNsbVVtbWNVNU15OFRqYmFQS2M1MmN5akRB?=
 =?utf-8?B?Q0hUdnYvZElYaWtkMCtpcGQyMkVWR1BGT2xQMTNVV3Z5VjZiTDl2OUZTKzRK?=
 =?utf-8?B?VXEyamcraFpwNW4xdUtYc3dLZFUyekhpM3FMSVdVTk12a0FSbi91KzY5Rms4?=
 =?utf-8?B?Sks4czNOZzZUWGdLOEd5UTJVT2t5c0MyQS8zZkhFSk96T2dzUXlTTitYc3Ix?=
 =?utf-8?B?QXJkeEViSEJTUVVBQ2k5REgyMXYvN1IrekJ1RFhzV0V6eWhzejlpa0lhTysz?=
 =?utf-8?B?cWtLVW02b2hMZEN4WXJmUlYyTFByTEF5WUEzdUVHTjhJOWNVQ1RYZWhGQnFp?=
 =?utf-8?B?N29seG1ZSUxRaHQ2Tk5uUFZFNlEvRDQ1ZEdjVkVaaUVDMC9nbW1NZ2xFMlBI?=
 =?utf-8?B?VGVTZGlJckpnV3dZamFLSElXT0twV2VlVGJScWh6ak9aa0ZBVG9RUlcrdjVO?=
 =?utf-8?B?c00xSXBVSzhUbURrV2ZNZ29Cc0FSbEg1UmdGMG5LdlVtSUNaK1p4d3M4ais4?=
 =?utf-8?B?U0hoaWFXVnlGai85MGNWRlAzOWtqVGhRTlMxNENqd2V6OVRTTXgreDVDcks5?=
 =?utf-8?B?WWlVaTRxeklpN0hSeEY1U3lSU3ZTc2lMVUFVYkl2dWJ6UDJDcW56QjdFR1pn?=
 =?utf-8?B?S3Bub2pZUzltenJXb0YzRTJKUHlaY1g0THJZaUJKNnhnTGlPUVNvOEpSTGp6?=
 =?utf-8?B?a2NRZW9uR2MxVEZFTy9CcDNmRDdLblVmUjVGSWhON01hejRaS3kxUldRWE85?=
 =?utf-8?B?MHBhS1J3ek5LcURlYUVvUkFwMThLVHc2M1EvWTBKaWZKaEVQZ3I1S3FvVE5V?=
 =?utf-8?B?cDdUdm5PMVAxYXZ2OTBCN2FyVEFZVTJYNjM1eURjNGE1L3llMWluRlpzZXc2?=
 =?utf-8?B?WHExZnFYVzdYS1ZDRW9lelVpaGhoRXQyT2xUV2FaL2lnN01IanhkbXdvZU16?=
 =?utf-8?B?TzVSYkRaMHRqSFQ1bDlydlIrV3oyemZOWko2TEZXc2RSb2s2aGV0SlBDOWgr?=
 =?utf-8?B?REFsRXAyYVRURzlObmFRL2NIL3dTTHNtRk55WjFKb2xYM2dMbm5kK0Q0WjBX?=
 =?utf-8?B?MzVvQXoxNk9sUzZuaHFjOWd3L1dMRkNnRVdKdCt6eWVvRENXa1c1MXE1d2lX?=
 =?utf-8?B?M1lsRFNYKzZicXZETFRBK3JMT1prTTcyVk8xaE1kMDZINTZwbVRwb0JNRXNh?=
 =?utf-8?B?NlFBMjRHaml6ZnV1aTZEUGFwQ2dDTC82S3cyWjc0RCtzckR6bzRhUEU2QUhl?=
 =?utf-8?B?TlI5bHUwYXFXbDFJVU1tRU1pcmMwa3FtNlZxOU5pT2gxZnJMSEQvL1VZZmhP?=
 =?utf-8?B?MjFGdUhtN04xcVBxSndCZndDZ05qdFpya3Y1eDlxRS9iUGpsL1ZQTTRFN0Iw?=
 =?utf-8?B?ckNaNVpraXNCaGMvcHBBSlNRMStVK3hxM3poSXBLRGM4UkxZSDNRNVZxL0d1?=
 =?utf-8?B?d1JXbVMybE11TnROUEpmdXhvbjBvNzAyM1dPQXpkVmdONndQRHJ0TXlnYVJs?=
 =?utf-8?B?UnBteEw1OVFoUHZBZmYydHY3RVE1d3YzVW1sSGF2L3U1bG54SE0yOXVQMDlN?=
 =?utf-8?B?ak5CcnRjU1p4ODM4Q1VOWmo5am40T3pHZ1ZXSmY2VXRjNitTWFFadGs3UU5I?=
 =?utf-8?B?bm9STjN2WExTa2xvcEdvZVRZbXpVUE4xUElEK0RWSVFhaE8wb0pOVUh2TmlN?=
 =?utf-8?B?YS9WV3V6UTNWaWk5dmRGcWp4cko2SGYrTzRmZ2pXbGlHNzd1ZlIrcGhyYnJI?=
 =?utf-8?Q?M5X04tFnA4oaQtaxXm7HVAhur?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 725b3997-d59f-4a17-639f-08dab65ba1ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Oct 2022 07:36:30.2026
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FNT1nKMn1Rj4+iKFYaEM7ZSl3FJug9RJwW+1MWHSAMW6jRL+UJ4N1E8EGf7c8A8D/QkIs7eC+a/tWFRJaZLxow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5358
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgV2VlIEtoZWUsDQoNCkdvb2Qgc3VnZ2VzdGlvbiEg8J+Yig0KDQpJIHdpbGwgbWFrZSByZWxh
dGVkIHVwZGF0ZS4NCg0KUmVnYXJkcywNCkp1bnhpYW8NCg0KLS0tLS1PcmlnaW5hbCBNZXNzYWdl
LS0tLS0NCkZyb206IFdvbmcgVmVlIEtoZWUgPHZlZWtoZWVAZ21haWwuY29tPiANClNlbnQ6IFR1
ZXNkYXksIE9jdG9iZXIgMjUsIDIwMjIgMzoxMSBQTQ0KVG86IENoYW5nLCBKdW54aWFvIDxqdW54
aWFvLmNoYW5nQGludGVsLmNvbT4NCkNjOiBKb2FvLlBpbnRvQHN5bm9wc3lzLmNvbTsgYWxleGFu
ZHJlLnRvcmd1ZUBmb3NzLnN0LmNvbTsgZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsgZWR1bWF6ZXRAZ29v
Z2xlLmNvbTsgam9hYnJldUBzeW5vcHN5cy5jb207IGt1YmFAa2VybmVsLm9yZzsgbGludXgtYXJt
LWtlcm5lbEBsaXN0cy5pbmZyYWRlYWQub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3Jn
OyBsaW51eC1zdG0zMkBzdC1tZC1tYWlsbWFuLnN0b3JtcmVwbHkuY29tOyBtY29xdWVsaW4uc3Rt
MzJAZ21haWwuY29tOyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBwYWJlbmlAcmVkaGF0LmNvbTsg
cGVwcGUuY2F2YWxsYXJvQHN0LmNvbQ0KU3ViamVjdDogUmU6IFtQQVRDSCBuZXQtbmV4dCAyLzJd
IG5ldDogc3RtbWFjOiByZW1vdmUgZHVwbGljYXRlIGRtYSBxdWV1ZSBjaGFubmVsIG1hY3Jvcw0K
DQpXaHkgbm90IGNvbWJpbmUgd2l0aCB0aGUgb3RoZXIg4oCYaWYgKHF1ZXVlIDwgNCkuLiBlbHNl
4oCZIGluIHRoaXMgZnVuY3Rpb24gYWxsIHRvZ2V0aGVyPw0KDQpSZWdhcmRzLA0KVmVlIEtoZWUN
Cg==
