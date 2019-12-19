Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93F49125925
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 02:19:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726705AbfLSBTV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 20:19:21 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:39747 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726616AbfLSBTV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 20:19:21 -0500
Received: by mail-lj1-f196.google.com with SMTP id l2so4283354lja.6;
        Wed, 18 Dec 2019 17:19:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lD+DvubTG0slwY9B4hEbD0fAlm8qh7zMncpqDpYbRQA=;
        b=OdTLAROHfqjCvY0zfPythgiPq7c/k3Be7/ieI20MSpLwghVeWkztnPmmRlrjMiAT93
         b4OYwH4OjoN5z/Or+cjZNUnqjXdgCtFLarjgLjgMl0CmTI6y1kKydmVDS6OyXHuJUWoa
         lrFT56jzBJ00HtgkOfQwuZCo0rPnQKQspCwLi4NUao5paEXhhYYbZzkA/mGXQdO78if3
         0bcYyWAuUPbobSDa++dpDR4OHImgvxXIk8TMA0wX5EakienHSbAOGoNBWxloT3lrTIz9
         WPNQ3b5CpaJV1ovvUYUHGAbIyUj01zaDVDN112vyC9Vd/pASNJ6WUpPJnndU2h1PDbsY
         THPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lD+DvubTG0slwY9B4hEbD0fAlm8qh7zMncpqDpYbRQA=;
        b=CP9bQcImu/QC00H/2OXdakY49yYC1zxQ16lMHef6psNRpdjWss/72eyV1GAkL+bDyH
         qgwyNfPXTyq/c+ziCHUEgcd2elaWOF953dJQ7Ru9fZiL7ebzfUXBNDA7JxLDM5DZe4TB
         QidWHscnNRxx5nQuqhznhg97WKg1neHOJep1QoNdu6M47dpr76OghWOM05YfRqJREHsd
         iX7T7ey46nRlpKEMps0QiEC/BDUpv6OQk0AfDi0Reouq3zfEj6+5NA0gq1RvPaOi7TVV
         OEG13SisVkL7dtBuiHiyjDX5BNrayZr8RQhzzBmRyUCWGlelUoI120vJ1QfPH38FjWlt
         5c0Q==
X-Gm-Message-State: APjAAAUwxiSHXttdfPMwSkFRl/0jlWUMDaf5TLYvgb/+cQevVcc9fNo/
        R3tZDjj86LNqiST8kUWRZozME+YLB9DKcsoe7pU=
X-Google-Smtp-Source: APXvYqyaoPW6xgTAu4nXS6XnlFioksGg01jWd3QdBwuXmYv5xGpKFPchpc1TDwck+6Doo+c7HUGK5ZSmYd4t5pFChH8=
X-Received: by 2002:a2e:93c9:: with SMTP id p9mr3961231ljh.136.1576718358892;
 Wed, 18 Dec 2019 17:19:18 -0800 (PST)
MIME-Version: 1.0
References: <20191218225039.2668205-1-andriin@fb.com> <20191218231215.kzrdnupxs3ybv2zh@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20191218231215.kzrdnupxs3ybv2zh@kafai-mbp.dhcp.thefacebook.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 18 Dec 2019 17:19:07 -0800
Message-ID: <CAADnVQLmrvnv=R6shyLwS61s7kO7=X5WbRur2kWu96FZAWidQg@mail.gmail.com>
Subject: Re: [Potential Spoof] [PATCH bpf-next] libbpf: add
 bpf_link__disconnect() API to preserve underlying BPF resource
To:     Martin Lau <kafai@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 18, 2019 at 3:13 PM Martin Lau <kafai@fb.com> wrote:
>
> On Wed, Dec 18, 2019 at 02:50:39PM -0800, Andrii Nakryiko wrote:
> > There are cases in which BPF resource (program, map, etc) has to outlive
> > userspace program that "installed" it in the system in the first place.
> > When BPF program is attached, libbpf returns bpf_link object, which
> > is supposed to be destroyed after no longer necessary through
> > bpf_link__destroy() API. Currently, bpf_link destruction causes both automatic
> > detachment and frees up any resources allocated to for bpf_link in-memory
> > representation. This is inconvenient for the case described above because of
> > coupling of detachment and resource freeing.
> >
> > This patch introduces bpf_link__disconnect() API call, which marks bpf_link as
> > disconnected from its underlying BPF resouces. This means that when bpf_link
> > is destroyed later, all its memory resources will be freed, but BPF resource
> > itself won't be detached.
> >
> > This design allows to follow strict and resource-leak-free design by default,
> > while giving easy and straightforward way for user code to opt for keeping BPF
> > resource attached beyond lifetime of a bpf_link. For some BPF programs (i.e.,
> > FS-based tracepoints, kprobes, raw tracepoint, etc), user has to make sure to
> > pin BPF program to prevent kernel to automatically detach it on process exit.
> > This should typically be achived by pinning BPF program (or map in some cases)
> > in BPF FS.
> Thanks for the patch.
>
> Acked-by: Martin KaFai Lau <kafai@fb.com>

Applied. Thanks
