Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4AF5E51A0
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 18:53:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505735AbfJYQxb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 12:53:31 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:33839 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502311AbfJYQxT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 12:53:19 -0400
Received: by mail-qk1-f196.google.com with SMTP id f18so2386394qkm.1;
        Fri, 25 Oct 2019 09:53:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fXySVCbtUFQUIjZ5IC2GZJTsKcpAKCopoZ/FlZT140g=;
        b=A3jagB2V0AdjVDOsm6a/Gc2+ftWVNuOHuMymBoha/0iXyp9tYXgUvuBGz5ddIc2eaW
         AaM8E7dvKA6A20X+omoNML6cf/6peHOprkVIN1iipy3SFg2agrgU2ys9K9h8AbK4eGaV
         HwZ4PlocxJQed3JQbXyGT7H9nhBaaxMZyKJa1efTkIDt6nxRMz3fsGX3WQnpoMRuorJt
         HmA2KEiJtpTpr/y8Rqj/dMZb/Rrv22NndEFy8i0UBW7wI2K92FXXoLa9+5WWyJfUUiro
         8f8heL6e4EPn7cpiu2b3uPoQL2JU7hn4QoxVtRFFCqLMsoNDZ5Edx4Upv+J+Dcj2iLoz
         0LoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fXySVCbtUFQUIjZ5IC2GZJTsKcpAKCopoZ/FlZT140g=;
        b=F3xjbfNOw3+7ozNSNMVsNgdlIBNVJRn5/jG3OXklTbDiI+Lqdj3009KUlDlrI7y7O9
         F1nMitHkf2x/j09FZu+ppFqUyl0M5l5y1b2ob1MmlB6rJkanU1MVQxVrq74S+E0tViQN
         poWxRM3SRVWzW1J7VPtIe7J8xa5889xXXkNbBtbXnyLnLwpLOnDbSESWDfqgm2pEyBjq
         NsuD8UKsxp32A8TL6HoKLggiMRkicSryeWwReEpolQRP2h8vTQhE7cYY++NICc6zzRY9
         A8REatDVnRQPLZ0FzNNs6ouHcBsM8bUvxSR/n3mDxFgPWFSWewIthM18R4Hirplan5Ku
         KzYQ==
X-Gm-Message-State: APjAAAVOepnDRq+GYH2NjMyjWjB2qfVJKADjFKeBnCBUg7efpAjZWkZX
        h2yK90pBMbjfQDNE4bTe7GCTLvUQvO4sLQjAoc8=
X-Google-Smtp-Source: APXvYqyu4fZHMUTfEeEPRzcnpvomOsyw/PeR+9TvbF/TDCLUr57FcahzSz4cKOfwSxf4TBWIAKbw5n3GzplNkg/zvtM=
X-Received: by 2002:a37:9a8a:: with SMTP id c132mr3823467qke.92.1572022398292;
 Fri, 25 Oct 2019 09:53:18 -0700 (PDT)
MIME-Version: 1.0
References: <20191024132341.8943-1-jolsa@kernel.org> <20191024105414.65f7e323@cakuba.hsd1.ca.comcast.net>
 <aeb566cd-42a7-9b3a-d495-c71cdca08b86@fb.com> <20191025093116.67756660@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20191025093116.67756660@cakuba.hsd1.ca.comcast.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 25 Oct 2019 09:53:07 -0700
Message-ID: <CAEf4BzY5o3rR3HXBPORm4NkX4SzDGTQ24p+TMmY8hxyb9+dN2g@mail.gmail.com>
Subject: Re: [PATCHv2] bpftool: Try to read btf as raw data if elf read fails
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>, Martin Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 25, 2019 at 9:31 AM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Fri, 25 Oct 2019 05:01:17 +0000, Andrii Nakryiko wrote:
> > >> +static bool is_btf_raw(const char *file)
> > >> +{
> > >> +  __u16 magic = 0;
> > >> +  int fd;
> > >> +
> > >> +  fd = open(file, O_RDONLY);
> > >> +  if (fd < 0)
> > >> +          return false;
> > >> +
> > >> +  read(fd, &magic, sizeof(magic));
> > >> +  close(fd);
> > >> +  return magic == BTF_MAGIC;
> > >
> > > Isn't it suspicious to read() 2 bytes into an u16 and compare to a
> > > constant like endianness doesn't matter? Quick grep doesn't reveal
> > > BTF_MAGIC being endian-aware..
> >
> > Right now we support only loading BTF in native endianness, so I think
> > this should do. If we ever add ability to load non-native endianness,
> > then we'll have to adjust this.
>
> This doesn't do native endianness, this does LE-only. It will not work
> on BE machines.

How is this LE-only? You have 2 first bytes in BE-encoding on BE
machines and in LE-encoding on LE machines. You read those two bytes
as is into u16, then do comparison to u16. Given all of that is
supposed to be in native encoding, this will work. What am I missing?
