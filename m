Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F411CA3C3
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 18:22:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389628AbfJCQSq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 12:18:46 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:42231 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388699AbfJCQSo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 12:18:44 -0400
Received: by mail-pl1-f195.google.com with SMTP id e5so1741434pls.9;
        Thu, 03 Oct 2019 09:18:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=HFMB6TYMRf3ctWgt0w7/+NhfpNo/ajEEmZE1ubfs/fM=;
        b=cX++/QzuCtPvcWGvW9rR2w0pNHGVDqh7r8YgIJrbAWo/GFiDarECecuvR3y7kfIYM0
         yWAJXqTQnW9b/R1uuVbzXXi7CcDQe6R2bDet/i64BDzJg3u/MVONMGGa+mD8wn8u74yD
         q4hRK0oRWZAEiuV36rVGaYthj/ms9rsHxu0//Aqs9oCIgo9NGVFbzms09Fkg3BADDa+C
         so2ThphCBFzj3dSGfoWGbmJsh10Py0mPZyC4YkmBaqG2GTcLeBW18R/Zqo6l9YxRgvfI
         tnFYai5PGkBJW9XIB+1yEt/Y9U6SfH2KUv53svlm3BL338gi49okkRDy7/dVbgbhXWye
         D9YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=HFMB6TYMRf3ctWgt0w7/+NhfpNo/ajEEmZE1ubfs/fM=;
        b=MzfdVTposjGOPEs9y4fqmkibJA3uCMk/E/AodBjAwZqowucZJIcTQ3K9lYOS/a/Lkx
         EH9CfWtkAixb1urk/vaxL0An3F749kO4zU/43JkhOPqoTOprtkjcNS5po8GvFMtJ3BHR
         qR3z1KWQoZ308vldErb52KGkHc3Y5eHk5WqnvLyGqkDEtNO0QZkY5DG4OyM2h6LUUhmh
         f92Vdc4QRP5vk9G13Gy9G4YiKOpo3L1mW1ugtwIzGWKbqZXF8C34EUXZ+9Mw4rsc4sbG
         /xa5+pZO+0q1z9PD59wtUmzyxnvtNEp6qPsZU0nRA2iJun9xY28YVAb9fiuqfEox61ur
         I1Fw==
X-Gm-Message-State: APjAAAWWIEMS2Z0/DfLzQaJvrH3gt3OqRA3OBzgA/KjMvfdoSVnB6+lb
        sBw61y0x83uhefGOZ8L4Q2E=
X-Google-Smtp-Source: APXvYqxu9doqbZMkk6qFu7+Jxqg9K/cmOBSwXKQk7QZnPbCTgsdlNVWFYwkNQz4upJiHaMGxtgH+rg==
X-Received: by 2002:a17:902:6b07:: with SMTP id o7mr10604286plk.44.1570119523163;
        Thu, 03 Oct 2019 09:18:43 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::2:535c])
        by smtp.gmail.com with ESMTPSA id d76sm3604486pfd.185.2019.10.03.09.18.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 03 Oct 2019 09:18:42 -0700 (PDT)
Date:   Thu, 3 Oct 2019 09:18:40 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Alexei Starovoitov <ast@fb.com>, Kees Cook <keescook@chromium.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        James Morris <jmorris@namei.org>, Jann Horn <jannh@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>,
        Linux API <linux-api@vger.kernel.org>
Subject: trace_printk issue. Was: [PATCH bpf-next] bpf, capabilities:
 introduce CAP_BPF
Message-ID: <20191003161838.7lz746aa2lzl7qi4@ast-mbp.dhcp.thefacebook.com>
References: <DA52992F-4862-4945-8482-FE619A04C753@amacapital.net>
 <20190829040721.ef6rumbaunkavyrr@ast-mbp.dhcp.thefacebook.com>
 <20190928193727.1769e90c@oasis.local.home>
 <201909301129.5A1129C@keescook>
 <20191001012226.vwpe56won5r7gbrz@ast-mbp.dhcp.thefacebook.com>
 <20191001181052.43c9fabb@gandalf.local.home>
 <6e8b910c-a739-857d-4867-395bd369bc6a@fb.com>
 <20191001184731.0ec98c7a@gandalf.local.home>
 <a98725c6-a7db-1d9f-7033-5ecd96438c8d@fb.com>
 <20191002190027.4e204ea8@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191002190027.4e204ea8@gandalf.local.home>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 02, 2019 at 07:00:27PM -0400, Steven Rostedt wrote:
> > >>>>
> > >>>> Both 'trace' and 'trace_pipe' have quirky side effects.
> > >>>> Like opening 'trace' file will make all parallel trace_printk() to be ignored.
> > >>>> While reading 'trace_pipe' file will clear it.
> > >>>> The point that traditional 'read' and 'write' ACLs don't map as-is
> > >>>> to tracefs, so I would be careful categorizing things into
> > >>>> confidentiality vs integrity only based on access type.  
> > >>>
> > >>> What exactly is the bpf_trace_printk() used for? I may have other ideas
> > >>> that can help.  
> > >>
> > >> It's debugging of bpf programs. Same is what printk() is used for
> > >> by kernel developers.
> > >>  
> > > 
> > > How is it extracted? Just read from the trace or trace_pipe file?  
> > 
> > yep. Just like kernel devs look at dmesg when they sprinkle printk.
> > btw, if you can fix 'trace' file issue that stops all trace_printk
> > while 'trace' file is open that would be great.
> > Some users have been bitten by this behavior. We even documented it.
> 
> The behavior is documented as well in the ftrace documentation. That's
> why we suggest the trace_pipe redirected into a file so that you don't
> lose data (unless the writer goes too fast). If you prefer a producer
> consumer where you lose newer events (like perf does), you can turn off
> overwrite mode, and it will drop events when the buffer is full (see
> options/overwrite).

I think dropping last events is just as bad. Is there a mode to overwrite old
and keep the last N (like perf does) ?
That aside having 'trace' file open should NOT drop trace_printks.
My point that bpf_trace_printk is just as important to bpf developers as
printk to kernel developers.
Imagine kernel developer losing their printk-s only because they typed
"dmesg" in another terminal?
It's completely unexpected and breaks developer trust in debugging mechanism.
Peter Wu brought this issue to my attention in
commit 55c33dfbeb83 ("bpf: clarify when bpf_trace_printk discards lines").
And later sent similar doc fix to ftrace.rst.
To be honest if I knew of this trace_printk quirk I would not have picked it
as a debugging mechanism for bpf.
I urge you to fix it.

