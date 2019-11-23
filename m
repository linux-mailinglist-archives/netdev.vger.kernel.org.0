Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F7C510805D
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 21:30:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726744AbfKWUaQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 15:30:16 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:41876 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726676AbfKWUaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 15:30:16 -0500
Received: by mail-pg1-f193.google.com with SMTP id 207so5109694pge.8
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 12:30:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=M/v3dNxe8diNyLlSuuoeUTwb7+3tRosmkuLTzYNjR20=;
        b=r/RcbhKwq9hvVDblq0o9jc6CKSoFyXnfz5DyqmG8v2qodqSksy+kVSx4OyyLqknpkQ
         HBgaRHcRpLmsChaXndWo/y3UgGRhiN/XQ0O23mxd3mdKP3OJq+Knw6KDvmhceR9uYMWL
         DG+AtSeZx4eWNxZUokMmzXJj9Z7+ABbDCoVGp5CkSTgA47jkl+lGI6BgUD6B2rRp31mV
         +nIKdKac1zX9nnZyORcp6KFRxR5ic4SHVxrOBIQdEHOjQuHCFPq0dgOOCCyzIsxSZtOd
         vzpaWyRHkM5x/ztPw4sHho1NL+PRgqtw2iOSCYdxSjLBIVXyKH3R9Wn+JHiIgdVRfpiK
         YIaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=M/v3dNxe8diNyLlSuuoeUTwb7+3tRosmkuLTzYNjR20=;
        b=EizANGgv2Q5FblStZ7AX+cIceHtnuCngKEyODmsflCkBql7j5EPphzhz08qi3reD4Q
         K81UC0zKEegJNAuFHgw2so+slxtn2m2U7uL71nszxbHvO6iBWfaG2/+tdPWJvroLtN7U
         qodXBeeCsPgR5tHvyPmsVof3ucrTA+BQs/5qnE2FQUiU5ZnoZgltr0plJqrscjKFSH6F
         UWSFaVpHlMya9xutRh9mgYv22Ytk1keCFvKvlARSNsE8fzUowaHXQIkXnelK3IIwh7bf
         B2BZrvf1ceju4KHudFbWPVoy/G93ArnUY2ddhuxGmUzlD3IihxBKHednH92Pk7LVULoX
         oKxQ==
X-Gm-Message-State: APjAAAWY16RUyHg9lticfUA1mmQbVNoxplJv8BTDdKI19/2v+KAGdZ33
        HcktzcUY4OS4mnAvphD9MksuVjYa
X-Google-Smtp-Source: APXvYqyBwQ9r1nAXVwHSsr1Oy0HtXxiHxiPkclRccGYbIQsF6PxfR/KilELMAWB6fD4bFS3UdqspRw==
X-Received: by 2002:a63:591:: with SMTP id 139mr23834957pgf.0.1574541014585;
        Sat, 23 Nov 2019 12:30:14 -0800 (PST)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id y11sm2739863pfq.1.2019.11.23.12.30.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 Nov 2019 12:30:13 -0800 (PST)
Subject: Re: [PATCH net-next 2/3] net: dsa: sja1105: Implement the port MTU
 callbacks
To:     Vladimir Oltean <olteanv@gmail.com>, andrew@lunn.ch,
        vivien.didelot@gmail.com, davem@davemloft.net,
        jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org
References: <20191123194844.9508-1-olteanv@gmail.com>
 <20191123194844.9508-3-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 a9BQwACgnzGuH1BVeT2J0Ra+ZYgkx7DaPR0=
Message-ID: <6bb2b2cb-361f-69bc-0299-26abcb09882f@gmail.com>
Date:   Sat, 23 Nov 2019 12:30:13 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191123194844.9508-3-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/23/2019 11:48 AM, Vladimir Oltean wrote:
> On this switch, the frame length enforcements are performed by the
> ingress policers. There are 2 types of those: regular L2 (also called
> best-effort) and Virtual Link policers (an ARINC664/AFDX concept for
> defining L2 streams with certain QoS abilities). To avoid future
> confusion, I prefer to call the reset reason "Best-effort policers",
> even though the VL policers are not yet supported.
> 
> We also need to change the setup of the initial static config, such that
> DSA calls to .change_mtu (which are expensive) become no-ops and don't
> reset the switch 5 times.
> 
> A driver-level decision is to unconditionally allow single VLAN-tagged
> traffic on all ports. The CPU port must accept an additional VLAN header
> for the DSA tag, which is again a driver-level decision.
> 
> The policers actually count bytes not only from the SDU, but also from
> the Ethernet header and FCS, so those need to be accounted for as well.
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> ---
>  drivers/net/dsa/sja1105/sja1105.h      |  1 +
>  drivers/net/dsa/sja1105/sja1105_main.c | 48 +++++++++++++++++++++++---
>  2 files changed, 45 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
> index d801fc204d19..3a5c8acb6e2a 100644
> --- a/drivers/net/dsa/sja1105/sja1105.h
> +++ b/drivers/net/dsa/sja1105/sja1105.h
> @@ -122,6 +122,7 @@ enum sja1105_reset_reason {
>  	SJA1105_RX_HWTSTAMPING,
>  	SJA1105_AGEING_TIME,
>  	SJA1105_SCHEDULING,
> +	SJA1105_BEST_EFFORT_POLICING,
>  };
>  
>  int sja1105_static_config_reload(struct sja1105_private *priv,
> diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
> index b60224c55244..3d55dd3c7e83 100644
> --- a/drivers/net/dsa/sja1105/sja1105_main.c
> +++ b/drivers/net/dsa/sja1105/sja1105_main.c
> @@ -459,12 +459,12 @@ static int sja1105_init_general_params(struct sja1105_private *priv)
>  #define SJA1105_RATE_MBPS(speed) (((speed) * 64000) / 1000)
>  
>  static void sja1105_setup_policer(struct sja1105_l2_policing_entry *policing,
> -				  int index)
> +				  int index, int mtu)
>  {
>  	policing[index].sharindx = index;
>  	policing[index].smax = 65535; /* Burst size in bytes */
>  	policing[index].rate = SJA1105_RATE_MBPS(1000);
> -	policing[index].maxlen = ETH_FRAME_LEN + VLAN_HLEN + ETH_FCS_LEN;
> +	policing[index].maxlen = mtu;
>  	policing[index].partition = 0;
>  }
>  
> @@ -496,12 +496,16 @@ static int sja1105_init_l2_policing(struct sja1105_private *priv)
>  	 */
>  	for (i = 0, k = 0; i < SJA1105_NUM_PORTS; i++) {
>  		int bcast = (SJA1105_NUM_PORTS * SJA1105_NUM_TC) + i;
> +		int mtu = VLAN_ETH_FRAME_LEN + ETH_FCS_LEN;
> +
> +		if (dsa_is_cpu_port(priv->ds, i))
> +			mtu += VLAN_HLEN;

That really seems like a layering violation it so happens that you use
DSA_TAG_8021Q which is why you need VLAN_ETH_HLEN, but you should not
assume that from with your driver, even if this one is special on so
many counts. How about using use dsa_port(port)->tag_ops->overhead +
ETH_HLEN here?
>  
>  		for (j = 0; j < SJA1105_NUM_TC; j++, k++)
> -			sja1105_setup_policer(policing, k);
> +			sja1105_setup_policer(policing, k, mtu);
>  
>  		/* Set up this port's policer for broadcast traffic */
> -		sja1105_setup_policer(policing, bcast);
> +		sja1105_setup_policer(policing, bcast, mtu);
>  	}
>  	return 0;
>  }
> @@ -1346,6 +1350,7 @@ static const char * const sja1105_reset_reasons[] = {
>  	[SJA1105_RX_HWTSTAMPING] = "RX timestamping",
>  	[SJA1105_AGEING_TIME] = "Ageing time",
>  	[SJA1105_SCHEDULING] = "Time-aware scheduling",
> +	[SJA1105_BEST_EFFORT_POLICING] = "Best-effort policing",
>  };
>  
>  /* For situations where we need to change a setting at runtime that is only
> @@ -1886,6 +1891,39 @@ static int sja1105_set_ageing_time(struct dsa_switch *ds,
>  	return sja1105_static_config_reload(priv, SJA1105_AGEING_TIME);
>  }
>  
> +static int sja1105_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
> +{
> +	int bcast = (SJA1105_NUM_PORTS * SJA1105_NUM_TC) + port;
> +	struct sja1105_l2_policing_entry *policing;
> +	struct sja1105_private *priv = ds->priv;
> +	int tc;
> +
> +	new_mtu += VLAN_ETH_HLEN + ETH_FCS_LEN;

Likewise
-- 
Florian
