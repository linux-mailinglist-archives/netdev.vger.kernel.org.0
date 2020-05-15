Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6ACB1D5910
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 20:28:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726297AbgEOS2a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 14:28:30 -0400
Received: from mail-co1nam11on2122.outbound.protection.outlook.com ([40.107.220.122]:26849
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726197AbgEOS23 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 14:28:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M1/Q0XwfSFkfe8O0pvIp5nugu6LvliySz1Jf+GKVI/y9flrsLTdxkIKOe8vT0TYF6bADTH1m0D9U+cP7T7MP6HaHw3m+tanGeIPFlolb8fwNPZi6/UCOS1h7bwAvMf+Oi0KQa4ShLohww8ARcrBssTF9uzwN2SAWrKBww4u9P6hMDeRBEu28EcZxqF2lHcUTarqMUN8qQytStZLxUuDBmwzmcZXsT/Gf2WBG8ahSRyQNYNl956aJHy+ufTdQEbjCSNlt1yUNSxPYpRT8QrHZpL4Qnw9xzzCvP6a98BX3rbkqEW+1lnNpEzbRkYCWs9Mve2XzbFJohv7f4iEQqm46Wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iA1ihPiBKFgqe1fKLb7Y6dpXxm+uKyCgsfeeWfLOxMs=;
 b=nwO/tv0zeyM+uQQi2IWi0wTwAy0M8m1Gd3eTNjmyG9vVNK5hzFfYd9VwH79IqYmxrpsd9Rb26W2r4nxQfLAp4Eyj7SkR7ERhHpXoR9sbR+g+kURap4/CTfBuKIClMhxQ58JE8BteS6G96g8H48vQdCu3SkXqlthBUdfNQxSLLXb95sINuBcRNFaqgmD7L/PYMJPHc9nGR77vqoE6xq+fpVHFrWbApbrOR/WqZNZHKs/yBbPfiVCZCggfuYXTxXshGLScQnhTdPV6Gk/P9TkRXIWXB4tVxZ8dCURLErdGQ/mR5K85QnVXKiZsvJNu8QIwNNAKY45hegk63oLWAU3RCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 204.77.163.244) smtp.rcpttodomain=hansenpartnership.com
 smtp.mailfrom=garmin.com; dmarc=pass (p=quarantine sp=quarantine pct=100)
 action=none header.from=garmin.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garmin.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iA1ihPiBKFgqe1fKLb7Y6dpXxm+uKyCgsfeeWfLOxMs=;
 b=cR8P1Poz96S1yCi3OVUU5aCsUMvrq+87gLYR8sUlrF563ttv2VYdHhct6owYI2x5eaVhkC+5+OuZ/2vMWw6LQl1y8WuL1meocIVNTH+m3LJ3KwUHjX0KAGY5XmDfRHeE7SnN7+9TCS2qZm7+9D8Fiii7IM3cf5PEj1EzSeye+qvyefZdA+J2RhC6IaQUPxhzt8qrHtWiioyrp2AQja23zdwSuCbPEv+yCAG6YBgg+y1JanKQseU26LRi+iHPrRe37hnTlP78LAd5MS8X3kEMtliaEt2Hn7kN+RQv+8qvIG8prGF2cO1GUV99jG+Nu4dEYQOGV984sHa7XbE+HxSfzA==
Received: from DM5PR17CA0065.namprd17.prod.outlook.com (2603:10b6:3:13f::27)
 by CY4PR04MB0919.namprd04.prod.outlook.com (2603:10b6:910:5b::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.34; Fri, 15 May
 2020 18:28:23 +0000
Received: from DM6NAM10FT006.eop-nam10.prod.protection.outlook.com
 (2603:10b6:3:13f:cafe::ed) by DM5PR17CA0065.outlook.office365.com
 (2603:10b6:3:13f::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.24 via Frontend
 Transport; Fri, 15 May 2020 18:28:23 +0000
Authentication-Results: spf=pass (sender IP is 204.77.163.244)
 smtp.mailfrom=garmin.com; HansenPartnership.com; dkim=none (message not
 signed) header.d=none;HansenPartnership.com; dmarc=pass action=none
 header.from=garmin.com;
Received-SPF: Pass (protection.outlook.com: domain of garmin.com designates
 204.77.163.244 as permitted sender) receiver=protection.outlook.com;
 client-ip=204.77.163.244; helo=edgetransport.garmin.com;
Received: from edgetransport.garmin.com (204.77.163.244) by
 DM6NAM10FT006.mail.protection.outlook.com (10.13.153.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3000.19 via Frontend Transport; Fri, 15 May 2020 18:28:22 +0000
Received: from OLAWPA-EXMB3.ad.garmin.com (10.5.144.15) by
 olawpa-edge5.garmin.com (10.60.4.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.1466.3; Fri, 15 May 2020 13:28:20 -0500
Received: from OLAWPA-EXMB7.ad.garmin.com (10.5.144.21) by
 OLAWPA-EXMB3.ad.garmin.com (10.5.144.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Fri, 15 May 2020 13:28:21 -0500
Received: from OLAWPA-EXMB7.ad.garmin.com ([fe80::68cc:dab9:e96a:c89]) by
 OLAWPA-EXMB7.ad.garmin.com ([fe80::68cc:dab9:e96a:c89%23]) with mapi id
 15.01.1913.007; Fri, 15 May 2020 13:28:21 -0500
From:   "Karstens, Nate" <Nate.Karstens@garmin.com>
To:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        Matthew Wilcox <willy@infradead.org>
CC:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Jeff Layton <jlayton@kernel.org>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>, Helge Deller <deller@gmx.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        David Laight <David.Laight@aculab.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-alpha@vger.kernel.org" <linux-alpha@vger.kernel.org>,
        "linux-parisc@vger.kernel.org" <linux-parisc@vger.kernel.org>,
        "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Changli Gao <xiaosuo@gmail.com>,
        "a.josey@opengroup.org" <a.josey@opengroup.org>
Subject: RE: [PATCH v2] Implement close-on-fork
Thread-Topic: [PATCH v2] Implement close-on-fork
Thread-Index: AQHWKtGJQW28Wposd0uF0sb7I7R5yaipTiDwgABbDAD//8IccA==
Date:   Fri, 15 May 2020 18:28:20 +0000
Message-ID: <4964fe0ccdf7495daf4045c195b14ed6@garmin.com>
References: <20200515152321.9280-1-nate.karstens@garmin.com>
         <20200515155730.GF16070@bombadil.infradead.org>
         <5b1929aa9f424e689c7f430663891827@garmin.com>
 <1589559950.3653.11.camel@HansenPartnership.com>
In-Reply-To: <1589559950.3653.11.camel@HansenPartnership.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.50.4.7]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25422.001
X-TM-AS-Result: No-24.660800-8.000000-10
X-TMASE-MatchedRID: 8HTFlOrbAtFjFj/UuKzq9Qm6mWzI013H+KgiyLtJrSBsMPuLZB/IRyaC
        jkFKp/+evR2IGXL11cAbfdh3Hrbds2bR7KDoJhGbN19PjPJahlK0UsBMUGKgfnN4oJrDvdmBnM1
        dYeGe93EBL2g6g557BbhV7es37XUhsJNnHjvcOolFM72aEhcbjcV0QyhMrtsxEt/W/Pt5w8c3YX
        JtvKOnOVl7IU/aBS0GS9KN/ejlLD70nMCL2lyVdnpRh12Siy9rz2Mm4Q3wKRsy/xh6GqNHVSg77
        wugamceSjUZtWeiLnmEDhdS1weMH6gZIrutfM9NMIxbvM3AVog5iooXtStiHvPG92V4Sj8j5Fn6
        Wz/jziF4hguXBP/sxySlqWcgaF36PTsJ3Tg6TUU4zuezdSAFjVoR8WAKiZ2PipwWNGS5ADgwV12
        /6ktutzd5TYrunab88q5GINhvEEAnmCeHyLMZHuIfK/Jd5eHmL7DjpoDqNZnR8qSEccyfO5t+T6
        w9CMQiVH79j+f18/U1La7l+470Uu7Gghg9I/XgB/XUnmGGOOrLRD51bz5RZCLT+St7cam6m/w4E
        oYoYmuNoxD32zE0Ft23HqVai7RF52/pxZx2tzRTL5B6BWU2DXpxIzIwLRluHdFjikZMLIdk6DvI
        SydC9/gqvgaKLRVbpJO1Fs6p7s7yha4uErRN/X4neC0h7SAD9zefYQcHZp8oglbEnCQoca5Pqqb
        CfIUPTAK2sVwEDfY9Wev+qZL2rj1iiwOv4P/78eSmTJSmEv1nbl5PcviP9PHSsb509cZ3LPJtWp
        bJjY3AR2ZLBV/mk4lCcfGIeGsgJ+JZYQfxoHyeAiCmPx4NwMFrpUbb72MU1kTfEkyaZdz6C0ePs
        7A07YVH0dq7wY7uA/3R8k/14e0=
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--24.660800-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25422.001
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:204.77.163.244;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:edgetransport.garmin.com;PTR:extedge.garmin.com;CAT:NONE;SFTY:;SFS:(39860400002)(136003)(346002)(396003)(376002)(46966005)(110136005)(54906003)(108616005)(82310400002)(2616005)(8676002)(316002)(7696005)(36756003)(426003)(53546011)(2906002)(47076004)(7636003)(24736004)(356005)(82740400003)(86362001)(478600001)(5660300002)(186003)(4326008)(336012)(7416002)(26005)(70586007)(966005)(70206006)(8936002);DIR:OUT;SFP:1102;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0ed33752-dfff-45b4-5de2-08d7f8fdbfd1
X-MS-TrafficTypeDiagnostic: CY4PR04MB0919:
X-Microsoft-Antispam-PRVS: <CY4PR04MB09191D8E26F495FBE67D6C879CBD0@CY4PR04MB0919.namprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 04041A2886
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zDbVoe/wvHcFcTc81XOZj/iDASHrjjUv/9EZ3qSyvIgCp5LKGDeQf7yzt8CCEjozBNS8DJJjU9GFZYB7LwjBbz/lj3EiYfdqOEYCpQljFYE2sxmdAG4f5nN+/Met7HbaMTy88wyS5oRiSmdQuUQoRYAmn8R36ioNWfF4tedS6nqMO93jkRWUXdO3eJ58rJXd7KiL5k373Xvy2E13H0P4rlvtztgbM52jCZ+bza6mbRTn1NDkPq9nr0si9Up4TzFmJLFJ2k85jMP3B5cRnatxTZ2P2AnAXcjTqxy4SrHw9iwHyI0RjxvHWwbAW7vLiC9RFzmfp+srcwQRti/9vDTxij0DZJuG1fAcvdJbHPydOEyNG7xy9LHgCNXZQg6T8I7lPfo9s4yIfRWn47jZcwakTeVB9J3DqRqhvPhOvUTw+ehP6mMh/80/TM6ubH2ErXtTB4F0lqRSbIWzr8N415at0wBKF5LDROBXSrslyIbHfLnV+pHlVZeWDa237+xD/CaEF10RHEEam8ZW4uBDUVFOivq6FP/4h8+l0bH1ETVCVWrHuHIuaCmVpo0Wfcqt7/nJ5MLbcyHKuKHaCWnz9T+59Q==
X-OriginatorOrg: garmin.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2020 18:28:22.3748
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ed33752-dfff-45b4-5de2-08d7f8fdbfd1
X-MS-Exchange-CrossTenant-Id: 38d0d425-ba52-4c0a-a03e-2a65c8e82e2d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=38d0d425-ba52-4c0a-a03e-2a65c8e82e2d;Ip=[204.77.163.244];Helo=[edgetransport.garmin.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR04MB0919
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SmFtZXMsDQoNClNvcnJ5LCBwZXJoYXBzIEkgd2FzIGluZGlyZWN0LCBidXQgSSB0aG91Z2h0IEkg
aGFkIHJlc3BvbmRlZCB0byB0aGF0IGluIGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xpbnV4LWZz
ZGV2ZWwvZGU2YWRjZTc2YjUzNDMxMDk3NWU0ZDNjNGE0ZmFjYjJAZ2FybWluLmNvbS8uDQoNCkkg
cmVhbGx5IGhvcGUgSSBkbyBub3QgY29tZSBvZmYgYXMgY29tcGxhaW5pbmcgYWJvdXQgdGhpcyBp
c3N1ZS4gV2UgaWRlbnRpZmllZCB3aGF0IHNlZW1lZCB0byBiZSBzb21ldGhpbmcgdGhhdCB3YXMg
b3Zlcmxvb2tlZCB3aXRoIHRoZSB2YXJpb3VzIEFQSXMgYXJvdW5kIGNyZWF0aW5nIGNoaWxkIHBy
b2Nlc3Nlcy4gUmF0aGVyIHRoYW4gZml4aW5nIGl0IG91cnNlbHZlcyBhbmQgbW92aW5nIG9uIHdl
IGNob3NlIHRvIGludmVzdCBtb3JlIHRpbWUgYW5kIGVmZm9ydCBpbnRvIGl0IGJ5IGVuZ2FnaW5n
IHRoZSBjb21tdW5pdHkgKGZpcnN0IFBPU0lYLCBhbmQgbm93IHRoaXMgb25lKSBpbiBhIGRpc2N1
c3Npb24uIEkgaHVtYmx5IGFuZCBzaW5jZXJlbHkgYXNrIGlmIHlvdSB3b3VsZCBoZWxwIG1lIHVu
ZGVyc3RhbmQsIGlmIHdlIGNvdWxkIHR1cm4gYmFjayB0aGUgY2xvY2ssIGhvdyBvdXIgYXBwbGlj
YXRpb24gY291bGQgaGF2ZSBiZWVuIHdyaXR0ZW4gdG8gYXZvaWQgdGhpcyBpc3N1ZToNCg0KKkEg
cGFyZW50IHByb2Nlc3MgZm9ya3MgYSBjaGlsZC4gQW5vdGhlciB0aHJlYWQgaW4gdGhlIHBhcmVu
dCBwcm9jZXNzIGNsb3NlcyBhbmQgYXR0ZW1wdHMgdG8gcmVvcGVuIGEgc29ja2V0LCBmaWxlLCBv
ciBvdGhlciByZXNvdXJjZSBpdCBuZWVkcyBleGNsdXNpdmUgYWNjZXNzIHRvLiBUaGlzIGZhaWxz
IGJlY2F1c2UgdGhlIC1vcGVyYXRpbmcgc3lzdGVtLSBzdGlsbCBoYXMgYSByZWZlcmVuY2UgdG8g
dGhhdCByZXNvdXJjZSB0aGF0IGl0IGlzIGtlZXBpbmcgb24gYmVoYWxmIG9mIHRoZSBjaGlsZC4g
VGhlIGNoaWxkIGV2ZW50dWFsbHkgY2FsbHMgZXhlYyBhbmQgdGhlIHJlc291cmNlIGlzIGNsb3Nl
ZCBiZWNhdXNlIHRoZSBjbG9zZS1vbi1leGVjIGZsYWcgaXMgc2V0LioNCg0KT3VyIGZpcnN0IGF0
dGVtcHQsIHdoaWNoIHdhcyB0byB1c2UgdGhlIHB0aHJlYWRfYXRmb3JrKCkgaGFuZGxlcnMsIGZh
aWxlZCBiZWNhdXNlIHN5c3RlbSgpIGlzIG5vdCByZXF1aXJlZCB0byBjYWxsIHRoZSBoYW5kbGVy
cy4NCg0KTW9zdCBvZiB0aGUgZmVlZGJhY2sgd2UncmUgZ2V0dGluZyBvbiB0aGlzIHNlZW1zIHRv
IHNheSAiZG9uJ3QgdXNlIHN5c3RlbSgpLCBpdCBpcyB1bnNhZmUgZm9yIHRocmVhZGVkIGFwcGxp
Y2F0aW9ucyIuIElzIHRoYXQgZG9jdW1lbnRlZCBhbnl3aGVyZT8gVGhlIG1hbiBwYWdlIHNheXMg
aXQgaXMgIk1ULVNhZmUiLg0KDQpBc2lkZSBmcm9tIHRoYXQsIGV2ZW4gaWYgd2UgcmVtb3ZlIGFs
bCB1c2VzIG9mIHN5c3RlbSgpIGZyb20gb3VyIGFwcGxpY2F0aW9uICh3aGljaCB3ZSBhbHJlYWR5
IGhhdmUpLCB0aGVuIG91ciBhcHBsaWNhdGlvbiwgbGlrZSBtYW55IG90aGVyIGFwcGxpY2F0aW9u
cywgbmVlZHMgdG8gdXNlIHRoaXJkLXBhcnR5IHNoYXJlZCBsaWJyYXJpZXMuIFRoZXJlIGlzIG5v
dGhpbmcgdGhhdCBwcmV2ZW50cyB0aG9zZSBsaWJyYXJpZXMgZnJvbSB1c2luZyBzeXN0ZW0oKS4g
V2UgY2FuIGF1ZGl0IHRob3NlIGxpYnJhcmllcyBhbmQgZ28gYmFjayB3aXRoIHRoZSB2ZW5kb3Ig
d2l0aCBhIHJlcXVlc3QgdG8gcmVwbGFjZSBzeXN0ZW0oKSB3aXRoIGEgc3RhbmRhcmQgZm9yay9l
eGVjLCBidXQgdGhleSB3aWxsIGFsc28gd2FudCBkb2N1bWVudGF0aW9uIHN1cHBvcnRpbmcgdGhh
dC4NCg0KV2UgY2FuIGFsc28gdGFrZSBzdGVwcyB0byBjaGFuZ2Ugb3IgcmVtb3ZlIHN5c3RlbSgp
IGZyb20gb3VyIHN0YW5kYXJkIGxpYnJhcnkuIEl0IGZpeGVzIG91ciBpc3N1ZSwgYnV0IHN0aWxs
IGxlYXZlcyB0aGUgY29tbXVuaXR5IHdpdGggYW4gQVBJIHRoYXQgaXMgYnJva2VuL2ZsYXdlZC9w
b29ybHktZG9jdW1lbnRlZCAoZGVwZW5kaW5nIG9uIGhvdyBvbmUgbG9va3MgYXQgaXQpLg0KDQpJ
ZiB0aGUgZmVlZGJhY2sgZnJvbSB0aGUgY29tbXVuaXR5IGlzIHRydWx5IGFuZCBmaW5hbGx5IHRo
YXQgc3lzdGVtKCkgc2hvdWxkIG5vdCBiZSB1c2VkIGluIHRoZXNlIGFwcGxpY2F0aW9ucywgdGhl
biBpcyB0aGVyZSBzdXBwb3J0IGZvciB1cGRhdGluZyB0aGUgbWFuIHBhZ2UgdG8gYmV0dGVyIGNv
bW11bmljYXRlIHRoYXQ/DQoNClRoYW5rcyBmb3IgeW91ciBoZWxwIHdpdGggdGhpcy4NCg0KTmF0
ZQ0KDQotLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KRnJvbTogSmFtZXMgQm90dG9tbGV5IDxK
YW1lcy5Cb3R0b21sZXlASGFuc2VuUGFydG5lcnNoaXAuY29tPg0KU2VudDogRnJpZGF5LCBNYXkg
MTUsIDIwMjAgMTE6MjYNClRvOiBLYXJzdGVucywgTmF0ZSA8TmF0ZS5LYXJzdGVuc0BnYXJtaW4u
Y29tPjsgTWF0dGhldyBXaWxjb3ggPHdpbGx5QGluZnJhZGVhZC5vcmc+DQpDYzogQWxleGFuZGVy
IFZpcm8gPHZpcm9AemVuaXYubGludXgub3JnLnVrPjsgSmVmZiBMYXl0b24gPGpsYXl0b25Aa2Vy
bmVsLm9yZz47IEouIEJydWNlIEZpZWxkcyA8YmZpZWxkc0BmaWVsZHNlcy5vcmc+OyBBcm5kIEJl
cmdtYW5uIDxhcm5kQGFybmRiLmRlPjsgUmljaGFyZCBIZW5kZXJzb24gPHJ0aEB0d2lkZGxlLm5l
dD47IEl2YW4gS29rc2hheXNreSA8aW5rQGp1cmFzc2ljLnBhcmsubXN1LnJ1PjsgTWF0dCBUdXJu
ZXIgPG1hdHRzdDg4QGdtYWlsLmNvbT47IEhlbGdlIERlbGxlciA8ZGVsbGVyQGdteC5kZT47IERh
dmlkIFMuIE1pbGxlciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47IEpha3ViIEtpY2luc2tpIDxrdWJh
QGtlcm5lbC5vcmc+OyBFcmljIER1bWF6ZXQgPGVkdW1hemV0QGdvb2dsZS5jb20+OyBEYXZpZCBM
YWlnaHQgPERhdmlkLkxhaWdodEBhY3VsYWIuY29tPjsgbGludXgtZnNkZXZlbEB2Z2VyLmtlcm5l
bC5vcmc7IGxpbnV4LWFyY2hAdmdlci5rZXJuZWwub3JnOyBsaW51eC1hbHBoYUB2Z2VyLmtlcm5l
bC5vcmc7IGxpbnV4LXBhcmlzY0B2Z2VyLmtlcm5lbC5vcmc7IHNwYXJjbGludXhAdmdlci5rZXJu
ZWwub3JnOyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwu
b3JnOyBDaGFuZ2xpIEdhbyA8eGlhb3N1b0BnbWFpbC5jb20+OyBhLmpvc2V5QG9wZW5ncm91cC5v
cmcNClN1YmplY3Q6IFJlOiBbUEFUQ0ggdjJdIEltcGxlbWVudCBjbG9zZS1vbi1mb3JrDQoNCkNB
VVRJT04gLSBFWFRFUk5BTCBFTUFJTDogRG8gbm90IGNsaWNrIGFueSBsaW5rcyBvciBvcGVuIGFu
eSBhdHRhY2htZW50cyB1bmxlc3MgeW91IHRydXN0IHRoZSBzZW5kZXIgYW5kIGtub3cgdGhlIGNv
bnRlbnQgaXMgc2FmZS4NCg0KDQpPbiBGcmksIDIwMjAtMDUtMTUgYXQgMTY6MDcgKzAwMDAsIEth
cnN0ZW5zLCBOYXRlIHdyb3RlOg0KPiBNYXR0aGV3LA0KPg0KPiBXaGF0IGFsdGVybmF0aXZlIHdv
dWxkIHlvdSBzdWdnZXN0Pw0KPg0KPiBGcm9tIGFuIGVhcmxpZXIgZW1haWw6DQo+DQo+ID4gLi4u
bm90aGluZyBlbHNlIGFkZHJlc3NlcyB0aGUgdW5kZXJseWluZyBpc3N1ZTogdGhlcmUgaXMgbm8g
d2F5IHRvDQo+ID4gcHJldmVudCBhIGZvcmsoKSBmcm9tIGR1cGxpY2F0aW5nIHRoZSByZXNvdXJj
ZS4gVGhlIGNsb3NlLW9uLWV4ZWMNCj4gPiBmbGFnIHBhcnRpYWxseS1hZGRyZXNzZXMgdGhpcyBi
eSBhbGxvd2luZyB0aGUgcGFyZW50IHByb2Nlc3MgdG8gbWFyaw0KPiA+IGEgZmlsZSBkZXNjcmlw
dG9yIGFzIGV4Y2x1c2l2ZSB0byBpdHNlbGYsIGJ1dCB0aGVyZSBpcyBzdGlsbCBhDQo+ID4gcGVy
aW9kIG9mIHRpbWUgdGhlIGZhaWx1cmUgY2FuIG9jY3VyIGJlY2F1c2UgdGhlIGF1dG8tY2xvc2Ug
b25seQ0KPiA+IG9jY3VycyBkdXJpbmcgdGhlIGV4ZWMoKS4gUGVyaGFwcyB0aGlzIHdvdWxkIG5v
dCBiZSBhbiBpc3N1ZSB3aXRoIGENCj4gPiBkaWZmZXJlbnQgcHJvY2Vzcy90aHJlYWRpbmcgbW9k
ZWwsIGJ1dCB0aGF0IGlzIGFub3RoZXIgZGlzY3Vzc2lvbg0KPiA+IGVudGlyZWx5Lg0KPg0KPiBE
byB5b3UgZGlzYWdyZWUgdGhlcmUgaXMgYW4gaXNzdWU/DQoNCk9oIGdvb2QgZ3JpZWYgdGhhdCdz
IGEgbGVhZGluZyBxdWVzdGlvbjogV2hlbiBJIHdyaXRlIGJhZCBjb2RlIGFuZCBpdCBjcmFzaGVz
LCBtb3N0IHBlb3BsZSB3b3VsZCBhZ3JlZSB0aGVyZSBpcyBhbiBpc3N1ZTsgdmVyeSBmZXcgd291
bGQgYWdyZWUgdGhlIGtlcm5lbCBzaG91bGQgYmUgY2hhbmdlZCB0byBmaXggaXQuIFNldmVyYWwg
b2YgdXMgaGF2ZSBhbHJlYWR5IHNhaWQgdGhlIHByb2JsZW0gc2VlbXMgdG8gYmUgd2l0aCB0aGUg
d2F5IHlvdXIgYXBwbGljYXRpb24gaXMgd3JpdHRlbi4gIFlvdSBkaWRuJ3QgZXZlbiBhbnN3ZXIg
ZW1haWxzIGxpa2UgdGhpcyBzcGVjdWxhdGluZyBhYm91dCB0aGUgY2F1c2UgYmVpbmcgdGhlIHdh
eSB5b3VyIGFwcGxpY2F0aW9uIGNvdW50cyByZXNvdXJjZXM6DQoNCmh0dHBzOi8vbG9yZS5rZXJu
ZWwub3JnL2xpbnV4LWZzZGV2ZWwvMTU4NzU2OTY2My4zNDg1LjE4LmNhbWVsQEhhbnNlblBhcnRu
ZXJzaGlwLmNvbS8NCg0KVGhlIGJvdHRvbSBsaW5lIGlzIHRoYXQgd2UgdGhpbmsgeW91IGNvdWxk
IHJld3JpdGUgdGhpcyBvbmUgYXBwbGljYXRpb24gbm90IHRvIGhhdmUgdGhlIHByb2JsZW0geW91
J3JlIGNvbXBsYWluaW5nIGFib3V0IHJhdGhlciB0aGFuIGludHJvZHVjZSBhIG5ldyBrZXJuZWwg
QVBJIHRvICJmaXgiIGl0Lg0KDQpKYW1lcw0KDQoNCg0KDQpfX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fXw0KDQpDT05GSURFTlRJQUxJVFkgTk9USUNFOiBUaGlzIGVtYWlsIGFuZCBhbnkg
YXR0YWNobWVudHMgYXJlIGZvciB0aGUgc29sZSB1c2Ugb2YgdGhlIGludGVuZGVkIHJlY2lwaWVu
dChzKSBhbmQgY29udGFpbiBpbmZvcm1hdGlvbiB0aGF0IG1heSBiZSBHYXJtaW4gY29uZmlkZW50
aWFsIGFuZC9vciBHYXJtaW4gbGVnYWxseSBwcml2aWxlZ2VkLiBJZiB5b3UgaGF2ZSByZWNlaXZl
ZCB0aGlzIGVtYWlsIGluIGVycm9yLCBwbGVhc2Ugbm90aWZ5IHRoZSBzZW5kZXIgYnkgcmVwbHkg
ZW1haWwgYW5kIGRlbGV0ZSB0aGUgbWVzc2FnZS4gQW55IGRpc2Nsb3N1cmUsIGNvcHlpbmcsIGRp
c3RyaWJ1dGlvbiBvciB1c2Ugb2YgdGhpcyBjb21tdW5pY2F0aW9uIChpbmNsdWRpbmcgYXR0YWNo
bWVudHMpIGJ5IHNvbWVvbmUgb3RoZXIgdGhhbiB0aGUgaW50ZW5kZWQgcmVjaXBpZW50IGlzIHBy
b2hpYml0ZWQuIFRoYW5rIHlvdS4NCg==
