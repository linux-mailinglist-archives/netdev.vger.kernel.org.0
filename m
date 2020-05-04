Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 696291C3B91
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 15:46:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728268AbgEDNqe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 09:46:34 -0400
Received: from mail-bn7nam10on2134.outbound.protection.outlook.com ([40.107.92.134]:60353
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726913AbgEDNqc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 May 2020 09:46:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iY7rNUIJrxtfpAozCdDIvTuS8CqGgVDuoWyBqCZ/cPypJqzQTBLkaDV6WFKLN3oIHuzBVnFUi1Ytfk6EjMzZK4BVGVKmt/vrW4tDR+q/3u3/tGiNtEDMKFKG+S1e6ylRp5oJMfxAJkm17nAfer96/NrUkBL2itsBeyilYd2Aq4qSX6hH4NTipK19DCPZDO+m88PJguOKZ8nEsQVD1b85FjMl/usPL4yH0cA4N53VgrlYOjrNWl4qwg8m007jTUiCAaDhXvfCgZqEji75tViwkwF6fWrID8Kc/zpo33emkzS8HCYoXJ2wFOi2iZeRodHESegQxCH6bPtco+/Gup7wGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I8S+NwkAFnMlPYchysvHz9W/d/XOnB8UJdtq5O3sPyU=;
 b=HmAK4HTV7MMbOWJjroD2yWWWFPKWyhxYmocJWBtAYCb4ZLvjEacu+4YhvVMR/7CV2WfUBAfnpCFM+dh7ltgCjC5ofN+/gjwIgqlDe5nQX8NL65aP/lPDf4qPTZkULXmSiOrahRiol5Jg3NPI85hBbQ2DGDnlodHWFzc5M7iQs3iIzH6SidxdbL18c8T4Lzbel7PGPfr2V3+gU2i/XaSnvkiuIH9iNu/Y58N7KhQPDl0hJ0QoxviKRwoKPi7ceg+EFKN/hD5+EStuB+TRmfl7bogu6u/LgJeE3V/bgC1tKn15/DzowQYaU319KJXu2lanoYqC0VR9+lVMwEy/68RN+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 204.77.163.244) smtp.rcpttodomain=zeniv.linux.org.uk
 smtp.mailfrom=garmin.com; dmarc=pass (p=quarantine sp=quarantine pct=100)
 action=none header.from=garmin.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garmin.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I8S+NwkAFnMlPYchysvHz9W/d/XOnB8UJdtq5O3sPyU=;
 b=t9rP8pyCF7hCYE7oD4GPSr4T6qE6vDgI46Tr8hz2lz7An+Ph51/Iup3OoSeiS04EKzSqWLhr3pe7/RoyadUjLc0HgDoA2uticbdobyH52bimFJgEILDof5cE1OsI/8BLnCAG4+euIf6JeFO1Ph0rK7jx9PCg7ks/VYObRRrlfEWpW23T2f6xwGILS9GExbiECD1c1Vwf+Fsvp8lbBz1IknljqGVo2H1+eru5gDaM0kWHziK19uRQwxtr1qmHoLs74jMERbokTKq0KFqWOk1PvjDcyeslUN0gpWg8/5XpbfTaX/hOArMa6VsqbA8w7R0u5kVtZ3yN1BgFW56rscW1mg==
Received: from MWHPR19CA0018.namprd19.prod.outlook.com (2603:10b6:300:d4::28)
 by BN6PR04MB0548.namprd04.prod.outlook.com (2603:10b6:404:98::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.27; Mon, 4 May
 2020 13:46:25 +0000
Received: from MW2NAM10FT063.eop-nam10.prod.protection.outlook.com
 (2603:10b6:300:d4:cafe::b9) by MWHPR19CA0018.outlook.office365.com
 (2603:10b6:300:d4::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend
 Transport; Mon, 4 May 2020 13:46:24 +0000
Authentication-Results: spf=pass (sender IP is 204.77.163.244)
 smtp.mailfrom=garmin.com; zeniv.linux.org.uk; dkim=none (message not signed)
 header.d=none;zeniv.linux.org.uk; dmarc=pass action=none
 header.from=garmin.com;
Received-SPF: Pass (protection.outlook.com: domain of garmin.com designates
 204.77.163.244 as permitted sender) receiver=protection.outlook.com;
 client-ip=204.77.163.244; helo=edgetransport.garmin.com;
Received: from edgetransport.garmin.com (204.77.163.244) by
 MW2NAM10FT063.mail.protection.outlook.com (10.13.155.36) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2958.20 via Frontend Transport; Mon, 4 May 2020 13:46:24 +0000
Received: from OLAWPA-EXMB2.ad.garmin.com (10.5.144.24) by
 olawpa-edge5.garmin.com (10.60.4.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.1466.3; Mon, 4 May 2020 08:46:22 -0500
Received: from OLAWPA-EXMB7.ad.garmin.com (10.5.144.21) by
 OLAWPA-EXMB2.ad.garmin.com (10.5.144.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Mon, 4 May 2020 08:46:23 -0500
Received: from OLAWPA-EXMB7.ad.garmin.com ([fe80::68cc:dab9:e96a:c89]) by
 OLAWPA-EXMB7.ad.garmin.com ([fe80::68cc:dab9:e96a:c89%23]) with mapi id
 15.01.1913.007; Mon, 4 May 2020 08:46:22 -0500
From:   "Karstens, Nate" <Nate.Karstens@garmin.com>
To:     Al Viro <viro@zeniv.linux.org.uk>,
        Matthew Wilcox <willy@infradead.org>
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
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-alpha@vger.kernel.org" <linux-alpha@vger.kernel.org>,
        "linux-parisc@vger.kernel.org" <linux-parisc@vger.kernel.org>,
        "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Changli Gao <xiaosuo@gmail.com>
Subject: RE: Implement close-on-fork
Thread-Topic: Implement close-on-fork
Thread-Index: AQHWGLbZv/+sbtLmUEywo/DM9o3r9aiFlOCAgAAL0QCADb2wEA==
Date:   Mon, 4 May 2020 13:46:22 +0000
Message-ID: <de6adce76b534310975e4d3c4a4facb2@garmin.com>
References: <20200420071548.62112-1-nate.karstens@garmin.com>
 <20200422150107.GK23230@ZenIV.linux.org.uk>
 <20200422151815.GT5820@bombadil.infradead.org>
 <20200422160032.GL23230@ZenIV.linux.org.uk>
In-Reply-To: <20200422160032.GL23230@ZenIV.linux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.50.4.6]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25394.007
X-TM-AS-Result: No-27.018700-8.000000-10
X-TMASE-MatchedRID: yebcs53SkkCWFjFUJMrS44VMtEwAWsdc4KGcvdz6T3yqvcIF1TcLYFaP
        6AhhdqyDXQS0szagh4Mxi8MyKU4EZNjTzYyhzXBGtvnlOJ61K3rdYVrFVbszaPyQXCBzKijh1TU
        m5o9W5vUTGmoC9JG/E5GuTWz+EB0g4QkhCfQ808F9j6Il8VAHF2AW2j9VWc0lI7vGkGphvBhyMB
        AlYDmp4lqggJY/GBdeNB7jBV5VDYO7Cjv/4LgPYnCxQs5EhhfjUg5zxCPHJW0xr/m//6oStvzis
        Q86/F0ZrTwuuE+7qnE+9k1u1Md9SZ9AhAcFWw1rU9ht8cPjV44YgyDj5TiRtT2yosu2E9kKkewQ
        9AfP6yyBAcI2M9CkidtXYrM5EPdswp83yWF/TK5BAOxoLJ+v3MV0QyhMrtsxYxDgISSqWZ6EbMb
        fBj9wt4sHqQHaw/Q7sVJ8zTsA3rUApIQ1X2G0S3CO70QAsBdCyWxPa/RwSU90rxNYA09+9oXvte
        Z/aS6Rkk084sJF0CYQy9bT0ApQg8EM7jBTDoIY+ACG5oWJ7tI8jmaHmXQMACNGK7UC7ElMyZZP6
        HlL02AbDC6jLuKs7R3btB6mqMnLkOYrLvfr5/LZw6vmg2YxmfiH64jt3FfEtGZL9hpabzCX0y6n
        lwu2zGpeBnrkhkXvS0mrIcn0eIdLzhnjbgktErSlePUaQB977KNezW4SKYV3pEVETu8p8a0ZkEG
        mg55zSxogTdxY9kZP2UMxnvUrSaH2g9syPs8854eqweLWaL4vsOOmgOo1mdjMMV3eZDNhtoa372
        /xU0Ozv2tt8x+SiCCezYDg2QbmcNYIRle9ggeeAiCmPx4NwNivpTdmVCR2xEHRux+uk8irEHfaj
        14ZyVVoEXK0hBS3
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--27.018700-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25394.007
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:204.77.163.244;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:edgetransport.garmin.com;PTR:extedge.garmin.com;CAT:NONE;SFTY:;SFS:(396003)(39860400002)(136003)(376002)(346002)(46966005)(70586007)(54906003)(186003)(966005)(316002)(478600001)(7696005)(108616005)(24736004)(70206006)(8936002)(2616005)(53546011)(2906002)(3480700007)(26005)(47076004)(4326008)(7416002)(7636003)(82740400003)(110136005)(5660300002)(16799955002)(36756003)(8676002)(426003)(82310400002)(356005)(86362001)(336012);DIR:OUT;SFP:1102;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 894847fa-29f7-43da-8c08-08d7f031893c
X-MS-TrafficTypeDiagnostic: BN6PR04MB0548:
X-Microsoft-Antispam-PRVS: <BN6PR04MB0548CC46F1EA3C4C2937BF449CA60@BN6PR04MB0548.namprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 03932714EB
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E0euQN9aVjxcn5KYAGBSKXY4PK56CbTmp2fiSuVTOrR/qEL9Y/rfmMJgYpEX13uDWXywih5fQZAoE0Nh1ngyDMks8NUBnxP8BwVUizCG4r9PN+wUsFozwHCjRVMCwRdvLgZFZIrPxWzI2QGzjzAzzjoFvCiUlmEXNlyXGU1B/M2dmOH7O6qmEF10Tqpo4jCjB0R7N0Ggm9seAaieVHIcyXkc3KKNQ8MXXv+pcuqi4GcQPx8e0vZ0hkQ9bGP3mQDbI9ofp/yeebtN+ppbOMvUg1juuPAEq5ogSwnQsyuLaEADyZyKxk1jf3og8DNYyrfzWNO+M3IU10qUybbsETfTA0DpZ7XyEX5uL2uXxodXdr297Up26e7YI4rX9moCZ0ve18GOtObtxdzqP/oLhpTyN04/irp8xazdozrn7IPorTe8BthrD9rW2H2SlgPF/ImGQg6/3btTs3YTzaIDfn6BhNP3Nsku+HmuUgUe+woo6lmRMgyxmYBQVuSKDGnN4U0sSMNI1aQ83tGhV1wCcMDY9unU1i+S6v5xZKUEiJvTXTgevbmqAWquBUdTTdbVfr+rorgTJAHkL7yXs1LaGLaF6w==
X-OriginatorOrg: garmin.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2020 13:46:24.1395
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 894847fa-29f7-43da-8c08-08d7f031893c
X-MS-Exchange-CrossTenant-Id: 38d0d425-ba52-4c0a-a03e-2a65c8e82e2d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=38d0d425-ba52-4c0a-a03e-2a65c8e82e2d;Ip=[204.77.163.244];Helo=[edgetransport.garmin.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR04MB0548
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks everyone for their comments, sorry for the delay in my reply.

> As for the original problem...  what kind of exclusion is used between th=
e reaction to netlink notifications (including closing every socket,
> etc.) and actual IO done on those sockets?
> Not an idle question, BTW - unlike Solaris we do NOT (and will not) have
> close(2) abort IO on the same descriptor from another thread.  So if one =
thread sits in recvmsg(2) while another does close(2), the socket will
> *NOT* actually shut down until recvmsg(2) returns.

The netlink notification is received on a separate thread, but handling of =
that notification (closing and re-opening sockets) and the socket I/O is al=
l done on the same thread. The call to system() happens sometime between wh=
en this thread decides to close all of its sockets and when the sockets hav=
e been closed. The child process is left with a reference to one or more so=
ckets. The close-on-exec flag is set on the socket, so the period of time i=
s brief, but because system() is not atomic this still leaves a window of o=
pportunity for the failure to occur. The parent process tries to open the s=
ocket again but fails because the child process still has an open socket th=
at controls the port.

This phenomenon can really be generalized to any resource that 1) a process=
 needs exclusive access to and 2) the operating system automatically create=
s a new reference in the child when the process forks.

> Reimplementing system() is trivial.
> LD_LIBRARY_PRELOAD should take care of all system(3) calls.

Yes, that would solve the problem for our system. We identified what we bel=
ieve to be a problem with the POSIX threading model and wanted to work with=
 the community to improve this for others as well. The Austin Group agreed =
with the premise enough that they were willing to update the POSIX standard=
.

> I wonder it it has some value to add runtime checking for "multi-threaded=
" to such lib functions and error out if yes.
> Apart from that, system() is a PITA even on single/non-threaded apps.

That may be, but system() is convenient and there isn't much in the documen=
tation that warns the average developer away from its use. The manpage indi=
cates system() is thread-safe. The manpage is also somewhat contradictory i=
n that it describes the operation as being equivalent to a fork() and an ex=
ecl(), though it later points out that pthread_atfork() handlers may not be=
 executed.

> FWIW, I'm opposed to the entire feature.  Improving the implementation wi=
ll not change that.

I get it. From our perspective, changing the OS to resolve an issue seems l=
ike a drastic step. We tried hard to come up with an alternative (see https=
://www.mail-archive.com/austin-group-l@opengroup.org/msg05324.html and http=
s://austingroupbugs.net/view.php?id=3D1317), but nothing else addresses the=
 underlying issue: there is no way to prevent a fork() from duplicating the=
 resource. The close-on-exec flag partially-addresses this by allowing the =
parent process to mark a file descriptor as exclusive to itself, but there =
is still a period of time the failure can occur because the auto-close only=
 occurs during the exec(). Perhaps this would not be an issue with a differ=
ent process/threading model, but that is another discussion entirely.

Best Regards,

Nate

-----Original Message-----
From: Al Viro <viro@ftp.linux.org.uk> On Behalf Of Al Viro
Sent: Wednesday, April 22, 2020 11:01
To: Matthew Wilcox <willy@infradead.org>
Cc: Karstens, Nate <Nate.Karstens@garmin.com>; Jeff Layton <jlayton@kernel.=
org>; J. Bruce Fields <bfields@fieldses.org>; Arnd Bergmann <arnd@arndb.de>=
; Richard Henderson <rth@twiddle.net>; Ivan Kokshaysky <ink@jurassic.park.m=
su.ru>; Matt Turner <mattst88@gmail.com>; James E.J. Bottomley <James.Botto=
mley@hansenpartnership.com>; Helge Deller <deller@gmx.de>; David S. Miller =
<davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>; linux-fsdevel@vger=
.kernel.org; linux-arch@vger.kernel.org; linux-alpha@vger.kernel.org; linux=
-parisc@vger.kernel.org; sparclinux@vger.kernel.org; netdev@vger.kernel.org=
; linux-kernel@vger.kernel.org; Changli Gao <xiaosuo@gmail.com>
Subject: Re: Implement close-on-fork

CAUTION - EXTERNAL EMAIL: Do not click any links or open any attachments un=
less you trust the sender and know the content is safe.


On Wed, Apr 22, 2020 at 08:18:15AM -0700, Matthew Wilcox wrote:
> On Wed, Apr 22, 2020 at 04:01:07PM +0100, Al Viro wrote:
> > On Mon, Apr 20, 2020 at 02:15:44AM -0500, Nate Karstens wrote:
> > > Series of 4 patches to implement close-on-fork. Tests have been
> > > published to https://github.com/nkarstens/ltp/tree/close-on-fork.
> > >
> > > close-on-fork addresses race conditions in system(), which
> > > (depending on the implementation) is non-atomic in that it first
> > > calls a fork() and then an exec().
> > >
> > > This functionality was approved by the Austin Common Standards
> > > Revision Group for inclusion in the next revision of the POSIX
> > > standard (see issue 1318 in the Austin Group Defect Tracker).
> >
> > What exactly the reasons are and why would we want to implement that?
> >
> > Pardon me, but going by the previous history, "The Austin Group Says
> > It's Good" is more of a source of concern regarding the merits,
> > general sanity and, most of all, good taste of a proposal.
> >
> > I'm not saying that it's automatically bad, but you'll have to go
> > much deeper into the rationale of that change before your proposal
> > is taken seriously.
>
> https://www.mail-archive.com/austin-group-l@opengroup.org/msg05324.htm
> l
> might be useful

*snort*

Alan Coopersmith in that thread:
|| https://lwn.net/Articles/785430/ suggests AIX, BSD, & MacOS have also
|| defined it, and though it's been proposed multiple times for Linux, neve=
r adopted there.

Now, look at the article in question.  You'll see that it should've been "s=
omeone's posting in the end of comments thread under LWN article says that =
apparently it exists on AIX, BSD, ..."

The strength of evidence aside, that got me curious; I have checked the sou=
rce of FreeBSD, NetBSD and OpenBSD.  No such thing exists in either of thei=
r kernels, so at least that part can be considered an urban legend.

As for the original problem...  what kind of exclusion is used between the =
reaction to netlink notifications (including closing every socket,
etc.) and actual IO done on those sockets?


________________________________

CONFIDENTIALITY NOTICE: This email and any attachments are for the sole use=
 of the intended recipient(s) and contain information that may be Garmin co=
nfidential and/or Garmin legally privileged. If you have received this emai=
l in error, please notify the sender by reply email and delete the message.=
 Any disclosure, copying, distribution or use of this communication (includ=
ing attachments) by someone other than the intended recipient is prohibited=
. Thank you.
