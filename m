Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3BF06194D4
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 11:51:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231835AbiKDKv3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 06:51:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231834AbiKDKvR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 06:51:17 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ABDE2C13A;
        Fri,  4 Nov 2022 03:51:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 70951CE2B93;
        Fri,  4 Nov 2022 10:51:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E27D3C4347C;
        Fri,  4 Nov 2022 10:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667559067;
        bh=4Bt3wT7yXYgAiC80JzTz8HYvGVPTyhH/6jt4qkLU5C4=;
        h=In-Reply-To:References:Date:From:To:Cc:Subject:From;
        b=TBGLLB0Mkp6lWt4L6AVAi9kYEdV6CeTFgjzRq2iTVXD7dhW26SK7IXRBhgk5rQj6R
         zbyHjw41OsJKZcfzvEbvefYl4UK0K1Gu9bqTBGCsel5TK9g1O4rmd3kw9BSd5bgOzW
         nOHffAzUTGF6x7kiCgfMsrH2SaB02Rf48BPLprmaYSOMOCESzFrravtxJAqEJT/t35
         K9p7cifssD/I14P84MDJzHqypnfevL1+nvKZNlGwIDfBLyJujziCkHUvfwtKoI4yX8
         hDVElXeLnK45I90wCtBf+oLvVCocgteXbtw1NKXVvp/hkfCDROsTiqRALESiDR+8qP
         E3QSHeXSsPP8A==
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailauth.nyi.internal (Postfix) with ESMTP id 800A927C0054;
        Fri,  4 Nov 2022 06:51:05 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute3.internal (MEProxy); Fri, 04 Nov 2022 06:51:05 -0400
X-ME-Sender: <xms:mO5kYwEsTyMVN-gDGgC0LOBuklZazLy6D9eMxrm9MfUJOlEo9OzNGw>
    <xme:mO5kY5W-IOHcMNweON5UHHEopi0QBS7OX4oGehMZRwWsMqEhK-TkqNolxuBRPpUqy
    hqhUbkUv49GKBaMlvY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrvddugddulecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvvefutgfgsehtqhertderreejnecuhfhrohhmpedftehr
    nhguuceuvghrghhmrghnnhdfuceorghrnhgusehkvghrnhgvlhdrohhrgheqnecuggftrf
    grthhtvghrnhepgeelhfelvdelheehteffjeehkeduvdeggeekieefleeuteeluddufeek
    gedtuefhnecuffhomhgrihhnpehlfihnrdhnvghtnecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomheprghrnhguodhmvghsmhhtphgruhhthhhpvghr
    shhonhgrlhhithihqdduvdekhedujedtvdegqddvkeejtddtvdeigedqrghrnhgupeepkh
    gvrhhnvghlrdhorhhgsegrrhhnuggsrdguvg
X-ME-Proxy: <xmx:mO5kY6Jb5yTe2noLlLmM4pQ5vL39RyQKj6soIoB-XzfeUcuNtarX3w>
    <xmx:mO5kYyH8EM2NbRWlK376BAUms-nnyvvAB0i0e0c5-TtONxvj9eHfGA>
    <xmx:mO5kY2XEcNvkj4Eb86GyYrYoyoWtX4qzxI8zPSvPzYBl9azGry2P8Q>
    <xmx:me5kY9MG3AvCnTNi3iQvHr73nyaszfQ9KTNBmaVv44MioVb92YhrJQ>
Feedback-ID: i36794607:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id DB4F5B603ED; Fri,  4 Nov 2022 06:51:04 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.7.0-alpha0-1087-g968661d8e1-fm-20221021.001-g968661d8
Mime-Version: 1.0
Message-Id: <ed2d2ea7-4a8c-4616-bca4-c78e6f260ba9@app.fastmail.com>
In-Reply-To: <8bd1dc3b-e1f0-e7f9-bf65-8d243c65adb5@opensynergy.com>
References: <20220825134449.18803-1-harald.mommer@opensynergy.com>
 <CAK8P3a1biW1qygRS8Mf0F5n8e6044+W-5v+Gnv+gh+Cyzj-Vjg@mail.gmail.com>
 <8bd1dc3b-e1f0-e7f9-bf65-8d243c65adb5@opensynergy.com>
Date:   Fri, 04 Nov 2022 11:50:45 +0100
From:   "Arnd Bergmann" <arnd@kernel.org>
To:     "Harald Mommer" <hmo@opensynergy.com>,
        "Harald Mommer" <harald.mommer@opensynergy.com>
Cc:     virtio-dev@lists.oasis-open.org, linux-can@vger.kernel.org,
        Netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org,
        "Wolfgang Grandegger" <wg@grandegger.com>,
        "Marc Kleine-Budde" <mkl@pengutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        "Dariusz Stojaczyk" <Dariusz.Stojaczyk@opensynergy.com>,
        "Stratos Mailing List" <stratos-dev@op-lists.linaro.org>
Subject: Re: [virtio-dev] [RFC PATCH 1/1] can: virtio: Initial virtio CAN driver.
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 3, 2022, at 13:26, Harald Mommer wrote:
> On 25.08.22 20:21, Arnd Bergmann wrote:
>>
...
> The messages are not necessarily processed in sequence by the CAN stac=
k.=20
> CAN is priority based. The lower the CAN ID the higher the priority. S=
o=20
> a message with CAN ID 0x100 can surpass a message with ID 0x123 if the=20
> hardware is not just simple basic CAN controller using a single TX=20
> mailbox with a FIFO queue on top of it.
>
> Thinking about this the code becomes more complex with the array. What=
 I=20
> get from the device when the message has been processed is a pointer t=
o=20
> the processed message by virtqueue_get_buf(). I can then simply do a=20
> list_del(), free the message and done.

Ok

>>> +#ifdef DEBUG
>>> +static void __attribute__((unused))
>>> +virtio_can_hexdump(const void *data, size_t length, size_t base)
>>> +{
>>> +#define VIRTIO_CAN_MAX_BYTES_PER_LINE 16u
>> This seems to duplicate print_hex_dump(), maybe just use that?
> Checked where it's still used. The code is not disabled by #ifdef DEBU=
G=20
> but simply commented out. Under this circumstances it's for now best t=
o=20
> simply remove the code now and also the commented out places where is=20
> was used at some time in the past.

Even better.

>>> +
>>> +       while (!virtqueue_get_buf(vq, &len) && !virtqueue_is_broken(=
vq))
>>> +               cpu_relax();
>>> +
>>> +       mutex_unlock(&priv->ctrl_lock);
>> A busy loop is probably not what you want here. Maybe just
>> wait_for_completion() until the callback happens?
>
> Was done in the same way as elsewhere=20
> (virtio_console.c/__send_control_msg() &=20
> virtio_net.c/virtnet_send_command()). Yes, wait_for_completion() is=20
> better, this avoids polling.

Ok. FWIW, The others seem to do it like this because they
are in non-atomic context where it is not allowed to call
wait_for_completion(), but since you already have the
mutex here, you know that sleeping is permitted.=20

>>> +       /* Push loopback echo. Will be looped back on TX interrupt/T=
X NAPI */
>>> +       can_put_echo_skb(skb, dev, can_tx_msg->putidx, 0);
>>> +
>>> +       err =3D virtqueue_add_sgs(vq, sgs, 1u, 1u, can_tx_msg, GFP_A=
TOMIC);
>>> +       if (err !=3D 0) {
>>> +               list_del(&can_tx_msg->list);
>>> +               virtio_can_free_tx_idx(priv, can_tx_msg->prio,
>>> +                                      can_tx_msg->putidx);
>>> +               netif_stop_queue(dev);
>>> +               spin_unlock_irqrestore(&priv->tx_lock, flags);
>>> +               kfree(can_tx_msg);
>>> +               if (err =3D=3D -ENOSPC)
>>> +                       netdev_info(dev, "TX: Stop queue, no space l=
eft\n");
>>> +               else
>>> +                       netdev_warn(dev, "TX: Stop queue, reason =3D=
 %d\n", err);
>>> +               return NETDEV_TX_BUSY;
>>> +       }
>>> +
>>> +       if (!virtqueue_kick(vq))
>>> +               netdev_err(dev, "%s(): Kick failed\n", __func__);
>>> +
>>> +       spin_unlock_irqrestore(&priv->tx_lock, flags);
>> There should not be a need for a spinlock or disabling interrupts
>> in the xmit function. What exactly are you protecting against here?
>
> I'm using 2 NAPIs, one for TX and one for RX. The RX NAPI just receive=
s=20
> RX messages and is of no interest here. The TX NAPI handles the TX=20
> messages which have been processed by the virtio CAN device in=20
> virtio_can_read_tx_queue(). If this was done without the TX NAPI this=20
> would have been done by the TX interrupt directly, no difference.
>
> In virtio_can_start_xmit()
>
> * Reserve putidx - done by an own mechanism using list operations in=20
> tx_putidx_list
>
> Could be that it's simpler to use idr_alloc() and friends getting thos=
e=20
> numbers to get rid of this own mechanism, not sure yet. But this needs=
 a=20
> locks as it's based on a linked list and the list operation has to be=20
> protected.

Right, makes sense. Lockless transmission should generally work
if your transmission queue is a strictly ordered ring buffer
where you just need to atomically update the index, but you are
right that this doesn't work with a linked list.

This probably directly ties into the specification of your
tx virtqueue: if the device could guarantee that any descriptors
are processed in sequence, you could avoid the spinlock in the
tx path for a small performance optimization, but then you have
to decide on the sequence in the driver already, which impacts
the latency for high-priority frames that get queued to the
device. It's possible that the reordering in the device would
not be as critical if you correctly implement the byte queue
limits.

>>> +       kfree(can_tx_msg);
>>> +
>>> +       /* Flow control */
>>> +       if (netif_queue_stopped(dev)) {
>>> +               netdev_info(dev, "TX ACK: Wake up stopped queue\n");
>>> +               netif_wake_queue(dev);
>>> +       }
>> You may want to add netdev_sent_queue()/netdev_completed_queue()
>> based BQL flow control here as well, so you don't have to rely on the
>> queue filling up completely.
> Not addressed, not yet completely understood.

https://lwn.net/Articles/454390/ is an older article but should still
explain the background. Without byte queue limits, you risk introducing
unbounded TX latency on a congested interface.

Ideally, the host device implementation should only send
back the 'completed' interrupt after a frame has left the
physical hardware. In this case, BQL will manage both the
TX queue in the guest driver and the queue in the host
device to keep the total queue length short enough to
guarantee low latency even for low-priority frames but
long enough to maintain wire-speed throughput.

>>> +
>>> +       register_virtio_can_dev(dev);
>>> +
>>> +       /* Initialize virtqueues */
>>> +       err =3D virtio_can_find_vqs(priv);
>>> +       if (err !=3D 0)
>>> +               goto on_failure;
>> Should the register_virtio_can_dev() be done here? I would expect thi=
s to be
>> the last thing after setting up the queues.
>
> Doing so makes the code somewhat simpler and shorter =3D better.

The problem is that as soon as an interface is registered,
you can have userspace sending data to it. This may be
a short race, but I fear that this would cause data corruption
if data gets queued before the device is fully operational.

>>> +#ifdef CONFIG_PM_SLEEP
>>> +       .freeze =3D       virtio_can_freeze,
>>> +       .restore =3D      virtio_can_restore,
>>> +#endif
>> You can remove the #ifdef here and above, and replace that with the
>> pm_sleep_ptr() macro in the assignment.
>
> This pm_sleep_ptr(_ptr) macro returns either the argument when=20
> CONFIG_PM_SLEEP is defined or NULL. But in struct virtio_driver there =
is
>
> #ifdef CONFIG_PM =C2=A0 int(*freeze) ...; =C2=A0 int(*restore) ...; #e=
ndif
>
> so without CONFIG_PM there are no freeze and restore structure members.
>
> So
>
>  =C2=A0 .freeze =3D pm_sleep_ptr(virtio_can_freeze)
>
> won't work.

I think this is a mistake in the virtio_driver definition,
it would be best to send a small patch that removes this
#ifdef along with your driver.

       Arnd
