Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42B39132E20
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 19:15:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728470AbgAGSPQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 13:15:16 -0500
Received: from mail-io1-f41.google.com ([209.85.166.41]:38240 "EHLO
        mail-io1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728364AbgAGSPQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 13:15:16 -0500
Received: by mail-io1-f41.google.com with SMTP id v3so305100ioj.5;
        Tue, 07 Jan 2020 10:15:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=VuA4wbYEEBGhPSUf++IDvynI0a8mQS0Uxx5u4Jjfn6I=;
        b=KFgXFhfJ4aF7FduK7zThQwTBWcE+eSjq8ikAmUcy5lVJ8ZDB+p5qI1ZsNm8Ry2w5IH
         IsACbLbZNbu36iz2Zuc0VyogbGw6XQLusEkWIv2SvkDC7iDTbexNYwrgiNwDvmgd7SfK
         u47YYHPS9wSTdZ9KrW5UXMDyaPyKwKwvt1rppn4lqEFOtpbfRE6g6qCn76Ifhhd4lJEy
         eBOYrnt+uHsnCJa8+wbx5JzNkuH6feeBuX9MYzFaiX6oObnA8I/Qup+D1UxekDJB0aAQ
         69Acsr1MH19IdwYwwy5VPcvYIeL2FzncP/KO3MKTITHuMMJfuAYMElbFbbJYwtgpnTX2
         zjnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=VuA4wbYEEBGhPSUf++IDvynI0a8mQS0Uxx5u4Jjfn6I=;
        b=PUrAGwVEM/hPO4D3aLHb8LE7cwLTU9kOo458p7+goLBsBF7wL4GAhznKk5IuVZm/DV
         5i7y4H0cdu7s7gnw29PpoXO8bbW4DuhUeeuNhVFd/rD12b97u6WlAL1PeNwJOhWPgO3V
         P8B799s7wt/gGd6Xrz+qfewETzrwAVSeGGFQ4RFbXLUgGorShKQsPn95ADIE8R+WCx7Q
         yIGkbBkexKq/UcOoKIU5VOkUwz2720RxFPE9CpCWOiovVFlcCalIk72UFCc+swvi+9N6
         SdBduFeg9vW9kSRnX4u7hndmbNp+rPp3fkO8NMiF3hAqe9MDXG50s+L1YkYIxaW0ka8M
         LtqA==
X-Gm-Message-State: APjAAAWS/C2vPVHkuHsuOE+5WymQ8VzjT7e5SC9shn7ZoeUnojk0ZdJ3
        s+K+qnfgYg9048lV0vUDl44=
X-Google-Smtp-Source: APXvYqwYRzvMHrE26Ab9cVDC6rl53/WUja7Hqw0BOxaYGXYBNRpe2CkiYyG6poO4F3j8IhrInXOqZQ==
X-Received: by 2002:a6b:8f0c:: with SMTP id r12mr161307iod.233.1578420915451;
        Tue, 07 Jan 2020 10:15:15 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id r14sm103684ilg.59.2020.01.07.10.15.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2020 10:15:14 -0800 (PST)
Date:   Tue, 07 Jan 2020 10:15:06 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, davem@davemloft.net,
        jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Message-ID: <5e14caaaab6f7_67962afd051fc5c06f@john-XPS-13-9370.notmuch>
In-Reply-To: <20191219061006.21980-8-bjorn.topel@gmail.com>
References: <20191219061006.21980-1-bjorn.topel@gmail.com>
 <20191219061006.21980-8-bjorn.topel@gmail.com>
Subject: RE: [PATCH bpf-next v2 7/8] xdp: remove map_to_flush and map swap
 detection
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bj=C3=B6rn T=C3=B6pel wrote:
> From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> =

> Now that all XDP maps that can be used with bpf_redirect_map() tracks
> entries to be flushed in a global fashion, there is not need to track
> that the map has changed and flush from xdp_do_generic_map()
> anymore. All entries will be flushed in xdp_do_flush_map().
> =

> This means that the map_to_flush can be removed, and the corresponding
> checks. Moving the flush logic to one place, xdp_do_flush_map(), give
> a bulking behavior and performance boost.
> =

> Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> ---

__dev_map_flush() still has rcu_read_lock/unlock() around flush_list by
this point, assuming I've followed along correctly. Can we drop those
now seeing its per CPU and all list ops are per-cpu inside napi context?

Two reasons to consider, with this patch dev_map_flush() is always
called even if the list is empty so even in TX case without redirect.
But probably more important it makes the locking requirements more clear.=

Could probably be done in a follow up patch but wanted to bring it up.=
