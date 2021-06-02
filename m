Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CC11398326
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 09:38:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231794AbhFBHkH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 03:40:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231775AbhFBHkE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 03:40:04 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4662DC061574;
        Wed,  2 Jun 2021 00:38:22 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1loLSC-000x3I-97; Wed, 02 Jun 2021 09:38:16 +0200
Message-ID: <15e467334b2162728de22d393860d7c01e26ea97.camel@sipsolutions.net>
Subject: Re: [RFC 3/4] wwan: add interface creation support
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Loic Poulain <loic.poulain@linaro.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        m.chetan.kumar@intel.com
Date:   Wed, 02 Jun 2021 09:38:15 +0200
In-Reply-To: <CAHNKnsRv3r=Y7fTR-kUNVXyqeKiugXwAmzryBPvwYpxgjgBeBA@mail.gmail.com> (sfid-20210602_034254_098035_0151122C)
References: <20210601080538.71036-1-johannes@sipsolutions.net>
         <20210601100320.7d39e9c33a18.I0474861dad426152ac7e7afddfd7fe3ce70870e4@changeid>
         <CAHNKnsRv3r=Y7fTR-kUNVXyqeKiugXwAmzryBPvwYpxgjgBeBA@mail.gmail.com>
         (sfid-20210602_034254_098035_0151122C)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sergey,

> Wow, this is a perfect solution! I just could not help but praise this
> proposal :)

Heh.

> When researching the latest WWAN device drivers and related
> discussions, I began to assume that implementing the netdev management
> API without the dummy (no-op) netdev is only possible using genetlink.
> But this usage of a regular device specified by its name as a parent
> for netdev creation is so natural and clear that I believe in RTNL
> again.
> 
> Let me place my 2 cents. Maybe the parent device attribute should be
> made generic? E.g. call it IFLA_PARENT_DEV_NAME, with usage semantics
> similar to the IFLA_LINK attribute for VLAN interfaces. The case when
> a user needs to create a netdev on behalf of a regular device is not
> WWAN specific, IMHO. So, other drivers could benefit from such
> attribute too. To be honest, I can not recall any driver that could
> immediately start using such attribute, but the situation with the
> need for such attribute seems to be quite common.

That's a good question/thought.

I mean, in principle this is trivial, right? Just add a
IFLA_PARENT_DEV_NAME like you say, and use it instead of
IFLA_WWAN_DEV_NAME.

It'd come out of tb[] instead of data[] and in this case would remove
the need to add the additional data[] argument to rtnl_create_link() in
my patch, since it's in tb[] then.

The only thing I'd be worried about is that different implementations
use it for different meanings, but I guess that's not that big a deal?

johannes

