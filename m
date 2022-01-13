Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EE8F48D688
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 12:15:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234065AbiAMLPq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 06:15:46 -0500
Received: from wnew2-smtp.messagingengine.com ([64.147.123.27]:54451 "EHLO
        wnew2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229670AbiAMLPm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 06:15:42 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailnew.west.internal (Postfix) with ESMTP id BE7292B002A5;
        Thu, 13 Jan 2022 06:15:40 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Thu, 13 Jan 2022 06:15:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        stressinduktion.org; h=message-id:date:mime-version:to:cc
        :references:from:subject:in-reply-to:content-type
        :content-transfer-encoding; s=fm2; bh=BFxJhU9E/D7kynUv0MHH4ibjf/
        VNb2cjiy4UK//QHKU=; b=d+8DLM+IPsUA5YdAZffnOu95gVa2pMIzICDvNl10Yj
        AYwa+pM3TLE/7nMdMN8Fh6AgwQwgzpVKcB17Q5euQh82ZHKkFRZGk/89eNLqq333
        SDfiiPivUHJIHMmxOREbf8Za1huiR1etMbL2yQ4rdj7yQQkm6W1BvwjwWHOLWvLV
        FMkULZoq3bx2Gd/vym+QdMUi1L6LriJ8goCwaZzGP07g2VfeD7iAlDqq6z2uUBte
        peVal0PPW2BtxlFlSuUN6VPXAkVn+yW6igj3HwtpiwU4G2QGrguRiKS55vRX1PA7
        vzQQk8PfIsiLfSNct6PcZK4v6mzx+3Bes6yaM18W6Tvw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=BFxJhU9E/D7kynUv0MHH4ibjf/VNb2cjiy4UK//QH
        KU=; b=WWcfCNoFgzHCHhShbJ4DPw4PZzWmIRKySnfX060o/LIWbs2FREKoggQb3
        sq2c6xFKZH052aASKAv8bj3GbiRgit28c+z6dTR/6dQZUSSy9fzZKmcT5s3W1t22
        waGXz6IM9K9UTzHOCVl4Yg7FBxn26x4NQ7xjGw9MmRB45qmgW5fGCcIczBY+0PId
        M/QiYILmrKFgepChbSeIwArruDcK1cQl+gAwqk07HM6qEGPUnPoeuIbPGl8P1LZl
        gv5lw8KV4PmN2mu/GEaXWhV9dOjfDVTO8N/fm0VPRbRirYbBbvkQtYwpSRPNa7EW
        ldK/uKBiCLSoOiZ4fLKZumo0p9Hdg==
X-ME-Sender: <xms:2gngYa1zfmq2yC-KiPTpZshdY5jExC4qXQbEv4UebGvh415prVJ-sw>
    <xme:2gngYdHKNuWPgj_k3SJgw07NazYRL_5-f3sUNAjAbC9JUef1HPkQYncAUs8UaTQ9a
    nbJ9czGCCM_DX8OUg>
X-ME-Received: <xmr:2gngYS55mAA1vnvvgEuFN8saBJzco4gUu7kbsMyAmsUhrg9RPy4RcIYKfrIQXCTqD4C5I0IfyFnmLZ9Hud91MlI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrtdefgddvgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefkffggfgfvfhfhufgjtgfgsehtkeertddtfeejnecuhfhrohhmpefjrghnnhgv
    shcuhfhrvgguvghrihgtucfuohifrgcuoehhrghnnhgvshesshhtrhgvshhsihhnughukh
    htihhonhdrohhrgheqnecuggftrfgrthhtvghrnhepkeehieekfeetueeuteelgedttddu
    veejueffvddthedthfejieeuieegkefhffffnecuffhomhgrihhnpeiigidvtgegrdgtoh
    hmnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhephhgr
    nhhnvghssehsthhrvghsshhinhguuhhkthhiohhnrdhorhhg
X-ME-Proxy: <xmx:2gngYb1YFh3ygjka2ZEb0iwHP5Fjz-5kSY5F60NFkYVCXMUrWJ4Wtg>
    <xmx:2gngYdFavWakDFC22laYtbnaZ2LMhVNWKDG15dhbX-he-bpycTgf9Q>
    <xmx:2gngYU8NylXolvo_M5eHgoFTUcgA8--XFkGDLxpBp5X_mcgaW080RA>
    <xmx:3AngYc8RykLem542incJQvZY3icSGdsnMluop3JO5hEoi5Ogwm2YTXrVcxI>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 13 Jan 2022 06:15:37 -0500 (EST)
Message-ID: <55d185a8-31ea-51d0-d9be-debd490cd204@stressinduktion.org>
Date:   Thu, 13 Jan 2022 12:15:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Content-Language: en-US
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ardb@kernel.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        linux-crypto@vger.kernel.org, Erik Kline <ek@google.com>,
        Fernando Gont <fgont@si6networks.com>,
        Lorenzo Colitti <lorenzo@google.com>,
        hideaki.yoshifuji@miraclelinux.com
References: <20220112131204.800307-1-Jason@zx2c4.com>
 <20220112131204.800307-3-Jason@zx2c4.com> <87r19cftbr.fsf@toke.dk>
 <CAHmME9pieaBBhKc1uKABjTmeKAL_t-CZa_WjCVnUr_Y1_D7A0g@mail.gmail.com>
From:   Hannes Frederic Sowa <hannes@stressinduktion.org>
Subject: Re: [PATCH RFC v1 2/3] ipv6: move from sha1 to blake2s in address
 calculation
In-Reply-To: <CAHmME9pieaBBhKc1uKABjTmeKAL_t-CZa_WjCVnUr_Y1_D7A0g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On 13.01.22 00:31, Jason A. Donenfeld wrote:
> On 1/13/22, Toke Høiland-Jørgensen <toke@redhat.com> wrote:
>> However, if we make this change, systems setting a stable_secret and
>> using addr_gen_mode 2 or 3 will come up with a completely different
>> address after a kernel upgrade. Which would be bad for any operator
>> expecting to be able to find their machine again after a reboot,
>> especially if it is accessed remotely.
>>
>> I haven't ever used this feature myself, though, or seen it in use. So I
>> don't know if this is purely a theoretical concern, or if the
>> stable_address feature is actually used in this way in practice. If it
>> is, I guess the switch would have to be opt-in, which kinda defeats the
>> purpose, no (i.e., we'd have to keep the SHA1 code around

Yes, it is hard to tell if such a change would have real world impact 
due to not knowing its actual usage in the field - but I would avoid 
such a change. The reason for this standard is to have stable addresses 
across reboots. The standard is widely used but most servers or desktops 
might get their stable privacy addresses being generated by user space 
network management systems (NetworkManager/networkd) nowadays. I would 
guess it could be used in embedded installations.

The impact of this change could be annoying though: users could suddenly 
lose connectivity due to e.g. changes to the default gateway after an 
upgrade.

> I'm not even so sure that's true. That was my worry at first, but
> actually, looking at this more closely, DAD means that the address can
> be changed anyway - a byte counter is hashed in - so there's no
> gurantee there.

The duplicate address detection counter is a way to merely provide basic 
network connectivity in case of duplicate addresses on the network 
(maybe some kind misconfiguration or L2 attack). Such detected addresses 
would show up in the kernel log and an administrator should investigate 
and clean up the situation. Afterwards bringing the interface down and 
up again should revert the interface to its initial (dad_counter == 0) 
address.

> There's also the other aspect that open coding sha1_transform like
> this and prepending it with the secret (rather than a better
> construction) isn't so great... Take a look at the latest version of
> this in my branch to see a really nice simplification and security
> improvement:
> 
> https://git.zx2c4.com/linux-dev/log/?h=remove-sha1

All in all, I consider the hash produced here as being part of uAPI 
unfortunately and thus cannot be changed. It is unfortunate that it 
can't easily be improved (I assume a separate mode for this is not 
reasonable). The patches definitely look like a nice cleanup.

Would this be the only user of sha_transform left?

Bye,
Hannes
