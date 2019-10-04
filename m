Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E206BCB4B6
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 09:01:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388492AbfJDHBK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 03:01:10 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:51566 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387623AbfJDHBK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 03:01:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1570172469;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/+SV3gwAgG40O12ODD6m4hgfyWqz5XOp/AVtX54TzA0=;
        b=g7Wc+5LXaGsBrgknEX3JIncgBy6aXGuvSHVz9v9vL4eOjbz2kV9SkP5aiV2gRF+SkRCm8i
        pmL+99PUJPTp6fr0yXs18SKCLqcX/2CUoGpJqCVmZIAIrAA/pKwWJaXO/Uwy9kzDPMrA2o
        xQkovMZUVfLgQzC6OwQ/VvN9EmdlBfg=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-121-O8IO1JQYOxahW2p4UA7EvA-1; Fri, 04 Oct 2019 03:01:06 -0400
Received: by mail-lj1-f198.google.com with SMTP id x13so1472999ljj.18
        for <netdev@vger.kernel.org>; Fri, 04 Oct 2019 00:01:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=/+SV3gwAgG40O12ODD6m4hgfyWqz5XOp/AVtX54TzA0=;
        b=OwEoqtDskhkrYwEzTr2dfJxfSb3BXV/SByoC8l4+LgU5GSZSCVL9l3028fMYYTcZYN
         /mByJiarOGnSAnc+0GWJ4EOUmyPipVRozLxPnhaezRwTRRnBVX7anWzvPe4nm4MtiJ3R
         pyYq+eOZlyn3e63RgxLUMW9nbmc4cArauUnx18Jlaw6rZkCbKOo8xue1Vt5+H45Qiycj
         0NBoTK2z93bLDmfwkAzf9i3XIS67ZUCux4sMcvKg/Zora0MhwghqUwUmWx1PYkeSqwYi
         srs02YpbOga+Ntda0w4AaPSfCEhEGm0wxzL7ZuczmElSYWgiNCK4nKt4d10o3An7lpFh
         A01w==
X-Gm-Message-State: APjAAAVPHrqvCLBm34LgbqCRhYY/VhY92bAd0s9akKawNvew0BCOtRcR
        VmZSIllOssOugxBkaTbMaNXNfXVZCkx7Xqkn3/qcMwdspkxP7dNv6nutv+AIfgFjxmmQ7XoW+pn
        WYlaWmphLNz7/pgYP
X-Received: by 2002:ac2:5dd0:: with SMTP id x16mr8229982lfq.38.1570172465027;
        Fri, 04 Oct 2019 00:01:05 -0700 (PDT)
X-Google-Smtp-Source: APXvYqy1QeWf7qCaEUQw/EZn5p2xaig4KIQMBOZvCAl1WITohaIjLZwXE214T++os9E/VExNP+M07w==
X-Received: by 2002:ac2:5dd0:: with SMTP id x16mr8229966lfq.38.1570172464735;
        Fri, 04 Oct 2019 00:01:04 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id e10sm1060746ljg.38.2019.10.04.00.01.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Oct 2019 00:01:04 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 810E018063D; Fri,  4 Oct 2019 09:01:03 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com,
        Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH v3 bpf-next 4/7] selftests/bpf: split off tracing-only helpers into bpf_tracing.h
In-Reply-To: <20191003212856.1222735-5-andriin@fb.com>
References: <20191003212856.1222735-1-andriin@fb.com> <20191003212856.1222735-5-andriin@fb.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 04 Oct 2019 09:01:03 +0200
Message-ID: <87zhihngeo.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: O8IO1JQYOxahW2p4UA7EvA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andriin@fb.com> writes:

> Split-off PT_REGS-related helpers into bpf_tracing.h header. Adjust
> selftests and samples to include it where necessary.
>
> Acked-by: John Fastabend <john.fastabend@gmail.com>
> Acked-by: Song Liu <songliubraving@fb.com>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

