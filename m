Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F145911AC
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 17:37:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726010AbfHQPg6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Aug 2019 11:36:58 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:37064 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725784AbfHQPg6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Aug 2019 11:36:58 -0400
Received: by mail-pg1-f195.google.com with SMTP id d1so3856434pgp.4;
        Sat, 17 Aug 2019 08:36:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=xbJ9K0DCfO2Bo9oHca9mENF0teDYreZja6IAQ39ZFlM=;
        b=vPoUCB1A6tv68EE3zNLPItEaMWiypqIzlHiZKGuzB0S8AmIfY+9v8okqli+Bsg7TGS
         fneTDRM2JSby8nj88WmXrE3NxNzNO1df3OLTASa3WM9CqLEHtEHh+iKibzYKNuw0i1fG
         ZO9bp15bKcL08GWcXNCsGP+HuDtioimc/AcfS5YtOIZIHsiU0OQfNPkYY9sTxzAcxAcW
         dLuGtPd6fq4RZm1s3HqKXotmb+s1qfmvrFMGtOGszbP4/u9VmEPJjT5ke7Kk8X9/M67v
         6x+4o4wtZbIhOYkSJFvTLtEIL8hquiVuM7+9GgBiIl3t5Z+ZjGlR2AsMjxyOU4MJcIrF
         rHiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=xbJ9K0DCfO2Bo9oHca9mENF0teDYreZja6IAQ39ZFlM=;
        b=C8eGJLZiBX5S4t24Q/RQleqD6nsS0Tw/bptdYM4eFIu2KBLa6Xe4OjOOPZs4t84M6D
         6T3CAoR9NCDs0hoSDwvMPpBsMCbBotIbuU2VtqIOl46XXyOmYT6w7/wR7WO81jm9vaOJ
         E0sKa/+9m+FljGRYZVL0/WuTEwmD3MO/XCTOOpPHLHCVGIX/G/ecl5RNZeJmCUQfldwf
         J4KTHaQCAjdGa2Zsmn1011PORPJZxqFe6YLySWoweqNmdJITVzhAdnehy5tFW6tsMaO2
         BV+63DPHfgTGqeRYQp1BYuaj7F2aOm0uNKOxmDzIoTYvFWcxWml+qPKOhvvjFWct5QWn
         xFtw==
X-Gm-Message-State: APjAAAUXyjN2PwQGnvie+Z/QJkf5iNs+4DEDrXYz8Jbrc7lyJk3YVmoX
        G9LxliYM0tzHtEel+BTNJZs=
X-Google-Smtp-Source: APXvYqyMFfSC6GP2b+6BEb/FE6aTWV75DM1ga1USkzlF8t8RPmRDfN/cmRy2eE4aNIH3MYo8jjjIHA==
X-Received: by 2002:aa7:8dd2:: with SMTP id j18mr15990831pfr.88.1566056217255;
        Sat, 17 Aug 2019 08:36:57 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:180::9c96])
        by smtp.gmail.com with ESMTPSA id 185sm14829384pff.54.2019.08.17.08.36.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 17 Aug 2019 08:36:56 -0700 (PDT)
Date:   Sat, 17 Aug 2019 08:36:54 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Andy Lutomirski <luto@amacapital.net>,
        Kees Cook <keescook@chromium.org>,
        Andy Lutomirski <luto@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Jann Horn <jannh@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux API <linux-api@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: unprivileged BPF access via /dev/bpf
Message-ID: <20190817153652.zfcsklt474j72dzm@ast-mbp.dhcp.thefacebook.com>
References: <20190806011134.p5baub5l3t5fkmou@ast-mbp>
 <CALCETrXEHL3+NAY6P6vUj7Pvd9ZpZsYC6VCLXOaNxb90a_POGw@mail.gmail.com>
 <20190813215823.3sfbakzzjjykyng2@ast-mbp>
 <201908151203.FE87970@keescook>
 <20190815234622.t65oxm5mtfzy6fhg@ast-mbp.dhcp.thefacebook.com>
 <B0364660-AD6A-4E5C-B04F-3B6DA78B4BBE@amacapital.net>
 <20190816214542.inpt6p655whc2ejw@ast-mbp.dhcp.thefacebook.com>
 <20190816222252.a7zizw7azkxnv3ot@wittgenstein>
 <20190817150843.4vsmzpwpcvzndjld@ast-mbp>
 <61B88085-9FBB-41E6-9783-324E445E428D@ubuntu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61B88085-9FBB-41E6-9783-324E445E428D@ubuntu.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 17, 2019 at 05:16:53PM +0200, Christian Brauner wrote:
> On August 17, 2019 5:08:45 PM GMT+02:00, Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> >On Sat, Aug 17, 2019 at 12:22:53AM +0200, Christian Brauner wrote:
> >> 
> >> (The one usecase I'd care about is to extend seccomp to do
> >pointer-based
> >> syscall filtering. Whether or not that'd require (unprivileged) ebpf
> >is
> >> up for discussion at KSummit.)
> >
> >Kees have been always against using ebpf in seccomp. I believe he still
> >holds this opinion. Until he changes his mind let's stop bringing
> >seccomp
> >as a use case for unpriv bpf.
> 
> That's why I said "whether or not".
> For the record, I do prefer a non-unpriv-ebpf way.
> It's still something that will most surely come up in the discussion though.

It's very un-kernely way to defer to in-person meetings.
If there is anything to discuss please discuss it on the public mailing list.

