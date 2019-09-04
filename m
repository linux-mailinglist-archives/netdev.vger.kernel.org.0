Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A94FA8D3E
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:31:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731747AbfIDQkn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 12:40:43 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:43916 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731493AbfIDQkm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 12:40:42 -0400
Received: by mail-pf1-f195.google.com with SMTP id d15so4080449pfo.10;
        Wed, 04 Sep 2019 09:40:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2J0mzQdMeSmayAIFRl/DDgdb93Tauzyrb7Uz/NHGZhc=;
        b=SoJYpgGY7CF2CfhToHrDRyXKndLqqg6yqRnD+DMeRrGyHxbvevNZEf0zkva8TDKsj5
         grsk/eRsIbzQ6kEnqZYEIdcXMB5B9tYwo2BJA0u2zcGRi99Qx98/YTjLlkTWmrb+s821
         gq166Pa/JIgxzMiZ1sQMxrLTnwCWpEw4fYE/zl44FRFEL/gnFbv7j2vCyop4vzZT+eKV
         bgOxZEILzW1jX1dUA8vjEk0OyvlniHIiJQM/y2i4O6g6Uma6bozJm2uokijVvE3Ae6uc
         5oFu6X/k7p7dEkGVii6zUJ3Zpu5yfPVWnS4kMy5caJUas7oE1VSTpmGUAfaQyAOPy/qV
         +P5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2J0mzQdMeSmayAIFRl/DDgdb93Tauzyrb7Uz/NHGZhc=;
        b=ulUzOzLGjgK98qmnKbA2bGjYRlFoJVFGjERBiH4DCt+bYZ+Fyo05oqycVizFM70TUf
         LC4N2eyxcrFvdw86csddz/THjvnmd0G7yXCHwiSnB5dyQdvZsuS00NgVfO3M0zpzoJY/
         v3tfVTkUamhGR9wPug/KnrZYfgDiQScPG+85ozN2BRrneIcjnbYgIo2btMRhUQUaWBKs
         FirXbpbzb4nMLBcdE+vQQESUypMJdltUFe4sZUV9jShaEfr3TFqVkGGUdfuFy6FfugVB
         UaPj7fwhB9MI4kkgn7mTBA3+sR4ZSivIlYwmnDighKYo1xsxP/KRBf05FpsbuQ59czAu
         xxhA==
X-Gm-Message-State: APjAAAW2YDE0qjg6v4bGLax0eTnVaXHx3atZquTYN1AmqHKZhSB+of/r
        k4h69jw6oaxslwGz2HY2oPE=
X-Google-Smtp-Source: APXvYqy32sWmcTKMymczeR/FTDJKW4oa06ltZ+9er8h2ggVTT79FL6lUmThH2aws9vzV0qfaChAP6w==
X-Received: by 2002:a63:2a41:: with SMTP id q62mr36168854pgq.444.1567615242106;
        Wed, 04 Sep 2019 09:40:42 -0700 (PDT)
Received: from [172.26.108.37] ([2620:10d:c090:180::85c5])
        by smtp.gmail.com with ESMTPSA id v8sm18712900pgs.82.2019.09.04.09.40.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Sep 2019 09:40:41 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "=?utf-8?b?QmrDtnJuIFTDtnBlbA==?=" <bjorn.topel@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        "=?utf-8?b?QmrDtnJuIFTDtnBlbA==?=" <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, magnus.karlsson@gmail.com,
        bpf@vger.kernel.org,
        syzbot+c82697e3043781e08802@syzkaller.appspotmail.com,
        hdanton@sina.com, i.maximets@samsung.com
Subject: Re: [PATCH bpf-next v3 3/4] xsk: use state member for socket
 synchronization
Date:   Wed, 04 Sep 2019 09:40:40 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <4FF1A5C9-F4DD-4FD8-86E8-DDEA753B7954@gmail.com>
In-Reply-To: <20190904114913.17217-4-bjorn.topel@gmail.com>
References: <20190904114913.17217-1-bjorn.topel@gmail.com>
 <20190904114913.17217-4-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4 Sep 2019, at 4:49, Björn Töpel wrote:

> From: Björn Töpel <bjorn.topel@intel.com>
>
> Prior the state variable was introduced by Ilya, the dev member was
> used to determine whether the socket was bound or not. However, when
> dev was read, proper SMP barriers and READ_ONCE were missing. In order
> to address the missing barriers and READ_ONCE, we start using the
> state variable as a point of synchronization. The state member
> read/write is paired with proper SMP barriers, and from this follows
> that the members described above does not need READ_ONCE if used in
> conjunction with state check.
>
> In all syscalls and the xsk_rcv path we check if state is
> XSK_BOUND. If that is the case we do a SMP read barrier, and this
> implies that the dev, umem and all rings are correctly setup. Note
> that no READ_ONCE are needed for these variable if used when state is
> XSK_BOUND (plus the read barrier).
>
> To summarize: The members struct xdp_sock members dev, queue_id, umem,
> fq, cq, tx, rx, and state were read lock-less, with incorrect barriers
> and missing {READ, WRITE}_ONCE. Now, umem, fq, cq, tx, rx, and state
> are read lock-less. When these members are updated, WRITE_ONCE is
> used. When read, READ_ONCE are only used when read outside the control
> mutex (e.g. mmap) or, not synchronized with the state member
> (XSK_BOUND plus smp_rmb())
>
> Note that dev and queue_id do not need a WRITE_ONCE or READ_ONCE, due
> to the introduce state synchronization (XSK_BOUND plus smp_rmb()).
>
> Introducing the state check also fixes a race, found by syzcaller, in
> xsk_poll() where umem could be accessed when stale.
>
> Suggested-by: Hillf Danton <hdanton@sina.com>
> Reported-by: syzbot+c82697e3043781e08802@syzkaller.appspotmail.com
> Fixes: 77cd0d7b3f25 ("xsk: add support for need_wakeup flag in AF_XDP 
> rings")
> Signed-off-by: Björn Töpel <bjorn.topel@intel.com>

Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
