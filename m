Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35FEC314713
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 04:30:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230490AbhBIDaA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 22:30:00 -0500
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:33779 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230491AbhBIDZs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 22:25:48 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailnew.nyi.internal (Postfix) with ESMTP id 8DDFF58015A;
        Mon,  8 Feb 2021 22:24:31 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Mon, 08 Feb 2021 22:24:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sholland.org; h=
        to:cc:references:from:subject:message-id:date:mime-version
        :in-reply-to:content-type:content-transfer-encoding; s=fm1; bh=4
        DiscTR6+K04v5pQyWV0iTVaBBWAg9lBcNkZsN81LHA=; b=F88+D0aHTMKL++WnJ
        //N/yaD06mgxOst6EWNCoy54TfJiTwiEgNTkoIaXHJbxWinTfy0agykHsbZj0+6C
        dSisvfGKwcqoVSW7zk0sL+fjnnb/ZZcQiAg5DG0LHTtLzuXFLBaakdmBAD7aQOAi
        jUhRjIic6Rau8bphEVExAl3v2rNp5AayWl7cvKdzoSZzQ4xBkgFxK+1SAW6LPZ4D
        QiiWmt2n3OdFCqerz1YPEAADpTIR1V1IgUYcMcgRHsAf6rYVrH4YIK/66eA8EH5V
        x0pxbFstD4EFqJXK/bf5GwRT49dXF5WRL6gDcvoP8G1zXOs9hJxdR4Y+xaQjxUyr
        AZBAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; bh=4DiscTR6+K04v5pQyWV0iTVaBBWAg9lBcNkZsN81L
        HA=; b=bfP1WHpoS9jpHZpGxcwwvDuyDOE0Q0Ip6tGyfjnNgUcVzY7Cg2lYtU6cm
        mp19CLQQ9Qe/Z/oFt6z/xCbqkb0dFx8b5bVhPhT6py96z01HLu//3RLO5Ur3GC1M
        OOrlZOTfoh2bva8nZyMQXCbn4Al0mPZO2/5yNP1+5yq1xVR1bznaIk+Wq4KBU2YR
        iVt2wkdiERMJTKsd8iA310Svci6QTsSIxIuFwhI6xmcoUDjJW3DgNAUAHPOddUnQ
        P1A5DFWXbtPq87/1IU+05HWslDCLFuVkQ8onfd14kFxQYwgY1no/t/0/tIU/kHL7
        zwHKVprFmX8AGPQVOHMJNVuR7ogJg==
X-ME-Sender: <xms:bAAiYF8sSjpbKske3vQajbBr6qA8JEdW-kJvk5-C1EiYjK_jLqLaOw>
    <xme:bAAiYJta_AaZoswPFy-lnayPaYA1hE9-fsRlR2BZ1jlOheUq2uFdVPbqUiFFq5vyh
    dCqVPWxvk061xaXdw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrheeggdeitdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefvfhfhuffkffgfgggjtgfgsehtkeertddtfeejnecuhfhrohhmpefurghmuhgv
    lhcujfholhhlrghnugcuoehsrghmuhgvlhesshhhohhllhgrnhgurdhorhhgqeenucggtf
    frrghtthgvrhhnpedvtddtjeeiuddugfffveetkeffgeffgedutdfgfeekudevudekffeh
    tdefveeuvdenucfkphepjedtrddufeehrddugeekrdduhedunecuvehluhhsthgvrhfuih
    iivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepshgrmhhuvghlsehshhholhhlrghn
    ugdrohhrgh
X-ME-Proxy: <xmx:bAAiYDAuHpuZZVxPKPthg6F3SeWur-6CxPno1t-VZOwd3sQDcj2y7w>
    <xmx:bAAiYJc2fKISPusaS96w3h7-QG2ZXtHtNkUC4JNFMc3MkLE1N-KoIQ>
    <xmx:bAAiYKOsZkkkBJ9yFI6EMBQUS9UVoYLb-FrMBMBNIBnYFtEk35ZS5Q>
    <xmx:bwAiYGniK4t9kay0GE7FNrridH9vQMPR495wlPXoSh_4U9FXSs4a2w>
Received: from [70.135.148.151] (70-135-148-151.lightspeed.stlsmo.sbcglobal.net [70.135.148.151])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2FD4B240057;
        Mon,  8 Feb 2021 22:24:28 -0500 (EST)
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        Corentin Labbe <clabbe@baylibre.com>,
        Ondrej Jirman <megous@megous.com>,
        Netdev <netdev@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>, linux-sunxi@googlegroups.com
References: <20210208062859.11429-1-samuel@sholland.org>
 <20210208062859.11429-5-samuel@sholland.org>
 <CAKgT0Ue3GAWbjZcX7aFxuM-iY-Ga2E0JOTftUqPBQC_dEGz_Eg@mail.gmail.com>
From:   Samuel Holland <samuel@sholland.org>
Subject: Re: [PATCH net-next RESEND 3/5] net: stmmac: dwmac-sun8i: Use
 reset_control_reset
Message-ID: <b12c9e59-cb96-dd88-e2b7-31517bd0f63e@sholland.org>
Date:   Mon, 8 Feb 2021 21:24:27 -0600
User-Agent: Mozilla/5.0 (X11; Linux ppc64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <CAKgT0Ue3GAWbjZcX7aFxuM-iY-Ga2E0JOTftUqPBQC_dEGz_Eg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/8/21 10:29 AM, Alexander Duyck wrote:
> On Sun, Feb 7, 2021 at 10:32 PM Samuel Holland <samuel@sholland.org> wrote:
>>
>> Use the appropriate function instead of reimplementing it,
>> and update the error message to match the code.
>>
>> Reviewed-by: Chen-Yu Tsai <wens@csie.org>
>> Signed-off-by: Samuel Holland <samuel@sholland.org>
>> ---
>>  drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c | 6 ++----
>>  1 file changed, 2 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
>> index 3c3d0b99d3e8..0e8d88417251 100644
>> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
>> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
>> @@ -806,11 +806,9 @@ static int sun8i_dwmac_power_internal_phy(struct stmmac_priv *priv)
>>         /* Make sure the EPHY is properly reseted, as U-Boot may leave
>>          * it at deasserted state, and thus it may fail to reset EMAC.
>>          */
>> -       reset_control_assert(gmac->rst_ephy);
>> -
>> -       ret = reset_control_deassert(gmac->rst_ephy);
>> +       ret = reset_control_reset(gmac->rst_ephy);
>>         if (ret) {
>> -               dev_err(priv->device, "Cannot deassert internal phy\n");
>> +               dev_err(priv->device, "Cannot reset internal PHY\n");
>>                 clk_disable_unprepare(gmac->ephy_clk);
>>                 return ret;
>>         }
> 
> I'm assuming you have exclusive access to the phy and this isn't a
> shared line? Just wanting to confirm since the function call has the
> following comment in the header for the documentation.

Yes, this driver has exclusive access:

	gmac->rst_ephy = of_reset_control_get_exclusive(iphynode, NULL);

And this is a reset line for the Ethernet PHY inside the SoC, that as
far as I can tell is not shared with anything else.

>  * Consumers must not use reset_control_(de)assert on shared reset lines when
>  * reset_control_reset has been used.
>  *
> 
> If that is the case it might not hurt to add some documentation to
> your call to reset_control_reset here explaining that it is safe to do
> so since you have exclusive access.

I can expand the comment above this line for v2.

Cheers,
Samuel
