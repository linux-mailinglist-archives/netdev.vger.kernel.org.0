Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C74D2111D1
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 19:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732661AbgGARTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 13:19:34 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:62667 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729465AbgGARTd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 13:19:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1593623972; x=1625159972;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Jkv3YNXu8wD6kKjDlH2GQI5wYMloMAT0klArWwgudGM=;
  b=SnDHlpquvey5FGJo1rTKnpyCUTjJTKdHG+ObLOLDnLyGy4bDFFZFBOfz
   0MPypZsI3eUgic+OejLJa+HRNsswyOzmWbPC2Z3lsEGc3K1CafmZiXkNP
   BvNyL77kiKYu66YDAfAdi0J2C3SnhOFGWPdcsNP79RUk4lLOlTlFpYpfI
   UMOMrjOU/4u3QR1DdEDT01feNoIGD8b1IWvudnacASPaM440RhgM0GPSI
   I3NKQQoHqj3ARkjJ8cCLadU0ldgvxVnp6ff7n+r/RWRwEEAi4lGCEj+H4
   ITisjp2ZpvplzGEwX6qsBzlkEzf6D7z72WoYREHa+xm3YPYYlkw+IrI5W
   Q==;
IronPort-SDR: BUv6voY4K39KStG0aZ9vZ6AvtsYKoc/Et+/oWNMT1LzKl7QSCXRF+Ra0ROZFDsEI7AGSITLklW
 p95BzXYqlveA/PvikPm+9kVPh1shFB7Qr17zyTl7I8pyY1oB/B0g2fFseRSXayyXBWaimFawfl
 /jJvksC6wxSfMn3XdRjHnRiI6wzM2DWqYnoNPyivnQ/sUB8naYgigx1hfQGS5BdrO49AqJdBnY
 E6JUmBXLWRwhu0ocKbmeujh5HA5Lp7ANy3FHNWCnKuW3hc0o9K1Emk4zvOZg5X7EptjszvRKY0
 MO8=
X-IronPort-AV: E=Sophos;i="5.75,301,1589266800"; 
   d="scan'208";a="82252363"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Jul 2020 10:19:32 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 1 Jul 2020 10:19:13 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3
 via Frontend Transport; Wed, 1 Jul 2020 10:19:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M0JEHqw1TNWIFf6oDArycqAoW2hrHnlpV1GCdqAc2SwYPAZC8A+MDrw7F5tw3Th+QvfrjWIAZqEnw8KG1AS+lLG1OOlOpzYr6BH8t5KZBMxqced8r1RDTIUlFKZZC47L3c9T3D/VX9DAfRXUO8aBTGqvJw86WQHZ7nrLMzKUyiWC8fn/Zw9KrKjP0ePorS411rVnmB+80XwjGi0v0RAW2x4TPU7lUOdOghKLJ49mXV9MW+lxedtMZ2YAyhj5vLGAiVSOaXNlL3jKLydpOXPNyTQBD0OTFSnzppopraMrdzqOA5YO1naLXQ9v8opI6P7sMbmZBhmCq848S6y7ujsP2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jkv3YNXu8wD6kKjDlH2GQI5wYMloMAT0klArWwgudGM=;
 b=PjsNyPh1gStDq2xbfUB4Tnpu6HyM5bV/kwRT98xOjtCaJXne+zBQ/y7TyRinwanhpYtEi5cKIcP6nRLGGatZdbqN7h+oPGWLSFIqj7DE0sHINrMR+kjNpC5NBKA3f6ddtAWq6vLUvIZjYSy6A4ogXpaXqMbEd7him6dlwn2TMYxr4lh2SO2iCe5xG/PNW7E69edHHvXDMdOT61bVIqMhU8akML3yQpgHULqGm0QcTLM8QUMZC1Gz/RJW8pvn46+lMWAP7gyA57xCD7NVS9HKf5YuEkCbfS/FXHy/IdA7W7qV1z5SFx8yX4SGhOBSi5Uw+N9VxcXgtS9cuO+qnoWbiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jkv3YNXu8wD6kKjDlH2GQI5wYMloMAT0klArWwgudGM=;
 b=oSU+Cljfa1gglHjN1rEmB/wQM4EJQoTeeK4vSmxtFWo4ggqFYB2QKXyNqEceLeePJ5N+TpnwG/FgEvWkrfngBM+jpMGy2p/m1KYtcxZhuG46kXDYWtSX08Y+R7N9Z3qt9BpwhTyyWvWpKJE1tiv0ywPZ3Qu36TfRN6UArT7+52E=
Received: from SN6PR11MB3504.namprd11.prod.outlook.com (2603:10b6:805:d0::17)
 by SA0PR11MB4591.namprd11.prod.outlook.com (2603:10b6:806:9c::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.21; Wed, 1 Jul
 2020 17:19:31 +0000
Received: from SN6PR11MB3504.namprd11.prod.outlook.com
 ([fe80::851c:67fc:a034:9ea0]) by SN6PR11MB3504.namprd11.prod.outlook.com
 ([fe80::851c:67fc:a034:9ea0%4]) with mapi id 15.20.3153.022; Wed, 1 Jul 2020
 17:19:31 +0000
From:   <Codrin.Ciubotariu@microchip.com>
To:     <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <Woojung.Huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <vivien.didelot@gmail.com>, <f.fainelli@gmail.com>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <Nicolas.Ferre@microchip.com>
Subject: Re: [PATCH 1/2] net: dsa: microchip: set the correct number of ports
 in dsa_switch
Thread-Topic: [PATCH 1/2] net: dsa: microchip: set the correct number of ports
 in dsa_switch
Thread-Index: AQHWT8fkk+DlVV4cukaXgz7WEm48/ajy9TEAgAACzgA=
Date:   Wed, 1 Jul 2020 17:19:31 +0000
Message-ID: <a992ae4a-64b6-83b6-cbe5-0e8db39dcea6@microchip.com>
References: <20200701165128.1213447-1-codrin.ciubotariu@microchip.com>
 <20200701170928.GE752507@lunn.ch>
In-Reply-To: <20200701170928.GE752507@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [84.232.220.208]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a4b63652-2c05-4321-cf3e-08d81de2eac4
x-ms-traffictypediagnostic: SA0PR11MB4591:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA0PR11MB459171A03FD919A9FDF93E0BE76C0@SA0PR11MB4591.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 04519BA941
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2/L9cKYXeG2zmeZVtX+wXy7ydpDv1PgRhs5prUmV3mKsTCF9SRSBRoMq5i6WydC/5f1tuR3UoqNuHt1hlw4HZgB3cfkuoxvGFYcr2BoBzgVLl8kC8VVjWyIY6Y4DD2Vt464JALuU2vzb3pnIgE4ipSGK7dpHCwlKMRI2Tntrd9axomt2SHk61ENGFpN5mNnp/O48fvFAXTqxaDZMVAx7r0MvHUN5QiQ7hP6NwhIrkMdmSSK3yh6xQaWEA4M6P9EDgb8Tk7ZmZ45TXdMcZqwiIMq4steeFsc/cC13rIGTiB7aJcSmK8/SOuqhJsGN6T55dCNtCvEBxZ9Xl58eKc8uZhX/TTrNrc5Eh2fvLCg/gtdMn7GvzIC2bAROsNv9xkPg
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3504.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(396003)(136003)(39860400002)(376002)(346002)(53546011)(26005)(36756003)(4326008)(186003)(107886003)(6512007)(2906002)(6916009)(66476007)(76116006)(91956017)(66446008)(66556008)(5660300002)(64756008)(66946007)(2616005)(6486002)(71200400001)(86362001)(8676002)(8936002)(31696002)(6506007)(31686004)(316002)(54906003)(478600001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: iPq9bEE0fcu2cd5zr/wNygi4fPgEQOyQHBzTHN/B8aoRQ5lYp/OjKMQzamc219w2hKz7JwvcsYBNVrvqODb87pwvlFK5+F6IfcHOTBez71b0hIxMFTDF5MbF2Ho9lstr4APxdfzvBGDQGa3rJSdxJ8B3w/fMzhcU9EnQGIbVQBLpPXVCFqXM6AWzc89XGnnA1s1KF3WjmXAdJ4rnUbrtGc8CesiYEMcJOMc/H+7X2ey+zUQIfliaKLxUDBSaWaa3DPBaMNSl99wfHsdzAXCPxx4QHbBetlKBdTao5VmfOCgLHW98rTPNhS2jtz7AxF0mUIpBr/dgzDR0p7qqY7ZAIoD+NZ2+o8GtJVBZj+6Ew55ZAe2wV62kv5D6VO0ynibMuMDtpTfSZzUWp8NYpgN6qTPn6y1imiJLWgwgGIMIO5S1q4jmUFCSUV8Pci6f4Zc0VFAyCFbTCCt1SFIJISuZHfjqeS98BUHgp0893piZIbUaPBFrX5hDUwsvL0WEHToY
Content-Type: text/plain; charset="utf-8"
Content-ID: <119BACB2E8D8694395FE2C9856BCE314@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3504.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4b63652-2c05-4321-cf3e-08d81de2eac4
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jul 2020 17:19:31.0356
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gWVskhlkfdBlgCAozWOcvl3eUBPy5xR4gITWuMyXYocVjXdUMV0bAxFjIsMYUkOV7XXiOL+AqZQoq7CIrxC2qQttIY+qqNe6v3Zn3NQ9ZxU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4591
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMDEuMDcuMjAyMCAyMDowOSwgQW5kcmV3IEx1bm4gd3JvdGU6DQo+IEVYVEVSTkFMIEVNQUlM
OiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91IGtub3cg
dGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiANCj4gT24gV2VkLCBKdWwgMDEsIDIwMjAgYXQgMDc6NTE6
MjdQTSArMDMwMCwgQ29kcmluIENpdWJvdGFyaXUgd3JvdGU6DQo+PiBUaGUgbnVtYmVyIG9mIHBv
cnRzIGlzIGluY29ycmVjdGx5IHNldCB0byB0aGUgbWF4aW11bSBhdmFpbGFibGUgZm9yIGEgRFNB
DQo+PiBzd2l0Y2guIEV2ZW4gaWYgdGhlIGV4dHJhIHBvcnRzIGFyZSBub3QgdXNlZCwgdGhpcyBj
YXVzZXMgc29tZSBmdW5jdGlvbnMNCj4+IHRvIGJlIGNhbGxlZCBsYXRlciwgbGlrZSBwb3J0X2Rp
c2FibGUoKSBhbmQgcG9ydF9zdHBfc3RhdGVfc2V0KCkuIElmIHRoZQ0KPj4gZHJpdmVyIGRvZXNu
J3QgY2hlY2sgdGhlIHBvcnQgaW5kZXgsIGl0IHdpbGwgZW5kIHVwIG1vZGlmeWluZyB1bmtub3du
DQo+PiByZWdpc3RlcnMuDQo+Pg0KPj4gRml4ZXM6IGI5ODdlOThlNTBhYiAoImRzYTogYWRkIERT
QSBzd2l0Y2ggZHJpdmVyIGZvciBNaWNyb2NoaXAgS1NaOTQ3NyIpDQo+IA0KPiBIaSBDb2RyaW4N
Cj4gDQo+IFlvdSBkb24ndCBpbmRpY2F0ZSB3aGljaCB0cmVlIHRoaXMgaXMgZm9yLiBuZXQtbmV4
dCwgb3IgbmV0PyAgSXQgbG9va3MNCj4gbGlrZSBpdCBmaXhlcyBhIHJlYWwgaXNzdWUsIHNvIGl0
IHByb2JhYmx5IHNob3VsZCBiZSBmb3IgbmV0LiBCdXQNCj4gcGF0Y2hlcyB0byBuZXQgc2hvdWxk
IGJlIG1pbmltYWwuIElzIGl0IHBvc3NpYmxlIHRvIGRvIHRoZQ0KPiANCj4gICAgICAgICAgZHMt
Pm51bV9wb3J0cyA9IHN3ZGV2LT5wb3J0X2NudDsNCj4gDQo+IHdpdGhvdXQgYWxsIHRoZSBvdGhl
ciBjaGFuZ2VzPyBZb3UgY2FuIHRoZW4gaGF2ZSBhIHJlZmFjdG9yaW5nIHBhdGNoDQo+IGluIG5l
dC1uZXh0Lg0KDQpUaGlzIG9uZSBzaG91bGQgYmUgZm9yIG5ldC4gT2sgdGhlbiwgSSB3aWxsIHNl
bmQgYSBzaW1wbGVyIHZlcnNpb24gb2YgDQp0aGlzIHBhdGNoIGZvciBuZXQsIGp1c3QgdG8gZml4
IHRoZSBpc3N1ZSBhbmQgYW5vdGhlciBvbmUgbGlrZSB0aGlzIG9uZSANCmZvciBuZXQtbmV4dC4N
Cg0KVGhhbmtzIGFuZCBiZXN0IHJlZ2FyZHMsDQpDb2RyaW4NCg0KPiANCj4gVGhhbmtzDQo+ICAg
ICAgICAgIEFuZHJldw0KPiANCg0K
