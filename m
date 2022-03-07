Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CE174CF0CB
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 06:02:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235236AbiCGFD0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 00:03:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiCGFDY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 00:03:24 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AC092626;
        Sun,  6 Mar 2022 21:02:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1646629350; x=1678165350;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=FUs+rIrwefUaWcWIVab0lrzVThWblVUqcXepOFsm2ds=;
  b=DesK+bMcqUOBbvETaCYCUS8yok88lRvVwtrk7szbZprt7zRbUbrjymbg
   vRJMFgO+xfaEp9Vc7HnxC0sVe2a+a+97zKg86p3otqRHZY9EA11Il/vU/
   m6mq7kwAc2d3MuhOT4sPMlem+Qv1r0kEWdfR0ABBdn+tOFxOC8asanqCP
   sA9ViZtyORLgtPwFIf40fp62HBtMQ8GCNADJVUhd+Qcdv61RVWbMEhgF9
   CG8MLLVAE6jcV8LXWIRUav0GA+k/au83g6FRAwkFxA0/W+Vwf1ujuGs2Z
   rB7GL+N7ys1MK23W1CVghDBQgwIXkHvYCynZKbGEhFFlD0cHPkapsq8Gd
   w==;
X-IronPort-AV: E=Sophos;i="5.90,160,1643698800"; 
   d="scan'208";a="88016132"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Mar 2022 22:02:29 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Sun, 6 Mar 2022 22:02:29 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17 via Frontend Transport; Sun, 6 Mar 2022 22:02:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Djsfn1JvPN4eqhx87tMcVTToCRe9Ca1s2J05NBCZb5PA2RQiQwDc55tYNVQCigHquIsREMK8RDp/h+Sb2Wdte63l2oK+6t4tOCqZL1XH08LHKomIxkkiHE4V0IMdPzUAb7XPr6FXZ/dm4fJxeOY5Tqh+ILsBAE9aQhKLvO+Yc4HaxfQOxOFeGlbJChCi2keFKi22ur4EFefvovWlwoTYtfbeUls0jWDTGKKbo13iFhEwoqjdtibHRyj7XK3NDKth8HbiCxPUhkJkXUbOSxocLFK02Tm2jcV8CezV6zeb2WP8ddT+7a1Dr6N+HHULUaAU8iOBTEgYJh++K69m+2ptHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FUs+rIrwefUaWcWIVab0lrzVThWblVUqcXepOFsm2ds=;
 b=EmPsdXl7hd/X2cNzP9KCLOJiwCD5szG7ifGIlr6hukzdWTPKGAGcNV4kfZudsNYGdRjt3cpYAZ9JWBFrDgebZXCsw23YCeQb63Kr7lpc/+kFM4gOWQk17o6BmW7lo8KsySvh4HLlINAOUyopVMg8KBUxmxSFFm9N16uRiETlCISRRFb1MehU9UVm1tTjiNDDFYaG1Iun8XQvk4IRpJa1mUfmH1Qyx6ojVTgaKiXjYRH8iRtN0TtkhcFyipSSdIRo3amsw7BrSzhS//ZpELXyEOPT5aORP6cbT09PUdhiAm01+O4U6mXjpKg/fTrj9mXiUvDksiF/TsddHj4hu6x6Dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FUs+rIrwefUaWcWIVab0lrzVThWblVUqcXepOFsm2ds=;
 b=WPoC0bm8fo446q3RpXWUpcs5z2ITi2f7/wCrxJb5YfrwK1ZtT8W/el9L92vpVqQo6zXkCA1H6fpOzxCVgHHreHjJKyOoowOlWV43ohcOMzklM9YTXIE0qZ1xP12uwRnmG4BtyI3FuGFh2J4CpKstY2NrF1BFcRFwGBx1G4fkT78=
Received: from CO1PR11MB4771.namprd11.prod.outlook.com (2603:10b6:303:9f::9)
 by BN7PR11MB2548.namprd11.prod.outlook.com (2603:10b6:406:b3::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Mon, 7 Mar
 2022 05:02:24 +0000
Received: from CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::7861:c716:b171:360]) by CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::7861:c716:b171:360%3]) with mapi id 15.20.5038.026; Mon, 7 Mar 2022
 05:02:24 +0000
From:   <Divya.Koppera@microchip.com>
To:     <richardcochran@gmail.com>, <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>, <hkallweit1@gmail.com>,
        <linux@armlinux.org.uk>, <davem@davemloft.net>, <kuba@kernel.org>,
        <robh+dt@kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <UNGLinuxDriver@microchip.com>,
        <Madhuri.Sripada@microchip.com>, <Manohar.Puri@microchip.com>
Subject: RE: [PATCH net-next 2/3] dt-bindings: net: micrel: Configure latency
 values and timestamping check for LAN8814 phy
Thread-Topic: [PATCH net-next 2/3] dt-bindings: net: micrel: Configure latency
 values and timestamping check for LAN8814 phy
Thread-Index: AQHYL6tdGiDfF8muKUy6jpI4YK/Ta6yvLZmAgAASIQCABCG/oA==
Date:   Mon, 7 Mar 2022 05:02:24 +0000
Message-ID: <CO1PR11MB4771605C6963865B2B5CE898E2089@CO1PR11MB4771.namprd11.prod.outlook.com>
References: <20220304093418.31645-1-Divya.Koppera@microchip.com>
 <20220304093418.31645-3-Divya.Koppera@microchip.com>
 <YiILJ3tXs9Sba42B@lunn.ch> <20220304135540.GD16032@hoboy.vegasvil.org>
In-Reply-To: <20220304135540.GD16032@hoboy.vegasvil.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 131f97bd-d51b-4f01-3af4-08d9fff7ab35
x-ms-traffictypediagnostic: BN7PR11MB2548:EE_
x-microsoft-antispam-prvs: <BN7PR11MB254822A958F757543A04EB92E2089@BN7PR11MB2548.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZEcsT/KP49w0plmovAB0piWcZ8Wx7s33AR7NlKwJCUpUYltmUvHthZFVB1Yk2vy8+ElXZdVGXAjuyIfqVgkkiQaKq+F2OY5CEGRonNoqkNICYeS+MCzF0l2mIBbw2nQkAhb5NQDsb5GEoDyuTZoUrWcueMgG7FsowRqVI/0nJIPy57kD9EkQ6DlMOXffFmPEpqXijNx6d/M0r7nTJ1Po33kFkQpPUd4bMARE85I5UAo1N9kUUswVefS1PTOcU3wIOClkQJyou6NFFRB+Eax90zURzN3hTFtGdE9KlmcAQk9XO9t6yRmM8RSZYePErsKVWhGyeLnn+bDENCD9CTtYVZQP6AmeYpbSPJpgSfVp10ETVBoZeRfkkTqHuG+66E90aEXjKdmDcPXcXBI10KIIozbYCXanRi1tjpqXseczA4ow0pag0tcdC0li3JiJ7Hkt/cppGmZFMmp/U9rE39DxtDc5KXGttbhWRUGQOXGlwvNVXyBIoz4XVT/jdmliemxCSB0ql5SyZO0bb7TNZkxuy0QmDdqp52Kk650crHHw6t0I5Crr++E9Ipf2epPPWC9onKPCGo4nkkxigXkjihMu8l+TGHb565Jx8p+md+n4b1WcTgx4I/JAcgCdA0xPW8yEgGT2XoraLJaWim74li/pce35FaAlY76rKj7csspq8AcjtyISRSkVodyh7juukMFF33PZEGIdWS8dGPvUkPVksw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4771.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(86362001)(508600001)(38100700002)(52536014)(110136005)(71200400001)(54906003)(55016003)(107886003)(122000001)(38070700005)(7696005)(6506007)(76116006)(66556008)(66946007)(4326008)(316002)(66476007)(66446008)(8676002)(64756008)(9686003)(26005)(33656002)(186003)(83380400001)(53546011)(8936002)(7416002)(5660300002)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WmxDSnJQekIzT2pLbzZObE9sTHlPOWxYaFV0ckJYak5iUGhVdWk2Sm1kM09C?=
 =?utf-8?B?WVQ4dzgyU2tybk5iTTd4OWIzNmJVaE11N0FIUmRjUEM3amIyeTBQSzBScHVY?=
 =?utf-8?B?UVBEalowSVRoRHJ1b2Y4TS93ajJuSUllelRMQmRCZG11anZBMlV3eXEwMGRz?=
 =?utf-8?B?anF4cDQ4UFRsclVoTVFleENUdEs0elhNVFgxdlV5MCt3cVVBemJaUlhxN3J5?=
 =?utf-8?B?WThONVZRd0hVZ3IwdkpmVTFWWGVKSDI0QnBGYk9LcDFsbGdFMXF2dU81REZG?=
 =?utf-8?B?WC85emM0ZE9GVTB6YlZWd3VYV29CMTFTQzJ5Wm5rRXc0YjlHc0RxbWlUVS8x?=
 =?utf-8?B?UUlMTDdlVDZnYjFCQkZ0bURwMHRreGNuTlFla1VwRU95dmw2WVZQN3RyTkpI?=
 =?utf-8?B?aGpoeHZoOXNpUFA1YlVpa1hoOG5rbkxQUVdsaTQyYSsrT0dMcmhJcVM3Z1RR?=
 =?utf-8?B?cW1KbitmOUtCL1dOK2s3SWZRN2dHSFd6ZUNhTzlpUFdxRk9STlRCaEcxOXhu?=
 =?utf-8?B?cFFld0RjTTFsS1VsMDdpQUR1aGs0OERuSHZUUzdzZmF1UVJVNWpNY2kvWWpW?=
 =?utf-8?B?RXNucE1SSlF6cVNxNEIyUVFIcTVidE9WZWFrTkJna0FKL21JYjJiRG00RzFQ?=
 =?utf-8?B?K3FZYlZkUk1wOGNEMjNSdy9MK213UE9xRWwxRmNqOExaVGZrTHJ1eFY1T0s5?=
 =?utf-8?B?TkFkWEFoN3lTV0djU3U0VFJadVN4TFZvRFhNc3JkVm96L1E5dzlCcjhUWjFv?=
 =?utf-8?B?cEFzOUJDYSsrTldzWUVQdVg3L1Y2N2NZc2src2FicWJsYW9VVm1kQ3VCanA5?=
 =?utf-8?B?TnVjdFB3Z0Q0amYxay91R05CNzh1d1RGT0NzNXJqMXhnUEgyYVJiMFFFeFdw?=
 =?utf-8?B?UmcvSHBBdVRaeHpVQXl3NzRYR0NxQUZuRDlFRXFlL0cyUXh6NG1HZ0NpRVR6?=
 =?utf-8?B?UVdnQkhZZ0QzZGRLTm9Kc0U0WjYxNXEydXA0SnUvT25FU1FQeUg4RFpGTTBo?=
 =?utf-8?B?WVVKbDhtUzYxNHdmZmtYM09xanhEdlRaYkg3Znpsc0hrSkxVRDVmQ0UyamQv?=
 =?utf-8?B?blVtdHFaay9oODdxdTRTT0NHL2UwWFhkWjNFV294My9yYThwZGFrSm1PNWlz?=
 =?utf-8?B?U05vby8wSG40NlZGS1AzeTVreW1QbGUwbmhLUFY2Qzl2aWs5RkJodDNxWUJl?=
 =?utf-8?B?Q3F6WEEwMXhhZ0p3TS9BeEd1TmUwaDRBWGpqZ0JVL3RQRGszL1hSWmwwOFZH?=
 =?utf-8?B?RytoWjh2WWM2dlNGd2x3cFB6Z043YklqdnFvYzQ2cE43cjloZDdWdkxQTm1p?=
 =?utf-8?B?TldKSExpbVBuZ2wySnhpczIvZFRlb2ZNVy91OWgvM05sNGRZSUZhWTFBVE42?=
 =?utf-8?B?aVpRMXdocWhDd2ZMWTlVYitnRmRnajloUzBvTTFmMmJwZVF1SDhhUjk2MnAy?=
 =?utf-8?B?Qi9qbzdJemRIS3JKRTYyWlVXUkNDNzJWNjMvaVRRNWpTRnFVbmVHTURsN1Vo?=
 =?utf-8?B?Y1VTY2JJZWNJSWc4TlFhcmdqalAvYmhoOU1VbmpxNVZ2UmY5Y2QwOGliRzkw?=
 =?utf-8?B?Mi9TNk4vS2g2c3ZpZHBMamoxWGxwbzUzeTlMdnVsbFZaKzNBdjlIdVhNek84?=
 =?utf-8?B?V3BmMFRhSzhwME4vWWZUT2VCRUdTejU5ZzlPenZtaWIwenhHRWZQcTVqTzlh?=
 =?utf-8?B?NSthVEprb2ZucUdrOFc1UXc1Z2lJb2dkc2h0THNvWWVkckovRWVFRFFua2pq?=
 =?utf-8?B?UlU4VnpydnlUbnMvSnpNK2ZuYXJyd29SZVJZTS9Ed2xKcDF2cmtRdkVCc3gr?=
 =?utf-8?B?NjlHMHplZnBHc2dHRWVUMkU1R0lISzhmeGdESzJUUlVmbWd6OXRqUE5vSWVu?=
 =?utf-8?B?TFpVUTVUUTVMenFlVkZ5Y3pRS1VoaWRheS9JV1VUbFpvQnhoTzdqQmJRYXlB?=
 =?utf-8?B?MVRLSmQrSGhjZ2tIa0E5TkwwdkR5TXlpNWJYRW40T1ZMOEFHT3lhbjc2RFR3?=
 =?utf-8?B?blBEZ0pqWitMT1R6bEhia3JlUlREQ3o3bTg2OEk5ZmphWWdOVHo4bUsyMmsx?=
 =?utf-8?B?S2lCRjdCSGkvWlhDWUp2RDZWQUFWOUhyOWNGQWNPbW9SOHFVV0JzL1YwNENj?=
 =?utf-8?B?cWszVFNOSGtJcnFsY2NzSFg1VW9kemxoeTd3RW5NVk9lbHh2djExRDNvQ0dG?=
 =?utf-8?B?SlRlcXZkRmlESUZwM2VmYkVxaVVuRWFrcmtna3gxU05MTER1OENDV2x0YXdp?=
 =?utf-8?B?cmdxK1g5SjBZbEoyeGRHRStESDV3PT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4771.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 131f97bd-d51b-4f01-3af4-08d9fff7ab35
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Mar 2022 05:02:24.2783
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7Xo3iLDYW2hXdOf1Nn072PLUwyXY5pDsAvXIklp5O5C6i9ynos5QXjVoBv0sth5BDVRxQZOhBtV0TCrXLYHFajqY7g1Gs+Cz7VFlHEHX5Kc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR11MB2548
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgUmljaGFyZCwNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBSaWNo
YXJkIENvY2hyYW4gPHJpY2hhcmRjb2NocmFuQGdtYWlsLmNvbT4NCj4gU2VudDogRnJpZGF5LCBN
YXJjaCA0LCAyMDIyIDc6MjYgUE0NCj4gVG86IEFuZHJldyBMdW5uIDxhbmRyZXdAbHVubi5jaD4N
Cj4gQ2M6IERpdnlhIEtvcHBlcmEgLSBJMzA0ODEgPERpdnlhLktvcHBlcmFAbWljcm9jaGlwLmNv
bT47DQo+IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGhrYWxsd2VpdDFAZ21haWwuY29tOyBsaW51
eEBhcm1saW51eC5vcmcudWs7DQo+IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IGt1YmFAa2VybmVsLm9y
Zzsgcm9iaCtkdEBrZXJuZWwub3JnOw0KPiBkZXZpY2V0cmVlQHZnZXIua2VybmVsLm9yZzsgbGlu
dXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsgVU5HTGludXhEcml2ZXINCj4gPFVOR0xpbnV4RHJp
dmVyQG1pY3JvY2hpcC5jb20+OyBNYWRodXJpIFNyaXBhZGEgLSBJMzQ4NzgNCj4gPE1hZGh1cmku
U3JpcGFkYUBtaWNyb2NoaXAuY29tPjsgTWFub2hhciBQdXJpIC0gSTMwNDg4DQo+IDxNYW5vaGFy
LlB1cmlAbWljcm9jaGlwLmNvbT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCBuZXQtbmV4dCAyLzNd
IGR0LWJpbmRpbmdzOiBuZXQ6IG1pY3JlbDogQ29uZmlndXJlIGxhdGVuY3kNCj4gdmFsdWVzIGFu
ZCB0aW1lc3RhbXBpbmcgY2hlY2sgZm9yIExBTjg4MTQgcGh5DQo+IA0KPiBFWFRFUk5BTCBFTUFJ
TDogRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNobWVudHMgdW5sZXNzIHlvdSBrbm93
IHRoZQ0KPiBjb250ZW50IGlzIHNhZmUNCj4gDQo+IE9uIEZyaSwgTWFyIDA0LCAyMDIyIGF0IDAx
OjUwOjQ3UE0gKzAxMDAsIEFuZHJldyBMdW5uIHdyb3RlOg0KPiA+IFdoeSBkb2VzIHRoaXMgbmVl
ZCB0byBiZSBjb25maWd1cmVkLCByYXRoZXIgdGhhbiBoYXJkIGNvZGVkPyBXaHkgd291bGQNCj4g
PiB0aGUgbGF0ZW5jeSBmb3IgYSBnaXZlbiBzcGVlZCBjaGFuZ2U/IEkgd291bGQgb2YgdGhvdWdo
dCB0aG91Z2ggeW91DQo+ID4gd291bGQgdGFrZSB0aGUgYXZlcmFnZSBsZW5ndGggb2YgYSBQVFAg
cGFja2V0IGFuZCBkaXZpZGUgaXMgYnkgdGhlDQo+ID4gbGluayBzcGVlZC4NCj4gDQo+IExhdGVu
Y3kgaXMgdW5yZWxhdGVkIHRvIGZyYW1lIGxlbmd0aC4NCj4gDQo+IE15IHVuZGVyc3RhbmRpbmcg
aXMgdGhhdCBpdCBpcyBWRVJZIHRyaWNreSB0byBtZWFzdXJlIFBIWSBsYXRlbmN5Lg0KPiBTdHVk
aWVzIGhhdmUgc2hvd24gdGhhdCBzb21lIFBIWXMgdmFyeSBieSBsaW5rIHNwZWVkLCBhbmQgc29t
ZSB2YXJ5DQo+IHJhbmRvbWx5LCBmcmFtZSBieSBmcmFtZS4NCj4gDQo+IFNvIEkgY2FuIHVuZGVy
c3RhbmQgd2FudGluZyB0byBjb25maWd1cmUgaXQuICBIb3dldmVyLCBEVFMgaXMgcHJvYmFibHkg
dGhlDQo+IHdyb25nIHBsYWNlLiAgVGhlIGxpbnV4cHRwIHVzZXIgc3BhY2Ugc3RhY2sgaGFzIGNv
bmZpZ3VyYXRpb24gdmFyaWFibGVzIGZvciB0aGlzDQo+IHB1cnBvc2U6DQo+IA0KPiAgICAgICAg
ZWdyZXNzTGF0ZW5jeQ0KPiAgICAgICAgICAgICAgIFNwZWNpZmllcyAgdGhlICBkaWZmZXJlbmNl
ICBpbiAgbmFub3NlY29uZHMgIGJldHdlZW4gIHRoZSBhY3R1YWwNCj4gICAgICAgICAgICAgICB0
cmFuc21pc3Npb24gdGltZSBhdCB0aGUgcmVmZXJlbmNlIHBsYW5lIGFuZCB0aGUgcmVwb3J0ZWQg
dHJhbnPigJANCj4gICAgICAgICAgICAgICBtaXQgIHRpbWUgIHN0YW1wLiBUaGlzIHZhbHVlIHdp
bGwgYmUgYWRkZWQgdG8gZWdyZXNzIHRpbWUgc3RhbXBzDQo+ICAgICAgICAgICAgICAgb2J0YWlu
ZWQgZnJvbSB0aGUgaGFyZHdhcmUuICBUaGUgZGVmYXVsdCBpcyAwLg0KPiANCj4gICAgICAgIGlu
Z3Jlc3NMYXRlbmN5DQo+ICAgICAgICAgICAgICAgU3BlY2lmaWVzIHRoZSBkaWZmZXJlbmNlIGlu
IG5hbm9zZWNvbmRzIGJldHdlZW4gdGhlIHJlcG9ydGVkIHJl4oCQDQo+ICAgICAgICAgICAgICAg
Y2VpdmUgIHRpbWUgIHN0YW1wICBhbmQgIHRoZSAgYWN0dWFsIHJlY2VwdGlvbiB0aW1lIGF0IHJl
ZmVyZW5jZQ0KPiAgICAgICAgICAgICAgIHBsYW5lLiBUaGlzIHZhbHVlIHdpbGwgYmUgc3VidHJh
Y3RlZCBmcm9tICBpbmdyZXNzICB0aW1lICBzdGFtcHMNCj4gICAgICAgICAgICAgICBvYnRhaW5l
ZCBmcm9tIHRoZSBoYXJkd2FyZS4gIFRoZSBkZWZhdWx0IGlzIDAuDQo+IA0KDQpJIHdpbGwgY2hl
Y2sgdGhpcyBhbmQgY29tZSBiYWNrIHdpdGggZml4IGlmIGl0IGlzIGFwcGxpY2FibGUuDQoNClRo
YW5rcywNCkRpdnlhDQoNCj4gVGhhbmtzLA0KPiBSaWNoYXJkDQo=
