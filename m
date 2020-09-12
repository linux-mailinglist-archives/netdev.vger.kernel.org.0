Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E335F26790F
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 11:10:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725850AbgILJKo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Sep 2020 05:10:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725805AbgILJKn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Sep 2020 05:10:43 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D708C061573;
        Sat, 12 Sep 2020 02:10:41 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id kk9so2839904pjb.2;
        Sat, 12 Sep 2020 02:10:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7PYEesOAlpZ6EGj+ZnorXol6wlG+lLB6E3fRAdDw39I=;
        b=lockxSqeqPWAPyWQut+klsJTsZpv/mmjtq1Ew3/fyzkXskyq9Dl+ybw70ltuZfRtuX
         difHzAuL51vYSHWAir+mRZza4wHpdP1pHV46ko9Ga5U8IC05HBFJ/JQLzq0KctECG1wK
         Uk5zt8nBHZ7qwgxnidBiRryGNMHkruOBUJ84m3Oa1b3ueDgwn7cmfAFA2QyjHJgnDhnK
         02r7kfVpw8R9LZ9Qa23uE6dTIzKnUBFgwI15ECSB4BWGVugVmo2yL+EHGjWnM2AwOGgM
         akRHdwx7b97bDLm9VorOZpH96KvLzuFVMCpRGBdU7rrOJwizb1VMv55gBXsQOcDQwg7e
         fM8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7PYEesOAlpZ6EGj+ZnorXol6wlG+lLB6E3fRAdDw39I=;
        b=eqHeFpMuZp8NISlnO5jaK+fIQMWR2yWSA31NmK0IWJane6V/33W74F3bc07szdlglA
         X7NUq9ghhJxjQ3ANY0bmuyLASdkx3i+F1sT81lzyUMQz5kMxuoqkdwDqXQHYVaKPd198
         WQkAwQlE5JGMNdldcV6sqrr5wV5cPoix8gAWBmxmHLi98FEOD5mD11h66JaE3rR2FCU8
         85ZzS3YolplvyTrZumNuN96Gh+MvBYCGCb9Qbo6i3mKuQqyP+Smu6JaZtIM1CPhGfHbJ
         rOrzu5DAJHyqNpyueqjAFZ0AfV3kR055HUAH4uj+Q/LuOCj4fs9GDn/fzeqKz7qkEsfX
         rzPQ==
X-Gm-Message-State: AOAM532pz5Fl3XzjOQrztcQVYoobuPubUVIraSM+OICluzNXLNvwffsD
        J0S+9lEi7DJTDRrztzQB/90=
X-Google-Smtp-Source: ABdhPJxAqItjHVWxp6Lt4YSjOiMy5z9xtkVG0MWQy8GWhKJivsm6O70ySfZCGPyc1Pzc/2mtPgU9bA==
X-Received: by 2002:a17:90b:617:: with SMTP id gb23mr5593370pjb.36.1599901837539;
        Sat, 12 Sep 2020 02:10:37 -0700 (PDT)
Received: from Thinkpad ([45.118.165.151])
        by smtp.gmail.com with ESMTPSA id ca6sm3870611pjb.53.2020.09.12.02.10.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Sep 2020 02:10:36 -0700 (PDT)
Date:   Sat, 12 Sep 2020 14:40:28 +0530
From:   Anmol Karn <anmol.karan123@gmail.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     marcel@holtmann.org, johan.hedberg@gmail.com,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        netdev@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net,
        syzbot+0bef568258653cff272f@syzkaller.appspotmail.com
Subject: Re: [Linux-kernel-mentees] [PATCH] net: bluetooth: Fix null pointer
 dereference in hci_event_packet()
Message-ID: <20200912091028.GA67109@Thinkpad>
References: <20200910043424.19894-1-anmol.karan123@gmail.com>
 <20200910104918.GF12635@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200910104918.GF12635@kadam>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 10, 2020 at 01:49:18PM +0300, Dan Carpenter wrote:
> On Thu, Sep 10, 2020 at 10:04:24AM +0530, Anmol Karn wrote:
> > Prevent hci_phy_link_complete_evt() from dereferencing 'hcon->amp_mgr'
> > as NULL. Fix it by adding pointer check for it.
> > 
> > Reported-and-tested-by: syzbot+0bef568258653cff272f@syzkaller.appspotmail.com
> > Link: https://syzkaller.appspot.com/bug?extid=0bef568258653cff272f
> > Signed-off-by: Anmol Karn <anmol.karan123@gmail.com>
> > ---
> >  net/bluetooth/hci_event.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
> > index 4b7fc430793c..871e16804433 100644
> > --- a/net/bluetooth/hci_event.c
> > +++ b/net/bluetooth/hci_event.c
> > @@ -4936,6 +4936,11 @@ static void hci_phy_link_complete_evt(struct hci_dev *hdev,
> >  		return;
> >  	}
> >  
> > +	if (IS_ERR_OR_NULL(hcon->amp_mgr)) {
> 
> It can't be an error pointer.  Shouldn't we call hci_conn_del() on this
> path?  Try to find the Fixes tag to explain how this bug was introduced.
> 
> (Don't rush to send a v2.  The patch requires quite a bit more digging
> and detective work before it is ready).
> 
> > +		hci_dev_unlock(hdev);
> > +		return;
> > +	}
> > +
> >  	if (ev->status) {
> >  		hci_conn_del(hcon);
> >  		hci_dev_unlock(hdev);
> 
> regards,
> dan carpenter
> 

Sir,

I need little advice in continuing with this Patch,

I have looked into the Bisected logs and the problem occurs from this commit:

941992d29447 ("ethernet: amd: use IS_ENABLED() instead of checking for built-in or module")


Here is a diff of patch which i modified from last patch,

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 4b7fc430793c..6ce435064e0b 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -4936,6 +4936,12 @@ static void hci_phy_link_complete_evt(struct hci_dev *hdev,
                return;
        }

+       if (!hcon->amp_mgr) {
+               hci_conn_del(hcon);
+               hci_dev_unlock(hdev);
+               return;
+       }
+
        if (ev->status) {
                hci_conn_del(hcon);
                hci_dev_unlock(hdev);


The value of 'hcon->amp_mgr' getting NULL due to hci_conn_hash_lookup_handle call
, and there is not any checks there for the members of hcon, which enables 
hci_phy_link_complete_evt() to dereference 'hcon->amp_mgr' as NULL.

please suggest improvements to this patch.

Regards,
Anmol  
