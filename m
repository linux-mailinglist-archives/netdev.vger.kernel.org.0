Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E26448D3FC
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 09:56:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231758AbiAMIz7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 03:55:59 -0500
Received: from mail-co1nam11on2086.outbound.protection.outlook.com ([40.107.220.86]:28322
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231301AbiAMIzy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jan 2022 03:55:54 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gawe/DMOkk9hzqZo0qmvfBdz8OW8hhAEq2dH2SV/5O7qtGz7bo63om+w9bSTKGj16ia1keSgMHW2hm3OHaEXFskyjyvKFGyVzRajexYb3xA3RIxloJ5qXdxqdUNhgCyys9fvqUGmieO2cqeY4BIks+vM28u2Ablae3JUYpjjMj7p91QlejIzxOoXDOHVy3LS4MDBHBo7yCYNGAHNQqmXbl5kO2mYaqFlDs0fQ24n8vFVUQQDUzwNkb3LpmKFBW1AOvmrJhEcxHoOuAndDKwzv/n3HByNMx9LrbcVqntpSbWNgFKD1napCugASV/n0qZ0UOnJv9MOIjFCCiuIg3Wk5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K2NpYeKofP+AM3/AJSHbF84kPqm4EPUJUKSnHPkPhns=;
 b=gMqN6kkzRfH3DgX0Djg02RzpLOqlNp2cgYO9ceow7SmLeAFktU6fzG2eZtDCAbHZzTA1/v0z/AMLZyFGWZAmk9DrKHClnHSZRfjb5dOfUgagexMwd6ZtjAi9T8FjckZJNJzCMv38xxjK678FoI0H6js+aWGKSJoNs1P2fz5i6w6zFJLKCcGyIrwGfhdl5dOtO0REvnJRFuD7nFhew7MmaO3sJWx8ex4gy/Eu7fEqYscZ3N2lfuEfXXFhfw6TzZJS/V9FvcXU8EUXk8VxJ299jGzp8acGoaOOUlbLCxz62mHSmivFSpbTZuBwxNL3au+oKgi8w62vFufc4SMI7Q/EdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K2NpYeKofP+AM3/AJSHbF84kPqm4EPUJUKSnHPkPhns=;
 b=nz++PNadxM6GDwmhBd//P+ZX2DftOnpqc5aw+wJXD5XZ4WYzjnzOpTfTkIh/Bw513MUVijyCSeHpF6/61cIwHQI9XUL3EX1d0iIcTmnjhNHlqvGGtD+GUO15hCdGLzOahKURmDsWkn5/zVi9S/Y0APnJEet9Uv2u5Rmnou1Txfw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=silabs.com;
Received: from PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
 by BY5PR11MB4040.namprd11.prod.outlook.com (2603:10b6:a03:186::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.10; Thu, 13 Jan
 2022 08:55:48 +0000
Received: from PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::d031:da9e:71a:73e4]) by PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::d031:da9e:71a:73e4%5]) with mapi id 15.20.4888.011; Thu, 13 Jan 2022
 08:55:48 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 05/31] staging: wfx: explain uncommon Makefile statement
Date:   Thu, 13 Jan 2022 09:54:58 +0100
Message-Id: <20220113085524.1110708-6-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220113085524.1110708-1-Jerome.Pouiller@silabs.com>
References: <20220113085524.1110708-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: SA0PR11CA0117.namprd11.prod.outlook.com
 (2603:10b6:806:d1::32) To PH0PR11MB5657.namprd11.prod.outlook.com
 (2603:10b6:510:ee::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fb0d7bfe-424c-46c1-fcc8-08d9d6727dfd
X-MS-TrafficTypeDiagnostic: BY5PR11MB4040:EE_
X-Microsoft-Antispam-PRVS: <BY5PR11MB4040C8EAA2E15DA1E9B19F1393539@BY5PR11MB4040.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:597;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HmVfIUz0skLrCJ9YyRcuUXh5lAZZQXBaKaL470HBTeZhhgTxsd1SpiGFimKsi1LwblXRglSvasUOEiOk4ib+Zqv6r9OK1ApbQQUObepEdpTAkVonzhF1jSVRWU0oBs6w2Zo/7xWLUOKnoE8rAk1zm2QKv5wDkgckCsCQLo5kmyl74j2DLPD33ARGf/MNCp+DVzEKxyewJP+xX2Z/Reg6uXIK/x05xUGEe+qqPVEeqWJC29nb5nwkI4FF6qu2vZiuHwr+W4adFnhakKqnPnZjtRbG9uNTpZicrjBheI1fXhIp3fE6Q8n5mSRo1rv8sSt9pbNUl2F2PxBWkQ8SuGfNCkESsf6thdrmTMZjhUIXPoWfT67K8CtBplBxPpd2JuAgy2H49YQkQzXmsCo4sRoZD0KbLgpn4Qv5QFtRELaMHa/lzujPwkuNxrupWoR0lOQ3O0vDsARCOwh5OrRhBUDPruUGjMzTmuU0alQTKaCTFxDHXp5f9N5lLmJzgsMtLB5UPd3+AhL+w6LGqs2cPoJzZV/l+ra7kjRUOhU9qkVeFGVJqFFPX0rik3dJptbC9I7Oah4OQ9DGl2HS6w/tyODcjrah9Gb/eyhvKR+DPP3y5syWBJCUcjS5Oc4RMxB5FggAHbAWQsDuEhXO8JYl3efxsQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6506007)(508600001)(186003)(38100700002)(4744005)(4326008)(8936002)(6512007)(6666004)(66946007)(1076003)(2616005)(54906003)(86362001)(66556008)(2906002)(66476007)(316002)(52116002)(36756003)(5660300002)(8676002)(6486002)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QnoyTnM2MzdYUkJXYlFuYUpVMytIS0ErdFpMbTl4eE5zdU5wcGRaWDkwWGZi?=
 =?utf-8?B?UzVTcTFJQkdkcHYzYjhPRUMvY3NvQnd6T2pnSmpCQlZJSWtHS2JVOGNCbVZv?=
 =?utf-8?B?QnRoaHY2R3JGZG0vQndLSHpQN2xXTU5RcVJsSmZwSENBdDZpU1lGdG1Va0ho?=
 =?utf-8?B?MjdRUXBKR3hFc2ZlRzhXc0RNK3BvSnozU2k4UTU4RGZwV0s2K3FUUWJCQSt6?=
 =?utf-8?B?cW04eVdyTUd6Z0NkNDlPUEZ5d1AyeElQUW1FOWlUSlpPMkhjNmtFd2lOMTJD?=
 =?utf-8?B?UEN0cHA1c0tWM3NPdXV5SlJ1Yi9VZUpWd0RPSGlxZUJGTXE0dHBHQzlKSVd0?=
 =?utf-8?B?cjd0ejd3eFV0SWRGeHVVMVhkd1lrZEZoWjk3eUFnK1o5TVp0T0VxejhWcHkx?=
 =?utf-8?B?RHdzUHRnVkkwL2NKaDZWYTd4U0JzdnlLRVUzTTg0eXowbi94TzR3RFY0SUhq?=
 =?utf-8?B?TS9nV1dUdGJFbThvUGlaS1E1UTgwS3duaG05c3VXcnhNMHNGUi92VkxXVGFl?=
 =?utf-8?B?T0NuRThBUEJBUjZLeFNIdjRMZ1lpOEl3ZlJVMmlwOURqbGVORzlGWkJRNGdn?=
 =?utf-8?B?dHFlbUswdE5aejNqdU82NERjZlpTbzgzeDBSZ2ZFQ1pBV1puZHAzeUVxSUVy?=
 =?utf-8?B?RTF3YkdkWFMyRk5peUdIaGlaaUI4dzZNa3llU1pCZXlId1NoanFHUkpUQnZS?=
 =?utf-8?B?NjBrMGwrd0o1RTJwU2lING95cHBHM2xUWVdCWnIvajd1QmFQVldvbUlwZHNp?=
 =?utf-8?B?SDZVNUtCR0lLYlhXa05VNXc0VCtsNStKelh1ZVNJTzFPNWpJRmZiRDZZZHpW?=
 =?utf-8?B?STJ4TW85b0p4SytqejFuMmM0L2hyTFZIbWdJUVlXVVhSYUxXODgrRDZ6dktM?=
 =?utf-8?B?b25iT0VNaXNUeVIwUUlROTRWQ244Y2xweThXUHdxd0JmTnRhTG16SWtxQ3Nq?=
 =?utf-8?B?THZOZFJYaHBjbndtOVlyUEZjdE5VbWNyZ0QwbjVTUFdHQW12TTQwYTFhVWdS?=
 =?utf-8?B?VlA0YXBqVk1TU2lmQmxpK3ZkV0d3aUsxMnZ2MXhNbXlPZU5CNklGK00vTEJP?=
 =?utf-8?B?aWtWYWVuQXNxbjFuNEMyVjh6SDNITEZuRGVIUXBRY0JMNWc0UFlRa09aZnUy?=
 =?utf-8?B?Z2dGdVRaWVhxKzBISjVQZ2hEd0dQMHpyWC9FckFYMk1YMEVvMlBwNGRxMzEx?=
 =?utf-8?B?SDcvdEN5aDlob3g0NUlqT0xwTlMzL1NlRVBodHA3WFhJMWdPYTQwTStnQnlD?=
 =?utf-8?B?eHl1VHRVRnJDM0NTM01VOG85QW1yZDRabUhySDgyNUYvcmxaelI5eHN4V2ov?=
 =?utf-8?B?NGEzU1JVa3NXT0pZdlRUaXlBQ1daRkY1ckk2U3JMOE1iYnlmSGNyRWV0ZEhm?=
 =?utf-8?B?ZHdJb0NvZy9GelZDWjk5VVpsQnFwZGVBK3VtdGx6UGM3RllOa2lvMXdvWnpB?=
 =?utf-8?B?ZEFkcFBzcXBlQW9ZcjU2TkJkK3JIOGpJK3I1ZmVFbGVLZkFqQ3F0TjBpMzZR?=
 =?utf-8?B?WlR6VUVjV2dUOW4rSjlTcGNGL3VieHpoaFdhNythdjA0dVI4alkydThCYUs0?=
 =?utf-8?B?NjkxSkVsWER1TFZHZDZJanhTdlRLeE0wTERrcVhYQ3JUTXh2MzhyR0JPV1ZY?=
 =?utf-8?B?NElBV1RqSnZkbHlQTXppdzl1ckZwbTNjaFczZmswL0hvOEc5Szl5T0ppdytK?=
 =?utf-8?B?bTNrbFdpNmFGOTN0KzQ4d01GRFY4SnVFUC9Yb2M0UzJ0K3FiZEM3aDZKTU1p?=
 =?utf-8?B?eVJLYzFuOC91N2pTeW1GdTFsKzNjcVRlYXlsdEZGN0dvM1JEQzUrYjY5akNv?=
 =?utf-8?B?WittWWp6L3hvMlE5a1BSOGF4MzNGQWZnQnZMc3QrR3J6Tm9lZzVENURhcjVO?=
 =?utf-8?B?bVhUZTlEbVVIYVo1dHU5M2p1dDd6NHVOQzFLK0o5M2hrL08wdUNONmJld0JL?=
 =?utf-8?B?VXg3VGFFQU1iTFFvUFhjd2pPRG4wa1VDanZaMnh3UWZFRStyYjYvclNJS3RT?=
 =?utf-8?B?cnJuTFFrQkVndVljS1NmQm5mNE5PL2RLcDVxcEkwaFlaaU9LSXUxWVlWbHcw?=
 =?utf-8?B?S3haYjZvY1lPd01BdVdsa0hYNHM4M2N6RnRianR4NzA2dnhBbS9HeTZZSDhq?=
 =?utf-8?B?TVlwL0R3L3A0N1RjT1N5eUxJakFBSUloY05jdE1aRzNia2VLL1VxZktSVnNY?=
 =?utf-8?B?dEJ2RUJSZFB5S3pUdEVMa3VYV1ZTYWVMUmVBRUMzMnBxYm5uRENtWm1rSUUx?=
 =?utf-8?Q?Xot0m4ZwgYKyO0tc1Ms9ot21++kEaTloGzPqVxOFj4=3D?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb0d7bfe-424c-46c1-fcc8-08d9d6727dfd
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2022 08:55:48.0256
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JME37LQhw8llX0UtNwbNxrgx9w/8DA7vWAniJdrNb77+ORZ50f9CKprNnVYHd2SBfKPt1Q7lV6nxkp/wWnxTHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4040
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKSSBo
YXZlIGdvdCBxdWVzdGlvbnMgYWJvdXQgdGhpcyBsaW5lIGZyb20gc2V2ZXJhbCByZXZpZXdlcnMu
IEEgY29tbWVudAppcyBkZWZpbml0aXZlbHkgd2VsY29tZS4KClNpZ25lZC1vZmYtYnk6IErDqXLD
tG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4KLS0tCiBkcml2ZXJzL3N0
YWdpbmcvd2Z4L01ha2VmaWxlIHwgMSArCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKykK
CmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L01ha2VmaWxlIGIvZHJpdmVycy9zdGFn
aW5nL3dmeC9NYWtlZmlsZQppbmRleCAxZTk5ZTZmZmUwNDQuLmFlOTRjNjU1MmQ3NyAxMDA2NDQK
LS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9NYWtlZmlsZQorKysgYi9kcml2ZXJzL3N0YWdpbmcv
d2Z4L01ha2VmaWxlCkBAIC0yMCw2ICsyMCw3IEBAIHdmeC15IDo9IFwKIAlzdGEubyBcCiAJZGVi
dWcubwogd2Z4LSQoQ09ORklHX1NQSSkgKz0gYnVzX3NwaS5vCisjIFdoZW4gQ09ORklHX01NQyA9
PSBtLCBhcHBlbmQgdG8gJ3dmeC15JyAoYW5kIG5vdCB0byAnd2Z4LW0nKQogd2Z4LSQoc3Vic3Qg
bSx5LCQoQ09ORklHX01NQykpICs9IGJ1c19zZGlvLm8KIAogb2JqLSQoQ09ORklHX1dGWCkgKz0g
d2Z4Lm8KLS0gCjIuMzQuMQoK
