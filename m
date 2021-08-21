Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DF663F394A
	for <lists+netdev@lfdr.de>; Sat, 21 Aug 2021 09:18:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232943AbhHUHTG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Aug 2021 03:19:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232097AbhHUHTD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Aug 2021 03:19:03 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1686DC061575;
        Sat, 21 Aug 2021 00:18:25 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id t13so10614917pfl.6;
        Sat, 21 Aug 2021 00:18:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PGx5d5ngOi9HnjW9jRL7IAc1ejry1+dTgBsQSCQFIoc=;
        b=HZ8B43IvV+JbpJ3FecDPs9LIiEjFxtdAZ6CHv49EHj8P5RrE+9XVo45rdFsmaVZRTX
         BIEmFooSBefIhdyyJ40rOeKql4I+uVFZ2LFP8HFprt/GBE+OY0RFkvJWYyhoRgho6c3g
         ykr/sZVy2M6pZ/STICWvKxPC2tCj9r83uEZZOazHDg+5bu06zqIIP6N9Rd4n8noIxT6C
         tSEVLRO4VFej8GTkoF9UUvtcOc69rD1pnyZq0ZI5CRQ+Uk484wGjrD/DLRuLEA6HunZj
         mVr6+2KTQb/tcwpxkje84m2yAFezpK8YciYiL3oxo5BExJJQiS1u7ePLZ96KX62ZVchn
         oBew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PGx5d5ngOi9HnjW9jRL7IAc1ejry1+dTgBsQSCQFIoc=;
        b=cxpqGHuGaXZItAw9vMiNJU39HoIoxcJogxOTajgp/E9osd1kVyy22L+0Lz7rz0xs9o
         sPytSqo+CwpmRKohf5aWGeDH4zx6amf1g4AsvvN7/bjHLHUyNQpE/tPOTerBG/Fu/21q
         UgtXA+LZroltmN1bd4Enwge8mWMTOC6AX9nSj22cZGZX0KiDSCpRY8YOEC/mxG8mJxtU
         5yS7+djvyRydu1NMBm6zIIPzCACef11H5Vecttok+KOepDQ5XReCoI1fNsuUgSzQ+sxA
         qJElDObeD62zNUOk+pX6Uy8zB2H38kZO3gQy6+Wj8gRcUD7iBo5pREaIswDZaVspm9Ue
         By8Q==
X-Gm-Message-State: AOAM533zpvXQyRjrVjaTehmg9nJH6y3KN7QDKcxTzBPNrkjX9loTz76G
        iFgtO+S4KejYyAjCIN9yKAc=
X-Google-Smtp-Source: ABdhPJzorGXrdVRMFuvS0naeiq9s7Dq7RzpV3qV7oA3R7RjMIhq/oSAK3AawSR1o2GwJCwqartI4JQ==
X-Received: by 2002:aa7:8b07:0:b029:3c7:c29f:9822 with SMTP id f7-20020aa78b070000b02903c7c29f9822mr23118926pfd.33.1629530304547;
        Sat, 21 Aug 2021 00:18:24 -0700 (PDT)
Received: from fedora ([2405:201:6008:6ce2:9fb0:9db:90a4:39e2])
        by smtp.gmail.com with ESMTPSA id q21sm10407216pgk.71.2021.08.21.00.18.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Aug 2021 00:18:24 -0700 (PDT)
Date:   Sat, 21 Aug 2021 12:48:11 +0530
From:   Shreyansh Chouhan <chouhan.shreyansh630@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+ff8e1b9f2f36481e2efc@syzkaller.appspotmail.com
Subject: Re: [PATCH] ip_gre/ip6_gre: add check for invalid csum_start
Message-ID: <YSCos0Sdw7RYsNQu@fedora>
References: <20210819143447.314539-1-chouhan.shreyansh630@gmail.com>
 <CA+FuTSdsLzjMapC-OGugkSP-ML99xF5UC-FjDhFS1_BDDSJ2sg@mail.gmail.com>
 <20210819100447.00201b26@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210819100447.00201b26@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Thank you Jakub and Willem for your reviews. I have separated the
changes into two differnet patches. Sorry for the delay.

Where can I read about patch targets? I have seen patches with differnet
targets but I do not know what they mean/how they work. I was not able
to find the documentation for these.

Thank you,
Shreyansh Chouhan
