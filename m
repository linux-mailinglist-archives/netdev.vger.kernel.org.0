Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A60DF3E4522
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 13:57:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234723AbhHIL6I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 07:58:08 -0400
Received: from mail-eopbgr40056.outbound.protection.outlook.com ([40.107.4.56]:40885
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231478AbhHIL6H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Aug 2021 07:58:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=My6E5XXmy/vvoIMvW2DtHmMn9H73cbjfPq+H+toUj2NZ9nPt4cV7JnV67z5fpvSRWJf3i+cAJRJAhsis9HaKkCUumMK+Dl90FKWXAH1hp3AfkFt3IW/WzR4upHfopOEKUlD4DBG6bSCGnr5C3bzCosiCyezopX2lFfPl6STyRLJ8ENlViipznaKwFKRif+clKPAVpEzozu2KBjrIHEVYYI4i/VAxrgrRVHCQ6UlqlE+cOILq/5wfIPeSqh9oPoNf+ezjGILXq1Dbbp50BxafHtMhZgwW+w8uaOSdub6Qzqlb602Sz73XTVTYVvcaCwCfYGJW64epJSGeCbHRQrpWvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pZNorZlF1z+trz9BZqZgzkU9zl73q91VWniKGK9UxMs=;
 b=d6vlLCMGF7VcgC8hHC67ZV1fmBfbyZcuXwdj1Juo0Vr2UynWkoGDoooqjfgRoBS6rIMokDLpbiqPLv5WF9PfIwRIfCEd6zhzI03DGyuHIrMehGKtzM818WA6r76IFAAN7nhThrZuP/MAcApllivYzRAq7B4XPW/wEbH3pDC9NSxQ7ccvkSNTONUAEs5x/j2gC0vZbVf1616C5+T5G72GweMu8SVKngKOlWBn66fGFILwoqKBRCbqWdgJ++WzEsEw0eanDlDqBcmSRq8xQl+opf4i0eUrmUJq5T2YXQKUpfZooL74l0CHeLu9Y0MVPL2wJb396gXqjvk2m6u1G5zjJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pZNorZlF1z+trz9BZqZgzkU9zl73q91VWniKGK9UxMs=;
 b=MGvh4ZQfr9FBOeW1HDIMJQsZ67UM7ju7CXjI4KM8nQYZs3xw8KKlMqGCPcR0CAy6NiEnRZ0n+wn+JeFzhT6NQqZ6NrgBiMErIoWCx+N3rq1sy7PA/Z7kSW/GQ4TYlg/gGOjrXgbLVxTlQE23mR8jgHsKUy4Qi77Jc1pzM5oNdjg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3712.eurprd04.prod.outlook.com (2603:10a6:803:1c::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17; Mon, 9 Aug
 2021 11:57:44 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4394.023; Mon, 9 Aug 2021
 11:57:44 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        DENG Qingfang <dqfext@gmail.com>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>
Subject: [RFC PATCH net-next 0/4] DSA tagger helpers
Date:   Mon,  9 Aug 2021 14:57:18 +0300
Message-Id: <20210809115722.351383-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VE1PR03CA0012.eurprd03.prod.outlook.com
 (2603:10a6:802:a0::24) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by VE1PR03CA0012.eurprd03.prod.outlook.com (2603:10a6:802:a0::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Mon, 9 Aug 2021 11:57:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7b490516-6b18-46da-9c9c-08d95b2ce5d1
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3712:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3712BD2FF9E2A05961D0BBD5E0F69@VI1PR0402MB3712.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A7kbWPZRym3SEuCxLHmfdk5j+3sHrMgFCL0Zvrbz4InKNMqqFhK6UhLDh40G9BovTbj8GpBm9/thXgO47TkVupD70QjRPA3KxsaMMZ5VUB/NFVQJAQSN6LY7b5B+0DHE6CiVZs0P+aq3/1QNIukOnv1vXI+uFSK0jpGITE4X4IKlALYhSecptp0kOQFjnIOuy2TLowTZlvrl/M5Ea4Tn4ps+T6HqJB7LkLrtpucRmH43n1gK0Q7mErXtax5gL+MokFVnkYd4xW9V05dVK5UzoVMWs7WJ1M6FqJ8+vsZSTagB9cXcgLDyaPaaQK811y4dFaoN+4VhPXphJMnOn2u0SdljuG1bWhgSGbSfe7CrT5mHaikRjaw7K5tS+ESWJFn6sFhsw4xd/NUHN3GqWhrDD2hulNfdjBdNsgQFCj7xPq9dXES/BsoVge8w0d/BvjUom4mSXz3zxLznnucjBocD97NzJGJi5M4R7ze0vbRAm5ws2BjoJFg688Wc8R1ZWiRIqmZGQYgY05Ph4Vq3dnWCYL6yugYtMuxr35M8OOwhBJhn684dQT/Uxlzuzhepwz6gDuAmDHHDgfo2mtw37pGc5Epora3XwElT/d+PyIHIQO8uzESP1rR9gpdstwE+bRbnSSl1/VmCFXWfnATCmOQc3XWvx82dGMXYxVcPCYy3zqvgKpapXA4mPHZUpJNPk0hnKJvj8FSWdHA7CUF05tpCjA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(136003)(39860400002)(366004)(346002)(44832011)(6486002)(6666004)(5660300002)(36756003)(52116002)(38350700002)(4326008)(38100700002)(2616005)(86362001)(956004)(66556008)(66476007)(7416002)(6512007)(316002)(66946007)(26005)(110136005)(2906002)(54906003)(6506007)(1076003)(8676002)(8936002)(83380400001)(478600001)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7WfHZGO3RG3EDV19BK3LbmLS6bWZtEkWLYJKGvOetF3slcx7fKVDZLsjGJTb?=
 =?us-ascii?Q?Qvmmn0QFBEd5M37MdOx18ygyYFdYV3XipaW7hjTTW9lYT6HeMQWGsDPyVFIw?=
 =?us-ascii?Q?JcE2O+B9SeQWEwXqPQNzgHgJMlLABJfugOG/W2cN+5CO32OskqmBO6HlefYG?=
 =?us-ascii?Q?RSGE8OjMHJr5VGVsqI7chkvFjx+Ln+6qNUqeTQW2H6l8MqYiW051b6MrxO6q?=
 =?us-ascii?Q?8aHFRJoVfgT91XhaJgBdssH0Tc636s7c28iKChQhjSXAziPTyNYAVqc+KjYP?=
 =?us-ascii?Q?TXuYa7/0xHk8gcCf5ny6iMpWZkigjIRs9Et7ZE+xDndRMZbp5obtucLcSgnr?=
 =?us-ascii?Q?b3SulVXjJGhtskIoXPhSSdkLiPWCWWugbCoom8O2vkdp9gSAPPbOkbtXdr8+?=
 =?us-ascii?Q?44jJw+n+wAL17O3W4DzBWj6RSozSKprYOb710i1r5tLcxSRVW1wUX4HvyNqe?=
 =?us-ascii?Q?gzqgeWyIy24nklHMix+I9WgGpEsG23wN0jHjNick+XizABjtSw+pihfVcbRq?=
 =?us-ascii?Q?cxawfzVY/B9Zsy49Z+Ck4SYkrVGgxFXUvOSJ68yUkMcYgpW6Ahv5oF1Yq0C/?=
 =?us-ascii?Q?9bRGAkOOF+X8yLk/f4eLgaATsq2XCZR8GgW09IVtjLDsvDbug7Po1FKaltcj?=
 =?us-ascii?Q?fe4i+SWLUzrGitFnI/mU9xDqdaIYmbFzxJUBPirBKOxwz3ciU0NM3QRtbwjy?=
 =?us-ascii?Q?BEh8PcRzau+Ohkj+M4+nQeyRvcKDP3yinpP/y8E1EJ8nKv9y8DUgwm5Fo4DN?=
 =?us-ascii?Q?qF9GKSjoeJ2+SnCU/lCXqyAEOASU9NpuS/30ZVEBNZ78oNL79FikpRMH+OTx?=
 =?us-ascii?Q?aeRfH7M9dUh+2i54VRGjfP+R/7OHQy2GhH6juxKNw8iKK6V5N/Iim78y3XEc?=
 =?us-ascii?Q?o0s2rJxtx0qTzHcyxRvB5z8vqsM2fIfWIOhqBUS8xiR/G6QIjuzVKhL51mh0?=
 =?us-ascii?Q?yw9l+vkfxWKmkW1ToceMcQdAg3IYwhGMI0HkszQUTWQZP4zAZunEzVw4WZdi?=
 =?us-ascii?Q?3VWr1bRV7eLMwpuUCPlKZmtz4SMQxFQcu9Tl9wb4zfTEmLWRSWdh4MKD5pbo?=
 =?us-ascii?Q?0DE3qZNCTXKPHAELuBkHjKTJawCid5f9NzONhY9LlR5X1sTxFBPmjF5rqejM?=
 =?us-ascii?Q?0YZeodLdSocfHUX2jYdHdBQeuS7c+onhfacu1LLlvsKjo1sf1FId/5oxvw8p?=
 =?us-ascii?Q?w1PgtxPdmmFxkk2Lv4YH67kVp1RpeX9AXFebaV/Vrqnbg+yEG9Jjr0PwM3DH?=
 =?us-ascii?Q?JYC//4IzkWzlKgENDxm5APNLIhVxeB0P5XDqG29vJptQkYEuORBZdR+eK9E3?=
 =?us-ascii?Q?P+oTW6TJ7DuQj4zZIL0WwnQd?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b490516-6b18-46da-9c9c-08d95b2ce5d1
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2021 11:57:44.3793
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cWlwLE5kwXBamryMVSjRBdQWf6WoPuCb8CIJWr9qNtoU5yxG5LZYRI6biMIlM2Ij18oF08ZF5aFcJfeN7FuZ7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3712
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The goal of this series is to minimize the use of memmove and skb->data
in the DSA tagging protocol drivers. Unfiltered access to this level of
information is not very friendly to drive-by contributors, and sometimes
is also not the easiest to review.

For starters, I have converted the most common form of DSA tagging
protocols: the DSA headers which are placed where the EtherType is.

The helper functions introduced by this series are:
- dsa_alloc_etype_header
- dsa_strip_etype_header
- dsa_etype_header_pos_rx
- dsa_etype_header_pos_tx

Vladimir Oltean (4):
  net: dsa: create a helper that strips EtherType DSA headers on RX
  net: dsa: create a helper which allocates space for EtherType DSA
    headers
  net: dsa: create a helper for locating EtherType DSA headers on RX
  net: dsa: create a helper for locating EtherType DSA headers on TX

 net/dsa/dsa_priv.h    | 78 +++++++++++++++++++++++++++++++++++++++++++
 net/dsa/tag_brcm.c    | 16 +++------
 net/dsa/tag_dsa.c     | 20 +++++------
 net/dsa/tag_lan9303.c | 18 ++++------
 net/dsa/tag_mtk.c     | 14 +++-----
 net/dsa/tag_qca.c     | 13 +++-----
 net/dsa/tag_rtl4_a.c  | 16 +++------
 net/dsa/tag_sja1105.c | 25 +++++---------
 8 files changed, 119 insertions(+), 81 deletions(-)

-- 
2.25.1

