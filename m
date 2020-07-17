Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 124562241CD
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 19:29:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbgGQR3B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 13:29:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726232AbgGQR3A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 13:29:00 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6229DC0619D2;
        Fri, 17 Jul 2020 10:29:00 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id u25so6508952lfm.1;
        Fri, 17 Jul 2020 10:29:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OssE5JOZoxVh4WZc8eAWRj3F23YE7gliVHRaokik27A=;
        b=UWjEk4wyWLWlcqghqtpOkkFoqCZOZVvDFfmVMjJz9HiNpvyvro+M75Y5SN8cqJYTo7
         7fMlOk1IkeC9wjhkhCDYRT4M7E2raUo2keyxSShKC26WoT3kX8/KtZDA/xkZEICnxC/C
         gFo4pBLQCxI83zTKUo1t90RZC6dB1hEi5pPvm8Z2keS6FiSNyZXJmRXym7uQ/3g358qH
         vj7B+u8UPnm9wfl4+ThnNgwlwbvFnS/FnMVAkABQD4yqRMD/Rzsm/Vq7Hi/ghee3SAVj
         cuU3KUQ2bRMNKAPKwEZx256ZI6luPJXFF3AzJ1jEnCRhGWT7IzVsPHXXnYcgDlCZAikM
         3lWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OssE5JOZoxVh4WZc8eAWRj3F23YE7gliVHRaokik27A=;
        b=bZT1CmoCb3+EeQNgxdFtQobUExG1N+LmoKgmQmunRUEf3V0iLyVYImNYGeyML2WFHQ
         YZW8Bimrr+RT6Y8ohoBg2x9b6IXNC6wgNdgKpNlvBd8DYc6acjUqeHlrrCrBdwH1TjQ7
         vTYHfQojYvKHtg6JxTjNFI3IbN9ZM+ABHnvYibN9dhhl/Anvgx75izjddkqb0Gsy/zaS
         hvKdpGPzhLZYudUoEypLTdO+f/NZoSXadM1ackbaY8tCnlpm1acvxj9694HDxXQqSBp7
         st9dYD7NvlPbBdzRCbgXCop5FFwmK35VpYwvlSk4iJnVTlM6L3nnsSUPXkOpotpAFR89
         0K/g==
X-Gm-Message-State: AOAM533fVhEisLPtdZip2wJX94ZeSqxeuQ1U5pbaHS4wSi4r1eqOLPLl
        MtTE98tF+WAxk4F6r6BCupLe7o/HRoYduG0G1kg=
X-Google-Smtp-Source: ABdhPJyH6Glorpg8aP3ugpC5YuYiHWmZYhxw3D/PmXsx1ga5VfUrXD8FiMxCiXQhuIWtiBH0Ln/SL9wDLVUEnbL5Wuo=
X-Received: by 2002:ac2:5970:: with SMTP id h16mr2269254lfp.196.1595006938836;
 Fri, 17 Jul 2020 10:28:58 -0700 (PDT)
MIME-Version: 1.0
References: <20200717055245.GA9577@lst.de> <CAADnVQ+rD+7fAsLZT4pG7AN4iO7-dQ+3adw0tBhrf8TGbtLjtA@mail.gmail.com>
 <20200717162526.GA17072@lst.de>
In-Reply-To: <20200717162526.GA17072@lst.de>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 17 Jul 2020 10:28:47 -0700
Message-ID: <CAADnVQJoMC=vfS4yb7gYZF4fmwrHd+gdOf9zmPm2XyK1jfosHg@mail.gmail.com>
Subject: Re: how is the bpfilter sockopt processing supposed to work
To:     Christoph Hellwig <hch@lst.de>
Cc:     Stanislav Fomichev <sdf@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 17, 2020 at 9:25 AM Christoph Hellwig <hch@lst.de> wrote:
>
> On Fri, Jul 17, 2020 at 09:13:07AM -0700, Alexei Starovoitov wrote:
> > On Thu, Jul 16, 2020 at 10:52 PM Christoph Hellwig <hch@lst.de> wrote:
> > >
> > > Hi Alexei,
> > >
> > > I've just been auditing the sockopt code, and bpfilter looks really
> > > odd.  Both getsockopts and setsockopt eventually end up
> > > in__bpfilter_process_sockopt, which then passes record to the
> > > userspace helper containing the address of the optval buffer.
> > > Which depending on bpf-cgroup might be in user or kernel space.
> > > But even if it is in userspace it would be in a different process
> > > than the bpfiler helper.  What makes all this work?
> >
> > Hmm. Good point. bpfilter assumes user addresses. It will break
> > if bpf cgroup sockopt messes with it.
> > We had a different issue with bpf-cgroup-sockopt and iptables in the past.
> > Probably the easiest way forward is to special case this particular one.
> > With your new series is there a way to tell in bpfilter_ip_get_sockopt()
> > whether addr is kernel or user? And if it's the kernel just return with error.
>
> Yes, I can send a fix.  But how do even the user space addressed work?
> If some random process calls getsockopt or setsockopt, how does the
> bpfilter user mode helper attach to its address space?

The actual bpfilter processing is in two patches that we didn't land:
https://lore.kernel.org/patchwork/patch/902785/
https://lore.kernel.org/patchwork/patch/902783/
UMD is using process_vm_readv().
The target process is waiting for the sockopt syscall to return,
so from the toctou perspective it's the same as the kernel doing copy_from_user.
