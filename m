Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FC4129DB54
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 00:52:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389292AbgJ1XwA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 19:52:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387762AbgJ1Xvs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 19:51:48 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D795C0613CF
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 16:51:48 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id r127so975735lff.12
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 16:51:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nzLz4C8/7x6rzuhgwBujVtBwU24k/ip+cGwa/LEOhsg=;
        b=v4M1qF5mDiC5N28sULoJTYGg1WgaQQ/emZkfbpqBiOCzkX+SSPW5W1uM0NbvfAh6YO
         9E9NFQnet8PJcyRMTHhYtgpYE7bVrUSfAQVf3wXDtig0GDDzclpTy6RCpO/CDkSwzFSw
         1IjiOdkAOxxHfDbnNC4X71Ioj0EI2UIuG/QuQyhFg+gO9e1vtVjLNnMKoPxMtar9kcu4
         Y7/Mos6ATXV6NyOub+XMEgoIiLmTrlSZF1qa9xGdnBAtX4ze+iq63skPQoPnYCEQ+QDJ
         DG4aO1r32cPLM7r5DjYDFQtGKkXmijlPbjhfYhJ0O+jXMH3CNTs00phfFjMeNylPtiEr
         LRNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nzLz4C8/7x6rzuhgwBujVtBwU24k/ip+cGwa/LEOhsg=;
        b=hf4enJVArxsKR80KZ5z/zauTjqd+fln4ngPqhgSk0dx2p7i63F0281UYZcovxe7plL
         dU2HXhObus6rNX2eqOEW0h6/FIggSmYssiDNI/HUr9LhLadGmYgH8Azi3k9AZwz1Jk47
         HNJw3SdakjM46r0LAbll+e64JZ9lvrxEQecXx/eLFjIXxBjZKm8RDnqXuDGa3lvOOyf4
         6RHX99FNuYe+QWrakpx3zLSNyALXdPMYGd/W3r1lqJTu/8vASzOdG/bjxx9RYSDX1Jld
         kugZM92j+NbjxFZASKrUcy7nQuMe+qOoq9yDtDMqaJOJJiqn8UErBPMIyhP2GGaybLP6
         g84A==
X-Gm-Message-State: AOAM532XhA5vy9bHlQ6vro8KiMr5mlGAlVQDROWFUGRWbmr+bRavykJC
        sjim8Q/GFRykp+ZCxyBux3gh4l+Rr8a3QNSWGfZOASErGA==
X-Google-Smtp-Source: ABdhPJyR411+6APaMeMHKRFz3XusXo7hZQPgNstyy+j9Bir1XmDNqruBwrAK8ySh4BzJWo1Qsqgz2KolL3IjMPV55EU=
X-Received: by 2002:a17:906:c1d4:: with SMTP id bw20mr5195940ejb.91.1603851000899;
 Tue, 27 Oct 2020 19:10:00 -0700 (PDT)
MIME-Version: 1.0
References: <160141647786.7997.5490924406329369782.stgit@sifl>
 <alpine.LRH.2.21.2009300909150.6592@namei.org> <CAHC9VhTM_a+L8nY8QLVdA1FcL8hjdV1ZNLJcr6G_Q27qPD_5EQ@mail.gmail.com>
In-Reply-To: <CAHC9VhTM_a+L8nY8QLVdA1FcL8hjdV1ZNLJcr6G_Q27qPD_5EQ@mail.gmail.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Tue, 27 Oct 2020 22:09:49 -0400
Message-ID: <CAHC9VhSq6stUdMSS5MXKDas5RHnrJiKSDU60CbKYe04x2DvymQ@mail.gmail.com>
Subject: Re: [RFC PATCH] lsm,selinux: pass the family information along with
 xfrm flow
To:     linux-security-module@vger.kernel.org
Cc:     selinux@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, James Morris <jmorris@namei.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 30, 2020 at 9:44 AM Paul Moore <paul@paul-moore.com> wrote:
> On Tue, Sep 29, 2020 at 7:09 PM James Morris <jmorris@namei.org> wrote:
> > I'm not keen on adding a parameter which nobody is using. Perhaps a note
> > in the header instead?
>
> On Wed, Sep 30, 2020 at 6:14 AM Herbert Xu <herbert@gondor.apana.org.au> wrote:
> > Please at least change to the struct flowi to flowi_common if we're
> > not adding a family field.
>
> It did feel a bit weird adding a (currently) unused parameter, so I
> can understand the concern, I just worry that a comment in the code
> will be easily overlooked.  I also thought about passing a pointer to
> the nested flowi_common struct, but it doesn't appear that this is
> done anywhere else in the stack so it felt wrong to do it here.

With the merge window behind us, where do stand on this?  I see the
ACK from Casey and some grumbling about adding an unused parameter
(which is a valid argument, I just feel the alternative is worse), but
I haven't seen any serious NACKs.

Any objections or other strong feelings to me merging this via the
selinux/next branch?

-- 
paul moore
www.paul-moore.com
