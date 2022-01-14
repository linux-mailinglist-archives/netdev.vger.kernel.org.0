Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FC5F48EF57
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 18:44:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243914AbiANRoM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 12:44:12 -0500
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:42241 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243918AbiANRoM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 12:44:12 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 2FEE5580183;
        Fri, 14 Jan 2022 12:44:09 -0500 (EST)
Received: from imap48 ([10.202.2.98])
  by compute4.internal (MEProxy); Fri, 14 Jan 2022 12:44:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        stressinduktion.org; h=mime-version:message-id:in-reply-to
        :references:date:from:to:cc:subject:content-type; s=fm2; bh=XC8x
        7KXAcVBSo+8COeedpg7cEMYqOq1otu+UETusZEE=; b=JkO4dr9OnXIi2E5oBM5K
        t66ge8M1MdOaiKC+cg+WCGTYPSOwvSHo58qUkzgvqULeHC1fZrOPnn3cvQ6Tf2vJ
        lxuoYGE4+5Ec0LULpqmhcN2kcyeEzlo7N3cuBeWugdDNbK13fRUuNVqeM0rCBS9b
        ddQIRMTYADY49oMEc1U0JRssBs8MX9sL49QHb196zqP8yHGD/7xEhyZhu+6QXv8A
        cQ8KNKhfmiBKqDOibsRYi711kfuBvekag0zW6rYmT8bEAiG+iHctt5F8n1b0PEuj
        U+mgmXBnQUnahqUky2UZczB84TlelCxsWyhg2kxr97EWeAqib+DNq+7QYnKEDYCn
        2g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=XC8x7K
        XAcVBSo+8COeedpg7cEMYqOq1otu+UETusZEE=; b=XxcYTeuCtnlGC7MarUYPyU
        ddvAlD8qIyyumQtLdcNmyBqPSY6bdaBIdld6+Mgc0lD4ShzjMtBhh8AeP+30iO9G
        rxqYC6i9zUuEd02xgX143G5o2jNxd3YwEDEhlLNCoUI20plomMgnylK5AsGt2NpB
        N4nERzqjE6+bMxjDK8l3kkILv7mmwWc4qevzfVe2+fVDbxeYc66U3KxxsUcXAWwH
        Zs92EJTLSbS/L6ZPkMj3fZUsNLGuq74mJR+xEllfbYqIUNrx1h3O4Agv0B/5jo61
        pYMOQTXo0ACFFHhAtqR/WT6X2ziLjVzed/Cg0wLbebL4JCawb2QhdVTUGpdT2G0w
        ==
X-ME-Sender: <xms:Z7bhYawjmLXYGTgJAKyZ1FGbCylbfWwK1B1aQqIKvBHVTlf-zVILWg>
    <xme:Z7bhYWTUWVR8aUIp1eK-sS1ALJZ0M7SDFoISDWpvpnpV1yYqr1PX0HK5yJ23j_MWs
    HdQg1FIvemwLZzHEA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrtdehgddutdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvffutgesthdtredtreertdenucfhrhhomhepfdfjrghn
    nhgvshcuhfhrvgguvghrihgtucfuohifrgdfuceohhgrnhhnvghssehsthhrvghsshhinh
    guuhhkthhiohhnrdhorhhgqeenucggtffrrghtthgvrhhnpeehieeggeethedtgfdvtdek
    ffduudegueevffekheefjeegvedugeetveffteetleenucffohhmrghinhepgihktggurd
    gtohhmnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhep
    hhgrnhhnvghssehsthhrvghsshhinhguuhhkthhiohhnrdhorhhg
X-ME-Proxy: <xmx:Z7bhYcWeoRrx3NNL4AJ4L4l3e6fjFBT30oc09LqJ9b3p5GoqjvS0gA>
    <xmx:Z7bhYQgE9QO-Zr2NhLl6GESvsvLlyiGDi-mgXrqLbIM48Yeeb90tCA>
    <xmx:Z7bhYcCrlbSm9vbPNpS9oYGCuspUQKDONypysdZK9dFUxFmO1Gshmw>
    <xmx:abbhYQ6uvmjAsuMFEM_JKvAwKKdZW48Ck8X5NcK9TwWNLoqyy1eV5A>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 7B93821E006E; Fri, 14 Jan 2022 12:44:07 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-4569-g891f756243-fm-20220111.001-g891f7562
Mime-Version: 1.0
Message-Id: <3db9c306-ea22-444f-b932-f66f800a7a28@www.fastmail.com>
In-Reply-To: <CAHmME9pR+qTn72vyANq8Nxx0BtGy7a_+dRvZS_F7RCag8Rvxng@mail.gmail.com>
References: <20220112131204.800307-1-Jason@zx2c4.com>
 <20220112131204.800307-3-Jason@zx2c4.com> <87r19cftbr.fsf@toke.dk>
 <CAHmME9pieaBBhKc1uKABjTmeKAL_t-CZa_WjCVnUr_Y1_D7A0g@mail.gmail.com>
 <55d185a8-31ea-51d0-d9be-debd490cd204@stressinduktion.org>
 <CAHmME9pR+qTn72vyANq8Nxx0BtGy7a_+dRvZS_F7RCag8Rvxng@mail.gmail.com>
Date:   Fri, 14 Jan 2022 18:41:58 +0100
From:   "Hannes Frederic Sowa" <hannes@stressinduktion.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Geert Uytterhoeven" <geert@linux-m68k.org>,
        "Herbert Xu" <herbert@gondor.apana.org.au>,
        "Ard Biesheuvel" <ardb@kernel.org>,
        "Jean-Philippe Aumasson" <jeanphilippe.aumasson@gmail.com>,
        "Linux Crypto Mailing List" <linux-crypto@vger.kernel.org>,
        "Erik Kline" <ek@google.com>,
        "Fernando Gont" <fgont@si6networks.com>,
        "Lorenzo Colitti" <lorenzo@google.com>,
        "Hideaki Yoshifuji" <hideaki.yoshifuji@miraclelinux.com>
Subject: Re: [PATCH RFC v1 2/3] ipv6: move from sha1 to blake2s in address calculation
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Fri, Jan 14, 2022, at 17:07, Jason A. Donenfeld wrote:
> On Thu, Jan 13, 2022 at 12:15 PM Hannes Frederic Sowa
> <hannes@stressinduktion.org> wrote:
>> > I'm not even so sure that's true. That was my worry at first, but
>> > actually, looking at this more closely, DAD means that the address can
>> > be changed anyway - a byte counter is hashed in - so there's no
>> > guarantee there.
>>
>> The duplicate address detection counter is a way to merely provide basic
>> network connectivity in case of duplicate addresses on the network
>> (maybe some kind misconfiguration or L2 attack). Such detected addresses
>> would show up in the kernel log and an administrator should investigate
>> and clean up the situation.
>
> I don't mean to belabor a point where I'm likely wrong anyway, but
> this DAD business has kept me thinking...
>
> Attacker is hanging out on the network sending DAD responses, forcing
> those counters to increment, and thus making SHA1(stuff || counter)
> result in a different IPv6 address than usual. Outcomes:
> 1) The administrator cannot handle this, did not understand the
> semantics of this address generation feature, and will now have a
> broken network;
> 2) The administrator knows what he's doing, and will be able to handle
> a different IPv6 address coming up.
>
> Do we really care about case (1)? That sounds like emacs spacebar
> heating https://xkcd.com/1172/. And case (2) seems like something that
> would tolerate us changing the hash function.

Taking a step back, there is the base case where we don't have duplicate
addresses on the network nor an attack is on-going. We would break those
setups with that patch. And those are the ones that matter most. In
particular those stable-random addresses are being used in router
advertisements for announcing the next-hop/default gateway on the
broadcast domain. During my time in IPv6 land I have seen lots of setups
where those automatic advertisements got converted into static
configuration for the sake of getting hands on a cool looking IPv6
address on another host (I did that as well ;) ). In particular, in the
last example, you might not only have one administrator at hand to
handle the issue, but probably multiple roles are involved (host admin
and network admin maybe from different organizations - how annoying -
but that's a worst case scenario).

Furthermore most L2 attacks nowadays are stopped by smarter switches or
wifi access points(?) anyway with per-port MAC learning and other
hardening features. Obviously this only happens in more managed
environments but probably already also at smaller home networks
nowadays. Datacenters probably already limit access to the Layer 2 raw
network in such a way that this attack is probably not possible either.
Same for IoT stuff where you probably have a point-to-point IPv6
connection anyway.

The worst case scenario is someone upgrading their kernel during a
trip away from home, rebooting, and losing access to their system. If we
experience just one of those cases we have violated Linux strict uAPI
rules (in my opinion). Thus, yes, we care about both, (1) and (2) cases.

I don't think we can argue our way out of this by stating that there are
no guarantees anyway, as much as I would like to change the hash
function as well.

As much as I know about the problems with SHA1 and would like to see it
removed from the kernel as well, I fear that in this case it seems hard
to do. I would propose putting sha1 into a compilation unit and
overwrite the compiler flags to optimize the function optimized for size
and maybe add another mode or knob to switch the hashing algorithm if
necessary.

>> Afterwards bringing the interface down and
>> up again should revert the interface to its initial (dad_counter == 0)
>> address.
>
> Except the attacker is still on the network, and the administrator
> can't figure it out because the mac addresses keep changing and it's
> arriving from seemingly random switches! Plot twist: the attack is
> being conducted from an implant in the switch firmware. There are a
> lot of creative different takes on the same basic scenario. The point
> is - the administrator really _can't_ rely on the address always being
> the same, because it's simply out of his control.

This is a very pessimistic scenario bordering a nightmare. I hope the
new hashing algorithm will protect them. ;)

> Given that the admin already *must* be prepared for the address to
> change, doesn't that give us some leeway to change the algorithm used
> between kernels?
>
> Or to put it differently, are there _actually_ braindead deployments
> out there that truly rely on the address never ever changing, and
> should we be going out of our way to support what is arguably a
> misreading and misdeployment of the feature?

Given the example above, users might hardcode this generated IP address
as a default gateway in their configs on other hosts. This is actually a
very common thing to do.

> (Feel free to smack this line of argumentation down if you disagree. I
> just thought it should be a bit more thoroughly explored.)

I haven't investigated recent research into breakage of SHA1, I mostly
remember the chosen-image and collision attacks against it. Given the
particular usage of SHA1 in this case, do you think switching the
hashing function increases security? I am asking because of the desire
to decrease the instruction size of the kernel, but adding a switch
will actually increase the size in the foreseeable future (and I agree
with Toke that offloading this decision to distributions is probably
not fair).

Maybe at some point the networking subsystem will adapt a generic knob
like LD_ASSUME_KERNEL? ;)

Bye,
Hannes
