Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3683244EE14
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 21:44:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235831AbhKLUrN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 15:47:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235833AbhKLUrM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 15:47:12 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52B66C0613F5
        for <netdev@vger.kernel.org>; Fri, 12 Nov 2021 12:44:21 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id z10so16104939edc.11
        for <netdev@vger.kernel.org>; Fri, 12 Nov 2021 12:44:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=55PU7NCx+y3qp+yVH779Q0TOGJYQ+3HFYI6HIRyxT3U=;
        b=htlSI9PbweXay3zAqrSqMP+DpA1ClH8JSrIOkKm4ThM5VQWQeSQcQTuWqsEfU+IDbe
         QIUllEebtflPJL8Cv/ENnzIJTDRXjeJPxnccsg30WJ4yh/6GCPQx8bZfjt8NAF4Bh6Vd
         1rJPvM8EESgHfctOmZ+HPr1SV7NkIGVI9BqW0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=55PU7NCx+y3qp+yVH779Q0TOGJYQ+3HFYI6HIRyxT3U=;
        b=FpR58mxB1aJWotmp2JDus0+8/FToEHuPtx5eb7SSuhSL9oQV6mpB6lbFdkfcWlXugz
         kqxun70HK/RrLxoeaS4UrkhGmgY8VJDAzo0/wyl/RGaWDlx28K6hKVP4dzkJu51sqppW
         mObflS8d4bH+MLidOV2IuQT5eZT8iu6O3VEtypGUqHtnN3uPp8dJowsSv3FfVr5a+Fds
         yRLufjyFtGo5KCtyn7EQXb2DI5DTgysLMGP10/7WF3zIB7Duv22VOrdhV9AvhgJjXmxf
         nToRTdgeG+K3R2Y7csPQ0V+eatn+HuT0xxMDC8Pdfof7sbyHtbdgLsqdx1JunNlH/Fu4
         ZURw==
X-Gm-Message-State: AOAM530JVpTrXLVOMlG42OKfa4GBuBi8lH2BeW4g2ekn5Ifs1yBtDTVD
        UfLBpbiienfnAy6AZtXsAAn13/O03kmCNvHoaeg=
X-Google-Smtp-Source: ABdhPJxLq4EhUbZfuJ/bZDsoY93QldFyRX/2hyC/ZyJFmZiCn26f/NSnWRZjSk/xtGV2S+1goa4uag==
X-Received: by 2002:a17:907:9156:: with SMTP id l22mr22895428ejs.220.1636749859469;
        Fri, 12 Nov 2021 12:44:19 -0800 (PST)
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com. [209.85.221.44])
        by smtp.gmail.com with ESMTPSA id y15sm3628434edd.70.2021.11.12.12.44.17
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Nov 2021 12:44:18 -0800 (PST)
Received: by mail-wr1-f44.google.com with SMTP id c4so17610161wrd.9
        for <netdev@vger.kernel.org>; Fri, 12 Nov 2021 12:44:17 -0800 (PST)
X-Received: by 2002:adf:dcd0:: with SMTP id x16mr22056131wrm.229.1636749857666;
 Fri, 12 Nov 2021 12:44:17 -0800 (PST)
MIME-Version: 1.0
References: <20211111163301.1930617-1-kuba@kernel.org> <163667214755.13198.7575893429746378949.pr-tracker-bot@kernel.org>
 <20211111174654.3d1f83e3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <CAHk-=wiNEdrLirAbHwJvmp_s2Kjjd5eV680hTZnbBT2gXK4QbQ@mail.gmail.com>
In-Reply-To: <CAHk-=wiNEdrLirAbHwJvmp_s2Kjjd5eV680hTZnbBT2gXK4QbQ@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 12 Nov 2021 12:44:01 -0800
X-Gmail-Original-Message-ID: <CAHk-=wi=w9_TXkQF9P5KranoL_=ChVQyahjecMo1wzRTe0UtEg@mail.gmail.com>
Message-ID: <CAHk-=wi=w9_TXkQF9P5KranoL_=ChVQyahjecMo1wzRTe0UtEg@mail.gmail.com>
Subject: Re: 32bit x86 build broken (was: Re: [GIT PULL] Networking for 5.16-rc1)
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        linux-can@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 11, 2021 at 6:48 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>   +#include <linux/io-64-nonatomic-lo-hi.h>

I committed that fix just to have my tree build on x86-32.

If the driver later gets disabled entirely for non-64bit builds,
that's fine too, I guess. Presumably the hardware isn't relevant for
old 32-bit processors anyway.

                Linus
