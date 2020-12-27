Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 982F12E31D0
	for <lists+netdev@lfdr.de>; Sun, 27 Dec 2020 17:23:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726187AbgL0QVY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Dec 2020 11:21:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46448 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726137AbgL0QVY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Dec 2020 11:21:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609085997;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=s1FLqDr2T5OPR0RNpbiiUSQuAeZdrU3I8IzlpgglHJ8=;
        b=Ecc/2wQA1FBo6UmUNablDiUJPkUM5C6tZ14tfVz6xUK5nkBnMgFfObJ+1fUHn8FUlDcsyl
        EavX1+RquwLCJNTxKutqaNK5yWi0JHVi2nLAVuG7MZORk+mXlPqSBL+Lm6dt+1BnQu1cvN
        2FM5bErzvCKVOIxp3obe+tMkY6RE+7U=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-431-X_HTqKFzPjK0Ru_VL68IXA-1; Sun, 27 Dec 2020 11:19:55 -0500
X-MC-Unique: X_HTqKFzPjK0Ru_VL68IXA-1
Received: by mail-wr1-f72.google.com with SMTP id n11so5194290wro.7
        for <netdev@vger.kernel.org>; Sun, 27 Dec 2020 08:19:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=s1FLqDr2T5OPR0RNpbiiUSQuAeZdrU3I8IzlpgglHJ8=;
        b=UFgXJL595JQIq+gDp10/zs04bZFPLSMTYcYyvRR5HPdWlVZv6V8yKE3OWYx8utKWVY
         tfM+/DQhK6Gxc4A2zsjzvnEF9/ea1ZFOzvwM/Flnde7lRaWLF6vPq9o1lRaTwTiQGIk2
         rSSU5ZPIi+9rbqSLrF2C8AfA9c2ePApPIeAO6hBzK39J7JWE8xT/TJInAn5D0GL1DquP
         w2rRxpUuBp37HyE4392TLMxctYk1zNvpSkS0fjFOgfCvrZ7EF+0hYDVqGUkXQqCSTlAJ
         C1uaDiOptgi5k9OHsn1NFMbDbYOzxgJ58BlOtI1J4gEH3RvA6AsTdYGhLfa/BspbztVI
         nhRw==
X-Gm-Message-State: AOAM533/lTC0qqA4o3e4eZN23WphDSnreXUBKtNxWZ5fO1eQS8KPw17Y
        dzHHril28ijIBLSrNpYhC3fgYC2lNjWCq0TdBPKBxnLVphPzwV6c670xx/viLdNJZ+Ff2v0XavV
        B8h0LCzJSUBNgTl2M
X-Received: by 2002:a1c:bd87:: with SMTP id n129mr16960199wmf.32.1609085994724;
        Sun, 27 Dec 2020 08:19:54 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwmJMdfu5omU3Fq/k+YHsA1p3S8BND3Qpt/IG1kGWMN0qiMyXrfIlAvRxmlJ23RHvGyGrnoDA==
X-Received: by 2002:a1c:bd87:: with SMTP id n129mr16960190wmf.32.1609085994516;
        Sun, 27 Dec 2020 08:19:54 -0800 (PST)
Received: from linux.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id b10sm16523034wmj.5.2020.12.27.08.19.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Dec 2020 08:19:53 -0800 (PST)
Date:   Sun, 27 Dec 2020 17:19:52 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        martin.varghese@nokia.com
Subject: Re: [PATCH net 1/2] bareudp: set NETIF_F_LLTX flag
Message-ID: <20201227161952.GA27369@linux.home>
References: <20201226171230.4165-1-ap420073@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201226171230.4165-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 26, 2020 at 05:12:30PM +0000, Taehee Yoo wrote:
> Like other tunneling interfaces, the bareudp doesn't need TXLOCK.
> So, It is good to set the NETIF_F_LLTX flag to improve performance and
> to avoid lockdep's false-positive warning.

Acked-by: Guillaume Nault <gnault@redhat.com>

