Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F05E68AFFE
	for <lists+netdev@lfdr.de>; Sun,  5 Feb 2023 14:38:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbjBENiB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Feb 2023 08:38:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbjBENiA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Feb 2023 08:38:00 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2094.outbound.protection.outlook.com [40.107.237.94])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE9C71C7C4;
        Sun,  5 Feb 2023 05:37:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R0jKV8BQgOm/8EMz6snl0maBCdNSgGc5ZRwStglIN6kzmx2ir0lG9ZY2usDH6UQstmbmVYMfivdnBG40bNp8gQDohanj9KSlP4PVQWRQXkljpo8dAwHCkU0ZNPuistmJl4h8eN4KEgZzjFUdsbJvIF0DBEcHla4lobNlZd6k6Ka9kqbCgfI0zIFqAbsxkUS9wcOO5Wq0DWBV0XpHQ/hurcJbuaYAHalKzQIHdDdf2zop7e5+i3q48qhemy87HJwXK4GXEG23Lb3w3+qLK3cgWmU/Rm9r4qK8HQ+ujM7ZRNJon8j5PJhshl1RppxhJTgIr4BAAiaoypyt36TcTQA8uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n/lN/qzsE91F776Z8lVciYILV8U8nIw2TrE6+WtINqg=;
 b=hFzU526o3UmnNJaQ4ahgWwTNi97KwzL1599xbtcdIFYdnECvTEXQ3Mz5hmtByyv37Tt/+GtsOb18ux8pdB0pfc5FdMpJmPBjyoSbiMbtGD34lbmbLrTd6todLCb1N7t+om6I+7uAG4VnjoQC+zduWNMiT1DbxL+AXXvub/hLpnRCr8X9zgp2sPTjd5qyFZXpadaRPccisqVXiK1iNhwjw9v8Qlzr2vNfJnP8j3rUoxQJuM6mGSvzyFPRl02gifpYq1FDMQ/hYPliUofboLc7cT0FyuNU2WvXjt6XDBMR2LNS2InDJ+6KK2GB/gqoRyppSDefleDtUMFhC/GfZJqMrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n/lN/qzsE91F776Z8lVciYILV8U8nIw2TrE6+WtINqg=;
 b=MFZZ4ZnwBslZc/4pCapge2cN/YyPdVsBywPNEI1hDSHZDk66W5SwfKIwW9eR2tdlVIN85Q6uYYcL2Lbo+NCjpbQ/15dIt5YKAQv+8eQgDF89dHoEy0D8MKXq4buhw4K1ryQbgOBA/mSFyz1XWvivi3re5V7TJ1GXjczV5lWd7YQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB6114.namprd13.prod.outlook.com (2603:10b6:510:2bb::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27; Sun, 5 Feb
 2023 13:37:42 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%3]) with mapi id 15.20.6064.034; Sun, 5 Feb 2023
 13:37:42 +0000
Date:   Sun, 5 Feb 2023 14:37:36 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     linux-wireless@vger.kernel.org, tony0620emma@gmail.com,
        kvalo@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>, pkshih@realtek.com
Subject: Re: [PATCH v2 2/4] wifi: rtw88: pci: Change queue datatype to enum
 rtw_tx_queue_type
Message-ID: <Y9+xIJTtEfIoUfHV@corigine.com>
References: <20230204233001.1511643-1-martin.blumenstingl@googlemail.com>
 <20230204233001.1511643-3-martin.blumenstingl@googlemail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230204233001.1511643-3-martin.blumenstingl@googlemail.com>
X-ClientProxiedBy: AM0PR04CA0100.eurprd04.prod.outlook.com
 (2603:10a6:208:be::41) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH7PR13MB6114:EE_
X-MS-Office365-Filtering-Correlation-Id: ffca995e-776d-4cce-1bb3-08db077e27fb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jecHygRLfpataZJIeOLouA/69D+DpVSM0v7odF4/L4XwZiMqHPtvQPsi8NKDbDXU8fEbCeFOkF6ac2fkpgJdsaXhcOmBzzPFo6fA8FGgaW4myxm8W+VsEp/9qS0v/vXOK/bv0dujf2fCX/b/cBaaDAxwe9yb7N51ZRka18bjSo/nrdzjcw/s3TW64zaJMooUBIWKGY0321w0Aa+tD56SAN8TaTNitLLz0QcKkJ1V9pAHYpOh5mh/bB1iniUoq10iFutcKons+9X4Z5HI0HiJaIPXU128FAmobuOb8d+r18EsOV6pwu7b6rgg4mQtwtBe6cPOrnEe82FNEecBh57y3dbisABBxfzvorAn8EUrbvXaPMiupuKju924OenePENZIZYyeLzN3i3X7EURTHjD58kxVUqoB72bAO0NMa/Ez/PpSLVFtIuwhpwjyfpF3FN9KWCyHd1RYdCdu84sK0AHzbNg8DnurfZTYbOG1gVF5fibYzQFfAhlkls9BlYQxUIqzP9qxHYr7kgnv9g9z2QcrapTwk9wLADXuxM9pCGpCzGRct5OxwNH7RCClMvmf6dofThyF9Pg+uczcPFEaoDYB5hZbl2gBztPaOK/CoB8cmU3Ddv+2m4unNLUWzyck8nTbFMFIUytQW2ICvZ4iIsLbdhx+Fl+h3YM+2CUZuRxsCnj+m/3TIomZuGLhQiSsN76adR9Tu/ySETLJBowuNy1yR3zeOd9Fbg8em4IKZ7oy0e7sbf3UU/iQ45bRr8vJrCy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(39830400003)(376002)(366004)(136003)(346002)(451199018)(4744005)(2616005)(38100700002)(8676002)(66946007)(6916009)(44832011)(41300700001)(8936002)(66476007)(66556008)(2906002)(86362001)(4326008)(5660300002)(6506007)(6486002)(478600001)(54906003)(186003)(6666004)(316002)(36756003)(6512007)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UA3pZSTWy6wG9Fz7vlKDsxQ4kpFmCc/0zOhEBMQFVSKHzkjyr0DHn8N+8JJc?=
 =?us-ascii?Q?ao/lP3iIQp8j/8fIk/A4YA1APKatqM2iNlOXUw79IXwsvfL3vWputpHGQ0Re?=
 =?us-ascii?Q?GCmN6gi5HqheCysSx/BrQe9iHSBeT/9/UpbUJKitrhDyYudYAbUQwGJcR2lk?=
 =?us-ascii?Q?FyYK3WGaxaMwartWWs7s5xuizLwQR7ZE5MWWKJJmzsXAF6A+tCw7N0TF0k0k?=
 =?us-ascii?Q?dH0rm6moz/EbbzLutcJM42PczLriCaq6roGUzvzsfEyKh9n4YMtNjS11fhot?=
 =?us-ascii?Q?/CvzY4I7Tw5+0/McGR+62juy6lNOgJNQtaH5Xcng7fYxR+CObOSWGAO96HkN?=
 =?us-ascii?Q?ClwoEADB7KbKeLToIrnHqPVbjk3BlsSpaC3kFQVdVKcasocIrIMbc6omFE5e?=
 =?us-ascii?Q?NigntkglBkpKbrX6BaLt20VudvkqeIF+3PTN7eZLhbKidP/BaJkocYp4L6yH?=
 =?us-ascii?Q?ufLgdCTrtMIo2duA1JzpVVDF3m+Xl5OGiHhQ5JNPnO4aJq/j+dj8o/85LMws?=
 =?us-ascii?Q?+xudcXJqLKhHBA8is6MIlMs9vc9tnyQ4gIk48xCID3DsV5JFjjSw3D8jvLeR?=
 =?us-ascii?Q?gQgUK4Rpj9sBRpG/7souUncW21rIbwIfJriQ2x5w41Gn7Lq5bEXOJE2nzloE?=
 =?us-ascii?Q?iNDzlY0NxRxxbZuRkfE+S6Mi5g/f6qkwPIPtFGxFBl9ZFPU3zsdCWqdTN46J?=
 =?us-ascii?Q?1Ln52NycCXzRi+PVwtpsNRrbFotdO3GadC9ba+K/e6Ns+fYG9vhTehHROSCk?=
 =?us-ascii?Q?EPK0VL1TpGggsCW/+Ox6jbP9eaoqPv9r88NzznW9/KLHHoX0w2NUVxn2a9Sw?=
 =?us-ascii?Q?I7nqChRXXpOwwb60I6flmPBLlaI4QDT77FXsYY8XphClPdMKbqbND3fO2QfK?=
 =?us-ascii?Q?RILUTU/gXGUB98SAVofuOkbz0LGYqJ+vuCblGndQ9CZKxlAqRiFS60yQ7Z/5?=
 =?us-ascii?Q?7Sga6MC65GcSlBjOyj8yk/6njNipJHdQjKYEB2iqduM6zOnAPEijhp/H51m3?=
 =?us-ascii?Q?DtrMfEg87GcvUX7z0LlAhbza9nZHj4Uao6e53TKS1xf+yOlH0RahKDLjRvB9?=
 =?us-ascii?Q?8ibGA1W0abQWGexW83Ai2XJFmqS99tPrStQVp8nK9+5m6U5rD8VLNdVDMZig?=
 =?us-ascii?Q?bHQevShrC50AkPNasMV2cyb1NHxMzl11C0T3udm8bX4HRUw22fRDBcJxaTM4?=
 =?us-ascii?Q?udD41iise4FJ1sOK5NwGEcQWkYRYr67mg9ewk2lxIBc8ZRlIykpMsW6XGfjG?=
 =?us-ascii?Q?QPIsaeAO8NTowG6F4yJROrtMua5xjG4VzcSBIIsaem2SuP9qMTb40U6wPzfm?=
 =?us-ascii?Q?vfBjmjvS2JLMDWNcFRBI/wTPj14EkOCABqqg+jmzlewF+oRTXO5rBvJljqd7?=
 =?us-ascii?Q?ygmu55TEjuIOlAhm1NVK/YJp/Iv2benkOAAMLWzhuxWMwHhXjn2SM4tisg19?=
 =?us-ascii?Q?nMYiI6Hztu6GRkpDgvBgYFUo/iDxp34LCBDCiyEofeuCChkXYroaFI+hmdX0?=
 =?us-ascii?Q?QNlFEItW1LNid5IPoIoRr3VZ0/OsGDiYRPiYdEAoGW5Quptm0k8XsiwguqTP?=
 =?us-ascii?Q?Gd+BH97VVT5p6rXyjUpWC8VqgvEDj1zqShs0xO0kv28lJAE5bQENCZm4cK75?=
 =?us-ascii?Q?HGratkRqIZB8y1jPpNcjzItOKejjw/FXVcN6EKEDKHvoAHW3H2mHREFr8wM1?=
 =?us-ascii?Q?W+Hvrw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ffca995e-776d-4cce-1bb3-08db077e27fb
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2023 13:37:42.3129
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MavnME6pwVfT2TlyYhJO3f/JmAozH6uvCMiW/FTncfgNormc/Gm5YgJkkvyEqptwJ3WRAD+lKu4IaJS85SlHgzYxUSh2kgR7Ol7YBxtVcwU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB6114
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 05, 2023 at 12:29:59AM +0100, Martin Blumenstingl wrote:
> This makes it easier to understand which values are allowed for the
> "queue" variable when using the enum instead of an u8.
> 
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

