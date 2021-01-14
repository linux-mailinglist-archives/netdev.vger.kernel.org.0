Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEB482F5581
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 01:16:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729639AbhANAPP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 19:15:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729812AbhANANs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 19:13:48 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86F50C0617A4;
        Wed, 13 Jan 2021 16:10:07 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id b6so3404106edx.5;
        Wed, 13 Jan 2021 16:10:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=rj2crcQ/IZtgH+p50bCWVHg0wJ+YFm6EnGhDzudnKJQ=;
        b=CJ5IyqYDwPIrmHWDzzDJ0wqTuECN6JmIEq20ZUg64UFA0hixOQwfgEt7soECHdlyDE
         dxTtKDFaONXywjzklxS7ea+fdi74NYhBuVT5mx8FCkYiiogbG0fmrYnk2r73+4vJj1TL
         8r6F7KgrXiTPws7HFCRj8116a8/u4OK02cs9tghFG6wo0OOqqOPiHcP9Bbkh0ir/KcS4
         TRKLnanNiReovvhzEsivbpfqop/ygUM4h+LL2q3/w4YNrgWmCvQFn9AqVid+3RZV/Ay1
         +TSTTkcAxZW6/TqR/PY7NJII8xVpAmNz+dIv8/0/uReoC8gQQg5Rqm21pUhBzGxfvITX
         KkpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=rj2crcQ/IZtgH+p50bCWVHg0wJ+YFm6EnGhDzudnKJQ=;
        b=EhrIlxl3SQxYdlrq2sBlOQz0BmTVr7pplImTgRI1TKMulkmTyFEnc4oisopVaZjNff
         mDPV83UvCshu5bmZq48ju7nuukOr6KWoJLftquf2QVY49fiwP0zmTKztG0aCSW1/b1EP
         5qPVxZgcEQ6t8P/gLNeZ+Z7uOIg2wbd/GpQC0bKb3lN73o1P/HNhMzQV3Q+thV3JMetK
         M6shP9vAcfxnuujRv3DDk0XsLTP1PDBcGRtX6fiZhav7eTozLk6IaoYxtes2XHJRxNlU
         YZhPhW3xCWUP/7gO75oFrSREjwOldEmcRrd/KixmMNSs346SfWC2Nj0Z7pOgWsTEzgc0
         hZBQ==
X-Gm-Message-State: AOAM533PehRzRtwrscbQKswGoKXvVDDuKQcT7rHrH3siokO2YVbS/jv4
        pdGjCumtAMxr6RB/JgIrjxY=
X-Google-Smtp-Source: ABdhPJxnh3zMjUvL+BojCxLrT3H1ehKl0PvJZWs1BTMoRw0/pTaVAm+QX6ptLLf8Oh0PE30gRaxUiw==
X-Received: by 2002:a05:6402:310f:: with SMTP id dc15mr3695554edb.225.1610583006295;
        Wed, 13 Jan 2021 16:10:06 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id hr31sm1265819ejc.125.2021.01.13.16.10.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jan 2021 16:10:05 -0800 (PST)
Date:   Thu, 14 Jan 2021 02:10:04 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Gilles DOFFE <gilles.doffe@savoirfairelinux.com>
Cc:     netdev@vger.kernel.org, Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 3/6] net: dsa: ksz: insert tag on ks8795 ingress
 packets
Message-ID: <20210114001004.zn7yf5ztej2mujsh@skbuf>
References: <cover.1610540603.git.gilles.doffe@savoirfairelinux.com>
 <bc79946d1dafded91729ee1674c1b88a3beea110.1610540603.git.gilles.doffe@savoirfairelinux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bc79946d1dafded91729ee1674c1b88a3beea110.1610540603.git.gilles.doffe@savoirfairelinux.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 13, 2021 at 01:45:19PM +0100, Gilles DOFFE wrote:
> If 802.1q VLAN tag is removed from egress traffic, ingress
> traffic should by logic be tagged.
> 
> Signed-off-by: Gilles DOFFE <gilles.doffe@savoirfairelinux.com>
> ---
>  drivers/net/dsa/microchip/ksz8795.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
> index 4b060503b2e8..193f03ef9160 100644
> --- a/drivers/net/dsa/microchip/ksz8795.c
> +++ b/drivers/net/dsa/microchip/ksz8795.c
> @@ -874,6 +874,7 @@ static void ksz8795_port_vlan_add(struct dsa_switch *ds, int port,
>  	}
>  
>  	ksz_port_cfg(dev, port, P_TAG_CTRL, PORT_REMOVE_TAG, untagged);
> +	ksz_port_cfg(dev, port, P_TAG_CTRL, PORT_INSERT_TAG, !untagged);
>  }
>  
>  static int ksz8795_port_vlan_del(struct dsa_switch *ds, int port,
> -- 
> 2.25.1
> 

KSZ8795 manual says:

TABLE 4-4: PORT REGISTERS
Bit 2: Tag insertion
1 = When packets are output on the port, the switch
will add 802.1q tags to packets without 802.1q tags
when received. The switch will not add tags to
packets already tagged. The tag inserted is the
ingress port’s “Port VID.”
0 = Disable tag insertion.

Bit 1: Tag Removal
1 = When packets are output on the port, the switch
will remove 802.1q tags from packets with 802.1q
tags when received. The switch will not modify
packets received without tags.
0 = Disable tag removal.

What I understand from this is that the "Tag Removal" bit controls
whether the port will send all VLANs as egress-untagged or not.

Whereas the "Tag insertion" bit controls whether the pvid of the ingress
port will be sent as egress-tagged (if the insertion bit is 1), or as-is
(probably egress-untagged) (if the insertion bit is 0) on the egress
port.

I deduce that the "Tag Removal" bit overrules the "Tag insertion" bit of
a different port, if both are set. Example:

lan0:               lan1
pvid=20
Tag insertion=1     Tag removal=0

An untagged packet forwarded from lan0 to lan1 should be transmitted as
egress-tagged, because lan0 is configured to insert its pvid into the
frames.

But:

lan0:               lan1
pvid=20
Tag insertion=1     Tag removal=1

An untagged packet forwarded from lan0 to lan1 should be transmitted as
untagged, because even though lan0 inserted its pvid into the frame,
lan1 removed it.

Based on my interpretation of the manual, I believe you have a lot more
work to do than simply operating "by logic". You can test, but I don't
believe that the PORT_INSERT_TAG flag affects the port on which the
switchdev VLAN object is supposed to be offloading. On the contrary: it
affects every other port in the same bridge _except_ for that one.
