Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BB19593369
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 18:45:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230517AbiHOQpI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 12:45:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiHOQpH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 12:45:07 -0400
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AE1B1658C;
        Mon, 15 Aug 2022 09:45:06 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 6A00A5C016C;
        Mon, 15 Aug 2022 12:45:05 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Mon, 15 Aug 2022 12:45:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
        cc:cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1660581905; x=1660668305; bh=0KCTs7QdX7
        QGBwK4s6VHupH8gpM1j2gtUP38/RuMSu8=; b=wxnOoOobFH7/VZq4GuA8ZYfkL/
        Lhre764xAmEugXFpsY42iirKKEIjXz7lH3Iuh+EYyJ4XVzxU+Ct/Haoz7UemohyI
        e75HzvhPrm+CKQcEmyVGgyYqhyK+D1rb5YH6+1ED0uZvnr3nIauntl0n9p1FNvSk
        a64uGShRVSzPoJHH8kM3XfcX3fW48kxDevFjbleH7c3iw0rAnkB2FoSSbxyCmMnw
        WLPR+RUjuMPwXOZW6QybbOvwPriIKgAvc/wP5p17DHdfhip6VICiYG/zpxzICJJh
        tSQB5gsS8gNlF2Y0wNij4FN/2Se3Iz3pNSRe9s643ISf6HRIRtACUAYqI0dA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1660581905; x=1660668305; bh=0KCTs7QdX7QGBwK4s6VHupH8gpM1
        j2gtUP38/RuMSu8=; b=2Pe5D+cvWI/5abiszZxAanXo30fXTV5miwX7fTY0gxdj
        u04M+HHRlMD7vGOhgeQMdQgVnHsw1e+j8xT3pI2kt9q26UqJGex081H6wjF3v5IP
        /sJCdfrf9mnUBL7SDVrjGGaQWmieG0s3irQ8/ZP6hW/UNb49RhYBa88X6yP9dAHi
        3xYpJyvGsZT7jUm6r1/0QEKRe57yP2q7vg/RBNtPHwbC1DGX3vZTCW65f1xcVEX5
        csW+nypoir5xtQXPxQE8WDQGizMCasdkmm+lA6jmYgjmsFK4jd8DK+qqsNxpu00b
        2+qcbmWFf7/y37YH6WGMnszN+YN6dcjdA7m9aDBl9w==
X-ME-Sender: <xms:EHj6YvJ0aNstevVxaz6EUaR_hX6gTW4mw5eCnKQnWMTbPZeoke9dyw>
    <xme:EHj6YjJTmTfjLJ6LH22E6unR-OOUgjOd3BechEgmVZ5YVUqoC5jw3NSK2UEZhHWkt
    MPsVMd2Nr4NuCJSZQ>
X-ME-Received: <xmr:EHj6Ynuwf3J6q3udhvFF8Q6oJF4oXre9oOwTj_0krKwypmTcHbEsBqyDug4B_PizuG3XKJXBbuAjOMSFu5HlVqzgfCJ9Buew4U1YOvPNlXvZ0ef8ddM25XOffW5Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdehvddguddtiecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeetnhgu
    rhgvshcuhfhrvghunhguuceorghnughrvghssegrnhgrrhgriigvlhdruggvqeenucggtf
    frrghtthgvrhhnpedvffefvefhteevffegieetfefhtddvffejvefhueetgeeludehteev
    udeitedtudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpegrnhgurhgvshesrghnrghrrgiivghlrdguvg
X-ME-Proxy: <xmx:EHj6YoYSNBmocmnHo5iVmuvrrMs5oPmp32HkJwVdRiM11gYUpI2Taw>
    <xmx:EHj6YmYLnAefTEEQEhppnEO4x5xeBtFNKvNqnvcrO2IZKMsbb4r8tg>
    <xmx:EHj6YsAaneYj-3JQJZI6s_bfPot3P3gWOy_cCkPzO1X-Pd2ifLsP0Q>
    <xmx:EXj6YrKpUmrwZ3BImSrl4ZeMawTCcGhodF4vRxSkux7WnF1ONB4IZg>
Feedback-ID: id4a34324:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 15 Aug 2022 12:45:04 -0400 (EDT)
Date:   Mon, 15 Aug 2022 09:45:03 -0700
From:   Andres Freund <andres@anarazel.de>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Guenter Roeck <linux@roeck-us.net>,
        linux-kernel@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>,
        c@redhat.com
Subject: Re: upstream kernel crashes
Message-ID: <20220815164503.jsoezxcm6q4u2b6j@awork3.anarazel.de>
References: <CAHk-=wi6raoJE-1cyRU0YxJ+9ReO1eXmOAq0FwKAyZS7nhvk9w@mail.gmail.com>
 <1c057afa-92df-ee3c-5978-3731d3db9345@kernel.dk>
 <20220815013651.mrm7qgklk6sgpkbb@awork3.anarazel.de>
 <CAHk-=wikzU4402P-FpJRK_QwfVOS+t-3p1Wx5awGHTvr-s_0Ew@mail.gmail.com>
 <20220815071143.n2t5xsmifnigttq2@awork3.anarazel.de>
 <20220815034532-mutt-send-email-mst@kernel.org>
 <20220815081527.soikyi365azh5qpu@awork3.anarazel.de>
 <20220815042623-mutt-send-email-mst@kernel.org>
 <FCDC5DDE-3CDD-4B8A-916F-CA7D87B547CE@anarazel.de>
 <20220815113729-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220815113729-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 2022-08-15 11:40:59 -0400, Michael S. Tsirkin wrote:
> OK so this gives us a quick revert as a solution for now.
> Next, I would appreciate it if you just try this simple hack.
> If it crashes we either have a long standing problem in virtio
> code or more likely a gcp bug where it can't handle smaller
> rings than what device requestes.
> Thanks!

I applied the below and the problem persists.

> diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
> index f7965c5dd36b..bdd5f481570b 100644
> --- a/drivers/virtio/virtio_pci_modern.c
> +++ b/drivers/virtio/virtio_pci_modern.c
> @@ -314,6 +314,9 @@ static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
>  	if (!size || size > num)
>  		size = num;
>  
> +	if (size > 1024)
> +		size = 1024;
> +
>  	if (size & (size - 1)) {
>  		dev_warn(&vp_dev->pci_dev->dev, "bad queue size %u", size);
>  		return ERR_PTR(-EINVAL);
> 
> 

[    1.165162] virtio_net virtio1 enp0s4: renamed from eth0
[    1.177815] general protection fault, probably for non-canonical address 0xffff000000000400: 0000 [#1] PREEMPT SMP PTI
[    1.179565] CPU: 1 PID: 125 Comm: systemd-udevd Not tainted 6.0.0-rc1-bisect14-dirty #14
[    1.180785] Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/29/2022
[    1.182475] RIP: 0010:__kmalloc_node_track_caller+0x19e/0x380
[    1.183365] Code: 2b 04 25 28 00 00 00 0f 85 f8 01 00 00 48 83 c4 18 48 89 e8 5b 5d 41 5c 41 5d 41 5e 41 5f c3 cc cc cc cc 8b 4d 28 48 8b 7d 00 <48> 8b 1c 08 48 8d 4a 40 65 48 0f c7 0f 0f 94 c0 84 c0 0f 84 0b ff
[    1.186208] RSP: 0018:ffff9c470021b860 EFLAGS: 00010246
[    1.187194] RAX: ffff000000000000 RBX: 00000000000928c0 RCX: 0000000000000400
[    1.188634] RDX: 0000000000005781 RSI: 00000000000928c0 RDI: 000000000002e0f0
[    1.190177] RBP: ffff908380042c00 R08: 0000000000000600 R09: ffff908380b665e4
[    1.191256] R10: 0000000000000003 R11: 0000000000000002 R12: 00000000000928c0
[    1.192269] R13: 0000000000000740 R14: 00000000ffffffff R15: 0000000000000000
[    1.193368] FS:  00007f746702a8c0(0000) GS:ffff9084b7d00000(0000) knlGS:0000000000000000
[    1.194846] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    1.195661] CR2: 00007ffc010df980 CR3: 0000000103826005 CR4: 00000000003706e0
[    1.196912] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    1.198216] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[    1.199367] Call Trace:
[    1.199815]  <TASK>
[    1.200138]  ? netlink_trim+0x85/0xb0
[    1.200754]  pskb_expand_head+0x92/0x340
[    1.202512]  netlink_trim+0x85/0xb0
[    1.203069]  netlink_unicast+0x54/0x390
[    1.203630]  rtnl_getlink+0x366/0x410
[    1.204155]  ? __d_alloc+0x24/0x1d0
[    1.204668]  rtnetlink_rcv_msg+0x146/0x3b0
[    1.205256]  ? _raw_spin_unlock+0xd/0x30
[    1.205867]  ? __d_add+0xf2/0x1b0
[    1.206600]  ? rtnl_calcit.isra.0+0x130/0x130
[    1.207221]  netlink_rcv_skb+0x49/0xf0
[    1.207904]  netlink_unicast+0x23a/0x390
[    1.208585]  netlink_sendmsg+0x23b/0x4b0
[    1.209203]  sock_sendmsg+0x57/0x60
[    1.210118]  __sys_sendto+0x117/0x170
[    1.210694]  ? __wake_up_common_lock+0x83/0xc0
[    1.211420]  __x64_sys_sendto+0x1b/0x30
[    1.211992]  do_syscall_64+0x37/0x90
[    1.212497]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
[    1.213407] RIP: 0033:0x7f74677404e6
[    1.213973] Code: 69 0e 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b8 0f 1f 00 41 89 ca 64 8b 04 25 18 00 00 00 85 c0 75 11 b8 2c 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 72 c3 90 41 54 48 83 ec 30 44 89 4c 24 2c 4c
[    1.217098] RSP: 002b:00007ffc010daa78 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[    1.219539] RAX: ffffffffffffffda RBX: 000000000011bc98 RCX: 00007f74677404e6
[    1.220552] RDX: 0000000000000020 RSI: 0000563160679570 RDI: 0000000000000005
[    1.222378] RBP: 00005631606796b0 R08: 00007ffc010daaf0 R09: 0000000000000080
[    1.223692] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
[    1.224793] R13: 0000000000000000 R14: 0000000000000000 R15: 00005631606794b0
[    1.226228]  </TASK>
[    1.226775] Modules linked in:
[    1.227414] ---[ end trace 0000000000000000 ]---

Greetings,

Andres Freund
