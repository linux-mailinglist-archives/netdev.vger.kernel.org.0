Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4149A312AC1
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 07:35:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbhBHGe1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 01:34:27 -0500
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:48175 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229725AbhBHGcg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 01:32:36 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailnew.nyi.internal (Postfix) with ESMTP id B22075801BA;
        Mon,  8 Feb 2021 01:31:35 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Mon, 08 Feb 2021 01:31:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sholland.org; h=
        subject:to:cc:references:from:message-id:date:mime-version
        :in-reply-to:content-type:content-transfer-encoding; s=fm1; bh=q
        yHgJypD7UyjQktxsd90zw6xmRVOTfop9RXXOGsXuwI=; b=klaYOGYQpnHUE8HUU
        sSSe247L3eQh6ZH3D9HaJX0SaJmHkahb4kg5TRnRxb80Ynq/GHTiO2vfBOPOoubr
        8CmJSWTGZu7doLCOcPn3eF1kA7QchCaapoUbwMe8facrpGxsNVZADWxJUhQb/z74
        kRmENA8oL4o/EIKAx4qB9MIDXMmNi0zlNFHvUIoy6bBCHvrSqfeoqEdOWHuNTl3Q
        0buG0oC2UQ8/WJAmM31Mc1UqWzmbyQTgyweVRwHfrTHiGTEWrFCI+3Iv5cCnJVyd
        yc8CQDfTXcAghThoDpaSQU4+FC5upvGUTFZlPoG2qwyzqE5eWSLvd2mc9hGY5/L5
        cyPuw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; bh=qyHgJypD7UyjQktxsd90zw6xmRVOTfop9RXXOGsXu
        wI=; b=VOCyJ4nTludCu2lPGjVWCJ5JJZjPWDhWKCahVTLJS0X2SNoyrnWLFtv1z
        KQyLkH9qMcz34GI2nyFHYyxgJZ3WilziW6dbtQhmNcVYbM5GRVRQbKW6DC2NpLNh
        3Lb8kZiCDk/OORkwlzyuRzDwNeyjiXRR2Wym3b1VN4CzsuZhFL/SrbcWPwHtKDW9
        FWUD4DIxz0lzttradaLVo02TMoiAaEFY6i0eerGKAo/an2dXSUk45UGuAJe+2qJw
        ZlCgeeczx4vX/6VcA56FWRF7KhIpFR+su0x9VhEGouyy+h20EuE9dPedAU/yiPx4
        UMrhbrzPYzft8MuLSWA33pdTwE9dQ==
X-ME-Sender: <xms:x9ogYOynww6tOC8NrNPy05rfT3KysiJ27m4bMZcCferNrHf6hhV9-w>
    <xme:x9ogYKSjss8887k49ijZX3Wt1tpwGA5tLoSrgqif5TAmQxpsOywWNGO6F8LbtOpxC
    O3zKehzAbDgDfFz2A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrhedvgdelgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefuvfhfhffkffgfgggjtgfgsehtjeertddtfeejnecuhfhrohhmpefurghmuhgv
    lhcujfholhhlrghnugcuoehsrghmuhgvlhesshhhohhllhgrnhgurdhorhhgqeenucggtf
    frrghtthgvrhhnpefgveffteelheffjeeukedvkedviedtheevgeefkeehueeiieeuteeu
    gfettdeggeenucfkphepjedtrddufeehrddugeekrdduhedunecuvehluhhsthgvrhfuih
    iivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepshgrmhhuvghlsehshhholhhlrghn
    ugdrohhrgh
X-ME-Proxy: <xmx:x9ogYAVdpfj7TsRuHs1E-mxO9xedS1trjuHvV0rAZRCW-QmpBwhFuA>
    <xmx:x9ogYEiFesu3NDomAFz3mCI_1ZaRzFCXokdFCfx9IDiI2jl86Qq5mQ>
    <xmx:x9ogYAA0jUHeLeKVJj9OlxLxf8RH1WIwMRHoKTtrWfzOyUnzK7MPcw>
    <xmx:x9ogYM4c_4N8gChxrZlEuymR1Eewfx6QWhcQa-jiK7gg0j-LkW6VJQ>
Received: from [70.135.148.151] (70-135-148-151.lightspeed.stlsmo.sbcglobal.net [70.135.148.151])
        by mail.messagingengine.com (Postfix) with ESMTPA id 010B0240057;
        Mon,  8 Feb 2021 01:31:34 -0500 (EST)
Subject: Re: [PATCH] i2c: mv64xxx: Fix check for missing clock
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        Corentin Labbe <clabbe@baylibre.com>
Cc:     Ondrej Jirman <megous@megous.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Dan Carpenter <dan.carpenter@oracle.com>
References: <20210208062859.11429-1-samuel@sholland.org>
 <20210208062859.11429-2-samuel@sholland.org>
From:   Samuel Holland <samuel@sholland.org>
Message-ID: <4f696b13-2475-49f2-5d75-f2120e159142@sholland.org>
Date:   Mon, 8 Feb 2021 00:31:34 -0600
User-Agent: Mozilla/5.0 (X11; Linux ppc64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20210208062859.11429-2-samuel@sholland.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/8/21 12:28 AM, Samuel Holland wrote:
> In commit e5c02cf54154 ("i2c: mv64xxx: Add runtime PM support"), error
> pointers to optional clocks were replaced by NULL to simplify the resume
> callback implementation. However, that commit missed that the IS_ERR
> check in mv64xxx_of_config should be replaced with a NULL check. As a
> result, the check always passes, even for an invalid device tree.

Sorry, please ignore this unrelated patch. I accidentally copied it to
the wrong directory before sending this series.

Samuel
