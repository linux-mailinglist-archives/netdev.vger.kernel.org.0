Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFD955025EF
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 08:59:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350831AbiDOHBW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 03:01:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350810AbiDOHBT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 03:01:19 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5751AB2472;
        Thu, 14 Apr 2022 23:58:52 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id i27so13942549ejd.9;
        Thu, 14 Apr 2022 23:58:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OI3GF4xjZzu1D4neEuDrMg3tnbukoM+/AXSNWLr/K1w=;
        b=pVptxzwSMjKbyebGjecwxf5tJKK0YxTlgD5JiFLCEkdIMrIqD9ZmxjnmTH9AER2Bel
         psMsbK47is/YBD2xA1sjZpHhfJV2Zuw9kKgxczGVfCnNkE5qWNG49SkhEEzRUKbwrzuZ
         /nkm68yoTRJF2Wk7zGzK49PwCY0PaS0vtResgaQZualISpqTvqz2Q7LqBy7OPs6Mr9ua
         7jvuOlmo149Uhb63YsfqRJwLE2o5HR4uQBE2q3xa0sQiOErP8MbrN9pEB+JhV+mrwjxC
         EQtiRXjJWs4VKSVIspz4DAGV/G6msrOxhE+YcdT3zJF+siA1DEoQNQVr+p2bj5A4n0Xz
         daRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OI3GF4xjZzu1D4neEuDrMg3tnbukoM+/AXSNWLr/K1w=;
        b=mmAYSzxCMddU17lzV3BNYk/Ah+BtsRlMDVAI3zeLoxmhMQ7XsMPr73PR1XiYZ07+1o
         yOfOVC219SokH0uQ95myVSSzhqbEQEFnsLivHbHRoA23VzdUxvEa1Y3d5v1VtAkgF/Fg
         f7i9Cb6fWlNsuXhNJilQrpeQBRoEWvlA46fln9Ptc1oCMYlKlFC+FczFXDMGxQ0sUH6S
         YAvdC6WABVPTkeBJmPRqxgjGjE7MkYMpQJoxDYiQm8VrE8+22oJBhAuZ3/p1zU5EJR8Q
         OWk0rSbMVWKni733knVtSXmEhWTlzjxQes3j0TP0fkI4Kb1wz+EG30JUmSSPijtl5PUe
         QM3w==
X-Gm-Message-State: AOAM5323vXeeioLIALhBvkZXOXy7J3p+8B1HnwVhmG8a41sHaKYwHT8z
        UpAPFqlZLheSVY36Y8rFN6yv7mbQPc/1zHia
X-Google-Smtp-Source: ABdhPJzr+2LDFjO6ChpD8ZWZgDqYxv7d+0s9XTLHBTMU4WX09MFl1eEtbpP3f59LeTWBsH1350Nnsw==
X-Received: by 2002:a17:907:1ca0:b0:6e9:9eef:a8d2 with SMTP id nb32-20020a1709071ca000b006e99eefa8d2mr5157847ejc.719.1650005930930;
        Thu, 14 Apr 2022 23:58:50 -0700 (PDT)
Received: from anparri (host-79-52-64-69.retail.telecomitalia.it. [79.52.64.69])
        by smtp.gmail.com with ESMTPSA id fx3-20020a170906b74300b006daecedee44sm1376689ejb.220.2022.04.14.23.58.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 23:58:50 -0700 (PDT)
Date:   Fri, 15 Apr 2022 08:58:47 +0200
From:   Andrea Parri <parri.andrea@gmail.com>
To:     "Michael Kelley (LINUX)" <mikelley@microsoft.com>
Cc:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 5/6] Drivers: hv: vmbus: Accept hv_sock offers in
 isolated guests
Message-ID: <20220415065847.GD2961@anparri>
References: <20220413204742.5539-1-parri.andrea@gmail.com>
 <20220413204742.5539-6-parri.andrea@gmail.com>
 <PH0PR21MB302520562EED77A587340D1DD7EE9@PH0PR21MB3025.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR21MB302520562EED77A587340D1DD7EE9@PH0PR21MB3025.namprd21.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > @@ -976,17 +976,22 @@ find_primary_channel_by_offer(const struct
> > vmbus_channel_offer_channel *offer)
> >  	return channel;
> >  }
> > 
> > -static bool vmbus_is_valid_device(const guid_t *guid)
> > +static bool vmbus_is_valid_offer(const struct vmbus_channel_offer_channel *offer)
> >  {
> > +	const guid_t *guid = &offer->offer.if_type;
> >  	u16 i;
> > 
> >  	if (!hv_is_isolation_supported())
> >  		return true;
> > 
> > +	if (is_hvsock_offer(offer))
> > +		return true;
> > +
> >  	for (i = 0; i < ARRAY_SIZE(vmbus_devs); i++) {
> >  		if (guid_equal(guid, &vmbus_devs[i].guid))
> >  			return vmbus_devs[i].allowed_in_isolated;
> >  	}
> > +
> 
> Spurious newline added?
> 
> >  	return false;

Intentionally added to visually separate the "hvsock", "vmbus_dev" and
"default" blocks, patch seemed simple enough to try to merge in "style
material" without incurring in the question.  ;-)

Newline removed.

Thanks,
  Andrea
