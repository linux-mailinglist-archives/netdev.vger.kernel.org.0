Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 223D765FD68
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 10:17:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232227AbjAFJRV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 04:17:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231810AbjAFJRP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 04:17:15 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E196A63188;
        Fri,  6 Jan 2023 01:17:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1672996634; x=1704532634;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=5SEJ+uYRwv98pHKNuPCUH9WwD/ay+3jiuz/RV+PML8I=;
  b=zPn8fBMZyc1WhKn3XVSMYlrfZtK9GZIQ2KDoTmjzkeDuQ/T1ZOYVKK2d
   QtZpLiTRyzcnwoHJirY+4YWQMwOrvjO7ndFWuziLzPv3FbrE2LJofxmHS
   02svMA6Gat67bfYpoVhzHleUuw9Simrti4w4FjxkU6YjbnJYamaIrG1ag
   O91J76VOSjI1+D2vS6PTVLvq0RrrqW/Ut68SsPfSNQUl1j2nlXhszT9MB
   OJxmo3Nj7aVw4ka82PJm2Lyej6qvYlmYVx4PUdi56C7vFz5RjIV52+jqv
   M+ua9DNu6cjr6ZbpqiNT9FAHZ1ApgalB6RJPqkof0SSHPjcxPsDhsToG7
   g==;
X-IronPort-AV: E=Sophos;i="5.96,304,1665471600"; 
   d="scan'208";a="191048943"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Jan 2023 02:17:12 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 6 Jan 2023 02:17:11 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16 via Frontend
 Transport; Fri, 6 Jan 2023 02:17:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZuY9t4AboijXxeFMujRllkG/aQ6r9rdIt7EjAFNmgR9QhougHs0HstvuBqZIMAOdTyAxv9sYPkHVn6I9JazoyMGpkMoPliyFe4dKMZ2t3xvagq/t/cerXyHeVRaWLcudmcDryQptIZUk5HHbcKAKcpgPFq9KiV3M3CaZvI03kjhMpdSAg14tRSiOrDXmNll8o2BVfgcThGVQfwXbmT2QWfeu1CXK3s9IAx8zAljxM+ZaEYstpc2IKBTqgtQOeTdwLGlT81NuPfu4xPx7TIa2NCGTwuBAJjZ3UHMAh5PQm6z7HcRZRvz2vgthlFy36QzXOXq3Xk9Da/WaFHV0kiVfYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5SEJ+uYRwv98pHKNuPCUH9WwD/ay+3jiuz/RV+PML8I=;
 b=cNHqhvqbZzV40GMZKxIBCU7s6kIDCTdQmxkVmUgQtocdjh+LyA9Yn07OhJ5TksX80cHfm5TwNdSHxwFUFyE4tfBFYQNlaQd38zbD2TBZndeduI99XEqvaHRpU4ftXtCUj5kzODqiU+21ZQl0s6AD3tWnad29X6v5M1cDwiDjF70RQueJNMf6iUEFA2QgHtxRCjFOcrd/FUfsZNspqDksZXb49WEPjMst4PDRNsDwcDIxktAYBTXkWJ68zhdR+f9U/AqVD07b/zKEMCwXx4OOr6pIQyioGs+RnD8lBBYRtphqdjPlkviUCHF+hZesCj8lqT9RSRWRcRR9NMm0cp18fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5SEJ+uYRwv98pHKNuPCUH9WwD/ay+3jiuz/RV+PML8I=;
 b=AtLWteOp2/j2QHTbNZmOsBICvuDD/XMIuy3lxMPzxY2oQTjySA55CuulGGSerlXRQlH/HIHb6qVKpSutJCoSvaII7A+6hgYfdAfenZFvhAkKTlkkw59jXr9YXu5m37uNefwzMOM7DLSbiU9lei+56oo65XyKGZ/ik64jFRCm34I=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 DM4PR11MB5550.namprd11.prod.outlook.com (2603:10b6:5:38b::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5944.19; Fri, 6 Jan 2023 09:17:10 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::9b7a:7604:7a30:1953]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::9b7a:7604:7a30:1953%7]) with mapi id 15.20.5944.019; Fri, 6 Jan 2023
 09:17:09 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <andrew@lunn.ch>, <linux-kernel@vger.kernel.org>,
        <linux@armlinux.org.uk>, <Divya.Koppera@microchip.com>,
        <kuba@kernel.org>, <edumazet@google.com>, <pabeni@redhat.com>,
        <richardcochran@gmail.com>, <netdev@vger.kernel.org>,
        <alexanderduyck@fb.com>, <davem@davemloft.net>,
        <hkallweit1@gmail.com>
CC:     <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH v6 net-next 1/2] net: phy: micrel: Fixed error related to
 uninitialized symbol ret
Thread-Topic: [PATCH v6 net-next 1/2] net: phy: micrel: Fixed error related to
 uninitialized symbol ret
Thread-Index: AQHZIakKRb85S9ZppkyOKT7kPUYrVK6RG/yA
Date:   Fri, 6 Jan 2023 09:17:09 +0000
Message-ID: <f83c935d99927bb23056760b04115296e6ade7de.camel@microchip.com>
References: <20230106082905.1159-1-Divya.Koppera@microchip.com>
         <20230106082905.1159-2-Divya.Koppera@microchip.com>
In-Reply-To: <20230106082905.1159-2-Divya.Koppera@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR11MB0076:EE_|DM4PR11MB5550:EE_
x-ms-office365-filtering-correlation-id: c83e0951-d9b8-4c07-e1b1-08daefc6ca16
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GWw9Gctz3L33fNttyZ7EIAquPUyEiyMXpE9vzrYZ5jWiEx2H39aSZbzK6DE6l7x7Owt4raXZJjVjTba/7jxvVtEdb9NlrzKRuWtk9Ny7nhGFM7delmq4lhCfm54AK3XXfXZaWHhJ7hWyWTgdSlWJJ9mM/KCoPtOmiXnq8TxwZyK2CRoSYZGCRp0giO8RamQgMaQbcvs6scbX6gzPIbbDh0jfRaPgDA4zgWPdM3ieJDEh684Zt9AITjQQKlExsn0kFyDJO+DevBvQDAuAJO1cqkRoOWQT+fGVv7n7nbctxdx4kt6Nbn7Z4mQNmGK7IBkUSaw91QHsBac3vTMo00pV6Cr4IBjuSYoqkg1vfzxcSp4ecJz2XESmRHVh2ePQ2IcUSExbthFH4y/mS5LDR6sApwAYxrCsdcApKyU+H+GCtp9zlAMwIkpAYYHIkwFodgg82Bb7TDl5ZlP9Pn/zxrlGmNINHXTY/MxjiyOHY8zx7CPUPqtQE7ZH85ne4Ro+xLEjNUNdt1cIRzbGGdfHgmYWw0FEvcKaunBJGacaAyA8+pQeH9+5HoDRH9rUG3ugz5rKPqPSms7ZOokDwWr1WwfrCfnX9FruDhDVOIMJolVyuJqKdotiNrbCNfE4iWFV5NCeNSBKrr2180tubPJ5fzjq+3ZNFP0eYawl/MNEn48mHju6as3tqejGUGO+hpDig+v5EXyAPpX3YF+rMclCVQvvTErxvaBHbzwhLIuz+ynoAgg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(396003)(376002)(346002)(39860400002)(451199015)(6486002)(107886003)(6506007)(186003)(478600001)(36756003)(38100700002)(921005)(38070700005)(122000001)(83380400001)(6512007)(86362001)(2616005)(71200400001)(110136005)(26005)(5660300002)(76116006)(91956017)(4744005)(7416002)(64756008)(4326008)(66446008)(8936002)(66946007)(66476007)(316002)(66556008)(8676002)(41300700001)(2906002)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?d1JSOEltaCtkUUZ6MmdaM0tHaFhiZURSelFwNzU4YnJRSzlRUjFwYkw2N1ZP?=
 =?utf-8?B?MTRMNTdpWFZ5bWg4QjBBV3E0Z1JQa2tJTWJieTc5NkxidTRzbk5GMktDM24r?=
 =?utf-8?B?dDRmQ3lMc1JMcFV2TXVLRHBqWUZYaDlUaWlFdkpiYjgyUkhoczFUME9kcHgz?=
 =?utf-8?B?Sm1LdjlKVHp6dVRDeGdISDgxWUpkUVAvaXYwbzNIRVBWOFViRnZtc09zVVd0?=
 =?utf-8?B?azFaemhKMnZUeDI0aUlUWHdEZGplRzNSYWVyNXEzUTdVUXM5dzJ5N2lZek1X?=
 =?utf-8?B?WVhtSW00MVRhSkZCRHN4QTY0eFQrS0l0ODByZURBcEg0L1pPdk1QbmhMSkFa?=
 =?utf-8?B?anlRQXBxaGxScm9IZGJ2eFcwMGZKbFg2YmcxbU1HU3pQTnlTNlRhamQxS3M4?=
 =?utf-8?B?eUhzSzc4eWlsUTBLRFFTaGJCTjdSYzJLRlhxT2hPbXBINnVwUWVnZ2hTajZ4?=
 =?utf-8?B?WEZQRi9YQm1iMkE2V0pLUFkyejNHQytXSDVDN3hsTlpnU3R6NTVnUTArSXM3?=
 =?utf-8?B?Y3NqME5zdjlaaUl1S2hTU1hmR1BMKzVRb1B5SnFPbGUwVWhzSjQvcWw0cjhn?=
 =?utf-8?B?b2pINWlFTXlTVC9OTFFacmxKa0w0aGFkNHFscG1CaHNIQ3RTejhWY21xampM?=
 =?utf-8?B?VnhFYlRHZEs0a1pLb1ZzOUVRelZpdjhYZ2pzL1lJbXQvZUU4MzFFMzdzSHNY?=
 =?utf-8?B?eC9zYWx0SGxHaTBJUjNGKzNaMkhoam90MmJ3ZDdMSmw1KzJmVEFiOFFTd1cz?=
 =?utf-8?B?cUNBY0U0S1JRd1phUVR0ZjVHTUUvZ21VUDBkY0Z0ckZ4SEhPeUpHSGZhYUNS?=
 =?utf-8?B?ZkJKUFl3WVYrMkRHMGJUQmZybFI1RVNPbCtmL2tmTjBxSFppY1pFR3UwMGx1?=
 =?utf-8?B?TDdyMmdqWVp0TlFOTUpiVVJ1VUlsVkRkSWVTbnZqWDE4Mm12ei8wN3FIWVhR?=
 =?utf-8?B?MkFkM09Pdm5JYTBwLzBWanY5UUROUmtPdFJ5Ukd4YitSbGFwN1E2c3pyUFJN?=
 =?utf-8?B?L2grMCswL3MxaUdKTjNSdkh4cnlXeFRpS1pSMTZ3NkVIVDV6YVJ0amF2YlJF?=
 =?utf-8?B?U0xQOExPWVQ5bzhNN3BKZFo3WjJHaXh5bFROa3k0anZkZUpDNHZDRTZjcUR3?=
 =?utf-8?B?T1NrY0cxUVVRNzJRbXI1YlVMbjZhQ3hvb2VVcTJtWU4yRlVjZ05hdnIrSWYx?=
 =?utf-8?B?NjczNGZsTk9jeWVMWS9WWWdCeXdIZm9FZ2ZiT0FuR2gxK1o0Um5hcE03VzNZ?=
 =?utf-8?B?bXBKc0EzaU8vUFBGTUVVaUV0ZkFZRW9ON1g1RnhOZDhMcktYZXFCOGZtZHpY?=
 =?utf-8?B?Z1IzTldzcGJMK2xlSGg4VThTNmgvdEIrT1JMN3dNMWRoa1VUK2tkWXRITzBj?=
 =?utf-8?B?dWFQeWhON2VYeHloMlA3YU84K3JyQ01JUkpaUy9IcTNTdThHaDNmWG1CUmFm?=
 =?utf-8?B?SElFcVBVZ3cxVTNhY3NpUXk0WGhKVTFNMGozRFFTUlNvRlg2c2x1ZXlDYjJF?=
 =?utf-8?B?SWVRMldKMmV5ejJYeEpxTVJqNy9vOXgzRFkveUZ1RXN3UEtmWiswMWFBNGt0?=
 =?utf-8?B?VUNxeFNVUFJQZ1BKV3FkODhzNUx5QmdPdG1kdkRCaGczaStUNnlaa2pPcWxo?=
 =?utf-8?B?b3ArUERLdzdXbzFKeDV1UEtZZjVCR1lKZnd2OHlzdkRzRVJ3T1lLM2YrVHpq?=
 =?utf-8?B?b3Y0ZU94U2ZxUXJ4aENnQUczZzJWcFpPcXVnZElNa0FOOUp4SmtsamYyK2VR?=
 =?utf-8?B?azZnSHNkaE5nSnR6VkRuZk9UYTFFUEVYdEY0MThBZS9WUFlYMUh0R05temJn?=
 =?utf-8?B?RGdVTFB0NHJidWR0ZWlZbGxyQ0Q1eXFyUDZSc2VaVTlUNnlJUkk4aitHQ3dO?=
 =?utf-8?B?L2Y5dkh1SWJERlIzbEYxd0dnN1JBbGt4czFJTnVpcDJEa0ZEQXJsQ0YyaWZI?=
 =?utf-8?B?TjRIMW5ENDY0UCtJZW9QM2FHbVlYaFVKVndPZXByMnlUMnlYcDB3M3BSeWRv?=
 =?utf-8?B?cy9lYXpPd3BnUVRRclZJMThoVGlIUXJEeVpGYUUvOThXdjFuRTUwZVhCa0FM?=
 =?utf-8?B?N1drbW9oK2FLZllRWllkUklJV2hJTFBEVXFab2Y1Ykczd3VBNzc3Mm8yYzUr?=
 =?utf-8?B?QnM3T2JOelhpbjVCaGp1UTh0VVU0QTdKSlA0VzlhenU1Rkxucmp2MEVtWHBv?=
 =?utf-8?Q?+51oswOD5/iZyDxDx+tytJg=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1C79E07C2ECB7E4E89D47C2C5B094AE4@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c83e0951-d9b8-4c07-e1b1-08daefc6ca16
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jan 2023 09:17:09.9094
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mWv08hgcDduNxgdd7O4y4GIQW50l+8UD7GflnbHnEsGz4kSCecJF6I/qU8br/4UJnnaLWteIPiL/Vau8rXAsLBjTG2CP/QwlthBnGz5ZMT0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5550
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgRGl2eWEsDQoNCk9uIEZyaSwgMjAyMy0wMS0wNiBhdCAxMzo1OSArMDUzMCwgRGl2eWEgS29w
cGVyYSB3cm90ZToNCj4gSW5pdGlhbGl6ZWQgcmV0dXJuIHZhcmlhYmxlDQo+IA0KPiBGaXhlcyBP
bGQgc21hdGNoIHdhcm5pbmdzOg0KPiBkcml2ZXJzL25ldC9waHkvbWljcmVsLmM6MTc1MCBrc3o4
ODZ4X2NhYmxlX3Rlc3RfZ2V0X3N0YXR1cygpIGVycm9yOg0KPiB1bmluaXRpYWxpemVkIHN5bWJv
bCAncmV0Jy4NCj4gDQo+IFJlcG9ydGVkLWJ5OiBrZXJuZWwgdGVzdCByb2JvdCA8bGtwQGludGVs
LmNvbT4NCj4gUmVwb3J0ZWQtYnk6IERhbiBDYXJwZW50ZXIgPGRhbi5jYXJwZW50ZXJAb3JhY2xl
LmNvbT4NCj4gUmV2aWV3ZWQtYnk6IEFuZHJldyBMdW5uIDxhbmRyZXdAbHVubi5jaD4NCj4gU2ln
bmVkLW9mZi1ieTogRGl2eWEgS29wcGVyYSA8RGl2eWEuS29wcGVyYUBtaWNyb2NoaXAuY29tPg0K
DQpJIHRoaW5rLCBSZXZpZXdlZC1ieSB0YWcgc2hvdWxkIGNvbWUgYWZ0ZXIgc2lnbmVkLW9mZiB0
YWcuIEl0IHNob3VsZCBiZQ0KaW4gY2hyb25vbG9naWNhbCBvcmRlci4NCg0K
