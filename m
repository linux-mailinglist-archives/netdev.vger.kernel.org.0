Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C57D1FCC96
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 13:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727000AbgFQLij (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 07:38:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726991AbgFQLih (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 07:38:37 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FB9CC061573
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 04:38:37 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id t21so1632006edr.12
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 04:38:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0D2h91sA5c63/XqdLeL54+KiO8vf142lb/nRNdTS8ew=;
        b=bYcJtainS7ifqb2c0ATkIGtSIxV9GOc6HZNMu1R7QAGWPQYugCvtd8oANclUm42+Qd
         GVRAJuUFmikbOjkARloys4cS/Blx1YkfcVxCdPrlG6Do3EfdvZ+yvGiIgZGJKytGAmox
         glzsENKF7v+WsIyhIaM1Yhe31GL6pTexLo09fxZElGTxvIjP46T34l5fayfLZe2AOPMX
         /5R4G1lA1JOBdSkL01mQ9LOou0yFLMvGzx76ht75lGI05dV3wx4N0Qfn7Ta2RHUjGoQE
         B9WqrgkCH1JuAiDShPVWP9P1ZXUdZscQJes6DsyQnRrIwlr5ish5MCYIMBWCtRUfVqSI
         UBuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0D2h91sA5c63/XqdLeL54+KiO8vf142lb/nRNdTS8ew=;
        b=QE3FHFGc0UdiP9jVyuAJv5aUYYH+slQcYLXyg4hyNIPa+V8lG1WaM5hl9fvRTZKU2K
         7eOrnvZ4FO2r1xzKxigRzPa2MhWBcZwbNet7gLM9485iFXtcWQ/EvrjaD8nzyfVJb6b3
         iVndsFMTuPEtexxAAvh0hO5C+iGrdxpDCMWVcqS5CxDJC+ssvpLq5IGrCINBriF0564E
         HEf3Hxd0UqOXeoq2L5JurU7Tqha3WKoXD3meuTxzP9ElaPrwho7JA0gsynhkzM+V3j3Z
         b/4YODwnb6lv5zsKdSVye26MtUTAiUWAFgCL05ZvE55nzs+wfyaTlgd4X+N1Pg1AatpD
         d+6g==
X-Gm-Message-State: AOAM531y/icrf8CP65luK4VMZPfqyNPnOUbbKNZfwVAcczVXeOdGKt5Q
        twDreYZvjkwxztbF6hbNunB34I+MTgK4B1SQLTY=
X-Google-Smtp-Source: ABdhPJyYryfyT4/n0iKzF55Qhz5/BbURUNYPgPy+8otCvy5TE8tzv3aQwEimzWWPVmgbXqMQ/vvxPjv3blefs/fzaA8=
X-Received: by 2002:aa7:c157:: with SMTP id r23mr6970937edp.139.1592393916222;
 Wed, 17 Jun 2020 04:38:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200616074955.GA9092@laureti-dev> <20200617105518.GO1551@shell.armlinux.org.uk>
 <CA+h21hotpF58RrKsZsET9XT-vVD3EHPZ=kjQ2mKVT2ix5XAt=A@mail.gmail.com> <20200617113410.GP1551@shell.armlinux.org.uk>
In-Reply-To: <20200617113410.GP1551@shell.armlinux.org.uk>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 17 Jun 2020 14:38:25 +0300
Message-ID: <CA+h21hqrDd6FLS7vhBW6GUdi8MvimiisyEbQLE0ZfasoQ1EQbw@mail.gmail.com>
Subject: Re: [PATCH] net: macb: reject unsupported rgmii delays
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Helmut Grohne <helmut.grohne@intenta.de>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 17 Jun 2020 at 14:34, Russell King - ARM Linux admin
<linux@armlinux.org.uk> wrote:
>

>
> Why are you so abrasive?
>
> Not responding to this until you start behaving more reasonably.
>
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

Sorry.
What I meant to say is: the documentation is unclear. It has been
interpreted in conflicting ways, where the strict interpretations have
proven to have practical limitations, and the practical
interpretations have been accused of being incorrect. In my opinion
there is no way to fix it without introducing new bindings, which I am
not sure is really worth doing.

Thanks,
-Vladimir
