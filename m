Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 217DCE1896
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 13:13:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404631AbfJWLNg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 07:13:36 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:34934 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404543AbfJWLNg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 07:13:36 -0400
Received: by mail-io1-f68.google.com with SMTP id t18so20278426iog.2;
        Wed, 23 Oct 2019 04:13:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=lrwdiC1W13nkBw6PvIySSzmlkqcAXs6uz34ttlriSM4=;
        b=V6TG3GeGuB4uvHWU+WLIJXl/NpYc5n73qx6h/YC9ctN+EnCFE+Wme1IYVHm/aFec+f
         mpUeI6XhxrZJ93nkDo8pJRN8q0ZtWFVtERvBr9vHDKRg6x94+t+uFNF2QP6D0c+xEdx4
         tI/HIxBdITAk3sa2xJwxMxyw1xl8ywOraLvCR4NlzN4l5j8lvfJtol/Z3+UH7J6icGfn
         EhZY//I/ECCOfK5RWpIyqlT5Uv87JTetLnMTC0Gns+YtLqkpayey5saW4ejNZzghkeIr
         FLZxiLQ+J/vV+jmwS4bdCWZYEZns6NP1QNN4OIK0PCPwRj2iF69pphmZIStFek8M15dk
         KPgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=lrwdiC1W13nkBw6PvIySSzmlkqcAXs6uz34ttlriSM4=;
        b=WmA+pNSn/jDH+NUBIl/mSmKEVrp8AeM60rKz9qjspoQOALA/O9Y6bdOXThPz0sfDnH
         AEM0O0J/4oU3kZlxWMBToo1Et7NaAnJfxirLrkYTxFMgkwFNhZoC7ZrtptA7wiq4d38q
         VmMsFr8yC6YwC6CiakcJQ7KUmYFPJcqiQr2qZVSL6vkqELUyl6oPFgcHFb0CBg89WJ4Q
         jLmbR3/WEP7RTRhEHaFzbtNkWUY+a1KFaehJGsBdduNb8IKwH2mvOYqpNmtNwDg8W838
         lhOxQi0oEpauArfJiErNU8al+GWfMaCWCXpqQNo7j42WpswXQcVvhgg0Xd4O3UR4VYH6
         6KnQ==
X-Gm-Message-State: APjAAAWqgtbe9uGV3qQTTcX0G5Mnhcyv+PScT/C48i8R7C9jsqlVhQMW
        ggswzqMcG6ZcYeKZPxqv06sOXuXQwGRDdnYJTH4=
X-Google-Smtp-Source: APXvYqwcZPpGb937kYA4ugVCdPW+wUH5NimR5e/DyjE+IYSZjS/a59lyBFzc/uaapAsu4Vg3gub+C8tA9Mz0pH6HPos=
X-Received: by 2002:a6b:2c15:: with SMTP id s21mr2554226ios.249.1571829213014;
 Wed, 23 Oct 2019 04:13:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190327165632.10711-1-mkl@pengutronix.de> <1571827920-9024-1-git-send-email-vincent.prince.fr@gmail.com>
In-Reply-To: <1571827920-9024-1-git-send-email-vincent.prince.fr@gmail.com>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Wed, 23 Oct 2019 04:13:22 -0700
Message-ID: <CAA93jw6koAuvuAXYBghJYcxwTz-uhvxPohFj9kBrpBDcQmmxMg@mail.gmail.com>
Subject: Re: [PATCH v4] net: sch_generic: Use pfifo_fast as fallback scheduler
 for CAN hardware
To:     Vincent Prince <vincent.prince.fr@gmail.com>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        =?UTF-8?B?SmnFmcOtIFDDrXJrbw==?= <jiri@resnulli.us>,
        kernel@pengutronix.de, linux-can@vger.kernel.org,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 23, 2019 at 3:52 AM Vincent Prince
<vincent.prince.fr@gmail.com> wrote:
>
> There is networking hardware that isn't based on Ethernet for layers 1 an=
d 2.
>
> For example CAN.
>
> CAN is a multi-master serial bus standard for connecting Electronic Contr=
ol
> Units [ECUs] also known as nodes. A frame on the CAN bus carries up to 8 =
bytes
> of payload. Frame corruption is detected by a CRC. However frame loss due=
 to
> corruption is possible, but a quite unusual phenomenon.
>
> While fq_codel works great for TCP/IP, it doesn't for CAN. There are a lo=
t of
> legacy protocols on top of CAN, which are not build with flow control or =
high
> CAN frame drop rates in mind.
>
> When using fq_codel, as soon as the queue reaches a certain delay based l=
ength,
> skbs from the head of the queue are silently dropped. Silently meaning th=
at the
> user space using a send() or similar syscall doesn't get an error. Howeve=
r
> TCP's flow control algorithm will detect dropped packages and adjust the
> bandwidth accordingly.
>
> When using fq_codel and sending raw frames over CAN, which is the common =
use
> case, the user space thinks the package has been sent without problems, b=
ecause
> send() returned without an error. pfifo_fast will drop skbs, if the queue
> length exceeds the maximum. But with this scheduler the skbs at the tail =
are
> dropped, an error (-ENOBUFS) is propagated to user space. So that the use=
r
> space can slow down the package generation.
>
> On distributions, where fq_codel is made default via CONFIG_DEFAULT_NET_S=
CH
> during compile time, or set default during runtime with sysctl
> net.core.default_qdisc (see [1]), we get a bad user experience. In my tes=
t case
> with pfifo_fast, I can transfer thousands of million CAN frames without a=
 frame
> drop. On the other hand with fq_codel there is more then one lost CAN fra=
me per
> thousand frames.
>
> As pointed out fq_codel is not suited for CAN hardware, so this patch cha=
nges
> attach_one_default_qdisc() to use pfifo_fast for "ARPHRD_CAN" network dev=
ices.
>
> During transition of a netdev from down to up state the default queuing
> discipline is attached by attach_default_qdiscs() with the help of
> attach_one_default_qdisc(). This patch modifies attach_one_default_qdisc(=
) to
> attach the pfifo_fast (pfifo_fast_ops) if the network device type is
> "ARPHRD_CAN".
>
> [1] https://github.com/systemd/systemd/issues/9194
>
> Suggested-by: Marc Kleine-Budde <mkl@pengutronix.de>
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> Signed-off-by: Vincent Prince <vincent.prince.fr@gmail.com>
> ---
> Changes in v4:
>  - add Marc credit to commit log
>
> Changes in v3:
>  - add description
>
> Changes in v2:
>  - reformat patch
>
>  net/sched/sch_generic.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
> index 77b289d..dfb2982 100644
> --- a/net/sched/sch_generic.c
> +++ b/net/sched/sch_generic.c
> @@ -1008,6 +1008,8 @@ static void attach_one_default_qdisc(struct net_dev=
ice *dev,
>
>         if (dev->priv_flags & IFF_NO_QUEUE)
>                 ops =3D &noqueue_qdisc_ops;
> +       else if(dev->type =3D=3D ARPHRD_CAN)
> +               ops =3D &pfifo_fast_ops;
>
>         qdisc =3D qdisc_create_dflt(dev_queue, ops, TC_H_ROOT, NULL);
>         if (!qdisc) {
> --
> 2.7.4
>

While I'm delighted to see such a simple patch emerge, openwrt long
ago patched out pfifo_fast. pfifo_fast has
additional semantics not needed in the can use case either (I think)
and "pfifo" is fine, but sure, pfifo_fast if you must.

anyway, regardless, that's an easy fix and I hope this fix goes to
stable, as I've had nightmares about cars exploding due to out of
order can bus operations ever since I learned of this bug.

Acked-by: Dave Taht <dave.taht@gmail.com>

--=20

Dave T=C3=A4ht
CTO, TekLibre, LLC
http://www.teklibre.com
Tel: 1-831-205-9740
