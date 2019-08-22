Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 563FD9A358
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 00:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390930AbfHVW6O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 18:58:14 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:45719 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727461AbfHVW6O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 18:58:14 -0400
Received: by mail-qk1-f196.google.com with SMTP id m2so6658471qki.12
        for <netdev@vger.kernel.org>; Thu, 22 Aug 2019 15:58:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=uLuPhcHCaJRyB7SqIdcuPhUQ+/J9410xyT/KslF6V6c=;
        b=cdJLygrk7r8T7y3K94oC2GeXy1W4lmA0puIen2qhZkbjKZxH+jbMt4/mNSlFVhPH9C
         3vsLkpYvJbAnfWrgPGJ/vMBgLb1HlTiVLAEmU0dZsgGk+9rbX6pLrg6jb93Mhd4Izxxi
         Y+p9x7vMzYaMFsJNitlrgJZAlJ+SiFe8BGKggPaVXA7zU0nii24A9Q+8RrVd+KsDNyJ7
         EICtpGLezH05IcbSVAQKH8jy/A0OVH/Esg4TD6Bb2uwD3rEyH4EzEmSPsCUx1/gtfkQS
         ch7XpUEH+6Sj34NleOKtHKGwmjnGMCMa2GxQ75ypnOJ/OZpSu0yrTpwN/8lpD46nZGGU
         Mdpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=uLuPhcHCaJRyB7SqIdcuPhUQ+/J9410xyT/KslF6V6c=;
        b=Hv+Dg8l2Kgf0m9v0oNhD6KtyBlrgm0bkyBMxIBt7qZTdiAAPR0HFbTvzWdG4cOE5w5
         X9EC2h8oaUxyI2PN3zIK9b2dZQ1MH6IAYCqqCmHL4qlevM3h2AXNgouVQyplnOKDU+ZM
         0EBKfunvNpNwEi3kj0B2y5oe+i41t/V7XF1XKd4Bqz1zoeqbtbffneEWPwRzfcFx+txz
         0Gs6DVPh5TlCCNZhenuRfbSxbofI10SFPFfU4W5QJ04+jMuZhIiWJ2opxdnhxDB4Imdm
         76Z4KedoQJQGQ6G+iPySXAzmsRI9ljgvWwkRiFWUnf/DqyKYiKx2xFKuqIBN/ol9d24m
         QJag==
X-Gm-Message-State: APjAAAV6SKdgUfZe/Z7mS3ZU3afGAfCVXcLBC7/umROjadLgomOLjc/i
        lpK87CpuTTcicIBHJrAxVXYTaA==
X-Google-Smtp-Source: APXvYqzJSLhGFjkYppVi49qHA8Dp7AvyJR0MDkhH2TbO57QE0N9UokOdeY5/wdfwCNdUhC06Wvbp6g==
X-Received: by 2002:a37:a492:: with SMTP id n140mr1366824qke.137.1566514693265;
        Thu, 22 Aug 2019 15:58:13 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id t26sm502104qtc.95.2019.08.22.15.58.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Aug 2019 15:58:13 -0700 (PDT)
Date:   Thu, 22 Aug 2019 15:58:05 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Vlad Buslov <vladbu@mellanox.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, pablo@netfilter.org,
        Jiri Pirko <jiri@mellanox.com>
Subject: Re: [PATCH net-next 04/10] net: sched: notify classifier on
 successful offload add/delete
Message-ID: <20190822155805.6fe6f00c@cakuba.netronome.com>
In-Reply-To: <20190822124353.16902-5-vladbu@mellanox.com>
References: <20190822124353.16902-1-vladbu@mellanox.com>
        <20190822124353.16902-5-vladbu@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 22 Aug 2019 15:43:47 +0300, Vlad Buslov wrote:
> diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
> index 4215c849f4a3..d8ef7a9e6906 100644
> --- a/net/sched/cls_api.c
> +++ b/net/sched/cls_api.c
> @@ -3099,9 +3099,13 @@ int tc_setup_cb_add(struct tcf_block *block, struct tcf_proto *tp,
>  	}
>  
>  	ok_count = __tc_setup_cb_call(block, type, type_data, err_stop);
> -	if (ok_count > 0)
> -		tc_cls_offload_cnt_update(block, tp, in_hw_count, flags,
> -					  ok_count, true);
> +	if (ok_count >= 0) {
> +		if (tp->ops->hw_add)
> +			tp->ops->hw_add(tp, type_data);
> +		if (ok_count > 0)
> +			tc_cls_offload_cnt_update(block, tp, in_hw_count, flags,
> +						  ok_count, true);
> +	}

nit:

	if (ok_count < 0)
		goto err_unlock;

	if (tp->ops->hw_add)
		tp->ops->hw_add(tp, type_data);
	if (ok_count > 0)
		tc_cls_offload_cnt_update(block, tp, in_hw_count, flags,
					  ok_count, true);

IOW try to keep the "success flow" unindented.

>  errout:
>  	up_read(&block->cb_lock);
>  	return ok_count;
