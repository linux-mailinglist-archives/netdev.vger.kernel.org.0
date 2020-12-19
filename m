Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D0C82DF02D
	for <lists+netdev@lfdr.de>; Sat, 19 Dec 2020 16:20:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbgLSPTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Dec 2020 10:19:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726578AbgLSPTe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Dec 2020 10:19:34 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D2FBC0617B0;
        Sat, 19 Dec 2020 07:18:53 -0800 (PST)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kqe0H-00Bye3-DL; Sat, 19 Dec 2020 16:18:41 +0100
Message-ID: <9003ea3720a03b4bd1b8abf3d8f645563a58f953.camel@sipsolutions.net>
Subject: Re: net: tso: add UDP segmentation support: adds regression for
 ax200 upload
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>,
        Ben Greear <greearb@candelatech.com>,
        Luca Coelho <luciano.coelho@intel.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org
Date:   Sat, 19 Dec 2020 16:18:40 +0100
In-Reply-To: <20201218121627.603329b2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <5664fa0f-aef2-c336-651a-093c9eed23ab@candelatech.com>
         <765f370d-ce2d-b75a-2dde-87f69ae7c185@candelatech.com>
         <CANn89iKpa1y2SKJuR9kRi=AZs94sj+-tzRs+2D0vmxh+ahEcGA@mail.gmail.com>
         <adbee2ec-c6ba-7a17-eb98-1c53365fa911@candelatech.com>
         <CANn89iJQnSVZFp2XDgREN1QMtU4exOsnJq=5VzJ6tqTCJ7MH-g@mail.gmail.com>
         <c4bcee7d-b2eb-759c-c659-d65f3e7daec9@candelatech.com>
         <CANn89i++Kgkj57ms70a5GDOQ-Cpewx3NQkzP3EmZmLYQ4eHzww@mail.gmail.com>
         <5d89fd24-f00a-7e70-00ce-83529f13b05e@candelatech.com>
         <20201218121627.603329b2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2020-12-18 at 12:16 -0800, Jakub Kicinski wrote:
> On Thu, 17 Dec 2020 12:40:26 -0800 Ben Greear wrote:
> > On 12/17/20 10:20 AM, Eric Dumazet wrote:
> > > On Thu, Dec 17, 2020 at 7:13 PM Ben Greear <greearb@candelatech.com> wrote:  
> > > > It is the iwlwifi/mvm logic that supports ax200.  
> > > 
> > > Let me ask again :
> > > 
> > > I see two different potential call points :
> > > 
> > > drivers/net/wireless/intel/iwlwifi/pcie/tx.c:1529:
> > > tso_build_hdr(skb, hdr_page->pos, &tso, data_left, !total_len);
> > > drivers/net/wireless/intel/iwlwifi/queue/tx.c:427:
> > > tso_build_hdr(skb, hdr_page->pos, &tso, data_left, !total_len);
> > > 
> > > To the best of your knowledge, which one would be used in your case ?
> > > 
> > > Both are horribly complex, I do not want to spend time studying two
> > > implementations.  
> > 
> > It is the queue/tx.c code that executes on my system, verified with
> > printk.
> 
> Not sure why Intel's not on CC here. 

Heh :)

Let's also add linux-wireless.

> Luca, is the ax200 TSO performance regression with recent kernel on your
> radar?

It wasn't on mine for sure, so far. But it's supposed to be Christmas
vacation, so haven't checked our bug tracker etc. I see Emmanuel was at
least looking at the bug report, but not sure what else happened yet.

Off the top of my head, I don't really see the issue. Does anyone have
the ability to capture the frames over the air (e.g. with another AX200
in monitor mode, load the driver with amsdu_size=3 module parameter to
properly capture A-MSDUs)?

johannes

