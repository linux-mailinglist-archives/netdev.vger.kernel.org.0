Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46FBD3435AD
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 00:24:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231278AbhCUXXg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Mar 2021 19:23:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230248AbhCUXXQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Mar 2021 19:23:16 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E26BC061574;
        Sun, 21 Mar 2021 16:23:15 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id f73-20020a9d03cf0000b02901b4d889bce0so14166736otf.12;
        Sun, 21 Mar 2021 16:23:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=B74youK00+gi/xqfb9oTzK7xl7IAxaoNJNt8Y8fsLdA=;
        b=Oo9j9TVYePGcOsh5RNcAkOrsfmfAXZeTZ+2cu/SkCOQt0g17TN9WI55JwKz/x5hP53
         JLnHSeoeRhJmeoECSq5eGWV5Pg5ZUMwGZ+D3byoJvLa/a+42uLOkeOjeK+ciPdhyaJm8
         pgAFSrF02ryJM+nMrd+gn8eZg5DEtPXKhopx7HdncZC387ZrREsB0u+lFpGGAPaoO9xk
         GSxNsTE/ZSf/MXs1eTXCZVg3dT/RoJgF/svkgXxMSiDdXF9GUEhyBkFv0tGjDUcArBeH
         EK2m/ySAyWNnoQCJnfCFb8Pigyc8G27ncec5HlBY6aCkQNz7tORkLLs2XFA0ieDacatk
         kcyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=B74youK00+gi/xqfb9oTzK7xl7IAxaoNJNt8Y8fsLdA=;
        b=YBB9BkQutX4QNphCulmrU88bhK4/TVaLfqxox0jJpSVKqAOqlAtg+E5trof/bOxbqR
         0+IMyM8J9tcFS8Ej/WnVDE8cff2u8WaG/oQ+Z0fa9PMnj7uGX3HFizFeujvhi5C6rFBp
         fWWru2yhdP5P1zbDWG6BR0jTdC6FLdMtJviDuDEUEq1ux48uWLXfRuQJh6xB+OFiuueA
         xJaw6H35+knOkhpwOT71bzIizJaRSA7cMcv+r71MY2F1xcSZy9fC52vLHuoRl/T89eHQ
         XCz87tW+8LlxvTKoqYdemnHBYsK/pOZ4rEWhV2cO8yKITmVvbtcGy4NElfQUNDb1GB4V
         x7iQ==
X-Gm-Message-State: AOAM533hORF3VLvIxsx+S4scVbqPvPBc157X7AD5Gb3KkcrJ5GNAbM72
        sqZQS9iZsRq+u9tjbQ+Jq/SbnSmr7dqbux5Cmgg=
X-Google-Smtp-Source: ABdhPJxRJba+qeIGPrVGbzJd6p+95y73QrUSIeTO+MVJpzPEq/KtAsbjuBjoOiGOc2UVpyBYSe7fOypcM+rLb9rZqr4=
X-Received: by 2002:a9d:6949:: with SMTP id p9mr9445538oto.252.1616368994696;
 Sun, 21 Mar 2021 16:23:14 -0700 (PDT)
MIME-Version: 1.0
References: <13aed72.61c7.17853a6a5cd.Coremail.linma@zju.edu.cn> <CABBYNZKwHEXK680Xz+W=2qXdkO2eEzTBu38Hc=5DaxggkaTSsg@mail.gmail.com>
In-Reply-To: <CABBYNZKwHEXK680Xz+W=2qXdkO2eEzTBu38Hc=5DaxggkaTSsg@mail.gmail.com>
From:   Emil Lenngren <emil.lenngren@gmail.com>
Date:   Mon, 22 Mar 2021 00:23:05 +0100
Message-ID: <CAO1O6sfdpWzULj_Yj1s_GTFiLaZFFjrrj_0RPAVe1hyk3uuSsg@mail.gmail.com>
Subject: Re: BUG: Out of bounds read in hci_le_ext_adv_report_evt()
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     =?UTF-8?B?6ams6bqf?= <linma@zju.edu.cn>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        yajin_zhou@zju.edu.cn, syzkaller@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Den m=C3=A5n 22 mars 2021 kl 00:01 skrev Luiz Augusto von Dentz
<luiz.dentz@gmail.com>:
> Or we do something like
> https://lore.kernel.org/linux-bluetooth/20201024002251.1389267-1-luiz.den=
tz@gmail.com/,
> that said the reason we didn't applied my patches was that the
> controller would be the one generating invalid data, but it seems you
> are reproducing with vhci controller which is only used for emulating
> a controller and requires root privileges so it is unlikely these
> conditions would happens with hardware itself, in the other hand as
> there seems to be more and more reports using vhci to emulate broken
> events it perhaps more productive to introduce proper checks for all
> events so we don't have to deal with more reports like this in the
> future.

Keep in mind that when using the H4 uart protocol without any error
correction (as H5 has), it is possible that random bit errors occur on
the wire. I wouldn't like my kernel to crash due to this. Bit errors
happen all the time on RPi 4 for example at the default baud rate if
you just do some heavy stress testing, or use an application that
transfers a lot of data over Bluetooth.

/Emil
