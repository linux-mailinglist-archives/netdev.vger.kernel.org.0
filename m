Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E1A7FD140
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 00:01:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727065AbfKNXB3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 18:01:29 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:33878 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726319AbfKNXB3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 18:01:29 -0500
Received: by mail-pf1-f196.google.com with SMTP id n13so5320091pff.1;
        Thu, 14 Nov 2019 15:01:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Ksm0spfjtvUqOncab1uEFlt7KD1234SwGTwyhb5SzSY=;
        b=Vg0iPEiVMcFu/oTfHYtPX5XjoOfm7dkQZYsjKRKqKsn9UQnP6TFO6kPymaQhJOjus8
         Dp1x5+x6JMydUzUOwwl4Zx8zvLTIhstlWkGgRpKrT+TPuJb4lLtnbOjxt8jNMDVn3Zup
         RxW7hTJI5XKrdAzXYoRj09qOf9jixc+O0mlaoufmzqikUgg5bDCZYqBxJQQo7Arestkz
         K06CvR0y1lNwuUswHmC9hTr+tcG40AqZWNi4WSdZzHpvEZazR7vwI60y21RBkeSs/Vj0
         3ZY9OR4map9ngdCWFpU/RD1q6k1RZArXLnCCsu9XaoDuvntII+D/IAqP0nJ2NrLY4XxU
         NqgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Ksm0spfjtvUqOncab1uEFlt7KD1234SwGTwyhb5SzSY=;
        b=ZwITZOoJ+8omr3IOEvkG6FcMU5fLf9VMmoOjvxBP/YJ1BRRln8lLNjiasO3FkAcQZt
         /UTs8c0CYtPyD5bdGwWMBXiYWlUmYJlJKV+Tl3RR8GwPZCltgMn6kWs7S/6Wo57o6d3T
         Il6V8O+pPDlRiuQbn3fl2oj0sG3yLaZdefSCGlCBvaakqpxxt9q9XyUhXXfL/F1mGNpp
         dSi0hyHIbvZJKB0yr5qxthG5V5Hkl6adSkpj3Hb/kH/9sW2Ovnz8JT8QFk8jTVBjuBVP
         AWqUIIuwk5eYSKsOL0sm2axpXgMUF4N3YOI4994YrIMTq3E/YdD42jePvgKwAXn9aiZk
         Q7hA==
X-Gm-Message-State: APjAAAVILDyzD5gxtI5ZGlFtdfmawZ/xPH0JxWUKVa+b0K5s2eZJvcBn
        Gp8OREPPMzc0Jzf2fV7rNI4=
X-Google-Smtp-Source: APXvYqxcGI99YPH8DSKvy9z3NUCjNluyZyIGs1CpAKZxhaMNvb1N4HfbFBuvfsWH9Hqe7HyjbXJ58w==
X-Received: by 2002:a63:c04f:: with SMTP id z15mr5721858pgi.52.1573772484926;
        Thu, 14 Nov 2019 15:01:24 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::6ab4])
        by smtp.gmail.com with ESMTPSA id h195sm8888854pfe.88.2019.11.14.15.01.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Nov 2019 15:01:24 -0800 (PST)
Date:   Thu, 14 Nov 2019 15:01:19 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Song Liu <songliubraving@fb.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "x86@kernel.org" <x86@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v4 bpf-next 15/20] bpf: Annotate context types
Message-ID: <20191114230117.wtusupri5p5xw63b@ast-mbp.dhcp.thefacebook.com>
References: <20191114185720.1641606-1-ast@kernel.org>
 <20191114185720.1641606-16-ast@kernel.org>
 <7092A2D7-BE2A-431F-B6A4-55BA963C36BF@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7092A2D7-BE2A-431F-B6A4-55BA963C36BF@fb.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 14, 2019 at 10:55:37PM +0000, Song Liu wrote:
> 
> 
> > On Nov 14, 2019, at 10:57 AM, Alexei Starovoitov <ast@kernel.org> wrote:
> > 
> > Annotate BPF program context types with program-side type and kernel-side type.
> > This type information is used by the verifier. btf_get_prog_ctx_type() is
> > used in the later patches to verify that BTF type of ctx in BPF program matches to
> > kernel expected ctx type. For example, the XDP program type is:
> > BPF_PROG_TYPE(BPF_PROG_TYPE_XDP, xdp, struct xdp_md, struct xdp_buff)
> > That means that XDP program should be written as:
> > int xdp_prog(struct xdp_md *ctx) { ... }
> > 
> > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> > 
> 
> [...]
> 
> > +	/* only compare that prog's ctx type name is the same as
> > +	 * kernel expects. No need to compare field by field.
> > +	 * It's ok for bpf prog to do:
> > +	 * struct __sk_buff {};
> > +	 * int socket_filter_bpf_prog(struct __sk_buff *skb)
> > +	 * { // no fields of skb are ever used }
> > +	 */
> > +	if (strcmp(ctx_tname, tname))
> > +		return NULL;
> 
> Do we need to check size of the two struct? I guess we should not 
> allow something like
> 
> 	struct __sk_buff {
> 		char data[REALLY_BIG_NUM]; 
> 	};
> 	int socket_filter_bpf_prog(struct __sk_buff *skb)
> 	{ /* access end of skb */ }

I don't think we should check sizes either. Same comment above applies. The
prog's __sk_buff can be different from kernel's view into __sk_buff. Either
bigger or larger doesn't matter. If it's accessed by the prog the verifier will
check that all accessed fields are correct. Extra unused fields (like char
data[REALLY_BIG_NUM];) don't affect safety.
When bpf-tracing is attaching to bpf-skb it doesn't use bpf-skb's
__sk_buff with giant fake data[BIG_NUM];. It's using kernel's __sk_buff.
That is what btf_translate_to_vmlinux() in patch 17 is doing.

