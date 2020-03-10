Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65591180CA0
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 00:53:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727729AbgCJXxg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 19:53:36 -0400
Received: from mail-eopbgr80042.outbound.protection.outlook.com ([40.107.8.42]:63319
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727591AbgCJXxg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Mar 2020 19:53:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kN+oTW1Z229f3Y0Uis0+1C8PaMgrreZXyqTg37mDKjKUYrtNQjTX0AuprUEy0a2nMz8sizABhUADLCtd3jbecsf4PxdrnRJhK9WpIuqlzQ7g35T+wQ2GU8GVuI8p2N7s6U2cG0uLNJ7LMCzyMqiz88+2415OzVCsJVPZ+Ju2gNpAQlpelYicMLdl2NYr1+obmRNq3qoGSw5gZlcPyBUaWgnIHKnNhsy/OSeRM2Vg/z3PILiIiC5JUTV9iN4Ldh0DB5Y6GehXsTv3iFj9hv51IWEtlx1Y3iIFSbUnx5r1gqB2jHiqxRueUdADYIbFHZN9FFeIUsU76Kkq4ttEWgFNdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oWi5Gh8gsjbrRPqjTiBUwBP8jBI6IsVAYAuaBSooPtY=;
 b=IackcMiXsCvGBtz7TZJ13DeHSg7Amrope8fiT7Ga9aAh4gR7i9voKeAQr64wGjAbFi9kPhT53S2FX5SQNKgFF7fmed+lVxOCe0OH4WJZda+ZWQfW7Fh1qkYpEy+YOJ1BEdgtvlij70aMiDsCodCyC67u5EtFCcM8XwSX8LqaVNi2UI8FaVS9u+Je1+UiPYYX1PhX++TPMTuXJr3hlAbC4256Yp6rPHgXSx+hZgXJgw+0HP5hq7cUImKJ0Aa93/NkXBC4BRAlMagS9p/oNmJS6KLGx4uz+Y3mmQ4qKtWvL0Pz2eJV05fF9+BL5mQzD9+grlyYkUYymFsabCJ2VV/hEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oWi5Gh8gsjbrRPqjTiBUwBP8jBI6IsVAYAuaBSooPtY=;
 b=liQp1f8cpYUUAoNQs4JANUrUlPEZeR/9qR5Nxz79Uc9f57NyAJW+on+UG5mGY+5fZ92UgzVR920rhM7F+LdM+3UuQgIzcGngZoy1OlASwUk2ChSNEHPuGpYd7T4+SMFS1vsG9Kds3Hg2Z3MQslcK9kW1J7n5v7GpIIsH9Dr8Jbk=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (20.176.168.150) by
 HE1PR05MB4587.eurprd05.prod.outlook.com (20.176.166.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.15; Tue, 10 Mar 2020 23:53:33 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::c146:9acd:f4dc:4e32]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::c146:9acd:f4dc:4e32%7]) with mapi id 15.20.2793.013; Tue, 10 Mar 2020
 23:53:33 +0000
References: <20200309183503.173802-1-idosch@idosch.org> <20200309183503.173802-3-idosch@idosch.org> <20200309151818.4350fae6@kicinski-fedora-PC1C0HJN> <87sgigy1zr.fsf@mellanox.com> <20200310125321.699b36bc@kicinski-fedora-PC1C0HJN> <87mu8nyhlw.fsf@mellanox.com> <20200310160052.72e7e09b@kicinski-fedora-PC1C0HJN>
User-agent: mu4e 1.3.3; emacs 26.3
From:   Petr Machata <petrm@mellanox.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org,
        davem@davemloft.net, jiri@mellanox.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 2/6] net: sched: Add centralized RED flag checking
In-reply-to: <20200310160052.72e7e09b@kicinski-fedora-PC1C0HJN>
Date:   Wed, 11 Mar 2020 00:53:29 +0100
Message-ID: <87lfo7ydfq.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: ZR0P278CA0026.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1c::13) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from yaviefel (89.176.246.183) by ZR0P278CA0026.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1c::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.15 via Frontend Transport; Tue, 10 Mar 2020 23:53:32 +0000
X-Originating-IP: [89.176.246.183]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: aa566bca-702e-4cdf-aecf-08d7c54e3d8e
X-MS-TrafficTypeDiagnostic: HE1PR05MB4587:|HE1PR05MB4587:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB45878ABA0653914CDA0C6598DBFF0@HE1PR05MB4587.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 033857D0BD
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(396003)(136003)(39860400002)(366004)(189003)(199004)(186003)(36756003)(6496006)(6916009)(478600001)(107886003)(8936002)(66556008)(2616005)(66476007)(5660300002)(66946007)(26005)(4326008)(316002)(956004)(86362001)(6486002)(81156014)(2906002)(81166006)(8676002)(16526019)(54906003)(6666004)(52116002);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR05MB4587;H:HE1PR05MB4746.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XNClAwy7o3pIwtrd6H2K+hoNuvOUJHyEoUA5ogICQNubXhIDM4J0vM3qJ5/jXvBOScyhUL/IhptVZ0PJQfPfCCGIKiIlr6MWlaskAdlHnJEMIP57Y+mpSWW27oLSHKlaSBW4+ygyeLEwO8q60HexpQwcjjw5nDcgo+RN/2dR1LedETOcSId4hIjainTlpwVDLL5hl+jaMAXHcl+lUt5WBniSg/Fyj+rqSaZssd+jQbpUtW2omMTWwAPWAUGG0W3kWewdywvVicRoFEO01OQ/Q78QL5lRShnFq6q7ETuJ9105gn/DIr4hOk6Rwf35d74Qlxh7tqih1yqR3l4BlD4m9M3Qxp4XX4kg0JddT5FUVxm7z+UW5VFgmzxBwkKmTxeUtS7HgMy/y8xAF8x99pBcFwPDptOm+j32CFrWRr/Vh17IRio2T0mPxpCZsNbogVlG
X-MS-Exchange-AntiSpam-MessageData: V4uIYmy8xZGub6yBv9qxvi/dxWaHt5v/TvCEKVxns3gnLpGtfNvb17AzjSAPnEAxFN6sjNvOZAOuBJXlD5ttbd84O77pBcG9fbdD6Zmsp/+UXWGxuG2DLBq2eMz6yXt704UxJqmVYdaHLNA2uaF6zA==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa566bca-702e-4cdf-aecf-08d7c54e3d8e
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2020 23:53:32.9335
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IjGsWYmd6xqFodBYmiS119PgDJ+3TShWH3m+tlypDmaS47Df2juaVgQTuJB+X/jBNf9mtMY0ke5dz2r5qy0pIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB4587
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Jakub Kicinski <kuba@kernel.org> writes:

> On Tue, 10 Mar 2020 23:23:23 +0100 Petr Machata wrote:
>> Jakub Kicinski <kuba@kernel.org> writes:
>> 
>> > On Tue, 10 Mar 2020 10:48:24 +0100 Petr Machata wrote:  
>> >> > The only flags which are validated today are the gRED per-vq ones, which
>> >> > are a recent addition and were validated from day one.  
>> >>
>> >> Do you consider the validation as such to be a problem? Because that
>> >> would mean that the qdiscs that have not validated flags this way
>> >> basically cannot be extended ever ("a buggy userspace used to get a
>> >> quiet slicing of flags, and now they mean something").  
>> >
>> > I just remember leaving it as is when I was working on GRED, because
>> > of the potential breakage. The uAPI policy is what it is, then again
>> > we probably lose more by making the code of these ancient Qdiscs ugly
>> > than we win :(
>> >
>> > I don't feel like I can ack it with clear conscience tho.  
>> 
>> Just to make sure -- are you opposed to adding a new flag, or to
>> validation? 
>
> They are both uABI changes, so both.
>
>> At least the adaptative flag was added years after the
>> others in 2011. I wasn't paying much attention to kernel back then, but
>> I think the ABI rules are older than that.
>
> Yes, but some (e.g. TC subsystem) didn't really care much about those
> rules until more recently.
>
> The alternative to validation/adding flag in place is obviously to add 
> a new netlink attribute which would be validated from the start. Can you
> give it a try and see how ugly it gets?

Yeah, I'll give it a stab tomorrow.
