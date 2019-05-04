Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 187A013A04
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 15:20:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727254AbfEDNUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 09:20:24 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:35974 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726781AbfEDNUX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 09:20:23 -0400
Received: by mail-wm1-f65.google.com with SMTP id a10so1476212wme.1
        for <netdev@vger.kernel.org>; Sat, 04 May 2019 06:20:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=LsT+GMIC/6YnKSdnUygx/unS2Ws7az/a5IQGM7H4jyM=;
        b=oIlWJIlSdLEvT2OK2mpTOf4JDR3Q76FD0OdscgVyZuolUAiVwZeXfUuM+yw0YTGDfP
         ueu67wDYKsSxbp3LznQWA6u7PybK5ygCgg+i05oFHp9L1CEfRvV64z9fscUysx2W3MqR
         bWx1L3d4nLQw50pmS/N5J3xybyVCW69SJzWDnXO24ohGMSSLt5d1zUSIXgKn8tCLmpVJ
         iSztW+K2lu3MoE1F9lON5Iyh+tZoA39k41EaaenGCG6l7FYfV5vEDp5OZVNMUJnGvmCp
         x+oXRpDnH/CSiW+ivfcjbOwBrR8XEUI7TzRsW/sETjf0qSK5B+2ZWZruhqVa3qiMNuqe
         GHfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=LsT+GMIC/6YnKSdnUygx/unS2Ws7az/a5IQGM7H4jyM=;
        b=XCi1g0/uzFYBDnfMvWjF2h2IpLhJUPzpkUGdK4RYrGHDQbxSHTFzR2Z2afS7kjEdsK
         Aot+ZfKBk/gE3OhuXLeEVWKgPMOX8SAaIr4rKuY1NJrzHYO6f0kS1ZPUXgUBH4wwwm2m
         8Qy95XZWiqMdz1ha99JNtncs3c8XnPW1N8BVSZes/Vuq/Eqpgs7JsZ7d3V3TbRvnxg8r
         Jh+aiMnoNu5MA3tAJ7+I7Wy0vE7fMdLWMfpwJwjlgR0pTXmMSTb5DBGh3KFeo0PqHbqw
         KlO87M8Z5ZeZcTarbjiOsMjwVSQ17zZRHnusYr4RYUjfn86+kc/utJlET5XJuRNLHuwP
         k9IQ==
X-Gm-Message-State: APjAAAX+81aXOb5jiW+995YdbetEctdtbjyas2rtBiZ73XZJvQUkyU9+
        JgPB3daxVfrytU3Tk5WAUiTJdy+sDRg=
X-Google-Smtp-Source: APXvYqy4bzqCBpGC1AGmTLFhJIT80fifHYTjTOVNVfuCFz/gx8FvTRPSAl8xtpAsWyIivDkpQh8aqg==
X-Received: by 2002:a1c:f901:: with SMTP id x1mr10434546wmh.136.1556976021439;
        Sat, 04 May 2019 06:20:21 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id c21sm5405061wme.36.2019.05.04.06.20.20
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 04 May 2019 06:20:20 -0700 (PDT)
Date:   Sat, 4 May 2019 15:20:19 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        oss-drivers@netronome.com, xiyou.wangcong@gmail.com,
        idosch@mellanox.com, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, gerlitz.or@gmail.com,
        simon.horman@netronome.com,
        Pieter Jansen van Vuuren 
        <pieter.jansenvanvuuren@netronome.com>
Subject: Re: [PATCH net-next 09/13] net/sched: allow stats updates from
 offloaded police actions
Message-ID: <20190504132019.GK9049@nanopsycho.orion>
References: <20190504114628.14755-1-jakub.kicinski@netronome.com>
 <20190504114628.14755-10-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190504114628.14755-10-jakub.kicinski@netronome.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, May 04, 2019 at 01:46:24PM CEST, jakub.kicinski@netronome.com wrote:
>From: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>
>
>Implement the stats_update callback for the police action that
>will be used by drivers for hardware offload.
>
>Signed-off-by: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>
>Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>

Acked-by: Jiri Pirko <jiri@mellanox.com>
