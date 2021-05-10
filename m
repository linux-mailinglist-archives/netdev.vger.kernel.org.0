Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D010A377C10
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 08:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbhEJGHP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 02:07:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbhEJGHO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 02:07:14 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 438DDC061573
        for <netdev@vger.kernel.org>; Sun,  9 May 2021 23:06:10 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id m37so12528466pgb.8
        for <netdev@vger.kernel.org>; Sun, 09 May 2021 23:06:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MDrcpXE39hK+tsy+zeJ9NcnfUtXm+Fj2OZgopVYIL0c=;
        b=a4k8t596jRiGiHvZ3K9iDz5sTR7VxyAB6dhL5+66qQchlvRyybuzfPcEgu3mErhetO
         sRGV2scP9qoVnV7zobRdH8j4p2CAHFm5D7KizyW267aRqlRFEy7sYCcruH9+5zj5BH71
         Uip2ZkTlM/yMTiCmBxx4lGSDZqexb2VIFjdTCUwMoacrvhf1UjKS3wHQ5ZVHg6BeNmie
         Mllfq7Xh2Iom/Gc9rLPnnmJO305FxGiuPMktkhi66GJ3O8VHpdv5qNowLBtp2Fv4Z22T
         ThPHreJeAGQFbiLRxL0GZu7CfOqC6YrfjF53myFmJbWQzKKj5ir9AitBShFvMsKvTRNP
         jFOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MDrcpXE39hK+tsy+zeJ9NcnfUtXm+Fj2OZgopVYIL0c=;
        b=EgeWK2vVVjdvF10o+GbU5HkrovNp/if9Lu/X5Yyd/VBWCVOW2kMvK0Gh/x0Jxt87OV
         +SZzq9lr8V83DxWbUQq7I+6uPmS6y/Jn/zsanPcVmrnIzb6HQ49PKezqNgu4vrWjQhcP
         Ya2MRUSz7bzgI+WtuSBu25ljQUPVQ22dgtb+Kgox/cFsIrufRnSuOEW/W8EFDX7kjvq+
         B8Qdv8ZfjpUKSYNEq1yod9lAdoVOkLKVJyvdYTMvNyZid64QHS519wa+rECVsGFpaP6m
         beBMFCPETM7egvtNfIqYDk7tWSI66shPbugmkyrS/7ybFvAdtMs76VUQ72xmxa5w1Nhf
         hTVQ==
X-Gm-Message-State: AOAM532VHIK2uBnX2JIYpf4EgU3nty1RkcItzBtQ7bQHmF4GW2k8zbRc
        r0vBNN9rtrcca8qSTDctj0fbbR66U6a+1H0f3o8=
X-Google-Smtp-Source: ABdhPJyI5s8NZwfuKDpEZ8b6Fp2u5on+enRQ4oHGe86WgJBiFubYi63j4o4IlmRCWCnLfYIus4gTKeOu0wdd5AuRwMU=
X-Received: by 2002:a62:1b97:0:b029:24e:44e9:a8c1 with SMTP id
 b145-20020a621b970000b029024e44e9a8c1mr24125765pfb.19.1620626769732; Sun, 09
 May 2021 23:06:09 -0700 (PDT)
MIME-Version: 1.0
References: <20210423100446.15412-1-magnus.karlsson@gmail.com> <75d0a1d13a755bc128458c0d43f16d54fe08051e.camel@intel.com>
In-Reply-To: <75d0a1d13a755bc128458c0d43f16d54fe08051e.camel@intel.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Mon, 10 May 2021 08:06:00 +0200
Message-ID: <CAJ8uoz0Pgfn8kai34_MFGYv3m7c24bpo4DhjZ8oLgd4zaGMWsg@mail.gmail.com>
Subject: Re: [PATCH intel-net 0/5] i40e: ice: ixgbe: ixgbevf: igb: add correct
 exception tracing for XDP
To:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Cc:     "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "brouer@redhat.com" <brouer@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 8, 2021 at 12:58 AM Nguyen, Anthony L
<anthony.l.nguyen@intel.com> wrote:
>
> On Fri, 2021-04-23 at 12:04 +0200, Magnus Karlsson wrote:
> > Add missing exception tracing to XDP when a number of different
> > errors
> > can occur. The support was only partial. Several errors where not
> > logged which would confuse the user quite a lot not knowing where and
> > why the packets disappeared.
> >
> > This patch set fixes this for all Intel drivers with XDP support.
> >
> > Thanks: Magnus
>
> This doesn't apply anymore with the 5.13 patches. It looks like your
> "optimize for XDP_REDIRECT in xsk path" patches are conflicting with
> some of these. Did you want to rework them?

I will rebase them and resubmit.

> Thanks,
> Tony
>
> > Magnus Karlsson (5):
> >   i40e: add correct exception tracing for XDP
> >   ice: add correct exception tracing for XDP
> >   ixgbe: add correct exception tracing for XDP
> >   igb add correct exception tracing for XDP
> >   ixgbevf: add correct exception tracing for XDP
> >
> >  drivers/net/ethernet/intel/i40e/i40e_txrx.c      |  7 ++++++-
> >  drivers/net/ethernet/intel/i40e/i40e_xsk.c       |  7 ++++++-
> >  drivers/net/ethernet/intel/ice/ice_txrx.c        | 12 +++++++++---
> >  drivers/net/ethernet/intel/ice/ice_xsk.c         |  7 ++++++-
> >  drivers/net/ethernet/intel/igb/igb_main.c        | 10 ++++++----
> >  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c    | 16 ++++++++----
> > ----
> >  drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c     | 13 ++++++++-----
> >  .../net/ethernet/intel/ixgbevf/ixgbevf_main.c    |  3 +++
> >  8 files changed, 52 insertions(+), 23 deletions(-)
> >
> >
> > base-commit: bb556de79f0a9e647e8febe15786ee68483fa67b
> > --
> > 2.29.0
