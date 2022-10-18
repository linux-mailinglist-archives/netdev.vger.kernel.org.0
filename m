Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A260602D39
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 15:43:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230442AbiJRNm6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 09:42:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230130AbiJRNmw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 09:42:52 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3C18CD5D8;
        Tue, 18 Oct 2022 06:42:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1666100570; x=1697636570;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=zpCphiPKThYD/drQXazl6BaN7k6Q/zKuSi27+EflJXM=;
  b=wdEQDMyiBBz5rnNTeTnNhS/HTIZWg1H17joTsaEpLDdC81tkFpOxHhtB
   Kc78UiASzaTUGUR0lwqtJ3VcfK+60XhfUmD5Nfp70C5+XaTo7CNoyXeYT
   VrgPus4vugvhQRGaBlVLae9UGFNLoRyMcl4dWhY884th90gaHHZemc6KS
   4+M5ANROog7yLO2Og9CPWO7rJexPQ0A/5bXkAEDUvvUN6D+n3mUglpHdT
   48FZtXY80eT8BDOfl1ytpZsov86mTqrVD73zyslSgZG3xa6+xpMkMlE7N
   3ibUq44tM+A4axmQG6N+rBPAj11+q4EN7oWN/XEv4KysQyKL3j6x4tqOQ
   Q==;
X-IronPort-AV: E=Sophos;i="5.95,193,1661842800"; 
   d="scan'208";a="119186819"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 18 Oct 2022 06:42:48 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 18 Oct 2022 06:42:47 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12 via Frontend Transport; Tue, 18 Oct 2022 06:42:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iMV+HGbkDU9L2BhPy/q9tgsFVsp9lIY90GlCd9P85Mjs/pwadugPSuoPMq3d3RqOVcaPXaSxqUUzjD8vclOZjUvVUvQ3rkGT+4p3fxG2qbtokgd8PB8OltWtnHlL0kyVNfBBxq//HNSOkzOnr7TqBZNEhENecFLOOnt48W3HOhIRqm9eEIs9Jwinq64qEHjf13UdcxTALh695B8CBM8wl9atQ11MaUlJGCHWibGvrVkD7BfxzEY89gcRJxcgI6wIK7DFo8krTBdKr0cYeW4kCo/X7tvD1M8VXGHh99GFvpiZ4w8zDuspEp9Z7EJhmQ4Tc++cc+iw99gcdeSqFaZU7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zpCphiPKThYD/drQXazl6BaN7k6Q/zKuSi27+EflJXM=;
 b=mK1kCW8SUKpJNlNi6M8BCHwv/nVCEVgfYXgEqeJ52HN6H2iLSPYuw75M9p5NLYgDa/DqZRySTxDkM7PDCC5ZMyRkGb7zWaIbWdZFcU3tYkHyXsNJYKPZfVNdTe2YJoFTJC0oxACZ8YsIqjtsPSU75QM9eIjPuGGeU0k4J23/7tNvr5h9foPKGaZ2KmuuOrUhEdIpxVfswD5Vks9K+oN2v8llNJ7R+qavIIok5zqW6ryV5uWjkrNgIqUfW0Ojn8etv76s5kfH6fxIWdEoWTvfcM8+v87EkKeNJsDhlT+LJclT1DVsxR3EULkE4tKiI4vXkYPA3VoW3GhilBRfqlWZFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zpCphiPKThYD/drQXazl6BaN7k6Q/zKuSi27+EflJXM=;
 b=dHuLtE3eItMmfhgUDLn7N4vSpszgz/DVSDFRsP6e4jcXQD6VsdQmYcXpAgiQrYg7v3Xc18jp8tvjhe1viDNKCpWPFAI6BVaWWHCG4h2v8nHCQzUm6VWI//5bKre4IBQSUEfUm0Ili/bp0Z3nFcNm2VhO50bDV+tDh5dJwZzocxw=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 MW5PR11MB5788.namprd11.prod.outlook.com (2603:10b6:303:198::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.30; Tue, 18 Oct
 2022 13:42:41 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::faca:fe8a:e6fa:2d7]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::faca:fe8a:e6fa:2d7%3]) with mapi id 15.20.5723.034; Tue, 18 Oct 2022
 13:42:41 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <olteanv@gmail.com>
CC:     <andrew@lunn.ch>, <linux-kernel@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>, <vivien.didelot@gmail.com>,
        <linux@armlinux.org.uk>, <ceggers@arri.de>,
        <Tristram.Ha@microchip.com>, <f.fainelli@gmail.com>,
        <kuba@kernel.org>, <edumazet@google.com>, <pabeni@redhat.com>,
        <richardcochran@gmail.com>, <netdev@vger.kernel.org>,
        <Woojung.Huh@microchip.com>, <davem@davemloft.net>,
        <b.hutchman@gmail.com>
Subject: Re: [RFC Patch net-next 0/6] net: dsa: microchip: add gPTP support
 for LAN937x switch
Thread-Topic: [RFC Patch net-next 0/6] net: dsa: microchip: add gPTP support
 for LAN937x switch
Thread-Index: AQHY3+HGUZklSl35HUmvWc+BxQ194q4S2WcAgADg2oCAAD73AIAANf6A
Date:   Tue, 18 Oct 2022 13:42:41 +0000
Message-ID: <d8459511785de2f6d503341ce5f87c6e6064d7b5.camel@microchip.com>
References: <20221014152857.32645-1-arun.ramadoss@microchip.com>
         <20221017171916.oszpyxfnblezee6u@skbuf>
         <77959874a88756045ae13e0efede5e697be44a7b.camel@microchip.com>
         <20221018102924.g2houe3fz6wxlril@skbuf>
In-Reply-To: <20221018102924.g2houe3fz6wxlril@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR11MB0076:EE_|MW5PR11MB5788:EE_
x-ms-office365-filtering-correlation-id: 244351f2-3ea6-4aeb-d990-08dab10ea0df
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jDRWelIOmQSQJp1BgYVJECucgm7h55MZPlYwVxPcJEIbkPUPjiPNnkrURcIi1f5xBRuB5oyfC/VeuYIxGjXIXo6rn0s+7TBxveu9c1UdkYzftalJ7t9bIiCD7LQxGAaxdI4gX2m9Z/RmcfkgrMWbOtgDsCCddDTfsasYKiWQdw8nnlHpDjoTvWfFENHc+THwuHzIWML68gLg31kI8z6BhzppHMa+6V6jWf0mM24mlTCuEwMFBFvXe5LXbWXhibZw5QZm6/O8lzoHJQ0kU7PTyBCf5Rt0NCCn4XPY26SbblJ5ZMEfrbtE9QKexuOxdkMI+VNi95IJQgpj2FE5cCeKpIXzCNcakEyUKnQszXAZ3jEcGOkNHR2Vvyta4FvJjAFIlrKWqTCIfkiqQLZRWkjhI1ARgpKz62MM7LNpfOY3NS9Ddjtc0PEMd2eAWdGV17GElsqqCBJtZvYB+gmaPTulGj38VC+0M0ptRBJ7DYRKrAt7U11Bo9pqbNVSssYOpNZZVu9Ac8T3bT5TCuTvU7QhJ0z5msXm7NE5kkKR9Fg2ZlhX9i0QuROA89Lfv2nlMlapkxo6uxcJVw2cVPg0nnEkUpdwuaLs4HMkQZE1tLFoSglwXzdEthQ1mPaUmmWgQbES2+2Psvr5xF/Hqy/beae8au+9xvcLT+8jTIWFe8auw7iKHFTuE0+JS4Bkb0QFCWht9hNnhAWZ6fXzbwK/lDUVlYtDm0OJaJWda7A0CWcE4sBUr6epru2GS8nzucn+q5VXuZaHFcjN1KGEKhxYwYdQN48V8Kj0DLaNUNfd/c+1MlM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(39860400002)(366004)(396003)(346002)(376002)(451199015)(4326008)(64756008)(8676002)(66446008)(66556008)(66476007)(66946007)(83380400001)(76116006)(91956017)(54906003)(6506007)(36756003)(86362001)(6916009)(41300700001)(5660300002)(6512007)(7416002)(8936002)(316002)(2616005)(4001150100001)(186003)(71200400001)(38100700002)(2906002)(6486002)(38070700005)(478600001)(122000001)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NklLUURBSFh0TUtjc1o1Z2VOR2F3RjI2V01nRlJGUzFPdWdUY3VyMnoyZUhp?=
 =?utf-8?B?ZUZNTmpvdk52bHV0OXcxdlhUZ2JaNFZWKzN5MDJ5U0pyMHc3c3hCT0MxQlJF?=
 =?utf-8?B?Z3JtWkh2TmIzZXpCNnMwVGkvRDNDVWtzN2kxM1pBOHNYZ091Q0NacUh0U2g3?=
 =?utf-8?B?UFNpSmE2MlZoeU5GMks3UkowaUkydjBSR2RvaUZOOURMaFZhWHFUYXN5bFQw?=
 =?utf-8?B?WG5teTZFZnlFa21YNkdhdDZvUllJaWkwaU5VSmxZSVB4V3E2WGZLUzNOSXVt?=
 =?utf-8?B?K3RIWExuRS9SK2xySmlxNHd4aXVXVUY2elFDUEJlQzRINUhWUUhNY2xwRTJF?=
 =?utf-8?B?TTNCbkdRQjRGWFZjNGZkZkpmWmNYQjlXVVVuNzFBcENSMTVyWFo3TWVVS3o4?=
 =?utf-8?B?SWtQLzRVQXNCTm9QOEFEQnQ0TDRkMDdGUG1jMUVpY1RJODFHMmg3UGtlME9T?=
 =?utf-8?B?QklEMVJwc25KUXJ6ZUlEVkJVRURzZWtoYWcrcmlHTElxbFlPb3ZvMUZ5d1VU?=
 =?utf-8?B?T2lMRUE4Wk8wbTU2VFZiTWNPVjJ6WFBjdUREOXd4NHNxWXBDY2NFMUFOalZK?=
 =?utf-8?B?WFNUSEQ5b0dHOHRTWnpBNTF0UzREbk1yV1MrRWpYVnNsR1VSMkdBQkVMTGwv?=
 =?utf-8?B?ck5ES0VvWWVydG14clJwZWlKWStNdWhxL3hacWNPVVNUemN5Nm1NSXN3VG11?=
 =?utf-8?B?UVdpTHBieDMybFg0anRaVGZvQmVsbEt5ZlMyZUpRWmZKVVJ3bnRIUmpEZnVX?=
 =?utf-8?B?ZTFsTCttc3RTZU5kbloyV0R2ME9oV0s3Z3g4T3B6Ny9mMXVDc2UzK2ZpajVN?=
 =?utf-8?B?ZzdmTzBQNUwzN1h1QmZibTlUdlgzdS82ZjZBcFZBaExIa1VhNkRPbWZYT0FZ?=
 =?utf-8?B?NE9QZmFTSXZoT0g2K01jWHQxanQrQzFsV0Y4dXBIV2NKaWsvYW5EM2ZkSFNU?=
 =?utf-8?B?OE1STSs0WUVieitFWmJwR1NaY0NiNVBPeHdPYkNXYTJudFIvc3FBcEdzZVdW?=
 =?utf-8?B?dWdXWXgxaVlBWVVjbGM2dG9iRHcyb2FXVHVNZVA3SlgwQWdOWUdjWWlwMmVX?=
 =?utf-8?B?SHUyTDBncDF1cTluUm8vUEZydVc3d1VqVmZoak0wR2hDSjI1Yksyb3JPdFdh?=
 =?utf-8?B?b2ZjZ1BnVjNGVnp3SjZPenhRQTJNbGg4TTNBMHlTTmZObm5nZWVtd3BpajZH?=
 =?utf-8?B?T0JlS3FIUGIrNmY0elFQMHFZWTRZSzFjSkYwOFg2N0xzQmtTWFhqdUZwcFdK?=
 =?utf-8?B?bGl1Sk1wbjQyL2h6aFpFSVlYcnFHcko5L1dKZHY2TzNFQ1J0YS83dVVFWUU2?=
 =?utf-8?B?SVh4NllKb1hGM3pMTTI3ODEvQ0U5U1FCeHlCY3ZxTFZWK0k1U3hpSFNncW9E?=
 =?utf-8?B?MFZVMExRZUdNQW9ZRTBaRUxrQU45RTk3VGxBeXVPVGZ6eFEyRjEwaklBSjll?=
 =?utf-8?B?ZlF6Z3pZa2ljbkhxbUMrb1pnbW5GN1BqOXVab3FvazNWcnBOUXBzR1JnR2FN?=
 =?utf-8?B?MStZMWF0M24yMlhGOHJvU1RRTkpXTm9yOTUxV3J1T2Y1VDdXd3JQb3hZVWJi?=
 =?utf-8?B?Nm9DRzZVUUNzcUxUSThORFlHL1ZJNU0va3lQejVtQ2UrZWhIQlQ4QnI3SHAz?=
 =?utf-8?B?eEwzVWFiQnFmbUJuN1poWC9KSGZ4WCtjWEhoWUQ4Vmt5WkRObFkyRGNIaU5y?=
 =?utf-8?B?UEZqeVpPSEtmWkczZG5HS1htcXJFN1l3cnN5cTY1bkYvb3lzeGNHZFUzTUk5?=
 =?utf-8?B?K24wdVBDR0ZGTTNmZGdPUExVMmozWnoySmxDUjR4T1RaaGY3dm4wbjdiV3Yw?=
 =?utf-8?B?OXhXYkZCTDI0cTE4amJkZFNoZm1LaWVXQnJnZUxnUnZUbXhZRkFUb2VUU253?=
 =?utf-8?B?M1hLM09qRkhLc2NrZko5QXNpRCt3YjE0WWdJSHMrRTJRYVB5YXE2cXcrYWpZ?=
 =?utf-8?B?eWtHYUFRZk52RHBhKzJrOTVLUDRNOGRVRFh0SDFnYVB1Zm5YU2JnQkRKTjU2?=
 =?utf-8?B?TmMxcHE2TllaOW9SeWRGVzkyeUJCTTlwcnp0VUZabnZiZmxMLzdoZHVqd0x5?=
 =?utf-8?B?bTEwUS9QTDZWUmVISmJHUlQ2bWZmN0w1b3hLNGduY1Q5ZUFSZVNqbFZFQk41?=
 =?utf-8?B?c01kcVhBcGlmQ0NQck1VdDUveVVUZkxKMmpQaTlQblIrYTlmaGlRaDhOck13?=
 =?utf-8?B?bXFpMWUyNnZIbW9PYjhqckt3UmJ0NTNjelAveTMrN3NhTm5jUXphdVNUQlVv?=
 =?utf-8?Q?ucdlJpGiQGot/WCGJyWb0xefbuF8Dnr3Fpa66unjt4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <289D8FA379C18649A841BFADC4EB7E7E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 244351f2-3ea6-4aeb-d990-08dab10ea0df
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2022 13:42:41.2561
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: r3pqhG01Mzdf4hivffCpIVqjfkNJgAJphNkGMOpZ/+rQlBgbx1eoAeBcrn9eDCKLxTS3Q8JaEyows3Std5HApzWdDWA+Hwfq6pJ6zf2W4q0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR11MB5788
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIyLTEwLTE4IGF0IDEzOjI5ICswMzAwLCBWbGFkaW1pciBPbHRlYW4gd3JvdGU6
DQo+IEVYVEVSTkFMIEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50
cyB1bmxlc3MgeW91DQo+IGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiANCj4gT24gVHVlLCBP
Y3QgMTgsIDIwMjIgYXQgMDY6NDQ6MDRBTSArMDAwMCwgQXJ1bi5SYW1hZG9zc0BtaWNyb2NoaXAu
Y29tDQo+ICB3cm90ZToNCj4gPiBJIGhhZCBkZXZlbG9wZWQgdGhpcyBwYXRjaCBzZXQgdG8gYWRk
IGdQVFAgc3VwcG9ydCBmb3IgTEFOOTM3eA0KPiA+IGJhc2VkIG9uDQo+ID4gdGhlIENocmlzdGlh
biBlZ2dlcnMgcGF0Y2ggZm9yIEtTWjk1NjMuIEluaXRpYWxseSBJIHRob3VnaHQgb2YNCj4gPiBr
ZWVwaW5nDQo+ID4gaW1wbGVtZW50YXRpb24gc3BlY2lmaWMgdG8gTEFOOTM3eCB0aHJvdWdoIGxh
bjkzN3hfcHRwLmMgZmlsZXMuDQo+ID4gU2luY2UNCj4gPiB0aGUgcmVnaXN0ZXIgc2V0cyBhcmUg
c2FtZSBmb3IgTEFOOTM3eC9LU1o5NTYzLCBJIGRldmVsb3BlZCB1c2luZw0KPiA+IGtzel9wdHAu
YyBzbyB0aGF0IGluIGZ1dHVyZSBDaHJpc3RhaW4gZWdnZXJzIHBhdGNoIGNhbiBiZSBtZXJnZWQg
dG8NCj4gPiBpdA0KPiA+IHRvIHN1cHBvcnQgdGhlIDEgc3RlcCBjbG9jayBzdXBwb3J0Lg0KPiA+
IEkgcmVhZCB0aGUgSGFyZHdhcmUgZXJyYXRhIG9mIEtTWjk1eHggb24gMiBzdGVwIGNsb2NrIGFu
ZCBmb3VuZA0KPiA+IHRoYXQgaXQNCj4gPiB3YXMgZml4ZWQgaW4gTEFOOTM3eCBzd2l0Y2hlcy4g
SWYgdGhpcyBpcyBjYXNlLCBEbyBJIG5lZWQgdG8gbW92ZQ0KPiA+IHRoaXMNCj4gPiAyIHN0ZXAg
dGltZXN0YW1waW5nIHNwZWNpZmljIHRvIExBTjkzN3ggYXMgTEFOOTM3eF9wdHAuYyAmIG5vdA0K
PiA+IGNsYWltDQo+ID4gZm9yIGtzejk1NjMgb3IgY29tbW9uIGltcGxlbWVudGF0aW9uIGluIGtz
el9wdHAuYyAmIGV4cG9ydCB0aGUNCj4gPiBmdW5jdGlvbmFsaXR5IGJhc2VkIG9uIGNoaXAtaWQg
aW4gZ2V0X3RzX2luZm8gZHNhIGhvb2tzLg0KPiANCj4gVGhlIGhpZ2gtbGV2ZWwgdmlzaWJsZSBi
ZWhhdmlvciBuZWVkcyB0byBiZSB0aGF0IHRoZSBrZXJuZWwgZGVuaWVzDQo+IGhhcmR3YXJlIHRp
bWVzdGFtcGluZyBmcm9tIGJlaW5nIGVuYWJsZWQgb24gdGhlIHBsYXRmb3JtcyBvbiB3aGljaCBp
dA0KPiBkb2VzIG5vdCB3b3JrICh0aGlzIGluY2x1ZGVzIHBsYXRmb3JtcyBvbiB3aGljaCBpdCBp
cyBjb252ZW5pZW50bHkNCj4gIm5vdCB0ZXN0ZWQiIGJ5IE1pY3JvY2hpcCBlbmdpbmVlcnMsIGRl
c3BpdGUgdGhlcmUgYmVpbmcgcHVibGlzaGVkDQo+IGVycmF0YSBzdGF0aW5nIGl0IGRvZXNuJ3Qg
d29yaykuIFRoZW4sIHRoZSBjb2RlIG9yZ2FuaXphdGlvbiBuZWVkcyB0bw0KPiBiZQ0KPiBzdWNo
IHRoYXQgaWYgYW55b25lIHdhbnRzIHRvIGFkZCBvbmUgc3RlcCBUWCB0aW1lc3RhbXBpbmcgdG8N
Cj4gS1NaOTQ3Ny9LU1o5NTYzDQo+IGFzIGEgd29ya2Fyb3VuZCBsYXRlciwgdGhlIGNvZGUgcmV1
c2UgaXMgY2xvc2UgdG8gbWF4aW1hbCB3aXRob3V0DQo+IGZ1cnRoZXIgcmVmYWN0b3JpbmcuIEFu
ZCB0aGVyZSBzaG91bGQgYmUgcGxlbnR5IG9mIHJldXNlIGJleW9uZCB0aGUNCj4gVFgNCj4gdGlt
ZXN0YW1waW5nIHByb2NlZHVyZS4NCj4gDQo+IEkgZXhwZWN0IHRoYXQgQ2hyaXN0aWFuIHdpbGwg
YWxzbyBiZSBhYmxlIHRvIGZpbmQgc29tZSB0aW1lIHRvIHJldmlldw0KPiB0aGlzIFJGQyBhbmQg
cHJvcG9zZSBzb21lIGNoYW5nZXMvYXNrIHNvbWUgcXVlc3Rpb25zIGJhc2VkIG9uIGhpcw0KPiBw
cmlvcg0KPiBvYnNlcnZhdGlvbnMsIGF0IGxlYXN0IHNvIGhlIHNhaWQgcHJpdmF0ZWx5Lg0KDQpU
aGFua3MgVmxhZGltaXIuIEkgd2lsbCB3YWl0IGZvciBDaHJpc3RpYW4gZmVlZGJhY2suDQoNCkhp
IENocmlzdGlhbiwNClRvIHRlc3QgdGhpcyBwYXRjaCBvbiBLU1o5NTYzLCB3ZSBuZWVkIHRvIGlu
Y3JlYXNlIHRoZSBudW1iZXIgb2YNCmludGVycnVwdHMgcG9ydF9uaXJxcyBpbiBLU1o5ODkzIGZy
b20gMiB0byAzLiBTaW5jZSB0aGUgY2hpcCBpZCBvZg0KS1NaOTg5MyBhbmQgS1NaOTU2MyBhcmUg
c2FtZSwgSSBoYWQgcmV1c2VkIHRoZSBrc3pfY2hpcF9kYXRhIHNhbWUgZm9yDQpib3RoIGNoaXBz
LiBCdXQgdGhpcyBjaGlwIGRpZmZlciB3aXRoIG51bWJlciBvZiBwb3J0IGludGVycnVwdHMuIFNv
IHdlDQpuZWVkIHRvIHVwZGF0ZSBpdC4gV2UgYXJlIGdlbmVyYXRpbmcgYSBuZXcgcGF0Y2ggZm9y
IGFkZGluZyB0aGUgbmV3DQplbGVtZW50IGluIHRoZSBrc3pfY2hpcF9kYXRhIGZvciBLU1o5NTYz
Lg0KRm9yIG5vdywgeW91IGNhbiB1cGRhdGUgdGhlIGNvZGUgYXMgYmVsb3cgZm9yIHRlc3Rpbmcg
dGhlIHBhdGNoDQoNCi0tIGEvZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3pfY29tbW9uLmMN
CisrKyBiL2RyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAva3N6X2NvbW1vbi5jDQpAQCAtMTI2Niw3
ICsxMjY2LDcgQEAgY29uc3Qgc3RydWN0IGtzel9jaGlwX2RhdGEga3N6X3N3aXRjaF9jaGlwc1td
ID0NCnsgICAgICAgICANCiAgICAgICAgICAgICAgICAgLm51bV9zdGF0aWNzID0gMTYsDQogICAg
ICAgICAgICAgICAgIC5jcHVfcG9ydHMgPSAweDA3LCAgICAgIC8qIGNhbiBiZSBjb25maWd1cmVk
IGFzIGNwdQ0KcG9ydCAqLw0KICAgICAgICAgICAgICAgICAucG9ydF9jbnQgPSAzLCAgICAgICAg
ICAvKiB0b3RhbCBwb3J0IGNvdW50ICovDQogLSAgICAgICAgICAgICAgIC5wb3J0X25pcnFzID0g
MiwNCiArICAgICAgICAgICAgICAgLnBvcnRfbmlycXMgPSAzLA0KICAgICAgICAgICAgICAgICAu
b3BzID0gJmtzejk0NzdfZGV2X29wcywNCiAgICAgICAgICAgICAgICAgLm1pYl9uYW1lcyA9IGtz
ejk0NzdfbWliX25hbWVzLA0KICAgICAgICAgICAgICAgICAubWliX2NudCA9IEFSUkFZX1NJWkUo
a3N6OTQ3N19taWJfbmFtZXMpLA0KDQotLQ0KQXJ1bg0K
