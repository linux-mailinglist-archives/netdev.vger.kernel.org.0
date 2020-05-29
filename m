Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0F0F1E8320
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 18:06:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728115AbgE2QGb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 12:06:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725795AbgE2QG2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 12:06:28 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84786C03E969;
        Fri, 29 May 2020 09:06:28 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id h9so2324147qtj.7;
        Fri, 29 May 2020 09:06:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lqTsyzjRehJUOH405LBW4wTGdQ2N6UIDHlWNnbs0wQw=;
        b=DgU2WmpxqUFLQ+4O4a2LwXWDXk1KgxaX+xNMUUQ/HtvQ0+NO3TPRP7NcpG/1oNMDBb
         VYLsi7BuudNO0qEyLzbKMaNuMVGwpQ5akkwxkS8zjNwT27AkwlrR5B58logDJ4VEfXQY
         6WOiqz4KzenhsujPS941u5eSadiokp0Pyn/nxfwnxlITVKVe5KCvpjKTbiKcTMijuzjc
         5qc0M2wM6QOwdqSg+6R6GKpfXzD/mujKDY9xgec3zMBT88rj38i26nMDRTaGGZiPHaQ9
         ApRm+G2O3dV5gDumTPB2cPUBwn0U7MWbJqhjV6JalsuIE/crJ5/YoQgNpT9hXGI0eqx2
         mYkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lqTsyzjRehJUOH405LBW4wTGdQ2N6UIDHlWNnbs0wQw=;
        b=qbVGZZuBKnCd7RQu9VW+XEY8WpnOh/8+WiwbPjQazp7Q1rvbxanrW3aSbu6D6TfBwP
         LqHHkrQtghEiYh1iJ1i6S8lRM31b9+PtHZLt1LCEAXjMS1R53P0SRM2oc6cAVV6c8YEw
         BECLfN/5FuO1LnSw18uN3DnjlIXGS+wPIPhI7ipxi/WYYzRmTJ213cBA/5OrkTXmQVMG
         2s1eBQHFWH9daT2dYixi1MQdu0mo+IRwMhQc0m4IiI0m8Tdl2RyvBN1pyt4y2R5/s/rg
         vk1pR5Dd6werW++42YE+FnoKX067Bv13FEqplp8/i3ZvniSUHKTy6GZS9h8b/rsSxIkU
         UsVg==
X-Gm-Message-State: AOAM533w3vVJDTRO+kDh2zahzBVfSqhdh7860RuwAq+i2BhV+qZuctVM
        CoekrpZ3P+VWpBdNcq8B9B8=
X-Google-Smtp-Source: ABdhPJwXvWOjITxD1BzHdHiBH+kJMAfmlqQtckkVGFDu1kRKUccRxxJwItrlNrQuqa2PGzC7wYeq8Q==
X-Received: by 2002:aed:3b54:: with SMTP id q20mr9805140qte.362.1590768387836;
        Fri, 29 May 2020 09:06:27 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:9452:75de:4860:c1e3? ([2601:282:803:7700:9452:75de:4860:c1e3])
        by smtp.googlemail.com with ESMTPSA id 10sm7802275qkv.136.2020.05.29.09.06.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 May 2020 09:06:27 -0700 (PDT)
Subject: Re: [PATCH bpf-next RFC 1/3] bpf: move struct bpf_devmap_val out of
 UAPI
To:     Jesper Dangaard Brouer <brouer@redhat.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
References: <159076794319.1387573.8722376887638960093.stgit@firesoul>
 <159076798058.1387573.3077178618799401182.stgit@firesoul>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <a0cadc6b-ceb4-c40b-8a02-67b99a665d74@gmail.com>
Date:   Fri, 29 May 2020 10:06:25 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <159076798058.1387573.3077178618799401182.stgit@firesoul>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/29/20 9:59 AM, Jesper Dangaard Brouer wrote:
> @@ -60,6 +60,15 @@ struct xdp_dev_bulk_queue {
>  	unsigned int count;
>  };
>  
> +/* DEVMAP values */
> +struct bpf_devmap_val {
> +	__u32 ifindex;   /* device index */
> +	union {
> +		int   fd;  /* prog fd on map write */
> +		__u32 id;  /* prog id on map read */
> +	} bpf_prog;
> +};
> +

I can pick up this name change for v4.
