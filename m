Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16E974A783
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 18:49:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729865AbfFRQtQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 12:49:16 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:34703 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729472AbfFRQtQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 12:49:16 -0400
Received: by mail-pf1-f193.google.com with SMTP id c85so8003961pfc.1
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 09:49:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=FjEbeGGFvhlYyKDfMjPVz1XlGl7OXiFw9YUnNCw4qc0=;
        b=OFJw0UyYYxj5Cekzz5ryrV0ImBkeplk323SSI5QNFL+V38/RgQYX1RV7bgwvI0MBc1
         +Ay2DI3Svh+UeEmvMZg5Mtuv+tse2tO9uXpfpPMg70AR+YPgeeNyKjcxWaTEOm6eUJ/c
         zIbUtMAJDUKOC8qzk70LCa5HKgIlh8MUNSqU9rXFB3NQZUiuvFKYljnbioabrnoJd7ax
         0mim1Pp+JgmQc4IcHE0AcrAeQw1TU8ymaRXWUZY7MnimIkhSto45k3w5kttQlLit9J3R
         Q0HNPq4NNJENmRe1IXRCVnXLDN/lDJ59dbNL8k5g0Oj+nEvx2kobMsV7gW458yN2sgpG
         +puQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=FjEbeGGFvhlYyKDfMjPVz1XlGl7OXiFw9YUnNCw4qc0=;
        b=nOd2xiUg49AuLUV38fofg6Nzd/NldhrKjbzFyvXgD6Fs1Ror7x+ePD2x5vFayOh/q5
         BYFhpPPVTXLOPujq73xH1TcRfQ+LSOP9Db6I2gjELbZqLMIGMe0UpXkaNbAZod0abx7l
         AVXLzGLGrI1J4YGtgFlXxKIK0uCGYZRseF14B9irEg1zxHQIBRFaU+e6E+eqf8lM1TgW
         5+0z5Cs8FURPR5w6lLSuTYTTHmhMM5FCEcgPeHxxUt1Vb8CWlJpPyOMNpVbE5Zvflm16
         fQSvE8hy1tLDYegtZ8WymV0TCQNdiXjcI1x0tTcjC621zKVFzs03qfJ6T4iw1/qOVu5c
         Ef7Q==
X-Gm-Message-State: APjAAAUq63PWjtI2R8TogMlND4a2v+gf9kp8y/dpmU7Ixo058fOXoZfW
        bxz5e8gz3V4PjizeDxqUQHced0+oSss=
X-Google-Smtp-Source: APXvYqzMB3hy6cVXiBZ1pNDk4e2oHDnNjb1sZs6GxdQwBoyLqlUQYVGEQHS6g5IS4ZF8QFYzMDdFMw==
X-Received: by 2002:a17:90a:ad89:: with SMTP id s9mr6231883pjq.41.1560876555743;
        Tue, 18 Jun 2019 09:49:15 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id a3sm14110396pff.122.2019.06.18.09.49.14
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 18 Jun 2019 09:49:14 -0700 (PDT)
Date:   Tue, 18 Jun 2019 09:49:13 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Stanislav Fomichev <sdf@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net, ast@kernel.org,
        daniel@iogearbox.net, Martin Lau <kafai@fb.com>
Subject: Re: [PATCH bpf-next v6 1/9] bpf: implement getsockopt and setsockopt
 hooks
Message-ID: <20190618164913.GI9636@mini-arch>
References: <20190617180109.34950-1-sdf@google.com>
 <20190617180109.34950-2-sdf@google.com>
 <20190618163117.yuw44b24lo6prsrz@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190618163117.yuw44b24lo6prsrz@ast-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/18, Alexei Starovoitov wrote:
> On Mon, Jun 17, 2019 at 11:01:01AM -0700, Stanislav Fomichev wrote:
> > Implement new BPF_PROG_TYPE_CGROUP_SOCKOPT program type and
> > BPF_CGROUP_{G,S}ETSOCKOPT cgroup hooks.
> > 
> > BPF_CGROUP_SETSOCKOPT get a read-only view of the setsockopt arguments.
> > BPF_CGROUP_GETSOCKOPT can modify the supplied buffer.
> > Both of them reuse existing PTR_TO_PACKET{,_END} infrastructure.
> > 
> > The buffer memory is pre-allocated (because I don't think there is
> > a precedent for working with __user memory from bpf). This might be
> > slow to do for each {s,g}etsockopt call, that's why I've added
> > __cgroup_bpf_prog_array_is_empty that exits early if there is nothing
> > attached to a cgroup. Note, however, that there is a race between
> > __cgroup_bpf_prog_array_is_empty and BPF_PROG_RUN_ARRAY where cgroup
> > program layout might have changed; this should not be a problem
> > because in general there is a race between multiple calls to
> > {s,g}etsocktop and user adding/removing bpf progs from a cgroup.
> > 
> > The return code of the BPF program is handled as follows:
> > * 0: EPERM
> > * 1: success, execute kernel {s,g}etsockopt path after BPF prog exits
> > * 2: success, do _not_ execute kernel {s,g}etsockopt path after BPF
> >      prog exits
> > 
> > Note that if 0 or 2 is returned from BPF program, no further BPF program
> > in the cgroup hierarchy is executed. This is in contrast with any existing
> > per-cgroup BPF attach_type.
> 
> This is drastically different from all other cgroup-bpf progs.
> I think all programs should be executed regardless of return code.
> It seems to me that 1 vs 2 difference can be expressed via bpf program logic
> instead of return code.
> 
> How about we do what all other cgroup-bpf progs do:
> "any no is no. all yes is yes"
> Meaning any ret=0 - EPERM back to user.
> If all are ret=1 - kernel handles get/set.
> 
> I think the desire to differentiate 1 vs 2 came from ordering issue
> on getsockopt.
> How about for setsockopt all progs run first and then kernel.
> For getsockopt kernel runs first and then all progs.
> Then progs will have an ability to overwrite anything the kernel returns.
Good idea, makes sense. For getsockopt we'd also need to pass the return
value of the kernel getsockopt to let bpf programs override it, but seems
doable. Let me play with it a bit; I'll send another version if nothing
major comes up.

Thanks for another round of review!
