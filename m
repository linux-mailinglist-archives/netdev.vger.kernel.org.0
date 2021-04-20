Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3885C36616B
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 23:14:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233992AbhDTVPE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 17:15:04 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:45300 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233548AbhDTVO4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 17:14:56 -0400
Received: from mailhost.synopsys.com (badc-mailhost2.synopsys.com [10.192.0.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 08E39400DF;
        Tue, 20 Apr 2021 21:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1618953264; bh=V2lzBBYP24AyvHm27fc7znXxbzxcXRd+zXw7ZBZUcB4=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=fgVibSljnc2nQiW5jaBnRRgXDMlpmbHJrKeE/fb4HFlHORQSx3uge1xa7SAkWoaWa
         E0siAFr7E6MUusb35HdKCvY8HuaqwV4HywHfoHHH3IrQaFVF1jteDbgx0ui3GXmn8m
         9jT3plX4RDgQXbE2psSDbCy6AqdLyt2GwM04HicmB/fBuA8JWZzMrWEFrY73G24XUj
         +pMBuGNuLhO5m51GRl3L2Ly4ujCNg2Ty1Ye6hweo3/2A7/CPw4XBtrhsHZHE/4KtsX
         eegJAPdy1C652V+gUXMtoGNJLIaX6+uYT7MEgoRqp7vhC8JLhPthbcaosmSMvFsqlK
         qAc5BT0Fewtxg==
Received: from o365relay-in.synopsys.com (sv2-o365relay1.synopsys.com [10.202.1.137])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id EACCDA0067;
        Tue, 20 Apr 2021 21:14:18 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "DigiCert Cloud Services CA-1" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id 8CDCB400F7;
        Tue, 20 Apr 2021 21:14:15 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=vgupta@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="V4ZrO4oP";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F29Mr4MmSxfdFmO19x6Nir1bXsIxfhKz249eKklJ7JuHpkBqN6G4jLHs4krxoRJRBFyYQwPY8rL+1inJEMRwGkmHV0pqyOU025sZFOe0mKLDFSQMGMfI//G7lGBSMUp0+WcxIKkbxeBCevFouOVcAF427GVys71vonqp3WkxfiMWNqfz8GD1ZHbSV+8IhKoMNZrdT+SOwHPI8SVwYTg9qIVhq2nS848/o34bcsumer8VdFz+kii/VnSAWj+Pb845zySPAsykd027kubeigDWlN67mzmTUOkzH9SFasnRBqk0tjasv+LGTvfSOJkUhK+kJjZpF2b02GwKZdJaE1Q+iA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V2lzBBYP24AyvHm27fc7znXxbzxcXRd+zXw7ZBZUcB4=;
 b=I+uqHkJU69al3mPA+qXqJcHqYWw2Veud4q35dTXCzT5gOpo/WL0huI8Cj+L2bNBHWgAMwUaoHL1dxcgCo9AJAnTkhsRuK4EMvA0Jowdlgnacf7xRlFZKn0U84L5nd8KcGuDbZ4sR1pY8djp3ySf4FG18UPWGbQ6nzCmogAZ8tc1eA2XrxeH8NdQI79tWQWqVoMeOi0BH3lhl7wZbRk//0V3i6QTUtSiiPnJeNmwbD1XYnN9aKi7QReKb8rVge49smIrFKiNuu6tI9OqEo0wC9T0jfCNmcR7u5x3XDsT/Vx8h27K7qkl9s39zLigVJpBdiA3njX5huTqzNap19ZcGMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V2lzBBYP24AyvHm27fc7znXxbzxcXRd+zXw7ZBZUcB4=;
 b=V4ZrO4oP2FJkFzrmIVtr/5w5acv5pKh7+8rdc+ZYLowRrUVR+9o0ORcSHIq1UGxLyK5Iry/KwHgu1FRvMDsZ+bXjmbRQpY/J40F2fq5w7Fo/x5CrTm4bp+tbD/FNudAqQCGAID+08gJ8nHL5PX6aL+PY4/XoD5gGoNJT1SXTuzY=
Received: from BYAPR12MB3479.namprd12.prod.outlook.com (2603:10b6:a03:dc::26)
 by BY5PR12MB5015.namprd12.prod.outlook.com (2603:10b6:a03:1db::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.18; Tue, 20 Apr
 2021 21:14:12 +0000
Received: from BYAPR12MB3479.namprd12.prod.outlook.com
 ([fe80::88a:1041:81ed:982]) by BYAPR12MB3479.namprd12.prod.outlook.com
 ([fe80::88a:1041:81ed:982%7]) with mapi id 15.20.4042.024; Tue, 20 Apr 2021
 21:14:12 +0000
X-SNPS-Relay: synopsys.com
From:   Vineet Gupta <Vineet.Gupta1@synopsys.com>
To:     Arnd Bergmann <arnd@kernel.org>,
        Matthew Wilcox <willy@infradead.org>
CC:     Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        "grygorii.strashko@ti.com" <grygorii.strashko@ti.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "mhocko@kernel.org" <mhocko@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "mgorman@suse.de" <mgorman@suse.de>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "mcroce@linux.microsoft.com" <mcroce@linux.microsoft.com>,
        "linux-snps-arc@lists.infradead.org" 
        <linux-snps-arc@lists.infradead.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "hch@lst.de" <hch@lst.de>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/2] mm: Fix struct page layout on 32-bit systems
Thread-Topic: [PATCH 1/2] mm: Fix struct page layout on 32-bit systems
Thread-Index: AQHXMxVijWO/awtGlkiVwcCofC+50Kq4AUEAgAS3z4CAAAY0gIAAQlaAgADscoA=
Date:   Tue, 20 Apr 2021 21:14:12 +0000
Message-ID: <8d0fce1c-be7c-1c9b-bf5c-0c531db496ac@synopsys.com>
References: <20210416230724.2519198-1-willy@infradead.org>
 <20210416230724.2519198-2-willy@infradead.org>
 <20210417024522.GP2531743@casper.infradead.org>
 <9f99b0a0-f1c1-f3b0-5f84-3a4bfc711725@synopsys.com>
 <20210420031029.GI2531743@casper.infradead.org>
 <CAK8P3a0KUwf1Z0bHiUaHC2nHztevkxg5_FBSzHddNeSsBayWUA@mail.gmail.com>
In-Reply-To: <CAK8P3a0KUwf1Z0bHiUaHC2nHztevkxg5_FBSzHddNeSsBayWUA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=synopsys.com;
x-originating-ip: [24.4.73.83]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 294c2d41-0b0a-429f-b149-08d904413f05
x-ms-traffictypediagnostic: BY5PR12MB5015:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB501534AB6C15A2B63B81EC00B6489@BY5PR12MB5015.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6tEcbfHlAKXwMvtkOt0dHb+xftJsugey+7+9j1pyJ3oaV67GrIIKlbtbIrPFp7P1Oa6VYcarTeIG+u7+uX1Vc54apzHaBDGE1YADDtoTSP0c7kOTkyDPR2V32YS0Og5IfkJpDNqMb1DK56eAd4DPrYzKSyqXQJphSAh4zdgOAG86kX4cHUnywbfmR4BPUqYZA/eaD6RFbhp5+kTnhHr8mDYWjURlCOFy69UjcM66O2ch3rZmDHkB2JFm57Yq4Ux8TlqN+ApXYi/y2TrqqlU7VfmbdVrIJXca4+SjeQPBtb+WGVGsCwmDEmADl5jK8BOvX6cp6G738v/95hLu4iuqoxi4scjg9qYWwwDCtYT2dOMyWBidoTEQbF6p9Yy3469PVEws9trVSTwfcktPOR9x7EIllOgwwDaED/GK5Yq0AdS7DNq1g6tF2GQksiN/HagM5r0Apxyok5NOaNZFXspuXclVqvgBJxqjjD5f3ZJhBA2fivAG7TdeKwzRKZ+5Ty1M8mp/3DFk15baygY6fZ8JN2ud0gD7OnZ1qHVKzy9taI2hQc5ItIKeM1YfRlFwAat68mYPoR4IK5FnLPT9aKfGn9BRWFf9wD0brtzfglfIkCWEGjYTz5EVJQwunLU0RS2687PHf6Nj08uP8TTBGDYBdf7BQ9oR+HZ+L7AcQ5+3PuJWL/5V1zzbQCKKnPPPRA9a
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3479.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(396003)(366004)(346002)(39850400004)(38100700002)(122000001)(2906002)(478600001)(110136005)(316002)(26005)(6512007)(8936002)(66946007)(36756003)(6506007)(4326008)(8676002)(71200400001)(53546011)(186003)(83380400001)(2616005)(76116006)(7416002)(64756008)(6486002)(31686004)(5660300002)(86362001)(54906003)(66556008)(66476007)(31696002)(66446008)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?djhWYXZYT3psL1o2bXkvMWxpV0FJUnJndFBQUjZvbUZIeEVnRUxPVkJwRzBD?=
 =?utf-8?B?NElQQU1xajlaNzd3S3BybWtVeDFuVkVMN3AyV2NGNmFGZ2FJUUl2SW4rOFlB?=
 =?utf-8?B?SmNBaTBydGtIc0UrZS93VEVMNjN5WlE5Yzd4VUl3eEhRaFFkSzBiZ1pqOGp5?=
 =?utf-8?B?aWNaL1k5dEVRWVF6RlFBRmJCQWx4S1ZQeUxpK2RmTXNxV0w4MnEyQXBFMVJL?=
 =?utf-8?B?VVJBUllWSU9DYmVqcnpJeUw1RUtzcGlmdjEvSVZTaFVEQ0ZidWVWcThPdzBG?=
 =?utf-8?B?a3pqU1c0RjdEcW0xV2Fid3d0ZzlMeFBxS1M3SVJoTVRndGRSN0VXV1M3SDJK?=
 =?utf-8?B?TnJ1MUdKelh0YkhpcE1NZkRmdmNkQ2Y0Z3pkeFFGeHJJbk14eXczZnN0czFo?=
 =?utf-8?B?ZFJaUGt5N3RqMnlRczdmdWNvazRZK3B6ZGFYakxPZEJmNElJRVQxaDNpL0JW?=
 =?utf-8?B?cEw2ZFpMcnhTUVNLUEJTdkpsYitXRDQxY1BDSGhpNFlqY1NSVE9QMGlGQTFH?=
 =?utf-8?B?TkV0ZEc5R1I4UFlqL0NxclYvTVFLZWFsRXhWRkVGamxhTks0WkdqUUlhU3VJ?=
 =?utf-8?B?WS93aDRNYkR6a1A2T01VMSt0VE5uSHNGRFFuODVxUmxueFhBekt3S1gweTF2?=
 =?utf-8?B?c3hQWlVxTWJSSGNUcm5Bbm1nM002dEJQQ0hQT3JGeVE2OWdqNlQ4Kytxamlr?=
 =?utf-8?B?d3grVUFNR294RHFWL0JGZzV6Qjd5MmlqUlh0RDVXK2F2U1JXdkxoU050MGtP?=
 =?utf-8?B?SGNvRi9Lb0FONWhFa1I4ZXVLMzIrYjdsUkVENXdBdUkyaXZQaTc2TkFiaXMv?=
 =?utf-8?B?TzBNYUdmQ1M3MElLbUpUVUh4SkI0d0paZHA0akNrOFY4WVlERDhLR2ZhZjlK?=
 =?utf-8?B?bExpNGxuZnZmL3FVWEdtcms5L3dkOVNtRUJGTE5hOGJJd1dVVXRWZXM3OXdu?=
 =?utf-8?B?WlBneXFweU1HQmc5UUEzNDQvR25SbUdmN0dZalA4V1l6d3N1VHkxYU1HcDd5?=
 =?utf-8?B?a2hTc09lM202NUhpMzZWYk10VVhlRUl5N01GenNJMUg1Wit2elFJa1d2UGtp?=
 =?utf-8?B?Y2l4Z2dFdGVuOGRnLzJQaUljRFByRlNDRTlSQXJEVkRSRUpjYXpYaTZPN295?=
 =?utf-8?B?anNmalRqdk1JVUdsdE5KSExQMHR1WkhEaHE0VnAxWkdnWUxPY3JycmNWWmRV?=
 =?utf-8?B?MzM2NkdaeTNBbWp4YTF4Si9oUFJmOHIvYzVuVWlRNkxYejJrY0lJL0NCMlpo?=
 =?utf-8?B?S1MwNXA4czFqTWtRYlZ0K3FvNnNJN01LYTd0M0RVSlZUS2NqSkNBNXNDNFF6?=
 =?utf-8?B?SkdKL2hGR2RSb3M4bEVIOGtXcFR3bzBTNVowdmFnMTBuaTFmVnJtMm9Gd3RQ?=
 =?utf-8?B?QkNNaGJGZ0dpekhIQTkxL3JlbWxwSXAyVFhXSGFuQ29ZekF6bGRBbUxEbVVO?=
 =?utf-8?B?ZlVVUENubWh2ckVNcXJ3MzFidWEyRTR2Umo3bGQxOXRJcnlUeVJMb1RFQklo?=
 =?utf-8?B?MGpjWjl2eEtFWTMyb3lMaG5EWFc0YTV6UC83WkZldjcxV2grUUJaem9HTmZM?=
 =?utf-8?B?SDlLVDY5SFVNYlF0SEFxY3VLakg2aDFHenh1NHMwUU9XYUZOK1B3a2xlQmM1?=
 =?utf-8?B?K0x2aFZudVBZRFRkSCtTeUl2NXZTM2QwVWs5dDNLUXIwc2EvZlNyT0gxSVV2?=
 =?utf-8?B?Z2hkL2xmaUV0TFNaNU1vMmp2RGoySHA0NytEb2ZEUEh4UnF0eXJnQkIzTkVq?=
 =?utf-8?Q?ztOLnCHKYuZBPK3Jzs=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F26DDAB18054BD438678BBED0DCD8FAD@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3479.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 294c2d41-0b0a-429f-b149-08d904413f05
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Apr 2021 21:14:12.4849
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TdyhZFishppDk72GrJChuMmZZtK0XTiCdF0c2nTeLY35KoRqSawcEs83kzc/8dT9ro5UwhdfTT8fMJvDqlRvIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB5015
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gNC8yMC8yMSAxMjowNyBBTSwgQXJuZCBCZXJnbWFubiB3cm90ZToNCj4gT24gVHVlLCBBcHIg
MjAsIDIwMjEgYXQgNToxMCBBTSBNYXR0aGV3IFdpbGNveCA8d2lsbHlAaW5mcmFkZWFkLm9yZz4g
d3JvdGU6DQo+PiBPbiBUdWUsIEFwciAyMCwgMjAyMSBhdCAwMjo0ODoxN0FNICswMDAwLCBWaW5l
ZXQgR3VwdGEgd3JvdGU6DQo+Pj4+IDMyLWJpdCBhcmNoaXRlY3R1cmVzIHdoaWNoIGV4cGVjdCA4
LWJ5dGUgYWxpZ25tZW50IGZvciA4LWJ5dGUgaW50ZWdlcnMNCj4+Pj4gYW5kIG5lZWQgNjQtYml0
IERNQSBhZGRyZXNzZXMgKGFyYywgYXJtLCBtaXBzLCBwcGMpIGhhZCB0aGVpciBzdHJ1Y3QNCj4+
Pj4gcGFnZSBpbmFkdmVydGVudGx5IGV4cGFuZGVkIGluIDIwMTkuDQo+Pj4gRldJVywgQVJDIGRv
ZXNuJ3QgcmVxdWlyZSA4IGJ5dGUgYWxpZ25tZW50IGZvciA4IGJ5dGUgaW50ZWdlcnMuIFRoaXMg
aXMNCj4+PiBvbmx5IG5lZWRlZCBmb3IgOC1ieXRlIGF0b21pY3MgZHVlIHRvIHRoZSByZXF1aXJl
bWVudHMgb2YgTExPQ0tEL1NDT05EDQo+Pj4gaW5zdHJ1Y3Rpb25zLg0KPj4gQWgsIGxpa2UgeDg2
PyAgT0ssIGdyZWF0LCBJJ2xsIGRyb3AgeW91ciBhcmNoIGZyb20gdGhlIGxpc3Qgb2YNCj4+IGFm
ZmVjdGVkLiAgVGhhbmtzIQ0KPiBJIG1pc3Rha2VubHkgYXNzdW1lZCB0aGF0IGkzODYgYW5kIG02
OGsgd2VyZSB0aGUgb25seSBzdXBwb3J0ZWQNCj4gYXJjaGl0ZWN0dXJlcyB3aXRoIDMyLWJpdCBh
bGlnbm1lbnQgb24gdTY0LiBJIGNoZWNrZWQgaXQgbm93IGFuZCBmb3VuZA0KPg0KPiAkIGZvciBp
IGluIC9ob21lL2FybmQvY3Jvc3MveDg2XzY0L2djYy0xMC4xLjAtbm9saWJjLyovYmluLyotZ2Nj
IDsgZG8NCj4gZWNobyBgZWNobyAnaW50IGEgPSBfX2FsaWdub2ZfXyhsb25nIGxvbmcpOycgfCAk
aSAteGMgLSAtV2FsbCAtUyAtby0gfA0KPiBncmVwIC1BMSBhOiB8IHRhaWwgLW4gMSB8IGN1dCAt
ZiAzIC1kXCAgIGANCj4gJHtpIy9ob21lL2FybmQvY3Jvc3MveDg2XzY0L2djYy0xMC4xLjAtbm9s
aWJjLyovYmluL30gOyBkb25lDQo+IDggYWFyY2g2NC1saW51eC1nY2MNCj4gOCBhbHBoYS1saW51
eC1nY2MNCj4gNCBhcmMtbGludXgtZ2NjDQo+IDggYXJtLWxpbnV4LWdudWVhYmktZ2NjDQo+IDgg
YzZ4LWVsZi1nY2MNCj4gNCBjc2t5LWxpbnV4LWdjYw0KPiA0IGg4MzAwLWxpbnV4LWdjYw0KPiA4
IGhwcGEtbGludXgtZ2NjDQo+IDggaHBwYTY0LWxpbnV4LWdjYw0KPiA4IGkzODYtbGludXgtZ2Nj
DQo+IDggaWE2NC1saW51eC1nY2MNCj4gMiBtNjhrLWxpbnV4LWdjYw0KPiA0IG1pY3JvYmxhemUt
bGludXgtZ2NjDQo+IDggbWlwcy1saW51eC1nY2MNCj4gOCBtaXBzNjQtbGludXgtZ2NjDQo+IDgg
bmRzMzJsZS1saW51eC1nY2MNCj4gNCBuaW9zMi1saW51eC1nY2MNCj4gNCBvcjFrLWxpbnV4LWdj
Yw0KPiA4IHBvd2VycGMtbGludXgtZ2NjDQo+IDggcG93ZXJwYzY0LWxpbnV4LWdjYw0KPiA4IHJp
c2N2MzItbGludXgtZ2NjDQo+IDggcmlzY3Y2NC1saW51eC1nY2MNCj4gOCBzMzkwLWxpbnV4LWdj
Yw0KPiA0IHNoMi1saW51eC1nY2MNCj4gNCBzaDQtbGludXgtZ2NjDQo+IDggc3BhcmMtbGludXgt
Z2NjDQo+IDggc3BhcmM2NC1saW51eC1nY2MNCj4gOCB4ODZfNjQtbGludXgtZ2NjDQo+IDggeHRl
bnNhLWxpbnV4LWdjYw0KPg0KPiB3aGljaCBtZWFucyB0aGF0IGhhbGYgdGhlIDMyLWJpdCBhcmNo
aXRlY3R1cmVzIGRvIHRoaXMuIFRoaXMgbWF5DQo+IGNhdXNlIG1vcmUgcHJvYmxlbXMgd2hlbiBh
cmMgYW5kL29yIG1pY3JvYmxhemUgd2FudCB0byBzdXBwb3J0DQo+IDY0LWJpdCBrZXJuZWxzIGFu
ZCBjb21wYXQgbW9kZSBpbiB0aGUgZnV0dXJlIG9uIHRoZWlyIGxhdGVzdCBoYXJkd2FyZSwNCj4g
YXMgdGhhdCBtZWFucyBkdXBsaWNhdGluZyB0aGUgeDg2IHNwZWNpZmljIGhhY2tzIHdlIGhhdmUg
Zm9yIGNvbXBhdC4NCj4NCj4gV2hhdCBpcyBhbGlnbm9mKHU2NCkgb24gNjQtYml0IGFyYz8NCg0K
JCBlY2hvICdpbnQgYSA9IF9fYWxpZ25vZl9fKGxvbmcgbG9uZyk7JyB8IGFyYzY0LWxpbnV4LWdu
dS1nY2MgLXhjIC0gDQotV2FsbCAtUyAtbyAtIHwgZ3JlcCAtQTEgYTogfCB0YWlsIC1uIDEgfCBj
dXQgLWYgMw0KOA0KDQpZZWFoIEFSQ3YyIGFsaWdubWVudCBvZiA0IGZvciA2NC1iaXQgZGF0YSB3
YXMgYSBiaXQgb2Ygc3VycHJpc2UgZmluZGluZyANCmZvciBtZSBhcyB3ZWxsLiBXaGVuIDY0LWJp
dCBsb2FkL3N0b3JlcyB3ZXJlIGluaXRpYWxseSB0YXJnZXRlZCBieSB0aGUgDQppbnRlcm5hbCBN
ZXRhd2FyZSBjb21waWxlciAobGx2bSBiYXNlZCkgdGhleSBkZWNpZGVkIHRvIGtlZXAgYWxpZ25t
ZW50IA0KdG8gNCBzdGlsbCAoZ3JhbnRlZCBoYXJkd2FyZSBhbGxvd2VkIHRoaXMpIGFuZCB0aGVu
IGdjYyBndXlzIGRlY2lkZWQgdG8gDQpmb2xsb3cgdGhlIHNhbWUgQUJJLiBJIG9ubHkgZm91bmQg
dGhpcyBieSBhY2NpZGVudCA6LSkNCg0KQ2FuIHlvdSBwb2ludCBtZSB0byBzb21lIHNwZWNpZmlj
cyBvbiB0aGUgY29tcGF0IGlzc3VlLiBGb3IgYmV0dGVyIG9mIA0Kd29yc2UsIGFyYzY0IGRvZXMn
J3QgaGF2ZSBhIGNvbXBhdCAzMi1iaXQgbW9kZSwgc28gZXZlcnl0aGluZyBpcyANCjY0LW9uLTY0
IG9yIDMyLW9uLTMyIChBUkMzMiBmbGF2b3Igb2YgQVJDdjMpDQoNClRoeCwNCi1WaW5lZXQNCg==
