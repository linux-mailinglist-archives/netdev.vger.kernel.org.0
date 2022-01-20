Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D94734951DF
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 16:58:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243235AbiATP6V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 10:58:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242969AbiATP6T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 10:58:19 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4886DC061574
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 07:58:19 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id l16so6233162pjl.4
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 07:58:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=plAhIr13b4XwHurcEYWqLrw2/SFdXJEpAKeF05bfY3E=;
        b=Dzc7tzNvbPxZVdJC+OUT+vBGUKHP1eaPTT4hHTqqEu8IvoMiBJw98hXgzw93CgKPSA
         m8tT8xeD2dwu9T5dCfWzvTkEdWvSESK9aL/jJnhOpuZlDVbcDqdCqbRDVjLw8q5c6/xC
         aQa+GKPufS1fmF15apaH7IzNcTrN1RyfIXn51fdWtx3CuqPV+VivHcryiy3jB2E/veE3
         ZXo2zeYvZLFevSoGMptVZh5oijyUffKJVp+lypRWRC+Hx4Jv41gygkUR+KxQY0sZSXUI
         TG6wgsmJ+vOfoug0rByldgZHTXr8Gw/bJu/2C2SAKwuvrRVhnwgKAqeGsafCVXH29YO2
         PUDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=plAhIr13b4XwHurcEYWqLrw2/SFdXJEpAKeF05bfY3E=;
        b=3qlKm9WTjxJg9JRW/6WdwHkO12a91fNWfBsci+JhhugQbYMrlI8l/wyJ+oCH3qekLb
         NNzRz/IjVqBIc0Z2tw7b74FyYkL9FKJF5O3r7lVGy+uNuiq9E30rxwm/k7nq3K/RvvPp
         dcgtGxzFGl12MaFBOy/7Mt6hOebsoN15TDSBUTpzlc4NPRrzZMU5Bwp6nL6BOF2lLIto
         NvujS4zwv8psfFrtBWG6sFrbNf1mMpryV1lFx55VAwfE1FAr3Q9qhOzMDb5Xd10neNpK
         kNewhe5GtgVdiwErTYz6X8cYpa8gr11oftMoUuy0wnwgPkq5P7D7IOMbaYesDMTwweXG
         0WXQ==
X-Gm-Message-State: AOAM530HT1a/bDrtC5xjdN9QBENWjlZwT+ixfoMwqSKNlKEUqkEMlOj2
        B9xEXeNLwQuQi+8KnKbgAdw2Sw==
X-Google-Smtp-Source: ABdhPJx7oO0WzTYd51AWifEVkB2uJvszD4XfjaVOxbrghIJO0/Q6VgGU7c/n9A+HhFTZvjRlSG89uQ==
X-Received: by 2002:a17:902:8212:b0:149:af87:9f9d with SMTP id x18-20020a170902821200b00149af879f9dmr38826458pln.39.1642694298800;
        Thu, 20 Jan 2022 07:58:18 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id s6sm2830877pgk.44.2022.01.20.07.58.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jan 2022 07:58:18 -0800 (PST)
Date:   Thu, 20 Jan 2022 07:58:15 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jianguo Wu <wujianguo106@163.com>
Cc:     netdev@vger.kernel.org, shemminger@linux-foundation.org,
        noureddine@arista.com, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH] net-procfs: show net devices bound packet types
Message-ID: <20220120075815.1aeb87c5@hermes.local>
In-Reply-To: <04a03a41-6d44-645e-4935-613de20afb2d@163.com>
References: <04a03a41-6d44-645e-4935-613de20afb2d@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 20 Jan 2022 15:04:58 +0800
Jianguo Wu <wujianguo106@163.com> wrote:

> From: wujianguo <wujianguo@chinatelecom.cn>
> 
> After commit:7866a621043f ("dev: add per net_device packet type chains"),
> we can not get packet types that are bound to a specified net device.

That is an API regression, why not fix that rather than adding new /proc API?

/proc API's are legacy and it would be best not to add more there.
