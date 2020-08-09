Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6379A23FF07
	for <lists+netdev@lfdr.de>; Sun,  9 Aug 2020 17:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726210AbgHIPcr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Aug 2020 11:32:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726175AbgHIPcq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Aug 2020 11:32:46 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7E07C061756
        for <netdev@vger.kernel.org>; Sun,  9 Aug 2020 08:32:44 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id kr4so3436912pjb.2
        for <netdev@vger.kernel.org>; Sun, 09 Aug 2020 08:32:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rPxyoRq/TgJI7TmnhLluclJ2I+ZFZughTp/LX9Coaw4=;
        b=iOpaCFmGyC92qRmorEb34NeTPlHMbjBYO+tqhodBUh/xg5tGr1y0Gwq1qRnVIcpDaB
         KkCzJ+Sd3kqCa2NwxwVNxY/D2a8Yt6fU6Ov2rz6MgFQGzD+dKzrIaPVMpYXTZoPnsU2l
         3U9GXq9p37TajqA2ZZ8Lf/oNTj3w/zajUpk625ISL6/60pDy2J4YNsHfWxQQxTLWSeUM
         wfb4ukCc/HLOmvLcgb9qekBzMEzJEMUK0mZXLMMDnm2CAEt+ZlqylDEqQVD2eR1Pr0mh
         WZDuDXRORfEPp3phUwrfjGuiR1343qPt4UGXpEHlx/f5fwGMxn3rY3TZk8yqmSA5h9L+
         dA5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rPxyoRq/TgJI7TmnhLluclJ2I+ZFZughTp/LX9Coaw4=;
        b=Nr4CtX+5cxKSb3WR2n7ykfzYP55rx7ZVG8p37jGPNd5ghiQsej1/SK2OUWLLXqbAJI
         8AWYELZV4aMU0js5/9txKnd78bR8l3bp/Wv4p/xsw0w065zV8ZqmaNbAthGckcKalYYx
         WB1JJjmWJqZyCtxCZdJY01MEuBaNW9KNWf61KbiaIotM5tVhE6BhWXWL5yzvrOKuTC+7
         Kw6LefGMfbPnGvwjpvbARY/JKvdVKikZRiUwBBo2qgaEjh8M6mWhNAc2kM+k4pyKtRYn
         J73+d11paBJlwwwFssuc85C44NpMHIGL3Pm/XrwLdDrnS6z/UA/iEEW3msxdHrhKZCy0
         zvUQ==
X-Gm-Message-State: AOAM533EBPRvI/PXCOcus1zsRRWDXlqdChGNjJwh8PmNyLx/ZFQ3XX0g
        uE/TwQ1r5N8ngZf9lXmI1A3m11oSrFw=
X-Google-Smtp-Source: ABdhPJwqk9PUEwC3ca7WjB9rPPo3HAr7ihKiqA9SI3OSR7Ww/ZgiK1N768wophtGobV7i5vY8Wylkw==
X-Received: by 2002:a17:90a:414d:: with SMTP id m13mr22309053pjg.163.1596987162218;
        Sun, 09 Aug 2020 08:32:42 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id q25sm15995539pfn.181.2020.08.09.08.32.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Aug 2020 08:32:41 -0700 (PDT)
Date:   Sun, 9 Aug 2020 08:32:33 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Hillf Danton <hdanton@sina.com>
Cc:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Network Development <netdev@vger.kernel.org>,
        Markus Elfring <Markus.Elfring@web.de>
Subject: Re: rtnl_trylock() versus SCHED_FIFO lockup
Message-ID: <20200809083233.00822e44@hermes.lan>
In-Reply-To: <20200809134924.12056-1-hdanton@sina.com>
References: <b6eca125-351c-27c5-c34b-08c611ac2511@prevas.dk>
        <20200805163425.6c13ef11@hermes.lan>
        <191e0da8-178f-5f91-3d37-9b7cefb61352@prevas.dk>
        <2a6edf25-b12b-c500-ad33-c0ec9e60cde9@cumulusnetworks.com>
        <20200806203922.3d687bf2@hermes.lan>
        <29a82363-411c-6f2b-9f55-97482504e453@prevas.dk>
        <20200809134924.12056-1-hdanton@sina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun,  9 Aug 2020 21:49:24 +0800
Hillf Danton <hdanton@sina.com> wrote:

> +
> +static void br_workfn(struct work_struct *w)
> +{
> +	struct br_work *brw = container_of(w, struct br_work, work);
> +
> +	rtnl_lock();
> +	brw->err = brw->set(brw->br, brw->val);
> +	if (!brw->err)
> +		netdev_state_change(brw->br->dev);
> +	rtnl_unlock();
> +
> +	brw->done = true;
> +	wake_up(&brw->waitq);
> +}

Sorry, this is unsafe.
This has the potential of running when bridge itself has been
deleted.
