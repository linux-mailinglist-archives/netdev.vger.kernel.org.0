Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C4A3E2161
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 19:06:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726931AbfJWRGE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 13:06:04 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:44159 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726812AbfJWRGE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 13:06:04 -0400
Received: by mail-lj1-f193.google.com with SMTP id c4so6787137lja.11;
        Wed, 23 Oct 2019 10:06:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=eGIjZFQLm4uQEvdp736SkyrSU6/XWjKzshqUAPI8MkU=;
        b=UDd1kLaE3jDdTqpw0a4Vz8thIFnTEFS4Ui0zy6nA6GJoCTBw7c87sDN3Y2J3CckHyC
         EDbL0kU5NQTEEqGKSjSsabFNonK2ZOI55Lq091AVAcGv90bDFu3NM4cMC4JvtAlZL0pY
         RR/Fs/lcX3VUn+DiKHrPBTXyOMwiZCBmBuaZlcMNBz9zG0gUQQZ9USR7p+8ZhBobqZQV
         qmzkT1j7YOp3GgRGogRlDCiaArGc7USAO+Rixo+9ea73COUiBB9LsiNSTOIcAhzmQHyJ
         xfkCiI9Dia2U7CeV/sqlIZmFMQUU52zUP8mS4wD5s+4nKVmUUa2RpVd27vUcXS0yfjZX
         kVDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=eGIjZFQLm4uQEvdp736SkyrSU6/XWjKzshqUAPI8MkU=;
        b=chSh8Zo8YHOpsDfC9ZokpGg9NbrCOAiNavIjfOXxIlnDw85AzKSA4X7lmr/FF5qVzo
         b98lm00MygHuRkZbFUusMMRgJ9JlW0cNEinYMhTvhuc3T2XCyo8PxRVl8h4wDlhpNEw+
         oElSBELuzemRgB5UZGL2E2X2VivqPzP5KNor8fjNVGYk8SjhAzkyxvjzt+BJzyeZydfF
         r2+hAa6p5bLEbg2qvi0NA/aAWKWMtZO0Xibmddi+X5FKKu45eLcoOP8bgKgLjEtHOqVi
         +W6jzy5Ow9Ah0iNCRea9+gfJW1RArkdatR9Nt2B+F4QafuVoEn/oTceBToOAgSYmzXNA
         hzIw==
X-Gm-Message-State: APjAAAVxlxJyF1LlBFdmfj79h+Cj5QOLHQhO52vKVIg4Swd/QmGjzyvJ
        D/U0kp+UByHtGUYOirjPIfVr4sfyG3OvKC0Bt90=
X-Google-Smtp-Source: APXvYqz3EG2Pqs08JE/n1ZGHatI3QyiVlsdwLPZIMXbF7s56RX2xrLBROyJoTSJ3vHGqJ3hHO4x+GGxUUV/iPLesxmQ=
X-Received: by 2002:a2e:9cc9:: with SMTP id g9mr22516372ljj.188.1571850362050;
 Wed, 23 Oct 2019 10:06:02 -0700 (PDT)
MIME-Version: 1.0
References: <20191022072206.6318-1-bjorn.topel@gmail.com> <87ftjlp703.fsf@toke.dk>
In-Reply-To: <87ftjlp703.fsf@toke.dk>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 23 Oct 2019 10:05:50 -0700
Message-ID: <CAADnVQJpBT63ySCMZUWUokORP2C8DiTKTtwf6Mawq3UsCFS5EQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3] libbpf: use implicit XSKMAP lookup from
 AF_XDP XDP program
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf <bpf@vger.kernel.org>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 22, 2019 at 12:35 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@red=
hat.com> wrote:
>
> Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> writes:
>
> > From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> >
> > In commit 43e74c0267a3 ("bpf_xdp_redirect_map: Perform map lookup in
> > eBPF helper") the bpf_redirect_map() helper learned to do map lookup,
> > which means that the explicit lookup in the XDP program for AF_XDP is
> > not needed for post-5.3 kernels.
> >
> > This commit adds the implicit map lookup with default action, which
> > improves the performance for the "rx_drop" [1] scenario with ~4%.
> >
> > For pre-5.3 kernels, the bpf_redirect_map() returns XDP_ABORTED, and a
> > fallback path for backward compatibility is entered, where explicit
> > lookup is still performed. This means a slight regression for older
> > kernels (an additional bpf_redirect_map() call), but I consider that a
> > fair punishment for users not upgrading their kernels. ;-)
> >
> > v1->v2: Backward compatibility (Toke) [2]
> > v2->v3: Avoid masking/zero-extension by using JMP32 [3]
> >
> > [1] # xdpsock -i eth0 -z -r
> > [2] https://lore.kernel.org/bpf/87pnirb3dc.fsf@toke.dk/
> > [3] https://lore.kernel.org/bpf/87v9sip0i8.fsf@toke.dk/
> >
> > Suggested-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> > Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>
> Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

Applied. Thanks
