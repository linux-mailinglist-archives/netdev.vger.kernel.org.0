Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41C5F654583
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 18:14:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230156AbiLVROU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 12:14:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbiLVROS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 12:14:18 -0500
Received: from wout4-smtp.messagingengine.com (wout4-smtp.messagingengine.com [64.147.123.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A61282936F;
        Thu, 22 Dec 2022 09:14:14 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id AB2DE32005B5;
        Thu, 22 Dec 2022 12:14:10 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Thu, 22 Dec 2022 12:14:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pjd.dev; h=cc:cc
        :content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm3; t=1671729250; x=
        1671815650; bh=RFhIMVVYEJyZrg3KvPJDbUDKPowMN311ENUpMjdGKVw=; b=h
        zsCph7hZzV/cGHf/Hm9Q1s0+gxEFnBH2NN7ELW/yFAPA5bMzgluoxOIv+USst2/A
        99R2eEh7zQXg2tl2o6wWF+2D9K8yGUv5Z8R1Byzwq83g61HllDJFkDlN1uNzjXq8
        f3HCrisf2siUqX4Gq5Gg7dRhxeI+Fbi5XT6Qrz+psASyOE3u4+XSIJyTHl6wSeyR
        WXvTplieVT4Tbdn3TDeeO/MIFU/EOSwFXC7KnyJc5zvY/vDUxH9a59K1JT9hBruy
        K4jMTiVOykeJT/R7OwC7SiHxXCimA8mXRn19SF7WmsMWsxpUAHgXJCt8XzkbifSX
        4fTwmdwG+M+b/GODWJ/OA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1671729250; x=
        1671815650; bh=RFhIMVVYEJyZrg3KvPJDbUDKPowMN311ENUpMjdGKVw=; b=V
        5fHBXKKmFl0vih+esuI0x2zoyOLP/ZrRaAhrdpvuRhmbKdjvOFnNEgo1R2+hXBCX
        BO05kSiZrzAMXSFOt4Iqc224bszsWw0s+SVBfmTk+RqV3iDeMIuh/fqAdMinX6Fg
        yBzVpztiJoEDkfZMdRy488tAIUn/j6qg/H6b+ZrGHjNf2lYsFnl3HLBqJZQcGOk+
        AYjqk9XNs1hlX3A+Rt2ZBFB9dulDuIhRWQZLbocLNM2t9kqBLdhoMKK2fgSrxWeR
        KRbzayF8lwhmdCT/RWst6Z3csBbbyXIWbXcqYGuZvI+FP4V3yfkFV6CJkJk/Axat
        vtCnr5wQgAoWgxptE6wNQ==
X-ME-Sender: <xms:YZCkY0_H3tn4tE9BiL7Zc46G1Qj2Y163yaBUdx6vfM_j9fg23kfu6A>
    <xme:YZCkY8vytXEVAnNny5Ge9qHtf8xQHTDAdkSHIcJ_AY-SMfknX6vtG_k7roWrJmX_Y
    VEoTJoSd-uRCj0Yc30>
X-ME-Received: <xmr:YZCkY6AaH7cJ03sXNfbVwJPB9r4BwKUALQXVNwuY0TVjl7jjiWBQg0Aw5kKerB7cprtmSAK_ldiOZDFA998ellMkxZd85L_5kUqV>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrhedtgddutddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurheptgfghfggufffkfhfvegjvffosehtqhhmtdhhtdejnecuhfhrohhmpefrvght
    vghrucffvghlvghvohhrhigrshcuoehpvghtvghrsehpjhgurdguvghvqeenucggtffrrg
    htthgvrhhnpeeuvdeukedtkefhhfevheffudekfeffvdehheekueefjefhudefvefgueek
    teelteenucffohhmrghinhepughmthhfrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomhepphgvthgvrhesphhjugdruggvvh
X-ME-Proxy: <xmx:YZCkY0eCjXrkxa2KCEuKXyryg3I7BEbAcPsXizAPZh4CFy8ECMRfJw>
    <xmx:YZCkY5MGBDmFOShF_D8_J33yzjSjTi1SvjtZA46A91MJi9gVVZTdNw>
    <xmx:YZCkY-l6Ce-T3ETSWMHDm4Z-52wKML7_ZRjEBTGRdjUR7KK2ABaR3w>
    <xmx:YpCkY8fFfWEFiT8h2vLHAU-Xc4GK5ITydqasD0hECtcKsGUotOEeBg>
Feedback-ID: i9e814621:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 22 Dec 2022 12:14:09 -0500 (EST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Peter Delevoryas <peter@pjd.dev>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH 0/3] net/ncsi: Add NC-SI 1.2 Get MC MAC Address command
Date:   Thu, 22 Dec 2022 09:13:57 -0800
Message-Id: <9D98FD36-FA3B-4C9C-A470-69A52FD80677@pjd.dev>
References: <8a0a90511222d3161bfe2984f6b14f82206b8930.camel@redhat.com>
Cc:     sam@mendozajonas.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, joel@jms.id.au, gwshan@linux.vnet.ibm.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <8a0a90511222d3161bfe2984f6b14f82206b8930.camel@redhat.com>
To:     Paolo Abeni <pabeni@redhat.com>
X-Mailer: iPhone Mail (20B110)
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Dec 22, 2022, at 2:44 AM, Paolo Abeni <pabeni@redhat.com> wrote:
>=20
> =EF=BB=BFOn Tue, 2022-12-20 at 21:22 -0800, Peter Delevoryas wrote:
>> NC-SI 1.2 isn't officially released yet, but the DMTF takes way too long
>> to finalize stuff, and there's hardware out there that actually supports
>> this command (Just the Broadcom 200G NIC afaik).
>>=20
>> The work in progress spec document is here:
>>=20
>> https://www.dmtf.org/sites/default/files/standards/documents/DSP0222_1.2W=
IP90_0.pdf
>>=20
>> The command code is 0x58, the command has no data, and the response
>> returns a variable-length array of MAC addresses for the BMC.
>>=20
>> I've tested this out using QEMU emulation (I added the Mellanox OEM Get
>> MAC Address command to libslirp a while ago [1], although the QEMU code
>> to use it is still not in upstream QEMU [2] [3]. I worked on some more
>> emulation code for this as well), and on the new Broadcom 200G NIC.
>>=20
>> The Nvidia ConnectX-7 NIC doesn't support NC-SI 1.2 yet afaik. Neither
>> do older versions in newer firmware, they all just report NC-SI 1.1.
>>=20
>> Let me know what I can do to change this patch to be more suitable for
>> upstreaming, I'm happy to work on it more!
>=20
> This series is targeting the net-next tree, you should include such tag
> into the patch subjected.
>=20
> We have already submitted the networking pull request to Linus
> for v6.2 and therefore net-next is closed for new drivers, features,
> code refactoring and optimizations. We are currently accepting
> bug fixes only.
> Please repost when net-next reopens after Jan 2nd.

I see, thanks, I=E2=80=99ll resubmit later.

>=20
> RFC patches sent for review only are obviously welcome at any time.

Oh good point, I should have submitted it as an RFC.

>=20
> Thanks,
>=20
> Paolo
>=20

