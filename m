Return-Path: <netdev+bounces-4770-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E3A170E296
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 19:07:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 95F2828136B
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 17:07:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CD01206BC;
	Tue, 23 May 2023 17:07:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79AEF4C91
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 17:07:24 +0000 (UTC)
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6943F18B
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 10:07:19 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id 5b1f17b1804b1-3f5dbd8f677so2875e9.1
        for <netdev@vger.kernel.org>; Tue, 23 May 2023 10:07:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684861638; x=1687453638;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GHdfMZv0cy22FLane8ijEboUT+kVjbL/DCDppADKX+k=;
        b=0grIKoLCQ1KOkzxXNQQcTiRdILG1UZHFa44FWGwoPciSkfblNsR9BngCSr/4SsspVN
         Ow5Na28xe6jkBR4eQUWliJUf4ayw2x+wKW4jUydglJ0ybRUK0UVJsOfm8ai0XpG56eaJ
         adC7VuahPtsUuh668ZqeL96i42QjQ5YY8wtlvocUrs2eqAuE5O/ZIXdfJbmXpfyVzXTQ
         REwGx1vCgYxWf8o2Uf+C+eurWXc0401I8BY1u9X9c/SkwcP2NHPhVBnROt11OXWK/RuB
         4VDOfv4Mz82SJLwDg6AfcPDU+u648WMpG9F1z6lnxpd4g8OPmqdMhEAoxvjNJo759r+G
         XPig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684861638; x=1687453638;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GHdfMZv0cy22FLane8ijEboUT+kVjbL/DCDppADKX+k=;
        b=TrWcbLe7FMC09ViZgGGIyk9IvMJuDs6diK/ZSRaqDJNeDHRMmLUyZozFhUDZw6DbHc
         4vsoE6f6Qc02DKfiikCGOrBJI1GOjs8UKwzXJdCPVJAky9JOYmQ2XMzdd51tPQrcX3st
         u681RvhB5Zz1bFkorHsD6fW2oqitrcyruO/lU2mgQxyVCB0wnZ5z8Qy0VleZbHwG6a6T
         6ddHnLup8xoKTS1IlpxzXJ+ELeJY1b2eDBpbDM8s++xDOgPs35xOc19KjhG68CtD2OQP
         z9q1DbIDkrWtKPzyOkUnxKJo8fSPvO0IcCmrNQC6eGuzq9eiR49yJzibpF3d9NxCl4tn
         8M5Q==
X-Gm-Message-State: AC+VfDwFgMOZ3POcWboQkdVJarLfL7qqLldJEO1g0KnLAVyy1wJ25Zby
	4Ki5UBDUczyr/1ImaGCA6IyuBKoiRTl9syMugy4m9g==
X-Google-Smtp-Source: ACHHUZ5Js64aJk0ljsRBYPJmgK9djtmA1ZUniVrphpU59gCR5nDmOPv+1UdBUgInscfNur8wGv5eVd5TyYXEDbVbjeM=
X-Received: by 2002:a05:600c:4309:b0:3f1:9396:6fbf with SMTP id
 p9-20020a05600c430900b003f193966fbfmr2569wme.4.1684861637622; Tue, 23 May
 2023 10:07:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <000000000000c0b11d05fa917fe3@google.com> <ZGzfzEs-vJcZAySI@zx2c4.com>
 <20230523090512.19ca60b6@kernel.org> <CANn89iLVSiO1o1C-P30_3i19Ci8W1jQk9mr-_OMsQ4tS8Nq2dg@mail.gmail.com>
 <20230523094108.0c624d47@kernel.org> <CAHmME9obRJPrjiJE95JZug0r6NUwrwwWib+=LO4jiQf-y2m+Vg@mail.gmail.com>
 <20230523094736.3a9f6f8c@kernel.org> <ZGzxa18w-v8Dsy5D@zx2c4.com> <CANn89iLrP7-NbE1yU_okruVKqbuUc3gxPABq4-vQ4SKrUhEdtA@mail.gmail.com>
In-Reply-To: <CANn89iLrP7-NbE1yU_okruVKqbuUc3gxPABq4-vQ4SKrUhEdtA@mail.gmail.com>
From: Eric Dumazet <edumazet@google.com>
Date: Tue, 23 May 2023 19:07:05 +0200
Message-ID: <CANn89iKEjb-g1ed2M+VS5avSs=M0gNgH9QWXtOQRM_uDTMCwPw@mail.gmail.com>
Subject: Re: [syzbot] [wireguard?] KASAN: slab-use-after-free Write in enqueue_timer
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Jakub Kicinski <kuba@kernel.org>, 
	syzbot <syzbot+c2775460db0e1c70018e@syzkaller.appspotmail.com>, 
	netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com, davem@davemloft.net, 
	linux-kernel@vger.kernel.org, pabeni@redhat.com, wireguard@lists.zx2c4.com, 
	jann@thejh.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 23, 2023 at 7:05=E2=80=AFPM Eric Dumazet <edumazet@google.com> =
wrote:
>
> On Tue, May 23, 2023 at 7:01=E2=80=AFPM Jason A. Donenfeld <Jason@zx2c4.c=
om> wrote:
> >
> > On Tue, May 23, 2023 at 09:47:36AM -0700, Jakub Kicinski wrote:
> > > On Tue, 23 May 2023 18:42:53 +0200 Jason A. Donenfeld wrote:
> > > > > It should, no idea why it isn't. Looking thru the code now I don'=
t see
> > > > > any obvious gaps where timer object is on a list but not active :=
S
> > > > > There's no way to get a vmcore from syzbot, right? :)
> > > > >
> > > > > Also I thought the shutdown leads to a warning when someone tries=
 to
> > > > > schedule the dead timer but in fact add_timer() just exits cleanl=
y.
> > > > > So the shutdown won't help us find the culprit :(
> > > >
> > > > Worth noting that it could also be caused by adding to a dead timer
> > > > anywhere in priv_data of another netdev, not just the sole timer_li=
st
> > > > in net_device.
> > >
> > > Oh, I thought you zero'ed in on the watchdog based on offsets.
> > > Still, object debug should track all timers in the slab and complain
> > > on the free path.
> >
> > No, I mentioned watchdog because it's the only timer_list in struct
> > net_device.
> >
> > Offset analysis is an interesting idea though. Look at this:
> >
> > > The buggy address belongs to the object at ffff88801ecc0000
> > >  which belongs to the cache kmalloc-cg-8k of size 8192
> > > The buggy address is located 5376 bytes inside of
> > >  freed 8192-byte region [ffff88801ecc0000, ffff88801ecc2000)
> >
> > IDA says that for syzkaller's vmlinux, net_device has a size of 0xc80
> > and wg_device has a size of 0x880. 0xc80+0x880=3D5376. Coincidence that
> > the address offset is just after what wg uses?
>
>
> Note that the syzkaller report mentioned:
>
> alloc_netdev_mqs+0x89/0xf30 net/core/dev.c:10626
>  usbnet_probe+0x196/0x2770 drivers/net/usb/usbnet.c:1698
>  usb_probe_interface+0x5c4/0xb00 drivers/usb/core/driver.c:396
>  really_probe+0x294/0xc30 drivers/base/dd.c:658
>  __driver_probe_device+0x1a2/0x3d0 drivers/base/dd.c:800
>  driver_probe_device+0x50/0x420 drivers/base/dd.c:830
>  __device_attach_driver+0x2d3/0x520 drivers/base/dd.c:958
>
> So maybe an usbnet driver has a timer_list in its priv_data.

struct usbnet {
...
struct timer_list   delay;

