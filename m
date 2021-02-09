Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA0373146CE
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 04:09:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230434AbhBIDI2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 22:08:28 -0500
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:38183 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230378AbhBIDG4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 22:06:56 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailnew.nyi.internal (Postfix) with ESMTP id 198A758038B;
        Mon,  8 Feb 2021 22:05:59 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Mon, 08 Feb 2021 22:05:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sholland.org; h=
        subject:to:cc:references:from:message-id:date:mime-version
        :in-reply-to:content-type:content-transfer-encoding; s=fm1; bh=S
        QTtgGmciLhHr7f+yNhIRYmT08Y8Iv6gmaMDOv3wfcI=; b=V7lCacyBoUr0hg8LH
        eTp2hmbZRYfdatRlyeQeHDanemFeTVPLlK3OZ/YowYw58g3zfROB8FjDXwRDD54e
        0HKiwxG8V6mi/LU9B+4y3oJXM9PDzTxylmenXpDT2fzjV0AB5ZMZX2RVPfTuZ2it
        OHHH4eiZu40dAQKM5T/NdQMqrg4712zYfVNjTHMia14kobk202eTn4Th+5JL/qwa
        eGANQzniwA9teahTVY7VDt3oEXHdQ0kzkHdaxx7z/PJP7I1YZOjZvO2wwQfG1ip0
        lxiUYyxbeFvnADrkkDySVAi4w9JaQtrfjcB7coqKV+AuVkn7vAvfxKAJUa7ate3s
        zOeag==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; bh=SQTtgGmciLhHr7f+yNhIRYmT08Y8Iv6gmaMDOv3wf
        cI=; b=n1IaRnelAQq2jPuw4adO2tfFi/ouMLitKlleGHYF3XAeb5ws6O5gyxP3n
        QrG0d+2Q9TpJFZZVRZSYHj2xKEHxcrPWfmi6e+HsqaKtx9h15LOWeRw2+XFJK7x4
        HoRFpBp0d2K3dwT0IdMzUhcxZSvUSsOg2w6bKiBqkQYYPeWOpgoLHtxl+2NRb5il
        cdS+YZudhj0zWevqmo4goop/Z3Co+55vsOb2/H9AKb7xfCCKsc0JbAHc5xhifCDD
        C99/KfJkkeBJi7l5GK3Caco7NgIIM243uzPu23oLXJJc2jTbwxDlf6k7Efhyod2k
        XXjKAtW7WomOS9nmxZBANO3KTdfIw==
X-ME-Sender: <xms:E_whYDu5w0hPIBq2-d8Zbgifx_2HIHjo7Mvx8zbTJdit--PDFSTLbQ>
    <xme:E_whYEf8Ggift4aBcrgg0CRAw9GUdR_-D3prGqARijH_hRGJjSlPUA3LiN7nW-msz
    GfZptGPaC8H2gtNiw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrheeggdehhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefuvfhfhffkffgfgggjtgfgsehtjeertddtfeejnecuhfhrohhmpefurghmuhgv
    lhcujfholhhlrghnugcuoehsrghmuhgvlhesshhhohhllhgrnhgurdhorhhgqeenucggtf
    frrghtthgvrhhnpefffedvhfehhfekfeetieehfedtveduvdelieelgeettdefjefhjeek
    tdfftdejkeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeejtddrudefhe
    drudegkedrudehudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhl
    fhhrohhmpehsrghmuhgvlhesshhhohhllhgrnhgurdhorhhg
X-ME-Proxy: <xmx:E_whYGyM-cyq0uB7Rmq_xDKOBAGYrHGIh91MuWFbiDb_QWUXS20p6g>
    <xmx:E_whYCM-3dpF-eIzITffkW9slNmCLvHhPKuBn3zxlHe-TvshjyMZsg>
    <xmx:E_whYD-rjtRjtoF2Rsnolrw9-VftvrPKqpVOVEQxblzhMblG8nZbnA>
    <xmx:F_whYJdXi-OPS6CJbjKOwUL5v3on6B8M0W35q1q1EI4E8IyNnvTGnw>
Received: from [70.135.148.151] (70-135-148-151.lightspeed.stlsmo.sbcglobal.net [70.135.148.151])
        by mail.messagingengine.com (Postfix) with ESMTPA id 463CA24005E;
        Mon,  8 Feb 2021 22:05:55 -0500 (EST)
Subject: Re: [PATCH] i2c: mv64xxx: Fix check for missing clock
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        Corentin Labbe <clabbe@baylibre.com>,
        Ondrej Jirman <megous@megous.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Dan Carpenter <dan.carpenter@oracle.com>
References: <20210208062859.11429-1-samuel@sholland.org>
 <20210208062859.11429-2-samuel@sholland.org>
 <4f696b13-2475-49f2-5d75-f2120e159142@sholland.org>
 <YCE6qwwJngcZMjmn@lunn.ch>
From:   Samuel Holland <samuel@sholland.org>
Message-ID: <089df4b2-8cd5-187a-55cf-0e558858a7d1@sholland.org>
Date:   Mon, 8 Feb 2021 21:05:54 -0600
User-Agent: Mozilla/5.0 (X11; Linux ppc64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <YCE6qwwJngcZMjmn@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/8/21 7:20 AM, Andrew Lunn wrote:
> On Mon, Feb 08, 2021 at 12:31:34AM -0600, Samuel Holland wrote:
>> On 2/8/21 12:28 AM, Samuel Holland wrote:
>>> In commit e5c02cf54154 ("i2c: mv64xxx: Add runtime PM support"), error
>>> pointers to optional clocks were replaced by NULL to simplify the resume
>>> callback implementation. However, that commit missed that the IS_ERR
>>> check in mv64xxx_of_config should be replaced with a NULL check. As a
>>> result, the check always passes, even for an invalid device tree.
>>
>> Sorry, please ignore this unrelated patch. I accidentally copied it to
>> the wrong directory before sending this series.
> 
> Hi Samuel
> 
> This patch looks correct. But i don't see it in i2c/for-next, where as
> e5c02cf54154 is. I just want to make sure it does not get lost...

Thanks for the concern. I had already sent it separately[0], to the
appropriate maintainers, so this submission was a duplicate.

Cheers,
Samuel

[0]:
https://lore.kernel.org/lkml/20210208061922.10073-1-samuel@sholland.org/

> 	     Andrew
> 

