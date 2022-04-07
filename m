Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F34DD4F83B8
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 17:41:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344931AbiDGPmG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 11:42:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344916AbiDGPmE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 11:42:04 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76EE61EAF3
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 08:39:46 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id r5so506288ybd.8
        for <netdev@vger.kernel.org>; Thu, 07 Apr 2022 08:39:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7AvsbPAce0Zm6SYyVd62fnUo12PcDxQJ27rYPHvZXRk=;
        b=fjf7AWP69YJT4yeCWiQ0Q8ftWxK8OFZ+N67gnbo3o6nyyculc49nYEaiY3+3mNt88a
         QQLOSGwOBjL0m5FpnH243EgzIiVW0onVdIFl8P3bUjyPICLjifpkeqCDmnK2l6Bjfnjo
         62kWjJW67FKBB54YHj3YItis4vE3R7Zu6RNDivVeE4mIJ8+ZOj1yVhziXuH4OTC/rKbi
         8nTk5qSSAlET0R/46a6sOmLkwZkD60zFjAI3KXQNEdkOTalUeJXvmUChKo4CP9WApCbB
         sb2adlunIsp+BM3iFfxxM09PR+36SWgToNnqj35aTpqOYIb2k5w8OurF71n4cYTnxQWO
         YluA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7AvsbPAce0Zm6SYyVd62fnUo12PcDxQJ27rYPHvZXRk=;
        b=lS96RVlDKaHG61Lz/slpZp1m5sl4v9PiP2vTfuh+rRIcVrRCoyUXVJ+okqwGrZlNHv
         Qp397d9ZVshCrFEpTuWlNXFGU9zPEfWdN2+fh6gKRE6cS58EDBQZ84BD39kddTCocsKW
         vrhzMm8eXq2WzCXjrzPNes1PT4sH2/bAyuiP7wECFU8qIjah85TSM4P3Z4jqDsAY5eiG
         92we4qHqbnqrKE9PlPJfJ5L1n6cR5e5PT5HGD7Ruz5IzMKotklcbGw2gVvGVUlxVMxNe
         EieAMSXo3aUnvM1eDmzBOQtOQc2Kwe3UqJiGH3KZlpae0TvWl5eIPAj+heeB6tO24AWN
         Eb1Q==
X-Gm-Message-State: AOAM533dwmyud0WZdeZNnlTh9Rwd6ZUSb2U6xufLjP2WuFwUfLAiDOru
        8sx9dRcPhYCH0H3Uqt2RTQ+RZ+pR/etJnNaFTnHjWQ==
X-Google-Smtp-Source: ABdhPJyhsGdF3cMRU0ODbyZoaVZ+2NHLKO70Ar7Zh7PvM+7yCGYcTkNyyLmxFo2geEJGDUM/lTdHjxS55wTDpYGiWIg=
X-Received: by 2002:a25:f441:0:b0:611:4f60:aab1 with SMTP id
 p1-20020a25f441000000b006114f60aab1mr10641308ybe.598.1649345985425; Thu, 07
 Apr 2022 08:39:45 -0700 (PDT)
MIME-Version: 1.0
References: <20220406172600.1141083-1-jeffreyjilinux@gmail.com>
 <20220406223141.51881854@kernel.org> <CAMzD94T_wo=5x5mzm6NgjgSyTrj6koCqg_ia50HeKZnGp73C6w@mail.gmail.com>
In-Reply-To: <CAMzD94T_wo=5x5mzm6NgjgSyTrj6koCqg_ia50HeKZnGp73C6w@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 7 Apr 2022 08:39:34 -0700
Message-ID: <CANn89iL=Yw1RmzH4qL1_jyM1D-aLrn-E2UiXh3YsFOZjc9y_cQ@mail.gmail.com>
Subject: Re: [PATCH net-next] net-core: rx_otherhost_dropped to core_stats
To:     Brian Vazquez <brianvv@google.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Jeffrey Ji <jeffreyjilinux@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Menglong Dong <imagedong@tencent.com>,
        Petr Machata <petrm@nvidia.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jeffrey Ji <jeffreyji@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 7, 2022 at 8:36 AM Brian Vazquez <brianvv@google.com> wrote:
>
> Looks good to me, thanks Jeffrey.
>
> Reviewed-by: Brian Vazquez <brianvv@google.com>


Reviewed-by: Eric Dumazet <edumazet@google.com>

Thank you.
