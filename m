Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B90A768ECA2
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 11:17:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231390AbjBHKRp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 05:17:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231392AbjBHKRW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 05:17:22 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2125.outbound.protection.outlook.com [40.107.244.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FCD847086
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 02:17:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CDbC0A3wwZiGACT5rZ4zhTG++13+lypv99iGwpezDwpFIARfOLjgVpk3RXl8NBK4O7BNcG5XrubctfauvBxN0PgVaA9lkOOiY9/ZMWD8YJvvR9qWRcuFoTKOqkeXUyO1ap4uguHSMh1safJNREEaU76RwjzkZQHN4//XK7VLWEHyRbZy++JqbXctErO98qAIY6rL6ABzIGJgS7/6yXS7NnNpr+vSKiu8VnwpPqQTPH9ic7NDuHuqsmEQG0qfC4cCE6RtXWm9zNIFg9lnJvg43lcskeWvPvPQpDJvsNWf3nBy8g60hT19WRfCO/G0SItaYixcvwO9RI+PC73qp3AlGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q6xL10GXAsgahDarVu/oS/WMre36Bjyvcu1EtZEfk7k=;
 b=bCNyXgbyLKuFvPI3CWML7zjRlfBbSmHiRLJhYu2r/hTni2xLkw/LuNHaEe0OVBSY2gKzooMJ08G+O5DfibzKJKE8lNwXQFUAFANJy9YoCXDCQe3CNvM0hBdsRhHRIQv8162DFoa3Q6gHmppiQrtKgFkvsxf2R/+GGjQoCCw72gsFz/hemybG/nhGyC9ifRK6N2lu+qPH8aBnNFGp3Va7oSTk0AeA4hOOwMMLXNFimCTiO/1OwUwDl//kcxw4GhjQXCOzG/FeE9WZi3uu738Uy3UNJqc4PsFfe4Ng8mvdpc0HQB3UviJsaCahKfEi2QlB81bKkWWCNuDWuUC1/7dulg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q6xL10GXAsgahDarVu/oS/WMre36Bjyvcu1EtZEfk7k=;
 b=KiCKQI2GuaFwuV93YchTXYc9bmZE7TUn2tP9g7HgdA5a4VgWiTV3suqxKQHUDowJtP7BHvnlUpszt9Z9gndgcBN9+27BKN4xJo7AQvK+9ky+i/DM4E1bXPkJcmscqYBIxLJ5GrQPzbEJhD8NSMyqJrK8hwYKoFvQ6bDMgdYrxpU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB4066.namprd13.prod.outlook.com (2603:10b6:5:2ab::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Wed, 8 Feb
 2023 10:17:10 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%7]) with mapi id 15.20.6086.017; Wed, 8 Feb 2023
 10:17:10 +0000
Date:   Wed, 8 Feb 2023 11:17:02 +0100
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
Subject: Re: [PATCHv2 net-next 5/5] net: extract nf_ct_handle_fragments to
 nf_conntrack_ovs
Message-ID: <Y+N2ngupTxrBpa+q@corigine.com>
References: <cover.1675810210.git.lucien.xin@gmail.com>
 <309974b4d45064b960003cca8b47dec66a0bb540.1675810210.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <309974b4d45064b960003cca8b47dec66a0bb540.1675810210.git.lucien.xin@gmail.com>
X-ClientProxiedBy: AS4P251CA0004.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d2::6) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB4066:EE_
X-MS-Office365-Filtering-Correlation-Id: c32a50b5-4fe2-4755-1e5d-08db09bda388
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZjL0A1eSMwmUP4vZgff2sviT2vybom2AFDuCKdGeQBvo/uXkwrNXYqCt2lVU2k2h3XxPXC3oRzxnP57q6qbMwN48uWhG9PbgXbJ87waBpnIPCf56mA2SHu+CMgi2ZiWIXcysmMdrlAyqirVf/xFpf9NIXHHThDOWiYniFR3hB+zlWWILYhZXqsbaNhFQWfHwXCILckHJhKo/RB1Dr3NcQgtJcQV0eqTdNu39Bc2wxSwMxilIffLifhDolj2fqxehlwJkOx0y+n1iYLeQ/fBg8I2o9k/VpS8D18fRYrSJmbKTx4dl9/ff3y27pV7sKl00e9V+GV3/BWzYDmSYx7d/9JCvxeRdPKKXaLusgqiOl9ofVn1CfZC/F0TfcbO0jqwxlQ+mY3kPxl+/eh2vNHVd0b7nzTgNV41M8kIdqQR2mdS9kiBqhSzEJM1TL5g6HMtY4DeOWrYRzl1GxYA4PSchn34RMtNKDQTvzTi57yQgE41mpNguw38YUhp3ZLTDb6Q1cmqTnHt58RMQRE5zG6x3GaH5h+zbJLIjTmTqDD3OegecUwG3PKOiSNNKFiBK10GVtT2iwFGYmNWUNYajYJjd6ktL2sfYrbQZXQPK7ftV1y5+fGeTqWMcUAnT3fRYfVRcadlsw8GcXbJw5KVmJxEZSw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(136003)(396003)(376002)(39830400003)(346002)(451199018)(86362001)(2616005)(6506007)(6666004)(6486002)(36756003)(478600001)(4326008)(41300700001)(8936002)(54906003)(316002)(6512007)(186003)(66946007)(8676002)(6916009)(66556008)(66476007)(44832011)(4744005)(7416002)(5660300002)(2906002)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qx9BjrKVLHcdeLkWFMrWGoAvvK8n0r+N9n/EsCiAAOoyMVAHwc89Hw2zPN5E?=
 =?us-ascii?Q?OtELrVE+o66mQg8IsLDNKPPtm4bQuWeP9EzhQFHi3Ni30+L6AhMCmD+GfH5j?=
 =?us-ascii?Q?l5RRZf7Bf1zpjzhQ49O/pFOQzN8HjHbRSQsTxGKiDj5ubHKb8eDzG6vpPX+I?=
 =?us-ascii?Q?P0vuj+XOUbsJi8VwXZgCuThWdwgrnNWTd6CdCJ0pmyj+yrG1Te9F4jcLv6Yo?=
 =?us-ascii?Q?QzLo8PXIbzc8ZcKhLYr7YimiS9OSI6cMerq4Y66+0a3H6LbGsFqqqjCDblfd?=
 =?us-ascii?Q?hNjLJhbekQI0Tf9OR/6d0y5dmLaDTJeKv/tEZapz5ySSLI40DONgjmcslYzR?=
 =?us-ascii?Q?PIoQKLNe8CXaBEY2ugvahWq9SjIPQuLZn+jRYL21oztA0E48KwZi3mx7Bn/z?=
 =?us-ascii?Q?93JylibmPMzso12PB10+GmwxNY+H2f3uFTFr+i073eGWtFXPEk/C0So7I0rB?=
 =?us-ascii?Q?MR+HWyZ0wzC8YoZOCuZ0EoOfXEg5pPd/E5dAt5Wot3+9AkiVzefy6uAPQqXx?=
 =?us-ascii?Q?0XrCfJl0xE4SMZ042sjkVuBAhTX136VXSOrTMuzL7SNgSsr4iFaXB67i50oP?=
 =?us-ascii?Q?Rqm19RphRdsJaqji98e+kTHHO7Lf/GHjySxrsUUKx4jKSPtRtB6s3MBwatdN?=
 =?us-ascii?Q?8xMR+79EZO1WiZKZ/ilD039iVTTisuxsEam7YStySkhz7KIQBBtUYj+D7RFv?=
 =?us-ascii?Q?xG4KY9UiPM8LJLJijvSk0MFMi+a6ByzhlrP3Z506bgxHbQFs3V9czpoXRBT1?=
 =?us-ascii?Q?SZpwyquyvoun+WsXPmCda0YCO0SvIFP6StVJnGFvaJtkdM4rXBf318nEC6tm?=
 =?us-ascii?Q?DV3wX2cFbdesINoKNXQoXNvqZhwRUAs3YvT0vZDw9DG7t5gTsddnqgcAsFrr?=
 =?us-ascii?Q?xiC9xwHP2OlsO+FwxP9B2o1nZ/fi4LqVKTLtz/BGOq1LQTeR5Y6WGcAq135i?=
 =?us-ascii?Q?cktpdKoZMKwK9VkBTNxeeIQcRg/4YtWPR1+ND42UQLJgjaLwEoerxyIH53OX?=
 =?us-ascii?Q?qxfB1lwA07dyP6KPumTb78V8ACQyC8fuuuHD89YHXZk9A0n3PUAMassiMqGf?=
 =?us-ascii?Q?gm9JM+nj7gxAX3LbRHm2aJMRqsEo7unXUj71CXlclzC11WneDFPPpnFYkJg6?=
 =?us-ascii?Q?gUZSoX8BXDeJmLymgfPVzSwvCvV8m0IIYhwfM5Re3mW/fauL/ZyKIitlJxEx?=
 =?us-ascii?Q?v/yOwuiRuYvX1q09xC+hCbh915nfEC4ev2/8eV6k+XbdMvkvWqX5n7OOQVR4?=
 =?us-ascii?Q?G9DHIjMIsq5OxxK6F1BJEVvStjIhEtAGgoJ3tyyEbDcgJ77h2nIV9bfC4Dl3?=
 =?us-ascii?Q?/QOFlck0a2WdboYZFtvmYA0NZAh3HA/akCSSqYbB2NrSPRFqCp19bI7yIvJV?=
 =?us-ascii?Q?1OOzkiFLvU4hoqMuAk5QOegQRurbYmk1lrRtcY6QxcVq9ARJbA4rfZNZSSxd?=
 =?us-ascii?Q?H456yzqrslr22HtGygnD1zdfLI39kNy5DvyRicEwuYlpuj+dJ4rkUz7/TBD1?=
 =?us-ascii?Q?ixcFY/DVH1/Ob9K0xWVEPFYihUbOEA++vMZOjEatwAWWe1AVK3kO723dfxUU?=
 =?us-ascii?Q?tDO3TnH3LvLeMtgooLp/3XMrvDJ+C1x7Vk+yNyepsotZ+7PvGb9h7w3B6vkq?=
 =?us-ascii?Q?SQ+Xs1Wvs0mgHuzfpEvhRfxdgsr2Pk53ypGQggkIye1fX8Eot2b1q5uuAqqd?=
 =?us-ascii?Q?f8m6Ew=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c32a50b5-4fe2-4755-1e5d-08db09bda388
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2023 10:17:10.2135
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tUscnI208woyC9ZepnLalVyqdgzDZx+gSVTVQNr8mmhwG+OCX2TL7NqqOCr05k+IXqxFW56oP2lmwbYEGncWYhesSfmONci2wKd7s0PWM9k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB4066
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 07, 2023 at 05:52:10PM -0500, Xin Long wrote:
> Now handle_fragments() in OVS and TC have the similar code, and
> this patch removes the duplicate code by moving the function
> to nf_conntrack_ovs.
> 
> Note that skb_clear_hash(skb) or skb->ignore_df = 1 should be
> done only when defrag returns 0, as it does in other places
> in kernel.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

