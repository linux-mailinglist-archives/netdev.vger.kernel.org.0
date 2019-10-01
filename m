Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F1C3C2DF9
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 09:47:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732756AbfJAHKQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 03:10:16 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:23677 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726157AbfJAHKQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 03:10:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1569913815;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FwK1cw+HTHejYMgpIxBGIUbF1NXkCBEpQH4yikdvzRc=;
        b=Q/gshWvcNmVZIRIRaIYJv0HRLCxxxeAlrxSmAIod6alsAP2TL718TjzYk0XGQmVP9s/O+D
        Md4uBvuLS83+SFT31DDrIWHg2rE67VHsf9RdZxeFx/yctE9f3OU4nLcNJCe40ttCT4fM44
        9/dPrDQ0ibItS/oiYra7kri+47spQPo=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-153-THndESYKMpSTAlJbsyrhhg-1; Tue, 01 Oct 2019 03:10:13 -0400
Received: by mail-lf1-f70.google.com with SMTP id w4so2555915lfl.17
        for <netdev@vger.kernel.org>; Tue, 01 Oct 2019 00:10:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=hqIzzpD8IOQLWmcd/1moh6fetqtyiKiVmX3233qBoxY=;
        b=jxZ2cktLV37lYbtnYU9OoLnB7uE7uwyPC0UyvYbPuXd1JP3bzCXW6fkT4c+WTqSjoa
         MUpA/39ZcGQMohnnIeqo5/xHqkUbzCAb0kSdtWBObONm7LAGTYrCelN+5/JjpoBP6HfX
         dE1iBpF5WT/Hh6fj+FUW++ACI46IME+CVvHtPJ0o1IK0uXpgOh6O/G2X8f7419IjahsG
         m6FSVtGYbuBUCvde/SRaNejkplxzq+fsz/dGwMJHU7ZcXVBs6GgmY2rlT5V82hK/3dBg
         KgiGX+6970h42zk+G8XIOkDUrsvWuKrn+WWvRDocksuvaM6HFjSWLqjf8c9EsGHi8Sn7
         +o3A==
X-Gm-Message-State: APjAAAUuH0jAjOnIfR/iENqpiWSb6xvQSM3HRUzKb6cGzNFAcpBkDtYW
        jhRAN/xHzzx5nx+aax8lyr636YUlY6h36DgIb/jPuXy/t07GRz/Hzfe5DMgp9mfYptxJXXsajiT
        duqZik1kUbKG7gGvA
X-Received: by 2002:a2e:4296:: with SMTP id h22mr15129047ljf.208.1569913812031;
        Tue, 01 Oct 2019 00:10:12 -0700 (PDT)
X-Google-Smtp-Source: APXvYqw5zdtdRl6GeiHx7FeDGheYopkFgYAPPKNKhz2hYebf0a7QjqWVwALCnmww4Qavi6M7oJ8AHA==
X-Received: by 2002:a2e:4296:: with SMTP id h22mr15129039ljf.208.1569913811905;
        Tue, 01 Oct 2019 00:10:11 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id m17sm4638187lje.0.2019.10.01.00.10.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Oct 2019 00:10:11 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 60A2E18063D; Tue,  1 Oct 2019 09:10:09 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com,
        Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH bpf-next 2/6] libbpf: move bpf_helpers.h, bpf_endian.h into libbpf
In-Reply-To: <20190930185855.4115372-3-andriin@fb.com>
References: <20190930185855.4115372-1-andriin@fb.com> <20190930185855.4115372-3-andriin@fb.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 01 Oct 2019 09:10:09 +0200
Message-ID: <87d0fhvt4e.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: THndESYKMpSTAlJbsyrhhg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> +struct bpf_map_def {
> +=09unsigned int type;
> +=09unsigned int key_size;
> +=09unsigned int value_size;
> +=09unsigned int max_entries;
> +=09unsigned int map_flags;
> +=09unsigned int inner_map_idx;
> +=09unsigned int numa_node;
> +};

Didn't we agree on no new bpf_map_def ABI in libbpf, and that all
additions should be BTF-based?

-Toke

