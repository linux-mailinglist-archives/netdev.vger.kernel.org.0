Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2EB23454EA
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 02:22:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbhCWBVj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 21:21:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231152AbhCWBVO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 21:21:14 -0400
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 231DEC061574
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 18:21:14 -0700 (PDT)
Received: by mail-oi1-x233.google.com with SMTP id a8so15253902oic.11
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 18:21:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JYxYqwBBeANyqWyQGmvwdqYnwLRNZNV58JDTVavfLTc=;
        b=a6JdwhHNlMdGaVeyHRZVJp6OtC/hlOt2kSI6OhN2ddlOaHVxVeZeQ8HV+E3FTvmvQI
         pH1SrynTesuBahTBNhFHiYEUSrRpIW+SEGg/Om+b8Jo2ibJxfOS4B1Nd+F1pWFpuNAjM
         1XKffvMC9iWDlAG/WJRZCqZ15ztaMjjuJsuMU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JYxYqwBBeANyqWyQGmvwdqYnwLRNZNV58JDTVavfLTc=;
        b=liYLOCb6A4uYUKW9Yvgus2EQCWjj+TcK6HwWIwq4xiBADtyX6W/qw5OQicscBKg9xM
         aVWsm/CiVnCkX0HoGYu87skwLJM11KszZnfjSw0cvUMbV2GUnmBDFZoyHb9N/1v4NEGO
         raZHXxy6mokQzlh9SFLHRgSYxzsOwCri2bzTtT5nBDzvWMzfnLPp/6AKytv61dUb8FIP
         DmGs7gf7tBIJUnDsYyCTFENQbQwRmCHlTC/TFqa2Me7dSDSeEwWD6TBZ2SkcCEz7nB5g
         H8GkBXPpkYtKDGt6UM/3HonVSCejQfmJvhfIa3jA85OFhYgJ/q++HzMd5oofjryVGwH9
         i9yA==
X-Gm-Message-State: AOAM533l3iCsmCp4cqoDZeX15W0v7+xoHBn4hDfi3HuOOEBbmUhBz2Eo
        +ypFTneLrBxGHYJL2ZbHDnjf35jvW9wG3w==
X-Google-Smtp-Source: ABdhPJwHLkG438fXtlE+tfchNBEjNqH0w/vy8+hGJWvnAZeiRHal8i9Uj0KfiEwbp/M1BASgZIRAow==
X-Received: by 2002:aca:c349:: with SMTP id t70mr1484725oif.87.1616462472894;
        Mon, 22 Mar 2021 18:21:12 -0700 (PDT)
Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com. [209.85.210.43])
        by smtp.gmail.com with ESMTPSA id e12sm3403616oou.33.2021.03.22.18.21.10
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Mar 2021 18:21:11 -0700 (PDT)
Received: by mail-ot1-f43.google.com with SMTP id 31-20020a9d00220000b02901b64b9b50b1so17908654ota.9
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 18:21:10 -0700 (PDT)
X-Received: by 2002:a9d:1b70:: with SMTP id l103mr2239864otl.203.1616462470404;
 Mon, 22 Mar 2021 18:21:10 -0700 (PDT)
MIME-Version: 1.0
References: <1595351666-28193-1-git-send-email-pillair@codeaurora.org>
 <1595351666-28193-3-git-send-email-pillair@codeaurora.org>
 <13573549c277b34d4c87c471ff1a7060@codeaurora.org> <d79ae05e-e75a-de2f-f2e3-bc73637e1501@nbd.name>
 <04d7301d5ad7555a0377c7df530ad8522fc00f77.camel@sipsolutions.net>
 <1f2726ff-8ba9-5278-0ec6-b80be475ea98@nbd.name> <06a4f84b-a0d4-3f90-40bb-f02f365460ec@candelatech.com>
In-Reply-To: <06a4f84b-a0d4-3f90-40bb-f02f365460ec@candelatech.com>
From:   Brian Norris <briannorris@chromium.org>
Date:   Mon, 22 Mar 2021 18:20:58 -0700
X-Gmail-Original-Message-ID: <CA+ASDXOotYHmtqOvSwBES6_95bnbAbEu6F7gQ5TjacJWUKdaPw@mail.gmail.com>
Message-ID: <CA+ASDXOotYHmtqOvSwBES6_95bnbAbEu6F7gQ5TjacJWUKdaPw@mail.gmail.com>
Subject: Re: [RFC 2/7] ath10k: Add support to process rx packet in thread
To:     Ben Greear <greearb@candelatech.com>
Cc:     Felix Fietkau <nbd@nbd.name>,
        Johannes Berg <johannes@sipsolutions.net>,
        Rajkumar Manoharan <rmanohar@codeaurora.org>,
        Rakesh Pillai <pillair@codeaurora.org>,
        ath10k <ath10k@lists.infradead.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        Doug Anderson <dianders@chromium.org>,
        Evan Green <evgreen@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 22, 2021 at 4:58 PM Ben Greear <greearb@candelatech.com> wrote:
> On 7/22/20 6:00 AM, Felix Fietkau wrote:
> > On 2020-07-22 14:55, Johannes Berg wrote:
> >> On Wed, 2020-07-22 at 14:27 +0200, Felix Fietkau wrote:
> >>
> >>> I'm considering testing a different approach (with mt76 initially):
> >>> - Add a mac80211 rx function that puts processed skbs into a list
> >>> instead of handing them to the network stack directly.
> >>
> >> Would this be *after* all the mac80211 processing, i.e. in place of the
> >> rx-up-to-stack?
> > Yes, it would run all the rx handlers normally and then put the
> > resulting skbs into a list instead of calling netif_receive_skb or
> > napi_gro_frags.
>
> Whatever came of this?  I realized I'm running Felix's patch since his mt76
> driver needs it.  Any chance it will go upstream?

If you're asking about $subject (moving NAPI/RX to a thread), this
landed upstream recently:
http://git.kernel.org/linus/adbb4fb028452b1b0488a1a7b66ab856cdf20715

It needs a bit of coaxing to work on a WiFi driver (including: WiFi
drivers tend to have a different netdev for NAPI than they expose to
/sys/class/net/), but it's there.

I'm not sure if people had something else in mind in the stuff you're
quoting though.

Brian
