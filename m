Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED99548D400
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 09:56:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232026AbiAMI4H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 03:56:07 -0500
Received: from mail-co1nam11on2086.outbound.protection.outlook.com ([40.107.220.86]:28322
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231735AbiAMIz5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jan 2022 03:55:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OjYudBbbZo41Gjf6bTMptm/REeGteE+wjfW2RCjeGZ2N5OCgUZDew8MwrO07jn3ipm+cjGSDePgnO/VUlg1gYiYPMOJZIUXB3qFrv2hZZkjtLzDTCGNry6e+cpf1n88ZJ2tWmG3RDVmi7B/1fIUMepU6HYRVfSNdHr80pPBc8+pLIj5m9JMAk9iSL1JRjLgPuxaFU07kVIk9RelwZEE6xGWkWXOcbtJt/qi9t8MS50Uf/hA8+YS5XY9By7pUuS9YOiSZxn6TcTN7T+m4VWU6Q91v+YhfMZdSHjyJCHJ8FPjVjJxi4MZrDz3KK73SeMM2KzbP7Esa9sGH+JC+Jp39RQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BXntoKDHEKe8j6IFAzofa70DVvtAsRQAIbYKne+fbOg=;
 b=ADUKQycKTM+LQ3pppvbT6IEnK5D/n1PPeeCGw8qe5tYrlIJaCnIMkLBe8fm3/MrL5EWuCNNHrvw/i2HUj9L8kq9B7OtKVKmlH6HV06d7jnafaJNn3kUBbagUWz4Bp2MNgMxLxXzohi7+Yw7n8WrkMIUuNDumYhWb2kAkR0CquZ8qAWYTPWXE09mwBmAmJv0so8FozKLgkCZtUcL1DZQpaI5fsanRIUPNM7oqhHbh+HPS90AHNfy0CxKHU/IZRo7mDHmpT0diczg93K1KIaejYBpTG4XHIx/JmjkBNhIxspDW9wdUF1/bCATymbm1LyuUYy1blq+ajJmxgojMKsPMAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BXntoKDHEKe8j6IFAzofa70DVvtAsRQAIbYKne+fbOg=;
 b=KN8riYeru3Y+l2V12ID4eRXbUtU70lmKWqPCeS1gOMGKaV4fx0AUh5mq81eAhp6tpPXe3AyR2mfRkOCwhEv59suNUHYc/3AXwGNCxkXJt/k+wTRIBr7C35g26iDn99UtfbvXIYe2nfMrhXcP++jyuLuS12iMkyRnu8fDbFnrT6s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=silabs.com;
Received: from PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
 by BY5PR11MB4040.namprd11.prod.outlook.com (2603:10b6:a03:186::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.10; Thu, 13 Jan
 2022 08:55:49 +0000
Received: from PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::d031:da9e:71a:73e4]) by PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::d031:da9e:71a:73e4%5]) with mapi id 15.20.4888.011; Thu, 13 Jan 2022
 08:55:49 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 06/31] staging: wfx: remove unnecessary braces
Date:   Thu, 13 Jan 2022 09:54:59 +0100
Message-Id: <20220113085524.1110708-7-Jerome.Pouiller@silabs.com>
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
X-MS-Office365-Filtering-Correlation-Id: 507bf973-549d-4d86-6dac-08d9d6727f12
X-MS-TrafficTypeDiagnostic: BY5PR11MB4040:EE_
X-Microsoft-Antispam-PRVS: <BY5PR11MB4040E49778946A32566A8E9893539@BY5PR11MB4040.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1388;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4e0GgFUqBJel+ge6+66vI1QM92XgoW4f/fP+X+KvY6q7GbmJLlkaCf4OVRoYaeVkXOGGo1FH1ovd3j7WjNTeqgaK5XKOmpqeampuKfJ+s37UzqGHk/aImgfhob1VVrrCmCXd3nl94yVhJWvc1TeOwGnQsRuPKswWgLPgjajzkm24eANfEk+vLHlH3a6mupmL8ffGPBduns1ovguvkL1zl5reEpftcF7eUOSwgOhIGW3PWwryXum2FuK7dPoql3unnGGDEonrtn2LuOPonMm4xK5jQDguQhcss99WNA+fsev0i5wqEyoPSvks98SZrIwYfDM+2GW3LKyCylqmwON7tYNCnV90M2CwxaF9a5oKiXccoULE3Qm3acooY/yBdNXVUJ+gVua2EUbpeo4ISTb/THN9WFEwVulPHjSAqTgYv+USdaL0mW8WfPn5P36Wktvf02W0V52nJ4GybeqMX/M2Tfd3aG6feXChn8w3KkxUbCBfqePidJhYxaY811KXVtO3sxTLZiopY7k/M4VvnmhafwGtuRAAvgou0gVl9TF6434tQJYgruEYFghhov0DhCZtahE0TtDHXrfVV/JpIAI3w6DwUwRCyeVDeGuhewkJcOyb2zSXFPMw89DldNgoNQUTnYgjlImK68Ft8imT8ZvISQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6506007)(508600001)(186003)(38100700002)(4744005)(4326008)(8936002)(6512007)(6666004)(66946007)(83380400001)(1076003)(2616005)(54906003)(86362001)(66556008)(2906002)(66476007)(316002)(52116002)(36756003)(5660300002)(8676002)(6486002)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZStOZ0pFZ0pDZStJN1Rkem8yL0NqRWw4Zm82ZjNVSFplcjlvRWYwSU1KVjZ6?=
 =?utf-8?B?Z3RQeXdJVmdrU2JMSUdESVJCdGpqb005SEtic3dTNkZRQ0hFU2FvTEoyVGR2?=
 =?utf-8?B?dVhPZnpRdENOeUJyTVB5aituOU8vN1h1R0gxVnR3TitiN0tVdHExU0x1cFZO?=
 =?utf-8?B?ZXVEd2NzMzJWUkNIU0JGYlNFdWJiaCtRbTVqUEJIUzF2czV0OWpmYUZJckti?=
 =?utf-8?B?ZnNUTjF3UGhMam1mcktKa2NFcnFzRXdaMG5sTDlKQ1Zyek14Y1pCMG1ZMXlY?=
 =?utf-8?B?Sjd2YlZQV1BNcFNzYnpYUy9qb3NNdkI4SUJvZ2JRd0FLVytkZGlwREZxWXli?=
 =?utf-8?B?cEt6MXVPQnpsTTlBWVVndG1wUjZZanRHNW0yaEx5MUNjN3RiRTV0Q09lTDMv?=
 =?utf-8?B?azlSK0dnREFudlVGYXdTWU5tdGtZVE9aMDBRMHZTdWtZcW1hd1EvMStLdHcz?=
 =?utf-8?B?VXc4T1U5UGhWRFFLV0N3UmRMeVFnb09lT3hGVC9kQmFMV0pqaXpKM1RTU2w0?=
 =?utf-8?B?QnYwcGsrSUowWlJHZnY5TWZXZ0lpYkVqWW44QzBUcCtYaG16ZWlZZGpLY1JR?=
 =?utf-8?B?RkNkbkFrZVAxbHhXR1Flb28rT2pyNnhLeGx2RnlJZ2kxVXVZbXNXV3FKYU9T?=
 =?utf-8?B?SkpUYzBOU1BlOXZRM2ZvVSsrdE4xVXo5OGw3MDBMUVh3dU4xZWg5cHNYTndC?=
 =?utf-8?B?cUdSOXNZcWFrTi9wL2lCZWpSSW4yOU8wMmNkcXVlTGJyU0w0b21UdEhCTnh4?=
 =?utf-8?B?NENqTE45L1dwZUZPYUNGdWY3am1ibjNqK3paTGhQUWhhK2hXV0Y3cm53MVBu?=
 =?utf-8?B?MktZN2VnWEUwUmtNbW5sTUZGcHNRUTcxcnErWHpoSWNhM3pzSUx1QW5lVjE0?=
 =?utf-8?B?UWNBYm9VVWtRYW9UY1lNTE9oY2pEZ2dhWjN5ck5xd1Q0R1N2c1RPd3FQQWV0?=
 =?utf-8?B?NjVrVGRpMlRkS1NjWmtmK1JEQmlRTmVvWnM2bm1Ub04xOG9NbGt5OTVPa1FE?=
 =?utf-8?B?VmIyeFhIaEN0VmtDNVprZWd1eDFFT3FObUhQYmc2OWFEeFcwRmtWZC9FN0NJ?=
 =?utf-8?B?TU1XK29LcGZFTFlBZGpBYnA5MjlxZXVtQktIdW40a1JNMTRkQ0J5aElsbldD?=
 =?utf-8?B?VVlLT3YwUjg3UkUvdkgveEI1OHhrRnBmbjZDUFQ1M3lZdVp6dlBXOFc3YWg3?=
 =?utf-8?B?WERKMUI4T2w0ZzdvWmNQbEpPaHhReERHU054TFNJdEJyUnpRRXBWbllmY0xq?=
 =?utf-8?B?YkdIeG9UMkdlWGZ3aDRKY2lIZmFZTGRZQzlheURWMHBpdUt1UHcvMStBUXU5?=
 =?utf-8?B?OE1OZzdOSDdyOVpIVVZDOVV6RmFXNkVzWDAzc1B6YXJUYXJTNnhjWE5XWlZX?=
 =?utf-8?B?UkI3R0N2UFdkQWphM0IwOU9hK1J5VWNGdE9LbGNPeCtqWGlTQkJqRDhxSzFK?=
 =?utf-8?B?N0dEaWdLeVlnSFc5NU1rQmxZWDdKTS8xenJ0dXF4eU1Zd1oxcmlVMlVjeUJG?=
 =?utf-8?B?eUNRRVNCTG5UOUhFMSthaFZBY3NISU1aTm5YZG51S1BQVzArUXpPVTZYblZh?=
 =?utf-8?B?bk9rRDBIQTcxRkEzcUpEemZSNW5hdldidGY2QzJSeUl1clNsMThmRWgxUHcr?=
 =?utf-8?B?RW96bkhCSnFNTWxJaVJMdkF6c3YyVmlnM21FMUIyNFRKNUhvWnU2bmNYN3pU?=
 =?utf-8?B?VExNWTkzUlhhSHNrOUNCNWsvZkowRDhoZUNKditmSDFzRDhkdTBIM0Nka241?=
 =?utf-8?B?S3U0Z2JFUmhDYk8rZnUwSENKc25lRGN3NENJK3NNZWIzYVB2RktZQ3ZkdnpR?=
 =?utf-8?B?dkdhYmVLMVk1aXlhZFhwZDhnZ2MvS2ZhVjJ1bXpEb3ZObDdlOEtkaVJzbXYz?=
 =?utf-8?B?ckJSQmhxYjRiS2NOWUVhekg4ZUxrVTV2a0xvUG54aUdlNkNXT3UzbHZoQzVY?=
 =?utf-8?B?L3VZUWJSNzF2VDdyUnFBMStmSldoRUhtdi9vRUdjaVc1TWtFUUJJUlVveHc5?=
 =?utf-8?B?YjUvNndlSGNDZWdpcGFVQzNnSG10RjFFZndNaWd0R3lWVXdCVWZlTzU4OGF3?=
 =?utf-8?B?R2U4MFVya3Qwa2FvUUdnWEFqbVVTWGJSeERxVW10cThJTjJqMURvYTNLSlAz?=
 =?utf-8?B?ZlZJalR3WjlWZ2RCa3pEZEg5aWJEUXJ5M3JQZFhOWXZxY2w3YURmRVprTW5G?=
 =?utf-8?B?bDR1MXpxTGJxYWMzU09yTytMei95TDBmVWZjUGQ1OWVUc1FJZHZoYWxqWkpQ?=
 =?utf-8?Q?PHQAt7VTnAJXIe4j0W/lZcZwMmGgxAMf/eyWkyz7AY=3D?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 507bf973-549d-4d86-6dac-08d9d6727f12
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2022 08:55:49.8352
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CrpnfjK8PfCG4TBdWch8iHC1vvm1NM1VSD2B+GwBNQ1GcPDjnnME8S2Q2Cm2LcNOxX/M+JWR9RfQAqkKIH/wdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4040
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKQnJh
Y2VzIGFyZSBub3QgbmVjZXNzYXJ5IGZvciBzaW5nbGUgc3RhdGVtZW50IGJsb2NrcwoKU2lnbmVk
LW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgot
LS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvbWFpbi5jIHwgNSArKy0tLQogMSBmaWxlIGNoYW5nZWQs
IDIgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0
YWdpbmcvd2Z4L21haW4uYyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvbWFpbi5jCmluZGV4IDg1OGQ3
NzhjYzU4OS4uZGRjOTVlYTE2YjZkIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L21h
aW4uYworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L21haW4uYwpAQCAtNDM4LDEyICs0MzgsMTEg
QEAgaW50IHdmeF9wcm9iZShzdHJ1Y3Qgd2Z4X2RldiAqd2RldikKIAkJZXRoX3plcm9fYWRkcih3
ZGV2LT5hZGRyZXNzZXNbaV0uYWRkcik7CiAJCWVyciA9IG9mX2dldF9tYWNfYWRkcmVzcyh3ZGV2
LT5kZXYtPm9mX25vZGUsCiAJCQkJCSB3ZGV2LT5hZGRyZXNzZXNbaV0uYWRkcik7Ci0JCWlmICgh
ZXJyKSB7CisJCWlmICghZXJyKQogCQkJd2Rldi0+YWRkcmVzc2VzW2ldLmFkZHJbRVRIX0FMRU4g
LSAxXSArPSBpOwotCQl9IGVsc2UgeworCQllbHNlCiAJCQlldGhlcl9hZGRyX2NvcHkod2Rldi0+
YWRkcmVzc2VzW2ldLmFkZHIsCiAJCQkJCXdkZXYtPmh3X2NhcHMubWFjX2FkZHJbaV0pOwotCQl9
CiAJCWlmICghaXNfdmFsaWRfZXRoZXJfYWRkcih3ZGV2LT5hZGRyZXNzZXNbaV0uYWRkcikpIHsK
IAkJCWRldl93YXJuKHdkZXYtPmRldiwgInVzaW5nIHJhbmRvbSBNQUMgYWRkcmVzc1xuIik7CiAJ
CQlldGhfcmFuZG9tX2FkZHIod2Rldi0+YWRkcmVzc2VzW2ldLmFkZHIpOwotLSAKMi4zNC4xCgo=
