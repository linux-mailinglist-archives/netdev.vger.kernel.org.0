Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20DE968A2A4
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 20:10:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233509AbjBCTKB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 14:10:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231614AbjBCTKA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 14:10:00 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2136.outbound.protection.outlook.com [40.107.237.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14284EA;
        Fri,  3 Feb 2023 11:09:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ISdJ1cFgocKs/xOe0sCMGKKaQ1Mh/YJNKHquzrhal/3CA/IsC+bFVAxtG8XWEXlv4yGnb/PQn7mS/Bel3AoOfXKGJMdr7wSzszOhL19iFSOBt9Q0BcGVG3VAWojz0fgRpx9b39P7rDPRHY+ugKSLCbX0xSxVOm55hRAq8C3/4X9TqtNSxxHxDL1WdIS1u3rOAOaXn2Sv5suMiifhg6keZNauuunqjp/CW6A364wlT6+g3nXvzHb9wc82Ih3VUqb1BWDySnv9IgWXT+/q972pqwNURnr9rv3ky8q6HwZnipd56G6KWv91kIrCrlEI0c358JODCCmIj0KKQG75e7nSPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hRkRJhVktJp5ijn1o9Sk3osCk7XMX3vht3cENPQq7g8=;
 b=A/unXQPsxsI1NgrwsbbKjvTmArxDQrZMbFrIBm4xfeiTgG7PluIFRe/N5yiI7k5jaGkMefs+vEtPMJpQ5caiAUB4qELGBuwk9Dg9KPyzkBjiJ4vhm6YgO6y+rTKhj7/BKn1EG3v+vRcqUoYsT8IpWTohZf1bV09pwU+0hFIqU7UkToeg8wnAIuN1TdAqPRkqX3JDsVQYxkpMap/XpctHZHXf5VPW9K+0yifeX507+2F9/jAn8S7YmFjj1LvCBhvJasTe6H50I/vlLPOnFwOpkMCjHgr6r10cRcLATu4ySJjLJlnvIM+1XxqMvZ1bdfK9q12cVBLHq99M0Z2tLpO74w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hRkRJhVktJp5ijn1o9Sk3osCk7XMX3vht3cENPQq7g8=;
 b=bW2GpsRrua/rH3OX2df1aMh7j4OQ1zFWASB6IJwBo8PH2cddKYlyzc0pSCwQZFdEQ1qYAQ2TVH7CNP1wNCX6UB3zqdadNFBLXjR5FUTYmDmEB6+Kb5OxIy01tU9Wfq2k+YMfCtYcznNcuGQTDBAsOYWQXkgy78cBJpDM/VjTMDg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO6PR13MB6029.namprd13.prod.outlook.com (2603:10b6:303:140::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.31; Fri, 3 Feb
 2023 19:09:54 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%5]) with mapi id 15.20.6064.027; Fri, 3 Feb 2023
 19:09:54 +0000
Date:   Fri, 3 Feb 2023 20:09:47 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     Alejandro Colomar <alx.manpages@gmail.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        linux-man@vger.kernel.org, netdev@vger.kernel.org,
        kernel-team@cloudflare.com
Subject: Re: [PATCH] ip.7: Document IP_LOCAL_PORT_RANGE socket option
Message-ID: <Y91b+yiXtEWDTn56@corigine.com>
References: <20230201123634.284689-1-jakub@cloudflare.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230201123634.284689-1-jakub@cloudflare.com>
X-ClientProxiedBy: AS4P189CA0044.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:5dd::13) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO6PR13MB6029:EE_
X-MS-Office365-Filtering-Correlation-Id: 51f0361e-2a13-4adc-0ea7-08db061a3b69
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vH1m38pU0XATwHT9iailfFGVBeIOz3vOiIXOls50UA22HWgaLv5H3NZPQc1gL5HCxsvWwNKURWCvsiMK/14siqpEn3CQ1WSyDTUbpxvjNeV3QM9Wq1VHvJaujKbuP3UjT+taofZ2oWVs6vVPfD2COjnES0MajbAkN7Rs5AzngGDjRuexITQcC4fAPLSwbqDofM8HM27EyyVXasb+ZKz+HkiuiZmreOeQf88NKGadZ1xeZW2GqinbJWKQxywlCagLXCH9ToYa8pVJ3CjfIRp6YjFiHeA1BukUeW9WA8/EPkMtINl+CS/Ex7gZSr6LedY8f/RykV7CtuMNMT6C95smFE2neBbRreuJXCi+oDhqXHgZ3fBvuaKJGm6lxhHKhbqIt+65CwMbdW7lEgDrY6SP2/Yj60Y4IFU+545iV/djCrEWk6pylL7gkT8KECXrBUTCjIRcFyCvwYGjsDpBL1GyJzHQnUM8wgA6sqjhyxlMdADtlFtfGMrHNKnFCesVTmt/hudUzCBntk0Xs7EbAXcqG4M8wo94doHb77pziO7rLZkwo0BzadT5YNc88oZYiI9u+ySvUolZwileJMfvTjeNSBE+f1yn7wxbDJKoanxDItLokj1JaVOl+z/rpzvg+e+/Tz1M79oqHdHQqy/f0WjQAvBQTeuM6wR6YHkfrSk19yWfGqwiAPKr0rgsk+jCGQFBNmi4qeWyzCa1w3Ffiey12EZr22Lhi8M88+Qjy/S26WmvTlXVt+w0XkkZLLmBXIdg7lHlaEBkr5Voown3mZD2pA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(366004)(346002)(39840400004)(136003)(396003)(451199018)(6916009)(66476007)(66556008)(66946007)(4326008)(4744005)(5660300002)(8936002)(41300700001)(54906003)(316002)(8676002)(2906002)(44832011)(83380400001)(38100700002)(2616005)(6666004)(966005)(6486002)(478600001)(186003)(6512007)(36756003)(86362001)(6506007)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+JXSAAtwdxPueTbw0s1+D4atmVBQtFIPMUK4i6JftW2f6AOgc3L8vloQg5g7?=
 =?us-ascii?Q?JU4nP3TNUQp92gQlTphvQlNS4le582aqtFsxetToMKuxcd2IuOBdT3AfJnM/?=
 =?us-ascii?Q?YfVTpLe2PrbM8MqdD16/mhrEl1Ix2PegAIBG9dl9m7pCZHn002GoyQSrIU8V?=
 =?us-ascii?Q?5L5uipkU1M7q+VTXMV2RI7w/KTlLS3YbWQ6bR5f5xZjV/oLvYUdU7JfMifZm?=
 =?us-ascii?Q?bYdOL/Nqr1HD+FosQtL2YgkZEDikBc7/sh0tII66PlsfQAVWXAeFzuV6e372?=
 =?us-ascii?Q?zny5NhEDWOqNGBMM3RLr7bVTrAb7whXgOPiyoH0bDfqf8cDNRJpZWQeDgf5o?=
 =?us-ascii?Q?SxyVIxoT4QdQItzbQpTi0ywKGIWuOpbyIzj6dY+TYgGMBwWvGBVhHslOswj9?=
 =?us-ascii?Q?hPr9ijjVgHyOg6UozIBIsRbp7xh6X35xkOb6w+tKeSdojHRp3Js+2eJo/b/8?=
 =?us-ascii?Q?kMHcqzuwoO4g4WTGfdgU9+panQSCEzNzDs5onL7mJzmqSrxEjGeKk6KHFRSr?=
 =?us-ascii?Q?Oher4LmcB5arUDU7ZUROfHPXPkwek22TqEYK5wgtoLiXgjrF2pN6WSu5YStd?=
 =?us-ascii?Q?K0sOkHmilR6gf/JTE31zVLAU/uP2QjkfdHBEETA4cL+6q5RSb/q/p0Qj8BDP?=
 =?us-ascii?Q?pLtBS89i4O7PE+uoWN0RblAcRF1mTPL1NGbkwx1x/+pE02OTfEfrZk38LCC4?=
 =?us-ascii?Q?pwSpRMYGTiN5fMD1BiWrpRjr7W+KT/If2w80OIyB7MDRHIiO6ejn/5QFPoj+?=
 =?us-ascii?Q?LKsHfkZ9ZAjPN3MPV7H7nCb30HnER0NbfGvNJwKzXhkvaUVskt+L+7jPA8QX?=
 =?us-ascii?Q?6h7V6q5A5AMzU8Gy/AuqpDw6LciUj3K3OCNjpg80C+/BgiiXtW1gCue9bLCl?=
 =?us-ascii?Q?U1YhIByXtCDwsuTc1FsC1m9aRzWoGeGtRZ+b735pwUFctOcJINNgk2FbaId3?=
 =?us-ascii?Q?V+ch/Bph0TIqfXSF5+Q0jwebmTS6yXbPH6jbdchZQKDM3riNJhdY8b6SeQWN?=
 =?us-ascii?Q?nm7JBQMKIkDnGbYd8FJQMEC8e9a5Irnr8D3eqjnlrz2GP5BKij4nCtv8HnK7?=
 =?us-ascii?Q?bqXSWe4vgZ5yiSMlOn4eQlQdJl/0OOY80u0CYfuNC8b+FLa5hQQK6VDIInTG?=
 =?us-ascii?Q?XfYLoeiZtZIZjoAlgxOH092Ss5jiOy9E5sCp23KqBBoOkT4Oh9zMJ05EMBjA?=
 =?us-ascii?Q?lhwldUvw9vs+VmG245223b7yuFKrKQ21kcqQI9IVnoJ2H3XoVVf1YiEiBtn1?=
 =?us-ascii?Q?OzL0gxYfEnimhR5nOGrRj8OO/ozCp6c5ztMv8q4z9uckFnQ0nLxj0TZEzupY?=
 =?us-ascii?Q?zGIKNwJ4rsLUSmkBD8OTIKsy6xvzxpxnfdptB/KOLUkFlfV6uClj7QJwXfRp?=
 =?us-ascii?Q?lJnEQLJR9hlObUQvMJyL9WJKn7+d6S8B2xMjvhKpQxvpdBF+djI0B4wKbg4x?=
 =?us-ascii?Q?4njNKinkFOjWjCOVX5kmrieMkM+jtR0MiUuvfOEFc9aTyLHWopzG+C4A8gIa?=
 =?us-ascii?Q?q9r2xzemm42LAAWq+Wlq5pxKF+OBTloM8cV++6RsD0yrOo+T9rI0MB6T2Gka?=
 =?us-ascii?Q?cFNE8h/2R3e8cP6cBYq80f++Xo/csU0NNpof042dXcmEZ9z5yN4lkylYuto/?=
 =?us-ascii?Q?sPGoS69iSK/lcAAQwKFImrq5eQcMY7R4nL8pQc5r1AsjB7XkArJ2onoWgovf?=
 =?us-ascii?Q?4GowAw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51f0361e-2a13-4adc-0ea7-08db061a3b69
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2023 19:09:54.2307
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ALsTQgXBajUwi4uZAxEzz/jKwU0BUHl7VBuvEJHQPkk9q349az00TZcEqYgCSEu4M8fck404bIX2vSC+NI8cWO6euzz50Owxv/pI9aKa03c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR13MB6029
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 01, 2023 at 01:36:34PM +0100, Jakub Sitnicki wrote:
> Linux commit 91d0b78c5177 ("inet: Add IP_LOCAL_PORT_RANGE socket option")
> introduced a new socket option available for AF_INET and AF_INET6 sockets.
> 
> Option will be available starting from Linux 6.3. Document it.
> 
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---
> Submitting this man page update as the author of the feature.
> 
> We did a technical review of the man page text together with the code [1].
> 
> [1]: https://lore.kernel.org/all/20221221-sockopt-port-range-v6-0-be255cc0e51f@cloudflare.com/

Reviewed-by: Simon Horman <simon.horman@corigine.com>

