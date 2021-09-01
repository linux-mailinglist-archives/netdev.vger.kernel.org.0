Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 041353FDEFA
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 17:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343820AbhIAPtV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 11:49:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232757AbhIAPtU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 11:49:20 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E529C061575;
        Wed,  1 Sep 2021 08:48:23 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id x19so130470pfu.4;
        Wed, 01 Sep 2021 08:48:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=vmclqQ0WSX1nYlOYWUqAexZ2LxQ9qNPAJcM+COYyC7M=;
        b=XByNdOk3/cONjGR+FAVB++rBl97wKVkKZqE0ONlZpU6LHNjDaXfbw6xYGY6ah004aB
         z9LmsUhR9wJjBYiq6DVKwYAWeuuULQQu0bRNF92+eJWQrHGlKY/0eEZy5KQHxPKkENWH
         LZB7XbYPtt4yLzcqkaLT7zt8uxYIgd5w1cMdya53kcPdPY5WjfotUunAZ2S+QnWqwuBZ
         i+iTtClpz1Fwvzg5w+l4v5dZDqtrey+5U1QQ81ayt2+UFdDWiJQ8h6u6JyWxU3TVqode
         MsvPBWE4RfMgMFyPrZJqVDFIZhwQyRNC9IDWQMQBX3j9jPa0du9xVny5h75NFMdDKMmb
         I3XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=vmclqQ0WSX1nYlOYWUqAexZ2LxQ9qNPAJcM+COYyC7M=;
        b=RI7wLezZ8tUwapNgT6WZQ9oBFdI++oXd3uqx9FRrbjzJnrrDeCNFoD87F1OY1TEsB8
         NmfbbkzA5ugFP3HOosGl3BY3AwRp8vnwITgdPPhA2Sw3R88kKc9sVf60eOw4AmpT8WG5
         PhBZy2/Ql6bbMms9tYt0l4q5os9Qlzc6maa81uArW/W6ux7kjoDCH8TK3gx2In/1cm7G
         yFlvKq+n+RVMNksvmT6RGkYxXHWFbehFA8mLx4f1SDu6MMbgIl8f2TRB3/OubSUEY6aq
         +fhIiKNtszSY4sorMGqUl+WCtYDLMfBJP1XzK4pLbvs7oITsvXQruYUyP21Yxe9KcHde
         r7Ww==
X-Gm-Message-State: AOAM532OMIg+PhmtKxIUmH+oslhCZsUpFrAvNNLxBkn1Od4XmqEg0qwv
        LkmzSKEcqjEKzZ4ILxKlsSBrrtB1d7tfa8oDGeo=
X-Google-Smtp-Source: ABdhPJz9k2s+gvuJecOLz5VorZBzX4Ibo7UwKfkK9GaFwnjmCU6wfZQhw5cIiPNfzbt8gZhO1+KW+sZzYMCaA4/3tZs=
X-Received: by 2002:aa7:875a:0:b0:3f1:c4c8:5f0d with SMTP id
 g26-20020aa7875a000000b003f1c4c85f0dmr155319pfo.40.1630511302856; Wed, 01 Sep
 2021 08:48:22 -0700 (PDT)
MIME-Version: 1.0
References: <20210830123704.221494-1-verdre@v0yd.nl> <20210830123704.221494-2-verdre@v0yd.nl>
 <CAHp75VeAKs=nFw4E20etKc3C_Cszyz9AqN=mLsum7F-BdVK5Rg@mail.gmail.com> <7e38931e-2f1c-066e-088e-b27b56c1245c@v0yd.nl>
In-Reply-To: <7e38931e-2f1c-066e-088e-b27b56c1245c@v0yd.nl>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Wed, 1 Sep 2021 18:47:46 +0300
Message-ID: <CAHp75VeKws85JMG_GjYPzgcqu7pGf66bLbUowNi-4z_=uda+HQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] mwifiex: Use non-posted PCI register writes
To:     =?UTF-8?Q?Jonas_Dre=C3=9Fler?= <verdre@v0yd.nl>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tsuchiya Yuto <kitakar@gmail.com>,
        "open list:TI WILINK WIRELES..." <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
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

On Wed, Sep 1, 2021 at 5:02 PM Jonas Dre=C3=9Fler <verdre@v0yd.nl> wrote:
> On 8/30/21 2:49 PM, Andy Shevchenko wrote:
>  > On Mon, Aug 30, 2021 at 3:38 PM Jonas Dre=C3=9Fler <verdre@v0yd.nl> wr=
ote:

...

>  > Thanks for all this work!
>  >
>  > Nevertheless, do we have any commits that may be a good candidate to
>  > be in the Fixes tag here?

> I don't think there's any commit we could point to, given that the bug
> is probably somewhere in the firmware code.

Here (in the commit message)...

>  >> +       /* Do a read-back, which makes the write non-posted,
> ensuring the
>  >> +        * completion before returning.
>  >
>  >> +        * The firmware of the 88W8897 card is buggy and this avoids
> crashes.
>  >
>  > Any firmware version reference? Would be nice to have just for the
>  > sake of record.
>
> Pretty sure the crash is present in every firmware that has been
> released, I've tried most of them. FTR, the current firmware version is
> 15.68.19.p21.

...and here it would be nice to state this version, so in the future
we will have a right landmark.

>  >> +        */

--=20
With Best Regards,
Andy Shevchenko
