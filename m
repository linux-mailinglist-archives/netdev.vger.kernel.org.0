Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 418E02C379F
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 04:41:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727319AbgKYD0E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 22:26:04 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:51764 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726849AbgKYD0E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 22:26:04 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1khlRF-0005RW-FL; Wed, 25 Nov 2020 14:25:50 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Wed, 25 Nov 2020 14:25:49 +1100
Date:   Wed, 25 Nov 2020 14:25:49 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Tariq Toukan <ttoukan.linux@gmail.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Moshe Shemesh <moshe@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH net] netdevice.h: Fix unintentional disable of
 ALL_FOR_ALL features on upper device
Message-ID: <20201125032549.GA13059@gondor.apana.org.au>
References: <20201123141256.14208-1-tariqt@nvidia.com>
 <CANn89iKRVyTZg-tNQvo_Ub-RZ_A+OOQQY8Py3J9fx=NOZXF9Qw@mail.gmail.com>
 <9bf8ba40-cd40-2af6-d358-48dd98526434@gmail.com>
 <CANn89iK8MXp0QmZbBKdMDHxi7A4afrVdBtgQq7cSY5SRefwraA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iK8MXp0QmZbBKdMDHxi7A4afrVdBtgQq7cSY5SRefwraA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 24, 2020 at 11:48:35AM +0100, Eric Dumazet wrote:
>
> Well, the 'increment' part was suggesting the function was adding
> flags, not removing them.

The idea of the increment part is that we're adding a constituent
device, not that we're adding features.  There have always been
features which were conjunctions, i.e., they must be supported by
all underlying devices for them to be enabled on the virtual device.

Your use of the increment function is unusual, as you're not adding
features that belong to one underlying device, but rather you're
trying to enable a feature on the virtual device unconditionally.

> We might ask Herbert Xu if we :
> 
> 1) Need to comment the function, or change its name to be more descriptive.
> 2) Change the behavior (as you suggested)
> 3) Other choice.

I think Tariq's patch is fine, although a comment should be added
to netdev_add_tso_features as this use of the increment function
is nonstandard.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
