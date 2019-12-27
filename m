Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B17212B905
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 19:00:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727210AbfL0SAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 13:00:16 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:36389 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726379AbfL0SAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Dec 2019 13:00:15 -0500
Received: by mail-pj1-f68.google.com with SMTP id n59so5218651pjb.1
        for <netdev@vger.kernel.org>; Fri, 27 Dec 2019 10:00:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=yAi/q24AyfQaGQAYnuWi1+l+OpeZEqyTvDNcM0hvSso=;
        b=UfW1FPHMnqESlMFf4eRcJIJN4xNd52klliaq38YVTyxZ/hLazhIANmVKwK5LGK1LAM
         tK0vCERWVCrNUill70peGUUr0jwej8erlVAnW6OWnLGMLSiD6gB+JzfBsNbW5RLRZG0k
         phkFMiqPUz2y10WqwMPg4BsMECoeZ4EsZRc2I4Y2Cp6Bk7lyQu0M/jLaNX664LDIVuMT
         YvAqj39xi2+5+8x9vaGGs7fAcapj9hTVNPNULFOpygl5XshEIAg4zUm47J2JRXtMWGTg
         AiiAUqgp3WiqFxs4YdRPDsTbtrZ/Mgynb6xWId5qlj56T+7kfwYsYV7oQ6HnLHtiCKkd
         9GsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=yAi/q24AyfQaGQAYnuWi1+l+OpeZEqyTvDNcM0hvSso=;
        b=LNs/Q1b0jhRHgwjAvCUVR2zx/nZlWGQGPDs98HH4vib20JwL7CTJv1XHDtf8jgiPu+
         TJBWdLX9JwcFDv2jVB20PV9q1vmBO5BivAQxmB9ZOua8TuWZ8CWHdhqhDS2qiP6T56M3
         iPR993Lflnz9IVNdCXug4ItGoFVZzgH8SG4te258LjMs4VvhDdYPjxPK3ZaEr/ENSXEO
         3qmypQ/DrS16DEnBWnglAHBXgRISFS3aa8n0Qpsvz5nLaGlYZgQErgGS1CoHZ8eW0M5d
         dohoeFXgPM+BXdCDFPSshYyNxrplGWOhsxSEs0MQEDrCzLiRYix8qCRbHRMI+FAwSkXd
         zK6w==
X-Gm-Message-State: APjAAAUAOw1bIwS6Q6hUtSNIgLrOLJQup0VNi3cYFnB+ockKEDPN2i5K
        YeexEgPRZxOcQJUvHj2/ppY=
X-Google-Smtp-Source: APXvYqxzDJgfdwUik3Sd9aTEGUpxVWg+8SuoywmhPfnerqwzhZktd3DMzWVtoI1ojIN8Bw+6YnuJQA==
X-Received: by 2002:a17:902:7c95:: with SMTP id y21mr13332000pll.150.1577469614763;
        Fri, 27 Dec 2019 10:00:14 -0800 (PST)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id o7sm43580500pfg.138.2019.12.27.10.00.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Dec 2019 10:00:13 -0800 (PST)
Date:   Fri, 27 Dec 2019 10:00:11 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        netdev@vger.kernel.org
Subject: Re: [PATCH net 1/2] gianfar: Fix TX timestamping with stacked (DSA
 and PHY) drivers
Message-ID: <20191227180011.GF1435@localhost>
References: <20191227004435.21692-1-olteanv@gmail.com>
 <20191227004435.21692-2-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191227004435.21692-2-olteanv@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 27, 2019 at 02:44:34AM +0200, Vladimir Oltean wrote:

> But a stacked driver such as a DSA switch or a PTP-capable PHY can
> also set SKBTX_IN_PROGRESS, which is actually exactly what it should do
> in order to denote that the hardware timestamping process is undergoing.

Please remove the text about the PHY.  This driver does not call
skb_tx_timestamp(), and so it isn't possible for a PHY driver to set
the flag.
 
> There have been discussions [0] as to whether non-MAC drivers need or not to
> set SKBTX_IN_PROGRESS at all (whose purpose is to avoid sending 2
> timestamps, a sw and a hw one, to applications which only expect one).
> But as of this patch, there are at least 2 PTP drivers that would break
> in conjunction with gianfar: the sja1105 DSA switch and the TI PHYTER
> (dp83640).

Again, please drop the bit about the phyter.  It is a non-issue here.
The clash with the DSA layer is reason enough for this patch.

> Fixes: f0ee7acfcdd4 ("gianfar: Add hardware TX timestamping support")
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Acked-by: Richard Cochran <richardcochran@gmail.com>
