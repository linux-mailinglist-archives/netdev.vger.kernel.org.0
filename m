Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D219910814C
	for <lists+netdev@lfdr.de>; Sun, 24 Nov 2019 01:48:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbfKXAso (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 19:48:44 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:33192 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726676AbfKXAso (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 19:48:44 -0500
Received: by mail-pf1-f196.google.com with SMTP id c184so5495346pfb.0
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 16:48:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=08RngbOuicktRcw+HNfNj3zM04HEgZChD4CkohXM03k=;
        b=A+GDGtK5zbDi0Xu+WFLZAAjcpbWJ/zPH7KT6yw2B9FNHmKMnNpPh+53LJnH3XfYF4A
         IZXy8GXafNUvjmPbsvPZ0hQ8CgaSPAjq3xDGK9JmZWclt2A4dGhdNVw1DyZJRreKk8+n
         nvFLxgbMuaf/fjGw+1ZZi1h4tzekiLaT+Llvf77LRhd8t3G+cN8wIgqJnFoU3k0ryw79
         HogBrq+VM2Sxj0A81gQhQK8EotSEWXTG2QaeOTOUNrbKIxVCUASo5rZk7TFbc85/bL9c
         KdoBcqZqb0u6wm0tZfEQrh3ZsiZiTyzqi/XKao0J8r+YZXzbIsIYcx9GK569V/pFdsyE
         2GuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=08RngbOuicktRcw+HNfNj3zM04HEgZChD4CkohXM03k=;
        b=exBHSJVoKeeyEDR1d0N00Mwmz3SIsyzjg+pAiNB+Ru8wGEvn9k19UWgjN+NnLkDOFw
         h1tnNms16/fpaytXwfbzqLgIv2fNxF949HtFVzPDNo1PeLG7gxjWy3tMkrF7UCY7ImCF
         JVbZKT/qdmJvZ9LbGvdoOkb+tXNrhBRuJw0okVHZjnYSadPmFOpeE1VYxVl4gOeDmxvv
         7SGcuV3BfjaTYUQfEHpKiLQl9UBb8DHFxW1V975YnmaFesqiSAqbXkmMUaz2gq9saJJb
         iueL4I1rGSx5aEIQ5Dv4wLE3GYnB0DwEvWCC+ikO6ZmRz1FxJVcKwMFgDaCtF9Zb0Cc8
         bgaQ==
X-Gm-Message-State: APjAAAUnqbn8SHqXp404mg5OZP160dh2ccCLiS9CJd2oGUcPk13dAyaE
        cUOE1rlfp0aPRjTyNqLBp0kqzjkbZzA=
X-Google-Smtp-Source: APXvYqxkOwR9iPaplRIEdfjdq4HgmU4mIlqlkL5K6pOK5S1PaRrSkCkJPkmCDZUq7Ynf9eMAg1FoRA==
X-Received: by 2002:a63:3d8a:: with SMTP id k132mr25070919pga.167.1574556523839;
        Sat, 23 Nov 2019 16:48:43 -0800 (PST)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id q20sm2827363pff.134.2019.11.23.16.48.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Nov 2019 16:48:43 -0800 (PST)
Date:   Sat, 23 Nov 2019 16:48:38 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>
Subject: Re: [PATCH V2 net-next 0/6] mlxfw: Improve error reporting
Message-ID: <20191123164838.2df4c87f@cakuba.netronome.com>
In-Reply-To: <20191122224126.24847-1-saeedm@mellanox.com>
References: <20191122224126.24847-1-saeedm@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 Nov 2019 22:41:45 +0000, Saeed Mahameed wrote:
> merge conflict with net:
> @ drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c
> 
> ++<<<<<<< (net-next) (keep)
> +
> +       if (fsm_state_err != MLXFW_FSM_STATE_ERR_OK)
> +               return mlxfw_fsm_state_err(mlxfw_dev, extack, fsm_state_err);
> +
> ++=======  
> + 
> +       if (fsm_state_err != MLXFW_FSM_STATE_ERR_OK) {
> +               fsm_state_err = min_t(enum mlxfw_fsm_state_err,
> +                                     fsm_state_err, MLXFW_FSM_STATE_ERR_MAX);
> +               pr_err("Firmware flash failed: %s\n",
> +                      mlxfw_fsm_state_err_str[fsm_state_err]);
> +               NL_SET_ERR_MSG_MOD(extack, "Firmware flash failed");
> +               return -EINVAL;
> ++>>>>>>> (net) (delete)   
> 
> To resolve just use the 1st hunk, from net-next.

Net has been merged into -next, please rebase and repost, this doesn't
apply right now.
