Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18F2924A3E5
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 18:21:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726893AbgHSQVI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 12:21:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726809AbgHSQVD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 12:21:03 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E96FAC061383
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 09:21:02 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id g13so11041801ioo.9
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 09:21:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=haRj08XdgMBFITFsEYrK3/rxakK39Am9hjBwIzkZU0A=;
        b=kCIidrWfCtD0JO9rdVWGMMAuY60Bgelu6j8UzS1WXodw6LirKrFzMaG9LbYkL1jmxs
         dshGG0mOWyCX4pjBRfez/2kswtaF0iJ0IjuLfQYI88HPawKOD8+Ld8tghBxZ9P3ScmBY
         4bpzyITYSRQ+KJOZBLcAEATHEeIffWabc7mL3JNU/HGoewB9T1FS1FOInZVlgCgu7FWV
         V4PgeS0fjxRQ1n3JIgsNo0Ck2dEGdDHltYA7THW9cz3GFfjmT2U4sZjsrIV679OXU0yS
         mSGurUU7sIfbOcxMGN8IH5K7wh7FvEtapJjJviQvPvLfzvnz9BcCGNUux2BaDK8OGDl1
         DpOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=haRj08XdgMBFITFsEYrK3/rxakK39Am9hjBwIzkZU0A=;
        b=FylwC/Q1mAeOUpCw4LJ7svE2qmaslDbgUPGKO3QK7Y9YpP3HV72UHlKmgPEuGV8RAc
         rZeIRsqsstCFMS8Ksi5l97gFMXUesgAUlYa5oPzpnr31DTCuCxoUCpWrQoJPyCdEshYH
         ePy6LPXaNRSyOsY6nZxHcZ1X2Zo0BUfkT8LHb3Ws881FT6uMU0Rob66Dh+G6/c0wK23/
         7vA/4tgKcXRvorr/ClhomOwAKkEm6NCGpBUyeQJUOPjPVnnrf7iV20sGZsUghS5Mn7JV
         io7e4Wkp1Mq5H/KD5kk2Pb7tmv2x4QEG/PcItKGr9dJCew+k+iGkztyX5Ux9Qh8LNUQU
         O0LQ==
X-Gm-Message-State: AOAM531Y40038eUHYaYHGuO4no0MvXYUiAX9qmb2Hxr3s8aaj0yE/MdP
        YO4u2vorKq660oyXPfKOpLSkIqj3nTdnFT73kOggWQ==
X-Google-Smtp-Source: ABdhPJxRHdwbxSUd7bFNc5JFOki0Ey+vQgWaKieAc+v/ZcfnYR7OxA9xOW97JNjT03+c3alRkI00rSP7XwxdQFu0UCg=
X-Received: by 2002:a6b:f919:: with SMTP id j25mr21437357iog.113.1597854062014;
 Wed, 19 Aug 2020 09:21:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200818231719.1813482-1-weiwan@google.com> <20200818224553.71bfa4ee@hermes.lan>
In-Reply-To: <20200818224553.71bfa4ee@hermes.lan>
From:   Wei Wang <weiwan@google.com>
Date:   Wed, 19 Aug 2020 09:20:51 -0700
Message-ID: <CAEA6p_Aot3Ow46D-hxNNfQ2FemNxasR9+zvEto=AX+P7O+kwsA@mail.gmail.com>
Subject: Re: [PATCH iproute2-next] iproute2: ss: add support to expose various
 inet sockopts
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Mahesh Bandewar <maheshb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 18, 2020 at 10:46 PM Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> On Tue, 18 Aug 2020 16:17:19 -0700
> Wei Wang <weiwan@google.com> wrote:
>
> > +                     if (!oneline)
> > +                             out("\n\tinet-sockopt: (");
> > +                     else
> > +                             out(" inet-sockopt: (");
> > +                     out("recverr: %d, ", sockopt->recverr);
> > +                     out("is_icsk: %d, ", sockopt->is_icsk);
> > +                     out("freebind: %d, ", sockopt->freebind);
> > +                     out("hdrincl: %d, ", sockopt->hdrincl);
> > +                     out("mc_loop: %d, ", sockopt->mc_loop);
> > +                     out("transparent: %d, ", sockopt->transparent);
> > +                     out("mc_all: %d, ", sockopt->mc_all);
> > +                     out("nodefrag: %d, ", sockopt->nodefrag);
> > +                     out("bind_addr_no_port: %d, ", sockopt->bind_address_no_port);
> > +                     out("recverr_rfc4884: %d, ", sockopt->recverr_rfc4884);
> > +                     out("defer_connect: %d", sockopt->defer_connect);
>
> Since these are all boolean options why not just print them only if on?
> That saves space and makes more compact output.
>
>                         if (sockopt->recverr) out("recverr, ");


Hmm.. Yes. Will send out v2.
