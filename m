Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2C842F8211
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 18:21:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728818AbhAORUh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 12:20:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727049AbhAORUh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 12:20:37 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB122C0613C1
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 09:19:56 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id x12so5020229plr.10
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 09:19:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=rf8f6+SUSRyYB+InXD+531v6cGmPgbtlp/pQSTSF7Zk=;
        b=fWhnPuzjvluY4/9Ppb2RZEHF25MFKZD9t54RhqXVwYgsOMfxdvj/c1CExkhTB9vs9t
         FZ4pYxXoMC8ywHYafFhnzqvtadGd2gWvZhLMqD8065NPGvnJKxja/IvGiO3KOiCYjl0B
         EaLyVNmuQUwqlWK0Z0RF/7JoT+dGgaMyYtjokZCEsZaBLby2qUpJNi/ddw7DVJ7+M79/
         vNQZ01sydjenjKRUKeGcZHzvdNP1h2lQaAS9L8HYRLzTWaGY/ZQmBRiV0q3/Vy8Bl185
         HKLVh5TJ5Km+RQw+oYP9qj5tIa9ddJvP27wp5h0EdeXWZv6tMP2Z7W8/ucrbhgySxuap
         0UmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=rf8f6+SUSRyYB+InXD+531v6cGmPgbtlp/pQSTSF7Zk=;
        b=hxx7FUjJg0It7i5dRHcy/pfzUrCFthFZ30X0PYI14aVcVAKKtQOOR826TiA2U81SUs
         PPnSDE+COwQMi0J47o4PA+A+Wtx8mBplg8K1uDs2+O1avO2YZLCwt5yMr1XAvkNClU4f
         hOAgRh4vf4VF8sBEvI88AxFAw/4eZPKHTeTGZ//fwQl42ZuPhqywifcCKqllNz3jBSLg
         GYz4uFhaL30cXIao0/50SqUqXv3hRaH0HYsYt8gHzTXL1CEub0vyVKfrg1GJVtcy5FbP
         y9II0d5E82AdhdAF7XlU2TDgRuodW3XbmdwOBy+R+wrQNywwflaEmu7r+yIuYNrUJ5MH
         gn8w==
X-Gm-Message-State: AOAM531DC5ytk48XNwn7BHkIdhsMPbJyfGieMyU3Shh1wp+F/ugFjOvW
        jGnQY95Fnti7O/dSbdqBJtQ=
X-Google-Smtp-Source: ABdhPJxXmsMqjtfFkyKGQwv3HZeosxRbkyCpyTaA80rLyFFyZddLzrNmKJHAR+vWKA+Ktj5ONUFMmw==
X-Received: by 2002:a17:90a:4306:: with SMTP id q6mr11723466pjg.231.1610731196584;
        Fri, 15 Jan 2021 09:19:56 -0800 (PST)
Received: from hoboy.vegasvil.org (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id z6sm8767622pfj.22.2021.01.15.09.19.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 09:19:55 -0800 (PST)
Date:   Fri, 15 Jan 2021 09:19:52 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Eran Ben Elisha <eranbe@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Guillaume Nault <gnault@redhat.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexei Starovoitov <ast@kernel.org>,
        Ariel Levkovich <lariel@mellanox.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: Re: [PATCH net-next v4 2/2] net: flow_dissector: Parse PTP L2 packet
 header
Message-ID: <20210115171952.GA3470@hoboy.vegasvil.org>
References: <1610478433-7606-1-git-send-email-eranbe@nvidia.com>
 <1610478433-7606-3-git-send-email-eranbe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1610478433-7606-3-git-send-email-eranbe@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 12, 2021 at 09:07:13PM +0200, Eran Ben Elisha wrote:
> Add support for parsing PTP L2 packet header. Such packet consists
> of an L2 header (with ethertype of ETH_P_1588), PTP header, body
> and an optional suffix.
> 
> Signed-off-by: Eran Ben Elisha <eranbe@nvidia.com>
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

Acked-by: Richard Cochran <richardcochran@gmail.com>
