Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 992CD432460
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 19:03:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233580AbhJRRFP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 13:05:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233317AbhJRRFP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 13:05:15 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C57AAC06161C
        for <netdev@vger.kernel.org>; Mon, 18 Oct 2021 10:03:03 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id v77so712853oie.1
        for <netdev@vger.kernel.org>; Mon, 18 Oct 2021 10:03:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vapiWb/xC/HRW5SVd0n9p5J20MNFCuAe3IsWE2MHhPY=;
        b=GqTp8rvXsmRgSRBgRe45CQVjz1yaUBVMoi36eb0mCXIkj3yNFhYbNyiHrgcQHnI0T7
         XubLveOeE7PZHLsJ+FyA3yQApHPHEy7QrG28bHcN2hx4Sz5FadDjXLdj4Df8+1/6iELu
         F06NmOHAYROdHylmOCvNQx/QGAP0exqVpShEo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vapiWb/xC/HRW5SVd0n9p5J20MNFCuAe3IsWE2MHhPY=;
        b=s6utLOILPDNc1ifZzuq35v3w+2vpKo/UNINwtEucGL/bAjyhVzJGONPY1Fijcx9XPE
         V118iGoUG9m7wdQMM4ERhosK8V8nSboKVDQfqLLh/IB+dejtLW48YS8k0MhZddYBa4d6
         WPjH1sIiRITORRek1implDXsgo2S6wZ4CKoPBkeD44xJ6M0jYiF7727sznWRmprceytJ
         YjTrdrocgQByZ75H8CTLqp2PmOynd2dr4L+jS7wURiyCVo+xT58zEl3tMaJt/N+k+HVw
         EVNRZMFYlkN+La+skB/UasaWWHq7Ty39s1g/pn9z2GDQJvwEIz+9MtRI/c4G5wGPksNx
         AB+A==
X-Gm-Message-State: AOAM5314+NvrOIbrhBO0tnE962azUgn0uRCOQUip+zEybXt5RuRP1L3z
        qFMYC2UixpPY3cIKs0NPEYASMxQoye2VUA==
X-Google-Smtp-Source: ABdhPJzf4LogEChqEWZ7RHQwMDev5zuKYvC+k64rw3Cbhzjzwyr183PYKM76GQsjtEWJoOUWxCrBOg==
X-Received: by 2002:aca:3bd7:: with SMTP id i206mr61096oia.166.1634576582283;
        Mon, 18 Oct 2021 10:03:02 -0700 (PDT)
Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com. [209.85.167.182])
        by smtp.gmail.com with ESMTPSA id w2sm2592132ooa.26.2021.10.18.10.02.59
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Oct 2021 10:03:00 -0700 (PDT)
Received: by mail-oi1-f182.google.com with SMTP id m67so675527oif.6
        for <netdev@vger.kernel.org>; Mon, 18 Oct 2021 10:02:59 -0700 (PDT)
X-Received: by 2002:a05:6808:30a2:: with SMTP id bl34mr36459oib.77.1634576579273;
 Mon, 18 Oct 2021 10:02:59 -0700 (PDT)
MIME-Version: 1.0
References: <20211018063818.1895774-1-wanghai38@huawei.com> <163456107685.11105.13969946027999768773.kvalo@codeaurora.org>
In-Reply-To: <163456107685.11105.13969946027999768773.kvalo@codeaurora.org>
From:   Brian Norris <briannorris@chromium.org>
Date:   Mon, 18 Oct 2021 10:02:47 -0700
X-Gmail-Original-Message-ID: <CA+ASDXMQhjOCwjVUcstx3GoZeqsFJ4e_6FCFos6Kqb34N66axg@mail.gmail.com>
Message-ID: <CA+ASDXMQhjOCwjVUcstx3GoZeqsFJ4e_6FCFos6Kqb34N66axg@mail.gmail.com>
Subject: Re: [PATCH net] mwifiex: Fix possible memleak in probe and disconnect
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Wang Hai <wanghai38@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, shenyang39@huawei.com,
        marcelo@kvack.org, linville@tuxdriver.com, luisca@cozybit.com,
        libertas-dev@lists.infradead.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 18, 2021 at 5:45 AM Kalle Valo <kvalo@codeaurora.org> wrote:
> mwifiex patches are applied to wireless-drivers, not to the net tree. Please be
> careful how you mark your patches.

Also, the driver being patched is "libertas" (a different Marvell
driver), not "mwifiex" -- so the subject line is doubly wrong.

Brian
