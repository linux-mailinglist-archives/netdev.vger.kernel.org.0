Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C88CE13487B
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 17:51:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729514AbgAHQvJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 11:51:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:47790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726401AbgAHQvJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jan 2020 11:51:09 -0500
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1E2220720;
        Wed,  8 Jan 2020 16:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578502268;
        bh=C/HNmaVtqAILoV5xCv+ws2hrk8QbFe2yN/GTNdsh374=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=GHDY91E4P322n23eUtHPoi5ZY5HvrAFg8dSa8cRyzQxfJ3xYecJjrSLy/3QEIqlAN
         7nAh3HPoS3XlKHLw6eWUA1hidTWYcDEROpZKGQz11lmb/ZIipnBZL0BH203Z+fDhvp
         zzc7sXZ9loe1hDt9OSLH3rwn34KUoUMonpwUGx/E=
Received: by mail-qk1-f169.google.com with SMTP id t129so3207916qke.10;
        Wed, 08 Jan 2020 08:51:08 -0800 (PST)
X-Gm-Message-State: APjAAAV4Fq73ixth96mxcpQyxl85MQVM7zLd8JyrpbskFDRNlZGHxJC8
        PgI5tkRHvOIPlL9EAZFrTBGnadC1MbVtjCJChSc=
X-Google-Smtp-Source: APXvYqyl1pAS9EIW7I7jpJp9tWfmIvQvL5AeJ5iq4foV+nizgUSq4PVaPrFn+mbecg/wNv05GrkFkqHLUeRtz2wxiTk=
X-Received: by 2002:a37:7b43:: with SMTP id w64mr5163096qkc.203.1578502267905;
 Wed, 08 Jan 2020 08:51:07 -0800 (PST)
MIME-Version: 1.0
References: <5e15526d2ebb6_68832ae93d7145c08c@john-XPS-13-9370.notmuch> <20200108045708.31240-1-forrest0579@gmail.com>
In-Reply-To: <20200108045708.31240-1-forrest0579@gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Wed, 8 Jan 2020 08:50:56 -0800
X-Gmail-Original-Message-ID: <CAPhsuW4457A1JKrPJSjdabbRAPBo1qucrnSirnYkM868zp9VKw@mail.gmail.com>
Message-ID: <CAPhsuW4457A1JKrPJSjdabbRAPBo1qucrnSirnYkM868zp9VKw@mail.gmail.com>
Subject: Re: [PATCH] bpf/sockmap: read psock ingress_msg before sk_receive_queue
To:     Lingpeng Chen <forrest0579@gmail.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 7, 2020 at 8:58 PM Lingpeng Chen <forrest0579@gmail.com> wrote:
>
> Right now in tcp_bpf_recvmsg, sock read data first from sk_receive_queue
> if not empty than psock->ingress_msg otherwise. If a FIN packet arrives
> and there's also some data in psock->ingress_msg, the data in
> psock->ingress_msg will be purged. It is always happen when request to a
> HTTP1.0 server like python SimpleHTTPServer since the server send FIN
> packet after data is sent out.
>
> Fixes: 604326b41a6fb ("bpf, sockmap: convert to generic sk_msg interface")
> Reported-by: Arika Chen <eaglesora@gmail.com>
> Suggested-by: Arika Chen <eaglesora@gmail.com>
> Signed-off-by: Lingpeng Chen <forrest0579@gmail.com>
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>

Cc: stable@vger.kernel.org # v4.20+
Acked-by: Song Liu <songliubraving@fb.com>
