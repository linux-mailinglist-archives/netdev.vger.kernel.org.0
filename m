Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0804F167CDE
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 12:56:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728311AbgBUL4b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 06:56:31 -0500
Received: from mail-eopbgr760043.outbound.protection.outlook.com ([40.107.76.43]:28579
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726909AbgBUL41 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Feb 2020 06:56:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mc+xvA2vdVKLqjlHOwpIcwNm+30ZXq7Ss8wBqNIgeHIdCGES94J3/Kwbv77ueVjyg25rKnXolIsWXowt0a3nin5EGYLherBtFimkjY/EArRgbwK65834TDU1PGbdAx6yqcehKmHxtP467OEMFLkblgahkSlwjk1hk1ZJR1SjhR8hHA+e/Ob69Rvr0uc4wFmu3pxhvAdcFL0rfwrnAuGKRw0K92TgrPzfDWEXACTVhfMhc+04Dw5T/rxRNMNBiu6DSXYMI9Rq5S90RBk0UtWLYYE4vscTi4xGl1SH+C2Fl4wP2cu1XiqRc2+s2Ujh7P19oykw+9uzJjj8tOv1AXNhyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XYcykw53iap05OUXgfxE2Ym3qqJBMTeqAVIn3dpkc9U=;
 b=LSuhFqNSncxibXEao1QjILaxOpFh23WhHkJ/1kJXCS4rQgXD56d7cEQTVfeGZPA3O3eo5bZF5TyZ28WNFE0OczqbmXDPWq6fjjVANwu4x37bGuioWDawWVYq9fpSrUr3b5igBwdgtvOQ0Hc7/1jikb7CflG5HvpwRdP4uPt4uddOf0PWrXfOvaS04LV3UQ8Lt0nClRgBcGy4lrp+YeON3I1QU8yixhvIIzeKaO3+Bb/g6zpxHWN+dWtyfB+ksmsNNFOMPb1Qqqyz0WWwNFqCOqn6d7wuuwea5UN0cOeoeK8KDrH8L1HZf5V1qXtjpiimiKV4/Ae7qoJE5avYV+lQYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XYcykw53iap05OUXgfxE2Ym3qqJBMTeqAVIn3dpkc9U=;
 b=YVYoEJI9rbrdWZWD75QUjN1gDGth5wRbFVlfz2FZCN54ane5RafaEfPYNUFthBwYdwZw+IaHUaIcwJ2oAD5eAZSz8/l0tynSrMAkTW8rqTAsAaHGjw/CkwUDGaIQ0CY73+yBiwYIZ+t5LqQUngdnqJM/lnPZuSiE3j1QxC/FESY=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (2603:10b6:208:13f::22)
 by MN2PR11MB4662.namprd11.prod.outlook.com (2603:10b6:208:263::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.17; Fri, 21 Feb
 2020 11:56:24 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3%7]) with mapi id 15.20.2729.033; Fri, 21 Feb 2020
 11:56:24 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 05/10] cfg80211: drop duplicated documentation of field "perm_addr"
Date:   Fri, 21 Feb 2020 12:55:59 +0100
Message-Id: <20200221115604.594035-5-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200221115604.594035-1-Jerome.Pouiller@silabs.com>
References: <20200221115604.594035-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR0P264CA0137.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1a::29) To MN2PR11MB4063.namprd11.prod.outlook.com
 (2603:10b6:208:13f::22)
MIME-Version: 1.0
Received: from pc-42.silabs.com (37.71.187.125) by PR0P264CA0137.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1a::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.18 via Frontend Transport; Fri, 21 Feb 2020 11:56:23 +0000
X-Mailer: git-send-email 2.25.0
X-Originating-IP: [37.71.187.125]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4dfd9d32-1425-40ca-c789-08d7b6c5133c
X-MS-TrafficTypeDiagnostic: MN2PR11MB4662:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR11MB4662EB54D13E3FEB875E7A6A93120@MN2PR11MB4662.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:741;
X-Forefront-PRVS: 0320B28BE1
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(396003)(346002)(39860400002)(366004)(136003)(376002)(199004)(189003)(36756003)(86362001)(8676002)(81156014)(478600001)(8936002)(81166006)(7696005)(52116002)(66946007)(2906002)(66574012)(4326008)(107886003)(6916009)(1076003)(66556008)(6486002)(66476007)(6666004)(4744005)(5660300002)(956004)(54906003)(316002)(2616005)(186003)(16526019)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4662;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eOKfRwUjHmZA+hud3zAly1vLVUncnDNSthyU1ahS2AfmhdViiao/J4Cu48T1Xnd1bteBAGr5qXeJnGjrhzZwp9xxeBL2fv583nT+Nzol5uP+C3tzMul9/YKHrWPt66Q61iDbgnqzvMRju+RP8WOuXw/xqOqt6+oVVaYkhQRcOAUHkkQIWfEmX9d9MARmKkZVtJ6UQDyO12HHrWMN7QUHhT1O6IoKRNUnN8cuTpWhUCBsxoheNPNk975ZKqzsY73YDx7av/hhj+luplzmhubA/o9QTZ7Y3J6VP+Yw/rb1bgaw4wjDNCbeFK1mLnzrah9Rmfj/lZfRVws/wpcXjuj/k3JphvzhEqgjZX5750Rbu9MQrqNOIkO+aHo58rqYsaZX07joPMdJosD3U15tU2aiYz+KupT4x8mXHIcF6SZiegSfyN+on3t+OM5xJPvbXMXX
X-MS-Exchange-AntiSpam-MessageData: TIojxJk9tx7pC/nfsrR3+TKTUIOandh4n6rmxyklTxXJCCySLJGnMMVnHSFF31IngDe7Wc94vatbwZ6ZNq7U72VTw0wfCmFLHwWpCX3uA1zK33+Px/RuCsxOx9ishQ4eHqcSNr9+i6T76EqdcYrTQA==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4dfd9d32-1425-40ca-c789-08d7b6c5133c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2020 11:56:24.6445
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /AkLmEFTiQuDbWmmw9yHl7PlnxkBHfn7vWGi2eddvdCR0DFRraMcOHoFuSB5jfxv3b6JWLX0Fjr1wSYtDKLFng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4662
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IGZpZWxkICJwZXJtX2FkZHIiIHdhcyBhbHJlYWR5IGRvY3VtZW50ZWQgYWJvdmUgdGhlIGRlZmlu
aXRpb24gb2YKc3RydWN0IHdpcGh5LiBDb21tZW50cyB3ZXJlIGFsbW9zdCBpZGVudGljYWwuCgpT
aWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5j
b20+Ci0tLQogaW5jbHVkZS9uZXQvY2ZnODAyMTEuaCB8IDEgLQogMSBmaWxlIGNoYW5nZWQsIDEg
ZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS9pbmNsdWRlL25ldC9jZmc4MDIxMS5oIGIvaW5jbHVk
ZS9uZXQvY2ZnODAyMTEuaAppbmRleCA1OWM4MTA4ZWI3NTYuLmI1ZjZmZTU2OTc0ZSAxMDA2NDQK
LS0tIGEvaW5jbHVkZS9uZXQvY2ZnODAyMTEuaAorKysgYi9pbmNsdWRlL25ldC9jZmc4MDIxMS5o
CkBAIC00NTUxLDcgKzQ1NTEsNiBAQCBzdHJ1Y3QgY2ZnODAyMTFfcG1zcl9jYXBhYmlsaXRpZXMg
ewogc3RydWN0IHdpcGh5IHsKIAkvKiBhc3NpZ24gdGhlc2UgZmllbGRzIGJlZm9yZSB5b3UgcmVn
aXN0ZXIgdGhlIHdpcGh5ICovCiAKLQkvKiBwZXJtYW5lbnQgTUFDIGFkZHJlc3MoZXMpICovCiAJ
dTggcGVybV9hZGRyW0VUSF9BTEVOXTsKIAl1OCBhZGRyX21hc2tbRVRIX0FMRU5dOwogCi0tIAoy
LjI1LjAKCg==
