Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0EF83730D0
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 21:31:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232254AbhEDTca (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 15:32:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbhEDTcY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 May 2021 15:32:24 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3D1DC061574
        for <netdev@vger.kernel.org>; Tue,  4 May 2021 12:31:27 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id l2so10619085wrm.9
        for <netdev@vger.kernel.org>; Tue, 04 May 2021 12:31:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YpfdYp+JammDZESyHmE088kxmPUUqxIHCGvlq8nXxpY=;
        b=j/WXxxfQsZvVmuZVliChNFVU7aT9nwZKZxJlgw8j6vwyBMJQIDgTvMhhvvsb/aUZ+s
         Ht66WoLanlTS7w9OzbVIO4pBrL1SDrzveyJqBQcgydbq5AHDz52J7G4IwZ5QD4E5wS3o
         RZBHxKj0+d9H9Jt6a+PClKmf1/PShoGnd51aJrIrfBG6q2CM7k7dbFG/3hkl9wI5MF2q
         HH3Jgh5Sz2T0KC/V+R8TjzmNZB1QZyVL4U95jMbd4yZ1LEGWiB1/8kVE68PcW9BMYs2p
         mGeQasLLosgauSyWkceQWjraHgRS1J+EDrwqea7x6EtXyltMADF4sH6tC+wwXlIJsSvV
         0aAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YpfdYp+JammDZESyHmE088kxmPUUqxIHCGvlq8nXxpY=;
        b=rOPP5B7tUrxbRvm2HBmVlDvtIJNS63hX+kWHsRu8bdQ9cT0HL1a60vJbXYEfjn7fj7
         JKZKoVKObcqmZov+p4cHG9N5PKcoOQ1gVnJCz01feaukb7xtkLuK74oCSfZjnqhxMeY9
         MnqsamXw4WneOwPzI/kb4XMqREAqrXwfWbwsHDqK2Wm106cvV4yaa8lKeZxY/oXESv0W
         sLSBzFDxtWgM35ILSkvAmJwXSEGC8AfkM1IB2Dl7NtsN7xuMuCuVWmSMjDdrKCKsTM7j
         E73mjlRAdqLHb5MN94xUoCgGH0qD3FQeV5pRMnQaM7/S2Ds/Ld86ZkEavQUht6YxbdIZ
         bqZQ==
X-Gm-Message-State: AOAM5301qDEQYGKermSCQs6EEpcMUBi3r1Akb8B0DDZ3TmzpxxK1IbD3
        0ZG2o7USH+2BTdIrfaCem7tD2teQynEyW2YfNJ4=
X-Google-Smtp-Source: ABdhPJzlr3EBkUDz4QZQc+t8xlVBDRUzjeEjuYXu+QICXxPO21RTvGT5X0wWy19CMAWDQyOS6niN1HtdNW7El1YSueQ=
X-Received: by 2002:a5d:64e4:: with SMTP id g4mr33808275wri.366.1620156686702;
 Tue, 04 May 2021 12:31:26 -0700 (PDT)
MIME-Version: 1.0
References: <20210504191142.2872696-1-drt@linux.ibm.com> <CAOhMmr5T_BLkqGspnzck=xtiX0rPABv8oX4=LCRbH00T8-B6qw@mail.gmail.com>
In-Reply-To: <CAOhMmr5T_BLkqGspnzck=xtiX0rPABv8oX4=LCRbH00T8-B6qw@mail.gmail.com>
From:   Lijun Pan <lijunp213@gmail.com>
Date:   Tue, 4 May 2021 14:31:15 -0500
Message-ID: <CAOhMmr5ucF3pa4jp9RLEzJNs29oVT0qAXmywNnd+Xe2seoRJfg@mail.gmail.com>
Subject: Re: [PATCH net v3] ibmvnic: Continue with reset if set link down failed
To:     Dany Madden <drt@linux.ibm.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        Thomas Falcon <tlfalcon@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 4, 2021 at 2:27 PM Lijun Pan <lijunp213@gmail.com> wrote:
>
> On Tue, May 4, 2021 at 2:14 PM Dany Madden <drt@linux.ibm.com> wrote:
> >
> > When ibmvnic gets a FATAL error message from the vnicserver, it marks
> > the Command Respond Queue (CRQ) inactive and resets the adapter. If this
> > FATAL reset fails and a transmission timeout reset follows, the CRQ is
> > still inactive, ibmvnic's attempt to set link down will also fail. If
> > ibmvnic abandons the reset because of this failed set link down and this
> > is the last reset in the workqueue, then this adapter will be left in an
> > inoperable state.
> >
> > Instead, make the driver ignore this link down failure and continue to
> > free and re-register CRQ so that the adapter has an opportunity to
> > recover.
> >
> > Fixes: ed651a10875f ("ibmvnic: Updated reset handling")
> > Signed-off-by: Dany Madden <drt@linux.ibm.com>
> > Reviewed-by: Rick Lindsley <ricklind@linux.ibm.com>
> > Reviewed-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
> > ---
> > Changes in V2:
> > - Update description to clarify background for the patch
> > - Include Reviewed-by tags
> > Changes in V3:
> > - Add comment above the code change
> > ---
> >  drivers/net/ethernet/ibm/ibmvnic.c | 11 +++++++++--
> >  1 file changed, 9 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
> > index 5788bb956d73..9e005a08d43b 100644
> > --- a/drivers/net/ethernet/ibm/ibmvnic.c
> > +++ b/drivers/net/ethernet/ibm/ibmvnic.c
> > @@ -2017,8 +2017,15 @@ static int do_reset(struct ibmvnic_adapter *adapter,
> >                         rtnl_unlock();
> >                         rc = set_link_state(adapter, IBMVNIC_LOGICAL_LNK_DN);
> >                         rtnl_lock();
> > -                       if (rc)
> > -                               goto out;
> > +
> > +                       /* Attempted to set the link down. It could fail if the
> > +                        * vnicserver has already torn down the CRQ. We will
> > +                        * note it and continue with reset to reinit the CRQ.
> > +                        */
> > +                       if (rc) {
> > +                               netdev_dbg(netdev,
> > +                                          "Setting link down failed rc=%d. Continue anyway\n", rc);
> > +                       }
>
> There are other places which check and rely on the return value of
> this function. Your change makes that inconsistent. Can you stop

To be more specific, __ibmvnic_close, __ibmvnic_open both call this
set_link_state.

> posting new versions and soliciting the maintainer to accept it before
> there is material change? There are many ways to make reset
> successful. I think this is the worst approach of all.
>
>
> >
> >                         if (adapter->state == VNIC_OPEN) {
> >                                 /* When we dropped rtnl, ibmvnic_open() got
> > --
> > 2.18.2
> >
