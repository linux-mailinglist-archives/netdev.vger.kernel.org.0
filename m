Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 539BB26238A
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 01:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729449AbgIHXW7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 19:22:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728297AbgIHXWz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 19:22:55 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67AD5C061755
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 16:22:55 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id v196so601163pfc.1
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 16:22:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8vw8y/keL8WobWtmOV5HZRJN8/Uakg/hovhFlM5RtH0=;
        b=dhgVv6ytoDhKtI7epFtTsWzhO99dRLXs9qP6tHOGr0W9iPEBMxhPEYFzCPy4e45x1p
         iv7oDHrhvzoFHFQbgnieeDK9qlcnx9jCxpTM73Wv9OxRI1dQYBAzJ5GwMJlhCteDErSG
         EnPe8FFbiKqJ1TpYawiqNukVf+bzmUYQIoggE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8vw8y/keL8WobWtmOV5HZRJN8/Uakg/hovhFlM5RtH0=;
        b=Cz4J3nKCIIVf8ymE/oInpXf17iO/Tqt3ZrM+1Hn+jjMYcjBvPfj8+0ShlT1X/5CTUa
         d0/tp2k5NB3pZo58kfNYyeb6mI59eY6XXuWIP4+jddxdj12b2/oppCZ/0remojSo0Hqd
         Bbv9l4CIImDhrD+zErY+AH+NzdwvrG9r5RJVORZfM+brJQhMgF4MXne1NW4tb2O3aTWv
         Kf+tc6Ml4Qa5rIzZcGJ/KAjDKkhUac+IkXI6s+f6vDWm5wonwsH2zGYtUO/zoY4+vH7B
         jqDoMAQAsvFpXpFDNw6yrmy3J1C4HS485im/mXnNkjtMK6pPj2pIqxaxVmRgD5nhMlTl
         Hjxg==
X-Gm-Message-State: AOAM532mWqObgU3Mdg8epggx1C27/KMa9+8Q41XHSNP+bb7pA8/8p0q0
        lJS74mxfvk/6aiVuGjh1xguveg==
X-Google-Smtp-Source: ABdhPJyWsjXkHCgvBe7fbOxyDUTgQ0nowPHAXIjoEPMa62KZxAej8RSYGYurVX5t0SOTnFuQ0UNLDw==
X-Received: by 2002:aa7:942a:: with SMTP id y10mr1046719pfo.68.1599607374934;
        Tue, 08 Sep 2020 16:22:54 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id 194sm474000pfy.44.2020.09.08.16.22.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2020 16:22:54 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     kafai@fb.com, songliubraving@fb.com,
        linux-kselftest@vger.kernel.org, luto@amacapital.net,
        wad@chromium.org, daniel@iogearbox.net, john.fastabend@gmail.com,
        kpsingh@chromium.org, shuah@kernel.org, netdev@vger.kernel.org,
        Zou Wei <zou_wei@huawei.com>, yhs@fb.com, andriin@fb.com,
        bpf@vger.kernel.org, ast@kernel.org, linux-kernel@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH -next] selftests/seccomp: Use bitwise instead of arithmetic operator for flags
Date:   Tue,  8 Sep 2020 16:22:12 -0700
Message-Id: <159960731879.1678444.6814133998182138035.b4-ty@chromium.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <1586924101-65940-1-git-send-email-zou_wei@huawei.com>
References: <1586924101-65940-1-git-send-email-zou_wei@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Apr 2020 12:15:01 +0800, Zou Wei wrote:
> This silences the following coccinelle warning:
> 
> "WARNING: sum of probable bitmasks, consider |"
> 
> tools/testing/selftests/seccomp/seccomp_bpf.c:3131:17-18: WARNING: sum of probable bitmasks, consider |
> tools/testing/selftests/seccomp/seccomp_bpf.c:3133:18-19: WARNING: sum of probable bitmasks, consider |
> tools/testing/selftests/seccomp/seccomp_bpf.c:3134:18-19: WARNING: sum of probable bitmasks, consider |
> tools/testing/selftests/seccomp/seccomp_bpf.c:3135:18-19: WARNING: sum of probable bitmasks, consider |

Applied, thanks!

[1/1] selftests/seccomp: Use bitwise instead of arithmetic operator for flags
      https://git.kernel.org/kees/c/76993fe3c1e4

Sorry for the massive delay on this one! I lost this email in my inbox. :)

-- 
Kees Cook

