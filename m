Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7270935D4C9
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 03:25:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238715AbhDMBZv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 21:25:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237792AbhDMBZu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 21:25:50 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D034C061574
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 18:25:30 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id nm3-20020a17090b19c3b029014e1bbf6c60so3938458pjb.4
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 18:25:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=XdOBuI7DEw0fulqmOwramoBH8yqxlwc/+oFM/+yUGE8=;
        b=H0WqkfP+YiAGfm14JBltGP7lqDjqCYiI/20mGVLUjpbBYVvpk7QzXuvkMiYHcdoeJJ
         BuqydOiH6T/AsRdXTKcbY1eb7uWnhOrwG56lpOPAHN3AyRnD+nh9/z3Bkk1AIJOnzNWM
         XD++jxDJzRstiaxCcRxVovRS5XiJCAjzj1k+67db/avRgdmGnRJhV7exQkwgzw5U6lqc
         iUKRXBHpmLkZQJ6w9MQrRQdy1qnIItXWLj9TNqg1nCwzXZDhYe46ZEnP1o34Ho4drsMR
         Ma+AWcblajFbNF0CJKu1RlKBRVR/muipNIdtiFT+j8dyDbxLbiyjEA2xbucQS5vhd11j
         nhKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=XdOBuI7DEw0fulqmOwramoBH8yqxlwc/+oFM/+yUGE8=;
        b=eMcr18B7qO1Mw3EatT8midSOivoB3xFsND9c8IAps5Ol311sF6DeU3U4Xozba6wXGy
         3E7c7zi/7DVbM3YyZpUgK26iqdcj6HmHHNRc+BM8BGEe6yCOWLriVmAcRoqIji0dMJJI
         lx2CXIjP2P56r+TQYYvdWhVXNq5ZTX8g/j3edFn0mt3OySdX9lpPcHU22Fj4+3yI5269
         Buu/dOODTBLl+XkAowzUlIlcQkp0iNahTp+ySvPUhypA8Zrt8QKMEltsDuugc4sju9Yf
         RAT2Gq6SDlu5gFnArsLmOyQkm9QijS2rcOGneJ48SlEgK4P4uT7uxj3ZWX3V2ualvU5l
         NEdg==
X-Gm-Message-State: AOAM532UvlCytORf4qlCrYQuUoIqoCuvk/EfAoadPPZH8iIwc+Vyhxgm
        8LuNsl9fD5f+DmcQ5/jkJVA=
X-Google-Smtp-Source: ABdhPJztQDNZkW92Nepe+VEMIhbW0sB5R276PhTtRdSbuQvTQYJ70a+JQXiLetIb7irg1tJ+N/qlug==
X-Received: by 2002:a17:902:e80e:b029:e4:b2b8:e36e with SMTP id u14-20020a170902e80eb02900e4b2b8e36emr29303606plg.45.1618277129587;
        Mon, 12 Apr 2021 18:25:29 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:35:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id i9sm551897pji.41.2021.04.12.18.25.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 18:25:29 -0700 (PDT)
Date:   Mon, 12 Apr 2021 18:25:27 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        drivers@pensando.io
Subject: Re: [PATCH net-next 0/8] ionic: hwstamp tweaks
Message-ID: <20210413012527.GA24198@hoboy.vegasvil.org>
References: <20210407232001.16670-1-snelson@pensando.io>
 <20210411153808.GB5719@hoboy.vegasvil.org>
 <5af0c4f1-82d6-a349-616d-0e92e10dd114@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5af0c4f1-82d6-a349-616d-0e92e10dd114@pensando.io>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 12, 2021 at 09:33:29AM -0700, Shannon Nelson wrote:
> If the original patches hadn't already been pulled into net-next, this is
> what I would have done.  My understanding is that once the patches have been
> pulled into the repo that we need to do delta patches, not new versions of
> the same patch, as folks don't normally like changing published tree
> history.

Oh, the series you posted on April 1 was merged on April 2 without any
review.  That seems surprising to me, but perhaps the development
tempo has increased.

Wow, and this delta series was also:

posted	Date: Wed,  7 Apr 2021 16:19:53 -0700
merged	Date: Thu, 08 Apr 2021 20:30:28 +0000

That is a pretty good turn around time, less that 24 hours!

Oh well, too late to add my Acked-by.

Thanks,
Richard
