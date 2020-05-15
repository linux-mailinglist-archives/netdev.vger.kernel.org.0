Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 143A31D558F
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 18:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726695AbgEOQHo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 12:07:44 -0400
Received: from mail-co1nam11on2110.outbound.protection.outlook.com ([40.107.220.110]:43617
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726266AbgEOQHn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 12:07:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SzlGEku6ScdipE5KD4uIicBoC8UD0aggPcKYSVJwUEtdb+4uOP2fN7qCnIbngS07ngypus1VXoaKwnd7m9MtqWh3XAccinnO4u4D2pjyv2O2JbiY6RsG2yPLpzxQfVq7eazG8q1GLLryJxv4xrFCXeY2pcEl6gd7fkR9FoAfbQSYZ7oWkgR08+S4t7/dJKY4HLIejG5tru/9iQDqPFiD2oWau46+eUAI4XiuXqA1lLvPCsY64jX3gmrPRRFpJvlkfi20qVC4xN5o4JdS28/0XCb7ur3y6JYfxHjG+Gyokf9nvDf5F3HeDFVNsDyBDZFZSeJsJwnypNb5xDkLMnTYIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rb2YHeO1+41Q8kQoJ1JKWwfs5rhebj8xlS1EZNJuMeY=;
 b=WquS58QhoP6Q504NcUvCkz3yZDHlEIv/Bdi60w2uzGw3l3RpEj+R7UAVCLMB1TaTdS130fc0iTEtAD56BDrBTxI6MvIRDZx3njuHay76/P4+JoF6NDP1SN5A1hETj+ftuE0zo+n3hKdpN60V1T2iqdmyIgez8RhvSedXjggVrO02w/MPffndDK61wE68SCrthy7T+X1hb/ONfHnJPH3Wv1qdp64tOEd8eVjujV1+wTQmI9Pujf7Eg2f/+OQBPLhHB7gPRGt7eD2/LX+dIMy+wjChzRsAtIospDANuozhieMsbTTZcAoXtbGu7qwsYmhqdOjA3w9TBQg2bapO11KKYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 204.77.163.244) smtp.rcpttodomain=infradead.org smtp.mailfrom=garmin.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=garmin.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garmin.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rb2YHeO1+41Q8kQoJ1JKWwfs5rhebj8xlS1EZNJuMeY=;
 b=VyNgLi6OiJZyDyeqCrtJm+sam5o/qtuXqjfRnJ74qWbpt8Sv2tICuds0pHxDyEMGIV3k3Olx8aTlakh8z1lyhJPHnI9lrnb9aqwkBzAwye8MbqrOLH2/bioIHZl+SyEoQLMbvntWamd7dztUlP2JT2lAu1B4qpj//2KdfhRXrxJdLIS8YFBtIcT+oeHh/1o6B/uMI+Q75Bma6ouyCDiv/BxeA6fzL0ygLPjsUhwYguRN2WSiyJQNnxO1ldQajzjFjs4orG5HYak29M92+FaWDIgU4/uYPlrLU+a3lX39CBWSORpjA3iMj3s9MKMch1vcvQL8eSEBMPXmO5uhU4ObgA==
Received: from BN6PR08CA0079.namprd08.prod.outlook.com (2603:10b6:404:b6::17)
 by BYAPR04MB5480.namprd04.prod.outlook.com (2603:10b6:a03:ec::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.26; Fri, 15 May
 2020 16:07:36 +0000
Received: from BN7NAM10FT052.eop-nam10.prod.protection.outlook.com
 (2603:10b6:404:b6:cafe::36) by BN6PR08CA0079.outlook.office365.com
 (2603:10b6:404:b6::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20 via Frontend
 Transport; Fri, 15 May 2020 16:07:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 204.77.163.244)
 smtp.mailfrom=garmin.com; infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=pass action=none header.from=garmin.com;
Received-SPF: Pass (protection.outlook.com: domain of garmin.com designates
 204.77.163.244 as permitted sender) receiver=protection.outlook.com;
 client-ip=204.77.163.244; helo=edgetransport.garmin.com;
Received: from edgetransport.garmin.com (204.77.163.244) by
 BN7NAM10FT052.mail.protection.outlook.com (10.13.156.198) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3000.19 via Frontend Transport; Fri, 15 May 2020 16:07:34 +0000
Received: from OLAWPA-EXMB8.ad.garmin.com (10.5.144.18) by
 olawpa-edge4.garmin.com (10.60.4.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1466.3; Fri, 15 May 2020 11:07:33 -0500
Received: from OLAWPA-EXMB7.ad.garmin.com (10.5.144.21) by
 OLAWPA-EXMB8.ad.garmin.com (10.5.144.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Fri, 15 May 2020 11:07:33 -0500
Received: from OLAWPA-EXMB7.ad.garmin.com ([fe80::68cc:dab9:e96a:c89]) by
 OLAWPA-EXMB7.ad.garmin.com ([fe80::68cc:dab9:e96a:c89%23]) with mapi id
 15.01.1913.007; Fri, 15 May 2020 11:07:33 -0500
From:   "Karstens, Nate" <Nate.Karstens@garmin.com>
To:     Matthew Wilcox <willy@infradead.org>
CC:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Jeff Layton <jlayton@kernel.org>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        Helge Deller <deller@gmx.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        David Laight <David.Laight@aculab.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-alpha@vger.kernel.org" <linux-alpha@vger.kernel.org>,
        "linux-parisc@vger.kernel.org" <linux-parisc@vger.kernel.org>,
        "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Changli Gao <xiaosuo@gmail.com>,
        "a.josey@opengroup.org" <a.josey@opengroup.org>
Subject: RE: [PATCH v2] Implement close-on-fork
Thread-Topic: [PATCH v2] Implement close-on-fork
Thread-Index: AQHWKtGJQW28Wposd0uF0sb7I7R5yaipTiDw
Date:   Fri, 15 May 2020 16:07:33 +0000
Message-ID: <5b1929aa9f424e689c7f430663891827@garmin.com>
References: <20200515152321.9280-1-nate.karstens@garmin.com>
 <20200515155730.GF16070@bombadil.infradead.org>
In-Reply-To: <20200515155730.GF16070@bombadil.infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.50.4.7]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25422.001
X-TM-AS-Result: No-19.858500-8.000000-10
X-TMASE-MatchedRID: cxtZ8fwm3r9Q6n/rRNAUKh3IeIGfKJW/9zefYQcHZp80C8Dp8kkTtYpb
        wG9fIuITJtTnAJs7jlD7RATI82Ncfwop/TpjK6C/U9ht8cPjV46UctRw0zzl2pWjuQbzw7c3VQU
        8VbWsRfi//eXS1ju9FBJ13g2/cvC1tr5RCqy4xhi3RxL+7EfzsOEEkuVtb8qfLraGNlLRahhGvu
        BXbruwYtnDYS1q+6iCYussib1CaMX8XF85VELdKHVQSHOJP6nQrdWvfWjvttlWw5sMt9VCxBrvY
        Yqm6deIsOgv3K25H2mLi6FD5GEKrSOUJST4unTHrQcmzcV8ovw9KBt6tnyFcrLbmp+EnGIKPQj+
        kfsj8xH5iQXL0X4jvhQHoijpT9e5vsHryaMJEsEiJT2HHpbp5vioIsi7Sa0gBaq8VaDdeDo9f7m
        Q7xYc42xgOzAu2kUet2ay5krgMg6ZMrhqeTBW6jYpyzRTw0APfYrr1p9yfCpe0yaZepF+XwzKIl
        W5ZSzaAEiNSxzGretaIVXDa1zIKPoQshw0oTdHTauf2PrRb1sj9+iycgC4IFUPHvwdQbxozkT37
        q8H81dc+mvQF6nOfX8mA3sDDq0A5MIx11wv+CPiRhduhvElsucjNHNZLY/T
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--19.858500-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25422.001
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:204.77.163.244;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:edgetransport.garmin.com;PTR:extedge.garmin.com;CAT:NONE;SFTY:;SFS:(396003)(39860400002)(136003)(376002)(346002)(46966005)(966005)(426003)(36756003)(316002)(4326008)(8676002)(8936002)(336012)(2616005)(2906002)(478600001)(26005)(86362001)(53546011)(70206006)(70586007)(7696005)(108616005)(24736004)(7416002)(356005)(5660300002)(47076004)(7636003)(6916009)(54906003)(82310400002)(82740400003)(186003);DIR:OUT;SFP:1102;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eb32ece5-e902-4075-ad7c-08d7f8ea14c7
X-MS-TrafficTypeDiagnostic: BYAPR04MB5480:
X-Microsoft-Antispam-PRVS: <BYAPR04MB5480ADF876F120274C69F16A9CBD0@BYAPR04MB5480.namprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 04041A2886
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t31PRUZC4V1rpC+NyghHQQfw7j2Q12P1JYCujfVP2waP4t3IE8o/pcDPAduMC9OFF+GGmnnlZIFiUgv/oplvSPUfiy99DNkwLxqeTdLYOMymN81OucQbIK0Yc3Fg+6YkNF8Fa1cZlcqwEEt4Y3U/6op2g88QWXzY5rFYTHDXkY9Mp3gppq2wVAglW9CPZvQyml5dsg3SGv3qV0QrCxKi2sxoOnPApgTD1TQpSQlkYMVTb00JOdDPdkc5L84nCBK9m7LVtW8zIeSocVSL8dVy6kvE0exOvj8/vUBKjVNbjgBKaTm/E5Lpyc50Ux/6kXhtx5BmQKyWDoosIUL3lKj6R9zQ0Nd5AZ4dyP7LcLIA4Wp8VEysnO/Swp3JxLLfyn4MzCi8reWWINHcMCrHlHOdxcv7OpBUmi6AoUWAKgm4anONPq4zguX/lbwGd+Ypzbuc3AJYiwEsBb6EHAmCOI3fibKIje7Xdknf2eqXibjkpAc5D1UWKY6nLribO9pKgkBqkWq0xlqUmtOUdZ3I02+3abDyBTFPWs21+Rbljz1kHE6/39cVt2GqKK0p4aWINbU+PCWG/ORgP7PkU8hDOvn6gnV0eYnQutQLeUCwTal/S3I=
X-OriginatorOrg: garmin.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2020 16:07:34.9821
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: eb32ece5-e902-4075-ad7c-08d7f8ea14c7
X-MS-Exchange-CrossTenant-Id: 38d0d425-ba52-4c0a-a03e-2a65c8e82e2d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=38d0d425-ba52-4c0a-a03e-2a65c8e82e2d;Ip=[204.77.163.244];Helo=[edgetransport.garmin.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5480
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Matthew,

What alternative would you suggest?

From an earlier email:

> ...nothing else addresses the underlying issue: there is no way to
> prevent a fork() from duplicating the resource. The close-on-exec
> flag partially-addresses this by allowing the parent process to
> mark a file descriptor as exclusive to itself, but there is still
> a period of time the failure can occur because the auto-close only
> occurs during the exec(). Perhaps this would not be an issue with
> a different process/threading model, but that is another discussion
> entirely.

Do you disagree there is an issue?

-----Original Message-----
From: Matthew Wilcox <willy@infradead.org>
Sent: Friday, May 15, 2020 10:58
To: Karstens, Nate <Nate.Karstens@garmin.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>; Jeff Layton <jlayton@kernel.o=
rg>; J. Bruce Fields <bfields@fieldses.org>; Arnd Bergmann <arnd@arndb.de>;=
 Richard Henderson <rth@twiddle.net>; Ivan Kokshaysky <ink@jurassic.park.ms=
u.ru>; Matt Turner <mattst88@gmail.com>; James E.J. Bottomley <James.Bottom=
ley@hansenpartnership.com>; Helge Deller <deller@gmx.de>; David S. Miller <=
davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>; Eric Dumazet <eduma=
zet@google.com>; David Laight <David.Laight@aculab.com>; linux-fsdevel@vger=
.kernel.org; linux-arch@vger.kernel.org; linux-alpha@vger.kernel.org; linux=
-parisc@vger.kernel.org; sparclinux@vger.kernel.org; netdev@vger.kernel.org=
; linux-kernel@vger.kernel.org; Changli Gao <xiaosuo@gmail.com>; a.josey@op=
engroup.org
Subject: Re: [PATCH v2] Implement close-on-fork

CAUTION - EXTERNAL EMAIL: Do not click any links or open any attachments un=
less you trust the sender and know the content is safe.


On Fri, May 15, 2020 at 10:23:17AM -0500, Nate Karstens wrote:
> Series of 4 patches to implement close-on-fork. Tests have been
> published to https://github.com/nkarstens/ltp/tree/close-on-fork
> and cover close-on-fork functionality in the following syscalls:

[...]

> This functionality was approved by the Austin Common Standards
> Revision Group for inclusion in the next revision of the POSIX
> standard (see issue 1318 in the Austin Group Defect Tracker).

NAK to this patch series, and the entire concept.

Is there a way to persuade POSIX that they made a bad decision by standardi=
sing this mess?

________________________________

CONFIDENTIALITY NOTICE: This email and any attachments are for the sole use=
 of the intended recipient(s) and contain information that may be Garmin co=
nfidential and/or Garmin legally privileged. If you have received this emai=
l in error, please notify the sender by reply email and delete the message.=
 Any disclosure, copying, distribution or use of this communication (includ=
ing attachments) by someone other than the intended recipient is prohibited=
. Thank you.
