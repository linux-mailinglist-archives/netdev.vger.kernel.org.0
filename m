Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 217B42B6E0B
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 20:08:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726417AbgKQTHd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 14:07:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725613AbgKQTHc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 14:07:32 -0500
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 979A6C0613CF;
        Tue, 17 Nov 2020 11:07:31 -0800 (PST)
Received: by mail-ot1-x343.google.com with SMTP id 79so20494733otc.7;
        Tue, 17 Nov 2020 11:07:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=9fgySF6K68SlluAGbdqXKQeVrDTrhLPgdEXfhoFPwX8=;
        b=XoZH8GpCCWfsU+IoFOA00/Zk5jH4C2i3Xv8NjBnsgNDw7x87/1ZRrXEnh0/DTnx7wd
         yT4rS+fQosOlWkWUSSMb1S4wkcVmamnYgFHuDu+G/giPJGRAsEvHsBx7aVrSHf5yeLVu
         GBn6DveQkZ/WKVf5bLD0LGrYI2s6h7faYVGbrZOzbMxeD2SFxmwpCH44B7bKQL27z8lM
         4VyzAdV4V/XemAMsQJDh5Q7eGlNMtjqaKFguAlWJbNYkAq4bEzyjuhhwosv4+ZzhO6wF
         HCO6gKEQhTZ5pIeZJVxN2Vn6vy4SOFRsUhT86MkV/l7NJpIMMFVDTEo3sSFAwVce/39L
         rHGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=9fgySF6K68SlluAGbdqXKQeVrDTrhLPgdEXfhoFPwX8=;
        b=Np/jbq0WWkammvnLB6pZDxb6dClUk+72TTw/IQHjwdql20/CvApxxyRIvrdiINbD8f
         IFbmA48Czz2SmODiUO/rEuIQ9WIcPQhjw5tgD1W0LDCV8fy8kkjZDU7L3oHwf5RxDULK
         kSrNddeSh8utcFMcg3Us8rQuqqiBwVjAqQ2AsaYneL8D2uOVbwWXetwO/TXfFVG7WyCh
         AakSagYtB3VIYrqYtl2Ui8t3nwpANJoqx7yN0gerMBBYoHsOj8YoiQB82uhpQgqcY/E6
         VYGbj3SN3XgPUQMqfMIPtrKvdCBuYEOZWljBHFnAA/2CCEhGh5DhQySBSFVxBTDwsMIY
         t7IA==
X-Gm-Message-State: AOAM533FcA8PxdnJtGkQkpz0A2hUcmoHjFWQvVcL4XPjAJVJ5Xkv7O+u
        l3tPG5n9MvY/XT1iiFH3WXvKV4C/l8KD1g==
X-Google-Smtp-Source: ABdhPJyvLHJlKU9g2W718K3p65afXZsjKc8wVd1jMSWIOnG1FdT8bzA4YxQmeyGQS90q+L6HzaBBUg==
X-Received: by 2002:a9d:460a:: with SMTP id y10mr3761572ote.99.1605640050975;
        Tue, 17 Nov 2020 11:07:30 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id w22sm1804563oie.49.2020.11.17.11.07.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2020 11:07:30 -0800 (PST)
Date:   Tue, 17 Nov 2020 11:07:22 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, kuba@kernel.org, john.fastabend@gmail.com
Cc:     bpf@vger.kernel.org, jeffrey.t.kirsher@intel.com,
        anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com,
        maciejromanfijalkowski@gmail.com, intel-wired-lan@lists.osuosl.org
Message-ID: <5fb41f6ae195_310220813@john-XPS-13-9370.notmuch>
In-Reply-To: <1605525167-14450-5-git-send-email-magnus.karlsson@gmail.com>
References: <1605525167-14450-1-git-send-email-magnus.karlsson@gmail.com>
 <1605525167-14450-5-git-send-email-magnus.karlsson@gmail.com>
Subject: RE: [PATCH bpf-next v3 4/5] xsk: introduce batched Tx descriptor
 interfaces
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Magnus Karlsson wrote:
> From: Magnus Karlsson <magnus.karlsson@intel.com>
> 
> Introduce batched descriptor interfaces in the xsk core code for the
> Tx path to be used in the driver to write a code path with higher
> performance. This interface will be used by the i40e driver in the
> next patch. Though other drivers would likely benefit from this new
> interface too.
> 
> Note that batching is only implemented for the common case when
> there is only one socket bound to the same device and queue id. When
> this is not the case, we fall back to the old non-batched version of
> the function.
> 
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> ---
>  include/net/xdp_sock_drv.h |  7 ++++
>  net/xdp/xsk.c              | 57 +++++++++++++++++++++++++++++
>  net/xdp/xsk_queue.h        | 89 +++++++++++++++++++++++++++++++++++++++-------
>  3 files changed, 140 insertions(+), 13 deletions(-)
> 

Acked-by: John Fastabend <john.fastabend@gmail.com>

> +
> +u32 xsk_tx_peek_release_desc_batch(struct xsk_buff_pool *pool, struct xdp_desc *descs,
> +				   u32 max_entries)
> +{
> +	struct xdp_sock *xs;
> +	u32 nb_pkts;
> +
> +	rcu_read_lock();
> +	if (!list_is_singular(&pool->xsk_tx_list)) {
> +		/* Fallback to the non-batched version */

I'm going to ask even though I believe its correct.

If we fallback here and then an entry is added to the list while we are
in the fallback logic everything should still be OK, correct?

> +		rcu_read_unlock();
> +		return xsk_tx_peek_release_fallback(pool, descs, max_entries);
> +	}
> +
> +	xs = list_first_or_null_rcu(&pool->xsk_tx_list, struct xdp_sock, tx_list);
> +	if (!xs) {
> +		nb_pkts = 0;
> +		goto out;
> +	}
> +
> +	nb_pkts = xskq_cons_peek_desc_batch(xs->tx, descs, pool, max_entries);
> +	if (!nb_pkts) {
> +		xs->tx->queue_empty_descs++;
> +		goto out;
> +	}
> +
> +	/* This is the backpressure mechanism for the Tx path. Try to
> +	 * reserve space in the completion queue for all packets, but
> +	 * if there are fewer slots available, just process that many
> +	 * packets. This avoids having to implement any buffering in
> +	 * the Tx path.
> +	 */
> +	nb_pkts = xskq_prod_reserve_addr_batch(pool->cq, descs, nb_pkts);
> +	if (!nb_pkts)
> +		goto out;
> +
> +	xskq_cons_release_n(xs->tx, nb_pkts);
> +	__xskq_cons_release(xs->tx);
> +	xs->sk.sk_write_space(&xs->sk);
> +
> +out:
> +	rcu_read_unlock();
> +	return nb_pkts;
> +}
> +EXPORT_SYMBOL(xsk_tx_peek_release_desc_batch);
> +
