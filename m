Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86A6957543A
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 19:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240374AbiGNRqf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 13:46:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232779AbiGNRqe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 13:46:34 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5FFF60690;
        Thu, 14 Jul 2022 10:46:32 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id u15so2992457lji.10;
        Thu, 14 Jul 2022 10:46:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=g+RhCd6WEoMJnjtigqoJ+UkxVYv0+Wn4W9v0cLG0xBE=;
        b=PhWfHlffLNEuGyPMoYIbwFcnyGaaBgr8E0CzGEoSw9IxA3uz9QgKdTU5UJEfUDcU0z
         XSMTHV4aUtN3PjM49KLiVvENVDMs/fHCAK79m9R0X+jtKaENBbqsRg49TbJkzOM/sblA
         yk3yYFRhkpYlq8aKLEczsIPM66jaLI3qpJ6JqfE8YAXlmiuEMiLa/9oTbSeQBkGGhcGd
         qQmqOfNvt12jjddw50tuv536tboaBYXJu2ykKnsNcV/Mdpo9uhne+t3uKkrrHe0oDPXl
         onHJv8dZk7ZZm87JQp1ipx1nmaffXFBMdT7wRcWubOsoDdZPlX4tAcWXqFWJjZLwB/Nv
         mMIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=g+RhCd6WEoMJnjtigqoJ+UkxVYv0+Wn4W9v0cLG0xBE=;
        b=ZKMmB8COFlc1HiSDCH2Gwd9NyhdC/m1VbyGnfmBUB1pEPeLDnarQ7GsxC1i33JqUk4
         RGYzBcQ0mnpNq1vsP+u9arGTEh2tJvNiYkcgp23nyFdbDHLN5yCzpMaPzZwPyzwZ3mqX
         km3skxG9s+pWQPYVO8OCC7I6FPPO85EvRO40gsHVfuygFusFj3KFHkxcwUKZZH0FuhCK
         NqReJauHaBEinCaCniWNifyN7tCmZtRXbl6YtA6GsnKDgTa8VZYPhbCUhCe58vI892yC
         HVZlBe88KRElG8u2X8JSvuR8nKhoQ0G0rD58nT1bvB0yLAh3dCYEfRfGQivGrJZQw//l
         OrYA==
X-Gm-Message-State: AJIora+8NExSswLHJrRZqvieGu+XRW6rc+qAVvtRXPAJ4NaJpxO3y4Ag
        YmBZOJueDeH625e81eOecujr5fcTgb1GJ94JGCM=
X-Google-Smtp-Source: AGRyM1uMyY7XYH0/zzmrSq65IVE1SZFCAhJuf/2hshWz/gQmdzRHaEdMciQe9DeYgsG3PLvvYOQd4iduOMlGmDGU17M=
X-Received: by 2002:a05:651c:1586:b0:25c:258:5837 with SMTP id
 h6-20020a05651c158600b0025c02585837mr4847085ljq.260.1657820790049; Thu, 14
 Jul 2022 10:46:30 -0700 (PDT)
MIME-Version: 1.0
References: <20220622082716.478486-1-lee.jones@linaro.org> <CANn89iK-uFP6Swgc0ZeEC38UsuywJ3wbybSNouH202Wa7X7Tzg@mail.gmail.com>
 <CABBYNZ+C=MQ7577Fr5_W8tQ4iWRSDBSiC4fkRBY3x=9ph+YAzA@mail.gmail.com>
 <CABBYNZLysdh3NFK+G8=NUQ=G=hvS8X0PdMp=bVqiwPDPCAokmg@mail.gmail.com>
 <YrxvgIiWuFVlXBaQ@google.com> <CABBYNZJFSxk9=3Gj7jOj__s=iJGmhrZ=CA7Mb74_-Y0sg+N40g@mail.gmail.com>
 <YsVptCjpzHjR8Scv@google.com> <CABBYNZKvVKRRdWnX3uFWdTXJ_S+oAj6z72zgyV148VmFtUnPpA@mail.gmail.com>
 <CABBYNZLTzW3afEPVfg=uS=xsPP-JpW6UBp6W=Urhhab+ai+dcA@mail.gmail.com>
In-Reply-To: <CABBYNZLTzW3afEPVfg=uS=xsPP-JpW6UBp6W=Urhhab+ai+dcA@mail.gmail.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Thu, 14 Jul 2022 10:46:18 -0700
Message-ID: <CABBYNZJXiGHB+pyKq3uPaGfP29VdauevrBPeXbcU0LEHcEf_hg@mail.gmail.com>
Subject: Re: [RESEND 1/1] Bluetooth: Use chan_list_lock to protect the whole
 put/destroy invokation
To:     Lee Jones <lee.jones@linaro.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        LKML <linux-kernel@vger.kernel.org>, stable@kernel.org,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Lee,

On Wed, Jul 6, 2022 at 1:58 PM Luiz Augusto von Dentz
<luiz.dentz@gmail.com> wrote:
>
> Hi,
>
> On Wed, Jul 6, 2022 at 1:36 PM Luiz Augusto von Dentz
> <luiz.dentz@gmail.com> wrote:
> >
> > Hi Lee,
> >
> > On Wed, Jul 6, 2022 at 3:53 AM Lee Jones <lee.jones@linaro.org> wrote:
> > >
> > > On Tue, 05 Jul 2022, Luiz Augusto von Dentz wrote:
> > >
> > > > Hi Lee,
> > > >
> > > > On Wed, Jun 29, 2022 at 8:28 AM Lee Jones <lee.jones@linaro.org> wrote:
> > > > >
> > > > > On Tue, 28 Jun 2022, Luiz Augusto von Dentz wrote:
> > > > >
> > > > > > Hi Eric, Lee,
> > > > > >
> > > > > > On Mon, Jun 27, 2022 at 4:39 PM Luiz Augusto von Dentz
> > > > > > <luiz.dentz@gmail.com> wrote:
> > > > > > >
> > > > > > > Hi Eric, Lee,
> > > > > > >
> > > > > > > On Mon, Jun 27, 2022 at 7:41 AM Eric Dumazet <edumazet@google.com> wrote:
> > > > > > > >
> > > > > > > > On Wed, Jun 22, 2022 at 10:27 AM Lee Jones <lee.jones@linaro.org> wrote:
> > > > > > > > >
> > > > > > > > > This change prevents a use-after-free caused by one of the worker
> > > > > > > > > threads starting up (see below) *after* the final channel reference
> > > > > > > > > has been put() during sock_close() but *before* the references to the
> > > > > > > > > channel have been destroyed.
> > > > > > > > >
> > > > > > > > >   refcount_t: increment on 0; use-after-free.
> > > > > > > > >   BUG: KASAN: use-after-free in refcount_dec_and_test+0x20/0xd0
> > > > > > > > >   Read of size 4 at addr ffffffc114f5bf18 by task kworker/u17:14/705
> > > > > > > > >
> > > > > > > > >   CPU: 4 PID: 705 Comm: kworker/u17:14 Tainted: G S      W       4.14.234-00003-g1fb6d0bd49a4-dirty #28
> > > > > > > > >   Hardware name: Qualcomm Technologies, Inc. SM8150 V2 PM8150 Google Inc. MSM sm8150 Flame DVT (DT)
> > > > > > > > >   Workqueue: hci0 hci_rx_work
> > > > > > > > >   Call trace:
> > > > > > > > >    dump_backtrace+0x0/0x378
> > > > > > > > >    show_stack+0x20/0x2c
> > > > > > > > >    dump_stack+0x124/0x148
> > > > > > > > >    print_address_description+0x80/0x2e8
> > > > > > > > >    __kasan_report+0x168/0x188
> > > > > > > > >    kasan_report+0x10/0x18
> > > > > > > > >    __asan_load4+0x84/0x8c
> > > > > > > > >    refcount_dec_and_test+0x20/0xd0
> > > > > > > > >    l2cap_chan_put+0x48/0x12c
> > > > > > > > >    l2cap_recv_frame+0x4770/0x6550
> > > > > > > > >    l2cap_recv_acldata+0x44c/0x7a4
> > > > > > > > >    hci_acldata_packet+0x100/0x188
> > > > > > > > >    hci_rx_work+0x178/0x23c
> > > > > > > > >    process_one_work+0x35c/0x95c
> > > > > > > > >    worker_thread+0x4cc/0x960
> > > > > > > > >    kthread+0x1a8/0x1c4
> > > > > > > > >    ret_from_fork+0x10/0x18
> > > > > > > > >
> > > > > > > > > Cc: stable@kernel.org
> > > > > > > >
> > > > > > > > When was the bug added ? (Fixes: tag please)
> > > > > > > >
> > > > > > > > > Cc: Marcel Holtmann <marcel@holtmann.org>
> > > > > > > > > Cc: Johan Hedberg <johan.hedberg@gmail.com>
> > > > > > > > > Cc: Luiz Augusto von Dentz <luiz.dentz@gmail.com>
> > > > > > > > > Cc: "David S. Miller" <davem@davemloft.net>
> > > > > > > > > Cc: Eric Dumazet <edumazet@google.com>
> > > > > > > > > Cc: Jakub Kicinski <kuba@kernel.org>
> > > > > > > > > Cc: Paolo Abeni <pabeni@redhat.com>
> > > > > > > > > Cc: linux-bluetooth@vger.kernel.org
> > > > > > > > > Cc: netdev@vger.kernel.org
> > > > > > > > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > > > > > > > > ---
> > > > > > > > >  net/bluetooth/l2cap_core.c | 4 ++--
> > > > > > > > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > > > > > > >
> > > > > > > > > diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
> > > > > > > > > index ae78490ecd3d4..82279c5919fd8 100644
> > > > > > > > > --- a/net/bluetooth/l2cap_core.c
> > > > > > > > > +++ b/net/bluetooth/l2cap_core.c
> > > > > > > > > @@ -483,9 +483,7 @@ static void l2cap_chan_destroy(struct kref *kref)
> > > > > > > > >
> > > > > > > > >         BT_DBG("chan %p", chan);
> > > > > > > > >
> > > > > > > > > -       write_lock(&chan_list_lock);
> > > > > > > > >         list_del(&chan->global_l);
> > > > > > > > > -       write_unlock(&chan_list_lock);
> > > > > > > > >
> > > > > > > > >         kfree(chan);
> > > > > > > > >  }
> > > > > > > > > @@ -501,7 +499,9 @@ void l2cap_chan_put(struct l2cap_chan *c)
> > > > > > > > >  {
> > > > > > > > >         BT_DBG("chan %p orig refcnt %u", c, kref_read(&c->kref));
> > > > > > > > >
> > > > > > > > > +       write_lock(&chan_list_lock);
> > > > > > > > >         kref_put(&c->kref, l2cap_chan_destroy);
> > > > > > > > > +       write_unlock(&chan_list_lock);
> > > > > > > > >  }
> > > > > > > > >  EXPORT_SYMBOL_GPL(l2cap_chan_put);
> > > > > > > > >
> > > > > > > > >
> > > > > > > >
> > > > > > > > I do not think this patch is correct.
> > > > > > > >
> > > > > > > > a kref does not need to be protected by a write lock.
> > > > > > > >
> > > > > > > > This might shuffle things enough to work around a particular repro you have.
> > > > > > > >
> > > > > > > > If the patch was correct why not protect kref_get() sides ?
> > > > > > > >
> > > > > > > > Before the &hdev->rx_work is scheduled (queue_work(hdev->workqueue,
> > > > > > > > &hdev->rx_work),
> > > > > > > > a reference must be taken.
> > > > > > > >
> > > > > > > > Then this reference must be released at the end of hci_rx_work() or
> > > > > > > > when hdev->workqueue
> > > > > > > > is canceled.
> > > > > > > >
> > > > > > > > This refcount is not needed _if_ the workqueue is properly canceled at
> > > > > > > > device dismantle,
> > > > > > > > in a synchronous way.
> > > > > > > >
> > > > > > > > I do not see this hdev->rx_work being canceled, maybe this is the real issue.
> > > > > > > >
> > > > > > > > There is a call to drain_workqueue() but this is not enough I think,
> > > > > > > > because hci_recv_frame()
> > > > > > > > can re-arm
> > > > > > > >    queue_work(hdev->workqueue, &hdev->rx_work);
> > > > > > >
> > > > > > > I suspect this likely a refcount problem, we do l2cap_get_chan_by_scid:
> > > > > > >
> > > > > > > /* Find channel with given SCID.
> > > > > > >  * Returns locked channel. */
> > > > > > > static struct l2cap_chan *l2cap_get_chan_by_scid(struct l2cap_conn
> > > > > > > *conn, u16 cid)
> > > > > > >
> > > > > > > So we return a locked channel but that doesn't prevent another thread
> > > > > > > to call l2cap_chan_put which doesn't care about l2cap_chan_lock so
> > > > > > > perhaps we actually need to host a reference while we have the lock,
> > > > > > > at least we do something like that on l2cap_sock.c:
> > > > > > >
> > > > > > > l2cap_chan_hold(chan);
> > > > > > > l2cap_chan_lock(chan);
> > > > > > >
> > > > > > > __clear_chan_timer(chan);
> > > > > > > l2cap_chan_close(chan, ECONNRESET);
> > > > > > > l2cap_sock_kill(sk);
> > > > > > >
> > > > > > > l2cap_chan_unlock(chan);
> > > > > > > l2cap_chan_put(chan);
> > > > > >
> > > > > > Perhaps something like this:
> > > > >
> > > > > I'm struggling to apply this for test:
> > > > >
> > > > >   "error: corrupt patch at line 6"
> > > >
> > > > Check with the attached patch.
> > >
> > > With the patch applied:
> > >
> > > [  188.825418][   T75] refcount_t: addition on 0; use-after-free.
> > > [  188.825418][   T75] refcount_t: addition on 0; use-after-free.
> >
> > Looks like the changes just make the issue more visible since we are
> > trying to add a refcount when it is already 0 so this proves the
> > design is not quite right since it is removing the object from the
> > list only when destroying it while we probably need to do it before.
> >
> > How about we use kref_get_unless_zero as it appears it was introduced
> > exactly for such cases (patch attached.)
>
> Looks like I missed a few places like l2cap_global_chan_by_psm so here
> is another version.

Any feedback regarding these changes?

> > Luiz Augusto von Dentz
>
>
>
> --
> Luiz Augusto von Dentz



-- 
Luiz Augusto von Dentz
