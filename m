Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A13172A9870
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 16:21:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727529AbgKFPVl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 10:21:41 -0500
Received: from mail-vi1eur05on2091.outbound.protection.outlook.com ([40.107.21.91]:60480
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727020AbgKFPVk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Nov 2020 10:21:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D2B1eF3KkcPlAi/M0wukEqIwddOsYHh2H7mEy2nWuS6FTNImIQ2bp7BXcLrpt610jvhb9Gkp/IK36gQamx3c8xvJS8l1sWuNe7pYvccCQMK4UFurTeANck2qCsyBDEkFgP369G4ZIjgK7+dIyJATumXZIgE6aqHfg3vybZEGZ727VxuHR8CCzBGvP4vqp4dwcmaR7OExUN/lyIKrK4hEXpjv0B1lN9lH0IOU8DVMQ96t5mT4ItKnjub7KpjxTrRegLgXih0JVxeUi4pfC6m+TErm8m9HlkERd5bxWQBXNKIPT66hX1V21nkAyARL5cSQTWFOvzkXz2mlVnPcYLQHYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jgzuxWC3DjCqV3mbXU30IRhp8BHac3I/9E/krhvwvgE=;
 b=bkgF0Wxrp/rRztrHOLBZ6Bf8uUs1KjZ2mswojsd14TD9zuBEP1ZfXYSLYoGiJtUCBu+wIP/OaWZPLMLalk+q+0FPnzIoj6nDExLPkuNpkFD5QRCzzD2TrtrjagkPapUvZb0ti0+yxPMmYquMY6LxVyjucM//2AxNM8Gsf+cUpnOwuxltKsYk/ZhZ3YNCPeGWM5z2Z8OoFc2aMvUgkw6H5mD9rEaCnyWsdSQNN+yhLnoKfCEuYipzhLW0y3CjjaXydZ0asL2ZqDVqtCQ1OFyiJ3Uebm/I+R9A1yteCSl6qEwcHQFrEKTHAOI8Ee7+HzXqsmxFq8387IUscYjAeHLRXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jgzuxWC3DjCqV3mbXU30IRhp8BHac3I/9E/krhvwvgE=;
 b=OPbyjrF4nGHMNoykJLG4uQwuNkLcKmGrq1N5aJqLHmd6PyV9wJMEavl1thk+2VqDu86bFHrqNtROr/57wGltLgpoTc2yCkmvFqE2Qw2bOn9/fiBKJbB3Ic3k2XPfe7T+FGJ1k+rUb8m22kQK+jxVgYwrAYtKKFJc5LvFi3tDHXI=
Authentication-Results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0300.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:5c::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3499.28; Fri, 6 Nov 2020 15:21:36 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::c1ab:71de:6bc2:89fe]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::c1ab:71de:6bc2:89fe%6]) with mapi id 15.20.3499.032; Fri, 6 Nov 2020
 15:21:36 +0000
References: <20201103181931.0ea86551@canb.auug.org.au> <0fcb653e-8a8c-350e-abf7-d802867ef0e9@infradead.org>
User-agent: mu4e 1.2.0; emacs 26.3
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Vadym Kochan <vadym.kochan@plvision.eu>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>
Subject: Re: linux-next: Tree for Nov 3 (drivers/net/ethernet/marvell/prestera/prestera_switchdev.o)
In-reply-to: <0fcb653e-8a8c-350e-abf7-d802867ef0e9@infradead.org>
Date:   Fri, 06 Nov 2020 17:21:34 +0200
Message-ID: <vrcxh2d00q1pfl.fsf@plvision.eu>
Content-Type: text/plain
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AM5PR04CA0024.eurprd04.prod.outlook.com
 (2603:10a6:206:1::37) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan (217.20.186.93) by AM5PR04CA0024.eurprd04.prod.outlook.com (2603:10a6:206:1::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Fri, 6 Nov 2020 15:21:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6cd1c83e-b516-4fbd-a006-08d88267a689
X-MS-TrafficTypeDiagnostic: HE1P190MB0300:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB0300161F141345B959B9F79B95ED0@HE1P190MB0300.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VymaMJ6nSBVOXnpecEs0+jULz0WeS8gcsHDJ5wpxBtkrI49VDdTFE48SH7uPJB5xWOKtOPFREa4xRuVg2oqOzYV6yo6uigPbNX3wJAZ/TotMAdtvEDgnAP2SKMiCondxjfsarbnFZfR3522m7zUsWI5IHSiLtaf1LxvvObYIPsTEG+rZhk3rWQTR51NL4t8CPsKLjfayCBPEBAEkLtWLu7D9ZrsnwYV65jLTitlNOjg0He/hwXQH7js/vO6lZZ+6ufpXEHGdIWcpfSg+a7IGvbJ3R/AUdJxTwENOW4hl+48CUIFyP2iUsDXXaHkyG9WL972Bb1LpwZaVQjlGBPgKhA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(39830400003)(136003)(366004)(346002)(376002)(396003)(5660300002)(52116002)(36756003)(4744005)(16526019)(26005)(66476007)(4326008)(53546011)(66556008)(478600001)(186003)(66946007)(316002)(6496006)(956004)(44832011)(6916009)(2906002)(2616005)(6486002)(86362001)(54906003)(8676002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 8En2HbDTPzb2WPwI85y/jb65WdmP+8uh6RgjDTZr/C9Eb06zgiLVVq5vX5XfTIwZ2Gb3Tt/sQMMjLeUpHaP7/rTU+QMokaZuDrFi9KQ3Vo1PyIiU4G5Kv/x0tvhbex3F6A4tV4Dd4g3XTe9b6RpzysrmzJL/R8VIBJDCqbdGyp0jZAHH2BcALLn4m/d6XPF+g02eMM6IZURPZKl0txaE5FBrYvrp290g0yGF93N7pyit+Dyv0AeZ3OREwqj8nbJ/CaGdypnYwtFaIwVrkAnEmFMV+2E6CBlGaf/93M1mP8jvy3yDmiQg7g57KV27zawiRXqYt4DuWHhIXvGeVnYnmebykytCURW1METkx8dV165zczXHlMZrlGJS5wFj//hprbZHl18FTeiHoLdoufts5QSOHbQk6loSwM0n+5+WZQGNEA5xGhcrbgMDP/WZkWQnuv6aT1KYUwNx+CqHTjBj8W/qQSebcNUCD7IynUNK0zqliHDu/N8/GRvkYVvKEHui2gXMy+hV4ugQoJweqf5J8/B8f1dP9gsYW6NwRx1esYk1MZNGk2g5vV/iMkMhqywFM1JRGJkF2YNicm0fRzGI/0cz70Esd8Fcb9WkueiK8N9MHJsSbcYtkph1puZBzwDyuc0yt0y+bpbHyR2my9LRUg==
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cd1c83e-b516-4fbd-a006-08d88267a689
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2020 15:21:36.2913
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k7Ii1SBVUQFUJYFc8/Ci+/zovVyfkFow7FKjMyrJbcvxYdIblElt4bGL023+//eMFF4DWcvrkBQPlSW95fZst6OGMTbdARZ9HZpR4J06WDU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0300
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi Randy,

Randy Dunlap <rdunlap@infradead.org> writes:

> On 11/2/20 11:19 PM, Stephen Rothwell wrote:
>> Hi all,
>> 
>> Changes since 20201102:
>> 
>
> on x86_64:
>
> when CONFIG_BRIDGE=m:
>
> ld: drivers/net/ethernet/marvell/prestera/prestera_switchdev.o: in function `prestera_bridge_port_event':
> prestera_switchdev.c:(.text+0x2ebd): undefined reference to `br_vlan_enabled'
>
>
> Also please add drivers/net/ethernet/marvell/prestera/ to the
> MAINTAINERS file.
>
> thanks.

Thanks for catching this, will send fix via the "net" tree.

Regards,
Vadym Kochan
