Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9908D1383FD
	for <lists+netdev@lfdr.de>; Sun, 12 Jan 2020 00:29:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731643AbgAKX2m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jan 2020 18:28:42 -0500
Received: from mail-oi1-f194.google.com ([209.85.167.194]:44806 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731621AbgAKX2l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jan 2020 18:28:41 -0500
Received: by mail-oi1-f194.google.com with SMTP id d62so5142200oia.11
        for <netdev@vger.kernel.org>; Sat, 11 Jan 2020 15:28:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XgsQ2wd7oHMAd5nOFS6lJmWzOavHx5TDiotohKMH8BA=;
        b=BwjQdzkc1jCWwphR8oCmyKJgMzVXzTXqsUo092VfRSU9A3JhaOoZP27WMymj9m1Zi8
         HxLK5J7ug4r4tPBLYGaRm7jWbcBbXcnYU9OzuBNgAwbHob1c2YLZmmG8rsEjF4ANzQS4
         31Ts1GiogYtiZBRiXMBxjDu1MVNoBr028zBBvieCu3+fTvRNpjtvGjgnP7scfv/3poDj
         Yyz8il67zlFkpkLKtDn5LmD7JTkd26CNAtRkQyE3oBmuzYMD5vhd94hYHWbC3K7kDH7C
         MsVfCDYEPG4KiR8ZaknK58QaF4URLZfowE4n/4rU7Cg1a5FX+kNkWF+PSsHPQNr5hwWY
         QvHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XgsQ2wd7oHMAd5nOFS6lJmWzOavHx5TDiotohKMH8BA=;
        b=AH2vuvJ1/NublHhvDHWEr8KRcy7Xij/ZLUXEovUYTiqlsgBoI3Dwe2gOxcSZvVmWk6
         K3nocBXLJgHs3Sw+/gaF6Pls0s+4ndtQxLPTLpq+2tTHLPdBbWrYYp5XgWFSeT4C85uN
         78AZyBYr5J5eFsdfV2tsNw5lKnOoYkE/ofhTwiT87weZEQy1yxFSCV7+KJfmDxAsgiS7
         w0BNBpRsRTEtjGGyJztwD3l0pQeQehjejySA8YDaCIJeMK4hqDuJZViim0tyy1bq0EC9
         he/pHPC8rwEkaqQkFdBfMqMGy66R6Mi/S9qgsc6ft8sVyB0pi62DiZgbtqzn0pqqYDqR
         HaKw==
X-Gm-Message-State: APjAAAWyDHPa+pIVl85ITYka3afgoy5ynWfwnTqnbAWKenHN3u0sZv0A
        Fixow9drRJuoINs6de+e2ZdJhLuAjO8tme0Wu6AzT+Spjm8=
X-Google-Smtp-Source: APXvYqxzT+1mZFs+UYSQVoKrwXWW6BhggnHkgQ0NjXni4ux6cPTIdjc7Qw9vMrN8PHc6iuMfeobnBc7HIFMVmXFQHUA=
X-Received: by 2002:aca:3cd7:: with SMTP id j206mr8006868oia.142.1578785320983;
 Sat, 11 Jan 2020 15:28:40 -0800 (PST)
MIME-Version: 1.0
References: <000000000000ab3f800598cec624@google.com> <000000000000802598059b6c7989@google.com>
 <CAM_iQpX7-BF=C+CAV3o=VeCZX7=CgdscZaazTD6QT-Tw1=XY9Q@mail.gmail.com>
 <CAMArcTXTtJB8WUuJUumP2NHVg_c19m-6EheC3JRGxzseYmHVDw@mail.gmail.com>
 <CAM_iQpVJiYHnhUJKzQpoPzaUhjrd=O4WR6zFJ+329KnWi6jJig@mail.gmail.com>
 <CAMArcTVPrKrhY63P=VgFuTQf0wUNO_9=H2R96p08-xoJ+mbZ5w@mail.gmail.com>
 <CAM_iQpX-S7cPvYTqAMkZF=avaoMi_af70dwQEiC37OoXNWA4Aw@mail.gmail.com>
 <CAMArcTUFK6TUYP+zwD3009m126fz+S-cAT5CN5pZ3C5axErh8g@mail.gmail.com>
 <CAM_iQpUpZLcsC2eYPGO-UCRf047FTvP-0x8hQnDxRZ-w3vL9Tg@mail.gmail.com>
 <CAMArcTV66StxE=Pjiv6zsh0san039tuVvsKNE2Sb=7+jJ3xEdQ@mail.gmail.com> <CAM_iQpU9EXx7xWAaps2E3DWiZbt25ByCK4sR=njYMHF=KsvLFg@mail.gmail.com>
In-Reply-To: <CAM_iQpU9EXx7xWAaps2E3DWiZbt25ByCK4sR=njYMHF=KsvLFg@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sat, 11 Jan 2020 15:28:29 -0800
Message-ID: <CAM_iQpUDd6hFrQwb2TkGpbe5AFOtTMyeVg1-OBfY50vC5CEJnQ@mail.gmail.com>
Subject: Re: WARNING: bad unlock balance in sch_direct_xmit
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     syzbot <syzbot+4ec99438ed7450da6272@syzkaller.appspotmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 11, 2020 at 1:53 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> The details you provide here are really helpful for me to understand
> the reasons behind your changes. Let me think about this and see how
> I could address both problems. This appears to be harder than I originally
> thought.

Do you think the following patch will make everyone happy?

diff --git a/net/core/dev.c b/net/core/dev.c
index 0ad39c87b7fd..7e885d069707 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9177,22 +9177,10 @@ static void
netdev_unregister_lockdep_key(struct net_device *dev)

 void netdev_update_lockdep_key(struct net_device *dev)
 {
-       struct netdev_queue *queue;
-       int i;
-
-       lockdep_unregister_key(&dev->qdisc_xmit_lock_key);
        lockdep_unregister_key(&dev->addr_list_lock_key);
-
-       lockdep_register_key(&dev->qdisc_xmit_lock_key);
        lockdep_register_key(&dev->addr_list_lock_key);

        lockdep_set_class(&dev->addr_list_lock, &dev->addr_list_lock_key);
-       for (i = 0; i < dev->num_tx_queues; i++) {
-               queue = netdev_get_tx_queue(dev, i);
-
-               lockdep_set_class(&queue->_xmit_lock,
-                                 &dev->qdisc_xmit_lock_key);
-       }
 }
 EXPORT_SYMBOL(netdev_update_lockdep_key);

I think as long as we don't take _xmit_lock nestedly, it is fine. And
most (or all?) of the software netdev's are already lockless, so I can't
think of any case we take more than one _xmit_lock on TX path.

I tested it with the syzbot reproducer and your set master/nomaster
commands, I don't get any lockdep splat.

What do you think?

Thanks!
