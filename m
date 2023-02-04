Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8435968A9FB
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 14:25:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233034AbjBDNZ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 08:25:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231654AbjBDNZZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 08:25:25 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2138.outbound.protection.outlook.com [40.107.92.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C834030B10;
        Sat,  4 Feb 2023 05:25:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E5tAUoELssD+oXeAquFnVJij2z0ReexoaRAXRTSpy6y4mT8zow35kPtFGnDoAS8TBQSTBI2k7rCOv+xs0CiUWLY+sjy50FIXNwPFZkGRGeU2TQVFjgBqt2M5L8cbubDVFMQUE622jak3v5Ll4Rzd0sZ4T1n9RjmaxO4SwHBC1682GiSTyNRXSW5ZkA2gWi9VihpIOI34wUGw1maIs8PwXl/Ku/LpxKlmLL3SKOiXHKicZoDvDh08bVmohPZUy4qZV5K/Fa5wimU0LTZBDgLp1zoqU/m8+oMD/mex428mdEo0GWt9c04xhzGUO7DklXg6rn0lVxDorUR910WB9JQOYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YgW+0vCH9Y27g49hmxXATPQt5i2TJU4pmGu8NRDHL5c=;
 b=BT71JZIu6dkTLId/3RhmZ+uhFAcrnNExhsf+DdCDyAasI2SfFgY2AB+NSwCZDx/SskhcyyaGfjdIMqWL5SUHhBHk//whO3iJRi6eSDnkaDIuy7CV28PH4phDC3vV75328ytCuC2Om1iEfoGEpNK4ZL5JIfI9h2Fi3XOwSmuGhvC5SMfsqdiHjlPaAV2/dJ3Kt3K3Scfq/Do9h4JxlBdr0Hel4r46GTdw7tzN3IAKvKy/RHgo0vEnaVB82SR72oojxjBFH1Rovcj/v5Gd2XhQQfiNNb1sfi4kDXOVx1wpqpBUA2Z6SdcHg8TEPgB/9pNa25Rw4Zum/6CG5ma9Q+LA1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YgW+0vCH9Y27g49hmxXATPQt5i2TJU4pmGu8NRDHL5c=;
 b=GLxR57SU0dgIf4cE2xaYOWKLBlRvKvR5Esss1oIyzRx0Xp5u/5B5TAzNJMHpGR2DOTNXIamS0YQ8BoqzcTtMR+Ag7LCFApZesXh/QcRQtLX92hTIDizmXuxUfUak9SJunaArRW6KAlSoEf25bpQ8hgHfu/BNQftV/MkGFC5cTFg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB3675.namprd13.prod.outlook.com (2603:10b6:5:1::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.24; Sat, 4 Feb 2023 13:25:21 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%6]) with mapi id 15.20.6064.032; Sat, 4 Feb 2023
 13:25:21 +0000
Date:   Sat, 4 Feb 2023 14:25:12 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Xin Long <lucien.xin@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        dev@openvswitch.org, tipc-discussion@lists.sourceforge.net,
        Andy Shevchenko <andy@kernel.org>,
        Jon Maloy <jmaloy@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Ying Xue <ying.xue@windriver.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [ovs-dev] [PATCH v1 1/3] string_helpers: Move string_is_valid()
 to the header
Message-ID: <Y95cuPGWCgrJauR2@corigine.com>
References: <20230203140501.67659-1-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230203140501.67659-1-andriy.shevchenko@linux.intel.com>
X-ClientProxiedBy: AM4PR0902CA0014.eurprd09.prod.outlook.com
 (2603:10a6:200:9b::24) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB3675:EE_
X-MS-Office365-Filtering-Correlation-Id: 503865a7-fef9-4e9c-6114-08db06b343e5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H8HZ1/1tC/VpVVuHSRHOpdoRxUJo+3hQdHEUt/8Xg1xQnpQuY39oy5qVrQ65ZATejK2m3acl7YrvITkuHQBDUiCCkc5Z4qePYO5vG/0SnXj9LIyiEMjXC2M6lwK3LvyYYKl/aqq9r6K01BZBG2fjrafjy3hQNe/Xfe3S2vMATCOOcgfJXw3GyWEt8YdtV0hmWiu2wz31VZoclpvyfiktmJktw94wqrcxfvbemGjrc3Z0X0V6XPmJc0xiRfBeB+Abw894Xqq2VHTiSgsYMeIdxKMczIC3ofS7PslE8lQ4o0XGusl78CSj/p1DOHTf3+AzFmBBbUiQbMiWcmXAtf4jdA7pCjFOa/Zg3u0ClXS4wWlD4SgA38BBchxFQpyuIWPhIL31yEba8FbGVA1oV9CavMqgKVNcCELsd9cSc7NZKfWATCDXt9dsVIFw94+eAQIRNqPYZTMB7eYiZzDj6wTxi0nsk64AW0X142iJ6kC5nuRzHRuWrSAqSH75QFRcEXou3q4yuvKh1aZbthBU0jBV9WaVETWMbdGOMU586f4Qp0W0AOBO0LMu1SMv7tGQXvdMjSUarF/u/zAu78JcmsifHOuj7GGv9wYpEipR00iKhYCpef2wSEQDiRxgJvI69JJfuj/wi7dkpVsILW1FrWMgXA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(366004)(346002)(39840400004)(396003)(376002)(451199018)(86362001)(36756003)(6512007)(6486002)(2616005)(38100700002)(478600001)(186003)(41300700001)(6506007)(54906003)(4744005)(316002)(6666004)(44832011)(4326008)(66946007)(2906002)(8936002)(66556008)(5660300002)(7416002)(8676002)(6916009)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?K2Q7qQR0lnffsbfEtPi4nitwmsxPWaDoSXYtLB7His1qUeCu8+IuhSBl9F1m?=
 =?us-ascii?Q?DQQKl4YT2r2FRZXnYwSDcLUzXpgj8HIPSszFwRH3hzs3EY0ywan7VPbooiwB?=
 =?us-ascii?Q?jkAQn1252+043w/AeyzHsVYXgWMBCgc39ZK/TIvZxAgnFu9xt3qdtxTyPW3R?=
 =?us-ascii?Q?FL/J5BAjOOGgHMeX5n3duxz75ijBniPaVZDMBC8M9qMgsZDWYQOt713yUsvi?=
 =?us-ascii?Q?/zjlem+88HHplTRR+rx7QmwgWj4Wz6JxNijlmQUsDP5ytuV4g3MPbUUePkCH?=
 =?us-ascii?Q?77wtNYbz/ZrE69ghKkNyAiLqI3v2pz6dVE+6vhO/YlON+YwPc9LocNt7J/Gq?=
 =?us-ascii?Q?rkom6nBKy0vjmCKClR7duQVnnVjP943ujAQ3NajK7mt9F7dQARBMl/KmvwCp?=
 =?us-ascii?Q?Gnc015JgzJrgJnBd+0WachpD6FIFGivILUxkP8bYzce0UGIREhZwfe/68pwb?=
 =?us-ascii?Q?LUUMJgO2/q1gktScPBvc7q6twI23v5xH6k4xfbO4XK7VbwfPShMK4FYPaRuG?=
 =?us-ascii?Q?/LwQaNH/kDjS0dfXh93CPkP5vDk5c04kEBaz6u3lVJUUrl8Za56F0r9vXtNS?=
 =?us-ascii?Q?IXRBGn7Lhrrpib75cP2Fi30kjDyUfImFDpExaYUtbc74yO/BCMlChRqt3k2E?=
 =?us-ascii?Q?bAei5t4kSYckdMSuLpG8B7OLNxnm1HTbEGHshlRWodXLXxfh9lWGJmODS7o+?=
 =?us-ascii?Q?q0pW3p6WlbNKUJhvT5QJAyXYaXByxcLRsbcpxobGWKUjFG2tSJueQUenx7rD?=
 =?us-ascii?Q?jaCp3TuUaB3/4BFFxkzBjeB4URLEMZBpRu5tIKd+s7XUC6cj/h4ijkVYUpJD?=
 =?us-ascii?Q?zaUySpm855rc82QJytxS/0u0Teuq8plJnwXO9Ahaciny+FSUy68OU/mB5b0o?=
 =?us-ascii?Q?XVs/wYgIBSPF0N9uYrfVdfzVfkoOcm7OmB3ljvwQY6/irwhqpIpLqMHRwwW4?=
 =?us-ascii?Q?Kgc+tgF/5OHsJvotcwxkcteQzs09y0YHMpJdRsraFrS77ro8pZCF9RSGI8Qz?=
 =?us-ascii?Q?fe5lLPxucCp79PrrItfs9MrQCmZCaRN3w9sXLDTA1711xkcvGPGp8OA1w0ZE?=
 =?us-ascii?Q?obK3L5eS/soFyOZugvvO60PBCzJ4UYEBPo6CHQY7uNdf3BZq1UgeIav4J97F?=
 =?us-ascii?Q?AxGHKqNFJcHAMnlgyMzfGbs2QWRMxLz8WvXzqk1XxOk7+oTP20RhUNLsK56k?=
 =?us-ascii?Q?ei4OaXykcVYtKcprTJ0MiNYhNGh7JuuERE3tiLARx2oE8pesz/J3chfMpTQM?=
 =?us-ascii?Q?5JE2NxsEkAv+lJOjHO16fVkXdEWaR1+lEAj9V4YfEoeJ1ip51kiPC0TH1w8X?=
 =?us-ascii?Q?0LrFfocgUAr5GKAuayDAA008xBQhJiv2RyvZNuOGRD9SD4e4730/MnP/+QjM?=
 =?us-ascii?Q?OAKyX4hCt8ZDwsMVYC1vfagwz3URn2KVDw6OlWcDz0l7gJFGK+qNqF2Oaxpm?=
 =?us-ascii?Q?NGvwqZ0zVcV1PWxu5pznWoNrAL+uVGMPWEAi7BrqskiY/H3tg/sdtW1386lJ?=
 =?us-ascii?Q?5UVtYvSrSiRQc8gxoBS2g99pyZ+D7OEMyZrH4f7JxpS9JZjO+8qv8zPNc2ug?=
 =?us-ascii?Q?DCn+aCYtcWOiIMPG8fF9nlgY4gYZ1CP687ITkDJp75UzyGtOskYEhXGsqhgj?=
 =?us-ascii?Q?FNgX76Nz+gvPOvARSn/yFg5H/pNwuEYl4U08LOZXgo/9LUylNE5Pf32DCzEK?=
 =?us-ascii?Q?402vCg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 503865a7-fef9-4e9c-6114-08db06b343e5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2023 13:25:21.3106
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s7zdtQbD7W9cR8H88PNwrguIflTxzHqRqmuZ9vsw2djptubsO5fYKD6muQTn//D0hUKOv8WfuMJJnoAK5oJy/S248DMNejSnjfvIu9zSFLU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB3675
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 03, 2023 at 04:04:59PM +0200, Andy Shevchenko wrote:
> Move string_is_valid() to the header for wider use.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

For networking patches, the target tree, in this case net-next, should
appear in the patch subject:

[PATCH v1 net-next 1/3] string_helpers: Move string_is_valid()

That notwithstanding,

Reviewed-by: Simon Horman <simon.horman@corigine.com>
