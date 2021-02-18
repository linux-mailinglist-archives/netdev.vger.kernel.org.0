Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A07431E38A
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 01:48:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbhBRAsV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 19:48:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbhBRAsR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 19:48:17 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD901C061574;
        Wed, 17 Feb 2021 16:47:37 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id u143so121643pfc.7;
        Wed, 17 Feb 2021 16:47:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9AQCchQC3RVaMv/Hcn0M+7TZdZEVJRof4WAPBKGbACg=;
        b=lmEGx+TeyVIR9oSiK4robQdT8vT9B9D2gCCx1AKSquREKfdRrdvFjot6+1PwmkMySC
         JGcfgQ3tzcMUP0a79XDAa8BoX9lJSTX6darSNC0HVNzhQ8ZsmcdYVVmajvpbheZqXufq
         3LSlRjO4tRJJO8bO8PrN+Doduh6OH4ZotEhk55FQ9t0HEwmitwRg8S/x7JCAVZ4RaW4V
         uIBIRA5zeiwI0OKpUJzS/s3FGmROLTLujN/SGTDO1Cuxf52CufpFnu3WEmOqiihYDwPr
         /MONKVCvl+9TJxdgsSQeUPv5Tub82a0tNMPp48eut8pQCD6oOVnljXOVLe/mi0ntkUMV
         Ae4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9AQCchQC3RVaMv/Hcn0M+7TZdZEVJRof4WAPBKGbACg=;
        b=GNJ77woeBY7yoXJ2ZUdfZXD2v60ly3wkf0WYF3b5EQDigQEXFMqjsNT+vVzIT4Rw2Q
         WhJgGwakJqeAJMPWd+eCrZyxF3QOjhJ3RkPwe4hMAQ343P+gET857TRKBtB1AIM+EMs6
         ETil8SR9eHfvDnxzqV/eSfVsgDbrAZ3vMsMAmpR9Ps0D9MRx8r0SQtCDa4dAlejlmppX
         p0oiSvdU0SIyJ/92CepWietOAuq9lFtczJQq0PQEIMHekZtKZJgzQNBLAtmbuKltTRHK
         dnnPMJQrCehLVYty3DwI+isa5Ke6fOhuHcqxUem3d/IjcdPhsvYG3VoJCoRviakJiSAt
         2djw==
X-Gm-Message-State: AOAM531auC+pRZA/lA6uScREct6joacC7THi1HyHPZrZDiZgypkWVwBx
        vLEFndUo4KPZH+omeflYZn0=
X-Google-Smtp-Source: ABdhPJyFVk8+ypuV2LLDlViNh2a+mh0HOrRUj0ErpARIXvmeJjPbciPtcJaO663PjuaXM5qhAJ9oUg==
X-Received: by 2002:a05:6a00:2353:b029:1ba:d824:f1dc with SMTP id j19-20020a056a002353b02901bad824f1dcmr1846175pfj.9.1613609257138;
        Wed, 17 Feb 2021 16:47:37 -0800 (PST)
Received: from localhost ([2409:10:2e40:5100:6e29:95ff:fe2d:8f34])
        by smtp.gmail.com with ESMTPSA id q139sm3368597pfc.2.2021.02.17.16.47.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Feb 2021 16:47:36 -0800 (PST)
Date:   Thu, 18 Feb 2021 09:47:34 +0900
From:   Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To:     "Enrico Weigelt, metux IT consult" <info@metux.net>
Cc:     linux-kernel@vger.kernel.org, pmladek@suse.com,
        rostedt@goodmis.org, sergey.senozhatsky@gmail.com,
        andriy.shevchenko@linux.intel.com, linux@rasmusvillemoes.dk,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH] lib: vsprintf: check for NULL device_node name in
 device_node_string()
Message-ID: <YC25JlDIPl30xPab@jagdpanzerIV.localdomain>
References: <20210217121543.13010-1-info@metux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210217121543.13010-1-info@metux.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On (21/02/17 13:15), Enrico Weigelt, metux IT consult wrote:
> Under rare circumstances it may happen that a device node's name is NULL
> (most likely kernel bug in some other place). In such situations anything
> but helpful, if the debug printout crashes, and nobody knows what actually
> happened here.
> 
> Therefore protect it by an explicit NULL check and print out an extra
> warning.
> 
> Signed-off-by: Enrico Weigelt, metux IT consult <info@metux.net>
> ---
>  lib/vsprintf.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> index 3b53c73580c5..050a60b88073 100644
> --- a/lib/vsprintf.c
> +++ b/lib/vsprintf.c
> @@ -2013,6 +2013,10 @@ char *device_node_string(char *buf, char *end, struct device_node *dn,
>  			break;
>  		case 'n':	/* name */
>  			p = fwnode_get_name(of_fwnode_handle(dn));
> +			if (!p) {
> +				pr_warn("device_node without name. Kernel bug ?\n");
> +				p = "<NULL>";
> +			}
>  			precision = str_spec.precision;
>  			str_spec.precision = strchrnul(p, '@') - p;
>  			buf = string(buf, end, p, str_spec);

What about other fwnode_get_name() calls in vsprintf?

	-ss
