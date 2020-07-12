Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BDA321C9D4
	for <lists+netdev@lfdr.de>; Sun, 12 Jul 2020 16:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728868AbgGLORB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jul 2020 10:17:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728786AbgGLORA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jul 2020 10:17:00 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28940C061794;
        Sun, 12 Jul 2020 07:17:00 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id g139so5728191lfd.10;
        Sun, 12 Jul 2020 07:17:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version;
        bh=LPicycpnJM7sePx564IeqVZ6I+CMVvaKcxYO2z8udBg=;
        b=Slh8i6rWfCSu8Etyr9vJgSl9OIt4jq+3ChiZdQMOIsGs/QaJxOMU2XEtJVrGh06ijK
         2ME1xstG0fk31vdT65SKUn32ZZK6hV7qONLIiezstOTuGvy/NdQzOh+1J+IKNxrfXKi6
         gIjjObDw8c7nrayAgr5/oMSqlC2pYrH8ECKM71AdVe6dKu8MmkoJZdd6ez3INtxsDBxv
         h1yVdWkSeP6208/P0oEHWKdbat6Q/W0iLlAWi6FzQjJV1STitdj96lj+rw7k6/0i03gS
         52PYcQ2I4u4HdSnfntdvyUi889FNP440uyDSWFCyLM0YIKrhnaWEgObmTP7MMxAg9m50
         n+fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:references:date:in-reply-to
         :message-id:user-agent:mime-version;
        bh=LPicycpnJM7sePx564IeqVZ6I+CMVvaKcxYO2z8udBg=;
        b=ZSfn5PG0zsC+Qcivwh1aHDTH+MASfmg1UiiRyslE0NH1gUI9VzFEUYlYYHP9RGYT34
         MpW+wztvyCcJy9NmU0bCVuM7dOjGHEA6hgrWN6YcIFNMIwD2+u1kdqI2Z7kFKCjI8Ofv
         p3jMxBh+IVxxV/0hZuiQAUvgXSniM2128P4pTK53qHIqBI6Ir7QyFLO6hrKjzf/+O/nr
         fWi24B6W3/NB1laTv+NJ5/WMPsJMzLIRSGrrzCVfBTuVSJkTAZu/aXyVd5Lz5AgWtLd9
         z+A1ABo6NcjczOx5axfveQG30TBybvu1zytwivEywd9ah5ZYEt5rP7dLHXqmjCqzIOyt
         ozxg==
X-Gm-Message-State: AOAM533tmZFzB03ZaAYR2z0/zIv5Cz050VQdtpauoKlCSh5mp5Rx0HpP
        tThqm3GtWN92S+WnkBNjDKY=
X-Google-Smtp-Source: ABdhPJwGyatVg8ctVtcmFui3wxaiJwMBbgFahj1dAWOsI9tMQNaGR5/UMhOeTGjD+j28v0O1B+Wm1g==
X-Received: by 2002:a19:c389:: with SMTP id t131mr36107606lff.130.1594563418310;
        Sun, 12 Jul 2020 07:16:58 -0700 (PDT)
Received: from osv.localdomain ([89.175.180.246])
        by smtp.gmail.com with ESMTPSA id v11sm3508198ljh.119.2020.07.12.07.16.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2020 07:16:57 -0700 (PDT)
From:   Sergey Organov <sorganov@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fugang Duan <fugang.duan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH v2 net] net: fec: fix hardware time stamping by external
 devices
References: <20200706142616.25192-1-sorganov@gmail.com>
        <20200711120842.2631-1-sorganov@gmail.com>
        <20200711231937.wu2zrm5spn7a6u2o@skbuf>
Date:   Sun, 12 Jul 2020 17:16:56 +0300
In-Reply-To: <20200711231937.wu2zrm5spn7a6u2o@skbuf> (Vladimir Oltean's
        message of "Sun, 12 Jul 2020 02:19:37 +0300")
Message-ID: <87wo387r8n.fsf@osv.gnss.ru>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vladimir Oltean <olteanv@gmail.com> writes:

> Hi Sergey,
>
> On Sat, Jul 11, 2020 at 03:08:42PM +0300, Sergey Organov wrote:
>> Fix support for external PTP-aware devices such as DSA or PTP PHY:
>> 
>> Make sure we never time stamp tx packets when hardware time stamping
>> is disabled.
>> 
>> Check for PTP PHY being in use and then pass ioctls related to time
>> stamping of Ethernet packets to the PTP PHY rather than handle them
>> ourselves. In addition, disable our own hardware time stamping in this
>> case.
>> 
>> Fixes: 6605b73 ("FEC: Add time stamping code and a PTP hardware clock")
>
> Please use a 12-character sha1sum. Try to use the "pretty" format
> specifier I gave you in the original thread, it saves you from
> counting,

I did as you suggested:

[pretty]
        fixes = Fixes: %h (\"%s\")
[alias]
	fixes = show --no-patch --pretty='Fixes: %h (\"%s\")'

And that's what it gave me. Dunno, maybe its Git version that is
responsible?

I now tried to find a way to specify the number of digits in the
abbreviated hash in the format, but failed. There is likely some global
setting for minimum number of digits, but I'm yet to find it. Any idea?

> and also from people complaining once it gets merged:
>
> https://www.google.com/search?q=stephen+rothwell+%22fixes+tag+needs+some+work%22
>
>> Signed-off-by: Sergey Organov <sorganov@gmail.com>
>> ---
>> 
>> v2:
>>   - Extracted from larger patch series
>>   - Description/comments updated according to discussions
>>   - Added Fixes: tag
>> 
>>  drivers/net/ethernet/freescale/fec.h      |  1 +
>>  drivers/net/ethernet/freescale/fec_main.c | 23 +++++++++++++++++------
>>  drivers/net/ethernet/freescale/fec_ptp.c  | 12 ++++++++++++
>>  3 files changed, 30 insertions(+), 6 deletions(-)
>> 
>> diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/freescale/fec.h
>> index d8d76da..832a217 100644
>> --- a/drivers/net/ethernet/freescale/fec.h
>> +++ b/drivers/net/ethernet/freescale/fec.h
>> @@ -590,6 +590,7 @@ struct fec_enet_private {
>>  void fec_ptp_init(struct platform_device *pdev, int irq_idx);
>>  void fec_ptp_stop(struct platform_device *pdev);
>>  void fec_ptp_start_cyclecounter(struct net_device *ndev);
>> +void fec_ptp_disable_hwts(struct net_device *ndev);
>>  int fec_ptp_set(struct net_device *ndev, struct ifreq *ifr);
>>  int fec_ptp_get(struct net_device *ndev, struct ifreq *ifr);
>>  
>> diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
>> index 3982285..cc7fbfc 100644
>> --- a/drivers/net/ethernet/freescale/fec_main.c
>> +++ b/drivers/net/ethernet/freescale/fec_main.c
>> @@ -1294,8 +1294,13 @@ fec_enet_tx_queue(struct net_device *ndev, u16 queue_id)
>>  			ndev->stats.tx_bytes += skb->len;
>>  		}
>>  
>> -		if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_IN_PROGRESS) &&
>> -			fep->bufdesc_ex) {
>> +		/* NOTE: SKBTX_IN_PROGRESS being set does not imply it's we who
>> +		 * are to time stamp the packet, so we still need to check time
>> +		 * stamping enabled flag.
>> +		 */
>> +		if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_IN_PROGRESS &&
>> +			     fep->hwts_tx_en) &&
>> +		    fep->bufdesc_ex) {
>>  			struct skb_shared_hwtstamps shhwtstamps;
>>  			struct bufdesc_ex *ebdp = (struct bufdesc_ex *)bdp;
>>  
>> @@ -2723,10 +2728,16 @@ static int fec_enet_ioctl(struct net_device *ndev, struct ifreq *rq, int cmd)
>>  		return -ENODEV;
>>  
>>  	if (fep->bufdesc_ex) {
>> -		if (cmd == SIOCSHWTSTAMP)
>> -			return fec_ptp_set(ndev, rq);
>> -		if (cmd == SIOCGHWTSTAMP)
>> -			return fec_ptp_get(ndev, rq);
>> +		bool use_fec_hwts = !phy_has_hwtstamp(phydev);
>
> I thought we were in agreement that FEC does not support PHY
> timestamping at this point, and this patch would only be fixing DSA
> switches (even though PHYs would need this fixed too, when support is
> added for them)? I would definitely not introduce support (and
> incomplete, at that) for a new feature in a bugfix patch.
>
> But it looks like we aren't.

We were indeed, and, honestly, I did prepare the split version of the
changes. But then I felt uneasy describing these commits, as I realized
that I fix single source file and single original commit by adding
proper support for a single feature that is described in your (single)
recent document, but with 2 separate commits, each of which solves only
half of the problem. I felt I need to somehow explain why could somebody
want half a fix, and didn't know how, so I've merged them back into
single commit.

In case you insist they are to be separate, I do keep the split version
in my git tree, but to finish it that way, I'd like to clarify a few
details:

1. Should it be patch series with 2 commits, or 2 entirely separate
patches?

2. If patch series, which change should go first? Here please notice
that ioctl() change makes no sense without SKBTX fix unconditionally,
while SKBTX fix makes no sense without ioctl() fix for PTP PHY users
only.

3. If entirely separate patches, should I somehow refer to SKBTX patch in
ioctl() one (and/or vice versa), to make it explicit they are
(inter)dependent? 

4. How/if should I explain why anybody would benefit from applying
SKBTX patch, yet be in trouble applying ioctl() one? 

>
>> +
>> +		if (cmd == SIOCSHWTSTAMP) {
>> +			if (use_fec_hwts)
>> +				return fec_ptp_set(ndev, rq);
>> +			fec_ptp_disable_hwts(ndev);
>> +		} else if (cmd == SIOCGHWTSTAMP) {
>> +			if (use_fec_hwts)
>> +				return fec_ptp_get(ndev, rq);
>> +		}
>>  	}
>>  
>>  	return phy_mii_ioctl(phydev, rq, cmd);
>> diff --git a/drivers/net/ethernet/freescale/fec_ptp.c b/drivers/net/ethernet/freescale/fec_ptp.c
>> index 945643c..f8a592c 100644
>> --- a/drivers/net/ethernet/freescale/fec_ptp.c
>> +++ b/drivers/net/ethernet/freescale/fec_ptp.c
>> @@ -452,6 +452,18 @@ static int fec_ptp_enable(struct ptp_clock_info *ptp,
>>  	return -EOPNOTSUPP;
>>  }
>>  
>> +/**
>> + * fec_ptp_disable_hwts - disable hardware time stamping
>> + * @ndev: pointer to net_device
>> + */
>> +void fec_ptp_disable_hwts(struct net_device *ndev)
>
> This is not really needed, is it?
> - PHY ability of hwtstamping does not change across the runtime of the
>   kernel (or do you have a "special" one where it does?)
> - The initial values for hwts_tx_en and hwts_rx_en are already 0
> - There is no code path for which it is possible for hwts_tx_en or
>   hwts_rx_en to have been non-zero prior to this call making them
>   zero.

If everybody agree it is not needed, I'm fine getting it out of the
patch, but please consider my worries below.

I'm afraid your third statement might happen to be not exactly true.
It's due to this same path the hwts_tx_en could end-up being set, as we
have if() on phy_has_hwtstamp(phydev), so the path can set hwts_xx_en if
this code gets somehow run when phydev->phy is set to 0, or attached PHY
is not yet has PTP property.

I'm not sure it can happen, but essential thing here is that I have no
evidence it can't, and another place to ensure hwts_xx_en fields are
cleared would be at the time of attachment of PTP-aware PHY, by check
and clear and that time, yet even here it'd rely on PTP-awareness being
already established at the moment.

The second variant is harder for me to figure, yet is less reliable, so,
overall, I preferred to keep the proposed solution that I believe should
work no matter what, and let somebody who is more fluid in the code-base
to get responsibility to remove it. For example, I didn't want to even
start to consider how all this behaves on cable connect/disconnect, if
up/down, or over hibernation.

>
> It is just "to be sure", in a very non-necessary way.

It is "to be sure", without "just", as I tried to explain above. If it
were my own code, I'd ask for an evidence that this part is not needed,
before getting rid of this safety belt.

>
> But nonetheless, it shouldn't be present in this patch either way, due
> to the fact that one patch should have one topic only, and the topic of
> this patch should be solving a clearly defined bug.

I actually don't care either way, but to be picky, the answer depends on
particular definition of the bug, and the bug I have chased, and its
definition I've used, even in the original series, requires simultaneous
fixes in 2 places of the code.

You have yet another bug in mind that part of my original patch happens
to solve, yes, but that, by itself, doesn't necessarily mean the patch
should be split. Nevertheless, I honestly tried to split it, according
to our agreement, but failed, see above, and I still willing to try
again, provided somebody actually needs it.

Thanks,
-- Sergey
