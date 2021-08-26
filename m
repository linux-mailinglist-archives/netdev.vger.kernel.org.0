Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52FB33F8AB9
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 17:08:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242890AbhHZPJn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 11:09:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231458AbhHZPJm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 11:09:42 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 346BFC061757
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 08:08:55 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id 2so3002245pfo.8
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 08:08:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LkKADXQovWE3M97DuHN/Y0OYTTsiR1iy6nJ2u9tIUrw=;
        b=WGWFSM9SkdLRZedl9P5JEBXpREohWZ4co1ayfMhh6uXfT0eZ8oQGR9tiPdUzImb6yw
         jyhnthi2KJB94clVnvEVxDTWvTbbpox6w+2tHj4ojlyr0Dz0j6gvwMJax5fDlQkMKI8E
         I1cJwE3bVceVKCVCtpauUhT6CW6sDLrxrY+RyQ9HSU951F+LYP18cK0yLFbBDbRhCdbl
         OQ1BheSsJRiBLfi/xbdmc4elTVoYzwgWH5U2aVnkeWh2vg+jYJrxCapCkk+VCLHBWI9C
         0UZpusr69BnKdz4dfDsbj7vQYA95w1UkSVGwFwDs4HVj+VtyiI+YOmOADBs1tcga1bHg
         2lng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LkKADXQovWE3M97DuHN/Y0OYTTsiR1iy6nJ2u9tIUrw=;
        b=hZq32HfHSiRcXj0IpFJUU6XtciaDsx6o/p3Sh+onOsl8FMeDBKpWZjOzJ8Xany6dH/
         7bSctvhG90BLbXMwgMJYP8ob/3MDMuOXJOgQH6M+JjIxvlk7VdkM/CIDCSj5pIgdBLfn
         RtxcklWwgh7NZuuQbsQLTyLXbXQ5Ctg/kVh3p4CNW539PyKKrAwu6GsyCT8W60aQkaKx
         DGAsO4KcOzJo55Sv9N3Zv58SOdh2fPRgcgMK3nnP3Zef+f7Mt4YZBBVsEJ6gD6k5QfJW
         4cE3EQxgVdWM8vphtT17ZHsk9mrUA4IlQ3Z/k+gYxS7Ru5Pdgx0vpzsHmcmwFfKIWCu+
         w42Q==
X-Gm-Message-State: AOAM533WQTqeONLKu/O4d6RHY8kjpiXeD7mGPaNES6i4+4MSo6AOomiB
        xs6FxU+u5l1hxbXpAyHs2THfRQ==
X-Google-Smtp-Source: ABdhPJyhb2EsEmxRbn9OmfCBEqDzhacpp6woVSlfgnYBtOV6le567VNgdPB7cMLehSLAw4UptWSsWQ==
X-Received: by 2002:a63:4a55:: with SMTP id j21mr3713034pgl.187.1629990534685;
        Thu, 26 Aug 2021 08:08:54 -0700 (PDT)
Received: from hermes.local (204-195-33-123.wavecable.com. [204.195.33.123])
        by smtp.gmail.com with ESMTPSA id nk17sm3233960pjb.18.2021.08.26.08.08.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 08:08:54 -0700 (PDT)
Date:   Thu, 26 Aug 2021 08:08:51 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     netdev@vger.kernel.org, roopa@nvidia.com,
        Joachim Wiberg <troglobit@gmail.com>, dsahern@gmail.com,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: Re: [PATCH iproute2-next 01/17] ip: bridge: add support for
 mcast_vlan_snooping
Message-ID: <20210826080851.1716e024@hermes.local>
In-Reply-To: <20210826130533.149111-2-razor@blackwall.org>
References: <20210826130533.149111-1-razor@blackwall.org>
        <20210826130533.149111-2-razor@blackwall.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 26 Aug 2021 16:05:17 +0300
Nikolay Aleksandrov <razor@blackwall.org> wrote:

> +		} else if (matches(*argv, "mcast_vlan_snooping") == 0) {
> +			__u32 mcvl_bit = 1 << BR_BOOLOPT_MCAST_VLAN_SNOOPING;

Using matches() is problematic.  since it will change how 'mcast' is
handled.

Overall, bridge command (and rest of iproute2) needs to move
away from matches
