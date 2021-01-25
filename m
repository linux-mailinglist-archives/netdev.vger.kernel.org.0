Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2EF630339D
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 06:01:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725806AbhAZFAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:00:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728192AbhAYMmZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 07:42:25 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 921D2C0611C3;
        Mon, 25 Jan 2021 04:40:22 -0800 (PST)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1l41AK-00BPsj-3w; Mon, 25 Jan 2021 13:40:20 +0100
Message-ID: <671b0c37867803d7229ef0c4a33baf2c7778df08.camel@sipsolutions.net>
Subject: Re: pull-request: mac80211 2021-01-18.2
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Hans de Goede <hdegoede@redhat.com>,
        "Peer, Ilan" <ilan.peer@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Coelho, Luciano" <luciano.coelho@intel.com>
Date:   Mon, 25 Jan 2021 13:40:19 +0100
In-Reply-To: <6c949dbe-5593-2274-7099-c2768b770aad@redhat.com>
References: <20210118204750.7243-1-johannes@sipsolutions.net>
         <77c606d4-a78a-1fa3-5937-b270c3d0bbd3@redhat.com>
         <b83f6cf001c4e3df97eeaed710b34fda0a08265f.camel@sipsolutions.net>
         <BN7PR11MB2610052E380E676ED5CCCC67E9BE9@BN7PR11MB2610.namprd11.prod.outlook.com>
         <348210d8-6940-ca8d-e3b1-f049330a2087@redhat.com>
         <666b3449fe33d34123255cc69da3aa46fc276dcb.camel@sipsolutions.net>
         <6c949dbe-5593-2274-7099-c2768b770aad@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

> > I don't have that much sympathy for a staging driver that's clearly
> > doing things differently than it was intended (the documentation states
> > that the function should be called only before wiphy_register(), not
> > during ndo_open). :-)
> 
> I completely understand and I already was worried that this might be
> a staging-driver issue, which is why I mentioned this was with a
> staging driver in the more detailed bug-report email.

I guess I missed that, but no worries.

> > But OTOH, that fix to the driver is simple and looks correct to me since
> > it only ever has a static regdomain, and the notifier does the work of
> > applying it to the channels as well.
> 
> So I've given your fix a quick try and it leads to a NULL pointer deref.

Ouch. Oh. I see, that driver is *really* stupid, trying to get to the
wiphy from the adapter, but going through the wdev instead ... ouch.

Wow are these pointers a mess in that driver ... Something like this,
perhaps?

https://p.sipsolutions.net/4400d9a3b7b800bb.txt

johannes

