Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E922930C800
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 18:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237561AbhBBRhs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 12:37:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237511AbhBBRf5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 12:35:57 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on0600.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe0d::600])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71B33C061573
        for <netdev@vger.kernel.org>; Tue,  2 Feb 2021 09:35:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nnXaRCHOJ+4XvqhyZGXZP80w/lHi715hXZ0tsV5bAsf4AJdta2T4bVAe53CcS0tIBVStT/aMy1PP/pPJ3rpPqYHW2C+uk5RV8GJ+P02fO/cChQ1mf9GFJHi1IAmdalIbRm/OQJsk/bZX5fDjra91Hud6DYIkbGs7yglNYYTMUbljWqTWpwgNZgbtEJtoZZKmUB1E4cfPweu/yRL2o8uigP2Ih8RZkE8gblNm7s139l4lIK0AcjTJwAXkzVU320bWJ7mEUzoUXBayvXe/mtLyq9p4gqz3L3SqWsfIHKpG7SG4hV6Z5WS4ZnMDQvnWPfl21tC+yKvqb2Va1XmbGo/3pA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CY0NqXbBwJ5V32XwipRzTin+6NJw4wtGJPdU7yHYk8w=;
 b=DiB2hkHlklu/4P6VZdzYZ9ylCA2QUadHD1KOwJGAzJDrOiq1sOZNMdNrwudM1xnu4+eyGtUCpE7dsSrTtIuT23ZSaxLKxp4T4PcAtRQNLZOhpNJzl2/OAeZdthtRTa8TGkcyjiFxhqETyK2JzGxBixLfgsHeVw08NHl+caOoRyoDHp/h9XhulwQcWFR1Soq0+OZXDJvmW326aIOS9UUK8FZrmwnHpYwIBoMMZGTRmrdA/YpCBIkbNXq7N9PwM7o7NawXPvBnMqGogy+uimPlqjhq1FBoBPDV8vQYMC/ZfwM9YKKzJEFxDVmaqCpMzQ2vh4T31jJwriaahR3PutE4cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CY0NqXbBwJ5V32XwipRzTin+6NJw4wtGJPdU7yHYk8w=;
 b=bQ3lozj7ACHH4+SW0u+VaoKqd+RtZ4lPdoUfBsM9W7S5jwsCkt4tETRJ4oIEtCQTr+BpsOxUx4dHaLCRmgJzMKkfIutCFiuFdf3QU+QeMfDs1AyDl0wYRLfkCrey6pr2pYPGp5DpTlZGGQdIl+gnMQy89sS8mgt2QndeFspFCuY=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com (2603:10a6:803:ec::21)
 by VE1PR04MB6462.eurprd04.prod.outlook.com (2603:10a6:803:11c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16; Tue, 2 Feb
 2021 17:35:21 +0000
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::6ccd:7fa9:bada:4]) by VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::6ccd:7fa9:bada:4%7]) with mapi id 15.20.3805.027; Tue, 2 Feb 2021
 17:35:20 +0000
From:   Camelia Groza <camelia.groza@nxp.com>
To:     kuba@kernel.org, davem@davemloft.net, maciej.fijalkowski@intel.com
Cc:     madalin.bucur@oss.nxp.com, netdev@vger.kernel.org,
        Camelia Groza <camelia.groza@nxp.com>
Subject: [PATCH net 0/3] dpaa_eth: A050385 erratum workaround fixes under XDP
Date:   Tue,  2 Feb 2021 19:34:41 +0200
Message-Id: <cover.1612275417.git.camelia.groza@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [83.217.231.2]
X-ClientProxiedBy: AM3PR07CA0093.eurprd07.prod.outlook.com
 (2603:10a6:207:6::27) To VI1PR04MB5807.eurprd04.prod.outlook.com
 (2603:10a6:803:ec::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15136.swis.ro-buh01.nxp.com (83.217.231.2) by AM3PR07CA0093.eurprd07.prod.outlook.com (2603:10a6:207:6::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.8 via Frontend Transport; Tue, 2 Feb 2021 17:35:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9111b510-d5e8-4169-eaa1-08d8c7a0e9d4
X-MS-TrafficTypeDiagnostic: VE1PR04MB6462:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB6462B1221BD3A17DEF3BD8DBF2B59@VE1PR04MB6462.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SRj+oZfV9y8WBkrgDzd//Y0RVoTDgf59roAr3rk4gUq1WuVap5mclko67d9Y6SpyV9mKL5Fzjqiut2NDx4bjgo5wWOy4x1ZBaIi3iTTOq1taNgjwfi9iNLgO7b3fpi36TXZI/OmclrzF9nydn5thRYPxKTZPTNQdxGiJjz0DMmp+vGGKBhEmRhtNLrMqhn8gDjL0GD/U0x2jB61PNU4wj7qHQGx4njtWgnjJ0T0euK7e8V19ZRD5M4Naj1GxTdorTyjTT/gRHYzSv/UeUjddJZXf9SzY+Y1V7UqY6I0oS5N5cOj+1nkeYiluIHm5dnpPkNtObU16ZJVVTxGdVAP4vN/bI6B2ZhiKoMI1cyIdHIpoW8RWvsg/DxXPn7ilF5OPB3X71vNS/VgGSS5MFXk9sEUaoMaXlNFhQbel/RMu6NMyoCmcSaBhiGKnsLsYfqIyuv2DxvGESc4X2tnXtnoRfspmLTFVtD6Fg250hRh9qyVrwQYh+q430lgqlYa4FUFOKALmAA9Atkn0Hy4iHWaIbQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(396003)(376002)(346002)(39860400002)(5660300002)(4744005)(26005)(6486002)(52116002)(86362001)(186003)(44832011)(316002)(36756003)(478600001)(8936002)(16526019)(8676002)(66946007)(2906002)(956004)(6666004)(2616005)(83380400001)(7696005)(4326008)(66476007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Q5vbdyuPCGQuEJToCVh1ZAAG9BJFFs4wlrJsqQ0a8hO/JsDCGPZrVvdXYQfu?=
 =?us-ascii?Q?apaBrxS9egAEHrL+mxHfSd6LQuEER27DtEeiooE5bh4kfZZB5FqdMmP0KQ6u?=
 =?us-ascii?Q?jbdncUWeZ4/Y6oDMSEy4Ro8WudTkz8ad9v/7QuHGEeQZa4JIh/UvSYvq0yCS?=
 =?us-ascii?Q?LqOy3PUt/Vchnizp9AWwgIu9c1dn8P+3zR0wqbHKKQGo+BIpnqqK4FAV0wic?=
 =?us-ascii?Q?pUzpTbaJcH0unsXhwSaE1xIey3LZbHH5Z4+X8wlX1C2KGcQLKZlEfzitL8hN?=
 =?us-ascii?Q?5sedb/K44wH/C8wm98neciR2rE0cHNovz17xATRK9A88DCuQyLsS5hD2fiJ2?=
 =?us-ascii?Q?hp6lnuMwVobbuyEnr4Wduj1qmUq1dIF2zFDH3fPBzTH0Fb0vFZ6xpO2/fL0I?=
 =?us-ascii?Q?V475cOFdglqn7RIeS3m/BHfzR0X9kZL01O58Ix0H39IpkLCvvCSAX9jzA6jN?=
 =?us-ascii?Q?HPGwNg016p0sELfZ+Z0dwDW+q+k6vAtWZT/kAHPW8ZrD9lkXH58E9T1ZnwsW?=
 =?us-ascii?Q?I76QbO6C0kuuQlFgtYo6wb0mlWpJYAXOGBxWFDBIznxEGYk0u4ebL+s3IBqG?=
 =?us-ascii?Q?9p1SLCbNfMAR4+MPpRQVavCu0B4h0d4UdXvpRzdhe6Y1oFHqKyqTvPvCWqQL?=
 =?us-ascii?Q?NpFCKuLh1inDGAhSUTZv0p4VZhxPGc0VIzjcPG1XKFubNlIs1qfUBacVCJb5?=
 =?us-ascii?Q?XipehZzpHfCj2+xTih28lBx6+YRShzEJPzg2HLaYRuSD9uZNz1KIDNBN/Xot?=
 =?us-ascii?Q?e6ZtKu3JsX9r1EeixtbL4HGtnLMlpwGYFv8AOo39LdR+5KVG7auqGjVvepS7?=
 =?us-ascii?Q?b2CE54dYRVOS5rllEGukxIcNZLbTxvc7UCIj5jECS0EXX4ioManxgCOtXiWj?=
 =?us-ascii?Q?cfWnIDyU26SsK2/VjAYw24MQQ6sMNRrI+W8fuEMSVgUJkl7/VEXxux6SHN6c?=
 =?us-ascii?Q?prKQfC6q9Yaz3awEPjH8QRN7JG8cz778pyB+RvjijFhFLE/lz7OJrDAmRUsS?=
 =?us-ascii?Q?BHgC0+iJBIl3deClD0OG45rz2v8ZAO2MCo7LiuENnb/YGyViQZ5zpO8ey0pO?=
 =?us-ascii?Q?TLOb3x+MJDOV4K74rXqznSsdltQ6TsefU7JyVea8OhhY7jA+Ck9W9h34HHDG?=
 =?us-ascii?Q?Md3+NdgfhCBrTcGCNP8LO4luQpZXDKsqihyzjAN9axaGFNzkggbEqiVv4xov?=
 =?us-ascii?Q?22AY5082axgugKjlYB1tOmdiQBL159xkjvum3ri2OhAKDB/6u2/Ywuf4LhLP?=
 =?us-ascii?Q?/K6eeZG/2imYlwEXn4Sp2UyNIRoCcAkEUCRYp9PycgsciJXXz59Pncz1cRF6?=
 =?us-ascii?Q?GgpBFhsqSOmMtYsNrUr/lVcT?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9111b510-d5e8-4169-eaa1-08d8c7a0e9d4
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2021 17:35:20.7623
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jUtuAtqyZ4woiWYc504oKz9Wp+d8gVaYqCX7iNf7mhPuJCkgiKZBtA36uFYMVk+IosQY+uqXHemllR3M9KVHew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6462
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series addresses issue with the current workaround for the A050385
erratum in XDP scenarios.

The first patch makes sure the xdp_frame structure stored at the start of
new buffers isn't overwritten.

The second patch decreases the required data alignment value, thus
preventing unnecessary realignments.

The third patch moves the data in place to align it, instead of allocating
a new buffer for each frame that breaks the alignment rules, thus bringing
an up to 40% performance increase. With this change, the impact of the
erratum workaround is reduced in many cases to a single digit decrease, and
to lower double digits in single flow scenarios.

Camelia Groza (3):
  dpaa_eth: reserve space for the xdp_frame under the A050385 erratum
  dpaa_eth: reduce data alignment requirements for the A050385 erratum
  dpaa_eth: try to move the data in place for the A050385 erratum

 .../net/ethernet/freescale/dpaa/dpaa_eth.c    | 39 +++++++++++++++++--
 1 file changed, 35 insertions(+), 4 deletions(-)

--
2.17.1

