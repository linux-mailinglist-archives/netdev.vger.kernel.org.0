Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16CD22D19B3
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 20:37:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726853AbgLGTgs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 14:36:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726777AbgLGTgs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 14:36:48 -0500
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB307C061794
        for <netdev@vger.kernel.org>; Mon,  7 Dec 2020 11:36:07 -0800 (PST)
Received: by mail-ot1-x341.google.com with SMTP id j12so13594898ota.7
        for <netdev@vger.kernel.org>; Mon, 07 Dec 2020 11:36:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5RceGSUFUjLEJW2/scx8HGaoDZct6NVCXjiTK9ixz94=;
        b=UqQDziRM06nUwkOqk9oocYn+WHozQc9sLlHnMvp+bs9W4+eRhAGuTj0f377FbXtgQ9
         saT0UGQRIFbZPDSy6ite4iDUkUbydVukCwhEYfzEWOCSgBjrGqvaYlSEbnE7F0DjqqR0
         q0eWqkt2F9y/LE+l9/PmIghjQstKsX5P9fSyE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5RceGSUFUjLEJW2/scx8HGaoDZct6NVCXjiTK9ixz94=;
        b=KWxmCYhxClyG1xzkGHmBSwhVasC4Ix4wlufjJelNRKO2ZaMaNeKCSHakcUGRywRUEW
         FD1fE2wJRvPKSqSVUCzEaRpYxt0rwl+qTyqsNTZDdeAzuZW7y8pK7e9pI2kUAOVWPn3i
         1w3znXZk7Fu0SW/BPwcIKAEzBH3ssznMj8CPVyl8qvUqP1lO84QOWDHtuWmrldR+oyQE
         S/QLlJAdZqWhZugSBszeNEeQUuA8FsVWLxoDvGKzr7EhjOlvI3OhqjC63jAbJPDgZ/Dr
         rkxNm1DOzrt04o7kqacaXq7mvKD1ztrbUWCFIvWUJvsT+62BTHvvC80oOaWFaBpkwZr7
         J3GQ==
X-Gm-Message-State: AOAM5336EjE0oWYUv/Ui9cICV/LmZi6BDnBidBAhpalSoKk24Gv5xo9+
        hpYB+60MQmzwTKE4rZS9OTq8db+5Y3C1Sw==
X-Google-Smtp-Source: ABdhPJyKs74xggZtLn17kT3MzKsieOal51WrYlYeYPdTMoPvD+sx4zjwCsMFKE+UG8s93/w1bRSZng==
X-Received: by 2002:a05:6830:1f52:: with SMTP id u18mr12609321oth.200.1607369766358;
        Mon, 07 Dec 2020 11:36:06 -0800 (PST)
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com. [209.85.210.42])
        by smtp.gmail.com with ESMTPSA id i4sm2805170oos.31.2020.12.07.11.36.05
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Dec 2020 11:36:05 -0800 (PST)
Received: by mail-ot1-f42.google.com with SMTP id b62so13620205otc.5
        for <netdev@vger.kernel.org>; Mon, 07 Dec 2020 11:36:05 -0800 (PST)
X-Received: by 2002:a9d:744a:: with SMTP id p10mr3982059otk.203.1607369764576;
 Mon, 07 Dec 2020 11:36:04 -0800 (PST)
MIME-Version: 1.0
References: <20201203185732.9CFA5C433ED@smtp.codeaurora.org>
 <20201204111715.04d5b198@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com> <87tusxgar5.fsf@codeaurora.org>
In-Reply-To: <87tusxgar5.fsf@codeaurora.org>
From:   Brian Norris <briannorris@chromium.org>
Date:   Mon, 7 Dec 2020 11:35:53 -0800
X-Gmail-Original-Message-ID: <CA+ASDXNT+uKLLhTV0Nr-wxGkM16_OkedUyoEwx5FgV3ML9SMsQ@mail.gmail.com>
Message-ID: <CA+ASDXNT+uKLLhTV0Nr-wxGkM16_OkedUyoEwx5FgV3ML9SMsQ@mail.gmail.com>
Subject: Re: pull-request: wireless-drivers-next-2020-12-03
To:     Kalle Valo <kvalo@codeaurora.org>, Jakub Kicinski <kuba@kernel.org>
Cc:     "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 7, 2020 at 2:42 AM Kalle Valo <kvalo@codeaurora.org> wrote:
> Jakub Kicinski <kuba@kernel.org> writes:
> > On Thu,  3 Dec 2020 18:57:32 +0000 (UTC) Kalle Valo wrote:
> > There's also a patch which looks like it renames a module parameter.
> > Module parameters are considered uAPI.
>
> Ah, I have been actually wondering that if they are part of user space
> API or not, good to know that they are. I'll keep an eye of this in the
> future so that we are not breaking the uAPI with module parameter
> changes.

Is there some reference for this rule (e.g., dictate from on high; or
some explanation of reasons)? Or limitations on it? Because as-is,
this sounds like one could never drop a module parameter, or remove
obsolete features. It also suggests that debug-related knobs (which
can benefit from some amount of flexibility over time) should go
exclusively in debugfs (where ABI guarantees are explicitly not made),
even at the expense of usability (dropping a line into
/etc/modprobe.d/ is hard to beat).

That's not to say I totally disagree with the original claim, but I'm
just interested in knowing precisely what it means.

And to put a precise spin on this: what would this rule say about the following?

http://git.kernel.org/linus/f06021a18fcf8d8a1e79c5e0a8ec4eb2b038e153
iwlwifi: remove lar_disable module parameter

Should that parameter have never been introduced in the first place,
never be removed, or something else? I think I've seen this sort of
pattern before, where features get phased in over time, with module
parameters as either escape hatches or as opt-in mechanisms.
Eventually, they stabilize, and there's no need (or sometimes, it's
actively harmful) to keep the knob around.

Or the one that might (?) be in question here:
fc3ac64a3a28 rtw88: decide lps deep mode from firmware feature.

The original module parameter was useful for enabling new power-saving
features, because the driver didn't yet know which chip(s)/firmware(s)
were stable with which power features. Now, the driver has learned how
to figure out the optimal power settings, so it's dropping the old
param and adding an "escape hatch", in case there are problems.

I'd say this one is a bit more subtle than the lar_disable example,
but I'm still not sure that really qualifies as a "user-visible"
change.

Brian
