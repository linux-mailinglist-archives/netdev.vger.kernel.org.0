Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97ED46E592F
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 08:15:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbjDRGPo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 02:15:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbjDRGPn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 02:15:43 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2073.outbound.protection.outlook.com [40.107.220.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1EA3137;
        Mon, 17 Apr 2023 23:15:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UXF+DT7LypABhyS5GqRG11dcQ5QXWrRDjVGPQtYJJ2gPDwxV7MX2kXKme/JT5aN1q2HwIVdJY1OSTmJbhQxjywDGw70sSxz9TXtMs05C107rY+lIAgT2mzvcIkpz4oNQrvb9IWcHS49w3tr0tV7OTnpZr5AZ/sYU7y52ExKQ/ohs4o5+pQqHZZumQ/EcQ0Uz29v6CjuseL4dSm8rudaR3st4fsbD7F1q7KdfUgMmvm/efYJ+rgiEISXBhPvNLliOlqzStBSab2doMDncdtK2ZXbwjQNtAkeeyVXQwBEG07Afy3Z5hr6IOCJ8oJos3B0JHsikr1UlO49sqW+6Hdg96Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lQXgmfZDfQKpstIGGoseI32fv0USjOeWtZ+0gohidXk=;
 b=iL8WOZhLJESAwEp4LDNSlmEeZ46yyPzDAZbyY8Rt55UgWuuh3QiG/RK4fLOrL6JuHHdg3Vtv5T1El3VNQLcxLWaqWNwsnbjT2zbnTTarUSEtu+hIYn8UVi8ofAMdDAraa2Qt26VsiD4yG7aLeofI5A1R+8udoQZm/WzbumfGYLRbaVfQJGB1VY0ifGaAPu218zbtES6TLNtJ0Gfw0oZg3R6B2Go/p809LjOdihRYZhF0RBuGk6cPKRZd0RXsNxmloEjoI5CaGP+eEffVeqmSVYxSiOnwA1qlWbMQT+xOHAL1sQkqot1qAha6jkqO5btkmRujF5J6SYSPDnZAOheTqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lQXgmfZDfQKpstIGGoseI32fv0USjOeWtZ+0gohidXk=;
 b=psgCks8pqt6MeHs9cJuUQLuNpPKOKEaTGsOYPKxmWdtn5jsqJ4Ig+lwo+RwqPpyQDGK+9mSryjpbhxaN6rxW3wzQ9ii3rGnti+MwvZY+cgqFMoio84pQ/TpPstVNMwUDPYBRqHvRdEfxhs/CTxjYTzUSBr4KiEnb++UcvFeAN0+tvceGmI9tpUcE6uCEvqNoJd59ye0kPDmm5ymxMPBF0j/UQIG6AjA7Nry7rFj3Egf4b2dn+RQvQ2MseDmzt/qBAkneXqoxsPfiPjz7qIIBY3Z5OcOhOu6NRozeuXM9FdcSnaq51/dkS75OSv9OdZu3Jljubn5uAA1sP59RsLzLDA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by CY8PR12MB7337.namprd12.prod.outlook.com (2603:10b6:930:53::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Tue, 18 Apr
 2023 06:15:39 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::66d8:40d2:14ed:7697]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::66d8:40d2:14ed:7697%5]) with mapi id 15.20.6298.045; Tue, 18 Apr 2023
 06:15:39 +0000
Date:   Tue, 18 Apr 2023 09:15:33 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Nikita Zhandarovich <n.zhandarovich@fintech.ru>
Cc:     mlxsw@nvidia.com, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org,
        Natalia Petrova <n.petrova@fintech.ru>
Subject: Re: [PATCH net] mlxfw: fix null-ptr-deref in mlxfw_mfa2_tlv_next()
Message-ID: <ZD41hW/SVdNNqKRW@shredder>
References: <20230417120718.52325-1-n.zhandarovich@fintech.ru>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230417120718.52325-1-n.zhandarovich@fintech.ru>
X-ClientProxiedBy: VI1P195CA0088.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:802:59::41) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|CY8PR12MB7337:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c67b31d-7091-4b80-2b30-08db3fd454ac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4+0tvEwr/tgIeaugOveR+ixxFKUThQK6Wj6R58tyBHJOxDNFseIOOpkoh/+zDwGs+GFbKcPo1PH3+baNL8Ks9zL1c8/repuOQeG1sm2ckdiajI7V6QDb7GwUV4e8ptpjoOkzadfGlcADqGnMEjL9kRtyzVpNn3UOAEXMIFWgqzcAKSgkCMusqWlz83W1/DF6jzQkNw5rHv2H7SYDapgg64CXNmjobk8cs5grjY99koKmBw3QGw0d88lm9YPtNxe5AOsTpeGyTeBbwkDyJxZvh36bzAPeM6OU16uz9SWKvaKJoiCVpc8e85HhQPy2ZW16efqIM0uw2D3s23kgK00kQ5rHnhnpz8a1ZT1NrsK0coPHQY5PddHZebcpVmbUsHS/Jjp2gI36W/wAmFE29cU4JF6TWjPPZ7zQW/MV0HEIevMqbadsCuR0Hce1nrZwQAMI+FRNJE3erY3QYaa5IJyXCRjVdXb0iWWsYSmTCa917uYbb0Dr4TPHV0CWik3eHkEFea3j0ZvgSY/dmkrS0WYfhRwE9P/EKmk4B7jKZz2SnlTkngtMs9yM9eTwF+zXsRjI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(396003)(366004)(136003)(346002)(376002)(39860400002)(451199021)(5660300002)(86362001)(33716001)(6512007)(83380400001)(186003)(9686003)(26005)(6506007)(38100700002)(8676002)(8936002)(478600001)(54906003)(6486002)(6666004)(316002)(41300700001)(66476007)(66556008)(4326008)(6916009)(66946007)(2906002)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/plU99jFizc+PIE1+cKvcs+KiWQp961vyqKTWxWPcQawdy54+ArG5wLPIxra?=
 =?us-ascii?Q?vhRQ2YZcBKbEMPgW28fQumj8M5Ky25mZA4YrVw+EWPXOnc3AMZeoVwrhWSRs?=
 =?us-ascii?Q?7G1v5/cw62VEdMDpOMwVe/HrYhl3ZnAkZJOineQiwYwNgi85rxCGhx9PvMSQ?=
 =?us-ascii?Q?C3EjhcvnSwXEGtVlk2Frvq51AAHBU7qteBwpfhuHMgsYZnfqBp4nENHzbhWO?=
 =?us-ascii?Q?A+JRQce/kwY2O8vm0NNbDWhgNOZ/2FRdhiYJMMFE+ob1jFjz0N+PN+11AWzg?=
 =?us-ascii?Q?XAGnc/GxmCM+oLSDSvPH0NkWXR6f1QZopYmKuaZSDVr3pQXVJ8lAB4PsfxRp?=
 =?us-ascii?Q?LTRdnZl9Z3D+Ge4RvJGl9K1f2B5yxj/EPMWjW+8eOl6LrVJeoHU0rosnkn8d?=
 =?us-ascii?Q?cbb0k2YsEEOFJISiBM8uRpfvuTCGFfklaavOR++NtrVHH+cIKT5y909tw0kL?=
 =?us-ascii?Q?tfznh/BFehFVQBtuRqmF7h3csJb6UNtbRN/jlI6DRpJS7vBAxt3RR9Pf1Cjt?=
 =?us-ascii?Q?LN5LmY07PSW01+z848/K2Dv2J7+LDip9rBZaChwDMbBQWejh/5QiwRX+21xn?=
 =?us-ascii?Q?tP3XOrvN8AUEMN/7tjzlTUv/U/ck84wNA9bI2pirC+z/0bds4b7RK0yE2Gde?=
 =?us-ascii?Q?HFt/AqFQHDTbLR+QElkccfchfteVyDI+BdSoWh1i6dN4gahsfuL755r0Nyxx?=
 =?us-ascii?Q?ypsqtSvyhiK+0g9gNN6cTmgZaDJlCrvuaSZnYpt4Pv5WrgbAqga5esX+7DaX?=
 =?us-ascii?Q?UY81FiyH2L9GOKp+viWXsuUag9/fP2C1QfmnzR0qQOydljf8sXhXiY0LUiq3?=
 =?us-ascii?Q?skhyXOKnRoAtmwjTv8Cvwgkd5E6FFtvoOZ9gQ/8172vPr3dN3IeXFjKhh7xs?=
 =?us-ascii?Q?tFNUNAAU/DAg04x2IchSN/dLDUcW3F68tuVDh3HSwuTCcvPNcFLvmyL32RVq?=
 =?us-ascii?Q?8qn0p2+p3/JnusGEUUmcUT3R9qNcTVQiNYJxjn97I9riEoCfDm3W2JthTJqj?=
 =?us-ascii?Q?2zdt7fUA7sOfFw1vkefF8kuCA6BJJXkTScLtFCur5crQjNez3cJMR1OjWhw7?=
 =?us-ascii?Q?BzUOGaK7JIPb4WusMamvzoC627NkHSUnmBUQNalv8h6qehGY2CE5XWzLr9x3?=
 =?us-ascii?Q?kNNl1h+76ERt2IXmpJQ7EdZfonSUo29OeJQGUDrH8jcs+jCmSoBFa9g7ujEZ?=
 =?us-ascii?Q?pyBWfqag2R8bvTfNQdlkumyja1Wy/2Z/what9mjFSqcvR1KjpC0ydP/VXD3r?=
 =?us-ascii?Q?5IBBCd0/UmM2vy4zES0cqbBnwhVglQzZHHXDLLqmaFNUoL+Mde15Gx7AtjmH?=
 =?us-ascii?Q?U2x137R1lxR/WCqnGVQJK8XJhRtmNi8C4+xVBzH/5fpN7IWZyCt/odw5ykcT?=
 =?us-ascii?Q?J5al/drlyAls5JNVjvLEMRHOMz7WTzAQHv2kbRE6IH1+aleYnv2dJRI4/ziM?=
 =?us-ascii?Q?Lv9bzZmUdAYON5/Dm7/+54K5lCW6mUsNGT56qaTSKXEABhdHCP1LmNF/0zOm?=
 =?us-ascii?Q?Td1h6Ze4J4EFX54IPENeA0bZhUtgpcf0ulw4CcZLJLntUmyq1K5TegWwKzLr?=
 =?us-ascii?Q?wZmimsswzRG7X3NJAsSq7sWl2PRlEqCBoUhNJNX/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c67b31d-7091-4b80-2b30-08db3fd454ac
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2023 06:15:39.5260
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NZak4cl5XtRV6kAxmGqISfmdM+ZN/aLpL82aFljGmtB4XHgEs7DbVkR2m7CsIKIFyk1Pxa5h0Mey5Pb6mvm/1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7337
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 17, 2023 at 05:07:18AM -0700, Nikita Zhandarovich wrote:
> Function mlxfw_mfa2_tlv_multi_get() returns NULL if 'tlv' in
> question does not pass checks in mlxfw_mfa2_tlv_payload_get(). This
> behaviour may lead to NULL pointer dereference in 'multi->total_len'.
> Fix this issue by testing mlxfw_mfa2_tlv_multi_get()'s return value
> against NULL.
> 
> Found by Linux Verification Center (linuxtesting.org) with static
> analysis tool SVACE.
> 
> Fixes: 410ed13cae39 ("Add the mlxfw module for Mellanox firmware flash process")
> Co-developed-by: Natalia Petrova <n.petrova@fintech.ru>
> Signed-off-by: Nikita Zhandarovich <n.zhandarovich@fintech.ru>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
