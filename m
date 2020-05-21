Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 002311DD018
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 16:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729828AbgEUOgU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 10:36:20 -0400
Received: from mail-db8eur05on2044.outbound.protection.outlook.com ([40.107.20.44]:6087
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729821AbgEUOgT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 May 2020 10:36:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bB9cjYzngKAjOh3Ccs1giBFmwEU0iIfMHA32ISbjit6zMa89SAafPHac035rJYzAh40jsrA0QauxRN5lJo5KMxamt4z4PuoxREgCBu4JqsMn4HBxNUo0Y2U4MNP6w7lnA4QuwZn//phXYfk5fE6uHxigbVkfSgedK1ldtOTdZ8U58OU/NXFdWDn+ZCrwfIY6Zxc4p4nHEOUEak4ScSd+/3hl86u0PQlq3kA6rNczj+z5MBTXSqjClWZDrP0EJwaoS9T3UgvkrBPx26W3ebFj46XzcApNFVqAHsk333i/nNUgZLNAQ3yvoZ7yPD9/C5ZBRieQVvyX+pauImVnoDlsog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fVeG4lZBo5xeM0fA5qoBbQbmII9vKgiLt07kru54O/A=;
 b=Sd/aS1P/9yNbgFWdNuMfXge8MarHGaC1xIQruXtFzUp8uMpegAo51+BWslGL1VbDJvulvz0zPuzIG5ycAX73GxrTZRcg/3USOPjHsZRO9S/adJSQ63Ljuw3X5h53H9fqUcV49g0Cho1MIW+aKnVg1wnBZY1fZfmbZXXdoyut8cxoim28PfNz1E3vj/M8+XFBKBlZtTGSHbRi8wt3WfchDO67AAHXQ+LvO/er8VXz4JETmZe+oPK+N8tH9SPB3u97f9/XWopwCnyO1c7sjMm4bWi61HtpZlhn3LX9rpyuLssxcGRZL8Wx085hdNkqtDIlP3XQejSpbXK+H5lZ/VP62g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fVeG4lZBo5xeM0fA5qoBbQbmII9vKgiLt07kru54O/A=;
 b=PIl8HatNUaR9PWDWUVN9i8xaptHcMw1IxDibzgRiMakiLdy70h58gc6anO20Nn9UKwMFziRO9HgOLZhISaNcptbrWxHVCz20Fgn7yvBvKkOkWVi7fct5Gt1cgGB7DGnKYSMundI9XYmn6HJXBLU6H6DoFCfkm5fmrxfOcQabLYM=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=mellanox.com;
Received: from AM7PR05MB6995.eurprd05.prod.outlook.com (2603:10a6:20b:1ad::15)
 by AM7PR05MB6963.eurprd05.prod.outlook.com (2603:10a6:20b:1a8::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23; Thu, 21 May
 2020 14:36:16 +0000
Received: from AM7PR05MB6995.eurprd05.prod.outlook.com
 ([fe80::e135:3e43:e5e5:860d]) by AM7PR05MB6995.eurprd05.prod.outlook.com
 ([fe80::e135:3e43:e5e5:860d%8]) with mapi id 15.20.3021.020; Thu, 21 May 2020
 14:36:15 +0000
References: <20200515114014.3135-1-vladbu@mellanox.com> <649b2756-1ddf-2b3e-cd13-1c577c50eaa2@solarflare.com>
User-agent: mu4e 1.2.0; emacs 26.2.90
From:   Vlad Buslov <vladbu@mellanox.com>
To:     Edward Cree <ecree@solarflare.com>, xiyou.wangcong@gmail.com
Cc:     Vlad Buslov <vladbu@mellanox.com>, netdev@vger.kernel.org,
        davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        dcaratti@redhat.com, marcelo.leitner@gmail.com, kuba@kernel.org
Subject: Re: [PATCH net-next v2 0/4] Implement classifier-action terse dump mode
In-reply-to: <649b2756-1ddf-2b3e-cd13-1c577c50eaa2@solarflare.com>
Date:   Thu, 21 May 2020 17:36:12 +0300
Message-ID: <vbf1rndz76r.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0902CA0002.eurprd09.prod.outlook.com
 (2603:10a6:200:9b::12) To AM7PR05MB6995.eurprd05.prod.outlook.com
 (2603:10a6:20b:1ad::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from reg-r-vrt-018-180.mellanox.com (37.142.13.130) by AM4PR0902CA0002.eurprd09.prod.outlook.com (2603:10a6:200:9b::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23 via Frontend Transport; Thu, 21 May 2020 14:36:14 +0000
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ac9d5cbc-6048-42f2-9575-08d7fd945146
X-MS-TrafficTypeDiagnostic: AM7PR05MB6963:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM7PR05MB6963CA8AE03418086BFA6E82ADB70@AM7PR05MB6963.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 041032FF37
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5lG9kcYvkunjVrfWe+9h8vw0ZyQ9gExX9Rc4H6Kx5oC4mHEMnydiF4+4bjrHTotYElvQT+xAo0MGjw+7+OhMrbV1bj7fwYtP20IQ4D5tzEhM57xUboQOeru1kIEW7opAfyv1CZKVRiRHXpixCQ7QZRzph86XlgwcJzJJCvO/MPqpLPAU/W4m6t/37l8PUQxOn+qDv5LYZW+sweVXLfz6e3vI0eR6cX74nhMhl5JR5LX3vf3Bw2+b5sJi5fPgAmQ56cK57IQp3FH8+4jPMSk+Q5VB/fFh9y/KkWXo7sjzkZtDYomtxaydmylVsvT207MQ+afsdK7XrgeBh331yj97UA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR05MB6995.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(376002)(366004)(136003)(346002)(396003)(5660300002)(66946007)(36756003)(4326008)(2906002)(316002)(8936002)(16526019)(478600001)(6486002)(956004)(2616005)(26005)(66476007)(86362001)(53546011)(186003)(52116002)(66556008)(7696005)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: IopA3Q4kr4qX/4NcIjBsttQ+d3lwV27AivbdieL1Ram+BB4qdroBfSS6l4aAMJzIo/C/S+qD1T+bPVTBaxfRxHAsB3XKm6eyIdpINJGT/5ayT+N8bsegRXApgl3Il05yUDlvWwraHZAcjUoLD5DGQh24OPMQRvM3Uof15OsG+0RmM11Li7ChK+dDdIfgB5JhYvsNjLCwp22S7sHORZwfqX6LMo0JSRmVqCA60DSCb65bUWJyN/zDqxs6aM7eMhYpr0H9E6VMtDer2t8/408MtyAMLFwk81eFQXypvBdyo6HTVkeloy0esuh1DRK2YEDOUhpesoebKNu9QgXpOeUjo2LxzN6VfCBO4Bkvtftyd4+os5wkWZJfyQs74t+BMw9kSRTw4UqP1ZRGUct5DR95L2yZFXrEEQylkLp8gEpN+oiTmXKkrQDGNfyK0AvGiL+PylNoS0xnPu74MQ3O1lqltqUmilLVi6EuAmcmutmOYZg=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac9d5cbc-6048-42f2-9575-08d7fd945146
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2020 14:36:15.8474
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LwJigT1yD67ooQAWwGoKF789W2luYkByPgd0dtmE3Xa96ew/DKLB4sWPVPQXn13IWKeLDPqzYBWM30F2fpjWww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR05MB6963
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Edward, Cong,

On Mon 18 May 2020 at 18:37, Edward Cree <ecree@solarflare.com> wrote:
> On 15/05/2020 12:40, Vlad Buslov wrote:
>> In order to
>> significantly improve filter dump rate this patch sets implement new
>> mode of TC filter dump operation named "terse dump" mode. In this mode
>> only parameters necessary to identify the filter (handle, action cookie,
>> etc.) and data that can change during filter lifecycle (filter flags,
>> action stats, etc.) are preserved in dump output while everything else
>> is omitted.
> I realise I'm a bit late, but isn't this the kind of policy that shouldn't
>  be hard-coded in the kernel?  I.e. if next year it turns out that some
>  user needs one parameter that's been omitted here, but not the whole dump,
>  are they going to want to add another mode to the uapi?
> Should this not instead have been done as a set of flags to specify which
>  pieces of information the caller wanted in the dump, rather than a mode
>  flag selecting a pre-defined set?
>
> -ed

I've been thinking some more about this. While the idea of making
fine-grained dump where user controls exact contents field-by-field is
unfeasible due to performance considerations, we can try to come up with
something more coarse-grained but not fully hardcoded (like current terse
dump implementation). Something like having a set of flags that allows
to skip output of groups of attributes.

For example, CLS_SKIP_KEY flag would skip the whole expensive classifier
key dump without having to go through all 200 lines of conditionals in
fl_dump_key() while ACT_SKIP_OPTIONS would skip outputting TCA_OPTIONS
compound attribute (and expensive call to tc_action_ops->dump()). This
approach would also leave the door open for further more fine-grained
flags, if the need arises. For example, new flags
CLS_SKIP_KEY_{L2,L3,L4} can be introduced to more precisely control
which parts of cls key should be skipped.

The main drawback of such approach is that it is impossible to come up
with universal set of flags that would be applicable for all
classifiers. Key (in some form) is applicable to most classifiers, but
it still doesn't make sense for matchall or bpf. Some classifiers have
'flags', some don't. Hardware-offloaded classifiers have in_hw_count.
Considering this, initial set of flags will be somewhat flower-centric.

What do you think?

Regards,
Vlad
