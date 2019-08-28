Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EE4DA0DAF
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 00:41:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbfH1WlL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 18:41:11 -0400
Received: from mail-ed1-f47.google.com ([209.85.208.47]:38559 "EHLO
        mail-ed1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726921AbfH1WlL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 18:41:11 -0400
Received: by mail-ed1-f47.google.com with SMTP id r12so1778229edo.5
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 15:41:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=6KtJ8ssmUwmQjYs63/njs22meXGub08wrswg0m3E3w4=;
        b=f36A4ewgjnI3UwsHj/pqHI3XIW6Gf95lhBLh+85nfgl9kOjW2hhKGyXrFmKWng6XC/
         aSodD+L8VyS0d2Uk0+rDDOreJbyxB4v9umuSiy4YYfRpcQ6fbJYRtfkfYMRNcUH4R1P6
         Fve3YnOWzKjTgj7W/iDtwgjmuq1GA4hUPFsXw0p36QLc+4Abr4rbOk0AMwWfft/7oTRN
         LW3LzwDyhVhKHQ5DNTOcwLzimeUNqTAYveYhIgVTU5F2kskyGdAKB/h0+xpBRLuIs19W
         cP9yv9uieTNsAwuD+n+YU+knKnc6km0k7b6Tyjn6gnWakZgD9DP5Vcu7oBoab6QEs6ES
         BWuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=6KtJ8ssmUwmQjYs63/njs22meXGub08wrswg0m3E3w4=;
        b=C+O8Tl0T6oEG3D/dveCSR2RRigqEk2QcXNaTxNhxGGemY8oxmAk5P9S0Z5y1p1qfSc
         P4t6BqyMFxpZGRnZvenNeXOcvFAc68ZsFxyY9+npZ1BhXevi18u86Ob0fevqV/Hc4ybp
         /Z6GgqAQkVBDNVpa9+o5dEej8ztLMTblNWA1nfOLytfa8nmywE2Qq0dn6TxeFWwPvy/Q
         +wxXwGRV/6iDy41g5hTfLLs0xOkHBffzwnQpc7/ryHkLgXqtmNA6OqibxBB+aP0d0SCr
         0Ke1EUJxpQGI11pvoDNQg6XZM76Dcl+LbU5jUynFO/bnX8IzDzho766bXqVgU36Yp8hx
         cG+g==
X-Gm-Message-State: APjAAAXi2iZkXj8+hYI035TAIkQBemZJDahOHiD9NB2Zen/p9tU6Vc9H
        VkS5v+LXV4eyvgkijenX4pfkRA==
X-Google-Smtp-Source: APXvYqweUU5H1aoyYbc4nXQjPTrKK+rNIXRhqnjd2Z0L+5JvM3GXrGbYzHmbl1czAimAWwEMe560vg==
X-Received: by 2002:a05:6402:60d:: with SMTP id n13mr6536759edv.303.1567032069690;
        Wed, 28 Aug 2019 15:41:09 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id u26sm87798eda.22.2019.08.28.15.41.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2019 15:41:09 -0700 (PDT)
Date:   Wed, 28 Aug 2019 15:40:48 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net, Firo Yang <firo.yang@suse.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: Re: [net-next 13/15] ixgbe: sync the first fragment unconditionally
Message-ID: <20190828154048.6d1347fc@cakuba.netronome.com>
In-Reply-To: <20190828064407.30168-14-jeffrey.t.kirsher@intel.com>
References: <20190828064407.30168-1-jeffrey.t.kirsher@intel.com>
        <20190828064407.30168-14-jeffrey.t.kirsher@intel.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 27 Aug 2019 23:44:05 -0700, Jeff Kirsher wrote:
> Fixes: f3213d932173 ("ixgbe: Update driver to make use of DMA
> attributes in Rx path")

wrapped tag
