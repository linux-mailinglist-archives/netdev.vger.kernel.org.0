Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2955B467C33
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 18:05:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240032AbhLCRIu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 12:08:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234423AbhLCRIu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 12:08:50 -0500
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A6F5C061751
        for <netdev@vger.kernel.org>; Fri,  3 Dec 2021 09:05:26 -0800 (PST)
Received: by mail-ot1-x32f.google.com with SMTP id x19-20020a9d7053000000b0055c8b39420bso4152039otj.1
        for <netdev@vger.kernel.org>; Fri, 03 Dec 2021 09:05:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=utEWWJWCkIkBpnfbd0GlEWSSdXyFrxBmwVjIY7e8ZOk=;
        b=QOgYXXrH89NVmvg1JknUCwAtXYQETcJIXfkETH/lKpXH48TIx/5VkG+X3WHOPrZD7J
         YMXS5X8IPUoK+ZoJXdX6FJ1gG8XI7/6JTwTjFEUV5mj84ArSl0230nhlqpAoDsyg3PZ8
         n4ez55Vw9+6xol6gNhLvhcCcapGhtIIXrY8TLOfHmabllUmhxXD5qOWS4yBLz9TpoOtp
         VLUJMmujA3VIPU94tGNlYDU7VQzbivSNt8r7xSmsEGSatvubYDMAKu97XXFkso4nakYO
         1aoAR2efqZkU70eYrP6sjpuOXei7gdaPMmkRI59vPCW8CxABmwh5lFSQ1M99hVOpQSJB
         XREQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=utEWWJWCkIkBpnfbd0GlEWSSdXyFrxBmwVjIY7e8ZOk=;
        b=jDH0mTdX6NwSBqVyvLZ+OaMo+ceRQ8ZNDz9sm8AHr1mLGWI+liiPWOghDQ7BXQt8d8
         0vwDZMANWaCo5reCbDLk8anY07NYX7A4ewiV8fC3Ng1rgNsydPiWvhbHDBofC+CBttL/
         8mv3Fnyt1gGZO10Ec4NET6Lhwj2rrJgppBL34kJuFg+17FC24eTaiu8acFLQyLrcWUSK
         5RZ+gkMO6gLecMXdvRx8bIQ9iXY0ZfxMgFhaQ69VBfFePFz6nIw2suFVnNMkQgcohRNM
         igGUCQPdquxw5IVUqx9vCbJ5RzWAUC8YSoywG+aGfBEvCHvjqREfbbMRGxvtZkbvKtBM
         u9Tg==
X-Gm-Message-State: AOAM530f1I1ujdyfmfh4RxWtwL231QU7ENsWNNaYS0RMUc8m6EbZM1q9
        KrGqeSZDCGR8b1L/wtR7IceAWmVQ1E0=
X-Google-Smtp-Source: ABdhPJxTQr22OYqI+8MVVWX2lPRrsqqfuOBij7hFh8aXcoar0mz8cpSccgVfGj2Djx64YxbporFoXA==
X-Received: by 2002:a05:6830:1e97:: with SMTP id n23mr16892839otr.4.1638551125619;
        Fri, 03 Dec 2021 09:05:25 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id o6sm704286oou.41.2021.12.03.09.05.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Dec 2021 09:05:25 -0800 (PST)
Message-ID: <3cbabdb5-8c45-68e0-e60e-7bf16fe19f54@gmail.com>
Date:   Fri, 3 Dec 2021 10:05:24 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: [iproute2-next 3/4] vdpa: Enable user to set mac address of vdpa
 device
Content-Language: en-US
To:     Parav Pandit <parav@nvidia.com>, stephen@networkplumber.org,
        netdev@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org, mst@redhat.com,
        jasowang@redhat.com
References: <20211202042239.2454-1-parav@nvidia.com>
 <20211202042239.2454-4-parav@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20211202042239.2454-4-parav@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/1/21 9:22 PM, Parav Pandit wrote:
> @@ -233,6 +254,15 @@ static int vdpa_argv_parse(struct vdpa *vdpa, int argc, char **argv,
>  
>  			NEXT_ARG_FWD();
>  			o_found |= VDPA_OPT_VDEV_MGMTDEV_HANDLE;
> +		} else if ((matches(*argv, "mac")  == 0) &&

use strcmp; we are not taking any more uses of matches() for parameters.


> +			   (o_all & VDPA_OPT_VDEV_MAC)) {
> +			NEXT_ARG_FWD();
> +			err = vdpa_argv_mac(vdpa, argc, argv, opts->mac);
> +			if (err)
> +				return err;
> +
> +			NEXT_ARG_FWD();
> +			o_found |= VDPA_OPT_VDEV_MAC;
>  		} else {
>  			fprintf(stderr, "Unknown option \"%s\"\n", *argv);
>  			return -EINVAL;

