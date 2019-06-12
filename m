Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3DB942F92
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 21:11:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727790AbfFLTKQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 15:10:16 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:42608 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727051AbfFLTKQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 15:10:16 -0400
Received: by mail-pf1-f194.google.com with SMTP id q10so10213177pff.9;
        Wed, 12 Jun 2019 12:10:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Re/8EnpYzudwaGvo8LCJj8Aad3O5n2uY5EksfH4Bs5A=;
        b=bO3gQwlHDpZoT+3hWkMKPIoKO5rCHMoZEYYIeAa0T0kBvQGENp//usJZ7jkT/jBT28
         Mi0fjZ6FUG6MCTnZm33FBTUgtH67bqBcHZT7CJxydbdF5JBrctLcX/d8lDL5YCGX+0xC
         qYACv1rGWqtUJtmcCagC6TCY/nDlroBxidHn+qY+VO7p2KUgrMEH+kFWTC+G5IXN3aBb
         7P0fbzvUbnKD9q7LuKlLCz9qqDQoz/iVakbXqT6xxeokDISMLnWYT+Jgpk4NEE0OxXgi
         l9eqJhiX9fPtxoyX72Tq+bpQ6lLH/qLjSLLY4Il4zGcWLam9KVsAj1GK+AlQnwnAfZLg
         yT3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Re/8EnpYzudwaGvo8LCJj8Aad3O5n2uY5EksfH4Bs5A=;
        b=fBgY14SXvi0pT08n66VQeeh2fDR6yAvjy/vtz5CO+xrD6uMPJK9xfM80gmlsAmmrqU
         8KLGSLXrrWtIaDDHKPiXLIINM+L0TzIyO/D5+NKjZ0wsI+LZHwQMSHgoqC/afN9mV63s
         126KAH9LPzRijoYRhTQbKCtyCws6G03igtkW2+hylXu3ygt9cCnM9ldLkq31bauHrkxf
         +npwVy2j8xh0WjylpOMtISCcmVAj0HpVK+nkDIm2NpbyH8M0DC4PgCb+fjkd0S9g/frd
         NPSxSgv6g1qPqQDBz7FjvdcuQNiolAZqQ6w2fqTzRf3cXpKlGDyzFr29LXFmIfMOW/mg
         4MuA==
X-Gm-Message-State: APjAAAXPrZ9Tu1twBpFfgg42EcnlqH3RPZWujjkyo0LUN95e5Ssw/xU8
        byOPDF/wjS3wNlECwh2VE6g=
X-Google-Smtp-Source: APXvYqzry5CvLO0bFrrUYCMTXScjX8ABtUONCewomrEazCDE3PS+alIhd6oR3CZ50sFn7afpkvCUCw==
X-Received: by 2002:a62:e417:: with SMTP id r23mr55442533pfh.160.1560366615867;
        Wed, 12 Jun 2019 12:10:15 -0700 (PDT)
Received: from [172.26.107.103] ([2620:10d:c090:180::1:1d4d])
        by smtp.gmail.com with ESMTPSA id y133sm337791pfb.28.2019.06.12.12.10.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 Jun 2019 12:10:15 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Maxim Mikityanskiy" <maximmi@mellanox.com>
Cc:     "Alexei Starovoitov" <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        "=?utf-8?b?QmrDtnJuIFTDtnBlbA==?=" <bjorn.topel@intel.com>,
        "Magnus Karlsson" <magnus.karlsson@intel.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        "Saeed Mahameed" <saeedm@mellanox.com>,
        "Tariq Toukan" <tariqt@mellanox.com>,
        "Martin KaFai Lau" <kafai@fb.com>,
        "Song Liu" <songliubraving@fb.com>, "Yonghong Song" <yhs@fb.com>,
        "Jakub Kicinski" <jakub.kicinski@netronome.com>,
        "Maciej Fijalkowski" <maciejromanfijalkowski@gmail.com>
Subject: Re: [PATCH bpf-next v4 00/17] AF_XDP infrastructure improvements and
 mlx5e support
Date:   Wed, 12 Jun 2019 12:10:13 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <CE3CB766-517C-4B6A-B3E1-288A34EFACE9@gmail.com>
In-Reply-To: <20190612155605.22450-1-maximmi@mellanox.com>
References: <20190612155605.22450-1-maximmi@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12 Jun 2019, at 8:56, Maxim Mikityanskiy wrote:

> This series contains improvements to the AF_XDP kernel infrastructure
> and AF_XDP support in mlx5e. The infrastructure improvements are
> required for mlx5e, but also some of them benefit to all drivers, and
> some can be useful for other drivers that want to implement AF_XDP.
>
> The performance testing was performed on a machine with the following
> configuration:
>
> - 24 cores of Intel Xeon E5-2620 v3 @ 2.40 GHz
> - Mellanox ConnectX-5 Ex with 100 Gbit/s link
>
> The results with retpoline disabled, single stream:
>
> txonly: 33.3 Mpps (21.5 Mpps with queue and app pinned to the same CPU)
> rxdrop: 12.2 Mpps
> l2fwd: 9.4 Mpps
>
> The results with retpoline enabled, single stream:
>
> txonly: 21.3 Mpps (14.1 Mpps with queue and app pinned to the same CPU)
> rxdrop: 9.9 Mpps
> l2fwd: 6.8 Mpps
>
> v2 changes:
>
> Added patches for mlx5e and addressed the comments for v1. Rebased for
> bpf-next.
>
> v3 changes:
>
> Rebased for the newer bpf-next, resolved conflicts in libbpf. Addressed
> Björn's comments for coding style. Fixed a bug in error handling flow in
> mlx5e_open_xsk.
>
> v4 changes:
>
> UAPI is not changed, XSK RX queues are exposed to the kernel. The lower
> half of the available amount of RX queues are regular queues, and the
> upper half are XSK RX queues. The patch "xsk: Extend channels to support
> combined XSK/non-XSK traffic" was dropped. The final patch was reworked
> accordingly.
>
> Added "net/mlx5e: Attach/detach XDP program safely", as the changes
> introduced in the XSK patch base on the stuff from this one.
>
> Added "libbpf: Support drivers with non-combined channels", which aligns
> the condition in libbpf with the condition in the kernel.
>
> Rebased over the newer bpf-next.

Very nice change for the RX queues!
For the series:

Tested-by: Jonathan Lemon <jonathan.lemon@gmail.com>
