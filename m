Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D79DD2A1B0B
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 23:31:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725949AbgJaW2E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 18:28:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725809AbgJaW2E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Oct 2020 18:28:04 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 839E4C0617A6;
        Sat, 31 Oct 2020 15:28:02 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id a3so1237643pjh.1;
        Sat, 31 Oct 2020 15:28:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9h1ScVWUC+i+KtoUQHyFrfgOWuvDnMNiIyhAQEjhvgM=;
        b=WbAzPJREPzNvV5aaGs/lBng3vfW4b4rpZ0SONjztWP0PRhqIZhGJ9wNyM6WQd+hqcy
         USQ5rm2Yw0BTvWHooEKAK30aLAvpKhSLMzuMoHEeSILbDncejGMqx8gIGJWaw5QIT6Lh
         7rgWzdK8UBQL9hDdwteBsyqHMnGO9hkmy3yRyfodWgY+2fhhsHzfy9a6c3mZRGq6kEYo
         f6nHjwyv2nIcYLwMZn7zly+8FhyJIUm9zpB6hUjmzXwkkksQqXDQNea2+7aYTJnCrRT+
         WnI+oqI3ATv9qp+2ForhcUljF4RsNVEQbH3A5gqXpEMr8hVSFXVj/Ufv3G9lzmtUSAqr
         nZfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9h1ScVWUC+i+KtoUQHyFrfgOWuvDnMNiIyhAQEjhvgM=;
        b=g5YxQC0FcMGUuRfQjLu1zLJItFkMbwPEk/z4gXJV1vKhY+gy8tG5SZyeSapGcwrkP7
         27+f3fHrtAcFpqy1xvQNvAuobNCMbgyzfq5oHIK4SA+pM8nYSDhv+aUwOHopsFNJDQIk
         slgM8fdfZ6uVGWE79d6I2PngtD9w7BMqHQpRCMLB02Vw1+re84PqdFDYBAWretQqmCM0
         q6goCN9U1K8oJcfwRzxVkZHfTVO9O+vlJMWlNuOmNsApQ2PxT3OL8QZbaUBzAAzK5b/C
         xjRW3XdBO/HkOqfkm7N5LnoRPvhwvxc3d9UWUz94FhZgwKIYYrlxD/EP76vqQBdXA9pD
         zwKQ==
X-Gm-Message-State: AOAM531K6nO91p70/cYWHVrGK1J8O63Ps4JzKkC7fbaLzJNgyY3Poes/
        7HOHK4AhjoiwbKTgWqF50GVlaogQFF1zW+XNWv4=
X-Google-Smtp-Source: ABdhPJzp8EmB2Rpi40t5/vDOi2ikxni/i6IpuvPxUKK2T7NiUZOF4ZzvcjpvMxWul2bAEx2SiOF4ZVAh/af0hA/nBi4=
X-Received: by 2002:a17:90a:3e02:: with SMTP id j2mr2554584pjc.210.1604183281987;
 Sat, 31 Oct 2020 15:28:01 -0700 (PDT)
MIME-Version: 1.0
References: <20201031004918.463475-1-xie.he.0141@gmail.com>
 <20201031004918.463475-2-xie.he.0141@gmail.com> <CA+FuTSfKzKZ02st-enPfsgaQwTunPrmyK2x2jobZrWGb16KN0w@mail.gmail.com>
 <CAJht_EOhnrBG3R8vJS559nugtB0rHVNBdM_ypJWiAN_kywevrg@mail.gmail.com>
 <CAJht_EMgt4RF_Y1fV7_6VdzbMu0Fn8o+yW8C2RfnSsLjqsm_cg@mail.gmail.com> <CA+FuTSfkMBow-2xvY1SKuiQQVicbxYSD0agCdGwr_h8ceXA8Fw@mail.gmail.com>
In-Reply-To: <CA+FuTSfkMBow-2xvY1SKuiQQVicbxYSD0agCdGwr_h8ceXA8Fw@mail.gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Sat, 31 Oct 2020 15:27:51 -0700
Message-ID: <CAJht_EMsFNx0Vikah047Xi0LTq8r230ne3zVzqW1jeGBy-tUzw@mail.gmail.com>
Subject: Re: [PATCH net-next v6 1/5] net: hdlc_fr: Simpify fr_rx by using
 "goto rx_drop" to drop frames
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Krzysztof Halasa <khc@pm.waw.pl>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 31, 2020 at 12:48 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> Returning code in branches vs an error jump label seems more of a
> personal preference, and to me does not pass the benefit/cost threshold.

This patch is necessary for the 2nd and 5th patch in this series,
because the 2nd and 5th patch would add a lot of places where we need
to "error out" and drop the frame. Without this patch, the 2nd and 5th
patch would add a lot of useless code.

The 2nd patch is also necessary for the 5th patch, because otherwise I
would not know how to produce the 5th patch. The logic is so
convoluted for me. And it seems to me that the simplest way for me
would make all code to follow the logic of eth_type_trans.

The patch series was actually a single patch previously:
http://patchwork.ozlabs.org/project/netdev/patch/20201017051951.363514-1-xie.he.0141@gmail.com/
I splitted it to make changes I do clearer. But really these patches
should be as a whole. It's really hard for me to do the 5th patch
without the 1st and 2nd patch.
