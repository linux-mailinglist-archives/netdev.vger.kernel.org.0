Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 750A460E08
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 00:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbfGEW6H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 18:58:07 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:37753 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726001AbfGEW6H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 18:58:07 -0400
Received: by mail-qt1-f193.google.com with SMTP id y26so109980qto.4
        for <netdev@vger.kernel.org>; Fri, 05 Jul 2019 15:58:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=V3huPFi5KeSbQVpvMwRP3iVP+5WLD8Rtz7d0wtuy69A=;
        b=zpA/2dhkO/33Zg2dKVcYEF/Jsr79zCI16PYrlBinlRv+T+BuUZ0cwf2nYIXOCpxn8v
         nIsAnxX5mdrYBbtSUpv6zu4+dc1JcFAYI4NDOi6sGccUXxPyIakxfCDnpVIqwCqppNLa
         IjJ4cGWHERJLRtIsOuAWd15YguugvY2OOMUECNqNMONTOlP4qvmyBQ4V/+oqPqGjrHmx
         EYit8xgILm37td+ODvj2tOIDP7YnRbwGz57SnV4JWbNcSTQATAMIdbEBgoX0XVJVVn4h
         9xYAVWYpyqVzfQsZfkxYbglIAkvNkRN91VA3XFuNVvzdtcU7FF0zq9FEUG5MAkVr6gjx
         TAgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=V3huPFi5KeSbQVpvMwRP3iVP+5WLD8Rtz7d0wtuy69A=;
        b=G6wTmZCGQ9NHKeRdzIl7ytDfl6z0ueK9zCRTBytQrqy3PuE3uU/5/7NUZ1xaYe5Nk3
         DsPffE/J8UV/9VRCM0y3yNrqB6k/vngpfS/QV0eDwm5AZsc0PDIaw38FzNL3T1WEOzwu
         EL3gRja5AIrV0xgwEg5OZ0jACiTHAqwlAaYb1PXr3BXfm+gFon2RcX3REQRQeS0uCnx4
         R+79rvgRB/17c0LFjc4ksGab9E6hDyQWaWds0gCgYTg1YgAyUiZ4HxMRbPsJsw95BCtr
         XWO33+pbnr+piHzXrs7pzvujXU37s8EG+HTWRj1nXVyaiethU4PyH28vxo1xRCoSxPcW
         tCxg==
X-Gm-Message-State: APjAAAU5MmDxHYEGt0o4+z4hvGU1SIy+dO3l74PlkcGi5AHmXCUwej7Z
        odxI7Ff13NpdD1eBcS0/V62+EA==
X-Google-Smtp-Source: APXvYqwZcBTLshn24PAmhjeuMGkEVMmpE7xYf+g9KWvwgZ+sva2ATknEj+/sA2iGchnnl1/3i2EV9A==
X-Received: by 2002:a0c:95a2:: with SMTP id s31mr5512931qvs.120.1562367486643;
        Fri, 05 Jul 2019 15:58:06 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id r26sm4395504qkm.57.2019.07.05.15.58.03
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 05 Jul 2019 15:58:06 -0700 (PDT)
Date:   Fri, 5 Jul 2019 15:58:00 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        davem@davemloft.net, thomas.lendacky@amd.com, f.fainelli@gmail.com,
        ariel.elior@cavium.com, michael.chan@broadcom.com,
        madalin.bucur@nxp.com, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, jeffrey.t.kirsher@intel.com,
        tariqt@mellanox.com, saeedm@mellanox.com, jiri@mellanox.com,
        idosch@mellanox.com, peppe.cavallaro@st.com,
        grygorii.strashko@ti.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        alexandre.torgue@st.com, joabreu@synopsys.com,
        linux-net-drivers@solarflare.com, ogerlitz@mellanox.com,
        Manish.Chopra@cavium.com, marcelo.leitner@gmail.com,
        mkubecek@suse.cz, venkatkumar.duvvuru@broadcom.com,
        maxime.chevallier@bootlin.com, cphealy@gmail.com
Subject: Re: [PATCH 04/15 net-next,v2] net: sched: add tcf_block_setup()
Message-ID: <20190705155800.4db7fb40@cakuba.netronome.com>
In-Reply-To: <20190704234843.6601-5-pablo@netfilter.org>
References: <20190704234843.6601-1-pablo@netfilter.org>
        <20190704234843.6601-5-pablo@netfilter.org>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  5 Jul 2019 01:48:32 +0200, Pablo Neira Ayuso wrote:
> @@ -1052,12 +1145,19 @@ static int tcf_block_offload_cmd(struct tcf_block *block,
>  				 struct netlink_ext_ack *extack)
>  {
>  	struct tc_block_offload bo = {};
> +	int err;
>  
>  	bo.command = command;
>  	bo.binder_type = ei->binder_type;
>  	bo.block = block;
>  	bo.extack = extack;
> -	return dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_BLOCK, &bo);
> +	INIT_LIST_HEAD(&bo.cb_list);
> +
> +	err = dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_BLOCK, &bo);
> +	if (err < 0)
> +		return err;
> +
> +	return tcf_block_setup(block, &bo);

If this fails nothing will undo the old ndo call, no?

>  }
>  
>  static int tcf_block_offload_bind(struct tcf_block *block, struct Qdisc *q,
