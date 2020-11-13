Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 908862B1387
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 01:51:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbgKMAvb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 19:51:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726055AbgKMAv2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 19:51:28 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2995DC0613D1;
        Thu, 12 Nov 2020 16:51:28 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id dk16so10784576ejb.12;
        Thu, 12 Nov 2020 16:51:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dmDtVKNd6s9AOBlam/rcWRuLOFWfl5+bHC3jAGhX/XE=;
        b=ryp14lO/ekfdqaPgfSHn9SbmIPJGpUA6g02EJr6VsRTe/kaavIIdH5k7X431dX3ZtJ
         RCyEptyaMGS/GA2i+8Fa6Uj7CsOn1zRFX1ftjnt6yoTh+D+srPlqmC1eqiQ43E+noPK7
         nWSJmAY4UC3RU9SbdHU1lqgg46YNKZQBj8dokTwx1yqUBv9zbCDAUeKPWSlEhgmJXy61
         mEI6pUTMzeY/gYHRjwpvjMVir+pU7ouhgP3r5kf//vbjl9XlgFqls+2sUBptUpQIBuSD
         y14uTPFJHgp/j12Vc8qBaStxNJLVs1fWWQAKRUDxYSPoLZemabj9cigGUfx+JYFiPDQ+
         F8Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dmDtVKNd6s9AOBlam/rcWRuLOFWfl5+bHC3jAGhX/XE=;
        b=fikj5zosggkr4WWXUKXpE4SOIQmn5Ev3lIxBVaoJdl/0f9jEpRk6JqHxnMn8aaWsiB
         3+O3jUHNcXORQavEZg6zxpqM7vb99PoV9kR2zPDq52iRmml7DrfD1h2knSS1vnLTL78y
         EoqQhZbl1qEPlrvF974Gm+deq8rQp+HhtSsMf0sJ6zXTeOCpyDEpN8Gf2FaWDcPuNsIV
         4Nf65X65cTvy5ZF1B0J5kh5/ApBilqRBvaM6cbSeGFUEk5F6uLn5UJ2Ry91s9iA8u86A
         EX1AlRdGDGbRGiYzNNwQ1jcSmOru5EYnkMZ46xpWFsuDk0UjUjWGz2dpwv9LdoRmx35C
         FYRA==
X-Gm-Message-State: AOAM530XPJSJXihEYwIG7+MeXP3Rd8Tui2AKCEC2s2/stn5e14y1jRT3
        6RkbVI3CKJCID7uSMm19iEA=
X-Google-Smtp-Source: ABdhPJy6XyeljeVl2ggvQUbCAcWdGE5SyVCtenmHJ8JiqLDbHr7jWRoSTfrT6ys/hzCDtyYOOdwfeA==
X-Received: by 2002:a17:906:60c8:: with SMTP id f8mr2079921ejk.14.1605228686821;
        Thu, 12 Nov 2020 16:51:26 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id h23sm3052105edv.69.2020.11.12.16.51.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 16:51:26 -0800 (PST)
Date:   Fri, 13 Nov 2020 02:51:24 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Eggers <ceggers@arri.de>
Cc:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Richard Cochran <richardcochran@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>,
        George McCollister <george.mccollister@gmail.com>,
        Marek Vasut <marex@denx.de>,
        Helmut Grohne <helmut.grohne@intenta.de>,
        Paul Barker <pbarker@konsulko.com>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 08/11] net: ptp: add helper for one-step P2P
 clocks
Message-ID: <20201113005124.n3stqpzafx65tz2u@skbuf>
References: <20201112153537.22383-1-ceggers@arri.de>
 <20201112153537.22383-9-ceggers@arri.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201112153537.22383-9-ceggers@arri.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 12, 2020 at 04:35:34PM +0100, Christian Eggers wrote:
> This function subtracts the ingress hardware time stamp from the
> correction field of a PTP header and updates the UDP checksum (if UDP is
> used as transport. It is needed for hardware capable of one-step P2P

Please close the parenthesis.

> that does not already modify the correction field of Pdelay_Req event
> messages on ingress.
> 
> Signed-off-by: Christian Eggers <ceggers@arri.de>

Please add more verbiage here, giving the reader as much context as
possible. You are establishing a de-facto approach for one-step peer
delay timestamping for hardware like yours, you need to explain why it
is done this way, for people to understand just by looking at git blame.

> ---
>  include/linux/ptp_classify.h | 97 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 97 insertions(+)
> 
> diff --git a/include/linux/ptp_classify.h b/include/linux/ptp_classify.h
> index 56b2d7d66177..f27b512e1abd 100644
> --- a/include/linux/ptp_classify.h
> +++ b/include/linux/ptp_classify.h
> @@ -10,8 +10,12 @@
>  #ifndef _PTP_CLASSIFY_H_
>  #define _PTP_CLASSIFY_H_
>  
> +#include <asm/unaligned.h>
>  #include <linux/ip.h>
> +#include <linux/ktime.h>
>  #include <linux/skbuff.h>
> +#include <linux/udp.h>
> +#include <net/checksum.h>
>  
>  #define PTP_CLASS_NONE  0x00 /* not a PTP event message */
>  #define PTP_CLASS_V1    0x01 /* protocol version 1 */
> @@ -118,6 +122,91 @@ static inline u8 ptp_get_msgtype(const struct ptp_header *hdr,
>  	return msgtype;
>  }
>  
> +/**
> + * ptp_check_diff8 - Computes new checksum (when altering a 64-bit field)
> + * @old: old field value
> + * @new: new field value
> + * @oldsum: previous checksum
> + *
> + * This function can be used to calculate a new checksum when only a single
> + * field is changed. Similar as ip_vs_check_diff*() in ip_vs.h.
> + *
> + * Return: Updated checksum
> + */
> +static inline __wsum ptp_check_diff8(__be64 old, __be64 new, __wsum oldsum)
> +{
> +	__be64 diff[2] = { ~old, new };
> +
> +	return csum_partial(diff, sizeof(diff), oldsum);
> +}
> +
> +/**
> + * ptp_onestep_p2p_move_t2_to_correction - Update PTP header's correction field
> + * @skb: packet buffer
> + * @type: type of the packet (see ptp_classify_raw())
> + * @hdr: ptp header
> + * @t2: ingress hardware time stamp
> + *
> + * This function subtracts the ingress hardware time stamp from the correction
> + * field of a PTP header and updates the UDP checksum (if UDP is used as
> + * transport). It is needed for hardware capable of one-step P2P that does not
> + * already modify the correction field of Pdelay_Req event messages on ingress.
> + */
> +static inline
> +void ptp_onestep_p2p_move_t2_to_correction(struct sk_buff *skb,
> +					   unsigned int type,
> +					   struct ptp_header *hdr,
> +					   ktime_t t2)

The way this function is coded up right now, there's no reason to call it:
- onestep
- p2p
- move_t2_to_correction
As it is, it would be better named ptp_header_update_correction.

> +{
> +	u8 *ptr = skb_mac_header(skb);
> +	struct udphdr *uhdr = NULL;
> +	s64 ns = ktime_to_ns(t2);
> +	__be64 correction_old;
> +	s64 correction;
> +
> +	/* previous correction value is required for checksum update. */
> +	memcpy(&correction_old,  &hdr->correction, sizeof(correction_old));
> +	correction = (s64)be64_to_cpu(correction_old);
> +
> +	/* PTP correction field consists of 32 bit nanoseconds and 16 bit

48 bit nanoseconds

> +	 * fractional nanoseconds.  Avoid shifting negative numbers.
> +	 */
> +	if (ns >= 0)
> +		correction -= ns << 16;
> +	else
> +		correction += -ns << 16;

Again? Why? There's nothing wrong with left-shifting negative numbers,
two's complement works the same (note that right-shifting is a different
story, but that's not the case here).

> +
> +	/* write new correction value */
> +	put_unaligned_be64((u64)correction, &hdr->correction);
> +
> +	/* locate udp header */
> +	if (type & PTP_CLASS_VLAN)
> +		ptr += VLAN_HLEN;

Can't you just go back from the struct ptp_header pointer and avoid this
check?

> +	ptr += ETH_HLEN;
> +
> +	switch (type & PTP_CLASS_PMASK) {
> +	case PTP_CLASS_IPV4:
> +		ptr += ((struct iphdr *)ptr)->ihl << 2;
> +		uhdr = (struct udphdr *)ptr;
> +		break;
> +	case PTP_CLASS_IPV6:
> +		ptr += IP6_HLEN;
> +		uhdr = (struct udphdr *)ptr;
> +		break;
> +	}
> +
> +	if (!uhdr)
> +		return;
> +
> +	/* update checksum */
> +	uhdr->check = csum_fold(ptp_check_diff8(correction_old,
> +						hdr->correction,
> +						~csum_unfold(uhdr->check)));
> +	if (!uhdr->check)
> +		uhdr->check = CSUM_MANGLED_0;
> +}
> +
> 
