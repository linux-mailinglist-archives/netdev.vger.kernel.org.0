Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A57562A0B1C
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 17:30:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727079AbgJ3QaH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 12:30:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727055AbgJ3QaG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 12:30:06 -0400
Received: from mail-vs1-xe43.google.com (mail-vs1-xe43.google.com [IPv6:2607:f8b0:4864:20::e43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19600C0613CF
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 09:30:06 -0700 (PDT)
Received: by mail-vs1-xe43.google.com with SMTP id u7so3695550vsq.11
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 09:30:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4poLgQBGdsSGDvNJLaT7Dlzjhi4aYmy6o/Lmtq6/qVo=;
        b=G4SLnL2eYkkiwoS7P5qeqcyMAzOSrF7xu1naInh5Whz77s8PuMbGResfIRFeAqs5HJ
         /VkMR0vIeT4WKeSU1i4COT9QPAiSZ4oVvUpT2wzY7oixSMC9nmmkNaPHEF3CYQQy1Y47
         36G91EPoARQdMg1Uzu56UHpM8f3VUJfnB7DVvHmhR9LwZa4jq7xDB3fvj3fJwiPxqhBj
         CmSKk09dFWYW665Rs1FssjrE0KbkX0/+3HgMCpkTPo8JOU1nipMuFCAzAKXm1vz37/7N
         YQeOJ7+q4fp/5MMt3A/d4J9jWGHTVAgPe+18PHcL4VwRaVOAgvtwrNsknPAYCAiPh9dl
         H7GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4poLgQBGdsSGDvNJLaT7Dlzjhi4aYmy6o/Lmtq6/qVo=;
        b=R/0b40zBXmwF/jkfDGLSyJO4JkvK/xcSEko/P43dwu2L5JkB2aatjfGri+OhC2coL4
         sladw6pVrvQ4GFZPG/IYIdbAGOTwYCeGvsbd5WBQHPjpVq1hoxvz6ag4uRPre7Il7OxZ
         WewrXHZhM0HHZsDNRWYYyLWD3Fg4Xye5PyRgEih7raa1fjZ26guAWLfmqzhQipD8/HSC
         YXE6MrTsCeJTuwzx019x9aDKtykLy1xCIC4TRyk00+lgENWU5UZshxvZ9bTpCRu1Ys4u
         sJji8xFmtPEdA55f9+Jqm8o521nYtskzRixtZvXjU5x2xE79ZHQbVYzPm9jL+DpkXmFn
         JTYw==
X-Gm-Message-State: AOAM532HNHn9UueqMDqOU0tLms3zm7e2JiLTmZOl5IohwHO/3BTPe9Z3
        OmZhkB1PKKxmoCNoCV8b/wMwbVJjBFk=
X-Google-Smtp-Source: ABdhPJwXwdhmHWUICF4fUBAMd/NskvwNzfOFUM5nUExI0AjSlYDyqSH9hxPAbH4icIzqe4AFECzePA==
X-Received: by 2002:a67:edcb:: with SMTP id e11mr8509954vsp.11.1604075404999;
        Fri, 30 Oct 2020 09:30:04 -0700 (PDT)
Received: from mail-ua1-f53.google.com (mail-ua1-f53.google.com. [209.85.222.53])
        by smtp.gmail.com with ESMTPSA id e10sm675835uan.11.2020.10.30.09.30.04
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Oct 2020 09:30:04 -0700 (PDT)
Received: by mail-ua1-f53.google.com with SMTP id r9so1883724uat.12
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 09:30:04 -0700 (PDT)
X-Received: by 2002:ab0:5447:: with SMTP id o7mr2256444uaa.37.1604075403498;
 Fri, 30 Oct 2020 09:30:03 -0700 (PDT)
MIME-Version: 1.0
References: <20201030022839.438135-1-xie.he.0141@gmail.com> <20201030022839.438135-5-xie.he.0141@gmail.com>
In-Reply-To: <20201030022839.438135-5-xie.he.0141@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 30 Oct 2020 12:29:26 -0400
X-Gmail-Original-Message-ID: <CA+FuTSczR03KGNdksH2KyAyzoR9jc6avWNrD+UWyc7sXd44J4w@mail.gmail.com>
Message-ID: <CA+FuTSczR03KGNdksH2KyAyzoR9jc6avWNrD+UWyc7sXd44J4w@mail.gmail.com>
Subject: Re: [PATCH net-next v4 4/5] net: hdlc_fr: Do skb_reset_mac_header for
 skbs received on normal PVC devices
To:     Xie He <xie.he.0141@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Krzysztof Halasa <khc@pm.waw.pl>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 29, 2020 at 10:33 PM Xie He <xie.he.0141@gmail.com> wrote:
>
> When an skb is received on a normal (non-Ethernet-emulating) PVC device,
> call skb_reset_mac_header before we pass it to upper layers.
>
> This is because normal PVC devices don't have header_ops, so any header we
> have would not be visible to upper layer code when sending, so the header
> shouldn't be visible to upper layer code when receiving, either.
>
> Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> Cc: Krzysztof Halasa <khc@pm.waw.pl>
> Signed-off-by: Xie He <xie.he.0141@gmail.com>

Acked-by: Willem de Bruijn <willemb@google.com>

Should this go to net if a bugfix though?
