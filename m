Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B979167AAD
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 11:22:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728679AbgBUKVk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 05:21:40 -0500
Received: from esa3.hc3370-68.iphmx.com ([216.71.145.155]:57846 "EHLO
        esa3.hc3370-68.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728278AbgBUKVk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 05:21:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1582280499;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=szw5kUCBwfMR4Umcye1UsaTnnWME1Rw3d5ErMmAgp5Q=;
  b=VylwvEXapF9ZtvMecqCj6wXVvMQAf6e/RyQMTzTs/04GswkrWp0qfgyv
   lBeIHT5VcnxHpfP11MgSKTslbKYdsaKPWiC3Igqt84YTbX/2QlFCuUjyN
   5MZLEhelEqvGbI/iyA8VnuHppQaSOeAogr3NPbq2lJJQIQLJ+eDIpj0Hj
   c=;
Authentication-Results: esa3.hc3370-68.iphmx.com; dkim=none (message not signed) header.i=none; spf=None smtp.pra=roger.pau@citrix.com; spf=Pass smtp.mailfrom=roger.pau@citrix.com; spf=None smtp.helo=postmaster@mail.citrix.com
Received-SPF: None (esa3.hc3370-68.iphmx.com: no sender
  authenticity information available from domain of
  roger.pau@citrix.com) identity=pra; client-ip=162.221.158.21;
  receiver=esa3.hc3370-68.iphmx.com;
  envelope-from="roger.pau@citrix.com";
  x-sender="roger.pau@citrix.com";
  x-conformance=sidf_compatible
Received-SPF: Pass (esa3.hc3370-68.iphmx.com: domain of
  roger.pau@citrix.com designates 162.221.158.21 as permitted
  sender) identity=mailfrom; client-ip=162.221.158.21;
  receiver=esa3.hc3370-68.iphmx.com;
  envelope-from="roger.pau@citrix.com";
  x-sender="roger.pau@citrix.com";
  x-conformance=sidf_compatible; x-record-type="v=spf1";
  x-record-text="v=spf1 ip4:209.167.231.154 ip4:178.63.86.133
  ip4:195.66.111.40/30 ip4:85.115.9.32/28 ip4:199.102.83.4
  ip4:192.28.146.160 ip4:192.28.146.107 ip4:216.52.6.88
  ip4:216.52.6.188 ip4:162.221.158.21 ip4:162.221.156.83
  ip4:168.245.78.127 ~all"
Received-SPF: None (esa3.hc3370-68.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@mail.citrix.com) identity=helo;
  client-ip=162.221.158.21; receiver=esa3.hc3370-68.iphmx.com;
  envelope-from="roger.pau@citrix.com";
  x-sender="postmaster@mail.citrix.com";
  x-conformance=sidf_compatible
IronPort-SDR: QEFBJckE/MYkvO2flXPlpJQt4Otkt0cu31Hi8oseCOIldyuYhI4sG/WgtjoU3dqM8aobRm4cza
 BxgWJnLKK6ZDvkNxA2rHcJKaR9vO6P7KJs3kG9lY1MfghynCwXfmNppiLeicgubrKuiqo1Fp/3
 pT0BMg+orHucSFRXhRTwIVHLS35iD+RLBJkiXqk4tRcaujIhh9XTXNUi/k+EbebNfX3kzbj8BJ
 L/ofjVQpTcO38wip8DTDbTm9fbWxG9KrnTUIm30Odti4icb8IAzr0zDY/JpPQYsftQMCxbG/61
 qk0=
X-SBRS: 2.7
X-MesageID: 12791624
X-Ironport-Server: esa3.hc3370-68.iphmx.com
X-Remote-IP: 162.221.158.21
X-Policy: $RELAYED
X-IronPort-AV: E=Sophos;i="5.70,467,1574139600"; 
   d="scan'208";a="12791624"
Date:   Fri, 21 Feb 2020 11:21:30 +0100
From:   Roger Pau =?utf-8?B?TW9ubsOp?= <roger.pau@citrix.com>
To:     "Durrant, Paul" <pdurrant@amazon.co.uk>
CC:     "Agarwal, Anchal" <anchalag@amazon.com>,
        "Valentin, Eduardo" <eduval@amazon.com>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "pavel@ucw.cz" <pavel@ucw.cz>, "hpa@zytor.com" <hpa@zytor.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "sstabellini@kernel.org" <sstabellini@kernel.org>,
        "fllinden@amaozn.com" <fllinden@amaozn.com>,
        "Kamata, Munehisa" <kamatam@amazon.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "Singh, Balbir" <sblbir@amazon.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
        "jgross@suse.com" <jgross@suse.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Woodhouse, David" <dwmw@amazon.co.uk>
Subject: Re: [Xen-devel] [RFC PATCH v3 06/12] xen-blkfront: add callbacks for
 PM suspend and hibernation
Message-ID: <20200221102130.GW4679@Air-de-Roger>
References: <20200218091611.GN4679@Air-de-Roger>
 <20200219180424.GA17584@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <20200220083904.GI4679@Air-de-Roger>
 <f986b845491b47cc8469d88e2e65e2a7@EX13D32EUC003.ant.amazon.com>
 <20200220154507.GO4679@Air-de-Roger>
 <c9662397256a4568a5cc7d70a84940e5@EX13D32EUC003.ant.amazon.com>
 <20200220164839.GR4679@Air-de-Roger>
 <e42fa35800f04b6f953e4af87f2c1a02@EX13D32EUC003.ant.amazon.com>
 <20200221092219.GU4679@Air-de-Roger>
 <5ddf980a3fba4fb39571184e688cefc5@EX13D32EUC003.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5ddf980a3fba4fb39571184e688cefc5@EX13D32EUC003.ant.amazon.com>
X-ClientProxiedBy: AMSPEX02CAS02.citrite.net (10.69.22.113) To
 AMSPEX02CL01.citrite.net (10.69.22.125)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 21, 2020 at 09:56:54AM +0000, Durrant, Paul wrote:
> > -----Original Message-----
> > From: Roger Pau Monné <roger.pau@citrix.com>
> > Sent: 21 February 2020 09:22
> > To: Durrant, Paul <pdurrant@amazon.co.uk>
> > Cc: Agarwal, Anchal <anchalag@amazon.com>; Valentin, Eduardo
> > <eduval@amazon.com>; len.brown@intel.com; peterz@infradead.org;
> > benh@kernel.crashing.org; x86@kernel.org; linux-mm@kvack.org;
> > pavel@ucw.cz; hpa@zytor.com; tglx@linutronix.de; sstabellini@kernel.org;
> > fllinden@amaozn.com; Kamata, Munehisa <kamatam@amazon.com>;
> > mingo@redhat.com; xen-devel@lists.xenproject.org; Singh, Balbir
> > <sblbir@amazon.com>; axboe@kernel.dk; konrad.wilk@oracle.com;
> > bp@alien8.de; boris.ostrovsky@oracle.com; jgross@suse.com;
> > netdev@vger.kernel.org; linux-pm@vger.kernel.org; rjw@rjwysocki.net;
> > linux-kernel@vger.kernel.org; vkuznets@redhat.com; davem@davemloft.net;
> > Woodhouse, David <dwmw@amazon.co.uk>
> > Subject: Re: [Xen-devel] [RFC PATCH v3 06/12] xen-blkfront: add callbacks
> > for PM suspend and hibernation
> > 
> > On Thu, Feb 20, 2020 at 05:01:52PM +0000, Durrant, Paul wrote:
> > > > > Hopefully what I said above illustrates why it may not be 100%
> > common.
> > > >
> > > > Yes, that's fine. I don't expect it to be 100% common (as I guess
> > > > that the hooks will have different prototypes), but I expect
> > > > that routines can be shared, and that the approach taken can be the
> > > > same.
> > > >
> > > > For example one necessary difference will be that xenbus initiated
> > > > suspend won't close the PV connection, in case suspension fails. On PM
> > > > suspend you seem to always close the connection beforehand, so you
> > > > will always have to re-negotiate on resume even if suspension failed.
> > > >
> > > > What I'm mostly worried about is the different approach to ring
> > > > draining. Ie: either xenbus is changed to freeze the queues and drain
> > > > the shared rings, or PM uses the already existing logic of not
> > > > flushing the rings an re-issuing in-flight requests on resume.
> > > >
> > >
> > > Yes, that's needs consideration. I don’t think the same semantic can be
> > suitable for both. E.g. in a xen-suspend we need to freeze with as little
> > processing as possible to avoid dirtying RAM late in the migration cycle,
> > and we know that in-flight data can wait. But in a transition to S4 we
> > need to make sure that at least all the in-flight blkif requests get
> > completed, since they probably contain bits of the guest's memory image
> > and that's not going to get saved any other way.
> > 
> > Thanks, that makes sense and something along this lines should be
> > added to the commit message IMO.
> > 
> > Wondering about S4, shouldn't we expect the queues to already be
> > empty? As any subsystem that wanted to store something to disk should
> > make sure requests have been successfully completed before
> > suspending.
> 
> What about writing the suspend image itself? Normal filesystem I/O
> will have been flushed of course, but whatever vestigial kernel
> actually writes out the hibernation file may well expect a final
> D0->D3 on the storage device to cause a flush.

Hm, I have no idea really. I think whatever writes to the disk before
suspend should actually make sure requests have completed, but what
you suggest might also be a possibility.

Can you figure out whether there are requests on the ring or in the
queue before suspending?

> Again, I don't know the specifics for Linux (and Windows actually
> uses an incarnation of the crash kernel to do the job, which brings
> with it a whole other set of complexity as far as PV drivers go).

That seems extremely complex, I'm sure there's a reason for it :).

Thanks, Roger.
