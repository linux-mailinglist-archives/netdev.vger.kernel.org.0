Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 327111B110F
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 18:05:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729952AbgDTQFJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 12:05:09 -0400
Received: from mail-mw2nam10on2061.outbound.protection.outlook.com ([40.107.94.61]:6055
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726067AbgDTQDr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 12:03:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WP3OCDMQVy4jXEeBFb0MqZjQMhnY4fdv+tEapJsxY9f4RYrSAN3rUZ4hqQMCx0Fxs4fTwzwjaR5a871tAjQlQEHtJ9oEisVHINdhTPgFJH/05ke29VZZxEJv2gBNJsTi6e0YkPtuyu+ifABteVhr2wkq/aVSuV3oKo1r8uN2T3sf+WWII3+Q0MLXHapeTv/XAHtxKeR3c4wwXsjycFYjFwFsFO5Ba5foTDSSqMDbs/iWWUp1wRiqDwJvlYqmO3GMyA66+f1l/69HkpLoEv7tf/VC+gc+av4OIIupV4v0c+DueTuDs3hqRxWET/s8OjCdgxtBJITXbOoHi/MTDgYBhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JiNhlmZDbk66but7bXaR9sdbK2SVjbBzmKhuoxaGOTw=;
 b=Xb+APXDtrmw851fkQgS2LU5N19wiB+sxJwcHg37Wk77shNHBqdN8dh7/WVNNNL6qjxZBroXixxA84nZRLvpszF93UInBSxSJ79ZrvakmedoPhW+ZDGRcNWspifhhKEWATMi+NOT47ZpbtYDHgysxPmYdsSPdfP3yCc0UYQuGf0PUJdNC9G9CTSdwG23/DPIpYG+QYDDFwldMSXwwm8tEDen8jUZvbAOV5XWXf6xFPnnnFE7DW10XkPf6d9Qo4wciNLfwHsYbwy/AmNo26MMVmF2NABEAR9X3QPOq/EiHdisz8GRfLKI1afso8bCMNOoAoUkbadkqavJdb7aHdGVOxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JiNhlmZDbk66but7bXaR9sdbK2SVjbBzmKhuoxaGOTw=;
 b=atsxhcsD4sxoocR6+cfRCCeyeRLWNXxK6lf63iC/T3D3BXMtBDT0nA+U3WCSCuiG3+Ogg+hO1zUIF5aCknlwKFqT+nzgmPXzYYflIo4koXdtDceIbFA/ix3H9MSbqw3Bya+cyPuXKM+keeaHR9vvGf7y5P9e6jPW8Lwzu1xyO9k=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHSPR00MB249.namprd11.prod.outlook.com (2603:10b6:300:68::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.25; Mon, 20 Apr
 2020 16:03:43 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe%10]) with mapi id 15.20.2921.030; Mon, 20 Apr
 2020 16:03:43 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 07/16] staging: wfx: field operational_rate_set is ignored by firmware
Date:   Mon, 20 Apr 2020 18:03:02 +0200
Message-Id: <20200420160311.57323-8-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200420160311.57323-1-Jerome.Pouiller@silabs.com>
References: <20200420160311.57323-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: DM6PR07CA0065.namprd07.prod.outlook.com
 (2603:10b6:5:74::42) To MWHPR11MB1775.namprd11.prod.outlook.com
 (2603:10b6:300:10e::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (2a01:e35:2435:66a0:544b:f17b:7ae8:fb7) by DM6PR07CA0065.namprd07.prod.outlook.com (2603:10b6:5:74::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.26 via Frontend Transport; Mon, 20 Apr 2020 16:03:41 +0000
X-Mailer: git-send-email 2.26.1
X-Originating-IP: [2a01:e35:2435:66a0:544b:f17b:7ae8:fb7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6cfaa082-6090-4d95-a8ba-08d7e544661e
X-MS-TrafficTypeDiagnostic: MWHSPR00MB249:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHSPR00MB249B031094934F60683EAE793D40@MWHSPR00MB249.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-Forefront-PRVS: 03793408BA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(136003)(366004)(376002)(396003)(39850400004)(346002)(8676002)(7696005)(52116002)(6666004)(4326008)(8936002)(81156014)(66556008)(66476007)(66946007)(36756003)(186003)(54906003)(16526019)(107886003)(478600001)(2906002)(316002)(66574012)(1076003)(86362001)(6486002)(2616005)(5660300002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dZyCU1X4D931YgyrOPUWW6ZlLUB2qNcL/eJrbl9drNfniExPsVRFdafZsR0+LFhYpdzCDt12HIHslXxbqrREnXxytmvZu2Z+lN37XspEWyV1Xsik2OAuMZ4WZSFLya6j2sliCGZxS1/DJasczUbPIe8DWEv9kKVkdMF6G78tmEBqE/wtfF1nrPsZFbx44iHMyNYUULS3hdffE8g6ZAMc8n5IRMb+8JZxyRcjBhtVosy0em9+F/2suqxeaJizI0XSF112jEzXqW5qP/nEUu3IV3IrSzWRm7YnWscR/NtW/lJFwVKEdE/td15Ku7TnMiALe3TGWcO9ofi/7tpKcTwkAYqdQui6jF4SUGOg5DczylwKwVWO00mB/xPVA29KY52AmJ058UqPQ7wmv1Fy8dkVOC5/gBqPwUjR1a+HmrGgTQvK7o1OHgDisBopZdOYBow1
X-MS-Exchange-AntiSpam-MessageData: FfvpstT7NcSiV3BYdffTzdxW1Yx9GyGidmokxxfiLj0gaWy576uVO3wwvpLhkkAI1H+jwjnOJTFeryoy4imX/790d2VYprOgJ2OSNCh4q5ydUFYWGV0q3HdvzZtkcn+lp9GANk+mmlBtTpNHnDMUxtZahEtAXb3FgFDmZWgEf23P3RdKpTxWfzmeh7sC2E3DjdCksPSlQCZOZyCRsCracHscrqakSyEkTHQELePTfet+d39o6Hqm6GP0gXZiNsPpjdhH7PL0HpcEw1TZ5o7XgxRuO8Im9XObngtyV714hHa6Jf6aAj2gmHqyf54I0YUH68nucb2GTJZRgWq7uGvyjwpsLJjrYpqTUQDBnLUHM9lR9fx5uSSIWustxprrQYQIBS9TX2FtjmQBb+ZN/IZj+yWjtqzv/Y2FIIoMoAq70sYh3Kq+kuS1nDVkqjv9wKlyd/u486Jo/CZPL8YrJRvS49fO2uEZXoctb6ONF4POn5xI2j6io670bB0toTp//cbG5HIxeQHJOvpbCIPKY9bR/SRLJvPCrRNy3ibHYO9bPluVCvlN5XNgASslNbIVSjP7fcnPOhrG3tEJUv9kEwNrWNHRnCpyPq62l3/5bH/CdpnsHS53OexAy6nrk4xrJkF8fP1ThhU+PX/yePGPDaFMd34wsGCA7kHd8kKtrLoeOX5c1cU2bxJGsB3aExaOFvX6lKxzaAodCQVhqlfH2FKRjjK3PT08fI7ouBeGv5zVnOokXRPtb6bswZrW5MJ/HxxRLqpc0sbEb9uSUoLp0KNAk/5PGlwBX4lLVneFyQhYxBwv4vwrT9xNhL11D9S9YuetKEMD75/CLpMNcBu3cd2D9OswzMw1HkPkaWJfw+C71jI=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cfaa082-6090-4d95-a8ba-08d7e544661e
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2020 16:03:43.3904
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: un3Gc/0KqqLpWGlh4boO6ES2/+CcewF+5MQA7izpsk7D8uHTveNCn+IQJ+mUr3UFDVdmgtlM13mUfEe1JBF+og==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHSPR00MB249
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IGZpZWxkIGJzc19wYXJhbXMub3BlcmF0aW9uYWxfcmF0ZV9zZXQgaXMgaWdub3JlIGJ5IHRoZSBm
aXJtd2FyZS4gSXQKaXMgbm90IG5lY2Vzc2FyeSB0byBzZW5kIGl0LiBUaGlzIGNoYW5nZSBncmVh
dGx5IHNpbXBsaWZ5CndmeF9qb2luX2ZpbmFsaXplKCkuIEl0IGlzIG5vIG1vcmUgbmVjZXNzYXJ5
IHRvIGdldCBzdGEgYW5kIGl0IGFsbG93IHRvCnNhdmUgYSBSQ1UuCgpTaWduZWQtb2ZmLWJ5OiBK
w6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVy
cy9zdGFnaW5nL3dmeC9zdGEuYyB8IDIyICsrKysrKy0tLS0tLS0tLS0tLS0tLS0KIDEgZmlsZSBj
aGFuZ2VkLCA2IGluc2VydGlvbnMoKyksIDE2IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvc3RhZ2luZy93Zngvc3RhLmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCmluZGV4
IDJhOWM3ZjI4ZDkzNC4uNmNkYjQwYTA1OTkxIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcv
d2Z4L3N0YS5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKQEAgLTQ3MCwyMiArNDcw
LDEyIEBAIHZvaWQgd2Z4X3N0b3BfYXAoc3RydWN0IGllZWU4MDIxMV9odyAqaHcsIHN0cnVjdCBp
ZWVlODAyMTFfdmlmICp2aWYpCiBzdGF0aWMgdm9pZCB3Znhfam9pbl9maW5hbGl6ZShzdHJ1Y3Qg
d2Z4X3ZpZiAqd3ZpZiwKIAkJCSAgICAgIHN0cnVjdCBpZWVlODAyMTFfYnNzX2NvbmYgKmluZm8p
CiB7Ci0Jc3RydWN0IGllZWU4MDIxMV9zdGEgKnN0YSA9IE5VTEw7Ci0Jc3RydWN0IGhpZl9yZXFf
c2V0X2Jzc19wYXJhbXMgYnNzX3BhcmFtcyA9IHsgfTsKLQotCXJjdV9yZWFkX2xvY2soKTsgLy8g
cHJvdGVjdCBzdGEKLQlpZiAoaW5mby0+YnNzaWQgJiYgIWluZm8tPmlic3Nfam9pbmVkKQotCQlz
dGEgPSBpZWVlODAyMTFfZmluZF9zdGEod3ZpZi0+dmlmLCBpbmZvLT5ic3NpZCk7Ci0JaWYgKHN0
YSkKLQkJYnNzX3BhcmFtcy5vcGVyYXRpb25hbF9yYXRlX3NldCA9Ci0JCQl3ZnhfcmF0ZV9tYXNr
X3RvX2h3KHd2aWYtPndkZXYsIHN0YS0+c3VwcF9yYXRlc1t3dmlmLT5jaGFubmVsLT5iYW5kXSk7
Ci0JZWxzZQotCQlic3NfcGFyYW1zLm9wZXJhdGlvbmFsX3JhdGVfc2V0ID0gLTE7Ci0JcmN1X3Jl
YWRfdW5sb2NrKCk7Ci0JLy8gYmVhY29uX2xvc3NfY291bnQgaXMgZGVmaW5lZCB0byA3IGluIG5l
dC9tYWM4MDIxMS9tbG1lLmMuIExldCdzIHVzZQotCS8vIHRoZSBzYW1lIHZhbHVlLgotCWJzc19w
YXJhbXMuYmVhY29uX2xvc3RfY291bnQgPSA3OwotCWJzc19wYXJhbXMuYWlkID0gaW5mby0+YWlk
OworCXN0cnVjdCBoaWZfcmVxX3NldF9ic3NfcGFyYW1zIGJzc19wYXJhbXMgPSB7CisJCS8vIGJl
YWNvbl9sb3NzX2NvdW50IGlzIGRlZmluZWQgdG8gNyBpbiBuZXQvbWFjODAyMTEvbWxtZS5jLgor
CQkvLyBMZXQncyB1c2UgdGhlIHNhbWUgdmFsdWUuCisJCS5iZWFjb25fbG9zdF9jb3VudCA9IDcs
CisJCS5haWQgPSBpbmZvLT5haWQsCisJfTsKIAogCWhpZl9zZXRfYXNzb2NpYXRpb25fbW9kZSh3
dmlmLCBpbmZvKTsKIAloaWZfa2VlcF9hbGl2ZV9wZXJpb2Qod3ZpZiwgMCk7Ci0tIAoyLjI2LjEK
Cg==
