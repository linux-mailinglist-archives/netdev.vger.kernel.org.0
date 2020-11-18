Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 315102B833B
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 18:42:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727857AbgKRRj7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 12:39:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725943AbgKRRj7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 12:39:59 -0500
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2B5CC0613D4
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 09:39:58 -0800 (PST)
Received: by mail-yb1-xb44.google.com with SMTP id s8so2427843yba.13
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 09:39:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=8KABC7APAn8HWA8TUE8T9+tys79NOmtJFfJcRi/4C4I=;
        b=eBC9l5RtAldDUzm/Swnmpe8GqncqaMDFpvz2ziv0bpSiC3Fb3e7bAuLhGf88gU27Ic
         MTWO+KKN1t6975nkjXyDaFXvYNNy21AsmOnZsPw1QSZK/MJWJRScQa0O+Xb+ZPMu13Ne
         CsYhb+T67dN/V8GWLd8ZBJ2RnBre1115cEVjM2Vh+K7fMDUPrI1rKwaH3iM9HQNidTUC
         ly9dUrBGxzAtx6qKhFpytW5VITlBmv/AtQAVgwggZn5O2C0wSllBykp/FhDQ4Gz1ZQ48
         s2xKhQJjMWfdZdUllPSv+T+SWiLKvsmQ/idhZkv5u8BT+quh4IA+TnZHzbo1goW7WGI3
         q0rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=8KABC7APAn8HWA8TUE8T9+tys79NOmtJFfJcRi/4C4I=;
        b=XCW1F2VTi3ZdS8I02FhRJj0lGcypAnrMj9i0H25Y1YYSwNyl7lLvDV6Ak/tn86/tL/
         +2L3iPk1455I4aeq7DoM7bF8T6dp/oIFM+E1D4GlU0zgX6LPi77t9g0FubshkRu2xLPl
         vkvO0TaWAMcoo9ln9tt6fRoBQ4UzoKQXgkiVQCym4OdhUpWvHnlHC/3f6g2f7PYAG60Y
         sMHW8na9M+VJIIDq7reaTXGb3FLFu0PqlE0Y+d1m3gyVVQZNjzq/rOfVjCh1EjrjDNoD
         qcjfXZvK6lY9znL68iQcVDXuqO8pWqck/pb7UecFWfyVbAB8dJS3wJew0HmhOYy99B68
         5TEQ==
X-Gm-Message-State: AOAM532BHvqkIbtHojNBcYqnfHz2ZWWXKquWTQNyhqhCnCzEdUIAegS0
        s/erMoyWzt1SzL3JyAIefI2nWkw74ZwtgwxUL8krPw==
X-Google-Smtp-Source: ABdhPJyIE2ulk8C+0sDc6GnwZF0VpOpamECPcMk9eLOaLKYgEDsPN+7xMnBUuD0/w/7azmUdtnrY2RK2/tFdSPTyrWQ=
X-Received: by 2002:a25:6ec3:: with SMTP id j186mr7542169ybc.335.1605721197822;
 Wed, 18 Nov 2020 09:39:57 -0800 (PST)
MIME-Version: 1.0
References: <20201111204308.3352959-1-jianyang.kernel@gmail.com>
 <20201114101709.42ee19e0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAF2d9jgYgUa4DPVT8CSsbMs9HFjE5fn_U8-P=JuZeOecfiYt-g@mail.gmail.com>
 <20201116123447.2be5a827@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAF2d9ji24VkLipTCFSAU+L8yqKt9nfPSNfks9_V1Tnb0ztPrfA@mail.gmail.com>
 <20201117171830.GA286718@shredder.lan> <CAF2d9jhJq76KWaMGZLTTX4rLGvLDp+jLxCG9cTvv6jWZCtcFAA@mail.gmail.com>
 <b3445db2-5c64-fd31-b555-6a49b0fa524e@gmail.com> <7e16f1f3-2551-dff5-8039-bcede955bbfc@6wind.com>
In-Reply-To: <7e16f1f3-2551-dff5-8039-bcede955bbfc@6wind.com>
From:   =?UTF-8?B?TWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS14KS+4KSwKQ==?= 
        <maheshb@google.com>
Date:   Wed, 18 Nov 2020 09:39:41 -0800
Message-ID: <CAF2d9jiD5OpqB83fyyutsJqtGRg0AsuDkTsS6j4Fc-H-FHWiUQ@mail.gmail.com>
Subject: Re: [PATCH net-next] net-loopback: allow lo dev initial state to be controlled
To:     nicolas.dichtel@6wind.com
Cc:     David Ahern <dsahern@gmail.com>, Ido Schimmel <idosch@idosch.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jian Yang <jianyang.kernel@gmail.com>,
        David Miller <davem@davemloft.net>,
        linux-netdev <netdev@vger.kernel.org>,
        Jian Yang <jianyang@google.com>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 18, 2020 at 8:58 AM Nicolas Dichtel
<nicolas.dichtel@6wind.com> wrote:
>
> Le 18/11/2020 =C3=A0 02:12, David Ahern a =C3=A9crit :
> [snip]
> > If there is no harm in just creating lo in the up state, why not just d=
o
> > it vs relying on a sysctl? It only affects 'local' networking so no rea=
l
> > impact to containers that do not do networking (ie., packets can't
> > escape). Linux has a lot of sysctl options; is this one really needed?
> >
I started with that approach but then I was informed about these
containers that disable networking all together including loopback.
Also bringing up by default would break backward compatibility hence
resorted to sysctl.
> +1
>
> And thus, it will benefit to everybody.

Well, it benefits everyone who uses networking (most of us) inside
netns but would create problems for workloads that create netns to
disable networking. One can always disable it after creating the netns
but that would mean change in the workflow and it could be viewed as
regression.
