Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C2AEE5138
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 18:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2633052AbfJYQaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 12:30:23 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:42662 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2633030AbfJYQaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 12:30:23 -0400
Received: by mail-lj1-f194.google.com with SMTP id a21so3375242ljh.9;
        Fri, 25 Oct 2019 09:30:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=W8J7V85mTgUhcGIBJTP6zmLNsIPhGohEfQkJqat8vKA=;
        b=ITLlzA8qlEIUMjjAQz11eDGYglS0ok8jLTJF9Ji05ZJ6jnnC61ulj9OM2JJZb1v4aa
         CPWyrysDzXZWwlfHWbyaVYp0Uo6u748ZfvLIxsQV1DjXgDlAa5i0McPraMDjEasv4HaR
         a5+G4dyVr2YW2fvEXGoH3fVyCQsMpkPfCaNmF4OR5QZjw4tGQqbdOfTqkvQytytbMzYr
         a21gywBXNwu7N+aOvflT1fxVN5tFtFVp7ScESW8nmQPEVJugtItTM09fOdlTbLgOB6BH
         /TCE5WX6WiAeUZG6BdldwKfJmAyf8i6oW67GVw3+UNZFZt7asod8FbHumI5U9RWYDgmu
         NbpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=W8J7V85mTgUhcGIBJTP6zmLNsIPhGohEfQkJqat8vKA=;
        b=U0RyvxX2R1Sp/+l6sfjuqbb4AhBoRJ1ZPVDsTXD3+gP/Fu74ZgRs6yjf8hF6nqzSgu
         eLrQRC/diIvQIuwf1pgp5JhIIMzX8cYcuWBwXZzK6zCZfex8WZvQOkGmSHTg+YRlDVEl
         qvCvtpLut4ZQvqAPMVEQsmvGu0kA/TQ5x1myWp6top469ZFktpcrmf60xGuP2tRBrA7C
         eEAIoXVwIDEBexqO9RjaagGrV8cRDNeY2RHqZT0AjeBqzpZEJnjzh544u5sED+YsX8nM
         xmmAtIkm2rLTISihxOunJMRsaVB37FTcdpVpnqU8SeyvpO067Y4SxS9pohJEzOqtTZIo
         O9OA==
X-Gm-Message-State: APjAAAUv6CjwNdCbUyUv8/c5TKhb/pqEOqrrn6J3q5PyhVadBI+qIkvH
        xphF9S40OAKwszC2WfI9qlI1akbdvAo69vDO3fcBHA==
X-Google-Smtp-Source: APXvYqwzVj6ckBGoV1DyaaT5oFgF0xb3whhdSuGvZPSPVI1gAVZHZE4oWPB1dKkKovNMMOKmHN46OMuPKwKPk9ikfvM=
X-Received: by 2002:a2e:b17b:: with SMTP id a27mr3110442ljm.243.1572021019412;
 Fri, 25 Oct 2019 09:30:19 -0700 (PDT)
MIME-Version: 1.0
References: <157046883502.2092443.146052429591277809.stgit@alrua-x1>
 <157046883614.2092443.9861796174814370924.stgit@alrua-x1> <20191007204234.p2bh6sul2uakpmnp@ast-mbp.dhcp.thefacebook.com>
 <87sgo3lkx9.fsf@toke.dk> <20191009015117.pldowv6n3k5p3ghr@ast-mbp.dhcp.thefacebook.com>
 <87o8yqjqg0.fsf@toke.dk> <20191010044156.2hno4sszysu3c35g@ast-mbp.dhcp.thefacebook.com>
 <87v9srijxa.fsf@toke.dk> <20191016022849.weomgfdtep4aojpm@ast-mbp>
 <8736fshk7b.fsf@toke.dk> <20191019200939.kiwuaj7c4bg25vqs@ast-mbp> <874l03d6ov.fsf@toke.dk>
In-Reply-To: <874l03d6ov.fsf@toke.dk>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 25 Oct 2019 09:30:07 -0700
Message-ID: <CAADnVQKOJZhova8GsUug364+QETPFq1DmGO5-P7YBjyDF99y9Q@mail.gmail.com>
Subject: Re: bpf indirect calls
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Alan Maguire <alan.maguire@oracle.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 20, 2019 at 3:58 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
> Great! I think it's probably more productive for everyone involved if I
> just wait for you to get around to this, rather than try my own hand at
> this. I'll go hash out the userspace management semantics of chain calls
> in the meantime (using my kernel support patch), since that will surely
> be needed anyway.

No problem. Indirect calls are next on my todo list.
Shouldn't take long.

Right now I'm hacking accelerated kretprobes for tracing.
I've shared first rough draft of patches with few folks and they
quickly pointed out that the same logic can be used to
create arbitrary call chains.
To make kretprobe+bpf fast I'm replacing:
  call foo
with
  prologue
  capture args
  call foo
  capture return
  call bpf_prog
  epilogue
That "call foo" can be anything. Including another bpf prog.
Patches are too rough for public review.
I hope to get them cleaned up by the end of next week.

Jesper request to capture both struct xdp_md and return
value after prog returns will be possible soon.
xdpdump before and after xdp prog.. here I come :)
