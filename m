Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 344C31D9CE8
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 18:35:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729358AbgESQfL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 12:35:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729000AbgESQfK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 12:35:10 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39B7AC08C5C1
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 09:35:10 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id o14so433294ljp.4
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 09:35:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=54tiBIP0EU7n2aZj7YIONdjaPqjtzHIpQK/HSrYUxTM=;
        b=BKlafAkH7UQm8tvxZZNMBXFgkeIFjR+sjrqKcA5zu8XfgLo2XsHzCIggLB+hau5PqY
         bXm4UtHx7/hgToK6wSRtXVRYfkosw2PzhwIv8qXaSb+oYyfc0spNrlQZmy04cFyxd8aX
         2/kuksBERD9XsYiDJcDnbRjB+/bFhGsJeMkcs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=54tiBIP0EU7n2aZj7YIONdjaPqjtzHIpQK/HSrYUxTM=;
        b=aytIBdlHKZX8tKle+I9bgE1M77s10pXPMNKi7PJ1XYri4yEvlWZyBwuBYJ18s633dq
         uBb0mpuQRRhlqtlLRADJHN+bzbPha7LeIOCZqH+cmc+fAVjI+m8IvHy90IEqfoEo5Psc
         /W94iWTnkAJ29CsBaMVrq3d368JQ4w3xf5s/Hm1UxXRQfAcrUcmbQg8u8wwQiZNkzjYs
         h24Gvr93/+i8/6auNi8lV7JApQe7NjhU+qD6aTGj5KxxRXi7IgOpZ131pvOfA0AMbkVR
         XTuSdoPIDRk2ttHGP623n9h1/GWJTwuVc0XzYnNAJBk6A3vqoXE1sKPrKFQlFGPZRB9b
         ioyQ==
X-Gm-Message-State: AOAM533uzqCekExElrvd7P2lrIWrRj4jIfTJLIL5HwsJ9t51acbkxTAr
        VAgZVyzSrLOzPU8FUd0uI6amUVu7OXE=
X-Google-Smtp-Source: ABdhPJxSbzKCHVSe+6XDgc3mg6BLAHZVirxcHUImAZcXgljjbnMjUH7M4W65fjMTB0YIrgNUJTmp7w==
X-Received: by 2002:a05:651c:119a:: with SMTP id w26mr162149ljo.53.1589906107701;
        Tue, 19 May 2020 09:35:07 -0700 (PDT)
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com. [209.85.167.43])
        by smtp.gmail.com with ESMTPSA id l9sm64128lje.57.2020.05.19.09.35.06
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 May 2020 09:35:06 -0700 (PDT)
Received: by mail-lf1-f43.google.com with SMTP id c21so80736lfb.3
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 09:35:06 -0700 (PDT)
X-Received: by 2002:ac2:5a4c:: with SMTP id r12mr1549357lfn.10.1589906105818;
 Tue, 19 May 2020 09:35:05 -0700 (PDT)
MIME-Version: 1.0
References: <20200519134449.1466624-1-hch@lst.de>
In-Reply-To: <20200519134449.1466624-1-hch@lst.de>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 19 May 2020 09:34:49 -0700
X-Gmail-Original-Message-ID: <CAHk-=whj0zVP-ErHcqGNrM0-bZ+TvSFAwpEd+pKFadZeFXj5PA@mail.gmail.com>
Message-ID: <CAHk-=whj0zVP-ErHcqGNrM0-bZ+TvSFAwpEd+pKFadZeFXj5PA@mail.gmail.com>
Subject: Re: clean up and streamline probe_kernel_* and friends v3
To:     Christoph Hellwig <hch@lst.de>
Cc:     "the arch/x86 maintainers" <x86@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-parisc@vger.kernel.org,
        linux-um <linux-um@lists.infradead.org>,
        Netdev <netdev@vger.kernel.org>, bpf@vger.kernel.org,
        Linux-MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 19, 2020 at 6:44 AM Christoph Hellwig <hch@lst.de> wrote:
>
>  - rebased on 5.7-rc6 with the bpf trace format string changes

Other than the critique about illegible conditionals in the result
when doing that bpf/trace conversion, I like it.

                  Linus
