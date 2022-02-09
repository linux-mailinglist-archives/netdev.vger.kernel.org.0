Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E848B4AF804
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 18:25:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231791AbiBIRYs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 12:24:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238126AbiBIRYr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 12:24:47 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1FF1C05CB86;
        Wed,  9 Feb 2022 09:24:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644427491; x=1675963491;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=YR6l4hfH4Q7dLJfhA7AZJjtOLBGEWjV8yaQ3hvfzD8Y=;
  b=Fe1s26f/9JbC2gDF/QjLEsK+eiCPGQAg/r92SQQmnJiZ7/URKLnkKAL9
   oSOO8tAcJGYWXFRUnKb26LZQyA4ER6oAwUaYN1Fe3+XKv6hja7Zo9s1Q/
   WfAqKlssoWexRxi08M3K+nerrmtGghOuQ0TRX10e/WRj20rYTkYTdE2C5
   EMGrlolJSb50SZeFh8H1Og1rhEEyFtg/b8AGw1wN7G1QlktfdLGRDnDEW
   y8mAYZZ7WzGDhIO0Hh+TgIPtieP3jSUIqIiXPZPug58WtPryMPN1lEq6o
   Am8aoSsgQ7A6RGkeSJSjwuhg8uxbwmD8xIDMounmTSAv7IOSU1FlR1+qb
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10252"; a="232825121"
X-IronPort-AV: E=Sophos;i="5.88,356,1635231600"; 
   d="scan'208";a="232825121"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2022 09:22:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,356,1635231600"; 
   d="scan'208";a="568306399"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga001.jf.intel.com with ESMTP; 09 Feb 2022 09:22:37 -0800
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 9 Feb 2022 09:22:37 -0800
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 9 Feb 2022 09:22:36 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Wed, 9 Feb 2022 09:22:36 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.173)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Wed, 9 Feb 2022 09:22:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bomQawTHXXkppOH9ApzTm0YiEfQ6SQf11i9yoQznCF4lI1SC6kt/+jkgQcgAPKJnVzFB7MZJ5TedBMhks+EDgzwPpK/QECF8+wF/LEj5aNpvD7GO9CBmw0XqK5UXqj0t2mnDbAC/NbsT8c56oIBkDzvRvS6ZAOB+BSKr/6fkXuj00xJBiUy3YmE9U8PQESQiikQEjKHAR3MoJYrarOo7gtKu+NabCf1AGSi8F8YQ+JNj9R3y6xXFY7fO2iSLg1nhDDGrm4UmSWfNCvIPeo5VpQhP0SWMFB8EPH/FgJGR4bfo7o74s9agzZfN8V6vbgnVAgb0EnaDj4WQm1B3711tDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YR6l4hfH4Q7dLJfhA7AZJjtOLBGEWjV8yaQ3hvfzD8Y=;
 b=ZBv6eei7aatriadRKfzjC5Jl4keiahC4K/FzeZypEUsy6rfwQSkaED4JoV3eSYdmK5N3Uz9b6hVUHSswlHC5zJwXXqDj70PD6/4vHxZpYvB7kjjhr3RrQhocgU+fgtSdo0OCLyUCE4MIarUJUCU6lxlxDMxEIIzIok1jRY6klaciNBbfrrQY78am5EJMo0ZOK6d9hDbJymYzr+cKq2JtpsAMDC7UKjOThZXhki09WRvK3kHi7luJ5lQ9H5+aR4rcphzOeiT7kGWnFPHBYUmf7VOCF/VG27nJyW7CcZZ/dNxeIgMPJUwZ/lH1jJeL+IyzLThqn1jST5fpMJigZEYY4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by SN6PR11MB3213.namprd11.prod.outlook.com (2603:10b6:805:be::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.18; Wed, 9 Feb
 2022 17:22:32 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::bded:8c4b:271e:7c1]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::bded:8c4b:271e:7c1%5]) with mapi id 15.20.4951.019; Wed, 9 Feb 2022
 17:22:32 +0000
From:   "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
To:     "leon@kernel.org" <leon@kernel.org>
CC:     "jgg@nvidia.com" <jgg@nvidia.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 0/1] [pull request] iwl-next Intel Wired LAN
 Driver Updates 2022-02-07
Thread-Topic: [PATCH net-next 0/1] [pull request] iwl-next Intel Wired LAN
 Driver Updates 2022-02-07
Thread-Index: AQHYHH7HWBPuCWMiOE2S/3RcG/zIdayJ4Z8AgABIPACAANIdgIAAfkSA
Date:   Wed, 9 Feb 2022 17:22:32 +0000
Message-ID: <836cd77f7453e6b4b29aa1efd69142c8d447cb00.camel@intel.com>
References: <20220207235921.1303522-1-anthony.l.nguyen@intel.com>
         <20220208170000.GA180855@nvidia.com>
         <6591eabecd1959c1744828dad006860520708e9a.camel@intel.com>
         <YgOOaZbP/Jvlbt8Q@unreal>
In-Reply-To: <YgOOaZbP/Jvlbt8Q@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.4 (3.40.4-1.fc34) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2ddaf651-03e0-4be9-392c-08d9ebf0c1bf
x-ms-traffictypediagnostic: SN6PR11MB3213:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <SN6PR11MB32134F42005733EABD6FE30CC62E9@SN6PR11MB3213.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0CcMkQT2IpLhraG90EjQAUaUskH7Y4AhuYhwWVeFv/1SlMcDxx64cXIFcOvCMXcJfUEqYK8dPTS4y0boZZjSDuQQLHa1I0NRcgp8D4Uk0G3ZYfG25od+4ZwhLPObkr5Fjq6mDb2t3uhgYnHSXD/ee33V7t7Rj3v97boAYcv/3zExFj0NrmVmcAUCPAfhYrMT0pjeze9iJCzdjFntcqfriDkUshp2ua31KWQM0nZup+TY9MlgrIvF21Daw0uoiAX7yttrqhP/VQ5Pi+pSV5wxRW52zuTxq9+fFfJ+j3Wu+DxVOfodker98OAl297BQHgP7oc9hwmTiI1oQa3cGg02xGGTqik44EwKgwDdrJl5b2uPbYx9hNyhC8br6ygymcWsH6uP3J7E2UEkYJP/opztmL4Om3r8IdVGIdLjy4j1FI75ZIqwjXT216P531bjpS9euGR++njBog7V48O0XZqSpGQbQRr3wtzeTFqcxN1e1TdhnQdOZZ+VKFFCaO2b8MuAouv0Kg7cSlBitiNHgSi0wTWngRS0kDaBepq3LlU83eidp3JEG/sbeyyUMhSgueuldfDp0VV8/ekf4Sy/dUsg6hgBKp/VhjfqFrnUToITZDbkSMfoZaKb0FSzSOxnlUw8FK8CDHHPeX558HttRC3gtyodRUrKnLHIqpseOCHIjVVrVlQ64DZxrsQOKGN+9hHvNzDjewmdkY5OmNN5eNExAQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8676002)(86362001)(6486002)(54906003)(6506007)(38100700002)(82960400001)(6512007)(122000001)(316002)(71200400001)(4326008)(66556008)(66476007)(66446008)(64756008)(76116006)(5660300002)(91956017)(66946007)(6916009)(38070700005)(4744005)(2906002)(508600001)(8936002)(186003)(2616005)(26005)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RXhyWVkyN0pkYjArSXNENnpxSE0yUWhxb3NUWDNPSHFoSlFVdUpicGxXTHZj?=
 =?utf-8?B?enhyMk1qMzhQU3R6MWN6YWl6dnpQY1NSNkh3Y3o4dG9HSnNIRGd3NjBGb3hh?=
 =?utf-8?B?VTFVR2lBTWIzRUdzUU9UMG5nS3A4dk8yOS9yUmN1VjlPM0wvL0FUcG1PRitQ?=
 =?utf-8?B?R1psODBRdkNsZFpnT2R2VW5XTlNOc2gxbUphOW1BQkFGVHR1S2NoZVJTaElz?=
 =?utf-8?B?WWYxTmMydjRGcmpWVTVQbXI3WHNNMEJGUm9CT1g2VW5XdzFYU29YWVQyVmtF?=
 =?utf-8?B?cEJ0dkdyZkFkdHdPNkYxelVjL09TU2hWY1lLV2p3SFhvWnRpdXh6M29rQnY1?=
 =?utf-8?B?aFQxdUwzZDVGSGdQRDlHTDF5elRRaWV5ZjVVQklNRUY4N3RiNTYyUU9hUFFI?=
 =?utf-8?B?dG41cHlmSFN5Zlh0T1lTQ2dHL0hsT1BFZW1rdThPd0tuV2lwT3hiV29TSU1F?=
 =?utf-8?B?dDBuUzZhanRTckhqb2lrMmZMWlFSZHhQeVpMSml0dlFWMnVLT3NHK1RkUzIx?=
 =?utf-8?B?RnlpcDJQME8zYjkxRENzY3dDQks1akpPQWc3VTNWNmFubFdRaThrUW4yYm4y?=
 =?utf-8?B?RlllZzVvZ3VKa1g5elVkbjluNytla1BXSG00dFl3UjU5R1RhSWVWNkV1OGlB?=
 =?utf-8?B?L3JvKzQ3blBQbllySVNGWDdNd1hlYTNZd3lZZzAxOGExZ2VQR0tjZkhRUGFM?=
 =?utf-8?B?c0s3TmJrYUNzUWYwZmRGNkQwM1N1MDVqZ1c1RFlvQzVPd1RoY280bEsxSXVh?=
 =?utf-8?B?dXFPWmVPVE5WV0svTVhTdXVhUUVzTlh5UWlLYmlEenNocXA0cEEvREZQd1Va?=
 =?utf-8?B?WnlIU05WM0haZGpxeE1vdG9zWkx6aHFTdHJIRVIrUm9DeWFzODN4STlPRENN?=
 =?utf-8?B?Z0dhU3czWVZKYTloUmVyUWk1bGVTZ2Q1a1p1RXE4Q2xZOUQ5MEZ1Q3FDdjlP?=
 =?utf-8?B?MTBvZFhrNUZGdlNwMkVQUElBYnpQUDZuVmNFaVNyY0hZblJiOFMzanlJK1dk?=
 =?utf-8?B?V0xTTmZ1bW92RE5wSDNKYTluQkdHaXc3NmJNTm5KMElxL3pRN3gvNmFydGZq?=
 =?utf-8?B?Mzk5ZmhxMktITGtJd1crU0JxdnBMckpTOWx3TU1kV0xWcmFZYnNhQ1Awa2dE?=
 =?utf-8?B?WENTc1lKazdER3pJaGFIVUJ2bTA2NGRsejVuZTkrM2xaM3JvZExDUkJ0aFlG?=
 =?utf-8?B?Yms3TkFkZkRoU0pMOHl5Rzg5OS9qWnFCazZ0YVhOYzFQZFB2bjkzSUFxN1JD?=
 =?utf-8?B?TVZhNEE3N2M4eG9Mdmo4Vk5TUEhKVXo2VUhxTzF2eHF5VFlMRXpTaEhqWWtz?=
 =?utf-8?B?VGNMZzJjSmVDcnFlc29DWjR0R1pEY3psTnFXMDJnVTEzN3BUS0RTK2RCcThG?=
 =?utf-8?B?U0xCR2lVZzErMjZnYUZuL2RkOExLQmozRnJJNnFKVERUcTlqbFMrdi95TzhX?=
 =?utf-8?B?QjJZSllPWFV5MFV0ZXk2bmhHTlFpRzFzQUEzMzlwYmN4dzJDamN5STdUTC9C?=
 =?utf-8?B?Wk1uQ3J2MG9CbWJkVzlaOWZqa2ROMlRSR0VaV1RCbFJJK2JQeHh1K0pqRWdx?=
 =?utf-8?B?K0o4eVJOZUNpV3MvYkJvU1lNS2doTnU2TUg5TDZpT0ZqR2NpSnBOUm9kN0c4?=
 =?utf-8?B?N1VjZWNFVGFFNFZqL0ZyWHQyazlnVDBBRnFxNThveVZBNFFHeE1Lck1rOU1s?=
 =?utf-8?B?ZkhUUEVoTTRwLzBOYXFLNjdSVmVEOEpyYlhDc2VRNWNiOU1qcXB1YnYxcmJN?=
 =?utf-8?B?bloyUEl2eDh3d2k3MGhKOW50K1VTSm9aT3pZR1lLSnJnSmt5djBsYmNtUUh3?=
 =?utf-8?B?Zkx3NEdkMWYrOFpoUVVnTTFtN2NiQktIK0kxalZMVllMbnh0a1l4cFpNZEFa?=
 =?utf-8?B?R01nenJHT1ZHUnhiNndKZlR3cit0YnBTRUNjdVlEbS9VSHdkRmpXSEs0ZzRs?=
 =?utf-8?B?bzBkUTFnTXBFdzEycXlwejk4Z25VMkRmUS9Vb1F5MTR5YmdYcEk3bVNzMVRn?=
 =?utf-8?B?eGhQWnZZSFh2QjArSHI1c2FtTmpZeUFvYnRoWkV5TTQ4YUUwbEhjbVh5eXZl?=
 =?utf-8?B?a2I4VW9qdFFEVWN0NnFWczljWjJuMzR3TzZVZkxRTVRhZFp0NWlFeGVZcTZk?=
 =?utf-8?B?VHhmMUxmVW9kVEFHbzFhN3ZSWGV4c1Z4blBnalZGN09EUTd3V0lpUkU3WGQx?=
 =?utf-8?B?clFFeG9zS3lpelpZaXBIK3dNT3JISE5mZWIzcnhoWWVmOHNPUFRjT2M0ZHdG?=
 =?utf-8?Q?617WAfRQzEcW8pI6y3MlcFePa0ssjkfk41eP6p1XZs=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <16E1E4FAE319A04AA7E859EACE620547@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ddaf651-03e0-4be9-392c-08d9ebf0c1bf
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2022 17:22:32.4223
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NFZZdblIvs6QbRaA2XAo0w8Z/Z9Nn2hAnLofmPUkead8/jd1ibO6qO0YAinwp+FUOtHUHZCsqf59jUwipSHVvI8OwfvJ5g7KNb1F5bnZ7KY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3213
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIyLTAyLTA5IGF0IDExOjUwICswMjAwLCBMZW9uIFJvbWFub3Zza3kgd3JvdGU6
DQo+IE9uIFR1ZSwgRmViIDA4LCAyMDIyIGF0IDA5OjE4OjM2UE0gKzAwMDAsIE5ndXllbiwgQW50
aG9ueSBMIHdyb3RlOg0KPiA+IE9uIFR1ZSwgMjAyMi0wMi0wOCBhdCAxMzowMCAtMDQwMCwgSmFz
b24gR3VudGhvcnBlIHdyb3RlOg0KPiA+ID4gT24gTW9uLCBGZWIgMDcsIDIwMjIgYXQgMDM6NTk6
MjBQTSAtMDgwMCwgVG9ueSBOZ3V5ZW4gd3JvdGU6DQo+ID4gPiANCj4gDQo+IEl0IG1lYW5zIHRo
YXQgc29tZXRpbWVzIGJvdGggbmV0ZGV2IGFuZCBSRE1BIHBhdGNoZXMgd2lsbCBiZSB0aGVyZSwN
Cj4gaG93ZXZlciBzdWNoIHNpdHVhdGlvbiBpcyBub3QgY29tbW9uIGZsb3cuIE1vc3Qgb2YgdGhl
IHRpbWUsIHlvdSB3aWxsDQo+IHB1dCBvbmx5IG5ldGRldiBjaGFuZ2VzIHRoZXJlLCBiZWNhdXNl
IHlvdXIgZHJpdmVyIGNvcmUgbG9naWMgbGF5cw0KPiB0aGVyZSBhbmQgaXQgaXMgdGhlcmUgdGhl
IGNvbmZsaWN0cyB3aWxsIGJlLg0KPiANCj4gSG93ZXZlciwgdGhlcmUgYXJlIG1pbmltYWwgc2V0
IG9mIHJ1bGVzIHdoaWNoIHlvdSBzaG91bGQgZm9sbG93Og0KPiAxLiBUaGlzIGJyYW5jaCBzaG91
bGQgYmUgYmFzZWQgb24gY2xlYW4gLXJjWC4gTm8gYmFjayBtZXJnZSBvZiBuZXQtDQo+IG5leHQN
Cj4gb3IgcmRtYS1uZXh0IG9yIG90aGVyIC1uZXh0Lg0KPiAyLiBCaXNlY3RhYmxlDQo+IDMuIFBv
c3NpYmxlIHRvIHB1bGwgYXMgYSBzdGFuZGxvbmUgc2V0IHdpdGhvdXQgZXh0cmEgcGF0Y2hlcyBv
biB0b3ANCj4gYW5kIGl0IHdvbid0IGJyZWFrIGNvbXBpbGF0aW9uIGFuZC9vciB3b3JraW5nIHRh
cmdldCB3aGljaCBwdWxsZWQNCj4gdGhpcw0KPiBicmFuY2guDQoNClRoaXMgaGVscHMuIFRoYW5r
cyBmb3IgdGhlIGluZm9ybWF0aW9uIExlb24uDQoNCi0gVG9ueQ0K
