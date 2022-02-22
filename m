Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81C424BEF95
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 03:43:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232409AbiBVCa3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 21:30:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231964AbiBVCa3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 21:30:29 -0500
Received: from new3-smtp.messagingengine.com (new3-smtp.messagingengine.com [66.111.4.229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1EED25C5E
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 18:30:03 -0800 (PST)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailnew.nyi.internal (Postfix) with ESMTP id 2254C580227;
        Mon, 21 Feb 2022 21:30:03 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Mon, 21 Feb 2022 21:30:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sholland.org; h=
        cc:cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm2; bh=/8S1Wc9bV2nrcu
        qcs6VRKxl+PEyUlE5qF6c1SHRXrZo=; b=spQu2M/ZvxdbNqz6dYMK9oUz+Frbzp
        yGMqPd/MA8VKnT/0JOgokXS3iGM4bXMKZvJNmCe2UndZJgwUPmSvYnSf/2ZV0Fls
        wCF3FH4pL9Ru3/nDRyT89D6m0fLNymUbQSyg6JFXZnLXuwAn8o0pxPL5jMct3Sve
        cl/63zqS2dL2DfwQPJ+aZ/0AQR4jjuEIHJp5rqoAFguaAQSHyTyspyeCMvN4ZeAV
        qHZncNazFn+yF6qd6DSqYvTtzoQfSLlVuxY8L9nMp8uKJjrf0bYxW010CnaqH4pK
        NxyQI3opGR3IrdD2Wn92I95eaBSHUpPctuOdiblRO7dzpDpZuwEIA4Sg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; bh=/8S1Wc9bV2nrcuqcs6VRKxl+PEyUlE5qF6c1SHRXr
        Zo=; b=bxyub//zayf2zVNLEuw54dR//7BQMDaWpYgrP4zdDLpOsIwGNc58tQPmy
        3LszycA7nOvFITiDfy+OcMZBLHEPvkSg15KhlG4OyT5vop63jUeZewh+lq3fjqqg
        BXz33voSW172kZmn0pR0wy3QdmnpUr5eiZlBvDaFdV73N9EijJUVxzjVTQ3mYyD+
        lTY23naGz2vfO/8zjO3kbghJWT/jH8jBS2Qiv951CxjdBauAKkR/Jpw+inbvdn8f
        xrP3sz+C7kR7ZIrRNo5Ajq+zlh/Npe0N12gyoGo0kujfFDBzQZTge1+woql2GtKa
        FeqWgTN1WuP65WYeVTh3eUUZLbmaQ==
X-ME-Sender: <xms:qkoUYsuSkt-5mMes4ZoE0H_pKiOB0iMtnWCEE5v_WwoyridnL-RXbg>
    <xme:qkoUYpf-ZIYjreUw2gZYVc2DqHt-I1od_wbv9S6RjZG340LYe9dB6YH_3zt6cBYAm
    1UNaC3NavMDivX5Gg>
X-ME-Received: <xmr:qkoUYnxoUJLAZECLmXTwq5yJSmzqxOyf0ctV5AsCoQHExlFwO28TB3wa7bL4mKZzOY5suWMCMW2jXZdK5LC_hLLRfPHpKqGy5cmAnv9zWGMQTTkrVDWnis-WEA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrkeejgdegiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefuvfhfhffkffgfgggjtgfgsehtjeertddtfeejnecuhfhrohhmpefurghmuhgv
    lhcujfholhhlrghnugcuoehsrghmuhgvlhesshhhohhllhgrnhgurdhorhhgqeenucggtf
    frrghtthgvrhhnpedtjeetveejleegjeeggeetgeeuleevtedvgeefudevtddtveevgfdu
    uedugfduieenucffohhmrghinhepfhhrvggvuggvshhkthhophdrohhrghenucevlhhush
    htvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehsrghmuhgvlhesshhh
    ohhllhgrnhgurdhorhhg
X-ME-Proxy: <xmx:qkoUYvNQT6lFUp3C6x266q_8oAOdo5NPsJt4mSyzV-76apbUujQBJw>
    <xmx:qkoUYs-Nx-9LPTvxnducYqXaL5tHfvRltAMGyAhhg-KfaAvrutADyw>
    <xmx:qkoUYnX3GR_bhPkiv7IntnNjBCDQ6gwKAvxMripCDhL2_h5s6rLL_A>
    <xmx:q0oUYt0x-eLj3IO72-wJbQUa6EOjEa3bALAwRNiPiLfeAZOzcSCKOg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 21 Feb 2022 21:30:01 -0500 (EST)
Subject: Re: net: stmmac: dwmac-meson8b: interface sometimes does not come up
 at boot
To:     Erico Nunes <nunes.erico@gmail.com>,
        Jerome Brunet <jbrunet@baylibre.com>
Cc:     Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        linux-amlogic@lists.infradead.org, netdev@vger.kernel.org,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        linux-sunxi@lists.linux.dev
References: <CAK4VdL3-BEBzgVXTMejrAmDjOorvoGDBZ14UFrDrKxVEMD2Zjg@mail.gmail.com>
 <1jczjzt05k.fsf@starbuckisacylon.baylibre.com>
 <CAK4VdL2=1ibpzMRJ97m02AiGD7_sN++F3SCKn6MyKRZX_nhm=g@mail.gmail.com>
From:   Samuel Holland <samuel@sholland.org>
Message-ID: <fc31b5ea-3fb4-e394-cded-f45f7d3732f3@sholland.org>
Date:   Mon, 21 Feb 2022 20:30:00 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CAK4VdL2=1ibpzMRJ97m02AiGD7_sN++F3SCKn6MyKRZX_nhm=g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/20/22 10:51 AM, Erico Nunes wrote:
> On Mon, Feb 7, 2022 at 11:56 AM Jerome Brunet <jbrunet@baylibre.com> wrote:
>>
>>
>> On Wed 02 Feb 2022 at 21:18, Erico Nunes <nunes.erico@gmail.com> wrote:
>>
>>> Hello,
>>>
>>> I've been tracking down an issue with network interfaces from
>>> meson8b-dwmac sometimes not coming up properly at boot.
>>> The target systems are AML-S805X-CC boards (Amlogic S805X SoC), I have
>>> a group of them as part of a CI test farm that uses nfsroot.
>>>
>>> After hopefully ruling out potential platform/firmware and network
>>> issues I managed to bisect this commit in the kernel to make a big
>>> difference:
>>>
>>>   46f69ded988d2311e3be2e4c3898fc0edd7e6c5a net: stmmac: Use resolved
>>> link config in mac_link_up()
>>>
>>> With a kernel before that commit, I am able to submit hundreds of test
>>> jobs and the boards always start the network interface properly.
>>>
>>> After that commit, around 30% of the jobs start hitting this:
>>>
>>>   [    2.178078] meson8b-dwmac c9410000.ethernet eth0: PHY
>>> [0.e40908ff:08] driver [Meson GXL Internal PHY] (irq=48)
>>>   [    2.183505] meson8b-dwmac c9410000.ethernet eth0: Register
>>> MEM_TYPE_PAGE_POOL RxQ-0
>>>   [    2.200784] meson8b-dwmac c9410000.ethernet eth0: No Safety
>>> Features support found
>>>   [    2.202713] meson8b-dwmac c9410000.ethernet eth0: PTP not supported by HW
>>>   [    2.209825] meson8b-dwmac c9410000.ethernet eth0: configuring for
>>> phy/rmii link mode
>>>   [    3.762108] meson8b-dwmac c9410000.ethernet eth0: Link is Up -
>>> 100Mbps/Full - flow control off
>>>   [    3.783162] Sending DHCP requests ...... timed out!
>>>   [   93.680402] meson8b-dwmac c9410000.ethernet eth0: Link is Down
>>>   [   93.685712] IP-Config: Retrying forever (NFS root)...
>>>   [   93.756540] meson8b-dwmac c9410000.ethernet eth0: PHY
>>> [0.e40908ff:08] driver [Meson GXL Internal PHY] (irq=48)
>>>   [   93.763266] meson8b-dwmac c9410000.ethernet eth0: Register
>>> MEM_TYPE_PAGE_POOL RxQ-0
>>>   [   93.779340] meson8b-dwmac c9410000.ethernet eth0: No Safety
>>> Features support found
>>>   [   93.781336] meson8b-dwmac c9410000.ethernet eth0: PTP not supported by HW
>>>   [   93.788088] meson8b-dwmac c9410000.ethernet eth0: configuring for
>>> phy/rmii link mode
>>>   [   93.807459] random: fast init done
>>>   [   95.353076] meson8b-dwmac c9410000.ethernet eth0: Link is Up -
>>> 100Mbps/Full - flow control off
>>>
>>> This still happens with a kernel from master, currently 5.17-rc2 (less
>>> frequently but still often hit by CI test jobs).
>>> The jobs still usually get to work after restarting the interface a
>>> couple of times, but sometimes it takes 3-4 attempts.
>>>
>>> Here is one example and full dmesg:
>>> https://gitlab.freedesktop.org/enunes/mesa/-/jobs/16452399/raw
>>>
>>> Note that DHCP does not seem to be an issue here, besides the fact
>>> that the problem only happens since the mentioned commit under the
>>> same setup, I did try to set up the boards to use a static ip but then
>>> the interfaces just don't communicate at all from boot.
>>>
>>> For test purposes I attempted to revert
>>> 46f69ded988d2311e3be2e4c3898fc0edd7e6c5a on top of master but that
>>> does not apply trivially anymore, and by trying to revert it manually
>>> I haven't been able to get a working interface.
>>>
>>> Any advice on how to further debug or fix this?
>>
>> Hi Erico,
>>
>> Thanks a lot for digging into this topic.
>> I'm seeing exactly the same behavior on the g12 based khadas-vim3:
>>
>> * Boot stalled waiting for DHCP - with an NFS based filesystem
>> * Every minute, the network driver gets a reset and try again
>>
>> Sometimes it works on the first attempt, sometimes it takes up to 5
>> attempts. Eventually, it reaches the prompt which might be why it went
>> unnoticed so far.
>>
>> I think that NFS just makes the problem easier to see.
>> On devices with an eMMC based filesystem, I noticed that, sometimes, I
>> had unplug/plug the ethernet cable to make it go.
>>
>> So far, the problem is reported on all the Amlogic SoC generation we
>> support. I think a way forward is to ask the the other users of
>> stmmac whether they have this problem or not - adding Allwinner and
>> Rockchip ML.
>>
>> Since the commit you have identified is in the generic part of the
>> stmmac code, Maybe Jose can help us understand what is going on.
> 
> Hi all,
> 
> thanks for the feedback so far, good to know that this is not only on
> my board farm.
> 
> Any more feedback about this from the people in cc?

The commit in question appears to have been merged in v5.7. I have been using
kernels newer than that (including up to v5.17-rc) on various Allwinner
platforms -- A64, H3, H6, D1 -- and I have not seen anything similar. I also
don't remember seeing reports of others having Ethernet issues at boot on
Allwinner boards either.

The only issue that's come up recently for us was related to runtime PM, but
that issue was traced to a commit a year later than the one you referenced here
(5ec55823438e).

Regards,
Samuel
