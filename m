Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79E746BFB26
	for <lists+netdev@lfdr.de>; Sat, 18 Mar 2023 16:19:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbjCRPTY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Mar 2023 11:19:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbjCRPTX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Mar 2023 11:19:23 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2134.outbound.protection.outlook.com [40.107.101.134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58CCB1E5C1;
        Sat, 18 Mar 2023 08:19:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q+Hy0onOuAU6PqppbwhV1ubJ6o2zleq+qfLM7tU3nDWf+kqPo4zVgB3TryoxmekJKh7WE9O9Mjlz0SMkfKee3xsqdz1nupMRZyyHXjr8I8QixnCfKPp0KcSYEg422fzloPe0VvIWIdbxcOF+X65iOhALlYwNNMz4iiViBIKf0lYWQjgGT94W4QnU6H1WQojaWgdcK3tSkGmbGCXRysEY157WFfoXG35GkxWxaNvJZLhoVN9MkRBvnUdDl7CtY/r6I4zf/nKgonw+WdPEjVxAtF8tdZNBLgEv2bM9SkoONwfsgxJYnC8KFvjHvYEngEiJklpR60L9VZRqQulBmfn7KQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fbFaRm6Cew8uk7gpSl/6lu0upxgFIduCjQvs7EvFnts=;
 b=a1+ctCbueotfcRhduxv9i47dxQdP04X4xEIIQRFPae00/smrIUjM/1R2i4H9OkTR17i3nRrm9Dbu7tBMk4Ui1Lv5OJa02uR88V3HeNJVFpBH0+s5FulbFzOH4/SQ/X0asYa+V+2ghDH83hKT8cH6D6G57G2Eh/NWOgB63Ho8VwIbTA2iXIPChGHXk3agK6QydsmOpWT/ZRltIKsDC6pElRxyD67JtW7IuMNawT3r+Njgv+VI8tGfDNf4pYn9GGMpzEPAcpJKjcNsWbIw6V0dMhuU/XVvXQeJP905P/gkLLuijpBBSGu2AlTZwO+1ecDRXwvJLYlGcveJJie5C7u/ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fbFaRm6Cew8uk7gpSl/6lu0upxgFIduCjQvs7EvFnts=;
 b=wHHd37+6JQ6K/CIiqPBKBBPwXFpR9HNQoWld63obvH1f3kbUjDZIE728nXcAIiOBJTlX3MpfNb1NBrfPAup3jZEy2Q0rsz+EEgW8oscbTnnbXV+CooZ0Y6ehGaes1hjXqBFdL5qTmfmBFCM472hK/7QjWjsABTEq+E5yoETFCrQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY5PR13MB3763.namprd13.prod.outlook.com (2603:10b6:a03:22a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.36; Sat, 18 Mar
 2023 15:19:18 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.036; Sat, 18 Mar 2023
 15:19:18 +0000
Date:   Sat, 18 Mar 2023 16:19:08 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Maxime Bizon <mbizon@freebox.fr>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Grant Likely <grant.likely@arm.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE" 
        <devicetree@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] net: mdio: fix owner field for mdio buses
 registered using device-tree
Message-ID: <ZBXWbPNHn0si8a4g@corigine.com>
References: <20230316233317.2169394-1-f.fainelli@gmail.com>
 <20230316233317.2169394-2-f.fainelli@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230316233317.2169394-2-f.fainelli@gmail.com>
X-ClientProxiedBy: AS4P190CA0036.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d1::7) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY5PR13MB3763:EE_
X-MS-Office365-Filtering-Correlation-Id: 5697c641-c4f3-4d67-044a-08db27c42451
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TfSqErTAmFhuQqexSbF5wUoUb1Hi5b/V3Gmnlg3tkHdYs8Lu/7Zx55q56+KjcUaC6QUKy+amYKF/5Y6fWbYPKZW1RjMQmIlPgMOAfydY9s/SZoG3PxmyLchvx9Xcy6CzJkkcmmp1/yUmaEpNAFsWII4RSfNf3y9XF0HzWAZQvkPICRQg2vgLZSOOrKNzwUBsYPT2GoZZqWzZzIkGZ6hCKQU1F444RuQUrcMSjAx0lXpxiRIDrK+mjEj+7oU4QZBrtRClBnKN14vkWUS3UT9ZoVWgbwjWsy1rhd+UXdB0thmyohUj4jIg/6WQsf/bxQ+wTCGSR/sEhA52G8wfWjBLnBOPIoNJwKtgmdCXaB9pcFBby+IDUfDMSHTS6DVzhyOTrh9DXjLukOxfzHo9WW2bxm0PCF0DhNOHBjIXiX7RXYRDlOtspUSX0KvYJwQBzb39VU+oDHJMnIQvWMCoT9wqXhQSkOKb46ypkwX1tyn8n5h4B3x3SMurHONhmJTrlSL1NauLSAwPhutQAx3vLeaavKKtz99DUjQyItwjRWaYJ7fYl7zgz3ou3YA53MBHAokqy+6b8gDl+ztSNS5rdv48htls65EYeJkDmqQQDPSyD0ftCE7UK0DEL+A1UsrmjE7oMRuVlwRshm8wl+ERzI3F1XHuo+R/PtHXoVrMtgpDnMlUY3K9ZqtRKhW92A0oiWLa
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(39830400003)(136003)(366004)(396003)(346002)(451199018)(316002)(478600001)(6486002)(54906003)(186003)(8936002)(41300700001)(6512007)(6506007)(8676002)(4326008)(6666004)(6916009)(2906002)(7416002)(2616005)(4744005)(5660300002)(44832011)(38100700002)(66476007)(66946007)(66556008)(36756003)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YQwjKpegT0XsTsQ6wM42sqX9mDNRawPmRJJHGrvtYdqNnDmTddqMF3ebl5z3?=
 =?us-ascii?Q?xDwmVNJRI4F0Lli1UKEo9nh2JoX+tLcdviC+T0o4+pqsekFCeemuc+XdeM+L?=
 =?us-ascii?Q?53IVUQx753kjxeovNNSbc5kXwAgKRwmYHc78TzwaEXRLTNylMR1W8H/DecqB?=
 =?us-ascii?Q?Xe3dZ5Dv3YSqmn/CLBCaXH7fsb2OPFaQ8ic+6tse/kFr8GxxSMohC+LZb5y1?=
 =?us-ascii?Q?7oxEjItDZ6q8VqOU4JgdLI1qeXZ6XKJMWS9ULrfJBMqD191DxCcDWIfoQ+5u?=
 =?us-ascii?Q?YRLYbplgk3qPTUpZFmsWhRn1/WkjFX8Va+UbOAIG0qkvgxYAP87lycbvPv7g?=
 =?us-ascii?Q?JuAkZFGNGFsrx/oN59EbhPSQkK8VLseWwPcVKYenkvwkyqD8iygzVeaS7frs?=
 =?us-ascii?Q?ubSQLVBSfSeAqxjsGyK+Suu8YI6cFWgCCoGcjDkZD/4N4cfc4iD4tXA9+JlW?=
 =?us-ascii?Q?Ow4dJKsqpHk45M+S628/OTz9qG5+wVsYVHuMxsKXjNjxdGTirwKyF4Mw2Eqh?=
 =?us-ascii?Q?LxRZ5YneQqMgA1loj5bae45sScYAnW7lwk49ZEOhxS6RdCN53wR6BWybLj5N?=
 =?us-ascii?Q?UGdfmeS7VrjxM/Ktn30HMn+imd567STaiD631G0ajdLfuhlDgEX5yio+u/zK?=
 =?us-ascii?Q?RtKtovOQrFqDeKYK9na89r6kco1En/nlDVTeJaC2oZ71tPsOunrDh0sRoMOl?=
 =?us-ascii?Q?1+VwBdw0Iiu263PmnEgOLLRSI8ojvhA24k7CrVsMGy5mx83iVjAVoyCiatlg?=
 =?us-ascii?Q?d+blIOfuwjHExH7wCaSLnSJO5yfrPwQY/DvjKNBZpefuftG4p5RJSyMoV1Tp?=
 =?us-ascii?Q?DSdYYkpqzkZrx9m/ZWhFbjb0A1rcoHcQZMyLSbBk53DaUEpZj8bAt9GFOIfJ?=
 =?us-ascii?Q?qImGBTrwWqDhbuQu6/ISlUVWk/G9DduRptxQ8QsQsbTjsBGMHTaPbgyrreYp?=
 =?us-ascii?Q?UIsYClzxn6d11D6w+RKm5dIHkZ31LuM2UkUbj+anVkPt/3U++GLJRTdzvMJU?=
 =?us-ascii?Q?1ru/NWMvE66ssW75MsmX1A3RG5isRQPOt4V7ko22Cpnc0MVqtlINmPjxAqIf?=
 =?us-ascii?Q?M3nIt87oeKh6gOaW//LnoJytcSUMisYqS8MWaNRXqK+Nbd3Y2wloZu5gSQSU?=
 =?us-ascii?Q?LkOgSa+8watNfQOFu1XUxRvUqWcz/snWAuA1kpL6sldmYr2/FSgUf4tUYQmX?=
 =?us-ascii?Q?P1ymuvHEY4V5oLfxcNBYTXA1fxOPjNbapkMlGPA8vZXs/px2SZtvWYBzAbxc?=
 =?us-ascii?Q?7RmIMySs3hdG/WdAChJY1oZPUZd+LDO72hWu+x9fY0NSQ4TgD33PiTTJxu7T?=
 =?us-ascii?Q?hi+J5Cyo3JrBpDYVin/GEFY1pLHUAJtXl8xHgJHE5F8Op9Yihv9qXgd8hZnA?=
 =?us-ascii?Q?htEN6RybLKa6PaxpiwIWCBBgeDSh0msBIACd2NBSZwbnC9a1PbxuqaxGlppe?=
 =?us-ascii?Q?NxC3g3tJkiEJZ5UPw16rt2XuaORMqGfMk1JQtlAypYCLblPoq0UWwdAubLv6?=
 =?us-ascii?Q?0Vdhc7mOUGpfcD57KRu5PcBFAwEoXxY/1FqX3edrUVuW+JFu89C6l4anFSI9?=
 =?us-ascii?Q?wKdpFJARhHv2NfRma5FRCXCAnIrEWEFwQOzy8xRcPVY8xc19cMuEEtE6jl8O?=
 =?us-ascii?Q?rYkusp5+eIEAogw8mXrXp+h0jxC+uPf230Vhz2tqQb9rCo//LESsRCJAg1rX?=
 =?us-ascii?Q?L8HhZA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5697c641-c4f3-4d67-044a-08db27c42451
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2023 15:19:18.1138
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EWljA8zTUuh4cxcLAN0POxYceTF/v1MX3A3RHwIDKbAGW9yz/tsu4p7D4n3tKQBIsbPMJCmbcxkzCxNkiR7mjEJ9/9Ikd1zXgygvzG0jdME=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR13MB3763
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 16, 2023 at 04:33:16PM -0700, Florian Fainelli wrote:
> From: Maxime Bizon <mbizon@freebox.fr>
> 
> Bus ownership is wrong when using of_mdiobus_register() to register an mdio
> bus. That function is not inline, so when it calls mdiobus_register() the wrong
> THIS_MODULE value is captured.
> 
> Signed-off-by: Maxime Bizon <mbizon@freebox.fr>
> Fixes: 90eff9096c01 ("net: phy: Allow splitting MDIO bus/device support from PHYs")
> [florian: fix kdoc, added Fixes tag]
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

