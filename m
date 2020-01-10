Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87F4B136478
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 01:54:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730405AbgAJAyY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 19:54:24 -0500
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:18038 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730385AbgAJAyX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 19:54:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1578617663; x=1610153663;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=gFWTLYKX2wEcgFfZMvELsMKmvJakxFojhlZCDgHoKHg=;
  b=U7GKw8Jhmg28KGS2rH3tbfnmhFi2Shc9gGMHZFzICGLHJdE/Eobu19B8
   lWijGG8pNWbEeGxLBXOIzUbDtDsVwP38ccgEHdFUzwQStmC4Hd8JypjE1
   7GQJ0KAxFnDu+V7xj0tBhBe5x+OOHMjYOtpGOmscWaNWtzkqCcAXuSvOH
   M=;
IronPort-SDR: vrQ2rPHO9WRjY8NbeMG8xCyVhFjs61ZAlZ1Xu5GgYue07j+xSBWWpbZpefhBRW+H/Yq4LaxKAh
 CmVfjKPeYQZQ==
X-IronPort-AV: E=Sophos;i="5.69,414,1571702400"; 
   d="scan'208";a="12337450"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2c-397e131e.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 10 Jan 2020 00:54:20 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2c-397e131e.us-west-2.amazon.com (Postfix) with ESMTPS id 61930A01F7;
        Fri, 10 Jan 2020 00:54:18 +0000 (UTC)
Received: from EX13D01UWB001.ant.amazon.com (10.43.161.75) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 10 Jan 2020 00:54:12 +0000
Received: from EX13MTAUWB001.ant.amazon.com (10.43.161.207) by
 EX13d01UWB001.ant.amazon.com (10.43.161.75) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 10 Jan 2020 00:54:12 +0000
Received: from dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com
 (172.22.96.68) by mail-relay.amazon.com (10.43.161.249) with Microsoft SMTP
 Server id 15.0.1367.3 via Frontend Transport; Fri, 10 Jan 2020 00:54:12 +0000
Received: by dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com (Postfix, from userid 4335130)
        id A7D9340E78; Fri, 10 Jan 2020 00:54:12 +0000 (UTC)
Date:   Fri, 10 Jan 2020 00:54:12 +0000
From:   Anchal Agarwal <anchalag@amazon.com>
To:     Boris Ostrovsky <boris.ostrovsky@oracle.com>
CC:     <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <hpa@zytor.com>, <x86@kernel.org>, <jgross@suse.com>,
        <linux-pm@vger.kernel.org>, <linux-mm@kvack.org>,
        <kamatam@amazon.com>, <sstabellini@kernel.org>,
        <konrad.wilk@oracle.co>, <roger.pau@citrix.com>, <axboe@kernel.dk>,
        <davem@davemloft.net>, <rjw@rjwysocki.net>, <len.brown@intel.com>,
        <pavel@ucw.cz>, <peterz@infradead.org>, <eduval@amazon.com>,
        <sblbir@amazon.com>, <xen-devel@lists.xenproject.org>,
        <vkuznets@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <Woodhouse@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>,
        <dwmw@amazon.co.uk>, <fllinden@amaozn.com>, <anchalag@amazon.com>
Subject: Re: [RFC PATCH V2 01/11] xen/manage: keep track of the on-going
 suspend mode
Message-ID: <20200110005412.GA2095@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
References: <20200107233720.GA17906@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <88721569-d425-8df3-2ab2-3aa9155b326c@oracle.com>
 <b0392e02-c783-8aaa-ab5e-8e29385fa281@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b0392e02-c783-8aaa-ab5e-8e29385fa281@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 09, 2020 at 06:49:07PM -0500, Boris Ostrovsky wrote:
> 
> 
> On 1/9/20 6:46 PM, Boris Ostrovsky wrote:
> >
> >
> >On 1/7/20 6:37 PM, Anchal Agarwal wrote:
> >>+
> >>+static int xen_setup_pm_notifier(void)
> >>+{
> >>+    if (!xen_hvm_domain())
> >>+        return -ENODEV;
> >
> >ARM guests are also HVM domains. Is it OK for them to register the
> >notifier? The diffstat suggests that you are supporting ARM.
> 
> I obviously meant *not* supporting ARM, sorry.
> 
> -boris
> 
> >
> >-boris
> >

TBH, I have not yet experimented with these patches on
ARM guest yet but that will be the next step. The same 
code with changes as needed should be made to work for ARM.
Currently I am focussed on getting a sane set of 
patches into mainline for x86 guests.

Thanks,

Anchal

> >>+
> >>+    return register_pm_notifier(&xen_pm_notifier_block);
> >>+}
> >>
> >
> 
