Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2D4A48D7E7
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 13:27:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231761AbiAMM1l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 07:27:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55981 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229660AbiAMM1j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 07:27:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642076859;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ViQVHhS9TeU1GADrKolwOU4MxQRPJUjTMiV4znToNZg=;
        b=S61E3PMcSiNkDJkvPVCzceJ9qfyhEJ3C2wN/Xz/GedDMNaGaHDfquIyBgQXMkdL0rs8cFq
        2qb53tWtXcxZuBkuXe5+9VTWyycoRiAvJ6p07PdHpIXvFjLyr4iGGfbMkAMet3UBZCnVXl
        a2gOjpm0nItJ+3FeJZ19ngUvXNuCu+A=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-572-mtFGF8BrNp2D39UrA2HCvw-1; Thu, 13 Jan 2022 07:27:37 -0500
X-MC-Unique: mtFGF8BrNp2D39UrA2HCvw-1
Received: by mail-ed1-f70.google.com with SMTP id m8-20020a056402510800b003f9d22c4d48so5169303edd.21
        for <netdev@vger.kernel.org>; Thu, 13 Jan 2022 04:27:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ViQVHhS9TeU1GADrKolwOU4MxQRPJUjTMiV4znToNZg=;
        b=YVd/HI4TOS9K987behwLibBceqWAKU2JhuZvbXtZVe0ivMGQGdju9XBbnQHK4b7pMs
         MtGYgMevbiTtCJLwhqPSmxSK8qvuAoEOsAbc2zObfrYRIjRsZBQ6dndmDMuk9aWa6hcj
         yMo503NqqbFyIKY+jQKsOoOINQbcClEpYK2DOOKZTlPRI0rxWNJzxweUkeHnSOwDKufw
         fQWXTLKlinc9uufGFRnXx34jvBqnfogwCiCSiR7vhZA5025BroWEU6E5QjA8sCBw/HWn
         Khf1eFeoJwunjnzMMBat0N011sN6Y0CQ+yJrR5NzXYglGggAecbYQ1TsG1k7Y2TcujdW
         w69Q==
X-Gm-Message-State: AOAM5300UKU3FydplEl/f9143+SfPS2LOeJ0mjHpBj5JJsOFiWWnCZ9x
        NYax8wMrO3lVeMETiIVNKYmo13WYy8GQzbOmMjQkElghQN4hQuO/bRdDU6hpTfgLZt8VTf8UbGi
        9JFWu12UR2ifWDfhw
X-Received: by 2002:a17:906:da1b:: with SMTP id fi27mr3480789ejb.68.1642076856777;
        Thu, 13 Jan 2022 04:27:36 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzzq8hitOmNz+ym3vvwJSFT3GdzZkSBYpwA288q5gf8tRuG+8tKBO7yzTkkVxcdxI0Vag+s+w==
X-Received: by 2002:a17:906:da1b:: with SMTP id fi27mr3480767ejb.68.1642076856599;
        Thu, 13 Jan 2022 04:27:36 -0800 (PST)
Received: from krava (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id qa35sm836380ejc.67.2022.01.13.04.27.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jan 2022 04:27:36 -0800 (PST)
Date:   Thu, 13 Jan 2022 13:27:34 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [RFC PATCH v2 0/8] fprobe: Introduce fprobe function entry/exit
 probe
Message-ID: <YeAatqQTKsrxmUkS@krava>
References: <164199616622.1247129.783024987490980883.stgit@devnote2>
 <Yd77SYWgtrkhFIYz@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yd77SYWgtrkhFIYz@krava>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 12, 2022 at 05:01:15PM +0100, Jiri Olsa wrote:
> On Wed, Jan 12, 2022 at 11:02:46PM +0900, Masami Hiramatsu wrote:
> > Hi Jiri and Alexei,
> > 
> > Here is the 2nd version of fprobe. This version uses the
> > ftrace_set_filter_ips() for reducing the registering overhead.
> > Note that this also drops per-probe point private data, which
> > is not used anyway.
> > 
> > This introduces the fprobe, the function entry/exit probe with
> > multiple probe point support. This also introduces the rethook
> > for hooking function return as same as kretprobe does. This
> 
> nice, I was going through the multi-user-graph support 
> and was wondering that this might be a better way
> 
> > abstraction will help us to generalize the fgraph tracer,
> > because we can just switch it from rethook in fprobe, depending
> > on the kernel configuration.
> > 
> > The patch [1/8] and [7/8] are from your series[1]. Other libbpf
> > patches will not be affected by this change.
> 
> I'll try the bpf selftests on top of this

I'm getting crash and stall when running bpf selftests,
the fprobe sample module works fine, I'll check on that

jirka

