Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F2A7230BE2
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 15:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730261AbgG1N6M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 09:58:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726764AbgG1N6L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 09:58:11 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60456C061794
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 06:58:11 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id kq25so7798192ejb.3
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 06:58:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ymP2tkbCreL/BF43+tTjYnEHkymNa3rchuw1gYfZEfQ=;
        b=oMNMtjIME3+WubEoBwV0RCzBSd3w/ZacHV0/MIaMQsDsXKVA+ffHU1K+cCfA0pZe5b
         8cmaUNwUFDPa7F+Oo47Ool4rApNg3xZ/KLqcmxmWlrP0p4y+H0nRUcngVmvfZw9RVRAO
         RjQhpeAhr763rKw69pCbpurmWe33driw0NlDRsF5667RjxZ/otWwsk8d9+9jzniz1Gn+
         oWcKZjScOYxJxQDIBjjkoqrBj+z2yY+8xDZNm1AGXQDBWrYMen1kq16oRSXqq2N6pSn3
         L7In1AgtUHsWRKlzODuHHfqmgaC7C0JL7ioaTxuQCVTzJ16Ehr5qMN0akImSf7QXATJB
         oiNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ymP2tkbCreL/BF43+tTjYnEHkymNa3rchuw1gYfZEfQ=;
        b=N1HpSxITgzJ+x3bHREEtW2358j9ZO3eYETzvI3RVSjBIYkm2c/4kmnlTY/d1hbGEpR
         lxnsUY5/WMBjj5Ju5RDzgV6EaVW+RFqwJ8YWVgIXgQuqSQejbB6DeNi6MkXo7QDRvyTT
         Se30lyIKMF9hTGmapvrsREhA3+MkTlpD6HlxGA6TP0+NIQgwIWOrAZwimVKjjSUAsrYf
         a2C2BvoLROK5KRGpB4ZPA4hu2dz4sH1sBC6eshRpWiFpSyTndgZgBeFt66r2Le9e0D24
         Jnm2QwJqcxKr9jb6yqir7HfXOmRQGxrkqruvzBfiXXW293UJltrVgLy/gIanSIVy0f9i
         M1fQ==
X-Gm-Message-State: AOAM531nPGTMkvmHc0zTtIrvlzDuI7BE0ivcGm3/Pmhe9sAOaIJIirGq
        L1460LO9UBu5pu0Dq/zc/HP5lA==
X-Google-Smtp-Source: ABdhPJwroLo223bNqj6sH/j5TpDMw2I5BPQp3H1jydSIXwW/JzjKbhx2qtE45esrYgcxkGyKrhleWQ==
X-Received: by 2002:a17:906:7f0e:: with SMTP id d14mr1886365ejr.400.1595944690141;
        Tue, 28 Jul 2020 06:58:10 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id f22sm442617edt.91.2020.07.28.06.58.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2020 06:58:09 -0700 (PDT)
Date:   Tue, 28 Jul 2020 15:58:08 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Moshe Shemesh <moshe@mellanox.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: Re: [PATCH net-next RFC 01/13] devlink: Add reload level option to
 devlink reload command
Message-ID: <20200728135808.GC2207@nanopsycho>
References: <1595847753-2234-1-git-send-email-moshe@mellanox.com>
 <1595847753-2234-2-git-send-email-moshe@mellanox.com>
 <20200727175802.04890dd3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200727175802.04890dd3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Jul 28, 2020 at 02:58:02AM CEST, kuba@kernel.org wrote:
>On Mon, 27 Jul 2020 14:02:21 +0300 Moshe Shemesh wrote:
>> Add devlink reload level to allow the user to request a specific reload
>> level. The level parameter is optional, if not specified then driver's
>> default reload level is used (backward compatible).
>
>Please don't leave space for driver-specific behavior. The OS is
>supposed to abstract device differences away.

But this is needed to maintain the existing behaviour which is different
for different drivers.


>
>Previously the purpose of reload was to activate new devlink params
>(with driverinit cmode), now you want the ability to activate new
>firmware. Let users specify their intent and their constraints.
>
>> Reload levels supported are:
>> driver: driver entities re-instantiation only.
>> fw_reset: firmware reset and driver entities re-instantiation.
>> fw_live_patch: firmware live patching only.
>
>I'm concerned live_patch is not first - it's the lowest impact (since
>it's live). Please make sure you clearly specify the expected behavior
>for the new API.
>
>The notion of multi-host is key for live patching, so it has to be
>mentioned.
>
>> Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
