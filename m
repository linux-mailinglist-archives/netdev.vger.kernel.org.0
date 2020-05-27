Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A9411E4737
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 17:23:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388135AbgE0PXK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 11:23:10 -0400
Received: from mail-eopbgr80053.outbound.protection.outlook.com ([40.107.8.53]:38934
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727017AbgE0PXK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 11:23:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rc5UdhNE9fzf8PEESgRb2IobE7oWzkh5EwhWohbYm+RJXsT03RwGaBa2crHredpWSZycMwysrb5iUIVKdWbpjkTf2sPHQjFUou/T5AHNVToEV2zKK8RTREwCB5hftPHvND23Vc2LzKoSFeO/5Vv4CMQUFsvDgeW1A85vvFBlaALi9byn5tGNDqAZqjv0H0RZKIXNz55pRYBOki1YSa4nNdaqX3xsKONaK6a0F8fIt6LxQYaM2Hw3CD5aO+52U9ZS7FIsWlcmyEu6pCljpumkJd52eCI8oAFA6+Uu7j7K0HfIYHrRvqIwKmg1HDuhmJr2p6mhUrQroGfoEACvIMhLdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BoI7a9dnmBcQ/XuDj2hT2TjowDb223ACliDAM02dXBY=;
 b=CIEhMOlexa66CAvjGn5zlk8umrCTBWlfUQi0h7fIsZyg3mRlRRCmS8+wPcTBmNdu4BhrgOsB+ruONDf30/gBqf2LrzQ/FRt/jVSyQdg38CQJSnNNtlE4CuII8Z83aVTE87BN4HzyUe2pMeBymA2bGSmP6aBPUdmeKB9LBD3URbWuNu+qAUF/t9TUHiels4y8nw4qHAaJ0yUXHhBwO5c3zj6OQwagrkXgDUXIhS+fSCesWG3Z2RgktnV+lez5KWiDBiEv/m6bKu6BY/s35KaBJupVCmrwJ5hwH6TtRiPxznRJUMN+d7GCwq4GpUIW8uZeYAVuquSfYCxEUswFXwVbkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BoI7a9dnmBcQ/XuDj2hT2TjowDb223ACliDAM02dXBY=;
 b=VIdJ5Q52g4niqg3g3Ryw6haGyJz6Dj5GNLNE03Bb8Ik80kI8uJuJ+NBqbg/sSaeLhOzWgJ0lLxmksbngws5/xd78oIkuT0vZ4EcAl3L0/ZsF8XMRIeEqF+SctfDSHjg0rLmxmqNwhbqJiX8ai5Grdu5m427cFKOFCrqkqlTLW28=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR05MB3177.eurprd05.prod.outlook.com (2603:10a6:7:36::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3021.23; Wed, 27 May 2020 15:23:05 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::9de2:ec4b:e521:eece]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::9de2:ec4b:e521:eece%5]) with mapi id 15.20.3045.018; Wed, 27 May 2020
 15:23:05 +0000
References: <cover.1590512901.git.petrm@mellanox.com> <b761925f786dc812c75e4d0e71c288909248216f.1590512901.git.petrm@mellanox.com> <20200526113207.31d1bec6@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
User-agent: mu4e 1.3.3; emacs 26.3
From:   Petr Machata <petrm@mellanox.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        jhs@mojatatu.com, jiri@mellanox.com, idosch@mellanox.com
Subject: Re: [RFC PATCH net-next 2/3] net: sched: sch_red: Split init and change callbacks
In-reply-to: <20200526113207.31d1bec6@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Date:   Wed, 27 May 2020 17:23:02 +0200
Message-ID: <87367lv1ux.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: AM4PR05CA0021.eurprd05.prod.outlook.com (2603:10a6:205::34)
 To HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from yaviefel (213.220.234.169) by AM4PR05CA0021.eurprd05.prod.outlook.com (2603:10a6:205::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.18 via Frontend Transport; Wed, 27 May 2020 15:23:04 +0000
X-Originating-IP: [213.220.234.169]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e6805484-a008-4e1c-e6f2-08d80251da20
X-MS-TrafficTypeDiagnostic: HE1PR05MB3177:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB3177D3B5E64C8B538F7358A0DBB10@HE1PR05MB3177.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-Forefront-PRVS: 04163EF38A
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SwWSfv1IoM6SdVBint5qwbdbgCbeeUvM9Fcod6baGM0+pC1nMr7Mqdf+4E31Uh6AmtqKtO4A7E5GmlG+YBolhiUFECDa5npInQuaazNZg9wlI2jyLnpkFSGRoNxeCHzXz8Mw87Q3mSRaBopyiWNcfuhIsAoNGHUMc1Q/TqFLcHWwmO8JU5lxE3S9ztiKSdwL9XxKckGAj9aNGiEBKS7Wx31Wn8URsljQ22xyBYRKpDU1eYapJCvz9KDnWOR+76vNAYYlTARgylb710vLcV06A4iLgSOMTezkbMS3bC6BVFYvIZhRqLkGZdAJO6UWHt0DJLjWOhFWV7TxdUAC3kYJVg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(136003)(346002)(376002)(366004)(39860400002)(2906002)(83380400001)(107886003)(86362001)(6486002)(36756003)(52116002)(26005)(6496006)(5660300002)(316002)(186003)(8676002)(8936002)(16526019)(478600001)(6916009)(4744005)(66476007)(4326008)(66556008)(2616005)(956004)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: dAN6sXqow+FLRGQIR0Mc5duEJJpbEcVygD+uV6ahSUVmcjdBh8eFPZgtG7a2z7fUWEnKhzg7e5zwAX/DxS1RKN7eKQ0rE6Rei3U3jibfnhMF9bNwn0FqnQjdr8++QEcW25BjRBOhpE4mfGoqK+0X0A+I05OzPWwAN4/4IJzxGvb5dnbriql4oBWt+KSL/pFcyAJNVnRen0MkkO4KB0MZ0b7r4VwDf2S1fDvOed9tFr9fHrRCp5ZnPLZHE/mwa8eR6YLV0h4PDVBOfROsjU60itjPZy0a7ysgbwfeS8DxLJjdEotfKED/rTxhs546ovuJB0ALyX42WJ6f/zh5MTB7JrjZLGAbKJT3GtgKXcfexZCVVgeRHtYaizcXgc9mYHxtHp29Lr6n6y7j8NKvRQPhqysDy4hDoCgzKVWvuOlK6iPWAHmm8FcqICw+J1ivk7778DM2UKbcrzJ6Xu2vDAd/h/yKvsz7e/Sn2SkfBjoVdTiTinRefv8ivGstg7dOMMje
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6805484-a008-4e1c-e6f2-08d80251da20
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2020 15:23:05.0859
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OYts+UWZcI92+Qd/qf6N+l1LoLHcE4RNHjVxQdLyvFq+hXPOyNM53pt34TsWHEH8OIoQsRoV0g/wW8jQ/Qj1Xw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3177
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Jakub Kicinski <kuba@kernel.org> writes:

> On Tue, 26 May 2020 20:10:06 +0300 Petr Machata wrote:
>> +static int red_change(struct Qdisc *sch, struct nlattr *opt,
>> +		      struct netlink_ext_ack *extack)
>> +{
>> +	struct red_sched_data *q = qdisc_priv(sch);
>
> net/sched/sch_red.c: In function red_change:
> net/sched/sch_red.c:337:25: warning: unused variable q [-Wunused-variable]
>   337 |  struct red_sched_data *q = qdisc_priv(sch);
>       |                         ^
>
> Needs to go to the next patch.

Indeed. I neglected to do my usual "git rebase -x" dance :-/
