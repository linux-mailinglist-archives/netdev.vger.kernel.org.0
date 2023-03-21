Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6200C6C322D
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 14:02:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230324AbjCUNCN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 09:02:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbjCUNCL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 09:02:11 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2065.outbound.protection.outlook.com [40.107.94.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41D594AFCB
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 06:02:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f1cFbafTQsfUQAef7w0dW9KOeNZluj3qxNA4tN4HVZevsSkTRfHVN6wGfpzVNeLA8Y1tl9jxYT/YlLdAAZZzoEVDq2Pfi+A9nzbvWUdLLpuEf/FmGYuKT+ErhM6QNvp9oSITc1QuOcBpbi8H08MVKzPYtCL0eqjbW+eT5rGoddjlV8EjhfX7yVMRy+jpUf9em0sxSInlf+k9oh2JkKeSVvXVzUvGcN0SlhXaaM2kDNzxLAN6WD4ZlcEbF6lp5Hn+IjJo95SFL/UKyxBOHdyGzAhNuUWD6XzsabUOCADoDgF3OjUt6Ij8akOZCiid1Ll05lpZAmQZLi+brHsyIg2iPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u6eArYhU/zdjlNEkNX4vNrFvCxyHIJBvfMuycpM39dg=;
 b=hJCfVl5UTUo7WXrOOugF2Gutvwh08oZi7KJoupOIS3PBMYpW/wVE0r+lavv9JxKPDigrF/n9naEWU0//1EV2MzKMCQBu6osgbhWai6YQGM+/AELa+nxPJTa/42OCBkJy/9qwMuSCQJwZmCLqdHwOkTwVKC4aeVN9JmdJVvQZ7rR34dpyCuk0Ta8PsN6+ihwVkyPUNbDQEui3nfO04z/xVib9B4KcncJyqwGhDl+QCqBIao7Hw5cd61XxaLWfM+fMluBfJJgPRyK7fjmzbF06LAVk00MDKoztMhwUFgJG0lB/vJQB09k1RLveXiwAon3XBDyNyp8zb5SJVUWLb8Vf5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u6eArYhU/zdjlNEkNX4vNrFvCxyHIJBvfMuycpM39dg=;
 b=MuV2DPPxlE7M4fxV+iYhkL51dQip04oXHFZ4oQv/ivm4ARxm2x5OB0L+rOTdhICtcMiGPe2Rf6myJ+ZOJe4/mNZ9458IO8wj3hns8NVHKQ5Rxcp9hYag7qEOhKucLYYTs8u18S0QFPkGTVMoFmYgL/LX5mVvlXfu5fWQr5vwrx6K7T8YzR90t3UTVy0XYr79Ch6ERneOuOgk0WpnDjvWtgBZfw28zVQADdlxvSDvrBa/NKCVifMPr/3KOj6gp7aB9pAjVeYdUC4eSSGEJaL8rgjRitkuLJiHy8GlP4Flw8WF6D9P7ePjjno1X+r1/LKmuYCvAnXgyEaeahhf/vXwgA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by MW3PR12MB4395.namprd12.prod.outlook.com (2603:10b6:303:5c::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Tue, 21 Mar
 2023 13:02:08 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3%5]) with mapi id 15.20.6178.037; Tue, 21 Mar 2023
 13:02:08 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, razor@blackwall.org,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH iproute2-next 0/7] bridge: mdb: Add VXLAN attributes support
Date:   Tue, 21 Mar 2023 15:01:20 +0200
Message-Id: <20230321130127.264822-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0602CA0023.eurprd06.prod.outlook.com
 (2603:10a6:800:bc::33) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|MW3PR12MB4395:EE_
X-MS-Office365-Filtering-Correlation-Id: d763fd63-35d8-45ac-44ed-08db2a0c7a1d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cB0rk0GL2Vm64PcuCYWIwVKwy1obov02KBrBlnZd9ly23gS8+0Ion3XiK5W0t32KYDSQ7VsVOPPpAWxHeyQ4LGSnUD3o5tl407CWzG2uODbd36/y3nDmTJwzXRP6rc4q7a6C1LpdW+J2/nvvdNTOZCskGIRkN+LDT5Phy2wVyQrQaS04IKQDkrGq4MvNMF69YwM5kGVo5SghJ6fJoe8cvWRIFpyRjLhzgvffbBlZF+PC9UcSTxQZJCg4jmYogaYX1lx7yB5kQsB/fTT0wTy+4DezlEpoOdVEyH3PpGyqfQrXHnawNu7QFxd51W8pYL07nxQhZDPoeakOGXSX/tgDbg6hzmhFklnoj4pcBY1P+P0m1QNedzfzDmysLYzgs4i1pYSx3sJoX9WTf6+nsBAyn9d2txYPjuWXqkWaCdO4tPy7wQiir4ppo4ZOooD38zyGdOr7FtVK2QItVw9hE3XElPMUQCuFwdL9kXNJ4skXhVlg8CLKNuC8IsOCsBmw5wXVc2FwzGDhxFe9ASCere7zGvZ8jXJf8G5rouLwinQAkoN2/N2b8NuQvlv5P4COATN3vDxnx4B/sO1ybGwlFoWs+L+lZfEx1AtgoZqmFEE/uOpnxlR944NdJrBtn9iVy5sEiMA7ndVkszmH0p+JAqOn+w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(366004)(376002)(396003)(39860400002)(136003)(451199018)(2616005)(6486002)(478600001)(6506007)(83380400001)(6666004)(107886003)(316002)(66556008)(66946007)(66476007)(8676002)(6916009)(1076003)(186003)(26005)(6512007)(4326008)(4744005)(41300700001)(5660300002)(8936002)(38100700002)(2906002)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?m6tTcHE7sDgErLDjbcFS1RNtK5UDGu0wMDmGlIRPPAGsGqGazOjfUdsMbnYa?=
 =?us-ascii?Q?oLW3TXasFUUQh8LZf6plYmgLnKFNUgWfJeAD/8ZjUg146emMfI7DlysxiALk?=
 =?us-ascii?Q?gMkeXBgJC7jTHeEONn7Q4Tk8WVFQwovItaZgbwklYNqjZt097lPB09/T6Lbj?=
 =?us-ascii?Q?42klH9ge4w8SDup+LI1scpiclfhKBErKA3Vz6alDu1jjZsnS4DMjAhxeoxKX?=
 =?us-ascii?Q?J4wcnWVUC+apSVPYhhnK/vOOhzEFaOh1N7lc5XOOGVhUdOjYcI4OCXiDPO+Z?=
 =?us-ascii?Q?APCUfOied50n/zenDgtwUkBLJgUvoFclJlOl2AZRg0t7zfMcGueuUcFkpcs+?=
 =?us-ascii?Q?uI5ToiU/24Rhjr7wL1Ev5+JuO/8cJUjSWS60KeY5F9KvrB+LILIC+WlgeVRX?=
 =?us-ascii?Q?xXyL4tRIOdEYo5DC2O8pq4k3wQaevcstzb9n/daKe+PmUAzj/Gf6jFbUWcVl?=
 =?us-ascii?Q?5F3zt5rCOBLCRPnK1gRsB4n2nzkBmJ5t1gHQZYkDp4G4Hwq60hQh/kst+osF?=
 =?us-ascii?Q?8AGRqYT8NH6LD8iItBAcswxDYHiuo2Rj8HRJC5ehFS9ggWDsWTvkR4SvIVvk?=
 =?us-ascii?Q?BZqYlDTK9O6Q0TQsE3BKXeDOQq8t6pLeIO2i8l0tFgUW4dmJLC+Trc/jO3Fi?=
 =?us-ascii?Q?HrGmDA4fmA0LzDIBrF685cAvW9yGxNSMw+yvI6DJiKT4EbFOkt2qBaZJELLg?=
 =?us-ascii?Q?lPUSbFm0XdrdM6JUUmSlqvuk9G8uOhDdO4GiL+hj56iucEMxOKBOtdiAaYLu?=
 =?us-ascii?Q?36QO2vl+0YWNN82fZdN4fIDgEzJqzB3JH6Rx8u8A0H6Rf8UvM7IWrEE219D8?=
 =?us-ascii?Q?sHQvflYrK7ylbtlNqsnTAg2f+7mSzuu+AcruFXTfIDMa0gdfGeM3/ANqta4x?=
 =?us-ascii?Q?XNK4GYUmMiNaaNx6TsLPhWonaZkhkB6ul7lXYGTTOemvbT7gj42qtvEP/vQG?=
 =?us-ascii?Q?wjzg5stge8TY3EdijjBcEheEeJoIFzEuVUzSL5/cY0Ixi4tEnAXrSLXNleWH?=
 =?us-ascii?Q?c1v8qivvB/EvTessymFLhf6A+4sgRpURaUn/k2txeU7H6alS97gBeO16hmuo?=
 =?us-ascii?Q?iE+00Pub6FQe3TB4UYgRrOQ6Oaecm69o6R3QgFgjld7iqJxGNuuWmf3uVVm2?=
 =?us-ascii?Q?5ssNTBSU5RltO3Sc1v//NiVngl+lYyH1vvFqnBYNa51p8Ms5Q4SE999ZvRIn?=
 =?us-ascii?Q?BZfyQybxZ6ppLQAMDoD17CxQCnpS4ioRgCRJWb1LT0QQFKx8QFtbxHob9R6l?=
 =?us-ascii?Q?uMi4BbsE/CzcB//j5N0Tlrx+xpAzqhqpgKwWBm5CYtQaxLvo3JGSyB32jUvK?=
 =?us-ascii?Q?9HgbBD5LDUDuCrlj7nREbnH+YFcF9UtADC+9k5v27fx0CVQoKBSgr+VX5mS/?=
 =?us-ascii?Q?5wUyQUSdCmxqFm2Y47e6SvpWy3vxFKXEPYYGpOb9xfDuVGc60TtQhKwQ6ADs?=
 =?us-ascii?Q?4HqZ/An2QsLIi/Qp1dw+R7G+gGa3bvx/Prf57NJ+MJLeXKcHkWzddE6iPY+2?=
 =?us-ascii?Q?eAo1KR+4HCPRe9JcqwzJN+qRfptoRdQKCNn2ZO+y3W5rjKUW7sY0Lwy2ErlZ?=
 =?us-ascii?Q?1dz8lJFS6hOK5EtcV7j1Um+2OHxqDQRP8g0v7qin?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d763fd63-35d8-45ac-44ed-08db2a0c7a1d
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2023 13:02:08.1332
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f39V56rXRke1o6licx61WBwNNfe8O9s+3nXoqiWZru9Q6HaxlSbsS0XAlEeWgmp6YcQBjqmaARvsOyHN4l9iXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4395
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for new VXLAN MDB attributes.

See kernel merge commit abf36703d704 ("Merge branch
'vxlan-MDB-support'") for background and motivation.

Patch #1 updates the kernel headers.

Patches #2-#6 add support for the new attributes.

Patch #7 documents the catchall entries in the VXLAN MDB.

See individual commit messages for example usage and output.

Ido Schimmel (7):
  Update kernel headers
  bridge: mdb: Add underlay destination IP support
  bridge: mdb: Add UDP destination port support
  bridge: mdb: Add destination VNI support
  bridge: mdb: Add source VNI support
  bridge: mdb: Add outgoing interface support
  bridge: mdb: Document the catchall MDB entries

 bridge/mdb.c                   | 163 ++++++++++++++++++++++++++++++++-
 include/uapi/linux/if_bridge.h |  10 ++
 man/man8/bridge.8              |  52 ++++++++++-
 3 files changed, 222 insertions(+), 3 deletions(-)

-- 
2.37.3

