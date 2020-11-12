Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C15122B0175
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 10:00:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725979AbgKLJAN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 04:00:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725995AbgKLJAL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 04:00:11 -0500
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07A8FC0613D4
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 01:00:10 -0800 (PST)
Received: by mail-lf1-x141.google.com with SMTP id d17so7146275lfq.10
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 01:00:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=6hq1Ugv3HkONjgb2TpIAbqEThyFQQyw3Au9DYtN5sqo=;
        b=dlRZk+ptqphaGEnbeS4FBLHGHSycXqm81pivADn5zLixb/0WuNC3Nv+3BkIPc/2bi5
         aD5MPdoTphBw3cL1Hkx6NO7Qdv6McoWaVDQH4JmCHuXpDjjZAUXAS3gFerqTQOEVz4W2
         bXK5FHEMiMoHScuK2sC1br0HL3tbBc0FZbwXg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=6hq1Ugv3HkONjgb2TpIAbqEThyFQQyw3Au9DYtN5sqo=;
        b=IIbhsEkTHAdqMwM7+w/EEha3dhO6hFdD40wl4clCEJOofUMrNSJjKZMDxVsVAUOc3E
         J17R/89ZhrxGkLwAUhjsKOmComViSLaWmiSrxctUCrh7odt55QbDrnmLUvfbGGV/U0HP
         F8ZEFFVr01FKjIK4/7wcIozZeP9LDcpmcma0Blvf8prVvsAyikpkxlWGcf2PMw4yx2gF
         YMd4Gbj0+Id5B00rb8b1+bhtF6iQYu74OzQEpS/U1hyCv5xdRRfu1aeVy5P6n18b70zo
         EbH8TS4Vb3Gkn7NmoouJhIR+bfKV1ZN0m7oFpN5AqYrC24X+a7GUzRxoON0tjUA5fFwj
         QH3g==
X-Gm-Message-State: AOAM531kYM624+NW6py6CGqspNK5zexH17M6fhr7qJvdjMr0+joH5r5c
        A22xhWu9+wPALwfaNNQyEK9C2Q==
X-Google-Smtp-Source: ABdhPJwkLX0tbuLgl+cGAeACPaweC5UrkY8OHb9dP3CA9ymo1IWJVv4o8CJHQs+bJpeI8L6QKJqQGw==
X-Received: by 2002:ac2:515b:: with SMTP id q27mr11462732lfd.123.1605171608405;
        Thu, 12 Nov 2020 01:00:08 -0800 (PST)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id 129sm487138lfg.214.2020.11.12.01.00.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 01:00:07 -0800 (PST)
References: <X6rJ7c1C95uNZ/xV@santucci.pierpaolo> <CAEf4BzYTvPOtiYKuRiMFeJCKhEzYSYs6nLfhuten-EbWxn02Sg@mail.gmail.com> <87imacw3bh.fsf@cloudflare.com> <X6vxRV1zqn+GjLfL@santucci.pierpaolo> <292adb9d-899a-fcb0-a37f-cd21e848fede@iogearbox.net>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Santucci Pierpaolo <santucci@epigenesys.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        sdf@google.com
Subject: Re: [PATCH] selftest/bpf: fix IPV6FR handling in flow dissector
In-reply-to: <292adb9d-899a-fcb0-a37f-cd21e848fede@iogearbox.net>
Date:   Thu, 12 Nov 2020 10:00:06 +0100
Message-ID: <87h7pvvtk9.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 12, 2020 at 12:06 AM CET, Daniel Borkmann wrote:

[...]

>>> I'm not initimately familiar with this test, but looking at the change
>>> I'd consider that Destinations Options and encapsulation headers can
>>> follow the Fragment Header.
>>>
>>> With enough of Dst Opts or levels of encapsulation, transport header
>>> could be pushed to the 2nd fragment. So I'm not sure if the assertion
>>> from the IPv4 dissector that 2nd fragment and following doesn't contain
>>> any parseable header holds.
>
> Hm, staring at rfc8200, it says that the first fragment packet must include
> the upper-layer header (e.g. tcp, udp). The patch here should probably add a
> comment wrt to the rfc.

You're right, it clearly says so. Nevermind my worries about malformed
packets then. Change LGTM:

Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
