Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5904A6A49BD
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 19:30:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbjB0SaB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 13:30:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbjB0S35 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 13:29:57 -0500
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EF221A4B1
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 10:29:56 -0800 (PST)
Received: by mail-qv1-xf35.google.com with SMTP id f1so5064830qvx.13
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 10:29:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8gqvdI/sqm54XWkh3DNgmjvQKemViz9xEEbhMbeWe3c=;
        b=ah1GvW2D49ep0hOqw/mlXtnmomQmxfiSth7nxEOTuMhOFAL99QpKjBLWCq+wH8akJc
         p0n17L3oxLnHyg17c6g1tVpvAhGVsDDQJ50GuexcKwOglLAInq/DFoZ3q+f1NL4Rn/rb
         08yaIH6KD+UisKS28gCNfID2vVt4qUmkz3Y+IO2RW8IyrhoMCJ6t1N0I+QvpdKycKOyU
         FzjRHlIkeZ0+vUkSNDinURM5kf8TIAjJItUN1cPmoXdFB3AnUcUOk/BQvBHU2AHJr+6Z
         eQzPi8E4NjFzpwYVOL1EkfNSKOYzIxCyH8BLc8E96SncGuibxJshN1FIwwDixyVhrobg
         4Hcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8gqvdI/sqm54XWkh3DNgmjvQKemViz9xEEbhMbeWe3c=;
        b=gQ5HGZs97FFCEhsARrtpEFANnQIKfnZxTfUgRPpyLq3+qA2fVwIGEvlhlYzBAKugp5
         FPKOsV4uxY2LMnDcVHYoTmt+xaUj+IJUsgnPDC0EN89yzNrt7coeiN6gi2b9xKF7nimL
         CBfPH8YKUqFKnfCh3iGVEemuTUZzGFks8iy4sBB6CVVmjdEI31hTFAMOQaQi37WlL/E3
         kSXS991RrSt3yNZ/I4y55uYhPJe0bSWUnxGEOmAqMg/NPG41l+5p0MkXmGnNolpaiTlZ
         silS1+VUaagACYjq9ktx4bwDDzvskZIblIhd5Hot+nfp7GXQVJtzTBJ22T15ajkaFQj7
         YDfg==
X-Gm-Message-State: AO0yUKXmbcszuOZ8n03cR/CaApHODTFoJcs0aTDbStBxeYhIGFTKLVbJ
        4n4o+s1JgrvGkuECS3dWE9o=
X-Google-Smtp-Source: AK7set8JAaa6QqvRhCiFk/ex/Sa1va63Zyjy0oAf4uJqHbWwiCQU/Mns4yyyJOxsM6zeFDkxU6du+w==
X-Received: by 2002:a05:6214:2425:b0:56e:c09e:7d6b with SMTP id gy5-20020a056214242500b0056ec09e7d6bmr673722qvb.43.1677522595026;
        Mon, 27 Feb 2023 10:29:55 -0800 (PST)
Received: from vps.qemfd.net (vps.qemfd.net. [173.230.130.29])
        by smtp.gmail.com with ESMTPSA id x21-20020a376315000000b007419eb86df0sm5374861qkb.127.2023.02.27.10.29.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Feb 2023 10:29:54 -0800 (PST)
Received: from schwarzgerat.orthanc (schwarzgerat.danknet [192.168.128.2])
        by vps.qemfd.net (Postfix) with ESMTP id 485D02B426;
        Mon, 27 Feb 2023 13:29:54 -0500 (EST)
Received: by schwarzgerat.orthanc (Postfix, from userid 1000)
        id 4394B60018D; Mon, 27 Feb 2023 13:29:54 -0500 (EST)
Date:   Mon, 27 Feb 2023 13:29:54 -0500
From:   nick black <dankamongmen@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jeffrey Ji <jeffreyji@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: Re: [PATCH] [net] add rx_otherhost_dropped sysfs entry
Message-ID: <Y/z2olg1C4jKD5m9@schwarzgerat.orthanc>
References: <Y/p5sDErhHtzW03E@schwarzgerat.orthanc>
 <20230227102339.08ddf3fb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230227102339.08ddf3fb@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski left as an exercise for the reader:
> "All the other stats are there" is not a strong enough reason
> to waste memory on all systems. You need to justify the change
> based on how important the counter is. I'd prefer to draw a
> line on adding the sysfs stats entries. We don't want to have 
> to invent a new stats struct just to avoid having sysfs entries
> for each stat.

In that case, I think a comment here is warranted explaining why
this stat, out of 24 total, isn't important enough to reproduce
in sysfs. I'm not sure what this comment would be:
rx_otherhost_dropped certainly seems as useful as, say
rx_compressed (only valid on e.g. CSLIP and PPP).

If this stat is left out of the sysfs interface, I'm likely to
just grab the rtnl_link_stats64 directly via netlink, and forgo
the sysfs interface entirely. If, in a modern switched world,
I'm receiving many packets destined for other hosts, that's at
least as interesting to me as several other classes of RX error.

-- 
nick black -=- https://www.nick-black.com
to make an apple pie from scratch,
you need first invent a universe.
