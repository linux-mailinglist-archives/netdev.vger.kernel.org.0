Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39D377756B
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 02:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387418AbfG0Aau (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 20:30:50 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:35796 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728325AbfG0Aat (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 20:30:49 -0400
Received: by mail-pl1-f195.google.com with SMTP id w24so25327772plp.2;
        Fri, 26 Jul 2019 17:30:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=cCmtCSeKFhu1ooEljTpOszFXABkArRKgOX9s+XSKPyY=;
        b=cn9un79b/4aDE3Rs5eRtcGv0r+JMBNTqfEnAcXFw5bnbZVXBSQGjFDEs7+N/xAVR4X
         shUwYgX9iO8wdsKliigACeyp66bGywVKsdQWYRt9hsm6Dbikpj8xSE0vB1v1paC8ucLd
         j8vUe0BVIlSZ6CBtTi5Q38aw/4gc3Val5Y8bz+cD68jxCh7Caqfc89fNV3V2YlfCQ7pB
         MHdQCAfUgr8c4qBcsZLeyiuhNl3MUZj1tmbPev6CXChZxYP89oBh+psOef6Y9sCH+Nw0
         xdEymesDOpAK2UNiJLtQSy9/kivPNGgUwmRfGAa1dzZvYbkJiDgjvkPUjDh3tWHvr0S0
         yq4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=cCmtCSeKFhu1ooEljTpOszFXABkArRKgOX9s+XSKPyY=;
        b=Po9x8l7M8FK9Khq8Cnl35y53SRH/dCitRyD34CMDnj8PuMvFG1KzdptAHl6Mapp6l8
         v1CveWSo2faflJr897Nrh3lTLk7qQCkAgNGyEFMli+UVMSHeRaNHvQ7LFd58I17Vzi+5
         CswrhSZyHEMUqQMtbLiTdnIuUr4zzQTob+ybjimYthyOfP4VCUe4l9OZWPXCVRzvtk6a
         kHwjIZYR/HT6SGZbOSeuRdmdoJPAthh8R1H6ynuyPkMhTO9heZEN0w5kEr5H2nrVe0Sd
         sFIRSTghcFn91TTkblZkPmLikihC3xwS4QWWbiS8nhqyfIZaryBDGKlMyGm2EdMniTED
         WyMg==
X-Gm-Message-State: APjAAAUA5Act4sY0aqH2O6u1MQz0wVKlUB0+h2WshKR/rMzgxoKVORem
        zi6dTP/0g+14EBFg+fPoBBc=
X-Google-Smtp-Source: APXvYqy+aCArdASXlyUyozrNvj1J4yuVqZwqZTOpExt7X/E2nIWhQOg2kjb0/Jf/raFBbWVlQ1tuVg==
X-Received: by 2002:a17:902:a514:: with SMTP id s20mr93723456plq.162.1564187448786;
        Fri, 26 Jul 2019 17:30:48 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::2:2eeb])
        by smtp.gmail.com with ESMTPSA id 4sm64014065pfc.92.2019.07.26.17.30.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Jul 2019 17:30:48 -0700 (PDT)
Date:   Fri, 26 Jul 2019 17:30:46 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Stanislav Fomichev <sdf@fomichev.me>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 4/9] libbpf: add libbpf_swap_print to get
 previous print func
Message-ID: <20190727003045.63s6qau6kcnpkgxq@ast-mbp.dhcp.thefacebook.com>
References: <20190726203747.1124677-1-andriin@fb.com>
 <20190726203747.1124677-5-andriin@fb.com>
 <20190726212818.GC24397@mini-arch>
 <CAEf4BzYoiL7XAXFdLaf5TDDas42u+jUTy2WydgmJT7WiniqOqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzYoiL7XAXFdLaf5TDDas42u+jUTy2WydgmJT7WiniqOqQ@mail.gmail.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 26, 2019 at 02:47:28PM -0700, Andrii Nakryiko wrote:
> On Fri, Jul 26, 2019 at 2:28 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
> >
> > On 07/26, Andrii Nakryiko wrote:
> > > libbpf_swap_print allows to restore previously set print function.
> > > This is useful when running many independent test with one default print
> > > function, but overriding log verbosity for particular subset of tests.
> > Can we change the return type of libbpf_set_print instead and return
> > the old function from it? Will it break ABI?
> 
> Yeah, thought about that, but I wasn't sure about ABI breakage. It
> seems like it shouldn't, so I'll just change libbpf_set_print
> signature instead.

I think it's ok to change return value of libbpf_set_print() from void
to useful pointer.
This function is not marked as __attribute__((__warn_unused_result__)),
so there should be no abi issues.

Please double check by compiler perf with different gcc-s as Arnaldo's setup does.

