Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B1465EC14
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 21:01:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727091AbfGCTBk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 15:01:40 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:42471 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726473AbfGCTBk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 15:01:40 -0400
Received: by mail-qt1-f193.google.com with SMTP id h18so2869152qtm.9;
        Wed, 03 Jul 2019 12:01:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=a4hi8wKrbqTGeszTm6+N010zWRC1VvcFxJuDUZi2Xrc=;
        b=M3cBmORnKXkNXvPbiVJl2qFUt9EXm1TgZku8X1lfQuzXPiidtjslbcbJ17eAtHmi3S
         KWT1O9SIBjQniMpLiFyPckjKKIKcbXLCKM1kw+z/i70KCsonx9otLPCMhXp5DleBBZCr
         DPVXSpQ1HXueLtgcfR5TvGNcMxhdFQjlTDbUGrFVM7YAgB7w2h9b2tgkeT9ewcMpwaJl
         uQVYl9IZcTsjWi3lSY4V8PbAH75VBAuUmXujwf5LyHE/Kxkt73jBusQg9nU09EAyrhfk
         kWxM2Z9Nkf3IK4dgNluQMy3x4XDbw9Nv3pIJaNaShDAWeOlfS3s4vaFm3M+2VykRaQ1U
         TASA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=a4hi8wKrbqTGeszTm6+N010zWRC1VvcFxJuDUZi2Xrc=;
        b=W9KWRUUl5iS1dlRC505rsbAbKQVn736vJ+XW8os74lNah3wr9D45uGPtgJM8laVGn+
         nHMY728ofqQhpQ39g1aZrf4U+E7rvNUS5m7MItQXMyfuKi+/BkEM6Nxqt8ZBdWQY+op/
         Q76NVV2z7tXZ/oxiXFphFB5meLMJ7zxC//FPcxWA1Rqs+6noVBbJiIxN1b3k4tisYeMP
         jGjCVy/6Gm9QovyvUXQ8lwQqs8j+20K7YsZ0Kp9zV+6Zbr0pgQ3mUhHXp7dSwyb5ngf1
         dA+BLSTPfCoZO3PwzbPVpjkZhdAyQ2CMngsgeEsuIRaKML0WFTLhCUZnyURFbLSRmONn
         p6NQ==
X-Gm-Message-State: APjAAAXJ7mpNI/k+4dh9KKMRczIanyh/2rMIZfdiduuK65wm2df63/oh
        ld8cDVGiyLK/64ieFN0kNT7upzwSF+bSzjF83GU=
X-Google-Smtp-Source: APXvYqwUll0xYu2yPKQ1EbnRp9gmuHua63nYAx/pK0sNp1+oiv0SlxTX94tCkPYNiEa2T/EXcdPR28N5Or99e4O8CHw=
X-Received: by 2002:a0c:d0fc:: with SMTP id b57mr33827753qvh.78.1562180499352;
 Wed, 03 Jul 2019 12:01:39 -0700 (PDT)
MIME-Version: 1.0
References: <20190702161403.191066-1-sdf@google.com> <20190702161403.191066-7-sdf@google.com>
In-Reply-To: <20190702161403.191066-7-sdf@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 3 Jul 2019 12:01:27 -0700
Message-ID: <CAEf4Bzak755ixqVetwaPOi96-aNbGwshO3anrP_i_dvPG_quQw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 6/8] selftests/bpf: test BPF_SOCK_OPS_RTT_CB
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        Priyaranjan Jha <priyarjha@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 2, 2019 at 9:14 AM Stanislav Fomichev <sdf@google.com> wrote:
>
> Make sure the callback is invoked for syn-ack and data packet.
>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Priyaranjan Jha <priyarjha@google.com>
> Cc: Yuchung Cheng <ycheng@google.com>
> Cc: Soheil Hassas Yeganeh <soheil@google.com>
> Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
> Acked-by: Yuchung Cheng <ycheng@google.com>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  tools/testing/selftests/bpf/Makefile        |   3 +-
>  tools/testing/selftests/bpf/progs/tcp_rtt.c |  61 +++++
>  tools/testing/selftests/bpf/test_tcp_rtt.c  | 254 ++++++++++++++++++++
>  3 files changed, 317 insertions(+), 1 deletion(-)
>  create mode 100644 tools/testing/selftests/bpf/progs/tcp_rtt.c
>  create mode 100644 tools/testing/selftests/bpf/test_tcp_rtt.c

Can you please post a follow-up patch to add test_tcp_rtt to .gitignore?
