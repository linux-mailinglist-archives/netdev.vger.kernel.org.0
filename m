Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AD1127B322
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 19:26:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbgI1R0R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 13:26:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726558AbgI1R0Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 13:26:16 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30A07C0613D3
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 10:26:16 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id o20so1642744pfp.11
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 10:26:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=xu75CUkAEe8YKESDX+6RMXTyhfVPWONUsVk2klTLLIw=;
        b=0/6i+LzwyathOMbvG6oG2ll/0evYhsEXpg9MB8BFBLC+1GFyqK6z7LlJJBxzxFdfbJ
         05TEF7DdGGpuvCMyi2NZv1Q92KQL0cR+D9CHNZcApVdI271h571JbWXG7v8ceUFtVFtf
         iwjyPFqYKOGDgEmB8LpvoaUN93/ZIPIYVvLAUawMj6Y4rR+hfMhita75OZvkqLyaAvUf
         xvE+pK94Tr93FIKvvY4r5qpOHmvw3WITNJyYhNThNqO4q29c3wTZYVBQe7Tq8UTIL6k4
         0ZHjkrbMpMyKmBmkJEdjYVDtZTHnR2/b6Pa/4fNUCUmKUcc1eo5AP/szp3Nr9ULAH1LL
         Gszg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=xu75CUkAEe8YKESDX+6RMXTyhfVPWONUsVk2klTLLIw=;
        b=NyAhOYWbkLEYXe8NiNYc4XsLAqqk9qgu9GV0Fb0wSUIjTIrsnC5PFqF+4c7r7kjMN1
         CTf0LrH2nLlVGFf0VTG/DYMdx8ceP6nYjacRFr413ADRlh3W/jYFVjV2MuIPdDmKY7nE
         H/qNHFkCuWny48/T+sZbp3+amwrgx1LzaMWOwo8DLibFM3+rscRKjKyfZbzf1GazSN/r
         sJwpDcBzydIMpBXjXarBcU6gEEa/hkMMcqI6YEHjRzYnI1j/wgjzd+Thg3cOytnYnY4K
         6FLIAR+AK3T8eudstp5cTOAauUvdtNXYrHBEmeB+HLnnDCCiwN3zQiL76TyuqWPCHbgr
         MdcA==
X-Gm-Message-State: AOAM532tkeGFtRk7DbNm0xviqvWn/tRmj0CLbQZ7ioU24cFVnRvUYFYV
        yq4F/BMaTw0lZ/gn3eV+rjcC1g==
X-Google-Smtp-Source: ABdhPJzwfjXkCsxEu3XfK2aVP501w1BXp/1/rfPP3H13WpeMSgLae7v91sNjQ8w4DmdYg1Jo2bc1PA==
X-Received: by 2002:a63:595a:: with SMTP id j26mr130244pgm.406.1601313975665;
        Mon, 28 Sep 2020 10:26:15 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id j18sm1986127pgm.30.2020.09.28.10.26.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Sep 2020 10:26:15 -0700 (PDT)
Subject: Re: [patch 12/35] net: ionic: Remove WARN_ON(in_interrupt()).
To:     Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linuxfoundation.org>,
        Paul McKenney <paulmck@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Pensando Drivers <drivers@pensando.io>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Christian Benvenuti <benve@cisco.com>,
        Govindarajulu Varadarajan <_govind@gmx.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-doc@vger.kernel.org,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Jay Cliburn <jcliburn@gmail.com>,
        Chris Snook <chris.snook@gmail.com>,
        Vishal Kulkarni <vishal@chelsio.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        intel-wired-lan@lists.osuosl.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
        Edward Cree <ecree@solarflare.com>,
        Martin Habets <mhabets@solarflare.com>,
        Jon Mason <jdmason@kudzu.us>, Daniel Drake <dsd@gentoo.org>,
        Ulrich Kunitz <kune@deine-taler.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, linux-usb@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        Stanislaw Gruszka <stf_xl@wp.pl>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Jouni Malinen <j@w1.fi>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        libertas-dev@lists.infradead.org,
        Pascal Terjan <pterjan@google.com>,
        Ping-Ke Shih <pkshih@realtek.com>
References: <20200927194846.045411263@linutronix.de>
 <20200927194921.026798214@linutronix.de>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <96baeba9-eb5f-1462-2dcc-ecb9793727a1@pensando.io>
Date:   Mon, 28 Sep 2020 10:26:10 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200927194921.026798214@linutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/27/20 12:48 PM, Thomas Gleixner wrote:
> From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
>
> in_interrupt() is ill defined and does not provide what the name
> suggests. The usage especially in driver code is deprecated and a tree wide
> effort to clean up and consolidate the (ab)usage of in_interrupt() and
> related checks is happening.
>
> In this case the check covers only parts of the contexts in which these
> functions cannot be called. It fails to detect preemption or interrupt
> disabled invocations.
>
> As the functions which are invoked from ionic_adminq_post() and
> ionic_dev_cmd_wait() contain a broad variety of checks (always enabled or
> debug option dependent) which cover all invalid conditions already, there
> is no point in having inconsistent warnings in those drivers.
>
> Just remove them.
>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Shannon Nelson <snelson@pensando.io>
> Cc: Pensando Drivers <drivers@pensando.io>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: netdev@vger.kernel.org
Thanks.

Acked-by: Shannon Nelson <snelson@pensando.io>

> ---
>   drivers/net/ethernet/pensando/ionic/ionic_main.c |    4 ----
>   1 file changed, 4 deletions(-)
>
> --- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
> @@ -248,8 +248,6 @@ static int ionic_adminq_post(struct ioni
>   	struct ionic_queue *adminq;
>   	int err = 0;
>   
> -	WARN_ON(in_interrupt());
> -
>   	if (!lif->adminqcq)
>   		return -EIO;
>   
> @@ -346,8 +344,6 @@ int ionic_dev_cmd_wait(struct ionic *ion
>   	int done;
>   	int err;
>   
> -	WARN_ON(in_interrupt());
> -
>   	/* Wait for dev cmd to complete, retrying if we get EAGAIN,
>   	 * but don't wait any longer than max_seconds.
>   	 */
>

