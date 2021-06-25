Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 172523B3A67
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 03:12:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232982AbhFYBOS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 21:14:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232918AbhFYBOR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 21:14:17 -0400
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68B49C061574;
        Thu, 24 Jun 2021 18:11:57 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id r20so6372779qtp.3;
        Thu, 24 Jun 2021 18:11:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=taoaWGZjWvH+Pt3GQGXozAMNRuJiUfuQHBpd6dPiqi4=;
        b=QEOv50U8WnElzn8RmSIYvklPijeIiT6EVpgR84n61YwKP+OnRDSwAP12pW9k2VtxvU
         S0nsou1Cfp5i12mEQ5bzRMLvH4IjYEXWU3CBsylNXNBzeQQGQzk8DtQtKXjUun98bVbR
         o8kg3zk+OiePK0dps7YdVwQ7smbGw7NQ9fsuchnTAsy8cxfpSKI21NKLW+VSBx4i1lR3
         uEc9sfeds5K2U0tJHtYuLXojMIyJBiha938FdgVdFCnT8RvkgeElPYdnZOrU6vzwFKYe
         HdXGHQG3Lx+yOgOleGAYBez6PQXAhu4hcFeT1DeD84oQ0UYfsDnCsTr2vs7wcoW0GZwV
         1RAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=taoaWGZjWvH+Pt3GQGXozAMNRuJiUfuQHBpd6dPiqi4=;
        b=DZQmUIPGnyryt72+ptVz9WPlLWf3NnMMYQ0cnSuVTBZ9m9uycHbCB9CATpHptKXKjy
         zoxzYjUt6ag7w/pxrximVoqS+bqcn4jLGs89v+RPCUgVF/GKvB7G+9zWmCgWIJA9r1bP
         gTSGyQGIawTScGw1FvYx8cLC7tzpjHTBO0+Hr7FDDu1UEdX5KsZmGrrvAHZJFnfgDCyC
         pA48nU4cEk1fyK+Yat2oYsdP1Lsm74cLJxxhzXa1VhBflG6y1zS26qBGJkItzHjPy/Wu
         HxwH3rNj1CqHVkRIVkXcwfzqC2xO4N763EoV0zlmbGZ1tNBGwqIOXQFrAWr5hMwUyNKV
         i8sQ==
X-Gm-Message-State: AOAM531ezKj0x3WM5tdHiiHuN3FdT/rqEZymDN7rBwW6SR7b9A6yQLCd
        xY20bnq+rg4eOtVqy+TYdlk=
X-Google-Smtp-Source: ABdhPJyQvLmcFoNfqdKD+T4RzbEhj1E+hfegr7I1Oq6ZfilqAKP8m5wpa8kYQtApOwJaII8QBaqcLQ==
X-Received: by 2002:ac8:6f03:: with SMTP id g3mr7440868qtv.68.1624583516485;
        Thu, 24 Jun 2021 18:11:56 -0700 (PDT)
Received: from horizon.localdomain ([177.220.172.71])
        by smtp.gmail.com with ESMTPSA id k7sm1569805qtu.83.2021.06.24.18.11.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 18:11:56 -0700 (PDT)
Received: by horizon.localdomain (Postfix, from userid 1000)
        id 6A1DAC0DDA; Thu, 24 Jun 2021 22:11:53 -0300 (-03)
Date:   Thu, 24 Jun 2021 22:11:53 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org, linux-sctp@vger.kernel.org,
        David Laight <david.laight@aculab.com>
Subject: Re: [PATCH net-next 1/2] sctp: do black hole detection in search
 complete state
Message-ID: <YNUtWejWC4ftv0DA@horizon.localdomain>
References: <cover.1624549642.git.lucien.xin@gmail.com>
 <08344e5d9b0eb31c1b777f44cd1b95ecdde5a3d6.1624549642.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <08344e5d9b0eb31c1b777f44cd1b95ecdde5a3d6.1624549642.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 24, 2021 at 11:48:08AM -0400, Xin Long wrote:
> @@ -333,13 +328,15 @@ void sctp_transport_pl_recv(struct sctp_transport *t)
>  		t->pl.probe_size += SCTP_PL_MIN_STEP;
>  		if (t->pl.probe_size >= t->pl.probe_high) {
>  			t->pl.probe_high = 0;
> +			t->pl.raise_count = 0;
>  			t->pl.state = SCTP_PL_COMPLETE; /* Search -> Search Complete */
>  
>  			t->pl.probe_size = t->pl.pmtu;
>  			t->pathmtu = t->pl.pmtu + sctp_transport_pl_hlen(t);
>  			sctp_assoc_sync_pmtu(t->asoc);
>  		}
> -	} else if (t->pl.state == SCTP_PL_COMPLETE) {
> +	} else if (t->pl.state == SCTP_PL_COMPLETE && ++t->pl.raise_count == 30) {

Please either break the condition into 2 lines or even in 2 if()s. The
++ operator here can easily go unnoticed otherwise.

> +		/* Raise probe_size again after 30 * interval in Search Complete */
>  		t->pl.state = SCTP_PL_SEARCH; /* Search Complete -> Search */
>  		t->pl.probe_size += SCTP_PL_MIN_STEP;
>  	}
> -- 
> 2.27.0
> 
