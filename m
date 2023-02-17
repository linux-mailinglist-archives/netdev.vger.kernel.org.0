Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A31AE69AA16
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 12:16:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbjBQLQO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 06:16:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbjBQLQN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 06:16:13 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36D81642DD
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 03:15:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676632480;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GwnXqRN41dS8yeNMsOJVqb/p7IdMaJcNLJqGuiCPy3I=;
        b=L+DoRngSNsCH1xar+WU2vWkI9HS8PcVCXXMscusw3bL/DIyukzJJlWpDqzK0moRtmpMmwk
        70qtoL6inw/MmoMQMnhPCxIpHcCgGq65qmad3dUMwrZ3f+34L5ROZ9eANzYGR2OOonvCzW
        rVrMx9HEZ1M8D8i7LLTPoiUJY5cBXbI=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-159-TaFsdlP1MGuqamoGjTs47w-1; Fri, 17 Feb 2023 06:14:39 -0500
X-MC-Unique: TaFsdlP1MGuqamoGjTs47w-1
Received: by mail-qk1-f198.google.com with SMTP id 130-20020a370588000000b0072fcbe20069so2887235qkf.22
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 03:14:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GwnXqRN41dS8yeNMsOJVqb/p7IdMaJcNLJqGuiCPy3I=;
        b=aGEC6mAWrFWrXRaQbqJRgjnGFU4iRn/xn8+Hr8uENut2UPexrCjg3mU5F4imOf7liG
         U+TeRHunk8E+WIinTJKs2BZanP03aLkGad1tJAVqItIy/Rx352ci9n8R2ZrJYG1qXiCT
         4jcSrMttBtiIo88U3x6rV8nDdMcVLCvHGSIYTtJY/uwZUD+Sqa95zrIJ6ypSTlQ51qJp
         wg4ZVXWLT+K6o8OUo7HA19+b9FZNAXdAy6D3ezZLKxAZ7c1MnJm6TNAPzXYQ9+VpcfRf
         0LhYwK8d8m3p0QO2hU4XizU58h49PewhzAT15FgWvQH5EaTcC+5J7WMeev0zUqw4tiQi
         HSRg==
X-Gm-Message-State: AO0yUKUhbSF2MIvLsGLgWi8HN71SOLaS65jBppHdZe2ljW/46R4V8p5r
        TOLstafDX2SnvAwIbgm68Y9aHijMaQMJXGudRYmXpyLNw9lTyhOB23Eek26ZNaREC9ve8s3MIv2
        qY4YgoFcrpXiG1kJf
X-Received: by 2002:a05:622a:100d:b0:3b9:b260:1e76 with SMTP id d13-20020a05622a100d00b003b9b2601e76mr1600339qte.1.1676632478726;
        Fri, 17 Feb 2023 03:14:38 -0800 (PST)
X-Google-Smtp-Source: AK7set+8uzOSpW1cpKYb+uvihRbYVIJFTUowWidMaTVzImSrBl99cLyg0x5RBoagtKPioicS78k0Xw==
X-Received: by 2002:a05:622a:100d:b0:3b9:b260:1e76 with SMTP id d13-20020a05622a100d00b003b9b2601e76mr1600312qte.1.1676632478456;
        Fri, 17 Feb 2023 03:14:38 -0800 (PST)
Received: from debian (2a01cb058918ce00f383cbdd978c726b.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:f383:cbdd:978c:726b])
        by smtp.gmail.com with ESMTPSA id x68-20020a379547000000b0073b692623c5sm3020287qkd.129.2023.02.17.03.14.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Feb 2023 03:14:37 -0800 (PST)
Date:   Fri, 17 Feb 2023 12:14:34 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Shigeru Yoshida <syoshida@redhat.com>
Cc:     jchapman@katalix.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>
Subject: Re: [PATCH net v3] l2tp: Avoid possible recursive deadlock in
 l2tp_tunnel_register()
Message-ID: <Y+9hmmAlHOo4yX9Q@debian>
References: <20230216163710.2508327-1-syoshida@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230216163710.2508327-1-syoshida@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 17, 2023 at 01:37:10AM +0900, Shigeru Yoshida wrote:
> @@ -840,8 +850,7 @@ static int pppol2tp_connect(struct socket *sock, struct sockaddr *uservaddr,
>  	}
>  	if (drop_refcnt)
>  		l2tp_session_dec_refcount(session);
> -	if (drop_tunnel)
> -		l2tp_tunnel_dec_refcount(tunnel);
> +	l2tp_tunnel_dec_refcount(tunnel);
>  	release_sock(sk);
>  
>  	return error;

The l2tp_tunnel_dec_refcount() call could be done after release_sock(),
to make the code more logical (as the refcount is now taken before
lock_sock()). Anyway, that shouldn't be a problem and I don't want to
delay this fix any longer.

Reviewed-by: Guillaume Nault <gnault@redhat.com>

