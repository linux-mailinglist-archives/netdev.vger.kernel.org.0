Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8142A41409F
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 06:38:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231527AbhIVEkE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 00:40:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbhIVEkA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 00:40:00 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FFF8C061574
        for <netdev@vger.kernel.org>; Tue, 21 Sep 2021 21:38:31 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id e7so1388476pgk.2
        for <netdev@vger.kernel.org>; Tue, 21 Sep 2021 21:38:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YcCD+2pxu1zwVRSGNmQcC+t7y8/Eh+P+UkuNbfnx/1A=;
        b=Xe+Dg8175PfNGKXONo+Uj+XDjQoJpPiKVqTXvRiv3T3Hr66l4M4RQH2sLFvhtASIyi
         P31xmvBULNB8y8P9nT9YPqJfTcy+kaisbCz0BxF9FIHQhnlTkaf8fU9WUwKLi5vYpsRV
         scfOcBJj8U/p2Gtv/Z3Zj9GY1t1qjM4tJmAlyBIBA5oaaa68yBJoNFtfbBr9Kd0mwqb8
         47YEAKt5TIHtqqRggT47UmXI9Wb97Qjafidg/uuxt9LS9R9i5N0Wma2sIU18Xo8S/d4D
         FPldwWxCBlEMG62AOFbAjRWJ7IWl+feAUeGsIRjfGiggnM7eRTUyEfz9nEz/8SFoOahD
         0Zig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YcCD+2pxu1zwVRSGNmQcC+t7y8/Eh+P+UkuNbfnx/1A=;
        b=YrN79p5aDUZq1n1JoxHhDaE5g0nsWwdoCwEwBEJpHpjtiIgq+MB4jLMnxhU/XdIn3f
         jSSsKCRiDEk1Lf4XTlkvK4Cb1ojm53BPNRmLD58OCdC6CV0ID3nG4etelosdLS4XtpzX
         OIcy39+uEzGfaIHKWt6+BpG1jgCZs9g7JbiRpZYPLYA6kWnGisZvGTfZ+AhPxdOPI/hI
         IfNeF5qmbmAawLjiVo6OTZrdgQeVhpxd9Fm6EkBn817UvZ6JrRZSVidPtL0eL47ya10r
         v13hQImasDfeGS0Ra3y5Pftkv2HLyht850HbOHGx72DFCJTFCzKzt2EZPDXDANj83GlA
         MOYg==
X-Gm-Message-State: AOAM532i0MFK5rDn1Hl1bLtj9rOQpj+ruWfue1FIYUSaFGKF/811ygxh
        ezOC3JTR2zguT8L5cIA5gTYhVBw9hINxYgCNzr0=
X-Google-Smtp-Source: ABdhPJwzIVzXvL1nr0swqC7xKidpejgUodtzwCGQxx37EzgKsigTFJlG3z15436RlhlyUDo9HoErVnqPXU5bt+Y/xus=
X-Received: by 2002:a63:9a12:: with SMTP id o18mr3203999pge.167.1632285511151;
 Tue, 21 Sep 2021 21:38:31 -0700 (PDT)
MIME-Version: 1.0
References: <20210916200041.810-1-felipe@expertise.dev>
In-Reply-To: <20210916200041.810-1-felipe@expertise.dev>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 21 Sep 2021 21:38:20 -0700
Message-ID: <CAM_iQpUkdz_EjiuPRF_qKBp_ZHok_c8+pr4skCWGs_QTeLWpwA@mail.gmail.com>
Subject: Re: [PATCH RFC net-next 0/2] net:sched: Introduce tc flower2
 classifier based on PANDA parser in kernel
To:     Felipe Magno de Almeida <felipe@sipanda.io>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        boris.sukholitko@broadcom.com, vadym.kochan@plvision.eu,
        ilya.lifshits@broadcom.com, Vlad Buslov <vladbu@nvidia.com>,
        Ido Schimmel <idosch@idosch.org>, paulb@nvidia.com,
        Davide Caratti <dcaratti@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        tom Herbert <tom@sipanda.io>,
        Pedro Tammela <pctammela@mojatatu.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 16, 2021 at 1:02 PM Felipe Magno de Almeida
<felipe@sipanda.io> wrote:
>
> The PANDA parser, introduced in [1], addresses most of these problems
> and introduces a developer friendly highly maintainable approach to
> adding extensions to the parser. This RFC patch takes a known consumer
> of flow dissector - tc flower - and  shows how it could make use of
> the PANDA Parser by mostly cutnpaste of the flower code. The new
> classifier is called "flower2". The control semantics of flower are
> maintained but the flow dissector parser is replaced with a PANDA
> Parser. The iproute2 patch is sent separately - but you'll notice
> other than replacing the user space tc commands with "flower2"  the
> syntax is exactly the same. To illustrate the flexibility of PANDA we
> show a simple use case of the issues described in [2] when flower
> consumes PANDA. The PANDA Parser is part of the PANDA programming
> model for network datapaths, this is described in
> https://github.com/panda-net/panda.

My only concern is that is there any way to reuse flower code instead
of duplicating most of them? Especially when you specifically mentioned
flower2 has the same user-space syntax as flower, this makes code
reusing more reasonable.

Thanks.
