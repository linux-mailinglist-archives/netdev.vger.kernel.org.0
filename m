Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA54B1D55FB
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 18:26:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbgEOQ0j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 12:26:39 -0400
Received: from mail-bn7nam10on2090.outbound.protection.outlook.com ([40.107.92.90]:43105
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726162AbgEOQ0f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 12:26:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nC0LbBdPttnRvCTo2+7/ReR4hzE2RAjKW1ND7A3udF8f5SUCTjCAgrKCyYBdblIm1jxNgUBupULV80MZ/GiEo3/1FI2/7Rtn1JJAHVnsVy3CNeVu9Cf89JG7w7UCp5hd4++5VI1ayLGqrE4TaXYXtpN8Smbex76o48AzNK007OYE9I1oH/5Yj4lXzhYvImbrsweqGSQi2gIgzcA9JrAkKzVAehbXS5FwIBqarx46guCprnPzjtOTqlDrVS223Rk+oNeZj468/rP70mI08AmW5kFbeiXb3ni6QnbKAC23oAyBnwnes6vHP3m6ds0dqii1zkZioNmkuDN1bzuL7VczpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ipFHuOC8jzTJusS9EnOrLBs7xPwpMEA0/oRFdlFittQ=;
 b=gSvAot4377V4tG++W70MIT0UnvDDSvOKckTD4EimlpM/pNKlwZq0sMLhcm/C3Mj/vhOB5zG8bFQOiUJYxZASSvH52VpQFNRAtcI3d3TvyP0/JrwX73EO4uGRUpW0KuOIsoIHs27iPaEZ2f1+G2kVSBZzDfp8hf+nQw17HhRv3q7vbMSPbgIFA17qTdStranBJkO6GWkhnhBJCd+1cxwwvggKRmZDrMBjbOjwyp+ZyD/BVqBEBGN5u8solsm2Hjf3vCnGoJld644gOQbX+DOGSoHNt2b8C34s69nA7FO4oMuw0ilv78F9Z/zbKTG3LGE3X0MN1jfA/wERgtEnRpiruA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 204.77.163.244) smtp.rcpttodomain=zeniv.linux.org.uk
 smtp.mailfrom=garmin.com; dmarc=pass (p=quarantine sp=quarantine pct=100)
 action=none header.from=garmin.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garmin.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ipFHuOC8jzTJusS9EnOrLBs7xPwpMEA0/oRFdlFittQ=;
 b=XP3naaRbUcAY0BQdHPyQOVZOxFQu11BfWx8hZtoSZXpO09znIkra6x3IQHCW9O/Q5wpBtEesa+QJebJ/5t3pHgjV1NSYl7PdBXhjGJwkn5XYCi7xfWpjelYGalt1q2YfAtugzT5r9148g4OQ0v6nBzzY6FBDzV/6NmnmHEUeWfWwxXJ6vif6oPTBTgO/lODZjOlhaxhD36HSrOhVyUsY9iMmY6GYGQPgL2gtfZWJsG8sJa0H9BbqcSIapfzT38nACig9YW6+45Rp/9KVVG8DqlLPeJ0mkgQfdB7yVXBLTLi58rYUuRRHa1VNZhusJDv/JNPWWr1Px6LIgKHDJ/19/w==
Received: from BN3PR05CA0025.namprd05.prod.outlook.com (2603:10b6:400::35) by
 DM6PR04MB4793.namprd04.prod.outlook.com (2603:10b6:5:1e::32) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3000.20; Fri, 15 May 2020 16:26:30 +0000
Received: from BN7NAM10FT054.eop-nam10.prod.protection.outlook.com
 (2603:10b6:400:0:cafe::13) by BN3PR05CA0025.outlook.office365.com
 (2603:10b6:400::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.11 via Frontend
 Transport; Fri, 15 May 2020 16:26:30 +0000
Authentication-Results: spf=pass (sender IP is 204.77.163.244)
 smtp.mailfrom=garmin.com; zeniv.linux.org.uk; dkim=none (message not signed)
 header.d=none;zeniv.linux.org.uk; dmarc=pass action=none
 header.from=garmin.com;
Received-SPF: Pass (protection.outlook.com: domain of garmin.com designates
 204.77.163.244 as permitted sender) receiver=protection.outlook.com;
 client-ip=204.77.163.244; helo=edgetransport.garmin.com;
Received: from edgetransport.garmin.com (204.77.163.244) by
 BN7NAM10FT054.mail.protection.outlook.com (10.13.157.112) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3000.19 via Frontend Transport; Fri, 15 May 2020 16:26:30 +0000
Received: from OLAWPA-EXMB1.ad.garmin.com (10.5.144.23) by
 olawpa-edge4.garmin.com (10.60.4.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.1466.3; Fri, 15 May 2020 11:26:28 -0500
Received: from OLAWPA-EXMB7.ad.garmin.com (10.5.144.21) by
 OLAWPA-EXMB1.ad.garmin.com (10.5.144.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Fri, 15 May 2020 11:26:28 -0500
Received: from OLAWPA-EXMB7.ad.garmin.com ([fe80::68cc:dab9:e96a:c89]) by
 OLAWPA-EXMB7.ad.garmin.com ([fe80::68cc:dab9:e96a:c89%23]) with mapi id
 15.01.1913.007; Fri, 15 May 2020 11:26:28 -0500
From:   "Karstens, Nate" <Nate.Karstens@garmin.com>
To:     Al Viro <viro@zeniv.linux.org.uk>
CC:     Jeff Layton <jlayton@kernel.org>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        Helge Deller <deller@gmx.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Eric Dumazet" <edumazet@google.com>,
        David Laight <David.Laight@aculab.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-alpha@vger.kernel.org" <linux-alpha@vger.kernel.org>,
        "linux-parisc@vger.kernel.org" <linux-parisc@vger.kernel.org>,
        "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Changli Gao <xiaosuo@gmail.com>
Subject: RE: [PATCH v2] Implement close-on-fork
Thread-Topic: [PATCH v2] Implement close-on-fork
Thread-Index: AQHWKtJnQW28Wposd0uF0sb7I7R5yaipUEHg
Date:   Fri, 15 May 2020 16:26:28 +0000
Message-ID: <954ef5ce2e47472f8b41300bf59209c5@garmin.com>
References: <20200515152321.9280-1-nate.karstens@garmin.com>
 <20200515160342.GE23230@ZenIV.linux.org.uk>
In-Reply-To: <20200515160342.GE23230@ZenIV.linux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.50.4.7]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25422.001
X-TM-AS-Result: No-25.565400-8.000000-10
X-TMASE-MatchedRID: IDdx3MBO6EA4lC5Kv9wUbvGSfx66m+aMOxjb9QQbt+RjjMm9SMavFeSZ
        sOHi07gEr/8sDK1kxPbQa1VnD/+FPUvOGeNuCS0S9FQh3flUIh7lEwMU8A2NKG0emrRhsFGLH9B
        pMenWNIoWh4Aghj5bPYFHACWsU4r1gQDUCAaEDqmdVNZaI2n6/+lUxvXGcRIyuIuOQRFsnGiD/m
        A2vw4bvUBcp7vyblpbpr6zm+W2pl9RBKsfa1kPYQPZZctd3P4Ba2pCAnJvQFEcNByoSo036QjyL
        z97jpWXx5s4kxOoTl8gns2A4NkG5uE1n7m+jMjAiVJZi91I9Jh6cSMyMC0ZbueB6sW/fZnmiqr8
        0tignQ46GiPP4hQJxbqJ0tfeyPe1R/LrKX7ntfC+vuhCHYf164IA1xEih5kwVOFdaTLzUEenyTA
        2OWm+MsvuusssvZ6cxv0KARCYxbkmiAtJc/lr9+yNEc7z2JzCyBEE5Ydf0DFemWwoCXDj9WkCNf
        w/mPvvYWE02nN6lGcqrrWA7JXyB0GpYFFdx/uzttAWxuM5sl7uHZGuwo6K7bkrYtQaB6j21ddNq
        6Z3NmdzIPtgA8AbFVaHG9BGTPOGKdJFmt/C31gmxe9I4Ere+oBOBQVQ0d5DpdltGKiWi0WoB03w
        QCIXjuRGNnMG86C8Iaqr32MlVaUT1tvBsmDmruCdOJAyA+r+42To+uHNEPbN+Vkq4CuVk6PFjJE
        Fr+olhAvhah9RwybYDKq9BLK39+JGF26G8SWy5yM0c1ktj9M=
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--25.565400-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25422.001
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:204.77.163.244;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:edgetransport.garmin.com;PTR:extedge.garmin.com;CAT:NONE;SFTY:;SFS:(39860400002)(376002)(136003)(396003)(346002)(46966005)(26005)(186003)(8676002)(82310400002)(7696005)(316002)(24736004)(7636003)(6916009)(108616005)(7416002)(82740400003)(54906003)(8936002)(356005)(2906002)(47076004)(86362001)(16799955002)(70586007)(70206006)(2616005)(53546011)(336012)(36756003)(5660300002)(478600001)(966005)(426003)(4326008);DIR:OUT;SFP:1102;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 15467618-325c-40ce-2458-08d7f8ecb952
X-MS-TrafficTypeDiagnostic: DM6PR04MB4793:
X-Microsoft-Antispam-PRVS: <DM6PR04MB4793F6B78B5C7F8E167848C49CBD0@DM6PR04MB4793.namprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 04041A2886
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mJtGoScZ0hPpjwAn8mWaqd/PLnGFnTX/Gd87Ou9ECWoSe5LHsZUILLb2RkMhpAw6o4CjFCcBLA+o8S3X1FaWL2iLk+10VYOMF28/Yf1xX5nAjpC1WXQnswodrwkkfKe6PB3lCyllBylKH0POxJjK1w4fUhEoaRH8rWEhMGosyUS4+RRaU8cbU28ImwZ0+rQffu+0HgqyMltJpw2bhEQ6IFtlREOY0EN2hAfM8Vy/gRQI2XQD1VnZaF4a9QexNj1acDT9Ksy5G3fMSvj2rKhILSFgW/IYoWVQ8XABCKuZd9iD9bVglu8/uC/tU3nWbsb5f/CMvNS8bJlRVTOMdeEng1UTZvcfHNcfazrDefegFSfF5nzIb5sJp91nJfTVb1Jvuw9dIZM1ZQmHxTlHDhYRUqVr6QBBCHnmcI1rQZi0N3KPbOY4HoQgpzhLJokI1TatwOjR1T/hj7wS2bgU8yQBo79c09E0iR6rqRdh63lF38moy7r7rEbXmu3datIK2FiP8nVe7wlPvQUcqt4zsFXKSJxu3iGZpv5yKeOJKW901hescY/UCGOSzWCP9lmqhzum914+PYYSTpppKKj8cEJ1uw==
X-OriginatorOrg: garmin.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2020 16:26:30.0243
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 15467618-325c-40ce-2458-08d7f8ecb952
X-MS-Exchange-CrossTenant-Id: 38d0d425-ba52-4c0a-a03e-2a65c8e82e2d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=38d0d425-ba52-4c0a-a03e-2a65c8e82e2d;Ip=[204.77.163.244];Helo=[edgetransport.garmin.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4793
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Al,

The reference to the POSIX change was included more for a reference to that=
 discussion, not to say "POSIX did this and so Linux must do it to". In any=
 case, the documentation presented to the Austin Group was focused more aro=
und the issue we ran into and some alternative solutions. In reviewing the =
notes from the meeting I didn't get the impression that they added this to =
POSIX simply because Solaris and *BSD already had it (reference https://aus=
tingroupbugs.net/view.php?id=3D1317, the first solution we suggested).

> It penalizes every call of fork() in the system

Is the performance hit really that drastic? fork() does a lot of stuff and =
this really seems like a drop in the bucket...

> adds an extra dirtied cacheline on each socket()/open()/etc.

It sounds like we can work to improve that, though.

> already has a portable solution

What is the solution?

Thanks,

Nate

-----Original Message-----
From: Al Viro <viro@ftp.linux.org.uk> On Behalf Of Al Viro
Sent: Friday, May 15, 2020 11:04
To: Karstens, Nate <Nate.Karstens@garmin.com>
Cc: Jeff Layton <jlayton@kernel.org>; J. Bruce Fields <bfields@fieldses.org=
>; Arnd Bergmann <arnd@arndb.de>; Richard Henderson <rth@twiddle.net>; Ivan=
 Kokshaysky <ink@jurassic.park.msu.ru>; Matt Turner <mattst88@gmail.com>; J=
ames E.J. Bottomley <James.Bottomley@hansenpartnership.com>; Helge Deller <=
deller@gmx.de>; David S. Miller <davem@davemloft.net>; Jakub Kicinski <kuba=
@kernel.org>; Eric Dumazet <edumazet@google.com>; David Laight <David.Laigh=
t@aculab.com>; linux-fsdevel@vger.kernel.org; linux-arch@vger.kernel.org; l=
inux-alpha@vger.kernel.org; linux-parisc@vger.kernel.org; sparclinux@vger.k=
ernel.org; netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Changli Ga=
o <xiaosuo@gmail.com>
Subject: Re: [PATCH v2] Implement close-on-fork

CAUTION - EXTERNAL EMAIL: Do not click any links or open any attachments un=
less you trust the sender and know the content is safe.


On Fri, May 15, 2020 at 10:23:17AM -0500, Nate Karstens wrote:

> This functionality was approved by the Austin Common Standards
> Revision Group for inclusion in the next revision of the POSIX
> standard (see issue 1318 in the Austin Group Defect Tracker).

It penalizes every call of fork() in the system (as well as adds an extra d=
irtied cacheline on each socket()/open()/etc.), adds memory footprint and c=
omplicates the API.  All of that - to deal with rather uncommon problem tha=
t already has a portable solution.

As for the Austin Group, the only authority it has ever had derives from co=
nsensus between existing Unices.  "Solaris does it, Linux and *BSD do not" =
translates into "Austin Group is welcome to take a hike".
BTW, contrary to the lovely bit of misrepresentation in that thread of thei=
rs ("<LWN URL> suggests that" !=3D "someone's comment under LWN article say=
s it _appears_ that"), none of *BSD do it.

IMO it's a bad idea.

NAKed-by: Al Viro <viro@zeniv.linux.org.uk>

________________________________

CONFIDENTIALITY NOTICE: This email and any attachments are for the sole use=
 of the intended recipient(s) and contain information that may be Garmin co=
nfidential and/or Garmin legally privileged. If you have received this emai=
l in error, please notify the sender by reply email and delete the message.=
 Any disclosure, copying, distribution or use of this communication (includ=
ing attachments) by someone other than the intended recipient is prohibited=
. Thank you.
