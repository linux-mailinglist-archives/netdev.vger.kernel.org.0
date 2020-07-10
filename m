Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16C8E21BCB2
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 20:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728099AbgGJSCA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 14:02:00 -0400
Received: from mail-vi1eur05on2046.outbound.protection.outlook.com ([40.107.21.46]:6071
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727046AbgGJSB7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jul 2020 14:01:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JmiajAPmsZkBBOHS7+CtQ03a2ZMd6yf9E94RWz+Ht9oy834a43xEQsRITsiahSrcJxRBeOKhcI8TAYmzrSlLgA42+E38Lhk48/numLe5BwyGv3YdrHg/vfuUoU/r3yjxDUU/RMR74Xfhhe2Va10/vs/NCUXxdnY5I/Z5YqB2VqKFjJL2hE7fyTNlL35f/k0hv0KSGm/jPvYN0wxoaUKV2N6Ld/SUuUb+x8ai1kvfa2E4m5xXxIR2bmn9e99mcFm87SjJu2mNDL9cAEgZ9m1bTLTpUD0CN5nQRNsaNLhqH9wBknuo0PIhMrDS316RaGLRZu05Tcx/kYWU1Lu2FuRJ7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h3NaE4YXqQGf0iABRwmRI4CRZ+GDygkJmiQFIwP1yRs=;
 b=NzzrCMuRUCxXPLp+DZ9Sqi19aOLM+gVQLQXSdpGlvauONgp1euFWM1PdSfcIzPSGkG9SPun6shj9sCoINpK6d7h1kvx8ano/6QFhEE0ZuWDa6LIcypKTA5sBXw+t/9u3CR13tRBzPma3l4ctZKecNmNdt6iGkB5KE3sSE+93RQRJ/HapIaWb6hjBFvYVyfS/VSvIMVnlVry7hbTa5zarHgBsFk8XuHLAnPqduzYLCjFmPSV6buKRFjlcok0OvtC4k/sD5y4Hdf1A9gjzIEQNLRs+4//NTHYLcZCBw+HdWvxWZqUNMoA/ffLDvtX5YcqNtIvxRt001rnIV6mhpe5T2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h3NaE4YXqQGf0iABRwmRI4CRZ+GDygkJmiQFIwP1yRs=;
 b=rdVDw1ltMHl2Su2BNycKrfLIaQi+bna8hj83nFByaI9Lh2U88sl4c0ansxg9bu9/tk5uUEwYGKF6YiZyZB0GvXiwvIvHaJ1pJOaD2iNEE8kgjzN3rSe3I9dYgfFhNe+HRF/vNusZ1D4ltLRTDrPbatBiqMotZ1WxlVtAlCDqs9U=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR0502MB3722.eurprd05.prod.outlook.com (2603:10a6:7:85::32) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3174.21; Fri, 10 Jul 2020 18:01:55 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6%7]) with mapi id 15.20.3174.023; Fri, 10 Jul 2020
 18:01:55 +0000
References: <20200710135706.601409-1-idosch@idosch.org> <20200710135706.601409-2-idosch@idosch.org> <20200710141500.GA12659@salvia> <87sgdzflk4.fsf@mellanox.com> <20200710152648.GA14902@salvia> <87r1tjfihg.fsf@mellanox.com> <20200710171327.GA15481@salvia>
User-agent: mu4e 1.3.3; emacs 26.3
From:   Petr Machata <petrm@mellanox.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, michael.chan@broadcom.com, saeedm@mellanox.com,
        leon@kernel.org, kadlec@netfilter.org, fw@strlen.de,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        simon.horman@netronome.com, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 01/13] net: sched: Pass qdisc reference in struct flow_block_offload
In-reply-to: <20200710171327.GA15481@salvia>
Date:   Fri, 10 Jul 2020 20:01:51 +0200
Message-ID: <87pn93fdv4.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0099.eurprd04.prod.outlook.com
 (2603:10a6:208:be::40) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from yaviefel (213.220.234.169) by AM0PR04CA0099.eurprd04.prod.outlook.com (2603:10a6:208:be::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21 via Frontend Transport; Fri, 10 Jul 2020 18:01:53 +0000
X-Originating-IP: [213.220.234.169]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7586ec6f-03d1-49b3-09fe-08d824fb5463
X-MS-TrafficTypeDiagnostic: HE1PR0502MB3722:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR0502MB372257CA85514489C40AEFE0DB650@HE1PR0502MB3722.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZfdYVcL2ljMpPFq+4LejLC3L8Xsm9kZzN+/7R9UHOGAfZCA2KQkZLVCXBBog+ZmwWcbOdtPS02awYW1WvZzedpRWUub41ykjbPKOz6z4EjRFo704a82ACGGFxuVM9jOPybqs4MYw604qRNPyaTeVFpNUh82IhCZbJ2siGpJYSEEcjVPilfvaG07MzIyzYo5CE1iGd4+8uGYcIkW210ut+etqMJ+/mCrZQLTFqQx8ekmabrn64lCKDg55ijHfjEIrnno9ed04GsO//LaSctQ3bVcDEc2czduY7RFPB3m1ZyDFDqxo9SUvLr+ftYrDGaW8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(136003)(396003)(376002)(39860400002)(346002)(107886003)(186003)(7416002)(36756003)(8676002)(26005)(2616005)(8936002)(86362001)(316002)(478600001)(5660300002)(16526019)(83380400001)(2906002)(6496006)(956004)(4326008)(6486002)(54906003)(66556008)(66476007)(6916009)(52116002)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ASGgFiklQBAqYfoxAbX6G9g2Yqvo4tjW5fhfnFLLPW4/5rBVC06X8sdKDtPna+/dnFcSaVcsme7aO0lpUjRJc9Jjmtu4u4wvF57qJ5FsgadGv3re6+GdcgIWOuHMhLedzYyysSrTgJkw7BpMJbHzWdBeeFf74mMxqVGWxr6lyJt+Qvneu8+XkZN2Igb87gJh4WAHjhmxSqe7tC4ifrURKCTefVTWJ20jsAZ6M0Zkam4lfqTKJ9jJaWnUiWkSFgYbUHhOcnsf3awCeV76kfkpwCbHMaMzaHOGQkItUzoPRQDlxNR8enyJVgI7gPYBty2EWwRNtX7G/V8GsjO4+lI/5YZD7cjnFWFg+p0sypJATopWQPk20+cRcizgLMHPWHz4xMUxHrPm3PquU2EgixSv97A8r8MIrldP4jBgywI+nAIxQ2JjnFs1PQg65hGcO3nBjp2acZayZftADQfXi3PEpgheJFJ8pbEpZJihWzq+Ir2AG7DQlkmJxiqtTbXCjLRY
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7586ec6f-03d1-49b3-09fe-08d824fb5463
X-MS-Exchange-CrossTenant-AuthSource: HE1PR05MB4746.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2020 18:01:54.6171
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WvkiL84AOwRwA7CwekzfIorgTlycFqw3FDZ73upHbRt39Gx0M227anXO405ImeZTR9McHFMf9wrAVA55PxfENA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0502MB3722
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Pablo Neira Ayuso <pablo@netfilter.org> writes:

> On Fri, Jul 10, 2020 at 06:22:03PM +0200, Petr Machata wrote:
>> 
>> Pablo Neira Ayuso <pablo@netfilter.org> writes:
>> 
>> > Moreover, the flow_offload infrastructure should also remain
>> > independent from the front-end, either tc/netfilter/ethtool, this is
>> > pulling in tc specific stuff into it, eg.
>> 
>> Hmm, OK, so I should not have assumed there is always a qdisc associated
>> with a block.
>> 
>> I'm not sure how strong your objection to pulling in TC is. Would it be
>> OK, instead of replacing the device with a qdisc in flow_block_indr, to
>> put in both? The qdisc can be NULL for the "normal" binder types,
>> because there the block is uniquely identified just by the type. For the
>> "non-normal" ones it would be obvious how to initialize it.
>
> Adding an extra field to flow_block_indr instead of replacing struct
> net_device should be ok for your new qevent use-case, right? This new
> Qdisc field will be NULL for the existing use-cases, that is what you
> mean, correct?

Yes, that is what I have in mind.

OK, I'll update the patches accordingly. Thanks!

> I still did not have a look at this new qevent infrastructure, so I
> don't have a better proposal right now.
