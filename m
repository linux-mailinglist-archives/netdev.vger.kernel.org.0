Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8A091986E4
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 00:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730802AbgC3WA7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 18:00:59 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:32882 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730794AbgC3WA7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 18:00:59 -0400
Received: by mail-wr1-f68.google.com with SMTP id a25so23612946wrd.0;
        Mon, 30 Mar 2020 15:00:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5wPSzH6TnG5KvWTMFPd9pCuWxykY+FLtxGKX4cPnNhU=;
        b=jdg3QgOy2Vw5NgJsu7oj5KXdnlDRsyHkcORDD/BOSbBVdxYY4kuoTkgTPq2FaE79EN
         wJrgv130H7FOnfTnvNFbNQDY69ioa4IqdAA0c/UgegWmD9GuymK/pZJUNuFGcN2aTgvG
         gafyMtQPIDBh4D4tbUbB0ieb18Muq9vKZ5WLD3TVXSqFt2oqOhE7R6czOgKWNHMtgS4H
         6rSdtC9G0jRP2MlRkxRmbXaOTYrMdz3A2gjskjjbyGGvVKMQycFQ+aKs5rX5yFHgCDJ8
         SyKVSNjDUqKuRxpAAxZ7Rfx7xs5cqNGbPk770RQxku9uivsY84CtbGzmIGw9p/Smb9SV
         D0+w==
X-Gm-Message-State: ANhLgQ2yIjqEUE6ZdrOUStPIM0LBB99B77K0Kmk+iRDgkTuDHlWsB4yo
        Jlbd7yBmTEOMNcA7EQqxb5DBRH+0Er4Z20n3bt4=
X-Google-Smtp-Source: ADFU+vv6o2Haeu6FKPsVYSadZPTaH03mfrxtZAxZmJKQwnLEFxYQl12EoooAtFV9TlrHzy6FRVuACv5WXP88pOZXMKQ=
X-Received: by 2002:adf:b1d8:: with SMTP id r24mr17300542wra.266.1585605656853;
 Mon, 30 Mar 2020 15:00:56 -0700 (PDT)
MIME-Version: 1.0
References: <20200329225342.16317-1-joe@wand.net.nz> <CAADnVQJ5nq-pJcH2z-ZddDUU13-eFH_7M0SdGsbjHy5bCw7aOg@mail.gmail.com>
In-Reply-To: <CAADnVQJ5nq-pJcH2z-ZddDUU13-eFH_7M0SdGsbjHy5bCw7aOg@mail.gmail.com>
From:   Joe Stringer <joe@wand.net.nz>
Date:   Mon, 30 Mar 2020 15:00:45 -0700
Message-ID: <CAOftzPhZyP_TjmDXEv5KcFCTQwXEBz3cFomXc13+fBum1N1_bw@mail.gmail.com>
Subject: Re: [PATCHv5 bpf-next 0/5] Add bpf_sk_assign eBPF helper
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Joe Stringer <joe@wand.net.nz>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 30, 2020 at 1:47 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Sun, Mar 29, 2020 at 3:53 PM Joe Stringer <joe@wand.net.nz> wrote:
> >
> > Introduce a new helper that allows assigning a previously-found socket
> > to the skb as the packet is received towards the stack, to cause the
> > stack to guide the packet towards that socket subject to local routing
> > configuration. The intention is to support TProxy use cases more
> > directly from eBPF programs attached at TC ingress, to simplify and
> > streamline Linux stack configuration in scale environments with Cilium.
>
> Applied.
> Patches 4 and 5 had warnings:
> progs/test_sk_assign.c:79:32: warning: ordered comparison between
> pointer and integer ('void *' and '__u32' (aka 'unsigned int'))
>         if ((void *)tuple + tuple_len > skb->data_end)
>             ~~~~~~~~~~~~~~~~~~~~~~~~~ ^ ~~~~~~~~~~~~~
>
> I fixed them up.

Thanks, I'll keep a closer eye on these in future.
