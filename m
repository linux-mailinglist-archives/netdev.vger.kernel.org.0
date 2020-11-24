Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5687B2C1AB3
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 02:12:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729522AbgKXBLf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 20:11:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728576AbgKXBLf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 20:11:35 -0500
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24BA9C0613CF
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 17:11:35 -0800 (PST)
Received: by mail-il1-x135.google.com with SMTP id t13so17755034ilp.2
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 17:11:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HklNV7Z5SeUqM6EgcLpiqnB4a/G5zUk7LdyWdJmUNm4=;
        b=Z1bKSkG7WXoYUxJlYzy5JmVhe9FN6vVASBjO+AwxMoYpgnymanD4Pm21bk47i3VUM1
         nYQ5TMnyCKBv5u0VOUofQ9lIKoRWQi1PI3yDnx5Cp787jk5hQDNrgN/AfdgZc2eVx3M4
         PxL2J7LN/Mpy764oMeZmpALErsAhZpBadYRIM77OUE718tnZa7DTnZQTcLfpPQkVdvxa
         G3lCNeyeGpD7pjgo0lqgn94WE6Pa/6vfp8eXwqxZflByRp4m3ezEA7p13wQcaMBIMivo
         dUzJQRIg+sVsI9/vvjhaoyiivArcsQhDGpESp+Fo1Wk00VLt+8cExaAc+OsGi1sfmXch
         7cgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HklNV7Z5SeUqM6EgcLpiqnB4a/G5zUk7LdyWdJmUNm4=;
        b=SCIX/5Pb6RDdKYHwvZSiZS4E3JUR8s5zzQM+rbixZEk4tJ9kT3W+WMaBT/M+P71BoP
         hdWvv4d73FeYjxOXOApqEKLRlYC+GSLLsx0LtNyEUvlsfwQ/D7UHUh3jiYgY/j8Rclxq
         A0SjTlftTFinDyJUWYy/G6hXpLjzd9/cfHBa1hJy1kHxJPPv93jVYET9AkPs7BKpPWaM
         2ksm2lPXm9e992/J33DBLJF5Wgh8PgTJBrg0moFXaiWtbMvHs9pew79VKKEkj6zj/Oe1
         aIBBrf1R/ru0FHlh1rLtAPO1trbDpUxcYiUmTs7pTWEpWO3XmgDt7c8OZS3ib5BwS5ZC
         XcOg==
X-Gm-Message-State: AOAM5335AaL5cHbOVwib1XjURIxZ7E31dy0grmrJ0gh4mFDeuFkxCaoQ
        1vyPWbMXV4MfCOqGNST8OBp50Q6KZPVKEOBDJJA=
X-Google-Smtp-Source: ABdhPJyRoBUUAz4xS7PV3I1zqUyZbFO45jzVVRGidkiKPG6Cko+821i9AOC0yspu3GFqO1Z7yuE/+LM4RoqDuGHrMeU=
X-Received: by 2002:a05:6e02:120f:: with SMTP id a15mr2044200ilq.97.1606180294275;
 Mon, 23 Nov 2020 17:11:34 -0800 (PST)
MIME-Version: 1.0
References: <20201113214429.2131951-1-anthony.l.nguyen@intel.com>
 <20201113214429.2131951-6-anthony.l.nguyen@intel.com> <CAKgT0UeQ5q2M-uiR0-1G=30syPiO8S5OFHvDuN1XtQg5700hCg@mail.gmail.com>
 <fd0fc6f95f4c107d1aed18bf58239fda91879b26.camel@intel.com>
 <CAKgT0Uewo+Rr19EVf9br9zBPsyOUANGMSQ0kqNVAzOJ8cjWMdw@mail.gmail.com> <20201123152137.00003075@intel.com>
In-Reply-To: <20201123152137.00003075@intel.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 23 Nov 2020 17:11:23 -0800
Message-ID: <CAKgT0UcoYrfONNVrRcTydahgH8zqk=ans+w0RcdqugzRdodsWQ@mail.gmail.com>
Subject: Re: [net-next v3 05/15] ice: create flow profile
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
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

On Mon, Nov 23, 2020 at 3:21 PM Jesse Brandeburg
<jesse.brandeburg@intel.com> wrote:
>
> Alexander Duyck wrote:
>
> > > > I'm not sure this logic is correct. Can the flow director rules
> > > > handle
> > > > a field that is removed? Last I knew it couldn't. If that is the case
> > > > you should be using ACL for any case in which a full mask is not
> > > > provided. So in your tests below you could probably drop the check
> > > > for
> > > > zero as I don't think that is a valid case in which flow director
> > > > would work.
> > > >
> > >
> > > I'm not sure what you meant by a field that is removed, but Flow
> > > Director can handle reduced input sets. Flow Director is able to handle
> > > 0 mask, full mask, and less than 4 tuples. ACL is needed/used only when
> > > a partial mask rule is requested.
> >
> > So historically speaking with flow director you are only allowed one
> > mask because it determines the inputs used to generate the hash that
> > identifies the flow. So you are only allowed one mask for all flows
> > because changing those inputs would break the hash mapping.
> >
> > Normally this ends up meaning that you have to do like what we did in
> > ixgbe and disable ATR and only allow one mask for all inputs. I
> > believe for i40e they required that you always use a full 4 tuple. I
> > didn't see something like that here. As such you may want to double
> > check that you can have a mix of flow director rules that are using 1
> > tuple, 2 tuples, 3 tuples, and 4 tuples as last I knew you couldn't.
> > Basically if you had fields included they had to be included for all
> > the rules on the port or device depending on how the tables are set
> > up.
>
> The ice driver hardware is quite a bit more capable than the ixgbe or
> i40e hardware, and uses a limited set of ACL rules to support different
> sets of masks. We have some limits on the number of masks and the
> number of fields that we can simultaneously support, but I think
> that is pretty normal for limited hardware resources.
>
> Let's just say that if the code doesn't work on an E810 card then we
> messed up and we'll have to fix it. :-)
>
> Thanks for the review! Hope this helps...

I gather all that. The issue was the code in ice_is_acl_filter().
Basically if we start dropping fields it will not trigger the rule to
be considered an ACL rule if the field is completely dropped.

So for example I could define 4 rules, one that ignores the IPv4
source, one that ignores the IPv4 destination, one that ignores the
TCP source port, and one that ignores the TCP destination port. With
the current code all 4 of those rules would be considered to be
non-ACL rules because the mask is 0 and not partial. If I do the same
thing and ignore all but one bit then they are all ACL rules. In
addition I don't see anything telling flow director it can ignore
certain inputs over verifying the mask so I am assuming that the
previously mentioned rules that drop entire fields would likely not
work with Flow Director.

Anyway I just wanted to point that out as that would be an issue going
forward and it seems like it would be easy to fix by simply just
rejecting rules where the required flow director fields are not
entirely masked in.

- Alex
