Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5B3A37FC2
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 23:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728040AbfFFVmK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 17:42:10 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:43290 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbfFFVmK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 17:42:10 -0400
Received: by mail-pl1-f195.google.com with SMTP id cl9so1427352plb.10
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 14:42:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vbIfzwMFHBPMsO+iuDXsFTdhu0Qwuvx/QCSJrHDbxTQ=;
        b=Fs+XYjGmn+hoeCslrEUydJq/scrrfRiKjrpvXcOTOkxYuLZ5tG8zBvuqXdEBTHPNf6
         kgEVAqGce9731XkzCFYvRFNIgUd+hzVG5NJSmUUq8TcC7QwlXhqy6MPhnWWZnQt191Rp
         3HBdmldsZ/2yNYP+hFP0yqmdhTSsQJVC2bgMOBapL/Whkj61iKXg7Q/4ZqkJwy+dVnby
         N/U2SzmAyQXHT1+fBGKB3J4jkiZxdZLh7wxZCPpCDy3Hecx0WxCnLcUozkfynnhFU4ND
         /EVTEip830bk+Uenx8p1R5rKnPLCalVfrR2fMYZCI1s8Nu0qTZGbcHcd7zIBafFQu7+b
         ZpQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vbIfzwMFHBPMsO+iuDXsFTdhu0Qwuvx/QCSJrHDbxTQ=;
        b=E7LPoLAv3f+94SL/4D2oSlrnviJg5ZGteIV4vJR5b7P4EINVjL+xzYVzzFi/LQSglc
         VlD8lkLgQgyrXW0EOYHKeOCCBdivFNA4GKTZdZAvj4/LV2maZFjYK3eDAj8FTo2ZyP1S
         8PswygN33xhaolcoqAgnAWazJRa0ROkG5ED1yxS+T7t3nQjiirH2E8y/tiviOfC5eskl
         OA0lpLR31yxf1Q+y5SNPqMLI/5FSPG4FuBUO8kzy/W3yd0ZFgHSPLff+GrN31hbPb+hY
         AyzHboTsej0WB+XtubJ61pxAqb74jbbxDSYwrHdZr8HNLJpmJreXm0zTFLDJfFezTcno
         Ps5A==
X-Gm-Message-State: APjAAAUa0OMe7pQ0B1ibGRPqIqwI5KFDpZVKPHr+I12RvBYRBEJ3ifru
        Ke9kn+15W5pE91OLfpWNjGHjVlMbzHM=
X-Google-Smtp-Source: APXvYqzda4S4EDmY4gOseWM4QUFpGYrlSZPD+uEW5P5I7it0kfQEJ/33xhEH5lA74/oBxLGNoEqjNA==
X-Received: by 2002:a17:902:7b8d:: with SMTP id w13mr29476532pll.145.1559857329502;
        Thu, 06 Jun 2019 14:42:09 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id u20sm93646pfm.145.2019.06.06.14.42.09
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 06 Jun 2019 14:42:09 -0700 (PDT)
Date:   Thu, 6 Jun 2019 14:42:01 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Roman Mashak <mrv@mojatatu.com>
Cc:     netdev@vger.kernel.org, kernel@mojatatu.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us
Subject: Re: [PATCH iproute2 1/1] tc: Fix binding of gact action by index.
Message-ID: <20190606144201.3ff30999@hermes.lan>
In-Reply-To: <1559856729-32376-1-git-send-email-mrv@mojatatu.com>
References: <1559856729-32376-1-git-send-email-mrv@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  6 Jun 2019 17:32:09 -0400
Roman Mashak <mrv@mojatatu.com> wrote:

> The following operation fails:
> % sudo tc actions add action pipe index 1
> % sudo tc filter add dev lo parent ffff: \
>        protocol ip pref 10 u32 match ip src 127.0.0.2 \
>        flowid 1:10 action gact index 1
> 
> Bad action type index
> Usage: ... gact <ACTION> [RAND] [INDEX]
> Where:  ACTION := reclassify | drop | continue | pass | pipe |
>                   goto chain <CHAIN_INDEX> | jump <JUMP_COUNT>
>         RAND := random <RANDTYPE> <ACTION> <VAL>
>         RANDTYPE := netrand | determ
>         VAL : = value not exceeding 10000
>         JUMP_COUNT := Absolute jump from start of action list
>         INDEX := index value used
> 
> However, passing a control action of gact rule during filter binding works:
> 
> % sudo tc filter add dev lo parent ffff: \
>        protocol ip pref 10 u32 match ip src 127.0.0.2 \
>        flowid 1:10 action gact pipe index 1
> 
> Binding by reference, i.e. by index, has to consistently work with
> any tc action.
> 
> Since tc is sensitive to the order of keywords passed on the command line,
> we can teach gact to skip parsing arguments as soon as it sees 'gact'
> followed by 'index' keyword. 
> 
> Signed-off-by: Roman Mashak <mrv@mojatatu.com>
> ---

Applied
