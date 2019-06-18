Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A41874A7A3
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 18:52:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729878AbfFRQvw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 12:51:52 -0400
Received: from mail-pl1-f175.google.com ([209.85.214.175]:45058 "EHLO
        mail-pl1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729319AbfFRQvv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 12:51:51 -0400
Received: by mail-pl1-f175.google.com with SMTP id bi6so5936237plb.12
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 09:51:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FlltVR/XsALb+JL+y43zL1E8EKO/23686wqaMw7nrDM=;
        b=qQw8YSEWz6fylwKdPZbuQCh4hGX5F3mes+iiy6woz8BRf7P8X+E+dfFDk5Q2ZRqlWq
         JIb889J3fUnIt4nim3XITn38pYhpvTwr3AsMVltxlmr7EpfflKo4jIX9x2CkPGyU9Q1T
         jMIXgn2u7cysh6fbS8ci/MmIrlThkQ+zJZfQxnBLqTYs6KQGHxMIxucjoJfhH5usGk6f
         CNJAXnlPLQEESrX19KgAHSbZWwPnMX0xeE1a4m3cVx6tOpRCSinT6oOI9nK8+XFDjeoC
         hM0AmUGtiIXB/jd+uwOw8/J4/6uXES5RD+y7nHbAT5edSeXPZL1E5C6IbgM3pk8GULPt
         Eq6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FlltVR/XsALb+JL+y43zL1E8EKO/23686wqaMw7nrDM=;
        b=fMtyTI0gXuTXTbvQ7cZpu/WDTOu6SclZY/fuHy8DotV99A/FnhJsRqAQVWXwvTu4Cu
         vgE9520W5JqO6InSFzXx1Tm/bE45+quIh555OcW/naKWxWxTADOSwSH8MQJA5FNsYFMf
         eHJVWgmJt8Qa4mZlvzuX8CmriWZInQnQBTN8midMdaHLHhFJS6THEQA3VYOwcEXieTa/
         2Sh0jjZenuh0IoZAY6k08pCl1sVjri9r2oAMkUqTXKn8P98t7Rg3wNP1rEOJMcj14+kN
         RI+Fr3RNQzF96FC1mGpHFJczHKb2iwcxlOBBdGxGER8KXnIVxVEQLlYqxJKB3sITvWnR
         bgIg==
X-Gm-Message-State: APjAAAXjXAa9roBeGI1X+U7pc/rddkF+07C0u7+zqeP/+eQ+hM2Fi5kz
        Ijc7TbeAp3ZDvBfC6ppOh4Sc6A==
X-Google-Smtp-Source: APXvYqzXdzzCqU4+WWmyhrTT/BwhEe9Jl4njGcfsCfF9Wckc0YMWrSri3z1my0Q6BJo5CjT6xL/TTw==
X-Received: by 2002:a17:902:7d8d:: with SMTP id a13mr2110361plm.98.1560876710919;
        Tue, 18 Jun 2019 09:51:50 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id d5sm46075pgm.49.2019.06.18.09.51.50
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 18 Jun 2019 09:51:50 -0700 (PDT)
Date:   Tue, 18 Jun 2019 09:51:44 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Denis Kirjanov <kda@linux-powerpc.org>
Cc:     dledford@redhat.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, mkubecek@suse.cz
Subject: Re: [iproute2] ipaddress: correctly print a VF hw address in the
 IPoIB case
Message-ID: <20190618095144.4ef794a9@hermes.lan>
In-Reply-To: <20190615114056.100808-2-dkirjanov@suse.com>
References: <20190615114056.100808-1-dkirjanov@suse.com>
        <20190615114056.100808-2-dkirjanov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 15 Jun 2019 13:40:56 +0200
Denis Kirjanov <kda@linux-powerpc.org> wrote:

> diff --git a/include/uapi/linux/netdevice.h b/include/uapi/linux/netdevice.h
> index 86d961c9..aaa48818 100644
> --- a/include/uapi/linux/netdevice.h
> +++ b/include/uapi/linux/netdevice.h
> @@ -30,7 +30,7 @@
>  #include <linux/if_ether.h>
>  #include <linux/if_packet.h>
>  #include <linux/if_link.h>
> -
> +#include <linux/if_infiniband.h>

You can't modify kernel headers in iproute.
These are updated by a script and your change will get overwritten.

I did go ahead and put if_link.h and if_infiniband.h in already.
