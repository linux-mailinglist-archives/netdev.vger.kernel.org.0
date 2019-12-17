Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 279351236DC
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 21:16:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727667AbfLQUQS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 15:16:18 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:54641 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727241AbfLQUQS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 15:16:18 -0500
Received: by mail-pj1-f66.google.com with SMTP id ep17so412314pjb.4;
        Tue, 17 Dec 2019 12:16:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=X/iEroEfK+rTLNriQL08rLYbVNMAs5CsvJ3Xgjb8kG8=;
        b=uSvKHPJ6MztXf90+CzCALN+W/RZYZdSjJK9Rs2hwghkHdhC9TTqxspv5ImlBroTDY8
         NrZsHMPsNO0hYDUQs50GrXmwAtpwolopUAVPM8h+ixrTOlvDEl8CqGoCw0cxRCa6Ezx6
         EVabkzzN3/YYc450u3pBm+59joKQZNtnOM9LDwy/lFP8Rkidx+XUrjX+3K9YqoEoku+e
         VSP4OLlaVI62a86wcd0HAwAKOijZTGn1dzyGl3Njq2+XwUTgil9AN84KNKD5e9Jpdf8P
         74cQD3OQvuntNL+JY2K7UY/fwVYUT28ms4n+pQLc052kARPtr4mATEBiF3daF7jLITVb
         C0EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=X/iEroEfK+rTLNriQL08rLYbVNMAs5CsvJ3Xgjb8kG8=;
        b=NhYvDPF2vxJKh6xOO9fiZH2dm2iLGAK4169kMMoExJVp/PwrvLsR+U2bLSJ4VrzV6A
         /ghdrNzR1B1LlHwKeurmGvUqSx2E++AC9BTJ1hTdK2rIlTxMvRF6SxNUCstzEl/VGWRT
         uwT1Wk9JjGf0mmNPXTQkcBvdPLu7FsXKM6KTrEsETFwIR6gXn/GlMy1icGb2N2kMGRi8
         +OFq1cndq1pB/88cNk0uHqCcsXCggRquFc5n9VBMjO5SwzSNwgDu1ohgCSdjiziVq49p
         973SORHvpGQ8NhNWZydodlPDsIOf8CtKmyttXfF4TvyopIBxSY6ifPPI/hyAhvnMQvl5
         Bqxw==
X-Gm-Message-State: APjAAAX1EgSqGWnsTks60RDNHlXhJ4UoL7SRidaqBEizyggMy9T+7U2y
        X7K7c8gEzeSunOa/fPTrq48=
X-Google-Smtp-Source: APXvYqxbDh6n89kxJ8ULMqUT1OxKqN5QVLl/46KlxlDdtmbXT1URYlIB7u3p1yiEDePyZ9O8CPZY4w==
X-Received: by 2002:a17:90a:b102:: with SMTP id z2mr8504371pjq.120.1576613776930;
        Tue, 17 Dec 2019 12:16:16 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::3:45c8])
        by smtp.gmail.com with ESMTPSA id 11sm15343904pfz.25.2019.12.17.12.16.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 Dec 2019 12:16:16 -0800 (PST)
Date:   Tue, 17 Dec 2019 12:16:14 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH v4 bpf-next 2/4] libbpf: support libbpf-provided extern
 variables
Message-ID: <20191217201613.iccqsqwuhitsyqyl@ast-mbp.dhcp.thefacebook.com>
References: <20191214014710.3449601-1-andriin@fb.com>
 <20191214014710.3449601-3-andriin@fb.com>
 <20191216111736.GA14887@linux.fritz.box>
 <CAEf4Bzbx+2Fot9NYzGJS-pUF5x5zvcfBnb7fcO_s9_gCQQVuLg@mail.gmail.com>
 <7bf339cf-c746-a780-3117-3348fb5997f1@iogearbox.net>
 <CAEf4BzYAWknN1HGHd0vREtQLHU-z3iTLJWBteRK6q7zkhySBBg@mail.gmail.com>
 <e569134e-68a9-9c69-e894-b21640334bb0@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e569134e-68a9-9c69-e894-b21640334bb0@iogearbox.net>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 17, 2019 at 08:50:31PM +0100, Daniel Borkmann wrote:
> > 
> > Yes, name collision is a possibility, which means users should
> > restrain from using LINUX_KERNEL_VERSION and CONFIG_XXX names for
> > their variables. But if that is ever actually the problem, the way to
> > resolve this collision/ambiguity would be to put externs in a separate
> > sections. It's possible to annotate extern variable with custom
> > section.
> > 
> > But I guess putting Kconfig-provided externs into ".extern.kconfig"
> > might be a good idea, actually. That will make it possible to have
> > writable externs in the future.
> 
> Yep, and as mentioned it will make it more clear that these get special
> loader treatment as opposed to regular externs we need to deal with in
> future. A '.extern.kconfig' section sounds good to me and the BPF helper
> header could provide a __kconfig annotation for that as well.

I think annotating all extern vars into special section name will be quite
cumbersome from bpf program writer pov.
imo capital case extern variables LINUX_KERNEL_VERSION and CONFIG_XXX are
distinct enough and make it clear they should come from something other than
normal C. Traditional C coding style uses all capital letters for macroses. So
all capital extern variables are unlikely to conflict with any normal extern
vars. Like vars in vmlinux and vars in other bpf elf files.
