Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4704E25F79D
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 12:17:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728796AbgIGKRC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 06:17:02 -0400
Received: from mail-eopbgr770058.outbound.protection.outlook.com ([40.107.77.58]:18596
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728740AbgIGKQ3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 06:16:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jw+AMvVAmGMJGhdWoK+MGuIF6/QCWiNaxwBLas2g4Sx75CNlVcvfP816w3V+wb+RXar3jvJoPAyi2x8RdZ9W3W37ZeGYlHbURij5Kwm1DlBN8zxBcDCZKy7PP8+MR4dW8qfYDx+0redT1Xdof5G5YopeyraKylvYJlXyB0igBANebjKhMzjvVGv40ouKk/Ua0BDiMr9CeeW81+pL/2N9tmPx4zj1GCBrQCrQS6YsaJNViMA/H4VBOtmxR6JUeGrbkoVWuqnbdB5H0tTgbPBdlxmS1+UYx9FB/fB0h3Mg1Z4AKN8raEUYGWf0C1miZX9nMxjk5XuPE2zi/UGQ3j+HSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ymZ8Ry/Xl4xkB76feNsIwKl+LQiceEInvMQJe0UCX5A=;
 b=S8YaEGpG3E/tbbdzFaw7WonrMd49x0LpXo36KRYaz4AGOzgitsafbEK8pc4cpX0x4/8ZKxqReiOy12aknP+9t9jYW+JMCrgOD8cllLzb3qr9NSa+HRUdBj7ELE7UPlJcdyJKvhYhmBJPW5oPks/IlTlEGL4TWJrOQhMOgLrvLbOJORQlSbBteXLwC4SFdXPhOdk8GbjPtIz5qp1lkxlNo1jUDiORvqETABvcxNZcCe0QRHXemL/HWyouq+yduoJHMscSEihoVqus6rV8fqSgr4pgx24RxY8ibFy7isBRFcmDWbdELHkd/nHtPVURQNtyYC/PUTWtDDvX3iGsIWKg5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ymZ8Ry/Xl4xkB76feNsIwKl+LQiceEInvMQJe0UCX5A=;
 b=LffBZMLOTvIZcrq6tMR6zoTIjJ5E0bK5SOAeO/KqTNh3wWAnW0SFMDjdZhM75ftggm+AOTyaDiYfbrE6GSBirYk6MHzE1e3KZoM4DrHwRliqNez5Sb6U6blcUZ33FPuyYg4pmUUyvpCTrgka4mk6m96PltI/MWe3ID2g3QbJdoo=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB2606.namprd11.prod.outlook.com (2603:10b6:805:55::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.17; Mon, 7 Sep
 2020 10:16:06 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::85c9:1aa9:aeab:3fa6]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::85c9:1aa9:aeab:3fa6%4]) with mapi id 15.20.3348.019; Mon, 7 Sep 2020
 10:16:06 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 13/31] staging: wfx: drop useless struct hif_bss_flags
Date:   Mon,  7 Sep 2020 12:15:03 +0200
Message-Id: <20200907101521.66082-14-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200907101521.66082-1-Jerome.Pouiller@silabs.com>
References: <20200907101521.66082-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR0P264CA0109.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:19::25) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (37.71.187.125) by PR0P264CA0109.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:19::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.16 via Frontend Transport; Mon, 7 Sep 2020 10:16:04 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [37.71.187.125]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3cf47290-2fa3-457c-fa23-08d8531707f9
X-MS-TrafficTypeDiagnostic: SN6PR11MB2606:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB2606983E07BC2F682AFA4CB693280@SN6PR11MB2606.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:551;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7te9NdC0PujWR+TSLL/93Oe9jjL+ep2TOvDgeNqoxm5GpKfdti59hD5pIOhpmNLma25fToQTAP49QIVx/RhJTlSdVXryIiQ0LegIzKKg9Og10IB4lUJeakc04sktarpBBUSn0+B2i9paA9bQd9K5BsVIVWiwJefb+zPaw1uHJ+4brGz+0H3IQ7cydQPRHVSObI0eJFAdRD8sWedHoTgXeeX0MpjaDCtKihrjuooL80T7z/k26LyIL/zxncKq7tMTGiSuSWpKuHrBYUNJ2IlBZva82sPcgQ7P9rUFHsf4QSsy8o5jCPQxEtwiubo/D4bqbWZA5lE3CavS78Ts22x5uw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(346002)(366004)(136003)(39850400004)(4744005)(66946007)(4326008)(5660300002)(2616005)(66476007)(316002)(956004)(478600001)(54906003)(52116002)(2906002)(66556008)(1076003)(36756003)(8676002)(86362001)(6486002)(8936002)(7696005)(83380400001)(26005)(107886003)(16526019)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 0X1VYXiIkbD7Qnc2W27n9vv/S+DxliDOQ3nHkFgn3NzbAsjd+dpbpMQ/FqbEv42rzNjoTIZL9nlyFgGtSyEQx52v7rnd8rMzr0BpCfXUiyJNy+0Lxpm7r2tjGrL02AUce9LP+ZuNlyCE9E7LRHaPHTRvpWBq0rHBafqCaq9Q+EfSJ/Bem6yQDMc0+mzUttCI0fNML9uCz/tBDQxGKjNQcChedDQ4dFg//XshAaHgzD0iorLXs9v3qpE/whNcNf5WEstgsZl3lZJgPymCDbOGiQxpOemicnLVGXLF8XwAkAuGjEOAUC723wHsWEJT0lqbeYH4pW4lt79z5x4Jm+VR3zCJEaQKfdLzXxMoM3QQFawfHOIyhtq397cmq2J/G/a6GrdpnNHQGubtMONfmh3gz2al1ihbZodCH/ct67Y66BW8x6k6tvUnsyB0ECv68vp0v1ruMBiLnSOXic8UA4mFNddU8zMmvVgHCFrxHp/4QQKxLSxFX7HgOze8/S94VxXj+NU9Ds4/BGP7Uoq7ARkfcQyA1YNHifoOqT/7hmqzjCPVW5LJiU+fMAglvz8eNWxpL/BqHqMIb2KgHrK4oJtyc1u0UylzvKp1w854xo1gslGxAIU4kH100+hiXPr+TysdsrFYnFJEkRwsEQqZKcEL8Q==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cf47290-2fa3-457c-fa23-08d8531707f9
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2020 10:16:05.9229
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G6oLWG8eEoNCH96PJ/f2hOPcIPJWK0/Bsr9wgpoKnIgqIfvcn84O70s1ZAy1q5fk1Wcy+Buq9SmICcbyQ1g28g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2606
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKU3Ry
dWN0IGhpZl9ic3NfZmxhZ3MgaGFzIG5vIHJlYXNvbiB0byBleGlzdC4gSW4gYWRkLCBpdCBpcyBu
ZXZlciB1c2VkLgpEcm9wIGl0LgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGpl
cm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvaGlmX2Fw
aV9jbWQuaCB8IDYgKy0tLS0tCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDUgZGVs
ZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfYXBpX2NtZC5o
IGIvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfYXBpX2NtZC5oCmluZGV4IDFjOTk0MzFlYjkwZi4u
ODk1ZjI2ZDlmMWEyIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9hcGlfY21k
LmgKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfYXBpX2NtZC5oCkBAIC0zNjYsMTMgKzM2
Niw5IEBAIHN0cnVjdCBoaWZfaW5kX2pvaW5fY29tcGxldGUgewogCV9fbGUzMiBzdGF0dXM7CiB9
IF9fcGFja2VkOwogCi1zdHJ1Y3QgaGlmX2Jzc19mbGFncyB7CitzdHJ1Y3QgaGlmX3JlcV9zZXRf
YnNzX3BhcmFtcyB7CiAJdTggICAgIGxvc3RfY291bnRfb25seToxOwogCXU4ICAgICByZXNlcnZl
ZDo3OwotfSBfX3BhY2tlZDsKLQotc3RydWN0IGhpZl9yZXFfc2V0X2Jzc19wYXJhbXMgewotCXN0
cnVjdCBoaWZfYnNzX2ZsYWdzIGJzc19mbGFnczsKIAl1OCAgICAgYmVhY29uX2xvc3RfY291bnQ7
CiAJX19sZTE2IGFpZDsKIAlfX2xlMzIgb3BlcmF0aW9uYWxfcmF0ZV9zZXQ7Ci0tIAoyLjI4LjAK
Cg==
