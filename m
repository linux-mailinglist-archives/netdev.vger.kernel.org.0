Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D05C0559447
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 09:39:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbiFXHis (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 03:38:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbiFXHir (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 03:38:47 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2128.outbound.protection.outlook.com [40.107.94.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9BC156F9F
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 00:38:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uel2QM3k4k3zo9SZXthdKZ4VyLYHWilBMpkX40nFSDowm7CD6gmC4+E9mlUKbnO6+EXl4HBDm1qjYxz1/lfLXArE4kyw7a/YY1ElEBmIhKUaAmk9cDG1xppj9Lxs1CSqDHV2KAv75gn/flD69j0UjDsVMnLw3gIB95G64/YHSJRKA2brYdtCzwkrUrWvRaXV6WMs4a2uW1/kUgVSGtYazoBwbkCAZ6xcqQM5HrWN1VkGwp5osi9JRG41Cjx3SU4DwGJI5Z1qw+9K29PUZdt6OgWUJDFJUPbuhNlaWwmU43wV/qJJ0FuU0E8nzHVeQ9fEZ96Nuc8RbFxKFGRlJ33P+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=btkrvE/McB9KELhEcrluzVGxhXb9brCQdD83NOj3u0w=;
 b=TybVSJmo0t6dZoW+xLxEHhFqnl5xNM5C+Ng30hCoSl9P1HvQOy8NYi83YlKrN9DEqk78fbnDhTZZz/XNstAnAYJV5Vxbcayn3dVyHXm23cY1n4JbYhhvYYnAM/WNIadOeo38rgp3wKosiflJ2HRjgmrRlJ0Wr3+GfiDh2HzzfcVCecTWdpqQjLKew4YKBFvBRkCdjZrC0eiGn9I3ddNCt+sGiwrRKbCJZ35G/N8BhtZSL/+OXA0TVWrakArb5NrN5O8b9vHmLXpLa21TLxrIooGzSCpH+r6pTxZQp2VjaVPjg+8M8sSFlwZwYxM1wCerqlRUjj+iVd5/Sc28E0yGuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=btkrvE/McB9KELhEcrluzVGxhXb9brCQdD83NOj3u0w=;
 b=F/4SkxcxHdnVQ1aqSXtrkevn+pBGZPR74Mbqxuei2c5pdgA+XF2cSpLrmlUKdNWyZxy0UwEmtTjPLtHB30yHS04jAJv0Aztt8Hl7zVhvWvw3NMKMRfwIXipJx+ZP9r8JFeymSapAwa+r9ZjJwxnXMk+aNzyw5kIwYsm/nmENk8o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CY4PR13MB1494.namprd13.prod.outlook.com (2603:10b6:903:13b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15; Fri, 24 Jun
 2022 07:38:44 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::b18b:5e90:6805:a8fa]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::b18b:5e90:6805:a8fa%6]) with mapi id 15.20.5373.017; Fri, 24 Jun 2022
 07:38:44 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Fei Qin <fei.qin@corigine.com>
Subject: [PATCH net-next 0/2] nfp: add VEPA and adapter selftest support
Date:   Fri, 24 Jun 2022 09:38:14 +0200
Message-Id: <20220624073816.1272984-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM9P192CA0003.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:21d::8) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2768087d-e559-4e56-f6a3-08da55b490b8
X-MS-TrafficTypeDiagnostic: CY4PR13MB1494:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6KPLDH3EBl6aR4pPSkS+Nw93oi3Bf76X9S3TxLPan2DmQBm9EOXEpaqca2uTTMTJSjewwZ3nhbEdDVLVqSI2hRnqh/WJdeuE2ZZIeV5FdDeT1BxYueS2KIvEYQPE6JkOW6LXdr8htKdGcCYlCHjpevhdlzj1JJi57yDtzxc0zFJEwKXDOxpnhpNyCoiOKwPQS7H39GR3+zHIqE8hAqmjLOoPuQyWn6v9ck3IffDfdpwuam7voccxm5hcontfq2jboGRP/bD8m1hiD4Q8pyzd+7B78iq0tong0WKWjUY4LPyUrTPP0ZfaxIu+15S4dUWUTi2DLfn0FgjcqnPp9C8rSwZyYMFM2iinhTmWfWiY28Brn8afTrZLBuWUJlfUhr8ipA6jYmJ+IIEqfwXQqw8DKEV8flkFpKku+yMfTVUeIj3GXVR0o+YfpDbxgt5Ufiivw13cg7jaukTg4w6LJokXy8YtBVxIz9eXleltrUWMqDhXvl89aj8TCO5RC/HGG003qhc0b0Fgv4FQUYHeXWplM/xPbop978hG7MGb/8hZnoTk4gLhdweGcCaIEAZ0bheG87ZWaaC6u01Al8obseHR9V0rItOaZLS8KO1VXzmREdvKkSPyOeiFGl0Cgos2lM98aoCvXb+hk7i8q3Hip7atwZyGpqHV+LpdtXYYatGcDzOAOUy628PTDyk9Oc/t1mCNg3KYkyg8dKAm1MD6/QuQo1rLnOWZiS39DcJdvQVyfKg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(39830400003)(366004)(376002)(396003)(346002)(316002)(86362001)(8936002)(83380400001)(110136005)(36756003)(6506007)(186003)(8676002)(6486002)(38100700002)(107886003)(4744005)(6666004)(478600001)(66946007)(66556008)(6512007)(44832011)(66476007)(52116002)(4326008)(2616005)(1076003)(41300700001)(5660300002)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9vKDlQuQQZWKlbcCPoSC/SooCverxqJfWuCbPbQ1gwDwQhvIsGD37yVOLx14?=
 =?us-ascii?Q?N4JWECNIqpYGPzOdZ8MhySmF7+0EgnmLIWzUYo0EyI4JgyeJnQP3HGYL8yNK?=
 =?us-ascii?Q?eVmTIWw7FEIsoiaxgijPkWlObZy/cyOnhfC92phXgZJk3AkQLr2cbjNANLSd?=
 =?us-ascii?Q?AGXwbRvgiXaht3jx3Qdpic0h0EoAp1aYiIJ1mTsB0uBUqLZOReHKGEYtu7ML?=
 =?us-ascii?Q?I/fUaOHc/k8a2Ds6wpGcD3cht6h5ECSvl6BTxjEwh21BNFvTvvWuNz3051yA?=
 =?us-ascii?Q?En+S+AYZfEOnsW6+IWdXupziBH4T0G4NNRg/iDEG/DxpS0ZlVI9Vq+uJ6bPB?=
 =?us-ascii?Q?3y1fZh5sHq5KcU23T9Tw/tfipJ4JeM8hpAvqx/AyUNqTsYsWlCs68iR5n+fE?=
 =?us-ascii?Q?RskOJS5KYBpmw3jq/WdWXvyhTN92M2EPNhTjQfKO8zbHFk+Vhwm8KxfgF9Ah?=
 =?us-ascii?Q?ZH4+R9wRoQfFFLago0yKQyKZhcEM/ERWXtKwdBMZgT7eIzSoWTxM6Nw7qzh1?=
 =?us-ascii?Q?dcihXp0F0Lopthc3DlDT+7JxxFPhyjRkht1MdYMCE/kZD9I9VHa2MX2RQA91?=
 =?us-ascii?Q?yAbQALx/trwWkI9FiJHc2FiQdqqudqnYssHwACohWOHeDPZxnrRYxLqHcrIc?=
 =?us-ascii?Q?t3b/G/m8bqSJKRvhkIPXNnv+LflQzbJGW9uuJZO5dPemUFjW8PFJQs60p10c?=
 =?us-ascii?Q?tEgvbwR/oRz8k2FIiVsD8+o76/gmx+IPi1IQbRKebUKPmhCQAjHOOcovSVkF?=
 =?us-ascii?Q?axNGmFwsL5P3o+rrbhjzgM0aFETD50fEKX5QPtiGzogm1v3i3eZ5ADahC7Sw?=
 =?us-ascii?Q?rgrpsu1wKeqbSCXtDS5NxuC4sX0QKnfhWpH+bBruI0l+a/YG830p/cC0pFQC?=
 =?us-ascii?Q?1L99Cd8OnMpPdIQz2qMjMr+DNHzOzrsfMFpWWzML7onkwS/f+imwe7AdmgNs?=
 =?us-ascii?Q?n3YruICp9YIBfr4Uzu+Ax23w/Hm+1A1V+VnHUcmtgt97PDPxcYOa5R8F8QAe?=
 =?us-ascii?Q?r8ZGar5orYT1TgecEMwVBsuCOiWTkgxYMuCsqxsicnekoOZNGUgwlVdVDlBZ?=
 =?us-ascii?Q?3Am8grsQziU1Mf3JuyTBwGXo2ljG5iVYYHC3RGXLLp4z8MlYR3oE9q9MVeX0?=
 =?us-ascii?Q?9E2jJIazyQpThBjHMVGLE7Jn40FAy6gbY/NuWSYJGbyc73Cu0grCj/Z60DY6?=
 =?us-ascii?Q?kOxw1wCLOlFVrN5HZe7hPVovk4p8Sih3wpnMMnW8Ce6xYMkE9+9OPtziHO4Z?=
 =?us-ascii?Q?3BO/ecZfnNdNdc+GofgWN/zKCzLJcpm/X3DrDX2v4omRMEXh54+HICfACK2m?=
 =?us-ascii?Q?jdLTXCgL94AxR8Ks9DFDzCtkInTNo2r1sj2+x5zFP3LABp5d6GM3rCSSYlXe?=
 =?us-ascii?Q?thpVA4obCobmjC60OJPWdVOmI48w/6UIq5nINiv+/OQkvvci9IZFYVFxDbJ7?=
 =?us-ascii?Q?AQUcXA9Y8i1+Wu9rIbNc4NsjhL5xWWKB/7hZFCJxtXkVTNEboHy4NOUGB42N?=
 =?us-ascii?Q?+G323hA6Ex0Wujavu8Ay97pQOERd7QbVCKLT2Rem3RMUVCDgh3NlBWNb8eno?=
 =?us-ascii?Q?E9OHNs4JUQv4mDYIXfJ64Q3sng+017KFohzSYYiWwZwpqdl8bOg+jvccVewc?=
 =?us-ascii?Q?CByft2FZwt1QFV6LNaqxO7c1zlhWb/0RRf0c/pZbQVjvNnfJRUwtBuXvQkRG?=
 =?us-ascii?Q?B2mv3w=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2768087d-e559-4e56-f6a3-08da55b490b8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2022 07:38:44.0465
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3ytWOMUjye+3Zd7qv655J+2Jr1nTOiJ4rtc0qD+bUo9TcdZ4pjXu92YWk3X7Hup7W8BKnFqr6wqKHlv73cL5pcifhertubHjcx9jmZmhCgs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR13MB1494
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

this short series implements two new features in the NFP driver.

1. Support for ethtool -t: adapter selftest
2. VEPA mode in HW bridge.
   This supplements existing support for VEB mode.

Fei Qin (1):
  nfp: add support for 'ethtool -t DEVNAME' command

Yinjun Zhang (1):
  nfp: support vepa mode in HW bridge

 .../net/ethernet/netronome/nfp/nfd3/rings.c   |   1 +
 .../net/ethernet/netronome/nfp/nfdk/rings.c   |   2 +-
 .../ethernet/netronome/nfp/nfp_net_common.c   |  71 +++++++-
 .../net/ethernet/netronome/nfp/nfp_net_ctrl.h |   1 +
 .../ethernet/netronome/nfp/nfp_net_ethtool.c  | 167 ++++++++++++++++++
 5 files changed, 240 insertions(+), 2 deletions(-)

-- 
2.30.2

