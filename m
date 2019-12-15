Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A22CF11F5C1
	for <lists+netdev@lfdr.de>; Sun, 15 Dec 2019 05:35:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726094AbfLOEdl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Dec 2019 23:33:41 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:35058 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725990AbfLOEdl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Dec 2019 23:33:41 -0500
Received: by mail-pj1-f68.google.com with SMTP id w23so1509766pjd.2
        for <netdev@vger.kernel.org>; Sat, 14 Dec 2019 20:33:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=K51j8K8EN2XPuqttk34dMlLQCvUL9tG6S45o7V+5+MU=;
        b=rSuoQkCYH6bzYBVjPU8FbqRNmY0YmiIcGj83O2cSsmxSzv22e16yc20L3uKiVbr3nK
         B52slI9FmgYjesrnwzmnCMtqozUyb7F7j9eyORMMTiB+BIt1vHimX+L+2eQO5LekkMnr
         koQfyq+dRdKzG/meZ+yw6bU2vO/Q+snYpLPwKD7cfrKBm/ohGaT6sGqDul/3zJQ1mkRn
         4oaveKo+jwkQaRKBl9hp/LLa4TrEPwAShyzFk5wahuGDyB2x4I9JBjh/KcK1ugyMVQiz
         8xF3W/J05lu9lQEcUzSpF91II4YLNi3EDZIQ6f99Ngi7L6E9hWPZMoSkhJiftWXuFHY/
         X8nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=K51j8K8EN2XPuqttk34dMlLQCvUL9tG6S45o7V+5+MU=;
        b=JT+Jq9L38Kt3YDcgHG4fliEcOV8vfHRLMcuGyFMoyHwGroY+Zttov/e6N38aSNBjJp
         WMztm81C/S4M0q/E8FmVF7nnxSXZU7DULRo2KNjzEVz7tcGSMUd0uYj61SFIzqLxU+lI
         Z4egkz4OH+bR+AXBdXfzIEXseMy2bdKICQyQgc9fAW0A0aXFWoaQCW/rxc+WD1FBiUDo
         1kyJhrPM0MbalOw1su1SAnAeMAfE13cY4P80UzGss1RHFBrwDtcdoLC0oVcqnKzv2ezD
         HSRxPcoiVJaD5Evq7SaHW8FMwIGAPjGWyE4PxDOaZNEjd2cfyLuGLSQzeJJS/2aopuLZ
         /iDg==
X-Gm-Message-State: APjAAAXcftPU8fWDNr5QaqaT66ygWdA6VoEdQxKiA0nHts7uVkkHRT8d
        Ea/FI4Hy2PfM7XeDmr36vNYt4Q==
X-Google-Smtp-Source: APXvYqxDxnE+42cDuVy+5iQUU/Tx31SkRqB05+m6gIJ/7lrWfSSLYL1x8M/df2LadQS8e5Ghu7t/Lg==
X-Received: by 2002:a17:902:209:: with SMTP id 9mr9254119plc.58.1576384420590;
        Sat, 14 Dec 2019 20:33:40 -0800 (PST)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id r20sm17218140pgu.89.2019.12.14.20.33.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Dec 2019 20:33:40 -0800 (PST)
Date:   Sat, 14 Dec 2019 20:33:37 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Milind Parab <mparab@cadence.com>
Cc:     <nicolas.nerre@microchip.com>, <andrew@lunn.ch>,
        <antoine.tenart@bootlin.com>, <f.fainelli@gmail.com>,
        <rmk+kernel@armlinux.org.uk>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <hkallweit1@gmail.com>,
        <linux-kernel@vger.kernel.org>, <dkangude@cadence.com>,
        <a.fatoum@pengutronix.de>, <brad.mouring@ni.com>,
        <pthombar@cadence.com>
Subject: Re: [PATCH v2 1/3] net: macb: fix for fixed-link mode
Message-ID: <20191214203337.687ebd6b@cakuba.netronome.com>
In-Reply-To: <1576230061-11239-1-git-send-email-mparab@cadence.com>
References: <1576230007-11181-1-git-send-email-mparab@cadence.com>
        <1576230061-11239-1-git-send-email-mparab@cadence.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Dec 2019 09:41:01 +0000, Milind Parab wrote:
> This patch fix the issue with fixed link. With fixed-link
> device opening fails due to macb_phylink_connect not
> handling fixed-link mode, in which case no MAC-PHY connection
> is needed and phylink_connect return success (0), however
> in current driver attempt is made to search and connect to
> PHY even for fixed-link.
> 
> Signed-off-by: Milind Parab <mparab@cadence.com>

We'll wait to give a chance for Russell, Andrew and others to review,
but this patch looks like a fix and the other ones look like features.
You should post the fix separately so it's included in Linus'es tree
ASAP (mark the patch with [PATCH net]), and the rest of the patches can
wait for the next merge window (mark [PATCH net-next]). Fixes should
also have an appropriate Fixes tag pointing at the first commit where
the bug was present.
