Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B92750A3E4
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 17:21:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1389992AbiDUPYR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 11:24:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232403AbiDUPYR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 11:24:17 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FFD93BBF8;
        Thu, 21 Apr 2022 08:21:27 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id l7so10797523ejn.2;
        Thu, 21 Apr 2022 08:21:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ctcaNqnsK/9euwlyEAdPOaYIg/qSLmmC7N58OzhpKVw=;
        b=E9rP+bSJG/6inY0A49vi66QRg78rzON90dZvX/SL1heSDeZalFx5qJacZL+5b0LwDc
         Rqtbufwnx3uWumuSca12mqYfn6umHhBhahyiVTO7/fTqbSDJADWJj7sKlcRHZhT+zquq
         zW3N+GzxRg4DnVHpOjXryeGDovu4ihr8UHiqUFShOKg44yM/HDs+5bCLx6bUbdzJcfI7
         Iq7w64TAQ2YcZ8VwagSHguCSAHjwtSJvjYRstukcEcTUJBr9bNumy48rTACXIpNVPEBw
         JdwYNYJPfntnDaqkW0Eox8yoQ+dgLGIQvy/htqtgTmvRbE5uqK/nQC4fLzVt2VcE8WvT
         Dz6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ctcaNqnsK/9euwlyEAdPOaYIg/qSLmmC7N58OzhpKVw=;
        b=XNXX3wO8y2nkT1xE2h/jjOKp5j8iue2tcxERhcw4SJ/1rSv1eVlyEgSxEjJkrPsyBi
         NeRhsjxirswfXTiHa5lPjajEycuwiT35KfX8YIh82HsV8n3o8BtnPY7TVKX74KHCQBb8
         TKArtznimMO5AoXseVDM7I/CqESEblGvjdjWyjJXZRcsIoZypJyFkhkSpZo1WNU6WH+L
         BX4Sw9LLM9DwS68Bj7VnXflENpyTN8eRViDjbxl+tz/ZqDi10BX3SAp5LNS4VtHF4cGN
         GK+8YI1lfTpcBJKgjznwlKj0CZ0k9o3MEQxe0gfy81K1prm9syInnYZdzSaPRsuZIZnY
         6wDg==
X-Gm-Message-State: AOAM531nOGb5jxjiobpVuhPaKbQomPfAJk4afz1T3Q3PsVTwIoMDekM5
        MW2NXid9HP/LMyla4spi5PM=
X-Google-Smtp-Source: ABdhPJyC8ho9tn+IN0nr/rQfbnRaQE4XjxklIRhEfEAnF0pxRd9AQumo4hDR+GsjzPH63rMhf5S3+g==
X-Received: by 2002:a17:906:a08b:b0:6b9:2e20:f139 with SMTP id q11-20020a170906a08b00b006b92e20f139mr15834ejy.463.1650554485514;
        Thu, 21 Apr 2022 08:21:25 -0700 (PDT)
Received: from anparri (host-79-27-69-122.retail.telecomitalia.it. [79.27.69.122])
        by smtp.gmail.com with ESMTPSA id f5-20020a1709067f8500b006da68bfdfc7sm7956486ejr.12.2022.04.21.08.21.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Apr 2022 08:21:24 -0700 (PDT)
Date:   Thu, 21 Apr 2022 17:21:17 +0200
From:   Andrea Parri <parri.andrea@gmail.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-hyperv@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] hv_sock: Copy packets sent by Hyper-V out of the
 ring buffer
Message-ID: <20220421152117.GA4679@anparri>
References: <20220420200720.434717-1-parri.andrea@gmail.com>
 <20220420200720.434717-3-parri.andrea@gmail.com>
 <20220421135839.2fj6fk6bvlrau73o@sgarzare-redhat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220421135839.2fj6fk6bvlrau73o@sgarzare-redhat>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > @@ -378,6 +381,8 @@ static void hvs_open_connection(struct vmbus_channel *chan)
> > 		rcvbuf = ALIGN(rcvbuf, HV_HYP_PAGE_SIZE);
> > 	}
> > 
> > +	chan->max_pkt_size = HVS_MAX_PKT_SIZE;
> > +
> 
> premise, I don't know HyperV channels :-(
> 
> Is this change necessary to use hv_pkt_iter_first() instead of
> hv_pkt_iter_first_raw()?

Yes, the change is required to initialize the buffer which holds the
copies of the incoming packets (in hv_ringbuffer_init()).


> If yes, then please mention that you set this value in the commit message,
> otherwise maybe better to have a separate patch.

Sure, will do.

Thanks,
  Andrea
