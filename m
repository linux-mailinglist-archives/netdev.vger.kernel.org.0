Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16B2BEB4AF
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 17:25:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728542AbfJaQZ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 12:25:26 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:51093 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727580AbfJaQZ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 12:25:26 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 1273E535E;
        Thu, 31 Oct 2019 12:25:25 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 31 Oct 2019 12:25:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=ciET5zZMdB4pJ11vI5qomBxM/l1ZE8whGPY1gejeE
        yw=; b=TPONw2RiqaN2UrYRFCm7Q85XKvLhUHvEAH4GbwOg/fvnYpPEG5j4bl8Wu
        kExovKf9j8oakVFZhLGGyKyt0CFrOYOBNLWW5+jNdAYVDr8uP3lsHNLbyJEsx0w8
        XFFCVSyBWfjZiMVFID8QHNPjOfe2yUUi7Xg+2mJR4sJ9BOWjJpq8swcIz/kTgC6C
        9JJIHPAtro/Czu8eIX7/7U3AVuO+dyK9ALVGeFDi87ex0dwa0xcw6YKZXcTp5pHZ
        3YOO1TV/KhzQKjh4BH+46nzDmMOKRdfSJKnt9FAGdk+pw3gJHrjzLq5qDvDCE+se
        +96SbHFmZt3dJmcstRu+E1SlB1A6A==
X-ME-Sender: <xms:8wq7XWpIp8yaMmk8m9Kq4YWct9qxVo6sevNgjhx86CIdwZRZBFw6mw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddthedgkeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    goufhushhpvggtthffohhmrghinhculdegledmnecujfgurhepfffhvffukfhfgggtugfg
    jggfsehtkeertddtreejnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughosh
    gthhesihguohhstghhrdhorhhgqeenucffohhmrghinheprghpphhsphhothdrtghomhdp
    ohiilhgrsghsrdhorhhgnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrg
    hmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushht
    vghrufhiiigvpedt
X-ME-Proxy: <xmx:8wq7XbVhgcuL2d7K_MEWHpfiIs8bvJ4V84gLLBShIWLpPn7DO17cbw>
    <xmx:8wq7XVYGh27KL7b8iDlQo7LI_8ghh5nGgTYtBUH49A7AfBBxe1ycDQ>
    <xmx:8wq7XWgUfOEnbotj3mKJtoQxfx6FRdxVIGLdZxs6gNVUpRZ9YTQN4A>
    <xmx:9Qq7XSt1obTxpWjWfWNVNBGg84LrIvjCIMSRaSaUEpCRYLkM6PY_Pw>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4478880060;
        Thu, 31 Oct 2019 12:25:23 -0400 (EDT)
Date:   Thu, 31 Oct 2019 18:25:21 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     syzbot <syzbot+9ed8f68ab30761f3678e@syzkaller.appspotmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Martin KaFai Lau <kafai@fb.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Yonghong Song <yhs@fb.com>
Subject: Re: general protection fault in process_one_work
Message-ID: <20191031162521.GA31303@splinter>
References: <0000000000001c46d5059608892f@google.com>
 <CACT4Y+b7nkRO_Q6X3sTWbGU5Y6bGuZPmKzoPL2uoFpA4KCP2hw@mail.gmail.com>
 <20191029084517.GA24289@splinter>
 <20191029165404.GA10996@splinter>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191029165404.GA10996@splinter>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 29, 2019 at 06:54:07PM +0200, Ido Schimmel wrote:
> On Tue, Oct 29, 2019 at 10:45:19AM +0200, Ido Schimmel wrote:
> > On Tue, Oct 29, 2019 at 09:43:27AM +0100, Dmitry Vyukov wrote:
> > > On Tue, Oct 29, 2019 at 9:38 AM syzbot
> > > <syzbot+9ed8f68ab30761f3678e@syzkaller.appspotmail.com> wrote:
> > > >
> > > > Hello,
> > > >
> > > > syzbot found the following crash on:
> > > >
> > > > HEAD commit:    38207291 bpf: Prepare btf_ctx_access for non raw_tp use case
> > > > git tree:       bpf-next
> > > > console output: https://syzkaller.appspot.com/x/log.txt?x=14173c0f600000
> > > > kernel config:  https://syzkaller.appspot.com/x/.config?x=41648156aa09be10
> > > > dashboard link: https://syzkaller.appspot.com/bug?extid=9ed8f68ab30761f3678e
> > > > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > > >
> > > > Unfortunately, I don't have any reproducer for this crash yet.
> > > >
> > > > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > > > Reported-by: syzbot+9ed8f68ab30761f3678e@syzkaller.appspotmail.com
> > > 
> > > +Jiří Pírko, this seems to be related to netdevsim.
> > 
> > Will check it.
> 
> Didn't have a lot of time today, but I think the issue is a race
> condition (note that syzbot only triggered it twice so far).
> 
> Upon reload nsim_dev_port_del_all() is called and starts deleting ports
> from the ports list without holding the ports list mutex. It is possible
> that during this time nsim_dev_trap_report_work() is executing from a
> workqueue and accessing freed memory despite holding the ports list
> mutex.
> 
> I'll try to reproduce and send a fix later this week.

Sent a fix:
https://patchwork.ozlabs.org/patch/1187587/

It was quite difficult to reproduce, so I used the below patch to
increase the time window in which the race could occur. Then it became
trivial to trigger :)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 54ca6681ba31..d12abd84c218 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -457,6 +457,7 @@ static void nsim_dev_trap_report_work(struct work_struct *work)
         */
        mutex_lock(&nsim_dev->port_list_lock);
        list_for_each_entry(nsim_dev_port, &nsim_dev->port_list, list) {
+               msleep(100);
                if (!netif_running(nsim_dev_port->ns->netdev))
                        continue;
