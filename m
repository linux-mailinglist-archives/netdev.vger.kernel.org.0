Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 908D3123A85
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 00:08:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbfLQXIv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 18:08:51 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:33668 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726467AbfLQXIv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 18:08:51 -0500
Received: by mail-lj1-f195.google.com with SMTP id p8so6213580ljg.0
        for <netdev@vger.kernel.org>; Tue, 17 Dec 2019 15:08:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=aGiB+hbSb9LA36NPoJtb7z2ChL7/cE8oaRzpEVpg4xY=;
        b=oeleUBPdDbOz5yUEadMq26sIIXeXyzMJVh5AKg+rfxxa6qrVXWpmVAuQsBbyY5l6pa
         VfbTQWrC3v1a9rfIm5Quejgv9tFi/+ert3ZMEyKp005+tyOC0XAEVcAMriz9gYl8/nJP
         DaOhA18cLXy18h4fZHDT/9cAJEPUOae43La46AE/vaHD0sidTb9gMb9FfPHRjpk1r/mK
         +TcZSmbzWyVwfNtrer+doj6A4kpUT6ScA4S7rzGIiJSbj2f4f/DjCdgZek0+/CIziilJ
         i6GJISoJUff7mOjry42NaefmsL5lCtNb7Yb+OzjH+fDHlegO+3i9U/s4xtEm5AMug85+
         gIKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=aGiB+hbSb9LA36NPoJtb7z2ChL7/cE8oaRzpEVpg4xY=;
        b=RhDmKZMSQAth72uqfjMOLIdISlbq7nqlAZ8dhTWsercq7QbozYhPRUXwkAx++8JzCg
         hUZjMSxV6t2Y/REC5VOKPuB70681WmD0SdN6rX0GP5TmrQmSIJsmJDp8hHwaune5zXJW
         WDjGmegnmdGUWgODUz7XKtzIstnYB+mUwy+7kZCIo7sLHjb8soajflfTc4exUV0TkzoG
         OgZj3gSusybm1/s5NuNOTAoR3HZwaBEZvFbfPRTlth/uT84oNBk+YIIsFbBQJHJhsnzY
         OFOnJUeM2hY70/JuE4h1p0cCQIJrFF9lcXMLy1fnC3kiA1bm9lixa6RDWo0BZ242bnHM
         JTCw==
X-Gm-Message-State: APjAAAXouab3mkpSR7SIxLdqXpPOqrp4wAtbn2MY7C9M5u5aGvrNUd86
        nzaL9zje5beXZ4O60Y7OntSWNw==
X-Google-Smtp-Source: APXvYqxukD7cTbWUkQTWB6DyDuO/pcX3ri7d1UFgmbDdVl/nzx1L/sDaryeDQItlZCm2Yo/AF3Rtbg==
X-Received: by 2002:a2e:b010:: with SMTP id y16mr203585ljk.238.1576624129615;
        Tue, 17 Dec 2019 15:08:49 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id r125sm74526lff.70.2019.12.17.15.08.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 15:08:49 -0800 (PST)
Date:   Tue, 17 Dec 2019 15:08:41 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Doug Berger <opendmb@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 3/8] net: bcmgenet: use CHECKSUM_COMPLETE for
 NETIF_F_RXCSUM
Message-ID: <20191217150841.563d6fb9@cakuba.netronome.com>
In-Reply-To: <1576616549-39097-4-git-send-email-opendmb@gmail.com>
References: <1576616549-39097-1-git-send-email-opendmb@gmail.com>
        <1576616549-39097-4-git-send-email-opendmb@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Dec 2019 13:02:24 -0800, Doug Berger wrote:
> @@ -1793,6 +1792,10 @@ static unsigned int bcmgenet_desc_rx(struct bcmgenet_rx_ring *ring,
>  
>  			status = (struct status_64 *)skb->data;
>  			dma_length_status = status->length_status;
> +			if (priv->desc_rxchk_en) {
> +				skb->csum = ntohs(status->rx_csum & 0xffff);

This adds a new warning for a W=1 C=1 build:

../drivers/net/ethernet/broadcom/genet/bcmgenet.c:1796:45: warning: cast to res\
tricted __be16                                                                  
../drivers/net/ethernet/broadcom/genet/bcmgenet.c:1796:45: warning: cast to res\
tricted __be16                                                                  
../drivers/net/ethernet/broadcom/genet/bcmgenet.c:1796:45: warning: cast to res\
tricted __be16                                                                  
../drivers/net/ethernet/broadcom/genet/bcmgenet.c:1796:45: warning: cast to res\
tricted __be16                                                                  
../drivers/net/ethernet/broadcom/genet/bcmgenet.c:1796:43: warning: incorrect t\
ype in assignment (different base types)                                        
../drivers/net/ethernet/broadcom/genet/bcmgenet.c:1796:43:    expected restrict\
ed __wsum [usertype] csum                                                       
../drivers/net/ethernet/broadcom/genet/bcmgenet.c:1796:43:    got int           
   
Could you perhaps consider a __force cast or such?

> +				skb->ip_summed = CHECKSUM_COMPLETE;
> +			}
>  		}
>  
>  		/* DMA flags and length are still valid no matter how

