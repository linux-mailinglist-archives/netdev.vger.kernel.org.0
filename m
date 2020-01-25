Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3EDF1496B9
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 17:53:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726769AbgAYQxR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 11:53:17 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:43951 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725843AbgAYQxR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jan 2020 11:53:17 -0500
Received: by mail-ed1-f67.google.com with SMTP id dc19so6218357edb.10
        for <netdev@vger.kernel.org>; Sat, 25 Jan 2020 08:53:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Qk5f72+Sib4giyAxY8nYWtuTCwjbZA5ibLvCozb5LHg=;
        b=KV0Xl9kYjpcS3+KVjnNBB+TORM6SYhWRIvCdWa+crTgnMPvAY1/Ead3ABs5AzZMkCX
         scTVr3SPgEJpJvj80tdfA6O37J6x8Cl+iftA3zlvM+EPtoIJzdJq4Gyo2mvrqyXMxZy/
         gp9HHlh8uPB5tqmQLOnszrrGgagRvew/N+efdjoVWpF0qR8t+Cve0CjnCyBpAUsi3eId
         xGj94p0wxZy64CEe5jXAYWOjZbg+RciVke0LCncGQAUaSweDwfCQP8frYKylUs2vyNAr
         HEOcefe+1HzZk2/Mt1gXzVX1uG0aP8OnmpGqGS6p+wgmlhUyXXbGki8bXyJq4XYWUVvV
         ICLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Qk5f72+Sib4giyAxY8nYWtuTCwjbZA5ibLvCozb5LHg=;
        b=R23fLcCgVAF+qm4xSwrnXvOFgvrY+4yzo72S8upS7pbtb7l1lVij/twWQLfLMYIIze
         RwhTjGpkSQ3QyKV1Xf4Wi0wxw61vSmPJxHMVDoJx33BM6AuYylkTA9eZhMGK9JjsMLGh
         EjF0/OYIzhTfTp+7Lm/hYu+9V+puxJy2Wo0qJNzPShSOgsdibLhR9lWdEmzY+t23Wd7D
         sHGgkx+lJFnXoSQHM7RLCeni3C9i0+PiYg5x2RT2wI5LYz9WZQrH07g68mBNU9cG4Xti
         s7siGLuTioDjUE5oEqgEipK1YwyCzmBu4UrZknsIcoLnpxdZVYNqIS/m/JobN+mCZDbP
         nBaw==
X-Gm-Message-State: APjAAAX/mEWKPib3ZKq2myrSW0wvIwHnytg57tZaMC1BBS1QuSU2WE9E
        J0hclLn9HsYzKPtBCISM8FrUvD2KRAKkUXIlSQc=
X-Google-Smtp-Source: APXvYqyWGj39qGGuiTklRw8o8WLWYktmiCPOxb5Z2VAXDshP/dMmUJgRT1TcGciEqKY7BAV8RZt8IdL3xABgEjlBAHE=
X-Received: by 2002:a17:906:1e48:: with SMTP id i8mr6787584ejj.189.1579971195773;
 Sat, 25 Jan 2020 08:53:15 -0800 (PST)
MIME-Version: 1.0
References: <20200125005320.3353761-1-vinicius.gomes@intel.com> <20200125005320.3353761-2-vinicius.gomes@intel.com>
In-Reply-To: <20200125005320.3353761-2-vinicius.gomes@intel.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sat, 25 Jan 2020 18:53:04 +0200
Message-ID: <CA+h21hob4SxGAprR5qXA+DP5VAQxmwEewP7GBfSGLSi18GdgMA@mail.gmail.com>
Subject: Re: [PATCH net v1 1/3] taprio: Fix enabling offload with wrong number
 of traffic classes
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Po Liu <po.liu@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 25 Jan 2020 at 02:53, Vinicius Costa Gomes
<vinicius.gomes@intel.com> wrote:
>
> If the driver implementing taprio offloading depends on the value of
> the network device number of traffic classes (dev->num_tc) for
> whatever reason, it was going to receive the value zero. The value was
> only set after the offloading function is called.
>
> So, moving setting the number of traffic classes to before the
> offloading function is called fixes this issue. This is safe because
> this only happens when taprio is instantiated (we don't allow this
> configuration to be changed without first removing taprio).
>
> Fixes: 9c66d1564676 ("taprio: Add support for hardware offloading")
> Reported-by: Po Liu <po.liu@nxp.com>
> Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> ---

Acked-by: Vladimir Oltean <vladimir.oltean@nxp.com>

>  net/sched/sch_taprio.c | 26 +++++++++++++-------------
>  1 file changed, 13 insertions(+), 13 deletions(-)
>
> diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
> index c609373c8661..ad0dadcfcdba 100644
> --- a/net/sched/sch_taprio.c
> +++ b/net/sched/sch_taprio.c
> @@ -1444,6 +1444,19 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
>
>         taprio_set_picos_per_byte(dev, q);
>
> +       if (mqprio) {
> +               netdev_set_num_tc(dev, mqprio->num_tc);
> +               for (i = 0; i < mqprio->num_tc; i++)
> +                       netdev_set_tc_queue(dev, i,
> +                                           mqprio->count[i],
> +                                           mqprio->offset[i]);
> +
> +               /* Always use supplied priority mappings */
> +               for (i = 0; i <= TC_BITMASK; i++)
> +                       netdev_set_prio_tc_map(dev, i,
> +                                              mqprio->prio_tc_map[i]);
> +       }
> +
>         if (FULL_OFFLOAD_IS_ENABLED(taprio_flags))
>                 err = taprio_enable_offload(dev, mqprio, q, new_admin, extack);
>         else
> @@ -1471,19 +1484,6 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
>                 q->advance_timer.function = advance_sched;
>         }
>
> -       if (mqprio) {
> -               netdev_set_num_tc(dev, mqprio->num_tc);
> -               for (i = 0; i < mqprio->num_tc; i++)
> -                       netdev_set_tc_queue(dev, i,
> -                                           mqprio->count[i],
> -                                           mqprio->offset[i]);
> -
> -               /* Always use supplied priority mappings */
> -               for (i = 0; i <= TC_BITMASK; i++)
> -                       netdev_set_prio_tc_map(dev, i,
> -                                              mqprio->prio_tc_map[i]);
> -       }
> -
>         if (FULL_OFFLOAD_IS_ENABLED(taprio_flags)) {
>                 q->dequeue = taprio_dequeue_offload;
>                 q->peek = taprio_peek_offload;
> --
> 2.25.0
>
