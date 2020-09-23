Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F6ED275D64
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 18:27:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbgIWQ1b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 12:27:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgIWQ1a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 12:27:30 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4040C0613CE
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 09:27:30 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id h2so141653ilo.12
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 09:27:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=l+Mi/4kyhkp8P/LlCQO7T7hv+jZ9yMvvlM+knwASzNU=;
        b=MD9Mc+elmSI40WNylJSi2CPZcKiv/ufR6b9rm7IBwCJkkau1AoIGGol8cwJAsF9Rk/
         09Q1NnVzfsJ8mRtZUCqyXpFA1wmnWes4THsB2u5eC5gICbKP7vN8lFa0HOCWTYHZFHDz
         U3TjsIkA0OqD50yPO8ik8kdAG3SHcOmas0qzlTCRLPV64yK5yaAU7XVlisfQzX/ukQSv
         cMGFMk79K/2/fDxDOu1R+tqV2WigV8iWWc94LnZPyur+trS44cOz+vUyXgOJPZhqGQCi
         QlOSep5WhZoGC/HI8M70j0hl2D4nWDw6aiUd8RzsVkCWZqNs/A1wKmHuZurCmkYWRfdE
         IRzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=l+Mi/4kyhkp8P/LlCQO7T7hv+jZ9yMvvlM+knwASzNU=;
        b=U/4bA700rB/lPkqqVqGgsmaeivk+qTIe7nz4b+jdu2bXossmd7OUnmObso2nFt+ndn
         TXev/n5wzvXVGG0x2W10ol79gu6lkCuJ9p0AyqVWy9Yh9wgPuvyF8KzdGkRACIm5DUb6
         c5cWeXzXn7/2aASO9V2XQvUkb1jeiBJoT7l/iQ4CmcpkJvBVZF8pt3BDjPzAb2AdXF5w
         wmFdtr/PF36UA+Jvz/XvjRKR9iKlb9M5sB1hNVGoWptjDJFRr5009xBWv2sBAWyvxemk
         RhO/BxYSMGsB/ebwLACQDSUYZto/wGGNdTbja4+9txS2TRenuoNZRrpmgA1QVf4mUyd7
         p4Dw==
X-Gm-Message-State: AOAM5301axD+FEzj3fie5rtDrmb+/0bL1GBjwz4PgD9ayU3OyrP+g4uM
        YF0FIoO+o+6FcDAIDS12L00LZ/hePnNKNrG4+BFTag==
X-Google-Smtp-Source: ABdhPJyh3dqToPMmq3yu9IONMkwnBdCM/3zUOGYkU9dv27I0FLgLYQZ6/XKjV8ZvFoEL0HX5PVSaOeJ+TkabcFse+VU=
X-Received: by 2002:a92:d910:: with SMTP id s16mr516149iln.258.1600878449871;
 Wed, 23 Sep 2020 09:27:29 -0700 (PDT)
MIME-Version: 1.0
References: <20200922155100.1624976-1-awogbemila@google.com>
 <20200922155100.1624976-3-awogbemila@google.com> <20200922103311.5db13ae1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200922103311.5db13ae1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   David Awogbemila <awogbemila@google.com>
Date:   Wed, 23 Sep 2020 09:27:19 -0700
Message-ID: <CAL9ddJf1hWt=Dm7K-w+io64H78tCZ04ueZ4-uriTDn3OrZAevg@mail.gmail.com>
Subject: Re: [PATCH net-next v2 2/3] gve: Add support for raw addressing to
 the rx path
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Catherine Sullivan <csully@google.com>,
        Yangchun Fu <yangchun@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 22, 2020 at 10:33 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 22 Sep 2020 08:50:59 -0700 David Awogbemila wrote:
> > From: Catherine Sullivan <csully@google.com>
> >
> > Add support to use raw dma addresses in the rx path. Due to this new
> > support we can alloc a new buffer instead of making a copy.
> >
> > RX buffers are handed to the networking stack and are then recycled or
> > re-allocated as needed, avoiding the need to use
> > skb_copy_to_linear_data() as in "qpl" mode.
>
> Please separate page recycling into a separate commit.

Ok, I'll separate them in v3.
