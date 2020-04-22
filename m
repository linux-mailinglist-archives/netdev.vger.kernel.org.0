Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 177261B495E
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 18:03:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726552AbgDVQC7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 12:02:59 -0400
Received: from mail-bn8nam11on2125.outbound.protection.outlook.com ([40.107.236.125]:47232
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725980AbgDVQC6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Apr 2020 12:02:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hozb55Mf9KCiSGwmvZnMV4bSAG97UBEQmLCd+t8ZuG3Kc0FfmZrkND68uOqX9dTFZCeSwaWS5q7hUjWCRo3YnoK/+qrobnp2wCdkgMZW1wqgALUL0mRCB+kn7Fcn8+tueSzHsdCQ2egH1732CJjn+mLkizuu4c460OfScvCcS5F9w87QG289Hhk6yntYm30nFZ2pygPKJ7FJPYVYqMNBBm/MdMLdsI2d8Kb5lKjVz5AU5/9tSznHo+lKNSwemUB5Dufwu6ZgUhLQ5EiSs0LFodf6iNqcwSaF486iMmp+NN7nbyUS09AIXaYVySD7YBtFZzHccJLgKCHKyQyIpx/vHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sPQ7p17HjjFh4gqCMU5jLeGYW0dkPPxdhAT/gmHhxAk=;
 b=C8J2DsOWq5SJje1MPyNE0/y3GGPm4HZzifRPCgPbFqg1tL6HBN3SKkU5yzVFGp6ZzUK5tig7iJpg7Lc1Fxz8fdWMvfePyWQ9QJTc27/K+iw5FNFpAcBC3r8VZoPZ2LW0SayS7zeXpdyaQjR1xiyTvUitnj6jZw6XCCifhy54K6tHTtvh/95622tFkpfEJEUpDpXmvXuspOLYhydEDNo+kOxuJa52L8oFI/Y5A0mmzXrBc/GygR7LgsXvMDH1p6FTMZMkvj1akUNYb49rIVusJrIaqP9Btfn5i7qVzwKH3JfTkhdoJcryw//jW8BghjaUMypWaKi0kImurLDinmyFlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 204.77.163.244) smtp.rcpttodomain=infradead.org smtp.mailfrom=garmin.com;
 dmarc=pass (p=quarantine sp=quarantine pct=40) action=none
 header.from=garmin.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garmin.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sPQ7p17HjjFh4gqCMU5jLeGYW0dkPPxdhAT/gmHhxAk=;
 b=BITHIsW0zePFjyaFfFOFFrO+u2T0qvsuAclpu1gkYBs38DNGXTup6Slr1Gtu30bOwCzYJHpFMPfph+5O984KZNzJP+skWU/0TviZmY8v7bgwhc+fHAMoylSD2zvhIklpBm0As2q+FNmTBUyFb4XBlTyuZ4MPgy8MFV8funiEQG0Vb+33HDvCe5F/APdPHULkXI1yXiogyenw/Op6OFxnDpGF+UBPtLH0EcDjpNKJsckCMjRHj0U2S/peuNwKNb92F1nnQrM12WMpUd+n4yDcELOM93pZz7HWFMiHhlJVlGLaB9H+IwJQoxe5NR86Hr68XrPJfC9JH9J85vdwOpXZYQ==
Received: from MWHPR12CA0034.namprd12.prod.outlook.com (2603:10b6:301:2::20)
 by SN6PR04MB4319.namprd04.prod.outlook.com (2603:10b6:805:31::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.30; Wed, 22 Apr
 2020 16:02:53 +0000
Received: from MW2NAM10FT013.eop-nam10.prod.protection.outlook.com
 (2603:10b6:301:2:cafe::6d) by MWHPR12CA0034.outlook.office365.com
 (2603:10b6:301:2::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend
 Transport; Wed, 22 Apr 2020 16:02:53 +0000
Authentication-Results: spf=pass (sender IP is 204.77.163.244)
 smtp.mailfrom=garmin.com; infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=pass action=none header.from=garmin.com;
Received-SPF: Pass (protection.outlook.com: domain of garmin.com designates
 204.77.163.244 as permitted sender) receiver=protection.outlook.com;
 client-ip=204.77.163.244; helo=edgetransport.garmin.com;
Received: from edgetransport.garmin.com (204.77.163.244) by
 MW2NAM10FT013.mail.protection.outlook.com (10.13.155.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2937.15 via Frontend Transport; Wed, 22 Apr 2020 16:02:52 +0000
Received: from OLAWPA-EXMB10.ad.garmin.com (10.5.144.12) by
 olawpa-edge5.garmin.com (10.60.4.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.1466.3; Wed, 22 Apr 2020 11:02:50 -0500
Received: from OLAWPA-EXMB7.ad.garmin.com (10.5.144.21) by
 OLAWPA-EXMB10.ad.garmin.com (10.5.144.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Wed, 22 Apr 2020 11:02:49 -0500
Received: from OLAWPA-EXMB7.ad.garmin.com ([fe80::68cc:dab9:e96a:c89]) by
 OLAWPA-EXMB7.ad.garmin.com ([fe80::68cc:dab9:e96a:c89%23]) with mapi id
 15.01.1913.007; Wed, 22 Apr 2020 11:02:49 -0500
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
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-alpha@vger.kernel.org" <linux-alpha@vger.kernel.org>,
        "linux-parisc@vger.kernel.org" <linux-parisc@vger.kernel.org>,
        "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Laight <David.Laight@aculab.com>,
        Changli Gao <xiaosuo@gmail.com>
Subject: RE: [PATCH 1/4] fs: Implement close-on-fork
Thread-Topic: [PATCH 1/4] fs: Implement close-on-fork
Thread-Index: AQHWFuOUNQrmUX2/BU6CQ6OUTp2yNKiFQqwQgABdCAD//650EA==
Date:   Wed, 22 Apr 2020 16:02:49 +0000
Message-ID: <6ed7bd08892b4311b70636658321904f@garmin.com>
References: <20200420071548.62112-1-nate.karstens@garmin.com>
 <20200420071548.62112-2-nate.karstens@garmin.com>
 <fa6c5c9c7c434f878c94a7c984cd43ba@garmin.com>
 <20200422154356.GU5820@bombadil.infradead.org>
In-Reply-To: <20200422154356.GU5820@bombadil.infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.50.4.7]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25372.001
X-TM-AS-Result: No-20.492900-8.000000-10
X-TMASE-MatchedRID: Rp71wniPtoM4HKI/yaqRm/KR06Kw3DzKRiPTMMc/MmlOyROmWLBZSuNb
        0aTvicGvSTuOLEQgmVbhVp16EZAE1e34OOTGEFTiB/XUnmGGOOr4qCLIu0mtIDyC5ddG2JcgDsh
        HkVWp6Z/gF59qS0/NMzzsW2Cgd3ClR0noGmyTNMsHz0YoejTedhlKjo8zguyKSX8n1Gj4wAExhE
        xXq6zLI1oWex3m0IGtG8983J7kkbz4Z8QQieNUXszWN98iBBeG+PgcXG6KFc5sMPuLZB/IR/hTn
        o/hWfnfwPb5NDq94CD80wK+80FbY2+4O3SBmLlWHmtCXih7f9P3N59hBwdmnyiCVsScJChxrk+q
        psJ8hQ9MAraxXAQN9j1Z6/6pkvauPWKLA6/g//v0VCHd+VQiHpRy1HDTPOXaT7zqZowzdpKXD5/
        te2xRDy6Ogi9NiuirBEmpoGQQfL5yOVk+FPzL1wYtEovY17GN9pLnYtQ99xIAZTQQTIkkcywmNV
        NFRFysdzi+MT2hFg7/6J39gwEM6MGfi/dxL5nubMGKOuLn5FURO65VAx9xehRnkhLZOCK9G88rs
        ck3r8QvJ+I7jC1cP1Mtpl6RMI3caTNicKv7gx9+AWdjDjY8Xfy0wgIDXBCTwUqLhUY4dAI4ULAZ
        wl+oC+LzNWBegCW2ak1q2nxhDrwLbigRnpKlKSBuGJWwgxArFnn7zLfna4I=
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--20.492900-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25372.001
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:204.77.163.244;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:edgetransport.garmin.com;PTR:extedge.garmin.com;CAT:NONE;SFTY:;SFS:(10019020)(376002)(39860400002)(136003)(346002)(396003)(46966005)(4326008)(8936002)(47076004)(86362001)(6916009)(26005)(36756003)(5660300002)(108616005)(2616005)(966005)(53546011)(7416002)(478600001)(7696005)(186003)(336012)(82740400003)(426003)(316002)(8676002)(24736004)(70206006)(7636003)(70586007)(54906003)(356005)(2906002)(246002)(82310400002);DIR:OUT;SFP:1102;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6cf3a271-9485-4c7d-0011-08d7e6d69cf6
X-MS-TrafficTypeDiagnostic: SN6PR04MB4319:
X-Microsoft-Antispam-PRVS: <SN6PR04MB43190D1D02FF28B2CD5DC6309CD20@SN6PR04MB4319.namprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 03818C953D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vlc2198EXg971jw/ZYN4GoYLruk06VPCw5NT/ZH3gpL7jR8D+aQMyuVPr/nqhyJnFmklnyZGFZzW6YX0H5nrIDDKbDLMC+HZ2Zu7xFR/ALAAR7o8VgH0rUukhaOpdhghL2ESsuT7usZnyPXwdmPty2eYXmcAowdTnSLDJWb+ItiAA+UirHKSU9HUFPh41nf5kj8FDfqsQB0CufVpcMoh5RCR5QsEGXtykxF2ZGm1cEEgL/rd609sL8ozflcGDRb7Gs6OOPTOPxyI9crDZekRsi3BwUH4+QCBrt6FQ2JyMTA9239mQmUtoZ4WytnqHgmbC1/SrF63M9yzVgJrDzNXwsHZgVQCmRH+tZjfbRkk9p5lcK6TXY7wxqSnDqHvhbE7JQ5oPRcGZ1OWNcpSAGPx+ArBrlLXoL4EFWUpKzYojSKq8aBIaxuKcagGUPT1o4sJSY6LtHjpzeg3VlNPqL9E6y2kd+3k3vohhL+cEGuGI4qG+jHeEXfC6IYAD3Ouywe08EKgPY0Y9NbhoahnLkRxX/Cm5JllkW/XS2dzjUqDPxE9qmUlo0+m8kDu9VpzAZBBVdP60XoSjtM+RqP/tg4ZGA==
X-OriginatorOrg: garmin.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2020 16:02:52.5232
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cf3a271-9485-4c7d-0011-08d7e6d69cf6
X-MS-Exchange-CrossTenant-Id: 38d0d425-ba52-4c0a-a03e-2a65c8e82e2d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=38d0d425-ba52-4c0a-a03e-2a65c8e82e2d;Ip=[204.77.163.244];Helo=[edgetransport.garmin.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4319
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> It's not safe to call system() from a threaded app.  That's all.  It's ri=
ght there in the DESCRIPTION:

That is true, but that description is missing from both the Linux man page =
and the glibc documentation (https://www.gnu.org/software/libc/manual/html_=
mono/libc.html#Running-a-Command). It seems like a minor point that won't b=
e noticed until it causes a problem, and problems are rare enough they migh=
t go unnoticed for a while. We have removed system() from our application, =
but we're also concerned that libraries we integrate will use system() with=
out our knowledge.

-----Original Message-----
From: Matthew Wilcox <willy@infradead.org>
Sent: Wednesday, April 22, 2020 10:44
To: Karstens, Nate <Nate.Karstens@garmin.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>; Jeff Layton <jlayton@kernel.o=
rg>; J. Bruce Fields <bfields@fieldses.org>; Arnd Bergmann <arnd@arndb.de>;=
 Richard Henderson <rth@twiddle.net>; Ivan Kokshaysky <ink@jurassic.park.ms=
u.ru>; Matt Turner <mattst88@gmail.com>; James E.J. Bottomley <James.Bottom=
ley@hansenpartnership.com>; Helge Deller <deller@gmx.de>; David S. Miller <=
davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>; linux-fsdevel@vger.=
kernel.org; linux-arch@vger.kernel.org; linux-alpha@vger.kernel.org; linux-=
parisc@vger.kernel.org; sparclinux@vger.kernel.org; netdev@vger.kernel.org;=
 linux-kernel@vger.kernel.org; David Laight <David.Laight@aculab.com>; Chan=
gli Gao <xiaosuo@gmail.com>
Subject: Re: [PATCH 1/4] fs: Implement close-on-fork

CAUTION - EXTERNAL EMAIL: Do not click any links or open any attachments un=
less you trust the sender and know the content is safe.


On Wed, Apr 22, 2020 at 03:36:09PM +0000, Karstens, Nate wrote:
> There was some skepticism about whether our practice of
> closing/reopening sockets was advisable. Regardless, it does expose
> what I believe to be something that was overlooked in the forking
> process model. We posted two solutions to the Austin Group defect tracker=
:

I don't think it was "overlooked" at all.  It's not safe to call system() f=
rom a threaded app.  That's all.  It's right there in the DESCRIPTION:

   The system() function need not be thread-safe.
https://pubs.opengroup.org/onlinepubs/9699919799/functions/system.html

> Ultimately the Austin Group felt that close-on-fork was the preferred
> approach. I think it's also worth pointing that out Solaris reportedly
> has this feature
> (https://www.mail-archive.com/austin-group-l@opengroup.org/msg05359.html)=
.

I am perplexed that the Austin Group thought this was a good idea.

________________________________

CONFIDENTIALITY NOTICE: This email and any attachments are for the sole use=
 of the intended recipient(s) and contain information that may be Garmin co=
nfidential and/or Garmin legally privileged. If you have received this emai=
l in error, please notify the sender by reply email and delete the message.=
 Any disclosure, copying, distribution or use of this communication (includ=
ing attachments) by someone other than the intended recipient is prohibited=
. Thank you.
