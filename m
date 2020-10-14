Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D86CD28EA2F
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 03:34:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388852AbgJOBep (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 21:34:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732244AbgJOBej (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Oct 2020 21:34:39 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD5EBC051126
        for <netdev@vger.kernel.org>; Wed, 14 Oct 2020 16:05:44 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id v6so1272204lfa.13
        for <netdev@vger.kernel.org>; Wed, 14 Oct 2020 16:05:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qlFvy8eyL04DCdB/CZCNzYgQ2J2bwqnrawGVF61K2Q4=;
        b=T4nkPbcrfWVzlUXPa2RR1CJimGsiGY65KGzNi9VNP62ZmKbMbTcQk0jIvKba4mQWTj
         Ql2R8WvQdFrPo1ebURmmR+z4SRbFVplsZde363RW7Z/ZsuQgnaSQ9O2JbS+GUN+LzQRD
         3lLLweu8MvSfGCWs26YQ2AN9k47D9sYkCWPjI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qlFvy8eyL04DCdB/CZCNzYgQ2J2bwqnrawGVF61K2Q4=;
        b=HlDAHEutzpFIttU/iEJBVIFTQWd3a6NT3GHqTHAKz96E7Qtile02cKotLTa/OaHcM+
         WsabjmiWl8xLJG/CEefzLL0DEVwaQZSta3u4SJ40vsoBey1dN5bNtQeUcaZeC5EuqcU9
         r0EqnfWPWFPrvBUjwuwMrEg7Kq1EGOHZFx8uIkyk1YBYOT0x3sxTiFgOFfssNd69e3LO
         MorOc1sAuQR/nT6DbBsHPv17VyTzh5BnxBMTY1rqO2Tp2mhve4T+psPopmbVm8y8FFge
         jhkL7h0O3MydAV+0wxfkuImnTZk/sRQH7IYa2XYOiyirJzlbZZML/CmeU/F2HLMcZcxa
         YR+Q==
X-Gm-Message-State: AOAM5302ObtXxBWxJ8T0We8FL7dNiXRFqSNEWyn9BahDllqsNcdzYuLu
        OD07lfnj0sa07u+aEClw27slL1ztEtLpRw==
X-Google-Smtp-Source: ABdhPJxc7Elrpc2r3IgDdKmVye1XnAEiBXxmOBYUYMfa6wJEO+UVQtGskp51uW1c/RK7CNuGN4Fi2Q==
X-Received: by 2002:a19:80cd:: with SMTP id b196mr131192lfd.118.1602716742943;
        Wed, 14 Oct 2020 16:05:42 -0700 (PDT)
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com. [209.85.208.178])
        by smtp.gmail.com with ESMTPSA id a6sm268695lfm.207.2020.10.14.16.05.41
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Oct 2020 16:05:42 -0700 (PDT)
Received: by mail-lj1-f178.google.com with SMTP id c21so1202959ljj.0
        for <netdev@vger.kernel.org>; Wed, 14 Oct 2020 16:05:41 -0700 (PDT)
X-Received: by 2002:a2e:8815:: with SMTP id x21mr173561ljh.312.1602716741597;
 Wed, 14 Oct 2020 16:05:41 -0700 (PDT)
MIME-Version: 1.0
References: <20201014222650.GA390346@zx2c4.com> <20201014230209.427011-1-Jason@zx2c4.com>
In-Reply-To: <20201014230209.427011-1-Jason@zx2c4.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 14 Oct 2020 16:05:24 -0700
X-Gmail-Original-Message-ID: <CAHk-=whgDWFJiioE+C=_JOQvEtcw3CVXPq7wDGHDhV8hFrFCnw@mail.gmail.com>
Message-ID: <CAHk-=whgDWFJiioE+C=_JOQvEtcw3CVXPq7wDGHDhV8hFrFCnw@mail.gmail.com>
Subject: Re: [PATCH] powerpc32: don't adjust unmoved stack pointer in
 csum_partial_copy_generic() epilogue
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks - applied and pushed out.

             Linus
