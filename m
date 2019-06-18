Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 357F24AE51
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 00:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730784AbfFRW5Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 18:57:25 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:43282 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730532AbfFRW5Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 18:57:25 -0400
Received: by mail-pf1-f196.google.com with SMTP id i189so8480776pfg.10
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 15:57:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=bhgB/XOS87xzY5SYQXCbXc3LyNLA5aTw5d9mEOvvGXc=;
        b=bWOBNmuQxe/oJdiMWlLuEdrYGMprNyvVlWgcV9EH6e3D49USh+OnAM5ZWU+ppGHW7Q
         MooNtT21chrxmOuI1vPtho1CP+enUHNppSTDuGjJAx1GOfEMEYMx70Bd6jeVgpSrvNJn
         RLSoWPnQimbh1EYo5EcIntgRq5VEO03WtpXIs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=bhgB/XOS87xzY5SYQXCbXc3LyNLA5aTw5d9mEOvvGXc=;
        b=MjNd6dwr5MOh2ak2er51v/HEAfoxTO2eXYsHN8mOf5ut8MHpPLKlOxRxcXzsiPf7b4
         hOl4TWgS2mBPfhUwS8+D8zPNEK0VWzuZ6VjFv0B67J0DM3ovUr1Y1kgwjST36ga0hfrj
         dMtKFoOOqn+l5qnuXx3f/5nZuzg+QM2Lj7G8JXhPSzcA4dhqttGCdjvdcieA7xcp/kl0
         VH6uJxn3IixKvwofiP1jv0SYf/zNnz4Xvgn9syWjZf+gvR+4JMwumoNoP/wTFjv4HKD7
         UtLSaDUyhzB9gc5vsKah2ZKCp7iXBEhw/Gy6s1eW87JfqunsGFbReQ5yJFQj513NL35Y
         p6ZA==
X-Gm-Message-State: APjAAAX/1R8cdRcGA/cicrCTPC+SSynIow2NIj4d5XW2/i2YvUWAmcMS
        C73jnVj4iUf4ILAAVpdKafqnCQ==
X-Google-Smtp-Source: APXvYqx5M9CfqCQlzLQLDQ3EKaZRX9aoa28F7oOTlwpDt44S+lIZDcQL/TLQVK6debmgbpPmNIPA2A==
X-Received: by 2002:a62:bd11:: with SMTP id a17mr48690314pff.126.1560898644798;
        Tue, 18 Jun 2019 15:57:24 -0700 (PDT)
Received: from localhost ([2620:15c:202:1:75a:3f6e:21d:9374])
        by smtp.gmail.com with ESMTPSA id p23sm3105121pjo.4.2019.06.18.15.57.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Jun 2019 15:57:24 -0700 (PDT)
Date:   Tue, 18 Jun 2019 15:57:21 -0700
From:   Matthias Kaehlcke <mka@chromium.org>
To:     Doug Anderson <dianders@chromium.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Alexander Duyck <alexander.h.duyck@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH] net/ipv4: fib_trie: Avoid cryptic ternary expressions
Message-ID: <20190618225721.GV137143@google.com>
References: <20190618211440.54179-1-mka@chromium.org>
 <CAD=FV=V6TqT93Lb2UoQdkyO2j7OHrggCn-4qwDLEFw=N7RZ2Eg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAD=FV=V6TqT93Lb2UoQdkyO2j7OHrggCn-4qwDLEFw=N7RZ2Eg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 18, 2019 at 02:45:34PM -0700, Doug Anderson wrote:
> Hi,
> 
> On Tue, Jun 18, 2019 at 2:14 PM Matthias Kaehlcke <mka@chromium.org> wrote:
> >
> > empty_child_inc/dec() use the ternary operator for conditional
> > operations. The conditions involve the post/pre in/decrement
> > operator and the operation is only performed when the condition
> > is *not* true. This is hard to parse for humans, use a regular
> > 'if' construct instead and perform the in/decrement separately.
> >
> > This also fixes two warnings that are emitted about the value
> > of the ternary expression being unused, when building the kernel
> > with clang + "kbuild: Remove unnecessary -Wno-unused-value"
> > (https://lore.kernel.org/patchwork/patch/1089869/):
> >
> > CC      net/ipv4/fib_trie.o
> > net/ipv4/fib_trie.c:351:2: error: expression result unused [-Werror,-Wunused-value]
> >         ++tn_info(n)->empty_children ? : ++tn_info(n)->full_children;
> >
> > Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
> > ---
> > I have no good understanding of the fib_trie code, but the
> > disentangled code looks wrong, and it should be equivalent to the
> > cryptic version, unless I messed it up. In empty_child_inc()
> > 'full_children' is only incremented when 'empty_children' is -1. I
> > suspect a bug in the cryptic code, but am surprised why it hasn't
> > blown up yet. Or is it intended behavior that is just
> > super-counterintuitive?
> >
> > For now I'm leaving it at disentangling the cryptic expressions,
> > if there is a bug we can discuss what action to take.
> > ---
> >  net/ipv4/fib_trie.c | 10 ++++++++--
> >  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> I have no knowledge of this code either but Matthias's patch looks
> sane to me and I agree with the disentangling before making functional
> changes.

I in terms of the -stable process it might make sense to either
disentangle & fix in a single step, or first fix the cryptic code
(shudder!) and then disentangle it. I guess if we make it a series
disentangle & fix could be separate steps.

I'm open to whatever maintainers & stable folks prefer.

> My own personal belief is that this is pointing out a bug somewhere.
> Since "empty_children" ends up being an unsigned type it doesn't feel
> like it was by-design that -1 is ever a value that should be in there.

good point that 'empty_children' is unsigned, that indeed reinforces
the bug theory.

> In any case:
> 
> Reviewed-by: Douglas Anderson <dianders@chromium.org>

Thanks!
