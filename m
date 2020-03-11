Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 807BC180E77
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 04:26:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728074AbgCKD0y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 23:26:54 -0400
Received: from wnew2-smtp.messagingengine.com ([64.147.123.27]:52289 "EHLO
        wnew2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727648AbgCKD0x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 23:26:53 -0400
X-Greylist: delayed 471 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Mar 2020 23:26:53 EDT
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailnew.west.internal (Postfix) with ESMTP id C6EC46BE;
        Tue, 10 Mar 2020 23:19:00 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Tue, 10 Mar 2020 23:19:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sakamocchi.jp;
         h=date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=n7m72Tx+CWEa02zHghdkj9AV/pW
        oZotPpODUQGq39GM=; b=TrxEz737tfc4toeTcWR6JE6dB+EN4l1X7zs9bym9ZW3
        6HcmOb6wtTuWJRtDKH8N6LWA6iVwY6S1lvkdLnp8DJRFN4yE/LlCXVS9Czh7M+Zr
        WJCwXjQnSM0NuK4fmv4wjXJYZ5a1U26aBPHKl+MIGlHh53Yyu5o8CxEzNtsDlo+s
        nsnb7nw0sNQV95CBjm9uwt8DsHoBsYCeqZxZyWHFoz/ydz6oZLvV9tSmY4OElaO2
        scjr9g8LRd+CpR292Oj1p5qHrpchE9KxnZbA+hkNMxsVrsilWRZkAMdX4xAtBGqO
        6SZ3rgaoNt8BRmB32jYRExf+5bMu9Fq/5F2aiWtpsBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=n7m72T
        x+CWEa02zHghdkj9AV/pWoZotPpODUQGq39GM=; b=CsgbMFq0GBoJbAzszr8IH5
        /25ZkX1Z3ZP6p9bO86zYssPEZCBQ6NPhk1yj1WI5YSEKe+IxdVnObvWw7xCM1rJg
        cysDqa8PwmcLR1au8LKZxNDpkzEQ3iGz730i59Fu9CaOrwrzN72erFKw+NN312B3
        6S1JGk6LnGQXuPqKwnOkgrJ52tK8x5dbsgBo+5Sq5upCD5fvBKPHaArzO3ng1+db
        pdiDJ/TomXx3EA03ZXpoiZXESNmKpqOt7Ss9MZz5bNr67FtX0Yq1Sv50KZrVvyHv
        1OExx+A0fZkSrVLoF13nKioeCyvsfBRmiWH8+RtdpqWtuF4Vv7WwGLZwDc7Jwy2A
        ==
X-ME-Sender: <xms:o1hoXiE9F8d63W5FJwaI-hRTaAe0E3KcYFl4fj5Bb0eJ5jyLm_putg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedruddvuddgheekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepvfgrkhgr
    shhhihcuufgrkhgrmhhothhouceoohdqthgrkhgrshhhihesshgrkhgrmhhotggthhhird
    hjpheqnecukfhppedugedrfedrjeegrdduieeknecuvehluhhsthgvrhfuihiivgeptden
    ucfrrghrrghmpehmrghilhhfrhhomhepohdqthgrkhgrshhhihesshgrkhgrmhhotggthh
    hirdhjph
X-ME-Proxy: <xmx:o1hoXpyvpK075-EuV3DK9-cOJwJdQNqwHsLwAtPjM8IeJlo0jnvfzA>
    <xmx:o1hoXk8k5N5gJTt-jqWBtt8oEPd9rAMHIUfdRsIvW7jMV9nE7x8Hrw>
    <xmx:o1hoXrVjRku8AwyWmYO0iMwZ51L9dICuSIv63yN3yZQSPxOSyWBYxg>
    <xmx:pFhoXrIdJdSGK1Dh7-0w7wkFolMYiM2ibdevR8DbGPFC5QjW7P7na5qWUJU>
Received: from workstation (ae074168.dynamic.ppp.asahi-net.or.jp [14.3.74.168])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7370B328005A;
        Tue, 10 Mar 2020 23:18:56 -0400 (EDT)
Date:   Wed, 11 Mar 2020 12:18:54 +0900
From:   Takashi Sakamoto <o-takashi@sakamocchi.jp>
To:     Jules Irenge <jbi.octave@gmail.com>
Cc:     boqun.feng@gmail.com, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        Clemens Ladisch <clemens@ladisch.de>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        Alexios Zavras <alexios.zavras@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Allison Randal <allison@lohutok.net>,
        "moderated list:FIREWIRE AUDIO DRIVERS and IEC 61883-1/6 PACKET..." 
        <alsa-devel@alsa-project.org>
Subject: Re: [PATCH 8/8] ALSA: firewire-tascam: Add missing annotation for
 tscm_hwdep_read_locked()
Message-ID: <20200311031853.GA8197@workstation>
Mail-Followup-To: Jules Irenge <jbi.octave@gmail.com>, boqun.feng@gmail.com,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Clemens Ladisch <clemens@ladisch.de>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
        Alexios Zavras <alexios.zavras@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Allison Randal <allison@lohutok.net>,
        "moderated list:FIREWIRE AUDIO DRIVERS and IEC 61883-1/6 PACKET..." <alsa-devel@alsa-project.org>
References: <0/8>
 <20200311010908.42366-1-jbi.octave@gmail.com>
 <20200311010908.42366-9-jbi.octave@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200311010908.42366-9-jbi.octave@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, Mar 11, 2020 at 01:09:08AM +0000, Jules Irenge wrote:
> Sparse reports a warning at tscm_hwdep_read_locked()
> 
> warning: context imbalance in tscm_hwdep_read_locked() - unexpected unlock
> 
> The root cause is the missing annotation at tscm_hwdep_read_locked()
> Add the missing __releases(&tscm->lock) annotation
> 
> Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
> ---
>  sound/firewire/tascam/tascam-hwdep.c | 1 +
>  1 file changed, 1 insertion(+)

Thanks for your care of the warning. Although I have found it, I had
no idea to suppress it.

Acked-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>

> diff --git a/sound/firewire/tascam/tascam-hwdep.c b/sound/firewire/tascam/tascam-hwdep.c
> index 9801e33e7f2a..6f38335fe10b 100644
> --- a/sound/firewire/tascam/tascam-hwdep.c
> +++ b/sound/firewire/tascam/tascam-hwdep.c
> @@ -17,6 +17,7 @@
>  
>  static long tscm_hwdep_read_locked(struct snd_tscm *tscm, char __user *buf,
>  				   long count, loff_t *offset)
> +	__releases(&tscm->lock)
>  {
>  	struct snd_firewire_event_lock_status event = {
>  		.type = SNDRV_FIREWIRE_EVENT_LOCK_STATUS,
> -- 
> 2.24.1
> 
