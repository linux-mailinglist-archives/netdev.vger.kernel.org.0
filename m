Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 465CF8DB41
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 19:24:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729115AbfHNRXn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 13:23:43 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:40751 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729840AbfHNRHR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 13:07:17 -0400
Received: by mail-pg1-f194.google.com with SMTP id w10so53390156pgj.7
        for <netdev@vger.kernel.org>; Wed, 14 Aug 2019 10:07:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=F6sZvDt8GfsqSL6+yaOVxmYir21u5qs+0FrDZAMGm+U=;
        b=P/zi5BsaaIlJFS27qbrRPHG19C5OHY9/C4zVdy7Cb6Jpf7LuJ+Up0Fht6/3cwDMPIj
         28qwwRlC6h2CihsxxQsJljtiN1VMl20e9sW5lez1zg09H+GuRy+mnObc1RNGO3qpqLLU
         8gTWRmY1XIwHOBi/KGKHPsJcAwLliaTgu2TCMO1DdSwoIVnJNMv66lyDzxPx+vuS5huV
         +RyTFeTeR8ilnIYQ9ReQXgeO66HU7Mqh15dB2oB09ya5+j2f1jgC8FLJj+65ARVnSfDC
         ej2Y2WDibJam82j5FL4I5swZRiBMJ6tNWEI9R9Nykh1ujrAAygao0vZYulwZXVlaOl0y
         4ipw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=F6sZvDt8GfsqSL6+yaOVxmYir21u5qs+0FrDZAMGm+U=;
        b=aL08CSfAjpyipfybodeEIqSSN5jqruYlUxxeGVOrq9cIn7jt2BlYxaF0+/iua0lKlI
         CqSm7l/wZNvam44g7CaM4EBMKT1wMBW96OUcD1EmVSVsjJhp9fleevTWS3EGNAHBmApg
         9b4TVKJaXdy8/g7YF8+DfmaGT1rLPtZkJqJTiZQLtsyoj/hnrgcw8Mr5I3GXMg37XBSq
         b/WuugpjJUfn0NUNwsTDq419dAz6jSHhZRKLKhG4R3QRrYT1e24g1JTIZiNOwX6QJVpu
         Sk8Q2CII3li7WgPIrdUzgOPhgr+3aXYEJUE1qsZjEmJ8FOf/4D9Qo2fBU7sAmkLCiy/q
         mW0w==
X-Gm-Message-State: APjAAAVrjCyAbgrDl5iZdeWRSQGNCIewAvuQ8bbq2F16svCpzUCcD34H
        higVpaDWLMByPon7XdFzZyIryUX5xoI=
X-Google-Smtp-Source: APXvYqwg07VY8os024RQPur1zjETv2lW8luJPu4P30Aw7c7WkUQFbc1mwMUhePSJ8MX5oM07n3Q0Ng==
X-Received: by 2002:a17:90a:c24e:: with SMTP id d14mr699458pjx.129.1565802437056;
        Wed, 14 Aug 2019 10:07:17 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id q24sm428759pjp.14.2019.08.14.10.07.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2019 10:07:16 -0700 (PDT)
Date:   Wed, 14 Aug 2019 10:07:15 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Toshiaki Makita <toshiaki.makita1@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, William Tu <u9012063@gmail.com>
Subject: Re: [RFC PATCH bpf-next 00/14] xdp_flow: Flow offload to XDP
Message-ID: <20190814170715.GJ2820@mini-arch>
References: <20190813120558.6151-1-toshiaki.makita1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190813120558.6151-1-toshiaki.makita1@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/13, Toshiaki Makita wrote:
> * Implementation
> 
> xdp_flow makes use of UMH to load an eBPF program for XDP, similar to
> bpfilter. The difference is that xdp_flow does not generate the eBPF
> program dynamically but a prebuilt program is embedded in UMH. This is
> mainly because flow insertion is considerably frequent. If we generate
> and load an eBPF program on each insertion of a flow, the latency of the
> first packet of ping in above test will incease, which I want to avoid.
Can this be instead implemented with a new hook that will be called
for TC events? This hook can write to perf event buffer and control
plane will insert/remove/modify flow tables in the BPF maps (contol
plane will also install xdp program).

Why do we need UMH? What am I missing?
