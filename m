Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E4423AA23D
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 19:13:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231411AbhFPRQB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 13:16:01 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([81.169.146.164]:32887 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbhFPRQA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 13:16:00 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1623863626; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=tFAoIyJpluUM1HCZZzgLY5TY44fZU3rqhoyEReXlUfT6U/ZZ00+cIju4Rpnvc48fGc
    H8P27Kft1pxKFD1FZJD0UojlhV/3GZmjA9JvkbihdauxFGOqnM0evZ8vgG7SiV5mdnQE
    CIsogcSiqn1Ok02ZBSb4qWbhjYNtzFCVRJFl6M6vvXSZbTnPv203pwz2Kyc7JQhEiLaC
    2SQd0EIeHhDRRbC0aoaS/9xgKilAMKr+gYfEoeSGWjXSoet8dagoiJBq7n8LzvBC8KoC
    l2x364+oAAhFmiUB09qdMF4b8JHA0sa3VzobFXahMx2+6r7lXa0K0DBqBCTQpVONbAFT
    XaZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1623863626;
    s=strato-dkim-0002; d=strato.com;
    h=In-Reply-To:References:Message-ID:Subject:Cc:To:From:Date:Cc:Date:
    From:Subject:Sender;
    bh=RDg1xSQ6mX0ylsSTt2fF3oHZQADxjAmoO8Kg/tTJSiY=;
    b=ObmqocqlpKqFqf/ry4MMzME9NYN2lkXgBDm30X2cJ+/EwncafhgyDSLUfQmbX46/+B
    x6O8POCgwf7xvb7hxiRSwGyZnaWGVU7YOUMPtcN0FeP23CJlZ0asmhB3T3/hT6v3bHDQ
    fCB47JJoMXqhNGEU46mV3j+rU2vSoUB42pitYeP1AtkCqtggd4x2gtt6AvcpmjDF6dez
    60tOcv+wcWOhLWmb/fIvBt/jf5Xrb0b+wwqxLMhR51f7uA+ra1+bT+3om4zQ+FRDdCkR
    r0CYZmmHQy8VnUz8rfLs2f0wkrRhPaFwP+rweUq/b8J3TL1n+VHh8oNEfl6I2fM1jfH9
    Qq7A==
ARC-Authentication-Results: i=1; strato.com;
    dkim=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1623863626;
    s=strato-dkim-0002; d=gerhold.net;
    h=In-Reply-To:References:Message-ID:Subject:Cc:To:From:Date:Cc:Date:
    From:Subject:Sender;
    bh=RDg1xSQ6mX0ylsSTt2fF3oHZQADxjAmoO8Kg/tTJSiY=;
    b=kRnCmt3lQ955BKBXGoZQkjftJ0ColV+KUz38afNjzoZGjYeQ49qTmDY3f431c/oz+C
    kTuMAdcZZac+kdFXBAlXEedt2r3NEh/u1yGu8RVZ+Ue9qOV8aT0le4VDi+JsH9QLE7Gt
    1D7LQoN9fZF/3J8hZnzPSGEoyQqGTGTHF1gLhH9AljW4rS6MQOIN+pemoFNEUx0YV64I
    6lZy+0ybYjCxTkAcrgeOVTnyh9TNQoR+K4c2lbtIHm/coQrZAO3zEBpsXeXivbGNVCMH
    tYU3PgScx+RKtQmKsN9lvHMB5dlNX4CTXOTHrPA1LAGWJiUlCTvLYKYz7IiYdkLyu4Rr
    3y2g==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P3gBZUipdd93FF5ZZvYFPugejmSTVR2nRPhVOQ/OcYgojyw4j34+u26zEodhPgRDZ8nxIc3GBg=="
X-RZG-CLASS-ID: mo00
Received: from gerhold.net
    by smtp.strato.de (RZmta 47.27.2 DYNA|AUTH)
    with ESMTPSA id y01375x5GHDjZg5
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Wed, 16 Jun 2021 19:13:45 +0200 (CEST)
Date:   Wed, 16 Jun 2021 19:13:41 +0200
From:   Stephan Gerhold <stephan@gerhold.net>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Aleksander Morgado <aleksander@aleksander.es>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-remoteproc@vger.kernel.org,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        phone-devel@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        ~postmarketos/upstreaming@lists.sr.ht
Subject: Re: [PATCH net-next 3/3] net: wwan: Allow WWAN drivers to provide
 blocking tx and poll function
Message-ID: <YMoxRRNXLNPRBdhy@gerhold.net>
References: <20210615133229.213064-1-stephan@gerhold.net>
 <20210615133229.213064-4-stephan@gerhold.net>
 <CAMZdPi8JuyqoF3GwJHcdXhdn0e7ks_f2WiUFpmn3E8HH7T_Gng@mail.gmail.com>
 <YMkkUM3fHcWhYhmV@gerhold.net>
 <CAMZdPi877Qu5F+mYqD0tAm5-gewpHHwpa2Xp7DAn8OM8rxVLMA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMZdPi877Qu5F+mYqD0tAm5-gewpHHwpa2Xp7DAn8OM8rxVLMA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 16, 2021 at 11:28:46AM +0200, Loic Poulain wrote:
> On Wed, 16 Jun 2021 at 00:06, Stephan Gerhold <stephan@gerhold.net> wrote:
> >
> > On Tue, Jun 15, 2021 at 11:24:41PM +0200, Loic Poulain wrote:
> > > On Tue, 15 Jun 2021 at 15:34, Stephan Gerhold <stephan@gerhold.net> wrote:
> > > >
> > > > At the moment, the WWAN core provides wwan_port_txon/off() to implement
> > > > blocking writes. The tx() port operation should not block, instead
> > > > wwan_port_txon/off() should be called when the TX queue is full or has
> > > > free space again.
> > > >
> > > > However, in some cases it is not straightforward to make use of that
> > > > functionality. For example, the RPMSG API used by rpmsg_wwan_ctrl.c
> > > > does not provide any way to be notified when the TX queue has space
> > > > again. Instead, it only provides the following operations:
> > > >
> > > >   - rpmsg_send(): blocking write (wait until there is space)
> > > >   - rpmsg_trysend(): non-blocking write (return error if no space)
> > > >   - rpmsg_poll(): set poll flags depending on TX queue state
> > > >
> > > > Generally that's totally sufficient for implementing a char device,
> > > > but it does not fit well to the currently provided WWAN port ops.
> > > >
> > > > Most of the time, using the non-blocking rpmsg_trysend() in the
> > > > WWAN tx() port operation works just fine. However, with high-frequent
> > > > writes to the char device it is possible to trigger a situation
> > > > where this causes issues. For example, consider the following
> > > > (somewhat unrealistic) example:
> > > >
> > > >  # dd if=/dev/zero bs=1000 of=/dev/wwan0p2QMI
> > > >  dd: error writing '/dev/wwan0p2QMI': Resource temporarily unavailable
> > > >  1+0 records out
> > > >
> > > > This fails immediately after writing the first record. It's likely
> > > > only a matter of time until this triggers issues for some real application
> > > > (e.g. ModemManager sending a lot of large QMI packets).
> > > >
> > > > The rpmsg_char device does not have this problem, because it uses
> > > > rpmsg_trysend() and rpmsg_poll() to support non-blocking operations.
> > > > Make it possible to use the same in the RPMSG WWAN driver by extending
> > > > the tx() operation with a "nonblock" parameter and adding an optional
> > > > poll() callback. This integrates nicely with the RPMSG API and does
> > > > not break other WWAN drivers.
> > > >
> > > > With these changes, the dd example above blocks instead of exiting
> > > > with an error.
> > > >
> > > > Cc: Loic Poulain <loic.poulain@linaro.org>
> > > > Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
> > > > ---
> > > > Note that rpmsg_poll() is an optional callback currently only implemented
> > > > by the qcom_smd RPMSG provider. However, it should be easy to implement
> > > > this for other RPMSG providers when needed.
> > > >
> > > > Another potential solution suggested by Loic Poulain in [1] is to always
> > > > use the blocking rpmsg_send() from a workqueue/kthread and disable TX
> > > > until it is done. I think this could also work (perhaps a bit more
> > > > difficult to implement) but the main disadvantage is that I don't see
> > > > a way to return any kind of error to the client with this approach.
> > > > I assume we return immediately from the write() to the char device
> > > > after scheduling the rpmsg_send(), so we already reported success
> > > > when rpmsg_send() returns.
> > > >
> > > > At the end all that matters to me is that it works properly, so I'm
> > > > open for any other suggestions. :)
> > > >
> > > > [1]: https://lore.kernel.org/linux-arm-msm/CAMZdPi_-Qa=JnThHs_h-144dAfSAjF5s+QdBawdXZ3kk8Mx8ng@mail.gmail.com/
> > > > ---
> > > >  drivers/net/wwan/iosm/iosm_ipc_port.c |  3 ++-
> > > >  drivers/net/wwan/mhi_wwan_ctrl.c      |  3 ++-
> > > >  drivers/net/wwan/rpmsg_wwan_ctrl.c    | 17 +++++++++++++++--
> > > >  drivers/net/wwan/wwan_core.c          |  9 ++++++---
> > > >  drivers/net/wwan/wwan_hwsim.c         |  3 ++-
> > > >  include/linux/wwan.h                  | 13 +++++++++----
> > > >  6 files changed, 36 insertions(+), 12 deletions(-)
> > > >
> > > > diff --git a/drivers/net/wwan/iosm/iosm_ipc_port.c b/drivers/net/wwan/iosm/iosm_ipc_port.c
> > > > index beb944847398..2f874e41ceff 100644
> > > > --- a/drivers/net/wwan/iosm/iosm_ipc_port.c
> > > > +++ b/drivers/net/wwan/iosm/iosm_ipc_port.c
> > > > @@ -31,7 +31,8 @@ static void ipc_port_ctrl_stop(struct wwan_port *port)
> > > >  }
> > > >
> > > >  /* transfer control data to modem */
> > > > -static int ipc_port_ctrl_tx(struct wwan_port *port, struct sk_buff *skb)
> > > > +static int ipc_port_ctrl_tx(struct wwan_port *port, struct sk_buff *skb,
> > > > +                           bool nonblock)
> > > >  {
> > > >         struct iosm_cdev *ipc_port = wwan_port_get_drvdata(port);
> > > >
> > > > diff --git a/drivers/net/wwan/mhi_wwan_ctrl.c b/drivers/net/wwan/mhi_wwan_ctrl.c
> > > > index 1bc6b69aa530..9754f014d348 100644
> > > > --- a/drivers/net/wwan/mhi_wwan_ctrl.c
> > > > +++ b/drivers/net/wwan/mhi_wwan_ctrl.c
> > > > @@ -139,7 +139,8 @@ static void mhi_wwan_ctrl_stop(struct wwan_port *port)
> > > >         mhi_unprepare_from_transfer(mhiwwan->mhi_dev);
> > > >  }
> > > >
> > > > -static int mhi_wwan_ctrl_tx(struct wwan_port *port, struct sk_buff *skb)
> > > > +static int mhi_wwan_ctrl_tx(struct wwan_port *port, struct sk_buff *skb,
> > > > +                           bool nonblock)
> > > >  {
> > > >         struct mhi_wwan_dev *mhiwwan = wwan_port_get_drvdata(port);
> > > >         int ret;
> > > > diff --git a/drivers/net/wwan/rpmsg_wwan_ctrl.c b/drivers/net/wwan/rpmsg_wwan_ctrl.c
> > > > index de226cdb69fd..63f431eada39 100644
> > > > --- a/drivers/net/wwan/rpmsg_wwan_ctrl.c
> > > > +++ b/drivers/net/wwan/rpmsg_wwan_ctrl.c
> > > > @@ -54,12 +54,16 @@ static void rpmsg_wwan_ctrl_stop(struct wwan_port *port)
> > > >         rpwwan->ept = NULL;
> > > >  }
> > > >
> > > > -static int rpmsg_wwan_ctrl_tx(struct wwan_port *port, struct sk_buff *skb)
> > > > +static int rpmsg_wwan_ctrl_tx(struct wwan_port *port, struct sk_buff *skb,
> > > > +                             bool nonblock)
> > > >  {
> > > >         struct rpmsg_wwan_dev *rpwwan = wwan_port_get_drvdata(port);
> > > >         int ret;
> > > >
> > > > -       ret = rpmsg_trysend(rpwwan->ept, skb->data, skb->len);
> > > > +       if (nonblock)
> > > > +               ret = rpmsg_trysend(rpwwan->ept, skb->data, skb->len);
> > > > +       else
> > > > +               ret = rpmsg_send(rpwwan->ept, skb->data, skb->len);
> > > >         if (ret)
> > > >                 return ret;
> > > >
> > > > @@ -67,10 +71,19 @@ static int rpmsg_wwan_ctrl_tx(struct wwan_port *port, struct sk_buff *skb)
> > > >         return 0;
> > > >  }
> > > >
> > > > +static __poll_t rpmsg_wwan_ctrl_poll(struct wwan_port *port, struct file *filp,
> > > > +                                    poll_table *wait)
> > > > +{
> > > > +       struct rpmsg_wwan_dev *rpwwan = wwan_port_get_drvdata(port);
> > > > +
> > > > +       return rpmsg_poll(rpwwan->ept, filp, wait);
> > > > +}
> > > > +
> > > >  static const struct wwan_port_ops rpmsg_wwan_pops = {
> > > >         .start = rpmsg_wwan_ctrl_start,
> > > >         .stop = rpmsg_wwan_ctrl_stop,
> > > >         .tx = rpmsg_wwan_ctrl_tx,
> > > > +       .poll = rpmsg_wwan_ctrl_poll,
> > > >  };
> > > >
> > > >  static struct device *rpmsg_wwan_find_parent(struct device *dev)
> > > > diff --git a/drivers/net/wwan/wwan_core.c b/drivers/net/wwan/wwan_core.c
> > > > index 7e728042fc41..c7fd0b897f87 100644
> > > > --- a/drivers/net/wwan/wwan_core.c
> > > > +++ b/drivers/net/wwan/wwan_core.c
> > > > @@ -500,7 +500,8 @@ static void wwan_port_op_stop(struct wwan_port *port)
> > > >         mutex_unlock(&port->ops_lock);
> > > >  }
> > > >
> > > > -static int wwan_port_op_tx(struct wwan_port *port, struct sk_buff *skb)
> > > > +static int wwan_port_op_tx(struct wwan_port *port, struct sk_buff *skb,
> > > > +                          bool nonblock)
> > > >  {
> > > >         int ret;
> > > >
> > > > @@ -510,7 +511,7 @@ static int wwan_port_op_tx(struct wwan_port *port, struct sk_buff *skb)
> > > >                 goto out_unlock;
> > > >         }
> > > >
> > > > -       ret = port->ops->tx(port, skb);
> > > > +       ret = port->ops->tx(port, skb, nonblock);
> > > >
> > > >  out_unlock:
> > > >         mutex_unlock(&port->ops_lock);
> > > > @@ -637,7 +638,7 @@ static ssize_t wwan_port_fops_write(struct file *filp, const char __user *buf,
> > > >                 return -EFAULT;
> > > >         }
> > > >
> > > > -       ret = wwan_port_op_tx(port, skb);
> > > > +       ret = wwan_port_op_tx(port, skb, !!(filp->f_flags & O_NONBLOCK));
> > > >         if (ret) {
> > > >                 kfree_skb(skb);
> > > >                 return ret;
> > > > @@ -659,6 +660,8 @@ static __poll_t wwan_port_fops_poll(struct file *filp, poll_table *wait)
> > > >                 mask |= EPOLLIN | EPOLLRDNORM;
> > > >         if (!port->ops)
> > > >                 mask |= EPOLLHUP | EPOLLERR;
> > > > +       else if (port->ops->poll)
> > > > +               mask |= port->ops->poll(port, filp, wait);
> > >
> > > I'm not sure it useful here because EPOLLOUT flag is already set above, right?
> > >
> >
> > Oops, you're right - sorry! I thought the flags are inverted (only set
> > if (is_write_blocked())), then it would have worked fine. :)
> >
> > I think this should be easy to fix though, I can just make the
> >
> >         if (!is_write_blocked(port))
> >                 mask |= EPOLLOUT | EPOLLWRNORM;
> >
> > if statement conditional to (port->ops->poll == NULL). It only makes
> > sense to supply the poll() op if the built-in write-blocking cannot be
> > used easily (like in my case).
> 
> Yes, so maybe in that case poll ops should be renamed to something like tx_poll?
> 

Sounds good! I will rename it to tx_poll() in v2. :)

Thanks!
Stephan
