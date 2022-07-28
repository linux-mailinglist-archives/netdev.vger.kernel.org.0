Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0817D58465D
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 21:33:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232233AbiG1TZP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 15:25:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiG1TZO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 15:25:14 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 473A9E0F8;
        Thu, 28 Jul 2022 12:25:13 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id sz17so4769829ejc.9;
        Thu, 28 Jul 2022 12:25:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+nd3xWw/+xpI7ARgc/j2G7d8IiJiJdGQQa3VBgVmZns=;
        b=F66GekNEaaXlRQyZmd6KX5IWAU1BmC9GMwIdl94kDExbkN4t7sc0Tux8F3ZeBKUJia
         Di0bsnewus0VWoPR/z0t7XCLHyqFAl6b55UAufrFTSgDDbD3wI4HBpvM8luLPjQWJ0pa
         AKeDoJkHdbvtVwHFGodm8h2USGYqWS2SBFOKiviwi3lnlLrFfYYs5ke6ZqFV5jGcqVAN
         2Ir1A7zvq4JIZZLszwqHG/vRvjzLGKoRlRxT5mCK2EEq9I1U9yUT+bkjBJ6vh363xax1
         mZzQxzw9IrAy+vhu2lFW7F5hWvtaUK9vFZ1WN8aXzwp8RrRoRNd+KNYC10LYRDOQ3KD4
         TNBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+nd3xWw/+xpI7ARgc/j2G7d8IiJiJdGQQa3VBgVmZns=;
        b=NZLhKeiF/WvQsC8C/fqrJyFWDRvsSv9IcZwEdU2isFdpJIg3FGc7s78FaZQJovsRb2
         3alvcNEZkd2a27KEqM8oVOVYeWLMCGL+MayI6u6s2Uf4OYBumKB0e0ivaaa1FEAN6h6J
         yyljIzLhbYNagKh1y6iwJx4AnasF0j2jiEr/zTwJvAMqSaOkT1iJTNsfApoto2/yQiBA
         tDsOYKOPzr+P70G8WRCJpwziPucIXIYB53Kt+fwiKhGP1QZL/rv2tlTHBeDwfwXmGi3s
         mVoMTlRv/XRDYE2AktZBiPXn5a4qJE+EUpTYNveVnz1rWw0bfzg7I+Buy0xCQ87ak4PS
         iZAQ==
X-Gm-Message-State: AJIora/rylBQQp4A2LJA3a2Ls5E0AbpYRV+vVPMWx3pc7NYV3X65A4pP
        YEU4/Oi0OHvfVgoxHfX+dTq1BlI7qdsY+6AIstA=
X-Google-Smtp-Source: AGRyM1vfB2WR2rUqrfFCsddh+QvpH9yzIki2IHTu9uyZcvpDsdZlbfoqc9fPBtk/wCJG2jH7aPmYJffGvF6Min/lQME=
X-Received: by 2002:a17:907:97d6:b0:72f:97d9:978d with SMTP id
 js22-20020a17090797d600b0072f97d9978dmr287285ejc.684.1659036311369; Thu, 28
 Jul 2022 12:25:11 -0700 (PDT)
MIME-Version: 1.0
References: <CANX2M5Yphi3JcCsMf3HgPPkk9XCfOKO85gyMdxQf3_O74yc1Hg@mail.gmail.com>
 <Ytzy9IjGXziLaVV0@kroah.com> <CANX2M5bxA5FF2Z8PFFc2p-OxkhOJQ8y=8PGF1kdLsJo+C92_gQ@mail.gmail.com>
 <Yt1MX1Z6z0y82i1I@kroah.com>
In-Reply-To: <Yt1MX1Z6z0y82i1I@kroah.com>
From:   Dipanjan Das <mail.dipanjan.das@gmail.com>
Date:   Thu, 28 Jul 2022 12:24:59 -0700
Message-ID: <CANX2M5aX=JnKD-8kPyAN0Q64HvLoSO+3LvNvuaxkexCgeDWZHA@mail.gmail.com>
Subject: Re: general protection fault in sock_def_error_report
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        sashal@kernel.org, edumazet@google.com,
        steffen.klassert@secunet.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        syzkaller@googlegroups.com, fleischermarius@googlemail.com,
        its.priyanka.bose@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 24, 2022 at 6:43 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> It is worth the effort if the problem is still in the latest kernel
> release as that is the only place that new development happens.

The problem does not exist in the latest release.

> If the issue is not reproducible on Linus's current releases, then finding the
> change that solved the problem is also good so that we can then backport
> it to the stable/long term kernel release for everyone to benefit from.

The change that solved the issue in the mainline is this:
341adeec9adad0874f29a0a1af35638207352a39

Here is one additional piece of information that you may find useful.
Though we originally reported the bug for the longterm release
v5.4.206, we noticed that the same issue exists in another longterm
release v5.10.131, too. We manually bisected the commits in those two
longterm branches to find the bug-introducing commits. We observe that
the commits d6e981ec9491be5ec46d838b1151e7edefe607f5 and
ff6eeb627898c179aac421af5d6515d3f50b84df introduced the bug in 5.4.y
and 5.10.y branches, respectively.

-- 
Thanks and Regards,

Dipanjan
