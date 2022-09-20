Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD66A5BE68B
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 14:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbiITM7O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 08:59:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbiITM7N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 08:59:13 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02765BE27
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 05:59:13 -0700 (PDT)
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id A30063F474
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 12:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1663678749;
        bh=eqAwEupQJTaL2ViF2lYJ6wP4Hl3nR09hRm2qaq0rQeE=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=jfwPx3+CMZMYXfO/R3CFtNTihgun1Cy5pHGdpOt4mnf/+ndsrIicf/AOhxqqtl+Wk
         RfsOs08552W2rFoo1EBpbCC8WZTY251poQBrebvtzY4NjxZH7qNfmIeVCBl1j149B0
         Oo92pKvtZZnf5CeaOdlpNViPsMbuT9UTDO7TztnNK/s9WtWelkgBiSZhONU5hNNm2e
         YsyBYZN1o97e/E6CvgIiYeUS3WtVgQmqsw8THjBBC+caXV1KE2dGh8jGdJCP4p/K7W
         E9yqb3rG2yeXXDlMR4KqUxI97sD3sllHiQGdtZWQRcvBBriQzm/+VVvvszAOzjNMqb
         UKwUglPJSpD2A==
Received: by mail-pg1-f199.google.com with SMTP id h5-20020a636c05000000b00429fa12cb65so1593614pgc.21
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 05:59:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:content-transfer-encoding:content-id:mime-version
         :comments:references:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date;
        bh=eqAwEupQJTaL2ViF2lYJ6wP4Hl3nR09hRm2qaq0rQeE=;
        b=Zt6BiUYnv9fJzWO94U/+xSo1R7Ezvfsqkj+R5G2+7pJTJ4+nMV6Iw+6Jp+FajS3W93
         kUC9g/rYIqjaUo3dGNLBTh/7WQEvOSURDQaaihGGuRVueUFqTAWZJNuY6kbm/q3swDdj
         gmkGWcc8yMeljG1Q2SV0nuukeq6NQcj/+WjaeOcizyS6oApNjtpCKP1wginNGGMfpZJ4
         ZPzSo7LnS0kT1MAxh7iGSp4jU8r36yAUJQo0CHN2ekdSaSimgLQLqBiH3pJLxl1hxYUb
         dpTib1220TnEtZRYlvBV04Txb7nOXVOqHuOJpi1X34fXtbe9Kd9vUqXBgK+bJRLXu7hY
         qI6Q==
X-Gm-Message-State: ACrzQf271dgxPsVGdXv4LC+9QpHWEvp+rqwCDyDzHOOi3DSCvJC/jOX6
        jYByleR4zX7dnyI+R+LTYWyEqiOO7S2NHNw0yJI5ljX6ywnAvucLNy7wtTkbq2X9QusmX8L4E/1
        221B9T/NWSEr/xYNfX4MHEzOw/GuqNMHfsA==
X-Received: by 2002:a17:90a:64c8:b0:202:6d4a:90f8 with SMTP id i8-20020a17090a64c800b002026d4a90f8mr3885580pjm.11.1663678747869;
        Tue, 20 Sep 2022 05:59:07 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5IRqKKEhDlg4r6E3b5F4XnWYIDAdTm4HI2gpPxq2zepmxnXXYtHpSQyLoifBaRxlfIrdwDPg==
X-Received: by 2002:a17:90a:64c8:b0:202:6d4a:90f8 with SMTP id i8-20020a17090a64c800b002026d4a90f8mr3885553pjm.11.1663678747591;
        Tue, 20 Sep 2022 05:59:07 -0700 (PDT)
Received: from famine.localdomain ([50.125.80.157])
        by smtp.gmail.com with ESMTPSA id d1-20020a170903230100b00176d347e9a7sm1364706plh.233.2022.09.20.05.59.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 20 Sep 2022 05:59:06 -0700 (PDT)
Received: by famine.localdomain (Postfix, from userid 1000)
        id 50334604E4; Tue, 20 Sep 2022 05:59:06 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 4A2C6A0101;
        Tue, 20 Sep 2022 05:59:06 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Jonathan Toppins <jtoppins@redhat.com>
cc:     "netdev @ vger . kernel . org" <netdev@vger.kernel.org>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jussi Maki <joamaki@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 2/2] bonding: fix NULL deref in bond_rr_gen_slave_id
In-reply-to: <3cd65bdf26ba7b64c8ade801820562c426b90109.1663628505.git.jtoppins@redhat.com>
References: <cover.1663628505.git.jtoppins@redhat.com> <3cd65bdf26ba7b64c8ade801820562c426b90109.1663628505.git.jtoppins@redhat.com>
Comments: In-reply-to Jonathan Toppins <jtoppins@redhat.com>
   message dated "Mon, 19 Sep 2022 19:08:46 -0400."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <16281.1663678746.1@famine>
Content-Transfer-Encoding: quoted-printable
Date:   Tue, 20 Sep 2022 05:59:06 -0700
Message-ID: <16282.1663678746@famine>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jonathan Toppins <jtoppins@redhat.com> wrote:

>Fix a NULL dereference of the struct bonding.rr_tx_counter member because
>if a bond is initially created with an initial mode !=3D zero (Round Robi=
n)
>the memory required for the counter is never created and when the mode is
>changed there is never any attempt to verify the memory is allocated upon
>switching modes.
>
>This causes the following Oops on an aarch64 machine:
>    [  334.686773] Unable to handle kernel paging request at virtual addr=
ess ffff2c91ac905000
>    [  334.694703] Mem abort info:
>    [  334.697486]   ESR =3D 0x0000000096000004
>    [  334.701234]   EC =3D 0x25: DABT (current EL), IL =3D 32 bits
>    [  334.706536]   SET =3D 0, FnV =3D 0
>    [  334.709579]   EA =3D 0, S1PTW =3D 0
>    [  334.712719]   FSC =3D 0x04: level 0 translation fault
>    [  334.717586] Data abort info:
>    [  334.720454]   ISV =3D 0, ISS =3D 0x00000004
>    [  334.724288]   CM =3D 0, WnR =3D 0
>    [  334.727244] swapper pgtable: 4k pages, 48-bit VAs, pgdp=3D00000804=
4d662000
>    [  334.733944] [ffff2c91ac905000] pgd=3D0000000000000000, p4d=3D00000=
00000000000
>    [  334.740734] Internal error: Oops: 96000004 [#1] SMP
>    [  334.745602] Modules linked in: bonding tls veth rfkill sunrpc arm_=
spe_pmu vfat fat acpi_ipmi ipmi_ssif ixgbe igb i40e mdio ipmi_devintf ipmi=
_msghandler arm_cmn arm_dsu_pmu cppc_cpufreq acpi_tad fuse zram crct10dif_=
ce ast ghash_ce sbsa_gwdt nvme drm_vram_helper drm_ttm_helper nvme_core tt=
m xgene_hwmon
>    [  334.772217] CPU: 7 PID: 2214 Comm: ping Not tainted 6.0.0-rc4-0013=
3-g64ae13ed4784 #4
>    [  334.779950] Hardware name: GIGABYTE R272-P31-00/MP32-AR1-00, BIOS =
F18v (SCP: 1.08.20211002) 12/01/2021
>    [  334.789244] pstate: 60400009 (nZCv daif +PAN -UAO -TCO -DIT -SSBS =
BTYPE=3D--)
>    [  334.796196] pc : bond_rr_gen_slave_id+0x40/0x124 [bonding]
>    [  334.801691] lr : bond_xmit_roundrobin_slave_get+0x38/0xdc [bonding=
]
>    [  334.807962] sp : ffff8000221733e0
>    [  334.811265] x29: ffff8000221733e0 x28: ffffdbac8572d198 x27: ffff8=
0002217357c
>    [  334.818392] x26: 000000000000002a x25: ffffdbacb33ee000 x24: ffff0=
7ff980fa000
>    [  334.825519] x23: ffffdbacb2e398ba x22: ffff07ff98102000 x21: ffff0=
7ff981029c0
>    [  334.832646] x20: 0000000000000001 x19: ffff07ff981029c0 x18: 00000=
00000000014
>    [  334.839773] x17: 0000000000000000 x16: ffffdbacb1004364 x15: 0000a=
aaabe2f5a62
>    [  334.846899] x14: ffff07ff8e55d968 x13: ffff07ff8e55db30 x12: 00000=
00000000000
>    [  334.854026] x11: ffffdbacb21532e8 x10: 0000000000000001 x9 : ffffd=
bac857178ec
>    [  334.861153] x8 : ffff07ff9f6e5a28 x7 : 0000000000000000 x6 : 00000=
0007c2b3742
>    [  334.868279] x5 : ffff2c91ac905000 x4 : ffff2c91ac905000 x3 : ffff0=
7ff9f554400
>    [  334.875406] x2 : ffff2c91ac905000 x1 : 0000000000000001 x0 : ffff0=
7ff981029c0
>    [  334.882532] Call trace:
>    [  334.884967]  bond_rr_gen_slave_id+0x40/0x124 [bonding]
>    [  334.890109]  bond_xmit_roundrobin_slave_get+0x38/0xdc [bonding]
>    [  334.896033]  __bond_start_xmit+0x128/0x3a0 [bonding]
>    [  334.901001]  bond_start_xmit+0x54/0xb0 [bonding]
>    [  334.905622]  dev_hard_start_xmit+0xb4/0x220
>    [  334.909798]  __dev_queue_xmit+0x1a0/0x720
>    [  334.913799]  arp_xmit+0x3c/0xbc
>    [  334.916932]  arp_send_dst+0x98/0xd0
>    [  334.920410]  arp_solicit+0xe8/0x230
>    [  334.923888]  neigh_probe+0x60/0xb0
>    [  334.927279]  __neigh_event_send+0x3b0/0x470
>    [  334.931453]  neigh_resolve_output+0x70/0x90
>    [  334.935626]  ip_finish_output2+0x158/0x514
>    [  334.939714]  __ip_finish_output+0xac/0x1a4
>    [  334.943800]  ip_finish_output+0x40/0xfc
>    [  334.947626]  ip_output+0xf8/0x1a4
>    [  334.950931]  ip_send_skb+0x5c/0x100
>    [  334.954410]  ip_push_pending_frames+0x3c/0x60
>    [  334.958758]  raw_sendmsg+0x458/0x6d0
>    [  334.962325]  inet_sendmsg+0x50/0x80
>    [  334.965805]  sock_sendmsg+0x60/0x6c
>    [  334.969286]  __sys_sendto+0xc8/0x134
>    [  334.972853]  __arm64_sys_sendto+0x34/0x4c
>    [  334.976854]  invoke_syscall+0x78/0x100
>    [  334.980594]  el0_svc_common.constprop.0+0x4c/0xf4
>    [  334.985287]  do_el0_svc+0x38/0x4c
>    [  334.988591]  el0_svc+0x34/0x10c
>    [  334.991724]  el0t_64_sync_handler+0x11c/0x150
>    [  334.996072]  el0t_64_sync+0x190/0x194
>    [  334.999726] Code: b9001062 f9403c02 d53cd044 8b040042 (b8210040)
>    [  335.005810] ---[ end trace 0000000000000000 ]---
>    [  335.010416] Kernel panic - not syncing: Oops: Fatal exception in i=
nterrupt
>    [  335.017279] SMP: stopping secondary CPUs
>    [  335.021374] Kernel Offset: 0x5baca8eb0000 from 0xffff800008000000
>    [  335.027456] PHYS_OFFSET: 0x80000000
>    [  335.030932] CPU features: 0x0000,0085c029,19805c82
>    [  335.035713] Memory Limit: none
>    [  335.038756] Rebooting in 180 seconds..
>
>The is to allocate the memory in bond_open() which is guaranteed to be
    ^
   "fix" or "remedy" or the like here?

	Other than the missing word, the patch looks good to me.

	-J

>called before any packets are processed.
>
>Fixes: 848ca9182a7d ("net: bonding: Use per-cpu rr_tx_counter")
>Signed-off-by: Jonathan Toppins <jtoppins@redhat.com>
>---
> drivers/net/bonding/bond_main.c | 15 ++++++---------
> 1 file changed, 6 insertions(+), 9 deletions(-)
>
>diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_m=
ain.c
>index bc6d8b0aa6fb..86d42306aa5e 100644
>--- a/drivers/net/bonding/bond_main.c
>+++ b/drivers/net/bonding/bond_main.c
>@@ -4182,6 +4182,12 @@ static int bond_open(struct net_device *bond_dev)
> 	struct list_head *iter;
> 	struct slave *slave;
> =

>+	if (BOND_MODE(bond) =3D=3D BOND_MODE_ROUNDROBIN && !bond->rr_tx_counter=
) {
>+		bond->rr_tx_counter =3D alloc_percpu(u32);
>+		if (!bond->rr_tx_counter)
>+			return -ENOMEM;
>+	}
>+
> 	/* reset slave->backup and slave->inactive */
> 	if (bond_has_slaves(bond)) {
> 		bond_for_each_slave(bond, slave, iter) {
>@@ -6243,15 +6249,6 @@ static int bond_init(struct net_device *bond_dev)
> 	if (!bond->wq)
> 		return -ENOMEM;
> =

>-	if (BOND_MODE(bond) =3D=3D BOND_MODE_ROUNDROBIN) {
>-		bond->rr_tx_counter =3D alloc_percpu(u32);
>-		if (!bond->rr_tx_counter) {
>-			destroy_workqueue(bond->wq);
>-			bond->wq =3D NULL;
>-			return -ENOMEM;
>-		}
>-	}
>-
> 	spin_lock_init(&bond->stats_lock);
> 	netdev_lockdep_set_classes(bond_dev);
> =

>-- =

>2.31.1
>

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
