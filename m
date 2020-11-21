Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E5F42BBBAD
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 02:51:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725944AbgKUBts (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 20:49:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbgKUBtr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 20:49:47 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A616CC0613CF
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 17:49:47 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id i18so11927929ioa.3
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 17:49:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DUcso+azzK9eyJdy0Wag92NnbpvoOyDlBr0Hqgr2xJQ=;
        b=fuLJp6xtgEYGlRePm3lmODhQ5oDu3kgpH41AKfzpkiSOLa9/KIhxlHxG3G/7XSyqqP
         6sYm0Kxvar/8iKscqfG9akyhWeoE8P23qA94y3qyzqU2Jx1ybjzSDaOGM8IZ4+SSFoLQ
         0rWiO5elWbYQv96CWP3sDcAqyuJ8ruPeCpQWHwfvQ5SkOKYHNlvEa2ExOm63p0FPR7uV
         Eh17DVTJvJuv1Ug4kXmup1kzTgRj8YWFWJKrRi2ZBC+N+p8YzJwSl8JLRc2Zc3o5pj93
         xmlxUMJmFZ9IbFF5Sa2iP9J9fCI0/ImPpWYT4cgBHHequPq8TxCb5I+Mr+IIm1piOFC+
         Fa8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DUcso+azzK9eyJdy0Wag92NnbpvoOyDlBr0Hqgr2xJQ=;
        b=GlONj/j4G2Fhrs8KlbvE7MX3x5KrwJb79FjA/81wwmP5IMLXRoPumrxwlFtqpOB50Y
         X12jDRecIh0PldNQoDMSfXsHi09swQpb/UCrUA3hb42UIMPzaZf+QVplpjv4ZN0744Hk
         YBem9dQoyoMWUPY+O5D2vcsFiTxIqhmkCqEq3cUrErLRTwbijnfsuqkQ7hFWtOo1oVjo
         hr7fudgCQaMd4EpAYSTSXZyIxyhpl0wioJB7x4H83zd3DzeLQHYQ7Lg8Wzuky86klIwF
         VgChuaW/CS5kHZVmKvWYwjDHfw27HIBWaI8F3xSLymph4d1u3KQyn6zF+9i3eGyI+rcx
         RJew==
X-Gm-Message-State: AOAM5305m1rlgw2bWJd6/fVMfZHqU8d6Q+OMZCao/AeS7uDfjCE709bc
        GawA7uEMADHk2+b30s3F8VWWD//H9QWbBk436s4/eGZEjZA=
X-Google-Smtp-Source: ABdhPJwKURbqmks7YfMsfiH0cFRkpj/EKJ7msnZqYzdYC1xGg8cX9F7p6MyNsPBAj2J33XCNnBOnmQNSJhsjJaqCooM=
X-Received: by 2002:a02:1301:: with SMTP id 1mr21251860jaz.83.1605923386710;
 Fri, 20 Nov 2020 17:49:46 -0800 (PST)
MIME-Version: 1.0
References: <20201113214429.2131951-1-anthony.l.nguyen@intel.com>
 <20201113214429.2131951-6-anthony.l.nguyen@intel.com> <CAKgT0UeQ5q2M-uiR0-1G=30syPiO8S5OFHvDuN1XtQg5700hCg@mail.gmail.com>
 <fd0fc6f95f4c107d1aed18bf58239fda91879b26.camel@intel.com>
In-Reply-To: <fd0fc6f95f4c107d1aed18bf58239fda91879b26.camel@intel.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Fri, 20 Nov 2020 17:49:35 -0800
Message-ID: <CAKgT0Uewo+Rr19EVf9br9zBPsyOUANGMSQ0kqNVAzOJ8cjWMdw@mail.gmail.com>
Subject: Re: [net-next v3 05/15] ice: create flow profile
To:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Cc:     "Cao, Chinh T" <chinh.t.cao@intel.com>,
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

On Fri, Nov 20, 2020 at 4:42 PM Nguyen, Anthony L
<anthony.l.nguyen@intel.com> wrote:
>
> On Fri, 2020-11-13 at 15:56 -0800, Alexander Duyck wrote:
> > On Fri, Nov 13, 2020 at 1:46 PM Tony Nguyen <
> > anthony.l.nguyen@intel.com> wrote:
> > >
> > > From: Real Valiquette <real.valiquette@intel.com>
> > >
> > > Implement the initial steps for creating an ACL filter to support
> > > ntuple
> > > masks. Create a flow profile based on a given mask rule and program
> > > it to
> > > the hardware. Though the profile is written to hardware, no actions
> > > are
> > > associated with the profile yet.
> > >
> > > Co-developed-by: Chinh Cao <chinh.t.cao@intel.com>
> > > Signed-off-by: Chinh Cao <chinh.t.cao@intel.com>
> > > Signed-off-by: Real Valiquette <real.valiquette@intel.com>
> > > Co-developed-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> > > Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> > > Tested-by: Brijesh Behera <brijeshx.behera@intel.com>
> >
> > So I see two big issues with the patch.
> >
> > First it looks like there is an anti-pattern of defensive NULL
> > pointer
> > checks throughout. Those can probably all go since all of the callers
> > either use the pointer, or verify it is non-NULL before calling the
> > function in question.
>
> I'm removing those checks that you pointed out and some others as well.
>
> >
> > In addition the mask handling doens't look right to me. It is calling
> > out a partial mask as being the only time you need an ACL and I would
> > think it is any time you don't have a full mask for all
> > ports/addresses since a flow director rule normally pulls in the full
> > 4 tuple based on ice_ntuple_set_input_set() .
>
> Commented below as well.
>
> <snip>
>
> > > +/**
> > > + * ice_is_acl_filter - Checks if it's a FD or ACL filter
> > > + * @fsp: pointer to ethtool Rx flow specification
> > > + *
> > > + * If any field of the provided filter is using a partial mask
> > > then this is
> > > + * an ACL filter.
> > > + *
> >
> > I'm not sure this logic is correct. Can the flow director rules
> > handle
> > a field that is removed? Last I knew it couldn't. If that is the case
> > you should be using ACL for any case in which a full mask is not
> > provided. So in your tests below you could probably drop the check
> > for
> > zero as I don't think that is a valid case in which flow director
> > would work.
> >
>
> I'm not sure what you meant by a field that is removed, but Flow
> Director can handle reduced input sets. Flow Director is able to handle
> 0 mask, full mask, and less than 4 tuples. ACL is needed/used only when
> a partial mask rule is requested.

So historically speaking with flow director you are only allowed one
mask because it determines the inputs used to generate the hash that
identifies the flow. So you are only allowed one mask for all flows
because changing those inputs would break the hash mapping.

Normally this ends up meaning that you have to do like what we did in
ixgbe and disable ATR and only allow one mask for all inputs. I
believe for i40e they required that you always use a full 4 tuple. I
didn't see something like that here. As such you may want to double
check that you can have a mix of flow director rules that are using 1
tuple, 2 tuples, 3 tuples, and 4 tuples as last I knew you couldn't.
Basically if you had fields included they had to be included for all
the rules on the port or device depending on how the tables are set
up.

Thanks.

- Alex
