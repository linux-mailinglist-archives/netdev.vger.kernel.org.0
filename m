Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2691E44EB7B
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 17:35:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235142AbhKLQiD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 11:38:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233776AbhKLQiD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 11:38:03 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 360A6C061766
        for <netdev@vger.kernel.org>; Fri, 12 Nov 2021 08:35:12 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id d5so16549931wrc.1
        for <netdev@vger.kernel.org>; Fri, 12 Nov 2021 08:35:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZxF0SV4mZtKjBCn/kCnLzi9dyDXyrgnZfX9ZorbsjfU=;
        b=R0eyu3uGLr56+b7qzWdBxCY3DDuVPL9jjU771M0BGxb4yFeRynptkX+RzZFBlQ+IqM
         6Sa7wgP3wAoIOu0sUcWPu7DYNmR4YQNTzVQxt3Tnr+bpPJpJgDxWSMfUJJWRcumKO6aA
         tfT1Bs7kV0icHP++JLJS+D2lyfUQsimvMfcszqamPRTCpxoFQOHj2zGzEwT4KNCXr2jJ
         oVE6D8XFRQk0fqYwxB/7z7YADT+cnD5vmwSqi7QmESuhYTLbUTQoCNohLLVDhg/gWoeg
         traCI6/hBfs9hPTT0UH1VgNr0bsrKg5Q2Zguy7GsHmHQbqbS2tJ+jMJ8wepi7sisTmEm
         lzTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZxF0SV4mZtKjBCn/kCnLzi9dyDXyrgnZfX9ZorbsjfU=;
        b=sgks6/88KWz2xrUgTX0R6eEATdZP8tM+JGixbdmO/I6pdJmZaUdlKQ4nd1Fa8+3p1I
         5WkCXyTMPhzsXCx1OMH/MpQ6bBHtBK+oFDuTlATyU2vEaGaOT7Ml/jz/8K6xY3G7V7t0
         pIwbjGhVglwzK2qZ03wUw0cUMX3aQU2Xuz5BLvQKeSIUqHAMv+P4RQ6D2mMs3vjlOrC/
         5ASVU33lHkBNb/nmc8n4mXWFOsXntkDV+g3R36SrcQys57EcFTNw6q0ecOsC5lepltrW
         1MuwHHZTmqKotcz+yFRtq51PBGVKT0llz1JG2VoFuf+/mIazoIb/nx9iEmWDNTBCfLzP
         9i8g==
X-Gm-Message-State: AOAM531nxs9UNLJlhmEsrkzQ3+TXwWw0Cl+j5HchvEADdd5QdzyeUsI1
        B05ts8zhWTGk3FV8qMD+uSGp7VP5DFFA/q5GRKz5/Ev5lH8Yig==
X-Google-Smtp-Source: ABdhPJxBd5zS89T9XewSTlBA7dOjaiJOGVZ4GmBJeDl3CxTBcp8osBHkOZPTLWYcW/Ooe8N9aNkkQObYpz3WxFpWYk4=
X-Received: by 2002:a05:6000:11c3:: with SMTP id i3mr20355945wrx.426.1636734910653;
 Fri, 12 Nov 2021 08:35:10 -0800 (PST)
MIME-Version: 1.0
References: <cover.1636734751.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1636734751.git.lucien.xin@gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Fri, 12 Nov 2021 11:34:59 -0500
Message-ID: <CADvbK_eVXs_peRrz2-q=5KyZPsUGq=bXy-W7JsPGeNksRu96DQ@mail.gmail.com>
Subject: Re: [PATCH net 0/2] net: fix the mirred packet drop due to the
 incorrect dst
To:     network dev <netdev@vger.kernel.org>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, davem <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+Cc Davide.

On Fri, Nov 12, 2021 at 11:33 AM Xin Long <lucien.xin@gmail.com> wrote:
>
> This issue was found when using OVS HWOL on OVN-k8s. These packets
> dropped on rx path were seen with output dst, which should've been
> dropped from the skbs when redirecting them.
>
> The 1st patch is to the fix and the 2nd is a selftest to reproduce
> and verify it.
>
> Davide Caratti (1):
>   selftests: add a test case for mirred egress to ingress
>
> Xin Long (1):
>   net: sched: act_mirred: drop dst for the direction from egress to
>     ingress
>
>  net/sched/act_mirred.c                        | 11 +++--
>  tools/testing/selftests/net/forwarding/config |  1 +
>  .../selftests/net/forwarding/tc_actions.sh    | 47 ++++++++++++++++++-
>  3 files changed, 55 insertions(+), 4 deletions(-)
>
> --
> 2.27.0
>
