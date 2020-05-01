Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56E8F1C183C
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 16:47:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729867AbgEAOpj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 10:45:39 -0400
Received: from mail-mw2nam10on2100.outbound.protection.outlook.com ([40.107.94.100]:53792
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728929AbgEAOpX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 May 2020 10:45:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IL4o83xRXAXQKp4Kl2hGNd921rfVdoFkz1LBI3CDW11NIec1DrwmjChPg9Qs6OvoIupg9JmSsZnbkvTFLjHdf8QoAIs2TUjqe7r4w+mIGes601sZp1XvMVU9Nd3/GvcpXvBfDSzUVLJHBaaG0Tqa2WcsF50/FrZPqINTIg9ssNnilF2OMGnVk6NirXjI8RSuVEw7O7jIyIpKg2Gk6h09M8T6/TKQWM41JkeyzY7uhJgCjF0OWeiSg4egj2XWHf66/SouUKTFy+De0L/MrKkQa3Ajfo64P5gCGH2ckxj1hzYXb6sHSg1w5N5H5Vp2MjpZTRbuXlGSQQ4TGEKabs9DdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iESgZOnK8SZKK6FXkXpC5ktu51akSyOH622vuGDzIXI=;
 b=SXUnX6WdBmsSgaH4FsKiWLhbHzU1IP7UV/Iq9gkJ0oqVhPnG7M+hLb3Qa4/UQLpg2b+31R0Dw/o/a13AM6zhl0val6E+3eut/eIkMfJQM7Wo89VBfhGqOnlgZD5LlqxT0D9jD85HUx36LASwD6XZLOnAWa7AISDJxzsB47uY5tHWMsJWq7z3nGBzSypxh33wI7GhRZImvOz18BcoYImnlMByGxxqHDSauR029+tPA/WaFK9B/xHZERsY3qv3uiKC7vIAZR6Cxou26B9ErdhuvFegv8G0B4V5yX1N6b0NFh3XvaC59bpqhDgSYw+D1qUJXFZpUjNrM1zvaIMC48BaVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 204.77.163.244) smtp.rcpttodomain=gmail.com smtp.mailfrom=garmin.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=garmin.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garmin.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iESgZOnK8SZKK6FXkXpC5ktu51akSyOH622vuGDzIXI=;
 b=P/AlArPQ9y+C6eY3MAmb6yyOy9+aOUCBW6H/KRDTmuquAjCgKxZRF2iZz6G4JxjBkT04nLslShPAZ9QJ2By4EbzALQrGzk/wNpfP4iRf0Y1k6zADQbUWh5UHQWBOwO0I7/+dfBUcW2Y4PlWfIAem1p6YmfpY9IbP+ECTu00aDL8NKvQghMqiVM+qdAb6m0BGZSnYnTGM82Ec547da7kIOV0Ac8wpllXMH0P0PYJOjqw9UOviQVIgUBmmr0OKep5dc1NKw6qCoMnnoVbn/NV2sEVPbFrjMbQa4T9hiF8hOYTK2nZ5ZxKYD+uKKNuWqFM9bi+DJc0gBEi9ysbK8tM8Ow==
Received: from DM5PR07CA0026.namprd07.prod.outlook.com (2603:10b6:3:16::12) by
 DM6PR04MB5881.namprd04.prod.outlook.com (2603:10b6:5:164::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2958.20; Fri, 1 May 2020 14:45:18 +0000
Received: from DM6NAM10FT064.eop-nam10.prod.protection.outlook.com
 (2603:10b6:3:16:cafe::3d) by DM5PR07CA0026.outlook.office365.com
 (2603:10b6:3:16::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend
 Transport; Fri, 1 May 2020 14:45:18 +0000
Authentication-Results: spf=pass (sender IP is 204.77.163.244)
 smtp.mailfrom=garmin.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=pass action=none header.from=garmin.com;
Received-SPF: Pass (protection.outlook.com: domain of garmin.com designates
 204.77.163.244 as permitted sender) receiver=protection.outlook.com;
 client-ip=204.77.163.244; helo=edgetransport.garmin.com;
Received: from edgetransport.garmin.com (204.77.163.244) by
 DM6NAM10FT064.mail.protection.outlook.com (10.13.152.218) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2958.20 via Frontend Transport; Fri, 1 May 2020 14:45:18 +0000
Received: from OLAWPA-EXMB8.ad.garmin.com (10.5.144.18) by
 olawpa-edge1.garmin.com (10.60.4.227) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1466.3; Fri, 1 May 2020 09:45:16 -0500
Received: from OLAWPA-EXMB7.ad.garmin.com (10.5.144.21) by
 OLAWPA-EXMB8.ad.garmin.com (10.5.144.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Fri, 1 May 2020 09:45:16 -0500
Received: from OLAWPA-EXMB7.ad.garmin.com ([fe80::68cc:dab9:e96a:c89]) by
 OLAWPA-EXMB7.ad.garmin.com ([fe80::68cc:dab9:e96a:c89%23]) with mapi id
 15.01.1913.007; Fri, 1 May 2020 09:45:16 -0500
From:   "Karstens, Nate" <Nate.Karstens@garmin.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jeff Layton <jlayton@kernel.org>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "Richard Henderson" <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Helge Deller <deller@gmx.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-alpha@vger.kernel.org" <linux-alpha@vger.kernel.org>,
        "linux-parisc@vger.kernel.org" <linux-parisc@vger.kernel.org>,
        "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     Changli Gao <xiaosuo@gmail.com>
Subject: RE: [PATCH 1/4] fs: Implement close-on-fork
Thread-Topic: [PATCH 1/4] fs: Implement close-on-fork
Thread-Index: AQHWFuOUNQrmUX2/BU6CQ6OUTp2yNKiCIimAgBEzlAA=
Date:   Fri, 1 May 2020 14:45:16 +0000
Message-ID: <0e884704c25740df8e652d50431facff@garmin.com>
References: <20200420071548.62112-1-nate.karstens@garmin.com>
 <20200420071548.62112-2-nate.karstens@garmin.com>
 <36dce9b4-a0bf-0015-f6bc-1006938545b1@gmail.com>
In-Reply-To: <36dce9b4-a0bf-0015-f6bc-1006938545b1@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.50.4.6]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25390.000
X-TM-AS-Result: No-24.071700-8.000000-10
X-TMASE-MatchedRID: 0+daXaNUWRWWFjFUJMrS41VeGWZmxN2MDKCEVfSXEXCaoyD8Xyl5JIu3
        renu5Y0wb722MFshFhiFdNiMjK9VDMqHIZzMU5Pj5Qo03mEdwAEA+JHhu0IR5j2cdopIjrPd8FS
        rkmy6/FLPSw+FV3q6pRNokrSOxcyYJ97RPj0PB2jFW296Y1uTJ+dppbZRNp/IMTkWY9HYyZEmNh
        b+NkYsr9KAj3QfSifdwpvu0an2gbWd2Z1BQDgOR02rn9j60W9bpNh/2/1+WiUutoY2UtFqGLIr+
        2b8PDJe2cNhLWr7qIJi6yyJvUJoxfxcXzlUQt0odVBIc4k/qdDESSxPxTa9g8BF4q457Pt+fy8S
        UsrzkMdZuyI+2J7/4pgmblWk1biVskDMZvejsngl05wGZISn5YdVU3k8UmpRLpmXl9ViEPDAnfG
        p+0jdAZ3hrH+SaxDBo07jnJDzx4pIL8dxyyZLfyfphWrcxCwjnigQ/9LjZDZemWwoCXDj9R7txg
        U9EMOT8etKVnt/PHbe6fV3r3qAAPkI7jWhozyPhQwmwdAU7bIBmf/gD11vZAaYevV4zG3ZlcHMC
        yWAI7PXKTbTa66f9qDP9tXPYHQRHgUQvH8xDPTTbR5agAsD1ysg/VvQWOjWi8VrlddQxsbkmbDh
        4tO4BEVguyk3ovIN+9AI+LLwgRxC/bXMk2XQLIMbH85DUZXySdusL1E/4lEFOa0P4w2W6vcUt5l
        c1lLgtT4piLWpY7p+3BndfXUhXQ==
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--24.071700-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25390.000
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:204.77.163.244;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:edgetransport.garmin.com;PTR:extedge.garmin.com;CAT:NONE;SFTY:;SFS:(396003)(39860400002)(376002)(346002)(136003)(46966005)(47076004)(336012)(82740400003)(426003)(356005)(82310400002)(2616005)(24736004)(316002)(4326008)(7696005)(108616005)(7416002)(7636003)(186003)(53546011)(5660300002)(26005)(110136005)(36756003)(2906002)(8936002)(478600001)(70586007)(70206006)(86362001)(8676002)(921003);DIR:OUT;SFP:1102;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f10af3dc-042f-4d38-11ba-08d7edde4455
X-MS-TrafficTypeDiagnostic: DM6PR04MB5881:
X-Microsoft-Antispam-PRVS: <DM6PR04MB5881731A6E874B9700C2A6C19CAB0@DM6PR04MB5881.namprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0390DB4BDA
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rIp+o6nHihtoWJiEv39kdhdsnPJCICfIkKwsY769BSpXsmoebIGFvRW7p36du3k0JauGzDAvhSdlmCxrMKF6AAlexT3nGPHRY4x3gvJ+tQzh5bTzDo6XQmztk3JojegWsqn49GPai3vZiqCfhB4IxpA+3CBpjR7VIqKdzi03pIA3ST8dyttQBltmPv0jZ4Txw7pTK/Z94DC7xqfl8yXAZi0H5CHD8kOkysRNCkhN63hbmwg3Du9AQUPwRg7ooOnMWfEDVUHJP1ZJEpIP9adyxUAmUVGuPWZU19gX+mHYJ8MwYxk0BO0KVSn9jSr/BI5CgCpwI/T8KZJL/Ib+US2Krv6P4s71fmq8mtNvba0izlDwORVaQ7392cgtlpt+kbSveIqEXWgtrkb6txO9mFeIvWSF/hdP6SNpF1LGcmm4GjfUvy//n8Qv9a1Iwgcrg1rK9Je/j/BA398wEXC5i3Xw4yeJ3FBpKQW+qaOxX3PTfh1ZJ1zWU6y3UyRIbH8L6NtXjw/BzMvjoAZ+Cc3xtX8fmMs+I7IGC4xSqPg4/T5h+xc=
X-OriginatorOrg: garmin.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2020 14:45:18.0103
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f10af3dc-042f-4d38-11ba-08d7edde4455
X-MS-Exchange-CrossTenant-Id: 38d0d425-ba52-4c0a-a03e-2a65c8e82e2d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=38d0d425-ba52-4c0a-a03e-2a65c8e82e2d;Ip=[204.77.163.244];Helo=[edgetransport.garmin.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5881
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RXJpYywNCg0KVGhhbmtzIGZvciB0aGUgc3VnZ2VzdGlvbi4gSSBsb29rZWQgaW50byBpdCBhbmQg
bm90aWNlZCB0aGF0IGRvX2Nsb3NlX29uX2V4ZWMoKSBhcHBlYXJzIHRvIGhhdmUgc29tZSBvcHRp
bWl6YXRpb25zIGFzIHdlbGw6DQoNCj4gc2V0ID0gZmR0LT5jbG9zZV9vbl9leGVjW2ldOw0KPiBp
ZiAoIXNldCkNCj4gCWNvbnRpbnVlOyANCg0KSWYgd2UgaW50ZXJsZWF2ZSB0aGUgY2xvc2Utb24t
ZXhlYyBhbmQgY2xvc2Utb24tZm9yayBmbGFncyB0aGVuIHRoaXMgb3B0aW1pemF0aW9uIHdpbGwg
aGF2ZSB0byBiZSByZW1vdmVkLiBEbyB5b3UgaGF2ZSBhIHNlbnNlIG9mIHdoaWNoIG9wdGltaXph
dGlvbiBwcm92aWRlcyB0aGUgbW9zdCBiZW5lZml0Pw0KDQpJIG5vdGljZWQgYSBjb3VwbGUgb2Yg
b3RoZXIgaXNzdWVzIHdpdGggdGhlIG9yaWdpbmFsIHBhdGNoIHRoYXQgSSB3aWxsIG5lZWQgdG8g
aW52ZXN0aWdhdGUgb3IgcmV3b3JrOg0KDQoxKSBJJ20gbm90IHN1cmUgZHVwX2ZkKCkgaXMgdGhl
IGJlc3QgcGxhY2UgdG8gY2hlY2sgdGhlIGNsb3NlLW9uLWZvcmsgZmxhZy4gRm9yIGV4YW1wbGUs
IHRoZSBrc3lzX3Vuc2hhcmUoKSA+IHVuc2hhcmVfZmQoKSA+IGR1cF9mZCgpIGV4ZWN1dGlvbiBw
YXRoIHNlZW1zIHN1c3BlY3QuIEkgd2lsbCBlaXRoZXIgYWRkIGEgcGFyYW1ldGVyIHRvIHRoZSBm
dW5jdGlvbiBpbmRpY2F0aW5nIGlmIHRoZSBmbGFnIHNob3VsZCBiZSBjaGVja2VkIG9yIGRvIGEg
c2VwYXJhdGUgZnVuY3Rpb24sIGxpa2UgZG9fY2xvc2Vfb25fZm9yaygpLg0KMikgSWYgdGhlIGNs
b3NlLW9uLWZvcmsgZmxhZyBpcyBzZXQsIHRoZW4gX19jbGVhcl9vcGVuX2ZkKCkgc2hvdWxkIGJl
IGNhbGxlZCBpbnN0ZWFkIG9mIGp1c3QgX19jbGVhcl9iaXQoKS4gVGhpcyB3aWxsIGVuc3VyZSB0
aGF0IGZkdC0+ZnVsbF9mZHNfYml0cygpIGlzIHVwZGF0ZWQuDQozKSBOZWVkIHRvIGludmVzdGln
YXRlIGlmIHRoZSBjbG9zZS1vbi1mb3JrIChvciBjbG9zZS1vbi1leGVjKSBmbGFncyBuZWVkIHRv
IGJlIGNsZWFyZWQgd2hlbiB0aGUgZmlsZSBpcyBjbG9zZWQgYXMgcGFydCBvZiB0aGUgY2xvc2Ut
b24tZm9yayBleGVjdXRpb24gcGF0aC4NCg0KT3RoZXJzIC0tIEkgd2lsbCByZXNwb25kIHRvIGZl
ZWRiYWNrIG91dHNpZGUgb2YgaW1wbGVtZW50YXRpb24gZGV0YWlscyBpbiBhIHNlcGFyYXRlIG1l
c3NhZ2UuDQoNClRoYW5rcywNCg0KTmF0ZQ0KDQotLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0K
RnJvbTogRXJpYyBEdW1hemV0IDxlcmljLmR1bWF6ZXRAZ21haWwuY29tPiANClNlbnQ6IE1vbmRh
eSwgQXByaWwgMjAsIDIwMjAgMDU6MjYNClRvOiBLYXJzdGVucywgTmF0ZSA8TmF0ZS5LYXJzdGVu
c0BnYXJtaW4uY29tPjsgQWxleGFuZGVyIFZpcm8gPHZpcm9AemVuaXYubGludXgub3JnLnVrPjsg
SmVmZiBMYXl0b24gPGpsYXl0b25Aa2VybmVsLm9yZz47IEouIEJydWNlIEZpZWxkcyA8YmZpZWxk
c0BmaWVsZHNlcy5vcmc+OyBBcm5kIEJlcmdtYW5uIDxhcm5kQGFybmRiLmRlPjsgUmljaGFyZCBI
ZW5kZXJzb24gPHJ0aEB0d2lkZGxlLm5ldD47IEl2YW4gS29rc2hheXNreSA8aW5rQGp1cmFzc2lj
LnBhcmsubXN1LnJ1PjsgTWF0dCBUdXJuZXIgPG1hdHRzdDg4QGdtYWlsLmNvbT47IEphbWVzIEUu
Si4gQm90dG9tbGV5IDxKYW1lcy5Cb3R0b21sZXlASGFuc2VuUGFydG5lcnNoaXAuY29tPjsgSGVs
Z2UgRGVsbGVyIDxkZWxsZXJAZ214LmRlPjsgRGF2aWQgUy4gTWlsbGVyIDxkYXZlbUBkYXZlbWxv
ZnQubmV0PjsgSmFrdWIgS2ljaW5za2kgPGt1YmFAa2VybmVsLm9yZz47IGxpbnV4LWZzZGV2ZWxA
dmdlci5rZXJuZWwub3JnOyBsaW51eC1hcmNoQHZnZXIua2VybmVsLm9yZzsgbGludXgtYWxwaGFA
dmdlci5rZXJuZWwub3JnOyBsaW51eC1wYXJpc2NAdmdlci5rZXJuZWwub3JnOyBzcGFyY2xpbnV4
QHZnZXIua2VybmVsLm9yZzsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgbGludXgta2VybmVsQHZn
ZXIua2VybmVsLm9yZw0KQ2M6IENoYW5nbGkgR2FvIDx4aWFvc3VvQGdtYWlsLmNvbT4NClN1Ympl
Y3Q6IFJlOiBbUEFUQ0ggMS80XSBmczogSW1wbGVtZW50IGNsb3NlLW9uLWZvcmsNCg0KQ0FVVElP
TiAtIEVYVEVSTkFMIEVNQUlMOiBEbyBub3QgY2xpY2sgYW55IGxpbmtzIG9yIG9wZW4gYW55IGF0
dGFjaG1lbnRzIHVubGVzcyB5b3UgdHJ1c3QgdGhlIHNlbmRlciBhbmQga25vdyB0aGUgY29udGVu
dCBpcyBzYWZlLg0KDQoNCk9uIDQvMjAvMjAgMTI6MTUgQU0sIE5hdGUgS2Fyc3RlbnMgd3JvdGU6
DQo+IFRoZSBjbG9zZS1vbi1mb3JrIGZsYWcgY2F1c2VzIHRoZSBmaWxlIGRlc2NyaXB0b3IgdG8g
YmUgY2xvc2VkIA0KPiBhdG9taWNhbGx5IGluIHRoZSBjaGlsZCBwcm9jZXNzIGJlZm9yZSB0aGUg
Y2hpbGQgcHJvY2VzcyByZXR1cm5zIGZyb20gDQo+IGZvcmsoKS4gSW1wbGVtZW50IHRoaXMgZmVh
dHVyZSBhbmQgcHJvdmlkZSBhIG1ldGhvZCB0byBnZXQvc2V0IHRoZSANCj4gY2xvc2Utb24tZm9y
ayBmbGFnIHVzaW5nIGZjbnRsKDIpLg0KPg0KPiBUaGlzIGZ1bmN0aW9uYWxpdHkgd2FzIGFwcHJv
dmVkIGJ5IHRoZSBBdXN0aW4gQ29tbW9uIFN0YW5kYXJkcyANCj4gUmV2aXNpb24gR3JvdXAgZm9y
IGluY2x1c2lvbiBpbiB0aGUgbmV4dCByZXZpc2lvbiBvZiB0aGUgUE9TSVggDQo+IHN0YW5kYXJk
IChzZWUgaXNzdWUgMTMxOCBpbiB0aGUgQXVzdGluIEdyb3VwIERlZmVjdCBUcmFja2VyKS4NCg0K
T2ggd2VsbC4uLiB5ZXQgYW5vdGhlciBmZWF0dXJlIHNsb3dpbmcgZG93biBhIGNyaXRpY2FsIHBh
dGguDQoNCj4NCj4gQ28tZGV2ZWxvcGVkLWJ5OiBDaGFuZ2xpIEdhbyA8eGlhb3N1b0BnbWFpbC5j
b20+DQo+IFNpZ25lZC1vZmYtYnk6IENoYW5nbGkgR2FvIDx4aWFvc3VvQGdtYWlsLmNvbT4NCj4g
U2lnbmVkLW9mZi1ieTogTmF0ZSBLYXJzdGVucyA8bmF0ZS5rYXJzdGVuc0BnYXJtaW4uY29tPg0K
PiAtLS0NCj4gIGZzL2ZjbnRsLmMgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgIDIgKysN
Cj4gIGZzL2ZpbGUuYyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgNTAgKysrKysrKysr
KysrKysrKysrKysrKysrKy0NCj4gIGluY2x1ZGUvbGludXgvZmR0YWJsZS5oICAgICAgICAgICAg
ICAgIHwgIDcgKysrKw0KPiAgaW5jbHVkZS9saW51eC9maWxlLmggICAgICAgICAgICAgICAgICAg
fCAgMiArKw0KPiAgaW5jbHVkZS91YXBpL2FzbS1nZW5lcmljL2ZjbnRsLmggICAgICAgfCAgNSAr
LS0NCj4gIHRvb2xzL2luY2x1ZGUvdWFwaS9hc20tZ2VuZXJpYy9mY250bC5oIHwgIDUgKy0tDQo+
ICA2IGZpbGVzIGNoYW5nZWQsIDY2IGluc2VydGlvbnMoKyksIDUgZGVsZXRpb25zKC0pDQo+DQo+
IGRpZmYgLS1naXQgYS9mcy9mY250bC5jIGIvZnMvZmNudGwuYw0KPiBpbmRleCAyZTRjMGZhMjA3
NGIuLjIzOTY0YWJmNGExYSAxMDA2NDQNCj4gLS0tIGEvZnMvZmNudGwuYw0KPiArKysgYi9mcy9m
Y250bC5jDQo+IEBAIC0zMzUsMTAgKzMzNSwxMiBAQCBzdGF0aWMgbG9uZyBkb19mY250bChpbnQg
ZmQsIHVuc2lnbmVkIGludCBjbWQsIHVuc2lnbmVkIGxvbmcgYXJnLA0KPiAgICAgICAgICAgICAg
IGJyZWFrOw0KPiAgICAgICBjYXNlIEZfR0VURkQ6DQo+ICAgICAgICAgICAgICAgZXJyID0gZ2V0
X2Nsb3NlX29uX2V4ZWMoZmQpID8gRkRfQ0xPRVhFQyA6IDA7DQo+ICsgICAgICAgICAgICAgZXJy
IHw9IGdldF9jbG9zZV9vbl9mb3JrKGZkKSA/IEZEX0NMT0ZPUksgOiAwOw0KPiAgICAgICAgICAg
ICAgIGJyZWFrOw0KPiAgICAgICBjYXNlIEZfU0VURkQ6DQo+ICAgICAgICAgICAgICAgZXJyID0g
MDsNCj4gICAgICAgICAgICAgICBzZXRfY2xvc2Vfb25fZXhlYyhmZCwgYXJnICYgRkRfQ0xPRVhF
Qyk7DQo+ICsgICAgICAgICAgICAgc2V0X2Nsb3NlX29uX2ZvcmsoZmQsIGFyZyAmIEZEX0NMT0ZP
UkspOw0KPiAgICAgICAgICAgICAgIGJyZWFrOw0KPiAgICAgICBjYXNlIEZfR0VURkw6DQo+ICAg
ICAgICAgICAgICAgZXJyID0gZmlscC0+Zl9mbGFnczsNCj4gZGlmZiAtLWdpdCBhL2ZzL2ZpbGUu
YyBiL2ZzL2ZpbGUuYw0KPiBpbmRleCBjOGE0ZTRjODZlNTUuLmRlNzI2MGJhNzE4ZCAxMDA2NDQN
Cj4gLS0tIGEvZnMvZmlsZS5jDQo+ICsrKyBiL2ZzL2ZpbGUuYw0KPiBAQCAtNTcsNiArNTcsOCBA
QCBzdGF0aWMgdm9pZCBjb3B5X2ZkX2JpdG1hcHMoc3RydWN0IGZkdGFibGUgKm5mZHQsIHN0cnVj
dCBmZHRhYmxlICpvZmR0LA0KPiAgICAgICBtZW1zZXQoKGNoYXIgKiluZmR0LT5vcGVuX2ZkcyAr
IGNweSwgMCwgc2V0KTsNCj4gICAgICAgbWVtY3B5KG5mZHQtPmNsb3NlX29uX2V4ZWMsIG9mZHQt
PmNsb3NlX29uX2V4ZWMsIGNweSk7DQo+ICAgICAgIG1lbXNldCgoY2hhciAqKW5mZHQtPmNsb3Nl
X29uX2V4ZWMgKyBjcHksIDAsIHNldCk7DQo+ICsgICAgIG1lbWNweShuZmR0LT5jbG9zZV9vbl9m
b3JrLCBvZmR0LT5jbG9zZV9vbl9mb3JrLCBjcHkpOw0KPiArICAgICBtZW1zZXQoKGNoYXIgKilu
ZmR0LT5jbG9zZV9vbl9mb3JrICsgY3B5LCAwLCBzZXQpOw0KPg0KDQpJIHN1Z2dlc3Qgd2UgZ3Jv
dXAgdGhlIHR3byBiaXRzIG9mIGEgZmlsZSAoY2xvc2Vfb25fZXhlYywgY2xvc2Vfb25fZm9yaykg
dG9nZXRoZXIsIHNvIHRoYXQgd2UgZG8gbm90IGhhdmUgdG8gZGlydHkgdHdvIHNlcGFyYXRlIGNh
Y2hlIGxpbmVzLg0KDQpPdGhlcndpc2Ugd2Ugd2lsbCBhZGQgeWV0IGFub3RoZXIgY2FjaGUgbGlu
ZSBtaXNzIGF0IGV2ZXJ5IGZpbGUgb3BlbmluZy9jbG9zaW5nIGZvciBwcm9jZXNzZXMgd2l0aCBi
aWcgZmlsZSB0YWJsZXMuDQoNCkllIGhhdmluZyBhIF9zaW5nbGVfIGJpdG1hcCBhcnJheSwgZXZl
biBiaXQgZm9yIGNsb3NlX29uX2V4ZWMsIG9kZCBiaXQgZm9yIGNsb3NlX29uX2ZvcmsNCg0Kc3Rh
dGljIGlubGluZSB2b2lkIF9fc2V0X2Nsb3NlX29uX2V4ZWModW5zaWduZWQgaW50IGZkLCBzdHJ1
Y3QgZmR0YWJsZSAqZmR0KSB7DQogICAgICAgIF9fc2V0X2JpdChmZCAqIDIsIGZkdC0+Y2xvc2Vf
b25fZm9ya19leGVjKTsgfQ0KDQpzdGF0aWMgaW5saW5lIHZvaWQgX19zZXRfY2xvc2Vfb25fZm9y
ayh1bnNpZ25lZCBpbnQgZmQsIHN0cnVjdCBmZHRhYmxlICpmZHQpIHsNCiAgICAgICAgX19zZXRf
Yml0KGZkICogMiArIDEsIGZkdC0+Y2xvc2Vfb25fZm9ya19leGVjKTsgfQ0KDQpBbHNvIHRoZSBG
X0dFVEZEL0ZfU0VURkQgaW1wbGVtZW50YXRpb24gbXVzdCB1c2UgYSBzaW5nbGUgZnVuY3Rpb24g
Y2FsbCwgdG8gbm90IGFjcXVpcmUgdGhlIHNwaW5sb2NrIHR3aWNlLg0KDQoNCg==
