Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEB0FAC30D
	for <lists+netdev@lfdr.de>; Sat,  7 Sep 2019 01:30:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405459AbfIFXav (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 19:30:51 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:51599 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728978AbfIFXau (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 19:30:50 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id F1DF32202A;
        Fri,  6 Sep 2019 19:30:48 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Fri, 06 Sep 2019 19:30:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=FGZ8S19n43tAruLCrzOkg9MRjNq
        62BLa54KBCyPc1Ic=; b=enS/hQsCWDFF6qI3rbYcTZyLHh+uaaU9vPEpOkLCmAh
        J7u+hgfrXrQgUw/UILiZB3WDTnXjgqQwqBCNgHKAgF4v90BGOvt0LDjKt2lUkKcK
        WR90Qqu0RRR+Yif2oSKFAsrVc2S4UIKAXZTGwrh6hiYCN7d/2E4taU23IsrVAJ1U
        2paxk/lz18QuvdCaAiErJmc0NX+c2fTI27NhBq3kBaHs/mwi5bAH/mCFo+e1WLkK
        1Uufn0n86xD3Zoj02TJl+dh0lr1487+NPDRhbBgGz975OYH5u/xHaD+EQzOS1oi1
        Bc76tvsJR6jcWMVKZpP5CZatBu1ii8W4pCac9ANJCow==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=FGZ8S1
        9n43tAruLCrzOkg9MRjNq62BLa54KBCyPc1Ic=; b=HOVzxhMYZCcjkYxlDqttm8
        Cw3fkZxuMsEUL/AwNxTpDF7jKUnJwaDaZQbMSxd47q/Ur7qKqugM78rb2RU+EUAI
        nXVFj/1JGME89Vj0BUeaavKy/HQI2IbVUeaw5QyYrLzRXjbgNW4zK1CvM5UFdU3f
        yihV2xmAtNxuf8zqOUAobHZWVUOxLmyI63ByQnQHn0Ih/ctwgUe8Yco3xYJ32WnT
        HsdHRO5WftlGBhcVA5fya4cTCuYKEcXHzniYIVZfit0CFsYphCG5yZSwvQZoodh4
        GmiwrqgPCsAWxs51Wbk2fobHaaNSlZzRCyrYjwj4M+9gZ6pMbt+ApSJDJ0mfkc8g
        ==
X-ME-Sender: <xms:KOxyXeCXnbphK_rHEudHrWoJMT_zQuvc0MryatwIn4QqRgvU95Fe2A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudektddgvdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeektddrvdehuddrudeivd
    drudeigeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
    necuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:KOxyXbG7eu3pSwfAE_T3eYhzU37ZxMp-b2vM4GCzpKhOC1BVn8glmA>
    <xmx:KOxyXSjv9NaFxJVTtG9_RVE646Ut2ntkRKqOAFXtpTVwYWYjsG4Jig>
    <xmx:KOxyXRzi6UZo7EXZoB2wLa6_jeLcWUxTT01cptI3lg0bt9Ratj4YvQ>
    <xmx:KOxyXYuKPS2NVxX3TMzGKiaqBdn6ejmA8XLM42f6iZY02RNnAaBiSw>
Received: from localhost (unknown [80.251.162.164])
        by mail.messagingengine.com (Postfix) with ESMTPA id 01ED8D6005B;
        Fri,  6 Sep 2019 19:30:47 -0400 (EDT)
Date:   Sat, 7 Sep 2019 01:30:45 +0200
From:   Greg KH <greg@kroah.com>
To:     Mark Salyzyn <salyzyn@android.com>
Cc:     linux-kernel@vger.kernel.org, kernel-team@android.com,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Marcel Holtmann <marcel@holtmann.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] net: enable wireless core features with
 LEGACY_WEXT_ALLCONFIG
Message-ID: <20190906233045.GB9478@kroah.com>
References: <20190906192403.195620-1-salyzyn@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190906192403.195620-1-salyzyn@android.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 06, 2019 at 12:24:00PM -0700, Mark Salyzyn wrote:
> In embedded environments the requirements are to be able to pick and
> chose which features one requires built into the kernel.  If an
> embedded environment wants to supports loading modules that have been
> kbuilt out of tree, there is a need to enable hidden configurations
> for legacy wireless core features to provide the API surface for
> them to load.
> 
> Introduce CONFIG_LEGACY_WEXT_ALLCONFIG to select all legacy wireless
> extension core features by activating in turn all the associated
> hidden configuration options, without having to specifically select
> any wireless module(s).
> 
> Signed-off-by: Mark Salyzyn <salyzyn@android.com>
> Cc: kernel-team@android.com
> Cc: Johannes Berg <johannes@sipsolutions.net>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Marcel Holtmann <marcel@holtmann.org>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: stable@vger.kernel.org # 4.19
> ---
> v2: change name and documentation to CONFIG_LEGACY_WEXT_ALLCONFIG
> ---
>  net/wireless/Kconfig | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
> index 67f8360dfcee..0d646cf28de5 100644
> --- a/net/wireless/Kconfig
> +++ b/net/wireless/Kconfig
> @@ -17,6 +17,20 @@ config WEXT_SPY
>  config WEXT_PRIV
>  	bool
>  
> +config LEGACY_WEXT_ALLCONFIG
> +	bool "allconfig for legacy wireless extensions"
> +	select WIRELESS_EXT
> +	select WEXT_CORE
> +	select WEXT_PROC
> +	select WEXT_SPY
> +	select WEXT_PRIV
> +	help
> +	  Config option used to enable all the legacy wireless extensions to
> +	  the core functionality used by add-in modules.
> +
> +	  If you are not building a kernel to be used for a variety of
> +	  out-of-kernel built wireless modules, say N here.
> +
>  config CFG80211
>  	tristate "cfg80211 - wireless configuration API"
>  	depends on RFKILL || !RFKILL
> -- 
> 2.23.0.187.g17f5b7556c-goog
> 

How is this patch applicable to stable kernels???
