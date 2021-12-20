Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BC9747A803
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 11:56:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230004AbhLTK4n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 05:56:43 -0500
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:40161 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229619AbhLTK4m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 05:56:42 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id 690E3580181;
        Mon, 20 Dec 2021 05:56:41 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 20 Dec 2021 05:56:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=9AcYE0yu0KZhD7v7tPxMpIY4EGh
        I9m76hau90FdriAM=; b=HoCN2BIqhNywUybo+xIOXPLbX7P84T+CYEmLAZOIKJ9
        c83H7+kqtlp3Nx3E+/deJu+Qjke34mCR78u6odtJbdUEvOoSoaAnKi3vUV3kpHuL
        AY4Ead3yT/T1KRFXsgJn3mR1v5+z4Bx8IkYfoSGc9/BDfBvdihPBq18JeQmkXlyP
        N1i7BO1m0cNOXYWAthpiMe/R9G09OjMeEJ7OgugAYpxEhs56PEUITrK/a7vWWbeJ
        Oqp1qf2MLSHGLX74/Q7xtYUVUnZbFfn+SKw4mmN1AJWNQbYz732CzQGdw7tUnOiP
        iM6KUNcjWxuE/Aq2NYKUGKCFvCbHN1LMFg863XUrq8g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=9AcYE0
        yu0KZhD7v7tPxMpIY4EGhI9m76hau90FdriAM=; b=Rk5L5LcXg1bgmarW4jCPdP
        rvyJnMYqy5LpgpCwgZgWG+hRL6ADmLR/MfWsD8k9aBB7RtImv55MqZ7Y4F8vuTx5
        NKFLuVlWToNYl7gSC35eW9RMEKAE88tjPe86usCKxLW6K6TcEG8qL5RH5SPYBNAN
        Y3dBGFLF7IpGyI14Iwa76M+pZh6J489SiYRD3O0rUIzH35eAQRczVTxfH3j1wW0t
        +EHSji4uEIjYG1vbgdK5vVG0nTtOFgLvSI5vrRnC7JdFzjZg/DHTjH1CZwTpxaa/
        vBd+6BIgtX79T3Bp162Fq9eZc+idLrkCYMH6vGqTRDDgG7jsW1DNRc4hDaLCInkw
        ==
X-ME-Sender: <xms:aGHAYWuAnwt8-6iZmqtmblceEtttJyfj92CG0GzMbRbyXeXkCrAcJw>
    <xme:aGHAYbfr47SkUyvDrQo9_gECgXEi4dPlw-rESlyW-o9uuP_YXlkD4WDOLpbSHemvB
    SR7V4cZ5mYieA>
X-ME-Received: <xmr:aGHAYRwf5sCTwbQTX6thYMK_S7GkRBesT01DMSOfX7fHRZsYP8H7ZXij1wGNdwzRbAMGPKusDhIbFdNItta_qjsohErXp5Lq>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddruddtvddgvddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpefgteefff
    etvdffledtgeduudetffdutdduveefvedtueegueeggfeiteehfeetfeenucffohhmrghi
    nhepghhithhhuhgsrdgtohhmnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:aGHAYRPToRypfycYbanRoBLhJwYAQJO0JbIc7iP67zB2MZ6rZ7Hpfg>
    <xmx:aGHAYW-1UeAtg5aEZ2_Kxybu-Xnu-1UNAuEfKEXuiNR7CIYlmAK6Yw>
    <xmx:aGHAYZWWBvEkTnj_bDpbSQCkR1sle0t0uStglgypDBqeKTDguiB6OQ>
    <xmx:aWHAYelmdg3AwCxbYeFPmPuPhpHnqIr955Hp_d_1FQcccQb4o6PVRQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 20 Dec 2021 05:56:40 -0500 (EST)
Date:   Mon, 20 Dec 2021 11:56:37 +0100
From:   Greg KH <greg@kroah.com>
To:     Anders Roxell <anders.roxell@linaro.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, clang-built-linux@googlegroups.com,
        ulli.kroll@googlemail.com, linux@armlinux.org.uk,
        linux-arm-kernel@lists.infradead.org, amitkarwar@gmail.com,
        nishants@marvell.com, gbhat@marvell.com, huxinming820@gmail.com,
        kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
        rostedt@goodmis.org, mingo@redhat.com, dmitry.torokhov@gmail.com,
        ndesaulniers@google.com, nathan@kernel.org,
        linux-input@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Andy Lavr <andy.lavr@gmail.com>
Subject: Re: [PATCH 4.19 3/6] mwifiex: Remove unnecessary braces from
 HostCmd_SET_SEQ_NO_BSS_INFO
Message-ID: <YcBhZdeTQfD0Sjtq@kroah.com>
References: <20211217144119.2538175-1-anders.roxell@linaro.org>
 <20211217144119.2538175-4-anders.roxell@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211217144119.2538175-4-anders.roxell@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 17, 2021 at 03:41:16PM +0100, Anders Roxell wrote:
> From: Nathan Chancellor <natechancellor@gmail.com>
> 
> commit 6a953dc4dbd1c7057fb765a24f37a5e953c85fb0 upstream.
> 
> A new warning in clang points out when macro expansion might result in a
> GNU C statement expression. There is an instance of this in the mwifiex
> driver:
> 
> drivers/net/wireless/marvell/mwifiex/cmdevt.c:217:34: warning: '}' and
> ')' tokens terminating statement expression appear in different macro
> expansion contexts [-Wcompound-token-split-by-macro]
>         host_cmd->seq_num = cpu_to_le16(HostCmd_SET_SEQ_NO_BSS_INFO
>                                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/net/wireless/marvell/mwifiex/fw.h:519:46: note: expanded from
> macro 'HostCmd_SET_SEQ_NO_BSS_INFO'
>         (((type) & 0x000f) << 12);                  }
>                                                     ^
> 
> This does not appear to be a real issue. Removing the braces and
> replacing them with parentheses will fix the warning and not change the
> meaning of the code.
> 
> Fixes: 5e6e3a92b9a4 ("wireless: mwifiex: initial commit for Marvell mwifiex driver")
> Link: https://github.com/ClangBuiltLinux/linux/issues/1146
> Reported-by: Andy Lavr <andy.lavr@gmail.com>
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
> Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
> ---
>  drivers/net/wireless/marvell/mwifiex/cmdevt.c | 4 ++--
>  drivers/net/wireless/marvell/mwifiex/fw.h     | 8 ++++----
>  2 files changed, 6 insertions(+), 6 deletions(-)

Also needed in 5.4.y, right?
