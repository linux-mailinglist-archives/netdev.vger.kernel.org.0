Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5B9536791D
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 07:12:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231656AbhDVFMx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 01:12:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbhDVFMv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 01:12:51 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 419E7C06138B
        for <netdev@vger.kernel.org>; Wed, 21 Apr 2021 22:12:16 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id r7so31410097wrm.1
        for <netdev@vger.kernel.org>; Wed, 21 Apr 2021 22:12:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=K2+e1oDiS7MWGuJTaGRRiMrN8mVbkWTxe2qRq2AZpNo=;
        b=O5QJkoVfqw+oxNplJGprOFaQFwP2fqtqGe5Yrujr1ucFdQXzxKQEIstAmNv5f7Vy8M
         Kja/yUyLJGGTp0js9M8TzqfZJRJw7Ust4eePJw2GJy4Da5KrMfWslxz7YaiA6bdul6BE
         +guxgbjLORR/8mbYJGZKEnchR5XuuqQ+BDj98RBZR42/9pek8NOuipwDgZ3Q3t9nBBFv
         rVQGZTPlwGiokADimSadGKlS29S1PvAP3EVQP4p7r+2N3WOFVcj3nmcGkNEK/CtPu+yf
         XXidE98/+yhND7xprG5F1+DgmE5L2YsdU97fq37pDkW2ZnzgDmukyOIV7vutauqbQXYA
         iMjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=K2+e1oDiS7MWGuJTaGRRiMrN8mVbkWTxe2qRq2AZpNo=;
        b=Z2gFIDwm6zHXzDywb07QR0QfERqEa7xGyBaz2D7YhGpRNsIohYjDk/RshxQEBCabsg
         n3btUAeGLjVw6xIebqy1ruCCa6WL38S1lSFueLlRvLUJeHtk6Fr+sxQqjaUeW5P08jbE
         DAbEvHE5zntnWm5QhO1CiVJthGz7UtApHUkQhyvs1PI/jz4dTsINmtvVgBuyhtEQFiZu
         wJO8SMxq1iwj1PIIYo8DzOIX21GlZsaN6Gf+YC6UKOMOB0NJtViSIv8NGeh9rTpPZIId
         0N1G4w2ti13OC5eIDw1xeVpjchY6GdBcDFG701+F1uIuUtfY3g3gFpWBhdzkxmwb9nW8
         80Lw==
X-Gm-Message-State: AOAM533JgqwOl/2FmOP5b19aaHVrJnLkOH40mHzJrWNH0nxZaSk+ezvy
        hE2S7xOpEYU1QzpkIQq4FHuLF8jH+B92AaBNk7RKcAPCUoY=
X-Google-Smtp-Source: ABdhPJyCbAbQhS5JLvf1Sn7b5LM9PXw3hyiK3KWm/Q5dY2PoJhoWI9zc5YCTZcNwSa9FXAbJtdZebdU0Aebdlz6llG0=
X-Received: by 2002:adf:a3c4:: with SMTP id m4mr1647627wrb.217.1619068335063;
 Wed, 21 Apr 2021 22:12:15 -0700 (PDT)
MIME-Version: 1.0
References: <20210420213517.24171-1-drt@linux.ibm.com> <60C99F56-617D-455B-9ACF-8CE1EED64D92@linux.vnet.ibm.com>
 <51a63be8-9b24-3f72-71d0-111959649059@linux.vnet.ibm.com>
In-Reply-To: <51a63be8-9b24-3f72-71d0-111959649059@linux.vnet.ibm.com>
From:   Lijun Pan <lijunp213@gmail.com>
Date:   Thu, 22 Apr 2021 00:12:04 -0500
Message-ID: <CAOhMmr4YF6HyBfa4gZZFQqUK6tyw5io=WzSb6G08zhbtu1sU-g@mail.gmail.com>
Subject: Re: [PATCH V2 net] ibmvnic: Continue with reset if set link down failed
To:     Rick Lindsley <ricklind@linux.vnet.ibm.com>
Cc:     Lijun Pan <ljp@linux.vnet.ibm.com>,
        Dany Madden <drt@linux.ibm.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tom Falcon <tlfalcon@linux.ibm.com>, netdev@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        linuxppc-dev@lists.ozlabs.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 21, 2021 at 3:06 AM Rick Lindsley
<ricklind@linux.vnet.ibm.com> wrote:
>
> On 4/20/21 2:42 PM, Lijun Pan wrote:
> >
> > This v2 does not adddress the concerns mentioned in v1.
> > And I think it is better to exit with error from do_reset, and schedule a thorough
> > do_hard_reset if the the adapter is already in unstable state.
>
> But the point is that the testing and analysis has indicated that doing a full
> hard reset is not necessary. We are about to take the very action which will fix
> this situation, but currently do not.

The testing was done on this patch. It was not performed on a full hard reset.
So I don't think you could even compare the two results.

>
> Please describe the advantage in deferring it further by routing it through
> do_hard_reset().  I don't see one.

It is not deferred. It exits with error and calls do_hard_reset.
See my reply to Suka's.
