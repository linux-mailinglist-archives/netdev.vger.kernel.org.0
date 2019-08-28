Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F17D49F990
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 06:49:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726146AbfH1EtI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 00:49:08 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:34636 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725865AbfH1EtI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 00:49:08 -0400
Received: by mail-pg1-f195.google.com with SMTP id n9so729078pgc.1;
        Tue, 27 Aug 2019 21:49:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=Wqg7s2VUiWnCXp5xHQk0TWcvmJznRH+GklDYl3ugIDI=;
        b=nm7UJeT8VU8VVcVNeCtyOXAcJCJMMtDOitRvkRUTUjYR2y0wLqfAcohps+3AX2vzEu
         2Ss8vu8CtJlLsRaDk5hEdiHwQ2JdXSkblDRgTc0Syx0KjAJsynvr6QgqPvBTiDCmh7j5
         OnxERo8Vt+LBNFgQrzRKHokekpEYBL5lA0nr4F0rSp8r+Gm/k4ZWyukryWWNzixQgZdF
         I+lfmWz5NQOimMpCk2reWHe+SaLmE2zisVXUKlJr3uJ94edlxQ1Ipbh9HYlcYjT2Kr6L
         tOUQ/wk+yE1x8eHzdE4mzeYEwIeENLEyefpxFKjipDmnp4fFRkiJW9GUHcdrVQjU9P6L
         Z9GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=Wqg7s2VUiWnCXp5xHQk0TWcvmJznRH+GklDYl3ugIDI=;
        b=mZnw1/kbEyEpFrisDiX4Ew71usXxBoVwY4bjRze0UDbxjH/PuU+W+26DRNUwH87oi2
         +SBaq2Swl0f40n71kjm8EoM7QDmO8CiH4hPqhyl0OBAheowPMvSBCTUTcLhl2g4qOfe2
         dcf6LZDPYlT+9fcp3ouyIRI04zk0tqtytrRXbjXPudvPErb9sHK25+Axwo/PCmB8V1ds
         xOEoDbTn+lqlxiTJhZvqnim+oTZJ08dhuHfgSfM03iUIALvmAr0r5mNtEeTOCiGPN51H
         98Lb/YL+LT2euM7utSxCd8Xf6TgeyP2AqEY9p8LulXJCm8s8dCxJUvXoCxSZ4KQ7Wgvw
         g88w==
X-Gm-Message-State: APjAAAXL7r5Xg+r/XDOE7pMvF0/RwjAJk0uM5NJmbmETyLV0tyxxfco6
        vA2TRONaFI5/NbFFnt1J2eg=
X-Google-Smtp-Source: APXvYqwqTRMDD2PNZbsRspgzW5nn2Eh6VJ2YQhL/gbSvytSSyRLGjMMEPHEzLxNmt8FgDx+JlCv94g==
X-Received: by 2002:a63:dc4f:: with SMTP id f15mr1803659pgj.227.1566967747577;
        Tue, 27 Aug 2019 21:49:07 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:180::86a2])
        by smtp.gmail.com with ESMTPSA id r3sm1155539pfr.101.2019.08.27.21.49.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Aug 2019 21:49:06 -0700 (PDT)
Date:   Tue, 27 Aug 2019 21:49:05 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        James Morris <jmorris@namei.org>, Jann Horn <jannh@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, kernel-team <kernel-team@fb.com>,
        Linux API <linux-api@vger.kernel.org>
Subject: Re: [PATCH bpf-next] bpf, capabilities: introduce CAP_BPF
Message-ID: <20190828044903.nv3hvinkkolnnxtv@ast-mbp.dhcp.thefacebook.com>
References: <20190827205213.456318-1-ast@kernel.org>
 <CALCETrV8iJv9+Ai11_1_r6MapPhhwt9hjxi=6EoixytabTScqg@mail.gmail.com>
 <20190828003447.htgzsxs5oevn3eys@ast-mbp.dhcp.thefacebook.com>
 <CALCETrVbPPPr=BdPAx=tJKxD3oLXP4OVSgCYrB_E4vb6idELow@mail.gmail.com>
 <CALCETrVVQs1s27y8fB17JtQi-VzTq1YZPTPy3k=fKhQB1X-KKA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALCETrVVQs1s27y8fB17JtQi-VzTq1YZPTPy3k=fKhQB1X-KKA@mail.gmail.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 27, 2019 at 07:00:40PM -0700, Andy Lutomirski wrote:
> 
> Let me put this a bit differently. Part of the point is that
> CAP_TRACING should allow a user or program to trace without being able
> to corrupt the system. CAP_BPF as you’ve proposed it *can* likely
> crash the system.

Really? I'm still waiting for your example where bpf+kprobe crashes the system...

