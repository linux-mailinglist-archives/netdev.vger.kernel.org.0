Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D970311D8C7
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 22:49:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730941AbfLLVss (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 16:48:48 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:42800 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730831AbfLLVsr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 16:48:47 -0500
Received: by mail-lj1-f193.google.com with SMTP id e28so312578ljo.9;
        Thu, 12 Dec 2019 13:48:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=251vXsWuEJ2xi9HpdeyVMWO66+kda9V2oIuPFR8DACc=;
        b=J/0ey5vBuE4xIZz39LnvoyOG/fAB6pu9gHIRMpxn3FSo9MZDCqhdn1dfxk10IvMKeB
         pC+Xc8mkKXhOujl6hgqYGP+EDyowenPt6283Ee2Vjw8beLyL3+BuchSUzHZknjIaVCxT
         da8JgISZntIHtFqHRb6JtT9YHW8Pz5aGyqlq2XEPQuViKwuIY5+XuGkdPzQ5qi7gbXOQ
         uSG5GJDThnuDVd5jzcW0R3jOazDHemWuPj2bqQmuvaa62L0qNmS6BMoaXEreMi2MwN2N
         vPRKEr8649pXde/FYIlbhhBf9EluRRUnTc89x0I8U9neCXPeXqwqFN/TiDIyp4y4j8/F
         Klqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=251vXsWuEJ2xi9HpdeyVMWO66+kda9V2oIuPFR8DACc=;
        b=UnJTu41UgGoi6CWC4SakYad0jZL+ishLvLY6CwmyhdKgMYJy6gQLkFNOfkwxd+3HoF
         a6kKzE0eZ5JCHfPpYm/QmmMdrkJjV7HaqUXLXZG2QNCs42O3b2JDxwwcg5xOT9wxixBQ
         ywMVdBE7vnC1cPOVINpB4TFusgGxQBrahau+EoHl3jTvCsHU3M15T/D1t8jYaVaUef79
         dtDrRBf8lDZKjRX4vkkfpK84/ThXALsRU9Qbblis+tEEuGoDpgisHOVfjG1UNi4uKvsz
         kIQW7eV3DNukPeP8RczXCj8WmcRyU991AADfahcp93sNLI5eQ8MvAqPodIu3zBxTXulr
         xwTg==
X-Gm-Message-State: APjAAAU6r/0oP9H6x4izN4NgFyc0h5g3/Cdn6ZNna3axXX1u3V5oh647
        hjoUFbZMCbU1Z4407D6B1jgSsVtVG6AI3aPCXtc=
X-Google-Smtp-Source: APXvYqzeBVphnRzs3/2/OERF5E5/HbE2ldGW+e9UXgfRWZWnzWK3+/UsUpkNCc7gdU81aliSlcSil8mHtQdh5Tv/F5c=
X-Received: by 2002:a2e:3609:: with SMTP id d9mr7282781lja.188.1576187325385;
 Thu, 12 Dec 2019 13:48:45 -0800 (PST)
MIME-Version: 1.0
References: <20191212171918.638010-1-andriin@fb.com> <20191212183046.7h4kcuvmayafzztg@kafai-mbp>
In-Reply-To: <20191212183046.7h4kcuvmayafzztg@kafai-mbp>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 12 Dec 2019 13:48:34 -0800
Message-ID: <CAADnVQJ2T72Jos4g348ZYO-Up1-hYFYVxmHNA3RsLJL1xRWKog@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next] libbpf: fix printf compilation warnings on
 ppc64le arch
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

On Thu, Dec 12, 2019 at 10:31 AM Martin Lau <kafai@fb.com> wrote:
>
> On Thu, Dec 12, 2019 at 09:19:18AM -0800, Andrii Nakryiko wrote:
> > On ppc64le __u64 and __s64 are defined as long int and unsigned long int,
> > respectively. This causes compiler to emit warning when %lld/%llu are used to
> > printf 64-bit numbers. Fix this by casting to size_t/ssize_t with %zu and %zd
> > format specifiers, respectively.
> Acked-by: Martin KaFai Lau <kafai@fb.com>

Applied. Thanks
