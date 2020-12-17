Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4CA92DDB70
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 23:32:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732169AbgLQWa6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 17:30:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732154AbgLQWa6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 17:30:58 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AD61C0611CE
        for <netdev@vger.kernel.org>; Thu, 17 Dec 2020 14:30:13 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id q4so312246plr.7
        for <netdev@vger.kernel.org>; Thu, 17 Dec 2020 14:30:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Pf9ckCEVaJ6zRPQluKNLBc+gFVAc92xCjtYHcq1JC/A=;
        b=mric7Hjj4cDYfT8pldW/fafGOVPxVs+mQFbytAiEFHYJTaxQpPs5WGeRJdQr7BzdVX
         ihAg41fvq0zIyvX5aFC2MqMexW25taT4H6J7QvZ5mkEdMop5x6mlkPcFpIqq/IlNbkI0
         0uIDEzpn4n4iOfw61QNDzjOWwaGBAtx2WH5M0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Pf9ckCEVaJ6zRPQluKNLBc+gFVAc92xCjtYHcq1JC/A=;
        b=Bq4rFUpiRcAF31S6tl9VR1ItogRfAMMAquCdd5QrKg+3KcrczhVgTPp4UqtKaYUEN5
         UDOajfLYVoIR4coV9KF93zZgjGlvEWv/p9WJ3xDCL/1vJEIh3surp9UFBHbKZMA+ZSPg
         EoK/qc/cJrpHqavhIgj6eOxgId68lURpEnoIw0JImELQUl20CqumSOzj9b9pFmQwmSwF
         Xud6u9zsBFkEHvryvrmuV8sUoJEGftyAZqf9qpdpzUvg8WRrC9q7u4zG3E9hYDQOLCEL
         mUEEPhe4eXbDNrCAOSFogbXb36d/B4xA0LbrfhW3UMvXQ98e+7qOXmYXmEdd6zdsYuPr
         ExJA==
X-Gm-Message-State: AOAM531DGdS8NX7a9GDnp+zQIUU0tu9zJ2MgWBGEUS7nTW8Nne14IVX2
        rkKjMGro8s1jKyeVU1XoZRczCA==
X-Google-Smtp-Source: ABdhPJx2cbX0FBjlN0OqPmNj516SIg9lvraV+rd1J5A+Cm3zOrLoueWLJm2ajUoRLZxZZeF3sxFHWA==
X-Received: by 2002:a17:90a:f311:: with SMTP id ca17mr1312552pjb.180.1608244213043;
        Thu, 17 Dec 2020 14:30:13 -0800 (PST)
Received: from google.com ([2620:15c:202:201:8edc:d4ff:fe53:350d])
        by smtp.gmail.com with ESMTPSA id c62sm6779936pfa.116.2020.12.17.14.30.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Dec 2020 14:30:12 -0800 (PST)
Date:   Thu, 17 Dec 2020 14:30:09 -0800
From:   Brian Norris <briannorris@chromium.org>
To:     Youghandhar Chintala <youghand@codeaurora.org>
Cc:     johannes@sipsolutions.net, ath10k@lists.infradead.org,
        kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kuabhs@chromium.org,
        dianders@chromium.org, pillair@codeaurora.org
Subject: Re: [PATCH 0/3] mac80211: Trigger disconnect for STA during recovery
Message-ID: <X9vb8TQvjElEtscA@google.com>
References: <20201215172113.5038-1-youghand@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201215172113.5038-1-youghand@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 15, 2020 at 10:51:13PM +0530, Youghandhar Chintala wrote:
> From: Rakesh Pillai <pillair@codeaurora.org>

I meant to mention in my other reply: the threading on this series is
broken (as in, it doesn't exist). It looks like you're using
git-send-email (good!), but somehow it doesn't have any In-Reply-To or
References (bad!). Did you send all your mail in one invocation, or did
you send them as separate git-send-email commands? Anyway, please
investigate what when wrong so you can get this right in the future.

For one, this affects Patchwork's ability to group patch series (not to
mention everybody who uses a decent mail reader, with proper threading).
See for example the lore archive, which only is threading replies to
this cover letter:

https://lore.kernel.org/linux-wireless/20201215172113.5038-1-youghand@codeaurora.org/

Regards,
Brian
