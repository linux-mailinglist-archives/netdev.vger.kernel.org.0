Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39FE36276F
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 19:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728189AbfGHRmJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 13:42:09 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:54728 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730527AbfGHRmJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 13:42:09 -0400
Received: by mail-wm1-f68.google.com with SMTP id p74so354711wme.4
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 10:42:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ye/ao4wrW+EUCxOtSAz3cL/mCw3UELfD0/7EA13+7ME=;
        b=IY+VaTm6YIzbox7XK448KVefzqd5kcSp7gecKsSU/OI4jZ+FnI8tbYpZypbMGQ0qFb
         nQCPv6r3tfaTnfEoFr16NXNlaxLHXCOhjU/qdWuGrTkotdQAeZcCuRaRyluusRnd2dl4
         azwgGpCp7q0nNyedInzjEGk3EMrhHfZeEgIi5Gjkr9e6ZVQfvRMgXs0SFYCC9HZjzJQN
         5JXM9hqJNhRFyABX8hsiPpzw+ZEW1hHDd3tb5S2zO6phyzoVEVtxNu4Qb5pIXBuP+7jN
         4Gp5UwmIBckGXHenyuhJe+3ma80GWxkgGVSEotiaK81rdX9qPwvZ6bw4UakhaKeQPcXU
         jh4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ye/ao4wrW+EUCxOtSAz3cL/mCw3UELfD0/7EA13+7ME=;
        b=tWNeAjpYsBJv1wQyNGSx2371kXThmGY23Mwi+2Ft9KFnKAGPpomI9+aLmg53Cp5ahD
         +6HOddLoal2VDuBew2UaKn2OCnqO7uQ5WhsfRVQFzNHYr5WEz5WBIO0E0u5W8Hna/1a0
         6I2nEktjptT1d8tpTXpe42KWe8gAoW6ADFq8l42ZEZKoOPEqqsQeYSXDAc+ZFSHMhNo9
         fgJHzN9ZlVo9uOupzLTn7+1hcMf4aEMFaujP8Nzoq27O8E8VbU507PYbwmBqKrXtugrN
         wWB1nFjxzNQaclYlZdRxyVVSkge9BdeF+taTexQ4Mtx7l2rkCG8VpVsjmEv3+1Odat3B
         1xiw==
X-Gm-Message-State: APjAAAV5RbTuQA5v9DAyFYtHJcl1xAqYDOwPc7hG4pfZQWHTD/wm+pTc
        3SXTNkh4jt0tgUbiEqAtx8qxBA==
X-Google-Smtp-Source: APXvYqyoDcfjbc5Jjj+wWrqlUumG0wn7U2u7ZZLPzrfGGDQIrVQ7L+7CEe4cZBozdheh3Kd/XPOh2A==
X-Received: by 2002:a05:600c:da:: with SMTP id u26mr17133667wmm.108.1562607727394;
        Mon, 08 Jul 2019 10:42:07 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id t17sm24535673wrs.45.2019.07.08.10.42.06
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Jul 2019 10:42:06 -0700 (PDT)
Date:   Mon, 8 Jul 2019 19:42:06 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        thomas.lendacky@amd.com, f.fainelli@gmail.com,
        ariel.elior@cavium.com, michael.chan@broadcom.com,
        madalin.bucur@nxp.com, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, jeffrey.t.kirsher@intel.com,
        tariqt@mellanox.com, saeedm@mellanox.com, jiri@mellanox.com,
        idosch@mellanox.com, jakub.kicinski@netronome.com,
        peppe.cavallaro@st.com, grygorii.strashko@ti.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, linux-net-drivers@solarflare.com,
        ogerlitz@mellanox.com, Manish.Chopra@cavium.com,
        marcelo.leitner@gmail.com, mkubecek@suse.cz,
        venkatkumar.duvvuru@broadcom.com, maxime.chevallier@bootlin.com,
        cphealy@gmail.com, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net-next,v3 07/11] net: sched: use flow block API
Message-ID: <20190708174206.GC2282@nanopsycho.orion>
References: <20190708160614.2226-1-pablo@netfilter.org>
 <20190708160614.2226-8-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190708160614.2226-8-pablo@netfilter.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Jul 08, 2019 at 06:06:09PM CEST, pablo@netfilter.org wrote:
>This patch adds tcf_block_setup() which uses the flow block API.
>
>This infrastructure takes the flow block callbacks coming from the
>driver and register/unregister to/from the cls_api core.
>
>Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

[...]


>+static int tcf_block_bind(struct tcf_block *block,
>+			  struct flow_block_offload *bo)
>+{
>+	struct flow_block_cb *block_cb, *next;
>+	int err, i = 0;
>+
>+	list_for_each_entry(block_cb, &bo->cb_list, driver_list) {
>+		err = tcf_block_playback_offloads(block, block_cb->cb,
>+						  block_cb->cb_priv, true,
>+						  tcf_block_offload_in_use(block),
>+						  bo->extack);
>+		if (err)
>+			goto err_unroll;
>+
>+		list_add(&block_cb->list, &block->cb_list);
>+		i++;
>+	}
>+	list_splice(&bo->cb_list, bo->driver_block_list);

This cl/driver_block list magic is really very hard to follow. Could you
please make it more clear?



>+
>+	return 0;
>+
>+err_unroll:
>+	list_for_each_entry_safe(block_cb, next, &bo->cb_list, driver_list) {
>+		if (i-- > 0) {
>+			list_del(&block_cb->list);
>+			tcf_block_playback_offloads(block, block_cb->cb,
>+						    block_cb->cb_priv, false,
>+						    tcf_block_offload_in_use(block),
>+						    NULL);
>+		}
>+		flow_block_cb_free(block_cb);
>+	}
>+
>+	return err;
>+}
>+
>+static void tcf_block_unbind(struct tcf_block *block,
>+			     struct flow_block_offload *bo)
>+{
>+	struct flow_block_cb *block_cb, *next;
>+
>+	list_for_each_entry_safe(block_cb, next, &bo->cb_list, driver_list) {
>+		list_del(&block_cb->driver_list);
>+		tcf_block_playback_offloads(block, block_cb->cb,
>+					    block_cb->cb_priv, false,
>+					    tcf_block_offload_in_use(block),
>+					    NULL);
>+		list_del(&block_cb->list);
>+		flow_block_cb_free(block_cb);
>+	}
>+}

[...]
