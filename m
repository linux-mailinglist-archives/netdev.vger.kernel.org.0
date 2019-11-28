Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D198B10C343
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 05:41:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727618AbfK1ElQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 23:41:16 -0500
Received: from mail-il1-f180.google.com ([209.85.166.180]:45769 "EHLO
        mail-il1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726401AbfK1ElQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 23:41:16 -0500
Received: by mail-il1-f180.google.com with SMTP id o18so23032561ils.12
        for <netdev@vger.kernel.org>; Wed, 27 Nov 2019 20:41:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=dLEIIz/fBdLf+iEohjtCUFIrt2eOBQD/328CRwxv6L0=;
        b=S6fA/4ENN4/I7A2C/+WlEq8sRg+OfqJDgA2zTVWmvbRqDBXZ3tbQGIGRKHXV9x4wj2
         n2EL2KXkqJ7TlvtpFxEnmwyzIDF5ILl/DmcfnGlSgI7ejHVy85hBGanVdBos54ds65ge
         FgzlLA5r9oNzlohrItr1Azm9XI0Lqf56V5kG7tXIoZBgMIyU9XTxNG8pFMAn6sQAn1SP
         oHUM9Z6eFjyAOyC7hGp8qYQLcf3dDLLDFaDH0Y7ejWRnoUMnXnqTAJtSRM5YT9nF536/
         eqbPUNYn4JF/kukzs6FWeF5Td37laloOhRYFGkZG2wynbwtF5Hhn37RGr2mWYcz/4IvO
         g3cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=dLEIIz/fBdLf+iEohjtCUFIrt2eOBQD/328CRwxv6L0=;
        b=pDHq7ej14kxiaQWYjrTiH4d2IvJU+JnZKRw0KPSVd7vIMdLUniTeq4+NJIsgM5Fr4Q
         TKtMH1aKoRfYfCyvtUGmBr4d//yUk7lWm+uzqiQmwi9wnJtTMZe3k5nSJGgYx1VsUG8H
         rUKt7jIj1ppYjk/NV2aGwC7+qOcoCnYWx3S7KNE9yupMfCT44JzE/nl6fA/uq9AaxoUh
         kUvXgct4M9lkcYwNuYoBthhoyjbBrBi0yxWURJWtDzSa1p62BqaiG70iobqQVrIWweUU
         7XAN5rHv2y9t0MyAbiwK1DzVJi3BpfZBBRZhC4oGpOPmhXxkpkypTKLEZRu7WMsHm1vZ
         nchQ==
X-Gm-Message-State: APjAAAW69jsQ/ZuGaR2gNrDnHW4vEx11ObZi3VXvT5oadrDa6mp7HZsA
        Eem9DV5I868v0508RyvZE5c=
X-Google-Smtp-Source: APXvYqyrssWqvogRrQ8BWPlUAcatK4LgBlQUqDQdqZJP2vUNN4JZbbbmbgQS7fPFJ+f8+NLBSBgkvg==
X-Received: by 2002:a92:8655:: with SMTP id g82mr35770016ild.2.1574916075447;
        Wed, 27 Nov 2019 20:41:15 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id h6sm5031933ilr.7.2019.11.27.20.41.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Nov 2019 20:41:15 -0800 (PST)
Date:   Wed, 27 Nov 2019 20:41:06 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>, davem@davemloft.net,
        john.fastabend@gmail.com
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        borisp@mellanox.com, aviadye@mellanox.com, daniel@iogearbox.net,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        syzbot+df0d4ec12332661dd1f9@syzkaller.appspotmail.com,
        Simon Horman <simon.horman@netronome.com>
Message-ID: <5ddf4fe2926c9_3c082aca725cc5bcf7@john-XPS-13-9370.notmuch>
In-Reply-To: <20191127201646.25455-3-jakub.kicinski@netronome.com>
References: <20191127201646.25455-1-jakub.kicinski@netronome.com>
 <20191127201646.25455-3-jakub.kicinski@netronome.com>
Subject: RE: [PATCH net 2/8] net/tls: free the record on encryption error
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski wrote:
> When tls_do_encryption() fails the SG lists are left with the
> SG_END and SG_CHAIN marks in place. One could hope that once
> encryption fails we will never see the record again, but that
> is in fact not true. Commit d3b18ad31f93 ("tls: add bpf support
> to sk_msg handling") added special handling to ENOMEM and ENOSPC
> errors which mean we may see the same record re-submitted.
> 
> As suggested by John free the record, the BPF code is already
> doing just that.
> 
> Reported-by: syzbot+df0d4ec12332661dd1f9@syzkaller.appspotmail.com
> Fixes: d3b18ad31f93 ("tls: add bpf support to sk_msg handling")
> Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> Reviewed-by: Simon Horman <simon.horman@netronome.com>
> ---
>  net/tls/tls_sw.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)


Acked-by: John Fastabend <john.fastabend@gmail.com>
