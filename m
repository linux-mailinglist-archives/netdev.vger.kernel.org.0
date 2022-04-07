Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BEA04F819D
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 16:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232310AbiDGOcJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 10:32:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230503AbiDGOcH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 10:32:07 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B938719234A
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 07:30:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1649341803; x=1680877803;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Uwil0fpw8PsamtEm7r7EI0PmdgDUox9M7JqnohErTP0=;
  b=KeWFhn/SlLPiF0FQmhsziI3Up6NY/WHgnNDr0JU9G9fV0YSmxKw/1NdC
   rRfD9LAFcMY8ZiiGHjmPl0Lzg1uCEEyWun0OKm27HPUTmsVPzjQN/HOlT
   BfoXF9nZfUrBQShdkPaOW5ZGZQouiIVYYQdVMlXFpAe49yT1xFQGTF71L
   xRsNyuhoyOw2l828RDMfbOQhTwHXWlOwJLEV6DzYebizqP2or/GQnEwjJ
   DwrDi4Vr7inyQA7aLardFcO9OKlYU3tfTHz0uc2uCyA3O7b/KPwuLaZQK
   I+ooDg3yEC1jeSrpMLZJxiuwULRM6ZKrtMnXtfVOhYxbGmOGy+HyfQIkk
   w==;
X-IronPort-AV: E=Sophos;i="5.90,242,1643698800"; 
   d="scan'208";a="168808109"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Apr 2022 07:30:02 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 7 Apr 2022 07:30:02 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17 via Frontend Transport; Thu, 7 Apr 2022 07:30:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ao/+Cnb9vL+s1CTPZkngFOF7OXHbHwJEgzB92zUA5h61vVWy10HPg3BRb7iCcR40AQGfOpk+CG5w2ituGbqDEX/GGZSZHrBv6ON/JNtAHgqBnlcS2WEz+VwvRUHl4+iJmGOQX3MoPJc4tjArSDYbSTo9xMA3UirSI44BuP2R+A0My6YWzqgPX0FXpw3Mv8aCGrR1bYy2dI60uP07jnTmpH95NN9aYk1bOgc+Yj5nfhTcimz52w7vOc43KpFWL/RLDgsqNwnEYFDuiqXrIB884AYkHr0ajqOO69tF2QPBicBKgl+XjZPnIVMqbptGt5ZWdQdJZK5LwpNyNszq3WVgyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Uwil0fpw8PsamtEm7r7EI0PmdgDUox9M7JqnohErTP0=;
 b=QCaMaAgMC6++N/s3YjMWxuObyfIiFvw48Kl0RY/m9EB6D5Yql0GAyj4SEEh6KByKNiNRcuHsLwItjML2LfNf/AbT1ZrWvlwIZhwQCNvFFJTw9f1rgdBbGWWFhzUaXwND+epKbxxb2EtKBecUA/EgmbHIBdfAhbSFkL7b9gM88Jz/ZjCcXk2m6omCCGixbEIRV4do664nUbOkt6fg6u6N5oVWw3sBntcAnXch+sy+z1wPteBu4dpx4dnlBCpri4I76IT2F0NCIvIaeo4G3uGg6LMZFFrUuxHBJQGji7xzqgHbJsAuNSx4e3Lssa+3fjGrH5FBCwYL/I/wH4s5aDN/pQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Uwil0fpw8PsamtEm7r7EI0PmdgDUox9M7JqnohErTP0=;
 b=LhcRv4eUOZl71/+lCwY+32zz/NMLdBtGbdgTWKH/RAkHFoDOP+lTtgqj2vM3NVYvMS+oNnnKANSkEIUmCCgwYVcWX+LCv+Q8Wrcu1b61NB0cWko5mBXJ3ccyomQiTqawYJtybn4HlB79xTgxTUlK8vlzogj1J63dZ8girLnShGs=
Received: from CO1PR11MB5154.namprd11.prod.outlook.com (2603:10b6:303:95::7)
 by SA2PR11MB5051.namprd11.prod.outlook.com (2603:10b6:806:11f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.22; Thu, 7 Apr
 2022 14:30:00 +0000
Received: from CO1PR11MB5154.namprd11.prod.outlook.com
 ([fe80::dc95:437b:6564:f220]) by CO1PR11MB5154.namprd11.prod.outlook.com
 ([fe80::dc95:437b:6564:f220%8]) with mapi id 15.20.5144.022; Thu, 7 Apr 2022
 14:30:00 +0000
From:   <Conor.Dooley@microchip.com>
To:     <andrew@lunn.ch>, <linux@armlinux.org.uk>, <palmer@rivosinc.com>,
        <Daire.McNamara@microchip.com>
CC:     <apatel@ventanamicro.com>, <netdev@vger.kernel.org>,
        <Nicolas.Ferre@microchip.com>, <Claudiu.Beznea@microchip.com>,
        <hkallweit1@gmail.com>, <linux-riscv@lists.infradead.org>
Subject: Re: riscv defconfig CONFIG_PM/macb/generic PHY regression in
 v5.18-rc1
Thread-Topic: riscv defconfig CONFIG_PM/macb/generic PHY regression in
 v5.18-rc1
Thread-Index: AQHYSO3IJSdXwoud5UqKTAwCCAurg6zhaxYAgAEl3QCAAfUCgA==
Date:   Thu, 7 Apr 2022 14:30:00 +0000
Message-ID: <6411f181-88a5-14a5-114b-77b401683570@microchip.com>
References: <9f4b057d-1985-5fd3-65c0-f944161c7792@microchip.com>
 <YkxaiEbHwduhS2+p@lunn.ch>
 <dd69c92d-dcb9-48e3-8ff5-078ea041769a@microchip.com>
In-Reply-To: <dd69c92d-dcb9-48e3-8ff5-078ea041769a@microchip.com>
Accept-Language: en-IE, en-US
Content-Language: en-IE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 83eab9c7-a51f-4c22-d0fc-08da18a31902
x-ms-traffictypediagnostic: SA2PR11MB5051:EE_
x-microsoft-antispam-prvs: <SA2PR11MB5051AD26C3C4351A0FB05CAA98E69@SA2PR11MB5051.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0d5tqlEjrk4k+AQwzSuYWsoV3kBu18Sn2bHe47ndT6OJcFCzyevMcnHEaGK1GnWtHL9PZ/tPeLz1slBzpIy2Qa1uMrCRFSZVvRfy+pwgD7BP4BYmUwC1BIBewSj0ZvaO4l5pQpXNMAYpw7VFopNS7d5Cv1EtR8UjGy3X+QdZHk6gDXfWipLfvg9ZBVXFcAR+MUKP+3oFDpsgM5NQqMZVy+Joh2oCDiodWDCfeWdrO8LfHdWlgDdNl9tCMcSnM2e7ImkdYenJwKlHqw9cnrAJ3StQ/iuFiZ8A9rHVhlw1gPn+svuPhE105uWz1L4ngPIj0b3N/sC9xDABxnRSv8Vmvoru/5yGCDVIzc/N4jgMxS8T8BklvHf5Zx8G3ozB8LGBP00Il62cJIuj+tjcnuwjrXFCArjBJNUpkmKwxcMzAANXLbEpCkugBsDuv+C9Whau47yH9/cjqJbmktQ8CH2eaUKEh9JFfZkTaZNW+jGeRaPmrR4G4N+2j3jMH3DnBUrFsDevUR2clPr+u4Th2YtNzaWjTZUp/ZPmmls3X2/gH85RzY8dL9jIBjc672uJxN4dq9FCk7CKsdJH5uBdp2hpmuhZJ9VvHwYUY737oMYKe2jNkdssz+km+275CaFe4go2SuFITxdETk/Q64HFdsfR601LQeM3p5NW5zuOeC+ahCwODlK0Zd2J9RgxL6CJqIdW5Wd371UTpFinYbHImb9zIWUEOlTvqR+9Q3fS0tu52SWxdgA2v6FzKGVgxLCiX9G1+DlG1XDQokUuvuwhh8YYtFIxfICI6w1+oKjcn7+YidE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5154.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(6486002)(86362001)(71200400001)(4326008)(31696002)(8676002)(91956017)(66446008)(64756008)(66946007)(53546011)(66556008)(66476007)(76116006)(122000001)(508600001)(26005)(36756003)(6512007)(2906002)(31686004)(186003)(5660300002)(316002)(6506007)(8936002)(83380400001)(6636002)(2616005)(38070700005)(110136005)(54906003)(41533002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UFhMS2s2Skl6bjBrU3o3emswMUpvMWVjNkc0NGg3UmxvVUpmSlFGMjBaKytF?=
 =?utf-8?B?QVNnYmR5ZHlsekxHeDRYcDVuc3MvWW15MHc1c1MyWlRtdGNGTjJUQ3dtREtq?=
 =?utf-8?B?Tk1QVjNrcGhsTkxWanZXYlVKQXFCWTg3b0VYcExUOUdQbnNqeHZxZ2VSUXZL?=
 =?utf-8?B?S0YyOG1SQ0ZpZVNIRy9oYmExYS9HTVBOcmYzR1l1dkxaYXJIQ29nTHFOVlR3?=
 =?utf-8?B?amgzazc3R0UrVkIydzFaQk0wY2h6MFM2QXgwV21YenlZMEFJTmVCalhGNzZi?=
 =?utf-8?B?N1B4MVcxRDIxNE9TNzEvYkw2dEpWMXdvTDYwUS9MaDVmdmpMSjMrREh3R0JK?=
 =?utf-8?B?QTdyUDJ2UkNFcTF4ME5YYUVMaUwzWXZnTDdUN3JocTdqbEdwWTB3S3A5NG11?=
 =?utf-8?B?YzlvNzFISzFnbk5sZFJUOFVBdzg1MjFiMUlxKzl3c3BFM1pIMnRnaUVJNk55?=
 =?utf-8?B?RWk4alpoZEhEOFY0bm5aRjVHYjJPL0pNaGoyVEw5YWdCZ2YwN0Z3NlM5emF4?=
 =?utf-8?B?TDlyMEFWVndKRkZSM0NjcllHWDRvQlpYRHZmdHV6OWxRRUtUTGdYbGVOQ2g4?=
 =?utf-8?B?REZkYWpkZGtrNXhVZExUbHZTcmV3aEkvNkNpN0RuWjlFNC9adlQrY3duMWVp?=
 =?utf-8?B?UEVzeENKUUhMN2hTS0ZrM1BxU2xUQXVYbUxjbkdnUFhDd0lNMUNic1d0SWp6?=
 =?utf-8?B?VUlWVFZYM2ZjemJmOUpEa2QraFd5cFJoY09oaGU4a3kxV3JTTm5xcHhzNGV4?=
 =?utf-8?B?cXVOQW1sNE5WMkZhUjlLek02MkRqZTRQSnUxWnR5bFhhK01GWlNkLzFTVnYw?=
 =?utf-8?B?Z1pHajZRK3RoVFpKOCtoT2IzK3l2Y1daU1JKWG1GajcrUVkyMW5wZ3hucWNX?=
 =?utf-8?B?V1ZrYkJuY0xVN09tZTUwajIxSzVLRE9MNkZpT1Y5b3V2czFrdE5PWkEyQzdS?=
 =?utf-8?B?S2N2ZE9vV0VIbHAvRmZ1YVM0bGVHOXdrM1Q5eTRrRlhSNGhadUorLy9QVW4x?=
 =?utf-8?B?dWNGT0dPK0gzTU9GNklvS3pYbnVFZWd6NWVabklpMXJIdG84Z0JSYWlnclJM?=
 =?utf-8?B?Q1BiRnNsem5FUFdNbjRPMzU0UmxpRFJaYW9aYThrRlp3OXhsRXR6enRLMk1i?=
 =?utf-8?B?NDR2S2lkdGZtYmVlKy9jWXVZNW1XRjNVQjFrc0RmK1l0YWozU0dzZGRPS1Zv?=
 =?utf-8?B?Tll5VUFCYkNVMXN5NXdDNjVQazdoc1ZQK0ZDcFQ4SWdBOGVPR3pWL05uQVRJ?=
 =?utf-8?B?bk5HbmYxcXQyak9RRENwcFdFSlhMb3ZLSlQ4cnFscmk4MHN1RmMwc2FSTWNo?=
 =?utf-8?B?Uk11N0pLMk50VTAwOTFiN0Rad0c0THFrakhySHFER3V5WVVGWGdnaFloMXVK?=
 =?utf-8?B?NEFFV3N4aFpCYmxIbEprbVVJZTVOUHg3Vmd2cHlSUytyZktBbzR3L0t6aU0r?=
 =?utf-8?B?QjdZTVJWeE5ucVUwQ0dVcjNPdGtzYjhtYUN4c2tDbDRKN25vcmlldjM5VnBV?=
 =?utf-8?B?bUthWjJHT2R6V1V0b0RUdXhKaFFXU0RMNmZsbTA1NHhOayttTzVwQmhDVjcx?=
 =?utf-8?B?TmhGdnN4b1Uwa0taVEJrbFo2clhjSlM0Yy9ocFQ3UTc4Q29vb0FhbE1sdTdp?=
 =?utf-8?B?MzdRRGhaRDFNK1JpY0trTUwyeFo2d3ZXcjFvQXBtaDFTQTFMZ08wNFprN0Zu?=
 =?utf-8?B?SHVMbEh5SGVIR05GbVhzemRmenRDcUZOd282UFg1WVRMcXB1L0VhaHZyQTla?=
 =?utf-8?B?cUw1NkFKZzdjMEpNaVVia25oUUQzQUJIcmpkd2FwUDJlUFI3Z1FpbE04NGZi?=
 =?utf-8?B?NWMwN0V5NXNSSmxsOTd2b25hMDhWZ081alRHM3NXZXo4TUkzeElidDFWNzd0?=
 =?utf-8?B?Ym9idFpZSW1HWTc2WWJ2UUtRbmttbEtMR2NiMWZ0d0FWL1BUWEJxaXVpWUxs?=
 =?utf-8?B?azBONi9hTWFRS0lVMHYxSU1yY21oeVg2bTdaNTVWSlRZVWF1T0k3MktWVG05?=
 =?utf-8?B?aEsxZ2dSQm1kY3haSDJ5NnN6M0RrYWN0YjhJLzBOdllsU3lmU3FQbm1mSFZJ?=
 =?utf-8?B?ZDJvSjJsdGhtS2lkSWlwNlJRaHdjUXp4cm02cUh1aFZvYXlrN25HRWpZYTFO?=
 =?utf-8?B?Qm1Sc0hzRjl3S2pyWUF3Q0tZMmZUMVFBcGxkNzdYTlI3SldjZDR3V2ZaYnZy?=
 =?utf-8?B?UDNtM2MyN0lPaWpqUW5sZG5xYnhxTGtHQzVhcjJQak5RYlQwVXkzZStSNTk0?=
 =?utf-8?B?aStnMWc1SmZkTm5lV0Q1dk5EWFZQNGdVd1NEdWFySGNUcFY0V0kzTnQ1N0Iy?=
 =?utf-8?B?alI3K2FndUVzUUxLSm8zdWt6cFF1eTJ6QU1tZGJoT2thRDFOSTJBZz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <61F5B57789A7E2469C20C37FBBE4B150@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5154.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83eab9c7-a51f-4c22-d0fc-08da18a31902
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Apr 2022 14:30:00.3447
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wB3bdIqKREkmlzGl99LhXo0elINnVzxjyeC+tx0cGv+RLHoNZwyEhEu44FA+Dyzjr+mzgYsDJERhNfREJh7qNDDm8kO2+qRvfzpGESCU8Xg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5051
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,
        T_SPF_TEMPERROR,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMDYvMDQvMjAyMiAwODozNiwgQ29ub3IgRG9vbGV5IHdyb3RlOg0KPiBPbiAwNS8wNC8yMDIy
IDE1OjA0LCBBbmRyZXcgTHVubiB3cm90ZToNCj4+IEVYVEVSTkFMIEVNQUlMOiBEbyBub3QgY2xp
Y2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91IGtub3cgdGhlIGNvbnRlbnQg
aXMgc2FmZQ0KPj4NCj4+PiBbIDIuODE4ODk0XSBtYWNiIDIwMTEyMDAwLmV0aGVybmV0IGV0aDA6
IFBIWSBbMjAxMTIwMDAuZXRoZXJuZXQtZmZmZmZmZmY6MDldIGRyaXZlciBbR2VuZXJpYyBQSFld
IChpcnE9UE9MTCkNCj4+PiBbIDIuODI4OTE1XSBtYWNiIDIwMTEyMDAwLmV0aGVybmV0IGV0aDA6
IGNvbmZpZ3VyaW5nIGZvciBwaHkvc2dtaWkgbGluayBtb2RlDQo+Pj4gWzExLjA0NTQxMV0gbWFj
YiAyMDExMjAwMC5ldGhlcm5ldCBldGgwOiBMaW5rIGlzIFVwIC0gMUdicHMvRnVsbCAtIGZsb3cg
Y29udHJvbCBvZmYNCj4+PiBbMTEuMDUzMjQ3XSBJUHY2OiBBRERSQ09ORihORVRERVZfQ0hBTkdF
KTogZXRoMDogbGluayBiZWNvbWVzIHJlYWR5DQo+Pg0KPj4gWW91IGhhdmUgYSBtdWx0aS1wYXJ0
IGxpbmsuIFlvdSBuZWVkIHRoYXQgdGhlIFBIWSByZXBvcnRzIHRoZSBsaW5lDQo+PiBzaWRlIGlz
IHVwLiBQdXQgc29tZSBwcmludGsgaW4gZ2VucGh5X3VwZGF0ZV9saW5rKCkgYW5kIGxvb2sgYXQN
Cj4+IHBoeWRldi0+bGluay4gWW91IGFsc28gbmVlZCB0aGF0IHRoZSBTR01JSSBsaW5rIGJldHdl
ZW4gdGhlIFBIWSBhbmQNCj4+IHRoZSBTb0MgaXMgdXAuIFRoYXQgaXMgYSBiaXQgaGFyZGVyIHRv
IHNlZSwgYnV0IHRyeSBhZGRpbmcgI2RlZmluZQ0KPj4gREVCVUcgYXQgdGhlIHRvcCBvZiBwaHls
aW5rLmMgYW5kIHBoeS5jIHNvIHlvdSBnZXQgYWRkaXRpb25hbCBkZWJ1Zw0KPj4gcHJpbnRzIGZv
ciB0aGUgc3RhdGUgbWFjaGluZXMuDQo+IA0KPiBUcmFja2VkIHRoZSBzdGF0ZSBvZiBwaHlkZXYt
PmxpbmsgaW4gZ2VucGh5X3VwZGF0ZV9saW5rLCBuZXZlciBzYXcgYQ0KPiB2YWx1ZSBvdGhlciB0
aGFuIDAuDQo+IA0KPiBVc2luZyB0aGUgZGVidWcgcHJpbnRzIGluIHBoeWxpbmsuYyBJIGdvdCB0
aGUgZm9sbG93aW5nOg0KPiBbICAgIDMuMjMwMzY0XSBtYWNiIDIwMTEyMDAwLmV0aGVybmV0IGV0
aDA6IFBIWSBbMjAxMTIwMDAuZXRoZXJuZXQtZmZmZmZmZmY6MDldIGRyaXZlciBbVml0ZXNzZSBW
U0M4NjYyXSAoaXJxPVBPTEwpDQo+IFsgICAgMy4yNDA2ODJdIG1hY2IgMjAxMTIwMDAuZXRoZXJu
ZXQgZXRoMDogcGh5OiBzZ21paSBzZXR0aW5nIHN1cHBvcnRlZCAwMDAwMDAwLDAwMDAwMDAwLDAw
MDA0MmZmIGFkdmVydGlzaW5nIDAwMDAwMDAsMDAwMDAwMDAsMDAwMDQyZmYNCj4gWyAgICAzLjI1
Mjc4M10gbWFjYiAyMDExMjAwMC5ldGhlcm5ldCBldGgwOiBjb25maWd1cmluZyBmb3IgcGh5L3Nn
bWlpIGxpbmsgbW9kZQ0KPiBbICAgIDMuMjU5ODkyXSBtYWNiIDIwMTEyMDAwLmV0aGVybmV0IGV0
aDA6IG1ham9yIGNvbmZpZyBzZ21paQ0KPiBbICAgIDMuMjY1NTI2XSBtYWNiIDIwMTEyMDAwLmV0
aGVybmV0IGV0aDA6IHBoeWxpbmtfbWFjX2NvbmZpZzogbW9kZT1waHkvc2dtaWkvVW5rbm93bi9V
bmtub3duIGFkdj0wMDAwMDAwLDAwMDAwMDAwLDAwMDAwMDAwIHBhdXNlPTAwIGxpbms9MCBhbj0w
DQo+IFsgICAgMy4yNzkyNDldIG1hY2IgMjAxMTIwMDAuZXRoZXJuZXQgZXRoMDogcGh5IGxpbmsg
ZG93biBzZ21paS9Vbmtub3duL1Vua25vd24vb2ZmDQo+IA0KPiBJIGNvdWxkbid0IHNlZSBhbnkg
cHJpbnRzIG91dCBvZiBwaHkuYw0KDQpJIHRoaW5rIEkgaGF2ZSBmb3VuZCB0aGUgcHJvYmxlbS4g
V2hpbGUgdGhlIFNNR0lJIGNsb2NrIGlzIG5vdCBpbg0KTGludXgncyByZW1pdCwgdGhlIG1hYyBj
bG9ja3MgYXJlLiBXaXRob3V0IENPTkZJR19QTSBJIHNlZQ0KdGhlIGZvbGxvd2luZywgd2hlcmUg
NSByZXByZXNlbnRzIHRoZSBjbG9jayBmb3IgTUFDMToNCg0KWyAgICAwLjkwNzk1OV0gbXBmc19w
ZXJpcGhfY2xrX2VuYWJsZTogNQ0KWyAgICAxLjMxMjk1NV0gbWFjYiAyMDExMjAwMC5ldGhlcm5l
dCBldGgwOiBDYWRlbmNlIEdFTSByZXYgMHgwMTA3MDEwYyBhdCAweDIwMTEyMDAwIGlycSAxNyAo
MDA6MDQ6YTM6NGQ6NGM6ZGMpDQpbICAgIDIuNjYwMzc2XSBtYWNiIDIwMTEyMDAwLmV0aGVybmV0
IGV0aDA6IFBIWSBbMjAxMTIwMDAuZXRoZXJuZXQtZmZmZmZmZmY6MDldIGRyaXZlciBbR2VuZXJp
YyBQSFldIChpcnE9UE9MTCkNClsgICAgMi42NzA0MDBdIG1hY2IgMjAxMTIwMDAuZXRoZXJuZXQg
ZXRoMDogY29uZmlndXJpbmcgZm9yIHBoeS9zZ21paSBsaW5rIG1vZGUNClsgICAgNi43ODk0NzRd
IG1hY2IgMjAxMTIwMDAuZXRoZXJuZXQgZXRoMDogTGluayBpcyBVcCAtIDFHYnBzL0Z1bGwgLSBm
bG93IGNvbnRyb2wgb2ZmDQoNCldpdGggQ09ORklHX1BNLCB0aGUgTUFDMSBjbG9jayBnZXRzIGRp
c2FibGVkIGJldHdlZW4gbWFjIGFuZCBwaHkNCmJyaW5ndXAuIDQgaXMgdGhlIGNsb2NrIGZvciB0
aGUgb3RoZXIgTUFDOg0KDQpbICAgIDAuOTMyNTk4XSBtcGZzX3BlcmlwaF9jbGtfZW5hYmxlOiA1
DQpbICAgIDEuMzI3ODc2XSBtYWNiIDIwMTEyMDAwLmV0aGVybmV0IGV0aDA6IENhZGVuY2UgR0VN
IHJldiAweDAxMDcwMTBjIGF0IDB4MjAxMTIwMDAgaXJxIDE3ICgwMDowNDphMzo0ZDo0YzpkYykN
ClsgICAgMS40NzM2MzJdIG1wZnNfcGVyaXBoX2Nsa19kaXNhYmxlOiA1DQpbICAgIDEuNTAzMzI3
XSBtcGZzX3BlcmlwaF9jbGtfZGlzYWJsZTogNA0KWyAgICAyLjk5OTUyOF0gbXBmc19wZXJpcGhf
Y2xrX2VuYWJsZTogNQ0KWyAgICAzLjAwMDMwMF0gbWFjYiAyMDExMjAwMC5ldGhlcm5ldCBldGgw
OiB2YWxpZGF0aW9uIG9mIHNnbWlpIHdpdGggc3VwcG9ydCAwMDAwMDAwLDAwMDAwMDAwLDAwMDA2
MjgwIGFuZCBhZHZlcnRpc2VtZW50IDAwMDAwMDAsMDAwMDAwMDAsMDAwMDQyODAgZmFpbGVkOiAt
RUlOVkFMDQpbICAgIDMuMDE4NjEyXSBtYWNiIDIwMTEyMDAwLmV0aGVybmV0IGV0aDA6IENvdWxk
IG5vdCBhdHRhY2ggUEhZICgtMjIpDQpbICAgIDMuMTQzNTk0XSBtcGZzX3BlcmlwaF9jbGtfZGlz
YWJsZTogNQ0KDQpIb3dldmVyIHRoZSBjbG9jayBkcml2ZXIgaXMgYWN0dWFsbHkgbm90IG9ubHkg
ZGlzYWJsaW5nIHRoZSBjbG9jaywNCmJ1dCBhbHNvIHB1dHRpbmcgcGVyaXBoZXJhbHMgaW50byBy
ZXNldCB3aGVuIHRoZSBjbG9jayB0byB0aGVtIGlzDQpkaXNhYmxlZC4gUmVtb3ZpbmcgdGhlIHJl
c2V0IGdpdmVzOg0KDQpbICAgIDAuOTM0NzE3XSBtcGZzX3BlcmlwaF9jbGtfZW5hYmxlOiA1DQpb
ICAgIDEuMzI2NTY0XSBtYWNiIDIwMTEyMDAwLmV0aGVybmV0IGV0aDA6IENhZGVuY2UgR0VNIHJl
diAweDAxMDcwMTBjIGF0IDB4MjAxMTIwMDAgaXJxIDE3ICgwMDowNDphMzo0ZDo0YzpkYykNClsg
ICAgMS40NzMxNTVdIG1wZnNfcGVyaXBoX2Nsa19kaXNhYmxlOiA1DQpbICAgIDEuNTAyODA1XSBt
cGZzX3BlcmlwaF9jbGtfZGlzYWJsZTogNA0KWyAgICAzLjAwNjM4NF0gbXBmc19wZXJpcGhfY2xr
X2VuYWJsZTogNQ0KWyAgICAzLjAwNzY5MV0gbWFjYiAyMDExMjAwMC5ldGhlcm5ldCBldGgwOiBQ
SFkgWzIwMTEyMDAwLmV0aGVybmV0LWZmZmZmZmZmOjA5XSBkcml2ZXIgW0dlbmVyaWMgUEhZXSAo
aXJxPVBPTEwpDQpbICAgIDMuMDIxNDA5XSBtYWNiIDIwMTEyMDAwLmV0aGVybmV0IGV0aDA6IGNv
bmZpZ3VyaW5nIGZvciBwaHkvc2dtaWkgbGluayBtb2RlDQpbICAgIDcuMTE0NzEwXSBtYWNiIDIw
MTEyMDAwLmV0aGVybmV0IGV0aDA6IExpbmsgaXMgVXAgLSAxR2Jwcy9GdWxsIC0gZmxvdyBjb250
cm9sIG9mZg0KDQoNClRoYW5rcyBmb3IgeW91ciBoZWxwIGluIGZpZ3VyaW5nIHRoaXMgb3V0LCBs
b29rcyBsaWtlIHRoZSBwcm9ibGVtDQppcyBtaW5lIHRvIGZpeCA6KQ0KDQpUaGFua3MgYWdhaW4s
DQpDb25vci4NCg==
