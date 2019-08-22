Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26D249A378
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 01:04:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405524AbfHVXDi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 19:03:38 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:43509 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405520AbfHVXDi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 19:03:38 -0400
Received: by mail-qt1-f194.google.com with SMTP id b11so9532309qtp.10
        for <netdev@vger.kernel.org>; Thu, 22 Aug 2019 16:03:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=JvKGaklR9PopJUf4ayA+2KK2nUbOaQb5vvy/Q91wppI=;
        b=ZP2nf1GOwO3OgJDhj8Kh+4/3DHPPwaa1bBI13Qze8ImeVq/97Ej2LOpFj7evFsLN1q
         A3S7G6MX0Em0a2M7IDwlE9t5yaqRNjqHJVaRwcGIV8Pf0ASeZf/6mc/1RrpKyxdMUMIV
         YN5gTAK622ixaS00nvhyuy1VuwP6L5ZRBKHB/6v3USh4GPlN8n/kJFE9E3LZg0wakcSo
         noezMDYWafa8+0SgiRXv9fzcmwzyR4DoVikNAoutE0Aax9jR7qyZ/EzFh4aYzx4ODyY4
         LF6pT3ZUfNzPr3x4jWUy7lhtbjc1nIF9AW0mXIzdphBsqzJVLYIwWyf7B4qeism4LUqN
         LToA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=JvKGaklR9PopJUf4ayA+2KK2nUbOaQb5vvy/Q91wppI=;
        b=eIVJUFSzewz/9UUFscY4cF5jQ16yWGlXCkAiuQgePziDZHVEbpG5FFNmlayiLPIhxq
         LgRnLmb019wFdDrbHcU1T1PUpV60+PKRlk8b/gqMMoXjyuRXTQvFbiDXYFp7yKRKqcdD
         LAAfltyrrU7NdD1d0o99jAsVoVNnzroSiMBcMNmO7Q460NeMK08MQyEtixZ8A9ov8NXL
         iFAzeubhT4aYIu0dLWYTbyAONtt3A3VfYh/nIxkN2rLEFP4/ERPU4Fw5StS9ldOzVU3k
         llnGeSTKJcds1p0D0ilNKKaVKboZgVh4phF5Lb16d3f7HCnk/w0S2JKFq0sESWm7stSq
         wn8Q==
X-Gm-Message-State: APjAAAVA80bLZaL/bAuKwRmYDtC0iImzoHr/Tbksltgw3yg8zilSKyFw
        VULdknNlnjiwYyEu+07t6WiQMg==
X-Google-Smtp-Source: APXvYqx7iZXYMjtiXrkVf3l8kAYovg1/rPPHkls/JIio+kw3gzJHr2OMp3Aw7v7G3Yb3++w558/3sw==
X-Received: by 2002:ac8:70d1:: with SMTP id g17mr2252904qtp.124.1566515017106;
        Thu, 22 Aug 2019 16:03:37 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id 6sm624936qtu.15.2019.08.22.16.03.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Aug 2019 16:03:36 -0700 (PDT)
Date:   Thu, 22 Aug 2019 16:03:28 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Vlad Buslov <vladbu@mellanox.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, pablo@netfilter.org,
        Jiri Pirko <jiri@mellanox.com>
Subject: Re: [PATCH net-next 06/10] net: sched: conditionally obtain rtnl
 lock in cls hw offloads API
Message-ID: <20190822160328.46f7fab7@cakuba.netronome.com>
In-Reply-To: <20190822124353.16902-7-vladbu@mellanox.com>
References: <20190822124353.16902-1-vladbu@mellanox.com>
        <20190822124353.16902-7-vladbu@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 22 Aug 2019 15:43:49 +0300, Vlad Buslov wrote:
> diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
> index 02a547aa77c0..bda42f1b5514 100644
> --- a/net/sched/cls_api.c
> +++ b/net/sched/cls_api.c
> @@ -3076,11 +3076,28 @@ __tc_setup_cb_call(struct tcf_block *block, enum tc_setup_type type,
>  int tc_setup_cb_call(struct tcf_block *block, enum tc_setup_type type,
>  		     void *type_data, bool err_stop, bool rtnl_held)
>  {
> +	bool take_rtnl = false;

Should we perhaps speculatively:

	 bool take_rtnl = READ_ONCE(block->lockeddevcnt);

here? It shouldn't hurt, really, and otherwise every offload that
requires rtnl will have to re-lock cb_lock, every single time..

>  	int ok_count;
>  
> +retry:
> +	if (take_rtnl)
> +		rtnl_lock();
>  	down_read(&block->cb_lock);
> +	/* Need to obtain rtnl lock if block is bound to devs that require it.
> +	 * In block bind code cb_lock is obtained while holding rtnl, so we must
> +	 * obtain the locks in same order here.
> +	 */
> +	if (!rtnl_held && !take_rtnl && block->lockeddevcnt) {
> +		up_read(&block->cb_lock);
> +		take_rtnl = true;
> +		goto retry;
> +	}
> +
>  	ok_count = __tc_setup_cb_call(block, type, type_data, err_stop);
> +
>  	up_read(&block->cb_lock);
> +	if (take_rtnl)
> +		rtnl_unlock();
>  	return ok_count;
>  }
>  EXPORT_SYMBOL(tc_setup_cb_call);

