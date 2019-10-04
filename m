Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25413CB4B1
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 09:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388463AbfJDHAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 03:00:22 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:22503 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388457AbfJDHAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 03:00:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1570172420;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8EyK1cVKkhMxyArw12T8tYjEZqilSb7AABG3zI0Hp2E=;
        b=S9AUDOVwYkuUNCelYiVuDwtNyFY7r2h+KotQ7Nb9CMoTCNwCittd91uvEXiQ64RQbSwHem
        oMYRXDFfRpCkclniBwctftnSonFFHgbA5R9eo640gShU+SAVrpA3eYQk3x1iOXS1YYiMvp
        62a1PuLKXKdyMTXMGT7P001pOfOMbR8=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-214-PcL62gIwPBaCSyHHPcNgOQ-1; Fri, 04 Oct 2019 03:00:18 -0400
Received: by mail-lj1-f200.google.com with SMTP id m22so1482331ljj.6
        for <netdev@vger.kernel.org>; Fri, 04 Oct 2019 00:00:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=8EyK1cVKkhMxyArw12T8tYjEZqilSb7AABG3zI0Hp2E=;
        b=fujhUDXyRw7J/DJYa597Z4SfwKBUuy+gJ2flEmZV4v9YFrMUI5B1qUD0W78JvrYz6N
         x+JAIa/gvLbcd1VSc0oiGE4rLe/yxVmmJGDpJpvSwd6dJ85WFzKo5HrlzuG3cnOaW70n
         Z+zu5+ITTDKVZatzoA2zE/Yzit6lY6EDzNg0IfYpwPzgGSQLwgjic87f6pOZr8plR6mP
         Az+PIocx2GV4dB9WQyWnICF4/zYum4+iqMAvDR1/oGLBlSvPPTExxIf28JS/doozpVaH
         PLiA14NDwNH3y4fjpzPAftF8AQAATxaE+SbBmZI227M5mS0YPKaboGAEkBYw9Si010lS
         SCZg==
X-Gm-Message-State: APjAAAXrsA/C7F6tAh4DAJ9GuIry4F/7tXIe60Zl5J8BkqRUbRCHL3eB
        hx/8AbzUQntEP6EWtJrGiHTaAFGDw0AuGWG1ILccG38sXefVz4ZWpkjisw5PhaPt7m5iHnIkNn0
        HRmC2pdLQCcj5wfYL
X-Received: by 2002:a2e:b1ce:: with SMTP id e14mr8281163lja.135.1570172417109;
        Fri, 04 Oct 2019 00:00:17 -0700 (PDT)
X-Google-Smtp-Source: APXvYqz51eZ7+KoSwTzay+lh1nndT6s8FnzF2hCCR7+MAAVdzubj44stcpUFZ/rmV5qe5rZz4nM3EQ==
X-Received: by 2002:a2e:b1ce:: with SMTP id e14mr8281154lja.135.1570172416979;
        Fri, 04 Oct 2019 00:00:16 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id b7sm930591lfp.23.2019.10.04.00.00.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Oct 2019 00:00:16 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id B2D9218063D; Fri,  4 Oct 2019 09:00:15 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com,
        Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH v3 bpf-next 2/7] selftests/bpf: samples/bpf: split off legacy stuff from bpf_helpers.h
In-Reply-To: <20191003212856.1222735-3-andriin@fb.com>
References: <20191003212856.1222735-1-andriin@fb.com> <20191003212856.1222735-3-andriin@fb.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 04 Oct 2019 09:00:15 +0200
Message-ID: <8736g9ov0g.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: PcL62gIwPBaCSyHHPcNgOQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andriin@fb.com> writes:

> Split off few legacy things from bpf_helpers.h into separate
> bpf_legacy.h file:
> - load_{byte|half|word};
> - remove extra inner_idx and numa_node fields from bpf_map_def and
>   introduce bpf_map_def_legacy for use in samples;
> - move BPF_ANNOTATE_KV_PAIR into bpf_legacy.h.
>
> Adjust samples and selftests accordingly by either including
> bpf_legacy.h and using bpf_map_def_legacy, or switching to BTF-defined
> maps altogether.
>
> Acked-by: John Fastabend <john.fastabend@gmail.com>
> Acked-by: Song Liu <songliubraving@fb.com>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

