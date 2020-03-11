Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8F4C180E7B
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 04:27:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727984AbgCKD0y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 23:26:54 -0400
Received: from wnew2-smtp.messagingengine.com ([64.147.123.27]:35191 "EHLO
        wnew2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727506AbgCKD0x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 23:26:53 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailnew.west.internal (Postfix) with ESMTP id C08D56C5;
        Tue, 10 Mar 2020 23:19:43 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Tue, 10 Mar 2020 23:19:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sakamocchi.jp;
         h=date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=b+Ma1H6/IShcWZqpJAo1sroDdFj
        4Te1+J3eJjPIM5JU=; b=ECHIVNCT6Daf9QX6h78auESsTvlreFKUsOl7YL/deIR
        DSKjlSxqc0pUdQDeWk9m8j0x/fp9VJlYhyjt0nByJumbzTGfu/0Wj3vplgfdTi6M
        4uRr9S1kVxp4FZSRI95dmyGMUbp1QFYVdaEUBasiPg9Hjd3X91tGEvRBxpfKcvtB
        oe8HGZePb7sitte8q9RvjRHSIe5FEbb6QlhOejhRNbDXZRNDPgRw9g53IoPnJC0t
        vs//S60QIOOJyXid7kyy4QOkQdBCg8bYTkzImzN7XLz3wbz3VWP3F54jLS0iekb6
        0O7rV8hwBawPi/wuvfQ8VXHedcSIy1a7Mo9gyfzBhqw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=b+Ma1H
        6/IShcWZqpJAo1sroDdFj4Te1+J3eJjPIM5JU=; b=rr04A5h7BMT9Yj65iF6YDE
        ECW6/MTrQ27G7qS9nzLXGSzUhxsev/OnnstAVSVWRkGBZkzJTUNJMhGCMiIbFPa1
        t8oLSlqv9MT5IV1+qyfPZdniPIWxc6DGovX/mRPCIXQbyUySOHfmA9bcItA64CNu
        ZglX+MDj09GgJhS2qTfgmtc6WJY4QCEUrdNSahqFmD2NIujb4iWAUI19B2aiMF4b
        weI+pancvkoiZGslUBJEjf2spiHkfEw2skOlfYswPD6hZq4yCalNey0R31ecO8Pr
        oBZk5Tkj+ZeA/WK+3NRYkNepwOIn1J90G+kr3W3mglvmI/XJpENb6rb6x3mdlxJA
        ==
X-ME-Sender: <xms:z1hoXmytAzEOi46fVw3GFhW_14BvvQR1Y1vWrMnMPUK4DGjvBo2RSA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedruddvuddgheekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepvfgrkhgr
    shhhihcuufgrkhgrmhhothhouceoohdqthgrkhgrshhhihesshgrkhgrmhhotggthhhird
    hjpheqnecukfhppedugedrfedrjeegrdduieeknecuvehluhhsthgvrhfuihiivgepuden
    ucfrrghrrghmpehmrghilhhfrhhomhepohdqthgrkhgrshhhihesshgrkhgrmhhotggthh
    hirdhjph
X-ME-Proxy: <xmx:z1hoXiiUkX573jKbV_tcMGplJyH-eTvnmffAW08TYCowKgGJZ43ZvQ>
    <xmx:z1hoXhO4Jm58TYxyrN5zn6entPRWUgacm00qBpgIiP8xHiW2q59qiQ>
    <xmx:z1hoXgZXzw0UOQ9ISWNUI8F-0ZTWyBlm3ZZ489HaxtrKPs-w7c4QMQ>
    <xmx:z1hoXjgGQP4vx36n0nQxZ9hGyM4-mPXoxwDnyYiOPkxeFxAyk-yhQQOwuNw>
Received: from workstation (ae074168.dynamic.ppp.asahi-net.or.jp [14.3.74.168])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8B70A3060F09;
        Tue, 10 Mar 2020 23:19:40 -0400 (EDT)
Date:   Wed, 11 Mar 2020 12:19:38 +0900
From:   Takashi Sakamoto <o-takashi@sakamocchi.jp>
To:     Jules Irenge <jbi.octave@gmail.com>
Cc:     boqun.feng@gmail.com, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        Clemens Ladisch <clemens@ladisch.de>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        Alexios Zavras <alexios.zavras@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Allison Randal <allison@lohutok.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        "moderated list:FIREWIRE AUDIO DRIVERS and IEC 61883-1/6 PACKET..." 
        <alsa-devel@alsa-project.org>
Subject: Re: [PATCH 7/8] ALSA: firewire-tascam: Add missing annotation for
 tscm_hwdep_read_queue()
Message-ID: <20200311031937.GB8197@workstation>
Mail-Followup-To: Jules Irenge <jbi.octave@gmail.com>, boqun.feng@gmail.com,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Clemens Ladisch <clemens@ladisch.de>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
        Alexios Zavras <alexios.zavras@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Allison Randal <allison@lohutok.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        "moderated list:FIREWIRE AUDIO DRIVERS and IEC 61883-1/6 PACKET..." <alsa-devel@alsa-project.org>
References: <0/8>
 <20200311010908.42366-1-jbi.octave@gmail.com>
 <20200311010908.42366-8-jbi.octave@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200311010908.42366-8-jbi.octave@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 11, 2020 at 01:09:07AM +0000, Jules Irenge wrote:
> Sparse reports a warning at tscm_hwdep_read_queue()
> 
> warning: context imbalance in tscm_hwdep_read_queue() - unexpected unlock
> 
> The root cause is the missing annotation at tscm_hwdep_read_queue()
> Add the missing __releases(&tscm->lock) annotation
> 
> Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
> ---
>  sound/firewire/tascam/tascam-hwdep.c | 1 +
>  1 file changed, 1 insertion(+)
 
This looks good.

Acked-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>

> diff --git a/sound/firewire/tascam/tascam-hwdep.c b/sound/firewire/tascam/tascam-hwdep.c
> index c29a97f6f638..9801e33e7f2a 100644
> --- a/sound/firewire/tascam/tascam-hwdep.c
> +++ b/sound/firewire/tascam/tascam-hwdep.c
> @@ -36,6 +36,7 @@ static long tscm_hwdep_read_locked(struct snd_tscm *tscm, char __user *buf,
>  
>  static long tscm_hwdep_read_queue(struct snd_tscm *tscm, char __user *buf,
>  				  long remained, loff_t *offset)
> +	__releases(&tscm->lock)
>  {
>  	char __user *pos = buf;
>  	unsigned int type = SNDRV_FIREWIRE_EVENT_TASCAM_CONTROL;
> -- 
> 2.24.1


Regards

Takashi Sakamoto
