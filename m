Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1667C1080AA
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 21:51:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726869AbfKWUvu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 15:51:50 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:35650 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726744AbfKWUvu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 15:51:50 -0500
Received: by mail-ed1-f67.google.com with SMTP id r16so9085462edq.2
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 12:51:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LiyHTkWn9I7Qh1gPgifVngb2Z19YGNYTxhJv/xobpPQ=;
        b=uGj5X8ZAbymhzekm47VxkFBqZzmwywXPeRx/+1IT4Tmux2sny8G7Vi4ARFG/5glPKA
         /siD+a7rJCpj3ETbO2JurOJ9n4fYzYxQf8PyttKJp59IIC2ajpKqN4gXjiqiWwRA0xuW
         LvCOA8kTkDmq9FP0MLnUN2WPiJdR4szAm1tQEBjI6XScQaPg7b8gJd83EAuppx7BVz0t
         BrdjAKa2wNhVwFTN2n50jumHYE09Q+irCuNiMLF79QOXHMLZcr319PCXu+k+b1kTNiVs
         NnZhR1ijP1jv/dHLydh7VuTwrL8pPB5JvoH7P/xf+8q96eAzkNtnfvoIZYCNgfxzWlnW
         D0QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LiyHTkWn9I7Qh1gPgifVngb2Z19YGNYTxhJv/xobpPQ=;
        b=GbqvVn0VBdXKTvS2Q56PaN7+DhTWlWUyE23o8YZCh90TliT5eP6bPGRukxPH9F7b5K
         NBwvJUQfuN25LrPCUlF8O1rldbonyDjrfcqD61fn105FscsmuHx0vjYJlpSZMQkPhWJ/
         vLpg89Fn8T0YSE3YGJ4c1zLWu3cowIyRsxsSwuLZFi7UgP2273yBKoX+4pYpo5SIod4A
         Pu+Hy3hAuMTjB0DtB6I850wt8qaD4ksnePHNSWTEXGP5S4ALE+TkDMlte4nhB81Xa/0Z
         BQF+w1R4DyNaTOeOETWodI8FRqvu2KW5dl64RVlKe90o6ikJBzLgbYcRU7EmeUB3PPZV
         F2VQ==
X-Gm-Message-State: APjAAAWwKLFm2iHot2ejVe1NdqVvqQsHCm0eXgVSM/dmxVN35Njr0te9
        3SJQxK95nQDh+d1Tnb9ljvs+ZGW3qgCcF2asjzs=
X-Google-Smtp-Source: APXvYqwNlXbw8ITF9gdt0TlQV1DWvz7NY5CoeUL0ZsuFyf9qBD1C4xXsJ4/XaxT+HZR02Klal+pWX6s3c9vQMCrGmy8=
X-Received: by 2002:a50:c408:: with SMTP id v8mr8878436edf.140.1574542307872;
 Sat, 23 Nov 2019 12:51:47 -0800 (PST)
MIME-Version: 1.0
References: <20191123194844.9508-1-olteanv@gmail.com> <20191123194844.9508-2-olteanv@gmail.com>
 <329f394b-9e6c-d3b0-dc3d-5e3707fa8dd7@gmail.com>
In-Reply-To: <329f394b-9e6c-d3b0-dc3d-5e3707fa8dd7@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sat, 23 Nov 2019 22:51:36 +0200
Message-ID: <CA+h21hpY7GtXCV0WTCob3Yoi2H+WYtwn6Bc0Y_cU_=qeB9_KZQ@mail.gmail.com>
Subject: Re: [PATCH net-next 1/3] net: dsa: Configure the MTU for switch ports
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 23 Nov 2019 at 22:28, Florian Fainelli <f.fainelli@gmail.com> wrote:
>
> Hi Vladimir,
>
[snip]
>
> I had prepared a patch series with Murali doing nearly the same thing
> and targeting Broadcom switches nearly a year ago but since I never got
> feedback whether this worked properly for the use case he was after, I
> did not submit it since I did not need it personally and found it to be
> a nice can of worms.
>
[snip]

Also, is there another can of worms beyond what you've described here?

> --
> Florian

Thanks,
-Vladimir
