Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 755E6E28F9
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 05:41:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392922AbfJXDly (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 23:41:54 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:45308 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390576AbfJXDlx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 23:41:53 -0400
Received: by mail-pg1-f194.google.com with SMTP id r1so13351560pgj.12
        for <netdev@vger.kernel.org>; Wed, 23 Oct 2019 20:41:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=TGFLtAjB1A6DulK8cM5FwrQiz0bTM6YTABVrADPNxCM=;
        b=RPgOtsnd45powVHiNiVSMAjDQOUuS45Lh/WotS4kDTiQpOiu77XgnTIjDEHv01qehj
         DaSUOVoAJX0cKkYo63fmhVDTSX/p1nPWlW4wG/P9FLIXvMx8/v4JhR4vI0JL0uAkhPWS
         6Ie4qlUmB86LrLw9+DlN3pkhR42ijMbjy4CoWIoh5mfIeb64ALJXiNmzidaFJrRWPfrF
         JXhD+qkAZiJNJLx+k2rn7zzMIMpPZY2Q/i28s53U9oOXGAm9EM7RkLxZQls4IRPtSv/K
         R2XD874JxQW66VfN7cTTFxQg01v5hCVlvUioBaC8MqaFyTjxYjvoTMsdZhz5MMtmDq/T
         9Jxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=TGFLtAjB1A6DulK8cM5FwrQiz0bTM6YTABVrADPNxCM=;
        b=pKxe4hsq+VB9H/axcKHjGAGf2/VQQ89AOsjhsjKCxTMuibn720bJc8uQn6Fvdzfn2J
         Nnrn+BqEGsYR/VoucH+JI337mQWMxBCVFLlMNNy3oKLcgW2mAa/Nk4CZXFRoLLgGX/at
         485KrdD/jz6rPEWzeP7uqjHYiF3KjfA1oKLVG8HQm1NSURYTSmiKMpUqGf+qLXbTIKeb
         T6ei8SbX2tCfSxFiUmuiNkASRGztxOUsv1T+6tI+nMTJAdtEyan5J9uus0l8WVpgWbSU
         AopLjfqysPICREC7wJdfmVI4LQKrZWVpN1Dt3webheOFObfmJ2wKYWJIbdeWBFiu6snv
         Jy/w==
X-Gm-Message-State: APjAAAV4/NIm92xGngepVWKGsHkzNrEMOD7EFlreaReI/Fqacx1cJ1kZ
        EB50LNywr3bG3GfAsX8t7Zg45sLSopo=
X-Google-Smtp-Source: APXvYqzTPK0UIjGxvUpb8wj1EGHH0Z87+bQho8OYzQMWFgxVKQTCxzSuRXHFv7T8cXeM7797aNRgXA==
X-Received: by 2002:a63:6cf:: with SMTP id 198mr9989438pgg.259.1571888513157;
        Wed, 23 Oct 2019 20:41:53 -0700 (PDT)
Received: from cakuba.hsd1.ca.comcast.net (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id q26sm21628104pgk.60.2019.10.23.20.41.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2019 20:41:52 -0700 (PDT)
Date:   Wed, 23 Oct 2019 20:41:49 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net, Arkadiusz Grubba <arkadiusz.grubba@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: Re: [net-next 02/11] i40e: Add ability to display VF stats along
 with PF core stats
Message-ID: <20191023204149.4ae25f90@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20191023182426.13233-3-jeffrey.t.kirsher@intel.com>
References: <20191023182426.13233-1-jeffrey.t.kirsher@intel.com>
        <20191023182426.13233-3-jeffrey.t.kirsher@intel.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 23 Oct 2019 11:24:17 -0700, Jeff Kirsher wrote:
> From: Arkadiusz Grubba <arkadiusz.grubba@intel.com>
>=20
> This change introduces the ability to display extended (enhanced)
> statistics for PF interfaces.
>=20
> The patch introduces new arrays defined for these
> extra stats (in i40e_ethtool.c file) and enhances/extends ethtool ops
> functions intended for dealing with PF stats (i.e.: i40e_get_stats_count(=
),
> i40e_get_ethtool_stats(), i40e_get_stat_strings() ).

This commit message doesn't explain _what_ stats your adding, and _why_.

=46rom glancing at the code you're dumping 128 * 12 stats, which are
basic netdev stats per-VF.=20

These are trivially exposed on representors in modern designs.

> There have also been introduced the new build flag named
> "I40E_PF_EXTRA_STATS_OFF" to exclude from the driver code all code snippe=
ts
> associated with these extra stats.

And this doesn't even exist in the patch.

> Signed-off-by: Arkadiusz Grubba <arkadiusz.grubba@intel.com>
> Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

