Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EC191D713C
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 08:46:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbgERGqa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 02:46:30 -0400
Received: from mail-eopbgr70047.outbound.protection.outlook.com ([40.107.7.47]:34857
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726412AbgERGqa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 May 2020 02:46:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TnCvzpE5FyTVFdGIBo9ctFNLcke7L+49WSUKd3ZriCR5wXBflWrltSXmfo2dNLtch7w8rYeuHZ6GJ0/PKeYqARexkZm+4prX2pIUW1RACZO+VW0EIE/sI28K9UW9Pd9HCM1EAl90vufV84Oehd7nvaXfqlrvEXs+PcAx/+fe7idCZCgCpe/09dZDBV5OzePFSfMnSdbTkEgyDez7LsiEeZHjKDnBU0C/nyiuOhlp2nvcY404nysU7hr9cyHWCguXCdv5ibKh5zvJKLk+GJ9HX0RpJ0DqE8nZcilk8GRP60Ri8qnM5PJnO5SsWdjy4txa0TSiHIjiHxtEr0PzeONaMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1QcKSD1GGGhBwGQtPlfJtx+imzYGthtV8mkUSBO1dZ0=;
 b=lmlZgw5Eg39AAYRFdEH+2ZpCXTBJQ3BmteDQXM+3/bt/ASEVl3QR54TmNdMe0y2NdSGL55aw7dDEjHNszYuAha6bEN6b57NHr3GGUFnitLNS7JybEjTnlekJlXIB3v//vOpnWwPp89Ww/Njq3NiF2NGUE7tZNtrVzVHkhFxM7NFOkxOBF9emub5PZNWcoAym88ctWkPp0C4UKKhgmrx8QLh3PYr1mBHRNHve5kvzv8oia6MECyIMPiDJfArqxjUsgED2f71gg7vKiAuKGTj4/VQJGcBxh6c0PZZS7ft+s2c0wgiaUYJQ0VZeCum/22JnjBioyycGHnZc+BH14IKsDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1QcKSD1GGGhBwGQtPlfJtx+imzYGthtV8mkUSBO1dZ0=;
 b=nvQF6i7t/7VMDjNCvtR+uyYNZ0TggUeMdK/X4u1mVGRnVSSui55eeM0xS2NhwdgLssZZ4sRiItUeKZ1Iowyw7Zx6Vf1kT9o0maMs0dC1cD3LeDLtCSTUOS/iHQe1e4AnAckU+E5Eanx89E5/DRUTo2CZ619gT3sYmqmIpY0nWXk=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=mellanox.com;
Received: from AM7PR05MB6995.eurprd05.prod.outlook.com (2603:10a6:20b:1ad::15)
 by AM7PR05MB7105.eurprd05.prod.outlook.com (2603:10a6:20b:1a1::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.26; Mon, 18 May
 2020 06:46:26 +0000
Received: from AM7PR05MB6995.eurprd05.prod.outlook.com
 ([fe80::3903:9c1e:52e0:d74e]) by AM7PR05MB6995.eurprd05.prod.outlook.com
 ([fe80::3903:9c1e:52e0:d74e%8]) with mapi id 15.20.3000.034; Mon, 18 May 2020
 06:46:26 +0000
References: <20200515114014.3135-1-vladbu@mellanox.com> <20200515100448.12b2c73d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-agent: mu4e 1.2.0; emacs 26.2.90
From:   Vlad Buslov <vladbu@mellanox.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Vlad Buslov <vladbu@mellanox.com>, netdev@vger.kernel.org,
        davem@davemloft.net, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, dcaratti@redhat.com, marcelo.leitner@gmail.com
Subject: Re: [PATCH net-next v2 0/4] Implement classifier-action terse dump mode
In-reply-to: <20200515100448.12b2c73d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Date:   Mon, 18 May 2020 09:46:23 +0300
Message-ID: <vbf367xpwow.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: PR3P193CA0011.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:102:50::16) To AM7PR05MB6995.eurprd05.prod.outlook.com
 (2603:10a6:20b:1ad::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from reg-r-vrt-018-180.mellanox.com (37.142.13.130) by PR3P193CA0011.EURP193.PROD.OUTLOOK.COM (2603:10a6:102:50::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.25 via Frontend Transport; Mon, 18 May 2020 06:46:25 +0000
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 12082c83-7604-4163-0ac7-08d7faf72ff7
X-MS-TrafficTypeDiagnostic: AM7PR05MB7105:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM7PR05MB7105312055B10CF45D704CDCADB80@AM7PR05MB7105.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 04073E895A
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A4jXL98txoyr/X6wYf6BoSQY2nlGNrlkYRdbabxZlIWGYq6wdjSBt5bv+ks3DuoBfUk4EWSQ7gGzkxH1wJbKkvNAwKXT6vynSPb2U1hw6TMEgxAsaKhxh0USsVZXKp0ko7wImCAmv4ZlZqLSABoH9TW6sud5dwyanaHdfxHkFm1ntYg7/b6RDY2wEkDIoHiW/Fd4z55jibmxbGMnkRB6gCGDxZmYCVZizMisfzVGvSGNGmyEZC+Mr0HMsA57uuPf6k5p5tR6IKkSIRFe0yHq8vqFRe8xGHCs/DpswBIudoyP/JHDWAZqzYnMPz3ZfFDyk3meg/Qzd71fWoXYcpP4jre9rSMifDaGME70J6QbKFj7Z9jooiySftKUCOo9OonhRGTR1HLcJbVcu9rsJUzau6WvhgNIxdHv2WwT4ZONJFmlWpuHWMweEUlzAkbtLL+N
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR05MB6995.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(39860400002)(136003)(346002)(376002)(478600001)(6916009)(66556008)(36756003)(316002)(4326008)(66476007)(2616005)(66946007)(8936002)(956004)(2906002)(6486002)(16526019)(186003)(26005)(7696005)(52116002)(86362001)(5660300002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: FcNyVveV73GvLsaL0IfI2rP5b21U9gsOFbp9QV6Qcs7t2FaSvK3jZ60Fmz28F0ZFXYwMYeQTLAuUsyZUXUt9ubiEne/CStf0ZNo/d6T+tbjZPiPOdcM3/0VBUE7m9/xVZ2jAUWrZmjaH831c3CGxtaH2mFHWfYyUT3taQPdy/AP8Isso1fukoaY6BuRZ2t67BkWfTRPliW9jMFuKX9HcY8mMQVl3xe1/oBNyGDMQSKcVLQTMOe/VSivKWUqRA/iuZACpNHkOmiRbJFL3CRxX/G+EQ4cP2AU7l2RjI8nGCylbuCWw94YaY8WN/XYbXaj/1DEvtZi8DoZiXkfuP/bMxeHxw0biOFjsbX7cYZXoPFjVhsBVoekuTruTNjidMM4y82N7GpdEM2Qi4dmTeIkz+AUvwF3Zxdg5G0K3uJJq4HpoxJRA9LxhgUM3QIYlZESgWS6P9Qv6k/0fRDTswuFwatfibjUXXfoO/i5HcxVE2dA=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12082c83-7604-4163-0ac7-08d7faf72ff7
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2020 06:46:26.6263
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vFEjLZ7sX1xyvtuFWGuEClOmmc2tmDGMgDX7SjPyhQiPx2OB1SlfasY1OaOF/NNu+GxbTiNnyv2eDI3FkpJf8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR05MB7105
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Fri 15 May 2020 at 20:04, Jakub Kicinski <kuba@kernel.org> wrote:
> On Fri, 15 May 2020 14:40:10 +0300 Vlad Buslov wrote:
>> Output rate of current upstream kernel TC filter dump implementation if
>> relatively low (~100k rules/sec depending on configuration). This
>> constraint impacts performance of software switch implementation that
>> rely on TC for their datapath implementation and periodically call TC
>> filter dump to update rules stats. Moreover, TC filter dump output a lot
>> of static data that don't change during the filter lifecycle (filter
>> key, specific action details, etc.) which constitutes significant
>> portion of payload on resulting netlink packets and increases amount of
>> syscalls necessary to dump all filters on particular Qdisc. In order to
>> significantly improve filter dump rate this patch sets implement new
>> mode of TC filter dump operation named "terse dump" mode. In this mode
>> only parameters necessary to identify the filter (handle, action cookie,
>> etc.) and data that can change during filter lifecycle (filter flags,
>> action stats, etc.) are preserved in dump output while everything else
>> is omitted.
>
> Please keep the review tags you already got when making minor changes.

Thanks. I generally hesitant to retain other people's tags when making
any changes to the code. I'll retain your tags when making trivial
changes from now on.

>
> Reviewed-by: Jakub Kicinski <kuba@kernel.org>

