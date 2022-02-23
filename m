Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5C5B4C1D81
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 22:14:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241687AbiBWVPZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 16:15:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232658AbiBWVPY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 16:15:24 -0500
Received: from wout4-smtp.messagingengine.com (wout4-smtp.messagingengine.com [64.147.123.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D7424B1F5;
        Wed, 23 Feb 2022 13:14:56 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 0CF4F3201DD2;
        Wed, 23 Feb 2022 16:14:53 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Wed, 23 Feb 2022 16:14:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=yUW5NrWp4eORsmlcX
        ZcclcuZif21PYwZWhbYlB+pCAg=; b=LDh3Dk9bE/KQViGQM63rqvL1VMc8uoeO5
        pVlkzEyX/cva7uEIe39Dj2GWrHB3wtzPMO2FhnQO2jlMy00pRAPiifXu8zNuO7eX
        lWjCgxiuBfiWCrtoIAPbIB0tDBXTQkB5o6yE7jgvWWyYc/zfsx93kfAtb7EZf0Rn
        q2nJ86xhAWtGOmxx5G1seFrcoRsBB6zGpOkzrWIDKLgDnvK0GQvw9x1q5Lwa33yH
        13gIW9nXb7Zl9PV8wmKkeLcfjVoy0Su0YxUHgNdQqdqdtFs2zAOuVsfFtBy2n2y0
        BquISaVeFQVhjQvBpqedFHME0bzeVYJkMykrHG5Cluc5ojaJOaXTg==
X-ME-Sender: <xms:zaMWYpir3nWLCMfuLnodtoS9s1yOyEtthSOuLCrqqI5xPYxIKRr0PA>
    <xme:zaMWYuC7D4Zf6mn3CbX4j-IRJQCArQNAMiex2dE-KEGuNyy5SKQNfpkfii8qZZWYF
    I5iJQLIUBk0Mg>
X-ME-Received: <xmr:zaMWYpGWXqF5RVCrj-JxQAx3Xfx0ft0W1AFyOMI2gcnsdM8NNqlDjwxFPWoxkqToW_z95stGNV5jM9dj-7MtCtKQ6pQDo07qgA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrledtgddugeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehgtderredttdejnecuhfhrohhmpeforghrvghk
    ucforghrtgiihihkohifshhkihdqifpkrhgvtghkihcuoehmrghrmhgrrhgvkhesihhnvh
    hishhisghlvghthhhinhhgshhlrggsrdgtohhmqeenucggtffrrghtthgvrhhnpeekgedt
    gfdvieehhfehtddvleeiieeuteevheetffejjeejvdeijeevhfeufeefgeenucffohhmrg
    hinhepghhithhhuhgsrdgtohhmnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghm
    pehmrghilhhfrhhomhepmhgrrhhmrghrvghksehinhhvihhsihgslhgvthhhihhnghhslh
    grsgdrtghomh
X-ME-Proxy: <xmx:zaMWYuTNG4Ei3q1O0xQhFzBGrX1pFxfw7jLnYUmfPoEvUdG-NqK_7A>
    <xmx:zaMWYmxGRbakm2kphG-zfIm6GYS4I108VixjYL-MpTGM-wt1Dp5BRg>
    <xmx:zaMWYk6gOu0k7Amx-u0-Yn3IVI8bW95fzAnBTuzCyMy95ck2THSG5Q>
    <xmx:zaMWYhz-Xz0Mb_o3gFA2yf1wCB6g5u51TGVRYJ9NmBvlI1fTUiuFjA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 23 Feb 2022 16:14:51 -0500 (EST)
Date:   Wed, 23 Feb 2022 22:14:48 +0100
From:   Marek =?utf-8?Q?Marczykowski-G=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Juergen Gross <jgross@suse.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Antoine Tenart <atenart@kernel.org>,
        "moderated list:XEN HYPERVISOR INTERFACE" 
        <xen-devel@lists.xenproject.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>
Subject: Re: [PATCH] xen/netfront: destroy queues before real_num_tx_queues
 is zeroed
Message-ID: <YhajyDmotYNQLx9J@mail-itl>
References: <20220220134202.2187485-1-marmarek@invisiblethingslab.com>
 <3786b4ef-68e7-5735-0841-fcbae07f7e54@suse.com>
 <20220222120301.10af2737@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Uax9XTxqAklV2iNX"
Content-Disposition: inline
In-Reply-To: <20220222120301.10af2737@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--Uax9XTxqAklV2iNX
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Date: Wed, 23 Feb 2022 22:14:48 +0100
From: Marek =?utf-8?Q?Marczykowski-G=C3=B3recki?= <marmarek@invisiblethingslab.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Juergen Gross <jgross@suse.com>, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Antoine Tenart <atenart@kernel.org>,
	"moderated list:XEN HYPERVISOR INTERFACE" <xen-devel@lists.xenproject.org>,
	"open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>
Subject: Re: [PATCH] xen/netfront: destroy queues before real_num_tx_queues
 is zeroed

On Tue, Feb 22, 2022 at 12:03:01PM -0800, Jakub Kicinski wrote:
> On Mon, 21 Feb 2022 07:27:32 +0100 Juergen Gross wrote:
> > On 20.02.22 14:42, Marek Marczykowski-G=C3=B3recki wrote:
> > > xennet_destroy_queues() relies on info->netdev->real_num_tx_queues to
> > > delete queues. Since d7dac083414eb5bb99a6d2ed53dc2c1b405224e5
> > > ("net-sysfs: update the queue counts in the unregistration path"),
> > > unregister_netdev() indirectly sets real_num_tx_queues to 0. Those two
> > > facts together means, that xennet_destroy_queues() called from
> > > xennet_remove() cannot do its job, because it's called after
> > > unregister_netdev(). This results in kfree-ing queues that are still
> > > linked in napi, which ultimately crashes:
> > >=20
> > >      BUG: kernel NULL pointer dereference, address: 0000000000000000
> > >      #PF: supervisor read access in kernel mode
> > >      #PF: error_code(0x0000) - not-present page
> > >      PGD 0 P4D 0
> > >      Oops: 0000 [#1] PREEMPT SMP PTI
> > >      CPU: 1 PID: 52 Comm: xenwatch Tainted: G        W         5.16.1=
0-1.32.fc32.qubes.x86_64+ #226
> > >      RIP: 0010:free_netdev+0xa3/0x1a0
> > >      Code: ff 48 89 df e8 2e e9 00 00 48 8b 43 50 48 8b 08 48 8d b8 a=
0 fe ff ff 48 8d a9 a0 fe ff ff 49 39 c4 75 26 eb 47 e8 ed c1 66 ff <48> 8b=
 85 60 01 00 00 48 8d 95 60 01 00 00 48 89 ef 48 2d 60 01 00
> > >      RSP: 0000:ffffc90000bcfd00 EFLAGS: 00010286
> > >      RAX: 0000000000000000 RBX: ffff88800edad000 RCX: 0000000000000000
> > >      RDX: 0000000000000001 RSI: ffffc90000bcfc30 RDI: 00000000ffffffff
> > >      RBP: fffffffffffffea0 R08: 0000000000000000 R09: 0000000000000000
> > >      R10: 0000000000000000 R11: 0000000000000001 R12: ffff88800edad050
> > >      R13: ffff8880065f8f88 R14: 0000000000000000 R15: ffff8880066c6680
> > >      FS:  0000000000000000(0000) GS:ffff8880f3300000(0000) knlGS:0000=
000000000000
> > >      CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > >      CR2: 0000000000000000 CR3: 00000000e998c006 CR4: 00000000003706e0
> > >      Call Trace:
> > >       <TASK>
> > >       xennet_remove+0x13d/0x300 [xen_netfront]
> > >       xenbus_dev_remove+0x6d/0xf0
> > >       __device_release_driver+0x17a/0x240
> > >       device_release_driver+0x24/0x30
> > >       bus_remove_device+0xd8/0x140
> > >       device_del+0x18b/0x410
> > >       ? _raw_spin_unlock+0x16/0x30
> > >       ? klist_iter_exit+0x14/0x20
> > >       ? xenbus_dev_request_and_reply+0x80/0x80
> > >       device_unregister+0x13/0x60
> > >       xenbus_dev_changed+0x18e/0x1f0
> > >       xenwatch_thread+0xc0/0x1a0
> > >       ? do_wait_intr_irq+0xa0/0xa0
> > >       kthread+0x16b/0x190
> > >       ? set_kthread_struct+0x40/0x40
> > >       ret_from_fork+0x22/0x30
> > >       </TASK>
> > >=20
> > > Fix this by calling xennet_destroy_queues() from xennet_close() too,
> > > when real_num_tx_queues is still available. This ensures that queues =
are
> > > destroyed when real_num_tx_queues is set to 0, regardless of how
> > > unregister_netdev() was called.
> > >=20
> > > Originally reported at
> > > https://github.com/QubesOS/qubes-issues/issues/7257
> > >=20
> > > Fixes: d7dac083414eb5bb9 ("net-sysfs: update the queue counts in the =
unregistration path")
> > > Cc: stable@vger.kernel.org # 5.16+
> > > Signed-off-by: Marek Marczykowski-G=C3=B3recki <marmarek@invisiblethi=
ngslab.com>
> > >=20
> > > ---
> > > While this fixes the issue, I'm not sure if that is the correct thing
> > > to do. xennet_remove() calls xennet_destroy_queues() under rtnl_lock,
> > > which may be important here? Just moving xennet_destroy_queues() befo=
re =20
> >=20
> > I checked some of the call paths leading to xennet_close(), and all of
> > those contained an ASSERT_RTNL(), so it seems the rtnl_lock is already
> > taken here. Could you test with adding an ASSERT_RTNL() in
> > xennet_destroy_queues()?
> >=20
> > > unregister_netdev() in xennet_remove() did not helped - it crashed in
> > > another way (use-after-free in xennet_close()). =20
> >=20
> > Yes, this would need to basically do the xennet_close() handling in
> > xennet_destroy() instead, which I believe is not really an option.
>=20
> I think the patch makes open/close asymmetric, tho. After ifup ; ifdown;
> the next ifup will fail because queues are already destroyed, no?
> IOW xennet_open() expects the queues were created at an earlier stage.

Right.

> Maybe we can move the destroy to ndo_uninit? (and create to ndo_init?)

It looks like talk_to_netback(), which currently create queues, needs
them for for quite some work. It is also called when reconnecting (and
netdev is _not_ re-registered in this case), so that would be a
significant refactor.
But, moving destroy to ndo_uninit() should be fine. It works, including
after ifup;ifdown;ifup case too. I'll send v2 shortly.

--=20
Best Regards,
Marek Marczykowski-G=C3=B3recki
Invisible Things Lab

--Uax9XTxqAklV2iNX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhrpukzGPukRmQqkK24/THMrX1ywFAmIWo8gACgkQ24/THMrX
1yy8TQf/fTgM2gqArLzbOD4YE+NC3A/kn5VWlNVJOnvRlmtUyoc1WUTqqsENYBGA
4E81gq+MF/m7dVdq54oQpBKXPL+b1xE5MUBOs8MXkJTCRuRCKGJFU2APU4CF95he
w3kAGC6JYyCnnHUoQLWkvJsMPtj2Ldsx7fw1EkcMXJjsXTQka4bMpDbgvoM0YDJG
HzJ5GlBbAEzLp8op2KaW0XKKc/wtlTrwxRxZE24AizaA+5zvykOsUdtvtZvC6dC1
DgGYZ9gKFeFTP41eeyr0ZtwKqRv1vhqEUFcqpej/UQUYorxld7uPy8YwlQgXc/SQ
dJxzm21BpI1tEcpdStGoMYD9TPcxOQ==
=QCDX
-----END PGP SIGNATURE-----

--Uax9XTxqAklV2iNX--
