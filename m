Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A84DB346616
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 18:16:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230027AbhCWRPq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 13:15:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbhCWRPh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 13:15:37 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90FE5C061574
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 10:15:33 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id z1so24378405edb.8
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 10:15:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7kxlgEcdUFm8TUBbNBULfXqJU2RwcDNLA6hcE2ptw0w=;
        b=j6rZ/jWRRorU6MnJ1POUaoTUoIvmuU9L8aHPP375ZeeE9hm17hlauPiZHM33jDAdlW
         gXq7W7g9kBFPKfgjXQsJ1j+uZpr4//rfbhzWOETd+uHTQurq1+v/bCxar0qfHhDQU/TF
         hDnRGOOoN6q+sLFClGlSQQD4kqGj3itv+ZCTTzAVzuWYuwr12hP9/luEEIwKeqqM77nf
         lhbqaltTKphNRKiS5sWp90nWZe+WONQjIxzxqvWR8AeFOgygMiqpqXEOYZSLNO3domdl
         Q254+qJNJqBYF4yFiCvJZ8RYVkMVh0YUZmq5clU5yJRpsWbqDoIbj0IQMtzseoiFjIsu
         U8Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7kxlgEcdUFm8TUBbNBULfXqJU2RwcDNLA6hcE2ptw0w=;
        b=LD4Y+NDzY7c+6gNc/X77GNlsyoe9r3ZxjyLDacjNuabUJH63liMc3K+NdLjkbNlTxM
         d3WdNn4jH8stZ0cRSuBxKJ/HTG7j8v1te8QdqUE9LTACuUt9zO2gS/k8pcq3V4Ts4HGp
         dpp1Yb76BpHPi/9oSQk15jGl1B0HsavO1hIsFOKZHtYcUApjigQtkIOuBNBb2n2Fa32x
         BvhliuxBfYvFbPM19Hog/9KgMLYwoNkLbYlm4mYrz65NLubuyR3g7mWHEo2ITOXO9b7z
         DtXMBbBXKuapGTU3gl4tBpKNcZPaQQIjkvxA9QKUsAq7H793JLTl9HCnuu9jCKsthHIB
         SDug==
X-Gm-Message-State: AOAM533bW275nQ3L3LB6rogkWae6qs0FD+bgu2m2INJddXdPYFpQRJGN
        kdv8XX+Dx27aeZg/F8r1r6PRKpfhCDg=
X-Google-Smtp-Source: ABdhPJyMYcU0V5+iuWDDowLRaYVL5G/q3o4goiTZC4d5d+g4hTNvuMjYJW+HVkcAbn/KjYWYIDq5XQ==
X-Received: by 2002:aa7:c889:: with SMTP id p9mr5566176eds.82.1616519730969;
        Tue, 23 Mar 2021 10:15:30 -0700 (PDT)
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com. [209.85.221.47])
        by smtp.gmail.com with ESMTPSA id q26sm11470799eja.45.2021.03.23.10.15.30
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Mar 2021 10:15:30 -0700 (PDT)
Received: by mail-wr1-f47.google.com with SMTP id j7so21599813wrd.1
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 10:15:30 -0700 (PDT)
X-Received: by 2002:adf:fa08:: with SMTP id m8mr5149878wrr.12.1616519729613;
 Tue, 23 Mar 2021 10:15:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210323125233.1743957-1-arnd@kernel.org> <CA+FuTSdZSmBe0UfdmAiE3HxK2wFhEbEktP=xDT8qY9WL+++Cig@mail.gmail.com>
 <CAK8P3a2r+wjJH3NsHf8XDBRhkbyc_HAbNtizO3L-Us+8_JC2bw@mail.gmail.com>
In-Reply-To: <CAK8P3a2r+wjJH3NsHf8XDBRhkbyc_HAbNtizO3L-Us+8_JC2bw@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 23 Mar 2021 13:14:51 -0400
X-Gmail-Original-Message-ID: <CA+FuTScvHD4fTfhzd42hPk_bLPUk0GtbVtq-TZ0=RQerztipBQ@mail.gmail.com>
Message-ID: <CA+FuTScvHD4fTfhzd42hPk_bLPUk0GtbVtq-TZ0=RQerztipBQ@mail.gmail.com>
Subject: Re: [RFC net] net: skbuff: fix stack variable out of bounds access
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Lobakin <alobakin@pm.me>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Guillaume Nault <gnault@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 23, 2021 at 12:30 PM Arnd Bergmann <arnd@kernel.org> wrote:
>
> On Tue, Mar 23, 2021 at 3:42 PM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
> >
> > On Tue, Mar 23, 2021 at 8:52 AM Arnd Bergmann <arnd@kernel.org> wrote:
> > >>
> > A similar fix already landed in 5.12-rc3: commit b228c9b05876 ("net:
> > expand textsearch ts_state to fit skb_seq_state"). That fix landed in
> > 5.12-rc3.
>
> Ah nice, even the same BUILD_BUG_ON() ;-)

Indeed :) Sorry that your work ended up essentially reproducing that.

> Too bad it had to be found through runtime testing when it could have been
> found by the compiler warning.

Definitely useful. Had I enabled it, it would have saved me a lot of debug time.
