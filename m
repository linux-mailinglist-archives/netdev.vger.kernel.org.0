Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18A5E63B9E0
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 07:42:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbiK2GmW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 01:42:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiK2GmV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 01:42:21 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F3BC5214A;
        Mon, 28 Nov 2022 22:42:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669704138; x=1701240138;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=AFjvgbrj5TpIssfZ0r7gsmzI7YydElcLpR7YkyKAxJ8=;
  b=wwmvvD+5xWJhh5XHRTJunRYXmXgfAe3weGuNJ06azb6qn6ApHErhHDPX
   qlCPHpPMV3CJqRYg29oZXMf7xTe80a/2Ty0igtKlenKB0n/hqXLtrebK2
   Fmkv86C8yn+rnBgapIs9uP6HJ1EwJLMyJw5nWSs7Q2R/rsaCT6wHZSYpH
   ISksZoO9q7+UtYL6549kTjdPlI0qo+KSyoZJWgX/yzMT8GRd9CVudU9gb
   RUx1LT48NVaB7bXG7sY9OvEFb/J5UNvRMuh7y1EqpIU8zoT1A1J6tmsAK
   dhbruT3LQsuo0AazmVgEbV+L8VmoHgvPEgbbS5wiAQs3XVuNhOGUOAC3P
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,202,1665471600"; 
   d="scan'208";a="201802707"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Nov 2022 23:42:17 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 28 Nov 2022 23:42:17 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.12 via Frontend
 Transport; Mon, 28 Nov 2022 23:42:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M0SlYqOB6+nH4Kkctao7Zh9gTVHy2GImuqL0KVmli4BFCd7ob+vIeWBCR4CAhZPJltdJOK0lX45lxvABtt1OoBMzC1coTNWSY3a2DdEeqjQx3OtDHQmCSNsWe9KCCMZdEM+8zfVuhgQPDTt1L2aDA48CvNyaBNG18r/qxY4lsON3lp7V56K4BA61cgiHAeaHzeaoWFBV823afGAkwR6WuVGyi0IQdlFqBGLT/A9xxao0kwtOkc9efaIehYnqDnLGOjyYL7qKt4GPJ/GB6tYu3XfAdmcNI38+OWvJWOpLHtm5ZYQKYWWFqCZMjrtd2Zm34KMAlFPj12HfzsJ3yszmUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AFjvgbrj5TpIssfZ0r7gsmzI7YydElcLpR7YkyKAxJ8=;
 b=dXgQZhSmsn/OgTt2VYXoXZT2wcNG5rS5OLzsk2e2t4wI8E9sqplDQb/r5kbVoshSsadX7Mg12ILF1rAKi5Hs+60rnYOFnusA4g5WRwUy52DbjtY33Rmjysxk4p8g9PAtVNU6L8fNuc5VBDFCLOQ9nOGCKPGakgKsdooub67/ayV4uEVIA/10BcRpytKWb9N6FmW8hL/wGbp0V9Sf7dU2FK8NYsrzk3BbNGF5+7zS/BYoIMU8BMh5uGfVexsB0m500jmtEPQ/iyfetl1R3JE06E0KmMeBBvlb8EcPkpelCUpUaPOBtDdv8WgJn11FMlPkTuSB4ncZGi4JEBjJCq0/9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AFjvgbrj5TpIssfZ0r7gsmzI7YydElcLpR7YkyKAxJ8=;
 b=HaD3mP+pj3t8vGb0vZOR0sX3yKJTMPZFCDjsJQmDNkDaMjGIBFgH8sl+YJyTjCAG6tr8DF8nDc4WX5N45Uj1H69iFNZwqpOKfFHfaQ/uDuxgXtkya9eYdlROv9JCQKSETmAEDpPWPsCgEwvMh0Rts2Sl75WzOzCqeoUR3ccZnhc=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 DM4PR11MB5534.namprd11.prod.outlook.com (2603:10b6:5:391::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.23; Tue, 29 Nov 2022 06:42:15 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::9b7a:7604:7a30:1953]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::9b7a:7604:7a30:1953%7]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 06:42:14 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <olteanv@gmail.com>, <UNGLinuxDriver@microchip.com>,
        <vivien.didelot@gmail.com>, <andrew@lunn.ch>,
        <f.fainelli@gmail.com>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <o.rempel@pengutronix.de>,
        <Woojung.Huh@microchip.com>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel@pengutronix.de>
Subject: Re: [PATCH v1 14/26] net: dsa: microchip: KSZ88x3 fix loopback
 support
Thread-Topic: [PATCH v1 14/26] net: dsa: microchip: KSZ88x3 fix loopback
 support
Thread-Index: AQHZAyEdO/7+sHMkKUetAaQpDgv9Cq5VdSqA
Date:   Tue, 29 Nov 2022 06:42:14 +0000
Message-ID: <d22b01e14ec4c4fc25900e3fdf98c525f695bbb1.camel@microchip.com>
References: <20221128115958.4049431-1-o.rempel@pengutronix.de>
         <20221128115958.4049431-15-o.rempel@pengutronix.de>
In-Reply-To: <20221128115958.4049431-15-o.rempel@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR11MB0076:EE_|DM4PR11MB5534:EE_
x-ms-office365-filtering-correlation-id: 99afe871-efcb-47b1-8004-08dad1d4d9e8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: u1gxEIABv623tBRKsns2+NKWUDMnz76YJZ1vDaSFJHrZjCrWyVoVtBStyzFobxTCiu/sGg6YzGadyuvk1fHYuRTRDcg49gH7Yix+JqhttJzQ5YCpmWz4WcTtJP4vJgeLSoZKu2gHr/WdpatH9JDxSgmef4RDEothnhh1YfvxMGkTT5BtgtCwVu6f4y4pScT7vZw5DxwTEXmz2+P2p1pbDaV9P7qBo0hSZ5aeoMoZe+ruzKQWJw0JZQ1WrA55SkIPpw4lnOzXQ8ATZ+osrEuN+OrdaoTS4H4EErDDnBsahILEOInYuoiSgPm/vm6HVADgi2dI/c5MH+z6T2aHTz3ds0NTSiKBgXqXWGACPKOBdX1wgPSb6+M3pYJ9JZI8cgmtFSJtkA8O8U806K3V0bYFb6yuWs2yPBxXUpCSQN9MxErVU54iWXdbA7s8k1c4kuib2eyMzD25r65Y3W0GCDuNB73JuRCIDm40R+gmnBeuhTDotshRly/PEh1Q1Qfs+M7upiX04GJi8mZXPhwGqxpS0WDhDLSVXY7Nb70iU23vWMntadhL5bDbC5wm4WkUHRgdPR8E7MIZCrQW0U3d9MrhIcOxmHOiTHpgFmz6J9gQ9OgqxkbF/4ZSSZk8Z0TguvmJLvvThbWh6x1w3DolBUDrbITUscw5hCLZN9RzfGXsogKu1B5XE/H+grVY/d9N3kauJoBJ3OOkKj+98th6G2NXDbzJf6A5Vq2C+24JXVR1M5nDNv7eAWs0amf/2EuK5vkv
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(366004)(39860400002)(376002)(346002)(451199015)(5660300002)(7416002)(66556008)(64756008)(66476007)(66446008)(4326008)(8676002)(8936002)(41300700001)(110136005)(6486002)(66946007)(71200400001)(36756003)(54906003)(2906002)(478600001)(4001150100001)(316002)(91956017)(76116006)(86362001)(6512007)(26005)(6506007)(921005)(186003)(38070700005)(2616005)(83380400001)(38100700002)(122000001)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OVdyVUcrQmI4NVE0d2hLbjc4Ykdqdnc0SUNtcHVJY3EzZllqVW9tam1WbllN?=
 =?utf-8?B?NTVqbkNTaWtGcVlvdFJJOVhhK3JFQzlHdng5L3ArYUJSTW1pNDlmd21QOU5Z?=
 =?utf-8?B?UXg1djk0V3JpbmtRWHcyNEpIN0hmR2UzbG05ZVM1THZLRFlaeUhkT0t4dUsw?=
 =?utf-8?B?VTBBRXM2SDQvYTcxdFU2bnBDa3RUcHJUcnpobWc1WFMzdU1hcDFOUm8wVHBL?=
 =?utf-8?B?dGxyU05qakU5cHlQUVpRNkUreG9HZ0lkSllyaitYc21STkg0ajMwWkxTa0Rx?=
 =?utf-8?B?ZHdLS1pzMElVU2tOWWxGU2Z2cHpWRWRCNzBVbWc0RE44TjR2L3dWc3JJNjZM?=
 =?utf-8?B?aFBrT0pLSFVleHl0c3VGeUdFTnZYQU5lSWg1MHBEZGxSUXorZktOY0g0L1FE?=
 =?utf-8?B?a1BPZksreHdEekhIb1dsOE9WeXdCQWdKSWJacjJNS0JhakJxTEJwTHNPWUVO?=
 =?utf-8?B?NStreUwvQkNOclJ5OWJ3aEZ5TmNpRUJnMzJOcmVXS2dubmxaMEg5Q2RIR2hK?=
 =?utf-8?B?ZlZ0WmwyVjJ2V1g4NDhtVURKUEY3ZElON3B2eEJ2MDJSWVRmK2tVbzRUNGQ5?=
 =?utf-8?B?N3lBZ3FrR3E3R2R0cVQ0dUxoUXpENzVnZHBIZ1NRM1NjcEtaVmxxN3VHdHNT?=
 =?utf-8?B?UnVaVzRDa2V0OWN5YlFUQ0dkUXc5WkI5TVFPaFY2ZUJSR241OU95dGdIaC9J?=
 =?utf-8?B?UVkwZlZPVVljdkJJT2o3T25ITHhodHNyNk5iYjFsdlF6U3Q2emZUR01QclVJ?=
 =?utf-8?B?QWRWTTd1WnovRXZ5Y0xHeDEvTHdScnNKUHpuQlN0WkVDTWZON0dwVnZwS3kw?=
 =?utf-8?B?cXpmdHlvWDd1ZFVRemFkdnVpbGtmQjRsamxYeHQ0b25YMjZHSS84Y2NjWDVl?=
 =?utf-8?B?Qjd2QjJmL1lUSTZRd21PK0Z1YVBLbmVvUWVUUm9LYUE0Q2lWQW1sdGd5dWVi?=
 =?utf-8?B?djNRVXJsZkJCdGltbmQrVWRqUmsyZHdubDJSK1V1QVJGalB3aHR3eEdQNEJY?=
 =?utf-8?B?dGJTVC9QbW0xSE8rMlR4TFdsSzdtNnhhZUdDTm5hRThOc2Z1S2E3NkZuU1ow?=
 =?utf-8?B?Ty9zdnBCSmx0VElpMmpGaDA2K3h6UXRaSWoySWlPVjJ3cjY2eGczMzNqT1VE?=
 =?utf-8?B?M0JabUZrSUlHaUgzMXZkalNxeU9JK3M4L0tPN2ZxWG12RytTdHhLakhpM3pQ?=
 =?utf-8?B?bjZ4RkRvUXRsRWIzWHpVVkViRENiUjNnd2dLTzF3SnJHWmVYc3pGc3FBNUg2?=
 =?utf-8?B?MEdZN3NncmJTRW4rcGQyTjMwVG9RWDdZeWpLU2UxVjVvTkFtUmJvc0tnMGkv?=
 =?utf-8?B?UUZ0MkdSZE5aVFpwS3l0dlB2US9MMTd6bUgxZU1ycGpPRDdYU0pRWEpvTXg5?=
 =?utf-8?B?aHcyUG5XL1Jsa3AwanlOUUZUNWJreFU4b1VKWXRROGl4MkEzV2lxYkxoL0hp?=
 =?utf-8?B?UmVXNU9GcThoQjJ4YjYyT0RSY1BldE9Iek9ZSG5ZQTM3TUoyZitpb2g5U1lE?=
 =?utf-8?B?MjhLREJaNFI5cmZETUNVWHNoK1pKbmNGOEJISk5Kd2xNUUVRekloL21sOFBZ?=
 =?utf-8?B?T2pjZUZlRVBMMzhnQ0FKZitHN2xvYnk2WmF3cytJcmxEa0RmRmU4bm9QT0VV?=
 =?utf-8?B?M3RCM1A0bEwyNXBNRjd1U1VXS3VYbEU2RXllT3NVZEhwSFFSNENVb01NbTdM?=
 =?utf-8?B?NGdQQk5LYVNJdDJ1LytRU2cvb3lYUk9JRTZQMTFzRXZESGhBc2tjVFYyYmx0?=
 =?utf-8?B?QThNdnVEYXZZOW5uM1E0NHBScnJ5Uk5SSWhsOVlCdmYxQWNZNTRBV3JrNjBR?=
 =?utf-8?B?MmVySjNpNWsraCtvZ0dWcm4vSXp1SWtObmpvL3U2YWtmcHhpWjJ6ZnFRMmFZ?=
 =?utf-8?B?RDNvWW05UExQbkVLRmdlRTlxbGh5bk5kQVF3cEdGTXI2U1A1Ui95T2FzVUtk?=
 =?utf-8?B?UXVJdnVrYWdvSmJGeEI2VTgwaXFzN3BRTnBXODhXZSsweTBBampiOE1ibm9k?=
 =?utf-8?B?Z3RsWldvcDVHY0tudFEzcFF0SGg1U21JcVJCeDM2L2lUcHVRdVE1dDd6SGpE?=
 =?utf-8?B?c0FjdWpKZG84ektpYnJSbGlsQ3Q5ZG8zRnJRWTg4dVY4T2FkTndxVVZiOExt?=
 =?utf-8?B?TXZUVnBnTnRJSmJzTEhnbnkyUUlLZzYrWGl4L3BJTWowUSs3eXRXZ0JTSXl5?=
 =?utf-8?Q?AcuqAVxk7+sl2C2dnG/cQZE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <312EA3896DE6994EB1CF0A61020971F0@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99afe871-efcb-47b1-8004-08dad1d4d9e8
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Nov 2022 06:42:14.5042
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: E+3iDkygO0j8IyQkBW0Vkp7Rl/XaNon42Lq+ALdL5rgm+DGEfPi4/7l/B0VU1W49kGW7LX0akC8BaeuKdYDF5l6GvcpRlsD0FbHgpGGKU60=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5534
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgT2xla3NpaiwNCg0KT24gTW9uLCAyMDIyLTExLTI4IGF0IDEyOjU5ICswMTAwLCBPbGVrc2lq
IFJlbXBlbCB3cm90ZToNCj4gRVhURVJOQUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBv
cGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3UNCj4ga25vdyB0aGUgY29udGVudCBpcyBzYWZlDQo+
IA0KPiBXaXRoIGN1cnJlbnQgY29kZSBsb29wYmFjayBpcyBub3Qgd29ya2luZyBhbmQgc2VsZnRl
c3Qgd2lsbCBhbHdheXMNCj4gZmFpbC4NCj4gRml4IHJlZ2lzdGVyIGFuZCBiaXQgb2Zmc2V0cyB0
byBtYWtlIGxvb3BiYWNrIG9uIEtTWjg4eDMgc3dpdGNoZXMuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5
OiBPbGVrc2lqIFJlbXBlbCA8by5yZW1wZWxAcGVuZ3V0cm9uaXguZGU+DQo+IC0tLQ0KPiAgZHJp
dmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3o4Nzk1LmMgICAgIHwgMjQgKysrKysrKysrKysrKysr
KysrLS0tLS0NCj4gLQ0KPiAgZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3o4Nzk1X3JlZy5o
IHwgIDEgKw0KPiAgMiBmaWxlcyBjaGFuZ2VkLCAxOSBpbnNlcnRpb25zKCspLCA2IGRlbGV0aW9u
cygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAva3N6ODc5
NS5jDQo+IGIvZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3o4Nzk1LmMNCj4gaW5kZXggMjA4
Y2Y0ZGRlMzk3Li5hNmQ1ZGU0MWE3NTQgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2RzYS9t
aWNyb2NoaXAva3N6ODc5NS5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAva3N6
ODc5NS5jDQo+IEBAIC02MjUsOCArNjI1LDEzIEBAIGludCBrc3o4X3JfcGh5KHN0cnVjdCBrc3pf
ZGV2aWNlICpkZXYsIHUxNiBwaHksDQo+IHUxNiByZWcsIHUxNiAqdmFsKQ0KPiAgICAgICAgICAg
ICAgICAgaWYgKHJldCkNCj4gICAgICAgICAgICAgICAgICAgICAgICAgcmV0dXJuIHJldDsNCj4g
DQo+IC0gICAgICAgICAgICAgICBpZiAocmVzdGFydCAmIFBPUlRfUEhZX0xPT1BCQUNLKQ0KPiAt
ICAgICAgICAgICAgICAgICAgICAgICBkYXRhIHw9IEJNQ1JfTE9PUEJBQ0s7DQo+ICsgICAgICAg
ICAgICAgICBpZiAoa3N6X2lzX2tzejg4eDMoZGV2KSkgew0KPiArICAgICAgICAgICAgICAgICAg
ICAgICBpZiAocmVzdGFydCAmIEtTWjg4NzNfUE9SVF9QSFlfTE9PUEJBQ0spDQo+ICsgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgZGF0YSB8PSBCTUNSX0xPT1BCQUNLOw0KPiArICAgICAg
ICAgICAgICAgfSBlbHNlIHsNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgaWYgKHJlc3RhcnQg
JiBQT1JUX1BIWV9MT09QQkFDSykNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBk
YXRhIHw9IEJNQ1JfTE9PUEJBQ0s7DQo+ICsgICAgICAgICAgICAgICB9DQoNCkNhbiB5b3UgY29u
c2lkZXIgdXNpbmcga3N6ODc5NV9tYXNrc1tdIGFuZCBrc3o4ODYzX21hc2tzW10gdG8gY2hlY2sg
dGhlDQpsb29wYmFjay4gTGlrZSBpZiAocmVzdGFydCAmIG1hc2tbUEhZX0xPT1BCQUspKSB0byBh
dm9pZCB0d28gY2hlY2tzLg0KDQo+ICAgICAgICAgICAgICAgICBpZiAoY3RybCAmIFBPUlRfRk9S
Q0VfMTAwX01CSVQpDQo+ICAgICAgICAgICAgICAgICAgICAgICAgIGRhdGEgfD0gQk1DUl9TUEVF
RDEwMDsNCj4gICAgICAgICAgICAgICAgIGlmIChrc3pfaXNfa3N6ODh4MyhkZXYpKSB7DQo+IGRp
ZmYgLS1naXQgYS9kcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzejg3OTVfcmVnLmgNCj4gYi9k
cml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzejg3OTVfcmVnLmgNCj4gaW5kZXggMGJkY2ViNTM0
MTkyLi4wODIwNGRhN2Q2MjEgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2RzYS9taWNyb2No
aXAva3N6ODc5NV9yZWcuaA0KPiArKysgYi9kcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzejg3
OTVfcmVnLmgNCj4gQEAgLTI2Miw2ICsyNjIsNyBAQA0KPiAgI2RlZmluZSBQT1JUX0FVVE9fTURJ
WF9ESVNBQkxFICAgICAgICAgQklUKDIpDQo+ICAjZGVmaW5lIFBPUlRfRk9SQ0VfTURJWCAgICAg
ICAgICAgICAgICAgICAgICAgIEJJVCgxKQ0KPiAgI2RlZmluZSBQT1JUX01BQ19MT09QQkFDSyAg
ICAgICAgICAgICAgQklUKDApDQo+ICsjZGVmaW5lIEtTWjg4NzNfUE9SVF9QSFlfTE9PUEJBQ0sg
ICAgICBCSVQoMCkNCj4gDQo+ICAjZGVmaW5lIFJFR19QT1JUXzFfU1RBVFVTXzIgICAgICAgICAg
ICAweDFFDQo+ICAjZGVmaW5lIFJFR19QT1JUXzJfU1RBVFVTXzIgICAgICAgICAgICAweDJFDQo+
IC0tDQo+IDIuMzAuMg0KPiANCg==
