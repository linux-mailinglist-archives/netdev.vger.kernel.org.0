Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D52FD10805B
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 21:28:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbfKWU2B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 15:28:01 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:46890 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726620AbfKWU2B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 15:28:01 -0500
Received: by mail-pf1-f193.google.com with SMTP id 193so5306671pfc.13
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 12:28:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TyIyFydgEOTKMkZQJp8UfydgrlE90NThieqDBtzIVUk=;
        b=c68pGY32kcbyZCx1dbHiPf15c4m6uqWAUyFlJNnptCT4i0V0eLLVuK/oyxslHipZ/K
         mBSTNl4HODLf7kaCWgz8MNoh8lxud3ubn/d9VKSr6IRkVqjp0IxLKRxfAbBF/y3Tk77Q
         owgtKn+WL41lWqi8nFbcPduvsUpI4pF9waSKPwsTkqm4S62blFlOBJ/0qYQuvb12qXgJ
         2pJzT0nSaAQV4xozDlnuWod9/NAxUNi1a982/2dxCbY/9BlrUXJ4FDv7wM6H9S/Jjp5H
         pq/YazEAvMt2mdW8ZOiQpwbPLrrol3086g8jHDJsjYZ9peKO+ocuqhfgtdnRSfJd/dX+
         TjSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=TyIyFydgEOTKMkZQJp8UfydgrlE90NThieqDBtzIVUk=;
        b=j8pnokkARBYxMsFboWE/lgwWqmtT4FdTu9PYyNBAH2ILK715C/yHKdOM3UdcwHspdm
         TAyUcHW3Vl7wY7YtnT1NG+r3UPTEIP1kPZ854O/YSjb+w7jiv3tnzsvhRTeAbJB8nMiN
         G/xAoZUs7Itp/ZvKi1AcUJU3EzxLlTsetuz4FXuL+YUgG7DPEwjgiKnrgCUdaoe0XWSl
         7yKU9BLRvs6NC84WQ8BTkOYODsFxwwFalpAdU4d5vhD6lJf5aY/duGXNQGu22gaOiHML
         Dx0ot1EnUKnoRDmdItHoOioajciyToV1wLTiCCSaJZLc9nPBdXkH/RTHsmUr68HS5ZFC
         bL3A==
X-Gm-Message-State: APjAAAX3+vkPPKOWFzryrptSqHwCG8fMAZk+UKm6o1QhOojN9HKOB0xH
        FZcrzMLvvQYgw7+Z2YeRu6jzvU06
X-Google-Smtp-Source: APXvYqwd5vc5pSvj/rm5HSoEkF8Xj2EgmO0gDhci/MPqTpckATb8h+c/gJNINuKP5fVU89FWT/xQvw==
X-Received: by 2002:a62:7f93:: with SMTP id a141mr25641980pfd.82.1574540879508;
        Sat, 23 Nov 2019 12:27:59 -0800 (PST)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id z10sm2582099pfr.139.2019.11.23.12.27.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 Nov 2019 12:27:58 -0800 (PST)
Subject: Re: [PATCH net-next 1/3] net: dsa: Configure the MTU for switch ports
To:     Vladimir Oltean <olteanv@gmail.com>, andrew@lunn.ch,
        vivien.didelot@gmail.com, davem@davemloft.net,
        jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org
References: <20191123194844.9508-1-olteanv@gmail.com>
 <20191123194844.9508-2-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 a9BQwACgnzGuH1BVeT2J0Ra+ZYgkx7DaPR0=
Message-ID: <329f394b-9e6c-d3b0-dc3d-5e3707fa8dd7@gmail.com>
Date:   Sat, 23 Nov 2019 12:27:58 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191123194844.9508-2-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On 11/23/2019 11:48 AM, Vladimir Oltean wrote:
> It is useful be able to configure port policers on a switch to accept
> frames of various sizes:
> 
> - Increase the MTU for better throughput from the default of 1500 if it
>   is known that there is no 10/100 Mbps device in the network.
> - Decrease the MTU to limit the latency of high-priority frames under
>   congestion.
> 
> For DSA slave ports, this is mostly a pass-through callback, called
> through the regular ndo ops and at probe time (to ensure consistency
> across all supported switches).
> 
> The CPU port is called with an MTU equal to the largest configured MTU
> of the slave ports. The assumption is that the user might want to
> sustain a bidirectional conversation with a partner over any switch
> port.
> 
> The DSA master is configured the same as the CPU port, plus the tagger
> overhead. Since the MTU is by definition L2 payload (sans Ethernet
> header), it is up to each individual driver to figure out if it needs to
> do anything special for its frame tags on the CPU port (it shouldn't
> except in special cases). So the MTU does not contain the tagger
> overhead on the CPU port.
> However the MTU of the DSA master, minus the tagger overhead, is used as
> a proxy for the MTU of the CPU port, which does not have a net device.
> This is to avoid uselessly calling the .change_mtu function on the CPU
> port when nothing should change.
> 
> So it is safe to assume that the DSA master and the CPU port MTUs are
> apart by exactly the tagger's overhead in bytes.
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> ---

[snip]
> +static int dsa_slave_change_mtu(struct net_device *dev, int new_mtu)
> +{
> +	struct net_device *master = dsa_slave_to_master(dev);
> +	struct dsa_slave_priv *p = netdev_priv(dev);
> +	struct dsa_switch *ds = p->dp->ds;
> +	struct dsa_port *cpu_dp;
> +	int port = p->dp->index;
> +	int max_mtu = 0;
> +	int cpu_mtu;
> +	int err, i;
> +
> +	if (!ds->ops->change_mtu)
> +		return -EOPNOTSUPP;
> +
> +	err = ds->ops->change_mtu(ds, port, new_mtu);
> +	if (err < 0)
> +		return err;
> +
> +	dev->mtu = new_mtu;
> +
> +	for (i = 0; i < ds->num_ports; i++) {
> +		if (!dsa_is_user_port(ds, i))
> +			continue;
> +
> +		/* During probe, this function will be called for each slave
> +		 * device, while not all of them have been allocated. That's
> +		 * ok, it doesn't change what the maximum is, so ignore it.
> +		 */
> +		if (!dsa_to_port(ds, i)->slave)
> +			continue;
> +
> +		if (max_mtu < dsa_to_port(ds, i)->slave->mtu)
> +			max_mtu = dsa_to_port(ds, i)->slave->mtu;
> +	}
> +
> +	cpu_dp = dsa_to_port(ds, port)->cpu_dp;
> +
> +	max_mtu += cpu_dp->tag_ops->overhead;
> +	cpu_mtu = master->mtu;
> +
> +	if (max_mtu != cpu_mtu) {
> +		err = ds->ops->change_mtu(ds, dsa_upstream_port(ds, port),
> +					  max_mtu - cpu_dp->tag_ops->overhead);
> +		if (err < 0)
> +			return err;

Before changing and committing the slave_dev's MTU you should actually
perform these two operations first to make sure that you can honor the
user port MTU that is requested. Here, you would possibly leave an user
port configured for a MTU value that is unsupported by the upstream
port(s) and/or the CPU port and/or the DSA master device, which could
possibly break frame forwarding depending on what the switch is willing
to accept.

I had prepared a patch series with Murali doing nearly the same thing
and targeting Broadcom switches nearly a year ago but since I never got
feedback whether this worked properly for the use case he was after, I
did not submit it since I did not need it personally and found it to be
a nice can of worms.

Another thing that I had not gotten around testing was making sure that
when a slave_dev gets enslaved as a bridge port member, that bridge MTU
normalization would kick in and make sure that if you have say: port 0
configured with MTU 1500 and port 1 configured with MTU 9000, the bridge
would normalize to MTU 1500 as you would expect.

https://github.com/ffainelli/linux/commits/dsa-mtu

This should be a DSA switch fabric notifier IMHO because changing the
MTU on an user port implies changing the MTU on every DSA port in
between plus the CPU port. Your approach here works for the first
upstream port, but not for the ones in between, and there can be more,
as is common with the ZII devel Rev. B and C boards.
-- 
Florian
