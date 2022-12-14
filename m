Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34B0B64CD85
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 16:57:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbiLNP52 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 10:57:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238618AbiLNP4j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 10:56:39 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6ED623EB1;
        Wed, 14 Dec 2022 07:56:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671033398; x=1702569398;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+OPR67C55sB3uSzkPAzaHuJltyNluW9EHNhnVCZiWwI=;
  b=aMmdFj1w/vZvkChMpw6HoQsj8ibAwAe1cOF6hMh/OZk8NJeXFC81fo+K
   0fucPtJPnMAyqXY4V84v2qP5HaAxnZFqDKjN0ELH5EtMzCTsoiXXhQ6pW
   WsVGKprCKnaYpcFA+iM7ux0FXDKqdka6lh4vTl20VJgzlxYTPW+m+Voa8
   zkEY7VNHS0lG+lBfkQht57dpQ8YGiMRmYiLym/ytz80BHbT4TaLLM5XGc
   3zjJ+BMSTVsr+ltRDDAXkbLc5DoMbJzYj8+cUndNi2lLIyN3k9CBTHA54
   dLYeRF6qdX8vbL/pjgI92YpDfTRPe+AAdxLIoro6koPdWuUJy9jorvjk1
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10561"; a="317142982"
X-IronPort-AV: E=Sophos;i="5.96,244,1665471600"; 
   d="scan'208";a="317142982"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2022 07:56:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10561"; a="651139190"
X-IronPort-AV: E=Sophos;i="5.96,244,1665471600"; 
   d="scan'208";a="651139190"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga007.fm.intel.com with ESMTP; 14 Dec 2022 07:56:18 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 14 Dec 2022 07:56:17 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 14 Dec 2022 07:56:17 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.172)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 14 Dec 2022 07:56:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RyRUVK78p883LkyGKqbKoeYSZyJ+8FK7fHp4MQDmNqtELzNlnf6mtIx5RbOOqVRaefeGNHh279oIVkkmVoW5sYXGHi3S0AiB0O40945WKDBiuzZngouXVY2rZAtSFx+unutemHHAmtvCvM/7JiUKrM3XwBwfN2qgKeNUh/r0XJFjXw1qmrioZS7Ug5Id5fkNwtr0vcpeiCV4ya5KXfMC5DARDUBVGUzIQ+ZZGax9gSaT08ejBDOkjpcTFVIyYtOo2HpYJH8gapj2aCAxhB0unIXEIQNDyxqvTslSVXsC184KDGedChy6M9EeH9nI3WgSqY7LF0CKgYDRVAH7uzFSBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+OPR67C55sB3uSzkPAzaHuJltyNluW9EHNhnVCZiWwI=;
 b=XfcAZz5Mc2JnMiDLinB+QbIxm3hXceY4JcsBpxAn1P2nWvFLbXDoJFUGUm/QdWf6hE4Y3Jz652PXn8OdwPxvsR8Y1A72WZOnj6+qXD75d+JQxZxvzeX6d0DB34zAxAKNfmxbHMoo33XvOQJlBqsRe9g7bRoHbuG/3o/3I4qTfJvTOAXLa/CjgeNNSOg1xNq9bODxzGlS7UMPdyssT1OcSKIh48FfGoSLHVdt75JXxfeh5gXKuofz5IsMw1a1dLqj8jsCwGVNFBam2azRtUsxxXJTEmuw3NqUaWJXiEMRqpQ/t1RWTH7G2NKXVUEbzgWfq8LzaZZa+yxraS0nHWCYHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CY4PR1101MB2360.namprd11.prod.outlook.com (2603:10b6:903:b9::9)
 by BL1PR11MB5494.namprd11.prod.outlook.com (2603:10b6:208:31d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11; Wed, 14 Dec
 2022 15:56:15 +0000
Received: from CY4PR1101MB2360.namprd11.prod.outlook.com
 ([fe80::bf04:7e33:140:cb15]) by CY4PR1101MB2360.namprd11.prod.outlook.com
 ([fe80::bf04:7e33:140:cb15%11]) with mapi id 15.20.5924.011; Wed, 14 Dec 2022
 15:56:15 +0000
From:   "Sarkar, Tirthendu" <tirthendu.sarkar@intel.com>
To:     Alexander H Duyck <alexander.duyck@gmail.com>,
        "tirtha@gmail.com" <tirtha@gmail.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>
Subject: RE: [PATCH intel-next 0/5] i40e: support XDP multi-buffer
Thread-Topic: [PATCH intel-next 0/5] i40e: support XDP multi-buffer
Thread-Index: AQHZDwvFjm+LEA64qkCmo+zgR8QXEq5th9EQ
Date:   Wed, 14 Dec 2022 15:56:15 +0000
Message-ID: <CY4PR1101MB2360D262A260CCE7ED0FD87390E09@CY4PR1101MB2360.namprd11.prod.outlook.com>
References: <20221213105023.196409-1-tirthendu.sarkar@intel.com>
 <cf6f03d04c8f2ad2627a924f7ee66645d661d746.camel@gmail.com>
In-Reply-To: <cf6f03d04c8f2ad2627a924f7ee66645d661d746.camel@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CY4PR1101MB2360:EE_|BL1PR11MB5494:EE_
x-ms-office365-filtering-correlation-id: ddd60ab7-b38f-4281-68f1-08daddebbb53
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BkFX7bpdGinCwSDdbC45Oc87jC4jeUjpPxSXKjjglktMthcN0SnCw7Ubit8IOYHA3Q+0SpvF5OWbl+qX5CzyTeSd21M18r3eTFrmoUKEqyzaigMYFQyh15Al86iyBXEv0XeirU+ptT35+i8HuSxn19UMvY9ThfOGjK9BO4TnVuabV33warTOSO5H4pIfTvyNr9IsBB9+38dbng9qCUCaRVeXrGrSbFjD64zsb5tB3mg4HULX3IS7C4KNAzX2oMNBlViNLnhfhMVSh6bqVIbSWbeHS4kHSFR17Q6Pbr0tHJNNQbRtFf1Ok0UMPIkxPBFUJHuk4zpsfoUODhVASaEqsd4nMhHkV1xcXn5MXPcCZBHg3qzpRGsahcHd5Kox+F+6CvjtbJ+OFvgQZsfrGyw7FQLf+S9RkuWeg5r0nOJ5hsFtlteeoLFk6sAstBcce1EnAw71tH1e0Tm5GoCOZIZfZcRMwqHlo/0sLcHKI5xbZEOeTmSgFPdclNpRc7rZIA7kIXw3DByjm19oeogIRnwvg6XxiDrL7dpGILLouqbF/LVqXhV2DePpTdql4VhYuUY1FoSGfBQkBJzYnY6ch45vnqkZI5X9mVEDaGXSab2xGgbLn3T4ys33Ri/kLPxFYVzlAUTwn2BlcQLHYAdgezT8ysDm+14KUZoP2vkoX9NgZwDj+hl6qtGCdeYbONRQDvvz43eLGlfIiofHrhH0kQA1BN7wAcg4+CGSKSjGlXOgLnI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1101MB2360.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(39860400002)(346002)(136003)(366004)(396003)(451199015)(55016003)(52536014)(107886003)(38070700005)(54906003)(8936002)(110136005)(5660300002)(122000001)(7416002)(2906002)(33656002)(316002)(41300700001)(6506007)(7696005)(478600001)(66556008)(66476007)(66946007)(71200400001)(66446008)(86362001)(64756008)(4326008)(8676002)(38100700002)(83380400001)(4744005)(921005)(9686003)(82960400001)(186003)(76116006)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dmpUSjE2MUUwVXZTQ2JQOTh6VGgyb2d0bnp1Wk1zL3g1YjE0aDA0c2tIZzBS?=
 =?utf-8?B?dmRjaCtYUENNUnpsOTNzNWREZWt0NDEySVBOVmgrVW5yeGNEQ0NGa3E4bEpl?=
 =?utf-8?B?ekk0YmliMnI3T3hIcFpBNzZLU0ZTcDhSTnFuR0Njc2dMK3Evd1JFV1RHWS9W?=
 =?utf-8?B?RDJrSm1OaE02Y0tZYkF6enEvSHRkd29yYXMxeWdhenFtemZuRC8zSWJwVzBu?=
 =?utf-8?B?c2dSQ1UvQWFsU3hoRzFTSFp5YVI1MDhEK3ZUS2VoL1owNXhiRFF5VExpTnJk?=
 =?utf-8?B?Tk1VNGZ4ZExKNWlvNGowSlljTlNIYS9CdE9ZOStwYzA3OUk2ZTJyK256eFRS?=
 =?utf-8?B?S25rOGJyMkxQNWI3OGp6bTZJeDRNSXhJTkVuMlUvMDd4TUR5RFBNZXV4U04v?=
 =?utf-8?B?ZHFjSFducytOdzBjcjh3dHFMOGtNdENrR3hNTlN3dWZZMk1kQmwrUUR4QTNx?=
 =?utf-8?B?a0UzVG9jQU1YNWJMekFpOWVFZ3Yzb2F3Q2JrendQdGUzbXc2MStLUWJINmoz?=
 =?utf-8?B?eDRWdG8xNFVDL28vUWNqTW9FQnYyTTZlUEdxVWtmZjBRWFMxcHlydXpMU3g1?=
 =?utf-8?B?YlgyYUlmKzRlbGxBU093alhneFFwbDBLK0l1cnk4V0dteXIvOFNTOG1wRkxx?=
 =?utf-8?B?eGNrbXNuUmErMXR3WE5ERmovRkRjV3pCcnZvQUQydUZWK3haQVE0NUowelk4?=
 =?utf-8?B?dDFQa2VHTWFQY0dqck8zai9mcFRNcmlLS2VJa2lLYlJKY3ZPSnFONmh2S0Jj?=
 =?utf-8?B?SzdoSU1hM2xiMnZMK0lRZU9lc2VnL1FSc2lxZ1U1dWVVTlBwT0M5cHNjSUpw?=
 =?utf-8?B?WkxZaHA1R1hlK0o0U2hJTENNdDAyYm1xdHArbDRGOFQzLyswY0phTC9Pb0xo?=
 =?utf-8?B?cVRKWTRtZUNONkJVOWtUN2tMSDJwL3krYWxXM2JscTZGcWtkd1M1WlpNcFV4?=
 =?utf-8?B?emdqWE5FbVgrY0RQN0J6MXhMYWpTVFd4T1p1bkJwSWwraUpISVYzdGwwZjdD?=
 =?utf-8?B?ZittclNBTlQzYTNtanhHZjhrN1NRNVdiOGpQUjJlS0RsenJpOW1ZSUlicFBR?=
 =?utf-8?B?SHFmeUYyRGY4RXh2YVpGTnNKTkJGU0JWRVlrSzhEZXNDZXNSeG5QcldQZksz?=
 =?utf-8?B?dE5EWnExTVhpcm1MMTFrY0ovSUFOcmZEVUdSUUhWd1NkZjZ4Q294VnhtTklO?=
 =?utf-8?B?dGdzUG1xVVBuM0lCMmVybkV0eVFERzdSUUorZVVObnI4K2FMdEU1OUNPaFVv?=
 =?utf-8?B?YzdMTVNZOFhoQlE2V0tDdzR6QklEOUJrUGF2dTRqVU14dmprRTllNzRCc1ZZ?=
 =?utf-8?B?elRlSW1mKzFXTzhaTXlDWEF0VjRlU1VxUDJya3k0U3lOT2l5em52M1lWOHlq?=
 =?utf-8?B?d3JVUWt0TFYrR1ZrbGFIemtQV21sa0FDSWtLR1p0YkZJZWM5YmdUZFl4cEdG?=
 =?utf-8?B?bUM3WnhMdEdTVVoxQXZvemsrTHpwdTZyU21ieURjaGdyd2o4RFpwZ3lkWm9B?=
 =?utf-8?B?UUs0K2pEWjZUYjlHMzlhUkY4eFFDZE1NNlo4ZHAwUTdXeitMQ2JJdk5Oc2RT?=
 =?utf-8?B?Smw2aUpJZGZTQm53a3BQUTJ2czcvK1ZRV1pwTHg3SnhvOHhhc0xHdGNsbmRC?=
 =?utf-8?B?WFhQL3RBOW93UDVIeXp4L0ZlUVZLYmRFR251S0xhNXZtbDBtZGFlRUdOY2pE?=
 =?utf-8?B?cWRTTW9WNUhGVTNDT0JZN0k0ZXhDN2ZWK083WnYwOFNidUJjRjQrMHVmSDB3?=
 =?utf-8?B?a2xQb3hrVnc3Z3Y0ekpWOXZoc3B2b1F4N2dhVEhzTzZRRldpdXNCM3dKNDYr?=
 =?utf-8?B?dDlHNGNsOWZtRzgrTGhkekhiOTFKWTBVbEpmYVA4ZmlTWnI2aWZyMm5qMXBI?=
 =?utf-8?B?KzltTlR3U1RlUWdtNTEwR285dngreHNuazVBaDExdVNMdE1pbFIwTEorVVBo?=
 =?utf-8?B?aURkUklPbTV5azE0NGRhWnNlcFFCamFjMkFzVVRUdlJqSndPVitmREFmQzdz?=
 =?utf-8?B?Y3VXVzZQYzRGVVFVZmhhMS8zOTFtOVRFdXVGWFl2YjRBMlRycTd1NzcyZVJr?=
 =?utf-8?B?UzIrbnE5UXFNbUd6SXFLYys1NWVwZWFXTklJbnJ3emQ0cmRzUFQyTmx6STVP?=
 =?utf-8?B?ODk2Q1NSakxRVndoWCtnRiszUVVpZm50ZUc2TTJLdXZzLzdlZjhWRG5WVnNt?=
 =?utf-8?B?RlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1101MB2360.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ddd60ab7-b38f-4281-68f1-08daddebbb53
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Dec 2022 15:56:15.6049
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TjypAQqPCh0s1CShw7I1EWe5hrNT5pPfGndpoEg9WE7Qntx/SCRxUg17FPUdrn0z37PjR8rbkJIf3GJBaGbNl3OtQ174HQe8cktMQzsdUz4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5494
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBGcm9tOiBBbGV4YW5kZXIgSCBEdXljayA8YWxleGFuZGVyLmR1eWNrQGdtYWlsLmNvbT4NCj4g
U2VudDogVHVlc2RheSwgRGVjZW1iZXIgMTMsIDIwMjIgOToyOCBQTQ0KPiANCj4gVGhpcyBhcHBy
b2FjaCBzZWVtcyBraW5kIG9mIGNvbnZvbHV0ZWQgdG8gbWUuIEJhc2ljYWxseSB5b3UgYXJlIHRy
eWluZw0KPiB0byBjbGVhbiB0aGUgcmluZyB3aXRob3V0IGNsZWFuaW5nIHRoZSByaW5nIGluIHRo
ZSBjYXNlcyB3aGVyZSB5b3UNCj4gZW5jb3VudGVyIGEgbm9uIEVPUCBkZXNjcmlwdG9yLg0KPiAN
Cj4gV2h5IG5vdCBqdXN0IHJlcGxhY2UgdGhlIHNrYiBwb2ludGVyIHdpdGggYW4geGRwX2J1ZmYg
aW4gdGhlIHJpbmc/IFRoZW4NCj4geW91IGp1c3QgYnVpbGQgYW4geGRwX2J1ZmYgdy8gZnJhZ3Mg
YW5kIHRoZW4gY29udmVydCBpdCBhZnRlciBhZnRlcg0KPiBpNDBlX2lzX25vbl9lb3A/IFlvdSBz
aG91bGQgdGhlbiBzdGlsbCBiZSBhYmxlIHRvIHVzZSBhbGwgdGhlIHNhbWUgcGFnZQ0KPiBjb3Vu
dGluZyB0cmlja3MgYW5kIHRoZSBwYWdlcyB3b3VsZCBqdXN0IGJlIGRyb3BwZWQgaW50byB0aGUg
c2hhcmVkDQo+IGluZm8gb2YgYW4geGRwX2J1ZmYgaW5zdGVhZCBvZiBhbiBza2IgYW5kIGZ1bmN0
aW9uIHRoZSBzYW1lIGFzc3VtaW5nDQo+IHlvdSBoYXZlIGFsbCB0aGUgbG9naWMgaW4gcGxhY2Ug
dG8gY2xlYW4gdGhlbSB1cCBjb3JyZWN0bHkuDQoNCldlIGhhdmUgYW5vdGhlciBhcHByb2FjaCBz
aW1pbGFyIHRvIHdoYXQgeW91IGhhdmUgc3VnZ2VzdGVkIHdoaWNoIHNvcnQgDQpvZiBpcyBhIGJp
dCBjbGVhbmVyIGJ1dCBub3QgZnJlZSBvZiBhIGJ1cmRlbiBvZiBnZXR0aW5nIHRoZSByeF9idWZm
ZXIgc3RydWN0IA0KYmFjayBhZ2FpbiBmb3IgYWxsIG9mIHRoZSBwYWNrZXQgZnJhZ3MgcG9zdCBp
NDBlX3J1bl94ZHAoKSBmb3IgcmVjeWNsaW5nLg0KV2Ugd2lsbCBleGFtaW5lIGlmIHRoYXQgdHVy
bnMgb3V0IHRvIGJlIGJldHRlci4NCg==
