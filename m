Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC10A25061D
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 19:28:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728270AbgHXR2J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 13:28:09 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:61345 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726374AbgHXR2H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 13:28:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1598290086; x=1629826086;
  h=date:from:to:cc:message-id:references:mime-version:
   in-reply-to:subject;
  bh=sJKVrhjRdjFhSQhYyBL/Jhi9uLQHVJpNK4GZYxSA/dc=;
  b=CvPpBnyw8hNNnY4IPnBFDrXoro9F1g0NILcb8GHoOD+YmiZ4Ofemxrqc
   dndVhC9tYiZEMmA0J5Osb7qa82j1Bd0RfhbR9BDsNZHZQhJLbBI3QHA1B
   J9rrjFAc6b4TIvjpuUxX/2/MtKeYKWInQuG8QJ6n+xPZRwsKu3nxmOSAc
   I=;
X-IronPort-AV: E=Sophos;i="5.76,349,1592870400"; 
   d="scan'208";a="70457034"
Subject: Re: [PATCH v3 05/11] genirq: Shutdown irq chips in suspend/resume during
 hibernation
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1a-821c648d.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 24 Aug 2020 17:25:48 +0000
Received: from EX13MTAUWA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1a-821c648d.us-east-1.amazon.com (Postfix) with ESMTPS id CCA4AA1B8E;
        Mon, 24 Aug 2020 17:25:41 +0000 (UTC)
Received: from EX13D10UWA001.ant.amazon.com (10.43.160.216) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.118) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 24 Aug 2020 17:25:15 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13D10UWA001.ant.amazon.com (10.43.160.216) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 24 Aug 2020 17:25:15 +0000
Received: from dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com
 (172.22.96.68) by mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP
 Server id 15.0.1497.2 via Frontend Transport; Mon, 24 Aug 2020 17:25:15 +0000
Received: by dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com (Postfix, from userid 4335130)
        id A16DC40770; Mon, 24 Aug 2020 17:25:15 +0000 (UTC)
Date:   Mon, 24 Aug 2020 17:25:15 +0000
From:   Anchal Agarwal <anchalag@amazon.com>
To:     Thomas Gleixner <tglx@linutronix.de>
CC:     <mingo@redhat.com>, <bp@alien8.de>, <hpa@zytor.com>,
        <x86@kernel.org>, <boris.ostrovsky@oracle.com>, <jgross@suse.com>,
        <linux-pm@vger.kernel.org>, <linux-mm@kvack.org>,
        <kamatam@amazon.com>, <sstabellini@kernel.org>,
        <konrad.wilk@oracle.com>, <roger.pau@citrix.com>,
        <axboe@kernel.dk>, <davem@davemloft.net>, <rjw@rjwysocki.net>,
        <len.brown@intel.com>, <pavel@ucw.cz>, <peterz@infradead.org>,
        <eduval@amazon.com>, <sblbir@amazon.com>,
        <xen-devel@lists.xenproject.org>, <vkuznets@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <dwmw@amazon.co.uk>, <benh@kernel.crashing.org>
Message-ID: <20200824172515.GA19449@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
References: <cover.1598042152.git.anchalag@amazon.com>
 <d9bcd552c946ac56f3f17cc0c1be57247d4a3004.1598042152.git.anchalag@amazon.com>
 <87h7svqzxm.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <87h7svqzxm.fsf@nanos.tec.linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 22, 2020 at 02:36:37AM +0200, Thomas Gleixner wrote:
> CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
> 
> 
> 
> On Fri, Aug 21 2020 at 22:27, Thomas Gleixner wrote:
> > Add a new quirk flag IRQCHIP_SHUTDOWN_ON_SUSPEND and add support for
> > it the core interrupt suspend/resume paths.
> >
> > Changelog:
> > v1->v2: Corrected the author's name to tglx@
> 
> Can you please move that Changelog part below the --- seperator next
> time because that's really not part of the final commit messaage and the
> maintainer has then to strip it off manually
> 
Ack.
> > Signed-off-by: Anchal Agarwal <anchalag@amazon.com>
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> 
> These SOB lines are just wrongly ordered as they suggest:
> 
>      Anchal has authored the patch and Thomas transported it
> 
> which is clearly not the case. So the right order is:
> 
I must admit I wasn't aware of that. Will fix.
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Anchal Agarwal <anchalag@amazon.com>
> 
> And that needs another tweak at the top of the change log. The first
> line in the mail body wants to be:
> 
> From: Thomas Gleixner <tglx@linutronix.de>
Yes I accidentally missed that in this patch.
Others have that line on all the patches and even v2 for this patch
has. Will fix.
> 
> followed by an empty new line before the actual changelog text
> starts. That way the attribution of the patch when applying it will be
> correct.
> 
> Documentation/process/ is there for a reason and following the few
> simple rules to get that straight is not rocket science.
> 
> Thanks,
> 
>         tglx
> 
> 
Anchal
