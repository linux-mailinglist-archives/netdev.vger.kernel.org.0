Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A6BE2036AB
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 14:25:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728110AbgFVMZk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 08:25:40 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:59364 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728034AbgFVMZk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 08:25:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592828739;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gTNATydljRDXc8kpeNmwHEday5gWAyzDt0KL/m3GWgg=;
        b=XRIJafG37J8WLIexy8HNzz3IyNhmUq0pqNu164zklWUrxfKWwIcXvLQB/tCTG+SO6ERzUr
        1u+ldrEjs0CX9eEpqrgv+uaxxoPwrAFbKy4Bu3bz2Y+t6nUhKfp3//2Y2hMHl6N93wcAde
        EbZEIy+2gLdKws0fthHuv/JzNhOm+5A=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-98-Ii_Aul46N4ez3hs4amzP3Q-1; Mon, 22 Jun 2020 08:25:37 -0400
X-MC-Unique: Ii_Aul46N4ez3hs4amzP3Q-1
Received: by mail-wm1-f70.google.com with SMTP id g187so2991412wme.0
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 05:25:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=gTNATydljRDXc8kpeNmwHEday5gWAyzDt0KL/m3GWgg=;
        b=JOmna/wbbyYE/xqTWGTnscNu2cJwkABy64hPoOVjMJqGGnHKoLLKJ5wp4EvOw194TB
         2Hx3t4NnfkuAaahrMZ75YPCl7jqdAZ0IK8m/AKVj/AfUfsn0JM7MAHMr/l0cmeG1ehrQ
         LZqiGTprleQ6cqRkawGnNEyJKG5V8QZfoWjNxroo+rdkZb3xypdCpR+Lg99JpkVTpvDZ
         E2fWe9rRFfkQgZzMJaMCnEHX5TtOmbZwnaY47txQlIPcGsq2mf3DHYkZtkEBD4ZP+2ot
         kHnyemQo1rngBdt2d/E+/WlGvVNmV/M9UUtZgTvRlfTskIlYiHS8eoJUEA7a1+qSWNXt
         mzGQ==
X-Gm-Message-State: AOAM533SxR/LuDtCmHi2DnV8VDXsCaryiC6cy0vQcqqeWdhl6Cs8M3xm
        PdS1DyIAR2Fcbn4oNHCga3aUE55XUuUIzLeUr1mn8KG3WC9uwaXyPR3r+wHAHGPxCi7QM02Zcv3
        2VCid3K/fiaN5pGiS
X-Received: by 2002:adf:82f4:: with SMTP id 107mr18606264wrc.163.1592828736302;
        Mon, 22 Jun 2020 05:25:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxlW9JmXyeDhC/4XAHiKD+ODx7ZaqBmWyf3RIOEM2zaljWjq9f/EE5Dt+X9wT+tl2NekZO9Ew==
X-Received: by 2002:adf:82f4:: with SMTP id 107mr18606243wrc.163.1592828736064;
        Mon, 22 Jun 2020 05:25:36 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id k14sm17446948wrq.97.2020.06.22.05.25.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 05:25:35 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id AAF3C1814F6; Mon, 22 Jun 2020 14:25:32 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com,
        Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH bpf-next] libbpf: add a bunch of attribute getters/setters for map definitions
In-Reply-To: <20200621062112.3006313-1-andriin@fb.com>
References: <20200621062112.3006313-1-andriin@fb.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 22 Jun 2020 14:25:32 +0200
Message-ID: <87zh8vthhf.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andriin@fb.com> writes:

> Add a bunch of getter for various aspects of BPF map. Some of these attri=
bute
> (e.g., key_size, value_size, type, etc) are available right now in struct
> bpf_map_def, but this patch adds getter allowing to fetch them individual=
ly.
> bpf_map_def approach isn't very scalable, when ABI stability requirements=
 are
> taken into account. It's much easier to extend libbpf and add support for=
 new
> features, when each aspect of BPF map has separate getter/setter.

+1, good idea!

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

