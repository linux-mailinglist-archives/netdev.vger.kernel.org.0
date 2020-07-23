Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AD1522B2CF
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 17:43:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729708AbgGWPmb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 11:42:31 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:37994 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728306AbgGWPm3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 11:42:29 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06NFZgiK008032;
        Thu, 23 Jul 2020 08:41:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=1psEQCMmjwM9uM70O8ZWFMEwmTJ5LhrvCuMyIyZDFX0=;
 b=RZ9tzfJO6/gJICbeQaA4roKSSt/64Zjoo3akFWeiGyqi+/hLfW+/jr5JMzLJq4CY0rJ1
 8CCBXzsG9q96Ja2uOQbaaFIxSFXl+aC661TPN8zwQ0IK4OLJO5OW5m7OB41aCouywNcl
 0UKtE6f7PYjWI3Zqg6dikqC9aijFljssHKrXfKMbF5p0qYyvoKDdXrueIWopQdps3L1w
 Edi8czPTJMxj6CYGw0y/aXJ/QtBXpp5FqQ034FhUdU8hmoXDpix6bKPtKpJBnFXCC6+p
 UQGDZrs5jQQwjB4FcS4LBiusQ3UKKKAMCSgF3IpSyI/uNDYqkiFfrOqMHEeQMLXmBqWe +g== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 32c0kkwg2s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 23 Jul 2020 08:41:51 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 23 Jul
 2020 08:41:50 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.177)
 by SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 23 Jul 2020 08:41:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iMTlpXI9P0IWuqiq36Qm8c6wRy6mlHg/mu7BpYYBVfeyvRdGiMQAenFsXizBwC+HKjNpN2PEPiOKIw6nFGZiTK2+A6QYjYPY/+nkkSzXEyFiAh6HZsS7V23d2MReC9hYnlvJZkfY2vRjJs/UOy84+1cRSLIc9nGZc+pv3OI/UfGpR8D7ou7NbBlHsFxJiShl229Mo4dlVs/GVfI67ZlxOXqxvnMF6dLszPCMHEG46KylJYNr9CREvMXxz7DIMfBcJtZtUSOUrjcwuHagaymKG+KFBQM+fLOlXk3ka1aSEA1nLhCpxPJivHH73rUOHv55/iGj3c+gQvNi9ERwhVhqVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1psEQCMmjwM9uM70O8ZWFMEwmTJ5LhrvCuMyIyZDFX0=;
 b=cyR5EBOESBKnO0YHX0dKsMkNBkUGOfvc5y5w+tz7XgxrA6doEVmIbY0xgUJfW33f/sUUFrV/hfTgPbUZQie9HFljXYXy/D2G34JW1BgGgaJiA4Pd1AQ9qjpuIiO3KafSiuprldOHNm4+sYb5jdb0xCqavGdh97YivuD9mbK1AqVXmwBm5/ktJir5kXKDBHrVSyb35D/Ix98dzFbjIz1iTbe2AZhZByecRgdU8rsnqg1Io3rBDEb1TBzPXRncpcCAwsYK/YwUdJZ6OlwH2nSW49VElC70WK+SddUiAGeHRJ9mmsRmXMYFR+pcsC8qmRHcP+zRCAbgibOtWbQpTcjqWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1psEQCMmjwM9uM70O8ZWFMEwmTJ5LhrvCuMyIyZDFX0=;
 b=AnG8zuLnUOlDRwe6OFQuNbgqFCuFfPbIBvQyiPL4vkT0pUMvRkiwC4eIQMr9H4nVolsCwARSeIe04E5/H3ZmsNEWqPrrcLbP6nHA+9pase/TgfNZH1tiVRMOr1ivLdTxeTBDlP8abkYf5zJQa54f15Ut22nfTbuwOyxLdrfo5yo=
Received: from MW2PR18MB2267.namprd18.prod.outlook.com (2603:10b6:907:3::11)
 by MWHPR18MB0927.namprd18.prod.outlook.com (2603:10b6:300:9a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23; Thu, 23 Jul
 2020 15:41:47 +0000
Received: from MW2PR18MB2267.namprd18.prod.outlook.com
 ([fe80::b9a6:a3f2:2263:dc32]) by MW2PR18MB2267.namprd18.prod.outlook.com
 ([fe80::b9a6:a3f2:2263:dc32%4]) with mapi id 15.20.3195.026; Thu, 23 Jul 2020
 15:41:47 +0000
From:   Alex Belits <abelits@marvell.com>
To:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "peterz@infradead.org" <peterz@infradead.org>
CC:     "mingo@kernel.org" <mingo@kernel.org>,
        Prasun Kapoor <pkapoor@marvell.com>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "will@kernel.org" <will@kernel.org>,
        "frederic@kernel.org" <frederic@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [EXT] Re: [PATCH v4 00/13] "Task_isolation" mode
Thread-Topic: [EXT] Re: [PATCH v4 00/13] "Task_isolation" mode
Thread-Index: AQHWYDagTVb+dYV8A0GKqxFlnWyBeKkVJq8AgAAUHACAABRRgA==
Date:   Thu, 23 Jul 2020 15:41:46 +0000
Message-ID: <670609a91be23ebb4f179850601439fbed844479.camel@marvell.com>
References: <04be044c1bcd76b7438b7563edc35383417f12c8.camel@marvell.com>
         <87imeextf3.fsf@nanos.tec.linutronix.de>
         <20200723142902.GT5523@worktop.programming.kicks-ass.net>
In-Reply-To: <20200723142902.GT5523@worktop.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linutronix.de; dkim=none (message not signed)
 header.d=none;linutronix.de; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [173.228.7.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e79c19df-e3d8-498d-7320-08d82f1ee89f
x-ms-traffictypediagnostic: MWHPR18MB0927:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR18MB09279D42442420D468EA4562BC760@MWHPR18MB0927.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YwN4/6EmwSCl7NSJXnF3E3fwH2Pev7JFlQG813uAh+xc448aOEndXMSg0TrZCnslyM7OKlfLR68NNP+nzRLSpi9UDTGotgbHMLwRh7/qGAGRXBji+6350UHUXEa0aiMVIh3gwOHEIrilPGM++aE12DZowHW9DRmRU+3/IRxplOkJARq2WOPfM4WXUvl5rBB+YbnHsrDrbOWC2VHufFyn9mMYSyFbdyQt2nn8rN1Qsy6AJjIhwlpUSoKD+ZSoqh7jb7d4sMZW0n4pefE12IS7aP1hGs2FhT8XMwTHMJjY1cekqzI6ZmMRltAwp9Ck46QDjQgNFygLQ0Dn59zuPZkmDQzcFoDfhfFDTiTKMAWqCSyU9GRBOm+uvf2mRozv0c0DCMZJ66vgLbNMEnId7M/bHQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR18MB2267.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(39860400002)(136003)(376002)(366004)(396003)(4326008)(36756003)(7416002)(5660300002)(66476007)(66946007)(66446008)(64756008)(66556008)(110136005)(91956017)(8936002)(6506007)(54906003)(26005)(2616005)(86362001)(2906002)(966005)(6486002)(71200400001)(316002)(478600001)(186003)(8676002)(6512007)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: WMDnPAtTKfDN7K2Ga8iTCHzOxQ60r2BznRAVHnkl94jmg/DzcSalbHQiI21Y9FEbXl+lRqFicnhIaB4vXvCDYzIqq24IRSujC2YNk7dCDwzv4VJKdSkaAcSgumZTVLaWzgVG4d0sAUk4NZNPRsNaTN+WZ4QKnzFebTWkyRhovsPoI2xYCOyxZxLZd+JshtrNJIRMkh4JdIS0ISjdKoSQPhTwyNdrQe1RvL0EGyiFsJDvd9bakNXgReaIGajFHBBanz5GYIdllBr6ik2IMidltlhScWonQAbG3GRV2Jdgh9WalA+d5RMaZIi5OzBFyWvSsYIFN6fpH2JQxFI1wUEZ3Nqn19FcYqeN7sC6h0mZo0+ugOmLyyDn22k5YeIxttxG2AIJTuqVMPeMzLtQ7ND/O0CMT4ovi0NjNosOGthXaXjNP/kKyOFJeWnwWnWBRQ31+r+TMeLU2YFPrnxZBV3kipGb35E49nkDbirc0fjkeFI=
Content-Type: text/plain; charset="utf-8"
Content-ID: <338E0FC799BFDC42AFD75D748BE872A0@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR18MB2267.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e79c19df-e3d8-498d-7320-08d82f1ee89f
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2020 15:41:46.9554
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jx9bP8LAi3qyDGr44VzjNGvzZx/rtvbgcyx8VYOycXT/yt1YPOjNsebcai2WVI0cr/W4nA18Nto8Q4+78Kzf+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR18MB0927
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-23_08:2020-07-23,2020-07-23 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiBUaHUsIDIwMjAtMDctMjMgYXQgMTY6MjkgKzAyMDAsIFBldGVyIFppamxzdHJhIHdyb3Rl
Og0KPiAuDQo+IA0KPiBUaGlzLi4gYXMgcHJlc2VudGVkIGl0IGlzIGFuIGFic29sdXRlbHkgdW5y
ZXZpZXdhYmxlIHBpbGUgb2YganVuay4gSXQNCj4gcHJlc2VudHMgY29kZSB3aXRvdXQgYW55IGNv
aGVyZW50IHByb2JsZW0gZGVzY3JpcHRpb24gYW5kIGFuYWx5c2lzLg0KPiBBbmQNCj4gdGhlIHBh
dGNoZXMgYXJlIG5vdCBzcGxpdCBzYW5lbHkgZWl0aGVyLg0KDQpUaGVyZSBpcyBhIG1vcmUgY29t
cGxldGUgYW5kIHNsaWdodGx5IG91dGRhdGVkIGRlc2NyaXB0aW9uIGluIHRoZQ0KcHJldmlvdXMg
dmVyc2lvbiBvZiB0aGUgcGF0Y2ggYXQgDQpodHRwczovL2xvcmUua2VybmVsLm9yZy9sa21sLzA3
YzI1YzI0NmM1NTAxMjk4MWVjMDI5NmVlZTIzZTY4YzcxOTMzM2EuY2FtZWxAbWFydmVsbC5jb20v
DQogLg0KDQpJdCBhbGxvd3MgdXNlcnNwYWNlIGFwcGxpY2F0aW9uIHRvIHRha2UgYSBDUFUgY29y
ZSBmb3IgaXRzZWxmIGFuZCBydW4NCmNvbXBsZXRlbHkgaXNvbGF0ZWQsIHdpdGggbm8gZGlzdHVy
YmFuY2VzLiBUaGVyZSBpcyB3b3JrIGluIHByb2dyZXNzDQp0aGF0IGFsc28gZGlzYWJsZXMgYW5k
IHJlLWVuYWJsZXMgVExCIGZsdXNoZXMsIGFuZCBkZXBlbmRpbmcgb24gQ1BVIGl0DQptYXkgYmUg
cG9zc2libGUgdG8gYWxzbyBwcmUtYWxsb2NhdGUgY2FjaGUsIHNvIGl0IHdvdWxkIG5vdCBiZSBh
ZmZlY3RlZA0KYnkgdGhlIHJlc3Qgb2YgdGhlIHN5c3RlbS4gRXZlbnRzIHRoYXQgY2F1c2UgaW50
ZXJhY3Rpb24gd2l0aCBpc29sYXRlZA0KdGFzaywgY2F1c2UgaXNvbGF0aW9uIGJyZWFraW5nLCB0
dXJuaW5nIHRoZSB0YXNrIGludG8gYSByZWd1bGFyDQp1c2Vyc3BhY2UgdGFzayB0aGF0IGNhbiBj
b250aW51ZSBydW5uaW5nIG5vcm1hbGx5IGFuZCBlbnRlciBpc29sYXRlZA0Kc3RhdGUgYWdhaW4g
aWYgbmVjZXNzYXJ5Lg0KDQpUbyBtYWtlIHRoaXMgZmVhdHVyZSBzdWl0YWJsZSBmb3IgYW55IHBy
YWN0aWNhbCB1c2UsIG1hbnkgbWVjaGFuaXNtcw0KdGhhdCBub3JtYWxseSB3b3VsZCBjYXVzZSBl
dmVudHMgb24gYSBDUFUsIHNob3VsZCBleGNsdWRlIENQVSBjb3JlcyBpbg0KdGhpcyBzdGF0ZSwg
YW5kIHN5bmNocm9uaXphdGlvbiBzaG91bGQgaGFwcGVuIGxhdGVyLCBhdCB0aGUgdGltZSBvZg0K
aXNvbGF0aW9uIGJyZWFraW5nLg0KDQpUaGVyZSBhcmUgdGhyZWUgYXJjaGl0ZWN0dXJlcyBzdXBw
b3J0ZWQsIHg4NiwgYXJtIGFuZCBhcm02NCwgYW5kIGl0DQpzaG91bGQgYmUgcG9zc2libGUgdG8g
ZXh0ZW5kIGl0IHRvIG90aGVycy4gVW5mb3J0dW5hdGVseSBrZXJuZWwgZW50cnkNCnByb2NlZHVy
ZXMgYXJlIG5laXRoZXIgdW5pZmllZCwgbm9yIHN0cmFpZ2h0Zm9yd2FyZCwgc28gaW50cm9kdWNp
bmcgbmV3DQpmZWF0dXJlIHRvIHRoZW0gY2F1c2VzIGFuIGFwcGVhcmFuY2Ugb2YgYSBtZXNzLg0K
DQotLSANCkFsZXgNCg==
