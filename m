Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51D03284E9C
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 17:05:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726519AbgJFPFj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 11:05:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:31442 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726123AbgJFPFi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 11:05:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601996736;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2SZb0+sOKzdlQiMWtCf9ytWY4nvBw9Fu6L0oBKKF1hk=;
        b=hNzZ+tpwpQyqUPzYMZzYYdkKp0cqocfBIP4crxM6wiJcGMiN/mDfdnuT5GAx/cMMxXoN6V
        S9rfKLIgMpvpiapYn429ip3U3AB6v4u5HSCIbnIePqn+ytNYH3aDKil2SEGtJap+vyrudU
        OhOGo27VmpA86nmX3bF5d4iCfuLBj3k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-190-kE9ajDNyM2aksN2lWwbBsA-1; Tue, 06 Oct 2020 11:05:32 -0400
X-MC-Unique: kE9ajDNyM2aksN2lWwbBsA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D322C18A8226;
        Tue,  6 Oct 2020 15:05:30 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.10.110.44])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BBB6A76646;
        Tue,  6 Oct 2020 15:05:28 +0000 (UTC)
Message-ID: <344c84c66b39864372fd3eb7231575b0cdb1386c.camel@redhat.com>
Subject: Re: [RFC] Status of orinoco_usb
From:   Dan Williams <dcbw@redhat.com>
To:     Jes Sorensen <jes.sorensen@gmail.com>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date:   Tue, 06 Oct 2020 10:05:27 -0500
In-Reply-To: <7f6e7c37-b7d6-1da4-6a3d-257603afd2ae@gmail.com>
References: <20201002103517.fhsi5gaepzbzo2s4@linutronix.de>
         <20201002113725.GB3292884@kroah.com>
         <20201002115358.6aqemcn5vqc5yqtw@linutronix.de>
         <20201002120625.GA3341753@kroah.com> <877ds4damx.fsf@codeaurora.org>
         <0c67580b-1bed-423b-2f00-49eae20046aa@broadcom.com>
         <7f6e7c37-b7d6-1da4-6a3d-257603afd2ae@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-10-06 at 08:40 -0400, Jes Sorensen wrote:
> On 10/6/20 3:45 AM, Arend Van Spriel wrote:
> > + Jes
> > 
> > On 10/5/2020 4:12 PM, Kalle Valo wrote:
> > > Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
> > > 
> > > > On Fri, Oct 02, 2020 at 01:53:58PM +0200, Sebastian Andrzej
> > > > Siewior
> > > > wrote:
> > > > > On 2020-10-02 13:37:25 [+0200], Greg Kroah-Hartman wrote:
> > > > > > > Is it possible to end up here in softirq context or is
> > > > > > > this a relic?
> > > > > > 
> > > > > > I think it's a relic of where USB host controllers
> > > > > > completed their
> > > > > > urbs
> > > > > > in hard-irq mode.  The BH/tasklet change is a pretty recent
> > > > > > change.
> > > > > 
> > > > > But the BH thingy for HCDs went in v3.12 for EHCI. XHCI was
> > > > > v5.5. My
> > > > > guess would be that people using orinoco USB are on EHCI :)
> > > > 
> > > > USB 3 systems run XHCI, which has a USB 2 controller in it, so
> > > > these
> > > > types of things might not have been noticed yet.  Who knows :)
> > > > 
> > > > > > > Should it be removed?
> > > > > > 
> > > > > > We can move it out to drivers/staging/ and then drop it to
> > > > > > see if
> > > > > > anyone
> > > > > > complains that they have the device and is willing to test
> > > > > > any
> > > > > > changes.
> > > > > 
> > > > > Not sure moving is easy since it depends on other files in
> > > > > that folder.
> > > > > USB is one interface next to PCI for instance. Unless you
> > > > > meant to move
> > > > > the whole driver including all interfaces.
> > > > > I was suggesting to remove the USB bits.
> > > > 
> > > > I forgot this was tied into other code, sorry.  I don't know
> > > > what to
> > > > suggest other than maybe try to fix it up the best that you
> > > > can, and
> > > > let's see if anyone notices...
> > > 
> > > That's what I would suggest as well.
> > > 
> > > These drivers for ancient hardware are tricky. Even if there
> > > doesn't
> > > seem to be any users on the driver sometimes people pop up
> > > reporting
> > > that it's still usable. We had that recently with one another
> > > wireless
> > > driver (forgot the name already).
> > 
> > Quite a while ago I shipped an orinoco dongle to Jes Sorensen which
> > he
> > wanted to use for some intern project if I recall correctly. Guess
> > that
> > idea did not fly yet.
> 
> I had an outreachy intern who worked on some of it, so I shipped all
> my
> Orinoco hardware to her. We never made as much progress as I had
> hoped,
> and I haven't had time to work on it since.

If anyone wants orinoco_usb, I think I still have one or two. I may
also have original orinoco hardware (PCMCIA) if anyone wants it.

Dan

