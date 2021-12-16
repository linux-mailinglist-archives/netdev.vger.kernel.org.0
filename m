Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4916D476ACF
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 08:09:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234341AbhLPHJH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 02:09:07 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:64803 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234333AbhLPHJG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 02:09:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1639638547; x=1671174547;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=6jNBb7MSI8l6TnBB/camvVVqgNqGXRXRMbUhHFD8tg4=;
  b=RyzaNmpV9/LZenvAr6W81p8pL37wrVsk8T9DuX51WNvHi7ZqTfC/8T8Y
   T6rXqqJRH7eFsxGBalbtBq+DsBp0Slrp0GCtchYNxw/Cdt2+Wa71qjtDt
   xTgf6iXCruYaUgKsu6yM9a6OG5IO17vgSHvzPol5Pdkz/0c6gv7CcSlMA
   dbQFqiBnRj+w8nI8WDD/WZFvIT1Ie846gfQbiqbw23/FuTJyhs4S1lW0U
   F3uRUVGjhFhjnHuJ62z7CovT6yHvF5NhzRGOxhRPZ1bOlOtN41JC7MK7m
   mHGK372EYoUbgweMh89+AGMo78+LyrRTpKa6qcrcUOv0oQN5TNkhfEvlS
   A==;
IronPort-SDR: xE8jrmhygneTBDyLJeEY36uTYP15acHjN9y9AOqaqYRX/5lEiJKMVBn+s6LXwrSsJFScd2NmGz
 lEjOw9EQHEweebGKOUH4jYyzAY0TcrbIx8n48N2FsS/JObFPKoBC5aKG20XpbdlrLOGCl+tXIC
 9dbMIzHyahs1wnwjGnk7MOnVz8CehrSw4NGhbSXbc/lJij1N0yBZqxatytE8AZe5zy5uisoAM1
 c1twPXYx9rjhfLYChe+po3qvStwpcyv1Vmtwudqy7x0pLMDXz/Q9flNiqvTK9n9kGTi274K71f
 gfgKnN6aiKI0vXuFjhnkEHab
X-IronPort-AV: E=Sophos;i="5.88,210,1635231600"; 
   d="scan'208";a="146852259"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Dec 2021 00:09:05 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 16 Dec 2021 00:09:00 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17 via Frontend
 Transport; Thu, 16 Dec 2021 00:09:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IiDwSvIHQLNN9l/c4l4a01XT5Pg1bn/GGLQ5KffMjiigJtPFrHpEaviZbsGNUSSbrXkYywIxwv5d2k7i4onZed3AGmgUJYJz6IYFY4Gk4e0JG6462aGRy2hEHg0QoqbRGMLQwocmIucKuULkf40gguI74z7h/eibW/SrLUlpoGNBU0bCiGP23bCIl7Y1oDVQYBXMhfIOWKA9TMXZ+/5254ma5YEnu6uYhvnhxMNoobFdSJn5AtMsKsZVqYsZClNZVZ8sZGrMp9MDBdXtLSwyChYl7O7ljE+wWQdNednxScjBkJNqZkGhD2nEW6pWSdfpD4aGR74xJxMZpnsqHqYYug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6jNBb7MSI8l6TnBB/camvVVqgNqGXRXRMbUhHFD8tg4=;
 b=AwhAVdlRNf/AyUH4UIt87wZvUh9YdZy8pZPl0RmO4J99oDugNjhg5aZ4dTeJ3jt6znF9r3HlXf9wtQBa+JRhrLrOCyia9j2oXO/HbgiTxUgPZuCE6KeH0iIUmeiTkTQmCoEil8xeYVX8oIWxkgMRvRVLF+WZLcuQfqoAbpRK/fke7K5JLOz3EWNA8p+Y7urfBKHuyAo1SBg3jw7byUvYn6hocACOobMM5M3L/Qp1BgDAJSi+EoLnIoqBOHO8mbTffFuwcpjnH7yKZqp1DMhAq67tj9azZR6c0KGX9/MMUZfaemgNK0pWiu03VKXUJLpGMD1AF3TCaeot71ZlpEqQAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6jNBb7MSI8l6TnBB/camvVVqgNqGXRXRMbUhHFD8tg4=;
 b=I7IlI3x2ICE7XgcljgcTXYohG6HeSK/FTHbCtHASwkBi4V0V6pAmWd1rERDzVNkhv3hZVDCgoyCKbf2STqQVzyURZPnIeBfaFga6lzb5hKhMtCL+lNtjhO0/wuP19nbOw26k9A+QZO+UzZbGSnc9g3ZvAlnauTHS4ShvPdED/lU=
Received: from CO1PR11MB4769.namprd11.prod.outlook.com (2603:10b6:303:91::21)
 by MWHPR11MB1581.namprd11.prod.outlook.com (2603:10b6:301:d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.18; Thu, 16 Dec
 2021 07:08:55 +0000
Received: from CO1PR11MB4769.namprd11.prod.outlook.com
 ([fe80::bd93:cf07:ea77:3b50]) by CO1PR11MB4769.namprd11.prod.outlook.com
 ([fe80::bd93:cf07:ea77:3b50%7]) with mapi id 15.20.4778.018; Thu, 16 Dec 2021
 07:08:55 +0000
From:   <Claudiu.Beznea@microchip.com>
To:     <davidm@egauge.net>, <Ajay.Kathat@microchip.com>
CC:     <adham.abozaeid@microchip.com>, <davem@davemloft.net>,
        <devicetree@vger.kernel.org>, <kuba@kernel.org>,
        <kvalo@codeaurora.org>, <linux-kernel@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <robh+dt@kernel.org>
Subject: Re: [PATCH v5 1/2] wilc1000: Add reset/enable GPIO support to SPI
 driver
Thread-Topic: [PATCH v5 1/2] wilc1000: Add reset/enable GPIO support to SPI
 driver
Thread-Index: AQHX8X7Fz1JXQBD6wEiVBWL5VPrTzg==
Date:   Thu, 16 Dec 2021 07:08:55 +0000
Message-ID: <0d3a6f22-1ab4-a93d-1fea-8763546db291@microchip.com>
References: <20211215030501.3779911-1-davidm@egauge.net>
 <20211215030501.3779911-2-davidm@egauge.net>
 <d55a2558-b05d-5995-b0f0-f234cb3b50aa@microchip.com>
 <9cfbcc99f8a70ba2c03a9ad99f273f12e237e09f.camel@egauge.net>
In-Reply-To: <9cfbcc99f8a70ba2c03a9ad99f273f12e237e09f.camel@egauge.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c7a45bee-2263-40b7-e49c-08d9c062ecab
x-ms-traffictypediagnostic: MWHPR11MB1581:EE_
x-microsoft-antispam-prvs: <MWHPR11MB158140E5A9643B938FE7204D87779@MWHPR11MB1581.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: r2OWZkyI7mOOmNW52WBZHsy0dQgYNib/Gktm6JV3glr1As05WCADY2XObhfpamHZiHOntHdxK3Z1XWvDpkEU7ld2nSm4FyphS6vfYmUbMtbfzoTn3Tks0N+VMe1j9EEHke/fc7PQ4kYvdYHjaL48TsjGjApx/awiqC6CUj2AMZZJuz+hFqGKUaPYn32/Uv3T+h+F2kl/72ZoyHvs1+DVqA6/Ea7B1SwxRuTdB7yqzvsVRm4H7BEUL5ryEtpgmfeh/2dB6j5Ms8+1PayCnzmgOgkCPqcHOO/M/1N4/I53Dw8/BOvfjn4aCqRiwcpCC4zrjPIcBB6+36r9i6Tq1pfxcLKDxwGUvnQJCcPmmI6Yo1kV25bPmtkqT+DtFah7LtGP5SpeP5VI8EyWtjFTE2WmzFWzLmH5sj+Bomarxb1qmsLwWl+8GYMuPbryL+ZBvbhlNeFeKRDBux0tv5CER2egJRJmH2kf2xE0V0pk1oLLrieOO/TnTUYEB7k/bqjlbPxH4K8GmowaLoKHlz+NtVYLQzSBQA/ekZJ9jvNw9RXnZe4JfoDNTEJusTeSOnQOeH1fKy9eF2/4SbhReOk29JRsunRqxZ+K/vx5RKQuUzfWItj5Mxe/pNZNnDAvHSW48U38YyvtC/2eB9UyJ6T+zWGGgpX97Pc6Tl4iTMHqe1fH7dab/JZ/vr6X+6HkVr2fVX/SXe57kbrU3o3eecSYbshvbB/1zT++Wj8jTGbveJeYIfPc1KJpUAdJsk7S7IIfLBILI4v9Z81u/hEMKN/Mc+CjZg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4769.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66946007)(31686004)(5660300002)(36756003)(38070700005)(6636002)(508600001)(6506007)(31696002)(186003)(2906002)(66556008)(8936002)(64756008)(4326008)(54906003)(86362001)(8676002)(66476007)(6512007)(71200400001)(91956017)(38100700002)(316002)(53546011)(6486002)(76116006)(110136005)(66446008)(83380400001)(26005)(4001150100001)(122000001)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QWVPTnRKWU5XV1hpVlNHSGdDbVozNVlQWDkxMG1HekNuUkVlWm9Wd0tDUi9S?=
 =?utf-8?B?TXBDNlhiblJUNkVrUTkxaUE0UzBZZnNxMTh1S3FjdDBTZENySW5XNS9HdmhF?=
 =?utf-8?B?a2dWV2hBK1ZzL2l5WERtUlZ2Y3BXMXJYbzZOamlEYTR2ZHRMb1RNYUtPZDRF?=
 =?utf-8?B?Skp4Z3M2R05uT0xQOXhCY0tudVBndlNQcTZKMHJrSUdiWTlqV04zdzIzdUJN?=
 =?utf-8?B?Ukx0NVJoL2NSdFhPWWNNejc5WTVIaitSTk5MellLUFJ2bEJxVkwzWC9wS3J5?=
 =?utf-8?B?dUcyL2tyRkdRNHB2UkJyUE1QWHZpdTRIeEVuaHVLdUQvLy9wKzNPSC9YbFYy?=
 =?utf-8?B?V21kL3l4cWQzcSs1L0ZHT0E1bnpEL2xtRkNTcXZCak00bTc2QjNmVEtBT3R5?=
 =?utf-8?B?T2htUXhnSGVIY2dJV29GQk5INzhDTzlDRlJUY21vaEdibmlwQzh3VXdIbzFP?=
 =?utf-8?B?Y1hOaEgzRitwbUtIM05Sc3ZUa1pEOUdHUkRnTDg0VW5iWjlibi8wRWxIWXJZ?=
 =?utf-8?B?QXM0UlpJNFBROGhPaVJ6YU9qOW5qSUxaYjZudDZIMHV5UkVRQWFkRks0eVhF?=
 =?utf-8?B?ZWEzQWFZUVBJN1pjUmZPaFRMODFFS3QvOXNXZDJXclZFZjJtU2dFKzRXVHk3?=
 =?utf-8?B?Tkl5M2EvSE40QmtDN1ZyckxuL00rTjlaTWs3NHdpaUxjZU8xclZVRHB0Z1o3?=
 =?utf-8?B?U1pSdTZLbkU5QnZOUEMxc2pKYkxSaGMwd2RQYUh3RlNiUnJzK1VJMW5xWWM0?=
 =?utf-8?B?QWw3M3FUbHpDK0JFaGJRMmYxbDV3bytVV0lrMWxpblFvQTJCVWc0bnFkV2tN?=
 =?utf-8?B?UHc5RUVRVVFTbDhrOEJpTTFmT0VUQ3VkUXpXdktxYW96eHpzd0ZUSSt2eWFp?=
 =?utf-8?B?RkZlcG9JMk1MVW81WEp3bk9QaDBybHpkNFBDRG8yblFDUE03UzF5MHJWMHNl?=
 =?utf-8?B?VEkrNGtlR2dORTVBMTl6WFA0a0xZNlJzdWdSTGVsdk85WGx6MlBraFJoOGxh?=
 =?utf-8?B?U1lNdmxqMlVWR2R1czNiQVNEYWh2MXdLbWZEVUwwbDlITHEwQUcyT1VqY3pJ?=
 =?utf-8?B?TlNRMTFpbklUZWQ2eFRLMzFKMk1lRjZsQVlCUTNFY2Z6Y0tvazFnYkFVcGdQ?=
 =?utf-8?B?M0xHUjN5TjgyVHhmWXRaMUlSbWZjbEJqRnZoYm9oNXNnUy9ZcjNRN3BYb0RR?=
 =?utf-8?B?TmthTXdBdlFUaWNpS0xITURVdU93eU83SUtEV3JjZTlXcWdBZWR2NFV3UXEv?=
 =?utf-8?B?Um5BWjd6NG1BV2ZESGJuVmdrL3pIS1JmUlJjNTcxeDJaZUNKdGxLUmVaMmJ1?=
 =?utf-8?B?aDdkcXowaFM1MFRtd3cxTzV5NnpRTnB1Q3pTaXRLVXc5enJrYlBYSDA4STV0?=
 =?utf-8?B?dzJWb0p2cVRtV1lWSHl5NTB1cHQ0NE1BTU9FZFFtQ3VReXZOdjdIN1dpUEx3?=
 =?utf-8?B?TnFPYlRyaGdlSDE5WTE1Z3BxTnN0ZzlqTkJrS09HeWV4NytBa0tWbjJYWGU5?=
 =?utf-8?B?dXR1d1c1ZHRFYk1BanorZlBjdWMxcEo2K1p2VS9ZbUVqaFZQa2hqRFRqSGZ1?=
 =?utf-8?B?SHdxelF2dVlUOWhlUU1wd1R0WUtkVVorRnoyZmFNR2EvOENrWEZGTHhReE5S?=
 =?utf-8?B?V0pCSCt6Y1k4NFRhdlpBSlpNTllSU0NNTDRTWHN5dGtzWlo0OU9sUGxOOTFL?=
 =?utf-8?B?Rlova2t3RURocVdGUi9lUXZxNEdpbmc5cFJSd3NZQ1E0Zll6Ly9mMlFLNGZE?=
 =?utf-8?B?WW5aeUxYa2dQUkxaTzhFMjNPeWZUTHRHeFpkK3U1VFlPT2dWT2VpSU9uaVpu?=
 =?utf-8?B?RGpuVzczWjhNOFdiNTJxUmNHSnpPcXl1b1NQL3R3KzJvUWtaanhDVXA5S0Fj?=
 =?utf-8?B?VXpiT01JbitKUjJVUU1pVzlvNk1zWTFWdEptTVdPSGo0VDEvWFNadjdHWXg0?=
 =?utf-8?B?T2V1c290Vm9mUFdYTkdGLzNRaUY3SlI0VURYbFV5bVhtcXd2cmRNeXd6Zkdy?=
 =?utf-8?B?YTF3TlNzbkFJampoOVFpYmFvUFdZUXJHNjJxdi80aStWRENwdkdseTZ5Vkg3?=
 =?utf-8?B?aTBZRWxId1kwWmhBV0ExVjdlMzhRVkxGeitCTno5UUlwditFZHNrUS8xTE9j?=
 =?utf-8?B?VEZOZDlFQUF3UkNFWXVsL1VDUE8vNzZ3aXVBK0dXeWRqdDBrWmV0cGozUGVE?=
 =?utf-8?B?WmlSS2liakNLa0pyMCtNNTZPVEw1d0gwTVVFKytpbWVYOEVWbDVmdmExSE4x?=
 =?utf-8?B?ckFOanA4c1UvdVFDaDNmVG1pdlNnPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <ACA354B21DA0CF4EA322A1947D19C3EC@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4769.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7a45bee-2263-40b7-e49c-08d9c062ecab
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2021 07:08:55.8656
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: d7tzrQoEXECgfY3rYr3WztMjnDK7X2wcxZGXdWZouv5e1N9JtAyX7MkAjDR1SwTZqXMLgcVQrLo3Qi3wrh9l8KncxMVOYyEOG+2NUk71kLU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1581
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTUuMTIuMjAyMSAxNjo1OSwgRGF2aWQgTW9zYmVyZ2VyLVRhbmcgd3JvdGU6DQo+IEVYVEVS
TkFMIEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3Mg
eW91IGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiANCj4gT24gV2VkLCAyMDIxLTEyLTE1IGF0
IDA2OjQxICswMDAwLCBDbGF1ZGl1LkJlem5lYUBtaWNyb2NoaXAuY29tIHdyb3RlOg0KPj4gT24g
MTUuMTIuMjAyMSAwNTowNSwgRGF2aWQgTW9zYmVyZ2VyLVRhbmcgd3JvdGU6DQo+Pj4NCj4+ICtz
dGF0aWMgaW50IHdpbGNfcGFyc2VfZ3Bpb3Moc3RydWN0IHdpbGMgKndpbGMpDQo+Pj4gK3sNCj4+
PiArICAgICAgIHN0cnVjdCBzcGlfZGV2aWNlICpzcGkgPSB0b19zcGlfZGV2aWNlKHdpbGMtPmRl
dik7DQo+Pj4gKyAgICAgICBzdHJ1Y3Qgd2lsY19zcGkgKnNwaV9wcml2ID0gd2lsYy0+YnVzX2Rh
dGE7DQo+Pj4gKyAgICAgICBzdHJ1Y3Qgd2lsY19ncGlvcyAqZ3Bpb3MgPSAmc3BpX3ByaXYtPmdw
aW9zOw0KPj4+ICsNCj4+PiArICAgICAgIC8qIGdldCBFTkFCTEUgcGluIGFuZCBkZWFzc2VydCBp
dCAoaWYgaXQgaXMgZGVmaW5lZCk6ICovDQo+Pj4gKyAgICAgICBncGlvcy0+ZW5hYmxlID0gZGV2
bV9ncGlvZF9nZXRfb3B0aW9uYWwoJnNwaS0+ZGV2LA0KPj4+ICsgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICJlbmFibGUiLCBHUElPRF9PVVRfTE9XKTsNCj4+
PiArICAgICAgIC8qIGdldCBSRVNFVCBwaW4gYW5kIGFzc2VydCBpdCAoaWYgaXQgaXMgZGVmaW5l
ZCk6ICovDQo+Pj4gKyAgICAgICBpZiAoZ3Bpb3MtPmVuYWJsZSkgew0KPj4+ICsgICAgICAgICAg
ICAgICAvKiBpZiBlbmFibGUgcGluIGV4aXN0cywgcmVzZXQgbXVzdCBleGlzdCBhcyB3ZWxsICov
DQo+Pj4gKyAgICAgICAgICAgICAgIGdwaW9zLT5yZXNldCA9IGRldm1fZ3Bpb2RfZ2V0KCZzcGkt
PmRldiwNCj4+PiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
InJlc2V0IiwgR1BJT0RfT1VUX0hJR0gpOw0KPj4NCj4+IEFzIGZhciBhcyBJIGNhbiB0ZWxsIGZv
cm0gZ3Bpb2xpYiBjb2RlIHRoZSBkaWZmZXJlbmNlIGIvdyBHUElPRF9PVVRfSElHSA0KPj4gYW5k
IEdQSU9EX09VVF9MT1cgaW4gZ3Bpb2xpYiBpcyByZWxhdGVkIHRvIHRoZSBpbml0aWFsIHZhbHVl
IGZvciB0aGUgR1BJTy4NCj4gDQo+IFllcy4NCj4gDQo+PiBEaWQgeW91IHVzZWQgR1BJT0RfT1VU
X0hJR0ggZm9yIHJlc2V0IHRvIGhhdmUgdGhlIGNoaXAgb3V0IG9mIHJlc2V0IGF0IHRoaXMNCj4+
IHBvaW50Pw0KPiANCj4gTm8sIH5SRVNFVCBpcyBhbiBhY3RpdmUtbG93IHNpZ25hbC4gIEdQSU9E
X09VVF9MT1cgc2hvdWxkIHJlYWxseSBiZQ0KPiBjYWxsZWQgR1BJT0RfT1VUX0RFQVNTRVJURUQg
b3Igc29tZXRoaW5nIGxpa2UgdGhhdC4gIFRoZSBjb2RlIGVuc3VyZXMNCj4gdGhhdCB0aGUgY2hp
cCBpcyBpbiBSRVNFVCBhbmQgfkVOQUJMRWQgYWZ0ZXIgcGFyc2luZyB0aGUgR1BJT3MuDQo+IA0K
Pj4+ICsgICAgICAgICAgICAgICBpZiAoSVNfRVJSKGdwaW9zLT5yZXNldCkpIHsNCj4+PiArICAg
ICAgICAgICAgICAgICAgICAgICBkZXZfZXJyKCZzcGktPmRldiwgIm1pc3NpbmcgcmVzZXQgZ3Bp
by5cbiIpOw0KPj4+ICsgICAgICAgICAgICAgICAgICAgICAgIHJldHVybiBQVFJfRVJSKGdwaW9z
LT5yZXNldCk7DQo+Pj4gKyAgICAgICAgICAgICAgIH0NCj4+PiArICAgICAgIH0gZWxzZSB7DQo+
Pj4gKyAgICAgICAgICAgICAgIGdwaW9zLT5yZXNldCA9IGRldm1fZ3Bpb2RfZ2V0X29wdGlvbmFs
KCZzcGktPmRldiwNCj4+PiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgInJlc2V0IiwgR1BJT0RfT1VUX0hJR0gpOw0KPj4+ICsgICAgICAgfQ0K
Pj4+ICsgICAgICAgcmV0dXJuIDA7DQo+Pj4gK30NCj4+PiArDQo+Pj4gK3N0YXRpYyB2b2lkIHdp
bGNfd2xhbl9wb3dlcihzdHJ1Y3Qgd2lsYyAqd2lsYywgYm9vbCBvbikNCj4+PiArew0KPj4+ICsg
ICAgICAgc3RydWN0IHdpbGNfc3BpICpzcGlfcHJpdiA9IHdpbGMtPmJ1c19kYXRhOw0KPj4+ICsg
ICAgICAgc3RydWN0IHdpbGNfZ3Bpb3MgKmdwaW9zID0gJnNwaV9wcml2LT5ncGlvczsNCj4+PiAr
DQo+Pj4gKyAgICAgICBpZiAob24pIHsNCj4+PiArICAgICAgICAgICAgICAgZ3Bpb2Rfc2V0X3Zh
bHVlKGdwaW9zLT5lbmFibGUsIDEpOyAgICAgIC8qIGFzc2VydCBFTkFCTEUgKi8NCj4+PiArICAg
ICAgICAgICAgICAgbWRlbGF5KDUpOw0KPj4+ICsgICAgICAgICAgICAgICBncGlvZF9zZXRfdmFs
dWUoZ3Bpb3MtPnJlc2V0LCAwKTsgICAgICAgLyogZGVhc3NlcnQgUkVTRVQgKi8NCj4+DQo+PiBG
cm9tIHdoYXQgSSBjYW4gdGVsbCBmcm9tIGdwaW9saWIgY29kZSwgcmVxdWVzdGluZyB0aGUgcGlu
IGZyb20gZGV2aWNlIHRyZWUNCj4+IHdpdGg6DQo+Pg0KPj4gKyAgICAgICAgcmVzZXQtZ3Bpb3Mg
PSA8JnBpb0EgNiBHUElPX0FDVElWRV9MT1c+Ow0KPj4NCj4+IG1ha2VzIHRoZSB2YWx1ZSB3cml0
dGVuIHdpdGggZ3Bpb2Rfc2V0X3ZhbHVlKCkgdG8gYmUgbmVnYXRlZCwgdGh1cyB0aGUgMA0KPj4g
d3JpdHRlbiBoZXJlIGlzIHRyYW5zbGF0ZWQgdG8gYSAxIG9uIHRoZSBwaW4uIElzIHRoZXJlIGEg
cmVhc29uIHlvdSBkaWQgaXQNCj4+IGxpa2UgdGhpcz8NCj4gDQo+IFllcywgb2YgY291cnNlLiAg
UkVTRVQgaXMgYW4gYWN0aXZlLWxvdyBzaWduYWwsIGFzIGRlZmluZWQgaW4gdGhlDQo+IGRhdGFz
aGVldC4NCg0KUmlnaHQsIEkgbWlzc2VkIHRoYXQuDQoNCj4gDQo+PiBXb3VsZCBpdCBoYXZlIGJl
ZW4gc2ltcGxlciB0byBoYXZlIGJvdGggcGlucyByZXF1ZXN0ZWQgd2l0aA0KPj4gR1BJT19BQ1RJ
VkVfSElHSCBhbmQgaGVyZSB0byBkbyBncGlvZF9zZXRfdmFsdWUoZ3BpbywgMSkgZm9yIGJvdGgg
b2YgdGhlDQo+PiBwaW4uIEluIHRoaXMgd2F5LCBhdCB0aGUgZmlyc3QgcmVhZCBvZiB0aGUgY29k
ZSBvbmUgb25lIHdvdWxkIGhhdmUgYmVlbg0KPj4gdGVsbGluZyB0aGF0IGl0IGRvZXMgd2hhdCBk
YXRhc2hlZXQgc3BlY2lmaWVzOiBmb3IgcG93ZXIgb24gdG9nZ2xlIGVuYWJsZQ0KPj4gYW5kIHJl
c2V0IGdwaW9zIGZyb20gMCB0byAxIHdpdGggYSBkZWxheSBpbiBiZXR3ZWVuLg0KPiANCj4gSSB0
aGluayB5b3UncmUgY29uZnVzaW5nIDAgYW5kIDEgd2l0aCBsb3ctdm9sdGFnZSBhbmQgaGlnaC12
b2x0YWdlLiAgMA0KPiBtZWFucyBkZS1hc3NlcnQgdGhlIHNpZ25hbCwgMSBtZWFucyBhc3NlcnQg
dGhlIHNpZ25hbC4gIFdoZXRoZXIgdGhhdA0KPiB0cmFuc2xhdGVzIHRvIGEgbG93IHZvbHRhZ2Ug
b3IgYSBoaWdoIHZvbHRhZ2UgZGVwZW5kcyBvbiB3aGV0aGVyIHRoZQ0KPiBzaWduYWwgYSBhY3Rp
dmUtbG93IG9yIGFjdGl2ZS1oaWdoLg0KPiANCj4+DQo+Pg0KPj4+ICsgICAgICAgfSBlbHNlIHsN
Cj4+PiArICAgICAgICAgICAgICAgZ3Bpb2Rfc2V0X3ZhbHVlKGdwaW9zLT5yZXNldCwgMSk7ICAg
ICAgIC8qIGFzc2VydCBSRVNFVCAqLw0KPj4+ICsgICAgICAgICAgICAgICBncGlvZF9zZXRfdmFs
dWUoZ3Bpb3MtPmVuYWJsZSwgMCk7ICAgICAgLyogZGVhc3NlcnQgRU5BQkxFICovDQo+Pg0KPj4g
SSBkb24ndCB1c3VhbGx5IHNlZSBjb21tZW50cyBuZWFyIHRoZSBjb2RlIGxpbmUgaW4ga2VybmVs
LiBNYXliZSBtb3ZlIHRoZW0NCj4+IGJlZm9yZSB0aGUgYWN0dWFsIGNvZGUgbGluZSBvciByZW1v
dmUgdGhlbSBhdCBhbGwgYXMgdGhlIGNvZGUgaXMgaW1wbGVyIGVub3VnaD8NCj4gDQo+IFlvdSdy
ZSBraWRkaW5nLCByaWdodD8NCj4gDQo+ICAgLS1kYXZpZA0KPiANCg0K
