Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B21C81CC5DC
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 03:02:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728620AbgEJBB5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 21:01:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726320AbgEJBB4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 21:01:56 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10FF0C061A0C
        for <netdev@vger.kernel.org>; Sat,  9 May 2020 18:01:55 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id fu13so5972679pjb.5
        for <netdev@vger.kernel.org>; Sat, 09 May 2020 18:01:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=uSW1DMa2xFD1JwY5E5sO8XesFCa8M5X82K6mPTFeOlM=;
        b=1+Cjd90dDpebl/lpjqKbNVokRT3OdtBCX464eur5zMRwc6sunR//0hTPKyGFMBYDn+
         4s4EMDlJoNIkNgtkCHvFKvJ4BK+FSLcJcF3J0h1lFBJHpcGvBOOdoVJNuJuduxyhdptA
         85j0f2zkLQyxEd/osyueYryePBBEKaHhfTf3pYUcyugloMOdyrOAfoJZ6gWHbUrjqQLj
         Bq4Jez4NN0LmXePlsppUQ+3lVV2FHHGMRHWmUEdUPVdDZtvm3xP30rhd+ijoCYftHXaH
         O/d9SbqFvB9iV52JjhqLOrwxcvZn53+35Gt30HqnEMHSXevbw+tJGlyzQoU9D+YGA4+g
         K2Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=uSW1DMa2xFD1JwY5E5sO8XesFCa8M5X82K6mPTFeOlM=;
        b=r6ZCDV2dJMcqzI5udZagpu7qfdawPkRdEAVyTER9HjmTJcKTU7t0irNqQvl21aKJxm
         335LvdgfjI2N0j5ycQ/cBRoiZOuU1MhSN5rR4oINuEEhqwuN0hErXU9b9p385V/ntWox
         9BLpff0svnpnGacejpCdZCOQGAfRSTSA6W4d1N/0WsFSfz84rLupsf6S1GTBS/TvyVk8
         yvpyMv3Y9xd3YvNcOuoemISwf2KRIDFR8vZOa02zcvG1Zzzrjui56oRfpJ4r8VFfjSNh
         swXSiT+q4PIVP7mA1/iEMLEA5wFsS+GvOPah3JPXO9g+W0BlQwY35IRe1j75oc9AKBjj
         H97g==
X-Gm-Message-State: AGi0Pub7Nmw4Hp5Kx5xD/gfXCzwmVl0IH4xaKjTUrAsVOKwVbOdo1urH
        bTUNSbcZr+br32WP7zOJu335vQ==
X-Google-Smtp-Source: APiQypK4urdSWKHAH3Iuz6cUfY7VBxMl/PQZvd82MG6IPFOmlk+5A2FE/bq13Bz5zOp9Fvriq0citA==
X-Received: by 2002:a17:902:8545:: with SMTP id d5mr9040836plo.34.1589072514404;
        Sat, 09 May 2020 18:01:54 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id b1sm5478906pfi.140.2020.05.09.18.01.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 May 2020 18:01:53 -0700 (PDT)
Subject: Re: [PATCH 00/15] net: taint when the device driver firmware crashes
To:     Luis Chamberlain <mcgrof@kernel.org>, jeyu@kernel.org
Cc:     akpm@linux-foundation.org, arnd@arndb.de, rostedt@goodmis.org,
        mingo@redhat.com, aquini@redhat.com, cai@lca.pw, dyoung@redhat.com,
        bhe@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        gpiccoli@canonical.com, pmladek@suse.com, tiwai@suse.de,
        schlad@suse.de, andriy.shevchenko@linux.intel.com,
        keescook@chromium.org, daniel.vetter@ffwll.ch, will@kernel.org,
        mchehab+samsung@kernel.org, kvalo@codeaurora.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200509043552.8745-1-mcgrof@kernel.org>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <1e097eb0-6132-f549-8069-d13b678183f5@pensando.io>
Date:   Sat, 9 May 2020 18:01:51 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200509043552.8745-1-mcgrof@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/8/20 9:35 PM, Luis Chamberlain wrote:
> Device driver firmware can crash, and sometimes, this can leave your
> system in a state which makes the device or subsystem completely
> useless. Detecting this by inspecting /proc/sys/kernel/tainted instead
> of scraping some magical words from the kernel log, which is driver
> specific, is much easier. So instead this series provides a helper which
> lets drivers annotate this and shows how to use this on networking
> drivers.
>
If the driver is able to detect that the device firmware has come back 
alive, through user intervention or whatever, should there be a way to 
"untaint" the kernel?  Or would you expect it to remain tainted?

sln

