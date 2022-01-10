Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44BE1489AF3
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 14:59:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234947AbiAJN7o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 08:59:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24571 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234923AbiAJN7n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 08:59:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641823183;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bKOg/EwHT2Xmlm8vOzkf7mihhsAOk5/RF4P4XaRODtI=;
        b=DNvjl/5cFpw18tL6XXGnaltUfakcW49NicyOrqzEuuGFED46ZmRIWUG9eAdUXnOANZADGn
        IpMvOF/uXKg6d157TFX3xXwmcT2OYc/7879mtkMiqmAIJPl9vtxxr741dbGjW8eWcQgc/1
        J5SOD25n6q07w1EWJAuXR9evFz2B2a0=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-92-NEFt3Uh4OnegHQ4A6gJoRA-1; Mon, 10 Jan 2022 08:59:42 -0500
X-MC-Unique: NEFt3Uh4OnegHQ4A6gJoRA-1
Received: by mail-wr1-f72.google.com with SMTP id o28-20020adfa11c000000b001a60fd79c21so2488386wro.19
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 05:59:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bKOg/EwHT2Xmlm8vOzkf7mihhsAOk5/RF4P4XaRODtI=;
        b=la7zML/U4WTHn5WrFuG9zXyTVpJZmRHTsuMCTG05LwHMSNRCOaB+RnB1PjuJrmfRLt
         U+ZagVwI4qKUvgWVvGSIH7H1cjUeAVxzPPd+Y4jyPfyJRMz/AxfguqQ8XaANzrUXLhoI
         AkEBqJhMPxhS/dqAO+kNjLK9Lumtll8QyPY9dit1/xAZDY/FJTEdXe49/x87lg7qZy1n
         mWN5gF9Kyl6iabC11MeZUZWOEjqZ7EWsmLm3rAlqPn9swbSTU4F2UgQlLOHTB+fn0x2m
         K40JyygixufkDLhMZrDa7Bv4r+IImPQhsUFdhnhYY1hN0n9G5KgeLt3RhfOEI/lHIsUx
         BofA==
X-Gm-Message-State: AOAM531tFtJ0WxL1B2LrQl/gDxRvwcIjcq1BY8ZjzTt2z324HMsiYfCp
        12Th+nLYIhxgZoo+yDE6LipOO+yw0JBim2YmD5J/1GcaaiDiNNqSF0RynzXF0nkCxzbgKFiGvdX
        P3m2Ga0DoAoObuBR3
X-Received: by 2002:a7b:c194:: with SMTP id y20mr22153070wmi.79.1641823180924;
        Mon, 10 Jan 2022 05:59:40 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyaomE/0xGJ2tL4n4Br2dlM1gDxW5rWIe9erV66WUk+0o9RbcBfLTBSngPd5co6esXOyrCXqw==
X-Received: by 2002:a7b:c194:: with SMTP id y20mr22153058wmi.79.1641823180769;
        Mon, 10 Jan 2022 05:59:40 -0800 (PST)
Received: from pc-4.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id g15sm5896778wrm.2.2022.01.10.05.59.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 05:59:40 -0800 (PST)
Date:   Mon, 10 Jan 2022 14:59:38 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, wenxu <wenxu@ucloud.cn>,
        Varun Prakash <varun@chelsio.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Vlad Buslov <vladbu@nvidia.com>,
        Or Gerlitz <ogerlitz@mellanox.com>
Subject: Re: [PATCH net 0/4] ipv4: Fix accidental RTO_ONLINK flags passed to
 ip_route_output_key_hash()
Message-ID: <20220110135938.GA3425@pc-4.home>
References: <cover.1641407336.git.gnault@redhat.com>
 <20220109162322.4fc665bc@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220109162322.4fc665bc@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 09, 2022 at 04:23:22PM -0800, Jakub Kicinski wrote:
> On Wed, 5 Jan 2022 20:56:16 +0100 Guillaume Nault wrote:
> > The IPv4 stack generally uses the last bit of ->flowi4_tos as a flag
> > indicating link scope for route lookups (RTO_ONLINK). Therefore, we
> > have to be careful when copying a TOS value to ->flowi4_tos. In
> > particular, the ->tos field of IPv4 packets may have this bit set
> > because of ECN. Also tunnel keys generally accept any user value for
> > the tos.
> > 
> > This series fixes several places where ->flowi4_tos was set from
> > non-sanitised values and the flowi4 structure was later used by
> > ip_route_output_key_hash().
> > 
> > Note that the IPv4 stack usually clears the RTO_ONLINK bit using
> > RT_TOS(). However this macro is based on an obsolete interpretation of
> > the old IPv4 TOS field (RFC 1349) and clears the three high order bits.
> > Since we don't need to clear these bits and since it doesn't make sense
> > to clear only one of the ECN bits, this patch series uses INET_ECN_MASK
> > instead.
> > 
> > All patches were compile tested only.
> 
> Does not apply cleanly to net any more, could you respin?

Yes, done:
  https://lore.kernel.org/netdev/cover.1641821242.git.gnault@redhat.com/

