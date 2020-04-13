Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ACDD1A6828
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 16:29:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730636AbgDMO3V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 10:29:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728609AbgDMO3T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Apr 2020 10:29:19 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 953CEC0A3BDC
        for <netdev@vger.kernel.org>; Mon, 13 Apr 2020 07:29:18 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id j4so9509133qkc.11
        for <netdev@vger.kernel.org>; Mon, 13 Apr 2020 07:29:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=w23AM0CsshBFYgzdTQY6CMYKoBwlBAbPcwQaj2+ZhKM=;
        b=ACvLD0S39P4RZNUv8h4ZhYRaashW9pb9+1DxpTKC57P3GSa2gH4+pCAcHNB8bW+asO
         odFm7tTttTj5wtmLCPUFoVHhK+IHUUyNN1zwGMtWI/AIqY/32r4T0c0pfSa8rEN45eRs
         EZsPqpyF8xC6Bx2w6SqcIrFXpOEhxOpmP7zOgu3mJ5YbQRgztR+AzYcgEzVvHvVheMId
         8J7vDsL0B+2MFEJ671Kbagnt2h9nRWE5i2eHFpwko0lm6UqXpA/yQH0CpeNAC/eNJIZb
         6P0mma2DmqgMaQHnX2JRVAemSvzpeZRJVhGInt6bBrOFMfLhDPU/BUlW6pewHeFey6AH
         cwNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=w23AM0CsshBFYgzdTQY6CMYKoBwlBAbPcwQaj2+ZhKM=;
        b=DgfpsVUBChF2u5nQPGAB4FmtDNUXoXPU4GGpW3GcxtO1DlrJH7CJyNaHjDlpFLdFKQ
         pJedxqkdyrdqh5tMDfxaFkPpVhCqOIhBEl6p769et24sMg0loQRQ8MlSS3vIUSCrg8eF
         kZi4cUfDCwblO+b5yFw1cmCihPNGX4supniPvlGnAIOV0+KQnwN/WFbLVSV4UxPJbLir
         wr8SBCC0WvqCcHtVeIyIFt0gW7Nb6PnoaX148g3nNmWqbG6F2AF+JaHrQCiEBSJMUUtH
         uAjDsPMqXajtvmL9oGGBPQ3OxF8/phnMMT/LSGYKKVjhuxchbltvPG9zaIdE8AGr+CoH
         yfdA==
X-Gm-Message-State: AGi0PubFEuG4Yrru6uEQhuzI0OFiMw3sJlYs5zfcQ1+VASPtpDeLWheE
        pyQCYNgoPlC2k+BAWlwBFzU=
X-Google-Smtp-Source: APiQypIHj6EF0Ztdnns4Y2ICbYri+tmKYYovYn2baRSdCaoEJ6EjjMjlShfNCTAsWO32Sjgjeh2LHw==
X-Received: by 2002:a37:a603:: with SMTP id p3mr16113040qke.109.1586788157554;
        Mon, 13 Apr 2020 07:29:17 -0700 (PDT)
Received: from localhost.localdomain ([177.220.172.108])
        by smtp.gmail.com with ESMTPSA id b13sm7921695qtp.46.2020.04.13.07.29.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2020 07:29:16 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 77D4EC5519; Mon, 13 Apr 2020 11:29:13 -0300 (-03)
Date:   Mon, 13 Apr 2020 11:29:13 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Or Gerlitz <gerlitz.or@gmail.com>
Cc:     Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Paul Blakey <paulb@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Leon Romanovsky <leonro@mellanox.com>
Subject: Re: [PATCH net] net/mlx5e: limit log messages due to (ovs) probing
 to _once
Message-ID: <20200413142913.GE137894@localhost.localdomain>
References: <d57b95462cccf0f67089c91d3dfd3d1f4c46e9bf.1585872570.git.marcelo.leitner@gmail.com>
 <c4e43a61a8ad7f57e2cb228cc0ba810b68af89cb.camel@mellanox.com>
 <20200403024835.GA3547@localhost.localdomain>
 <d4c0225fc25a6979c6f6863eaf84ee4d4d0a7972.camel@mellanox.com>
 <20200408215422.GA137894@localhost.localdomain>
 <54e70f800bc8f3b4d2dc7ddea02c1baa0036ea54.camel@mellanox.com>
 <20200408224256.GB137894@localhost.localdomain>
 <6f4e8a85-ede4-0c10-0ef7-0d45f2b7fc73@mellanox.com>
 <CAJ3xEMibkDZmLYokvHinjiuv3V_ZA7x3s4SBpXbp2_BDpTUjgA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ3xEMibkDZmLYokvHinjiuv3V_ZA7x3s4SBpXbp2_BDpTUjgA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 13, 2020 at 09:35:54AM +0300, Or Gerlitz wrote:
> On Sun, Apr 12, 2020 at 11:15 AM Roi Dayan <roid@mellanox.com> wrote:
> 
> [..]
> 
> > in some places we already only use extack without netdev_warn.
> > so currently in favor in removing the other logs if extack error exists to
> > avoid flooding the log
> 
> +1 for using the modern messaging way (extack)
> +1 for driver diet by avoiding double messaging systems

Nice, okay. Do you prefer to do it yourselves? Otherwise I'll just
remove the _warn messages I changed in the initial patch.
