Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F019929E2B2
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 03:34:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391338AbgJ2CeN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 22:34:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391325AbgJ2CdR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 22:33:17 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E665C0613D1
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 19:33:17 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id g12so1111404pgm.8
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 19:33:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZrMjTuUshxaUx8lG41ryftnAhV+LbAcoOy+j8S1yJN0=;
        b=iytJonZo41X69gJnQ/PDIM+cxMxMNSROwiqYr8xjZ8FmTUzGkkb+3QRBe4snAG9KmJ
         5RNUzh0b46gnVs60lzRJoWPxiCjlfTwQh5V3dY8zTmw6Mw5QWjIbyxAXWkMuu3AsIjM6
         AQ2pC+snEwP/9C+CWNplCYzJGb7xtjILLJiip0lRj5KYebIBZ3YEiVngp+rQXEzClq/b
         MikjFnVqBRE4ObeQnz0gnJ+MVb61k27l3h4bCKwld1Ai61ZagMM1VOb/Aswnq+Y6Dq9g
         W/rp6uzN/cBQwAMM6KN7fFObi7pu6SE/XI/vQLmWe/2oY7GkcMx9M/WqlreISbRC5p54
         IAuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZrMjTuUshxaUx8lG41ryftnAhV+LbAcoOy+j8S1yJN0=;
        b=L6cR5Z+rDAOSCJLLOmy3bhCcbRpZZkamHsCKJWjzKJ1kQs4XYW0IckfyFetgzNqub/
         IMnW/EKJ1aNZVKSic8ko93sf3FPUFXCzuJGdWME9aEQlI0sXn8TQ3e2eZMydPouC+ldM
         XMIzU5fRa7T25SzJFm8L4wE8eem+SMZuBPNc2sL+KJXNXXFjz2MguQhpisMEHk0u9Af7
         9rdzEhhAR7mTutyvFJ03BO3J5bSOX4dpr1dF+p4AI64qU2Gp/uwK1+hymT964EGzsbA4
         hfAZtbDGqbAbTMX33JFGEbKXxHUYh9qchWle7fF0dejDiFqpJZ3k5YIRVZk0Sq7O1DFJ
         dcTQ==
X-Gm-Message-State: AOAM531siK6QTM0jt4/mfRsQzkf62UhKlHKAiruYdtffh9rewvPI5gq6
        62kyEbsE5ApDiFV9J3gdyMv15w==
X-Google-Smtp-Source: ABdhPJwWh3qjIs//hgZ5k50XcrJo6eEt89F3tRvsfrdVlLHHnFB9QoPpsqdWH+O0osxVjfIFI6glnw==
X-Received: by 2002:a17:90a:3b0d:: with SMTP id d13mr1798394pjc.169.1603938796825;
        Wed, 28 Oct 2020 19:33:16 -0700 (PDT)
Received: from hermes.local (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id hg15sm687006pjb.39.2020.10.28.19.33.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 19:33:16 -0700 (PDT)
Date:   Wed, 28 Oct 2020 19:33:08 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Hangbin Liu <haliu@redhat.com>
Cc:     David Ahern <dsahern@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Jiri Benc <jbenc@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdl?= =?UTF-8?B?bnNlbg==?= 
        <toke@redhat.com>
Subject: Re: [PATCHv2 iproute2-next 0/5] iproute2: add libbpf support
Message-ID: <20201028193308.0ec219d4@hermes.local>
In-Reply-To: <20201029020637.GM2408@dhcp-12-153.nay.redhat.com>
References: <20201023033855.3894509-1-haliu@redhat.com>
        <20201028132529.3763875-1-haliu@redhat.com>
        <7babcccb-2b31-f9bf-16ea-6312e449b928@gmail.com>
        <20201029020637.GM2408@dhcp-12-153.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Oct 2020 10:06:37 +0800
Hangbin Liu <haliu@redhat.com> wrote:

> On Wed, Oct 28, 2020 at 05:02:34PM -0600, David Ahern wrote:
> > fails to compile on Ubuntu 20.10:
> > 
> > root@u2010-sfo3:~/iproute2.git# ./configure
> > TC schedulers
> >  ATM	yes
> >  IPT	using xtables
> >  IPSET  yes
> > 
> > iptables modules directory: /usr/lib/x86_64-linux-gnu/xtables
> > libc has setns: yes
> > SELinux support: yes
> > libbpf support: yes
> > ELF support: yes
> > libmnl support: yes
> > Berkeley DB: no
> > need for strlcpy: yes
> > libcap support: yes
> > 
> > root@u2010-sfo3:~/iproute2.git# make clean
> > 
> > root@u2010-sfo3:~/iproute2.git# make -j 4
> > ...
> > /usr/bin/ld: ../lib/libutil.a(bpf_libbpf.o): in function `load_bpf_object':
> > bpf_libbpf.c:(.text+0x3cb): undefined reference to
> > `bpf_program__section_name'
> > /usr/bin/ld: bpf_libbpf.c:(.text+0x438): undefined reference to
> > `bpf_program__section_name'
> > /usr/bin/ld: bpf_libbpf.c:(.text+0x716): undefined reference to
> > `bpf_program__section_name'
> > collect2: error: ld returned 1 exit status
> > make[1]: *** [Makefile:27: ip] Error 1
> > make[1]: *** Waiting for unfinished jobs....
> > make: *** [Makefile:64: all] Error 2  
> 
> You need to update libbpf to latest version.
> 
> But this also remind me that I need to add bpf_program__section_name() to
> configure checking. I will see if I missed other functions' checking.
> 
> Thanks
> Hangbin
> 

Then configure needs to check for this or every distro is going to get real mad...
