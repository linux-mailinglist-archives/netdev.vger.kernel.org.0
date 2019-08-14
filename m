Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7894D8C502
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 02:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726316AbfHNAVO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 20:21:14 -0400
Received: from mail-qt1-f180.google.com ([209.85.160.180]:45316 "EHLO
        mail-qt1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726007AbfHNAVO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 20:21:14 -0400
Received: by mail-qt1-f180.google.com with SMTP id k13so11064682qtm.12
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 17:21:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=b2VUq5MwZqpurFanOdLTxoPZRa90061wQcUNAC1MqhI=;
        b=Mr86EnbifMSNk0aGsz6+JaEYChGtiH6TtoGiNJUkAqBah20bvbskZNNHStGfwWsaqz
         D9+hLpvPciG5h5SLRH1TSYltSbAAQRANi4bI7am9ulqjBGM/iMjGsptq4iJrPwBmVbMn
         eU+gLJTDhGcfw9IPzANMu6cLoYMPa8gwAgZYe/epLS55co2uwMWSJrAbW/LpIVEB1PKW
         wbi/WZvGoLP4D4WfUwLCbKrCIP5BAGBRA3IndOZqI4NOpYQlCFoI4nyoR8fpT9W+9BGI
         nBSxl5w5gk7+8Yhc+BrqwsKTpdtu1eHC7sBab6h/bh115QdYlQTCYrDIeKnzz4XlVUEq
         UIig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=b2VUq5MwZqpurFanOdLTxoPZRa90061wQcUNAC1MqhI=;
        b=m3QHdtEbH0ZajN8yDhP1UYA+J8MXIYD+0FgqXW57bwjaoAkzcpjBnGkucD3z1Rah0s
         q3l9GNuJnmV4DFmph+WF1uqAHZdAO8nP7zqgFj1Qh8aVz57XkqG4b5T3MQuj5Ba9ihXK
         bM9ZYeRrXay5gsmiz5oDZIJJbTyK0ctCNzc9HcVQqS+vgFiWzTmQx5iBc5Gtf0y3Gw3g
         z8P1/PJa3cb65krmU7NsVcOcSRtoFxpDaBY812JvzTiPLmmbhApRPIfWjKzKq+TD6OE7
         3EDSkpCIVqMsULqWCp0py38oxbDsbKiapCnoppQ4MX5oMJPMHaN8SwOqK2IGFlAQMijq
         Wpww==
X-Gm-Message-State: APjAAAVaazdlcdKFzY4oPk7wbrsF1RMWpK4+4nlI6/gnIqRlDXMjywML
        NJgC4D/4JsHdyf9LFZ5PKFVo2w==
X-Google-Smtp-Source: APXvYqx+f3UcBSxUzCAZ0Gd/sMRckAN+rIDWAaD6y4LFXzlLUS9zdc1DAPl1i+CGoEXR5Ze/YPZiUA==
X-Received: by 2002:ac8:4602:: with SMTP id p2mr11691177qtn.291.1565742073188;
        Tue, 13 Aug 2019 17:21:13 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id q29sm13519937qtf.74.2019.08.13.17.21.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Aug 2019 17:21:13 -0700 (PDT)
Date:   Tue, 13 Aug 2019 17:21:03 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v2 0/3] net: phy: let phy_speed_down/up support
 speeds >1Gbps
Message-ID: <20190813172103.14678de0@cakuba.netronome.com>
In-Reply-To: <dca82a0e-e936-b60a-3a1c-9fdb1714d1d3@gmail.com>
References: <dca82a0e-e936-b60a-3a1c-9fdb1714d1d3@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 12 Aug 2019 23:47:45 +0200, Heiner Kallweit wrote:
> So far phy_speed_down/up can be used up to 1Gbps only. Remove this
> restriction and add needed helpers to phy-core.c
> 
> v2:
> - remove unused parameter in patch 1
> - rename __phy_speed_down to phy_speed_down_core in patch 2

Applied, thanks.
