Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6C4A196012
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 21:52:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727495AbgC0UwD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 16:52:03 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:37627 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727349AbgC0UwD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 16:52:03 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 642A55C0313;
        Fri, 27 Mar 2020 16:52:02 -0400 (EDT)
Received: from imap2 ([10.202.2.52])
  by compute4.internal (MEProxy); Fri, 27 Mar 2020 16:52:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        stressinduktion.org; h=mime-version:message-id:in-reply-to
        :references:date:from:to:cc:subject:content-type
        :content-transfer-encoding; s=fm3; bh=7Cv0b5zS2UVFUNiJoSIaMm53on
        TaDjzjzCOCVdOuC1M=; b=ZKzBcgYVwakj0Two3ROpHVFSPZqMdEfSoyXi875pBd
        zNaEUu7ryi5pqxfRY/fgjGpqn224mTEpOU5yr/DCpaS+lFGNB0bNKRdPU2Rq3tN+
        XanxA4j6xKpeU1yBJhbPZUv0+VFtLQ+vp3AnJlfyi0+IVva1p/0lJcSvJajizJzn
        qUT4az1deVcsydJAPf2rzHYlHocmu323DkGKED+pKQrYzgqLH6fITCfug+IaZZdR
        nx5+46fOlOlgV3LUt3D3jSc1S/v6S299aybn/vu03HhInqBgnGNVRKUXZkwUFPEf
        BxHIIM4MvNvZA5HxAD3wqzfY8bzf8s2dI3WKg1y7VLVw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; bh=7Cv0b5zS2UVFUNiJoSIaMm53onTaDjzjzCOCVdOuC
        1M=; b=XXKRHOblLGV//F+JKWxgqVXqJpVHD1vja5nJ1Lt17e4zJtCFSbAypqwvU
        jslDjQj/LtEJj8ZAjYnkr8CKlnB6DaxYPyi8wuciUENW+70t4ZBJn+rbZAObbXT7
        myHgFp7CBuhvMohYdkO3gLEbZbLIE5KtP/O3g0unR9v43Ngu6LJMRl4RZEyJH9rJ
        qEorIfG/H1fbUO09UGWUGbYsn3EM4rsRRSx3E0Cv9PdClrWuzTVHA2XbDMb3GqYf
        XSJD4rjnRcNZSaTD9Qx+d4I9KErhrDL3MrNnl4r7w9piGxpdnndToqeGXeaP/wn8
        TfIF16bUhTHNN/YQW8m0HOwPAVJ8w==
X-ME-Sender: <xms:cGd-XiQAHQEWiIwoVt3j3mO-C6RdZM2KV8OHu1CfaR5ywlIOum-ENw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudehledgudeflecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefofgggkfgjfhffhffvufgtgfesthhqredtreerjeenucfhrhhomhepfdfj
    rghnnhgvshcuhfhrvgguvghrihgtucfuohifrgdfuceohhgrnhhnvghssehsthhrvghssh
    hinhguuhhkthhiohhnrdhorhhgqeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgr
    mhepmhgrihhlfhhrohhmpehhrghnnhgvshesshhtrhgvshhsihhnughukhhtihhonhdroh
    hrgh
X-ME-Proxy: <xmx:cGd-XgUaR8_QWdCvZjqycoTzI01-O-qxwjuO46SG3PB-LrQGBi7q3A>
    <xmx:cGd-XnlO6qwZ3_TLBvvfaXclDy5GqpJ8ekwRe2ElLHKsy9oVB6hlAw>
    <xmx:cGd-Xm-EqIHfjWAFla3XEZcklxbHZgIWKWngXeSYMs5LvHbGsuVlaQ>
    <xmx:cmd-Xihhnq7QK8gdcCEh44Oug9ozybq0VrpXkClZpDmKtSEH98ZBNg>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id C0414E00BB; Fri, 27 Mar 2020 16:52:00 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.1.7-1021-g152deaf-fmstable-20200319v1
Mime-Version: 1.0
Message-Id: <55ad4be2-3b0d-4f2c-9020-d06dafab2b55@www.fastmail.com>
In-Reply-To: <CABWXKLz-+wmhypzZGRMCtsWkGzg0-hj8qzjC2M=JYZXRWXFjEQ@mail.gmail.com>
References: <20200326094252.157914-1-brambonne@google.com>
 <20200326.114550.2060060414897819387.davem@davemloft.net>
 <CABWXKLwamYiLhwUHsb5nZHnyZb4=6RrrdUg3CiX7CZOuVime7g@mail.gmail.com>
 <a50808d0-df80-4fbc-a0aa-5a3342067378@www.fastmail.com>
 <CABWXKLz-+wmhypzZGRMCtsWkGzg0-hj8qzjC2M=JYZXRWXFjEQ@mail.gmail.com>
Date:   Fri, 27 Mar 2020 21:51:40 +0100
From:   "Hannes Frederic Sowa" <hannes@stressinduktion.org>
To:     =?UTF-8?Q?Bram_Bonn=C3=A9?= <brambonne@google.com>
Cc:     "David Miller" <davem@davemloft.net>,
        "Alexey Kuznetsov" <kuznet@ms2.inr.ac.ru>,
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

On Fri, Mar 27, 2020, at 18:15, Bram Bonn=C3=A9 wrote:
> Thank you for your detailed explanation and helping me understand the
> context! This is really useful.

Sure, let's try to solve this. :) Sorry for the bad formatting of the
previous email, I tried to fix it. Also I am a bit rusty on those
topics, so excuse me if I do mistakes in my argumentation here.

> On Fri, Mar 27, 2020 at 2:06 PM Hannes Frederic Sowa
> <hannes@stressinduktion.org> wrote:
> > The main idea behind stable IPv6 identifiers is to eventually
> > replace EUI-48 based generated addresses, because knowledge of the
> > MAC address should never leave the broadcast domain you are in. This=

> > leads to tracking of a user moving between different networks (in
> > this case moving between different ipv6 prefixes). It does not
> > necessarily replace the temporary address mode which fully
> > randomizes addresses and is still available to you for use in cases
> > where you don't want to have this compromise. temp_addresses are
> > still a good choice to use.
> >
> > MAC address randomization was mainly introduced to blind the unique
> > identifier during wifi probing and association, where no IPv6
> > traffic is yet visible on unencrypted links. As soon as the
> > encrypted link between your wifi endpoint and the access point is
> > established, IPv6 addresses are generated and used inside the
> > "encrypted wifi tunnel". This is an orthogonal measure to reduce the=

> > exposure of unique identifiers in the closer geographical proximity.=

>
> While the purpose of disassociated MAC address randomization is indeed=

> to prevent tracking a device during probing and association, my
> understanding is that connected MAC address randomization (as used in
> Android, for example) is designed to prevent devices being tracked
> across different networks that are managed by the same network
> operator. In this mode, a different MAC address is used for every
> network (based on SSID in the case of wireless networks) the user
> associates with. A user using connected MAC address randomization to
> associate with two different networks has the privacy expectation that=

> those networks are not able to link those associations to the same
> device without some other form of identification.

Okay, I understand. This is an additional scenario that wasn't on my
radar so far. Is the MAC address randomized on the (E)SSID or the BSSID?=

I assume later as the ESSID might be stable across operators, but
anyways that's just nit picking.

In this scenario you would like to blind all unique identifiers on the
network of a device in a "stable way". The MAC address is already
blinded, thus it would be possible to just inherit it as the link local
address, nothing seems to be lost then? Same for the globally scoped
generated addresses stemming from this randomized MAC address?

Using EUI-48 address generation mode here would give you the benefit of
having no unique identifier (managed by the randomized mac address), a
stable link-local address and global addresses per ESSID and not having
to maintain the stable address generation secret. Seems to me to be the
easiest way forward. I wonder what the implications regarding duplicate
MAC address detection and thus IPv6 address selection are, but that's
another topic.

Additionally for the global scoped address generation I think it makes
sense to still enable use_tempaddr=3D2, as it makes sure that for longer=

lasting associations to an AP new addresses are phased in and old ones
are phased out regularly.

Do IPv6 addresses generated with the EUI-48 mode from a randomized MAC
address have less random bits than if it would having been generated
with the stable or temporary method?

> > You might want to combine those two features: Not being able to be
> > disclosed in your proximity while having a stable address on your
> > network. If that is not your goal, you can still enable temporary
> > addresses, which will fully randomize your IPv6 addresses and are
> > thus is completely independent of your MAC address. This would meet
> > your concerns above.
>
> I was under the impression that use_tempaddr does not apply to link-
> local addresses. Is this not the case? A quick experiment on my
> machine shows:
>
> # sysctl -w net.ipv6.conf.enp0s31f6.use_tempaddr=3D2 ip link set dev
> # enp0s31f6 down && ip link set dev enp0s31f6 up ip address show dev
> # enp0s31f6
> 2: enp0s31f6: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc
>    pfifo_fast state UP group default qlen 1000 inet6 {same as before}
>    scope link noprefixroute valid_lft forever preferred_lft forever

Right, temporary addresses are only globally scoped. You can enable the
random address generator for link local addresses via `ip link ...
addrgenmode random`. Those addresses are not phased in and out like
temporary addresses are. Also check if keep_addr_on_down is enabled, as
this might influence this behavior as well.

> > My additional concern with this patch is that users might already
> > expect a certain way of the generation of stable IPv6 identifiers:
> > even though wpa_supplicant randomizes the mac address, they might
> > already depend on the stable generation of those addresses. If this
> > changes, contact to those systems might get lost during upgrade.
> > Though I don't know how severe this scenario is, I do, in fact, have=

> > some IPv6 stable identifiers in my shell history which are wifi
> > endpoints.
>
> If this is a scenario we care about, do you think it would make sense
> to put this behavior behind a separate configuration parameter?
> Something like use_software_mac, defaulting to disabled to keep
> current behavior?

If you like to keep the semantics of having ipv6 stable addresses as per=

spec, I would not object a patch adding a new mode like e.g.
IN6_ADDR_GEN_MODE_STABLE_PRIVACY_SOFTMAC (or some better name) on an
interface and consequently using the admin-mac address. For me the sole
benefit seems to be that the generated global addresses would
additionally depend on the prefix announced by the operator in that
particular network. This would only help if use_tempaddr=3D2 is not
enabled or applications deliberately bind to a non temp addresses
circumventing the source address selection.

> > If the IPv6 link local address can get discovered on the unencrypted=

> > wifi medium, I would be concerned but I don't think that is the
> > case. In case of fully unencrypted wifis you can make the above
> > case. It is possible to determine if a network endpoint (with the
> > same secret and permanent mac address) shows up again. In this case
> > I would recommend temporary addresses.
>
> I'm not sure I understand this paragraph. In unencrypted wireless
> networks, the link-local IPv6 address would be visible to
> eavesdroppers when it's being used, again negating the benefits of MAC=

> address randomization. Please let me know if I misunderstood.

I think there was a misunderstanding: I was referring to the case that
an IPv6 address might leak prior to joining an encrypted wifi (in the
"pre-auth phase").

Off topic: does Android also deal with sockets that are still bound to
old addresses, which potentially (I am not sure) generate packets that
are black holed because of wrong source address but still recognizable
by an network operator?

Bye, Hannes
