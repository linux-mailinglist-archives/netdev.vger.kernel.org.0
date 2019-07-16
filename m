Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 078AA6B1CA
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 00:27:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388105AbfGPW05 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 18:26:57 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:45716 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728434AbfGPW04 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 18:26:56 -0400
Received: by mail-pl1-f194.google.com with SMTP id y8so10826809plr.12;
        Tue, 16 Jul 2019 15:26:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=hcjV9uH9o/Tpwbd+n48l2oD9yyltFtf5hW/1E21RjyU=;
        b=Ymf6xo4NrjW2SIVOsZOOqSvetHWupjVmlYrmElXDyHBKCX8ks4YgoT7Anv5Qpom3GA
         qnP5F7jnSEy+ilw9DoY72QKUnhDhBtQlhoBpsgip8PfmUHXc2eEKy/Yfm0ax8OXHa0Yb
         MIoHxh045on0dY/ZFz0VdDKW+zMNgxe+lYfouF865NoJ9R4vBJG1R3l14IEacMupMwyA
         t77qcoozBWRaZlVop7hqq3X3DTIbqnGOvpG9prSTXDu1cc2vYN1NxzhGv/F5OvJZfmBH
         utVEaG7rHNqfd45NSI7jCq6f9bYsfmufbe6w5OeAJccc6jN6ccfcLte3It6Yh9VJ4ytv
         5RFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=hcjV9uH9o/Tpwbd+n48l2oD9yyltFtf5hW/1E21RjyU=;
        b=TnjCOu2x/K4ATt6NfCFpCzWPu2n+VRiU1eeu/bTY0ff83Kgu9rm0nflvxFZbtLAXbL
         ceLBJgQmNyiOIh2vRFntrElA4Dxw5nxd0pWUPhQATJkWUqvlP836vvch813hAJ/ClNjh
         DIP9PBUhU2FF9mp8ceOFdcuzcEVUmkIsng8R8SJKkLD+plXTWLO4QudVTQdy/fNqjW1H
         g4TY7Jf1/JR4xL+HkN4bfbBciGnJZE6wS5c6xy3hlQDrmCC54I9MVFhnaKV4s373bh9P
         eW9/4K3jk0myTQ0lkDlxpAqIM3i3cYhMH5UqGvXupJ0DCfJgetVCwnyxs1sLIUwWFwdb
         dU/g==
X-Gm-Message-State: APjAAAXHlDpLWnQsaVtpx91CqGJxesY7koe2i4Zf6hgZWu0S78fiHcla
        IEhpZXxNPwjJZXYtsUmhg0I=
X-Google-Smtp-Source: APXvYqwC3kdgKK35Yn22pK0bh+EbrHOnIHECPI36YpDJ37htRFwCfM16yjI+qWCYeN28q10/j4LYFg==
X-Received: by 2002:a17:902:7894:: with SMTP id q20mr37225250pll.339.1563316015990;
        Tue, 16 Jul 2019 15:26:55 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::c7d4])
        by smtp.gmail.com with ESMTPSA id l15sm21540039pgf.5.2019.07.16.15.26.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 16 Jul 2019 15:26:54 -0700 (PDT)
Date:   Tue, 16 Jul 2019 15:26:52 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Joel Fernandes <joel@joelfernandes.org>
Cc:     linux-kernel@vger.kernel.org,
        Adrian Ratiu <adrian.ratiu@collabora.com>,
        Alexei Starovoitov <ast@kernel.org>, bpf@vger.kernel.org,
        Brendan Gregg <brendan.d.gregg@gmail.com>, connoro@google.com,
        Daniel Borkmann <daniel@iogearbox.net>,
        duyuchao <yuchao.du@unisoc.com>, Ingo Molnar <mingo@redhat.com>,
        jeffv@google.com, Karim Yaghmour <karim.yaghmour@opersys.com>,
        kernel-team@android.com, linux-kselftest@vger.kernel.org,
        Manali Shukla <manalishukla14@gmail.com>,
        Manjo Raja Rao <linux@manojrajarao.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Matt Mullins <mmullins@fb.com>,
        Michal Gregorczyk <michalgr@fb.com>,
        Michal Gregorczyk <michalgr@live.com>,
        Mohammad Husain <russoue@gmail.com>, namhyung@google.com,
        namhyung@kernel.org, netdev@vger.kernel.org,
        paul.chaignon@gmail.com, primiano@google.com,
        Qais Yousef <qais.yousef@arm.com>,
        Shuah Khan <shuah@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Srinivas Ramana <sramana@codeaurora.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Tamir Carmeli <carmeli.tamir@gmail.com>,
        Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH RFC 0/4] Add support to directly attach BPF program to
 ftrace
Message-ID: <20190716222650.tk2coihjtsxszarf@ast-mbp.dhcp.thefacebook.com>
References: <20190710141548.132193-1-joel@joelfernandes.org>
 <20190716205455.iimn3pqpvsc3k4ry@ast-mbp.dhcp.thefacebook.com>
 <20190716213050.GA161922@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190716213050.GA161922@google.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 16, 2019 at 05:30:50PM -0400, Joel Fernandes wrote:
> 
> I also thought about the pinning idea before, but we also want to add support
> for not just raw tracepoints, but also regular tracepoints (events if you
> will). I am hesitant to add a new BPF API just for creating regular
> tracepoints and then pinning those as well.

and they should be done through the pinning as well.

> I don't see why a new bpf node for a trace event is a bad idea, really.

See the patches for kprobe/uprobe FD-based api and the reasons behind it.
tldr: text is racy, doesn't scale, poor security, etc.

> tracefs is how we deal with trace events on Android. 

android has made mistakes in the past as well.

> This is a natural extension to that and fits with the security model
> well.

I think it's the opposite.
I'm absolutely against text based apis.

