Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CAC9DF5AF
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 21:08:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730106AbfJUTHk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 15:07:40 -0400
Received: from mail-lj1-f182.google.com ([209.85.208.182]:34161 "EHLO
        mail-lj1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728543AbfJUTHj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 15:07:39 -0400
Received: by mail-lj1-f182.google.com with SMTP id j19so14550158lja.1
        for <netdev@vger.kernel.org>; Mon, 21 Oct 2019 12:07:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BSOTEpR1iANma8ay32cYmdCfvX2esIgnM2QlJRcRyTg=;
        b=QA/0Od4dok65WKNqL596SVzzaRnW0JhUSFfefFarcKUTsFn6ctQS16tDFqRRiO6UTa
         I+Wl9moaJ8RG01vybjPbuFtn+yTnKYFi2TINkT+k9BvG4avXF2toXpuZ2IUmQul6bfh/
         THbIUIHQGDgzwYTif50kCCk9xupulxRsUykwYSqj/w1T/WXYMX2OBnFu/18CSYje932X
         ZGoS0eDHE6IEhc0+WX/BJGWmwW5BL8G0aHFf2QA84yOU4MlrFcrxPeGZOzU4U7x1SbA1
         Vu710BtPZ6pvPvkKtP8OoJB3+vP6mOomCqq4m2mi+8aSkcKBMOtzc84R0wEAGLRupmBw
         fLVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BSOTEpR1iANma8ay32cYmdCfvX2esIgnM2QlJRcRyTg=;
        b=tYS5rY7b1ru7zLgeQfSlYJzIPt8ghNXNWHUW1I8QFNratAWd/Oi9DvWt4RVXSPeNix
         iceWqOAwERoO2XLfVWoX2J/o4DArUEkmXzoVNdUFsUIO813SPYVgGD/ZTsL5ZaEYiu/R
         O7VfNBApp/Mffk5rPaBugu7JRa92HtbmrXRtJZPgRE03pWoaKtRuhW3RQIgnxuyroobC
         7eGXReNvBOzKBVMP8SvAf62SWedE8umdpEbHAnjKhaVHyUoxEuGQXELailYs+duXaT7V
         w4Mt6hNwp2JiPelotCwFPcwR2xWXJ9QwyRLGl8sS4EW6Z2kM6FeZ8m8kiAIbOsG0Ke1L
         9QAw==
X-Gm-Message-State: APjAAAVPrEvSKQFlAVK7x9JUnMchlR3I4CTLCtHDnOcUFY0Mmcn3LYhg
        yTYpKQUMUhkX7EjrGAk0lqZCspB5055NT/j5u+8=
X-Google-Smtp-Source: APXvYqxIRuzHq3YeIYqLbid/cxrL33LIn4UOXW3e/ltg8iugnsQsmqEfdzJOOBbEgv6U47sWF7gaqhY+atiLNng04u4=
X-Received: by 2002:a05:651c:150:: with SMTP id c16mr16566929ljd.222.1571684857472;
 Mon, 21 Oct 2019 12:07:37 -0700 (PDT)
MIME-Version: 1.0
References: <1571425340-7082-1-git-send-email-jbaron@akamai.com>
 <CAJ75kXa0EcXtn6xBNCr56A_Auzm9NOtPGhXUTGvSARKgfOjTcw@mail.gmail.com> <b781b46f-2682-6f59-1f61-312135b0924c@gmail.com>
In-Reply-To: <b781b46f-2682-6f59-1f61-312135b0924c@gmail.com>
From:   William Dauchy <wdauchy@gmail.com>
Date:   Mon, 21 Oct 2019 21:07:25 +0200
Message-ID: <CAJ75kXbyhCxR+X+x+EAkd9m=fpMQQ8ti7+CeY9GBfR6rtSo0Aw@mail.gmail.com>
Subject: Re: [net-next] tcp: add TCP_INFO status for failed client TFO
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Jason Baron <jbaron@akamai.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        NETDEV <netdev@vger.kernel.org>,
        Neal Cardwell <ncardwell@google.com>,
        Christoph Paasch <cpaasch@apple.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Eric,

On Mon, Oct 21, 2019 at 9:02 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Reporting tsval/tsecr values were not well defined and seemed quite experimental to me.
>
> TCP fastopen would use 2 unused bits, not real extra cost here.
>
> This is persistent information after the connect(), while your tsval/tsecr report
> seems quite dynamic stuff can be stale as soon as the info is fetched from the kernel.

Thanks for your answer. I better understand the context.

-- 
William
