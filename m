Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98DC829E2C3
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 03:38:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727282AbgJ2CgN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 22:36:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726045AbgJ2Cem (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 22:34:42 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4E21C0613CF
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 19:34:42 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id n16so1099935pgv.13
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 19:34:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Lgp5E2CBFegdQFbndqfbV77VhNdz0J+UuczY3mSKBZw=;
        b=esLg1vG/os3sInhirw59iWuJxIkaFMgO/UtjqVMskru6qP7rcOZ2BNDk2NeyoR4JCP
         pz6X1L6+P7E9+S09B0ZXki1K5jazTLUCJxJSlOVsnlxfXnqmtD6zXaRTpIN9RrcMBzQg
         jpldOl2X9wJfjvf/CqkDXw0YvEfHKuhj6NzhpRKBmCXAo5Z2bj9AXcfrWzXgIPYC/IRQ
         8tyakq+DwH7i6LmQAcuQpH2IwLHJCFzaHx2LpoJF7jVLgEfMrFy79TRDGriwZeWYxjAu
         MfEmdr34E5Xw8SjnrIh+v23y29MkrYlUGUBTatIxUg203u8sEm15Z5ZR15TGkeAX01I5
         PLvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Lgp5E2CBFegdQFbndqfbV77VhNdz0J+UuczY3mSKBZw=;
        b=GZ3gG+suON8pUWwmtW5MMSGYZvHNYtBZZw5AJZstQf99vPGAuGD7VnRO9BNzIYJLOi
         /4Ive/NGPAAQq57wRjR5rbyvuBpgdxywA6UeKl5im4MQHSi/KOke7cpeFe53eItCypoa
         krIWWhLzo0SLNxoYDob9sLt7LA2HsOuBAFmDwBX7Z6Z4FifxolhpsLftfda0SY4I4HAl
         G3OQz5p81L90tok0iP+VPJeMShJbaCc8RV1ZEA+lOdcVQC+calH+wI9lJVFIX3i39hGa
         Pdn4q5yxfL2QLywdVo/Ntz+C/tw4Ctdb0a79iRRicBXYqjmOPlFimJcZ7XGW6BFKEDUj
         x2yQ==
X-Gm-Message-State: AOAM530Zih0Yf+71Pwb4JI9IEhAe3g1n0B9pMwi6FK4cAY5xtoYBzigT
        YhE8KYQruYw+c8KmCdlYzhI73Q==
X-Google-Smtp-Source: ABdhPJwTGI6fl8sa55HBLrVTQ9r3KRRl90VlkndcgHFTXwFK2dbzHSnaob2FPj3WNGrEyt+Ybzgcjw==
X-Received: by 2002:a17:90b:20a:: with SMTP id fy10mr1921179pjb.20.1603938882375;
        Wed, 28 Oct 2020 19:34:42 -0700 (PDT)
Received: from hermes.local (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id 32sm679997pgz.11.2020.10.28.19.34.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 19:34:42 -0700 (PDT)
Date:   Wed, 28 Oct 2020 19:34:38 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Hangbin Liu <haliu@redhat.com>, David Ahern <dsahern@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Jiri Benc <jbenc@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Subject: Re: [PATCHv2 iproute2-next 0/5] iproute2: add libbpf support
Message-ID: <20201028193438.21f1c9b0@hermes.local>
In-Reply-To: <CAEf4BzZR4MqQJCD4kzFsbhpfmp4RB7SHcP5AbAiqzqK7to2u+g@mail.gmail.com>
References: <20201023033855.3894509-1-haliu@redhat.com>
        <20201028132529.3763875-1-haliu@redhat.com>
        <7babcccb-2b31-f9bf-16ea-6312e449b928@gmail.com>
        <20201029020637.GM2408@dhcp-12-153.nay.redhat.com>
        <CAEf4BzZR4MqQJCD4kzFsbhpfmp4RB7SHcP5AbAiqzqK7to2u+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 28 Oct 2020 19:27:20 -0700
Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:

> On Wed, Oct 28, 2020 at 7:06 PM Hangbin Liu <haliu@redhat.com> wrote:
> >
> > On Wed, Oct 28, 2020 at 05:02:34PM -0600, David Ahern wrote:  
> > > fails to compile on Ubuntu 20.10:
> > >
> > > root@u2010-sfo3:~/iproute2.git# ./configure
> > > TC schedulers
> > >  ATM  yes
> > >  IPT  using xtables
> > >  IPSET  yes
> > >
> > > iptables modules directory: /usr/lib/x86_64-linux-gnu/xtables
> > > libc has setns: yes
> > > SELinux support: yes
> > > libbpf support: yes
> > > ELF support: yes
> > > libmnl support: yes
> > > Berkeley DB: no
> > > need for strlcpy: yes
> > > libcap support: yes
> > >
> > > root@u2010-sfo3:~/iproute2.git# make clean
> > >
> > > root@u2010-sfo3:~/iproute2.git# make -j 4
> > > ...
> > > /usr/bin/ld: ../lib/libutil.a(bpf_libbpf.o): in function `load_bpf_object':
> > > bpf_libbpf.c:(.text+0x3cb): undefined reference to
> > > `bpf_program__section_name'
> > > /usr/bin/ld: bpf_libbpf.c:(.text+0x438): undefined reference to
> > > `bpf_program__section_name'
> > > /usr/bin/ld: bpf_libbpf.c:(.text+0x716): undefined reference to
> > > `bpf_program__section_name'
> > > collect2: error: ld returned 1 exit status
> > > make[1]: *** [Makefile:27: ip] Error 1
> > > make[1]: *** Waiting for unfinished jobs....
> > > make: *** [Makefile:64: all] Error 2  
> >
> > You need to update libbpf to latest version.  
> 
> Why not using libbpf from submodule?

Because it makes it harder for people downloading tarballs and distributions.
Iproute2 has worked well by being standalone.

Want to merge libbpf into iproute2?? 
 

