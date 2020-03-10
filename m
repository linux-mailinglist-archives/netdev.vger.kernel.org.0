Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92B2117F411
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 10:48:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbgCJJsd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 05:48:33 -0400
Received: from mail-eopbgr20056.outbound.protection.outlook.com ([40.107.2.56]:50691
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726211AbgCJJsd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Mar 2020 05:48:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YEGbhYzbxSg8ongkswF5tJTvcc8c4QYx0RNlk8q7iUJvwjLGZaNBaG25PbJHqbqFc1n0Eh20cTJdAYlmRhpoQKOC6yYjmiTfw7c/bkLpXM5L6sm8Mp/iHzN6PFmQ4BEEGkvYPJF+R2O1pdB9fk9P/aogqUth5aTy42ckhoBOM+LqAF5kuUNJueMbe/IC8asjcyIBKBGrY1sQPBtI/cpDowsfKThE6fsKXuK/WP9gRwU1ng/zDLn3WICCmKdzbuEehhawVozQs4/TGmKdl+3lq7+mUjsdIAzHftl2xNaI019R773wfP00dXlj5hNwdOPb/3PzoRCarPUtcivShNmyIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TU62Sxm/ueQPAy+fBcrEYScCpNh3qZlsnYedtN+o/4M=;
 b=BFyDZgSViVh3RkEOvqLXeqQhqJcCDLA30AgwEn42bClAbWFmZc6B2X3qiza74EHk4wuBzNzqrRrm8lf7IMZcl4Tg3B+xNvlWpWuCns4A/Ll4PTExfsgJ/srnOiV2cwoED2IJCDMULc+Aju6XRm+GK+Z4CA3lac3BLR+WL3VA1obi15baKkeZsAbhriBelSXLroVhZiGvv3JJg7u8ADVj3QW4kHMf+D/tvojhXF98412Fnh8GE5/CsKulSJ01m1Jqnjulo7mg+PJxxAgUarAClGogjqVOEa080LGdJpUXXatM7AIHtWFSarbMiZVWI911fB1r0XZjyQWPwyZ4Hb4Z8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TU62Sxm/ueQPAy+fBcrEYScCpNh3qZlsnYedtN+o/4M=;
 b=bReAsUPLflp4akA/YOpNnC9jH2prllbbAaSJyvtJNMPvXgH+Z9xW/bNo7wrpIO+jdwqn/gu49DxEC4hZ9M4O3e1PdI2SG+aULA8AzaszGzBGZ8Raw+kBelRVRaauCUF74NKgrNSgoXlrey/PD8K1UbfsWlCixLiUd6nGNYw4HNM=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (20.176.168.150) by
 HE1PR05MB4635.eurprd05.prod.outlook.com (20.176.164.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.17; Tue, 10 Mar 2020 09:48:26 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::c146:9acd:f4dc:4e32]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::c146:9acd:f4dc:4e32%7]) with mapi id 15.20.2793.013; Tue, 10 Mar 2020
 09:48:26 +0000
References: <20200309183503.173802-1-idosch@idosch.org> <20200309183503.173802-3-idosch@idosch.org> <20200309151818.4350fae6@kicinski-fedora-PC1C0HJN>
User-agent: mu4e 1.3.3; emacs 26.3
From:   Petr Machata <petrm@mellanox.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org,
        davem@davemloft.net, jiri@mellanox.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 2/6] net: sched: Add centralized RED flag checking
In-reply-to: <20200309151818.4350fae6@kicinski-fedora-PC1C0HJN>
Date:   Tue, 10 Mar 2020 10:48:24 +0100
Message-ID: <87sgigy1zr.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0085.eurprd07.prod.outlook.com
 (2603:10a6:207:6::19) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from yaviefel (213.220.234.169) by AM3PR07CA0085.eurprd07.prod.outlook.com (2603:10a6:207:6::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.5 via Frontend Transport; Tue, 10 Mar 2020 09:48:25 +0000
X-Originating-IP: [213.220.234.169]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 400062f6-902f-4e43-69e7-08d7c4d82e48
X-MS-TrafficTypeDiagnostic: HE1PR05MB4635:|HE1PR05MB4635:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB463575AFF91EA9CCBC52C2A2DBFF0@HE1PR05MB4635.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 033857D0BD
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39850400004)(136003)(346002)(366004)(376002)(199004)(189003)(6496006)(478600001)(36756003)(2906002)(8936002)(81156014)(81166006)(86362001)(8676002)(316002)(52116002)(66476007)(6916009)(6486002)(2616005)(107886003)(66556008)(5660300002)(26005)(66946007)(4326008)(956004)(186003)(16526019)(54906003);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR05MB4635;H:HE1PR05MB4746.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YNUVWbu+sA38BUKI03z4Kq94dP1onWvSc+YELstjlBCuYOh+uB33dBFFu7SKKn5S/IvwSB26rgPR5DkV3iy22SuGm8ZJlJxpYvaisabbO5VorC9ImdPvFQeC/T6ryePP/Sl5aubH67vR0lyPhxsCjJi1Hzi39Ynhhkrr4nH/bbj09vhWCXVgssavwpGS/OGoFx83R2yHsNaoICmmPIe+yvJvgxQWSfrf62offSZ0HGgCKClaC3TBmx7xl5pcBJXesB1kVIha/aOWkADgqe7xbp49S5qEF0j0rKY4EKSfcEPhIViQcmqG7cid141LROQ/rnU+MPNj1KxNPNZtcAzNtvSgUmDc8lUkeUMH8SZhZzhFikqwlSHxIiq0HXWFOaf1tcLpW85ZsYUXWX4lC/Ex1kRohqfbnvCQD3XL8eqbEY64OZn0mc5U+bl09JXsWKP4
X-MS-Exchange-AntiSpam-MessageData: qodRSAWU0l8AlJ+x29EJS/rdIjPtyX8pNxz5WoAyj4htzZmgs8Iw38LpjtvEnKZIKdb1W8Yd7CJDazMDtkQlrrMdpHcga9U+eG3Y5bv9EabkApGjyFwc5AMVu18pTSkDIbj2Fp4FFm1ZPEEp+bT++w==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 400062f6-902f-4e43-69e7-08d7c4d82e48
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2020 09:48:26.6960
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0CfrBC6LUlDhZAwMdoKlWuLZyHZ3OmjjWeon/OJvSYO+or/mL7GFZY4jBL/1Ia/Gl1w2N5Y2KPxxd6Y+QS0qwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB4635
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Jakub Kicinski <kuba@kernel.org> writes:

> On Mon,  9 Mar 2020 20:34:59 +0200 Ido Schimmel wrote:
>> From: Petr Machata <petrm@mellanox.com>
>> 
>> The qdiscs RED, GRED, SFQ and CHOKE use different subsets of the same pool
>> of global RED flags. Add a common function for all of these to validate
>> that only supported flags are passed. In later patches this function will
>> be extended with a check for flag compatibility / meaningfulness.
>> 
>> Signed-off-by: Petr Machata <petrm@mellanox.com>
>> Acked-by: Jiri Pirko <jiri@mellanox.com>
>> Signed-off-by: Ido Schimmel <idosch@mellanox.com>
>
> The commit message should mention this changes behavior of the kernel,
> as the flags weren't validated, so buggy user space may start to see
> errors.

True, I can add that for v2.

> The only flags which are validated today are the gRED per-vq ones, which
> are a recent addition and were validated from day one.

Do you consider the validation as such to be a problem? Because that
would mean that the qdiscs that have not validated flags this way
basically cannot be extended ever ("a buggy userspace used to get a
quiet slicing of flags, and now they mean something").
