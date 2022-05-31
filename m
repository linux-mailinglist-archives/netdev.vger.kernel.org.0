Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A576538D12
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 10:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244940AbiEaInZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 04:43:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241386AbiEaInQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 04:43:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CFE2860B81
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 01:43:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653986593;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9fPaBZDsV84kO0IEmLkMM+G7p0afLOtSjYZX9TssTp0=;
        b=aO4tJH3JJRPN+DCu2Aut0KBwInyQRWtxoh2bSmin/pdTOfrbrcMden7QY3T3P19L1c/KpW
        s3IUqUmdcdKsjlQqJeMQWEQxE5uHvItjDHDDtu5kkfMfrgflkaRUEGYnAOtHOBk9aHY6Hx
        8drAuU8yrzj+9+vuto022pbSuyRZYss=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-482-FqLzTIuoNoO7z2xIZZdufQ-1; Tue, 31 May 2022 04:43:12 -0400
X-MC-Unique: FqLzTIuoNoO7z2xIZZdufQ-1
Received: by mail-wr1-f70.google.com with SMTP id p8-20020a5d4588000000b0021033f1f79aso707023wrq.5
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 01:43:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=9fPaBZDsV84kO0IEmLkMM+G7p0afLOtSjYZX9TssTp0=;
        b=Xf7o52bhJ4lJXAwUjCu9Wtr6S4E0FO/Cfe2UIeJ6Mh6hfzoofjt4ajxNRvfDjX1cDx
         qlPZn3uFVj4aiTLPDfwz0NvGoLcvWy18OwgtAzgRc8cO2hriRygDBoKhwhug3eLu8Kbk
         wCuAZvWtlBuYtXafv7JVw5xsBMMxF9+X6hlMNkKpuAqGho9Gb9ak7Kse+W0Ttf88B+xC
         uNCLdjyavr7YimucFps5A60fLkLLrSsvLhFAnxrIq7+RbmlveMJCuNSaZMbbm8T1E1c3
         m0+hDVeZpTfwSkuDeRyBaIx14T2/QS/LfwChcxXaFeJWX5HGEb2cNJnXdpoix92IQyN+
         klng==
X-Gm-Message-State: AOAM533M4idQSVNmjqnw6TR6NrN00F/MpIO9P9uFPM0g8xZjVgBLhHZc
        6Tvo7Fkv7DihlT067dZOjot/rr4CtjOPn1K0GQ+b7ezY1mJTGfgpw4R8HSmE6FXh6Hyxh7JkD4b
        BBKGPUmmK/otegUU/
X-Received: by 2002:a05:600c:3b05:b0:397:54ce:896 with SMTP id m5-20020a05600c3b0500b0039754ce0896mr22494785wms.3.1653986591071;
        Tue, 31 May 2022 01:43:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzfshR+I/hDPQmtoECOmlS+FrzrfxKwqTinLxQRa/ZAYNB2+FaUFLoMjB75XtGMJIFbhKjijA==
X-Received: by 2002:a05:600c:3b05:b0:397:54ce:896 with SMTP id m5-20020a05600c3b0500b0039754ce0896mr22494767wms.3.1653986590859;
        Tue, 31 May 2022 01:43:10 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-112-184.dyn.eolo.it. [146.241.112.184])
        by smtp.gmail.com with ESMTPSA id g9-20020a05600c4ec900b0039c17452732sm1554367wmq.19.2022.05.31.01.43.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 May 2022 01:43:10 -0700 (PDT)
Message-ID: <e530dc2021d43a29b64f985d7365319eab0d5595.camel@redhat.com>
Subject: Re: [PATCH 1/6] netlink: fix missing destruction of rhash table in
 error case
From:   Paolo Abeni <pabeni@redhat.com>
To:     Chengguang Xu <cgxu519@mykernel.net>, netdev@vger.kernel.org,
        linux-staging@lists.linux.dev, linux-scsi@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org
Date:   Tue, 31 May 2022 10:43:09 +0200
In-Reply-To: <20220529153456.4183738-2-cgxu519@mykernel.net>
References: <20220529153456.4183738-1-cgxu519@mykernel.net>
         <20220529153456.4183738-2-cgxu519@mykernel.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Sun, 2022-05-29 at 23:34 +0800, Chengguang Xu wrote:
> Fix missing destruction(when '(--i) == 0') for error case in
> netlink_proto_init().
> 
> Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
> ---
>  net/netlink/af_netlink.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
> index 0cd91f813a3b..bd0b090a378b 100644
> --- a/net/netlink/af_netlink.c
> +++ b/net/netlink/af_netlink.c
> @@ -2887,7 +2887,7 @@ static int __init netlink_proto_init(void)
>  	for (i = 0; i < MAX_LINKS; i++) {
>  		if (rhashtable_init(&nl_table[i].hash,
>  				    &netlink_rhashtable_params) < 0) {
> -			while (--i > 0)
> +			while (--i >= 0)
>  				rhashtable_destroy(&nl_table[i].hash);
>  			kfree(nl_table);
>  			goto panic;

The patch looks correct to me, but it looks like each patch in this
series is targeting a different tree. I suggest to re-send, splitting
the series into individual patches, and sending each of them to the
appropriate tree. You can retain Dan's Review tag.

Thanks,

Paolo

