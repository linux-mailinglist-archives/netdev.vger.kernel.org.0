Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1BC21C55AC
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 14:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729105AbgEEMio (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 08:38:44 -0400
Received: from mail-eopbgr770049.outbound.protection.outlook.com ([40.107.77.49]:46720
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728737AbgEEMih (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 May 2020 08:38:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JdnwPAT4W8XAYwXsnhyjHkR95JYMY+fDJJtXRx7h3GguWEgaUC1hkhrXpGWTqALP4g0u0HeqvqrG9c38xCPCxFqi5F4OllsnKRo4sLtyJ8gZL3aFwCkMf6UQqthFmWMa9+sQ7VylyqYmaou4/VAFiQ0YZfCglVmUKZJ7nsoOPjC5KmPsXmb70lpDWrHw5MX/gyh2YRDveu9Mjxv7vJTqbb+pqkcOSdVygc1sVFACoVT4jQGic8oSg/P6AeZBa7c/r6sTRWf0wuFAql+3e7J4i8fCXsrPcTs0sICGQ7wXpbdkud5buU6WOdDNUQSsUcdE55tw/COpbmOlPceA8fK1FA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/Voorz1nbEcUN0yj+akMAPNW372Wl9yW5ZwfS5LzEME=;
 b=J/JlVeuCjn+hCjzzaBVlzSvPSVDaNz8ZyrtUAPMEMPSA2/p2zeLf1rtkFGm07KcJZH6vw0hy+BwoLpB224sLWVMh0VGK1hmPF7xXn9PAQ+dD/R9aEtE2xTEyWzMwoA8wvprXOyGPm7wANParfP/dBLQlXFOricOUm7GsRAd1jtsiK7V3TNTb4AItOQqeokH10hD6YDdV0CTPmmDOm1N0osa8GEk90f+M5CpyTWyVx8kK8J4zy0lu7wK91wMf6UYXDOGya8+xSzItrKUyz1Z2GxWD8l+hAct1hW9KlaCW85XDJH/YnUILGUQ5FUea/Js82eD2WsPHnl4mSBqLq6WLiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/Voorz1nbEcUN0yj+akMAPNW372Wl9yW5ZwfS5LzEME=;
 b=Hd0ClXJWHMs5wE6wrXrMBHZjegcwm+yM7Hxy2sOBRhR8hxTMQ+k3tb2QGht5WaIBibOfa+ewUl08WDzFhuBYahVy3iQmXQQDF0F2KV+aK9afmxUTd5xVmR86/di84dLcx5kKFB3tAhg1Va83UWG5CJR85EmMBTVVCEE/mYfkfYc=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHPR11MB2046.namprd11.prod.outlook.com (2603:10b6:300:28::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20; Tue, 5 May
 2020 12:38:33 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe%10]) with mapi id 15.20.2958.030; Tue, 5 May 2020
 12:38:33 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 10/15] staging: wfx: fix missing 'static' keyword
Date:   Tue,  5 May 2020 14:37:52 +0200
Message-Id: <20200505123757.39506-11-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200505123757.39506-1-Jerome.Pouiller@silabs.com>
References: <20200505123757.39506-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR3P189CA0022.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:102:52::27) To MWHPR11MB1775.namprd11.prod.outlook.com
 (2603:10b6:300:10e::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.home (2a01:e35:2435:66a0:1265:30ff:fefd:6e7f) by PR3P189CA0022.EURP189.PROD.OUTLOOK.COM (2603:10a6:102:52::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend Transport; Tue, 5 May 2020 12:38:31 +0000
X-Mailer: git-send-email 2.26.1
X-Originating-IP: [2a01:e35:2435:66a0:1265:30ff:fefd:6e7f]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8849a99d-67f0-4281-7b86-08d7f0f13916
X-MS-TrafficTypeDiagnostic: MWHPR11MB2046:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB2046476C9A3B20C87B93DF4E93A70@MWHPR11MB2046.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-Forefront-PRVS: 0394259C80
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 70PqeK4EsHL+SlsU4WoJhVKX/FBxvKwn6iDWOXhQPNH70IWZ3KvmtQP9cBeGth8O2uIodfuw5lWccx8EDgfUzbbqo3D0vUkjQ+n5VJNv2mAcYMJST31zyxAOaKlmBLPfo0FpxMDqfnV17oa82NM9SbsALka1yDAIEE2KaScx1/afPd48y03XX/IT8yoSQWLKBs4qCaeLCYnjDDGjFwFLwZIAtJ3duFHoy2/YzXM/ZaJoHs8LPOfwx7XKRLHERQ9E5f3hH710XCYykKDTz2uSYIuAzoZ6I4ZNEv1PqOf9FhKVYZDTmR9QV0cbYqsact7r1wn/pu26LnakUbFK9j6KENef2pUjm+dW+jGng1MHFMjo0qKQfOewh0x5vauWCyVEJm0ZN7kSl0b6gbX2MHjsKT6kwU2Kv1bWK2u7Ii7Xl1jxw+TwwZWzBV0TKuFwZa+ti20HDPdNpcrYqylnJM2ePnOTQslmNxD9Q62GN+y0scGa83DdmYcqRvu0EDdEjN4swo23j/68kY3ygAKe5+g2jQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(366004)(346002)(39850400004)(136003)(376002)(33430700001)(2906002)(36756003)(4744005)(52116002)(86362001)(5660300002)(6486002)(1076003)(8676002)(66574012)(8936002)(6666004)(107886003)(2616005)(66476007)(66946007)(16526019)(186003)(66556008)(6512007)(8886007)(478600001)(4326008)(6506007)(33440700001)(54906003)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: sU6cfI0eFWnk8zqxE/u4QMnoEekmVPNMORtRwm1oVC56YcK2Q+hGmvZpWXx8q7oBPscAqCFJ7U3siMlthdsJPgdZVDBMD0e/JqcHOk6U6w/PaUhI1v6b/jwBggmIDRKW7msdI5ffFGB4kQN3p89PBktQqmF2sxsEm7AswUearIXNqw014WVWb0fNx/8Pl0T21xZw5LA4u2xb/8jEXedHT75Rt4EsbUS2h/tv17qiIkJFb07O5L7dfj7ctHtlwd/sbyPunvVA5l/CUnVipjFelKTRreBeKgZmD0MWL/hqCHhQeK4pWwbcv8mqK2DKfACk9Zg6SIafB4NPHyXtSf3AI/8m5idu1fqL/WwTzhzyOM1+Ub1pbPF1Mi/usYHy1DDnuZ2IZuJJDGzHyk7icfiT5Pe7tlAC8o+e2QfvZsH7L2rUROGDa+mSJjp131u6bCg00p9HVW3qqWDADi4Z8b4WsKQtSC8k3GbD2QsHBgRtDbAkme7wGnst+YUFvTJw2NEoUNJxLe/USPPexTZITDw+uWo1mzb/NZRHcOZV9jj6YCtfihkDxwEGQjinE7zfWr7xsmVg6eSnmg2T6/s+mwhgnsYFzZw4WPsp3fpg42xG1K572Kf/Q65+etrqcd5VAh4GtqQlRYaSsomGbtyQqNi4YZH6fuTN9ce1lo8uTZCg/rAA5+1BSmejfjauowOrjKgZOOM63aMgtmTc1USkJUCQAwZBJP4qiDagmtVLBjR1hdetneSif9ZzwpgmygON5shk9ZeVeHcDRikm/5ImQPPLroRdonnAfGj8CSa9ojHXdjEqfEemVas+tWdczkxP7A12Lkqk8tSyMEFh8P1zQpKwN4IowGKqHU5pJjBEhwwssVQ=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8849a99d-67f0-4281-7b86-08d7f0f13916
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2020 12:38:33.5862
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: amP72ULyb9m+W8In2qfyGc75bb7NOR+9je+LSOFOXnRSCmJRDlBwsEKHNhczWv0XdKdIV6mdM+8MmXusVRkldg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB2046
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKU3Bh
cnNlIHRvb2wgbm90aWNlZCB0aGF0IHdmeF9lbmFibGVfYmVhY29uKCkgaXMgbmV2ZXIgdXNlZCBv
dXRzaWRlIG9mCnN0YS5jLiBUaGVyZWZvcmUsIGl0IGNhbiBiZSBkZWNsYXJlZCBzdGF0aWMuCgpT
aWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5j
b20+Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYyB8IDIgKy0KIDEgZmlsZSBjaGFuZ2Vk
LCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3Rh
Z2luZy93Zngvc3RhLmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCmluZGV4IDc0ZWMwYjYw
NDA4NS4uM2FkMGI2N2E3ZGNhIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5j
CisrKyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKQEAgLTUxOSw3ICs1MTksNyBAQCB2b2lk
IHdmeF9sZWF2ZV9pYnNzKHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3LCBzdHJ1Y3QgaWVlZTgwMjEx
X3ZpZiAqdmlmKQogCXdmeF9kb191bmpvaW4od3ZpZik7CiB9CiAKLXZvaWQgd2Z4X2VuYWJsZV9i
ZWFjb24oc3RydWN0IHdmeF92aWYgKnd2aWYsIGJvb2wgZW5hYmxlKQorc3RhdGljIHZvaWQgd2Z4
X2VuYWJsZV9iZWFjb24oc3RydWN0IHdmeF92aWYgKnd2aWYsIGJvb2wgZW5hYmxlKQogewogCS8v
IERyaXZlciBoYXMgQ29udGVudCBBZnRlciBEVElNIEJlYWNvbiBpbiBxdWV1ZS4gRHJpdmVyIGlz
IHdhaXRpbmcgZm9yCiAJLy8gYSBzaWduYWwgZnJvbSB0aGUgZmlybXdhcmUuIFNpbmNlIHdlIGFy
ZSBnb2luZyB0byBzdG9wIHRvIHNlbmQKLS0gCjIuMjYuMQoK
