Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDDD4122528
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 08:08:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727354AbfLQHIJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 02:08:09 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:38490 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726704AbfLQHII (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 02:08:08 -0500
Received: by mail-lj1-f195.google.com with SMTP id k8so9668832ljh.5
        for <netdev@vger.kernel.org>; Mon, 16 Dec 2019 23:08:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=unikie-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-transfer-encoding;
        bh=Jtrsu4vY+WoqgI4DuJwnGKgjwAzrNBsJxrq1YyKOiys=;
        b=w6K7EFD32PFprkiXGjr+uh3P4HwhYUxpprXArHX6Z1hwNimWYv8mT9vCGf/ku5L7tA
         uXptZ1falDY/HQQIpq7ta/rd5Us/yKJYofbI0BxOsqNklHZHqhpPqNivt8dxvCvt2yjo
         EX3DewCD1JevZx+cwWc+sDDhyNpbt17fDumUfg9XlkmMAPGdYBO/91UKJSRWUR9aSSk6
         3Ep8AlLMALaTpDYAFQE43yYc9fN7NXP1L5Uenr17qy29FrRDaktIhkcC5BTBxFM7pvrP
         racXfga8SRx8whLF9UZ1iLLoqY/tzaslWL4WfA92cV2byQg06tFJk/k5b5hHMJcN6n5Z
         WCgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:references:date:in-reply-to
         :message-id:user-agent:mime-version:content-transfer-encoding;
        bh=Jtrsu4vY+WoqgI4DuJwnGKgjwAzrNBsJxrq1YyKOiys=;
        b=QHLi7N/6+GLapUOWP2JEdxFaI2Z9Neqzk+AxizChI/mAFT7x6+HxZj5/ZtC6YJVOnZ
         RF8H47nryd2p3/nn8DbC2cd+7UJSAlmDglDgp+fWVrtd3k20sweG1rASkCY4Epg+juMW
         YQZij21dTUvXotLlGh/e0wyKdSdabrrrH53ai/9nV3VZOoMesOD0aqH2OmppJUusx6L6
         gz4MSzBTPhnIuipkkX7/l8e4WJyyX3lORfDPSWU8wHpC7xehR129VYRtmMnkWskMrh3J
         KYqaFH7ML6BtJshbxz0sArUC0Io+guPocNg4TY7sAUkiCpX7x/AAGziUXy0wWwiyK9z2
         cO3g==
X-Gm-Message-State: APjAAAVsPRcMt/K8zRULilFZZzDC006GNzkmoqwHt8w6t3wJ3R4a6six
        O+StakpjoMy1CcXCC7FBxOdYfQ==
X-Google-Smtp-Source: APXvYqwJSoURLhxqyPdFcLfz1UBq+W03d6+2qSB7DgG21qQ9u2Z12wAKUcUfHMrV1531cqrpVpa4YQ==
X-Received: by 2002:a2e:97cf:: with SMTP id m15mr2127081ljj.130.1576566485787;
        Mon, 16 Dec 2019 23:08:05 -0800 (PST)
Received: from GL-434 ([109.204.235.119])
        by smtp.gmail.com with ESMTPSA id k12sm5122459lfc.33.2019.12.16.23.08.04
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 16 Dec 2019 23:08:05 -0800 (PST)
From:   jouni.hogander@unikie.com (Jouni =?utf-8?Q?H=C3=B6gander?=)
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
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
        <87y2vrgkij.fsf@unikie.com>
        <c03d8353-ae34-2f84-68d3-0153873ffc3e@i-love.sakura.ne.jp>
        <9c563a2d-4805-dbd3-08c6-4c541ec30a60@i-love.sakura.ne.jp>
Date:   Tue, 17 Dec 2019 09:08:03 +0200
In-Reply-To: <9c563a2d-4805-dbd3-08c6-4c541ec30a60@i-love.sakura.ne.jp>
        (Tetsuo Handa's message of "Mon, 16 Dec 2019 20:12:19 +0900")
Message-ID: <875zifh1kc.fsf@unikie.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/25.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp> writes:

> Hello, again.
>
> On 2019/12/05 20:00, Tetsuo Handa wrote:
>> On 2019/12/05 19:00, Jouni H=C3=B6gander wrote:
>>>> diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
>>>> index ae3bcb1540ec..562d06c274aa 100644
>>>> --- a/net/core/net-sysfs.c
>>>> +++ b/net/core/net-sysfs.c
>>>> @@ -1459,14 +1459,14 @@ static int netdev_queue_add_kobject(struct net=
_device *dev, int index)
>>>>  	struct kobject *kobj =3D &queue->kobj;
>>>>  	int error =3D 0;
>>>>=20=20
>>>> +	dev_hold(queue->dev);
>>>> +
>>>>  	kobj->kset =3D dev->queues_kset;
>>>>  	error =3D kobject_init_and_add(kobj, &netdev_queue_ktype, NULL,
>>>>  				     "tx-%u", index);
>>>>  	if (error)
>>>>  		goto err;
>>>>=20=20
>>>> -	dev_hold(queue->dev);
>>>> -
>>>>  #ifdef CONFIG_BQL
>>>>  	error =3D sysfs_create_group(kobj, &dql_group);
>>>>  	if (error)
>>>
>>> Now after reproducing the issue I think this is actually proper fix for
>>> the issue.  It's not related to missing error handling in in
>>> tun_set_real_num_queues as I commented earlier. Can you prepare patch
>>> for this?
>>=20
>> You can write the patch; I don't know about commit a3e23f719f5c4a38
>> ("net-sysfs: call dev_hold if kobject_init_and_add success").
>>=20
>> I was wondering how can the caller tell whether to drop the refcount, for
>> the caller won't be able to know which one (kobject_init_and_add() or
>> sysfs_create_group()) returned an error. Therefore, always taking the
>> refcount seems to be a proper fix...
>>=20
>
> sysbot is still reporting this problem.
>
> [  878.476981][T12832] FAULT_INJECTION: forcing a failure.
> [  878.476981][T12832] name failslab, interval 1, probability 0, space 0,=
 times 0
> [  878.490068][T12832] CPU: 1 PID: 12832 Comm: syz-executor.3 Not tainted=
 5.5.0-rc1-syzkaller #0
> [  878.498850][T12832] Hardware name: Google Google Compute Engine/Google=
 Compute Engine, BIOS Google 01/01/2011
> [  878.508957][T12832] Call Trace:
> [  878.512243][T12832]  dump_stack+0x197/0x210
> [  878.516570][T12832]  should_fail.cold+0xa/0x15
> [  878.531871][T12832]  __should_failslab+0x121/0x190
> [  878.536792][T12832]  should_failslab+0x9/0x14
> [  878.541474][T12832]  __kmalloc_track_caller+0x2dc/0x760
> [  878.561156][T12832]  kvasprintf+0xc8/0x170
> [  878.588298][T12832]  kvasprintf_const+0x65/0x190
> [  878.593044][T12832]  kobject_set_name_vargs+0x5b/0x150
> [  878.598309][T12832]  kobject_init_and_add+0xc9/0x160
> [  878.620657][T12832]  net_rx_queue_update_kobjects+0x1d3/0x460
> [  878.626547][T12832]  netif_set_real_num_rx_queues+0x16e/0x210
> [  878.632424][T12832]  tun_attach+0x5a1/0x1530
> [  878.641587][T12832]  __tun_chr_ioctl+0x1ef0/0x3fa0
> [  878.667270][T12832]  tun_chr_ioctl+0x2b/0x40
> [  878.671678][T12832]  do_vfs_ioctl+0x977/0x14e0
> [  878.717612][T12832]  ksys_ioctl+0xab/0xd0
> [  878.721752][T12832]  __x64_sys_ioctl+0x73/0xb0
> [  878.726336][T12832]  do_syscall_64+0xfa/0x790
> [  878.730834][T12832]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> [  878.736703][T12832] RIP: 0033:0x45a909
> [  878.740585][T12832] Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00=
 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08=
 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
> [  878.760179][T12832] RSP: 002b:00007fb6b281cc78 EFLAGS: 00000246 ORIG_R=
AX: 0000000000000010
> [  878.768587][T12832] RAX: ffffffffffffffda RBX: 00007fb6b281cc90 RCX: 0=
00000000045a909
> [  878.776543][T12832] RDX: 0000000020000040 RSI: 00000000400454ca RDI: 0=
000000000000004
> [  878.784503][T12832] RBP: 000000000075bf20 R08: 0000000000000000 R09: 0=
000000000000000
> [  878.792466][T12832] R10: 0000000000000000 R11: 0000000000000246 R12: 0=
0007fb6b281d6d4
> [  878.800420][T12832] R13: 00000000004c5fdc R14: 00000000004dc3b0 R15: 0=
000000000000005
> [  878.810319][T12832] kobject: can not set name properly!
> [  888.898307][T12830] unregister_netdevice: waiting for nr0 to become fr=
ee. Usage count =3D -1
>
> I think that the same problem exists in rx_queue_add_kobject().

Yes, missed that one. Sending patch soon. Thank you for pointing it out.

BR,

Jouni H=C3=B6gander
