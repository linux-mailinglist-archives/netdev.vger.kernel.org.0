Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB7593509E6
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 00:01:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232589AbhCaWA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 18:00:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231676AbhCaWAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 18:00:21 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1701DC061574;
        Wed, 31 Mar 2021 15:00:21 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id x16so162141iob.1;
        Wed, 31 Mar 2021 15:00:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=OJa7aLdBWO57LWQ6v7C3AUMAfgikKe2S1MkL/HKL6YE=;
        b=bVdZ5hw0IPXo/QBzMf2MxbBFy43vg2RajrcN0E4ZYRR5a6Bn6G0iSClyMT1OOiYXny
         Qezv3MbdyyIarrXql2g3OEP/2wSWAj3S5d9MPVzyf41y9PdsTAJ0H/H9GfEnw2cTM0Kg
         Y5IL0czg4jXbu1Hn0JgqV0xQXn0diXA6rOwjm6/gYHxWp7/lOGdlZ+7YjX3m69ZSdtgm
         cPpEirT1jiFhlYPMaNP6XLwv4KVj4KiIVmdz5ut0G6evs+sapDMft7ZBbribvu65Jqvs
         pwYSlLApZTjWkhDdVMD8wPD5+3XnHq7vM3kTHohLV1LLUAuh+wmd/9S+i/snnUe32oRo
         IfHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=OJa7aLdBWO57LWQ6v7C3AUMAfgikKe2S1MkL/HKL6YE=;
        b=GzbSfNY/1DoepoKuMFIxBLBTjyEBmKy5Fi9hQ+3padOORedS5SO5yUC9Tydg/mzCBX
         7EYmj+m+bAvBjUEeTepLVIvb3WtaeyWd24vN0bLgQNC+5eoDWoYXtWCkFNtXmu2wgvIt
         GyJwnEpU0U1Ob0HkLuoyhyseIRpwr3AZECrPFfzjiptOjxp7u5AGCGfQ/E91/i79gYq5
         eZO/IYDLiaT4UjTzG8Jay30mIFG1O7wey+2+mmlrBE7UjnbbYM/7ICGng2fv2tPa/lGu
         g1ROJ1OXJqcfAECIA2rCdYzsYLjQdAWYdVIgXOx9YS3aXPXr3gR8zovA8jDtfvhaapQV
         CKOg==
X-Gm-Message-State: AOAM531X+JHZ9PeDGh5jwXXtalClckCx0YoaOrQQ2xZpQMRhc8UdHsyX
        TaMFL+f6BKchwTtRRsERf0o=
X-Google-Smtp-Source: ABdhPJxNj9MoRc0F5aSJBTglJ2+nl87+A9UaUVLaNDuQ3InP8fS/t7PhF77t7eNW41OpIh5F7LGiEQ==
X-Received: by 2002:a02:9048:: with SMTP id y8mr4873510jaf.66.1617228020497;
        Wed, 31 Mar 2021 15:00:20 -0700 (PDT)
Received: from localhost ([172.242.244.146])
        by smtp.gmail.com with ESMTPSA id c19sm1595613ile.17.2021.03.31.15.00.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Mar 2021 15:00:19 -0700 (PDT)
Date:   Wed, 31 Mar 2021 15:00:10 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Message-ID: <6064f0ea917f5_868622089b@john-XPS-13-9370.notmuch>
In-Reply-To: <20210331023237.41094-2-xiyou.wangcong@gmail.com>
References: <20210331023237.41094-1-xiyou.wangcong@gmail.com>
 <20210331023237.41094-2-xiyou.wangcong@gmail.com>
Subject: RE: [Patch bpf-next v8 01/16] skmsg: lock ingress_skb when purging
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
> 
> Currently we purge the ingress_skb queue only when psock
> refcnt goes down to 0, so locking the queue is not necessary,
> but in order to be called during ->close, we have to lock it
> here.
> 
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Lorenz Bauer <lmb@cloudflare.com>
> Acked-by: Jakub Sitnicki <jakub@cloudflare.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---
>  net/core/skmsg.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/core/skmsg.c b/net/core/skmsg.c
> index 07f54015238a..bebf84ed4e30 100644
> --- a/net/core/skmsg.c
> +++ b/net/core/skmsg.c
> @@ -634,7 +634,7 @@ static void sk_psock_zap_ingress(struct sk_psock *psock)
>  {
>  	struct sk_buff *skb;
>  
> -	while ((skb = __skb_dequeue(&psock->ingress_skb)) != NULL) {
> +	while ((skb = skb_dequeue(&psock->ingress_skb)) != NULL) {
>  		skb_bpf_redirect_clear(skb);
>  		kfree_skb(skb);
>  	}
> -- 
> 2.25.1
> 

Acked-by: John Fastabend <john.fastabend@gmail.com>
