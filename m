Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 226FB4AD84
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 23:46:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730418AbfFRVpt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 17:45:49 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:41996 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730176AbfFRVps (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 17:45:48 -0400
Received: by mail-io1-f68.google.com with SMTP id u19so33310610ior.9
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 14:45:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QtGsm9WX8qP+HbJjvyzMb2QakiyoOOg84hiYW3my0nw=;
        b=nO1pjUe/xoju9XQ5kDeOKFOV8VLFjaJAWlRPbUWc3MKYyfcxq3PmbZPASElNtf1Zct
         ag57MRSiicEJRy+CYsGzgLipcWGigIExuFQ5cPPumcq02+IOnBS5pzQi8LVvlMfeTkV6
         E64pRIJHmX3RVduPFvrEimQEbIsobVuUXoX28=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QtGsm9WX8qP+HbJjvyzMb2QakiyoOOg84hiYW3my0nw=;
        b=lLtS1HCFKKpoHd+r3CzolWw1+t0Cm9EQs4p+DcFq13tUIaGNR7C2deiRw0dh2C+F4t
         +HJILXpC3p2dgkKY6B2Lghf4sKKU/lZmMWO5xx327DFggTQeAtnBvaGrYXFFTF0PmUrQ
         pk2kRz2MkVmXXIeYXbZRWBSycmleXPcYPXN6Qlb145ktFjiNcObH+XWB1TiXPAl16GvL
         TzLZi7p5vLbVNjtKsLp6gtyGhj29nsueHAgoC3nfHYwkSxuedrLbh9yUUDdYA1YTA9Dt
         EVBHnjIJ3RNzRhV/qTeJFwr17hE5DIr2OxrJ9ngUdh5cwjaxCAVFlIwJxYslPTMRKXtC
         ctcw==
X-Gm-Message-State: APjAAAWxDg2vmDHDoLvgzA9mEaAOdx3ZuovB85ALzV0e0+bLaXj1GlNF
        jXR0WAVEb2odIjuFW7Ymf9rcaO2K5fo=
X-Google-Smtp-Source: APXvYqy9Wg9HZiKO9sB4CNIzE4kAZYYaBz+C0sn8zewyxwmCqRtO9zMSEACBM/c3U9sNwGfP5tSvjQ==
X-Received: by 2002:a02:ab83:: with SMTP id t3mr4501860jan.133.1560894347604;
        Tue, 18 Jun 2019 14:45:47 -0700 (PDT)
Received: from mail-io1-f44.google.com (mail-io1-f44.google.com. [209.85.166.44])
        by smtp.gmail.com with ESMTPSA id j23sm15976586ioo.6.2019.06.18.14.45.46
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Jun 2019 14:45:46 -0700 (PDT)
Received: by mail-io1-f44.google.com with SMTP id w25so33303997ioc.8
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 14:45:46 -0700 (PDT)
X-Received: by 2002:a5e:8f08:: with SMTP id c8mr6439411iok.52.1560894346193;
 Tue, 18 Jun 2019 14:45:46 -0700 (PDT)
MIME-Version: 1.0
References: <20190618211440.54179-1-mka@chromium.org>
In-Reply-To: <20190618211440.54179-1-mka@chromium.org>
From:   Doug Anderson <dianders@chromium.org>
Date:   Tue, 18 Jun 2019 14:45:34 -0700
X-Gmail-Original-Message-ID: <CAD=FV=V6TqT93Lb2UoQdkyO2j7OHrggCn-4qwDLEFw=N7RZ2Eg@mail.gmail.com>
Message-ID: <CAD=FV=V6TqT93Lb2UoQdkyO2j7OHrggCn-4qwDLEFw=N7RZ2Eg@mail.gmail.com>
Subject: Re: [PATCH] net/ipv4: fib_trie: Avoid cryptic ternary expressions
To:     Matthias Kaehlcke <mka@chromium.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Alexander Duyck <alexander.h.duyck@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, Jun 18, 2019 at 2:14 PM Matthias Kaehlcke <mka@chromium.org> wrote:
>
> empty_child_inc/dec() use the ternary operator for conditional
> operations. The conditions involve the post/pre in/decrement
> operator and the operation is only performed when the condition
> is *not* true. This is hard to parse for humans, use a regular
> 'if' construct instead and perform the in/decrement separately.
>
> This also fixes two warnings that are emitted about the value
> of the ternary expression being unused, when building the kernel
> with clang + "kbuild: Remove unnecessary -Wno-unused-value"
> (https://lore.kernel.org/patchwork/patch/1089869/):
>
> CC      net/ipv4/fib_trie.o
> net/ipv4/fib_trie.c:351:2: error: expression result unused [-Werror,-Wunused-value]
>         ++tn_info(n)->empty_children ? : ++tn_info(n)->full_children;
>
> Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
> ---
> I have no good understanding of the fib_trie code, but the
> disentangled code looks wrong, and it should be equivalent to the
> cryptic version, unless I messed it up. In empty_child_inc()
> 'full_children' is only incremented when 'empty_children' is -1. I
> suspect a bug in the cryptic code, but am surprised why it hasn't
> blown up yet. Or is it intended behavior that is just
> super-counterintuitive?
>
> For now I'm leaving it at disentangling the cryptic expressions,
> if there is a bug we can discuss what action to take.
> ---
>  net/ipv4/fib_trie.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)

I have no knowledge of this code either but Matthias's patch looks
sane to me and I agree with the disentangling before making functional
changes.

My own personal belief is that this is pointing out a bug somewhere.
Since "empty_children" ends up being an unsigned type it doesn't feel
like it was by-design that -1 is ever a value that should be in there.

In any case:

Reviewed-by: Douglas Anderson <dianders@chromium.org>
