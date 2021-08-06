Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DD3E3E2A85
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 14:29:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343666AbhHFM3e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 08:29:34 -0400
Received: from mail-bn8nam12on2121.outbound.protection.outlook.com ([40.107.237.121]:46560
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243697AbhHFM3d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Aug 2021 08:29:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lPBJWEZHM3BQB+2RMKLD96JMMEVifjp/woQq34g53pG41qWWI01Y9a413OxIR42rSfrlnWz36JA8FJ/mbg/My1yyUHvUZMDh66qgJLzVEMbGqvIvz/0BtbSqSYUzGaiyXw2xuXHi63nxVHDPRh7U/NaTWOHcIXSy5nZKXsn8EQ+kIpEhblqO+Uz5bSuTU6/wjTaLsIn7ZKHJSZE5ZhCa2e77iiLWmowI8BAcrXXRTJSt/dPvwUKxwl+JhoYOnGKpcmiQ/kHuxWdTIz3jgSils3NqVp3IjHXhYfBPD54b7NxRhk0lndp7vonH+XJOoGVhlxd3XSVXkvXooZ7cYZbFKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=izZDCUrbFb04cCoc7qQ18KA544YhPnK5i2PMzNbsc30=;
 b=Lz4QhEjba1eZVZi6REbOa3W0jma5cHFbyVxl84v7H6zkdbOW/Vo6I/sMTaklAdR4DQTC1T28Oqy/fuQgBH9E5KhI6Jn/lSNqT2w9QmVrOTwS7XavHYl+FSNwQqXcLi7k3dGAg7yul9ig+ofQYYmqvDFG2ggFDA3aqqcJ90nuBza1/ZleRvY3dCsAejnnsOtlmsQV655uA63NjDI4b0WfEMoMuXch/kfS4swBlyP4WhTQ8r+sUu2wyMPofNUgpSwrsnOHzkV7SbkPVC83lPl4SH/fxKJY55ciYZfdgZvM+1IaFm6BmHm33tDhokP2l0HA8d1FBXUmK3NOwF2Deu868g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=izZDCUrbFb04cCoc7qQ18KA544YhPnK5i2PMzNbsc30=;
 b=jR4rzj60zqkrrTarL89/AMShjtBf8AMB8AsyM4guOkrrYVu7irQsMOO5rYDJOJmFZwHk3dEAZ27Hmhwr24D7cBTpqXBqqFbxkMqGZA58t3JXxzJaCWZNzvSwdlTHnAYw0AcN+cxLzcoyXNzXdb7vOnx1ox9Lj1O8H3C+Hz0L/fM=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4825.namprd13.prod.outlook.com (2603:10b6:510:99::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.7; Fri, 6 Aug
 2021 12:29:15 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::cd1:e3ba:77fd:f4f3]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::cd1:e3ba:77fd:f4f3%9]) with mapi id 15.20.4373.023; Fri, 6 Aug 2021
 12:29:15 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        oss-drivers@corigine.com,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH 0/2] samples/bpf: xdpsock: Minor enhancements
Date:   Fri,  6 Aug 2021 14:28:53 +0200
Message-Id: <20210806122855.26115-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM3PR07CA0141.eurprd07.prod.outlook.com
 (2603:10a6:207:8::27) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from madeliefje.horms.nl (2001:982:7ed1:403:201:8eff:fe22:8fea) by AM3PR07CA0141.eurprd07.prod.outlook.com (2603:10a6:207:8::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.6 via Frontend Transport; Fri, 6 Aug 2021 12:29:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dc4fe441-3f7e-4cc8-1d40-08d958d5cda7
X-MS-TrafficTypeDiagnostic: PH0PR13MB4825:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR13MB4825DC435E122D01A58A7B7EE8F39@PH0PR13MB4825.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:792;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5ov8MxQrTCU1RPo9qyZi5uPF8vNTe+R06uxfUXYMmYx9Lugo4kjZU5VzJQqg1K50TqnQFFNNymDMS3Kj4mu8Ba15tPiSeuJHlesHVRnBeR6QBcNRfTZjYGjwThCIk/kSUjdG0C43vFPKMFQAJcpXpkwpdilStWhsm2lvEMIXRRqUUkvpbR8Zs481iGSWFEQjcQS/T9YOUCWwIZYXsepEgpUAp2R/at//YYtLDw0GolOP9mQF8X6jCINYmySwqN1Om4y+j5vz4G3mmVynN+s96WjTRLk878zqjO7pIKRT39tZn2vvXT8X5khnZQ+9r2iSbOQEUCaHaS8r9YraUrpi9XXY49noo9zhgFidH5RRFgVKSXD/Qz9zObUS65Rr3hnN78RDiJJJ3R77NS9OIaDDSp0uLs23p9ivQVYTYNyYuFpmmkB9nw3QHbXFeGEKQwQVA7kiO4/8Su9ObuYXlntVs9hmz6P9MqGmHOGJ7ZFV/iKWuyOVLzZ784bOJPO2p0JSZgVgUhRpokGCBUH2BoPMHsiWMcD2t9bVAkTiM+glTgKdm2CyJZaXW4ztrNfoMyvdVgEqEh3pGgkgm+E7Qw/hbyyne7j0QYGKbHhF/gHF0DoXN+Uirqwl0Q0BlOLC453DqAcuG7/pkp7YB6zs7/otzw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(39840400004)(346002)(366004)(376002)(38100700002)(6486002)(186003)(5660300002)(478600001)(4326008)(52116002)(6506007)(36756003)(86362001)(83380400001)(110136005)(107886003)(8936002)(54906003)(8676002)(66946007)(44832011)(66556008)(2616005)(66476007)(1076003)(6666004)(4744005)(2906002)(6512007)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VTV0YURDZDh2cm5MRGFlK0pLK0ZmVVc3YWRUaEd2eXV6TXMvRmFKdTQ5Qktk?=
 =?utf-8?B?dDVLSVZBRW4vVDY4czhOVDdLTUVHTUNwS2tNT3lBRkt0aHdXTi9wdzRWTlFi?=
 =?utf-8?B?Y1RJN2pHdTluN3Z4SThwaE4zd0g0NHRycTVURUo4YjcrOExDV0NiVjZxMlk0?=
 =?utf-8?B?L0ZFVU9TaE8xMmdmc2R2NzdsNmZnNllaYU1kMko3S204cEp2MzZIVlY5ZmFU?=
 =?utf-8?B?MWMvU0dIL2E1RW9VT1RVUW5PcDRkZ1QreW4zT2lzQm45OUMxMEdZNk8yMXJn?=
 =?utf-8?B?OXFSbDYxVXJ5a0VFMDh6R2ZiRWhIY0ZwMCswcUdGdEMzeFNvQ2dMRjhzUE9Z?=
 =?utf-8?B?VXA5M1JGRXFDVERIQm1GSG91M25wL3p0QzE5ckpNTXZOTFJHRFpXcXNXWUtL?=
 =?utf-8?B?UUY4RzJFY0VRa3gyTVdDNTdPdUhKd2Y0eUI0ZHJSTTg2czdBNVczbVBLMjFU?=
 =?utf-8?B?UU95MlBYKzQwNE9UL2UxN1RjL2hqREM2YmJYZW43S3NoRHJuL2M5Sk9Samdz?=
 =?utf-8?B?dXhxNTgxcGdkQUl6NUlITGFVait1bDdxR0FBS1o3TTlLY2xrcDVUR2hvNm5s?=
 =?utf-8?B?TGpMS3MydFhYNFlaMWJnZ2N0bHMrUlJTbVhadnM0UnNKSU9SNXA2a2tkTHRu?=
 =?utf-8?B?cTVDZEpiaERhTCtaLzU0S0sxaTJlSVZaMkgxdmRCR09HbC9ENkxQMFdZVEtp?=
 =?utf-8?B?L1Jza3JITDBNdCttcGFuT0xNVFFOeHN6YXU4RU9KVEJvNkhWcjRYQldpd2ZD?=
 =?utf-8?B?QTBNVExsU3NaYnJSZ3NnekpmbmdhelpyVW93NDNnUWgvcjgvUU9QUHdraHkz?=
 =?utf-8?B?YllSaEZjRjllTEtLa094Um9lWnZSaTVONjVNVG12bVNEUnRJMmQ0VTJ1VnUw?=
 =?utf-8?B?SlRSQUx4dmp4TEZrK29CYnlLRmFqbHNkSEdJTTZEdUQzbnVVZ2wzLzZnQUJB?=
 =?utf-8?B?Y0ZHRkwxVGxoRERmZTNkUDFudXQxdkJwUEFZVndhaU1JRmFVaWxBUkhTM1pp?=
 =?utf-8?B?VVF1SkR3OGlyejhnUkt1TklZWDZuTU9SeWtiYXNZRzMrT2FRK2szRlg0T1Z1?=
 =?utf-8?B?aTNWNlh5bW9JZjc0d1U1TjFsK3J0NlBXeUhYRy94ZmV6dGZ0YlpEQiswNEZm?=
 =?utf-8?B?TDlmT09FL2tsM1dHdithVHF3SlVlWVRBaVRhNWNGbjlhcnhSdWZjS3NiTitk?=
 =?utf-8?B?VXd1R3pINWxJVkh5ZGYxNGZoOFp0OVZGS3hvWDc0dm5rUmd4dFA2RUduZDRn?=
 =?utf-8?B?S1A2bTVxS0ljLzNzbzZNNjAzeWZZeWJ0OUVuTkxvcHFSNi9TRzBxVXZHN2hP?=
 =?utf-8?B?Ly84YzBSZzI0NXljUEJFSjJpaUJDZERqemJTZmRINEZ6NS9tZ2lBeFFSMXRk?=
 =?utf-8?B?V2lISlczcXBJclM0SWVaVzBCM0ZYVjhhbDFrd3FreSthNGlyckFFc2IzSE96?=
 =?utf-8?B?RHN2aGJvZUtBS0t1SDBDZmprV093UEptcGNVMzRwU3dzNmEzVWlKeDhHWjVx?=
 =?utf-8?B?RTg4enU0Qzk0OTRwemRDQmV3UEhGbHpGclI3ZjZobkIvOEFDRjJKSW9ENzFD?=
 =?utf-8?B?eUYwS1B3anFVdVQxd24yNzh1ekVXWnM5TDFZMXk3VkkvclpoN3prTE9hdHBp?=
 =?utf-8?B?NE9mdGg5Mmo3blBEYWFUdTUvWDNQTDlNci9PMDVKUGhlYnJua3NiQU9jSjdu?=
 =?utf-8?B?Q2ZqWWVvRkJyb1pvS0liSHF3WjhWQzdyTTdGMWd5UzhGVGwrQlNZVy9oOGV3?=
 =?utf-8?B?RThkRitFWnFleFZpa2lTRm9rNlFZcE9TR3hNSTR0bEFremZ4NVM1TDhnM2Rj?=
 =?utf-8?B?WXBBRTJsK3FBMndaR09TM2p3S1JkcTRaS3ZEMktXaUwyN0huK3AzVWV1RXVy?=
 =?utf-8?Q?7rjscqSG8XiHP?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc4fe441-3f7e-4cc8-1d40-08d958d5cda7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2021 12:29:15.4062
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +tH+XdwOT0bDwC7n5tp3A7z9YSqHXTm5okiOReBK8OO39qutgfeZxGDIi3tkPPOMOdLQB0qqPu9DX8HEK8y/f3SpU5Zhr8S7XnkL1VXI7RQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4825
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

this short series provides to minor enhancements to the
ample code in samples/bpf/xdpsock_user.c.

Each change is explained more fully in its own commit message.

Niklas Söderlund (2):
  samples/bpf: xdpsock: Make the sample more useful outside the tree
  samples/bpf: xdpsock: Remove forward declaration of ip_fast_csum()

 samples/bpf/xdpsock_user.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

-- 
2.20.1

