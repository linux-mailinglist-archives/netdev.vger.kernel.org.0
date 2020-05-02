Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB73F1C23E0
	for <lists+netdev@lfdr.de>; Sat,  2 May 2020 09:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726574AbgEBHgd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 May 2020 03:36:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726468AbgEBHgd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 May 2020 03:36:33 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEB61C061A0C
        for <netdev@vger.kernel.org>; Sat,  2 May 2020 00:36:32 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id t11so5515022lfe.4
        for <netdev@vger.kernel.org>; Sat, 02 May 2020 00:36:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=M96x9SPR/e+I/WlaypUHK3RiMhfX73d7LsmqfrHehrU=;
        b=ICpCMFvNbZPaINsj0vvdBDPrbOV2M60RUZBZjpvgzu/jFFTDYks8Cyjm/5xbNJ/cDb
         DsxCI4bwd46kYPzOu9jscVmbEwx2qWjUehn0hQYta7BIShRMz40JNEamDAH2Y3x2eapC
         bIgUaHexJGqzNa2nHyyoEmalUF3n+cdhkbQoMsoEdYxH+w5Reb3SfcHtsnItfktyXWtJ
         u0ki5k/qpv1THN3EQ7qVvsNJdg0GCHISmrOfHNJZu0ap1jrbO9pCW2xgXzr3w1SX5jTk
         60wII2X9YwEaW92xF9Mpa3xyfKAFnCNZataVQinnkd+/1KPJoiAANchvkkmrrX3QhDGI
         lEFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=M96x9SPR/e+I/WlaypUHK3RiMhfX73d7LsmqfrHehrU=;
        b=JaKEhwfXvWtB0nmAm0Z7hehR/29OmP6vVvvIu7EgYkBsw97ItujiwzF9e/42yKZxx7
         aeiUp9h0m7vQyPtam797Wtf5wcUPU0jck0d8zimsxZASxS5NWHhPm5BRDul9cThwVuPO
         qfKP5CZrXGjKCJEyR3GEfold/AGdfuSe8JiVJWqOluYKZT9WIZHzZrJ2UC9FxMBLb16k
         +NOHu962mc6OFBsXCf2r3M4aKSt40BCXQnCpKjilNVyVvexf4q1Xqw3IXFKDPftXeTbb
         rgGmAujo2UEAVE04xN5aHEvSmE02mOyKiEU7tRWrxF6n7YoAxQGxGtHqCzdLa7f0TpQ1
         C2TQ==
X-Gm-Message-State: AGi0PubJmOJv1wZpy5TlVP97fqGov9rZpTjwvAxVrEnvE+6ZQUGkGWpk
        zOvTksPosnm5h6AK1Zkauy4khYr6KsZaQfLNqCE=
X-Google-Smtp-Source: APiQypL/TOldCbE52+Xkqdc0F5RYxQUsWXVl9Z+HrY9rN4wiEol5ieBI5UQlLha6UAEOwq7eOnsYq9pzRg3FPKV7Ze4=
X-Received: by 2002:a05:6512:25c:: with SMTP id b28mr5020785lfo.129.1588404990958;
 Sat, 02 May 2020 00:36:30 -0700 (PDT)
MIME-Version: 1.0
References: <20200428060206.21814-1-xiyou.wangcong@gmail.com>
 <20200428060206.21814-2-xiyou.wangcong@gmail.com> <CAMArcTU2r2undM5119_1W=pc2fu5AtUDp2RtizjVayRY=fGVEg@mail.gmail.com>
 <CAM_iQpWdf+K7n+YfZv-+_Cz5b9+kxXV0F0PfYuUyHJ574OEGsA@mail.gmail.com>
In-Reply-To: <CAM_iQpWdf+K7n+YfZv-+_Cz5b9+kxXV0F0PfYuUyHJ574OEGsA@mail.gmail.com>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Sat, 2 May 2020 16:36:19 +0900
Message-ID: <CAMArcTVei4AF7TdUEawZbJZKpf6ABAu7UwL+5iP9jVQsxqOWSQ@mail.gmail.com>
Subject: Re: [Patch net-next 1/2] net: partially revert dynamic lockdep key changes
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        syzbot <syzbot+aaa6fa4949cc5d9b7b25@syzkaller.appspotmail.com>,
        Dmitry Vyukov <dvyukov@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 1 May 2020 at 15:02, Cong Wang <xiyou.wangcong@gmail.com> wrote:
>

Hi Cong,

> On Thu, Apr 30, 2020 at 12:40 AM Taehee Yoo <ap420073@gmail.com> wrote:
> > > +static void vlan_dev_set_lockdep_one(struct net_device *dev,
> > > +                                    struct netdev_queue *txq,
> > > +                                    void *_subclass)
> > > +{
> > > +       lockdep_set_class_and_subclass(&txq->_xmit_lock,
> > > +                                      &vlan_netdev_xmit_lock_key,
> > > +                                      *(int *)_subclass);
> >
> > I think lockdep_set_class() is enough.
> > How do you think about it?
>
> Good catch. I overlooked this one. Is lockdep_set_class() safe
> for vlan stacked on vlan?
>

I think this is safe because of the LLTX flag.
Also, I tested nested VLAN interfaces with lockdep_set_class().
I didn't see any lockdep warning.

Thanks a lot!
Taehee Yoo

> Thanks.
