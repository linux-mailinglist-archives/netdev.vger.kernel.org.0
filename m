Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94DA717288C
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 20:27:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729727AbgB0T1K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 14:27:10 -0500
Received: from mail-ot1-f43.google.com ([209.85.210.43]:35058 "EHLO
        mail-ot1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727159AbgB0T1K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 14:27:10 -0500
Received: by mail-ot1-f43.google.com with SMTP id r16so304316otd.2
        for <netdev@vger.kernel.org>; Thu, 27 Feb 2020 11:27:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NPBf9GoR3mr8KsuN8h5+MalLvyvB4cPf6zqyFJWmFHI=;
        b=IVVrNjMVKRKgA0XUyEQWwltiwUZxPiqsrxqISz5TSCmNG4PFpEknGrglo5AAEFZDw6
         43YmwczB7ZK7vR3YNub70qwblQgzOXa/O+Dip85fjy0Pz4tt8TFt9WMWmp5M72P27/de
         zYZOL/Qi75WNxFZELLR+icUqbisjH33nP81RY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NPBf9GoR3mr8KsuN8h5+MalLvyvB4cPf6zqyFJWmFHI=;
        b=uBAx8jK7Xd7EeUFdBByJn75lCRrHeRLKmY02hhUtkt6E9dHl1o7rMqGVBudgteBoLD
         LdnGhxVRJ40fUvbGx7mc65Qwajr0ulP/0zej9Q8c5re0N1lcSIYm/AEOew5sWcgNMjlU
         u1MAUyl7fFqmvOlnF5xhGturtFiyaYkJUAlxbFvzcLz3G5LUQh+WDhL/FiMrClwymUgm
         Ww0dE2ZB1DA6IQlYQvCx7sBTTF9JmEiqLz/heJXHik2vHK7GfGsVslMUdE/wtdtNIhjj
         PQMeheydo7yPck4ZRFLnco1wERn3MaMj6R8bU8BkfMcLoKPXnYPl2nK8CBRH8y+Ue2Jn
         WCSQ==
X-Gm-Message-State: APjAAAWJnvpKSUJs3swVWdtYtwWbB9t9Dw5jNlUoRsAq9bYZM0m7WMt8
        w8KqwfeDCNbhFRDF5+HFgYlSwCDUCjfk41l4C5ZM8Q==
X-Google-Smtp-Source: APXvYqyIWBX48HR408KP5mDkdprhOh5PWRbG60zfid9VZMmNc4mmTMojojLM4uA36vtbm1RInjHFwWes1LdmPAkZegQ=
X-Received: by 2002:a9d:836:: with SMTP id 51mr400281oty.318.1582831629331;
 Thu, 27 Feb 2020 11:27:09 -0800 (PST)
MIME-Version: 1.0
References: <20200226093330.GA711395@redhat.com> <87lfopznfe.fsf@toke.dk>
 <0b446fc3-01ed-4dc1-81f0-ef0e1e2cadb0@digitalocean.com> <20200226115258-mutt-send-email-mst@kernel.org>
 <ec1185ac-a2a1-e9d9-c116-ab42483c3b85@digitalocean.com> <20200226120142-mutt-send-email-mst@kernel.org>
 <20200226173751.0b078185@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200226173751.0b078185@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Thu, 27 Feb 2020 11:26:58 -0800
Message-ID: <CACKFLim6Y5HoUSab=J=ex8hmFbJApivWpXpQV8pnzJ4EBnCs9w@mail.gmail.com>
Subject: Re: virtio_net: can change MTU after installing program
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        David Ahern <dahern@digitalocean.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andy Gospodarek <andy@greyhouse.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 26, 2020 at 5:37 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 26 Feb 2020 12:02:03 -0500 Michael S. Tsirkin wrote:
> > On Wed, Feb 26, 2020 at 09:58:00AM -0700, David Ahern wrote:
> > > On 2/26/20 9:55 AM, Michael S. Tsirkin wrote:
> > > > OK that seems to indicate an ndo callback as a reasonable way
> > > > to handle this. Right? The only problem is this might break
> > > > guests if they happen to reverse the order of
> > > > operations:
> > > >   1. set mtu
> > > >   2. detach xdp prog
> > > > would previously work fine, and would now give an error.
> > >
> > > That order should not work at all. You should not be allowed to change
> > > the MTU size that exceeds XDP limits while an XDP program is attached.
> >
> >
> > Right. But we didn't check it so blocking that now is a UAPI change.
> > Do we care?
>
> I'd vote that we don't care. We should care more about consistency
> across drivers than committing to buggy behavior.
>
> All drivers should have this check (intel, mlx, nfp definitely do),
> I had a look at Broadcom and it seems to be missing there as well :(
> Qlogic also. Ugh.

The Broadcom bnxt_en driver should not allow the MTU to be changed to
an invalid value after an XDP program is attached.  We set the
netdev->max_mtu to a smaller value and dev_validate_mtu() should
reject MTUs that are not supported in XDP mode.
