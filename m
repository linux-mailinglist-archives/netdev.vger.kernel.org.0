Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44A311E8FE4
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 10:56:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728071AbgE3Iz6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 04:55:58 -0400
Received: from mail-eopbgr50061.outbound.protection.outlook.com ([40.107.5.61]:4686
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725554AbgE3Iz6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 May 2020 04:55:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SpmcCryWrZqiEWrMdzSq9owEg3U8A1nSNIfH6WK40vraai+jxqCDMA4lz6+u+qlgxCtE8g0n1TEhy+Jnk8hlL9c9fsG8f5nbqoX0aPe5SL0I+714W9DIHEqrcM94IC/dD8eUmsSZ56wZE3wUjuz+Cy3I85v1ZNL2A3mfM3zExlTUQL2g/muIQf6vV/7x5vlRK9CK6daPGncKMuWPuieekuSnQXrRdjdd63oUICgrZZlvT8VyO2MjETGbkb48vYJMXsKeySWvLNwizGdOz/glNxbb1xxCQd1MQyBbkxtRk03y2sHKiC68FMbgPpnzlSfuGnO+PDogBT0EtXmOHko9Hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3Zd3ihHkFtf/R8HHfrXHh/3b/VCtxQWSl0mZnJA9YzQ=;
 b=jV1gLHk4l2eVYvusvd5gW3Jtut1tmyL3DHqU+9/aUTwToggxyGU1hf/v2hifO3FRalRNHuEQrHkw0LBuqVkkpdD+b/XyDc0EJF2bwTilVII43ALgOopWENI8JWineHcf5VUBWdwXQmHOmOFQ+E/bpZ9YxyoVrsxhgmUL8d+e3ajiMko+UG60OzMiag0Agj0x8BYMj3voSKiIrQSxd0UG/mh3SptZPY+2OZSAoHmy2ifp1QyohoQfU3O7yeFBioFNOdz5HEuTfvquQ68W7VdaTJ3JKcD38IBqt7eeUnW8Bz8qEtiPxYde8zMBmm8jM98Ax2OpT7N+UiaCEnUSOy+ECw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3Zd3ihHkFtf/R8HHfrXHh/3b/VCtxQWSl0mZnJA9YzQ=;
 b=rNCDQ4dP7S0s0fW20PwgWqVNYC0qJqMb/SEf3UsVVMNmiDqmyvydB8LdgcVSuQZjvyXDe7B+PFOHBp4E9+6SxfV4ZytY/w3NZinMEcH1ywDEyCO40LHizefsEwLfv19zpH33QGk0aTX4TSWwbNmm1hPKlewS9TakGdWOWU4eTD8=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR05MB3482.eurprd05.prod.outlook.com (2603:10a6:7:2d::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3045.19; Sat, 30 May 2020 08:55:53 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::9de2:ec4b:e521:eece]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::9de2:ec4b:e521:eece%5]) with mapi id 15.20.3045.022; Sat, 30 May 2020
 08:55:53 +0000
References: <cover.1590512901.git.petrm@mellanox.com> <CAM_iQpW8NcZy=ayJ49iY-pCix+HFusTfoOpoD_oMOR6+LeGy1g@mail.gmail.com> <877dwxvgzk.fsf@mellanox.com> <CAM_iQpX2LMkuWw3xY==LgqpcFs8G01BKz=f4LimN4wmQW55GMQ@mail.gmail.com> <87wo4wtmnx.fsf@mellanox.com> <CAM_iQpUxNJ56o+jW=+GHQjyq-A_yLUcJYt+jJJYwRTose1LqLg@mail.gmail.com>
User-agent: mu4e 1.3.3; emacs 26.3
From:   Petr Machata <petrm@mellanox.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [RFC PATCH net-next 0/3] TC: Introduce qevents
In-reply-to: <CAM_iQpUxNJ56o+jW=+GHQjyq-A_yLUcJYt+jJJYwRTose1LqLg@mail.gmail.com>
Date:   Sat, 30 May 2020 10:55:50 +0200
Message-ID: <87o8q5u7hl.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0135.eurprd07.prod.outlook.com
 (2603:10a6:207:8::21) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from yaviefel (89.176.246.183) by AM3PR07CA0135.eurprd07.prod.outlook.com (2603:10a6:207:8::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.7 via Frontend Transport; Sat, 30 May 2020 08:55:52 +0000
X-Originating-IP: [89.176.246.183]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6422ada5-b7a0-43ba-b6bf-08d80477422a
X-MS-TrafficTypeDiagnostic: HE1PR05MB3482:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB34823763CCB8582927C6577CDB8C0@HE1PR05MB3482.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 041963B986
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4x6Hl4xkDzr7cBlZJwxsyAc8fdp+zCs7evFDpuTK9tOV386zLEPis1ro3qFAo9foKKuFkFSc++5cbww2lVd4FNxOPIBf8ja6+6JAzsdfr5VfY5GtR7adqVOphzI+FLo7FLMqSKEDRRS3BLwfRE6NlP+jO6xau6W/ESHbBESj650P4NtZOn37LXwf3E2sPIZ0gKxniJsdjvQj2O9G/59WjUHFAz+NF8Curehf3VHpUIvdfykCRUD+Novf8ExvoxXfsSXRisK1I/v2twpgyaDfxWhiXAhH0ZvJYMrYkZ4rZ7eFowudQry6ppG+mAT6lx0A/o0ZR61yN6jxga3p8KUweA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(396003)(136003)(376002)(346002)(86362001)(956004)(6916009)(66476007)(186003)(16526019)(478600001)(26005)(2616005)(6496006)(5660300002)(316002)(53546011)(2906002)(52116002)(54906003)(66556008)(36756003)(107886003)(83380400001)(66946007)(8676002)(6486002)(4326008)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 8cbOB6v8ymDF00fNOTfgY4C+FbWLTkPpE7FsZ2fUjI6eT/rWidilOmHSeb/nTrOFE7GBjfFaHw9pAdF1nAP0Ab6BrwT/3BQCA7N9qcMrGn5ajh7u+qYNKCpnFX+XFCB3g8vA55oPoaVixG/d2qFyJaVO7ZZORbM4UzPPobvm5bNnm7IRUmIySaB9Iz8P8G/vyPecNmWnwwwfnhukxIjmNG7yUZ4Sq+b1o/nXZfCrfs2cbh6betnKKmuci1wY+86NMffBQ4MP2JxVwLrTnfpxY5msFGdYMiXB0ouP3du6MuhAkxWOiqPCHHbfaBNcTAtaX70wIcfJ9EgL22yRudOSuBWv6f4Ow7J2TWLBiYX3m8m3iH2TnKTN51y/ZYIukV3jMP0WZQ/CP79T6pifGimCA5LUYzz52aTICUOIeEwDqeaq/DSXjCDfcnteKwVi75E2PHquKpYNu/xqxL3MsdSeXZXmKw19RNnZuxpUdI7FoUxVcByPnpW8aQm/p7y0ufGM
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6422ada5-b7a0-43ba-b6bf-08d80477422a
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2020 08:55:53.3178
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jq5QgmKWczVZBhJRGWIyIeS3sG0KiYzJ5L4TzEzd00W+/jNr7bpx30uWVF44BLpcOsguO0WwNhtYfQKFGlX+yw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3482
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Cong Wang <xiyou.wangcong@gmail.com> writes:

> On Thu, May 28, 2020 at 2:48 AM Petr Machata <petrm@mellanox.com> wrote:
>> So you propose to have further division within the block? To have sort
>> of namespaces within blocks or chains, where depending on the context,
>> only filters in the corresponding namespace are executed?
>
> What I suggest is to let filters (or chain or block) decide where
> they belong to, because I think that fit naturally.

So filters would have this attribute that marks them for execution in
the qevent context?

Does "goto chain" keep this position? I.e. are the executed filters from
the "position" context or not? If they keep the position, then this new
system can be equivalently modeled as simply a block binding point.

If "goto chain" loses the position, that is just a block binding point
and a chain to start on, instead of the default zero.

So introducing the position does not seem to allow us to model anything
that could not be modeled before. But it is a more complicated system.

> What you suggest is to let qdisc's decide where they put filters,
> which looks odd to me.

Ultimately the qdisc decides what qevents to expose. Qevents are closely
tied to the inner workings of a qdisc algorithm, they can't be probed as
modules the way qdiscs, filters and actions can. If a user wishes to
make use of them, they will have to let qdiscs "dictate" where to put
the filters one way or another.
