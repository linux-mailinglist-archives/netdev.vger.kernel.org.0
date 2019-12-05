Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 147C3113EED
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 11:00:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729247AbfLEKAJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 05:00:09 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:34171 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728629AbfLEKAJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Dec 2019 05:00:09 -0500
Received: by mail-lj1-f194.google.com with SMTP id m6so2863911ljc.1
        for <netdev@vger.kernel.org>; Thu, 05 Dec 2019 02:00:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=unikie-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-transfer-encoding;
        bh=CmLQYer57shUUBOpu/Cd8aIR5RIL9543fihD/YvLsXE=;
        b=iM86cNmC7keSOExpd9IrsKNuFPzBGDGkRHg9At0x8Lrs927cuxIwkxOcjGd0CnoM/D
         z5r5s5SWGsk7yF3bsf5V9hfoh5RDpSKkWYcPg3e3zzXKP7HhymAcXeVYAItQ7IV4YoME
         IPY22akkBZJFht2KUw2TExBOa0YroucwX7WSLSz4UktYJoH12fR9duIguY55evDR1Udx
         W16vXoviQB27t+cbxA9drid0BBTkC4gGoo5xHG84DUPZ/xdIYh+ir3R3OxxV57BnwHD1
         VuGhrL3Qrm559vqA0VoXMTsJxltJOxcVKaS3MoLTf4B2epukdJRAjl+BIJGcVsJpAApV
         88EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:references:date:in-reply-to
         :message-id:user-agent:mime-version:content-transfer-encoding;
        bh=CmLQYer57shUUBOpu/Cd8aIR5RIL9543fihD/YvLsXE=;
        b=rjAcUqCNIJ9j+4Wou4c8CmJxkL0QMCvP0PStgd6tFF43Yk1CCMoA7gUtyrZ9C1PeQy
         D9K1CmO9cQTBFlpuK/wQ9wGFegb10dY1AkplwX0EUKmzRLLLqVkdP2z3hxygmS1Erc7y
         NTWgzr2QjGLeNXDiZIFWiPjk8saoGvykjFlOiD8qtVv3UKd1frlAPqhH7dXIm/2w9Xjl
         1zx32I1LImXa/RskwKOy0awyVICiLYaUew/tUm4xD0gZAZMOjGWDzzP2JmRnOrxb4Cpe
         j//vlQtPq7jxn7SgTooBjqKYbzrBHm4v3BgLxZBalmvFKCUIH2ZCiCobbeLcRT5MrNiZ
         9upw==
X-Gm-Message-State: APjAAAUef6xeRxDt7jHCLLN3co+/BWaWCpqQGM6YuwxtHjxV9LQSHHd6
        7P5w8to1mGSSJ/siz+sHuAVONw==
X-Google-Smtp-Source: APXvYqyUd6Hu34vl80xhCcuVStEXBKoEqU2PZVoi1m8XyMQLuipmj09Hb9bDLlW4CULsjFp7UzhYhQ==
X-Received: by 2002:a2e:b52a:: with SMTP id z10mr4837726ljm.178.1575540006971;
        Thu, 05 Dec 2019 02:00:06 -0800 (PST)
Received: from GL-434 ([109.204.235.119])
        by smtp.gmail.com with ESMTPSA id k5sm389873lfd.86.2019.12.05.02.00.05
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 05 Dec 2019 02:00:06 -0800 (PST)
From:   jouni.hogander@unikie.com (Jouni =?utf-8?Q?H=C3=B6gander?=)
To:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc:     syzbot <syzbot+30209ea299c09d8785c9@syzkaller.appspotmail.com>,
        YueHaibing <yuehaibing@huawei.com>, Julian Anastasov <ja@ssi.bg>,
        ddstreet@ieee.org, dvyukov@google.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, Hulk Robot <hulkci@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: Re: unregister_netdevice: waiting for DEV to become free (2)
References: <0000000000007d22100573d66078@google.com>
        <alpine.LFD.2.20.1808201527230.2758@ja.home.ssi.bg>
        <ace19af4-7cae-babd-bac5-cd3505dcd874@I-love.SAKURA.ne.jp>
Date:   Thu, 05 Dec 2019 12:00:04 +0200
In-Reply-To: <ace19af4-7cae-babd-bac5-cd3505dcd874@I-love.SAKURA.ne.jp>
        (Tetsuo Handa's message of "Thu, 28 Nov 2019 18:56:21 +0900")
Message-ID: <87y2vrgkij.fsf@unikie.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/25.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp> writes:

> [   61.584734] Code: bd b1 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 4=
8 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <=
48> 3d 01 f0 ff ff 0f 83 8b b1 fb ff c3 66 2e 0f 1f 84 00 00 00 00
> [   61.590407] RSP: 002b:00007f25d540ec88 EFLAGS: 00000246 ORIG_RAX: 0000=
000000000010
> [   61.592488] RAX: ffffffffffffffda RBX: 000000000071bf00 RCX: 000000000=
045a729
> [   61.594552] RDX: 0000000020000040 RSI: 00000000400454d9 RDI: 000000000=
0000003
> [   61.596829] RBP: 00007f25d540eca0 R08: 0000000000000000 R09: 000000000=
0000000
> [   61.598540] R10: 0000000000000000 R11: 0000000000000246 R12: 00007f25d=
540f6d4
> [   61.600278] R13: 00000000004ac5a5 R14: 00000000006ee8a0 R15: 000000000=
0000005
> [   61.655323] kobject_add_internal failed for tx-1 (error: -12 parent: q=
ueues)
> [   71.760970] unregister_netdevice: waiting for vet to become free. Usag=
e count =3D -1
> [   82.028434] unregister_netdevice: waiting for vet to become free. Usag=
e count =3D -1
> [   92.140031] unregister_netdevice: waiting for vet to become free. Usag=
e count =3D -1
> ----------
>
> Worrisome part is that tun_attach() calls tun_set_real_num_queues() at th=
e end of tun_attach()
> but tun_set_real_num_queues() is not handling netif_set_real_num_tx_queue=
s() failure.
> That is, tun_attach() is returning success even if netdev_queue_update_ko=
bjects() from
> netif_set_real_num_tx_queues() failed.
>
>   static void tun_set_real_num_queues(struct tun_struct *tun)
>   {
>           netif_set_real_num_tx_queues(tun->dev, tun->numqueues);
>           netif_set_real_num_rx_queues(tun->dev, tun->numqueues);
>   }
>
> And I guess that ignoring that failure causes clean-up function to drop a=
 refcount
> which was not held by initialization function. Applying below diff seems =
to avoid
> this problem. Please check.
>
> ----------
> diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
> index ae3bcb1540ec..562d06c274aa 100644
> --- a/net/core/net-sysfs.c
> +++ b/net/core/net-sysfs.c
> @@ -1459,14 +1459,14 @@ static int netdev_queue_add_kobject(struct net_de=
vice *dev, int index)
>  	struct kobject *kobj =3D &queue->kobj;
>  	int error =3D 0;
>=20=20
> +	dev_hold(queue->dev);
> +
>  	kobj->kset =3D dev->queues_kset;
>  	error =3D kobject_init_and_add(kobj, &netdev_queue_ktype, NULL,
>  				     "tx-%u", index);
>  	if (error)
>  		goto err;
>=20=20
> -	dev_hold(queue->dev);
> -
>  #ifdef CONFIG_BQL
>  	error =3D sysfs_create_group(kobj, &dql_group);
>  	if (error)

Now after reproducing the issue I think this is actually proper fix for
the issue.  It's not related to missing error handling in in
tun_set_real_num_queues as I commented earlier. Can you prepare patch
for this?

BR,

Jouni H=C3=B6gander
