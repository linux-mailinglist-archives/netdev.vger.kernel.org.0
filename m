Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7F2B1E5254
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 02:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725795AbgE1Akh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 20:40:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725267AbgE1Akg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 20:40:36 -0400
Received: from mail-oo1-xc43.google.com (mail-oo1-xc43.google.com [IPv6:2607:f8b0:4864:20::c43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7593C05BD1E
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 17:40:36 -0700 (PDT)
Received: by mail-oo1-xc43.google.com with SMTP id u40so2432141ooi.11
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 17:40:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=gQzAFwN4GUy2bUTKe4fObk+r+dogWYF+g7KaI/1pzDE=;
        b=JXrSpgr5i6h68gvruSFJYDWxn04PtHmXDVz1Na1vDRuBn9rRwJGfNm60jwt6EcF8VV
         QkOWYE79kGZQ9b6aZvb14Luar/bkx5Wcy0x/RK5Qjbc/LRD7G+PTJQk1Hc4X6Er7BTl+
         er8pdrva+MnminEskZcurYoqFjSksGjc5ulG0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=gQzAFwN4GUy2bUTKe4fObk+r+dogWYF+g7KaI/1pzDE=;
        b=XujzelVq/u1yNcIgYOerX0yHDeY26Nuqw6fxHXENnF9/5tSIHaY+BMgUkBjYYWDs6V
         UcC070FoqAqe8cggMtSu5rsWVRVWN65B6mzIe+tXN76MsoZRyDlVRVWM/jQvrJCo+9DL
         R335VBAZWQ4YBoyJarPLCSS8VX1cEJsMjPKTwx78J+vzxSFNdgftjbwhnqEabm6ogG1t
         YqZwL9N9VdIZNNpk1Vp1X3ZR6UmBNV60YrUnL/wQX5x+nXfQ6oKFTXsmHGQzvR36eqUn
         x8O4mwOmP8u/I5OiNdgrhj5yUSHcPPQlB0UGZ/HPCzUV1pxqKqOzppoB57ka994jjMLP
         cYuQ==
X-Gm-Message-State: AOAM530hxyVlO7kthLqB/LXLUe4cWMf3bX2jg+0dumo4YzU4q7NMKtz+
        l19++C6mDyTvefIF0Sz/oGMK84Wd90L85EHrGlmkCXB8
X-Google-Smtp-Source: ABdhPJwE3N2JYpZdER+UDffvh4EWD96jfstLEJoa2YSQ5Dhb1o2m3+eI2zHvh1ccf7UTq0wSAkSeqt4mhHmG5ty5vR8=
X-Received: by 2002:a4a:e0d1:: with SMTP id e17mr635520oot.1.1590626435817;
 Wed, 27 May 2020 17:40:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200527212512.17901-1-edwin.peer@broadcom.com> <20200527234849.GA18589@qmqm.qmqm.pl>
In-Reply-To: <20200527234849.GA18589@qmqm.qmqm.pl>
From:   Edwin Peer <edwin.peer@broadcom.com>
Date:   Wed, 27 May 2020 17:39:59 -0700
Message-ID: <CAKOOJTzzV8Aiz3yn=a2o8mBW3xzxOPCWHFyu9KJJ9TBC4UAnYg@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 00/11] Nested VLANs - decimate flags and add another
To:     =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>
Cc:     netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 27, 2020 at 5:15 PM Micha=C5=82 Miros=C5=82aw <mirq-linux@rere.=
qmqm.pl> wrote:

> Have you considered adding a 'vlan_headroom' field (or another name)
> for a netdev instead of a flag? This would submit easily to device
> aggregation (just take min from the slaves) and would also handle
> nested VLANs gracefully (subtracting for every layer).

Great idea, I think that would be much nicer.

> In patch 3 you seem to assume that if lower device reduces MTU below
> its max, then its ok to push it up with VLAN headers. I don't think
> this is apropriate when reducing MTU because of eg. PMTU limit for
> a tunnel.

Indeed. For non-tunnel devices I think this behavior is still correct,
because past the 1st hop (where device MTU should be appropriate), all
of L2, including any VLANs, has been replaced by something else. But
yes, tunnels probably do need to unconditionally reduce MTU, because
PMTU is something more dynamic. I guess I kind of half thought about
this for gre6, where this is what I did because PMTU is so much more
in your face for IPv6.

Regards,
Edwin Peer
