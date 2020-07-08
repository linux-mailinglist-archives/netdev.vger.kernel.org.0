Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 764172191ED
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 23:04:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726107AbgGHVEo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 17:04:44 -0400
Received: from mail-eopbgr60060.outbound.protection.outlook.com ([40.107.6.60]:46049
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725787AbgGHVEn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jul 2020 17:04:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mUdkXdtzWGTNQi/X7xy8SIK68ytWcYaodzTFWiI9k5CEwuETpSiU0WmRuqlK3Rg0Ubryznfd0Pdc/TgZFGI3dBNqyytGsh/c8IZeX1I33rxK7qpR3FSQJ82fc7REnCVU/AFB74ePMQEgYkM9E5LAk/+devD9DwxWomsRs/Z2ow1d3cxp4BkvEGIWcGoaK8Nf8dVwu5Xrl6SRYTnUWBe+5cmS/04zCg3x6e2de9h84IKmWPBoI7TOUWq5dRj0k3uK5I8mQddVC9IgP9R4+8oy2+XAzqm7gDS5TnNKKmx4yBO85Vj566l/JQiS/kH278mBfkOMVftF/y5p3QUtivREYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r3CBNVAdp7xlqFh+K1IRERRLoHfAGd9ytoB63K6yAUU=;
 b=gpxvzxrC/rSpDPgnmUymrqUB7Y24yMOZVML0i9T3yCMC8+XxXTDU1JTPLiZty5fRiwzwqG8xDd+chL+j4UWU+Q+lgnkCwZD7Ef0g3Pc8KXqQ9/bNtb/jhQC6L1gNmOPNm77SqfGpPlp2xiT/z8MUSeqLI76DnVAlVBSThSdXXBQr84G36qkaKjSgv5c7g7bQdTqtuzIi25WYQxcUy7E6NyPr9rMwynoJ+YN/RVHWWGD0usiRljPV37Ir45DWbMjlQE8YHjHZaexLB7GjNEA0Nxc2U+D1+GdLiOcKaPcv8m4mJsMTVgylccJSLnBDnB8l1mQZSjt/36ZKQoXPF3WAiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r3CBNVAdp7xlqFh+K1IRERRLoHfAGd9ytoB63K6yAUU=;
 b=hU1+m/LOjpIYt56OeMEgzSC/I5d8nSQQx12dolGhjFOjVrXif+Rxqv2UcLbG4wAycTVsgGlIjbOB3EPTk0AbjpZ1Fp0jdJhBBsS5ynDceAkCq2zR/tyII/RZlT6CRMeseDMz1TXhQhEno41jKqwgMPYYlW6883SRkCv5qULjxMc=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
Received: from DB6PR05MB4743.eurprd05.prod.outlook.com (2603:10a6:6:47::26) by
 DBBPR05MB6537.eurprd05.prod.outlook.com (2603:10a6:10:c1::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3153.23; Wed, 8 Jul 2020 21:04:40 +0000
Received: from DB6PR05MB4743.eurprd05.prod.outlook.com
 ([fe80::40af:a621:1c1a:b5c9]) by DB6PR05MB4743.eurprd05.prod.outlook.com
 ([fe80::40af:a621:1c1a:b5c9%5]) with mapi id 15.20.3153.030; Wed, 8 Jul 2020
 21:04:39 +0000
References: <cover.1593209494.git.petrm@mellanox.com> <79417f27b7c57da5c0eb54bb6d074d3a472d9ebf.1593209494.git.petrm@mellanox.com> <CAM_iQpXvwPGz=kKBFKQAkoJ0hwijC9M03SV9arC++gYBAU5VKw@mail.gmail.com> <87a70bic3n.fsf@mellanox.com> <CAM_iQpWjod0oLew-jSN+KUXkoPYkJYWyePHsvLyW4f2JbYQFRw@mail.gmail.com> <873662i3rc.fsf@mellanox.com> <CAM_iQpVs_OEBw54qMhn7Tx6_YAGh5PMSApj=RrO0j6ThSXpkcg@mail.gmail.com>
User-agent: mu4e 1.3.3; emacs 26.3
From:   Petr Machata <petrm@mellanox.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next v1 2/5] net: sched: Introduce helpers for qevent blocks
In-reply-to: <CAM_iQpVs_OEBw54qMhn7Tx6_YAGh5PMSApj=RrO0j6ThSXpkcg@mail.gmail.com>
Date:   Wed, 08 Jul 2020 23:04:36 +0200
Message-ID: <87wo3dhg63.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: VI1P18901CA0016.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:801::26) To DB6PR05MB4743.eurprd05.prod.outlook.com
 (2603:10a6:6:47::26)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from yaviefel (185.156.122.193) by VI1P18901CA0016.EURP189.PROD.OUTLOOK.COM (2603:10a6:801::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20 via Frontend Transport; Wed, 8 Jul 2020 21:04:38 +0000
X-Originating-IP: [185.156.122.193]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1fdebac8-71b2-4bb0-113a-08d823828740
X-MS-TrafficTypeDiagnostic: DBBPR05MB6537:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBBPR05MB6537DDE3421EF2EE85443CECDB670@DBBPR05MB6537.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-Forefront-PRVS: 04583CED1A
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4+B2ZcJRFT7ZqtGEDWa13OS5pa4VgxQqCw8U0hLl0wNnZS4swRBj+3XJzHD+K2GWyNrHddO/XYVQ0nAmGE5IuAXnnbjBBzQhOvAjvzJJ9F+cUjv2Bj3RfjiAI5d7mu3utivJKwKkqJoThSwIjPyS/gLX+u3v4X2wAJLJOQgdBy4XeF1zokUlZna/JMpDo3v4YpxTTcupFjlQ3wtY0Vex8IWrCcUghllqDBuFvnh58PGP05Jg7q5YV+iWpDn8nQdVKzPZxzCzcliLi+RmBEhfUR6824PKNdZL+xypMOkVCm77m2vilRvo5GVI0yJon+r1CCsVKvuyrcL9kZT0/wnrug==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB6PR05MB4743.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(396003)(366004)(39860400002)(136003)(5660300002)(36756003)(54906003)(6916009)(4326008)(4744005)(316002)(8676002)(86362001)(83380400001)(2616005)(6486002)(956004)(8936002)(478600001)(2906002)(53546011)(107886003)(6496006)(52116002)(26005)(66946007)(66476007)(16526019)(186003)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ZumUiq6QPF6L+qoYvOKjcUY0KW3BNIVoH1G83M9UBCbefS8dB2opiiNnIYGB8oRLR6bJtyupxnxAzrthX0MlCk804MCS74jETznT+0cK5ndi/gMJ85taWWCFR6Xe6KkWDRYvmMKcTh1Ym35QkGMD6pxDqA1IXQgjR2xnZS8NhJEQLFi4AmCEI5j2Q1qjq13kPlcUATIfx7wyrsVHxBz0znn3YL85eSUonEGnRwqCy1XeOv/EjXJrf7OC8L38Rt4D4uxrKGSEXV2LAV5XBEkDamOZ2D4VnmORucTB1IYZbLFNxsk5IMB9wlINOnBBxPqZkyhzO8aQrm25Gsy7ehtfwOoyglQlTyYJphPtswfpd8Qv4miQMh47CvDs9G/g+eYKpvJTbke+2PQJPpzVvvJvHPk3Xto+5aWdY5lgrj+0fehmAqB/92Zj8w4LiDJxEAgmESTWAZewQLWqclsgk7p002Krsz5gkIe0ibPzbq29YjXIBmXHwka8OwDFEuGQJslj
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fdebac8-71b2-4bb0-113a-08d823828740
X-MS-Exchange-CrossTenant-AuthSource: DB6PR05MB4743.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2020 21:04:39.6907
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TNYEolp/ulOyTEblnIWkO7Hz6BMF8nbqealF/l5MB2A/+ee02p/GW2VKbvRtKEWDjWjzcjDVAJplJH43abnjKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR05MB6537
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Cong Wang <xiyou.wangcong@gmail.com> writes:

> On Wed, Jul 8, 2020 at 5:35 AM Petr Machata <petrm@mellanox.com> wrote:
>> Do you have another solution in mind here? I think the deadlock (in both
>> classification and qevents) is an issue, but really don't know how to
>> avoid it except by dropping the lock.
>
> Ideally we should only take the lock once, but it clearly requires some
> work to teach the dev_queue_xmit() in act_mirred not to acquire it again.

act_mirred does not acquire it though. The egress path does. And the
packet can traverse several mirred instances on several devices before
it gets to the deadlock. Currently I don't see a way to give the egress
path a way to know that the lock is already taken.

I'll think about it some more. For now I will at least fix the lack of
locking.
