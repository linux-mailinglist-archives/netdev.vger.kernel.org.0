Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF3954BEE84
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 02:14:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237428AbiBVAQE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 19:16:04 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbiBVAQC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 19:16:02 -0500
Received: from wout4-smtp.messagingengine.com (wout4-smtp.messagingengine.com [64.147.123.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E164224BFC;
        Mon, 21 Feb 2022 16:15:37 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id EFD5E32020A4;
        Mon, 21 Feb 2022 19:15:34 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Mon, 21 Feb 2022 19:15:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=rc93G4/qTvE1ZYiC5
        yWr1O2C0TkaoFvvFLrkTcp0OiU=; b=Y69o6eJC81KbBulRopMzp6lUJuZ9AISxP
        +1QcRCFA2Lymy2SX6QdNNij+bpUKjLI7JY4jk6B+bsTE4uvRYLBtYJQVtWxLXOF7
        MC7BrgMjs73uOxKJd9JXq/llwO7LemYllNLWxpBII5AYt1DEKRPBJVbzniAl47EV
        I9+klBHWuuqK0ub/hUfvoMiMtMxtH8+AXU2eUhu1qnegNWweYwBpOLP94gcFk3Ed
        /xZmjxfMLtm6ggHg69s6N6iJbAvkHiohXHuNcbXTJ0JCAuGZGUMILtklyzt0pOtX
        cCF3DmjcxDKdnzI5Gl1lgGvALIo1R+JX0RkT5U6LWasdG37Dbrdqw==
X-ME-Sender: <xms:JisUYrJ7-Kx2Gz-DcSLX6JUni2MkM8yWYJQp4AoCgn2hvNSgKKT9zA>
    <xme:JisUYvKy_JBBMxZSyUGE4ic2Ird8J5qQ0NkL0YVsZKDDDDr5YdhauOPKZEfTegD1y
    GXHtTTeqwQ4Cw>
X-ME-Received: <xmr:JisUYjv11Y6MM_noDbeYIUb00bL2l060gnp-_P2lzYgS7yb48dKXZo_tsjqwkhStKt7m7VELWr2YvwyH0hCdhxXSpyzovDUyiw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrkeejgddvtdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesghdtreertddtjeenucfhrhhomhepofgrrhgvkhcu
    ofgrrhgtiiihkhhofihskhhiqdfikphrvggtkhhiuceomhgrrhhmrghrvghksehinhhvih
    hsihgslhgvthhhihhnghhslhgrsgdrtghomheqnecuggftrfgrthhtvghrnhepteevffei
    gffhkefhgfegfeffhfegveeikeettdfhheevieehieeitddugeefteffnecuvehluhhsth
    gvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepmhgrrhhmrghrvghksehi
    nhhvihhsihgslhgvthhhihhnghhslhgrsgdrtghomh
X-ME-Proxy: <xmx:JisUYkbYs4yRQDuWPVpdWhTz-QMKtlgY3G4siF3Azf63M4nIiJq4Rg>
    <xmx:JisUYia-rc0nv9Ddr695FsbNsEykqpokrW3ZBB2ZlTMV7xRwvbrssA>
    <xmx:JisUYoC2vmtUkDy87UAuKxSdgXE1Y-PGs7AKNdt35uk5T5MudK5U5A>
    <xmx:JisUYq7doJGgZO5OJpN9rhB7hPF6DYbyZo9JLQQtjrg4kaKuGWyz8w>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 21 Feb 2022 19:15:32 -0500 (EST)
Date:   Tue, 22 Feb 2022 01:15:29 +0100
From:   Marek =?utf-8?Q?Marczykowski-G=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>
To:     Juergen Gross <jgross@suse.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Antoine Tenart <atenart@kernel.org>,
        "moderated list:XEN HYPERVISOR INTERFACE" 
        <xen-devel@lists.xenproject.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>
Subject: Re: [PATCH] xen/netfront: destroy queues before real_num_tx_queues
 is zeroed
Message-ID: <YhQrIWyJ4hhEVVNb@mail-itl>
References: <20220220134202.2187485-1-marmarek@invisiblethingslab.com>
 <3786b4ef-68e7-5735-0841-fcbae07f7e54@suse.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="+tkBggBQeIzPYW+u"
Content-Disposition: inline
In-Reply-To: <3786b4ef-68e7-5735-0841-fcbae07f7e54@suse.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--+tkBggBQeIzPYW+u
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Date: Tue, 22 Feb 2022 01:15:29 +0100
From: Marek =?utf-8?Q?Marczykowski-G=C3=B3recki?= <marmarek@invisiblethingslab.com>
To: Juergen Gross <jgross@suse.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Antoine Tenart <atenart@kernel.org>,
	"moderated list:XEN HYPERVISOR INTERFACE" <xen-devel@lists.xenproject.org>,
	"open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>
Subject: Re: [PATCH] xen/netfront: destroy queues before real_num_tx_queues
 is zeroed

On Mon, Feb 21, 2022 at 07:27:32AM +0100, Juergen Gross wrote:
> I checked some of the call paths leading to xennet_close(), and all of
> those contained an ASSERT_RTNL(), so it seems the rtnl_lock is already
> taken here. Could you test with adding an ASSERT_RTNL() in
> xennet_destroy_queues()?

Tried that and no issues spotted.

> In case your test with the added ASSERT_RTNL() doesn't show any
> problem you can add my:
>=20
> Reviewed-by: Juergen Gross <jgross@suse.com>

Thanks.

--=20
Best Regards,
Marek Marczykowski-G=C3=B3recki
Invisible Things Lab

--+tkBggBQeIzPYW+u
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhrpukzGPukRmQqkK24/THMrX1ywFAmIUKyEACgkQ24/THMrX
1yzoYwf9Gx9pcUVHvqm8ndGiV2gIwVCSdgcmDurruCiP0HW8l4A1u6WAWRPs1qRH
ZBdfn5OSBZwFZu0tVetXVnmWmMAKjqWAHNIF+DlptXue1GzEMa8QIy3NA5iplpOc
E4xTNf2rn4tEhz4lunfATqTeLKtju19I0w8CD/szjq5CcqOTyHbOV5PodTF2ZdhY
yAxGB/KTZUROG+8+orCaqmv9RTe0nob293WI8FpAGr4+QowJKuTsygIX+tryKzIA
2baSea6s+ZjOg0d4NSGSEbU9u8o0NibNiiuT5cAVRHVkVpUNwn4bs3H7K7P25fZe
RrtbyZfzDTeTV5TfKUQwWl9q6tORaw==
=Kebw
-----END PGP SIGNATURE-----

--+tkBggBQeIzPYW+u--
