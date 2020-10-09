Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F003288FAE
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 19:14:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390021AbgJIRNY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 13:13:24 -0400
Received: from mail-eopbgr700055.outbound.protection.outlook.com ([40.107.70.55]:34657
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732488AbgJIRNX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 13:13:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FNmsIXcKV66r6d+HgcOfLnnvA7WmBPKe+8kDcaaTNLMmkAyDcZLh+gHEqymtQ2BzuzHIMwS/Ly3PQY/WRdOAzYgKJNvUKPiGf2KWRVMkEFQNclzkpAOKqxswbEotYdWxJF5iOjd20kdrJVZl81mttieUTUWWUSgxXOdrV3B81C6Sv20p2CBhwBbo4t8/Giq+zCEvhWwZ2vP0pDr7WDive35GAciXl98RJkXjx4pFJbFSmkDxPJAURH1UzcnuTNOBj8BozhoKX6TkSuF1eXk0N5AmA+J2WwlUq1e5E4keoGd2L91TLz4IrulNgwOwW+NDQZMxbPjYkH6Hv6fmBCMTLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RdQnn7KtqOF4b1wTixE5lJE2zyrDP49oqSRqyH6PopU=;
 b=L79MWWvcKhNkjiYnfmjUkMQKSbsWQe0K2yIGigPMRxksNAa98WMROyKat+hjAKVcSb1OnOr3SmYj8eFGsVeJ8V7Q4XYl98q1DmTJbTqe2uOXq6IvTWqmyphafnV4M5ziiPsi/m7sBRXsGr+539Z++2UALSvDA6Xu5praXk0EojCUZHpZxMFnL7jkvJuB8vumcN5TdqQPLQlyIzkBjKlDboD6VwsH2MT3yQY7nmRf0ZjJUMnggzEoytc1EOTtzs0lw+2pMRcvNZhlb9TuOqpq96UjjAV4Agvh3R0/nySVyrnGUZSaO78Ol0ZMGgMW5eZ/nKzgB2ID4vj9OcM4K554bA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RdQnn7KtqOF4b1wTixE5lJE2zyrDP49oqSRqyH6PopU=;
 b=OZk+oVJ5+0dOwsijg2m3a63HoAuWvDUl7/IrxAlbB8g0p4pjZ2dsXcjahMuw6+sPfXu5V4Dp1XsuE2Hdn37u7agd6XwE3JW4aOz/kx3VYZsLN4166K54BB3HNrnhJd/k3sdiruiC44uzVqKRhqFubufPbINVK0tuuDqGWSOX+Og=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB3087.namprd11.prod.outlook.com (2603:10b6:805:d3::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32; Fri, 9 Oct
 2020 17:13:22 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::4f5:fbe5:44a7:cb8a]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::4f5:fbe5:44a7:cb8a%5]) with mapi id 15.20.3455.024; Fri, 9 Oct 2020
 17:13:21 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 0/8] staging: wfx: fix issues reported by Smatch
Date:   Fri,  9 Oct 2020 19:12:59 +0200
Message-Id: <20201009171307.864608-1-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.28.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Originating-IP: [82.67.86.106]
X-ClientProxiedBy: SA9PR10CA0004.namprd10.prod.outlook.com
 (2603:10b6:806:a7::9) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (82.67.86.106) by SA9PR10CA0004.namprd10.prod.outlook.com (2603:10b6:806:a7::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.24 via Frontend Transport; Fri, 9 Oct 2020 17:13:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5b7c6d91-c731-4279-f840-08d86c769f95
X-MS-TrafficTypeDiagnostic: SN6PR11MB3087:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB30872AA1DD727DE7AE8C1F1E93080@SN6PR11MB3087.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 504BqhFaNsmnSPd8a/FxaTPXFGfmyrLQE8OVN1jDNxtYTRgr2PYg23M81yXJucxjn7KGe10UhpMPjqNKto4IA+WoIYysOcyDWqgmFRhT9SYMAC1uhXtPl8qmc+rhkGEeW8DaTtz+ruqolVQRvDBqhmqI4HtW6RqZlzLYbIOISEWIYN9SXy5H5DcrrUAbqFfJTKUNQkp/eo7ve0efF2owZzG50UuNb8ynFtBKeAb09tx6zE0DR/6W5kcyYCdNO+pkKBeYP1ETQZgWhQ2eePgQb+J9w6P1g66Gs+NIy8NuZy6oiq21lvtEz0voBKogd74OSMLEzg6ZyCgOsENrlYlf/VKsZ2K77CZxu/+H9uvm61fJa+w6u86WgRK/fFxhzfzIfA+5rT68ARzP2Ph4gvVGmA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39850400004)(136003)(376002)(346002)(366004)(7696005)(1076003)(2616005)(66476007)(36756003)(66556008)(956004)(478600001)(2906002)(6666004)(5660300002)(4744005)(54906003)(316002)(6486002)(4326008)(83080400001)(966005)(86362001)(8676002)(66946007)(8936002)(52116002)(107886003)(66574015)(186003)(26005)(16526019)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: z3lwGv0SUEIa8lQQOdCRBorGJqTvGwq9BEovAuy7B4DkTOW/dwhrYAzIFl7dPbF/a4Iyuxdc8zwThlHRECaSiUTGWRfojZFGJHiDzEwko317RBUnmCfvzqbhhcegmobh3Y2h1aXKLFqm8ZVWelNrunZwfg6KWzGWez31acs5PHEhyu4pmn8IVVeQjCt9ipePQqQSdzkQGbnPOG2LFpXMCkzXW0rpMK5koIyUdrYvkdYQtnL+Kv6UFFoDM+G/oQci3GgeSuPxaN9+/f5GPLmU0+9zKRE6yc5kDYaJXxu+ISA0wcXGK7mFnwFbALpYabaPkswpNlvgG1yI+lmIRMFHdEhC8FRwjAkbUUFtjStKeLbY2GZ8oc2RyV9Hhe1hDjCSOIaXHWjcK37/j3b/1CbxURnBn4uGXRujjW3EM/davaQD2Ws+PTIBdR/v3Fskip8/B+uutYDcmH1X8ua2QdgoVjnhr+RXPhpFRU5OIUu8SgarOVV4NTwDwe7zpNe8tdACzYJ09hB/ej5IisOBRmThxaF1ZafEKl5xaaEf+/6iINDOgm8MIKf54HUhSPu2mA37uNGmLRsjAIc692gHk5e4PDh1mv0mgjUpqgIWrgu/eobZ5OfE6xMv55jk1PPBYOWVQ4W1lBLu8Wu46m3Ue8/P+g==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b7c6d91-c731-4279-f840-08d86c769f95
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2020 17:13:21.5739
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B8w4Iv7rPhZ3Wblb7s4++Ru1LVvshdg25cx63M5xmj4L+1PTNlOxJeIYWSNcqJblK2QfrXwxqVFxOLNHSIEhAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3087
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKRml4
IHRoZSBpc3N1ZXMgcmVwb3J0ZWQgYnkgRGFuIHVzaW5nIFNtYXRjaFsxXS4KClsxXSBodHRwczov
L2xvcmUua2VybmVsLm9yZy9sa21sLzIwMjAxMDA4MTMxMzIwLkdBMTA0MkBrYWRhbS8KCkrDqXLD
tG1lIFBvdWlsbGVyICg4KToKICBzdGFnaW5nOiB3Zng6IGltcHJvdmUgZXJyb3IgaGFuZGxpbmcg
b2YgaGlmX2pvaW4oKQogIHN0YWdpbmc6IHdmeDogY2hlY2sgbWVtb3J5IGFsbG9jYXRpb24KICBz
dGFnaW5nOiB3Zng6IHN0YW5kYXJkaXplIHRoZSBlcnJvciB3aGVuIHZpZiBkb2VzIG5vdCBleGlz
dAogIHN0YWdpbmc6IHdmeDogd2Z4X2luaXRfY29tbW9uKCkgcmV0dXJucyBOVUxMIG9uIGVycm9y
CiAgc3RhZ2luZzogd2Z4OiBpbmNyZWFzZSByb2J1c3RuZXNzIG9mIGhpZl9nZW5lcmljX2NvbmZp
cm0oKQogIHN0YWdpbmc6IHdmeDogZ3Bpb2RfZ2V0X3ZhbHVlKCkgY2FuIHJldHVybiBhbiBlcnJv
cgogIHN0YWdpbmc6IHdmeDogZHJvcCB1bmljb2RlIGNoYXJhY3RlcnMgZnJvbSBzdHJpbmdzCiAg
c3RhZ2luZzogd2Z4OiBpbXByb3ZlIHJvYnVzdG5lc3Mgb2Ygd2Z4X2dldF9od19yYXRlKCkKCiBk
cml2ZXJzL3N0YWdpbmcvd2Z4L2JoLmMgICAgICB8ICAyICstCiBkcml2ZXJzL3N0YWdpbmcvd2Z4
L2RhdGFfdHguYyB8ICA5ICsrKysrKy0KIGRyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3J4LmMgIHwg
NDQgKysrKysrKysrKysrKysrKysrKysrKystLS0tLS0tLS0tLS0KIGRyaXZlcnMvc3RhZ2luZy93
ZngvaGlmX3R4LmMgIHwgIDQgKysrLQogZHJpdmVycy9zdGFnaW5nL3dmeC9tYWluLmMgICAgfCAx
MCArKysrKystLQogZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYyAgICAgfCAgNCArKysrCiA2IGZp
bGVzIGNoYW5nZWQsIDUzIGluc2VydGlvbnMoKyksIDIwIGRlbGV0aW9ucygtKQoKLS0gCjIuMjgu
MAoK
