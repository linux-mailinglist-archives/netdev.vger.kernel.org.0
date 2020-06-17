Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1DC81FC30E
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 02:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbgFQA4r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 20:56:47 -0400
Received: from ozlabs.org ([203.11.71.1]:39891 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725894AbgFQA4p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Jun 2020 20:56:45 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 49mmqG0flvz9sSd;
        Wed, 17 Jun 2020 10:56:41 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1592355403; bh=It8Ol8FTn6mCiBtd5Eu5trnzOP4nwp0yMirCQfFQjI4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=GLNMlwIRHK4pxs2eWPaSduZkglcrtJZrIbuImMTxCv3SLsjO1cU7L2ERZxq+6izVV
         SzgC/CzFWqsqHIgq/GASK4IVeMk8gJHHtNWeaa/ACdjaXnr0Q7BZ8CuU14ZAe102oX
         OzUKJM9UNTs8g6qz11tak+IETDhm6cjOj0JjUvhrdjq6+NoVALRd2GMAWx2f1IM+wt
         uOe161SUNJCHkNrFDagK9Vvgc7Xep2FUVoJNLUqK+qyRgFaSAF+9tP+dMqb8Do32Ra
         lKUPBeJQsGFG+fUCYPeQkVsVLrtCGzdLIeQPtN8vZ9Ci0RJXMxhMujm9JZLw/HY3Tc
         JCwIPkdNfiaxg==
Message-ID: <ac9ac673933f0e8383c6ab538302058ba2469192.camel@ozlabs.org>
Subject: Re: [PATCH] net: usb: ax88179_178a: fix packet alignment padding
From:   Jeremy Kerr <jk@ozlabs.org>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, allan@asix.com.tw, freddy@asix.com.tw,
        pfink@christ-es.de, linux-usb@vger.kernel.org, louis@asix.com.tw
Date:   Wed, 17 Jun 2020 08:56:39 +0800
In-Reply-To: <20200616.135535.379478681934951754.davem@davemloft.net>
References: <20200615025456.30219-1-jk@ozlabs.org>
         <20200615.125220.492630206908309571.davem@davemloft.net>
         <e780f13fdde89d03ef863618d8de3dd67ba53c72.camel@ozlabs.org>
         <20200616.135535.379478681934951754.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

> It seems logical to me that what the chip does is align up the total
> sub-packet length to a multiple of 4 or larger, and then add those two
> prefix padding bytes.  Otherwise the prefix padding won't necessarily
> and reliably align the IP header after the link level header.

Yep, that makes sense, and is what the driver is currently doing;
between clustered packets, the header is aligned (up) to 8 bytes, then
the 2-byte padding is added to that.

For this change, I have assumed that the packet length behaviour (ie,
describing the un-padded length) is consistent between clustered
packets.

[If you have any hints for forcing clustered packets, I'll see if I can
probe the behaviour a little better to confirm]

Cheers,


Jeremy

