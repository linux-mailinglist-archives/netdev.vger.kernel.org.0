Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E10AF1CB8B4
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 21:58:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbgEHT6m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 15:58:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726825AbgEHT6l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 15:58:41 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72AA9C05BD43
        for <netdev@vger.kernel.org>; Fri,  8 May 2020 12:58:40 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id fb4so1208343qvb.7
        for <netdev@vger.kernel.org>; Fri, 08 May 2020 12:58:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=8fjdVK7f+8aigodcAGlUvVOf1RKpAaK1SR2MV0cPRHk=;
        b=SerDa9iQZ83WrkL915BvYV2YXa3azn5jCBvL+GuHfLmB+uvp5jiI9xM8ZkIqtZrAi7
         pBDK7Jzswe0it1opDQQqu6SctIHaZ+C3in+UTP1mXx0Z+JtIf8VHPCVDwGjfGJBhGExO
         HsIOwuCDDlQpa3DU5KTONkS8VgROsGsqlP2XBCwro+hwxoXejKF4dvXWtk3kxocjwgAg
         Slhr/j8T41VSBdZmOOc4ntLhjVUyQWLEzfPUfsxa+Uf9uHgBfjPKSqdSfcZ/uqDZmWum
         FgGR2k+k7PAfnz5OKKTJphYVs6pI4QiCDmJBZpKFVhlNByGshjBVdmlgrQVHSgy2jGVH
         DOVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=8fjdVK7f+8aigodcAGlUvVOf1RKpAaK1SR2MV0cPRHk=;
        b=oPCUcGLOpt7sxed1EowQF2t6n3Q+53/IA2A2g8/zp1QQNgdRYHbyybkM1CH3mRNWKv
         E3o7TJeWjt6NM+oz/IhTytTXB2QrDKi4IhG8LHo9k97X+Se+KvT+PC9AT0kLt7qr6HT0
         Yl6bmkdOYOCvt8+KH4ftE7nQcIEl/xUlCNhpCW1VZnFpoaXYTv9quG5jEcNhaz6ifitY
         RlqOcQkur1+DVrPAFfwD6gldAW7NtXdHaOpb44qjfZUrZpq+2ofsJUrVJoitsltbhbZ5
         3U16Y1IJzXkDtn2+hZLMIvb+OwKNGe5Sm9RcyWbl4hRYZtuJUMzoWeaS396crM4fqqyb
         nmqQ==
X-Gm-Message-State: AGi0PuYzMyGDXf6ZVZtqNuEp7uQo357aQcHUOUtfwVR8g5BoZs4iIzBF
        70FI2tZOzTNZuqBDV7nZ3u7I4g==
X-Google-Smtp-Source: APiQypIV9W4VqbD706RMPBHoU3J0Rlm8JP6X6d8XroY+EFRoHlJmbkNUXElgZMdBHJXnifk4YaIgVA==
X-Received: by 2002:ad4:53a2:: with SMTP id j2mr4489976qvv.159.1588967919686;
        Fri, 08 May 2020 12:58:39 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id 66sm1844186qtg.84.2020.05.08.12.58.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 May 2020 12:58:39 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jX98o-0002a3-Lx; Fri, 08 May 2020 16:58:38 -0300
Date:   Fri, 8 May 2020 16:58:38 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Maor Gottlieb <maorg@mellanox.com>, linux-rdma@vger.kernel.org,
        Mark Bloch <markb@mellanox.com>,
        Mark Zhang <markz@mellanox.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: Re: [PATCH mlx5-next v1 1/4] {IB/net}/mlx5: Simplify don't trap code
Message-ID: <20200508195838.GA9696@ziepe.ca>
References: <20200504053012.270689-1-leon@kernel.org>
 <20200504053012.270689-2-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200504053012.270689-2-leon@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 04, 2020 at 08:30:09AM +0300, Leon Romanovsky wrote:
> +	flow_act->action &=
> +		~MLX5_FLOW_CONTEXT_ACTION_FWD_NEXT_PRIO;
> +	flow_act->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
> +	handle = _mlx5_add_flow_rules(ft, spec, flow_act, dest, num_dest);
> +	if (IS_ERR_OR_NULL(handle))
> +		goto unlock;

I never like seeing IS_ERR_OR_NULL()..

In this case I see callers of mlx5_add_flow_rules() that crash if it
returns NULL, so this can't be right.

Also, I don't see an obvious place where _mlx5_add_flow_rules()
returns NULL, does it?

Jason
