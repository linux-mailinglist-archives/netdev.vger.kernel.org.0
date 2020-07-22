Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 343E7229AF4
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 17:05:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728812AbgGVPFr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 11:05:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727985AbgGVPFq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 11:05:46 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C83C8C0619DE
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 08:05:46 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id u64so2224632qka.12
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 08:05:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RGlEkhcsZo3yhQXvjN0G+bmOOv4WJUp5U029tMuuyYg=;
        b=TaHrNGo0vX9p8V/a8lm0ySt7CsVnoSD6VsPJ+ZHw5/3XzTaHXum+uEEJNhhxBUw7xz
         mmpy3MgxQTOlnS7qSticTtoJFnxrKcB0v4bgF67rRG8ALv6V3prPwY4UQ61ULQEPiW7d
         fGVddSAaLcvTOnFIVytrgfb2Lt2Q5rc7KLuHKsci8sv6h/Uty2++ObGjwpo9CXCnQXkj
         6/jeCkZRq0KSMWZSxST07kWW6fGXdrKm2suORrbRZ7mtSduUSplay6gSECXy8YghAUPV
         ZrHwJZB2skAayNjFeyvDGFRe8MG6NryWipDSceAbDEIogR/7GtyW02yZsFGfUXhvRJtk
         77mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RGlEkhcsZo3yhQXvjN0G+bmOOv4WJUp5U029tMuuyYg=;
        b=dl73vi2pUA1LjbPWHIXPbN90KD03oejB7Qc/wbYCSBaDpo3pEraLT4eu9AuQTQpu1D
         vDBe6or1jzZhh0DTRDBIVx9LUfgUWOlmYq9fG/4QzAF+k+Zyk5J/p1s3Cd0bY2UuiUIh
         WXG8kYcst3XNAP0Ha3aeIyNCKJTxokRVWjP0UGh6bPo4rHiGUWWWHPk3A6VUbzQjdJZr
         rGiaX6LftxgNEagGxZeGOVmL3LaOcISCxzLp2xn/hSeJzmTEudQpoL2KrfJAre7Hq8NM
         rVpQmV8AWkdj6BYV8ERo+JXyt2e4NwtG87GEd0YG3+Mks/7xeV8S9Nnw5YM4cz2Siji+
         aBow==
X-Gm-Message-State: AOAM532rxmkt5zatJMYCLTjj7UwRtIDAbFW7eJkZKoNmoad0FNcOS11V
        fTJLzIdcO7sM4yA+XGlG9SjJzOhq
X-Google-Smtp-Source: ABdhPJx3YEdHGVIIXp5eD1iEMxAadHYMvlxBtVv/1oWKSqd1XmdiQUkLG1g+ZSalmRivkuTrWp4q9Q==
X-Received: by 2002:a37:468a:: with SMTP id t132mr322612qka.467.1595430344819;
        Wed, 22 Jul 2020 08:05:44 -0700 (PDT)
Received: from mail-yb1-f178.google.com (mail-yb1-f178.google.com. [209.85.219.178])
        by smtp.gmail.com with ESMTPSA id y12sm23229016qto.87.2020.07.22.08.05.43
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jul 2020 08:05:43 -0700 (PDT)
Received: by mail-yb1-f178.google.com with SMTP id f5so1186289ybq.2
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 08:05:43 -0700 (PDT)
X-Received: by 2002:a25:df81:: with SMTP id w123mr51454810ybg.428.1595430342800;
 Wed, 22 Jul 2020 08:05:42 -0700 (PDT)
MIME-Version: 1.0
References: <87wo2vwxq6.fsf@cloudflare.com> <20200722144212.27106-1-kuniyu@amazon.co.jp>
 <87v9ifwq2p.fsf@cloudflare.com>
In-Reply-To: <87v9ifwq2p.fsf@cloudflare.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 22 Jul 2020 11:05:06 -0400
X-Gmail-Original-Message-ID: <CA+FuTScto+Z_qgFxJBzhPUNEruAvKLSTL7-0AnyP-M6Gon_e5Q@mail.gmail.com>
Message-ID: <CA+FuTScto+Z_qgFxJBzhPUNEruAvKLSTL7-0AnyP-M6Gon_e5Q@mail.gmail.com>
Subject: Re: linux-next: manual merge of the bpf-next tree with the net tree
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        kernel-team <kernel-team@cloudflare.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 22, 2020 at 11:02 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> On Wed, Jul 22, 2020 at 04:42 PM CEST, Kuniyuki Iwashima wrote:
> > Can I submit a patch to net tree that rewrites udp[46]_lib_lookup2() to
> > use only 'result' ?
>
> Feel free. That should make the conflict resolution even easier later
> on.

Thanks for the detailed analysis, Jakub.

Would it be easier to fix this wholly in bpf-next, by introducing
reuseport_result there?
