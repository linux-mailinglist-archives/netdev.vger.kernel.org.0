Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 953091957BA
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 14:06:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727345AbgC0NG2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 09:06:28 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:48737 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726165AbgC0NG1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 09:06:27 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 831CC83B;
        Fri, 27 Mar 2020 09:06:26 -0400 (EDT)
Received: from imap2 ([10.202.2.52])
  by compute4.internal (MEProxy); Fri, 27 Mar 2020 09:06:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        stressinduktion.org; h=mime-version:message-id:in-reply-to
        :references:date:from:to:cc:subject:content-type
        :content-transfer-encoding; s=fm3; bh=dPr6QdQOf4NoboK9rwgoQ5mjpA
        EquGAswUU8HOhEMiE=; b=lFMpWC5LW003c1d9US5i1rR1GIkaBxyVZnfM8bm+ie
        K5DCuq/fQMupaFOnZRV60RMLnDZNUdKSZABSApN1elS9Pg5dSvmos7/pgny91X3t
        ttS+4I8gKhRiF7JX++QKHCpUy67kU+jccwHiJzfATNJFfGvYfc7kjrjiHVqUxQVF
        iEzlhkDlj5crzQEbE2foLoJady6E269pyZaL4mm+VJF+Oco9GG3XSDuOcIjAFLOK
        yA90Gz4tG7C4w77BfkQIktJ1n0ifOIA/qd06e4yM3YtSr0v0wa0m+rh/NhWJWFrq
        Fq++m8YkEGzO0ZdSABrYSx80uix8VG9SOaGovW7SB9wQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; bh=dPr6QdQOf4NoboK9rwgoQ5mjpAEquGAswUU8HOhEM
        iE=; b=uJvABexFJB1/u3vlPaDHdHRjGyDQVtvqsa2K9hfuvTTRJZ/SI6cflNvwu
        OAI6ztFgqtuhqPXdxRY/cuA8X1cbzMTiT8QjvLz3YxpsIrDFoel66k/b9AKzb2Tl
        hiii5/IAHh2DEe5MXHhzOT9vuIIpf0AsFt6H/rQbJwqy2rnpCE9T9m76IYnC2Y0U
        F9IB0O6bJZNnLB9PXPgbzFNIgKHNpr4bN0tPK+UVzOA4bS28fZuTpM0SppFG2yNr
        3ULnxhwe35yJxhvoBSEzV2fIZiIJWOyNc/iTOTezX08jtihc1ZDevXIt6TebR9ch
        abnj0EC0G4Ky99OeBzK9JO7eSZiOA==
X-ME-Sender: <xms:UPp9Xo_H24hTv_6Avjp2MATAKKDkfpl5Nd0mLLSfPeUNKtcevp9OxQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudehledggeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvffutgfgsehtqhertderreejnecuhfhrohhmpedfjfgr
    nhhnvghsucfhrhgvuggvrhhitgcuufhofigrfdcuoehhrghnnhgvshesshhtrhgvshhsih
    hnughukhhtihhonhdrohhrgheqnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghm
    pehmrghilhhfrhhomhephhgrnhhnvghssehsthhrvghsshhinhguuhhkthhiohhnrdhorh
    hg
X-ME-Proxy: <xmx:UPp9XpUrS9Zdp0rXl6-Bt0WUGmD4bgfM1T-jPkOmNagtK7sgyf6cWQ>
    <xmx:UPp9XnA9-fcWW5ePW5hxyBfVf7t9rdtkEGBsFfOtKkg3KMvccWzvBg>
    <xmx:UPp9Xgm7fQ9lU5yPvRgFulNJTF62Vt8yDXkfbyGyJ4a8EsSfuKsK5g>
    <xmx:Uvp9XiAxGBbV0NFTglgiuT6I0is3kK804xLg46U7sj0lhj5HWYYoNA>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id CDA67E00C3; Fri, 27 Mar 2020 09:06:24 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.1.7-1021-g152deaf-fmstable-20200319v1
Mime-Version: 1.0
Message-Id: <a50808d0-df80-4fbc-a0aa-5a3342067378@www.fastmail.com>
In-Reply-To: <CABWXKLwamYiLhwUHsb5nZHnyZb4=6RrrdUg3CiX7CZOuVime7g@mail.gmail.com>
References: <20200326094252.157914-1-brambonne@google.com>
 <20200326.114550.2060060414897819387.davem@davemloft.net>
 <CABWXKLwamYiLhwUHsb5nZHnyZb4=6RrrdUg3CiX7CZOuVime7g@mail.gmail.com>
Date:   Fri, 27 Mar 2020 14:06:03 +0100
From:   "Hannes Frederic Sowa" <hannes@stressinduktion.org>
To:     =?UTF-8?Q?Bram_Bonn=C3=A9?= <brambonne@google.com>,
        "David Miller" <davem@davemloft.net>
Cc:     "Alexey Kuznetsov" <kuznet@ms2.inr.ac.ru>,
        "Hideaki YOSHIFUJI" <yoshfuji@linux-ipv6.org>, kuba@kernel.org,
        netdev@vger.kernel.org, "Lorenzo Colitti" <lorenzo@google.com>,
        "Jeffrey Vander Stoep" <jeffv@google.com>
Subject: =?UTF-8?Q?Re:_[RFC_PATCH]_ipv6:_Use_dev=5Faddr_in_stable-privacy_address?=
 =?UTF-8?Q?_generation?=
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Fri, Mar 27, 2020, at 12:50, Bram Bonn=C3=A9 wrote:
> On Thu, Mar 26, 2020 at 7:45 PM David Miller <davem@davemloft.net> wro=
te:
> > I think the current behavior is intentional in that it's supposed to=
 use
> > something that is unchanging even across arbitrary administrator cha=
nges
> > to the in-use MAC address.
>=20
> Thank you for your feedback David.
>=20
> Could you help me understand the use cases where the admin / user
> chooses to use MAC address randomization, but still wants an IPv6
> link-local address that remains stable across these networks? My
> assumption was that the latter would defeat the purpose of the former,=

> though it's entirely possible that I'm missing something.

The main idea behind stable IPv6 identifiers is to eventually replace EU=
I-48 based generated addresses, because knowledge of the MAC address sho=
uld never leave the broadcast domain you are in. This leads to tracking =
of a user moving between different networks (in this case moving between=
 different ipv6 prefixes). It does not necessarily replace the temporary=
 address mode which fully randomizes addresses and is still available to=
 you for use in cases where you don't want to have this compromise. temp=
_addresses are still a good choice to use.

MAC address randomization was mainly introduced to blind the unique iden=
tifier during wifi probing and association, where no IPv6 traffic is yet=
 visible on unencrypted links. As soon as the encrypted link between you=
r wifi endpoint and the access point is established, IPv6 addresses are =
generated and used inside the "encrypted wifi tunnel". This is an orthog=
onal measure to reduce the exposure of unique identifiers in the closer =
geographical proximity.

You might want to combine those two features: Not being able to be discl=
osed in your proximity while having a stable address on your network. If=
 that is not your goal, you can still enable temporary addresses, which =
will fully randomize your IPv6 addresses and are thus is completely inde=
pendent of your MAC address. This would meet your concerns above.

My additional concern with this patch is that users might already expect=
 a certain way of the generation of stable IPv6 identifiers: even though=
 wpa_supplicant randomizes the mac address, they might already depend on=
 the stable generation of those addresses. If this changes, contact to t=
hose systems might get lost during upgrade. Though I don't know how seve=
re this scenario is, I do, in fact, have some IPv6 stable identifiers in=
 my shell history which are wifi endpoints.

If the IPv6 link local address can get discovered on the unencrypted wif=
i medium, I would be concerned but I don't think that is the case. In ca=
se of fully unencrypted wifis you can make the above case. It is possibl=
e to determine if a network endpoint (with the same secret and permanent=
 mac address) shows up again. In this case I would recommend temporary a=
ddresses.

Bye,
Hannes
