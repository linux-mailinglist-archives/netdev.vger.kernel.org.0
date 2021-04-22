Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AD72367E18
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 11:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235513AbhDVJsi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 05:48:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230285AbhDVJsh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 05:48:37 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CF7CC06174A
        for <netdev@vger.kernel.org>; Thu, 22 Apr 2021 02:48:02 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id t14-20020a05600c198eb029012eeb3edfaeso2874425wmq.2
        for <netdev@vger.kernel.org>; Thu, 22 Apr 2021 02:48:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tigera.io; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=e0wB+8LWoSHa2GesXosjoVr98ClHI2C+EzkIcTmgClI=;
        b=WwS3aZBqFszFrbR1qs6xGYxOyqDpPkFY2r3EF63TXkGOWh65REBH5gHGdw/I2aXQsC
         0+FU/fRKQzsDoNmCujV4Y+q3EFmIyvhtnZXg5NRaeCs6puMWImxLCcPxhUAgpH4HVTPC
         WXMFNyXTtRkJ/RtqyEgjO441hqsFI9yOZjqME=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=e0wB+8LWoSHa2GesXosjoVr98ClHI2C+EzkIcTmgClI=;
        b=pA3KUUnDO0gLhYINn4TkNEfjU0XUYnX7fB+uyD59Qawtd6V9iGkpHNS9HT+NpaYh4/
         qOwkGJgYwS44I7l8pt6VEpnhXzGIm1g03etEYvHkQ7rjl/lJ1XPlBf1P04mST9xQuw5l
         meGysOR1aR5gETbUruUg31S+Aidzxq0fmhdz5Ak4oXWRuDLh2ljwJHUJ9kpcA0xbATiN
         eRUlJ5L4Ynbv9yCP0TfON5n2T8J7T9Z7jNTdE4idZxpHb3Jt0F6oH5dW0PWAjXmT7UkJ
         IodfHbO2vUf8mG+3xTMPrapiPRX8SBApN6aYv7Rx1j5criaWgkxCxGh8vIAr8rvJtjoi
         W6Sg==
X-Gm-Message-State: AOAM531sMHoU0sF9tPCnjSQJ480cbAUxIu2jNVpGXHCTOI+PFbv24Bn/
        dBYu2fF1RosV1le6z0GOajaxfZTb/o04j9giTE7hrw==
X-Google-Smtp-Source: ABdhPJxDtSxcLvikHxQEhHxlbbW6PsL6kkqYQSnRdfqxv0h5SdqoKOlPazhs9irT5B/Zj/3Qw+9dRgEn12X8kEBoDUA=
X-Received: by 2002:a1c:a78b:: with SMTP id q133mr2939987wme.68.1619084880811;
 Thu, 22 Apr 2021 02:48:00 -0700 (PDT)
MIME-Version: 1.0
References: <20210420193740.124285-1-memxor@gmail.com> <20210420193740.124285-3-memxor@gmail.com>
 <9b0aab2c-9b92-0bcb-2064-f66dd39e7552@iogearbox.net> <20210421230858.ruwqw5jvsy7cjioy@apollo>
 <21c55619-e26d-d901-076e-20f55302c2fd@iogearbox.net> <20210421233054.sgs5lemcuycx4vjb@apollo>
 <b504c839-d698-19a2-2018-05f867a8ff84@iogearbox.net>
In-Reply-To: <b504c839-d698-19a2-2018-05f867a8ff84@iogearbox.net>
From:   Shaun Crampton <shaun@tigera.io>
Date:   Thu, 22 Apr 2021 10:47:50 +0100
Message-ID: <CAMhR0U1DRBw5AjzzLfN+bpnxsrONO_Jkr9p57yfeyCND+qMAtQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 2/3] libbpf: add low level TC-BPF API
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>, bpf@vger.kernel.org,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Nope, just get it from the prog itself.

Looks like the API returns the prog ID, so from that we can look up the prog
and then get its tag? If so that meets our needs.  Alternatively, if
the API allows
for atomic replacement of a BPF program with another, that'd also work for us.

The use case is that our daemon is restarted and it doesn't know what BPF
program was previously loaded. We want to make sure we end up with the
latest version loaded, either by doing a seamless replace with the
latest version
or by checking if the loaded version matches the latest.
