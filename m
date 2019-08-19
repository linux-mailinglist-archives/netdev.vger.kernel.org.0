Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF25195187
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 01:14:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728679AbfHSXLu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 19:11:50 -0400
Received: from mail-qt1-f179.google.com ([209.85.160.179]:36797 "EHLO
        mail-qt1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728204AbfHSXLu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 19:11:50 -0400
Received: by mail-qt1-f179.google.com with SMTP id z4so3892982qtc.3
        for <netdev@vger.kernel.org>; Mon, 19 Aug 2019 16:11:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=xG91OBP5cDqwQydFtlOgLpRJRvLP25fdpxvQsSxdzxg=;
        b=1iAl96dXH1pWy+pVxktxnk4QiSaJHc5JYS09b9v+bTz5SJk5MfuJo4QHlD0U4Km8Ps
         CjuWCJSECn5v1qyfXGCsOQLesd5cJ0v9ogRwn0RvnZ5M8AievOOInoLizTBz0Zx0PZSG
         w1qi4FTO7GA9vK+x0dGNLGgxxpZ1nBJgUBEibQgPrqzjERH5v5ZatSVWETvqJD/aZIbI
         /EfrlJv3fncGnHiooaJI8dZegxz1PqHEV/2WA5PwBeg/mH3EUfkGFb+n7urn69tE0H+s
         lZa4Au5V8LVZtvzBJHR3FAHqL1ykd6Az9BNxTobcbVQklOrNDRhav1lYZNS+Z8MPCFSh
         c/iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=xG91OBP5cDqwQydFtlOgLpRJRvLP25fdpxvQsSxdzxg=;
        b=K3Xad50CDi+55sfFJZaJKIusb78bwsyNiolf+4nLCaKW2iwU9Y3v8V7bOJC+L9gKFh
         0FGEqQmzeeZHIQIzt4hEkXc+c7NoYtJFiRkiLhu90mXZPzyKJzkvzVsLoVHR9b+QQlJU
         Hr1Sp4Q2w/A7MbJUjJuA06NNsU4m1SuP2wPaQR51HiBW8l3nSUzmsN9J6hfDr6BUhKe1
         QgCvUAORAKzIybXAiAX0psdWFzmgAM2mLAOGgXT+UaJnxEqVtXJejuudQOTpgoFnEfAB
         1zjPCKOvbGIE5bxFe3msdQ5zh8EffLpSnFjMUcSHhZjt0FiM1G19E2KAs/z13k6eG9rk
         rQcw==
X-Gm-Message-State: APjAAAWGRlUcat7SXPoYpuXhtdq+jWF6LE8dV71HckKRJ3Re083TdgMI
        O3YzaB7VWTzCdiVx6bECY71YZw==
X-Google-Smtp-Source: APXvYqwnSy9z3F7yR1pX7XqA/Pbyuk/Kfx52xewldDw6mKVwktwVxn7mYZHI3WLhPFjI4Z3si2Uulw==
X-Received: by 2002:ac8:444b:: with SMTP id m11mr22734593qtn.257.1566256309735;
        Mon, 19 Aug 2019 16:11:49 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id q28sm9654400qtk.34.2019.08.19.16.11.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Aug 2019 16:11:49 -0700 (PDT)
Date:   Mon, 19 Aug 2019 16:11:42 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net, Paul Greenwalt <paul.greenwalt@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: Re: [net-next v2 04/14] ice: fix set pause param autoneg check
Message-ID: <20190819161142.6f4cc14d@cakuba.netronome.com>
In-Reply-To: <20190819161708.3763-5-jeffrey.t.kirsher@intel.com>
References: <20190819161708.3763-1-jeffrey.t.kirsher@intel.com>
        <20190819161708.3763-5-jeffrey.t.kirsher@intel.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 19 Aug 2019 09:16:58 -0700, Jeff Kirsher wrote:
> +	pcaps = devm_kzalloc(&vsi->back->pdev->dev, sizeof(*pcaps),
> +			     GFP_KERNEL);
> +	if (!pcaps)
> +		return -ENOMEM;
> +
> +	/* Get current PHY config */
> +	status = ice_aq_get_phy_caps(pi, false, ICE_AQC_REPORT_SW_CFG, pcaps,
> +				     NULL);
> +	if (status) {
> +		devm_kfree(&vsi->back->pdev->dev, pcaps);
> +		return -EIO;
> +	}
> +
> +	is_an = ((pcaps->caps & ICE_AQC_PHY_AN_MODE) ?
> +			AUTONEG_ENABLE : AUTONEG_DISABLE);
> +
> +	devm_kfree(&vsi->back->pdev->dev, pcaps);

Is it just me or is this use of devm_k*alloc absolutely pointless?
