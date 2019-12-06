Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F1311158A7
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 22:30:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726414AbfLFVao (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 16:30:44 -0500
Received: from mail-lj1-f169.google.com ([209.85.208.169]:35981 "EHLO
        mail-lj1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726330AbfLFVao (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Dec 2019 16:30:44 -0500
Received: by mail-lj1-f169.google.com with SMTP id r19so9195118ljg.3
        for <netdev@vger.kernel.org>; Fri, 06 Dec 2019 13:30:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=k0AxtQz+D7li61OwD0X5pV6PAQ8uw+d579qmg3IG/Sc=;
        b=mAfmmdqYYPI+241u23YkLT5FNXAd6Us6oAhyOkFeeaChfuL8HUY/KL/aRPeC98uOjB
         jBRgJGVuaY5rSYOEiVnLD0huIwsk1PmN72pR4DaeFr6S/isdPi7syuc31sNbHp/s7iTC
         oAuG1/6vwNvlvB8iyfZgu/hd6hwR5cl5xev52EZ6lhICVdpMvQD28ICIKiVa9buPcQNo
         Sn3C+NK50zWpLU0kAZSY020jw9rqfutmkug6FQB440KyYK8ADpqOC68gnj1MYlGa+uAf
         1jbC956B7ggVWt2RP9xQJkFx7yLDkuYl5riRLDm7WgqIYVQ/MUlal1CQUtu3KLdbjdB7
         0KxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=k0AxtQz+D7li61OwD0X5pV6PAQ8uw+d579qmg3IG/Sc=;
        b=j3qM0BbsbtTQ5OvwJC9zMAxFu3W20kLc3baHzH1J2zZywOD6yP/mXi5hnUZ1vvPk5D
         3fc2oum9Ntt0xmtZ6nIZkFOHO2L8MQqLyiDg4BPcqz+/xT4TmRd0EL+F30cHBE9GQW4c
         4aJaaszHMDBLgYPhetCDEYrKGx2uhScpeQ+iYjX+22z4fBSB//5ozqh4gPIHABKCvqSr
         qJdHyP20WTLlpN93EfA5+Qu7xP9O5xoQ2JKDdUPMbyBpvvzdJr5um+2oh8y5kdItWbUt
         PS3OAc8PWjlKYpuGyDJM6J8xD3ABVeQrYUZwOFyfucLPWIh7cnh4ICDaIpfrVeEbcYiy
         H6YA==
X-Gm-Message-State: APjAAAVXxik6zOuHChydjJ6l19gk0XydkUc3JLlPgBx8hSvri24nMuZU
        Oh2kVXpzbAU9Q6neXhiyGePZl7MhxDe06kE/kgXJ
X-Google-Smtp-Source: APXvYqyZoE3a2k8tZCPJpj4lF4MwO9mGx9MdBNu06QbG8u9mHXKSYb/POTKAfMu4sAUc1UjlBg8/cUDFd3qgiyCR00Y=
X-Received: by 2002:a2e:4704:: with SMTP id u4mr9986759lja.117.1575667841756;
 Fri, 06 Dec 2019 13:30:41 -0800 (PST)
MIME-Version: 1.0
References: <20191205102552.19407-1-jolsa@kernel.org> <CAHC9VhTWnNvfMAPz-WhD9Wqv6UZZDBdMxF9VuS3UeTLHLtfhHw@mail.gmail.com>
 <20191206212746.GA30691@krava>
In-Reply-To: <20191206212746.GA30691@krava>
From:   Paul Moore <paul@paul-moore.com>
Date:   Fri, 6 Dec 2019 16:30:30 -0500
Message-ID: <CAHC9VhRv8dTXt0e9L16KXdCTs8E-fFym5tWq8y0dqPT0ghgKgw@mail.gmail.com>
Subject: Re: [PATCHv2] bpf: Emit audit messages upon successful prog load and unload
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-audit@redhat.com,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Steve Grubb <sgrubb@redhat.com>,
        David Miller <davem@redhat.com>,
        Eric Paris <eparis@redhat.com>, Jiri Benc <jbenc@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 6, 2019 at 4:28 PM Jiri Olsa <jolsa@redhat.com> wrote:
> On Fri, Dec 06, 2019 at 04:11:13PM -0500, Paul Moore wrote:
> > Other than that, this looks good to me, and I see Steve has already
> > given the userspace portion a thumbs-up.  Have you started on the
> > audit-testsuite test for this yet?
>
> yep, it's ready.. waiting for kernel change ;-)
> https://github.com/olsajiri/audit-testsuite/commit/16888ea7f14fa0269feef623d2a96f15f9ea71c9

Seeing tests for new features always makes me happy :)

-- 
paul moore
www.paul-moore.com
