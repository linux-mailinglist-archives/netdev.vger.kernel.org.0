Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69CF55BC12C
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 03:59:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbiISB7p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 21:59:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbiISB7m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 21:59:42 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22F676262
        for <netdev@vger.kernel.org>; Sun, 18 Sep 2022 18:59:37 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id h194so20016076iof.4
        for <netdev@vger.kernel.org>; Sun, 18 Sep 2022 18:59:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date;
        bh=j03uyH0eO/wuIxUPs2A6a3jLSTL0RE2dBr8bkzJCYVU=;
        b=gbR18aqKhwmg5KG28RGPIQm9BfKLXz+95oq27SIKPxi0JUZCXStnN057cWAGyIfank
         X4TFqUar89pBpcbEFBKuGHEjxblgfcJkuD5nDqRNHb9CHllGRP252L3hMTDjaxC/IRvN
         AdUjtiQftmJGIcwIzMiOEjFh1xLqbfrg0ezSvUXznNA41Nu8fJD7NpCQBtI0APgqvLTz
         LLs2+vjHdwlR2pyOhLSnDBZkMR3WtdWbn6xIT9sexVMuMB4EHIz/GFMWt4ebr97GCpxE
         gNtn8T81z0CWLabzHvfz/ts/tC6a8Wa1/gehal3QnsEF6c26hVD6XnU63gRiFuNtUID0
         O/8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=j03uyH0eO/wuIxUPs2A6a3jLSTL0RE2dBr8bkzJCYVU=;
        b=e93dXx2wmGh9fXtNDunWY0vXCgoCt8AetqI6cqS4A48YEFHIVy0iUwwtx7riScrXS+
         HhTwemFYj/m+da1xqU/oszwqxausssWVzPk03BgB71bdFgj6Qhz/iNbHzMV0fO+yGZQL
         dVw0sAk93Fjxfgh/OP2r3ohWjJ6/6hRjLtJFyQr+lC39NcvfOtYV/XD+8MQLxgwkLUcj
         f/q/4Xp/eFPRbog3GngWD2x8Fy/wmCtPZVQu5s48lt1eIQaVtDrRNzz2lahawHcwZGrp
         xt6JKRgQOhl3WPX3bXpUmHwTk0OBRnqmc4UgF6xSgQp6jkcI0TJD1xA6mcD2PazBupGl
         WQ6A==
X-Gm-Message-State: ACrzQf0lTDyy9Ub1YpYWIgMek16y4K5a+cir8FEO/Qk1StHXF0EJ+F73
        aLpc1660fD6T0CvpAsPezFpx20oS/4YwV7ngQHHtHioi79o=
X-Google-Smtp-Source: AMsMyM4H0Ah1XNMjbxsM8xh7ts4IJivskdQA9gh+DZIJ8RLTD78yUUny8bTO8Qym+Z4ozYbvFWpfrn0mZpu0YDqqh7s=
X-Received: by 2002:a02:c735:0:b0:35a:9166:b7b8 with SMTP id
 h21-20020a02c735000000b0035a9166b7b8mr6204335jao.16.1663552776517; Sun, 18
 Sep 2022 18:59:36 -0700 (PDT)
MIME-Version: 1.0
References: <927100312.1863.1662997394065.JavaMail.zimbra@nicevt.ru>
In-Reply-To: <927100312.1863.1662997394065.JavaMail.zimbra@nicevt.ru>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Mon, 19 Sep 2022 04:59:28 +0300
Message-ID: <CAHNKnsQ_rhMOCfkAfsXjDg2eAfYkZTJ6DOJLmDb3OSB4AotXzA@mail.gmail.com>
Subject: Re: RFH, is it possible to set ndo_start_xmit() cpu affinity in
 ethernet driver?
To:     =?UTF-8?B?0JLQsNGB0LjQu9C40Lkg0KPQvNGA0LjRhdC40L0=?= 
        <umrihin@nicevt.ru>
Cc:     netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Vasiliy,

On Mon, Sep 12, 2022 at 6:45 PM =D0=92=D0=B0=D1=81=D0=B8=D0=BB=D0=B8=D0=B9 =
=D0=A3=D0=BC=D1=80=D0=B8=D1=85=D0=B8=D0=BD <umrihin@nicevt.ru> wrote:
> On the receiving side we have the opportunity to choose the CPU that will=
 process the receive queue (RPS).
> On the sender side XPS selects the send queue for the given CPU, but ther=
e is no way to select the CPU on which ndo_start_xmit() will be launched.
> Taskset is able to bind user task, but in ndo_start_xmit() binding differ=
s.
> In my case CPU0 reserved for polling kthread, because our NIC have no int=
errupts, therefore it is necessary. I need nothing else to run on this CPU.
>
> For example, setting CPU1 for RPS on both nodes:
>
> host1: echo 0x2 > /sys/class/net//queues/rx-0/rps_cpus
> host2: echo 0x2 > /sys/class/net//queues/rx-0/rps_cpus
>
> Then run iperf on two nodes:
>
> host1: taskset -c 1 iperf -s
> host2: taskset -c 1 iperf -c host1
>
> After adding pr_info("cpu%d\n", smp_processor_id()); in my ndo_start_xmit=
() method, see in dmesg:
>
> host1: dmesg | grep cpu0 | wc -l
> 0
> host2: dmesg | grep cpu0 | wc -l
> 6512
>
> Is it possible to choose the CPU on which ndo_start_xmit() will be launch=
ed on the sender side?

AFAIK, there is no mechanism to force the ndo_start_xmit() invocation
on a specific core.

If I realize your goal correctly, then you can implement such
functionality in the driver. Just use an intermediate queue that is
filled by the ndo_start_xmit() callback and processed by a thread
bound to a specific core. E.g.

netdev_tx_t foodriver_start_xmit(struct sk_buff *skb, struct net_device *de=
v)
{
    struct foodev_priv *p =3D netdev_priv(dev);

    skb_queue_tail(&p->xmit_queue, skb);

    return NETDEV_TX_OK;
}

int foodriver_xmit_thread(void *arg)
{
    struct foodev_priv *p =3D arg;

    while (!kthread_should_stop()) {
        struct sk_buff *skb =3D skb_dequeue(&p->xmit_queue);

        /* Do main xmit actions here */

    }
}

int foodriver_open(struct net_device *dev)
{
    struct foodev_priv *p =3D netdev_priv(dev);
    ...
    t =3D kthread_create(foodriver_xmit_thread, p, "xmit_thread");
    kthread_bind(t, prefered_cpu);
   ....
}

--
Sergey
