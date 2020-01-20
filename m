Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8049C142F2C
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 17:04:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728596AbgATQEL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 11:04:11 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:23453 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726819AbgATQEL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 11:04:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579536249;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=p4ejQ2/oe91bnyA0QOnuHtrCvG5ijZh9PVgfR3T6gU8=;
        b=ZvszC1JBnuRxVBB4Fnd5io/E71okdLn6h3270qtWx9SH89wxtzhMdtI37cFEKCW6zaonzN
        tb+YsfqYp61heIhcr2pyptzjkT9n+Iqzk4dKXjswth364rgKSfvTc9zH2xHjhQWYGOzc4C
        5CMWP7+PV5mvd5zaTx6fKTahI09rZro=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-264-lLu9iAeSObme8k2rx8iXHA-1; Mon, 20 Jan 2020 11:04:08 -0500
X-MC-Unique: lLu9iAeSObme8k2rx8iXHA-1
Received: by mail-qt1-f200.google.com with SMTP id z11so67676qts.1
        for <netdev@vger.kernel.org>; Mon, 20 Jan 2020 08:04:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=p4ejQ2/oe91bnyA0QOnuHtrCvG5ijZh9PVgfR3T6gU8=;
        b=fI1eSvxJxb6r8e4cKB1FQZcKoRsYYG0oFJN1xcxqXwWxe2U1FhWhoCNy3rvH/wYAFr
         7C48kggKAN5Eo1RFqwEMCTEejpfWDnYHK65M3roUx+5OAKPdB2CawGxFBR0+klCHzn/1
         24rmIc+pAiJTdZW5ZhqdKeSKmFCIfECpr6zY1dnjqoOvvC+IjgIY9a5I/9HWv1LnKNQP
         P1T4du8WoonYi7Xoj3IdrYyIcpNcF/szgwyfbL68ApaUVZH9VLdVva2fpvI/i17z5wfv
         K2LyVDCWKAKlvZzdu9/kTrPjO1p8qq123GbqtWXl1EQC0Ga8SaQamLM+dhBzpTmWSHsg
         iJ8w==
X-Gm-Message-State: APjAAAWLiQwMSaQERDIxkKnCzZ+xkvWRKcMJw1T4rRo0eLgINfqr6Lm4
        PkdLY3y93oc2EIN7Gkkq6G1AiM8uotS8fAXDvTn5orriXr8pPrYi/Bx4XEH3jveBs+cuQvjBKEV
        Jaj9T81ENbUBr6wLx
X-Received: by 2002:aed:2d67:: with SMTP id h94mr14151qtd.74.1579536247741;
        Mon, 20 Jan 2020 08:04:07 -0800 (PST)
X-Google-Smtp-Source: APXvYqyHYHZZeb/F+oSnPwvaj7ijjCP3wY5WXEKtUs5DPKrE69F2FmzJea/xoQ0/lmBxFbbg2H6+0w==
X-Received: by 2002:aed:2d67:: with SMTP id h94mr14119qtd.74.1579536247441;
        Mon, 20 Jan 2020 08:04:07 -0800 (PST)
Received: from redhat.com (bzq-79-179-85-180.red.bezeqint.net. [79.179.85.180])
        by smtp.gmail.com with ESMTPSA id 68sm16186184qkj.102.2020.01.20.08.04.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2020 08:04:06 -0800 (PST)
Date:   Mon, 20 Jan 2020 11:04:00 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jorgen Hansen <jhansen@vmware.com>,
        Jason Wang <jasowang@redhat.com>, kvm <kvm@vger.kernel.org>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        virtualization@lists.linux-foundation.org,
        linux-hyperv@vger.kernel.org, Dexuan Cui <decui@microsoft.com>
Subject: Re: [PATCH net-next 1/3] vsock: add network namespace support
Message-ID: <20200120110319-mutt-send-email-mst@kernel.org>
References: <20200116172428.311437-1-sgarzare@redhat.com>
 <20200116172428.311437-2-sgarzare@redhat.com>
 <20200120.100610.546818167633238909.davem@davemloft.net>
 <20200120101735.uyh4o64gb4njakw5@steredhat>
 <20200120060601-mutt-send-email-mst@kernel.org>
 <CAGxU2F6VH8Eb5UH_9KjN6MONbZEo1D7EHAiocVVus6jW55BJDg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGxU2F6VH8Eb5UH_9KjN6MONbZEo1D7EHAiocVVus6jW55BJDg@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 20, 2020 at 02:58:01PM +0100, Stefano Garzarella wrote:
> On Mon, Jan 20, 2020 at 1:03 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > On Mon, Jan 20, 2020 at 11:17:35AM +0100, Stefano Garzarella wrote:
> > > On Mon, Jan 20, 2020 at 10:06:10AM +0100, David Miller wrote:
> > > > From: Stefano Garzarella <sgarzare@redhat.com>
> > > > Date: Thu, 16 Jan 2020 18:24:26 +0100
> > > >
> > > > > This patch adds 'netns' module param to enable this new feature
> > > > > (disabled by default), because it changes vsock's behavior with
> > > > > network namespaces and could break existing applications.
> > > >
> > > > Sorry, no.
> > > >
> > > > I wonder if you can even design a legitimate, reasonable, use case
> > > > where these netns changes could break things.
> > >
> > > I forgot to mention the use case.
> > > I tried the RFC with Kata containers and we found that Kata shim-v1
> > > doesn't work (Kata shim-v2 works as is) because there are the following
> > > processes involved:
> > > - kata-runtime (runs in the init_netns) opens /dev/vhost-vsock and
> > >   passes it to qemu
> > > - kata-shim (runs in a container) wants to talk with the guest but the
> > >   vsock device is assigned to the init_netns and kata-shim runs in a
> > >   different netns, so the communication is not allowed
> > > But, as you said, this could be a wrong design, indeed they already
> > > found a fix, but I was not sure if others could have the same issue.
> > >
> > > In this case, do you think it is acceptable to make this change in
> > > the vsock's behavior with netns and ask the user to change the design?
> >
> > David's question is what would be a usecase that's broken
> > (as opposed to fixed) by enabling this by default.
> 
> Yes, I got that. Thanks for clarifying.
> I just reported a broken example that can be fixed with a different
> design (due to the fact that before this series, vsock devices were
> accessible to all netns).
> 
> >
> > If it does exist, you need a way for userspace to opt-in,
> > module parameter isn't that.
> 
> Okay, but I honestly can't find a case that can't be solved.
> So I don't know whether to add an option (ioctl, sysfs ?) or wait for
> a real case to come up.
> 
> I'll try to see better if there's any particular case where we need
> to disable netns in vsock.
> 
> Thanks,
> Stefano

Me neither. so what did you have in mind when you wrote:
"could break existing applications"?

