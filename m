Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0CD1CB4B9
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 09:01:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388501AbfJDHBZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 03:01:25 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:46419 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387822AbfJDHBY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 03:01:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1570172483;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=a7sKR8lHgOs//1ZX2JG7IaLVTQKiw5ft09FgGbhCp5w=;
        b=d2rAk+exnNhp6c+VPqhXR11XdGaH43SKAonfCifK/fQC5iloS7CELmC1I8m/jzfapRS9vv
        irRNd6u/kwDWNIlc5TdSLKOg6z9kFxHZWY3cH74/7wK73nti1yXtdycZOMPJXRWtUc0R7u
        /jxrMr8iU8PKOHikJQPjv+3hr9+95AI=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-267-ZNJpzarMMra5Lav1TFU1og-1; Fri, 04 Oct 2019 03:01:17 -0400
Received: by mail-lj1-f197.google.com with SMTP id v24so1471441ljh.23
        for <netdev@vger.kernel.org>; Fri, 04 Oct 2019 00:01:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=a7sKR8lHgOs//1ZX2JG7IaLVTQKiw5ft09FgGbhCp5w=;
        b=eBoQtx/8Op8neC2g95hNpL8jBRyHP+vrwU3H1zGbuxvHC6ns1udpEMVJnkZylYvELM
         SqTmXnfUAtD48QLMh6sYe6ugtmgcJ8+VUnO7820J2h/EPxRWfuOPPudU01fTya+zRIvM
         FjhOmVB7NyOgzc63AhMr7TNWy+7H0VW+3WCpbusI68MUegtXVdXXZGrm4trOAuXRRunl
         NOBfzYaXlSmeeqUzssFI8eZPff5hFji7QPOVzLu0DDx5TqCZdX9zE4gN/mhI/i9sBSss
         KLRvs6EVGPAvMQOOGysppwrYhUw3oEkFmpxyoCFJ0V4rx6sybtnT3U+ca8py/dBllmiI
         Ex2Q==
X-Gm-Message-State: APjAAAX7U3r2Me3dqg0mBkowYKPyTG5ygpBeEEWjQLAKkI6dP8AHAtv4
        WNLhL3FukxLwe+lnGHxO0qkI6tiXAhoFAvXYnvzT+fbEvk5mNiqvXj1r1nl07/e0KVhHi/hG//y
        pZzMFqADa5TLqEWF8
X-Received: by 2002:a19:f707:: with SMTP id z7mr8256038lfe.142.1570172476456;
        Fri, 04 Oct 2019 00:01:16 -0700 (PDT)
X-Google-Smtp-Source: APXvYqw+qyv0vaXwIRlImnSQAdgUqEb2zspoEtsVo+p2JoY74DJrgQ85FcFAdWogs4yc+OsyRLhy9A==
X-Received: by 2002:a19:f707:: with SMTP id z7mr8256021lfe.142.1570172476094;
        Fri, 04 Oct 2019 00:01:16 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id n5sm1333942ljh.54.2019.10.04.00.01.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Oct 2019 00:01:15 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id D46F618063D; Fri,  4 Oct 2019 09:01:14 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com,
        Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH v3 bpf-next 5/7] libbpf: move bpf_{helpers,endian,tracing}.h into libbpf
In-Reply-To: <20191003212856.1222735-6-andriin@fb.com>
References: <20191003212856.1222735-1-andriin@fb.com> <20191003212856.1222735-6-andriin@fb.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 04 Oct 2019 09:01:14 +0200
Message-ID: <87wodlnged.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: ZNJpzarMMra5Lav1TFU1og-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andriin@fb.com> writes:

> Move bpf_helpers.h, bpf_tracing.h, and bpf_endian.h into libbpf. Ensure
> they are installed along the other libbpf headers. Also, adjust
> selftests and samples include path to include libbpf now.
>
> Acked-by: Song Liu <songliubraving@fb.com>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

