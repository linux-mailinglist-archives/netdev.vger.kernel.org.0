Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 452FB134CD6
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 21:10:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbgAHUKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 15:10:24 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:38763 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726390AbgAHUKX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 15:10:23 -0500
Received: by mail-pl1-f193.google.com with SMTP id f20so1560287plj.5;
        Wed, 08 Jan 2020 12:10:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=4nZJCKBglVZdy8suzHxnhiSlQv2zY3PPAi3S3tW88yc=;
        b=dG6oQsUt2C+pHunFW2j53ycWmb/eax7SXDaHSF4qXjYKosArLi24LSDvJ/3xi812di
         r1SjAfDWdPZwAFdfioTwL7hzS43iY69Eu8G5de6VCtSiw6qT9EXMpAFl/ghBpY0gkKq0
         MGbNDZZei0tJayYndD7BZqEjbvmEamRNky/FjNF/+6JE9eFS6NaDZ4akU/+GzRTm2r+O
         xSOD9DyxIhtG316e+grHceb6g7nnuTgemKe5+GWktPngTgjQaiZGXM2jSsV0BrwudPZj
         JWf87BYglSBLbtQOWLOgXPuKK4J81SCuThTqSVVjXOD+CJsoqY64rIgh/lVH1NeeNwRA
         2+jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=4nZJCKBglVZdy8suzHxnhiSlQv2zY3PPAi3S3tW88yc=;
        b=MZFS4RtS0LbJ9tAMmPH972M+oQIQqaSZ9Fu7RebeNoBpVzh9fT6fpbzf78kLGrYGhI
         mKIAld1nEmFfGbfWJq21g85NuAxc05FIschbKf1FlGM5KZAK1gdEBX0Xz1RBl9doPpNW
         U2gFn9WlI6x6jKkhH2izLBnwWcpcvzmnZFEObW6znj4/P/0PjsPyBRhd/U+VzIa7O5aH
         n3ahYEbqskJxJzVmMMZeOq6UfhwHhAHbCF+is4PiNf1LmO5oWk7KMr237Acu4jbgHpJh
         TJmEMSlKej6s6fX2qfm9ZIGe2uP8rBcVUM727E8kbmrosbRPmCpZF9xlP4Rckw7o/+/r
         Q5cw==
X-Gm-Message-State: APjAAAU3UdDsX2kXvcAyxTFLpdOuOQUQi3V3mi+ah328f5KxvZOq8Y7Y
        JuASb7cOykELqaX4JFMKV6s=
X-Google-Smtp-Source: APXvYqxNF1ayI0KTuIwHc7L68kSmRuWTcZ7svJ6YdakKkIJ7SQ0DAID3/jo3VmX/ts7yq492woBUAQ==
X-Received: by 2002:a17:902:bf0a:: with SMTP id bi10mr7447040plb.324.1578514222662;
        Wed, 08 Jan 2020 12:10:22 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:200::3:1e54])
        by smtp.gmail.com with ESMTPSA id c17sm4552496pfi.104.2020.01.08.12.10.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 Jan 2020 12:10:21 -0800 (PST)
Date:   Wed, 8 Jan 2020 12:10:20 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Song Liu <songliubraving@fb.com>
Cc:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 2/6] libbpf: Collect static vs global info about
 functions
Message-ID: <20200108201019.q4xtcdawor36rxyo@ast-mbp>
References: <20200108072538.3359838-1-ast@kernel.org>
 <20200108072538.3359838-3-ast@kernel.org>
 <871rsai6td.fsf@toke.dk>
 <76F721B3-A848-40BD-8B1D-A0AA3EB1AB39@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <76F721B3-A848-40BD-8B1D-A0AA3EB1AB39@fb.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 08, 2020 at 05:57:55PM +0000, Song Liu wrote:
> 
> 
> > On Jan 8, 2020, at 2:25 AM, Toke Høiland-Jørgensen <toke@redhat.com> wrote:
> > 
> > Alexei Starovoitov <ast@kernel.org> writes:
> > 
> >> Collect static vs global information about BPF functions from ELF file and
> >> improve BTF with this additional info if llvm is too old and doesn't emit it on
> >> its own.
> > 
> > Has the support for this actually landed in LLVM yet? I tried grep'ing
> > in the commit log and couldn't find anything...
> > 
> > [...]
> >> @@ -313,6 +321,7 @@ struct bpf_object {
> >> 	bool loaded;
> >> 	bool has_pseudo_calls;
> >> 	bool relaxed_core_relocs;
> >> +	bool llvm_emits_func_linkage;
> > 
> > Nit: s/llvm/compiler/? Presumably GCC will also support this at some
> > point?
> 
> Echoing this nit (and other references to llvm). Otherwise,

sure. will rename to compiler, but I think you folks are overly optimistic
about gcc. Even basic stuff doesn't work yet. I doubt we will see BTF
emitted by gcc this year.
