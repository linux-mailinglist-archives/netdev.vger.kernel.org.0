Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 185491C55C1
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 14:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729016AbgEEMiU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 08:38:20 -0400
Received: from mail-eopbgr680041.outbound.protection.outlook.com ([40.107.68.41]:21169
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728820AbgEEMiR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 May 2020 08:38:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N7goQeyxUWFKBEGlfQ+yiFkFW4mI8J+PpogtRXO82IQR0Wp6L6OSfDepiel1GUfI7xTGdD0601uuASoZyudizsKQh5e6v6ItxpD2j8QfKqSnQGZWj5fc7B7xt4OGmo1TYoVHmOrF3GtvxDWK48TvdmxIl7JX2si/ih7zpyj2nNjMxczzSPqkaxz6lgbdOi0bZi4vjv8feqTAZEaZO/+TZKz/emrUllbcZFc0UZSQvKfnrBmbcQecCyKdeElbgZLO30dvVBFV2mdh30ySTPZPqxTy1IV0uCwCusbEltUMkt5MOOLK6InUURYPW8xmdsxtDCzg6IUWHjfF9k/1TkA9jQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kg0fpV6J8wbKQWde4/vMX8w/mrW9jr6sKX+MkbzvZ0c=;
 b=hzKwesXYc5zAbYzt54aNT6Q8ASYRzueQZsCrfXWxt15vY+6EOoRN+aC64uYWlnd/xeVeBtf3NAZXLa4S2n5hvOhtdEnBjCccka+QCyNpoERsd8qGh7RUyrKHDgmiUYc2hlzI7Fsvl+R2r8oHs+aJv2Wi3U3XaDmSiveUjz/LzbwQMymz6CBq58M78SWffe5R7okvwcV0cKFig82Tv7xHa+WjrmEUmDiiizpl0etkc1ajOZkWvXaYjP3jgNjEBJmbgmYQEzawv5Sl8hFKy4zSzIhgM9Ai83sPLqBxvpdOUVP6xVZS9/Y431cFL8SwcwAWgelQDl8rucDJ0SfU4MYhHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kg0fpV6J8wbKQWde4/vMX8w/mrW9jr6sKX+MkbzvZ0c=;
 b=cmqiCfJLahr+WYRpRKksawian0jL4NW8BsX4bMQ8u8SN3438lcCaQpwZVrOAOljncQOEmyG5i3ds42l9pxG8Lpyeco1tQq0aV2zPMYrodr48nYrz5X/f2Gfsg1CZDLhRYzFRwn7ZJikceVPaoV2kb68idOvuHzv/jSTZd7u306g=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHPR11MB1824.namprd11.prod.outlook.com (2603:10b6:300:110::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19; Tue, 5 May
 2020 12:38:13 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe%10]) with mapi id 15.20.2958.030; Tue, 5 May 2020
 12:38:13 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 01/15] staging: wfx: add support for hardware revision 2 and further
Date:   Tue,  5 May 2020 14:37:43 +0200
Message-Id: <20200505123757.39506-2-Jerome.Pouiller@silabs.com>
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
Received: from pc-42.home (2a01:e35:2435:66a0:1265:30ff:fefd:6e7f) by PR3P189CA0022.EURP189.PROD.OUTLOOK.COM (2603:10a6:102:52::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend Transport; Tue, 5 May 2020 12:38:11 +0000
X-Mailer: git-send-email 2.26.1
X-Originating-IP: [2a01:e35:2435:66a0:1265:30ff:fefd:6e7f]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ccc18d7c-1497-4030-2bcc-08d7f0f12d20
X-MS-TrafficTypeDiagnostic: MWHPR11MB1824:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB18246F0B2EBC4D853BF1ECEC93A70@MWHPR11MB1824.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-Forefront-PRVS: 0394259C80
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u+YekbkNR/WwYp4Anam3WRL5tpErzLki6T8uWaPZF6Gug7jRaTwyELz6L4nylNHHGi20iKgg5e/FRIzbJnR5adhVjIJU2s+wpdsUhDJY2BxjwxNrSwl8SRvm0DzeVKsen8QDO9UB24xQQX9jK/TwfU44+Vhq+vU3ymgLd59KBpMcd4ZtiWh9xD1KXdo3Wwwb7B6bt/S2B2QW+jXjFgc1CGlMQeNa6wlEoVmR9HqzolOxGKoJZOfeXTEFVbu2KxpQ6RFo+ckkwtfH4ZT6K9hqice4lJgFYmGD2b8Pr/UTGvkuJd/gZKdX35ycyMBxHslkwASdxZPPSyBUa1I60FYxkYgMCN4Cc2AYGJc7PhYNLmfXhF7Iwnstb7D6yf+daCKKMN7OXDLfxW2/DLHk7lZO0AZ9I2D/M1OOOVQffZ46RW5zVKjBI1BV4VSJWx+5WPCGR8k2sL/S22/uOdTiidj3xhgqBWNFFZRC5IEx3b1lEp2h2mtRAAHA1oStHMM9ufBW7R3HEMJPWrACpEU/1Vh8ZQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(396003)(39850400004)(366004)(376002)(346002)(33430700001)(86362001)(6666004)(107886003)(8886007)(1076003)(6512007)(6486002)(66574012)(4744005)(36756003)(5660300002)(2906002)(66476007)(6506007)(16526019)(186003)(52116002)(66946007)(66556008)(54906003)(2616005)(4326008)(8936002)(8676002)(316002)(33440700001)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Gxy/EqGBBFuMgtlxlzCgZoD2V2TcyqCU5ly6t6cNAbT6li+L/mSmwfzROT+8vB7j2PKYEKWl8b1gIktyQR26EVpIXD4Cuad78f4A+MpUvLHae7xbSN8tl5i3YgnaAzaLu9Ic61K2Cj09buLguzGmAWGtJTVzb1V5KjjWFP9IzE9swgxcoM5d5qbXtdfwG2Gm76ucJwFbZBfjRueEOTtgGNub8qhctoL1CDR3kRLqO1+PdXSc3ji1Kaz2AlosJZsZ+FaKQgpkSajigdINwa8Xl92WncKM6A0kpfKO3GCMxXGYIPVY4xHGuhOMyg91P1kWlJBoZd2h+iSYnQSVnb0Jq3QcMlyc9vbKYToNs2/OGHtVxg+7ylqp3/Xvn0oK3tx0MUXPYMqf5n7dglIrqH2P2toNwfQGE2NBZbQT++/FT+nIjlOIigilclusG0u8r+ZaxmJCLcEuaIPtItnY/0a0+VxdRyCrRzoXjjd59Q63YvEwgzZvS/PeZSP0mSrqlLdRaACcQpL8zFhepPkQEkUeU4iXoMyc2B7DPR5FbW4KYdXEBYS5WLSEqhwUGwWp9KvBD0HW1Do4XMFS3NO4KUplB9NJLY6gMq5SAgdWbZnpUy6lgFQ3UlIka9b9RFTgoiENPJBV87gCCKaAwvHWgvJFHFbyVITssdo1KljKjyBCtOJvw0A9kpxTQDRZj9aTRoIgqKT9Za0mjpRvKpSMsSG6eFfdaKu5JGo2+t6IZPZYbJAhz2Q/ItoiGTwHf3/4M5JKFqVvFScf9nmGyDaxcC/8P/Xl+DjpJLQKiNdjI/11B/R8GDs9DzxVoNagIiZBTVdiyVSeXmHqbxKBH173vknUNycXmHdUy3+xdTqv/YH5F2w=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ccc18d7c-1497-4030-2bcc-08d7f0f12d20
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2020 12:38:13.5980
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ihUWIp8X/qkyMMYDWIVtVlyD+6MH92CO2bj5FidEwW/pR89zbqweMgRd2toGUIuWI2/Hi+9qfwGYRIQiSDMr0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1824
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKQ3Vy
cmVudGx5LCB0aGUgZHJpdmVyIGV4cGxpY2l0bHkgZXhjbHVkZSBzdXBwb3J0IGZvciBjaGlwIHdp
dGggdmVyc2lvbgpudW1iZXIgaXQgZG9lcyBub3Qga25vdy4gSG93ZXZlciwgaXQgdW5saWtlbHkg
dGhhdCBhbnkgZnV0dXIgaGFyZHdhcmUKY2hhbmdlIHdvdWxkIGJyZWFrIHRoZSBkcml2ZXIuIFRo
ZXJlZm9yZSwgd2UgcHJlZmVyIHRvIGludmVydCB0aGUgdGVzdAphbmQgb25seSBleGNsdWRlIHRo
ZSB2ZXJzaW9ucyB3ZSBrbm93IHRoZSBkcml2ZXIgZG9lcyBub3Qgc3VwcG9ydC4KClNpZ25lZC1v
ZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4KLS0t
CiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2Z3aW8uYyB8IDIgKy0KIDEgZmlsZSBjaGFuZ2VkLCAxIGlu
c2VydGlvbigrKSwgMSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93
ZngvZndpby5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9md2lvLmMKaW5kZXggOWQ2MTA4MmMxZTZj
Li5lMmY5MTQyOTY2NzcgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvZndpby5jCisr
KyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvZndpby5jCkBAIC0zNjAsNyArMzYwLDcgQEAgaW50IHdm
eF9pbml0X2RldmljZShzdHJ1Y3Qgd2Z4X2RldiAqd2RldikKIAlkZXZfZGJnKHdkZXYtPmRldiwg
ImluaXRpYWwgY29uZmlnIHJlZ2lzdGVyIHZhbHVlOiAlMDh4XG4iLCByZWcpOwogCiAJaHdfcmV2
aXNpb24gPSBGSUVMRF9HRVQoQ0ZHX0RFVklDRV9JRF9NQUpPUiwgcmVnKTsKLQlpZiAoaHdfcmV2
aXNpb24gPT0gMCB8fCBod19yZXZpc2lvbiA+IDIpIHsKKwlpZiAoaHdfcmV2aXNpb24gPT0gMCkg
ewogCQlkZXZfZXJyKHdkZXYtPmRldiwgImJhZCBoYXJkd2FyZSByZXZpc2lvbiBudW1iZXI6ICVk
XG4iLAogCQkJaHdfcmV2aXNpb24pOwogCQlyZXR1cm4gLUVOT0RFVjsKLS0gCjIuMjYuMQoK
