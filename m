Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D543F241AD9
	for <lists+netdev@lfdr.de>; Tue, 11 Aug 2020 14:17:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728677AbgHKMRO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 08:17:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728556AbgHKMQm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Aug 2020 08:16:42 -0400
Received: from mail-oo1-xc43.google.com (mail-oo1-xc43.google.com [IPv6:2607:f8b0:4864:20::c43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0F7EC06174A;
        Tue, 11 Aug 2020 05:16:41 -0700 (PDT)
Received: by mail-oo1-xc43.google.com with SMTP id y30so2579022ooj.3;
        Tue, 11 Aug 2020 05:16:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BfaOWSVdZQ07T1WYL8SAoDKGztX/6CbsXqzUzK0St8s=;
        b=SUZSVEhCg6bsE5g5AFV3Nu7ILrIBK14FCJeQTRW4bRuMioqVg6Xp+cvlp3Yg1AIoqp
         +KJKITEVIQCC1qHMKKl6em+lfdg+/slX9FriU4yJcV/PdONBjp+w5Vg7c5lA5H/B30xo
         kbK88mNEzpr+gxCHW2krRACRsrCFrXErLis+oz+OGxiTog21ZC3h/ORMHGljsYc9qYWV
         ZeSRskj+HxmoIBBv6sNByjudCtnXj72+c/p3RBZs0DnyCBEZoD1zrdj3FaN1e60XJNeh
         zDBtXC4LSVsOIfENZwvo9yqNGeotY1MPPOUoEKYypDhOkuCUPSA4AiGeNj248+s7ZXKA
         jOMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BfaOWSVdZQ07T1WYL8SAoDKGztX/6CbsXqzUzK0St8s=;
        b=dehgjnTXRiHNOkGlKjcTrGnd1GhBC0cslb6IMQqDgBQHpcX53uvuOqLGIbMv5B6odm
         0isrv9qbXuDuRI8ZNgL55slnmpgjnHDUvOvrLTEdBQvHK84dAcLc2uyN0GqXEIZbYElR
         iVyPe5Eh9a3IXX+II7b+vyBFCPHSJS6jTSfhm8ZrLRcOfI+7N4eUBqHl+l7iEY1l0VHE
         /EzUBD1SO3SwJ8+oRxshr0emmx//cKsGRFaljsbSXOIiaOPEOapzqJ0lwWqR/xd/r+yU
         8Wh4PKgstJZWYdK/RT7/HMR8RWzPd63v8c8cx9nFFBY8Mr/uNsrCa6PAj2OqhYxBlwaa
         9F2g==
X-Gm-Message-State: AOAM5321oNah6qdtpwjFo0Bkdy+lwc74yeF3o/LcS2BZjmVsdPM28NMI
        Pu4eIYcW91tjxbj0mD8HpTfGSY9YPQ3GL/Bna9E=
X-Google-Smtp-Source: ABdhPJzSaTIBww3RVWzclOnCFAapTOONrFiRaRjDySuKQvXkeW9wMlyEhPPRLW4/2hyPS3tLM0iChxXJ4fWU8jt/XPY=
X-Received: by 2002:a4a:2c83:: with SMTP id o125mr823335ooo.84.1597148201081;
 Tue, 11 Aug 2020 05:16:41 -0700 (PDT)
MIME-Version: 1.0
References: <20200716030847.1564131-1-keescook@chromium.org>
 <87h7tpa3hg.fsf@nanos.tec.linutronix.de> <202007301113.45D24C9D@keescook> <CAOMdWSJQKHAWY1P297b9koOLd8sVtezEYEyWGtymN1YeY27M6A@mail.gmail.com>
In-Reply-To: <CAOMdWSJQKHAWY1P297b9koOLd8sVtezEYEyWGtymN1YeY27M6A@mail.gmail.com>
From:   Allen <allen.lkml@gmail.com>
Date:   Tue, 11 Aug 2020 17:46:29 +0530
Message-ID: <CAOMdWSLef4Vy=k-Kfp8RJ++=SsMwCQTU4+hEueK_APDGvJ-PaA@mail.gmail.com>
Subject: Re: [PATCH 0/3] Modernize tasklet callback API
To:     Kees Cook <keescook@chromium.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Oscar Carter <oscar.carter@gmx.com>,
        Romain Perier <romain.perier@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will@kernel.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-usb@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        alsa-devel@alsa-project.org,
        Kernel Hardening <kernel-hardening@lists.openwall.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kees,

> >
>
> Here's the series re-based on top of 5.8
> https://github.com/allenpais/tasklets/tree/V3
>
> Let me know how you would want these to be reviewed.
>

  I see the first set of infrastructure patches for tasklets have
landed in Linus's tree. Good time to send out the ~200 patches?

- Allen
