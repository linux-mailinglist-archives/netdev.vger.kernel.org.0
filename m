Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A76AC1DCAB0
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 12:09:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbgEUKJJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 06:09:09 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:38191 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726821AbgEUKJJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 06:09:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590055747;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=D9Fbaz+JJ8kEEZ0tlvUZ395m97V8aOJOFAoDkHvGhQA=;
        b=fWkRj0MaX0xlSEi2fPutpRZ/xidPPE/Gi+9L8NSaO99BBcK95mw+55uYFbL0u+/KzwsKVi
        078W74TvsvznP9f3aQDVkxVekTSFEVAwkMomWyoevpi5qMKww6/EVwNnBU3GmcGHRRsb5P
        8yp96Iukuxt28MIsOIihIFMsAgXu03c=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-179-uB5WMKUjOYSGR037gn4XYw-1; Thu, 21 May 2020 06:09:05 -0400
X-MC-Unique: uB5WMKUjOYSGR037gn4XYw-1
Received: by mail-wm1-f71.google.com with SMTP id q6so1664173wme.1
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 03:09:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=D9Fbaz+JJ8kEEZ0tlvUZ395m97V8aOJOFAoDkHvGhQA=;
        b=ulO/VwoGfx9ZjCswC3MYodMVOu1KQXgLHfPdmLsNoo1Rp6zKfyJBY8LvwUrAapnIHK
         zqGTqJzJxk90xtzXz3qr4RLR/PjM1HKldX4dwLXR1upJVbce7gfOwmh1GoTh86+A8qGI
         vjkAxdYApDjDBri7c8wehjKWJCFXgw5UT8HFRDTF/C+Zu2Df8a1VYyxYr78bXDHUx30v
         3kRTFHxvvI5nG0nnrkh5JJwCXQWhktDKti9k9Dek0WS7wiN8cYUa3eqhy9ZMBpAFVeDP
         j78U3HXBQD5k5mNVD+C/+loIWO+YoM7fXGGM2RXOAPyVZ6UNjBRgNtJyz394XjkDWPBK
         nc9A==
X-Gm-Message-State: AOAM5307L8r54eBkAA/0f7l2b2nKHxkcmc0mYBy9FICtQeWDP++sklH3
        rZH/QwGBkfJqeQxpbDzbnGbW/cwKMJI83TKn0SWDWOit5OYBky8VjICDOKH32qKQ7OMgkugViK1
        v6v6Rl0jkHk85mXPx
X-Received: by 2002:adf:d4c6:: with SMTP id w6mr8319579wrk.92.1590055744899;
        Thu, 21 May 2020 03:09:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJycbzKmFRNRkyB/+G/ug6q84G+P7Jm+MG6E498KZP4gd5TeqIghwXi90/wVX8qLe9oSNT+zZA==
X-Received: by 2002:adf:d4c6:: with SMTP id w6mr8319562wrk.92.1590055744672;
        Thu, 21 May 2020 03:09:04 -0700 (PDT)
Received: from pc-3.home (2a01cb0585138800b113760e11343d15.ipv6.abo.wanadoo.fr. [2a01:cb05:8513:8800:b113:760e:1134:3d15])
        by smtp.gmail.com with ESMTPSA id 62sm4718700wrm.1.2020.05.21.03.09.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2020 03:09:03 -0700 (PDT)
Date:   Thu, 21 May 2020 12:09:02 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     kbuild test robot <lkp@intel.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, kbuild-all@lists.01.org,
        netdev@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Benjamin LaHaise <benjamin.lahaise@netronome.com>,
        Tom Herbert <tom@herbertland.com>,
        Liel Shoshan <liels@mellanox.com>,
        Rony Efraim <ronye@mellanox.com>
Subject: Re: [PATCH net-next 1/2] flow_dissector: Parse multiple MPLS Label
 Stack Entries
Message-ID: <20200521100902.GA24550@pc-3.home>
References: <1cf89ed887eff6121d344cd1c4e0e23d84c1ac33.1589993550.git.gnault@redhat.com>
 <202005210931.kHcrKMdv%lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202005210931.kHcrKMdv%lkp@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 21, 2020 at 09:24:25AM +0800, kbuild test robot wrote:
> All errors (new ones prefixed by >>, old ones prefixed by <<):
> 
> In file included from include/linux/build_bug.h:5,
> from include/linux/bitfield.h:10,
> from drivers/net/ethernet/netronome/nfp/flower/match.c:4:
> drivers/net/ethernet/netronome/nfp/flower/match.c: In function 'nfp_flower_compile_mac':
> >> drivers/net/ethernet/netronome/nfp/flower/match.c:100:57: error: 'struct flow_dissector_key_mpls' has no member named 'mpls_label'
> 
Sorry, I didn't realise this was used by NFP.
I'll respin.

