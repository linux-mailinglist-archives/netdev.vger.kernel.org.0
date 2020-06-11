Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 417701F6F03
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 22:50:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725873AbgFKUue (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 16:50:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726186AbgFKUud (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jun 2020 16:50:33 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5240C08C5C1
        for <netdev@vger.kernel.org>; Thu, 11 Jun 2020 13:50:32 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id q8so7940559iow.7
        for <netdev@vger.kernel.org>; Thu, 11 Jun 2020 13:50:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/nzXY/rjMjGOSpWYISd7S7NtrlCcPq12WC0DULXfYSI=;
        b=B++PglUL+VGA1Ufft0gIqAeI3TG5SAqrSA7bJQerq70CahPOcuHHXhs2uF++LAJjwD
         C6TIqVJ7yhiZGH7yyGQ4ZfHdRAXb11loYYhEqLdPynQ5zzmmgPq0NpE8tLPAGVaGhZ9n
         CF1VM0YIvAmxTIYh34bYYXcNSRlKLTdqIhIwWGbbXNh4gmcNACP9vNqvnKuJGX3Gguju
         HIz0yJWTueV7NfnSsP7KcI3w984FohdlWtjUBaEeMXbyIEUbMtJBwKIMbJDrDQP+AhAD
         2hegK6kT6GpJEEGEFygE/cC9q1pbsEtMXx8rnmgPN6+y55n7vmwqLOLTSrkBi0TtVGDj
         UasQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/nzXY/rjMjGOSpWYISd7S7NtrlCcPq12WC0DULXfYSI=;
        b=doHjEpzc62ghXb/u7wJpLCqeKIuiobm0auNhkQ1Q52EkbJe93prZJP2VGLPr1np8cO
         c8Bmv2U+OKjV8Qyik/+0aBtkVayNxYi/pctvQPuuNCRwud5hHVtRzEMuDF+SftYpvCIZ
         ks0V1h3Maks//9i+Blqo+DC5g1tMDpHhNxYtz1bdrwIt1VraXY7A2AaqAjFTlPUy1IuO
         kpBzEXUTP18NnlMp1RznXAzqYM72Ei197GkFTM9qwPI0mpMMpROw/vYP1D4IMgdk0+bO
         f2cHklAGK5hnP9R4iVC6nQrzALNIaq7GUjoiIO1vguYPv4n2/evdhwbFYKtLLj110Vfl
         SkEQ==
X-Gm-Message-State: AOAM530Q86hdxgics5UT7VQqqTzv7eJWgBzQ6Eax+7eDNhgkTMjZ0URz
        E95UkWlnm+b8BUHFVWksBqTZUC5uaGJLYk9Ct9c=
X-Google-Smtp-Source: ABdhPJwJgJnYNogFFS7h63jLBsy2weG3crslAytDjeEdb9cbSvQtio4NhHiBMBQf+CkLNm17LvxIi7Z+Rp025qjGD98=
X-Received: by 2002:a02:6cd8:: with SMTP id w207mr5079374jab.49.1591908632030;
 Thu, 11 Jun 2020 13:50:32 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1591824863.git.dcaratti@redhat.com> <8ef32bd7f2afa7e3eba5b67872b56440e6154d5a.1591824863.git.dcaratti@redhat.com>
In-Reply-To: <8ef32bd7f2afa7e3eba5b67872b56440e6154d5a.1591824863.git.dcaratti@redhat.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 11 Jun 2020 13:50:20 -0700
Message-ID: <CAM_iQpX33ZTz0UHwcpH7ehFE4MjmB14fuLHHRFkVYYOqv+FCwA@mail.gmail.com>
Subject: Re: [PATCH net 2/2] net/sched: act_gate: fix configuration of the
 periodic timer
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     Po Liu <Po.Liu@nxp.com>, "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 10, 2020 at 2:43 PM Davide Caratti <dcaratti@redhat.com> wrote:
> +static void gate_setup_timer(struct tcf_gate *gact, u64 basetime,
> +                            enum tk_offsets tko, s32 clockid,
> +                            bool do_init)
> +{
> +       bool timer_change = basetime != gact->param.tcfg_basetime ||
> +                           tko != gact->tk_offset ||
> +                           clockid != gact->param.tcfg_clockid;
> +
> +       if (!do_init) {
> +               if (timer_change) {
> +                       spin_unlock_bh(&gact->tcf_lock);
> +                       hrtimer_cancel(&gact->hitimer);
> +                       spin_lock_bh(&gact->tcf_lock);
> +                       goto init_hitimer;
> +               }
> +               return;
> +       }
> +
> +init_hitimer:
> +       gact->param.tcfg_basetime = basetime;
> +       gact->param.tcfg_clockid = clockid;
> +       gact->tk_offset = tko;
> +       hrtimer_init(&gact->hitimer, clockid, HRTIMER_MODE_ABS_SOFT);
> +       gact->hitimer.function = gate_timer_func;
> +}

This function would be more readable if you rewrite it like this:

if (!do_init && !timer_change)
  return;
if (timer_change) {
...
}
...

The rest looks good to me.

Thanks.
