Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFA5117DCEC
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 11:06:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbgCIKGp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 06:06:45 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:46853 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726027AbgCIKGp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 06:06:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583748404;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5pVffw3WEJdN/t3fxfYggMKUlU5RNvR//cUlYZSKZw8=;
        b=BXzqqP7/BwI3pzK5pCw1iLwk4OheGd/UCDpm0Qp2gbhY5pPs242br7JuEw8flmB+eP7Y/k
        LXnsPhZWfa3HEaXF5dBXT9wJEymS+2NiQnDf8Ff9PoRF6zBbXKzBTHmAF/w3mpFyxbPYGO
        5hpvwhyfzPgL0wMt9Sw+3i4QzY4q29k=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-491-wsF2OhqFOV6GwAqoFg2swg-1; Mon, 09 Mar 2020 06:06:43 -0400
X-MC-Unique: wsF2OhqFOV6GwAqoFg2swg-1
Received: by mail-wr1-f69.google.com with SMTP id p5so4917591wrj.17
        for <netdev@vger.kernel.org>; Mon, 09 Mar 2020 03:06:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=5pVffw3WEJdN/t3fxfYggMKUlU5RNvR//cUlYZSKZw8=;
        b=Kn8sNrcXVlTQdLfNOAstMQF4gxq6hCJ8M3hVc6d20CoiyuGk6X671sDFUP4qVVrYuX
         3AD4JH5F6kjfVm2A4m8eOFp3tq3hoxzTrXkARjZroaP4r9mkQ947mZXuN/x1aYAd1nKp
         yHgA9nm9uXzYxVF/hVvtDc44qoWTNAkDqj7e3r9GAkIlC7ipKQGFwmq7oHsTPQaaYFMf
         /SW4An78NRpjnrWB1r2Ohq/q217gIyvxb1JhVYk2r4L3v2s6r7K9epWnVVJLaqXoO72G
         o1JSUxFAUGQULYZkpHiWGsdtUpbsPAaFP3tL+X80srVN+mT/Jbv8bKFZO20AClSahZpi
         6aww==
X-Gm-Message-State: ANhLgQ3KNM22VaI2Vng5KzDpdYA4DLTdh7Kq3zssyr2wSLdEre5219RS
        HgKULW+LlCfRa73oys1JxO0+yLkwRvkrENGj9BuXs5xaDIZmVpH2EKCqhW0cjhdmld2tmtozBze
        fZHc2EPq/41Kc6Lg8
X-Received: by 2002:a1c:8103:: with SMTP id c3mr13893977wmd.166.1583748402081;
        Mon, 09 Mar 2020 03:06:42 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vsGKUaZexq9c7r3nw7dAdzYDqo8N9O8HFYpRjT3YC3C8khqjG/LN06T7s3/+ot0hMM+ZgBBRQ==
X-Received: by 2002:a1c:8103:: with SMTP id c3mr13893949wmd.166.1583748401833;
        Mon, 09 Mar 2020 03:06:41 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id l64sm3298717wmf.30.2020.03.09.03.06.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2020 03:06:41 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id B196C18034F; Mon,  9 Mar 2020 11:06:38 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Eelco Chaudron <echaudro@redhat.com>, bpf@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, andriin@fb.com
Subject: Re: [PATCH bpf-next] bpf: add bpf_xdp_output() helper
In-Reply-To: <158348514556.2239.11050972434793741444.stgit@xdp-tutorial>
References: <158348514556.2239.11050972434793741444.stgit@xdp-tutorial>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 09 Mar 2020 11:06:38 +0100
Message-ID: <87r1y1266p.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eelco Chaudron <echaudro@redhat.com> writes:

> Introduce new helper that reuses existing xdp perf_event output
> implementation, but can be called from raw_tracepoint programs
> that receive 'struct xdp_buff *' as a tracepoint argument.
>
> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

