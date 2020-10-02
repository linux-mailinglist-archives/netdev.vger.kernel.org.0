Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7DD1281CD8
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 22:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725768AbgJBUU3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 16:20:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbgJBUU3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 16:20:29 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83929C0613D0;
        Fri,  2 Oct 2020 13:20:27 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id a2so2045697ybj.2;
        Fri, 02 Oct 2020 13:20:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZjYnH8NMd9EvKTTZ3QWx8KfiPBRRSNu4BBCpFrxwX6U=;
        b=jglmkFc7yMnmRm2kf3IEajZwdq/N5wMlZqj1wcr/RoBp7JeOLUhQFSswNRX9+m3SL0
         FT1ga/PQYnhCSW32/8M/6POIYCpcb46e1xvKi0CVB6DtcHPniQObCSe1Zd3qQIZKJlcz
         x/r2Tk0DnAcYwf59jzV8p1acVAc9QmoQPkj02DpCjuHPn0lwIBOvnGPjmEFhZBQpixfW
         W7aulzdcnyOmvETDek2MHUyuvrjEdVWfkh813gnNVWB9BTuLr9gqH50ObVZaUqyY2Q+i
         tYi7LF7jsqNikZtjl5swV27lHf9vMWmTUYq2vheBqdg0ox1AzcDXfse6keDcy2GF1DkP
         JzJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZjYnH8NMd9EvKTTZ3QWx8KfiPBRRSNu4BBCpFrxwX6U=;
        b=S7S0eR4RMpNqSX5Lpnxi36mCkrfoEtDbBL2r2DvPKr9LGllZRatEyjDEYIFlf94K4t
         +12GOTz0nsBYCUAEtoYBolL1EBHI872spC87WP+h+v5ut3w+tubrlkRSSE4zrky7xlkg
         2wwDWfs6Sw8fUQRWjCpM4xwphNYkRsK1eKh2M2SXfOVXoM9Xij0dyxYeMZ93yxmQo6YG
         fseu18AFQ2nxtRRl+GhXoQ7TB672eCC4wHWbymjor5EFfQA1Zp7snqv1vf3UIUdmpzMS
         7lk/3Qt4/Vly5mH7+viPYUouws6RRTLZWC09TyXdMsTRbHLJs3m/I+aTI7ENBOgcb5i9
         CIgQ==
X-Gm-Message-State: AOAM530KL65uibBqFVoCTtDJPxttZ/tqpkkizHwAbN69DCJO+X89XpUl
        L1cAU3xhb+O+naNc5MZp9/SbXvJSf4Z9sYtuy/Q=
X-Google-Smtp-Source: ABdhPJwzt36OP4Lp8Ish2l0V38vFOreqRh7WQEtDvB8x4bQ+GzXB/7cHtAZN64Qxg0IYfpcCW7l6T34e6u4n9Ckfn3U=
X-Received: by 2002:a05:6902:4ae:: with SMTP id r14mr5197035ybs.22.1601670026875;
 Fri, 02 Oct 2020 13:20:26 -0700 (PDT)
MIME-Version: 1.0
References: <20201002174001.3012643-1-jarod@redhat.com> <20201002174001.3012643-4-jarod@redhat.com>
In-Reply-To: <20201002174001.3012643-4-jarod@redhat.com>
From:   Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date:   Fri, 2 Oct 2020 22:20:13 +0200
Message-ID: <CANiq72=WDR028qoM0du_ZKr0FSVv+X5BsZJJUw_Hf51dE6MD6w@mail.gmail.com>
Subject: Re: [PATCH net-next v2 3/6] bonding: rename slave to port where possible
To:     Jarod Wilson <jarod@redhat.com>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Davis <tadavis@lbl.gov>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jarod,

On Fri, Oct 2, 2020 at 7:44 PM Jarod Wilson <jarod@redhat.com> wrote:
>
>  .clang-format                                 |    4 +->  #ifdef CONFIG_NET_POLL_CONTROLLER

Acked-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>

Cheers,
Miguel
