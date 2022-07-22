Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE3E657E9A3
	for <lists+netdev@lfdr.de>; Sat, 23 Jul 2022 00:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236314AbiGVW1p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 18:27:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234255AbiGVW1p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 18:27:45 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D7268D5CD
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 15:27:44 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id s188so7089828oie.0
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 15:27:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CcuiPvBW+hW8D7z0gFEllDUeKqCv7YHCr1OAa5+6XzE=;
        b=4TvRam5ukjVVe8JnDmc16TBCdOwZSfj8pJ2ktzO/pddhS+72X0U/JjLHReoPf1KY+L
         ORzwT6JCkTNhvs8dr+jiJbO5BrjPS12JMVYc+YMMI86cAUXNuCMxAWVn2YuW5fnbrfms
         x3HX0Ah+bglS9zL65V/JsxsSEF2u5jKnE4FNAl8q0ERz2LABYYMGYX9h+pLlC1Lhu79u
         jlnvEEefG69QNZAi3/s5gfgl5RWBimmp5ziFck17VJFthmxVkZzt5zEnHIfPzbHILANI
         EiNzHi25aaAI3aSVKaCfzJPfkNtsQpvpsxvfgAd8i6bxPx7Op1+bWmCUZIv7Qqs9gxiX
         OGEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CcuiPvBW+hW8D7z0gFEllDUeKqCv7YHCr1OAa5+6XzE=;
        b=UtTAacC10hkMsEXYbw8tJPM7YOuwn83kw2Cow6VYFe2svxn5M85IuMF2y6zf1LnECX
         Y2ui8eIqNHqYmf82NZBR3gEYYjCVMY9Gj54bNQN85pY6ip+tSgR1k9JNQ4v89dsMkOg7
         gy3XzfcqzhZ/pjoVYOa3Lj2DRV3z5Zi0yajNeY8Q+PhmKuvP5yZCG8wB6oTJtWFFf874
         7b4ay04EZXz3Kq0oBAM0Xjgdni8mUi3M4X8Q5huu3KrA4WFbCTHQwvKKYvvBJZV4KdPG
         HRAi4rxPZ368wSl66qshbf9lacMQ19bkNDtB13PrdhJTol/Jy0rDLJRidVmj2ImJr1gW
         leJg==
X-Gm-Message-State: AJIora/Jx3pqXKGQ3L6D67FDnY5lUjOwwJ5aazMfeK8iXmjQnrlK4Vo3
        mFPRXBf37sZaENJkvvZfiYza4J14nsHzwuAhHLolOw==
X-Google-Smtp-Source: AGRyM1vbgHuwGubHwjoJm9WIp+tqCf/j+Atfn7qt9u/pqkXXNftWBCviASChTaDSElYGVUOBiN5bH72juWQDH8pueb4=
X-Received: by 2002:a54:4618:0:b0:326:9f6e:edc6 with SMTP id
 p24-20020a544618000000b003269f6eedc6mr844798oip.2.1658528863393; Fri, 22 Jul
 2022 15:27:43 -0700 (PDT)
MIME-Version: 1.0
References: <c2ef23da1d9a4eb62f4e7b7c4540f9bafb553c15.1658420239.git.dcaratti@redhat.com>
In-Reply-To: <c2ef23da1d9a4eb62f4e7b7c4540f9bafb553c15.1658420239.git.dcaratti@redhat.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Fri, 22 Jul 2022 18:27:32 -0400
Message-ID: <CAM0EoMmnkkZryqBMDuoH78Y5R-61beeUg5tDNb0oXDo7GkZjvw@mail.gmail.com>
Subject: Re: [PATCH net-next] net/sched: act_mirred: avoid printout in the
 traffic path
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

You dont want to use the target device if it is operationally/admin down.
But if that happens momentarily then it comes back up - what happens then?

cheers,
jamal



On Thu, Jul 21, 2022 at 12:19 PM Davide Caratti <dcaratti@redhat.com> wrote:
>
> when tc-mirred outputs to a device that's not up, dmesg is cluttered with
> messages like:
>
>  tc mirred to Houston: device br-int is down
>
> we can't completely remove this printout: users might be relying on it to
> detect setups where tc-mirred drops everything, as discussed earlier [1].
> however, we can at least reduce the amount of these messages, and improve
> their content as follows:
>  - add a pr_notice(...) in the .init() function, to warn users of missing
>    IFF_UP flag on the target of a newly added tc-mirred action
>  - check for NETDEV_DOWN in the .notifier_call() function, and add proper
>    pr_notice(...) to warn users of missing/down target devices
>
> [1] https://lore.kernel.org/netdev/CAM_iQpUvn+ijyZtLmca3n+nZmHY9cMmPYwZMp5BTv10bLUhg3Q@mail.gmail.com/
>
> Suggested-by: Cong Wang <xiyou.wangcong@gmail.com>
> CC: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>
> ---
>  net/sched/act_mirred.c | 34 +++++++++++++++++++---------------
>  1 file changed, 19 insertions(+), 15 deletions(-)
>
> diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
> index a1d70cf86843..4af6073e472b 100644
> --- a/net/sched/act_mirred.c
> +++ b/net/sched/act_mirred.c
> @@ -178,6 +178,13 @@ static int tcf_mirred_init(struct net *net, struct nlattr *nla,
>                         err = -ENODEV;
>                         goto put_chain;
>                 }
> +               if (!(ndev->flags & IFF_UP))
> +                       pr_notice("tc mirred: action %i %s on %s while device is down",
> +                                 m->tcf_index,
> +                                 tcf_mirred_is_act_redirect(parm->eaction) ?
> +                                       "redirects" : "mirrors",
> +                                 ndev->name);
> +
>                 mac_header_xmit = dev_is_mac_header_xmit(ndev);
>                 odev = rcu_replace_pointer(m->tcfm_dev, ndev,
>                                           lockdep_is_held(&m->tcf_lock));
> @@ -251,16 +258,8 @@ static int tcf_mirred_act(struct sk_buff *skb, const struct tc_action *a,
>         m_eaction = READ_ONCE(m->tcfm_eaction);
>         retval = READ_ONCE(m->tcf_action);
>         dev = rcu_dereference_bh(m->tcfm_dev);
> -       if (unlikely(!dev)) {
> -               pr_notice_once("tc mirred: target device is gone\n");
> +       if (unlikely(!dev || !(dev->flags & IFF_UP)))
>                 goto out;
> -       }
> -
> -       if (unlikely(!(dev->flags & IFF_UP))) {
> -               net_notice_ratelimited("tc mirred to Houston: device %s is down\n",
> -                                      dev->name);
> -               goto out;
> -       }
>
>         /* we could easily avoid the clone only if called by ingress and clsact;
>          * since we can't easily detect the clsact caller, skip clone only for
> @@ -397,16 +396,21 @@ static int mirred_device_event(struct notifier_block *unused,
>         struct tcf_mirred *m;
>
>         ASSERT_RTNL();
> -       if (event == NETDEV_UNREGISTER) {
> +       if (event == NETDEV_UNREGISTER || event == NETDEV_DOWN) {
>                 spin_lock(&mirred_list_lock);
>                 list_for_each_entry(m, &mirred_list, tcfm_list) {
>                         spin_lock_bh(&m->tcf_lock);
>                         if (tcf_mirred_dev_dereference(m) == dev) {
> -                               netdev_put(dev, &m->tcfm_dev_tracker);
> -                               /* Note : no rcu grace period necessary, as
> -                                * net_device are already rcu protected.
> -                                */
> -                               RCU_INIT_POINTER(m->tcfm_dev, NULL);
> +                               pr_notice("tc mirred: target device %s is %s\n",
> +                                         dev->name,
> +                                         event == NETDEV_UNREGISTER ? "gone" : "down");
> +                               if (event == NETDEV_UNREGISTER) {
> +                                       netdev_put(dev, &m->tcfm_dev_tracker);
> +                                       /* Note : no rcu grace period necessary, as
> +                                        * net_device are already rcu protected.
> +                                        */
> +                                       RCU_INIT_POINTER(m->tcfm_dev, NULL);
> +                               }
>                         }
>                         spin_unlock_bh(&m->tcf_lock);
>                 }
> --
> 2.35.3
>
