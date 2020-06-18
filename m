Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B5A31FFC41
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 22:06:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730652AbgFRUG2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 16:06:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730355AbgFRUG2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 16:06:28 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51B25C06174E
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 13:06:28 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id u13so8609570iol.10
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 13:06:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=thyaVO24iv2eF/B7JpSDsoF0DnYKWT+LxnLf/XcEDlM=;
        b=rTZUxvWs4JlfHMg5AMfGDmnRhlNd62aVfZxn+mWWA3OKGcnuEjUXL6hnf1hzAP6n1g
         NdX0tv7zKH/aeZHsi5bv2DIeKiN07QTmh86WeuCpQZQw6MH6u8lzTqRtlzrQzi2K7XSF
         8YkJAVXpVi51Qbbc4xie20jAce5tp7uihALzoz+f4xIhQW3N87vzLQ3BDdhomCC4C4K4
         43/qCAJSqV/kGlv0lcbDoZsw1FxMGam8ZH4CJmDOeRD0c2OTA0rkdqMC2Gkmcij4Pksu
         xi34XFBUDqO5wcOmy3Y3Gh57yU6yIGHabaFWcn6YXRYE3qjjdX8VqMh3QugJbBGkr8L0
         FsNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=thyaVO24iv2eF/B7JpSDsoF0DnYKWT+LxnLf/XcEDlM=;
        b=bMUyDTV2z5a/OR0Fr4KkwGDgh8+hy5gWnCqqz2gVk9jmqefkBGA2zvx2ykDyRfKahc
         mjsdHZRsZ1xHxwvHmC3t/7tLij9oGuwCywa6RlyuvZqFwhWm7IiOHH6rQzNTee4mW/qm
         3IjalZotGRmok346wkr7PAM8vXbKNMQ7i80ZfARR83esoK5ju+QnA3x4uobC54CAfqUV
         IWBFnUGFlaG8tFssoPyHm1SFtM0+PIbHtmlBUizjtQCtxCK5m8AvfdFDR4zAGRi4WE34
         eQsG0fO5y31f1zOA5h+HynfO2XvbH7wsDwoht+HqJRgbVEt75Z/+yaWclOSsx1vjIv5P
         INHA==
X-Gm-Message-State: AOAM533o35R7jEKLDPRj0sWQWEbGnumbtDVTnXwwsQsXEiRGezjiZM49
        xQ60WwKIYKurbGSvAKb1CBXEivAiAucgnAborys=
X-Google-Smtp-Source: ABdhPJxNEHRN6i5K3Z+Q6L3UWCW2AFhUghBFuNoSaY1fv9Fo03jPHNtUyYE7+ma189BF3mug4BaYjVbzlMEw8yJrqOk=
X-Received: by 2002:a05:6602:1204:: with SMTP id y4mr478062iot.44.1592510787759;
 Thu, 18 Jun 2020 13:06:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200608215301.26772-1-xiyou.wangcong@gmail.com>
 <CA+h21hr_epEqWukZMQmZ2ecS9Y0yvX9mzR3g3OA39rg_96FfnQ@mail.gmail.com> <CAM_iQpW-5WpaSvSmJgoqEbcjtrjvaZY3ngKzVy2S-v81MdK4iQ@mail.gmail.com>
In-Reply-To: <CAM_iQpW-5WpaSvSmJgoqEbcjtrjvaZY3ngKzVy2S-v81MdK4iQ@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 18 Jun 2020 13:06:16 -0700
Message-ID: <CAM_iQpUBuk1D4JYZtPQ_yodkLJwAyExvGG5vSOazed2QN7NESw@mail.gmail.com>
Subject: Re: [Patch net] net: change addr_list_lock back to static key
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        syzbot+f3a0e80c34b3fc28ac5e@syzkaller.appspotmail.com,
        Taehee Yoo <ap420073@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 18, 2020 at 12:56 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Thu, Jun 18, 2020 at 12:40 PM Vladimir Oltean <olteanv@gmail.com> wrote:
> >
> > It's me with the stacked DSA devices again:
>
> It looks like DSA never uses netdev API to link master
> device with slave devices? If so, their dev->lower_level
> are always 1, therefore triggers this warning.
>
> I think it should call one of these netdev_upper_dev_link()
> API's when creating a slave device.
>

I don't know whether DSA is too special to use the API, but
something like this should work:

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 4c7f086a047b..f7a2a281e7f0 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1807,6 +1807,11 @@ int dsa_slave_create(struct dsa_port *port)
                           ret, slave_dev->name);
                goto out_phy;
        }
+       ret = netdev_upper_dev_link(slave_dev, master, NULL);
+       if (ret) {
+               unregister_netdevice(slave_dev);
+               goto out_phy;
+       }

        return 0;

@@ -1832,6 +1837,7 @@ void dsa_slave_destroy(struct net_device *slave_dev)
        netif_carrier_off(slave_dev);
        rtnl_lock();
        phylink_disconnect_phy(dp->pl);
+       netdev_upper_dev_unlink(slave_dev, dp->master);
        rtnl_unlock();

        dsa_slave_notify(slave_dev, DSA_PORT_UNREGISTER);
