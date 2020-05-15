Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28DFC1D486D
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 10:34:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728194AbgEOIeT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 04:34:19 -0400
Received: from mail-bn8nam11on2054.outbound.protection.outlook.com ([40.107.236.54]:18393
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728128AbgEOIeO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 04:34:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hcw2KaPzYOoryk/Kfs5LezrsFfsTsO6mLtLntzSUs6yJnEn3kwY+0pzzeDTIKUfJEr0/GexxT8KyNGj+hkvvN5cdywaHxPIHR0E5RZJCfzupja0eT1PCPY+OHz1csjRrJdUH7lmFsjwn+MaPBsTb+fdJUrPrKYVKtW7Z9enAtLHuE6vJthOOVsWVxu7f+GT+pBAJl2fvrtM/IshnpPRQYg9d2PIRun5cCi5IzKHH/MmOMxdYxvx0cplvvrfQAJrD5yCAHErR1sgJ/d/FLggjgAVqiegJY+aTzIsQODc55Ha5brxD/cX6fwgMhyKhm0jRSuCke1fVD/J+hk996QQ4Mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LD2oN55t8Dw8tcBb5rw07q4iSwGuyj0sgAKW/og9I5o=;
 b=ntp3sDqTaMQKYVec60Rm28UfbkSeWIZ1hQxtNxpJyeaFb3riy94Ipn7joPGe+7soxgYwg9DlLtjWEOHtIIuPNzCHjd5ai0vGlIehNZZNT8JNCPCcIRY1ctw/sKKnI3N6TquXQgH/17wOYFmG/ECgcd+gxdKlybVrL/7pohEtjC2Gda/2ozW2JvEWRQolh9+2pZcmEGwxp0lB19wHJ22Fdp4pvjjz6QgWK4NfjWZJTelqzCd238vc0wlFYiqw2vO2T6k/fkgqXGTL+cUUZn1eEX63Kz7g85juLPkagMrb8QpYT3rRn9b37dDCuq1/cjczhk6LP5auVDMdw4AITa6nDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LD2oN55t8Dw8tcBb5rw07q4iSwGuyj0sgAKW/og9I5o=;
 b=Rkl7lXQg57nd1NLFleLwBi7YF7SH2dxsRUoy42pX/JytL6Ln0+WBKHlpHGBBuPYDPnSxzlhUtjl/Eg+fquNeOHxqO8Nr0G5jnXpvNEus+epkE3Cn/lrJbo8xsahBHhFilppYhuuo4W1AxBip0z4Fuyt9xjBoHJUkLrdKIaPdmmM=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHPR11MB2030.namprd11.prod.outlook.com (2603:10b6:300:28::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.25; Fri, 15 May
 2020 08:34:11 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::e055:3e6d:ff4:56da]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::e055:3e6d:ff4:56da%5]) with mapi id 15.20.3000.022; Fri, 15 May 2020
 08:34:11 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 12/19] staging: wfx: merge wfx_stop_ap() with wfx_reset()
Date:   Fri, 15 May 2020 10:33:18 +0200
Message-Id: <20200515083325.378539-13-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200515083325.378539-1-Jerome.Pouiller@silabs.com>
References: <20200515083325.378539-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR0P264CA0076.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:18::16) To MWHPR11MB1775.namprd11.prod.outlook.com
 (2603:10b6:300:10e::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.home (82.67.86.106) by PR0P264CA0076.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:18::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.24 via Frontend Transport; Fri, 15 May 2020 08:34:09 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [82.67.86.106]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 75d432f8-6dc5-41af-66ac-08d7f8aabe04
X-MS-TrafficTypeDiagnostic: MWHPR11MB2030:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB2030EDF25BAD3EC9B5FCED7493BD0@MWHPR11MB2030.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:741;
X-Forefront-PRVS: 04041A2886
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h6dct3yAmSgqA5MSPoUEgTcNtUE9ppfVWCS9H/b2S2U/henzi3g1XDARZQI6cm8Mn41DSr3FTh6YCdZzZuQ1es8doMwh83WjNfZ7e5z6CXKb8X7KrhnQhrb325t8nz7DUorz3egEvQ4FUbyRgNmDfIxYAhxHCLotI9NFqKT1D6BEnHUFPrkCzt/KEky/XRKuNyysUoEjxg9DPgiRagS0sd/Yn1NLMY/pM/C26dENmmDV0QKoa0xPb5nILJBLIdADgbajGw5RTPOmaD4W1WepZrQqfhC7o4KXOl/mh9LbUyRcTD6ERxHdNYf1HfSRZeMVeYao+yKgJl0TAFO48AvK0t+FiBtLIC80pBQm/5KxUJT6zbMW9GJX8pBB+gr0Y+1JuCdp2MBiJ/SDDkbZrcwSE7sknx6lefxdmAE2vSYZoCmlvIdSw006aBdXnQnLBSrl
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(346002)(366004)(376002)(39850400004)(396003)(6486002)(8936002)(2906002)(6506007)(4744005)(316002)(52116002)(8676002)(956004)(2616005)(16526019)(54906003)(86362001)(26005)(186003)(4326008)(478600001)(1076003)(66946007)(36756003)(5660300002)(66556008)(6512007)(107886003)(66476007)(6666004)(8886007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Wy5A5xhnoqq0k7XPVhSvZpOqZMvUS8IAIyiPaTZ+d5lZpK4S/rvWv0Oh1rfsOsQr1cPfA1Xm8TwtDTpSVOaviS7cLKHv66av4JEXPMWZskIQHnQiB8kG1cufD3mxpPrU3KEgS4ufFyjNV5SX3fosmqWQTZlpQv11Ww8fV2INeAoj/e0CZG3uye3PuG72OyvsV4EaSKx0mGaLSl+bgvCIbh37kch+uq3Xo3cCXaY/yg4JnYCEcyMm88birXx44q20aIbLWOrEq+zpvswogKY2lU4Uk7kyUAv6LyyZpKCfPSMZfIVUGrW3Tk2iEc0YbKmfY+fWlo2VcYmvziLQH+7Uc/u+rfYXMs+n5X6dpi2OHtDDIpPm2A75Div6Z7CIWcpap8n7fjPMGNyK1uCbL7ouex/OKjM1Q0j0FxCUCde5N8qdcsVbdu8RukgRsLu9RiEfhLNSMYkgTPxDqeTRK8yCQ7g28kblsaCqBCov3s2c8Ag=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75d432f8-6dc5-41af-66ac-08d7f8aabe04
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2020 08:34:11.5081
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 25Vevilr/bA3LTZ5qh7bFqo6OTLO9Nn0Xxs2E9MQQIqUR7/z95KPLBzOU9UlqAN4V4PR8lJpiNaFlExzw0F7TA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB2030
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKd2Z4
X3N0b3BfYXAoKSBhbmQgd2Z4X3Jlc2V0KCkgZG8gdGhlIHNhbWUgdGhpbmcuIE1lcmdlIHRoZW0u
CgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFi
cy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYyB8IDYgKy0tLS0tCiAxIGZpbGUg
Y2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDUgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJp
dmVycy9zdGFnaW5nL3dmeC9zdGEuYyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKaW5kZXgg
ZTA3N2Y0MmI2MmRjLi43ZDlmNjgwY2E1M2EgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93
Zngvc3RhLmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYwpAQCAtNDc5LDExICs0Nzks
NyBAQCB2b2lkIHdmeF9zdG9wX2FwKHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3LCBzdHJ1Y3QgaWVl
ZTgwMjExX3ZpZiAqdmlmKQogewogCXN0cnVjdCB3ZnhfdmlmICp3dmlmID0gKHN0cnVjdCB3Znhf
dmlmICopdmlmLT5kcnZfcHJpdjsKIAotCWhpZl9yZXNldCh3dmlmLCBmYWxzZSk7Ci0Jd2Z4X3R4
X3BvbGljeV9pbml0KHd2aWYpOwotCWlmICh3dmlmX2NvdW50KHd2aWYtPndkZXYpIDw9IDEpCi0J
CWhpZl9zZXRfYmxvY2tfYWNrX3BvbGljeSh3dmlmLCAweEZGLCAweEZGKTsKLQl3dmlmLT5ic3Nf
bm90X3N1cHBvcnRfcHNfcG9sbCA9IGZhbHNlOworCXdmeF9yZXNldCh3dmlmKTsKIH0KIAogc3Rh
dGljIHZvaWQgd2Z4X2pvaW5fZmluYWxpemUoc3RydWN0IHdmeF92aWYgKnd2aWYsCi0tIAoyLjI2
LjIKCg==
