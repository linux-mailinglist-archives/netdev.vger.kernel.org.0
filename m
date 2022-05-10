Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 788BA520D30
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 07:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236698AbiEJF0j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 01:26:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231875AbiEJF0i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 01:26:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B1E872438C9
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 22:22:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652160161;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dSBUCgbnrXyS4xiqIulcu9NB35K8gsqks7zGiCMctnI=;
        b=KJSzo2VeX+LBPZI2eiNRBPuck9BvuQW7e4AyaOnF4dFPmtG5evwQYX/H1BssPCBdQulM1I
        uEVitmE9tfNSX30IVuJxcHYl+U9nUsYE0P7sbPXbL2PTAI1IXfvk1wT0mEKa1ZqJksClPx
        XzH657zxmNntKqL6zOob3RJk7wgu0B4=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-584-qBV0-bq5Nv6nvNBTeNHXiw-1; Tue, 10 May 2022 01:22:39 -0400
X-MC-Unique: qBV0-bq5Nv6nvNBTeNHXiw-1
Received: by mail-wr1-f69.google.com with SMTP id w4-20020adfbac4000000b0020acba4b779so6620545wrg.22
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 22:22:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dSBUCgbnrXyS4xiqIulcu9NB35K8gsqks7zGiCMctnI=;
        b=W2IgQ5PctPBLXCpVF21q10OcO3gegJSbjw+OA4HHiIkbv4FS18qin+AEv+mohk4mhd
         egtFoxPeg2yk78M6JbFeiXBQWlrtIdUZPjw8U0jBvzoJlNCX0Sok9AJ9S057ezir8BXi
         /wBzOkE8xtacSKaEDqePnIwkG6MxpBci69LFQ9OqNneq5rggO09CESh5RFCuZp04mtHr
         RuAnc5SEtgdS5YwMbB5yuK0Fhr7zujggaN8XJgtw4tmJLt9/JzPcSp05vC6/uDAoqcIf
         yO8ggGLu5MdVTZGV0HekUpsq2kRkzZZFPyplQQRjNEzBHrRss/sQTuuI8oeK/SAaK5VT
         cHHQ==
X-Gm-Message-State: AOAM530/X9rfaG9sbFikAkjSvvKZ4qFk99RR15KIGLX5jayAQ0R85ZXz
        sswjOI5/YHXNYz1vN6zHmO/h4kOp1L23Jd8pryPphyAmAyHJlRJNWUqE8Zp5q9ytdhUZMDNN9qX
        VqYGhp7n36VEfPpoJ
X-Received: by 2002:a05:600c:378b:b0:394:3894:3a65 with SMTP id o11-20020a05600c378b00b0039438943a65mr19610045wmr.18.1652160158254;
        Mon, 09 May 2022 22:22:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwhdbrn6t2cTRanVgLinK3hRXX7cC5Jz0nyau26pq9cmJz/uWA/9EYU3xUh3J1fN8kX9UjBNA==
X-Received: by 2002:a05:600c:378b:b0:394:3894:3a65 with SMTP id o11-20020a05600c378b00b0039438943a65mr19610035wmr.18.1652160158047;
        Mon, 09 May 2022 22:22:38 -0700 (PDT)
Received: from redhat.com ([2.55.130.230])
        by smtp.gmail.com with ESMTPSA id a15-20020a056000100f00b0020c5253d8d9sm12974968wrx.37.2022.05.09.22.22.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 22:22:37 -0700 (PDT)
Date:   Tue, 10 May 2022 01:22:34 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Tang Bin <tangbin@cmss.chinamobile.com>
Cc:     jasowang@redhat.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] virtio_net: Remove unused case in virtio_skb_set_hash()
Message-ID: <20220510012221-mutt-send-email-mst@kernel.org>
References: <20220509131432.16568-1-tangbin@cmss.chinamobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220509131432.16568-1-tangbin@cmss.chinamobile.com>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 09, 2022 at 09:14:32PM +0800, Tang Bin wrote:
> In this function, "VIRTIO_NET_HASH_REPORT_NONE" is included
> in "default", so it canbe removed.
> 
> Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>

What's the point of this?

> ---
>  drivers/net/virtio_net.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 87838cbe3..b3e5d8637 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -1172,7 +1172,6 @@ static void virtio_skb_set_hash(const struct virtio_net_hdr_v1_hash *hdr_hash,
>  	case VIRTIO_NET_HASH_REPORT_IPv6_EX:
>  		rss_hash_type = PKT_HASH_TYPE_L3;
>  		break;
> -	case VIRTIO_NET_HASH_REPORT_NONE:
>  	default:
>  		rss_hash_type = PKT_HASH_TYPE_NONE;
>  	}
> -- 
> 2.20.1.windows.1
> 
> 

