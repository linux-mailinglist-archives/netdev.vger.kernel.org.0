Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FD1246D1F
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 02:08:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726756AbfFOAI6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 20:08:58 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:41209 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725981AbfFOAI5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 20:08:57 -0400
Received: by mail-qk1-f195.google.com with SMTP id c11so2812424qkk.8
        for <netdev@vger.kernel.org>; Fri, 14 Jun 2019 17:08:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=IgxmHxBGexTXN5xRx0qHLFvabR9vgokcyVqBtBYU39U=;
        b=Up0hXnt7yywp5bUgYE9qnesNwGZ2LDr0H/PxpGR9a10pl81csl3VRlT0lk4mO/dXvo
         obOQRe38hPitA9BbJsWsJVbXcYMZZNxU45l9gkHhrblp9zeAQjZKsGS3VV7M2b02jWTZ
         PH2+sp9ZD+rbfzj4XpPkjHoGZ4pGlw4ol70ZFcxXAzxBP7RaeDyCCj16PHbXbgbFaODR
         k5JaQ35ibf37SvASwEmtiObqA3pDyasAN67iP2bmH8tWFqTSUsW7HrcmPyhmQ6++1OaQ
         tjq9SuYRqpc2akIA7P9Cj4dgzxFzwB+wC1UNQ4TMFuc4XTgX1vFer9et/tI2HORGx62i
         NyUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=IgxmHxBGexTXN5xRx0qHLFvabR9vgokcyVqBtBYU39U=;
        b=t8CnFDvwrEfZ6cHWmm1DEiPse/PiZiioII6Ihsv8JKKF04D07BmVLsg6KZunrObppM
         Px4mcJ4BAbY443SHrXoCLm78XWta3Qnd2dJj2M24dUHkahkvykYXNJMQYoWT7xmuRj6/
         YgYvkpUa/+PsuKlXC1UZ0XHwR5mND1DNY+0fzX/ia7j8CtV9eGnTYi2QIsTCGnP9uoAy
         w1z7cA1LTfc0XapQm1IsJaNqdbN/vcYkcWkb7PhoB9uWvvMCCmQ1g8rzC6AyxI+k8Ud3
         isF7e2BM9VM+Nu2Ee5cMWIo4SluqIXzu8JLJHbtFziNQeFui2ayopeDIFboTtRU+USip
         A1Bg==
X-Gm-Message-State: APjAAAWSmmCmBqvnBVe7OnLNVOoRjxUyLpYmSc/cJEenHMJ1nkeCzsy2
        BNNLiZ7BXJm52rqwmRhegWDp7/nsFe6gUg4zU8iYpvvd
X-Google-Smtp-Source: APXvYqxn80GTaQSEE5yXnNu8kJrj3CgUiArLxf0n485HjHsQ6E+xZ5sue8ZfFP/6DDl5tCqlFvsWC1Q5Jykg//yWJXA=
X-Received: by 2002:ae9:de81:: with SMTP id s123mr9417371qkf.339.1560557336627;
 Fri, 14 Jun 2019 17:08:56 -0700 (PDT)
MIME-Version: 1.0
References: <156042464138.25684.15061870566905680617.stgit@alrua-x1> <156042464164.25684.10124291261871041128.stgit@alrua-x1>
In-Reply-To: <156042464164.25684.10124291261871041128.stgit@alrua-x1>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 14 Jun 2019 17:08:45 -0700
Message-ID: <CAEf4Bzb_vB7VSCAEuXa_Rh04NzbOf8=0TzZ-yW8mV9uK3Jimsg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 3/3] devmap: Allow map lookups from eBPF
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Networking <netdev@vger.kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 13, 2019 at 8:31 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> We don't currently allow lookups into a devmap from eBPF, because the map
> lookup returns a pointer directly to the dev->ifindex, which shouldn't be
> modifiable from eBPF.
>
> However, being able to do lookups in devmaps is useful to know (e.g.)
> whether forwarding to a specific interface is enabled. Currently, program=
s
> work around this by keeping a shadow map of another type which indicates
> whether a map index is valid.
>
> Since we now have a flag to make maps read-only from the eBPF side, we ca=
n
> simply lift the lookup restriction if we make sure this flag is always se=
t.
>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>
