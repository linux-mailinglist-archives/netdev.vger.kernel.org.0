Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6732B4D517B
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 20:43:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242216AbiCJTEh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 14:04:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232058AbiCJTEg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 14:04:36 -0500
X-Greylist: delayed 64 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 10 Mar 2022 11:03:31 PST
Received: from mail-edgeF24.fraunhofer.de (mail-edgef24.fraunhofer.de [192.102.164.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0771D13C9CA;
        Thu, 10 Mar 2022 11:03:30 -0800 (PST)
IronPort-SDR: 4kFHJH3xnGHZG2uBK93TygKZKswVyrTQEVVzUtFrOSi8MtTWBZbkbJtm1Np8SmfD6jLk1nKzWK
 nf978tb3tSGQ==
X-IPAS-Result: =?us-ascii?q?A2E7AABqSipi/x0BYJlaHAEBAQEBAQcBARIBAQQEAQFAg?=
 =?us-ascii?q?UcGAQELAYInfoFVhFWDTYpJgwIDmzGBLoElAxg8CwEBAQEBAQEBAQcBATUMB?=
 =?us-ascii?q?AEBAwEDhQACF4QNJjUIDgECBAEBAQEDAgMBAQEBBQEBBgEBAQEBAQUEAgKBG?=
 =?us-ascii?q?IUvOQ2DU006AQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBA?=
 =?us-ascii?q?QUCCFIuHgEBHQEBAQEDIwQNDAEBNwEPAgEGAhUDAgImAgICMBUQAgQBDQWDB?=
 =?us-ascii?q?YJlAz2TKZsSen8ygQGCCAEBBgQEfoQNGII3CQkBgQYsAYMQhCWHEgiCBUOBF?=
 =?us-ascii?q?TaCdD6ERReDA4JllnsxXRQYIDCBLpMUgnxGqReBIwsDBAOCD4E6iwqVFIVBk?=
 =?us-ascii?q?QaRa5VgdSCMc5k9AgQCBAUCDgiBYwOCEXGDOAlIGQ+OIINyM4IYiBN1AjYCB?=
 =?us-ascii?q?gEKAQEDCZFvAQE?=
IronPort-PHdr: A9a23:/SwqUheVAg8/YS50C4ubyodRlGM/vYqcDmcuAtIPh7FPd/Gl+JLvd
 Aza6O52hVDEFYPc97pfiuXQvqyhPA5I4ZuIvH0YNpAZURgDhJYamgU6C5uDDkv2ZPfhcy09G
 pFEU1lot3G2OERYAoDwfVrX93Oz8XgcABziMwpyKOnvXILf3KyK
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="5.90,171,1643670000"; 
   d="scan'208";a="36649982"
Received: from mail-mtaka29.fraunhofer.de ([153.96.1.29])
  by mail-edgeF24.fraunhofer.de with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2022 20:02:24 +0100
IronPort-SDR: Z6zv1MK0Eb4c/3k0hhIQsOrtjg1PwU4ffL7jyp1nsvvY8cSbbs3kpkEVN16VRgqvAL81lNTAj/
 VVIknvzfdD/5PI+yLGKpu+ya15RrEJYUvNwTQbdKJN/jAiyXsVGYiE9SZ6HTLeeFQ4BMLv4o1m
 sEDrKmUeg3FuaP8wods90mEjGNBAp56Pir61gVYJlEg4rLhHx9TQ5hhAgivKR/a2AVsdRr8soJ
 rzCbno8gSSP+GjShJqE9vY7D5U1IbWoUuEjmI6Vj7l869rzPwCeKQngr70JTHomiprbE1IlPb0
 AjUwxILjLgJtSLSP/zzSdvrV
X-IPAS-Result: =?us-ascii?q?A0AQAAA1SipimH+zYZlaHAEBAQEBAQcBARIBAQQEAQFAC?=
 =?us-ascii?q?YE+BgEBCwGBUVZ+WSZWhFSDSgOFOYUQXQGCJAM4AZp4gS6BJQNUCwEDAQEBA?=
 =?us-ascii?q?QEHAQE1DAQBAYUHAheECgImNQgOAQIEAQEBAQMCAwEBAQEFAQEFAQEBAgEBB?=
 =?us-ascii?q?QQUAQEBAQEBAQEdBwYMBQ4QQWRogU+BYRMLNA2GQgEBAQEDEhEEDQwBARQjA?=
 =?us-ascii?q?Q8CAQYCFQMCAiYCAgIwBw4QAgQBDQUigmIBgmUDLQEBDpMojzYBgToCgQ6JE?=
 =?us-ascii?q?Xp/MoEBgggBAQYEBIULGII3CQkBgQYsAYMQhCWHEgiCBUOBFTaCdD6ERReDA?=
 =?us-ascii?q?4JllnsxXRQYIDCBLpMUgnxGqReBIwsDBAOCD4E6iwqVFIVBkQaRa5VgdSCMc?=
 =?us-ascii?q?5k9AgQCBAUCDgEBBoFjAzWBW3GDOAlFAQIBAg0BAgIDAQIBAgkBAQKOHRmDW?=
 =?us-ascii?q?TOCGIgTQzICNgIGAQoBAQMJkW8BAQ?=
IronPort-PHdr: A9a23:O2J4ohzxUvApjyrXCzPRngc9DxPP8534PQ8Qv5wgjb8GMqGu5I/rM
 0GX4/JxxETIUoPW57Mh6aLWvqnsVHZG7cOHt3YPI5BJXgUO3MMRmQFoCcWZCEr9efjtaSFyH
 MlLWFJ/uX+hNk0AFsfiIVPIq2C07TkcFw+5OQcmTtk=
IronPort-Data: A9a23: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
IronPort-HdrOrdr: A9a23:X+7/lKyamIh2ckSnvbatKrPwJb1zdoMgy1knxilNoHtuA66lfq
 GV7ZcmPHrP4gr5N0tMpTntAsa9qBDnlaKdg7NxAV7KZmCP01dAR7sN0WKN+VHd86qVzJ856U
 /nGZIObOHNMQ==
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="5.90,171,1643670000"; 
   d="scan'208";a="13940745"
Received: from 153-97-179-127.vm.c.fraunhofer.de (HELO smtp.exch.fraunhofer.de) ([153.97.179.127])
  by mail-mtaKA29.fraunhofer.de with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2022 20:02:22 +0100
Received: from XCH-HYBRID-04.ads.fraunhofer.de (10.225.9.46) by
 XCH-HYBRID-04.ads.fraunhofer.de (10.225.9.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.15; Thu, 10 Mar 2022 20:02:21 +0100
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (104.47.12.57) by
 XCH-HYBRID-04.ads.fraunhofer.de (10.225.9.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.15
 via Frontend Transport; Thu, 10 Mar 2022 20:02:21 +0100
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dp+XuEdrV3P+/fMJba3K3YhlyCItRSGwx2sZyrYvB9s9tWBw3WbuS5GXGjHceTZsUYLGigGknzH4of+qbfbZtwl4/tGtFSbN0lj8r56g9d24tzhN1EjXHro5yWizLo7L3hWsZik+xohBYgi8VrYj0KPsRW5Mtifwy+nGiTJSAMLnu0hSAvjRRTHPngzmxp1+a2pGLTfqZDcct6Cs+GsSAdNAzl2ZcKOK5qkhgGBYAYGjmLtF3sNvtioZ3UQSAv71h1pNNS38zHFZEQWzAu/DJuJg0Delj+Yf2OpN92DZOsJCJ6NIbGlXYvsauW2EMP6msYWqCbwKcA3vTKpBP+/3ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T0+0o8yuEAqBVCYugdtFF0lvmi3VZZ84AoyBLkTvGS0=;
 b=kGSJVjOYPVWDvnwhHfBk56YDmrknj66ac5DH3QKzickOOBmmI3CxMsX9SAaWWnawq4CU52gsmRbq85kAd113oizz8A6T83NqNP/UoVbLs3ikiANkmNtmdweNANTyve6II6rg6AeaOkC825E/ZFx5IEKakc5KhX7Sb+e8MMPx0t1i/KfIYuBhvjM+Gzrs4RvwXrP8Bkdd2AxNdrbJQ/7xdgb06UQYEUDdySzDTKpGCL6Mkfpg2QcnfAlMD8bLWCK8dT84Dt3Nx+x6mpnjeTxLmsad0hUxNv3zexXmtKEb9yz10SQnEYV2LnaQzF+ZEhGAYXJV6Skmoac9j6UwkBoyfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fit.fraunhofer.de; dmarc=pass action=none
 header.from=fit.fraunhofer.de; dkim=pass header.d=fit.fraunhofer.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fraunhofer.onmicrosoft.com; s=selector2-fraunhofer-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T0+0o8yuEAqBVCYugdtFF0lvmi3VZZ84AoyBLkTvGS0=;
 b=pMOwfXMyFG8M9EhcQUWyClowGZxMkcsB2plFuZ+Gv+HyN8TCn+JdQDmW4FEk4o82vqZe86gOjtNvF1XP/RRZrZEGOqT84sZKjOwh601CewSeUKlWhz4dlma4N7/LAr6h2BIhIHRWaxSVkRIcWVZKYFRA1x9//i2wCk6tQIXRrKU=
Received: from VE1P194MB0814.EURP194.PROD.OUTLOOK.COM (2603:10a6:800:16e::20)
 by DBBP194MB1002.EURP194.PROD.OUTLOOK.COM (2603:10a6:10:1eb::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Thu, 10 Mar
 2022 19:02:20 +0000
Received: from VE1P194MB0814.EURP194.PROD.OUTLOOK.COM
 ([fe80::85d0:4a1b:cb25:2b46]) by VE1P194MB0814.EURP194.PROD.OUTLOOK.COM
 ([fe80::85d0:4a1b:cb25:2b46%6]) with mapi id 15.20.5061.022; Thu, 10 Mar 2022
 19:02:20 +0000
From:   "Kretschmer, Mathias" <mathias.kretschmer@fit.fraunhofer.de>
To:     "linus.luessing@c0d3.blue" <linus.luessing@c0d3.blue>,
        "johannes.berg@intel.com" <johannes.berg@intel.com>
CC:     "sw@simonwunderlich.de" <sw@simonwunderlich.de>,
        "ll@simonwunderlich.de" <ll@simonwunderlich.de>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "repk@triplefau.lt" <repk@triplefau.lt>
Subject: Re: [PATCH net] mac80211: fix potential double free on mesh join
Thread-Topic: [PATCH net] mac80211: fix potential double free on mesh join
Thread-Index: AQHYNK2z+NiS5ZeJvEuJ/3kaAmgW+ay4+V+A
Date:   Thu, 10 Mar 2022 19:02:20 +0000
Message-ID: <4f709ac610cf937106a17bd131855dd0f02c71cf.camel@fit.fraunhofer.de>
References: <20220310183513.28589-1-linus.luessing@c0d3.blue>
In-Reply-To: <20220310183513.28589-1-linus.luessing@c0d3.blue>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.43.3-1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fit.fraunhofer.de;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8c16ab63-290d-4984-a20b-08da02c880d6
x-ms-traffictypediagnostic: DBBP194MB1002:EE_
x-microsoft-antispam-prvs: <DBBP194MB1002ACE7D81A7F43AABE11BED70B9@DBBP194MB1002.EURP194.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: du/Mdk8JnKxt3mGP4y2AEsAjnws8TFuy+pFDtWGI3doVl7pu+PCluL8xXVvjtMFbBG94VQ+UuFw6rxo+5wvZmstki75bpwK3o1Lny9D/uDKYaczfXSzSTLVr+M9l5b8bGM6sbC568uwEt+32jX8llYbiPzJOMwmipJTBbRXzUL1VGWhz72CxhqJ9jQ8lqQ2ESwT4jengYV4zG6WaItdImlLeH+8AMPyzy5NhHnFSg2PnaNFM25JqylJRO1//V0JobRlbUHocyMcuhZfCsXMVXT/lI1ImnrUWS9gWVzTv6OBjXa28lz6Ek/IqCAG3q2bFRknKfA1/O2Y1+qLRA05PyDIAlvnKkwcwWJGBUkttNk00xRZaiGoof1fqBGPMCwmNiCU9fxnl2eGq216QnDoojI2P1HdThZ6lZN6g0Z4ya2IWiQxf60eeB9G4AZyME7/LkJLwAsT5iJ6rvwTpQ7TjDPOBY9ofVL6HRZoUZGuEy46kHlwolu9sigXaXE/s3F6GX0D7pBIzQzUEKm4zMHaPcV1G3VENhQohqPV3+fzrE9ZLnpGc1d2q3CliOlxB3qIarIYcxsqQTPLZ8s7C5dkaQM5mZtEE14Bgnn7eyfVv4ZmMc+oEQFDXknclGdN8JeGrzITHLQxkmhHrZFC6PBNaQ4g25CLLi/ESut3KDBzmbI+uLbpoqggR656nTFmGmYAvm2pSqi+UBIilNENY4r1Md8kxP30x6BE4jk0DtfEmfjP8GvSepEtLhccyK3SebvDlsIXL/ifciB1exIsALNG1WImQT2FZQTeBIqYgH+bTIjM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1P194MB0814.EURP194.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(366004)(86362001)(508600001)(8676002)(38100700002)(82960400001)(38070700005)(110136005)(71200400001)(6486002)(122000001)(966005)(91956017)(4326008)(6506007)(54906003)(64756008)(66476007)(76116006)(66946007)(66556008)(66446008)(316002)(186003)(6512007)(26005)(83380400001)(8936002)(7416002)(5660300002)(2616005)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OGZwQnVCTjlERUtnaXRoNmpQTVpIMnNzNGNyV3hPUFNGZzdBa2tpZHllU2VH?=
 =?utf-8?B?ei8xbHhjUVdzQ2w1RktVdXlCcHRTR3cxSXF1dXUvS2FXVFd2cWQ4R0FpcmJD?=
 =?utf-8?B?V05yd0tPQm9rdlh2dkxVajIzczVGNmIzdUU3ZFIyL1hxdS9JdTBEYkJoWmFa?=
 =?utf-8?B?amFKOHpQSWsrOWNjRnQ2UWRsS0orNjVHRnpQdy9EWlhnYm5Td3pxZHN0QXh6?=
 =?utf-8?B?UnVJRjNpNUhUV3NPZ2JNMlhyQUd0SEd5VjFQL21nRHhBUzBic1VRUjU0UDVR?=
 =?utf-8?B?OEF0L1M4Njl5bDNZRElGWlo3QzBoT1dyeWV5ZGZnUHJQZ3FXUVpqWXJDYXly?=
 =?utf-8?B?SmxyUDdlUlQxeUNhczNsWEpuWURDOTlyQ1crRlV0MjVPN25PQWZsQ1ZGVHhH?=
 =?utf-8?B?UGcwamRsWlk3T0xVWFo3RFlRcVk3dG16N3loODRoSjdiVHQvYjA2MkxIMkVI?=
 =?utf-8?B?ZjNYYlRwMm5KRFlhcnFwTVJNWHFaekhoK3d6bWZiRTdUMW5mZ2dQaUtudUlr?=
 =?utf-8?B?TFdzb1htbk1TR2xSSW40azBwTitNRlZjVHVSVmRSbnY1ZjQxOUg4UDcvcXE1?=
 =?utf-8?B?Zzh3WUV5cElTcDlwbEdoQmh5amhjL3ZMamdhQXErbUdFUS9TZTVwQ1U4RzQx?=
 =?utf-8?B?NnBQMVBZZEFaS2xyTXJuYWNrUS82TS9qN2FrTVhRNXA5QlB5b2xlUEc2L0kv?=
 =?utf-8?B?K0sxUW9XZ1Bhd1ZoaFdnVjZuVkFRZ0ljYktrMVJPTWt6N293bEJOdlBsZnBm?=
 =?utf-8?B?MU11cVJxNitIczM5b0hTeXB5M1VtRW4xQ09TL1MzQTJsSDNaMUU5N2gvL1hG?=
 =?utf-8?B?NUtvNUZGNTA2UXg2NXVYRlRTeDZGdm5QZkNhU3RhcEQ5Yi84SUhRcmI1eUNS?=
 =?utf-8?B?REZTeXRvMFFTRVdwMDQwV3BrZE9BeDRxTTRsK1ZNZ01SaDVSU3U5RlRydmw1?=
 =?utf-8?B?TkpjT3lBeDZNZ1RDVllUZHVBSko1Y2pMbmtKSzNXTXl2ZC9WUnJZempwMWNs?=
 =?utf-8?B?OFp3aFNXSFZKSlhOS2ZORDBjL2IwV2JWbjZBYjZUd0JJL1lPUjZXYkhFNzVm?=
 =?utf-8?B?dEphL0diVGs3aVdRTkFpQms3bCtJZDQrcG0vSk8xYy9ieUgzR3VBdCtVSUg3?=
 =?utf-8?B?RnBzdnArdDNra0JnaE96Qk5pUFFNM3EwWXhNZFZkeFJzWW53UUNPSTZ5dnhy?=
 =?utf-8?B?bXhXRllLM3o1MTBwa1M4NmFtaStJL2VkbGVibDV5Y3doSEt0NXhaaTlpd2Z6?=
 =?utf-8?B?dGhVY0Nnd0VBaFRVVW9EVlhBV0pPM2Z1MmZCSGJGcG5zMGhtQ2dvT2dvMmJB?=
 =?utf-8?B?bmhUNGJ6NXJTbVpBT3V0Wi9RWHl1VnlwRWxpNHM0NEhWZHpza1N2dG5xczV1?=
 =?utf-8?B?THNtQUM3MkxBeVdjbjRPVWx2NEo2OFBRcDhHYnJKN1dRcjQ2MklZWjM3ZXhh?=
 =?utf-8?B?UCtPcUdvL2JWYmxWRHpxVjA5UTZ4ZEFQR3FYdzVZVSt6WkNScHRVTWIrcTdK?=
 =?utf-8?B?Rm1icXBUbktXZ0l4S2ZFV3EvVlZWeFpMSzRuOWQwdWhOU2lvREorY2RNV0Fa?=
 =?utf-8?B?WjJncUtFdUJqUitEZjVmdTV3TGZWOVR2THRWa1IzYjJLM3BzQTROUTRrNTZp?=
 =?utf-8?B?Wm4vTDZxTXhqMjFXbVM2Z2VNYmtidDZEZmxFakZnVjRGU1lhRGFtYVJ0Unpt?=
 =?utf-8?B?bFNzRGF3bW9KRkt6UXIyakRXZzhSUXJMOFNNSktLbndOY0hQZVFweEh6eVJ3?=
 =?utf-8?B?ckRGY09wVkJwZUUxZHdWd0hoUi83WkFEK0lsZTQxdDcwT3ZjUEMzbE9VczM5?=
 =?utf-8?B?cFB6VzBjYm9wM01RLy9UWWJVaEpweDZESjdZVXp5TkRKMXRWRzNINUhZaGRs?=
 =?utf-8?B?U0x1Y2VicVV2ZHFQSnJGOWRxZjBUWng0WXZGT0FiWVVYTnYwN2lrVnkxa2lz?=
 =?utf-8?B?VCtUQ0wrVlF4QnExNmFIMVlXZnlXNGVEVWN2eDdvVEphcjI5V1JLZ09XU0Ex?=
 =?utf-8?B?UFRwL0JqZDE3bjNSVlQzclVGOTFhL0dLeFR2L3RqOERQYlFLNmQ5ZHI2d2Yr?=
 =?utf-8?B?NE9tbWlsbjh5UkNmNU1FV2ZTdUVub2lnRkdqS3FiMk1ZOXNCWHZ3QXUrdEFS?=
 =?utf-8?B?MDkyRXM2YXNiNFhoWnpOTVN6VEsvekwvRkp6Z3VoSzdNUGplM2dwY1BNLzgz?=
 =?utf-8?B?enRpOG12L3dJSnhVYTNMV1ZiOXRSSjZWWktyWi9EZEl4MCtlaDFncVRmWmc3?=
 =?utf-8?B?WlFabW44ZlMxUnJYN3J5ZXIyekxsR085SE5kWWJKNjg3Zzd3MXhHTm5adkd4?=
 =?utf-8?B?UG9iNWVYMkxndVdQRmRWVnQxYkJRcVNMZnVsNnVFUWVySC94Y2NKZz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <11DA2EF59B640F4AA5FE99015C50475E@EURP194.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VE1P194MB0814.EURP194.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c16ab63-290d-4984-a20b-08da02c880d6
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Mar 2022 19:02:20.3673
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f930300c-c97d-4019-be03-add650a171c4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lUu+JE59g9iAapC5Z6v7Kd26Y/lm3mVA4sOdw9MuF8SEYmJBe4p+vNJRwFn0LbWgTuSwV45PcXHa12NNzd8acftoIKusftm7IFOCBMlekeyoGKGGhJ1xCRF6Eoehy9Dd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBP194MB1002
X-OriginatorOrg: fit.fraunhofer.de
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

WWVwLCB0aGF0J3MgY29ycmVjdC4gV2UgZG8gdXN1YWxseSBub3QgZ28gdGhyb3VnaCBhIE5FVERF
Vl9ET1dOL05FVERFVl9VUCBjeWNsZSwNCndoZW4sIGZvciBleGFtcGxlLCByZWFzc2lnbmluZyBj
aGFubmVscy4NCg0KV2lsbCB0ZXN0IHlvdXIgcGF0Y2ggYW5kIHJlcG9ydCBiYWNrLg0KDQpCUiwN
Cg0KTWF0aGlhcw0KDQpPbiBUaHUsIDIwMjItMDMtMTAgYXQgMTk6MzUgKzAxMDAsIExpbnVzIEzD
vHNzaW5nIHdyb3RlOg0KPiBGcm9tOiBMaW51cyBMw7xzc2luZyA8bGxAc2ltb253dW5kZXJsaWNo
LmRlPg0KPiANCj4gV2hpbGUgY29tbWl0IDZhMDFhZmNmODQ2OCAoIm1hYzgwMjExOiBtZXNoOiBG
cmVlIGllIGRhdGEgd2hlbiBsZWF2aW5nDQo+IG1lc2giKSBmaXhlZCBhIG1lbW9yeSBsZWFrIG9u
IG1lc2ggbGVhdmUgLyB0ZWFyZG93biBpdCBpbnRyb2R1Y2VkIGENCj4gcG90ZW50aWFsIG1lbW9y
eSBjb3JydXB0aW9uIGNhdXNlZCBieSBhIGRvdWJsZSBmcmVlIHdoZW4gcmVqb2luaW5nIHRoZQ0K
PiBtZXNoOg0KPiANCj4gwqAgaWVlZTgwMjExX2xlYXZlX21lc2goKQ0KPiDCoCAtPiBrZnJlZShz
ZGF0YS0+dS5tZXNoLmllKTsNCj4gwqAgLi4uDQo+IMKgIGllZWU4MDIxMV9qb2luX21lc2goKQ0K
PiDCoCAtPiBjb3B5X21lc2hfc2V0dXAoKQ0KPiDCoMKgwqDCoCAtPiBvbGRfaWUgPSBpZm1zaC0+
aWU7DQo+IMKgwqDCoMKgIC0+IGtmcmVlKG9sZF9pZSk7DQo+IA0KPiBUaGlzIGRvdWJsZSBmcmVl
IC8ga2VybmVsIHBhbmljcyBjYW4gYmUgcmVwcm9kdWNlZCBieSB1c2luZyB3cGFfc3VwcGxpY2Fu
dA0KPiB3aXRoIGFuIGVuY3J5cHRlZCBtZXNoIChpZiBzZXQgdXAgd2l0aG91dCBlbmNyeXB0aW9u
IHZpYSAiaXciIHRoZW4NCj4gaWZtc2gtPmllIGlzIGFsd2F5cyBOVUxMLCB3aGljaCBhdm9pZHMg
dGhpcyBpc3N1ZSkuIEFuZCB0aGVuIGNhbGxpbmc6DQo+IA0KPiDCoCAkIGl3IGRldiBtZXNoMCBt
ZXNoIGxlYXZlDQo+IMKgICQgaXcgZGV2IG1lc2gwIG1lc2ggam9pbiBteS1tZXNoDQo+IA0KPiBO
b3RlIHRoYXQgdHlwaWNhbGx5IHRoZXNlIGNvbW1hbmRzIGFyZSBub3QgdXNlZCAvIHdvcmtpbmcg
d2hlbiB1c2luZw0KPiB3cGFfc3VwcGxpY2FudC4gQW5kIGl0IHNlZW1zIHRoYXQgd3BhX3N1cHBs
aWNhbnQgb3Igd3BhX2NsaSBhcmUgZ29pbmcNCj4gdGhyb3VnaCBhIE5FVERFVl9ET1dOL05FVERF
Vl9VUCBjeWNsZSBiZXR3ZWVuIGEgbWVzaCBsZWF2ZSBhbmQgbWVzaCBqb2luDQo+IHdoZXJlIHRo
ZSBORVRERVZfVVAgcmVzZXRzIHRoZSBtZXNoLmllIHRvIE5VTEwgdmlhIGEgbWVtY3B5IG9mDQo+
IGRlZmF1bHRfbWVzaF9zZXR1cCBpbiBjZmc4MDIxMV9uZXRkZXZfbm90aWZpZXJfY2FsbCwgd2hp
Y2ggdGhlbiBhdm9pZHMNCj4gdGhlIG1lbW9yeSBjb3JydXB0aW9uLCB0b28uDQo+IA0KPiBUaGUg
aXNzdWUgd2FzIGZpcnN0IG9ic2VydmVkIGluIGFuIGFwcGxpY2F0aW9uIHdoaWNoIHdhcyBub3Qg
dXNpbmcNCj4gd3BhX3N1cHBsaWNhbnQgYnV0ICJTZW5mIiBpbnN0ZWFkLCB3aGljaCBpbXBsZW1l
bnRzIGl0cyBvd24gY2FsbHMgdG8NCj4gbmw4MDIxMS4NCj4gDQo+IEZpeGluZyB0aGUgaXNzdWUg
YnkgcmVtb3ZpbmcgdGhlIGtmcmVlKCknaW5nIG9mIHRoZSBtZXNoIElFIGluIHRoZSBtZXNoDQo+
IGpvaW4gZnVuY3Rpb24gYW5kIGxlYXZpbmcgaXQgc29sZWx5IHVwIHRvIHRoZSBtZXNoIGxlYXZl
IHRvIGZyZWUgdGhlDQo+IG1lc2ggSUUuDQo+IA0KPiBMaW5rOiBodHRwczovL2dpdGxhYi5maXQu
ZnJhdW5ob2Zlci5kZS93aWJhY2svc2VuZg0KPiBGaXhlczogNmEwMWFmY2Y4NDY4ICgibWFjODAy
MTE6IG1lc2g6IEZyZWUgaWUgZGF0YSB3aGVuIGxlYXZpbmcgbWVzaCIpDQo+IFJlcG9ydGVkLWJ5
OiBNYXR0aGlhcyBLcmV0c2NobWVyIDxtYXRoaWFzLmtyZXRzY2htZXJAZml0LmZyYXVuaG9mZXIu
ZGU+DQo+IFNpZ25lZC1vZmYtYnk6IExpbnVzIEzDvHNzaW5nIDxsbEBzaW1vbnd1bmRlcmxpY2gu
ZGU+DQo+IC0tLQ0KPiDCoG5ldC9tYWM4MDIxMS9jZmcuYyB8IDMgLS0tDQo+IMKgMSBmaWxlIGNo
YW5nZWQsIDMgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvbmV0L21hYzgwMjExL2Nm
Zy5jIGIvbmV0L21hYzgwMjExL2NmZy5jDQo+IGluZGV4IDg3YTIwODA4OWNhZi4uNThmZjU3ZGM2
NjljIDEwMDY0NA0KPiAtLS0gYS9uZXQvbWFjODAyMTEvY2ZnLmMNCj4gKysrIGIvbmV0L21hYzgw
MjExL2NmZy5jDQo+IEBAIC0yMTQ4LDE0ICsyMTQ4LDEyIEBAIHN0YXRpYyBpbnQgY29weV9tZXNo
X3NldHVwKHN0cnVjdCBpZWVlODAyMTFfaWZfbWVzaA0KPiAqaWZtc2gsDQo+IMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgY29uc3Qgc3RydWN0IG1lc2hfc2V0dXAgKnNldHVwKQ0KPiDC
oHsNCj4gwqDCoMKgwqDCoMKgwqDCoHU4ICpuZXdfaWU7DQo+IC3CoMKgwqDCoMKgwqDCoGNvbnN0
IHU4ICpvbGRfaWU7DQo+IMKgwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgaWVlZTgwMjExX3N1Yl9pZl9k
YXRhICpzZGF0YSA9IGNvbnRhaW5lcl9vZihpZm1zaCwNCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqBzdHJ1Y3QgaWVlZTgwMjExX3N1Yl9pZl9kYXRhLCB1Lm1lc2gpOw0KPiDCoMKgwqDCoMKgwqDC
oMKgaW50IGk7DQo+IMKgDQo+IMKgwqDCoMKgwqDCoMKgwqAvKiBhbGxvY2F0ZSBpbmZvcm1hdGlv
biBlbGVtZW50cyAqLw0KPiDCoMKgwqDCoMKgwqDCoMKgbmV3X2llID0gTlVMTDsNCj4gLcKgwqDC
oMKgwqDCoMKgb2xkX2llID0gaWZtc2gtPmllOw0KPiDCoA0KPiDCoMKgwqDCoMKgwqDCoMKgaWYg
KHNldHVwLT5pZV9sZW4pIHsNCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBuZXdf
aWUgPSBrbWVtZHVwKHNldHVwLT5pZSwgc2V0dXAtPmllX2xlbiwNCj4gQEAgLTIxNjUsNyArMjE2
Myw2IEBAIHN0YXRpYyBpbnQgY29weV9tZXNoX3NldHVwKHN0cnVjdCBpZWVlODAyMTFfaWZfbWVz
aA0KPiAqaWZtc2gsDQo+IMKgwqDCoMKgwqDCoMKgwqB9DQo+IMKgwqDCoMKgwqDCoMKgwqBpZm1z
aC0+aWVfbGVuID0gc2V0dXAtPmllX2xlbjsNCj4gwqDCoMKgwqDCoMKgwqDCoGlmbXNoLT5pZSA9
IG5ld19pZTsNCj4gLcKgwqDCoMKgwqDCoMKga2ZyZWUob2xkX2llKTsNCj4gwqANCj4gwqDCoMKg
wqDCoMKgwqDCoC8qIG5vdyBjb3B5IHRoZSByZXN0IG9mIHRoZSBzZXR1cCBwYXJhbWV0ZXJzICov
DQo+IMKgwqDCoMKgwqDCoMKgwqBpZm1zaC0+bWVzaF9pZF9sZW4gPSBzZXR1cC0+bWVzaF9pZF9s
ZW47DQoNCg==
