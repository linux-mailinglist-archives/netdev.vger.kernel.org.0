Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8AF05E6E2
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 16:37:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727152AbfGCOh3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 10:37:29 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45678 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726656AbfGCOh1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 10:37:27 -0400
Received: by mail-wr1-f66.google.com with SMTP id f9so3084196wre.12
        for <netdev@vger.kernel.org>; Wed, 03 Jul 2019 07:37:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+w5Ekzo0SUahclNPS3vsY3fS0WmvuqOMIX4TEp2/zXU=;
        b=07A6jNkE1oZ17E6pSSQcXrtw++E4AfOcl4aVpafT+DrXKVAMRhAsyZP5pr7j5EJK/P
         Qdbx+5zRTouOI/jAymN9T607NfuaU5yV24hb29bPSAUb16qiyuY07oK+fKNMiP8rlf/Z
         IMUAESTHosw5O6M8IHc36GM22RGTj401EyYn26G04VX3sr/bIt952ZCW0LTStV5DYj/2
         WxE/NqDgYe17v6AdSmEl2ZSMgBsmYNOYoCRcQhNNSz/uH6ySyE+vXiLtYQA/H3HlKLlM
         ZGmaPXnp0hd7gXHXldUm+kTQxbJ97UQbdGd25jbTH+iqkG+sK3iYodSer/U6+7q6q2Ol
         2fxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=+w5Ekzo0SUahclNPS3vsY3fS0WmvuqOMIX4TEp2/zXU=;
        b=fY91sJtjM+7GNZkEStbeTN2ABxT1m+Sczzl6EE8p/wwwkxLVJ0/7i+xcDHZLSfQPiA
         dan7JwALfgd40867+o8/hytgQx8sH1OR2MiELov3zNEkw3ToHYSaM8GJwigy4c2Mtu6s
         6KCu+8mwAcXLche5Lz7XiEziQhxtjRLNGxL5oSCViopCmcsL2t2q/mHk6wl9sS7IdFQH
         yKh/qM0TO5yW91yeGkG2Z8umpnDFXXzpAAAJGF8ueuTOW4NFgYQvwIn3q1u556AtxPsn
         h63DTH5LvhJY4ReTw8pFD9dmHyJ7AhsbEnRt92zIM3EKXOJAInJs8VoMfDuvsMOtd065
         kHdA==
X-Gm-Message-State: APjAAAWiJMdQ8UfJ71G+n+4LOzdNYwppCrr8qDNB6BULFCX5bK6BJiEO
        ol7oKUc1bJR7ERSSu2irzvvGaQ==
X-Google-Smtp-Source: APXvYqy5XFF9pJ0FRYUwSNusa6CVo7/tVR45PaASQaVwJKYJNKmjqG7ZZ6lGYGu9KpEKxcPBDkWaow==
X-Received: by 2002:a5d:60c5:: with SMTP id x5mr16038910wrt.253.1562164646037;
        Wed, 03 Jul 2019 07:37:26 -0700 (PDT)
Received: from localhost (ip-213-220-235-213.net.upcbroadband.cz. [213.220.235.213])
        by smtp.gmail.com with ESMTPSA id c15sm1256625wrx.65.2019.07.03.07.37.25
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 03 Jul 2019 07:37:25 -0700 (PDT)
Date:   Wed, 3 Jul 2019 16:37:24 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Michal Kubecek <mkubecek@suse.cz>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v6 06/15] ethtool: netlink bitset handling
Message-ID: <20190703143724.GD2250@nanopsycho>
References: <cover.1562067622.git.mkubecek@suse.cz>
 <cb614bebee1686293127194e8f7ced72955c7c7f.1562067622.git.mkubecek@suse.cz>
 <20190703114933.GW2250@nanopsycho>
 <b3cd61506080143f571d6286223ae33c8bd02c3a.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b3cd61506080143f571d6286223ae33c8bd02c3a.camel@sipsolutions.net>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jul 03, 2019 at 03:44:57PM CEST, johannes@sipsolutions.net wrote:
>On Wed, 2019-07-03 at 13:49 +0200, Jiri Pirko wrote:
>> 
>> > +Value and mask must have length at least ETHTOOL_A_BITSET_SIZE bits rounded up
>> > +to a multiple of 32 bits. They consist of 32-bit words in host byte order,
>> 
>> Looks like the blocks are similar to NLA_BITFIELD32. Why don't you user
>> nested array of NLA_BITFIELD32 instead?
>
>That would seem kind of awkward to use, IMHO.
>
>Perhaps better to make some kind of generic "arbitrary size bitfield"
>attribute type?

Yep, I believe I was trying to make this point during bitfield32
discussion, failed apparently. So if we have "NLA_BITFIELD" with
arbitrary size, that sounds good to me.


>
>Not really sure we want the complexity with _LIST and _SIZE, since you
>should always be able to express it as _VALUE and _MASK, right?
>
>Trying to think how we should express this best - bitfield32 is just a
>mask/value struct, for arbitrary size I guess we *could* just make it
>kind of a binary with arbitrary length that must be a multiple of 2
>bytes (or 2 u32-bit-words?) and then the first half is the value and the
>second half is the mask? Some more validation would be nicer, but having
>a generic attribute that actually is nested is awkward too.
>
>johannes
>
>
