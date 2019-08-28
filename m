Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28C38A0DAC
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 00:38:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727014AbfH1Wit (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 18:38:49 -0400
Received: from mail-ed1-f48.google.com ([209.85.208.48]:36509 "EHLO
        mail-ed1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726980AbfH1Wit (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 18:38:49 -0400
Received: by mail-ed1-f48.google.com with SMTP id g24so1783765edu.3
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 15:38:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=OgkX61po1KMu2i9a33T+3TgBDWXmupqSfE49ySvtFrs=;
        b=NNGU7sSJ9Lk1dwzSYrsCFsxyYfwOqjPzb7Xfcw/84wMjLMJ99mmNaNkWin8SNbSj2f
         oxBwTcK4G8saDhhusOuJhnjsTJLGm9R31aPPg37fVjZDw6fOS14huEoyO3w021IY4hPk
         leXXJwUPTJ1oE0C/tnL6LGhrULKRbNS1YU8pgyDiHyUxmsoRh75TNAOt8/awEFC7Xxfh
         8hxg9f6Ga4jxTJhobJg3nquWgd4RKg6vbszEcLQDjFNGcF+nfCoHH54IIoG7H8Vg/K99
         BzTG5pLsCtvr9jm7KTo+8dTi6s9wG5PHTPJD5WRvdc9KE5r7fGw7IhG5mvTDHyrBON5S
         7T7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=OgkX61po1KMu2i9a33T+3TgBDWXmupqSfE49ySvtFrs=;
        b=O9DNs4NjY3Z4zrOgc/lqJrPiha+IWi2Q3now22Tu9SdsbvRPP20wwM9JXzTpknsjCN
         d0NPspVkK/WdIzw08EkuT1/FcXwv2lYFe3Tgf3QRkcVYlHWKphxThhNc1nGvVy4pKI71
         uNrBsXwwHXaCrkzrPNdb9kaBxztBE4C/2Zrv5NCTAbi4LUYVERhVQKwL6NxzlgU3ZJ4Z
         LfKXVH5ei8hCdbcugzzQtO+rTH/vFDu+H2MnVgWjwXmd7cGxVVu60Amuj/PB3mf53YHD
         R8VyuRMbnn3b0l21QTKVSLzVqYxBgMvJjJzdD4cVpeqMvFXOHUfhnNPu0bKPVhyb/t8r
         4JLg==
X-Gm-Message-State: APjAAAWk6vDYZ9Zbsgey7DFwz6Kaln0wtedYa1Urw+sHTFHUy2XoNpaP
        A3ICrHZAb3KUYuNS9RuurA2CFA==
X-Google-Smtp-Source: APXvYqxn65LW8vK30gz88wM6nNQtKr+GwweNsOqHOi7weSczgjyQ7vk9ffLc63PYdSvIO2+5loRA5w==
X-Received: by 2002:a17:906:b30a:: with SMTP id n10mr5494102ejz.231.1567031927515;
        Wed, 28 Aug 2019 15:38:47 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id j2sm94993ejj.34.2019.08.28.15.38.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2019 15:38:47 -0700 (PDT)
Date:   Wed, 28 Aug 2019 15:38:25 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net,
        "Mauro S. M. Rodrigues" <maurosr@linux.vnet.ibm.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: Re: [net-next 10/15] i40e: fix hw_dbg usage in
 i40e_hmc_get_object_va
Message-ID: <20190828153825.67833893@cakuba.netronome.com>
In-Reply-To: <20190828064407.30168-11-jeffrey.t.kirsher@intel.com>
References: <20190828064407.30168-1-jeffrey.t.kirsher@intel.com>
        <20190828064407.30168-11-jeffrey.t.kirsher@intel.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 27 Aug 2019 23:44:02 -0700, Jeff Kirsher wrote:
> @@ -982,6 +983,7 @@ i40e_status i40e_hmc_get_object_va(struct i40e_hmc_info *hmc_info,
>  	struct i40e_hmc_sd_entry *sd_entry;
>  	struct i40e_hmc_pd_entry *pd_entry;
>  	u32 pd_idx, pd_lmt, rel_pd_idx;
> +	struct i40e_hmc_info *hmc_info = &hw->hmc;

reverse xmas tree

>  	u64 obj_offset_in_fpm;
>  	u32 sd_idx, sd_lmt;
>  
