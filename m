Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A57356862E
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 12:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231831AbiGFKxs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 06:53:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233147AbiGFKxr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 06:53:47 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31FCD27B2F
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 03:53:44 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id cl1so21505364wrb.4
        for <netdev@vger.kernel.org>; Wed, 06 Jul 2022 03:53:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=+p/4sekWheWdbGIovM0EKfWut/d2MmPvCx5j78VW0Vs=;
        b=rXldJeWVAwZytiPiHVi1BAjtiAFO4lS3mLt9IX7NcreiMLklVm5nuj5Uig5SKiFb5b
         S1xNuDFdy0EiIINahHtwOJNRHPPzZlyBKl5C1yFwJAapLu7reu6rKJfJ1iw78eSveo20
         QWA8uQnYuvMuTt71mYPYlmt0UZDyNFYExPf8GrKeijuRoQ8htT1APLBwkGlUdTRUMyil
         FkbJ7vKWKpwH0ZEa5bq7TYooTjT0Jb/78M1I+AprGItcMZykwhQMY+U3ijRaHyJHexj5
         CH5Qxz7QX89rZKUyTgmscg7x0jfnd9hr5S5Iwp/C+IZFXn1N86Fi6mpAfVWA/UL38Zqq
         GVDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=+p/4sekWheWdbGIovM0EKfWut/d2MmPvCx5j78VW0Vs=;
        b=AootmxlvssBStSl2SmqMnDYThadqofdGXt80WPohoVfsvYO2nUCZwFCuK0BnjusvDN
         bQw5eiTquYJPPZ8hL51+PWFMQIObcyFGMHnBFlpiBCObUHtWO8n/uomMpir9VRMA+KfW
         1Wsdst0B46KsreWf+mSlkEl+1Ifsswz2jk0+PJ5Iinx0ZQan3NWjs6geeo4deGQHL/J8
         Zdz698oWDyPnE3TFedJ6s4wPTFKAg+u70BvB5yHRc50Mnmc1W3iFQFnJvTDKHg+sPcgC
         aWeI24r2HmNizoRyB16G0SV8DvN4gU7ScV1YJ4i/OC+1Bwn5L7yBM377aJBPQiFGHg5x
         NTRQ==
X-Gm-Message-State: AJIora+jtecwe/mH9o9XD1BDeKlwP5D49mXHViF4rTDOp59Iwl9sqSue
        8jNXM2k5qzYsRvp+zAQ8muNx/Q==
X-Google-Smtp-Source: AGRyM1sVpr33P2lGME5nAB3rmW5C4qG2GBBItyEacEYV04dU0Z8Luz6mWEWOSjhPRu9n+W5O4KKXZw==
X-Received: by 2002:a5d:448e:0:b0:21b:887f:23f with SMTP id j14-20020a5d448e000000b0021b887f023fmr37162663wrq.240.1657104822588;
        Wed, 06 Jul 2022 03:53:42 -0700 (PDT)
Received: from google.com (cpc155339-bagu17-2-0-cust87.1-3.cable.virginm.net. [86.27.177.88])
        by smtp.gmail.com with ESMTPSA id d21-20020a1c7315000000b003a02cbf862esm24990019wmb.13.2022.07.06.03.53.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jul 2022 03:53:42 -0700 (PDT)
Date:   Wed, 6 Jul 2022 11:53:40 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        LKML <linux-kernel@vger.kernel.org>, stable@kernel.org,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [RESEND 1/1] Bluetooth: Use chan_list_lock to protect the whole
 put/destroy invokation
Message-ID: <YsVptCjpzHjR8Scv@google.com>
References: <20220622082716.478486-1-lee.jones@linaro.org>
 <CANn89iK-uFP6Swgc0ZeEC38UsuywJ3wbybSNouH202Wa7X7Tzg@mail.gmail.com>
 <CABBYNZ+C=MQ7577Fr5_W8tQ4iWRSDBSiC4fkRBY3x=9ph+YAzA@mail.gmail.com>
 <CABBYNZLysdh3NFK+G8=NUQ=G=hvS8X0PdMp=bVqiwPDPCAokmg@mail.gmail.com>
 <YrxvgIiWuFVlXBaQ@google.com>
 <CABBYNZJFSxk9=3Gj7jOj__s=iJGmhrZ=CA7Mb74_-Y0sg+N40g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABBYNZJFSxk9=3Gj7jOj__s=iJGmhrZ=CA7Mb74_-Y0sg+N40g@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 05 Jul 2022, Luiz Augusto von Dentz wrote:

> Hi Lee,
> 
> On Wed, Jun 29, 2022 at 8:28 AM Lee Jones <lee.jones@linaro.org> wrote:
> >
> > On Tue, 28 Jun 2022, Luiz Augusto von Dentz wrote:
> >
> > > Hi Eric, Lee,
> > >
> > > On Mon, Jun 27, 2022 at 4:39 PM Luiz Augusto von Dentz
> > > <luiz.dentz@gmail.com> wrote:
> > > >
> > > > Hi Eric, Lee,
> > > >
> > > > On Mon, Jun 27, 2022 at 7:41 AM Eric Dumazet <edumazet@google.com> wrote:
> > > > >
> > > > > On Wed, Jun 22, 2022 at 10:27 AM Lee Jones <lee.jones@linaro.org> wrote:
> > > > > >
> > > > > > This change prevents a use-after-free caused by one of the worker
> > > > > > threads starting up (see below) *after* the final channel reference
> > > > > > has been put() during sock_close() but *before* the references to the
> > > > > > channel have been destroyed.
> > > > > >
> > > > > >   refcount_t: increment on 0; use-after-free.
> > > > > >   BUG: KASAN: use-after-free in refcount_dec_and_test+0x20/0xd0
> > > > > >   Read of size 4 at addr ffffffc114f5bf18 by task kworker/u17:14/705
> > > > > >
> > > > > >   CPU: 4 PID: 705 Comm: kworker/u17:14 Tainted: G S      W       4.14.234-00003-g1fb6d0bd49a4-dirty #28
> > > > > >   Hardware name: Qualcomm Technologies, Inc. SM8150 V2 PM8150 Google Inc. MSM sm8150 Flame DVT (DT)
> > > > > >   Workqueue: hci0 hci_rx_work
> > > > > >   Call trace:
> > > > > >    dump_backtrace+0x0/0x378
> > > > > >    show_stack+0x20/0x2c
> > > > > >    dump_stack+0x124/0x148
> > > > > >    print_address_description+0x80/0x2e8
> > > > > >    __kasan_report+0x168/0x188
> > > > > >    kasan_report+0x10/0x18
> > > > > >    __asan_load4+0x84/0x8c
> > > > > >    refcount_dec_and_test+0x20/0xd0
> > > > > >    l2cap_chan_put+0x48/0x12c
> > > > > >    l2cap_recv_frame+0x4770/0x6550
> > > > > >    l2cap_recv_acldata+0x44c/0x7a4
> > > > > >    hci_acldata_packet+0x100/0x188
> > > > > >    hci_rx_work+0x178/0x23c
> > > > > >    process_one_work+0x35c/0x95c
> > > > > >    worker_thread+0x4cc/0x960
> > > > > >    kthread+0x1a8/0x1c4
> > > > > >    ret_from_fork+0x10/0x18
> > > > > >
> > > > > > Cc: stable@kernel.org
> > > > >
> > > > > When was the bug added ? (Fixes: tag please)
> > > > >
> > > > > > Cc: Marcel Holtmann <marcel@holtmann.org>
> > > > > > Cc: Johan Hedberg <johan.hedberg@gmail.com>
> > > > > > Cc: Luiz Augusto von Dentz <luiz.dentz@gmail.com>
> > > > > > Cc: "David S. Miller" <davem@davemloft.net>
> > > > > > Cc: Eric Dumazet <edumazet@google.com>
> > > > > > Cc: Jakub Kicinski <kuba@kernel.org>
> > > > > > Cc: Paolo Abeni <pabeni@redhat.com>
> > > > > > Cc: linux-bluetooth@vger.kernel.org
> > > > > > Cc: netdev@vger.kernel.org
> > > > > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > > > > > ---
> > > > > >  net/bluetooth/l2cap_core.c | 4 ++--
> > > > > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > > > >
> > > > > > diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
> > > > > > index ae78490ecd3d4..82279c5919fd8 100644
> > > > > > --- a/net/bluetooth/l2cap_core.c
> > > > > > +++ b/net/bluetooth/l2cap_core.c
> > > > > > @@ -483,9 +483,7 @@ static void l2cap_chan_destroy(struct kref *kref)
> > > > > >
> > > > > >         BT_DBG("chan %p", chan);
> > > > > >
> > > > > > -       write_lock(&chan_list_lock);
> > > > > >         list_del(&chan->global_l);
> > > > > > -       write_unlock(&chan_list_lock);
> > > > > >
> > > > > >         kfree(chan);
> > > > > >  }
> > > > > > @@ -501,7 +499,9 @@ void l2cap_chan_put(struct l2cap_chan *c)
> > > > > >  {
> > > > > >         BT_DBG("chan %p orig refcnt %u", c, kref_read(&c->kref));
> > > > > >
> > > > > > +       write_lock(&chan_list_lock);
> > > > > >         kref_put(&c->kref, l2cap_chan_destroy);
> > > > > > +       write_unlock(&chan_list_lock);
> > > > > >  }
> > > > > >  EXPORT_SYMBOL_GPL(l2cap_chan_put);
> > > > > >
> > > > > >
> > > > >
> > > > > I do not think this patch is correct.
> > > > >
> > > > > a kref does not need to be protected by a write lock.
> > > > >
> > > > > This might shuffle things enough to work around a particular repro you have.
> > > > >
> > > > > If the patch was correct why not protect kref_get() sides ?
> > > > >
> > > > > Before the &hdev->rx_work is scheduled (queue_work(hdev->workqueue,
> > > > > &hdev->rx_work),
> > > > > a reference must be taken.
> > > > >
> > > > > Then this reference must be released at the end of hci_rx_work() or
> > > > > when hdev->workqueue
> > > > > is canceled.
> > > > >
> > > > > This refcount is not needed _if_ the workqueue is properly canceled at
> > > > > device dismantle,
> > > > > in a synchronous way.
> > > > >
> > > > > I do not see this hdev->rx_work being canceled, maybe this is the real issue.
> > > > >
> > > > > There is a call to drain_workqueue() but this is not enough I think,
> > > > > because hci_recv_frame()
> > > > > can re-arm
> > > > >    queue_work(hdev->workqueue, &hdev->rx_work);
> > > >
> > > > I suspect this likely a refcount problem, we do l2cap_get_chan_by_scid:
> > > >
> > > > /* Find channel with given SCID.
> > > >  * Returns locked channel. */
> > > > static struct l2cap_chan *l2cap_get_chan_by_scid(struct l2cap_conn
> > > > *conn, u16 cid)
> > > >
> > > > So we return a locked channel but that doesn't prevent another thread
> > > > to call l2cap_chan_put which doesn't care about l2cap_chan_lock so
> > > > perhaps we actually need to host a reference while we have the lock,
> > > > at least we do something like that on l2cap_sock.c:
> > > >
> > > > l2cap_chan_hold(chan);
> > > > l2cap_chan_lock(chan);
> > > >
> > > > __clear_chan_timer(chan);
> > > > l2cap_chan_close(chan, ECONNRESET);
> > > > l2cap_sock_kill(sk);
> > > >
> > > > l2cap_chan_unlock(chan);
> > > > l2cap_chan_put(chan);
> > >
> > > Perhaps something like this:
> >
> > I'm struggling to apply this for test:
> >
> >   "error: corrupt patch at line 6"
> 
> Check with the attached patch.

With the patch applied:

[  188.825418][   T75] refcount_t: addition on 0; use-after-free.
[  188.825418][   T75] refcount_t: addition on 0; use-after-free.
[  188.840629][   T75] WARNING: CPU: 5 PID: 75 at lib/refcount.c:25 refcount_warn_saturate+0x147/0x1b0
[  188.840629][   T75] WARNING: CPU: 5 PID: 75 at lib/refcount.c:25 refcount_warn_saturate+0x147/0x1b0
[  188.862642][   T75] Modules linked in:
[  188.862642][   T75] Modules linked in:
[  188.871686][   T75] CPU: 5 PID: 75 Comm: kworker/u17:0 Not tainted 5.18.0-00005-gc3401a7ad65f #8
[  188.871686][   T75] CPU: 5 PID: 75 Comm: kworker/u17:0 Not tainted 5.18.0-00005-gc3401a7ad65f #8
[  188.892806][   T75] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.0-debian-1.16.0-4 04/01/2014
[  188.892806][   T75] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.0-debian-1.16.0-4 04/01/2014
[  188.917398][   T75] Workqueue: hci0 hci_rx_work
[  188.917398][   T75] Workqueue: hci0 hci_rx_work
[  188.928515][   T75] RIP: 0010:refcount_warn_saturate+0x147/0x1b0
[  188.928515][   T75] RIP: 0010:refcount_warn_saturate+0x147/0x1b0
[  188.943176][   T75] Code: c7 e0 a1 70 85 31 c0 e8 d7 c2 e8 fe 0f 0b eb a1 e8 fe 33 15 ff c6 05 f9 e2 a5 04 01 48 c7 c7 80 a2 70 80
[  188.943176][   T75] Code: c7 e0 a1 70 85 31 c0 e8 d7 c2 e8 fe 0f 0b eb a1 e8 fe 33 15 ff c6 05 f9 e2 a5 04 01 48 c7 c7 80 a2 70 80
[  188.990053][   T75] RSP: 0018:ffffc9000156f800 EFLAGS: 00010246
[  188.990053][   T75] RSP: 0018:ffffc9000156f800 EFLAGS: 00010246
[  189.004337][   T75] RAX: 118d918bf1a47e00 RBX: 0000000000000002 RCX: ffff8881130ce000
[  189.004337][   T75] RAX: 118d918bf1a47e00 RBX: 0000000000000002 RCX: ffff8881130ce000
[  189.023131][   T75] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
[  189.023131][   T75] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
[  189.042044][   T75] RBP: ffffc9000156f810 R08: ffffffff81574218 R09: ffffed107de165d1
[  189.042044][   T75] RBP: ffffc9000156f810 R08: ffffffff81574218 R09: ffffed107de165d1
[  189.060967][   T75] R10: ffffed107de165d1 R11: 0000000000000000 R12: 1ffff920002adf10
[  189.060967][   T75] R10: ffffed107de165d1 R11: 0000000000000000 R12: 1ffff920002adf10
[  189.079650][   T75] R13: dffffc0000000000 R14: 0000000000000002 R15: ffff888139224818
[  189.079650][   T75] R13: dffffc0000000000 R14: 0000000000000002 R15: ffff888139224818
[  189.098573][   T75] FS:  0000000000000000(0000) GS:ffff8883ef080000(0000) knlGS:0000000000000000
[  189.098573][   T75] FS:  0000000000000000(0000) GS:ffff8883ef080000(0000) knlGS:0000000000000000
[  189.119604][   T75] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  189.119604][   T75] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  189.135313][   T75] CR2: 00000000004a2e98 CR3: 000000000680f000 CR4: 0000000000350ea0
[  189.135313][   T75] CR2: 00000000004a2e98 CR3: 000000000680f000 CR4: 0000000000350ea0
[  189.154165][   T75] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  189.154165][   T75] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  189.173465][   T75] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  189.173465][   T75] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  189.192075][   T75] Call Trace:
[  189.192075][   T75] Call Trace:
[  189.199853][   T75]  <TASK>
[  189.199853][   T75]  <TASK>
[  189.206820][   T75]  l2cap_global_chan_by_psm+0x55a/0x5a0
[  189.206820][   T75]  l2cap_global_chan_by_psm+0x55a/0x5a0
[  189.219891][   T75]  ? l2cap_connect+0x12c0/0x12c0
[  189.219891][   T75]  ? l2cap_connect+0x12c0/0x12c0
[  189.231602][   T75]  ? __kfree_skb+0x13e/0x1c0
[  189.231602][   T75]  ? __kfree_skb+0x13e/0x1c0
[  189.242612][   T75]  ? l2cap_recv_frame+0xf5c/0x95c0
[  189.242612][   T75]  ? l2cap_recv_frame+0xf5c/0x95c0
[  189.254714][   T75]  ? skb_pull+0xde/0x150
[  189.254714][   T75]  ? skb_pull+0xde/0x150
[  189.264776][   T75]  l2cap_recv_frame+0x5bd/0x95c0
[  189.264776][   T75]  l2cap_recv_frame+0x5bd/0x95c0
[  189.276329][   T75]  ? debug_smp_processor_id+0x1c/0x20
[  189.276329][   T75]  ? debug_smp_processor_id+0x1c/0x20
[  189.288985][   T75]  ? update_cfs_rq_load_avg+0x412/0x4f0
[  189.288985][   T75]  ? update_cfs_rq_load_avg+0x412/0x4f0
[  189.302202][   T75]  ? l2cap_recv_acldata+0x1a60/0x1a60
[  189.302202][   T75]  ? l2cap_recv_acldata+0x1a60/0x1a60
[  189.314998][   T75]  ? __kasan_check_write+0x14/0x20
[  189.314998][   T75]  ? __kasan_check_write+0x14/0x20
[  189.326877][   T75]  ? __switch_to+0x617/0x1060
[  189.326877][   T75]  ? __switch_to+0x617/0x1060
[  189.337858][   T75]  ? __kasan_check_write+0x14/0x20
[  189.337858][   T75]  ? __kasan_check_write+0x14/0x20
[  189.349712][   T75]  ? _raw_spin_lock_irqsave+0xdc/0x1f0
[  189.349712][   T75]  ? _raw_spin_lock_irqsave+0xdc/0x1f0
[  189.362793][   T75]  ? compat_start_thread+0x20/0x20
[  189.362793][   T75]  ? compat_start_thread+0x20/0x20
[  189.375316][   T75]  l2cap_recv_acldata+0x5c9/0x1a60
[  189.375316][   T75]  l2cap_recv_acldata+0x5c9/0x1a60
[  189.387262][   T75]  ? hci_connect_sco+0x9b0/0x9b0
[  189.387262][   T75]  ? hci_connect_sco+0x9b0/0x9b0
[  189.398857][   T75]  hci_rx_work+0x54b/0x750
[  189.398857][   T75]  hci_rx_work+0x54b/0x750
[  189.409172][   T75]  process_one_work+0x6eb/0x1080
[  189.409172][   T75]  process_one_work+0x6eb/0x1080
[  189.420829][   T75]  worker_thread+0xb2b/0x13d0
[  189.420829][   T75]  worker_thread+0xb2b/0x13d0
[  189.431922][   T75]  kthread+0x2b1/0x2d0
[  189.431922][   T75]  kthread+0x2b1/0x2d0
[  189.441724][   T75]  ? process_one_work+0x1080/0x1080
[  189.441724][   T75]  ? process_one_work+0x1080/0x1080
[  189.454559][   T75]  ? kthread_blkcg+0xd0/0xd0
[  189.454559][   T75]  ? kthread_blkcg+0xd0/0xd0
[  189.465457][   T75]  ret_from_fork+0x1f/0x30
[  189.465457][   T75]  ret_from_fork+0x1f/0x30
[  189.475777][   T75]  </TASK>
[  189.475777][   T75]  </TASK>
[  189.482907][   T75] ---[ end trace 0000000000000000 ]---
[  189.482907][   T75] ---[ end trace 0000000000000000 ]---
[  189.496567][   T75] ------------[ cut here ]------------
[  189.496567][   T75] ------------[ cut here ]------------
[  189.510250][   T75] refcount_t: underflow; use-after-free.
[  189.510250][   T75] refcount_t: underflow; use-after-free.

> From 88cf6b4f2b0c9ed0bd7ef3b0d38574b412264609 Mon Sep 17 00:00:00 2001
> From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
> Date: Tue, 28 Jun 2022 15:46:04 -0700
> Subject: [PATCH] Bluetooth: L2CAP: WIP
> 
> Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
> ---
>  net/bluetooth/l2cap_core.c | 25 +++++++++++++++++++------
>  1 file changed, 19 insertions(+), 6 deletions(-)
> 
> diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
> index 09ecaf556de5..359fb1ce4372 100644
> --- a/net/bluetooth/l2cap_core.c
> +++ b/net/bluetooth/l2cap_core.c
> @@ -111,7 +111,8 @@ static struct l2cap_chan *__l2cap_get_chan_by_scid(struct l2cap_conn *conn,
>  }
>  
>  /* Find channel with given SCID.
> - * Returns locked channel. */
> + * Returns a reference locked channel.
> + */
>  static struct l2cap_chan *l2cap_get_chan_by_scid(struct l2cap_conn *conn,
>  						 u16 cid)
>  {
> @@ -119,15 +120,17 @@ static struct l2cap_chan *l2cap_get_chan_by_scid(struct l2cap_conn *conn,
>  
>  	mutex_lock(&conn->chan_lock);
>  	c = __l2cap_get_chan_by_scid(conn, cid);
> -	if (c)
> +	if (c) {
> +		l2cap_chan_hold(c);
>  		l2cap_chan_lock(c);
> +	}
>  	mutex_unlock(&conn->chan_lock);
>  
>  	return c;
>  }
>  
>  /* Find channel with given DCID.
> - * Returns locked channel.
> + * Returns a reference locked channel.
>   */
>  static struct l2cap_chan *l2cap_get_chan_by_dcid(struct l2cap_conn *conn,
>  						 u16 cid)
> @@ -136,8 +139,10 @@ static struct l2cap_chan *l2cap_get_chan_by_dcid(struct l2cap_conn *conn,
>  
>  	mutex_lock(&conn->chan_lock);
>  	c = __l2cap_get_chan_by_dcid(conn, cid);
> -	if (c)
> +	if (c) {
> +		l2cap_chan_hold(c);
>  		l2cap_chan_lock(c);
> +	}
>  	mutex_unlock(&conn->chan_lock);
>  
>  	return c;
> @@ -4464,6 +4469,7 @@ static inline int l2cap_config_req(struct l2cap_conn *conn,
>  
>  unlock:
>  	l2cap_chan_unlock(chan);
> +	l2cap_chan_put(chan);
>  	return err;
>  }
>  
> @@ -4578,6 +4584,7 @@ static inline int l2cap_config_rsp(struct l2cap_conn *conn,
>  
>  done:
>  	l2cap_chan_unlock(chan);
> +	l2cap_chan_put(chan);
>  	return err;
>  }
>  
> @@ -5305,6 +5312,7 @@ static inline int l2cap_move_channel_req(struct l2cap_conn *conn,
>  	l2cap_send_move_chan_rsp(chan, result);
>  
>  	l2cap_chan_unlock(chan);
> +	l2cap_chan_put(chan);
>  
>  	return 0;
>  }
> @@ -5397,6 +5405,7 @@ static void l2cap_move_continue(struct l2cap_conn *conn, u16 icid, u16 result)
>  	}
>  
>  	l2cap_chan_unlock(chan);
> +	l2cap_chan_put(chan);
>  }
>  
>  static void l2cap_move_fail(struct l2cap_conn *conn, u8 ident, u16 icid,
> @@ -5489,6 +5498,7 @@ static int l2cap_move_channel_confirm(struct l2cap_conn *conn,
>  	l2cap_send_move_chan_cfm_rsp(conn, cmd->ident, icid);
>  
>  	l2cap_chan_unlock(chan);
> +	l2cap_chan_put(chan);
>  
>  	return 0;
>  }
> @@ -5524,6 +5534,7 @@ static inline int l2cap_move_channel_confirm_rsp(struct l2cap_conn *conn,
>  	}
>  
>  	l2cap_chan_unlock(chan);
> +	l2cap_chan_put(chan);
>  
>  	return 0;
>  }
> @@ -5896,12 +5907,11 @@ static inline int l2cap_le_credits(struct l2cap_conn *conn,
>  	if (credits > max_credits) {
>  		BT_ERR("LE credits overflow");
>  		l2cap_send_disconn_req(chan, ECONNRESET);
> -		l2cap_chan_unlock(chan);
>  
>  		/* Return 0 so that we don't trigger an unnecessary
>  		 * command reject packet.
>  		 */
> -		return 0;
> +		goto unlock;
>  	}
>  
>  	chan->tx_credits += credits;
> @@ -5912,7 +5922,9 @@ static inline int l2cap_le_credits(struct l2cap_conn *conn,
>  	if (chan->tx_credits)
>  		chan->ops->resume(chan);
>  
> +unlock:
>  	l2cap_chan_unlock(chan);
> +	l2cap_chan_put(chan);
>  
>  	return 0;
>  }
> @@ -7598,6 +7610,7 @@ static void l2cap_data_channel(struct l2cap_conn *conn, u16 cid,
>  
>  done:
>  	l2cap_chan_unlock(chan);
> +	l2cap_chan_put(chan);
>  }
>  
>  static void l2cap_conless_channel(struct l2cap_conn *conn, __le16 psm,


-- 
Lee Jones [李琼斯]
Principal Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
