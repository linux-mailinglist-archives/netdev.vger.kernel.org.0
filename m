Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EC2568EC9F
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 11:17:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231149AbjBHKRW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 05:17:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231345AbjBHKQ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 05:16:57 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2104.outbound.protection.outlook.com [40.107.92.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 599B611E82
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 02:16:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OocA0rof17oKNC74tLAItFrPwuh6p7HEySm1meqqpqFcm4oQfT+MFrYcHcWj7IGmLpt28ICqy7QfUzPGW8qitghUiNyA1XaGZ/r1XTUzAlUp4dHxrCN019deJj4glWBsRvNDdPY4uYjS6ASsoLeN+ZVa0RpRigVlS+oxlTZJnNoHy+rpMic9WS8o+xnQDydNKJBajfv+ggNzsXp7y6IC3cC5K0yrlWh7/FC2z91ILFTaKMf8L36sepogetwTTN53A2ZhRdPXRXeQZpN8hkL4tOR6KUKu0hAcOJKr/DUAQ6i72DdITn+LFjTWEVoMfubqVe1XFUjfc9psiSq7M+yQfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iTHg/mXbPyHqR3tlY35BjEgrMJtdB0kspV6lFVJ5sj4=;
 b=aoHf1sv9hZi0/nnlWLt38JRX2JAutjV9JDkKnu6fOgM6YW43rMx8+iqv5BdbYbiWnKPsXsbkUIb2PXm/Sn2CGEuY1rjWIlsBhe7qWhSuCM+DCPRMwatI2ma1qw9u9qSAPczQ0smlwovR81htRY6jn3kBr0IvGSpor99YoCJh1A29sUFOGd+TkbWC0oGmD1NPFdAet3WCgouMyCvDT4AZsSKklRw6W/NGAtVHrSd0qgb5YKbDzLZZF+pgtUSywdjzDTghFtmsuIqSYu+MBN6VunxBOIvYqMQio1L6lzIfsJDjF7QTHtQKuSPjXupwABgvFLfYIZauqjOkPczqolLXvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iTHg/mXbPyHqR3tlY35BjEgrMJtdB0kspV6lFVJ5sj4=;
 b=phOuT6TlW35qLDQopxLR/kdpFFr2UJymCctnw78JSYrNH72OwwZ2yNuMg6xljmRN4lvd5UFMS+vBfqJVHNmKRfyxrysxjhfGcqXcf3LVXl4m0rpBzoIujo2WZRHLPJiqoFb2fTtwFDvd3WhOpB/ku0VGfFrgxgZ3sW1cvA7QuXA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BL3PR13MB5148.namprd13.prod.outlook.com (2603:10b6:208:33b::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Wed, 8 Feb
 2023 10:16:49 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%7]) with mapi id 15.20.6086.017; Wed, 8 Feb 2023
 10:16:49 +0000
Date:   Wed, 8 Feb 2023 11:16:42 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, dev@openvswitch.org,
        davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Aaron Conole <aconole@redhat.com>
Subject: Re: [PATCHv2 net-next 4/5] net: sched: move frag check and tc_skb_cb
 update out of handle_fragments
Message-ID: <Y+N2ij0mKN4lcSTI@corigine.com>
References: <cover.1675810210.git.lucien.xin@gmail.com>
 <a73fd95cb3873dd8f94da53487428b44cb2534a2.1675810210.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a73fd95cb3873dd8f94da53487428b44cb2534a2.1675810210.git.lucien.xin@gmail.com>
X-ClientProxiedBy: AM8P189CA0015.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:218::20) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BL3PR13MB5148:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c63fdf6-b919-4448-c2f4-08db09bd972b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: niXRCi/C03rcv7HQnmKCLPJweYH4UOIWVyx17st5+wI5r/Ok89NcwUcWKWYSsTrbDa5zX04uhS2H84s1um96hFJ/BIWt5ekzIytqlBOgjT0SyX4tPPysCiWI9rWXXCNTZ61Hfb+/Fhgtmy3aWxnralefH8uu8hkIfSzc9ZUyOtrexbmIwCEOj89NirzwDUZg/p40wo1E7SrdfPs1Y/U4u5Gse8wKEyDdfg8ZdU5+HewuqSoVrCi6miGAVe5eKVqHSeoQXjqaygWRQfkChyoJThLQ8mFscgTb7MZMXgXy7EAS3hIr28BWyQKcZ3Fx7PE09c30/2PQ1kEcsbBDIMynoMX2GWoK6rM8ANZt//S+Lmk27Us6LBuBUWSmSKHn/I+P9k0+sHNeuv2MAtXI/t2Wck73gWIteKIfXrQDqlr/CAYDV5pW852jZicWIH0sNsc1dpvO+nwTku/eReDNXNLzAeA/lxynGNKwMFKZd8buDmOwFTlcU9wr4YP3ilasGNRz22V/n1UYp9iu62I975bNX0pyDgn/bmmyeLFDywad2n1r1diB/FI64jZV9mUIxCOUUc1qUv/61itELCnkrtAznpdRgqPvqPQHkS/lxBVR8VxUIoHMah9br5E9bvVX95hvPvu+fWDleruWKRemtyyLAm8TGul8gZ4jzoZDXe8ZyuzmdHyzP11LwiXKWVuQBO0s
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(376002)(346002)(39840400004)(366004)(451199018)(66556008)(66476007)(6916009)(6486002)(15650500001)(66946007)(41300700001)(316002)(478600001)(54906003)(83380400001)(38100700002)(4744005)(44832011)(8676002)(186003)(2906002)(6512007)(86362001)(2616005)(8936002)(6666004)(5660300002)(6506007)(7416002)(36756003)(4326008)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1WLGO39iyetj22avewMUjvNvB2GowfrrF/Xnvrp14yiRuaKw+TAosBwa++4+?=
 =?us-ascii?Q?aFR5ENf6bPgCNg0SizVGHDP+q66wQZBlrYD3ovHCFw9Goev9Z/egytDmpS9i?=
 =?us-ascii?Q?6bU1Vm0KDiUIMSEa9V3Gs2Svs9WZ6bn1LrpOMPkcYxSV7bWZwP1MxHZZmrPX?=
 =?us-ascii?Q?mGjqvH3akKjmBsB9+/+O9gO4RCEqokMTWmaB6u/PeChiVkReDCe/GaEjvdEV?=
 =?us-ascii?Q?Vh3TeFJ3sOZP2ZOQuQnKtiOKrp81mtjtHRVRIF6q0NcNdlEDZf1tqem6EHvE?=
 =?us-ascii?Q?kVVTWzk4jvvstRIkoUZOSVWsCGMCkjHqJ4MXQ1z8QFFcTKuSwOjipDBCv1/1?=
 =?us-ascii?Q?7r/ap93UO3mjq5hp8gX8Xw1T0TkptR1i/hP2YroB8DxQZg3SApqsut0KKvEV?=
 =?us-ascii?Q?mQPqO1t42UDGmdRwxtYdXL05StsX6Vaq10vetmUve47FgT/D8hjR9aIY1AlQ?=
 =?us-ascii?Q?zVgIBXJKsQNuZWEhJh/ZLJtKqbOx7I/TpYjE4ZMJ5HlgKjEKsZRkE754Sr8W?=
 =?us-ascii?Q?90LtReOypV6D8yK5Fbjs4OkyXyn6OEAmPCHCpI++4H1Q+zVPGZSFgF8Fi4sv?=
 =?us-ascii?Q?xpOFU2IVhP2k9CvGX1C7yL7UXV29hANzmXYHio6cWyl7tQN1bQMIuMfLOqZd?=
 =?us-ascii?Q?XyHSEyt6xbnmRZSrXl3Ahu+qHx1qcsGa1NStidgBtQEkZVhe6zqBHS+bR7gx?=
 =?us-ascii?Q?UH+2eEZWj35/lj+gRxgSoYVbUW8yol9HCPjha713iwcWp9mImGAtGJEm9ZG5?=
 =?us-ascii?Q?xIWw1+a3PahcyX1OuHT2XE/uS9OumW3N6dqMZRE7o7hdLNrYt4xr1hnz0PlT?=
 =?us-ascii?Q?j+9QthKju0l5R8r/wiG7L9S0LSZKt2LBgkZZhjtDgykKJHMjsWm+4h+gcsLY?=
 =?us-ascii?Q?6S3mhqVVY6z4rJ6n+tPjYbNALNMQF31kRke99Pi0smhsldJmHnnoaAUlO+Sd?=
 =?us-ascii?Q?agI7ELDJULj7wR/++mBTQrOyv+pjCmJ9upr73TV0OD/61O3PKlhzG26Umprz?=
 =?us-ascii?Q?229aTWfSOSe0bM+V2/DW6TJfXbgjyfp/6rrIpt7wQPD7HU/QdZFG8+fperx6?=
 =?us-ascii?Q?VxvsvKtppsrf4L1Hdv7Kaqifpr6XipuLbXoXLbjgsTE+pbzSt7YLK3WfGS7t?=
 =?us-ascii?Q?rnJjdV4YFniGUteNBtleNnBtURiJsiiFFcYsO/kqTlxbIMPa0oDmOB/AXVNh?=
 =?us-ascii?Q?q49vUlsPsdkzAe1NGwwx2/y2bRMGEfWeJA8TLcfK93eEN0Rsx9n9Ud9FKMqh?=
 =?us-ascii?Q?HqLhm9bRH77tWkdNDh2WHNSd5t64R/KnzD78Q9i66oLXFsKzMVcUNdLKeT14?=
 =?us-ascii?Q?gNjFzjVfhYMN45qrf1JFygjYhJmBCMa+U+5KB4aQ7VxtBSKUcrYR88i97YuV?=
 =?us-ascii?Q?FXe0ivplkEm2QacGQJ4NHJgdlDJt2KcyxpiYEsnGB90oUEdlz9GmNqc7Lhdj?=
 =?us-ascii?Q?zbbE8glm7/xOj5FanHYbu/9sV70BJrIfKlw3EmksSWOfheiRYmu48pKuxZu8?=
 =?us-ascii?Q?xzH3RgP7T5DUN8Y0Mgp1ATwY0nqIJhH9r/mP9y275gnA1IG1Xdi+XTbKtZqc?=
 =?us-ascii?Q?uOaE/nIsG4mSyjxhTFVLvh1f8l9+Nu2BezaQDPFsETcb4H+3WULNi5g0wlBq?=
 =?us-ascii?Q?F6YaAgNN1bBOwgxUFS+kz2mwFkql23HNkQ7azzbwg2FuopGVdWlDSGftEl1R?=
 =?us-ascii?Q?eIrbYw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c63fdf6-b919-4448-c2f4-08db09bd972b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2023 10:16:49.4784
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YMVYA1iqO/1tLsCjD+6yCT7H32zR3zM9H6n24cyOg6fGdKt/8xWhr/QSTXciyngTMDoB9tXNcq859hHNsm3ZoXqklrCwmuoiHzNvbO2VSwQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR13MB5148
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 07, 2023 at 05:52:09PM -0500, Xin Long wrote:
> This patch has no functional changes and just moves frag check and
> tc_skb_cb update out of handle_fragments, to make it easier to move
> the duplicate code from handle_fragments() into nf_conntrack_ovs later.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

