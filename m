Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5405567576
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 19:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232623AbiGERVd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 13:21:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbiGERVc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 13:21:32 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29EAA1F639;
        Tue,  5 Jul 2022 10:21:30 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id j13so2173207ljo.7;
        Tue, 05 Jul 2022 10:21:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BJiLtE764551pODrU/Uui/Vx48pMc8mhIb1OPxIuC6c=;
        b=fmZdn0N4RA+nLTjfP1iauDv593GW1tWx2twoVgKrV6B+jxHuIftpnWriqQhLWJUvOA
         jhtAOGBtUw46u0cR3uxgb5KkQUqAqAHAIXmzEHJrBBP47GDnSqnFDHjpNZEFjmnvIBF/
         lI9jKAUt5tKBbZQFoy4dfgLiCf9s+OqpNqemjOji1FvIU6z54lAmbm6KraY5pi6cYAtI
         KNx5OLkkBVrLg5z2LXFbIt4yF3WYdG4+rl3YM4lWGprw1xULzmLpccjlLZtrD+4CKK/+
         dcPtaYRd8+SZrta3iD5Azzrv08x1h2G3dwWRFFqCb2k8eTv3pi48GcasutOZCfaTeNDo
         URBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BJiLtE764551pODrU/Uui/Vx48pMc8mhIb1OPxIuC6c=;
        b=iWKMdn0NI9ey1nT6TIqb5lBcwsszp4hCcjJ2c9ybfQZxG0Ioqz+L2Zy+ENXW+o6yzq
         z/ZLFikEAbhK3CF8Z1E6rb5LrC45zCVBq9xPr4x1t3+sk09VTTeUF7/fXfvWFTmkIodT
         cCD0IGNVtnXMpDYzqAeWPbrnMjcobHO6qd7xIbOgaSK9huT6GYfOkKlioLBAO+EHQ3hH
         hWlxxCt7kFbXyFG4bm6ftmGl2uyieLE9BnvEK/aVYLlapl5mcG3dP6sziDujeP7IPZBs
         cDISGWiQ0TmuI3FEZ1SvQSGpS8gFYz6QOE9E7Amlsp1XAQPZhKKufs+uKs9eKlPoIYkM
         AZbg==
X-Gm-Message-State: AJIora93QwUpe2REbEswoSukvRt5eVJ68fIoxUhx0p4nuYG81Sjn48wk
        kUAwsRi/Il4xRRYIB1eCOzmDVHdQ5tYNTtsBoBc=
X-Google-Smtp-Source: AGRyM1shPPJ8+8JOYYkUBZmp2EOJAR9+2qt8IIhwd6+mZyxsKx4JJeCqZf2hLrBLJ17pjSAZtAk7n7fx4c+hEEyI/Bc=
X-Received: by 2002:a05:651c:507:b0:25d:3043:ead9 with SMTP id
 o7-20020a05651c050700b0025d3043ead9mr3174706ljp.65.1657041688321; Tue, 05 Jul
 2022 10:21:28 -0700 (PDT)
MIME-Version: 1.0
References: <20220622082716.478486-1-lee.jones@linaro.org> <CANn89iK-uFP6Swgc0ZeEC38UsuywJ3wbybSNouH202Wa7X7Tzg@mail.gmail.com>
 <CABBYNZ+C=MQ7577Fr5_W8tQ4iWRSDBSiC4fkRBY3x=9ph+YAzA@mail.gmail.com>
 <CABBYNZLysdh3NFK+G8=NUQ=G=hvS8X0PdMp=bVqiwPDPCAokmg@mail.gmail.com> <YrxvgIiWuFVlXBaQ@google.com>
In-Reply-To: <YrxvgIiWuFVlXBaQ@google.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Tue, 5 Jul 2022 10:21:16 -0700
Message-ID: <CABBYNZJFSxk9=3Gj7jOj__s=iJGmhrZ=CA7Mb74_-Y0sg+N40g@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="0000000000003610eb05e3121524"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000003610eb05e3121524
Content-Type: text/plain; charset="UTF-8"

Hi Lee,

On Wed, Jun 29, 2022 at 8:28 AM Lee Jones <lee.jones@linaro.org> wrote:
>
> On Tue, 28 Jun 2022, Luiz Augusto von Dentz wrote:
>
> > Hi Eric, Lee,
> >
> > On Mon, Jun 27, 2022 at 4:39 PM Luiz Augusto von Dentz
> > <luiz.dentz@gmail.com> wrote:
> > >
> > > Hi Eric, Lee,
> > >
> > > On Mon, Jun 27, 2022 at 7:41 AM Eric Dumazet <edumazet@google.com> wrote:
> > > >
> > > > On Wed, Jun 22, 2022 at 10:27 AM Lee Jones <lee.jones@linaro.org> wrote:
> > > > >
> > > > > This change prevents a use-after-free caused by one of the worker
> > > > > threads starting up (see below) *after* the final channel reference
> > > > > has been put() during sock_close() but *before* the references to the
> > > > > channel have been destroyed.
> > > > >
> > > > >   refcount_t: increment on 0; use-after-free.
> > > > >   BUG: KASAN: use-after-free in refcount_dec_and_test+0x20/0xd0
> > > > >   Read of size 4 at addr ffffffc114f5bf18 by task kworker/u17:14/705
> > > > >
> > > > >   CPU: 4 PID: 705 Comm: kworker/u17:14 Tainted: G S      W       4.14.234-00003-g1fb6d0bd49a4-dirty #28
> > > > >   Hardware name: Qualcomm Technologies, Inc. SM8150 V2 PM8150 Google Inc. MSM sm8150 Flame DVT (DT)
> > > > >   Workqueue: hci0 hci_rx_work
> > > > >   Call trace:
> > > > >    dump_backtrace+0x0/0x378
> > > > >    show_stack+0x20/0x2c
> > > > >    dump_stack+0x124/0x148
> > > > >    print_address_description+0x80/0x2e8
> > > > >    __kasan_report+0x168/0x188
> > > > >    kasan_report+0x10/0x18
> > > > >    __asan_load4+0x84/0x8c
> > > > >    refcount_dec_and_test+0x20/0xd0
> > > > >    l2cap_chan_put+0x48/0x12c
> > > > >    l2cap_recv_frame+0x4770/0x6550
> > > > >    l2cap_recv_acldata+0x44c/0x7a4
> > > > >    hci_acldata_packet+0x100/0x188
> > > > >    hci_rx_work+0x178/0x23c
> > > > >    process_one_work+0x35c/0x95c
> > > > >    worker_thread+0x4cc/0x960
> > > > >    kthread+0x1a8/0x1c4
> > > > >    ret_from_fork+0x10/0x18
> > > > >
> > > > > Cc: stable@kernel.org
> > > >
> > > > When was the bug added ? (Fixes: tag please)
> > > >
> > > > > Cc: Marcel Holtmann <marcel@holtmann.org>
> > > > > Cc: Johan Hedberg <johan.hedberg@gmail.com>
> > > > > Cc: Luiz Augusto von Dentz <luiz.dentz@gmail.com>
> > > > > Cc: "David S. Miller" <davem@davemloft.net>
> > > > > Cc: Eric Dumazet <edumazet@google.com>
> > > > > Cc: Jakub Kicinski <kuba@kernel.org>
> > > > > Cc: Paolo Abeni <pabeni@redhat.com>
> > > > > Cc: linux-bluetooth@vger.kernel.org
> > > > > Cc: netdev@vger.kernel.org
> > > > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > > > > ---
> > > > >  net/bluetooth/l2cap_core.c | 4 ++--
> > > > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > > >
> > > > > diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
> > > > > index ae78490ecd3d4..82279c5919fd8 100644
> > > > > --- a/net/bluetooth/l2cap_core.c
> > > > > +++ b/net/bluetooth/l2cap_core.c
> > > > > @@ -483,9 +483,7 @@ static void l2cap_chan_destroy(struct kref *kref)
> > > > >
> > > > >         BT_DBG("chan %p", chan);
> > > > >
> > > > > -       write_lock(&chan_list_lock);
> > > > >         list_del(&chan->global_l);
> > > > > -       write_unlock(&chan_list_lock);
> > > > >
> > > > >         kfree(chan);
> > > > >  }
> > > > > @@ -501,7 +499,9 @@ void l2cap_chan_put(struct l2cap_chan *c)
> > > > >  {
> > > > >         BT_DBG("chan %p orig refcnt %u", c, kref_read(&c->kref));
> > > > >
> > > > > +       write_lock(&chan_list_lock);
> > > > >         kref_put(&c->kref, l2cap_chan_destroy);
> > > > > +       write_unlock(&chan_list_lock);
> > > > >  }
> > > > >  EXPORT_SYMBOL_GPL(l2cap_chan_put);
> > > > >
> > > > >
> > > >
> > > > I do not think this patch is correct.
> > > >
> > > > a kref does not need to be protected by a write lock.
> > > >
> > > > This might shuffle things enough to work around a particular repro you have.
> > > >
> > > > If the patch was correct why not protect kref_get() sides ?
> > > >
> > > > Before the &hdev->rx_work is scheduled (queue_work(hdev->workqueue,
> > > > &hdev->rx_work),
> > > > a reference must be taken.
> > > >
> > > > Then this reference must be released at the end of hci_rx_work() or
> > > > when hdev->workqueue
> > > > is canceled.
> > > >
> > > > This refcount is not needed _if_ the workqueue is properly canceled at
> > > > device dismantle,
> > > > in a synchronous way.
> > > >
> > > > I do not see this hdev->rx_work being canceled, maybe this is the real issue.
> > > >
> > > > There is a call to drain_workqueue() but this is not enough I think,
> > > > because hci_recv_frame()
> > > > can re-arm
> > > >    queue_work(hdev->workqueue, &hdev->rx_work);
> > >
> > > I suspect this likely a refcount problem, we do l2cap_get_chan_by_scid:
> > >
> > > /* Find channel with given SCID.
> > >  * Returns locked channel. */
> > > static struct l2cap_chan *l2cap_get_chan_by_scid(struct l2cap_conn
> > > *conn, u16 cid)
> > >
> > > So we return a locked channel but that doesn't prevent another thread
> > > to call l2cap_chan_put which doesn't care about l2cap_chan_lock so
> > > perhaps we actually need to host a reference while we have the lock,
> > > at least we do something like that on l2cap_sock.c:
> > >
> > > l2cap_chan_hold(chan);
> > > l2cap_chan_lock(chan);
> > >
> > > __clear_chan_timer(chan);
> > > l2cap_chan_close(chan, ECONNRESET);
> > > l2cap_sock_kill(sk);
> > >
> > > l2cap_chan_unlock(chan);
> > > l2cap_chan_put(chan);
> >
> > Perhaps something like this:
>
> I'm struggling to apply this for test:
>
>   "error: corrupt patch at line 6"

Check with the attached patch.


-- 
Luiz Augusto von Dentz

--0000000000003610eb05e3121524
Content-Type: text/x-patch; charset="US-ASCII"; name="0001-Bluetooth-L2CAP-WIP.patch"
Content-Disposition: attachment; filename="0001-Bluetooth-L2CAP-WIP.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_l58ftrys0>
X-Attachment-Id: f_l58ftrys0

RnJvbSA4OGNmNmI0ZjJiMGM5ZWQwYmQ3ZWYzYjBkMzg1NzRiNDEyMjY0NjA5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBMdWl6IEF1Z3VzdG8gdm9uIERlbnR6IDxsdWl6LnZvbi5kZW50
ekBpbnRlbC5jb20+CkRhdGU6IFR1ZSwgMjggSnVuIDIwMjIgMTU6NDY6MDQgLTA3MDAKU3ViamVj
dDogW1BBVENIXSBCbHVldG9vdGg6IEwyQ0FQOiBXSVAKClNpZ25lZC1vZmYtYnk6IEx1aXogQXVn
dXN0byB2b24gRGVudHogPGx1aXoudm9uLmRlbnR6QGludGVsLmNvbT4KLS0tCiBuZXQvYmx1ZXRv
b3RoL2wyY2FwX2NvcmUuYyB8IDI1ICsrKysrKysrKysrKysrKysrKystLS0tLS0KIDEgZmlsZSBj
aGFuZ2VkLCAxOSBpbnNlcnRpb25zKCspLCA2IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL25l
dC9ibHVldG9vdGgvbDJjYXBfY29yZS5jIGIvbmV0L2JsdWV0b290aC9sMmNhcF9jb3JlLmMKaW5k
ZXggMDllY2FmNTU2ZGU1Li4zNTlmYjFjZTQzNzIgMTAwNjQ0Ci0tLSBhL25ldC9ibHVldG9vdGgv
bDJjYXBfY29yZS5jCisrKyBiL25ldC9ibHVldG9vdGgvbDJjYXBfY29yZS5jCkBAIC0xMTEsNyAr
MTExLDggQEAgc3RhdGljIHN0cnVjdCBsMmNhcF9jaGFuICpfX2wyY2FwX2dldF9jaGFuX2J5X3Nj
aWQoc3RydWN0IGwyY2FwX2Nvbm4gKmNvbm4sCiB9CiAKIC8qIEZpbmQgY2hhbm5lbCB3aXRoIGdp
dmVuIFNDSUQuCi0gKiBSZXR1cm5zIGxvY2tlZCBjaGFubmVsLiAqLworICogUmV0dXJucyBhIHJl
ZmVyZW5jZSBsb2NrZWQgY2hhbm5lbC4KKyAqLwogc3RhdGljIHN0cnVjdCBsMmNhcF9jaGFuICps
MmNhcF9nZXRfY2hhbl9ieV9zY2lkKHN0cnVjdCBsMmNhcF9jb25uICpjb25uLAogCQkJCQkJIHUx
NiBjaWQpCiB7CkBAIC0xMTksMTUgKzEyMCwxNyBAQCBzdGF0aWMgc3RydWN0IGwyY2FwX2NoYW4g
KmwyY2FwX2dldF9jaGFuX2J5X3NjaWQoc3RydWN0IGwyY2FwX2Nvbm4gKmNvbm4sCiAKIAltdXRl
eF9sb2NrKCZjb25uLT5jaGFuX2xvY2spOwogCWMgPSBfX2wyY2FwX2dldF9jaGFuX2J5X3NjaWQo
Y29ubiwgY2lkKTsKLQlpZiAoYykKKwlpZiAoYykgeworCQlsMmNhcF9jaGFuX2hvbGQoYyk7CiAJ
CWwyY2FwX2NoYW5fbG9jayhjKTsKKwl9CiAJbXV0ZXhfdW5sb2NrKCZjb25uLT5jaGFuX2xvY2sp
OwogCiAJcmV0dXJuIGM7CiB9CiAKIC8qIEZpbmQgY2hhbm5lbCB3aXRoIGdpdmVuIERDSUQuCi0g
KiBSZXR1cm5zIGxvY2tlZCBjaGFubmVsLgorICogUmV0dXJucyBhIHJlZmVyZW5jZSBsb2NrZWQg
Y2hhbm5lbC4KICAqLwogc3RhdGljIHN0cnVjdCBsMmNhcF9jaGFuICpsMmNhcF9nZXRfY2hhbl9i
eV9kY2lkKHN0cnVjdCBsMmNhcF9jb25uICpjb25uLAogCQkJCQkJIHUxNiBjaWQpCkBAIC0xMzYs
OCArMTM5LDEwIEBAIHN0YXRpYyBzdHJ1Y3QgbDJjYXBfY2hhbiAqbDJjYXBfZ2V0X2NoYW5fYnlf
ZGNpZChzdHJ1Y3QgbDJjYXBfY29ubiAqY29ubiwKIAogCW11dGV4X2xvY2soJmNvbm4tPmNoYW5f
bG9jayk7CiAJYyA9IF9fbDJjYXBfZ2V0X2NoYW5fYnlfZGNpZChjb25uLCBjaWQpOwotCWlmIChj
KQorCWlmIChjKSB7CisJCWwyY2FwX2NoYW5faG9sZChjKTsKIAkJbDJjYXBfY2hhbl9sb2NrKGMp
OworCX0KIAltdXRleF91bmxvY2soJmNvbm4tPmNoYW5fbG9jayk7CiAKIAlyZXR1cm4gYzsKQEAg
LTQ0NjQsNiArNDQ2OSw3IEBAIHN0YXRpYyBpbmxpbmUgaW50IGwyY2FwX2NvbmZpZ19yZXEoc3Ry
dWN0IGwyY2FwX2Nvbm4gKmNvbm4sCiAKIHVubG9jazoKIAlsMmNhcF9jaGFuX3VubG9jayhjaGFu
KTsKKwlsMmNhcF9jaGFuX3B1dChjaGFuKTsKIAlyZXR1cm4gZXJyOwogfQogCkBAIC00NTc4LDYg
KzQ1ODQsNyBAQCBzdGF0aWMgaW5saW5lIGludCBsMmNhcF9jb25maWdfcnNwKHN0cnVjdCBsMmNh
cF9jb25uICpjb25uLAogCiBkb25lOgogCWwyY2FwX2NoYW5fdW5sb2NrKGNoYW4pOworCWwyY2Fw
X2NoYW5fcHV0KGNoYW4pOwogCXJldHVybiBlcnI7CiB9CiAKQEAgLTUzMDUsNiArNTMxMiw3IEBA
IHN0YXRpYyBpbmxpbmUgaW50IGwyY2FwX21vdmVfY2hhbm5lbF9yZXEoc3RydWN0IGwyY2FwX2Nv
bm4gKmNvbm4sCiAJbDJjYXBfc2VuZF9tb3ZlX2NoYW5fcnNwKGNoYW4sIHJlc3VsdCk7CiAKIAls
MmNhcF9jaGFuX3VubG9jayhjaGFuKTsKKwlsMmNhcF9jaGFuX3B1dChjaGFuKTsKIAogCXJldHVy
biAwOwogfQpAQCAtNTM5Nyw2ICs1NDA1LDcgQEAgc3RhdGljIHZvaWQgbDJjYXBfbW92ZV9jb250
aW51ZShzdHJ1Y3QgbDJjYXBfY29ubiAqY29ubiwgdTE2IGljaWQsIHUxNiByZXN1bHQpCiAJfQog
CiAJbDJjYXBfY2hhbl91bmxvY2soY2hhbik7CisJbDJjYXBfY2hhbl9wdXQoY2hhbik7CiB9CiAK
IHN0YXRpYyB2b2lkIGwyY2FwX21vdmVfZmFpbChzdHJ1Y3QgbDJjYXBfY29ubiAqY29ubiwgdTgg
aWRlbnQsIHUxNiBpY2lkLApAQCAtNTQ4OSw2ICs1NDk4LDcgQEAgc3RhdGljIGludCBsMmNhcF9t
b3ZlX2NoYW5uZWxfY29uZmlybShzdHJ1Y3QgbDJjYXBfY29ubiAqY29ubiwKIAlsMmNhcF9zZW5k
X21vdmVfY2hhbl9jZm1fcnNwKGNvbm4sIGNtZC0+aWRlbnQsIGljaWQpOwogCiAJbDJjYXBfY2hh
bl91bmxvY2soY2hhbik7CisJbDJjYXBfY2hhbl9wdXQoY2hhbik7CiAKIAlyZXR1cm4gMDsKIH0K
QEAgLTU1MjQsNiArNTUzNCw3IEBAIHN0YXRpYyBpbmxpbmUgaW50IGwyY2FwX21vdmVfY2hhbm5l
bF9jb25maXJtX3JzcChzdHJ1Y3QgbDJjYXBfY29ubiAqY29ubiwKIAl9CiAKIAlsMmNhcF9jaGFu
X3VubG9jayhjaGFuKTsKKwlsMmNhcF9jaGFuX3B1dChjaGFuKTsKIAogCXJldHVybiAwOwogfQpA
QCAtNTg5NiwxMiArNTkwNywxMSBAQCBzdGF0aWMgaW5saW5lIGludCBsMmNhcF9sZV9jcmVkaXRz
KHN0cnVjdCBsMmNhcF9jb25uICpjb25uLAogCWlmIChjcmVkaXRzID4gbWF4X2NyZWRpdHMpIHsK
IAkJQlRfRVJSKCJMRSBjcmVkaXRzIG92ZXJmbG93Iik7CiAJCWwyY2FwX3NlbmRfZGlzY29ubl9y
ZXEoY2hhbiwgRUNPTk5SRVNFVCk7Ci0JCWwyY2FwX2NoYW5fdW5sb2NrKGNoYW4pOwogCiAJCS8q
IFJldHVybiAwIHNvIHRoYXQgd2UgZG9uJ3QgdHJpZ2dlciBhbiB1bm5lY2Vzc2FyeQogCQkgKiBj
b21tYW5kIHJlamVjdCBwYWNrZXQuCiAJCSAqLwotCQlyZXR1cm4gMDsKKwkJZ290byB1bmxvY2s7
CiAJfQogCiAJY2hhbi0+dHhfY3JlZGl0cyArPSBjcmVkaXRzOwpAQCAtNTkxMiw3ICs1OTIyLDkg
QEAgc3RhdGljIGlubGluZSBpbnQgbDJjYXBfbGVfY3JlZGl0cyhzdHJ1Y3QgbDJjYXBfY29ubiAq
Y29ubiwKIAlpZiAoY2hhbi0+dHhfY3JlZGl0cykKIAkJY2hhbi0+b3BzLT5yZXN1bWUoY2hhbik7
CiAKK3VubG9jazoKIAlsMmNhcF9jaGFuX3VubG9jayhjaGFuKTsKKwlsMmNhcF9jaGFuX3B1dChj
aGFuKTsKIAogCXJldHVybiAwOwogfQpAQCAtNzU5OCw2ICs3NjEwLDcgQEAgc3RhdGljIHZvaWQg
bDJjYXBfZGF0YV9jaGFubmVsKHN0cnVjdCBsMmNhcF9jb25uICpjb25uLCB1MTYgY2lkLAogCiBk
b25lOgogCWwyY2FwX2NoYW5fdW5sb2NrKGNoYW4pOworCWwyY2FwX2NoYW5fcHV0KGNoYW4pOwog
fQogCiBzdGF0aWMgdm9pZCBsMmNhcF9jb25sZXNzX2NoYW5uZWwoc3RydWN0IGwyY2FwX2Nvbm4g
KmNvbm4sIF9fbGUxNiBwc20sCi0tIAoyLjM1LjMKCg==
--0000000000003610eb05e3121524--
