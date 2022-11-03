Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60E19618C13
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 23:54:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbiKCWyv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 18:54:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbiKCWyt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 18:54:49 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2077.outbound.protection.outlook.com [40.107.223.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F1DB65DD
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 15:54:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k+POvzpzcTCZVC2bylsuV2s8BMVzfTZP0kpSmeAxTGr8+CoPS0q81p00wIecS3v0fNJgxoEclzgct+sKegrXnGSUMgOMC3YZnAIgaUxgVe5PkbEwHwKxf+oklJPouhCWlnh0po7fjaqA0YgwRQxjbscdZx2XQ2mC04Zp2ch9UnL26jPWm4EdQu/cnQnIKrchrXG017zZQZyBXb1ZK/ztEzoOjdadvxQfkaCPWnQrT/4hjstlWvXdC+AGuzBz96CAcJldb2SjNGyaF/CrUTX9VLM5jo4JqeV1i16gP7cHwETbR/cVHWL07Z9Xja9zszR5VHDiO8YBo+ceFNqtAVJwRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Sd6lTwrU7OS5ue6Z4VN6v8iDwezzkp/KTuN1mVW5z+c=;
 b=Ponhpe8B9pHhQv7+ClSQ5bhmrmTQz3eEHKjNgT5XntK8AztsfEhVoP22dKLhMInWkyKMVcgTek/TbK93G/xv9Ac6yTeVtFOkkl0q7Ty7UVSUH2fmXXtCY2ZbQqg7pTCSU2lve9ARbVc2ejMHiCHKqh//8Y4DCXeo1Tqx3M0lOqx1omJgdHuJ/qhRBbDyjcv5zcbv75+WtJiFar2dywR0A/ScmEZBn6an9L4I+mbAF3PEvrYmtSc3o5HLr3gvmrDH0AawaJCh/syxmjghE7jU4xnt1r/uCOxk+Pj4pxq1dBqgM1/KC6MdbMFjEIjWT+A0jZH3MM2JJzb9+DNFvcBw/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sd6lTwrU7OS5ue6Z4VN6v8iDwezzkp/KTuN1mVW5z+c=;
 b=Dv1aWTVdZdbHuVcSueZ8Z+GUKQu6klKMD06+/EW0enFlWzMW51xnALIRxS+0b6hWIMGDIch/YNfunjSbKBLcm3eAfofxDMVfg+2Bv0urFRNfYHxSIl6E7FCuFPZgLPnooedQ5Nibd3YvYkHfkrUVV4t8PIZACH6/v3z5GAiZQdxfBK0ySaacio1Jzf9OcwlsLWDDhzb5zSoY4UGbZZbxJ18UXL72EiqMYIOHpkBOkJaZhTN96j74cSzXg9j7eh4yLWZADOLolVaxaGdsaOBx7zezDXTvy3p6+uev/BUgtuL7eKdJLUWe+eGakRkKDd6EePy6vgRluMi41y5uSMXc8A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by SJ0PR12MB6685.namprd12.prod.outlook.com (2603:10b6:a03:478::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.19; Thu, 3 Nov
 2022 22:54:46 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::3409:6c36:1a7f:846e]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::3409:6c36:1a7f:846e%4]) with mapi id 15.20.5791.020; Thu, 3 Nov 2022
 22:54:46 +0000
Date:   Fri, 4 Nov 2022 00:54:39 +0200
From:   Ido Schimmel <idosch@nvidia.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "jiri@nvidia.com" <jiri@nvidia.com>,
        "petrm@nvidia.com" <petrm@nvidia.com>,
        "ivecera@redhat.com" <ivecera@redhat.com>,
        "roopa@nvidia.com" <roopa@nvidia.com>,
        "razor@blackwall.org" <razor@blackwall.org>,
        "netdev@kapio-technology.com" <netdev@kapio-technology.com>,
        "mlxsw@nvidia.com" <mlxsw@nvidia.com>
Subject: Re: [RFC PATCH net-next 10/16] mlxsw: spectrum_switchdev: Add
 support for locked FDB notifications
Message-ID: <Y2RGr9ssyMXbNsC+@shredder>
References: <20221025100024.1287157-1-idosch@nvidia.com>
 <20221025100024.1287157-1-idosch@nvidia.com>
 <20221025100024.1287157-11-idosch@nvidia.com>
 <20221025100024.1287157-11-idosch@nvidia.com>
 <20221027233939.x5jtqwiic2kmwonk@skbuf>
 <Y140a2DqcCaT/5uL@shredder>
 <20221031083210.fxitourrquc4bo6p@skbuf>
 <20221103223151.cnmlvgnz3maj75iv@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221103223151.cnmlvgnz3maj75iv@skbuf>
X-ClientProxiedBy: VI1PR04CA0106.eurprd04.prod.outlook.com
 (2603:10a6:803:64::41) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|SJ0PR12MB6685:EE_
X-MS-Office365-Filtering-Correlation-Id: db5ab661-e85f-4471-6654-08dabdee676c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MyqHZqxe84FPQindQFfrDIJzlj/cPXAApH321eLho20hLVpWKB+70jv1J0YnSFTay0QpnzlbMRnsj0PRba8/FNMDaDNbZ0EdqTkCLQrdnW0TW+0d9VH41DZ0j6VkkzcAQS87VA0dTcT4fT2VDbuiJeQ4ELHw4wxFORu5j91xtBEtspBRSMvtwC1DqATxPHBtClwnDbnMghEjluZgMjpiUpeh9HiePi8FZZ89kYmOJfByQXpYIGykK59ewNt7NGVlcOlRRSjrtCjR4jeB+jFeF5liQqIjYkCLltg4JP5t0XzHgFspHbt0rZXJwh1rUlEWXDLamKyrnhO2Z2FTDrkqLBgsISGByBkDeAh41HjOMhb5QHtzSAHqQuMsYWbL9u7Q0AlLI6V5KddPKtuFtJf18juurkDvaKS9MVR4lTHQXu0wOCtjjIHZaaJdT1/JhaaToVhoDqH48r5QwfvGkC8Fyr52+SEBLpA/qv5B5mVy7OcUZrHTyVNKuCfA85RYn6pnLTCPwBqDXCtsop4PEcAuFJR5rNSL0awwphsHhUaX2o9G8RwLKAWHiCosFjtOch7i8OkQehj3zGiEZ7/metAMWKaNHRC1r++YdDlzA13E1axlQzYwhOHj2G1YXF7bVAj2/ykfAkNf1mC4rRunquqRkkzehRshf3k0ls7HCj0pl0EvvsarCnuB9tiuBEl/QTOH1iepZ1jknJvikP34ry1KFg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(39860400002)(366004)(396003)(376002)(136003)(346002)(451199015)(41300700001)(6486002)(66556008)(8936002)(66946007)(66476007)(478600001)(4326008)(5660300002)(6916009)(316002)(54906003)(83380400001)(8676002)(7416002)(107886003)(38100700002)(86362001)(9686003)(6666004)(26005)(6506007)(186003)(33716001)(6512007)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Tf9hGqHX335hpFV83/uq/+Ul/8mfRnHFlHqmyQcj1i2EqCwj2laQQodF5Haz?=
 =?us-ascii?Q?xIezZ46uXi0MZ5WcDg7efVqNVnjCiKritrYtmUFl3YZQf7sSZClyt/4uO0e3?=
 =?us-ascii?Q?47LyC8Q9yAQQACZ/4DKS2DpAGyR/fz7rw2/mOM9Y+ruvg4BPcR+wln4bw+cc?=
 =?us-ascii?Q?rPmzfMx8oBRSV+8FbeWsg+iNZ3fB48du8mipfCNOExvWytjSWw4w59NjcPgw?=
 =?us-ascii?Q?O2h3eOcZmGsB68NPGz5jmCG3Mize8GlC3umUKGsQKviCx07zkmY4F7rkAs0s?=
 =?us-ascii?Q?iJfHDRt3u7IVNhLTOJaSdGQbKSqIQDA9+MuSI6zjTmPJkafBl8sNoKaedS3o?=
 =?us-ascii?Q?Yufh6IcnyvzwsEQAvFQia9y+HBNIifVbDI8f+/kAke8Yw+YpGJdZL4QKhRg1?=
 =?us-ascii?Q?EkkFW7tb1ojJwGg0WTcE47jTHpUvU2+Z2FnnwHmh4yLLrQhIgC6ncBj4V1Xg?=
 =?us-ascii?Q?cD6+O3vYgVBuMCXs7cwRojG+ptcAXnITG3U3c8cySpR4GVSNsYNWMhi1aYFa?=
 =?us-ascii?Q?tT1tEl/C/6XAlQxgwz6qHBIElkTIPTLt1ZYsVGYKWou1fp3T84SUSRQQF81K?=
 =?us-ascii?Q?0Az7xVOD4dwmMmDbgWVIhkQ0AO5ya4YAXoqWvj+PLmA1Fpv0SrvBbGwml9L/?=
 =?us-ascii?Q?JmQvUskG1c7tqjHfAeCPqSg06/P0qrWh5+WpbYMmrK9JxvkWTx8l3+v9h3WB?=
 =?us-ascii?Q?Vkno15RkbYI9dj5tluAgQeF/IpQeFbnzh1eonP6XSxBaYTn6j0q10eglq1rI?=
 =?us-ascii?Q?5AHfd3RFFkiFXJ2/iyr8S+ZtRPZxh7axaOm6Agm00bGG9gtOBBJporL37WC0?=
 =?us-ascii?Q?MUPEs9qjSDbNKOSFTUIiwV11kteYC8+eLMJuSVDpYrJrbDtG+9viMTa/krzA?=
 =?us-ascii?Q?tjbsNc1GVUfVJDJ0nUrcHsw8Ugknjtu0L69QKvkUK7MHkNn0OzPK2eCU4SMM?=
 =?us-ascii?Q?nytlHqfKXG75ftUWpl/UXjl9kvJeuds12D+RCSXMLHWIWYlkD7JplKFOzgSR?=
 =?us-ascii?Q?6C68uKZoapOU1k2smTpomizp1hn4cwYDPbWG6sc3w1DOi4kbGcbEdIbtpp2y?=
 =?us-ascii?Q?4id02BGLKAB+rL36oedrkMlr+b7OVDrFFPXlvzDVWH1sAPj4RmP7s4l5qhkr?=
 =?us-ascii?Q?9Ex9gJKXAJHq8nStlVMMSeOBqhN3ZhxxlzJXS9/Op7Jwr/OzUrMvPwxNikyH?=
 =?us-ascii?Q?H1q4uTZ5DJo4yZhdbuO6Zow8Iv8Kz9rviVMrhwA9jjdzm1DyHu/w2jWOwFos?=
 =?us-ascii?Q?2X5JVw6uIS4szbVtPFMkPYkEvg4oXNKuR/liMg0OHIkDx93yHekLsobsSAkm?=
 =?us-ascii?Q?2xQ3NTPUJIkGVvgResJcMVGf9g7C+4phZATnwpQyGzBuMzANkJLZmqf/Opmd?=
 =?us-ascii?Q?jjgAmAzny0EzjsXDYctJfh8xxRLCkW+VENmMnA3XGrO1mGHjAhsPgDGEdglp?=
 =?us-ascii?Q?tEPvrpJHjR717SJHKNhG3SXIQs71NQYWBj71xxzwYSmtriLpCo6f3AEuJL9a?=
 =?us-ascii?Q?c+3ASBNo6l98NZb+nVn9bqXPMk56OQME8R6oFJoT2F2x43xfDJ9d+E0pkUcx?=
 =?us-ascii?Q?AeMsHcOZMOGF9cZWGNRQ1wvsqPOW+72FfojYDY7B?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db5ab661-e85f-4471-6654-08dabdee676c
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2022 22:54:46.4650
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ocWXg/fOPoxVWpJI/LnIZHOv/BYvjx53aBsKy8Gk1JqcNGtRdd5K4FXybXqaKIb6GRPFUC6D0YfR6iGIzx7Pkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6685
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 03, 2022 at 10:31:52PM +0000, Vladimir Oltean wrote:
> Hi Ido,
> 
> On Mon, Oct 31, 2022 at 10:32:10AM +0200, Vladimir Oltean wrote:
> > On Sun, Oct 30, 2022 at 10:23:07AM +0200, Ido Schimmel wrote:
> > > Right. I'm quite reluctant to add the MAB flag to
> > > BR_PORT_FLAGS_HW_OFFLOAD as part of this patchset for the simple reason
> > > that it is not really needed. I'm not worried about someone adding it
> > > later when it is actually needed. We will probably catch the omission
> > > during code review. Worst case, we have a selftest that will break,
> > > notifying us that a bug fix is needed.
> > 
> > For drivers which don't emit SWITCHDEV_FDB_ADD_TO_BRIDGE but do offload
> > BR_PORT_LOCKED (like mv88e6xxx), things will not work correctly on day 1
> > of BR_PORT_MAB because they are not told MAB is enabled, so they have no
> > way of rejecting it until things work properly with the offload in place.
> > 
> > It's the same reason for which we have BR_HAIRPIN_MODE | BR_ISOLATED |
> > BR_MULTICAST_TO_UNICAST in BR_PORT_FLAGS_HW_OFFLOAD, even if nobody acts
> > upon them.
> 
> Do you have any comment on this?

Sorry, forgot to reply... I added a patch (see below) to the offload
set. If the bridge patches are accepted and we have disagreements on the
offload part I can always split out this patch and send it separately so
that mv88e6xxx rejects MAB in 6.2.

commit ebdd7363f8c1802af63c35f74d6922b727617a7d
Author: Ido Schimmel <idosch@nvidia.com>
Date:   Mon Oct 31 19:36:36 2022 +0200

    bridge: switchdev: Reflect MAB bridge port flag to device drivers
    
    Reflect the 'BR_PORT_MAB' flag to device drivers so that:
    
    * Drivers that support MAB could act upon the flag being toggled.
    * Drivers that do not support MAB will prevent MAB from being enabled.
    
    Signed-off-by: Ido Schimmel <idosch@nvidia.com>

Notes:
    v1:
    * New patch.

diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index 8a0abe35137d..7eb6fd5bb917 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -71,7 +71,7 @@ bool nbp_switchdev_allowed_egress(const struct net_bridge_port *p,
 }
 
 /* Flags that can be offloaded to hardware */
-#define BR_PORT_FLAGS_HW_OFFLOAD (BR_LEARNING | BR_FLOOD | \
+#define BR_PORT_FLAGS_HW_OFFLOAD (BR_LEARNING | BR_FLOOD | BR_PORT_MAB | \
                                  BR_MCAST_FLOOD | BR_BCAST_FLOOD | BR_PORT_LOCKED | \
                                  BR_HAIRPIN_MODE | BR_ISOLATED | BR_MULTICAST_TO_UNICAST)
