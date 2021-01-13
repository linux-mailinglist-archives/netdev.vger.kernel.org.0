Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A3C52F5795
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 04:00:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729445AbhANCCM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 21:02:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729389AbhAMXWY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 18:22:24 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90F58C0617A9;
        Wed, 13 Jan 2021 15:07:42 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id y12so2038743pji.1;
        Wed, 13 Jan 2021 15:07:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=m4PIDzYT3CXhoACwt4A5q0aBFravQnGjz5z9j8ZUsEY=;
        b=kSQ5AATGqJZ1OZcYKgwWY5EamTo6erdhBn8bkSwXMwNhcF7BCVo9sbg80BYZt14h/X
         WRETpPnEcpfjBwMcAfT6nVWS7rl/zjTc9uqDfmVBydaJkiH80gHIpSxxTchw7nacf0Za
         gh6XJyD2mZnCktbfjPnCPtUk3wBxDscxfYH+Ryrx1jozwqwLS+f8wSKLkE6kHDFFhjJS
         ly7S4GM7zj3gxUKPbS9xxituOC9XKYq4TouBRaDT0BfiNP9YFap3ZtsIfWH9gY2H/XRQ
         XUuOCy9Y1L1RkUbq8pLQhTxUo/UG03EVThoUtbWoL8uLja4Xh6ARab+sw1wtdeCWR+xL
         73ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=m4PIDzYT3CXhoACwt4A5q0aBFravQnGjz5z9j8ZUsEY=;
        b=d/CuTKqHDrAXaXxDmvUY2cnYkOV4uYeC35p4/83X04DMESNMn6pGX/oR+vkT3YDSOx
         Mmycbuy/4M5gpu51GncIxQqaoMiKD94KjE+7NTQQJbv/b9dPKa7lMKfVj70cPCyTIMWu
         XfXvePhUrHPJNcCo4F76gQpsyn9fyL7w1LRfHzRNmw5H8bqctUtZPnKVF1GSC8ruJnZG
         KB0MYcXsliijIJf0NfJxxKZoUoNZd6CjrO48ehc3pP9KwchvonRgIEs/HRJl6nDt5e8i
         /61ID96si6kHVciCFmWWfsOdZen2HpFVQ7C7tUfv4wcmy2PktB805bpiR85KEwvf3ngP
         EfLw==
X-Gm-Message-State: AOAM531zzS5GiCPv+au5QzZjzKmJDMQUmBPyAUy6dd3wK+9wJWJBZ1Dg
        NdYRLtFxEehminafAtVJ3ao=
X-Google-Smtp-Source: ABdhPJxQjXFrORq7aRfjX5AzuzrkieozDdbOI+BgMpe3PbPu7LmqaHSUfdR9PjmJQind1uC0ObZucQ==
X-Received: by 2002:a17:90a:fd08:: with SMTP id cv8mr1652767pjb.29.1610579261988;
        Wed, 13 Jan 2021 15:07:41 -0800 (PST)
Received: from Ryzen-9-3900X.localdomain (ip68-104-204-241.ph.ph.cox.net. [68.104.204.241])
        by smtp.gmail.com with ESMTPSA id t1sm3515705pfq.154.2021.01.13.15.07.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jan 2021 15:07:41 -0800 (PST)
Date:   Wed, 13 Jan 2021 16:07:39 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Sedat Dilek <sedat.dilek@gmail.com>
Subject: Re: [PATCH] bpf: Hoise pahole version checks into Kconfig
Message-ID: <20210113230739.GA22747@Ryzen-9-3900X.localdomain>
References: <20210111180609.713998-1-natechancellor@gmail.com>
 <CAK7LNAQ=38BUi-EG5v2UiuAF-BOsVe5BTd-=jVYHHHPD7ikS5A@mail.gmail.com>
 <20210111193400.GA1343746@ubuntu-m3-large-x86>
 <CAK7LNASZuWp=aPOCKo6QkdHwM5KG6MUv8305v3x-2yR7cKEX-w@mail.gmail.com>
 <20210111200010.GA3635011@ubuntu-m3-large-x86>
 <CAEf4BzaL18a2+j3EYaD7jcnbJzqwG2MuBxXR2iRZ3KV9Jwrj6w@mail.gmail.com>
 <CAEf4Bzbv6nrJNxbZAvFx4Djvf1zbWnrV_i90vPGHtV-W7Tz=bQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4Bzbv6nrJNxbZAvFx4Djvf1zbWnrV_i90vPGHtV-W7Tz=bQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 13, 2021 at 02:38:27PM -0800, Andrii Nakryiko wrote:
> Hm.. Just saw Linus proposing using $(error-if) in Kconfig for an
> unrelated issue ([0]). If we can make this work, then it would catch
> such issue early on, yet won't have any downsides of hiding
> CONFIG_DEBUG_INFO_BTF if pahole is too old. WDYT?
> 
>   [0] https://lore.kernel.org/lkml/CAHk-=wh-+TMHPTFo1qs-MYyK7tZh-OQovA=pP3=e06aCVp6_kA@mail.gmail.com/

Yes, I think that would be exactly what we want because DEBUG_INFO_BTF
could cause the build to error if PAHOLE_VERSION is not >= 116. I will
try to keep an eye on that thread to see how it goes then respin this
based on anything that comes from it.

Cheers,
Nathan
