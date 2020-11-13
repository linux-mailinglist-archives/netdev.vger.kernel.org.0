Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDAFA2B1382
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 01:50:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726148AbgKMAud (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 19:50:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725929AbgKMAuc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 19:50:32 -0500
Received: from mail-oo1-xc42.google.com (mail-oo1-xc42.google.com [IPv6:2607:f8b0:4864:20::c42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77D3FC0613D1;
        Thu, 12 Nov 2020 16:50:31 -0800 (PST)
Received: by mail-oo1-xc42.google.com with SMTP id h10so212354ooi.10;
        Thu, 12 Nov 2020 16:50:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=2DtYk9HZqyEvMEaETEH6zalA/3XhQS1k0ZsPubjYnnk=;
        b=t0GmFoXmGbiGv+heed+HCO88cXvVm1/t29g3XKiIQIukIb4zdXRVeHR+Lrae5OqHDx
         qAJw3gJG8ZC5/8C8DrOU9bsiDEkKM9FYVyfHNVPMO8GYELkL5BfPP+dLMyYIvL4/n6B4
         7ThEO1cmNq5i7MZF/VdKyNp9bFsXj1EDlqtQMv9leH46OsyQPdWA+438jQ8XbPdQdy7U
         w7Xsr1laomxfEgaSCs8M713mLQZ7nGnfAXLqxZR3LRIyf9vRkdWzSy2Obw2Q9NCfT5v0
         z27AEKoYq+/ctHEl1DY/UKT4K4B2+PwWY5kbwvyN5Q/ecESWExRoYMUnXqhkL1PPqkxD
         zQLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=2DtYk9HZqyEvMEaETEH6zalA/3XhQS1k0ZsPubjYnnk=;
        b=rBDsdZjEkCuOitkwxuvPC5Ut593rG8YCm27yKZY2eAT1sQdFhzuyJm+tGnTPZJAbt5
         BrDzuUl2Y7LczLi5biKzcD8LnP/uD0FMtaAxL6h2Pt3/lKblzvzZCMF+TXnluBjHr6Q/
         wxWxt4DEc6qD3S1ZN2l7lbZlGXIBxt74rHsq1ecp9I93uxoeOwzFTJHrvdLM2JGDkIDJ
         m8GHRBdJd4ZdrZ7wyRIu2nstX62vyGAqig49mnx4XOkxgSSu2LLoea9fdHGdw3hBxDKg
         9CD4piVvnwogYNi+Nr6J9Vpl8NhleJyxy1Zp0a7WN0K7ull9ND/HVluaELBrAqxRZad7
         PI0g==
X-Gm-Message-State: AOAM5304HPaku2HyookJqxou+Ea69HUjdCYWin0kTkr2OJXijRa6saPR
        0sMqunRBmhi7+yJbEkKuKJk=
X-Google-Smtp-Source: ABdhPJwvLtc0JIfn+lIFP0Z8u7PxKexvUTiavin7UTOHeCIdojS/tl8aT4k23PgJdP+bCgDcO4MFjQ==
X-Received: by 2002:a4a:1e43:: with SMTP id 64mr1440265ooq.57.1605228630945;
        Thu, 12 Nov 2020 16:50:30 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id 85sm1530668oie.30.2020.11.12.16.50.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 16:50:30 -0800 (PST)
Date:   Thu, 12 Nov 2020 16:50:23 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
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
Message-ID: <5fadd84fc74e4_27844208d0@john-XPS-13-9370.notmuch>
In-Reply-To: <87h7pvvtk9.fsf@cloudflare.com>
References: <X6rJ7c1C95uNZ/xV@santucci.pierpaolo>
 <CAEf4BzYTvPOtiYKuRiMFeJCKhEzYSYs6nLfhuten-EbWxn02Sg@mail.gmail.com>
 <87imacw3bh.fsf@cloudflare.com>
 <X6vxRV1zqn+GjLfL@santucci.pierpaolo>
 <292adb9d-899a-fcb0-a37f-cd21e848fede@iogearbox.net>
 <87h7pvvtk9.fsf@cloudflare.com>
Subject: Re: [PATCH] selftest/bpf: fix IPV6FR handling in flow dissector
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki wrote:
> On Thu, Nov 12, 2020 at 12:06 AM CET, Daniel Borkmann wrote:
> 
> [...]
> 
> >>> I'm not initimately familiar with this test, but looking at the change
> >>> I'd consider that Destinations Options and encapsulation headers can
> >>> follow the Fragment Header.
> >>>
> >>> With enough of Dst Opts or levels of encapsulation, transport header
> >>> could be pushed to the 2nd fragment. So I'm not sure if the assertion
> >>> from the IPv4 dissector that 2nd fragment and following doesn't contain
> >>> any parseable header holds.
> >
> > Hm, staring at rfc8200, it says that the first fragment packet must include
> > the upper-layer header (e.g. tcp, udp). The patch here should probably add a
> > comment wrt to the rfc.
> 
> You're right, it clearly says so. Nevermind my worries about malformed
> packets then. Change LGTM:
> 
> Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>

Also please add some of the details discussed here to the commit msg so
we can remember this next time. 

Thanks!
