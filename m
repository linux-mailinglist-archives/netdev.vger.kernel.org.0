Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F04641FF90D
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 18:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731128AbgFRQSo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 12:18:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730775AbgFRQSm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 12:18:42 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B0E3C06174E
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 09:18:42 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id k22so4870722qtm.6
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 09:18:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vYvgdhM5HqQ7GxLo0HF9mk4pQ8qZlYShOF7Z0aaxwJE=;
        b=AKhFqoVahtvF3gPWNmXImC0b1cKuIsDdRKKIvOjJMye5wt8NypGRr7hLfh/cifIPh3
         DnmBxaKqqQVq6LZaRpxs+RyyJ2wzXyORdKRfdVYSdENP0duzsODYcaqBHszE1ZZNyOab
         wgvFODJWIWv4oquAUOynY06rLHIlIKU9EBrR1VQ4T3giIAjKKKF/cbac2pZnFhB5LQoy
         3U/+N0Vm440MvRezKrQiInezngyzVpacA9Pp0IhR6jWnh020jIPdvAq1f0/O5zZGNfpa
         JD9EUgyRTlRctjkQXLlRgqhbLkXwf1wY1IMyzQeJ9CYVRwS1/X7ARbqgnA8fPr5JUpgy
         2Hyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vYvgdhM5HqQ7GxLo0HF9mk4pQ8qZlYShOF7Z0aaxwJE=;
        b=I78oudkA/9/cWMHHosbKuE8uJVPxqamYhanc0F5Gxtz8lp/izaiDuGxKu9VD5676dI
         XdQeOKPDe9v9nPCRyG2hIR1W7uJ4HW8UAIuZRegrVWDTGwq/q/RSsfsDYD06ZmKhQyHr
         vKQozRVXmOhYTYFUR3rS7BwFJyF32+61lY5Iv+S9X3xZLxImSiteS/fHALUfTnNRgSyo
         IhLLOgBdBSVYZUSQw9cID7tmQpTwMuiLKML6cyVMz/9RU6DshoD4R98+EgS0h/IQHJUs
         2LyLsuEyLRjaqpvK+jZB7TPs8LP1Saqp5cAjlPKIB/LjteIOCgwWsTW1+HqwYjMDFJjd
         Icmw==
X-Gm-Message-State: AOAM531ow2i9vx3Y2XX4BhJbVqtq8wTh1pZpD+WenvRPon+XRUBhJxyp
        xn0qQ5ayE2CPOc0X363xpwcj+4KN
X-Google-Smtp-Source: ABdhPJwY3WVFg2wqbz3fPG0b8D+ZJ4HWVDrmZFjbfeR8FtGaieYJo/t56XZLq1JTu3V9iOEjdxo7Bw==
X-Received: by 2002:ac8:4742:: with SMTP id k2mr5326259qtp.304.1592497120766;
        Thu, 18 Jun 2020 09:18:40 -0700 (PDT)
Received: from mail-yb1-f179.google.com (mail-yb1-f179.google.com. [209.85.219.179])
        by smtp.gmail.com with ESMTPSA id n25sm3085766qkk.76.2020.06.18.09.18.39
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Jun 2020 09:18:39 -0700 (PDT)
Received: by mail-yb1-f179.google.com with SMTP id s1so3399356ybo.7
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 09:18:39 -0700 (PDT)
X-Received: by 2002:a25:b8c:: with SMTP id 134mr8190668ybl.428.1592497119169;
 Thu, 18 Jun 2020 09:18:39 -0700 (PDT)
MIME-Version: 1.0
References: <20200618145549.37937-1-willemdebruijn.kernel@gmail.com> <20200618085416.48b44e51@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200618085416.48b44e51@kicinski-fedora-PC1C0HJN>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 18 Jun 2020 12:18:01 -0400
X-Gmail-Original-Message-ID: <CA+FuTSeLneTOB10Vd+wO2LFmU9eY_zQJJ0QvX7JbCW9C1ef=ew@mail.gmail.com>
Message-ID: <CA+FuTSeLneTOB10Vd+wO2LFmU9eY_zQJJ0QvX7JbCW9C1ef=ew@mail.gmail.com>
Subject: Re: [PATCH net] selftests/net: report etf errors correctly
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 18, 2020 at 11:54 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 18 Jun 2020 10:55:49 -0400 Willem de Bruijn wrote:
> > +             switch (err->ee_errno) {
> > +             case ECANCELED:
> > +                     if (err->ee_code != SO_EE_CODE_TXTIME_MISSED)
> > +                             error(1, 0, "errqueue: unknown ECANCELED %u\n",
> > +                                         err->ee_code);
> > +                     reason = "missed txtime";
> > +             break;
> > +             case EINVAL:
> > +                     if (err->ee_code != SO_EE_CODE_TXTIME_INVALID_PARAM)
> > +                             error(1, 0, "errqueue: unknown EINVAL %u\n",
> > +                                         err->ee_code);
> > +                     reason = "invalid txtime";
> > +             break;
> > +             default:
> > +                     error(1, 0, "errqueue: errno %u code %u\n",
> > +                           err->ee_errno, err->ee_code);
> > +             };
> >
> >               tstamp = ((int64_t) err->ee_data) << 32 | err->ee_info;
> >               tstamp -= (int64_t) glob_tstart;
> >               tstamp /= 1000 * 1000;
> > -             fprintf(stderr, "send: pkt %c at %" PRId64 "ms dropped\n",
> > -                             data[ret - 1], tstamp);
> > +             fprintf(stderr, "send: pkt %c at %" PRId64 "ms dropped: %s\n",
> > +                             data[ret - 1], tstamp, reason);
>
> Hi Willem! Checkpatch is grumpy about some misalignment here:
>
> CHECK: Alignment should match open parenthesis
> #67: FILE: tools/testing/selftests/net/so_txtime.c:187:
> +                               error(1, 0, "errqueue: unknown ECANCELED %u\n",
> +                                           err->ee_code);
>
> CHECK: Alignment should match open parenthesis
> #73: FILE: tools/testing/selftests/net/so_txtime.c:193:
> +                               error(1, 0, "errqueue: unknown EINVAL %u\n",
> +                                           err->ee_code);
>
> CHECK: Alignment should match open parenthesis
> #87: FILE: tools/testing/selftests/net/so_txtime.c:205:
> +               fprintf(stderr, "send: pkt %c at %" PRId64 "ms dropped: %s\n",
> +                               data[ret - 1], tstamp, reason);

Thanks for the heads-up, Jakub.

I decided to follow the convention in the file, which is to align with
the start of the string.

Given that, do you want me to resubmit with the revised offset? I'm
fine either way, of course.

Also, which incantation of checkpatch do you use? I did run
checkpatch, without extra args, and it did not warn me about this.
