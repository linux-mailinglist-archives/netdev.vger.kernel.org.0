Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DB792D34B6
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 22:03:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729545AbgLHU5P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 15:57:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727988AbgLHU5O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 15:57:14 -0500
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ED51C0613D6
        for <netdev@vger.kernel.org>; Tue,  8 Dec 2020 12:56:34 -0800 (PST)
Received: by mail-il1-x131.google.com with SMTP id k8so16754336ilr.4
        for <netdev@vger.kernel.org>; Tue, 08 Dec 2020 12:56:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7+dd4AcO6XF4CSTyM4Poz45WMoNGquQg2COnNYpIkzI=;
        b=U65/ij2E5fO/B9qn7KdFDq20c18l+jeOYLcaNkhRD8zLzKIU4xmX9M6zR42osHUOf6
         jfZbT3SVRkHIwvJwrFOWA51lZ8fGKVghZCwVqvRXBzIyHtxImOa7CkkkRA6m8KL1rtth
         yPaUCWc1vq5M3d9yFA5vIlIeGV1bOoexQIvn7sV0iuuvn5+tzBdOrlSlybXot0hFn6oI
         nkPHw2b5FtdKouvXQJpOibco5Pl720O69T6K9uX2CObptSA8Y+H69AN11tNazI1UaZfa
         jp0QRaUH55YbHNcXeDQw0Dgrbsaa4KDU6HqZvG4wOr7ZvJf6agwQN5ByjKTF9slyeEJD
         T83A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7+dd4AcO6XF4CSTyM4Poz45WMoNGquQg2COnNYpIkzI=;
        b=TsRU7wjtm2+kKY0xvsBWKVets/Nn28Y3qbGX6L2P/qMWHQSktxPTADDdaesP1hmbpT
         ra1dJhSmpBTB61nOmQNXrUehYmghGmD90SgR+il60ZNuL6PAJFCVs61pV/WT6ItO+5zB
         +qUTiTadVZH69oC2DW+KU2dqFm38Wx/6+ACCoOXzIF0EPTi525E/E8wtBURfc7SVvSS7
         f9X2Zszqs4uHtKs456D2e1fPAvurxA8WpzTrV5FgBFxnDoWKJlzqaNBPk4EHgwzy4AaR
         4SS6E6D9H0PgEj/Ugvc1tjDm4NdrCK6jHxeN8qZLVe5gCK0wmXMOw8Ff0zgR1LZ0ozMH
         6XBg==
X-Gm-Message-State: AOAM533e5Yh6HrHx2Q4G3bnbxV08f3ydyRD6BD0qsCQrT9Ugi1g6nGoX
        cg9Gv+9vXBfZmgGkovg3gyqLccrl3ZtW4CQoHSRTFXsAxsw=
X-Google-Smtp-Source: ABdhPJzqrR5HAt9NAI57UqrQMWibbgFHIEGB0LubDgKM1+7ZrLAtktzTXLW8DXautOoHKuPLOI+YtQHYiIIDzEIb7yw=
X-Received: by 2002:a92:730d:: with SMTP id o13mr27591052ilc.95.1607454012076;
 Tue, 08 Dec 2020 11:00:12 -0800 (PST)
MIME-Version: 1.0
References: <20201113214429.2131951-1-anthony.l.nguyen@intel.com>
 <20201113214429.2131951-6-anthony.l.nguyen@intel.com> <CAKgT0UeQ5q2M-uiR0-1G=30syPiO8S5OFHvDuN1XtQg5700hCg@mail.gmail.com>
 <fd0fc6f95f4c107d1aed18bf58239fda91879b26.camel@intel.com>
 <CAKgT0Uewo+Rr19EVf9br9zBPsyOUANGMSQ0kqNVAzOJ8cjWMdw@mail.gmail.com>
 <20201123152137.00003075@intel.com> <CAKgT0UcoYrfONNVrRcTydahgH8zqk=ans+w0RcdqugzRdodsWQ@mail.gmail.com>
 <4bd4d1e76cd74319ab54aa5ff63a1e3979c62887.camel@intel.com>
In-Reply-To: <4bd4d1e76cd74319ab54aa5ff63a1e3979c62887.camel@intel.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 8 Dec 2020 11:00:01 -0800
Message-ID: <CAKgT0Uf+Q_dcx5Jj99XFVwf=AxbAWAD_r9PUAsbOCXdR46cMig@mail.gmail.com>
Subject: Re: [net-next v3 05/15] ice: create flow profile
To:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Cc:     "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Cao, Chinh T" <chinh.t.cao@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Behera, BrijeshX" <brijeshx.behera@intel.com>,
        "Valiquette, Real" <real.valiquette@intel.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 8, 2020 at 8:58 AM Nguyen, Anthony L
<anthony.l.nguyen@intel.com> wrote:
>
> On Mon, 2020-11-23 at 17:11 -0800, Alexander Duyck wrote:
> > On Mon, Nov 23, 2020 at 3:21 PM Jesse Brandeburg
> > <jesse.brandeburg@intel.com> wrote:
> > >
> > > Alexander Duyck wrote:
> > >
> > > > > > I'm not sure this logic is correct. Can the flow director
> > > > > > rules
> > > > > > handle
> > > > > > a field that is removed? Last I knew it couldn't. If that is
> > > > > > the case
> > > > > > you should be using ACL for any case in which a full mask is
> > > > > > not
> > > > > > provided. So in your tests below you could probably drop the
> > > > > > check
> > > > > > for
> > > > > > zero as I don't think that is a valid case in which flow
> > > > > > director
> > > > > > would work.
> > > > > >
> > > > >
> > > > > I'm not sure what you meant by a field that is removed, but
> > > > > Flow
> > > > > Director can handle reduced input sets. Flow Director is able
> > > > > to handle
> > > > > 0 mask, full mask, and less than 4 tuples. ACL is needed/used
> > > > > only when
> > > > > a partial mask rule is requested.
> > > >
> > > > So historically speaking with flow director you are only allowed
> > > > one
> > > > mask because it determines the inputs used to generate the hash
> > > > that
> > > > identifies the flow. So you are only allowed one mask for all
> > > > flows
> > > > because changing those inputs would break the hash mapping.
> > > >
> > > > Normally this ends up meaning that you have to do like what we
> > > > did in
> > > > ixgbe and disable ATR and only allow one mask for all inputs. I
> > > > believe for i40e they required that you always use a full 4
> > > > tuple. I
> > > > didn't see something like that here. As such you may want to
> > > > double
> > > > check that you can have a mix of flow director rules that are
> > > > using 1
> > > > tuple, 2 tuples, 3 tuples, and 4 tuples as last I knew you
> > > > couldn't.
> > > > Basically if you had fields included they had to be included for
> > > > all
> > > > the rules on the port or device depending on how the tables are
> > > > set
> > > > up.
> > >
> > > The ice driver hardware is quite a bit more capable than the ixgbe
> > > or
> > > i40e hardware, and uses a limited set of ACL rules to support
> > > different
> > > sets of masks. We have some limits on the number of masks and the
> > > number of fields that we can simultaneously support, but I think
> > > that is pretty normal for limited hardware resources.
> > >
> > > Let's just say that if the code doesn't work on an E810 card then
> > > we
> > > messed up and we'll have to fix it. :-)
> > >
> > > Thanks for the review! Hope this helps...
> >
> > I gather all that. The issue was the code in ice_is_acl_filter().
> > Basically if we start dropping fields it will not trigger the rule to
> > be considered an ACL rule if the field is completely dropped.
> >
> > So for example I could define 4 rules, one that ignores the IPv4
> > source, one that ignores the IPv4 destination, one that ignores the
> > TCP source port, and one that ignores the TCP destination port.
>
> We have the limitation that you can use one input set at a time so any
> of these rules could be created but they couldn't exist concurrently.

No, I get that. The question I have is what happens if you try to
input a second input set. With ixgbe we triggered an error for trying
to change input sets. I'm wondering if you trigger an error on adding
a different input set or if you just invalidate the existing rules.

> > With
> > the current code all 4 of those rules would be considered to be
> > non-ACL rules because the mask is 0 and not partial.
>
> Correct. I did this to test Flow Director:
>
> 'ethtool -N ens801f0 flow-type tcp4 src-ip 192.168.0.10 dst-ip
> 192.168.0.20 src-port 8500 action 10' and sent traffic matching this.
> Traffic correctly went to queue 10.

So a better question here is what happens if you do a rule with
src-port 8500, and a second rule with dst-port 8500? Does the second
rule fail or does it invalidate the first. If it invalidates the first
then that would be a bug.

> > If I do the same
> > thing and ignore all but one bit then they are all ACL rules.
>
> Also correct. I did as follows:
>
> 'ethtool -N ens801f0 flow-type tcp4 src-ip 192.168.0.10 dst-ip
> 192.168.0.20 src-port 9000 m 0x1 action 15'
>
> Sending traffic to port 9000 and 90001, traffic went to queue 15
> Sending traffic to port 8000 and 90002, traffic went to other queues

The test here is to set-up two rules and verify each of them and one
case that fails both. Same thing for the test above. Basically we
should be able to program multiple ACL rules with different masks and
that shouldn't be an issue up to some limit I would imagine. Same
thing for flow director rules. After the first you should not be able
to provide a flow director rule with a different input mask.

- Alex
