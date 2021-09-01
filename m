Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 915103FE42F
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 22:41:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231659AbhIAUmP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 16:42:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231398AbhIAUmO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 16:42:14 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C512C061575;
        Wed,  1 Sep 2021 13:41:17 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id m17so409591plc.6;
        Wed, 01 Sep 2021 13:41:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=NO/zd5PEh4sGso5loCQniKnDMB+CL8oSBEUV4F7LrXw=;
        b=IP0mTBtq6mlacOZ39e0lYeKPTk+VrJ0ZQqRlm1T1+QNDaOlvcqYRPV8jm+803qYDl7
         LY4ZXJsWOq+hbIlsbXpy6iNRIGf2Q1TF7o68nDz9wP41a0Qi2vHBy+eWiI8u6Hx0ifHk
         ixOXbYG9jzZTr7QFpGbJ/H7QmmaWWFgbtHh3B8Wh6leVIAHm8+dsbahllR3BJHiFEPlY
         pk+VVnObLh2Tq/ChZWHPsg8sGfqTHuVvRPzv/zTs+czN7mrfONq8O0n7skB9RzkYyXjU
         CkM+Z1XN0DZVxaW89t+e1m2jWWMZME8O76qbDN2EaSMVIfmYoPo2wThKC6gPSkMERMaC
         bSaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=NO/zd5PEh4sGso5loCQniKnDMB+CL8oSBEUV4F7LrXw=;
        b=GWqqbfDvmE0c5TTLJ7Ue12iU09sx1xZLu/49uLd7uxwZURFtS8vcOTUx1SWaOvpdM9
         ukGJzx2ZXXbciFsG2qpOArKUJ6bNq2FS0QcO4tgPjFUlXs62RPLVcILW7jDD93rZfbM0
         2kQmQlEzf0nSq/2ZpOY5AqXvqjqqZyyLTq4uC4leKHZD0NzHgIZ9JJpHEgdOeAs0z53/
         c86vfDq9kJCfnl8KFyLYlFdA1VsSyRU5JUEVDu85ulUAFUBiu6OwmaOWDfhqlL+ZCn0N
         kKb8dUzaqETOqpTLb8vlKjLqEmKpM/1CaWeXLNSnZW1V8nmEHe+pV7S/zGVebuqJUQEy
         VAzA==
X-Gm-Message-State: AOAM531mceOYJGVf5pYlb59+So0aO6h4wOTnajSyoKyx75dis5jFBTeb
        a9Xth/dNwem4m/e/5faVikBHnwMxDhS1B2ddfxQ=
X-Google-Smtp-Source: ABdhPJyokH7tzWOv52uIscrHN+41KOxxtDBm9KGPkir22Mv0bLlWOv/nJud3iY+etysezBR/VQTmiUQ9iCOMiMV7vB4=
X-Received: by 2002:a17:903:120e:b0:138:d732:3b01 with SMTP id
 l14-20020a170903120e00b00138d7323b01mr877939plh.21.1630528876524; Wed, 01 Sep
 2021 13:41:16 -0700 (PDT)
MIME-Version: 1.0
References: <20210830123704.221494-1-verdre@v0yd.nl> <20210830123704.221494-2-verdre@v0yd.nl>
 <CA+ASDXPKZ0i5Bi11Q=qqppY8OCgw=7m0dnPn0s+y+GAvvQodog@mail.gmail.com>
In-Reply-To: <CA+ASDXPKZ0i5Bi11Q=qqppY8OCgw=7m0dnPn0s+y+GAvvQodog@mail.gmail.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Wed, 1 Sep 2021 23:40:40 +0300
Message-ID: <CAHp75VdR4VC+Ojy9NjAtewAaPAgowq-3rffrr3uAdOeiN8gN-A@mail.gmail.com>
Subject: Re: [PATCH 1/2] mwifiex: Use non-posted PCI register writes
To:     Brian Norris <briannorris@chromium.org>
Cc:     =?UTF-8?Q?Jonas_Dre=C3=9Fler?= <verdre@v0yd.nl>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tsuchiya Yuto <kitakar@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 1, 2021 at 11:25 PM Brian Norris <briannorris@chromium.org> wro=
te:
> On Mon, Aug 30, 2021 at 5:37 AM Jonas Dre=C3=9Fler <verdre@v0yd.nl> wrote=
:

...

> This might be good for many cases, but please read this commit:
>
> https://git.kernel.org/linus/062e008a6e83e7c4da7df0a9c6aefdbc849e2bb3
> mwifiex: pcie: use posted write to wake up firmware
>
> It's very much intentional that this is a posted write in some cases.
>
> Without ensuring this doesn't regress, NAK from me.

Can you ensure that from Chrome / Google perspective, please?

--=20
With Best Regards,
Andy Shevchenko
