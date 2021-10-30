Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3C8C440681
	for <lists+netdev@lfdr.de>; Sat, 30 Oct 2021 02:54:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231203AbhJ3A5B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 20:57:01 -0400
Received: from mail-cusazon11021018.outbound.protection.outlook.com ([52.101.62.18]:30959
        "EHLO na01-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229734AbhJ3A5B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Oct 2021 20:57:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NXIN153+CnetazxE3MYhUxlOxuzC4eJwoo+e6ZuJjOHCPeDFO0drY//B0VmKJlb/Mh/zA8bPToxgDXg22lnkrHIjBkl0wMn/szPZV8r2UxxuLqMntUGEZpjGeSYXGVO1TH8yQ2DBGhJqiODAg5UmDOModRCdQPpOUERDSrO/P3XiLqq3R1FZeuEmV+RKfOUHKgTvPJDOnZdEgo56tepinY1NlZqLEwd94TRw43KTvFVsFBmeay3wSGjUZyFuiGQ0X6R5k/2lSBnjd4Q6LGCUPmyY9SJULijTsWj56OJMKOFqBoXpZ9KPi6rk5ablKdqbD2e7hrsSQ6WhixRtcP0SjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zBJB/6xYDlvQ86fms88Rp07Y5azxTXlT9qLIn9pzu/4=;
 b=Z1y13ktTgsbgsHhgFTHgYkpL2hB/ynLBLFc4Wxd7Jpanm0nKvSRzQxgnRRjyOxCjUXt1UlSFfijTs//fDk9vEMQxdfm5ighpc3J6nvRB0QQ1qdg/fu7CEdyE/osuu5ZBQ+M+3XM9XHakrqQA9Z5/HuOtUfoTkJngPdnH46KaSiIrb3jho3iQFAiVy8j4TLWQy8TeokYA/fyme5Lcwk0OjNfpn3IXsW+QEQpc0gmMDw+NKQEb4AChBiTAtWeS3S/bXatzq/OuAQ6lU8r15+VgF4Sm+Q9WLuohIEIa6xLMjCl59HqEUoRh662VGiSkU6zS8JwTYL1Wba6mXcWs+aMrRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zBJB/6xYDlvQ86fms88Rp07Y5azxTXlT9qLIn9pzu/4=;
 b=MB10VZaKXcaDzlrZ7sLwbjEaIkd5gRjfvYqZqDsdYz4/i6Lo2MKn9bwhF/yhTk0qdZt+9OHt+KSEZiNswMPjXxKGtmGGc0v0ReyRH3ozG5+/dW0gRD7376FW5/Lt67cHbbEEOsYNCEr+J3vepEbhjPxvt6uE1R3opG1ARzVHHpA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM5PR2101MB1095.namprd21.prod.outlook.com (2603:10b6:4:a2::17)
 by DM6PR21MB1180.namprd21.prod.outlook.com (2603:10b6:5:161::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.3; Sat, 30 Oct
 2021 00:54:27 +0000
Received: from DM5PR2101MB1095.namprd21.prod.outlook.com
 ([fe80::c0b9:3e28:af1e:a828]) by DM5PR2101MB1095.namprd21.prod.outlook.com
 ([fe80::c0b9:3e28:af1e:a828%4]) with mapi id 15.20.4649.010; Sat, 30 Oct 2021
 00:54:27 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     davem@davemloft.net, kuba@kernel.org, gustavoars@kernel.org,
        haiyangz@microsoft.com, netdev@vger.kernel.org
Cc:     kys@microsoft.com, stephen@networkplumber.org, wei.liu@kernel.org,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
        shacharr@microsoft.com, paulros@microsoft.com, olaf@aepfle.de,
        vkuznets@redhat.com, Dexuan Cui <decui@microsoft.com>
Subject: [PATCH net-next 0/4] net: mana: some misc patches
Date:   Fri, 29 Oct 2021 17:54:04 -0700
Message-Id: <20211030005408.13932-1-decui@microsoft.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: MWHPR22CA0002.namprd22.prod.outlook.com
 (2603:10b6:300:ef::12) To DM5PR2101MB1095.namprd21.prod.outlook.com
 (2603:10b6:4:a2::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from decui-u1804.corp.microsoft.com (2001:4898:80e8:f:7661:5dff:fe6a:8a2b) by MWHPR22CA0002.namprd22.prod.outlook.com (2603:10b6:300:ef::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14 via Frontend Transport; Sat, 30 Oct 2021 00:54:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1b4e42be-9408-49b8-fa49-08d99b3fd2c3
X-MS-TrafficTypeDiagnostic: DM6PR21MB1180:
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-Microsoft-Antispam-PRVS: <DM6PR21MB118064A05725A3D8F8B87CD3BF889@DM6PR21MB1180.namprd21.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: akwLW677y0tlnfelxHmK3ln1s7iXrER7XJP8aEqQDbvlC3d4v8o190Wt6x/YflTjcAhIsNZY3YeT60vC3MSDKuCozR4FS+WijuuigKTamaHMHin2Ix3exLxmeii/9UgZbExM/B3nfmL9vnO40wBE0klAKRIlMB2aWyK8zjSKZP+ywUel6S88UZ6Y6ixqfu/jMrsgNOWdqSqNCjer3X0yvmDaxRYCGMXlzK/ck5fjHnwA6/bgJleNt3yW1Q8FsG9IgO9KmldWhzJJiuU7ITecRvbpz6q1dFIxfhAi49HE6hEDmZnS7VjfG1dQ9aisknrW1oIf4MgakQZ4urY6e7yPNe8X/fO6mPtPqtacCOTMsIeOO5onB1XmtWV9kJrRQNxofsf1wJs9HNL2z5QaiQMNW45MslofL7CEMqkwzSu8M0eElkT/4cVVcpt3Ovkl7f9XNw+5ap+x75OMJ+M7V6ocC0HGzuHqMCYx89jUU8ogD/KG5A0kx56FTNwUpBavqezURooltY3w4lOYZ7yvqsLufxmuHyUIlhnsoPwAxwFrgKUZmZ+iAGVQAKHS6arkAksy1JkO9XyGpMlgohrjK4/hPvBxWAQ28s9ir9KQ04Ef2uGjQ6fh6o6Mw0WEFXia4DqZ/UpGVK2foscNyo0zoGRIsw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR2101MB1095.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(2906002)(1076003)(107886003)(508600001)(10290500003)(66946007)(316002)(186003)(4744005)(86362001)(7696005)(52116002)(8676002)(6486002)(7416002)(36756003)(82950400001)(66556008)(82960400001)(5660300002)(66476007)(38100700002)(8936002)(2616005)(83380400001)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/3W4us5lLDdHyzCz9wZXnUzy3UwH2ccrNgcYiieNMLgEKzugMIu28v8cLfpr?=
 =?us-ascii?Q?jp3s5BqQrhfjIHujk3aa/cvWKcoUd7jQ1J5GPLrdRBUMPv/Cw+xHeXNZttxx?=
 =?us-ascii?Q?S475zwp9qyA8sBlDCEHn56kZafT8xZirZhs7sYmNGpYkwDFZ5auIMNsyRmb9?=
 =?us-ascii?Q?c2HDOEnwWNIfMAsW3pZJ2MDZhyOo71xbX8aMe/ybvDHXFTF58oFLlaxDBy3b?=
 =?us-ascii?Q?xnlO6fnaDhrzm0CHcNdAHXIfkoQTirVIVShnWCaM58eDjJ6kJzTVh7yj5Eiw?=
 =?us-ascii?Q?Z61S18eS3j488ECSq9xikz/OUNn3Ej2MooSH42teOTV+YP/M2JlnYVkvHppf?=
 =?us-ascii?Q?/I5TtTJfiMIvL1tjlY1RiLAK/2NdddHJq/9gg8Ww7qUNxFBxQDY0Q5ohnVs/?=
 =?us-ascii?Q?Ejk0Qg+PsEuYyE620ML5ctCwMhppnA3z+NFWeDquiDWZ77TXEQ9Dlm3p8QfB?=
 =?us-ascii?Q?VhS0qVA90LbPP/fFNL+WKtBF+K5GnaeoaYsA+ECkmm5KjqSlq6JttSLfIspK?=
 =?us-ascii?Q?kUvJD/rwNULj7mXRXKKqhPYitNdNtiSSbbZ/22XlcmGB4sCx2DriEmyinlTh?=
 =?us-ascii?Q?gm8orPhS9RMc4vtX+//PPKqdilKRUkSOpEKD6F2ehEWRla/DlcSpcCVektPi?=
 =?us-ascii?Q?1Eo/IpanRAni9oFtlP+IPM2QzZM0cbgRDS2kCvaCRMRDbWw9QNqgYjmbVLDi?=
 =?us-ascii?Q?ksPfWzwzsbOZ3WS0KYtyqalgGH3xm6PH982yQmk9V84mxfa0KAeWHQazuVz+?=
 =?us-ascii?Q?VCyR7ZGIJofPzDQOcdLzf3XIS4Hef5+eiZkVIAyqcdBcIdfsyT2T8fDE/oEA?=
 =?us-ascii?Q?GZf38aVU/i0rCWhDBc1m8jPK6lKnYYA1Jv0TXKzNNtb4KVREj+p8QG5g51NC?=
 =?us-ascii?Q?eFWW3E+/zlX1Qix031kmeKIVKmKcCKTTp1lS/TXZ+ZWdeJICR3BaTrWoieas?=
 =?us-ascii?Q?8OXMpYSO3+jIHY87BGiBclLAShUuBIsdRMfa++Egx/wIzWy6uuK6Ua2yV6jp?=
 =?us-ascii?Q?2tlgBGOcBWLoN72i1gb7HpxTHZAQ7V3QLcimsMQ8ha+FeZWCszBe2qpFJTLp?=
 =?us-ascii?Q?3yC7Hp0unuC3iVLG0l6/5EOhvu3n9R9fJTfsnijKdxKrgDBl7Qa8HnugrgYc?=
 =?us-ascii?Q?7AJ9ZW2Y9ARyjjgoqAz5xu0OahOGsVelrU6ywrcB/nNA3TBgeZkoTu2q9fNp?=
 =?us-ascii?Q?3HLWfllHPurXyjecm4r5eHjIpsl8M9HbSw3Lou7+0F6OI9hem9e2Pxgiyu4k?=
 =?us-ascii?Q?dR3LwVZu+BVVJnqU+l2qcq3A3XTg4sp3cHiax6ZQv3xsJ+pv7dB5zfXv+IxW?=
 =?us-ascii?Q?LDZ1VZrppEoey04ib2hQ3vJnLI8yHwhQz/BrOfTPCVpDCqQoIAmqXRiYHGAh?=
 =?us-ascii?Q?Wg/5nOlD5XHPg2NhoPlm56YNB6OZD++9/3X44BysZL9PsS/0V5nHqUE/1rJf?=
 =?us-ascii?Q?4wH0DbiXm4HePKZtr4KKBOKOBWXg/JboKtMj48txPLCa9gWI6JQTNLeEcjCS?=
 =?us-ascii?Q?JauFHQ82SyKeSixJc8x9ImJc3IG0HBI/aFAAr+KQh+SOfMGcCsjGXXmvNOJB?=
 =?us-ascii?Q?t2uZ/4fD4edMMzZYR3SDgYmB/W/uXJRXJn+Hu7svqSxyCdZz5+Rv4MMZRTmO?=
 =?us-ascii?Q?MjL9gU0lGpqStlAKCLxMRXPZTK9LVsrQpCEjEt2WNGClLqRDsOxdqMPH0cSb?=
 =?us-ascii?Q?Jh2IBCBIgRtUhwB9FjLwgBGx9sI=3D?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b4e42be-9408-49b8-fa49-08d99b3fd2c3
X-MS-Exchange-CrossTenant-AuthSource: DM5PR2101MB1095.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2021 00:54:27.4197
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JuZpz3HeqdA2U3edaJWPb1TM4PGic2AGADdqeG5kzhaIuDYveKws0jALsHR+S74l338kz+gPibr47Ze/OkWlrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR21MB1180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

Patch 1 is a small fix.

Patch 2 reports OS info to the PF driver.
Before the patch, the req fields were all zeros.

Patch 3 fixes and cleans up the error handling of HWC creation failure.

Patch 4 adds the callbacks for hibernation/kexec. It's based on patch 3.

Please review. Thanks!

Thanks,
Dexuan

Dexuan Cui (4):
  net: mana: Fix the netdev_err()'s vPort argument in mana_init_port()
  net: mana: Report OS info to the PF driver
  net: mana: Improve the HWC error handling
  net: mana: Support hibernation and kexec

 .../net/ethernet/microsoft/mana/gdma_main.c   | 155 +++++++++++++-----
 .../net/ethernet/microsoft/mana/hw_channel.c  |  71 ++++----
 drivers/net/ethernet/microsoft/mana/mana.h    |   4 +-
 drivers/net/ethernet/microsoft/mana/mana_en.c |  75 +++++++--
 4 files changed, 208 insertions(+), 97 deletions(-)

-- 
2.17.1

