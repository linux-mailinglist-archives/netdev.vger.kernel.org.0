Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C38460E22
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 01:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbfGEX1g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 19:27:36 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:36170 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725878AbfGEX1g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 19:27:36 -0400
Received: by mail-qt1-f194.google.com with SMTP id z4so9262830qtc.3
        for <netdev@vger.kernel.org>; Fri, 05 Jul 2019 16:27:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=mwg+ztVOA+vaS7NvwRZje9clNsDiQtGyZWkfd3T57lE=;
        b=guhlpDtMlf9u7YLUfgzCNu6nZgskp9CuuNrGcHVP8fo+T1PL8W48f511Lq3lW4rtAr
         SRWvyy9S876g0tfr9M/QQNqRIpMz7oP9JElZvy7PAEzYtLP/j6WZ+kfChU0Di8Q8M3ue
         y4w7yAnN2gOmeOmeMBeS4tZYAvoqudT83KOKk1vh5P4KaAZtoV0ureXi6q165+91xBF8
         5Gwoho4MPbVXSgQX7QSM3mIoumDu7p+TNdNoKAAxC3wfm03Eu7y5+x9H+Vl4uTfJ0HBy
         8RVno9aOzXYmev5xP5M9Xv3dmlyj1iIaHm0xxikZVQQCHSRP0b2fYSi5Bj8L7hnozNZM
         THOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=mwg+ztVOA+vaS7NvwRZje9clNsDiQtGyZWkfd3T57lE=;
        b=rl4EsGVYOGpUZQyPOYQAh/fzxIiuxTQEGBOkYRjZgwn34YJeye6xa/kQFzqTLANZh5
         f0pPGCgVmMiNUUKCktFzRwJJeEu1i2Y6LMoxPrtAu0Tp1F0aTYjq7ggVFiRkBGCwEMtM
         xOhynmzG7ZPZX7zMNNki7wX+5BzLkJcnYFjNb3wJlQ42ICnHKJPT7QAah8w+ony7RB1r
         fuaYJ48hs3/0wU9bArqRBby6lpUKGTiI6CngjLbxozPp3az1pG+1Tv5MwrjyAZMJ89n0
         mE0dZYZgMAjVf19vhRw2Nk/3FqdHJFv8XyyV+helPocsHAInunW43Y7E+Ngf6RSDAhlv
         O8TQ==
X-Gm-Message-State: APjAAAX53qn9SCRCjxsmJlyz/0uxfJJFWcoKwMi6TnOaJIFwhnzYz/gl
        IyGzxL8FNmeoNh7zcSN9/dmlcQ==
X-Google-Smtp-Source: APXvYqz5kCJja49nxO5AbpOLhFikbGxoNkoiSNQI1UlUs834S4nln1XgYHl9at/wZFblV15pqKgN6g==
X-Received: by 2002:ac8:3006:: with SMTP id f6mr4750546qte.122.1562369255378;
        Fri, 05 Jul 2019 16:27:35 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id h8sm1633583qto.45.2019.07.05.16.27.32
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 05 Jul 2019 16:27:35 -0700 (PDT)
Date:   Fri, 5 Jul 2019 16:27:29 -0700
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
Subject: Re: [PATCH 06/15 net-next,v2] net: sched: add
 tcf_setup_block_offload()
Message-ID: <20190705162729.67ee3d66@cakuba.netronome.com>
In-Reply-To: <20190704234843.6601-7-pablo@netfilter.org>
References: <20190704234843.6601-1-pablo@netfilter.org>
        <20190704234843.6601-7-pablo@netfilter.org>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  5 Jul 2019 01:48:34 +0200, Pablo Neira Ayuso wrote:
> Most drivers do the same thing to set up the block, add a helper
> function to do this.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

> diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
> index 534a545ea51e..003f24a1323f 100644
> --- a/net/sched/cls_api.c
> +++ b/net/sched/cls_api.c
> @@ -922,6 +922,26 @@ static int tcf_block_setup(struct tcf_block *block, struct tc_block_offload *bo)
>  	return err;
>  }
>  
> +int tcf_setup_block_offload(struct tc_block_offload *f, tc_setup_cb_t *cb,
> +			    void *cb_ident, void *cb_priv, bool ingress_only)
> +{
> +	if (ingress_only &&
> +	    f->binder_type != TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
> +		return -EOPNOTSUPP;
> +
> +	switch (f->command) {
> +	case TC_BLOCK_BIND:
> +		return tcf_block_cb_register(f->block, cb, cb_ident, cb_priv,
> +					     f->extack);
> +	case TC_BLOCK_UNBIND:
> +		tcf_block_cb_unregister(f->block, cb, cb_ident);
> +		return 0;
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +}
> +EXPORT_SYMBOL(tcf_setup_block_offload);
> +
>  static struct rhashtable indr_setup_block_ht;
>  
>  struct tc_indr_block_dev {

This change is pretty much unrelated to the rest of the series, isn't
it?  Can you please post it separately and make the series smaller
this way?

Perhaps tcf_setup_block_offload_simple() would be a good name for this
helper?
