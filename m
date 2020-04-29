Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD2F91BE30C
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 17:47:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726580AbgD2Pr1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 11:47:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726456AbgD2Pr1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 11:47:27 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1C26C03C1AD
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 08:47:26 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id e26so2572349wmk.5
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 08:47:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2rgeKl9mfpEnqPitbFu91m+5OLEe95eSjN4EXjOS5oo=;
        b=jqc5WDa4CuNdnniJqSwahXLoQdylu497lgfeXaUZu6Sxz3kVZ9o+OzOFH7L9bZBu70
         43MaddcATIBzIoYVDA7HindxZ10w+S7qsAwr2kLYI1y22WJY2drxlP8/Vv0gAfv6KCqD
         5u34n6355XfW/VD99gOctJVs0HZ0C9oO/a5FWcmDj5E/wPrGMVZq2Ck+/pniSVMA8e+b
         3U2az+vukEShYtVtzaP8MsirWNvIDaHJiFrrsQX9/oEGyQDBBkz6pobZw+6KOi4W2/3u
         gptSf/zvHETFuR5w4xKTZA2KCXCDaM+BWZCfyRzb9+hJe472kXVtb/1G/jEC6TvqjxXw
         zD1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2rgeKl9mfpEnqPitbFu91m+5OLEe95eSjN4EXjOS5oo=;
        b=SDWGMpFBk1RE0N8LJr3yYT4C3GISft3FKpGnBTMkvoLkXtATevQSvE14VyWx7oPLLZ
         gOmMkffSMsWvBM+PNc9gcSlhzxmoJXT0cQLDX+2E7BXBIgKjDIDTp6iT8Qntsx53JAF/
         +bXPcwEufoVejux4QC6iPXX2HI962hb/HnmkvwS5ii5LqLYyyjxC70cQZqXO4x2ZubE0
         +h1k5czLBuLTcp0BWpkgdpX8UXYFssMAW/fkHNXFxnHozouJo4I4dbIAfTlRHtrkdSZ3
         1SysQ0seQrSHeFwXkvZwCUW/8Y6OoHYfb0EIHhklvt9YM7JgdZcmkUtBf5glzUywaeYU
         1YWg==
X-Gm-Message-State: AGi0PuYjd+i1xA4seoHd+BU+IImmyiFboUy7rqqqa8ZOyRdgRTyFVfPg
        k4YW/ziHdBI5wp8y7B0Sd2ts07loQ72hgw==
X-Google-Smtp-Source: APiQypJLKq9WKeocv1t1LgKVQIGsyLl5Ez1U1e2SL8/IP9R5EXkpwIXFZu4Ao7k7wOJCQR8lzMlEUw==
X-Received: by 2002:a05:600c:2c47:: with SMTP id r7mr3908791wmg.50.1588175245598;
        Wed, 29 Apr 2020 08:47:25 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id i6sm33146353wrc.82.2020.04.29.08.47.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2020 08:47:24 -0700 (PDT)
Date:   Wed, 29 Apr 2020 17:47:24 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kernel-team@fb.com,
        jacob.e.keller@intel.com, parav@mellanox.com
Subject: Re: [PATCH net] devlink: fix return value after hitting end in
 region read
Message-ID: <20200429154724.GD6581@nanopsycho.orion>
References: <20200429020158.988886-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429020158.988886-1-kuba@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Apr 29, 2020 at 04:01:58AM CEST, kuba@kernel.org wrote:
>Commit d5b90e99e1d5 ("devlink: report 0 after hitting end in region read")
>fixed region dump, but region read still returns a spurious error:
>
>$ devlink region read netdevsim/netdevsim1/dummy snapshot 0 addr 0 len 128
>0000000000000000 a6 f4 c4 1c 21 35 95 a6 9d 34 c3 5b 87 5b 35 79
>0000000000000010 f3 a0 d7 ee 4f 2f 82 7f c6 dd c4 f6 a5 c3 1b ae
>0000000000000020 a4 fd c8 62 07 59 48 03 70 3b c7 09 86 88 7f 68
>0000000000000030 6f 45 5d 6d 7d 0e 16 38 a9 d0 7a 4b 1e 1e 2e a6
>0000000000000040 e6 1d ae 06 d6 18 00 85 ca 62 e8 7e 11 7e f6 0f
>0000000000000050 79 7e f7 0f f3 94 68 bd e6 40 22 85 b6 be 6f b1
>0000000000000060 af db ef 5e 34 f0 98 4b 62 9a e3 1b 8b 93 fc 17
>devlink answers: Invalid argument
>0000000000000070 61 e8 11 11 66 10 a5 f7 b1 ea 8d 40 60 53 ed 12
>
>This is a minimal fix, I'll follow up with a restructuring
>so we don't have two checks for the same condition.
>
>Fixes: fdd41ec21e15 ("devlink: Return right error code in case of errors for region read")
>Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Jiri Pirko <jiri@mellanox.com>
