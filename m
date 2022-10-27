Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB14F60F8CF
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 15:15:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235651AbiJ0NPU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 09:15:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235578AbiJ0NPR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 09:15:17 -0400
X-Greylist: delayed 177 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 27 Oct 2022 06:15:15 PDT
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4349B50FB3;
        Thu, 27 Oct 2022 06:15:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1666876324;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=sEFEYQJdYoP8d2ZYeKq+6NW4ODH6uGoGm67Ksk8y4Gs=;
    b=MytR1PYZZfDbs3P5B7VQF8peU6FfX5lqlupUp0Lp5cSmZzfqIwwSrE1RMrBASt2js+
    fwbeYuRBMXP37UTh08RoezLCvjfl+OD6xYNZXNEaKIgPkGglEFfTIy/RHYiNwn/MQhJg
    gPGrkUWk8Md/RnX+XBLI82Rla2oEC+S2G5By4DTJmiixF/yDpYqQk41l+88QGtbiNtnF
    UUnVaVCe2x+O+maiFuPv/WMtoMAIRG2xhw5daqVtgHB2bfFT649t135XT5N0VJSqvCpt
    g+0VdwF4fMfivTq3/IZ5nfMxo8Weyb3oME0/MOsklj4TToyV5zSuAqmT/tzrQy0cTAH5
    lf4w==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusx3hdIrpKytJSr6hfz3Vg=="
X-RZG-CLASS-ID: mo00
Received: from [IPV6:2a00:6020:1cfd:d100::923]
    by smtp.strato.de (RZmta 48.2.1 AUTH)
    with ESMTPSA id Dde783y9RDC27V2
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Thu, 27 Oct 2022 15:12:02 +0200 (CEST)
Message-ID: <31c8f481-aeec-daf8-92d7-016824f88760@hartkopp.net>
Date:   Thu, 27 Oct 2022 15:11:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH 12/15] drivers: net: slip: remove SLIP_MAGIC
To:     =?UTF-8?B?0L3QsNCx?= <nabijaczleweli@nabijaczleweli.xyz>,
        Jiri Slaby <jirislaby@kernel.org>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Federico Vaga <federico.vaga@vaga.pv.it>,
        Alex Shi <alexs@kernel.org>,
        Yanteng Si <siyanteng@loongson.cn>,
        Hu Haowen <src.res@email.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        =?UTF-8?Q?Jakub_Kici=c5=84ski?= <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Duoming Zhou <duoming@zju.edu.cn>,
        Huang Pei <huangpei@loongson.cn>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-doc-tw-discuss@lists.sourceforge.net, netdev@vger.kernel.org
References: <9a453437b5c3b4b1887c1bd84455b0cc3d1c40b2.1666822928.git.nabijaczleweli@nabijaczleweli.xyz>
 <f5f9036f2a488886fe5a424d8143e8f2f3fdcf3f.1666822928.git.nabijaczleweli@nabijaczleweli.xyz>
Content-Language: en-US
From:   Oliver Hartkopp <socketcan@hartkopp.net>
In-Reply-To: <f5f9036f2a488886fe5a424d8143e8f2f3fdcf3f.1666822928.git.nabijaczleweli@nabijaczleweli.xyz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I'm not sure why I'm in 'To' here as I'm definitely not the official 
maintainer of slip.

But it looks like there is no real maintainer anyway but maybe Jiri ;-)

On 27.10.22 00:43, наб wrote:
> According to Greg, in the context of magic numbers as defined in
> magic-number.rst, "the tty layer should not need this and I'll gladly
> take patches"
> 
> We have largely moved away from this approach,
> and we have better debugging instrumentation nowadays: kill it
> 
> Additionally, all SLIP_MAGIC checks just early-exit instead
> of noting the bug, so they're detrimental, if anything
> 
> Ref: https://lore.kernel.org/linux-doc/YyMlovoskUcHLEb7@kroah.com/
> Signed-off-by: Ahelenia Ziemiańska <nabijaczleweli@nabijaczleweli.xyz>

Reviewed-by: Oliver Hartkopp <socketcan@hartkopp.net>


Many thanks!
Oliver

> ---
>   Documentation/process/magic-number.rst                |  1 -
>   .../translations/it_IT/process/magic-number.rst       |  1 -
>   .../translations/zh_CN/process/magic-number.rst       |  1 -
>   .../translations/zh_TW/process/magic-number.rst       |  1 -
>   drivers/net/slip/slip.c                               | 11 +++++------
>   drivers/net/slip/slip.h                               |  4 ----
>   6 files changed, 5 insertions(+), 14 deletions(-)
> 
> diff --git a/Documentation/process/magic-number.rst b/Documentation/process/magic-number.rst
> index 3b3e607e1cbc..e59c707ec785 100644
> --- a/Documentation/process/magic-number.rst
> +++ b/Documentation/process/magic-number.rst
> @@ -69,6 +69,5 @@ Changelog::
>   Magic Name            Number           Structure                File
>   ===================== ================ ======================== ==========================================
>   FASYNC_MAGIC          0x4601           fasync_struct            ``include/linux/fs.h``
> -SLIP_MAGIC            0x5302           slip                     ``drivers/net/slip.h``
>   CCB_MAGIC             0xf2691ad2       ccb                      ``drivers/scsi/ncr53c8xx.c``
>   ===================== ================ ======================== ==========================================
> diff --git a/Documentation/translations/it_IT/process/magic-number.rst b/Documentation/translations/it_IT/process/magic-number.rst
> index e8c659b6a743..37a539867b6f 100644
> --- a/Documentation/translations/it_IT/process/magic-number.rst
> +++ b/Documentation/translations/it_IT/process/magic-number.rst
> @@ -75,6 +75,5 @@ Registro dei cambiamenti::
>   Nome magico           Numero           Struttura                File
>   ===================== ================ ======================== ==========================================
>   FASYNC_MAGIC          0x4601           fasync_struct            ``include/linux/fs.h``
> -SLIP_MAGIC            0x5302           slip                     ``drivers/net/slip.h``
>   CCB_MAGIC             0xf2691ad2       ccb                      ``drivers/scsi/ncr53c8xx.c``
>   ===================== ================ ======================== ==========================================
> diff --git a/Documentation/translations/zh_CN/process/magic-number.rst b/Documentation/translations/zh_CN/process/magic-number.rst
> index 2105af32187c..8a3a3e872c52 100644
> --- a/Documentation/translations/zh_CN/process/magic-number.rst
> +++ b/Documentation/translations/zh_CN/process/magic-number.rst
> @@ -58,6 +58,5 @@ Linux 魔术数
>   魔术数名              数字             结构                     文件
>   ===================== ================ ======================== ==========================================
>   FASYNC_MAGIC          0x4601           fasync_struct            ``include/linux/fs.h``
> -SLIP_MAGIC            0x5302           slip                     ``drivers/net/slip.h``
>   CCB_MAGIC             0xf2691ad2       ccb                      ``drivers/scsi/ncr53c8xx.c``
>   ===================== ================ ======================== ==========================================
> diff --git a/Documentation/translations/zh_TW/process/magic-number.rst b/Documentation/translations/zh_TW/process/magic-number.rst
> index 793a0ae9fb7c..7ace7834f7f9 100644
> --- a/Documentation/translations/zh_TW/process/magic-number.rst
> +++ b/Documentation/translations/zh_TW/process/magic-number.rst
> @@ -61,6 +61,5 @@ Linux 魔術數
>   魔術數名              數字             結構                     文件
>   ===================== ================ ======================== ==========================================
>   FASYNC_MAGIC          0x4601           fasync_struct            ``include/linux/fs.h``
> -SLIP_MAGIC            0x5302           slip                     ``drivers/net/slip.h``
>   CCB_MAGIC             0xf2691ad2       ccb                      ``drivers/scsi/ncr53c8xx.c``
>   ===================== ================ ======================== ==========================================
> diff --git a/drivers/net/slip/slip.c b/drivers/net/slip/slip.c
> index 6865d32270e5..95f5c79772e7 100644
> --- a/drivers/net/slip/slip.c
> +++ b/drivers/net/slip/slip.c
> @@ -426,7 +426,7 @@ static void slip_transmit(struct work_struct *work)
>   
>   	spin_lock_bh(&sl->lock);
>   	/* First make sure we're connected. */
> -	if (!sl->tty || sl->magic != SLIP_MAGIC || !netif_running(sl->dev)) {
> +	if (!sl->tty || !netif_running(sl->dev)) {
>   		spin_unlock_bh(&sl->lock);
>   		return;
>   	}
> @@ -690,7 +690,7 @@ static void slip_receive_buf(struct tty_struct *tty, const unsigned char *cp,
>   {
>   	struct slip *sl = tty->disc_data;
>   
> -	if (!sl || sl->magic != SLIP_MAGIC || !netif_running(sl->dev))
> +	if (!sl || !netif_running(sl->dev))
>   		return;
>   
>   	/* Read the characters out of the buffer */
> @@ -761,7 +761,6 @@ static struct slip *sl_alloc(void)
>   	sl = netdev_priv(dev);
>   
>   	/* Initialize channel control data */
> -	sl->magic       = SLIP_MAGIC;
>   	sl->dev	      	= dev;
>   	spin_lock_init(&sl->lock);
>   	INIT_WORK(&sl->tx_work, slip_transmit);
> @@ -809,7 +808,7 @@ static int slip_open(struct tty_struct *tty)
>   
>   	err = -EEXIST;
>   	/* First make sure we're not already connected. */
> -	if (sl && sl->magic == SLIP_MAGIC)
> +	if (sl)
>   		goto err_exit;
>   
>   	/* OK.  Find a free SLIP channel to use. */
> @@ -886,7 +885,7 @@ static void slip_close(struct tty_struct *tty)
>   	struct slip *sl = tty->disc_data;
>   
>   	/* First make sure we're connected. */
> -	if (!sl || sl->magic != SLIP_MAGIC || sl->tty != tty)
> +	if (!sl || sl->tty != tty)
>   		return;
>   
>   	spin_lock_bh(&sl->lock);
> @@ -1080,7 +1079,7 @@ static int slip_ioctl(struct tty_struct *tty, unsigned int cmd,
>   	int __user *p = (int __user *)arg;
>   
>   	/* First make sure we're connected. */
> -	if (!sl || sl->magic != SLIP_MAGIC)
> +	if (!sl)
>   		return -EINVAL;
>   
>   	switch (cmd) {
> diff --git a/drivers/net/slip/slip.h b/drivers/net/slip/slip.h
> index 3d7f88b330c1..d7dbedd27669 100644
> --- a/drivers/net/slip/slip.h
> +++ b/drivers/net/slip/slip.h
> @@ -50,8 +50,6 @@
>   
>   
>   struct slip {
> -  int			magic;
> -
>     /* Various fields. */
>     struct tty_struct	*tty;		/* ptr to TTY structure		*/
>     struct net_device	*dev;		/* easy for intr handling	*/
> @@ -100,6 +98,4 @@ struct slip {
>   #endif
>   };
>   
> -#define SLIP_MAGIC 0x5302
> -
>   #endif	/* _LINUX_SLIP.H */
