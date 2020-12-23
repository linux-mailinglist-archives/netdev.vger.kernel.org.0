Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A136B2E1E61
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 16:43:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728442AbgLWPkt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 10:40:49 -0500
Received: from mail-mw2nam12on2063.outbound.protection.outlook.com ([40.107.244.63]:15105
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727207AbgLWPks (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Dec 2020 10:40:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b+ZwTyMFWZLWqthHv6z5KCfCASo6ZqlAYgQvem0PEZquvWgsO2LfHOiGsbNOvfElsp5j5vKjkLm2nKwUaGZQJ71x1z46KFLbK8qc6T4pWSP6BJU9t0hiozDxtqOgrjVUctNfoCnaaTS1noNqBke9BZqPkEOjRR3r5uMVMFDRhdCt+fwHFb86fV9GD2aWDrb/EdTRoTRoKdRO8q6ZpXX8rwSdI1v+YeLuJ0jOiQqT6miFZobpkfvMIFyTWgBE6f/CYGWPepJVyoKMcxbVSDoBUR7zE6KU3EhbJ1acXcsBEI9fmS7dLjQKuDuMia6W9zektnQnciv+w+S8QxZahJIS/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+PQnugVFQUogr3RQecwba27lQbNH5Z1PJCDZzJID6Ws=;
 b=hKEZNbL60t51N0f/Pe3nfAqo//FWcys6uk9VUKH2ssSuT3gEg8O4NdcNXDDuVnZPnUBI0p+/B6d41kxg9RVBVPiiJDqR6s/Q9Fg09vDKumpjKVx6nYpIg9rfCrPwXaXG6CMTVzHwkbYNVsfo6FB0eL0F+2fDPv6mzkYub0RkQ7PKIC1Y/nJIvvSC42lWvoz2GX2pQb8pGT/Es6uFCX0C694+ihvtla3dBN7CDI/z+Ixv/NVYf1wMEukq4BqBBnWYh6FVSxSgSJMBXhNj7Jb9XS780QSSwsBGGosXd8FFyl9jqHHqvZ9bjSucNmrDrPShUgThUDnemIFVUKy8FNdlKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+PQnugVFQUogr3RQecwba27lQbNH5Z1PJCDZzJID6Ws=;
 b=T+DxsLlIDrF5U4tex3LfqLmQFHnixwDf/pAZKZ2fGJgMoWj8PuJHhaK70yvkMjbiEdtkhm3tXVZs9f1syiNb34IDgRIMKA1hQJHCblw3XjjsGsi892YWBDXKACLZsuQ1YBSBRAQADjRtr6EL7Cu/Lw3AqKQ5/R502SHZ7oEEQ7k=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB2815.namprd11.prod.outlook.com (2603:10b6:805:62::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.25; Wed, 23 Dec
 2020 15:39:45 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::a989:f850:6736:97ca]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::a989:f850:6736:97ca%5]) with mapi id 15.20.3700.026; Wed, 23 Dec 2020
 15:39:45 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-mmc@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v4 01/24] mmc: sdio: add SDIO IDs for Silabs WF200 chip
Date:   Wed, 23 Dec 2020 16:39:02 +0100
Message-Id: <20201223153925.73742-2-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201223153925.73742-1-Jerome.Pouiller@silabs.com>
References: <20201223153925.73742-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Originating-IP: [82.67.86.106]
X-ClientProxiedBy: SA0PR12CA0024.namprd12.prod.outlook.com
 (2603:10b6:806:6f::29) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (82.67.86.106) by SA0PR12CA0024.namprd12.prod.outlook.com (2603:10b6:806:6f::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3700.27 via Frontend Transport; Wed, 23 Dec 2020 15:39:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 75e6b8b4-bf23-474f-342b-08d8a758f95d
X-MS-TrafficTypeDiagnostic: SN6PR11MB2815:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB2815AD12AFDBCF20366E22D993DE0@SN6PR11MB2815.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H1mUk9tGQANv7e/PlFfXsZJeeFSaR5Dq4S5MpMzBkbJq//QzdTuCvOoEWPs7uGqOX++H0e+cBIsVdhVjZ/0CKGOx49l5e8+U81SY6FQN2ZC2K3TmkV5tj0vElNN/E0aMiPcoflYQPWJxsTpiuz35DTSEUFQDG+korBr9CWmvI0gy1pZCexzNouOdQRcqthmTrQ5AxjY/Ilr6wP4vuMSVx+dcTb8oFMz/Y3d8U8c3cNEvopg6CdViwMDI3jBxY2rJbpmi8ickUmaFg5u7yN1gOU+DT66bqTPTaamAxj2K7yunMHl0+P5kImY/HQolavG/AEiYVbNFKV05hIMupR0iUn0ucHK5Y7ltOlbEAN2dqCTALMIIBIJUXarmOmZumqq/kT7issfBzJ5xROnIn4vw0w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(366004)(376002)(39850400004)(346002)(478600001)(8676002)(186003)(2906002)(8936002)(26005)(52116002)(107886003)(16526019)(7696005)(66946007)(7416002)(6486002)(956004)(4744005)(2616005)(54906003)(66476007)(316002)(4326008)(6666004)(36756003)(5660300002)(1076003)(86362001)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?QThCTmd4WDBrdVMyMkJMdWVRcVUwTTRuOTlaOGg5eUpsSllybkpsc0R1ZGhz?=
 =?utf-8?B?bnBXdHBZN0loU0hqNDR3T1AzZEQyc0JtYXdJUVVrcExsUXV1akg4dDVtSXJa?=
 =?utf-8?B?bjQvaXVJUHV5RDZVeFgwS2tiQksyNE1CTWYwT3R1VXYrSGdMUExGLyt1RTVF?=
 =?utf-8?B?ZnB5ZldoRFFJUzJJbDZaZkNaOGlqdXJzRk9CeGZLd3dpREJDbkJkZkN2cTNQ?=
 =?utf-8?B?U05QL0N1cVlQeklkcmk1TldkQlIwYUZodmNjTC93R1RucTdNNm5LczJoUnds?=
 =?utf-8?B?SzE4VytkR0JQUjVVMExOclhGNVBuL05PVERrUHBMSzQ5VXU5NTRZNFVyRENa?=
 =?utf-8?B?Z2dXRUxlanFETU1DRmVabnFsVWluZUVnRHNlcktBWVNDRnZjYkU3U2UyZW90?=
 =?utf-8?B?aldMQlljQzZaQzliTjNSYlJkRDQ5RlZWSnZUdDJvdXM0ekVFeXdOVmtLOVJo?=
 =?utf-8?B?aVZNTDRHd3djYndSK3ZrdFlsY1d3Y1NzN3BWbjlKUHFzZGhYRUowc29QT3F3?=
 =?utf-8?B?ZHB2Y3k2eGJmb0VTZVJTQzNmMFNJS3JhMTRXRUcxZ3Z6UUpkckFlbVg2aWQv?=
 =?utf-8?B?STN6MVZRa3JoUFYrTHdYQlJhYllrNjIwT2MyQzBoY21pQ3JuY0FRN0V3Tk0x?=
 =?utf-8?B?OUJSSEF4WlhtM2FIUkMzNkZtNlVIZjVrYVByNEd5RGdXY2paNWliZlpVbEFP?=
 =?utf-8?B?dFRMbVE1dFQzNkpraVJTTFNURVZ4czdGRGVwR3ZBQnkwVCtqZ3hVVzlGUWd3?=
 =?utf-8?B?L3pMWmowWTg4VFlVRFVCcmhvQno2a0R3Sk5mdnlmZkVQNCtXS3NDM25ibVI3?=
 =?utf-8?B?am5xamQwRmNZVWlPVEtkTWplMktvck9LQXJUN3lLcnpiRlAzK2UvV01hZE5h?=
 =?utf-8?B?RE1XeWdTTndjSWNNbHBTM2h2N09obDRMVkpNU3FZclRqTzZ5TVJPOUp5MGlw?=
 =?utf-8?B?K0F4MkxUcyt2ejFqTG9aVDdIc2IzZCttaVU2RDhTank3WTI0MmlEOWhBbTYw?=
 =?utf-8?B?V3hoc3BJdExnNGZYQmVZbUswRk54VGpPYkxLbHF1R1JxeTJhRldqRWk0RWlw?=
 =?utf-8?B?Ry9BY0RrUExoV0V2T1ROTFlZb1dtcE02NStYYUxxTitKalRWYlBVbS9YUmR1?=
 =?utf-8?B?YXV4eEpYWlljRFBONStvZkMvRURpRGd4cHdkdmE2bjRHSWV1L1Nvb0hQSW5M?=
 =?utf-8?B?MnlhbkxCVmtENjBlYmllNUN1NDNydmsrb0hidlBQSTViUzVYeE5pVXoyRnI2?=
 =?utf-8?B?Mldtd1BCS1dWeU1odmNNQ0NDWTNiM3dRZWc3SndhUnlQQ2dJbWUyMy82NWsy?=
 =?utf-8?Q?7gZwM39g8D6E4=3D?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2020 15:39:45.4791
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-Network-Message-Id: 75e6b8b4-bf23-474f-342b-08d8a758f95d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: smy9MAM9FgxBTva3QLKdtxgj5OogGtPayKSDrngpeqQ/eeR3oHit8VIsrfhhPOGkjxGzH+0Rf37lID8481mWRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2815
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKQWRk
IFNpbGFicyBTRElPIElEIHRvIHNkaW9faWRzLmguCgpOb3RlIHRoYXQgdGhlIHZhbHVlcyB1c2Vk
IGJ5IFNpbGFicyBhcmUgdW5jb21tb24uIEEgZHJpdmVyIGNhbm5vdCBmdWxseQpyZWx5IG9uIHRo
ZSBTRElPIFBuUC4gSXQgc2hvdWxkIGFsc28gY2hlY2sgaWYgdGhlIGRldmljZSBpcyBkZWNsYXJl
ZCBpbgp0aGUgRFQuCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBv
dWlsbGVyQHNpbGFicy5jb20+Ci0tLQogaW5jbHVkZS9saW51eC9tbWMvc2Rpb19pZHMuaCB8IDcg
KysrKysrKwogMSBmaWxlIGNoYW5nZWQsIDcgaW5zZXJ0aW9ucygrKQoKZGlmZiAtLWdpdCBhL2lu
Y2x1ZGUvbGludXgvbW1jL3NkaW9faWRzLmggYi9pbmNsdWRlL2xpbnV4L21tYy9zZGlvX2lkcy5o
CmluZGV4IDEyMDM2NjE5MzQ2Yy4uNzM0OTE4ZmJmMTY0IDEwMDY0NAotLS0gYS9pbmNsdWRlL2xp
bnV4L21tYy9zZGlvX2lkcy5oCisrKyBiL2luY2x1ZGUvbGludXgvbW1jL3NkaW9faWRzLmgKQEAg
LTI1LDYgKzI1LDEzIEBACiAgKiBWZW5kb3JzIGFuZCBkZXZpY2VzLiAgU29ydCBrZXk6IHZlbmRv
ciBmaXJzdCwgZGV2aWNlIG5leHQuCiAgKi8KIAorLyoKKyAqIFNpbGFicyBkb2VzIG5vdCB1c2Ug
YSByZWxpYWJsZSB2ZW5kb3IgSUQuIFRvIGF2b2lkIGNvbmZsaWN0cywgdGhlIGRyaXZlcgorICog
d29uJ3QgcHJvYmUgdGhlIGRldmljZSBpZiBpdCBpcyBub3QgYWxzbyBkZWNsYXJlZCBpbiB0aGUg
RFQuCisgKi8KKyNkZWZpbmUgU0RJT19WRU5ET1JfSURfU0lMQUJTCQkJMHgwMDAwCisjZGVmaW5l
IFNESU9fREVWSUNFX0lEX1NJTEFCU19XRjIwMAkJMHgxMDAwCisKICNkZWZpbmUgU0RJT19WRU5E
T1JfSURfU1RFCQkJMHgwMDIwCiAjZGVmaW5lIFNESU9fREVWSUNFX0lEX1NURV9DVzEyMDAJCTB4
MjI4MAogCi0tIAoyLjI5LjIKCg==
