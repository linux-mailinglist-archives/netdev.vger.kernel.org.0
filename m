Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B282A5693B8
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 22:58:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234351AbiGFU6n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 16:58:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbiGFU6m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 16:58:42 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2AD613FAA;
        Wed,  6 Jul 2022 13:58:40 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id j21so27943634lfe.1;
        Wed, 06 Jul 2022 13:58:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C01ffpOgx4WvDOiZmitZs4G9/ytDkF+3lkhWoP9eI5Y=;
        b=NDGh6xZkLxznP6/c1nBFBT7xOLTrBP28nYJEV3pRLdxcr45HQnbjLjziU7VWo56OIu
         8WjTp+3BQ4POe6GXTi9uEM4UIc/vxicAagk3XMnNsdXJestHz/T0okwXDpg52HJBKquy
         rbhubK7zXfcP6golFd6U4B81Y16RbMdqpmXqn6wWq3n3BrRE7pSdHVehWK6T74OxUV/S
         PFssE2Mau6uOiBSBqsnAcL/6bXZbNhvbD+QEjUOuaOuKHEwj1ycrdSx1+6LSgGKxB/b4
         h63lVnDk0u0TS2F/CIsZJZF0KXHvLb1FKG2xTZx3QL1gnJI/wkKhE9Z0KwOGjhIrch/6
         50Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C01ffpOgx4WvDOiZmitZs4G9/ytDkF+3lkhWoP9eI5Y=;
        b=0lEUknsJIs2TSZhhdcHhcnaKSiLUhmyBqMRDpat6ot0Yd59OdX9Gw7PazsH6vOEJkc
         2ofheWpyF3ilC+uS84SbJ2b3QEcIdJtFVazxbzgM9dLBFDnh32z3nD8KyXxVgOElh7VE
         UrMbifJ3ocz4lIzYFY3+dDm4XxoiwYiTb5Wpv74uKvqPvCZcWEdH2E2OYUlaa4HRI2Yt
         6hJbrCk7M5+Ik1eQPj/j/F6JMsN6JZHva1NDPgUR4ZOqggNcrL1uU9LSLHTUeHuR83c7
         80lQBWZknzyn1uyp4FlvPstWlkDpvKx+iWaIdZWppKreI7lZ/3BP+6z/qV4NqeFQt78i
         BI2A==
X-Gm-Message-State: AJIora+rwYj89o6G3OPSVNq69cXqyFGPxMrBMB6Kq+G6wjErJkfmUcf3
        JF8qC6R1EwoeBcNg6hemTCVVbxODKopAmTKRbwM=
X-Google-Smtp-Source: AGRyM1u3/bFPcIHtTv5VDMx/votS18IU995bwjeY7VxkjcAO/uO0fK8rC+SejQAP6rLKxuQXwrhOAyXInZAej42i3DQ=
X-Received: by 2002:a05:6512:3b9f:b0:483:9ecc:6740 with SMTP id
 g31-20020a0565123b9f00b004839ecc6740mr7158535lfv.57.1657141119096; Wed, 06
 Jul 2022 13:58:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220622082716.478486-1-lee.jones@linaro.org> <CANn89iK-uFP6Swgc0ZeEC38UsuywJ3wbybSNouH202Wa7X7Tzg@mail.gmail.com>
 <CABBYNZ+C=MQ7577Fr5_W8tQ4iWRSDBSiC4fkRBY3x=9ph+YAzA@mail.gmail.com>
 <CABBYNZLysdh3NFK+G8=NUQ=G=hvS8X0PdMp=bVqiwPDPCAokmg@mail.gmail.com>
 <YrxvgIiWuFVlXBaQ@google.com> <CABBYNZJFSxk9=3Gj7jOj__s=iJGmhrZ=CA7Mb74_-Y0sg+N40g@mail.gmail.com>
 <YsVptCjpzHjR8Scv@google.com> <CABBYNZKvVKRRdWnX3uFWdTXJ_S+oAj6z72zgyV148VmFtUnPpA@mail.gmail.com>
In-Reply-To: <CABBYNZKvVKRRdWnX3uFWdTXJ_S+oAj6z72zgyV148VmFtUnPpA@mail.gmail.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Wed, 6 Jul 2022 13:58:27 -0700
Message-ID: <CABBYNZLTzW3afEPVfg=uS=xsPP-JpW6UBp6W=Urhhab+ai+dcA@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="000000000000bf4c2605e3293b50"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000bf4c2605e3293b50
Content-Type: text/plain; charset="UTF-8"

Hi,

On Wed, Jul 6, 2022 at 1:36 PM Luiz Augusto von Dentz
<luiz.dentz@gmail.com> wrote:
>
> Hi Lee,
>
> On Wed, Jul 6, 2022 at 3:53 AM Lee Jones <lee.jones@linaro.org> wrote:
> >
> > On Tue, 05 Jul 2022, Luiz Augusto von Dentz wrote:
> >
> > > Hi Lee,
> > >
> > > On Wed, Jun 29, 2022 at 8:28 AM Lee Jones <lee.jones@linaro.org> wrote:
> > > >
> > > > On Tue, 28 Jun 2022, Luiz Augusto von Dentz wrote:
> > > >
> > > > > Hi Eric, Lee,
> > > > >
> > > > > On Mon, Jun 27, 2022 at 4:39 PM Luiz Augusto von Dentz
> > > > > <luiz.dentz@gmail.com> wrote:
> > > > > >
> > > > > > Hi Eric, Lee,
> > > > > >
> > > > > > On Mon, Jun 27, 2022 at 7:41 AM Eric Dumazet <edumazet@google.com> wrote:
> > > > > > >
> > > > > > > On Wed, Jun 22, 2022 at 10:27 AM Lee Jones <lee.jones@linaro.org> wrote:
> > > > > > > >
> > > > > > > > This change prevents a use-after-free caused by one of the worker
> > > > > > > > threads starting up (see below) *after* the final channel reference
> > > > > > > > has been put() during sock_close() but *before* the references to the
> > > > > > > > channel have been destroyed.
> > > > > > > >
> > > > > > > >   refcount_t: increment on 0; use-after-free.
> > > > > > > >   BUG: KASAN: use-after-free in refcount_dec_and_test+0x20/0xd0
> > > > > > > >   Read of size 4 at addr ffffffc114f5bf18 by task kworker/u17:14/705
> > > > > > > >
> > > > > > > >   CPU: 4 PID: 705 Comm: kworker/u17:14 Tainted: G S      W       4.14.234-00003-g1fb6d0bd49a4-dirty #28
> > > > > > > >   Hardware name: Qualcomm Technologies, Inc. SM8150 V2 PM8150 Google Inc. MSM sm8150 Flame DVT (DT)
> > > > > > > >   Workqueue: hci0 hci_rx_work
> > > > > > > >   Call trace:
> > > > > > > >    dump_backtrace+0x0/0x378
> > > > > > > >    show_stack+0x20/0x2c
> > > > > > > >    dump_stack+0x124/0x148
> > > > > > > >    print_address_description+0x80/0x2e8
> > > > > > > >    __kasan_report+0x168/0x188
> > > > > > > >    kasan_report+0x10/0x18
> > > > > > > >    __asan_load4+0x84/0x8c
> > > > > > > >    refcount_dec_and_test+0x20/0xd0
> > > > > > > >    l2cap_chan_put+0x48/0x12c
> > > > > > > >    l2cap_recv_frame+0x4770/0x6550
> > > > > > > >    l2cap_recv_acldata+0x44c/0x7a4
> > > > > > > >    hci_acldata_packet+0x100/0x188
> > > > > > > >    hci_rx_work+0x178/0x23c
> > > > > > > >    process_one_work+0x35c/0x95c
> > > > > > > >    worker_thread+0x4cc/0x960
> > > > > > > >    kthread+0x1a8/0x1c4
> > > > > > > >    ret_from_fork+0x10/0x18
> > > > > > > >
> > > > > > > > Cc: stable@kernel.org
> > > > > > >
> > > > > > > When was the bug added ? (Fixes: tag please)
> > > > > > >
> > > > > > > > Cc: Marcel Holtmann <marcel@holtmann.org>
> > > > > > > > Cc: Johan Hedberg <johan.hedberg@gmail.com>
> > > > > > > > Cc: Luiz Augusto von Dentz <luiz.dentz@gmail.com>
> > > > > > > > Cc: "David S. Miller" <davem@davemloft.net>
> > > > > > > > Cc: Eric Dumazet <edumazet@google.com>
> > > > > > > > Cc: Jakub Kicinski <kuba@kernel.org>
> > > > > > > > Cc: Paolo Abeni <pabeni@redhat.com>
> > > > > > > > Cc: linux-bluetooth@vger.kernel.org
> > > > > > > > Cc: netdev@vger.kernel.org
> > > > > > > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > > > > > > > ---
> > > > > > > >  net/bluetooth/l2cap_core.c | 4 ++--
> > > > > > > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > > > > > >
> > > > > > > > diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
> > > > > > > > index ae78490ecd3d4..82279c5919fd8 100644
> > > > > > > > --- a/net/bluetooth/l2cap_core.c
> > > > > > > > +++ b/net/bluetooth/l2cap_core.c
> > > > > > > > @@ -483,9 +483,7 @@ static void l2cap_chan_destroy(struct kref *kref)
> > > > > > > >
> > > > > > > >         BT_DBG("chan %p", chan);
> > > > > > > >
> > > > > > > > -       write_lock(&chan_list_lock);
> > > > > > > >         list_del(&chan->global_l);
> > > > > > > > -       write_unlock(&chan_list_lock);
> > > > > > > >
> > > > > > > >         kfree(chan);
> > > > > > > >  }
> > > > > > > > @@ -501,7 +499,9 @@ void l2cap_chan_put(struct l2cap_chan *c)
> > > > > > > >  {
> > > > > > > >         BT_DBG("chan %p orig refcnt %u", c, kref_read(&c->kref));
> > > > > > > >
> > > > > > > > +       write_lock(&chan_list_lock);
> > > > > > > >         kref_put(&c->kref, l2cap_chan_destroy);
> > > > > > > > +       write_unlock(&chan_list_lock);
> > > > > > > >  }
> > > > > > > >  EXPORT_SYMBOL_GPL(l2cap_chan_put);
> > > > > > > >
> > > > > > > >
> > > > > > >
> > > > > > > I do not think this patch is correct.
> > > > > > >
> > > > > > > a kref does not need to be protected by a write lock.
> > > > > > >
> > > > > > > This might shuffle things enough to work around a particular repro you have.
> > > > > > >
> > > > > > > If the patch was correct why not protect kref_get() sides ?
> > > > > > >
> > > > > > > Before the &hdev->rx_work is scheduled (queue_work(hdev->workqueue,
> > > > > > > &hdev->rx_work),
> > > > > > > a reference must be taken.
> > > > > > >
> > > > > > > Then this reference must be released at the end of hci_rx_work() or
> > > > > > > when hdev->workqueue
> > > > > > > is canceled.
> > > > > > >
> > > > > > > This refcount is not needed _if_ the workqueue is properly canceled at
> > > > > > > device dismantle,
> > > > > > > in a synchronous way.
> > > > > > >
> > > > > > > I do not see this hdev->rx_work being canceled, maybe this is the real issue.
> > > > > > >
> > > > > > > There is a call to drain_workqueue() but this is not enough I think,
> > > > > > > because hci_recv_frame()
> > > > > > > can re-arm
> > > > > > >    queue_work(hdev->workqueue, &hdev->rx_work);
> > > > > >
> > > > > > I suspect this likely a refcount problem, we do l2cap_get_chan_by_scid:
> > > > > >
> > > > > > /* Find channel with given SCID.
> > > > > >  * Returns locked channel. */
> > > > > > static struct l2cap_chan *l2cap_get_chan_by_scid(struct l2cap_conn
> > > > > > *conn, u16 cid)
> > > > > >
> > > > > > So we return a locked channel but that doesn't prevent another thread
> > > > > > to call l2cap_chan_put which doesn't care about l2cap_chan_lock so
> > > > > > perhaps we actually need to host a reference while we have the lock,
> > > > > > at least we do something like that on l2cap_sock.c:
> > > > > >
> > > > > > l2cap_chan_hold(chan);
> > > > > > l2cap_chan_lock(chan);
> > > > > >
> > > > > > __clear_chan_timer(chan);
> > > > > > l2cap_chan_close(chan, ECONNRESET);
> > > > > > l2cap_sock_kill(sk);
> > > > > >
> > > > > > l2cap_chan_unlock(chan);
> > > > > > l2cap_chan_put(chan);
> > > > >
> > > > > Perhaps something like this:
> > > >
> > > > I'm struggling to apply this for test:
> > > >
> > > >   "error: corrupt patch at line 6"
> > >
> > > Check with the attached patch.
> >
> > With the patch applied:
> >
> > [  188.825418][   T75] refcount_t: addition on 0; use-after-free.
> > [  188.825418][   T75] refcount_t: addition on 0; use-after-free.
>
> Looks like the changes just make the issue more visible since we are
> trying to add a refcount when it is already 0 so this proves the
> design is not quite right since it is removing the object from the
> list only when destroying it while we probably need to do it before.
>
> How about we use kref_get_unless_zero as it appears it was introduced
> exactly for such cases (patch attached.)

Looks like I missed a few places like l2cap_global_chan_by_psm so here
is another version.

> Luiz Augusto von Dentz



-- 
Luiz Augusto von Dentz

--000000000000bf4c2605e3293b50
Content-Type: text/x-patch; charset="US-ASCII"; name="0001-Bluetooth-L2CAP-WIP.patch"
Content-Disposition: attachment; filename="0001-Bluetooth-L2CAP-WIP.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_l5a30y210>
X-Attachment-Id: f_l5a30y210

RnJvbSAyMzU5MzdhYzdhMzlkMTZlNWRhYmJmY2EwYWMxZDU4ZTRjYzgxNGQ5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBMdWl6IEF1Z3VzdG8gdm9uIERlbnR6IDxsdWl6LnZvbi5kZW50
ekBpbnRlbC5jb20+CkRhdGU6IFR1ZSwgMjggSnVuIDIwMjIgMTU6NDY6MDQgLTA3MDAKU3ViamVj
dDogW1BBVENIXSBCbHVldG9vdGg6IEwyQ0FQOiBXSVAKClNpZ25lZC1vZmYtYnk6IEx1aXogQXVn
dXN0byB2b24gRGVudHogPGx1aXoudm9uLmRlbnR6QGludGVsLmNvbT4KLS0tCiBpbmNsdWRlL25l
dC9ibHVldG9vdGgvbDJjYXAuaCB8ICAxICsKIG5ldC9ibHVldG9vdGgvbDJjYXBfY29yZS5jICAg
IHwgNTggKysrKysrKysrKysrKysrKysrKysrKysrKysrLS0tLS0tLS0KIDIgZmlsZXMgY2hhbmdl
ZCwgNDYgaW5zZXJ0aW9ucygrKSwgMTMgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvaW5jbHVk
ZS9uZXQvYmx1ZXRvb3RoL2wyY2FwLmggYi9pbmNsdWRlL25ldC9ibHVldG9vdGgvbDJjYXAuaApp
bmRleCAzYzRmNTUwZTVhOGIuLjJmNzY2ZTM0MzdjZSAxMDA2NDQKLS0tIGEvaW5jbHVkZS9uZXQv
Ymx1ZXRvb3RoL2wyY2FwLmgKKysrIGIvaW5jbHVkZS9uZXQvYmx1ZXRvb3RoL2wyY2FwLmgKQEAg
LTg0Nyw2ICs4NDcsNyBAQCBlbnVtIHsKIH07CiAKIHZvaWQgbDJjYXBfY2hhbl9ob2xkKHN0cnVj
dCBsMmNhcF9jaGFuICpjKTsKK3N0cnVjdCBsMmNhcF9jaGFuICpsMmNhcF9jaGFuX2hvbGRfdW5s
ZXNzX3plcm8oc3RydWN0IGwyY2FwX2NoYW4gKmMpOwogdm9pZCBsMmNhcF9jaGFuX3B1dChzdHJ1
Y3QgbDJjYXBfY2hhbiAqYyk7CiAKIHN0YXRpYyBpbmxpbmUgdm9pZCBsMmNhcF9jaGFuX2xvY2so
c3RydWN0IGwyY2FwX2NoYW4gKmNoYW4pCmRpZmYgLS1naXQgYS9uZXQvYmx1ZXRvb3RoL2wyY2Fw
X2NvcmUuYyBiL25ldC9ibHVldG9vdGgvbDJjYXBfY29yZS5jCmluZGV4IDA5ZWNhZjU1NmRlNS4u
M2U1ZDgxZTk3MWNjIDEwMDY0NAotLS0gYS9uZXQvYmx1ZXRvb3RoL2wyY2FwX2NvcmUuYworKysg
Yi9uZXQvYmx1ZXRvb3RoL2wyY2FwX2NvcmUuYwpAQCAtMTExLDcgKzExMSw4IEBAIHN0YXRpYyBz
dHJ1Y3QgbDJjYXBfY2hhbiAqX19sMmNhcF9nZXRfY2hhbl9ieV9zY2lkKHN0cnVjdCBsMmNhcF9j
b25uICpjb25uLAogfQogCiAvKiBGaW5kIGNoYW5uZWwgd2l0aCBnaXZlbiBTQ0lELgotICogUmV0
dXJucyBsb2NrZWQgY2hhbm5lbC4gKi8KKyAqIFJldHVybnMgYSByZWZlcmVuY2UgbG9ja2VkIGNo
YW5uZWwuCisgKi8KIHN0YXRpYyBzdHJ1Y3QgbDJjYXBfY2hhbiAqbDJjYXBfZ2V0X2NoYW5fYnlf
c2NpZChzdHJ1Y3QgbDJjYXBfY29ubiAqY29ubiwKIAkJCQkJCSB1MTYgY2lkKQogewpAQCAtMTE5
LDE1ICsxMjAsMTkgQEAgc3RhdGljIHN0cnVjdCBsMmNhcF9jaGFuICpsMmNhcF9nZXRfY2hhbl9i
eV9zY2lkKHN0cnVjdCBsMmNhcF9jb25uICpjb25uLAogCiAJbXV0ZXhfbG9jaygmY29ubi0+Y2hh
bl9sb2NrKTsKIAljID0gX19sMmNhcF9nZXRfY2hhbl9ieV9zY2lkKGNvbm4sIGNpZCk7Ci0JaWYg
KGMpCi0JCWwyY2FwX2NoYW5fbG9jayhjKTsKKwlpZiAoYykgeworCQkvKiBPbmx5IGxvY2sgaWYg
Y2hhbiByZWZlcmVuY2UgaXMgbm90IDAgKi8KKwkJYyA9IGwyY2FwX2NoYW5faG9sZF91bmxlc3Nf
emVybyhjKTsKKwkJaWYgKGMpCisJCQlsMmNhcF9jaGFuX2xvY2soYyk7CisJfQogCW11dGV4X3Vu
bG9jaygmY29ubi0+Y2hhbl9sb2NrKTsKIAogCXJldHVybiBjOwogfQogCiAvKiBGaW5kIGNoYW5u
ZWwgd2l0aCBnaXZlbiBEQ0lELgotICogUmV0dXJucyBsb2NrZWQgY2hhbm5lbC4KKyAqIFJldHVy
bnMgYSByZWZlcmVuY2UgbG9ja2VkIGNoYW5uZWwuCiAgKi8KIHN0YXRpYyBzdHJ1Y3QgbDJjYXBf
Y2hhbiAqbDJjYXBfZ2V0X2NoYW5fYnlfZGNpZChzdHJ1Y3QgbDJjYXBfY29ubiAqY29ubiwKIAkJ
CQkJCSB1MTYgY2lkKQpAQCAtMTM2LDggKzE0MSwxMiBAQCBzdGF0aWMgc3RydWN0IGwyY2FwX2No
YW4gKmwyY2FwX2dldF9jaGFuX2J5X2RjaWQoc3RydWN0IGwyY2FwX2Nvbm4gKmNvbm4sCiAKIAlt
dXRleF9sb2NrKCZjb25uLT5jaGFuX2xvY2spOwogCWMgPSBfX2wyY2FwX2dldF9jaGFuX2J5X2Rj
aWQoY29ubiwgY2lkKTsKLQlpZiAoYykKLQkJbDJjYXBfY2hhbl9sb2NrKGMpOworCWlmIChjKSB7
CisJCS8qIE9ubHkgbG9jayBpZiBjaGFuIHJlZmVyZW5jZSBpcyBub3QgMCAqLworCQljID0gbDJj
YXBfY2hhbl9ob2xkX3VubGVzc196ZXJvKGMpOworCQlpZiAoYykKKwkJCWwyY2FwX2NoYW5fbG9j
ayhjKTsKKwl9CiAJbXV0ZXhfdW5sb2NrKCZjb25uLT5jaGFuX2xvY2spOwogCiAJcmV0dXJuIGM7
CkBAIC0xNjIsOCArMTcxLDEyIEBAIHN0YXRpYyBzdHJ1Y3QgbDJjYXBfY2hhbiAqbDJjYXBfZ2V0
X2NoYW5fYnlfaWRlbnQoc3RydWN0IGwyY2FwX2Nvbm4gKmNvbm4sCiAKIAltdXRleF9sb2NrKCZj
b25uLT5jaGFuX2xvY2spOwogCWMgPSBfX2wyY2FwX2dldF9jaGFuX2J5X2lkZW50KGNvbm4sIGlk
ZW50KTsKLQlpZiAoYykKLQkJbDJjYXBfY2hhbl9sb2NrKGMpOworCWlmIChjKSB7CisJCS8qIE9u
bHkgbG9jayBpZiBjaGFuIHJlZmVyZW5jZSBpcyBub3QgMCAqLworCQljID0gbDJjYXBfY2hhbl9o
b2xkX3VubGVzc196ZXJvKGMpOworCQlpZiAoYykKKwkJCWwyY2FwX2NoYW5fbG9jayhjKTsKKwl9
CiAJbXV0ZXhfdW5sb2NrKCZjb25uLT5jaGFuX2xvY2spOwogCiAJcmV0dXJuIGM7CkBAIC00OTcs
NiArNTEwLDE2IEBAIHZvaWQgbDJjYXBfY2hhbl9ob2xkKHN0cnVjdCBsMmNhcF9jaGFuICpjKQog
CWtyZWZfZ2V0KCZjLT5rcmVmKTsKIH0KIAorc3RydWN0IGwyY2FwX2NoYW4gKmwyY2FwX2NoYW5f
aG9sZF91bmxlc3NfemVybyhzdHJ1Y3QgbDJjYXBfY2hhbiAqYykKK3sKKwlCVF9EQkcoImNoYW4g
JXAgb3JpZyByZWZjbnQgJXUiLCBjLCBrcmVmX3JlYWQoJmMtPmtyZWYpKTsKKworCWlmICgha3Jl
Zl9nZXRfdW5sZXNzX3plcm8oJmMtPmtyZWYpKQorCQlyZXR1cm4gTlVMTDsKKworCXJldHVybiBj
OworfQorCiB2b2lkIGwyY2FwX2NoYW5fcHV0KHN0cnVjdCBsMmNhcF9jaGFuICpjKQogewogCUJU
X0RCRygiY2hhbiAlcCBvcmlnIHJlZmNudCAldSIsIGMsIGtyZWZfcmVhZCgmYy0+a3JlZikpOwpA
QCAtMTk2OSw3ICsxOTkyLDcgQEAgc3RhdGljIHN0cnVjdCBsMmNhcF9jaGFuICpsMmNhcF9nbG9i
YWxfY2hhbl9ieV9wc20oaW50IHN0YXRlLCBfX2xlMTYgcHNtLAogCQkJc3JjX21hdGNoID0gIWJh
Y21wKCZjLT5zcmMsIHNyYyk7CiAJCQlkc3RfbWF0Y2ggPSAhYmFjbXAoJmMtPmRzdCwgZHN0KTsK
IAkJCWlmIChzcmNfbWF0Y2ggJiYgZHN0X21hdGNoKSB7Ci0JCQkJbDJjYXBfY2hhbl9ob2xkKGMp
OworCQkJCWMgPSBsMmNhcF9jaGFuX2hvbGRfdW5sZXNzX3plcm8oYyk7CiAJCQkJcmVhZF91bmxv
Y2soJmNoYW5fbGlzdF9sb2NrKTsKIAkJCQlyZXR1cm4gYzsKIAkJCX0KQEAgLTE5ODQsNyArMjAw
Nyw3IEBAIHN0YXRpYyBzdHJ1Y3QgbDJjYXBfY2hhbiAqbDJjYXBfZ2xvYmFsX2NoYW5fYnlfcHNt
KGludCBzdGF0ZSwgX19sZTE2IHBzbSwKIAl9CiAKIAlpZiAoYzEpCi0JCWwyY2FwX2NoYW5faG9s
ZChjMSk7CisJCWMxID0gbDJjYXBfY2hhbl9ob2xkX3VubGVzc196ZXJvKGMxKTsKIAogCXJlYWRf
dW5sb2NrKCZjaGFuX2xpc3RfbG9jayk7CiAKQEAgLTQ0NjQsNiArNDQ4Nyw3IEBAIHN0YXRpYyBp
bmxpbmUgaW50IGwyY2FwX2NvbmZpZ19yZXEoc3RydWN0IGwyY2FwX2Nvbm4gKmNvbm4sCiAKIHVu
bG9jazoKIAlsMmNhcF9jaGFuX3VubG9jayhjaGFuKTsKKwlsMmNhcF9jaGFuX3B1dChjaGFuKTsK
IAlyZXR1cm4gZXJyOwogfQogCkBAIC00NTc4LDYgKzQ2MDIsNyBAQCBzdGF0aWMgaW5saW5lIGlu
dCBsMmNhcF9jb25maWdfcnNwKHN0cnVjdCBsMmNhcF9jb25uICpjb25uLAogCiBkb25lOgogCWwy
Y2FwX2NoYW5fdW5sb2NrKGNoYW4pOworCWwyY2FwX2NoYW5fcHV0KGNoYW4pOwogCXJldHVybiBl
cnI7CiB9CiAKQEAgLTUzMDUsNiArNTMzMCw3IEBAIHN0YXRpYyBpbmxpbmUgaW50IGwyY2FwX21v
dmVfY2hhbm5lbF9yZXEoc3RydWN0IGwyY2FwX2Nvbm4gKmNvbm4sCiAJbDJjYXBfc2VuZF9tb3Zl
X2NoYW5fcnNwKGNoYW4sIHJlc3VsdCk7CiAKIAlsMmNhcF9jaGFuX3VubG9jayhjaGFuKTsKKwls
MmNhcF9jaGFuX3B1dChjaGFuKTsKIAogCXJldHVybiAwOwogfQpAQCAtNTM5Nyw2ICs1NDIzLDcg
QEAgc3RhdGljIHZvaWQgbDJjYXBfbW92ZV9jb250aW51ZShzdHJ1Y3QgbDJjYXBfY29ubiAqY29u
biwgdTE2IGljaWQsIHUxNiByZXN1bHQpCiAJfQogCiAJbDJjYXBfY2hhbl91bmxvY2soY2hhbik7
CisJbDJjYXBfY2hhbl9wdXQoY2hhbik7CiB9CiAKIHN0YXRpYyB2b2lkIGwyY2FwX21vdmVfZmFp
bChzdHJ1Y3QgbDJjYXBfY29ubiAqY29ubiwgdTggaWRlbnQsIHUxNiBpY2lkLApAQCAtNTQyNiw2
ICs1NDUzLDcgQEAgc3RhdGljIHZvaWQgbDJjYXBfbW92ZV9mYWlsKHN0cnVjdCBsMmNhcF9jb25u
ICpjb25uLCB1OCBpZGVudCwgdTE2IGljaWQsCiAJbDJjYXBfc2VuZF9tb3ZlX2NoYW5fY2ZtKGNo
YW4sIEwyQ0FQX01DX1VOQ09ORklSTUVEKTsKIAogCWwyY2FwX2NoYW5fdW5sb2NrKGNoYW4pOwor
CWwyY2FwX2NoYW5fcHV0KGNoYW4pOwogfQogCiBzdGF0aWMgaW50IGwyY2FwX21vdmVfY2hhbm5l
bF9yc3Aoc3RydWN0IGwyY2FwX2Nvbm4gKmNvbm4sCkBAIC01NDg5LDYgKzU1MTcsNyBAQCBzdGF0
aWMgaW50IGwyY2FwX21vdmVfY2hhbm5lbF9jb25maXJtKHN0cnVjdCBsMmNhcF9jb25uICpjb25u
LAogCWwyY2FwX3NlbmRfbW92ZV9jaGFuX2NmbV9yc3AoY29ubiwgY21kLT5pZGVudCwgaWNpZCk7
CiAKIAlsMmNhcF9jaGFuX3VubG9jayhjaGFuKTsKKwlsMmNhcF9jaGFuX3B1dChjaGFuKTsKIAog
CXJldHVybiAwOwogfQpAQCAtNTUyNCw2ICs1NTUzLDcgQEAgc3RhdGljIGlubGluZSBpbnQgbDJj
YXBfbW92ZV9jaGFubmVsX2NvbmZpcm1fcnNwKHN0cnVjdCBsMmNhcF9jb25uICpjb25uLAogCX0K
IAogCWwyY2FwX2NoYW5fdW5sb2NrKGNoYW4pOworCWwyY2FwX2NoYW5fcHV0KGNoYW4pOwogCiAJ
cmV0dXJuIDA7CiB9CkBAIC01ODk2LDEyICs1OTI2LDExIEBAIHN0YXRpYyBpbmxpbmUgaW50IGwy
Y2FwX2xlX2NyZWRpdHMoc3RydWN0IGwyY2FwX2Nvbm4gKmNvbm4sCiAJaWYgKGNyZWRpdHMgPiBt
YXhfY3JlZGl0cykgewogCQlCVF9FUlIoIkxFIGNyZWRpdHMgb3ZlcmZsb3ciKTsKIAkJbDJjYXBf
c2VuZF9kaXNjb25uX3JlcShjaGFuLCBFQ09OTlJFU0VUKTsKLQkJbDJjYXBfY2hhbl91bmxvY2so
Y2hhbik7CiAKIAkJLyogUmV0dXJuIDAgc28gdGhhdCB3ZSBkb24ndCB0cmlnZ2VyIGFuIHVubmVj
ZXNzYXJ5CiAJCSAqIGNvbW1hbmQgcmVqZWN0IHBhY2tldC4KIAkJICovCi0JCXJldHVybiAwOwor
CQlnb3RvIHVubG9jazsKIAl9CiAKIAljaGFuLT50eF9jcmVkaXRzICs9IGNyZWRpdHM7CkBAIC01
OTEyLDcgKzU5NDEsOSBAQCBzdGF0aWMgaW5saW5lIGludCBsMmNhcF9sZV9jcmVkaXRzKHN0cnVj
dCBsMmNhcF9jb25uICpjb25uLAogCWlmIChjaGFuLT50eF9jcmVkaXRzKQogCQljaGFuLT5vcHMt
PnJlc3VtZShjaGFuKTsKIAordW5sb2NrOgogCWwyY2FwX2NoYW5fdW5sb2NrKGNoYW4pOworCWwy
Y2FwX2NoYW5fcHV0KGNoYW4pOwogCiAJcmV0dXJuIDA7CiB9CkBAIC03NTk4LDYgKzc2MjksNyBA
QCBzdGF0aWMgdm9pZCBsMmNhcF9kYXRhX2NoYW5uZWwoc3RydWN0IGwyY2FwX2Nvbm4gKmNvbm4s
IHUxNiBjaWQsCiAKIGRvbmU6CiAJbDJjYXBfY2hhbl91bmxvY2soY2hhbik7CisJbDJjYXBfY2hh
bl9wdXQoY2hhbik7CiB9CiAKIHN0YXRpYyB2b2lkIGwyY2FwX2Nvbmxlc3NfY2hhbm5lbChzdHJ1
Y3QgbDJjYXBfY29ubiAqY29ubiwgX19sZTE2IHBzbSwKQEAgLTgwODYsNyArODExOCw3IEBAIHN0
YXRpYyBzdHJ1Y3QgbDJjYXBfY2hhbiAqbDJjYXBfZ2xvYmFsX2ZpeGVkX2NoYW4oc3RydWN0IGwy
Y2FwX2NoYW4gKmMsCiAJCWlmIChzcmNfdHlwZSAhPSBjLT5zcmNfdHlwZSkKIAkJCWNvbnRpbnVl
OwogCi0JCWwyY2FwX2NoYW5faG9sZChjKTsKKwkJYyA9IGwyY2FwX2NoYW5faG9sZF91bmxlc3Nf
emVybyhjKTsKIAkJcmVhZF91bmxvY2soJmNoYW5fbGlzdF9sb2NrKTsKIAkJcmV0dXJuIGM7CiAJ
fQotLSAKMi4zNS4zCgo=
--000000000000bf4c2605e3293b50--
