Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3203A1E738
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 05:49:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726279AbfEODtY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 23:49:24 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:46556 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726254AbfEODtX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 May 2019 23:49:23 -0400
Received: by mail-lf1-f65.google.com with SMTP id l26so789539lfh.13
        for <netdev@vger.kernel.org>; Tue, 14 May 2019 20:49:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=V6Q1Y+NN5YAgrXYw7LWjBvbRlmONvZyqdxZKQsOcdZI=;
        b=Xc/XcFUhUKR2Gj3JJV7y/pPk2C8C4DFm9DZmcMx0bzI4lNG25u5QTProLz8QpcchYW
         +Dq0RPUFNzs730fAGnFaMHh0JxxzJKRkClC4mycljAUDNGtShWI3kpW1pJuuV19QrXbX
         ZeOLLmU3r0pebmQhnnf3TKcLKvV3dfD5Ue2cJLEZoZBIhPAiGVQy5MhF3qnz5sMBcLwN
         ppfcwVV0/8uMohvPLnrSI95T4S8dZf7CVlIQRh+C7nDUEtRQ6mcCdPYGMox2Ay/VGEsu
         TYfPVHYtxMc07zhUY8iLsLdjb1fFN53tBfrplF0WRn/MN84LboMRaitqvkhdqd9w0I9C
         5rjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V6Q1Y+NN5YAgrXYw7LWjBvbRlmONvZyqdxZKQsOcdZI=;
        b=trXx+2i7JKCkZaVsBaSW3hClTBGImXtgslraeIxLZcs7jcjDoELqjm47nPsXDujzu9
         o/B+JLr2N45zFrTc7V3sEDKzyk09b8FL3oteZOZKnXOw0M/tytXgLGzXB0XwsvdqGWZu
         HcWzCJZe+8VwQrUT0QF5hZB+4K164BgoI28Rw0TSzqvK/KysV6eFSjls6AmlPNxq02VA
         u5Nl2T6jYvMmA14Qclk8qfBBIK3R+seE4HQr4tVdNzNBTqgD5jXz1J+3CgdGKjH6jhdO
         RbvEjBWucoCmFsM4SzvNcVCpe8JiF9xqOQzeF5B1M7NLiBYNBjpGVU4lNggSEKuwUJev
         kfiQ==
X-Gm-Message-State: APjAAAWE+rGEq4CkOnvOoCD/oxErWeKJp8Y7spcVpSFl13iNq66/3kvF
        OI8CkYvrMu5Qr6IPEDJBR+e+/jVfNSbr6NxByJotCQ==
X-Google-Smtp-Source: APXvYqyBvPgZyqbKgzRCMXrt0pgC+WcWjV3Z+lycFUcJkj8xHR6cyiRLJ41uMFVBkNbW4Nsahks5boWxruHMNXUm8Pg=
X-Received: by 2002:a19:4811:: with SMTP id v17mr12722068lfa.10.1557892161554;
 Tue, 14 May 2019 20:49:21 -0700 (PDT)
MIME-Version: 1.0
References: <20190513185724.GB24057@mini-arch> <CAADnVQLX3EcbW=iVxjsjO38M3Lqw5TfCcZtmbnt1DJwDvp64dA@mail.gmail.com>
 <20190514173002.GB10244@mini-arch> <20190514174523.myybhjzfhmxdycgf@ast-mbp>
 <20190514175332.GC10244@mini-arch> <CAADnVQLAJ77XS8vfdnszHsw_KcmzrMDvPH0UxVXORN-wjc=rWQ@mail.gmail.com>
 <20190515021144.GD10244@mini-arch> <CAADnVQ+LPLfdfkv2otb6HRPeQiiDyr4ZO04B--vrXT_Tu=-9xQ@mail.gmail.com>
 <5ed25b81-fdd0-d707-f012-736fe6269a72@gmail.com> <20190515025636.GE10244@mini-arch>
 <20190515031643.blzxa3sgw42nelzd@ast-mbp.dhcp.thefacebook.com>
 <CAKH8qBuSM3a6j6xupaWOGqT3XM9rUzZRLujg_E_8WLjsd2t-DA@mail.gmail.com> <CAADnVQLnFr6hBM1BFTLY7FLDVR85-jQn4O9UtJLB0-a0WLjuiQ@mail.gmail.com>
In-Reply-To: <CAADnVQLnFr6hBM1BFTLY7FLDVR85-jQn4O9UtJLB0-a0WLjuiQ@mail.gmail.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Tue, 14 May 2019 20:49:09 -0700
Message-ID: <CAKH8qBtW=N9QdtAPNY-3WDKu6rzqZ8w-d3JNA_XZbitED0LgDg@mail.gmail.com>
Subject: Re: [PATCH bpf 0/4] bpf: remove __rcu annotations from bpf_prog_array
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Stanislav Fomichev <sdf@fomichev.me>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 14, 2019 at 8:42 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, May 14, 2019 at 8:38 PM Stanislav Fomichev <sdf@google.com> wrote:
> >
> > Take a look at the patches 2-4 in the current series where I convert
> > the callers.
> >
> > (Though, I'd rename xxx_dereference to xxx_rcu_dereference for clarity we
> > get to a v2).
>
> please make a fresh repost _after_ bpf-next opens.
Sure, sgtm, thank you for a preliminary review and input!
