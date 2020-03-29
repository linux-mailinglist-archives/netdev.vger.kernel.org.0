Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 005641970F4
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 00:54:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729217AbgC2Wyn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 18:54:43 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:44993 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728857AbgC2Wyn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Mar 2020 18:54:43 -0400
Received: by mail-lf1-f66.google.com with SMTP id j188so12527721lfj.11
        for <netdev@vger.kernel.org>; Sun, 29 Mar 2020 15:54:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fG1FCfpblEeeyRVCOqihJyiegEdebBW/tbsZxLvpGqs=;
        b=MyJp/244+a+a3Cg9H3lGj5v7fdcZqqvXBEK5/ZDytptCJBBYHNSyPi/UFnPOxpQHDB
         VZfuMGC6PfX8sFNM71cI5qLW+kNXzrAgcXkOyqexMM8DAksV7SXKQd1WVvYZDFz7gby5
         5WJFB/qircGO/IczWSNzUuJessXnoQ0F9ANxo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fG1FCfpblEeeyRVCOqihJyiegEdebBW/tbsZxLvpGqs=;
        b=HkaJQMVWuVHIh6AQuMbGPjnintbr/yN2/1Z6VeO8H4Hy9S8bJMrLe1wWjV2mC2rKTE
         IqMKA4BFd8MJXe56BPVfUqY4B5Dzs8Hhf8MjL2HNjJARrqzfWwG6gTupAEVnpjwf+Jgk
         kfAxm2xPRePJ7KuQFVfMf7uFuuPgwX18i8NEE6eyVpyYTPPQRJkIG9zGceUlaYBYqR1g
         YyMBuwQT/TfAmb7+yzj1LK1Ly3Gu5Ws0vscPNrAkAJo4Ys/TxBFeyz0Vq2cRpzT/1bW2
         Ocw2eJ9WuZiTnsM+mNyV6GhqxUzv8HRhmvuC4zpRO3XVcRKVT3crJx9/TeIMmGwXECCW
         cgaw==
X-Gm-Message-State: AGi0PuYxYLMBKo0LItL0D3UwkMkditNZJpB+Crn73nQ5jV1+xBimOhlo
        WUzIjjyyJaaV4dn5He5EI+4CcDnkcAk=
X-Google-Smtp-Source: APiQypLKqHvyBCfWSxpakkfdjPRUs47d21j2HwcosUbFdERIC9E2wZ5n+xP7DURDttdLKovI4mhhmA==
X-Received: by 2002:ac2:4c88:: with SMTP id d8mr6431125lfl.100.1585522480267;
        Sun, 29 Mar 2020 15:54:40 -0700 (PDT)
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com. [209.85.167.54])
        by smtp.gmail.com with ESMTPSA id d19sm6051467lji.95.2020.03.29.15.54.39
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 Mar 2020 15:54:39 -0700 (PDT)
Received: by mail-lf1-f54.google.com with SMTP id u15so3440061lfi.3
        for <netdev@vger.kernel.org>; Sun, 29 Mar 2020 15:54:39 -0700 (PDT)
X-Received: by 2002:ac2:46d3:: with SMTP id p19mr472542lfo.125.1585522479223;
 Sun, 29 Mar 2020 15:54:39 -0700 (PDT)
MIME-Version: 1.0
References: <20200328.183923.1567579026552407300.davem@davemloft.net>
 <CAHk-=wgoySgT5q9L5E-Bwm_Lsn3w-bzL2SBji51WF8z4bk4SEQ@mail.gmail.com> <20200329.155232.1256733901524676876.davem@davemloft.net>
In-Reply-To: <20200329.155232.1256733901524676876.davem@davemloft.net>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun, 29 Mar 2020 15:54:23 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjDZTfj3wYm+HKd2tfT8j_unQwhP-t3-91Z-8qqMS=ceQ@mail.gmail.com>
Message-ID: <CAHk-=wjDZTfj3wYm+HKd2tfT8j_unQwhP-t3-91Z-8qqMS=ceQ@mail.gmail.com>
Subject: Re: [GIT] Networking
To:     David Miller <davem@davemloft.net>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 29, 2020 at 3:52 PM David Miller <davem@davemloft.net> wrote:
>
> Meanwhile, we have a wireless regression, and I'll get the fix for
> that to you by the end of today.

Oops. This came in just after I posted the 5.6 release announcement
after having said that there didn't seem to be any reason to delay.

Oh well.

                 Linus
