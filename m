Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DF0D18FD03
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 19:47:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727766AbgCWSra (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 14:47:30 -0400
Received: from mail-yb1-f195.google.com ([209.85.219.195]:35664 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727275AbgCWSra (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 14:47:30 -0400
Received: by mail-yb1-f195.google.com with SMTP id x63so7692075ybx.2
        for <netdev@vger.kernel.org>; Mon, 23 Mar 2020 11:47:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Qmii+y/AcNF/3IaoysaoSwbUreiK2GotAvn0cRg6OCo=;
        b=XONA2ALhlQSOjB4m/OLYG90hyIRbP5OVRK9yqkf5dg3l3UN/GmwUjmmlBELMEnBinR
         AVRS8uN7cnbpMdhHPC/dIgWWnv0urvibcgcuw32VT2v3GtXVox37tuYVf11F/5AsXR75
         HAXWSI+I5O3XeocnR2BCnMOeYCxIb+mydXqoh3bzpCdorYoimgWSKGoHXOngMCO+nDhD
         sJP/ZhFvYAaE1LlKnkMJU5QOEWis3VZCA9HGRHFExWX5sHvjTzHD/ibaWzBxjcEWA3P4
         oaAy6yTljtF6AIHzt6IK+ZD2T1qX3xxZImsftO+hA1DuTkFJE1+WUBSXawTwM4+nKS4E
         6t2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Qmii+y/AcNF/3IaoysaoSwbUreiK2GotAvn0cRg6OCo=;
        b=l3y4vZBW5G1YGUy2h0F9BHMIlNvLBmm+KU0B2+WdINWlntBJnMlgl0PuXVEmv6ti89
         zMlS1E3RJJTDOyuLn2rgCOE3peolcpGtrK99CzB3Vbdqbv/XTy7jF3F4RRFsQ7YK+l2K
         K3rzXTY7iGd4vhVJGN7rFhS6J5Xw4EWRT50KGxfgcEUJABk9bHQOwaesDmZbm/2qHK1f
         fFHRm/gK2grMqh/6YGuV9SE6mHy29UHf4HapoutFshbGGWx6Nel50iwCE/JzXbsTm0lf
         1QLtwAmg2C4p5Iol5TuceczzDGNp0ipRxDW91SNVaSm5V+pGGoARAnc/FLxNQOA4ipUM
         96EA==
X-Gm-Message-State: ANhLgQ0kyN3UC9y4y92NhfByFr7Ju9hSe5T5l8hSWG6Olprnji7+PFQr
        96f1Txl5AF4/+sjA7eoWSU3L9R5jTZn5XfnugvfGaw==
X-Google-Smtp-Source: ADFU+vtav6o/bnihXn2iB8YftH+/bmoXqpYdTtOQ4OeJHLeaMCZEmjlm8VxvL+9kjDSOTxO20pi5Nzxesf03O67paTY=
X-Received: by 2002:a25:c206:: with SMTP id s6mr37781574ybf.101.1584989248967;
 Mon, 23 Mar 2020 11:47:28 -0700 (PDT)
MIME-Version: 1.0
References: <20200323181814.87661-1-kuniyu@amazon.co.jp> <20200323181814.87661-3-kuniyu@amazon.co.jp>
In-Reply-To: <20200323181814.87661-3-kuniyu@amazon.co.jp>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 23 Mar 2020 11:47:17 -0700
Message-ID: <CANn89iLfqRCgsng=ZVxjU_WxL6kiymmicQ7Jn=K8pU0D9HNwEg@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] tcp/dccp: Remove unnecessary initialization
 of refcounted.
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Gerrit Renker <gerrit@erg.abdn.ac.uk>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        dccp@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        osa-contribution-log@amazon.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 23, 2020 at 11:22 AM Kuniyuki Iwashima <kuniyu@amazon.co.jp> wrote:
>
> When we get a TCP_NEW_SYN_RECV/DCCP_NEW_SYN_RECV socket by
> __inet_lookup_skb(), refcounted is already set true, so it is not
> necessary to do it again.

This changelog is absolutely not accurate.

sk is a listener here.
(because sk was set to req->rsk_listener;)

Please do not add confusion by mixing different things.

I prefer not relying on the old value of 'refcounted', since we
switched sk value.

Note that we call reqsk_put(req); regardless of 'refcounted'

I would rather not change this code and make future backports more complicated.

Thanks.
