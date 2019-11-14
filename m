Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8337FC65B
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 13:31:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbfKNMbV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 07:31:21 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:57218 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726185AbfKNMbU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 07:31:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573734679;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XhE8xXmj9Z10HCp53338fqgsIScQRA8Qbn5n78q0HLM=;
        b=KZ8on4A82KHsEcQLGwD5bOQyyk5ZH+bk5sJWnqvApNHsQi+12w9ZK9al0HDoyxJZvSLDvv
        x2u5lCYLwlorAJtcRduuBselXsskPbLHKGcUwBD9l15CyRkdqmEodwy3nMqRPA1rVWi8G3
        P3anW7vMb49b5VpVSHuK4mIE+GEL8zE=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-169-re31c3w5N6azzAsSw32_uQ-1; Thu, 14 Nov 2019 07:31:18 -0500
Received: by mail-lf1-f71.google.com with SMTP id v204so1917943lfa.0
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 04:31:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=XhE8xXmj9Z10HCp53338fqgsIScQRA8Qbn5n78q0HLM=;
        b=F8gLtxJrc69eNt7oiHTV8yw4/b3mEpf1vNB9jziLbFFN6u69xYCd2H4u7CMHF1EdCv
         CkLP4RQF5Pg+pxuukfugoKJadzbWVZlWmeemDrSTXsbM+arkA7s43BOMgUmDvEUu5Hzt
         KEZ7x+ywX/faLh6gQKRmeWiiTGoY1Hf8LlXdR9N0Ky0cIYeCHpVhPvaE5t4aj6kH0kWl
         DVmkqVYarcBJpOeL7s2lTH78steSKArHBRpaKBNaWsyG7FBdFvAlFxCoOXbZ3PRVoaLx
         24HWER4IsyFLchZK8e34rSjyBaiIUf59EwBJOujNH8GBmGTLk1+FDQnEc/LaRQ0r501w
         7mSg==
X-Gm-Message-State: APjAAAWe3kp3g/U8tlfbOhdDapYU+IwT1xmICO8/XenFH/Hf821uxpQu
        rGJYLqeN97z5dTga99crYd/BBSM0amFAD4xW/WGUDeLBv5t5vVycK1HNHIaxARJ1H7W8+h9POEo
        1WvhxHqN+QQuq/JTf
X-Received: by 2002:a2e:8188:: with SMTP id e8mr6371715ljg.152.1573734677047;
        Thu, 14 Nov 2019 04:31:17 -0800 (PST)
X-Google-Smtp-Source: APXvYqxGJRRLcesQFw2O4Hh8Ga/RpXJ0X4addeIb99orB44DGObzCBFjjx9JM7maP75fzoyae4L39w==
X-Received: by 2002:a2e:8188:: with SMTP id e8mr6371687ljg.152.1573734676719;
        Thu, 14 Nov 2019 04:31:16 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id i18sm2864083lfc.82.2019.11.14.04.31.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2019 04:31:16 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 2EC4C1803C7; Thu, 14 Nov 2019 13:31:15 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <thoiland@redhat.com>
To:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, magnus.karlsson@gmail.com,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com
Subject: Re: [RFC PATCH bpf-next 2/4] bpf: introduce BPF dispatcher
In-Reply-To: <20191113204737.31623-3-bjorn.topel@gmail.com>
References: <20191113204737.31623-1-bjorn.topel@gmail.com> <20191113204737.31623-3-bjorn.topel@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 14 Nov 2019 13:31:15 +0100
Message-ID: <87o8xeod0s.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: re31c3w5N6azzAsSw32_uQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> writes:

> From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>
> The BPF dispatcher builds on top of the BPF trampoline ideas;
> Introduce bpf_arch_text_poke() and (re-)use the BPF JIT generate
> code. The dispatcher builds a dispatch table for XDP programs, for
> retpoline avoidance. The table is a simple binary search model, so
> lookup is O(log n). Here, the dispatch table is limited to four
> entries (for laziness reason -- only 1B relative jumps :-P). If the
> dispatch table is full, it will fallback to the retpoline path.

So it's O(log n) with n =3D=3D 4? Have you compared the performance of just
doing four linear compare-and-jumps? Seems to me it may not be that big
of a difference for such a small N?

> An example: A module/driver allocates a dispatcher. The dispatcher is
> shared for all netdevs. Each netdev allocate a slot in the dispatcher
> and a BPF program. The netdev then uses the dispatcher to call the
> correct program with a direct call (actually a tail-call).

Is it really accurate to call it a tail call? To me, that would imply
that it increments the tail call limit counter and all that? Isn't this
just a direct jump using the trampoline stuff?

-Toke

