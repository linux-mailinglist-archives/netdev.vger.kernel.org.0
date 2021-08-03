Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BD323DEDE1
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 14:32:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235666AbhHCMcT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 08:32:19 -0400
Received: from mail-bn1nam07on2115.outbound.protection.outlook.com ([40.107.212.115]:48302
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234524AbhHCMcQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 08:32:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DZaNgu3QsBeAtYMFwrJEi2Gsk+eZx+UqITlQFVAzARnhjtJd/xC3jopg+a8rW16e/fbdWJGFQ75wO0BrOXivTwGKtHLcB3cAITu5bI4fab2vD9IaIdI9YNR8nxTg8Vp1leqzUDPP+ewjC87YoSm4Td1EwQwTZ/1/5q0qjxqdZXgpQm5y2XCQ38TM8iW6CDfb/56xv+n4lbGCEZRM/vr2fu61zTdIRcizmyC1lUkAJqZWIYjMYremXTIjkFaJQ3f7s60acC4DBSutBbcuZRd4FkCqhX+5VRXcDdW3RKBAUCduaGMnJP6/KMLpPABaKTCXZO2ZIMlij87FvvefYDGgfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ol+EigD9sEs7WuEskUrSHzxPjvVvZwqwcmM/CaiYoI8=;
 b=XCdidVTalNlSIYr5kICM3EjiumCXWSJaxKofWvStxpUf6wsMNMLd+rWKaa6yPdcn2BuWmVZCmUk3SAXRLE2RvuYTWh7NFZkOX49vZjYM6CvvbbagKdYXmpPJSq5bDvLexj8DvyZIEH2r++AdyhVGwjyxwH1RR+qhJ4d8Q1t4uyKL1qjS66Y/YuwK+yCWG8Bwe5tjcmpTMBkhRGGqkF7YdX1/LNJ226KD1eqz6gmns6SHWGz/16lJIkowFw2zPlqtOcX3MSxUeof76PmSl9jAsXVBH8t9CECwLtU2ZLrT5Ucq2VlbJQ7PNEgFxyErehCLHMy81Y+q8Dghi0UNcRV4Tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ol+EigD9sEs7WuEskUrSHzxPjvVvZwqwcmM/CaiYoI8=;
 b=P3Fp2UbVznvME/3U3ZPQDK/HwYdwmFEwEnrZgPFLDYsjh6XUpGeUUGXuDPi/TaepD3m7xqPydePma0Z6zbu2U1f3pUY2YhqbGvPXHABhzLlRHRyy7/bWJ1XpA/DaNpEvUpFDAgXjc5hvP1yp9V6WQwl839P/Fm6RfviTSG3Ovks=
Authentication-Results: mojatatu.com; dkim=none (message not signed)
 header.d=none;mojatatu.com; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4890.namprd13.prod.outlook.com (2603:10b6:510:95::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.12; Tue, 3 Aug
 2021 12:32:02 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::cd1:e3ba:77fd:f4f3]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::cd1:e3ba:77fd:f4f3%9]) with mapi id 15.20.4373.023; Tue, 3 Aug 2021
 12:32:02 +0000
Date:   Tue, 3 Aug 2021 14:31:56 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Vlad Buslov <vladbu@nvidia.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>, Roopa Prabhu <roopa@nvidia.com>
Subject: Re: [PATCH net-next 1/3] flow_offload: allow user to offload tc
 action to net device
Message-ID: <20210803123153.GD23765@corigine.com>
References: <95d6873c-256c-0462-60f7-56dbffb8221b@mojatatu.com>
 <ygnh4kcfr9e8.fsf@nvidia.com>
 <20210728074616.GB18065@corigine.com>
 <7004376d-5576-1b9c-21bc-beabd05fa5c9@mojatatu.com>
 <20210728144622.GA5511@corigine.com>
 <2ba4e24f-e34e-f893-d42b-d0fd40794da5@mojatatu.com>
 <20210730132002.GA31790@corigine.com>
 <a91ab46a-4325-bd98-47db-cb93989cf3c4@mojatatu.com>
 <20210803113655.GC23765@corigine.com>
 <2eb7375d-3609-3d94-994a-b16f6940b010@mojatatu.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2eb7375d-3609-3d94-994a-b16f6940b010@mojatatu.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: AM0P190CA0022.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:190::32) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from corigine.com (2001:982:7ed1:403:201:8eff:fe22:8fea) by AM0P190CA0022.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:190::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.19 via Frontend Transport; Tue, 3 Aug 2021 12:31:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 811346e0-7df9-4b86-dffa-08d9567ab1f7
X-MS-TrafficTypeDiagnostic: PH0PR13MB4890:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR13MB4890E691580081F2C4DDBD24E8F09@PH0PR13MB4890.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QmHje9EJnPkYZWSb/gjFGIco5jmjw5z+PG1RSb3aLIBZIY6ZvmcrNMlOmPPL6w+e1S+dx/2u0ZGCmFYJH0lUH6ibCQANaRSpnnwkcGdc9fP5+Ah/xcmCa/eLukQuEP40CfpXmoUudS0WSGVrfAbxuCMX/Phj45QW8WR2jRoQw/dsz3b2bgbBKzUHMBdaI6klZJ4/70heveDW++wWZNdCAfqL0un2RX6MBspmMQRDqgGH6Zjf0n7nZwC6Gsl2POFxoXRraQsqQA0pE3HAEe0zpIV3m4wwMlq4cAtW8YUWhu5+WDB3AiQ90rNysqelZHujdpA3WcrFVk4LOsNji+1Y235q7G3BdIcEEELt//gSBwyOvJJWt5TdSLyoZsI2pAx6D94ZVQv1uhhDA8nK+vUV0eoHMoivINP1ao6gHIKpNsxXRlmu2rwoF9Kagr00N5XXLv4rfp1A5bXgM6wNzVWqSWkyKQXQufF6h8QL09bqk/I+1F/iH9OPnuTpE6Krt26ksOQq0VD92gjsI+8QF1qrIKLXiLQV3hxvwH7ckm6B6evvCR1dg53L+zrcBmSLLanyADIyraEedsThWFUs9a9JDqetH85/wjmpEyu5jse8zuKoWrQxk2Sg/dh8s4W+5a+XvMf8gLoogGg88c+PhwdOTA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39830400003)(396003)(366004)(376002)(136003)(44832011)(6916009)(33656002)(86362001)(36756003)(478600001)(38100700002)(7416002)(8886007)(8936002)(83380400001)(53546011)(66946007)(54906003)(66476007)(66556008)(186003)(4326008)(5660300002)(2616005)(6666004)(8676002)(1076003)(55016002)(52116002)(316002)(2906002)(7696005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PIeP0Axki9DoTzqOQlPcpn31baDxZTigl+hKwZfk5GZj5g+6KivbAxsZu+Iy?=
 =?us-ascii?Q?0Py7NRhlbyKCB247wUuz394Ec1TxUqqTtDJ4RX7urn4pni2l+eZAmU9xNTGK?=
 =?us-ascii?Q?HnwQ0oF8clxJSEvKD9aWT2MbL7LAZl9IavnqRlwq9+mNUvWPZhwoJLaZEtL9?=
 =?us-ascii?Q?hB4OOPMxzc+bwnhbY853mOh27f+YJZYs/5wpriftdHzTukJarHbM+mDXxRxx?=
 =?us-ascii?Q?tTRMbOPncK8+ffbQ8VoQ6qVqxWBEckRuQP6jM1+64xlOcjs8C3BCPI2txT1d?=
 =?us-ascii?Q?gGHwdzso7KH39yzGoviNfLX6OWGftehxKBTfwdqQi33HFxaO5eebopQd3/Ct?=
 =?us-ascii?Q?iT0bIGujKm84JpaG1kpk4T7DMo33sPmabW1wUZ08Zw5iyE/vhgj4rQcSxOmA?=
 =?us-ascii?Q?Sg5FpmP/ewsI6jMqIDww1mTH43B17AV5+58GkDgsTbcihpSqbyuvPKsrrFbX?=
 =?us-ascii?Q?JCvakS2uERoj+67K5jKf96ob+lMumw3LBBNcnRZl3KgDqrxeAigZMmmVyf3u?=
 =?us-ascii?Q?boL1aLdL0ERjeHVQvkey7csKOOr3IgzZ1KocX0MlS7dYoBrRqlzsRjOUGvSL?=
 =?us-ascii?Q?Rla5F+rInT627hltcJ35m13fEnryZj90VO9bSAHCWrv5WSXhInwNd8O0o97x?=
 =?us-ascii?Q?rkUBSc3+tJHNmATlKxpQJd723s1hRzf1k/wppRsvSTZPRB++pyWfGA9sQGT8?=
 =?us-ascii?Q?jVaBqUXPMvqga682OrvzZSTNCb9MaN2PC+rgAWS/qIVdMzY0HzbIZto62779?=
 =?us-ascii?Q?g1vrcrBrFTzSkaleOFWZR5s+pfp0iapaiS0LTgYwnRLdmh1lag5i91Loj2CM?=
 =?us-ascii?Q?ks/GrJJS0tWxZYVTmCMOhKIUB6Pv0L37XQULJCTDkpIsJNujNVtdQAsuhfyT?=
 =?us-ascii?Q?qFi1c4doEoVuFMccLaEEfO6jKoZtQsn6ISSX9SeFkpPga9lnfSMGS8YmUjsI?=
 =?us-ascii?Q?HN+n2y+WU6GciXRhMlaUtlApqyNaYLis7ExS4kwvQMew38F9E8Sm61Otj+GY?=
 =?us-ascii?Q?ST1fG4iXZOlY09jaBoGXx9q2rrpAYMuYguQJDRBCuJOPvCvJ4/oALVNq41E9?=
 =?us-ascii?Q?w2YVWIh8wzDzCiA3yXjzftfotofGtqJSTeJdWWejdpLszBh/NUeCnyPkRMAv?=
 =?us-ascii?Q?pxM0x1/WGkQgSulVVsGj+kcWSr+mqX8HuDiHfnG2FULXP5iE5jxv6cq8Ttyu?=
 =?us-ascii?Q?KQ5H7qg728Smitsi75TD479wfVLrBPK6vqVzjAcKeGngzKT7osfD+hhDm4yO?=
 =?us-ascii?Q?UrnZohJrUfOgY/oarDU5SA91wOg1a6TPVohjDE6KXlMzbOFLw2+dfpY5bvLp?=
 =?us-ascii?Q?WIikwzNa/r+MQiLny2nj753Vg1e8EC3uwp8auxMhsKwshVbjEXfARce9PeST?=
 =?us-ascii?Q?4qMManyNasfCxEa8FASiO7aaObgt?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 811346e0-7df9-4b86-dffa-08d9567ab1f7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2021 12:32:02.4343
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NZtfMtjRFTjCLU+Tu1FfLJ0ttU9aoL9uswL5wn9PYeGwDPKTVZIjjyXSxtMzGrM7NOebvdPKQ/F8SkvwAtG1QPHfiOzS6cZAKv2RCkrynPY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4890
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 03, 2021 at 07:45:13AM -0400, Jamal Hadi Salim wrote:
> On 2021-08-03 7:36 a.m., Simon Horman wrote:
> > On Tue, Aug 03, 2021 at 06:14:08AM -0400, Jamal Hadi Salim wrote:
> > > On 2021-07-30 9:20 a.m., Simon Horman wrote:
> 
> [..]
> 
> > > Example of something you could show was adding a policer,
> > > like so:
> > > 
> > > tc actions add action ... skip_sw...
> > > 
> > > then show get or dump showing things in h/w.
> > > And del..
> > > 
> > > And i certainly hope that the above works and it is
> > > not meant just for the consumption of some OVS use
> > > case.
> > 
> > I agree it would be useful to include a tc cli example in the cover letter.
> > I'll see about making that so in v2.
> > 
> 
> Thanks. That will remove 95% of my commentary.

:)

> Check my other comment on the user space notification.
> I was just looking at the way classifiers handle things from this
> perspective and they dont return to cls_api until completion so
> the notification gets sent after both h/w and software succeed...

Thanks, I will look into this. But it would make my life slightly easier if

a) You could be more specific about what portion of cls_api you are
   referring to.
b) Constrained comments to a topic to a single sub-thread.

