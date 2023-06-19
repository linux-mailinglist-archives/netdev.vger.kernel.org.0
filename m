Return-Path: <netdev+bounces-12050-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B65F735D10
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 19:32:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 944BA1C208AF
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 17:32:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91D0013AF5;
	Mon, 19 Jun 2023 17:32:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D43014265
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 17:32:09 +0000 (UTC)
Received: from mx0c-0054df01.pphosted.com (mx0c-0054df01.pphosted.com [67.231.159.91])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E330B9D;
	Mon, 19 Jun 2023 10:32:07 -0700 (PDT)
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
	by mx0c-0054df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35JAffGm003001;
	Mon, 19 Jun 2023 13:31:44 -0400
Received: from can01-yqb-obe.outbound.protection.outlook.com (mail-yqbcan01lp2236.outbound.protection.outlook.com [104.47.75.236])
	by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3r97xvhj3b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 19 Jun 2023 13:31:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D9qI4BHhe+99btbtShWuXGgx5gVpRY/Hxhkfd4BUf2kAWW1xwfo41IeoCIvRzo2PEqYrNrAzn2NUZYBmTpgRJd+h0gv7b47ljLa3o+D9YQGMBlcslRFNnCoy10C8clRXawVpc009Nxp1JYO8lVSOA/B9NlJ2JTXGZmsrlQBsa63YO12pLiAbwqvnymPN1M56XULDx5XKxgIMELin+YYtxrJZ71tNc+IwQpdKT1s+F0qh1pZWG+nUUnrGg9U9LvNEPSPff+hRaKtgydX3TXOMApGGpE5DoVE2Ml3C6olvoTK4P2Ti62pd5qWydpzWhmzXYMbcL9VUzzK3a1ygA/6GZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4jQuUZzAlNDeHGPLUQKmE271IDOAs/+SPSy5G1rO6jI=;
 b=KfnizCzfyqHoIBhLix0l+aUcsYOgu3s9m9r3xSfvmlUzT3N848zYHUV0BzyJuI/9W/BefWdhDTrTuKNyWLzNADwFegk3JLk6Zyf4oGSZifKWuUh5g0pf63uoKpBkVaEBQ8lpROJ95w7XHxhPmRCZQobGcfS9prZU1sdiJ8R59Oz11TddQSSlWxDPkEyhuD60qDZgeW5N2yied1Zr42GcwrsFbZifWQiS2gZoKiG6HWkJYPoRAVaqBCvsnZXB3sEiZZabIr/nOgBBPYRUdJIbl0ZBu3IzP8zQIii5K2cef1Jln+yhiDtHqAw0CCAN9S40/LT0jEdX2Ahxk0xM9RrbgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4jQuUZzAlNDeHGPLUQKmE271IDOAs/+SPSy5G1rO6jI=;
 b=AhbNldcV34/X5K6djpDRkPbBOvSZSHGZBcfsq/56xFjwHZIEX/GI65YQRyLQOTMbeXS7G3HsSk91F8K1PHuaI7nMzSTM7yquBlHuO/lBS0eT2gF+NzE+TEwUwopT8Z/0w8l+ACC/NWUrZwAgIyPUqLyJ7ifdlveFs0hZqGuZLNw=
Received: from YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:b9::6)
 by YT2PR01MB5307.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:52::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.37; Mon, 19 Jun
 2023 17:31:41 +0000
Received: from YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::8648:f9aa:dc1d:ba56]) by YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::8648:f9aa:dc1d:ba56%6]) with mapi id 15.20.6500.036; Mon, 19 Jun 2023
 17:31:40 +0000
From: Robert Hancock <robert.hancock@calian.com>
To: "andrew@lunn.ch" <andrew@lunn.ch>,
        "olteanv@gmail.com"
	<olteanv@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "hancock@sedsystems.ca" <hancock@sedsystems.ca>,
        "woojung.huh@microchip.com"
	<woojung.huh@microchip.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "edumazet@google.com"
	<edumazet@google.com>,
        "linux@rasmusvillemoes.dk" <linux@rasmusvillemoes.dk>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>
CC: "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: dsa: microchip: ksz9477: follow errata
 sheet when applying fixups
Thread-Topic: [PATCH net-next] net: dsa: microchip: ksz9477: follow errata
 sheet when applying fixups
Thread-Index: AQHZoobH8rvO4mdk0kaJx9QDPXCcWq+SYr0A
Date: Mon, 19 Jun 2023 17:31:40 +0000
Message-ID: <b91cc419988fe21723f948524c1d7e44e3953ee2.camel@calian.com>
References: <20230619081633.589703-1-linux@rasmusvillemoes.dk>
In-Reply-To: <20230619081633.589703-1-linux@rasmusvillemoes.dk>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4-0ubuntu1 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: YT2PR01MB8838:EE_|YT2PR01MB5307:EE_
x-ms-office365-filtering-correlation-id: 586809ce-8cab-4bd9-2bcc-08db70eb0aa4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 EcQlLVnr8ce2+Yd7IMyGB8vKX8ZwHG4oEmMf+g/qgeB0iGw1lHvfUvUsLQp0W03QTGios1ZAItQlZw0KNz+oShnFeJdu0vOKaxUie0KtULLO6rDa9sDJSeJGoBPLJUc9VghazjeWhcXKDiCIG+DCAH3YhzfdUQJ9xOp1ilNDJQjybgip0L1FsWIVgcxhJEsQTNYPizbfDrQ7L20NqRkkYf0oOXYZ7eVJ0FayqW3DuJgDFGJYXrymY0ewYslmUywr2tSOk/gQWdLl/Njen7+Mmynp7bk8208J4Jig0s+mau7nMZVg1plMfzsmkxWt2TWIINZSsNHq28R4woTk8kXK5g0DmuTpXMblW0hWf5v+5oR10WjjDGc3GIAlk+36pbcqMlc8h1B2lQlISxR8oQqinQRdKpm5UHRHDciuarl42EnLldCRaPXTBrjHMpAdv+Co/YlDT1QFdPSOVGyNEFzmDqaW1/NMWtlcslFRNxe66Yqepw5bN1Z996+bdG5wtUHDFdTlB3MtVv3macU+uConY7CM3DjAzJv7gOnHYsI5CCoHbvhAvbvKHarooPs9ttbo64NYw11EdUIcMFrakUyMwQU31GYHPehUjZHH07CqgRJreyDN1gS6WYi+QLxig/Er+n3iSSI4GXIZGRfcXd7egw==
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(39860400002)(376002)(366004)(346002)(451199021)(186003)(8936002)(8676002)(66946007)(66556008)(66446008)(66476007)(64756008)(5660300002)(76116006)(110136005)(54906003)(4326008)(6486002)(316002)(38100700002)(41300700001)(478600001)(36756003)(6506007)(6512007)(71200400001)(7416002)(91956017)(921005)(122000001)(38070700005)(86362001)(2906002)(83380400001)(44832011)(2616005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?aWlqWm5URGRmL0cvNk9WbmZuMDdvSFVQSk5tZ2gvc3dEdlNoSHlVVUNQYm4y?=
 =?utf-8?B?YVpDVVZTV3lsd3RvenZqSWpLOE9WNTVEckFsc243TC9sbUJHVFpVVm9NTlZB?=
 =?utf-8?B?Z2NCMm1zMmZNSGtTdlBZQ3grTG1LdC94OXMvTFkvV3hYUmRrSVRVVWxyYzA5?=
 =?utf-8?B?cldTOVA2ZjhCaXAxQTM3TUVJS3gxSnNXWG55dXVtY1RrdmppYXRCS2k2VFNx?=
 =?utf-8?B?YTlhUDJISW1iWTR0RGZGTXFxSmxPZDhaODRUN1A1NENXOGorYUNwR2RIa3Vn?=
 =?utf-8?B?TGJwOGNPclkrY1RYRTMxVFFvaVdJZm5pWGhiVTZQYlRsWFJNOE5YWHpCZEVq?=
 =?utf-8?B?SFdmSjJhZDFmVzV5VTl1UktwNG15Nm8yM2VTS0Y3Z2o1OHFlMDk1UlN3VDlq?=
 =?utf-8?B?dnk0dDVvMjI2Ulp6RkxEbWV5OGlXQlJwU0h2dFZGMzJpSUVWUVFhZDM1VnRn?=
 =?utf-8?B?ZUdUNnlka2VrZjdONmRZSWVwU1QycWIxS1A0UFppZDdsOUNVbHQ4TWRSM2VS?=
 =?utf-8?B?R3hpc3BNT2ZuZmRRVVJqOU5VVEp4TVBKbUkrVHR2eEZsRUtzcmRJazl5eTZN?=
 =?utf-8?B?VU5rUEJyWnNhN2JKQ3hwN2RHTnJ1YWM1NERITCtGakcrNVBaLzZHMTgzUHZ1?=
 =?utf-8?B?NkNBVmhzcUNCVGJsYk5XZEk3eW82NjlrQTNURm5Eb2R0T29GWTlCek81OXhN?=
 =?utf-8?B?M3N2aUY0VEJLT1Q0WnhmblBURjNRbWN6V20vS2NGa09rREVkWHBkVVdpVUIz?=
 =?utf-8?B?MEltbE9NSFczd1RtZURoZ05CVEsyM2lPSThaekVuaTMxQnVlQWVZYVBGSm1w?=
 =?utf-8?B?b1YyS0FZamhtV2Nqdm12eUk0T21hVlIzZ1JBR0kvN25SMjVMVWlzZEtQSndp?=
 =?utf-8?B?WjdsY3R6K3pnYS9OMkRzcGlGb2NHTm5QOFFpd3hKRE1DOTZkeExqRThQVTE1?=
 =?utf-8?B?VGwwQ3NmRTg2QkkzekFCeFlOck5UdFJGYlFLdXlVMTVycXVub0d3b1YzL0o2?=
 =?utf-8?B?YVJZMTdiSWVkKzFuVTJQU3BGcURQMTlyODJsS1ZhWFo4cnNMV0tLam1MQ2xU?=
 =?utf-8?B?R3pub3dQV3RJRHR4bXR0eDVYbUlRWnozSlljZXFXbzZnNDBhQjJBQSt3bVNW?=
 =?utf-8?B?d0pSWEVUamY2VjZCWVVyTzFCK3BNYWx5NkdNa29iVndJYkgvM1VTb21ocVdL?=
 =?utf-8?B?VUg5S0VQbCtFZlRDRXB1Qmw3bFRMS2JEK0tOWVRQeXBrREM5QThvaDEveXRo?=
 =?utf-8?B?QjZWOG1tYmpxTVgrUnVBTVBDcWFjcDEwQml1UFZXa3NKNDlGMHF5ejQrbG9X?=
 =?utf-8?B?WVh3VGpnMnUzZ0luamNaSW41TC9XNFR3MHdnbHFBb0lTS294a2dGakRvYm1X?=
 =?utf-8?B?eWFIdzU0cDZMWTBSWDVpY2crR3pYOCtXOFhsZlZiZXJUdHg0QnNaVTlkcG50?=
 =?utf-8?B?UlprSUswd1ViMVpNSWRGbHo1UTZLQXllSU9hcHlPRTkrVVlHWTlWZVFkejZ5?=
 =?utf-8?B?RDNEejdDLzBsbW40TWdHY25xU05vUFRMNnlidURlekt4VC9aeVV1MXV2Rk1O?=
 =?utf-8?B?N3RKWXd6aVVneExoR0xuaGZIQ1E1L0M3eUp4aGVoWFRYSVVycHRTc2pncEdR?=
 =?utf-8?B?cSt3TEcwVGxVZk9CajNDQmRiWDhKb3ZmamRQcWhoRWgrSHZLT0hwSGJqeHo4?=
 =?utf-8?B?cmVaaGtEb3FhREdYaXFFZ3RIQnNTeTV4d2pMNWpabGZ4b2tJdm56T3cwb0Iz?=
 =?utf-8?B?T2EzdVdoS2VqODg2UzBpS3BlMDcxRTRkbGRlT0tkOUxjanI0VzFPYnF2OHRL?=
 =?utf-8?B?SW9nYVVockJXNHdGWnNxbjNzYm44VG9Fd3pld0w1LzBaZTRScGxobERMY1Rj?=
 =?utf-8?B?WlhCdUh6dlExRERyUEVNTWcrYStCZzZ2S3lMN2drQ04wSFRtbnBMcDZqdUdu?=
 =?utf-8?B?WFZxRmNjZVhHdGg3VWRXMS9UYnU2Q1pCc1VVVjlaMktETlFGTzgrMk5na0hI?=
 =?utf-8?B?OFVKQXZaOGpvQ0k3Qnp4TllUeG5JdWlTYmlyWlZGTkFLZTdnY1lBSy9FdWJE?=
 =?utf-8?B?QW1oeFNRME1RLy94aGxaMlZPc2M4NGNnbitob1Y0bzB1L0dOVjBvblovRXRm?=
 =?utf-8?B?OHJENk9HRlVtZmppUlQxbW92WUpXSHhBaGRNZ3MzckR5MVAzTUZ0SHdPZHAy?=
 =?utf-8?B?QTc0eW1WT0duQ2lhNnpiUmxKZ1plNUhaVDhVaUVabVRVanBIb1oxY2thZHg1?=
 =?utf-8?B?OENlYW93UHFmYkRVdXcwd3FjUlFnPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C89BAFE5AE8D2942BE664FE2ABD1CC19@CANPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	=?utf-8?B?V0R4WCt6THRVaFJBL1A4NFRiQVYrdTJBYVRjemhFSzNyb2tVbnF1SFhvWTFy?=
 =?utf-8?B?NEV1S3hIYW9EU3QxbTQvMFNTVituV05nMnR1UHFTWWo0RDZkdEV2Z0Y1Y2xa?=
 =?utf-8?B?YnZ2RXVLa2RrOGZpZnkxcUFGVnFlZHVJdGRTWFRKb2RzT1creFpWQ1d4QlJ5?=
 =?utf-8?B?cW4yZ2RaK2VoWjlSRGRIVThCaTNYT0dnemsyVS9BYjZzeFJiYjM0aHBRcGJS?=
 =?utf-8?B?SkFacTgrWk1JTnpNZ2tOMmxrVEtnNSswQVB4SDNic0YyR3V0UUhMVjJKa01X?=
 =?utf-8?B?ckJYaC9PQ2YvOWtyTFRmRDlHZWl4RzI2VWp3Q1lPN0xEZ1NheU1yOE5sTlcy?=
 =?utf-8?B?OUZuaWFNcXhvZUh1UmJReHJhM1k1ZHM3aDB3TEdaUWtINWpLMmQzdVlsOEdt?=
 =?utf-8?B?K2hQWXNFVlkrVjBYLzVRc2RkWko3MlZGU0JkR3AyN0JjVmxLbWFhUHV5dll5?=
 =?utf-8?B?WFErTy9kQmRvWXNHQzVHREdTV0lGSDhocE81OVAyY0Q0YWM4NXoyTW9GTy9T?=
 =?utf-8?B?dE13ZDZTUVE2SVJNckY2eXhlRjE2cnoza2Z5L0wvYlczOHJseXUzL0hwWGla?=
 =?utf-8?B?dEtDb29nakNkUEVjbUk2aFppbHdpemY2SEo0SXpHZERCbS9WTXYrekNEN1o2?=
 =?utf-8?B?QzczMllOYVpKOU4rclJobkw2NHk2RkJ0SU8vUnkzd1RVVmZoVkRRUXY5RmFJ?=
 =?utf-8?B?Mk5mcmZVY3g3MkhxYzJNbUVOVWdNRXJVeXd4UkdXTDhoa2FyTnNURnpKa2h4?=
 =?utf-8?B?ZW1PdTlOSmNvYzRxbzNyc2lIOFVQYm45blZ0NCtaZ1ZmcDNYQmU4enI2N1JY?=
 =?utf-8?B?aDhjMlFyNm1GR09LZDhpSGhJbW1sNzlTSk9YL05XZll1cUErZ0ZDczFmVHRh?=
 =?utf-8?B?SnhuUmFhSSttakk0Ym1YUzhRYkNTanpVYS9QSi9PWHk1c0VyaDBUYjVNeEx5?=
 =?utf-8?B?eWtFV2V0WEZEd0ZCZlgwaTk5UTBsOFdUTHFUcmdHZkhGTVZMM2pyUE9FKzQx?=
 =?utf-8?B?NVZFSHV4R0VZMUtHbkxxK29HSURuSFJuYk5SZjRQclF2L0dYSFY5YjhVeStO?=
 =?utf-8?B?Mk5RRGxKdUZTTlBwSEJ0OTBKWkhCaHZ5Z0ZVekJwS2xMbGF5WmxYSDdKWlUw?=
 =?utf-8?B?UTNVUVIyWlVUSWFPbGQ4bUZsZzhkdXRWMzQrZFFMSDRVZnF1ODlFZnNlRDhU?=
 =?utf-8?B?QWZwMkN4S1BjSW42L1BxTU1BK1BoUHZnS0FNak9jUTc5MkErL1V0RUNINjBx?=
 =?utf-8?B?cGR1Q1M4RWJxNXBFeTM0ZFpma280YW5JUlVpejFueUlpNEk4Y29GQXpPQXZC?=
 =?utf-8?B?aEdncjlWYk81bU1qNUNUNnVlQmJtaUpuTTBWZTlEVVRlV1JVdkZOMTBJZFJu?=
 =?utf-8?B?c0tlZHpkUEFUQWhmZTZJcXlRR1dla1gvSW1KVE0rM1dlOERwbGhLcnJtU0xu?=
 =?utf-8?B?RTNNSWRiSUdHV1hJemtRUTFNd1lFZlFLdG9ia0x3PT0=?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 586809ce-8cab-4bd9-2bcc-08db70eb0aa4
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jun 2023 17:31:40.0609
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: psfyc9/dsFYpa+M7RZ18cIofkFiiWGfxcCvj/SW0QIV6VFrB4SN8VRZ6GOJSPxBiuWYg7MroUmVVK5hj+3kEcaA3hZASXDetteBXzW7yVEs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT2PR01MB5307
X-Proofpoint-GUID: JowCwgdx1ou-hwQzIM2mTfF0L-Hwc_Li
X-Proofpoint-ORIG-GUID: JowCwgdx1ou-hwQzIM2mTfF0L-Hwc_Li
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-19_11,2023-06-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1011
 phishscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999 lowpriorityscore=0
 spamscore=0 impostorscore=0 priorityscore=1501 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2306190161
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

T24gTW9uLCAyMDIzLTA2LTE5IGF0IDEwOjE2ICswMjAwLCBSYXNtdXMgVmlsbGVtb2VzIHdyb3Rl
Og0KPiBDQVVUSU9OOiBUaGlzIGVtYWlsIG9yaWdpbmF0ZWQgZnJvbSBvdXRzaWRlIG9mIHRoZSBv
cmdhbml6YXRpb24uIERvDQo+IG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVu
bGVzcyB5b3UgcmVjb2duaXplIHRoZSBzZW5kZXINCj4gYW5kIGtub3cgdGhlIGNvbnRlbnQgaXMg
c2FmZS4NCj4gDQo+IFRoZSBlcnJhdGEgc2hlZXRzIGZvciBib3RoIGtzejk0NzcgYW5kIGtzejk1
NjcgYmVnaW4gd2l0aA0KPiANCj4gwqAgSU1QT1JUQU5UIE5PVEUNCj4gDQo+IMKgIE11bHRpcGxl
IGVycmF0YSB3b3JrYXJvdW5kcyBpbiB0aGlzIGRvY3VtZW50IGNhbGwgZm9yIGNoYW5naW5nIFBI
WQ0KPiDCoCByZWdpc3RlcnMgZm9yIGVhY2ggUEhZIHBvcnQuIFBIWSByZWdpc3RlcnMgMHgwIHRv
IDB4MUYgYXJlIGluIHRoZQ0KPiDCoCBhZGRyZXNzIHJhbmdlIDB4TjEwMCB0byAweE4xM0YsIHdo
aWxlIGluZGlyZWN0IChNTUQpIFBIWSByZWdpc3RlcnMNCj4gwqAgYXJlIGFjY2Vzc2VkIHZpYSB0
aGUgUEhZIE1NRCBTZXR1cCBSZWdpc3RlciBhbmQgdGhlIFBIWSBNTUQgRGF0YQ0KPiDCoCBSZWdp
c3Rlci4NCj4gDQo+IMKgIEJlZm9yZSBjb25maWd1cmluZyB0aGUgUEhZIE1NRCByZWdpc3RlcnMs
IGl0IGlzIG5lY2Vzc2FyeSB0byBzZXQNCj4gdGhlDQo+IMKgIFBIWSB0byAxMDAgTWJwcyBzcGVl
ZCB3aXRoIGF1dG8tbmVnb3RpYXRpb24gZGlzYWJsZWQgYnkgd3JpdGluZyB0bw0KPiDCoCByZWdp
c3RlciAweE4xMDAtMHhOMTAxLiBBZnRlciB3cml0aW5nIHRoZSBNTUQgcmVnaXN0ZXJzLCBhbmQg
YWZ0ZXINCj4gwqAgYWxsIGVycmF0YSB3b3JrYXJvdW5kcyB0aGF0IGludm9sdmUgUEhZIHJlZ2lz
dGVyIHNldHRpbmdzLCB3cml0ZQ0KPiDCoCByZWdpc3RlciAweE4xMDAtMHhOMTAxIGFnYWluIHRv
IGVuYWJsZSBhbmQgcmVzdGFydCBhdXRvLQ0KPiBuZWdvdGlhdGlvbi4NCj4gDQo+IFdpdGhvdXQg
dGhhdCBleHBsaWNpdCBhdXRvLW5lZyByZXN0YXJ0LCB3ZSBkbyBzb21ldGltZXMgaGF2ZSBwcm9i
bGVtcw0KPiBlc3RhYmxpc2hpbmcgbGluay4NCj4gDQo+IFJhdGhlciB0aGFuIHdyaXRpbmcgYmFj
ayB0aGUgaGFyZGNvZGVkIDB4MTM0MCB2YWx1ZSB0aGUgZXJyYXRhIHNoZWV0DQo+IHN1Z2dlc3Rz
ICh3aGljaCBsaWtlbHkganVzdCBjb3JyZXNwb25kcyB0byB0aGUgbW9zdCBjb21tb24gc3RyYXAN
Cj4gY29uZmlndXJhdGlvbiksIHJlc3RvcmUgdGhlIG9yaWdpbmFsIHZhbHVlLCBzZXR0aW5nIHRo
ZQ0KPiBQT1JUX0FVVE9fTkVHX1JFU1RBUlQgYml0IGlmIFBPUlRfQVVUT19ORUdfRU5BQkxFIGlz
IHNldC4NCj4gDQo+IEZpeGVzOiAxZmMzMzE5OTE4NWQgKCJuZXQ6IGRzYTogbWljcm9jaGlwOiBB
ZGQgUEhZIGVycmF0YQ0KPiB3b3JrYXJvdW5kcyIpDQo+IENjOiBzdGFibGVAdmdlci5rZXJuZWwu
b3JnDQo+IFNpZ25lZC1vZmYtYnk6IFJhc211cyBWaWxsZW1vZXMgPGxpbnV4QHJhc211c3ZpbGxl
bW9lcy5kaz4NCj4gLS0tDQo+IFdoaWxlIEkgZG8gYmVsaWV2ZSB0aGlzIGlzIGEgZml4LCBJIGRv
bid0IHRoaW5rIGl0J3MgcG9zdC1yYzcNCj4gbWF0ZXJpYWwsIGhlbmNlIHRhcmdldGluZyBuZXQt
bmV4dCB3aXRoIGNjIHN0YWJsZS4NCg0KSSBkb24ndCB0aGluayB0aGlzIHdpbGwgYXBwbHkgdG8g
bmV0LW5leHQgYXMgdGhlIHJlbGV2YW50IGNvZGUgaGFzIGJlZW4NCm1vdmVkIHRvIHRoZSBNaWNy
ZWwgUEhZIGRyaXZlciBhbmQgcmVtb3ZlZCBmcm9tIHRoaXMgb25lIGluIHRoZQ0KZm9sbG93aW5n
IGNvbW1pdHMsIGFuZCBlZmZlY3RpdmVseSB0aGUgc2FtZSBjaGFuZ2UgdG8gZGlzYWJsZSBhdXRv
bmVnDQpiZWZvcmUgdGhlIHJlZ2lzdGVyIHdyaXRlcyBhbmQgcmUtZW5hYmxlIGFmdGVyd2FyZHMg
d2FzIGluY29ycG9yYXRlZDoNCg0KY29tbWl0IDI2ZGQyOTc0YzViNWNhZWYzNTg3ODQ1MzBjOWU3
MjcxNWFkYzhmNWINCkF1dGhvcjogUm9iZXJ0IEhhbmNvY2sgPHJvYmVydC5oYW5jb2NrQGNhbGlh
bi5jb20+DQpEYXRlOiAgIE1vbiBKdW4gNSAwOTozOTo0MiAyMDIzIC0wNjAwDQoNCiAgICBuZXQ6
IHBoeTogbWljcmVsOiBNb3ZlIEtTWjk0NzcgZXJyYXRhIGZpeGVzIHRvIFBIWSBkcml2ZXINCg0K
Y29tbWl0IDYwNjhlNmQ3YmE1MDAxZGZiOTZiYjhiN2I5MmUyZWQyYTU4Nzc3ODYNCkF1dGhvcjog
Um9iZXJ0IEhhbmNvY2sgPHJvYmVydC5oYW5jb2NrQGNhbGlhbi5jb20+DQpEYXRlOiAgIE1vbiBK
dW4gNSAwOTozOTo0MyAyMDIzIC0wNjAwDQoNCiAgICBuZXQ6IGRzYTogbWljcm9jaGlwOiByZW1v
dmUgS1NaOTQ3NyBQSFkgZXJyYXRhIGhhbmRsaW5nDQoNCkhvd2V2ZXIsIHlvdXIgcGF0Y2ggbWF5
IGJlIHJlYXNvbmFibGUgdG8gYXBwbHkgdG8gLXJjNyBvciBzdGFibGUgYXMgYQ0KbW9yZSB0YXJn
ZXRlZCBjaGFuZ2UgZm9yIHRob3NlIHJlbGVhc2VzLg0KDQo+IA0KPiDCoGRyaXZlcnMvbmV0L2Rz
YS9taWNyb2NoaXAva3N6OTQ3Ny5jIHwgMTcgKysrKysrKysrKysrKysrKysNCj4gwqAxIGZpbGUg
Y2hhbmdlZCwgMTcgaW5zZXJ0aW9ucygrKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0
L2RzYS9taWNyb2NoaXAva3N6OTQ3Ny5jDQo+IGIvZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9r
c3o5NDc3LmMNCj4gaW5kZXggYmYxM2Q0N2MyNmNmLi45YTcxMmVhNzFlZTcgMTAwNjQ0DQo+IC0t
LSBhL2RyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAva3N6OTQ3Ny5jDQo+ICsrKyBiL2RyaXZlcnMv
bmV0L2RzYS9taWNyb2NoaXAva3N6OTQ3Ny5jDQo+IEBAIC05MDIsNiArOTAyLDE2IEBAIHN0YXRp
YyB2b2lkIGtzejk0NzdfcG9ydF9tbWRfd3JpdGUoc3RydWN0DQo+IGtzel9kZXZpY2UgKmRldiwg
aW50IHBvcnQsDQo+IA0KPiDCoHN0YXRpYyB2b2lkIGtzejk0NzdfcGh5X2VycmF0YV9zZXR1cChz
dHJ1Y3Qga3N6X2RldmljZSAqZGV2LCBpbnQNCj4gcG9ydCkNCj4gwqB7DQo+ICvCoMKgwqDCoMKg
wqAgdTE2IGNyOw0KPiArDQo+ICvCoMKgwqDCoMKgwqAgLyogRXJyYXRhIGRvY3VtZW50IHNheXMg
dGhlIFBIWSBtdXN0IGJlIGNvbmZpZ3VyZWQgdG8gMTAwTWJwcw0KPiArwqDCoMKgwqDCoMKgwqAg
KiB3aXRoIGF1dG8tbmVnIGRpc2FibGVkIGJlZm9yZSBjb25maWd1cmluZyB0aGUgUEhZIE1NRA0K
PiArwqDCoMKgwqDCoMKgwqAgKiByZWdpc3RlcnMuDQo+ICvCoMKgwqDCoMKgwqDCoCAqLw0KPiAr
wqDCoMKgwqDCoMKgIGtzel9wcmVhZDE2KGRldiwgcG9ydCwgUkVHX1BPUlRfUEhZX0NUUkwsICZj
cik7DQo+ICvCoMKgwqDCoMKgwqAga3N6X3B3cml0ZTE2KGRldiwgcG9ydCwgUkVHX1BPUlRfUEhZ
X0NUUkwsDQo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBQT1JUX1NQ
RUVEXzEwME1CSVQgfCBQT1JUX0ZVTExfRFVQTEVYKTsNCj4gKw0KPiDCoMKgwqDCoMKgwqDCoCAv
KiBBcHBseSBQSFkgc2V0dGluZ3MgdG8gYWRkcmVzcyBlcnJhdGEgbGlzdGVkIGluDQo+IMKgwqDC
oMKgwqDCoMKgwqAgKiBLU1o5NDc3LCBLU1o5ODk3LCBLU1o5ODk2LCBLU1o5NTY3LCBLU1o4NTY1
DQo+IMKgwqDCoMKgwqDCoMKgwqAgKiBTaWxpY29uIEVycmF0YSBhbmQgRGF0YSBTaGVldCBDbGFy
aWZpY2F0aW9uIGRvY3VtZW50czoNCj4gQEAgLTk0Myw2ICs5NTMsMTMgQEAgc3RhdGljIHZvaWQg
a3N6OTQ3N19waHlfZXJyYXRhX3NldHVwKHN0cnVjdA0KPiBrc3pfZGV2aWNlICpkZXYsIGludCBw
b3J0KQ0KPiDCoMKgwqDCoMKgwqDCoCBrc3o5NDc3X3BvcnRfbW1kX3dyaXRlKGRldiwgcG9ydCwg
MHgxYywgMHgxZCwgMHhlN2ZmKTsNCj4gwqDCoMKgwqDCoMKgwqAga3N6OTQ3N19wb3J0X21tZF93
cml0ZShkZXYsIHBvcnQsIDB4MWMsIDB4MWUsIDB4ZWZmZik7DQo+IMKgwqDCoMKgwqDCoMKgIGtz
ejk0NzdfcG9ydF9tbWRfd3JpdGUoZGV2LCBwb3J0LCAweDFjLCAweDIwLCAweGVlZWUpOw0KPiAr
DQo+ICvCoMKgwqDCoMKgwqAgLyogUmVzdG9yZSBQSFkgQ1RSTCByZWdpc3RlciwgcmVzdGFydCBh
dXRvLW5lZ290aWF0aW9uIGlmDQo+ICvCoMKgwqDCoMKgwqDCoCAqIGVuYWJsZWQgaW4gdGhlIG9y
aWdpbmFsIHZhbHVlLg0KPiArwqDCoMKgwqDCoMKgwqAgKi8NCj4gK8KgwqDCoMKgwqDCoCBpZiAo
Y3IgJiBQT1JUX0FVVE9fTkVHX0VOQUJMRSkNCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAgY3IgfD0gUE9SVF9BVVRPX05FR19SRVNUQVJUOw0KPiArwqDCoMKgwqDCoMKgIGtzel9wd3Jp
dGUxNihkZXYsIHBvcnQsIFJFR19QT1JUX1BIWV9DVFJMLCBjcik7DQo+IMKgfQ0KPiANCj4gwqB2
b2lkIGtzejk0NzdfZ2V0X2NhcHMoc3RydWN0IGtzel9kZXZpY2UgKmRldiwgaW50IHBvcnQsDQo+
IC0tDQo+IDIuMzcuMg0KPiANCg0KLS0gDQpSb2JlcnQgSGFuY29jayA8cm9iZXJ0LmhhbmNvY2tA
Y2FsaWFuLmNvbT4NCg==

