Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C443A4CC2C
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 12:47:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbfFTKr2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 06:47:28 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:46297 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726211AbfFTKr2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 06:47:28 -0400
Received: by mail-qt1-f196.google.com with SMTP id h21so2669338qtn.13
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 03:47:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4sRUxc78T3PiDag50aqEMvObqexRwokvbb2vXdTDTY0=;
        b=psmTWWhJp8n3q0p/lOK+kqddqEDQpFU1cdpSEJyXmr1m7ohPKevUOsusMGmDNSFuD+
         cuEblhLd4g/pdyVfWHRR3NqIPeBhFnpcxIuXdry36EN8M94oLgtQPibDRMUxj/MnL0ma
         vW7vkfDXMScsJPaJTS4ZKt4UWqJwj/ESQ0Z3FI0O/FPq/kcVYcr4aTd3SPgf3O9gAsAR
         fLWBjaHrzSYRUl7YqY6AtrchaiaR8goC/nhlCe4+GMygu4afwsG1MKx+QeEVXEDzlCnL
         ZvWXEBDb5/xM36GoEuIYN3rQQusPgUEyBBSigToDDtOGF8YceAEu0f5dmjDwYjxsRQoj
         D7Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4sRUxc78T3PiDag50aqEMvObqexRwokvbb2vXdTDTY0=;
        b=rFmxvC7Q2HlzafT9M3a2CX/081Rpx/SIJ7/VttVpeid90l+vQwDeLoLEYQb0Fhiz6q
         TYT3o49Z7/ByVIVHt6da+KZeF5sXDNHlP6lTcE0q6dyD6WViHCJvfvKO3dc+QKbKuxNC
         5DmKtumClWz37z1jzQbXbMlhIwN1OErgVSS/0W5X3vRXsGuYTxY+nM1eBjJVB6DGA70N
         fNCgbJM9XSXsSTZiUk8+Gvd+8PRfTg3y45Or97CICBR7Isab+ZTs5k4fV17pv+vWE3aD
         mZnQVEiGi+KYluCA+aCGXYAnGwFvk7SPborJbH3PI7cqk4WvS6lTB4XeWaRHo8ivK0Fj
         z8sw==
X-Gm-Message-State: APjAAAU224VW0tNKIhOF298fAST30yLw9ADA5ud17IwnHLxxQ+T9IuDi
        0M7z6kztIlX1QHcTxBcK1W8=
X-Google-Smtp-Source: APXvYqxWmZypaMzjKk/9r7pkngeJ+lFeIzyvqlZDuP2NGsnNPsP5Bh3kR9sGBZGWuJ3hCXtaZvuusQ==
X-Received: by 2002:ac8:3908:: with SMTP id s8mr110014212qtb.224.1561027647385;
        Thu, 20 Jun 2019 03:47:27 -0700 (PDT)
Received: from [10.246.221.134] ([50.234.174.228])
        by smtp.gmail.com with ESMTPSA id p64sm13329230qkf.60.2019.06.20.03.47.26
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Jun 2019 03:47:26 -0700 (PDT)
Subject: Re: [PATCH net-next v4 1/7] igb: clear out tstamp after sending the
 packet
To:     Vedang Patel <vedang.patel@intel.com>, netdev@vger.kernel.org
Cc:     jeffrey.t.kirsher@intel.com, davem@davemloft.net, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        intel-wired-lan@lists.osuosl.org, vinicius.gomes@intel.com,
        l@dorileo.org, jakub.kicinski@netronome.com, m-karicheri2@ti.com,
        sergei.shtylyov@cogentembedded.com
References: <1560966016-28254-1-git-send-email-vedang.patel@intel.com>
 <1560966016-28254-2-git-send-email-vedang.patel@intel.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <d6655497-5246-c24e-de35-fc6acdad0bf1@gmail.com>
Date:   Thu, 20 Jun 2019 06:47:25 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <1560966016-28254-2-git-send-email-vedang.patel@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/19/19 10:40 AM, Vedang Patel wrote:
> skb->tstamp is being used at multiple places. On the transmit side, it
> is used to determine the launchtime of the packet. It is also used to
> determine the software timestamp after the packet has been transmitted.
> 
> So, clear out the tstamp value after it has been read so that we do not
> report false software timestamp on the receive side.
> 
> Signed-off-by: Vedang Patel <vedang.patel@intel.com>
> ---
>  drivers/net/ethernet/intel/igb/igb_main.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
> index fc925adbd9fa..f66dae72fe37 100644
> --- a/drivers/net/ethernet/intel/igb/igb_main.c
> +++ b/drivers/net/ethernet/intel/igb/igb_main.c
> @@ -5688,6 +5688,7 @@ static void igb_tx_ctxtdesc(struct igb_ring *tx_ring,
>  	 */
>  	if (tx_ring->launchtime_enable) {
>  		ts = ns_to_timespec64(first->skb->tstamp);
> +		first->skb->tstamp = 0;

Please provide more explanations.

Why only this driver would need this ?


>  		context_desc->seqnum_seed = cpu_to_le32(ts.tv_nsec / 32);
>  	} else {
>  		context_desc->seqnum_seed = 0;
> 
