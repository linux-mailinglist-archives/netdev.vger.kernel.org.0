Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1D3E62D7B
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 03:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726945AbfGIBfm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 21:35:42 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:43358 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726124AbfGIBfm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 21:35:42 -0400
Received: by mail-qk1-f195.google.com with SMTP id m14so14832706qka.10
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 18:35:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=Cb2dddoti7YGRSOZwHdkhuGfGb9RZ6NmxAXuZNqQSLE=;
        b=m6jgncgukFgZm+xW9SmQ7E0cFhkR9pd4NxXBOMmaMkbcTY3Hb/RleN4/ZMZX0MQrtf
         i4h3tXVzHeh9yA5abOgX6DwgOizbz0+HBMtE6rFZiyJs12jsKu24MZQGYcHnbV5Ysl/t
         Q/b2aJMD2gf1tQh5Yj4wDbWt4C8yclC7SmClZOcgFNiXGOv53vKv3sJ13NxzXJJjiJII
         3Kn7S8qQb4/mHPvls8JFduxQVVi2yRHWCj3WAB9JtyKNoNZtl55JCA1ligIVcO1nh+g1
         3ZsgnWAwQEDrthu55hkSJKiXXueq2b1xQHPGXz2XTAl9Pr3lLKenfKtvmy9nE6HxIMVj
         xirw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=Cb2dddoti7YGRSOZwHdkhuGfGb9RZ6NmxAXuZNqQSLE=;
        b=t8jZx6zg1YyP2FxpDPe0MnkVOp8kXwn57TGgpXBRsoLjhehydC1S6jRlh22vxqKxmG
         Sdix59KbwWmPfWtROgowj0C9zkv6c7/9Znn++Efglp4XGx1xyX4sUIb3n8mqZ9VI6hov
         3Du9LduZbL3J3cVpjZ2G2OIJqZuIkWHKlc2Zyuq2POH6T3EGuUwWISwGSYRTNu9GkGSk
         rhmT/R6eJI4E/dIIif29jKKRwe0J4ny4EQ8z2/ezrcDm73l4Mx3gxHCu74TN38pL8P+w
         mYEvnv4QLMCX2zx8zlRJvp3vgQ7S+amuB805TXZP67/hZ6N3aXS5x3925pJ3izNGielG
         nkKQ==
X-Gm-Message-State: APjAAAU06wzuyELJLlIvNf+sh/O60c4ZSAfgfejrZUKco55UjO62mgd6
        PC6atlRfxCdX9fYuDffVczygvw==
X-Google-Smtp-Source: APXvYqzLtP/3KLDMLg1oczan6Qjcn8hU8Nskau519g5Y76r8W0jCjw99dVHSe27WUg0lGj1UXS9q6w==
X-Received: by 2002:a37:dcc7:: with SMTP id v190mr16922738qki.169.1562636141114;
        Mon, 08 Jul 2019 18:35:41 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id n184sm8303767qkc.114.2019.07.08.18.35.38
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Jul 2019 18:35:41 -0700 (PDT)
Date:   Mon, 8 Jul 2019 18:35:34 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        thomas.lendacky@amd.com, f.fainelli@gmail.com,
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
        maxime.chevallier@bootlin.com, cphealy@gmail.com,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net-next,v3 08/11] drivers: net: use flow block API
Message-ID: <20190708183534.12ed0acc@cakuba.netronome.com>
In-Reply-To: <20190708160614.2226-9-pablo@netfilter.org>
References: <20190708160614.2226-1-pablo@netfilter.org>
        <20190708160614.2226-9-pablo@netfilter.org>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  8 Jul 2019 18:06:10 +0200, Pablo Neira Ayuso wrote:
> diff --git a/drivers/net/ethernet/netronome/nfp/bpf/main.c b/drivers/net/ethernet/netronome/nfp/bpf/main.c
> index 0c93c84a188a..7549547c4ef0 100644
> --- a/drivers/net/ethernet/netronome/nfp/bpf/main.c
> +++ b/drivers/net/ethernet/netronome/nfp/bpf/main.c
> @@ -160,6 +160,8 @@ static int nfp_bpf_setup_tc_block_cb(enum tc_setup_type type,
>  	return 0;
>  }
>  
> +static LIST_HEAD(nfp_bfp_block_cb_list);

This still says bfp.

> +
>  static int nfp_bpf_setup_tc(struct nfp_app *app, struct net_device *netdev,
>  			    enum tc_setup_type type, void *type_data)
>  {
> @@ -167,7 +169,8 @@ static int nfp_bpf_setup_tc(struct nfp_app *app, struct net_device *netdev,
>  
>  	switch (type) {
>  	case TC_SETUP_BLOCK:
> -		return flow_block_cb_setup_simple(type_data, NULL,
> +		return flow_block_cb_setup_simple(type_data,
> +						  &nfp_bfp_block_cb_list,
>  						  nfp_bpf_setup_tc_block_cb,
>  						  nn, nn, true);
>  	default:

