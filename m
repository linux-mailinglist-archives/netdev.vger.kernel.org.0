Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BA9E3DC695
	for <lists+netdev@lfdr.de>; Sat, 31 Jul 2021 17:19:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233381AbhGaPT1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Jul 2021 11:19:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233035AbhGaPTX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Jul 2021 11:19:23 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAC96C06175F;
        Sat, 31 Jul 2021 08:19:14 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id n28-20020a05600c3b9cb02902552e60df56so8275163wms.0;
        Sat, 31 Jul 2021 08:19:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Jmdv6+M5DYVmC5tUgYPclAdQAFpA2evNf07gbE3dhFc=;
        b=eNRuBJhzC4yV3oxU+1Ew124brFKLkYUbMbXgcgUI4/pIoRHhndPX0ptjQVxg8bNlhI
         gKacsZYdczqGm05lbIfrnjacpt+XH5dYVtscYHKcdeHSyjfk1PetJnceQWh9ljlS4KMK
         EYw8ri68aPwSzsmkWtIlfNCw9/jFh/hFiDhZyvMTb+MMHKFnwMm9dT/vNib923upc9kC
         jytC2odxVSkuRZ+Ga5On0/sq0YGS6PYXpTFXFAgaGu71aETOQWVf41o3f42eKIU23U0b
         NzC3Ub0dypzdGLWd5syATjcRoNYlR0a4uBnwp03ofYnA03tZ56SQ6sOcIEyPJN+jL5oA
         6IYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Jmdv6+M5DYVmC5tUgYPclAdQAFpA2evNf07gbE3dhFc=;
        b=DQiWYZURO+ta6m06jKjt4hF3Vn1g10UgzbSfpC/DgGdJqc+ZdNa1fjpmCwCWhvsxt1
         iZXEG7W+JmHElagRrjO80/afaUv2PF6cj02MPQs6A+bXp1ld5hG5RelPNNXTYN0pnCoI
         GRJ2G0kyC5CGZeIWz0wDQKwPHSqXYL7PsNidv3+1tWdI+5k27iD2L94qRMEAtSUsnALx
         VC58FAkVxVsu39PaFKMPUNvTCsN8CTNGX9LoVe0lpz72CCKAFRXBnFj9I8bsWFrpb1oK
         IT4ldIP+3fPOE5gCbevTEXQ0kah514WLJ4pwastDEjR935Q16pQI9f/GzmVNZ+ZvTW+k
         pnWw==
X-Gm-Message-State: AOAM533k81cNoG+g6qPdenM+zmjtkKn/clMMfXmleBPznczQ1xlCXaY5
        suk2ZZzuw9+S9A3xMMBi+t0=
X-Google-Smtp-Source: ABdhPJyF4xMvhdF6wJMt19uS8hGHglYfEFl0jJFjIQnPMnD+nNSIy7SiMWNgWGACJ/E+hpdlB1bZ5g==
X-Received: by 2002:a05:600c:b59:: with SMTP id k25mr8692388wmr.51.1627744753511;
        Sat, 31 Jul 2021 08:19:13 -0700 (PDT)
Received: from skbuf ([82.76.66.29])
        by smtp.gmail.com with ESMTPSA id d203sm4885942wmd.38.2021.07.31.08.19.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Jul 2021 08:19:12 -0700 (PDT)
Date:   Sat, 31 Jul 2021 18:19:11 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Cc:     andrew@lunn.ch, netdev@vger.kernel.org, robh+dt@kernel.org,
        UNGLinuxDriver@microchip.com, Woojung.Huh@microchip.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v3 net-next 09/10] net: dsa: microchip: add support for
 fdb and mdb management
Message-ID: <20210731151911.zfapctgfc2l6ycaa@skbuf>
References: <20210723173108.459770-1-prasanna.vengateshan@microchip.com>
 <20210723173108.459770-10-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210723173108.459770-10-prasanna.vengateshan@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 23, 2021 at 11:01:07PM +0530, Prasanna Vengateshan wrote:
> +static int lan937x_port_fdb_add(struct dsa_switch *ds, int port,
> +				const unsigned char *addr, u16 vid)
> +{
> +	struct ksz_device *dev = ds->priv;
> +	u8 fid = lan937x_get_fid(vid);
> +	u32 alu_table[4];
> +	int ret, i;
> +	u32 data;
> +	u8 val;
> +
> +	mutex_lock(&dev->alu_mutex);
> +
> +	/* Accessing two ALU tables through loop */
> +	for (i = 0; i < ALU_STA_DYN_CNT; i++) {
> +		/* find any entry with mac & fid */
> +		data = fid << ALU_FID_INDEX_S;
> +		data |= ((addr[0] << 8) | addr[1]);

Maybe upper_32_bits(ether_addr_to_u64(addr)) and
lower_32_bits(ether_addr_to_u64(addr)) would be slightly easier on the
eye?

> +		if (alu_table[0] & ALU_V_STATIC_VALID) {
> +			/* read ALU entry */
> +			ret = lan937x_read_table(dev, alu_table);
> +			if (ret < 0) {
> +				dev_err(dev->dev, "Failed to read ALU table\n");
> +				break;
> +			}
> +
> +			/* clear forwarding port */
> +			alu_table[1] &= ~BIT(port);
> +
> +			/* if there is no port to forward, clear table */
> +			if ((alu_table[1] & ALU_V_PORT_MAP) == 0) {
> +				alu_table[0] = 0;
> +				alu_table[1] = 0;
> +				alu_table[2] = 0;
> +				alu_table[3] = 0;

memset?

> +			}
> +		} else {
> +			alu_table[0] = 0;
> +			alu_table[1] = 0;
> +			alu_table[2] = 0;
> +			alu_table[3] = 0;
> +		}
> +
> +		ret = lan937x_write_table(dev, alu_table);
> +		if (ret < 0)
> +			break;
