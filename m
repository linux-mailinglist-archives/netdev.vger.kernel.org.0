Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C1552DDAAA
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 22:16:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731672AbgLQVPH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 16:15:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730768AbgLQVPG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 16:15:06 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95C57C0617A7;
        Thu, 17 Dec 2020 13:14:26 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id t22so189181pfl.3;
        Thu, 17 Dec 2020 13:14:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=X8jlvHg6Q7y3xiJzuJA/KXnJAwu4vh56DFFNSdAhHgo=;
        b=YmyKXAbxl+EEI5A3fL92uUTNa56/jhxrj7Pew7YWXtxSVlJG7oTStecsPLNoi+y4de
         dlNm1WjjVjIWMl/jA5DzBssSz7mUBMPA4qk0tWxaF15VTMCrUA424xRyt7XmFXNbUyUa
         5s+8FTnZ+FQR1w4jxBkddsaZU89RlF66JY3PC/4ooaZPVtXZinztM7Qk+sdTKbsDMw2D
         qKQivk+rYS2h56X1k6sP9CQ0MEIZTbChU07WCG9h7i/9YBI0XWKgQitWTQnG8rlNdrXr
         uKk9Alx6ZUrFfhQ1peEzipgsssfguMtj2A7DKfE2j/k5eDbnhh7KZT/08XoqJeFrAOcZ
         q0Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=X8jlvHg6Q7y3xiJzuJA/KXnJAwu4vh56DFFNSdAhHgo=;
        b=uNhQWarZxkQdswF/ORNI52XVSSYO5zgouup74JvvOa2h6f8Z31CdXPICm5Wj62/Xzk
         cuQt9hdIj9w63n4cez3cEw9bHq36yVycUVF7nkg8hkRUyBc3HO3YMZIq/twaxl69HwXo
         U2hum5hfbuDutMPHG9pFH5le/IjmMASuguWm34ZYR0XyUdzViANmq14yNN5vrTMODpEf
         w6oxk4DJ29Fjtjy3FgoYXMsM83heiajsWwhXpNm2uF+varjTqT+VWKMcq6s3jD0qID83
         0YGLlRLu8uRlZONRUdFthohxUaejEGBmefz2UORCszPBVb8H0CrbY4Rn+1WJ5qPdqfF+
         1GLA==
X-Gm-Message-State: AOAM531vuPdkDNDzNFXw9p+GmK5JjlzW4xsubSu+62rVzisetjj8rY2N
        lT/KCMKTXze+NX1goM984jrw96ElOrwvz5cmUEo=
X-Google-Smtp-Source: ABdhPJx+A+AZ+b8PrqUGvgQInAugU+o3zKmkIfQWobkx7kkfdwFVsyyGf8bnipMaXTVWN+mZz5aRr/diBK1fYTtlKq4=
X-Received: by 2002:a63:e109:: with SMTP id z9mr1137578pgh.5.1608239666081;
 Thu, 17 Dec 2020 13:14:26 -0800 (PST)
MIME-Version: 1.0
References: <20201214201118.148126-1-xiyou.wangcong@gmail.com>
 <20201214201118.148126-3-xiyou.wangcong@gmail.com> <CAEf4BzZa15kMT+xEO9ZBmS-1=E85+k02zeddx+a_N_9+MOLhkQ@mail.gmail.com>
 <CAM_iQpVR_owLgZp1tYJyfWco-s4ov_ytL6iisg3NmtyPBdbO2Q@mail.gmail.com>
 <CAEf4BzbyHHDrECCEjrSC3A5X39qb_WZaU_3_qNONP+vHAcUzuQ@mail.gmail.com>
 <CAM_iQpVBPRJ+t3HPryh-1eKxV-=2CmxW9T3OyO6-_sQVLskQVQ@mail.gmail.com>
 <CAEf4BzY4fdGieUbuAc4ttzfavBeGtE2a0rDmVfqpmZ6h6_dHiQ@mail.gmail.com> <CAM_iQpVsR=K344msuREEmidwXOeeZ=tdj4zpkrSX5yXz6VhijA@mail.gmail.com>
In-Reply-To: <CAM_iQpVsR=K344msuREEmidwXOeeZ=tdj4zpkrSX5yXz6VhijA@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 17 Dec 2020 13:14:14 -0800
Message-ID: <CAM_iQpXOts4YFsfaZYKiL-8u=v=0_vQ+DjML8g_JD0jPfz9kpw@mail.gmail.com>
Subject: Re: [Patch bpf-next v2 2/5] bpf: introduce timeout map
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Dongdong Wang <wangdongdong.6@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 16, 2020 at 10:29 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Wed, Dec 16, 2020 at 10:35 AM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> > Minimize duplication of the code, no one said copy/paste all the code.
> > But memory bloat is a real problem and should be justification enough
> > to at least consider other options.
>
> Sure, I have no problem with this. The question is how do we balance?
> Is rewriting 200 lines of code to save 8 bytes of each entry acceptable?
> What about rewriting 2000 lines of code? Do people prefer to review 200
> or 2000 (or whatever number) lines of code? Or people just want a
> minimal change for easier reviews?

No worry any more. I manage to find some way to reuse the existing
members, that is lru_node. So the end result is putting gc stuff into
the union with lru_node without increasing the size of htab_elem.
And of course, without duplicating/refactoring regular htab code.

Thanks.
