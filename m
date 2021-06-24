Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19A633B303E
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 15:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231580AbhFXNlm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 09:41:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51748 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229995AbhFXNll (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 09:41:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624541960;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9vLK98PdEnpyQ/nS6/7YJpw/gmVqIJdAagVZW4uCkYo=;
        b=hH40r3nxhE480aJAjea+7jZRIp4WZw91yRNuo5g/HhnzchiGnuoy8kYeOnB7JqUse8GFGg
        UI3UrNpb0fTVGBAriqCtf0fkCKyQDZep7CsC6OHUIEgMXlKqVBVwDWa0QJ/E3Y8N7CvOB3
        ZcTvqg3hjNAzOtHofR5kOaXY/sjIi2E=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-532-s8-a7UoTMOC2w2wXKj0p-g-1; Thu, 24 Jun 2021 09:39:19 -0400
X-MC-Unique: s8-a7UoTMOC2w2wXKj0p-g-1
Received: by mail-wm1-f70.google.com with SMTP id j2-20020a05600c1c02b02901cecbe55d49so573882wms.3
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 06:39:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9vLK98PdEnpyQ/nS6/7YJpw/gmVqIJdAagVZW4uCkYo=;
        b=iLwE+qSVFWY3HyyyW90FvrzD5eguBj2iZ57CzgiarnqXzuFR5X939PfpSSeCuj+48F
         DuvPXvf0Nms+IHPmE+RLeTLI0Hl84lN8i9iRq7HsTOAakg70V/xvI1+PSEpBhfX/q9CF
         FLZUQaZp9jUZ/Hr+Nazp+7nNK92Lwo9w9Nizy3eIaZ86bnV9cwJ5pK6uhTsZP3m7bbVi
         11TXo1CGwDNbZR50SgAaSOQ1Z2Ii7sGU1Lc0qcRQ2F2W2WykYy0T2GIalDMVsvj3Vi9s
         Je8G/0byv5jl8/s0TM5ztQrDJ8k72SKDyLCVUJanvFwgxOB+XAGd/PXdY3jnXCg6KeM3
         kBWQ==
X-Gm-Message-State: AOAM532tSh0RxdnbafGflAnkpSpnXTyc6+SrXYLQBa5Kjn4KBTv/689B
        cWxVEA3WgEn+Gqvic5XJjApSE0wuxHJslTTqS3xVjU9EQmhsOQaBSPLhORSneDDFXEHKzA44OqD
        4luQPkHkMsHZL/eU0
X-Received: by 2002:a5d:4a01:: with SMTP id m1mr4658206wrq.51.1624541958186;
        Thu, 24 Jun 2021 06:39:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzAJF2wUKvYOPeRb1CAsZgVlgHOPr4wgvdb504Sg1whYhBbruwbvWgntrHJxJYp0n/StAFHkA==
X-Received: by 2002:a5d:4a01:: with SMTP id m1mr4658188wrq.51.1624541958066;
        Thu, 24 Jun 2021 06:39:18 -0700 (PDT)
Received: from pc-32.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id u18sm2798608wmj.15.2021.06.24.06.39.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 06:39:17 -0700 (PDT)
Date:   Thu, 24 Jun 2021 15:39:15 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        netdev@vger.kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, vfedorenko@novek.ru
Subject: Re: [PATCH net] ip6_tunnel: fix GRE6 segmentation
Message-ID: <20210624133915.GA4606@pc-32.home>
References: <20210622015254.1967716-1-kuba@kernel.org>
 <33902f8c-e14a-7dc6-9bde-4f8f168505b5@gmail.com>
 <20210622152451.7847bc24@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <592a8a33-dfb8-c67f-c9e6-0e1bab37b00d@gmail.com>
 <20210623091458.40fb59c6@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <5011b8aa-8bbf-9172-0982-599afed69c5d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5011b8aa-8bbf-9172-0982-599afed69c5d@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 23, 2021 at 12:28:05PM -0600, David Ahern wrote:
> On 6/23/21 10:14 AM, Jakub Kicinski wrote:
> > Noob question, why do we need that 2 sec wait with IPv6 sometimes?
> > I've seen it randomly in my local testing as well I wasn't sure if 
> > it's a bug or expected.
> 
> It is to let IPv6 DAD to complete otherwise the address will not be
> selected as a source address. That typically results in test failures.
> There are sysctl settings that can prevent the race and hence the need
> for the sleep.

But Jakub's script uses "nodad" in the "ip address add ..." commands.
Isn't that supposed to disable DAD entirely for the new address?
Why would it need an additional "sleep 2"?

