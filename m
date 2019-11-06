Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AAD2F0BC3
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 02:48:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730747AbfKFBsq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 20:48:46 -0500
Received: from mail-lf1-f43.google.com ([209.85.167.43]:40778 "EHLO
        mail-lf1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727252AbfKFBsq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 20:48:46 -0500
Received: by mail-lf1-f43.google.com with SMTP id f4so16678806lfk.7
        for <netdev@vger.kernel.org>; Tue, 05 Nov 2019 17:48:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=aMbPqETnnSXp2ayuk4Nj1XyShmlFl0aTZh0bV6goC20=;
        b=iGHlJoOpDCH4buauYopkqXzzsD0WnUXf8ncFHbXdjoG4zikQSAfmmdRnYl0CVusriv
         hhNWAeEuIsWff8Zg9IaIx2uXS67jNCgVUBzYSw12pvJ8wugvPQp4ilcUTb2FqjwWixOE
         DiBsAE0Xv6fYRAGiEjTAcxxgWdmHIW9NedjLIpkJJTd1TkI4ukp8IWnhHB0pbR7eo+7L
         8AWXj4GaWS2WIFzAq7VjrPlMY6tODwtQCDIGLlKkeBgvtQx+oGSFQKfvezTgQ8nA+TVv
         yZidVaZiBZ+qNvvkRy3yTnHJh9gk8UCvGF0+sPMAlrHXminicmkL7X3AZeMqGm48W+ts
         rfgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=aMbPqETnnSXp2ayuk4Nj1XyShmlFl0aTZh0bV6goC20=;
        b=eSW0Hx487fWtbJD6REsHwS0bvTN/VIzmckhNXXH1c20mX6dZjHSfs4HZysgh1g2nQl
         P3hdsmvtYD2eUF8I5PTB/NQnkCJeJgcrBuf1a/Och3wVmqfwICmRBN9DNSteK5aAr+h2
         sHZf5eNzZXeR2x/OG8Pscts4aKMGdro6VVNHw12isRne7WnWxXJLbOwYrQdM7NULkoKm
         HjscaBap0aSlOO04EVxTxeTY7mrDhQVmXS7fnT4L3DnTvhHIST02n1+my6ElgvzQb94N
         vC2WtPx6T6ARuBpO+5AXqYOEjOJT9S2+B2p0mW+n06yQTsYwv9si7vpt2MFjuD27Occp
         CWcQ==
X-Gm-Message-State: APjAAAXMXqUxa4ymwrsbbbN6FmfCHutN1Q428bkjD85GzmSPmvYkewq8
        MndaFXr2gucP3cZ0C7uZ8ixY9Q==
X-Google-Smtp-Source: APXvYqwxiHMMfJI0mVYduwSDdaV5sxge3jfKbjdUW2O6SDDZRl/2kv0tz6j6L2VJUnvEONX9lH1FgA==
X-Received: by 2002:a19:8092:: with SMTP id b140mr22172276lfd.13.1573004923862;
        Tue, 05 Nov 2019 17:48:43 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id x17sm4396398lfe.19.2019.11.05.17.48.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Nov 2019 17:48:43 -0800 (PST)
Date:   Tue, 5 Nov 2019 17:48:36 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: Re: [net-next 03/15] ice: Add support for FW recovery mode
 detection
Message-ID: <20191105174836.4df162dd@cakuba.netronome.com>
In-Reply-To: <20191106004620.10416-4-jeffrey.t.kirsher@intel.com>
References: <20191106004620.10416-1-jeffrey.t.kirsher@intel.com>
        <20191106004620.10416-4-jeffrey.t.kirsher@intel.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  5 Nov 2019 16:46:08 -0800, Jeff Kirsher wrote:
> From: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
> 
> This patch adds support for firmware recovery mode detection.
> 
> The idea behind FW recovery mode is to recover from a bad FW state,
> due to corruption or misconfiguration. The FW triggers recovery mode
> by setting the right bits in the GL_MNG_FWSM register and issuing
> an EMP reset.
> 
> The driver may or may not be loaded when recovery mode is triggered. So
> on module load, the driver first checks if the FW is already in recovery
> mode. If so, it drops into recovery mode as well, where it creates and
> registers a single netdev that only allows a very small set of repair/
> diagnostic operations (like updating the FW, checking version, etc.)
> through ethtool.
> 
> If recovery mode is triggered when the driver is loaded/operational,
> the first indication of this in the driver is via the EMP reset event.
> As part of processing the reset event, the driver checks the GL_MNG_FWSM
> register to determine if recovery mode was triggered. If so, traffic is
> stopped, peers are closed and the ethtool ops are updated to allow only
> repair/diagnostic operations.
> 
> Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

You shouldn't need to spawn a fake netdev just to recover the device.

Implement devlink, you can have a devlink instance with full debug
info and allow users to update FW via the flash op, even if driver is
unable to bring up any port.
