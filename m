Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5651029E14A
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 03:00:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728646AbgJ1V4n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 17:56:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728591AbgJ1V4j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 17:56:39 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 501D5C0613D1
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 14:56:39 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id 23so872030ljv.7
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 14:56:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XA0a40BN8Ps5E0YfBjco6DAburIuHH7198zJJzK765g=;
        b=uV8fWbiL/4bgMd+JWuDlJkCY4pbDTF8p0sR74mtfq+I8yw8E3z9bk3EJ9SVlCU6/gq
         bq8b2DkN7eAa3r0wWUx3HrcC1TrJZikwqGWSYO2b5uY6FDnBkgFwcAge/yAL9AT7Qcrr
         +RxWilOrwIUH1FaeVksTF58elD27p6YYfDoGvz/4qDT+HUdD9sAKjuuMPapNqdz4e3yV
         XmH3GlzowEGCisAk8QDZqlvF59qzC15MO1Pt2gc5MVALqVWMuX26UmhoffB9ralOfbGs
         DHdyNfj8EqpGxlkC9TfDltrBmGot+PGhRzOFx0Izfa41Cnq+7PgnS26avsZzQucfsrEh
         UWcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XA0a40BN8Ps5E0YfBjco6DAburIuHH7198zJJzK765g=;
        b=fD49Xn5kW3h0pi9wTFED2OsJQyWwtPu8ZbPjJA79Fzcsq2P4p9DStcJqhFvMYoCIPv
         pnVW9HZGmwEYEGseZT8pufJ370JApbKtQordujDjvyLmtfUJL1e98LUwg1qT56+YgPIs
         pdfAOGYPYkrB848UIscA31DyoSQX5MK1fT66Dxr9zWxWrnMAS/WJk2cicnuN916tzZ+R
         y1g8g/6hGIzFPEsFfj0wf5xX/5/cALOu8HRqu7IYcE3/CSqCDimDPTUjxkT3yrtjsUxn
         gm1wIHIgCrkAMoE4c3Ewlblb4CJyYnPjU8Ut3RSPObGo/vYlodkQuHBgOYBcN3qiSccu
         pFYw==
X-Gm-Message-State: AOAM5334Lpor3CGtIJHEOB7R1+v1Mw/QXaB8wmgl+xtU/tcL0n5noUUm
        QfVGN67y1YWRhlm3OCg0nDnghrxkQ9UQkLOSPW9rKzFp
X-Google-Smtp-Source: ABdhPJwp+tkGZxQrg1CSDFLpIwGP7pYSSYicFeTyL1SonSyyr5nUh4bUrjY/Gc6EnVYlZ0nAHx8osGXB+58UP+oih/g=
X-Received: by 2002:a17:906:3b91:: with SMTP id u17mr899776ejf.504.1603917970403;
 Wed, 28 Oct 2020 13:46:10 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1603899392.git.camelia.groza@nxp.com> <5b077d5853123db0c8794af1ed061850b94eae37.1603899392.git.camelia.groza@nxp.com>
In-Reply-To: <5b077d5853123db0c8794af1ed061850b94eae37.1603899392.git.camelia.groza@nxp.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 28 Oct 2020 16:45:34 -0400
Message-ID: <CAF=yD-LN14YF9Y4z_+2McNrdj5H4OV0wF=Je=b5L+Ws7csP94Q@mail.gmail.com>
Subject: Re: [PATCH net v2 2/2] dpaa_eth: fix the RX headroom size alignment
To:     Camelia Groza <camelia.groza@nxp.com>
Cc:     madalin.bucur@oss.nxp.com, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 28, 2020 at 12:41 PM Camelia Groza <camelia.groza@nxp.com> wrote:
>
> The headroom reserved for received frames needs to be aligned to an
> RX specific value. There is currently a discrepancy between the values
> used in the Ethernet driver and the values passed to the FMan.
> Coincidentally, the resulting aligned values are identical.
>
> Fixes: 3c68b8fffb48 ("dpaa_eth: FMan erratum A050385 workaround")
> Signed-off-by: Camelia Groza <camelia.groza@nxp.com>

Acked-by: Willem de Bruijn <willemb@google.com>
