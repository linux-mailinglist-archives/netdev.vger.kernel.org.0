Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06007116ECA
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 15:14:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727865AbfLIOOe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 09:14:34 -0500
Received: from mx01-fr.bfs.de ([193.174.231.67]:35326 "EHLO mx01-fr.bfs.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726687AbfLIOOd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Dec 2019 09:14:33 -0500
Received: from mail-fr.bfs.de (mail-fr.bfs.de [10.177.18.200])
        by mx01-fr.bfs.de (Postfix) with ESMTPS id AA9D5201F4;
        Mon,  9 Dec 2019 15:14:26 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bfs.de; s=dkim201901;
        t=1575900866; h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VV/fphlTsj7XOOXxkDOSVDjI40GPzBonnX8fbQjETRM=;
        b=tpgCOf8YgWJE3uVLYXbARPc0s/DmmpdpdIAU0uvDC878YwwYn3J2FT/R+fnrwwblqMFGoN
        ZCoDnLmZzkG8u96tnhI5NuNOX7sV6V/FJ7lkDi7svSaS5kMMatyJXAVpMT2OZBSuSZaaRS
        MjZbPLQob5d0TwYzdHmH0apJt4wfRDSHF+h9QEs7n8+FtTjSPEHH0M+5SaQ5dPe6SpjVWr
        UHF+6liYzaFxVOMGSFMc7yYVVgL+jM1gKLDiSks0BLdT16DRoKQcELUBUF0Ln42brVRwBK
        Mec3wW97M/79PKtt9nfGlV82oQ8kujT3EQCDZ00fRBukaNn9B/k+Hsr2Va+INw==
Received: from [134.92.181.33] (unknown [134.92.181.33])
        by mail-fr.bfs.de (Postfix) with ESMTPS id 37CC4BEEBD;
        Mon,  9 Dec 2019 15:14:24 +0100 (CET)
Message-ID: <5DEE56BF.5000102@bfs.de>
Date:   Mon, 09 Dec 2019 15:14:23 +0100
From:   walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To:     Mao Wenan <maowenan@huawei.com>
CC:     davem@davemloft.net, loke.chetan@gmail.com, willemb@google.com,
        edumazet@google.com, maximmi@mellanox.com, nhorman@tuxdriver.com,
        pabeni@redhat.com, yuehaibing@huawei.com, tglx@linutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Xiao Jiangfeng <xiaojiangfeng@huawei.com>
Subject: Re: [PATCH net] af_packet: set defaule value for tmo
References: <20191209133125.59093-1-maowenan@huawei.com>
In-Reply-To: <20191209133125.59093-1-maowenan@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.10
Authentication-Results: mx01-fr.bfs.de
X-Spamd-Result: default: False [-3.10 / 7.00];
         ARC_NA(0.00)[];
         HAS_REPLYTO(0.00)[wharms@bfs.de];
         BAYES_HAM(-3.00)[100.00%];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         TAGGED_RCPT(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         REPLYTO_ADDR_EQ_FROM(0.00)[];
         DKIM_SIGNED(0.00)[];
         RCPT_COUNT_TWELVE(0.00)[14];
         NEURAL_HAM(-0.00)[-0.999,0];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         RCVD_COUNT_TWO(0.00)[2];
         MID_RHS_MATCH_FROM(0.00)[];
         RCVD_TLS_ALL(0.00)[]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Am 09.12.2019 14:31, schrieb Mao Wenan:
> There is softlockup when using TPACKET_V3:
> ...
> NMI watchdog: BUG: soft lockup - CPU#2 stuck for 60010ms!
> (__irq_svc) from [<c0558a0c>] (_raw_spin_unlock_irqrestore+0x44/0x54)
> (_raw_spin_unlock_irqrestore) from [<c027b7e8>] (mod_timer+0x210/0x25c)
> (mod_timer) from [<c0549c30>]
> (prb_retire_rx_blk_timer_expired+0x68/0x11c)
> (prb_retire_rx_blk_timer_expired) from [<c027a7ac>]
> (call_timer_fn+0x90/0x17c)
> (call_timer_fn) from [<c027ab6c>] (run_timer_softirq+0x2d4/0x2fc)
> (run_timer_softirq) from [<c021eaf4>] (__do_softirq+0x218/0x318)
> (__do_softirq) from [<c021eea0>] (irq_exit+0x88/0xac)
> (irq_exit) from [<c0240130>] (msa_irq_exit+0x11c/0x1d4)
> (msa_irq_exit) from [<c0209cf0>] (handle_IPI+0x650/0x7f4)
> (handle_IPI) from [<c02015bc>] (gic_handle_irq+0x108/0x118)
> (gic_handle_irq) from [<c0558ee4>] (__irq_usr+0x44/0x5c)
> ...
> 
> If __ethtool_get_link_ksettings() is failed in
> prb_calc_retire_blk_tmo(), msec and tmo will be zero, so tov_in_jiffies
> is zero and the timer expire for retire_blk_timer is turn to
> mod_timer(&pkc->retire_blk_timer, jiffies + 0),
> which will trigger cpu usage of softirq is 100%.
> 
> Fixes: f6fb8f100b80 ("af-packet: TPACKET_V3 flexible buffer implementation.")
> Tested-by: Xiao Jiangfeng <xiaojiangfeng@huawei.com>
> Signed-off-by: Mao Wenan <maowenan@huawei.com>
> ---
>  net/packet/af_packet.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
> index 53c1d41fb1c9..118cd66b7516 100644
> --- a/net/packet/af_packet.c
> +++ b/net/packet/af_packet.c
> @@ -544,7 +544,8 @@ static int prb_calc_retire_blk_tmo(struct packet_sock *po,
>  			msec = 1;
>  			div = ecmd.base.speed / 1000;
>  		}
> -	}
> +	} else
> +		return DEFAULT_PRB_RETIRE_TOV;
>  
>  	mbits = (blk_size_in_bytes * 8) / (1024 * 1024);
>  

With some litrle refactoring you can save one indent
and make it more readable.

err = __ethtool_get_settings(dev, &ecmd);

if (err)
     return DEFAULT_PRB_RETIRE_TOV;

speed = ethtool_cmd_speed(&ecmd);

if (speed < SPEED_1000 || speed == SPEED_UNKNOWN)
      return DEFAULT_PRB_RETIRE_TOV;

msec = 1;  // never changes - needed at all ??
div = speed / 1000;

jm2c

re,
 wh


