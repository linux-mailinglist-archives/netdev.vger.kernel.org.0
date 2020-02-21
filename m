Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 210EE1679BA
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 10:47:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728279AbgBUJro (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 04:47:44 -0500
Received: from esa4.hc3370-68.iphmx.com ([216.71.155.144]:45069 "EHLO
        esa4.hc3370-68.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727592AbgBUJro (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 04:47:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1582278463;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=GGvy69JckNgFz+hczURopPTJOBE9gpMRPOIkan44JhQ=;
  b=VCCjy4dYV0EZTkVSv56tLk6En85Tlo8p9dU+qrzMiiBQBx8Rdh08ubVq
   7FNCnPhvYf7Yc3dfRce2D+MkfqHzR4r812XSWvv1USUsLclPpeiA/MeIt
   AYUrf4AtrT2javLdJcDKmycZFXzQk+ahpCTHjo65Y3beNEk7bOV15ZLXU
   c=;
Authentication-Results: esa4.hc3370-68.iphmx.com; dkim=none (message not signed) header.i=none; spf=None smtp.pra=roger.pau@citrix.com; spf=Pass smtp.mailfrom=roger.pau@citrix.com; spf=None smtp.helo=postmaster@mail.citrix.com
Received-SPF: None (esa4.hc3370-68.iphmx.com: no sender
  authenticity information available from domain of
  roger.pau@citrix.com) identity=pra; client-ip=162.221.158.21;
  receiver=esa4.hc3370-68.iphmx.com;
  envelope-from="roger.pau@citrix.com";
  x-sender="roger.pau@citrix.com";
  x-conformance=sidf_compatible
Received-SPF: Pass (esa4.hc3370-68.iphmx.com: domain of
  roger.pau@citrix.com designates 162.221.158.21 as permitted
  sender) identity=mailfrom; client-ip=162.221.158.21;
  receiver=esa4.hc3370-68.iphmx.com;
  envelope-from="roger.pau@citrix.com";
  x-sender="roger.pau@citrix.com";
  x-conformance=sidf_compatible; x-record-type="v=spf1";
  x-record-text="v=spf1 ip4:209.167.231.154 ip4:178.63.86.133
  ip4:195.66.111.40/30 ip4:85.115.9.32/28 ip4:199.102.83.4
  ip4:192.28.146.160 ip4:192.28.146.107 ip4:216.52.6.88
  ip4:216.52.6.188 ip4:162.221.158.21 ip4:162.221.156.83
  ip4:168.245.78.127 ~all"
Received-SPF: None (esa4.hc3370-68.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@mail.citrix.com) identity=helo;
  client-ip=162.221.158.21; receiver=esa4.hc3370-68.iphmx.com;
  envelope-from="roger.pau@citrix.com";
  x-sender="postmaster@mail.citrix.com";
  x-conformance=sidf_compatible
IronPort-SDR: RbCXnuRrHuq0rKPJfUulfq14400bSrZsUVVOUEIBDlqmlN8pUmdWOt6Bofx+4GBNKTj7tXep72
 9vxVJK+d0ivzIZkgMrlGXeox5zAu1OCeEr2Ez4mnpXvI5PIgQ1hTg8ewMgvN1n8c2bl48r5ETn
 7JSiKBwC4qAktm3GNIEwjNvzqWy+D/Pjf4pr8wWc2sJoRDpZ6VqXhZpJu6EM01eFLHZixtanzu
 4kLP5nzJUewYYv90/U34x9c3+1srhcr+v+hpLMGf+rXn1PkrRxSVxMp1R3+2iSbpig8r41NJzc
 xbc=
X-SBRS: 2.7
X-MesageID: 13431981
X-Ironport-Server: esa4.hc3370-68.iphmx.com
X-Remote-IP: 162.221.158.21
X-Policy: $RELAYED
X-IronPort-AV: E=Sophos;i="5.70,467,1574139600"; 
   d="scan'208";a="13431981"
Date:   Fri, 21 Feb 2020 10:47:35 +0100
From:   Roger Pau =?utf-8?B?TW9ubsOp?= <roger.pau@citrix.com>
To:     Anchal Agarwal <anchalag@amazon.com>
CC:     "Durrant, Paul" <pdurrant@amazon.co.uk>,
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
Message-ID: <20200221094735.GV4679@Air-de-Roger>
References: <20200217230553.GA8100@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <20200218091611.GN4679@Air-de-Roger>
 <20200219180424.GA17584@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <20200220083904.GI4679@Air-de-Roger>
 <f986b845491b47cc8469d88e2e65e2a7@EX13D32EUC003.ant.amazon.com>
 <20200220154507.GO4679@Air-de-Roger>
 <c9662397256a4568a5cc7d70a84940e5@EX13D32EUC003.ant.amazon.com>
 <20200220164839.GR4679@Air-de-Roger>
 <e42fa35800f04b6f953e4af87f2c1a02@EX13D32EUC003.ant.amazon.com>
 <20200221004918.GA13221@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200221004918.GA13221@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
X-ClientProxiedBy: AMSPEX02CAS01.citrite.net (10.69.22.112) To
 AMSPEX02CL01.citrite.net (10.69.22.125)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 21, 2020 at 12:49:18AM +0000, Anchal Agarwal wrote:
> On Thu, Feb 20, 2020 at 10:01:52AM -0700, Durrant, Paul wrote:
> > > -----Original Message-----
> > > From: Roger Pau Monné <roger.pau@citrix.com>
> > > Sent: 20 February 2020 16:49
> > > To: Durrant, Paul <pdurrant@amazon.co.uk>
> > > Cc: Agarwal, Anchal <anchalag@amazon.com>; Valentin, Eduardo
> > > <eduval@amazon.com>; len.brown@intel.com; peterz@infradead.org;
> > > benh@kernel.crashing.org; x86@kernel.org; linux-mm@kvack.org;
> > > pavel@ucw.cz; hpa@zytor.com; tglx@linutronix.de; sstabellini@kernel.org;
> > > fllinden@amaozn.com; Kamata, Munehisa <kamatam@amazon.com>;
> > > mingo@redhat.com; xen-devel@lists.xenproject.org; Singh, Balbir
> > > <sblbir@amazon.com>; axboe@kernel.dk; konrad.wilk@oracle.com;
> > > bp@alien8.de; boris.ostrovsky@oracle.com; jgross@suse.com;
> > > netdev@vger.kernel.org; linux-pm@vger.kernel.org; rjw@rjwysocki.net;
> > > linux-kernel@vger.kernel.org; vkuznets@redhat.com; davem@davemloft.net;
> > > Woodhouse, David <dwmw@amazon.co.uk>
> > > Subject: Re: [Xen-devel] [RFC PATCH v3 06/12] xen-blkfront: add callbacks
> > > for PM suspend and hibernation
> > > For example one necessary difference will be that xenbus initiated
> > > suspend won't close the PV connection, in case suspension fails. On PM
> > > suspend you seem to always close the connection beforehand, so you
> > > will always have to re-negotiate on resume even if suspension failed.
> > >
> I don't get what you mean, 'suspension failure' during disconnecting frontend from 
> backend? [as in this case we mark frontend closed and then wait for completion]
> Or do you mean suspension fail in general post bkacend is disconnected from
> frontend for blkfront? 

I don't think you strictly need to disconnect from the backend when
suspending. Just waiting for all requests to finish should be enough.

This has the benefit of not having to renegotiate if the suspension
fails, and thus you can recover from suspension faster in case of
failure. Since you haven't closed the connection with the backend just
unfreezing the queues should get you working again, and avoids all the
renegotiation.

> In case of later, if anything fails after the dpm_suspend(),
> things need to be thawed or set back up so it should ok to always 
> re-negotitate just to avoid errors. 
> 
> > > What I'm mostly worried about is the different approach to ring
> > > draining. Ie: either xenbus is changed to freeze the queues and drain
> > > the shared rings, or PM uses the already existing logic of not
> > > flushing the rings an re-issuing in-flight requests on resume.
> > > 
> > 
> > Yes, that's needs consideration. I don’t think the same semantic can be suitable for both. E.g. in a xen-suspend we need to freeze with as little processing as possible to avoid dirtying RAM late in the migration cycle, and we know that in-flight data can wait. But in a transition to S4 we need to make sure that at least all the in-flight blkif requests get completed, since they probably contain bits of the guest's memory image and that's not going to get saved any other way.
> > 
> >   Paul
> I agree with Paul here. Just so as you know, I did try a hacky way in the past 
> to re-queue requests in the past and failed miserably.

Well, it works AFAIK for xenbus initiated suspension, so I would be
interested to know why it doesn't work with PM suspension.

> I doubt[just from my experimentation]re-queuing the requests will work for PM 
> Hibernation for the same reason Paul mentioned above unless you give me pressing
> reason why it should work.

My main reason is that I don't want to maintain two different
approaches to suspend/resume without a technical argument for it. I'm
not happy to take a bunch of new code just because the current one
doesn't seem to work in your use-case.

That being said, if there's a justification for doing it differently
it needs to be stated clearly in the commit. From the current commit
message I didn't gasp that there was a reason for not using the
current xenbus suspend/resume logic.

> Also, won't it effect the migration time if we start waiting for all the
> inflight requests to complete[last min page faults] ?

Well, it's going to dirty pages that would have to be re-send to the
destination side.

Roger.
