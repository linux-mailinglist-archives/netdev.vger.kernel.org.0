Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA892CF0ED
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 04:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729818AbfJHCuN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 22:50:13 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:43930 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729212AbfJHCuN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 22:50:13 -0400
Received: by mail-pf1-f194.google.com with SMTP id a2so9886329pfo.10
        for <netdev@vger.kernel.org>; Mon, 07 Oct 2019 19:50:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=SnvVQ/EzvqOCzbAnO9hVrTvDIptEI4+VavfPumW1v9U=;
        b=mA3bNLh9xeJTxheDBXnxHp8LysvFis+b/BMv1BbfmL1faamZOzTGrWr0EDS8UkA9AG
         Qevo/es4qy9/cl96z0pRPOCVyBk7IyoBiMec5eiMQLlABSo4eu2P+yf3YKGLQx9Gl8kc
         rG3nHk0Z52n5mIV2hn0+c4Pi1vcu5XATAHmoJLVIvDp3TzGi3lrnnz8TJiuH9z63Hnng
         D+2S/ZtUe5Ft1mxw4jqLj975j5l/wBCHmzxX7hiXE4TiZYfRtohmRJIUIUyjoCO7xHhl
         gAfHc0Aej1IiDAeDYTde6hBQXTs3nXnUF4kQAtGbujj0loxJ90CetSf+VyE2GbKVXSFI
         WTXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=SnvVQ/EzvqOCzbAnO9hVrTvDIptEI4+VavfPumW1v9U=;
        b=evjl7DcXzzgiLE650lKUndugK2dGuYZHK8HRw4tkFmT8y558Xcr5yfGJitQubtTnXV
         LmipIme/FW+N4KXBhB42WwlPbNPWdUjP0VrxVYBiZSM+k5ZE3ieMBaSKntQNpGpDqIY1
         uUYc0rUO9Xtv/lLn7h7zFPZ3WRgnVVocNNktb7HTGTaFD7/FxN7Xv8HHtUnBr3H1stW9
         14iW2wcB46AKxAD83k4jJX9pf9XOaJdEerbcKwehSniP07DYKb8t9UNdle0fzGVwZCdI
         yUsG9kk9cfW9TvXdo6j3uvG76HJXkRtcZYle40lLdUDmm0/Kxvko61QTzRNSiOfuX2tx
         IjuA==
X-Gm-Message-State: APjAAAVKvH2lmhTjV4SmUc3o914YGpYbLpVHVdet/rmwax4zEKkZkRS8
        2cyNokdRmPoJmJxuyICGArLBdg==
X-Google-Smtp-Source: APXvYqwvBB9deBauQloqA9P1Cs/C0DVWNaziW70egUTa97uoHeiIbeUN2t7ujVtigVXLllR6cBz26w==
X-Received: by 2002:aa7:8b49:: with SMTP id i9mr37199326pfd.255.1570503012500;
        Mon, 07 Oct 2019 19:50:12 -0700 (PDT)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id y8sm16245460pgr.28.2019.10.07.19.50.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2019 19:50:12 -0700 (PDT)
Date:   Mon, 7 Oct 2019 19:50:01 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Stanislav Fomichev <sdf@google.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next] bpftool: fix bpftool build by switching to
 bpf_object__open_file()
Message-ID: <20191007195001.4cb47f99@cakuba.netronome.com>
In-Reply-To: <CAADnVQJne3UYsuuyzTMrCB5LS2d+=--mJ1uRod=JVBcozuuDzg@mail.gmail.com>
References: <20191007225604.2006146-1-andriin@fb.com>
        <20191007185932.24d00391@cakuba.netronome.com>
        <CAADnVQ+XrFG25PaT_859Vz+9HmenKm4F1y4m8F-KauKkBCZp7Q@mail.gmail.com>
        <20191007192328.2d89f63e@cakuba.netronome.com>
        <CAADnVQJne3UYsuuyzTMrCB5LS2d+=--mJ1uRod=JVBcozuuDzg@mail.gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 7 Oct 2019 19:38:15 -0700, Alexei Starovoitov wrote:
> On Mon, Oct 7, 2019 at 7:23 PM Jakub Kicinski wrote:
> > On Mon, 7 Oct 2019 19:16:45 -0700, Alexei Starovoitov wrote:  
> > > On Mon, Oct 7, 2019 at 7:00 PM Jakub Kicinski wrote:  
> > > > On Mon, 7 Oct 2019 15:56:04 -0700, Andrii Nakryiko wrote:  
> > > > > diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
> > > > > index 43fdbbfe41bb..27da96a797ab 100644
> > > > > --- a/tools/bpf/bpftool/prog.c
> > > > > +++ b/tools/bpf/bpftool/prog.c
> > > > > @@ -1092,9 +1092,7 @@ static int do_run(int argc, char **argv)
> > > > >  static int load_with_options(int argc, char **argv, bool first_prog_only)
> > > > >  {
> > > > >       struct bpf_object_load_attr load_attr = { 0 };
> > > > > -     struct bpf_object_open_attr open_attr = {
> > > > > -             .prog_type = BPF_PROG_TYPE_UNSPEC,
> > > > > -     };
> > > > > +     enum bpf_prog_type common_prog_type = BPF_PROG_TYPE_UNSPEC;
> > > > >       enum bpf_attach_type expected_attach_type;
> > > > >       struct map_replace *map_replace = NULL;
> > > > >       struct bpf_program *prog = NULL, *pos;  
> > > >
> > > > Please maintain reverse xmas tree..  
> > >
> > > There are exceptions. I don't think it's worth doing everywhere.  
> >
> > Rule #0 stick to the existing code style.
> >
> > "Previous line of code declaring this variable in a different way was
> > in this place" is a really weak argument and the only one which can be
> > made here...  
> 
> do you seriously think that arguing about xmas tree is a good
> spend of yours and my time?!

Hahaha I really don't, I was about to say. I'm just registering my
disgruntlement :) I can't stay silent when I see hasty submissions
that make the code of which I'm the original author deteriorate.
I hope that's understandable.
