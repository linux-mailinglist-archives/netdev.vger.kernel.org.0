Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 993401D9AFB
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 17:17:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729103AbgESPRd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 11:17:33 -0400
Received: from mail-eopbgr70082.outbound.protection.outlook.com ([40.107.7.82]:48246
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728775AbgESPRc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 May 2020 11:17:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YP1EsDQzDiG+Ovc/Fpb3WRCvK3rsg8ACXT1p0ShHranCbQ4/Pi9gJrx/JVru3kcSjEJS480epG887iDmrkTsfulIDNP1x4LMVx+bTixy8vgOgX7HxV+3LmcF1XsGwAfRXLWMker26/ypDGyP2GY/m2KiC4l/89bZUcu4qNfrPYZT0C1R7ddKaH+VpAGlTcR6zBBiWI4DNNNXqpXaI7wOuLtRCCArFEv/G0/30+VxEVlN+s20cPEOTKeip42bXDPFq8m+fyyxC9xJ4PoMgI/Pe72rhlm9yHijxHp4dnNjCOE/Pi1a3kdBIonH2ALshW/yC463KuzUBcyUb2Ho++rhRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gYR/kGtaSgAcJbP+YmY6pvMhuVELQgW4djHCrbANVd8=;
 b=b31yosc1EKa2jOzakma007mTi6/NPHby2binfgf7P5b/FCYYfFNMNQLyzKjml0I6RUaeEGDhu2OygwR0m2o4/XkLxP4yiwh13vJa2Lh+NPRqUiQbF5RKraLHN7QKdXq/fMSZew2Q+7dGgE/BDargGxnVbM2jDDqDIDqC4D2vl/Vdd9a8SFuBq85GYtmJOWpxvjxtMUUNrJAW5pdV5pQtulnCRZFkFa4VpAdn9EaufyUdMQGkpstjX/BUZDOS0iBAj8S54FnP2AxwGab6oQ6WRrZqNig5/ihsTpKlBtmbQw6Txs+5l9ky25pYnFc/PVErkRJ10DkzjlFWWwuZE+NgWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gYR/kGtaSgAcJbP+YmY6pvMhuVELQgW4djHCrbANVd8=;
 b=SmAnkMOAax0p4yY5KmY3YaPXc1UgZMGysrt13q9YgVDxZVTaz/L1shu76cz6epHduZF4Hdf8baShfK4p2gvAG4Yf1QNZbSVxAiweVc8+uPtmHqx1Nu/9famTrZ6bGKTL71C+igqWH+BP2zA7+5bougFJyL12afzgLN1zFN2C+fo=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=mellanox.com;
Received: from AM7PR05MB6995.eurprd05.prod.outlook.com (2603:10a6:20b:1ad::15)
 by AM7PR05MB6852.eurprd05.prod.outlook.com (2603:10a6:20b:18e::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20; Tue, 19 May
 2020 15:17:28 +0000
Received: from AM7PR05MB6995.eurprd05.prod.outlook.com
 ([fe80::3903:9c1e:52e0:d74e]) by AM7PR05MB6995.eurprd05.prod.outlook.com
 ([fe80::3903:9c1e:52e0:d74e%8]) with mapi id 15.20.3000.034; Tue, 19 May 2020
 15:17:28 +0000
References: <20200515114014.3135-1-vladbu@mellanox.com> <649b2756-1ddf-2b3e-cd13-1c577c50eaa2@solarflare.com> <vbfo8qkb8ip.fsf@mellanox.com> <1581796d-2f28-397b-d234-2614b1e64f8a@solarflare.com>
User-agent: mu4e 1.2.0; emacs 26.2.90
From:   Vlad Buslov <vladbu@mellanox.com>
To:     Edward Cree <ecree@solarflare.com>
Cc:     Vlad Buslov <vladbu@mellanox.com>, netdev@vger.kernel.org,
        davem@davemloft.net, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, dcaratti@redhat.com, marcelo.leitner@gmail.com,
        kuba@kernel.org
Subject: Re: [PATCH net-next v2 0/4] Implement classifier-action terse dump mode
In-reply-to: <1581796d-2f28-397b-d234-2614b1e64f8a@solarflare.com>
Date:   Tue, 19 May 2020 18:17:24 +0300
Message-ID: <vbfwo58vtrv.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: FRYP281CA0004.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::14)
 To AM7PR05MB6995.eurprd05.prod.outlook.com (2603:10a6:20b:1ad::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from reg-r-vrt-018-180.mellanox.com (37.142.13.130) by FRYP281CA0004.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23 via Frontend Transport; Tue, 19 May 2020 15:17:27 +0000
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9b7543ff-8057-404e-f83f-08d7fc07be70
X-MS-TrafficTypeDiagnostic: AM7PR05MB6852:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM7PR05MB68521C95FFD20687E6CF6A3FADB90@AM7PR05MB6852.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 040866B734
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ud4MpO2ipFAVVPyx0rCXem19YpRydbBWx6WX4WMKT54QAiZNDzMS4zdrUBsOssk2Y0+vDQ9oImSoyOez1PpXHuX0lgdEi8L6xI16WDheTGUN5OB5aRP420ik8QmHdGv3tglTEEmNlMK9MC644wI7LVVKCq+EDchqaXiMRfwk8JEIlkZJqeXHgyX5Vj4W43VCQr7/7zf1Ek3HtDCSERakllLGPBGDU5bRIKbrIwGubuXl/hFwE9AuI02r+ZGlgcVX1VNF5vCIyUs201wFJpUZ8SpmhWTQ3VHNV15DquctSzqfIXDlx81o71U67Q0dzDwm9kZyup8TxQL7fU4+UT9IblwcAesLXPcSNacfahjiIqP/DkMhhsIuJHLho62Z81bDd+ylH+9QqIMWfFwvlNtB7uxN9nT715roGdZ314uDRpf+BYbYzY7a7ipW9TW6M5Vo
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR05MB6995.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39850400004)(136003)(396003)(346002)(376002)(366004)(8676002)(53546011)(2906002)(16526019)(2616005)(956004)(66556008)(66476007)(6486002)(66946007)(4326008)(36756003)(6666004)(7696005)(316002)(478600001)(26005)(6916009)(86362001)(8936002)(5660300002)(186003)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: oKwFnP2o4/UHcrmxO94IByngccoinRKQsOhzox8UPAMj03R/NiGSCwmoq4ed0r9Zmdp3/gD/k/cNYHlxwP0MNTmEaPYwfs5FRxkF9Nrc7aOBE3aP4tTwtbhWjBLKG229NJZwfCnK2Uef8xz3SjvVXN0uM1ha6HVTMapd62PHhVDSRfRwinRALgegBE6yWsmZHML3b4t5H9Wk0bM3iyJdSPjCRgHUcMFURP13413pEPnz3aktOON9L7tZuBexjTCeuY4uW8uh3Tvs+cnX+sBQH1sx86w8wS9JmJA2DiNPbr0Q6OST9ptiFD+LHaxryOfQJdXQ8AFNYMDt/wZFBuf125mcCV6ZsYRC7zGS0EzwdR43YTAqWtv/mtXX56sKjq8lDpCkrEXlTv0hYfesfRvjM9Du9RRNVWcNpRsEIQE1vMe7QYB/rKOjr/5ST6EMBVbhEMjPJcb8fYVLix9Fp2e/VjX09srrT0zK6USGJKY1GqTUtNK2VPmJsVodnRBPmnqM
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b7543ff-8057-404e-f83f-08d7fc07be70
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2020 15:17:28.7703
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xiuctJISe4roSXawBXFdmJYabs5eUzdOBrzDKlQpGFjQJ9aX4owY9Hd0MP5dO2iEXxmLdyW4qNkR54mX480dzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR05MB6852
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Tue 19 May 2020 at 17:30, Edward Cree <ecree@solarflare.com> wrote:
> On 19/05/2020 10:04, Vlad Buslov wrote:
>> On Mon 18 May 2020 at 18:37, Edward Cree <ecree@solarflare.com> wrote:
>>> I.e. if next year it turns out that some
>>>  user needs one parameter that's been omitted here, but not the whole dump,
>>>  are they going to want to add another mode to the uapi?
>> Why not just extend terse dump? I won't break user land unless you are
>> removing something from it.
> But then all terse dump users pay the performance cost for thatone
>  app's extra need.

Yes. However reducing amount of data per filter is only part of
optimization. Skipping fl_dump_key() in flower and completely omitting
calling any of the tc_action_ops callbacks is also a major improvement.
So as long as outputting new parameter doesn't require calling one of
those (and it shouldn't, otherwise the parameter represent something
very cls or action type specific) it shouldn't impact performance
significantly.

>
>> - Generic data is covered by current terse dump implementation.
>>   Everything else will be act or cls specific
> Fair point.
> I don't suppose something something BPF mumble solve this? I haven't
>  been following the BPF dumping work in detail but it sounds like it
>  might be a cheap way to get the 'more performant next step' that
>  was mentioned in the subthread with David.  Just a thought.

I'm very interested in ideas how to use BPF to improve dump performance
so any comments/suggestions from resident BPF experts are welcome. Don't
think it will as fast as what David suggested though.
