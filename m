Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A184209982
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 07:34:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389430AbgFYFd7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 01:33:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389269AbgFYFd5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 01:33:57 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71BF4C061573
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 22:33:57 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id ev7so1998749pjb.2
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 22:33:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Mxb4WRU7SAma7+l9xJEopVSHwgKOTPnxvCl9R3cfEO8=;
        b=bjUBbpoXm0u1G8V6JPM/N711l9/3KMfIuDBIuCk6cgyFXwzwhANmtwhAqsjLDTf3qU
         IDQwUnVHSDDTdgopRyELlMeoAnmOXL1gXfoNXIyZBjd+i/ggBhfnBdxReTjCXjKlw9Cr
         cmSWeaqxFSZVLa/Vb0i49GC3ywVzZhuM5TWdloF+4BzNswobmTcrwHoKjk4i93RrFvL3
         4Y24007tUjbB5IW/R0xDHVskv5DdqdXTnrolKm3Zu+4vNg7YMd8W77Z/4q/7iapoLtXC
         2h7AiA6SFChjDxUKodoqEhXFDCs5GLNFEvp9ybNaglcyMQWp5mTrcOILtuY7GwsJN5IM
         i3xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Mxb4WRU7SAma7+l9xJEopVSHwgKOTPnxvCl9R3cfEO8=;
        b=JmQyqqWSI9RKhfhrVSTqWKf8ejkkOmCogCu5a/f4gsmkOenwA9+oECUvbuLg9a1+xL
         WS0+yavimBBBgCY08IEjlrNIavf/4p0wVj6OlXepyEz7I+piabf5fQ1Hx1vtIsk2L7Gc
         mvAwQUd8qswfL5zheAT9zl5GV4GDUSwvFDgVV45FBGc3qwc5DGU1UqzNqPyvZht/pb9J
         AIhHCaW65fN5QBWV8Y4Uur59o8rdIPnXUMYi4kgyRAAAoVMxCkgs3FkfuZhVDfC9gNSj
         uvdg/M+NPC8Uo94mql1Ndoj1Tbwu6Ls2R2KfcWyBpgBuJZiu17YJ+/Pj/t1oGclDRx/P
         vKNw==
X-Gm-Message-State: AOAM533bVjjigpYgfLIXsDUnKbX98wKFDnb8IFLE8ICUVA8Y8OzjNCwp
        klbIl0LUjZUyVDpkz+TPfDopkS6KQ2o=
X-Google-Smtp-Source: ABdhPJxeqBCOerxFo8L9FFBv4u3VuRMNWD/OxhenVAKmmqXNh3i1AJSTOFBzNCFJDMpa3sFov35fMg==
X-Received: by 2002:a17:902:c206:: with SMTP id 6mr29333002pll.133.1593063236529;
        Wed, 24 Jun 2020 22:33:56 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id h17sm21230920pfo.168.2020.06.24.22.33.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 22:33:56 -0700 (PDT)
Date:   Wed, 24 Jun 2020 22:33:53 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Michal Kubecek <mkubecek@suse.cz>, netdev <netdev@vger.kernel.org>,
        Chris Healy <cphealy@gmail.com>
Subject: Re: [ethtool v2 3/6] json_writer: Import the iproute2 helper code
 for JSON output
Message-ID: <20200624223353.79e62ea7@hermes.lan>
In-Reply-To: <20200625001244.503790-4-andrew@lunn.ch>
References: <20200625001244.503790-1-andrew@lunn.ch>
        <20200625001244.503790-4-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Jun 2020 02:12:41 +0200
Andrew Lunn <andrew@lunn.ch> wrote:

> In general, Linux network tools use JSON for machine readable output.
> See for example -json for iproute2 and devlink. In order to support
> JSON output from ethtool, import the iproute2 helper code.
> 
> Maybe some time in the future it would make sense to either have a
> shared library, or to merge ethtool into the iproute2 source
> distribution?
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

You might also want to borrow the json_print code that merges both
output formats.  Or not
