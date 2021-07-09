Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3B843C29D3
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 21:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbhGITvE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 15:51:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbhGITvE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Jul 2021 15:51:04 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 708EBC0613DD;
        Fri,  9 Jul 2021 12:48:19 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id m83so2015282pfd.0;
        Fri, 09 Jul 2021 12:48:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zFraQTlxIKOC9rWgqvN4Foc42UQD7O8NHfZ+X7Ngn7w=;
        b=ZXzaINnaIl6OF7u6G9n7DO5c7cT2Xpc30+Cp5CyvLS2VEeHDjjfQOldFaUu1QzrVS+
         4dVUazGpvY3HzMPWv1HtSfukiiojTqGqby6PL0QqTHO+8yIIgOO12CvQB35Cb9eMN62a
         LTytVq7QzBr3fsoPCFhtvoZljdUFepTL/Se7bRCaLazkiNwyXektGGSYBFiXDbjtMtRX
         g4xAehs3m0RV0bQ3F/j0/IaD8f9+kp0w9xWPsFkbuBoX6JfECeui7U3kDpQhgJyFd4G6
         NxnKPY+Vtm38G4xVFO+IJgAH9NAdmTqyApbSM/jN72XQOA5xDgsV5OpUyNVWevw1M5At
         gq4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zFraQTlxIKOC9rWgqvN4Foc42UQD7O8NHfZ+X7Ngn7w=;
        b=SOZIbx8z1FPxkULFLOchPIYN6dv6W2SrFlrLuYFKqPMtcuhEr/Eh0eqt+QwCC74hTN
         bKmrZX5vHLR/3jKHfpVTAp2LEKqiyzRFqh70eShECzph+CYWm5pWv6Ne+AF1tpdLgMOE
         f1Mtj9dBQBOP/VuzaxLAwkBCfoJq1TRJoYowD7Za5Ti+n/OpXqcIjPUwb91LDiAm7qDw
         meUovZKg3Uo5CmwOanJ/IksC+FHWCv4Pc49r4hYO1U6aI7h4upy3MAfHwBKVYZKOQt0g
         2V9yxB5nmzcNeZaT5/B6Q6SLpN7LHYLnft0U7nKbMisNRi8vFs0WdNezbsQIeUS3nS25
         xG4Q==
X-Gm-Message-State: AOAM532dncJpeo4yQSoONkeR6TeQH2H+gvHeA5shP8ChswosvvG9rE2y
        BhfxKxez3Zu2kidlJTHabUIOqdfA2wCtHx2XxYX5fOaJee4=
X-Google-Smtp-Source: ABdhPJxJvdLsXFJrVhMnP4zPHLFbby+coc89CY+82bYbYrA/9LDfKHjCx6quEMUez0wpA4u5lYCrNJbYB6U0IBdbHKU=
X-Received: by 2002:a63:f65:: with SMTP id 37mr39838066pgp.367.1625860098775;
 Fri, 09 Jul 2021 12:48:18 -0700 (PDT)
MIME-Version: 1.0
References: <CAHQn7pKcyC_jYmGyTcPCdk9xxATwW5QPNph=bsZV8d-HPwNsyA@mail.gmail.com>
 <a7f11cc2-7bef-4727-91b7-b51da218d2ee@nbd.name> <YNtdKb+2j02fxfJl@kroah.com>
 <872e3ea6-bbdf-f67c-58f9-4c2dafc2023a@nbd.name> <CAHQn7pJY4Vv_eWpeCvuH_C6SHwAvKrSE2cQ=cTir72Ffcr9VXg@mail.gmail.com>
 <56afa72ef9addbf759ffb130be103a21138712f9.camel@sipsolutions.net>
In-Reply-To: <56afa72ef9addbf759ffb130be103a21138712f9.camel@sipsolutions.net>
From:   Davis Mosenkovs <davikovs@gmail.com>
Date:   Fri, 9 Jul 2021 22:48:06 +0300
Message-ID: <CAHQn7pLxUt03sgL0B2_H0_p0iS0DT-LOEpMOkO_kd_w_WVTKBA@mail.gmail.com>
Subject: Re: Posible memory corruption from "mac80211: do not accept/forward
 invalid EAPOL frames"
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Felix Fietkau <nbd@nbd.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-07-02 at 09:54 Johannes Berg (<johannes@sipsolutions.net>) wrote:
>
> > If testing procedure mentioned in my first email is sufficient (and
> > using skb->data is the correct solution in kernel trees where current
> > code doesn't work properly), I can make and test the patches.
> > Should I do that?
>
> Yes, please do.
>
> Thanks,
> johannes
>
I have done the testing on kernel versions 4.4.274, 4.9.274, 4.14.238,
4.19.196, 5.4.130, 5.10.48, 5.12.15 and 5.13.1.
Only kernels 4.4.274, 4.9.274 and 4.14.238 are affected.
On kernels 4.19.196, 5.4.130, 5.10.48, 5.12.15 and 5.13.1 current code
works properly (and skb->data produces incorrect pointer when used
instead of skb_mac_header()).
I have submitted patches for the affected kernel versions:
https://lore.kernel.org/r/20210707213800.1087974-1-davis@mosenkovs.lv
https://lore.kernel.org/r/20210707213820.1088026-1-davis@mosenkovs.lv
https://lore.kernel.org/r/20210707213834.1088078-1-davis@mosenkovs.lv

Best regards,
Davis
