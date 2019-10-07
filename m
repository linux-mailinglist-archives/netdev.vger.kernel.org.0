Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D080BCEE1E
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 23:01:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728846AbfJGVBW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 17:01:22 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:46427 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728330AbfJGVBW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 17:01:22 -0400
Received: by mail-pg1-f195.google.com with SMTP id b8so2595642pgm.13;
        Mon, 07 Oct 2019 14:01:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=EXSaX+u+4G65h/ERUamc/6bYuc2C0NOXNy4/BXyLVaE=;
        b=dHCq8pkj6UT4Jd8rB2BeMt514X3eQwyLMPeHI5Dyf+oLczdSeBAsBt200btr8riRlV
         8dXh5kpWAqy96CQmGunpu9o1ADGbLZrhwWAyml5rsQxZehBxb3Fva5H+JA1YaqQo1WMN
         RlNt4j2OtWWSTeqXuyC8h48zC58eYDEbuV5+hCh3peBxZT9LTpJdjJmONF6ozTjFl0bE
         kwSYRZCkkACT7Q/QAXV/7TWyVQvnRS5sh5F3qRimUt8+4hNYslFL0eKrP90msJGFPt+V
         ANwsJh8LJ6HQBiLlPTcyOzgXY8Fz2kh4HjLqYFdVrUqmmDuYFmPhQSSXOnYvU/a+sSWd
         W+9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=EXSaX+u+4G65h/ERUamc/6bYuc2C0NOXNy4/BXyLVaE=;
        b=qJcU/H4CagBgFkWKjhc1CnlRVT6A6jbs3vdz3mJZxHocCoHvAAcR/cfr7LtXWSB16M
         TzTfzxoSNkpT5LTd2yV1/fj+jTvsqDCefMq3j14H9cWXVql8P0fN7BcomQq+Zm6CH66T
         anevSue5lVCjPk7SfMCWiAntyViwi2IqIcsvr5ryDL67b7v/T5qhmV/AEOxLGwT7sOOR
         4+Cby3l0PmSX/zL8qsrpoqchtioNKC/NwtDCqpfpcCiEGSlZdRNwzM3lAqO6TMztQgU4
         rFDvxKYYFqGsZ+3tVYTKQI0cONW3afLl0m+10ODx5IBKNa8UvjQsw0asLpH/lekP+tR6
         Icxg==
X-Gm-Message-State: APjAAAVJd8XUCiIkBuiJ6I2l4WfCo8BtaF0pQwYZ3Bup4iUXd+otsSCr
        fVb1nuhXontuM8mdrwZVy7U=
X-Google-Smtp-Source: APXvYqy1x3pPQMjKcSIUGfWOk1AdmkVjZbUgEsD4d1Lzx1g5ypt/LMO8E6BB3fsdfn/vwKYNwYq4AQ==
X-Received: by 2002:a62:a509:: with SMTP id v9mr33877557pfm.180.1570482081580;
        Mon, 07 Oct 2019 14:01:21 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::2:2257])
        by smtp.gmail.com with ESMTPSA id q3sm15415482pgj.54.2019.10.07.14.01.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 07 Oct 2019 14:01:20 -0700 (PDT)
Date:   Mon, 7 Oct 2019 14:01:19 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Edward Cree <ecree@solarflare.com>
Cc:     Lorenz Bauer <lmb@cloudflare.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Song Liu <songliubraving@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, Martin Lau <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>,
        Marek Majkowski <marek@cloudflare.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>
Subject: Re: [PATCH bpf-next 0/9] xdp: Support multiple programs on a single
 interface through chain calls
Message-ID: <20191007210117.6b2mvhkcysmsgfnv@ast-mbp.dhcp.thefacebook.com>
References: <87r23vq79z.fsf@toke.dk>
 <20191003105335.3cc65226@carbon>
 <CAADnVQKTbaxJhkukxXM7Ue7=kA9eWsGMpnkXc=Z8O3iWGSaO0A@mail.gmail.com>
 <87pnjdq4pi.fsf@toke.dk>
 <1c9b72f9-1b61-d89a-49a4-e0b8eead853d@solarflare.com>
 <5d964d8ccfd90_55732aec43fe05c47b@john-XPS-13-9370.notmuch>
 <87tv8pnd9c.fsf@toke.dk>
 <68466316-c796-7808-6932-01d9d8c0a40b@solarflare.com>
 <CACAyw99oUfst5LDaPZmbKNfQtM2wF8fP0rz7qMk+Qn7SMaF_vw@mail.gmail.com>
 <1871cacb-4a43-f906-9a9b-ba6a2ca866dd@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1871cacb-4a43-f906-9a9b-ba6a2ca866dd@solarflare.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 07, 2019 at 05:43:44PM +0100, Edward Cree wrote:
> 
> (Although I also think full-blown dynamically-linked calls ought not to be
>  impossible, *if* we restrict them to taking a ctx and returning a u64, in
>  which case the callee can be verified as though it were a normal program,
>  and the caller's verifier just treats the program as returning an unknown
>  scalar.  The devil is in the details, though, and it seems no-one's quite
>  wanted it enough to do the work required to make it happen.)

Absolutely.
Full dynamic linking and libraries is on todo list.
It's taking long time, since it needs to be powerful and generic from the day one.
If we do 'pass ctx only and return u64' as a stop gap, it will be just as limited
as existing bpf_tail_calls.
bpf_tail_call api was badly designed.
I couldn't figure out how to make tail calls safe and generic, so I came up
with this bpf_tail_call hack. bpf usability suffers.
The verifier is different now. It's powerful enough to do true calls and jumps.
Especially with BTF it can see and track all types.
True tail calls will be seen as indirect jump assembler insn.
True indirect calls will be seen as indirect call assembler insn.
The choice of opcode encoding is clear.
The verifier, interpreter, and JIT work left.
It won't take long.

