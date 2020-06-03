Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD13C1ECD32
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 12:08:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbgFCKIK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 06:08:10 -0400
Received: from mail-eopbgr60077.outbound.protection.outlook.com ([40.107.6.77]:12363
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725943AbgFCKIJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jun 2020 06:08:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kgAiflROW6Z7bWa8b9qM4RDAuLqAL0aclBK+uGGYD8MtHC/jo0rvPMsdXMoP4oS8AMIYuPVb2PF2dper2aEi5kVNS342qg/RLug7qjV87516dCRRSjVEhEncnC/meTigO9iEaVpLP5oi51jI6jMG+y2t63EvZQ2EvnbGnX6lpCmU7uBJVY+rPLCvwfyyxj1mBzJmuuufIFjRafNaNeC1JE9bTuTXT4KbO5mOxXigkBoDv6jqjtHSO2SSl5SxJz23mo4+260ClvmJL7hC6T0tOFPIxuoaPF4noiiyR6H/V/+OKZLJNh1/9OKP4bFguOGLlY2XhgIR9VyARN5FSRDAyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=um816ZEGAitQzUF4eb5opsan7fhs8EUbZDc3jhD7T38=;
 b=N5Y6GQPL8R5/mRaA4JzzHQTdXtckCxjf/B5yMNx+JJ27EK7jYCOQ/XKM1GxYX3d2cz4Vg78UMXHqdubQKL69uCGDRtCQmpE/YH3GUYqw5FczAXA5MWpgXT/BeSA/bhph65nxKqy9Zw2JO8/Ln4ze2M2SfWRpCn5pDqZtGlc+MplpE2PVYuVxOUKQ/hiXEZpdn6GDHMvRvhrJ9VDlhmB8s7a8hzgXF1YlJEfIzqQC2ab5Tl37sPo61FidfFkk/ETpZ/6UbMOWBJ0I+JRBRea92JnHT1MXN7Muif0I2u5vXf7OS59g8cAdQ2p6W2uec+5k+jdrjwTj8ZdyMP44CBfBDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=um816ZEGAitQzUF4eb5opsan7fhs8EUbZDc3jhD7T38=;
 b=EozgC7165QCdSwvtcQtpIMWM7VbQpD5s2thzLabkY3aGZxV89PSa6KW1ELdfm8hfebF/tiZufD9VDydCV/hJv3UrrKTQxAHu/z0BDah3cVUFbrSn3d4uNcqTnJuvkoHQniPMUystH1HmruwEE4jewiMtLUnSlN7uz6mpxHO+E9U=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR05MB3305.eurprd05.prod.outlook.com (2603:10a6:7:35::31) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3066.18; Wed, 3 Jun 2020 10:08:04 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::9de2:ec4b:e521:eece]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::9de2:ec4b:e521:eece%5]) with mapi id 15.20.3066.018; Wed, 3 Jun 2020
 10:08:03 +0000
References: <cover.1590512901.git.petrm@mellanox.com> <CAM_iQpW8NcZy=ayJ49iY-pCix+HFusTfoOpoD_oMOR6+LeGy1g@mail.gmail.com> <20200601134023.GQ2282@nanopsycho> <CAM_iQpXTWK+-_42CsVsL==XOSZO1tGeSDCz=BkgAaRsJvZL6TQ@mail.gmail.com> <20200602060555.GR2282@nanopsycho> <CAM_iQpWw81SqpWHFMLz=rxM8CwFW77796=Cf9x+tERd6gK6nrg@mail.gmail.com>
User-agent: mu4e 1.3.3; emacs 26.3
From:   Petr Machata <petrm@mellanox.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [RFC PATCH net-next 0/3] TC: Introduce qevents
Message-ID: <87r1uw31nt.fsf@mellanox.com>
In-reply-to: <CAM_iQpWw81SqpWHFMLz=rxM8CwFW77796=Cf9x+tERd6gK6nrg@mail.gmail.com>
Date:   Wed, 03 Jun 2020 12:08:01 +0200
Content-Type: text/plain
X-ClientProxiedBy: AM0P190CA0021.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:190::31) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from yaviefel (213.220.234.169) by AM0P190CA0021.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:190::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.18 via Frontend Transport; Wed, 3 Jun 2020 10:08:02 +0000
X-Originating-IP: [213.220.234.169]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3d2a7429-88d1-4bb4-4818-08d807a600ec
X-MS-TrafficTypeDiagnostic: HE1PR05MB3305:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB330508EA092F1E939566C55ADB880@HE1PR05MB3305.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 04238CD941
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uySzIYaC/hT4v2FZ7PvgyWel8GyxKZZFW8Fjw4uUYbRBDpBTD/EQRCXR4WOIfUClztZfMeDHgHaLsm3SpSmaKcX/4twOmKz9saTjr8c3aP1kzQaRsXeh902mOX104+ftBULzsM8KclmjgxYo5PQm+oNsb0nUslep6kCrVLTuQEqROOg6QwPPZmbSw1kd8d2g6Fuu52Khr0E0Cj94f9sV/X66gPeBkSsH579q9OckrzL7agZ0IS1rlxF+oH0s+W6w19sa2cEopHzIEOUYVC0nzHv5iyFBxXYX3pJaaiN2+27UhBkyUjNkUsLbXa9Hlzi7IbDWSCL3shVAt3cPRUqwCQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(346002)(366004)(396003)(39860400002)(376002)(6486002)(478600001)(8676002)(83380400001)(6916009)(52116002)(8936002)(6496006)(2906002)(36756003)(5660300002)(107886003)(66946007)(26005)(186003)(2616005)(16526019)(956004)(4326008)(54906003)(86362001)(316002)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ie5kIY1O1rHbCQfVQ8ZtzF5Oe+j+WfUWxj5EuwCngUfCS0N/a3U5E7yZ7VERw3W8yMrYYvQSlOr0b9MDLAtJ/xlmKaIyYVqA3atw0a/HH57Q0roOwn2iTszsIzLy2nIbyelZVTbMWJddkR9EjpMQnmLEdHnmLdZaMMsD+YG50st/9IPDj5booHwcI3pYLPN3dS6NBoiLspu3nMtaXmxlbmGJGoLEJa1qKjw9iMNxM3Wqgy4HNGZm4C37mb6Ohdeh6IfvKEdHLh8hjAMiJWNv8SSUJIRnN0mG5SJ/U/+vHrmmusuzNSPiAgwTWqHNzFdxktgHMT1Og7okdELo5kPumN36u3n9fVBYqSj9kmDLvLhcvgweQmUj4U3axJWUH1ii+6hkYpWRTliERl+sQ+66jT0kZZ70TGndSQGTwggLQLboR7L1qjiVs7xm+BVaGBOGCJSfyguHV3XSMO+o975jb1lu+W+wlIZjsUul0jnT6bxMKkBkDh7Zx85kvZZL05EO
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d2a7429-88d1-4bb4-4818-08d807a600ec
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2020 10:08:03.7124
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L0kiRB94dksYuYvf4nrFCPKyKC4M3jz9kxXHV54oI14L8ytPrAp/cC/MAab+P7zEv8R5K0zRXsllmbgAgEh29w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3305
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Cong Wang <xiyou.wangcong@gmail.com> writes:

> I imagine we could introduce multiple blocks for a qdisc.

Yes, and that's what the patchset does. If you look at struct
tcf_qevent, it is just some block bookkeeping and an attribute name.

> Currently we have:
>
> struct some_qdisc_data {
>   struct tcf_block *block;
> };
>
> Maybe we can extend it to:
>
> struct some_qdisc_data {
>   struct tcf_block *blocks[3];

Yeah, except not all qdiscs will implement all qevents, so let's instead
make it a handful of fields, like in the patchset.

> };
>
> #define ENQUEUE 0
> #define DEQUEUE 1
> #define DROP 2
>
> static struct tcf_block *foo_tcf_block(struct Qdisc *sch, unsigned long cl,
>                                             struct netlink_ext_ack
> *extack, int position)
> {
>         struct some_qdisc_data *q = qdisc_priv(sch);
>
>         if (cl)
>                 return NULL;
>         return q->block[position];
> }

Interestingly, this is close to my original approach, pre-RFC. But there
needs to be this global list of all existing qevents. On its own, that's
a negative--at least it's an extra uAPI to maintain. What does it bring?

It theoretically allows one to refer to blocks symbolically, through
binding point coordinates (dev D parent P qevent Q) not by indices
(block B). But then one block could be referenced by several different
coordinates, which is confusing. That is the reason TC disallows editing
filters on shared blocks. Qevents should be the same.

What else is there?
