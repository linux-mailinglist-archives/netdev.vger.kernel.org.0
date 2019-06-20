Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 839AD4D1FF
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 17:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731980AbfFTPVU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 11:21:20 -0400
Received: from mail-yb1-f176.google.com ([209.85.219.176]:33943 "EHLO
        mail-yb1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726757AbfFTPVU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 11:21:20 -0400
Received: by mail-yb1-f176.google.com with SMTP id x32so1393365ybh.1
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 08:21:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WWcTTKF/82/ExwUFM1sAVWc5mPz5k5o+tscsjovzbdY=;
        b=sIyWfeXi6KwmuxnVzP1J8xyTlUH5LBx2rOkbUmIHEEbH4qtiKxfEot6fOUNodIzm22
         BOJW1KLRlcqTIDUm8mvA/hgZCQETxs35ZW/FmAUe6Zz32N7cSqPifP+EbGHCidGq3khp
         Eof5Mn2YrAR2RN89YJGr1V3fs4rAfIqkKhf4LvfOAOrYz+abZYmErCDqSUVwQkTUMKRq
         Vx4ZzS+Hgyd1dAsgOYqaHRnJYgP/FhxvvhspEM7MWOkB6uUALFE/ST9Kwm4Agq9rbdul
         Lbs78S9dLslqZ+yiWdtzwaU9D+5G10ulweUt/JDewc/ksWRSjfGvLCDAoDnMHSTGA8bi
         YjrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WWcTTKF/82/ExwUFM1sAVWc5mPz5k5o+tscsjovzbdY=;
        b=rjKZVyboYUy+KgHa332jGacec0O7S0Na4hM9dYfICB8CjTDTyPTk+/33ASt4JvSjPj
         AxppsVydEpbJxiyLpovgGfymE2DkuPzrWFmtYGtxKrPOFeqU0roH2UIhHFSvkgJm/rDn
         r5dvBlVdgYU1XyrRI4y7ZC6KgqeZEkAPNZETVOnpBQ19TEv2U4DzaEZg/26loFh3ANFp
         YGPMJNXVoa64tsJE6qmFMEiw1xutPYkyr0aRq99wjCf9cMEivtBcjrJefpc0Rwrq5rfR
         H5vMyFfAA5WbAA8lyuqKbnwDhds9w6Wh2QyYwL2Ll+rvsjcFeYwQ6Ku2Mcd5Pz6kYL1k
         VsLg==
X-Gm-Message-State: APjAAAUd+rkV4vJF8pN/lWChd4/B7RaRHSXPMBPa9np4EBDs/5eP0PqA
        +qNk40pL5mFdkSW39H+hsaUPMQxiHqxpT52IPgGtbQI5U8gEAA==
X-Google-Smtp-Source: APXvYqw+46mmXl47rsAlKbBelFwFwq7OOcf4h9cRWpPp+rUk2J7SVChb5VwvnPH8XQ2VsyehJ0FK86XudESDLPdUqXs=
X-Received: by 2002:a25:bf83:: with SMTP id l3mr67617590ybk.446.1561044078765;
 Thu, 20 Jun 2019 08:21:18 -0700 (PDT)
MIME-Version: 1.0
References: <1561042360-20480-1-git-send-email-cai@lca.pw>
In-Reply-To: <1561042360-20480-1-git-send-email-cai@lca.pw>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 20 Jun 2019 11:21:07 -0400
Message-ID: <CANn89iLBy+u3KTjjfvyc8-r4eUdL2b6VX=fNgqFg8f7t84EUNw@mail.gmail.com>
Subject: Re: [PATCH -next] inet: fix compilation warnings in fqdir_pre_exit()
To:     Qian Cai <cai@lca.pw>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 20, 2019 at 10:52 AM Qian Cai <cai@lca.pw> wrote:
>
> The linux-next commit "inet: fix various use-after-free in defrags
> units" [1] introduced compilation warnings,
>
> ./include/net/inet_frag.h:117:1: warning: 'inline' is not at beginning
> of declaration [-Wold-style-declaration]
>  static void inline fqdir_pre_exit(struct fqdir *fqdir)
>  ^~~~~~

Interesting warning, this is kind of new compiler major feature I guess :/

BTW :

$ git grep -n "static void inline"  | wc -l
9
