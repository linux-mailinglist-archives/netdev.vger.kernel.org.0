Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 002B351BB2
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 21:49:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731137AbfFXTtk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 15:49:40 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:40722 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728549AbfFXTtj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 15:49:39 -0400
Received: by mail-io1-f66.google.com with SMTP id n5so4834940ioc.7;
        Mon, 24 Jun 2019 12:49:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NZu4O00NPZleuCWXITSxnWW1rGLa66653MvVC+wHLmw=;
        b=jVeSXiVsHVu2ouD9U37An682AZzAmmkFDiJ+LkM6/EftdC972P9MeMDquhfc5L4lZL
         j18MoUvN4XjKZXE8rOAlSmSh2ypQaGsQoNcsFVIgUXlQDhNWGg0oUi9l+paz44faPa3+
         7pEB3QBX417I/pQ+SqxPYr+HKmEHMeM8Jy5nKjXEC88TEMrlxO01uMszzLY9Li5eIOBt
         q+Kju30heEn6reuItzwtS+hr+qVrMPOrn7MbwoleSpbDniuYdJtHhFZjPnTmf+jmD8MS
         lf4UlMnZew435rZg9jB3TiwL33OJLG1VQlSaLpWEO+3P/OpW1E6aF9XKP52g89geYsfX
         dVqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NZu4O00NPZleuCWXITSxnWW1rGLa66653MvVC+wHLmw=;
        b=lVkKH6ziGeWS1YGXBuqHOtlS9aX0D0bfhylGJLDaCRUHKPVZHgJc35bRMzFVU9I9Iy
         d9wMRe/sl203f7mIHlWTJ8jF+Yxacew2uvGMrF2KCAmngs2LgzhHZy218MYnpdmveql1
         aIygR8Zt+e32kG13S0ABGNHuAPq5PPiKJOOCKnooD+vvjMXAlBEJ4/kGptRGQfeAOy65
         Md7Z6TvAwneX1otjyc8wqJ/LOsqNPZedrZo6QLsCSVOXf99yIZbYCqghmnAScR0MeLuE
         nImUctd4ODJCNivC35jtxJA0qjtCEoutL0EktM7fOCOhBcTxRw+IqJL+3+eKpCYiSjPW
         bwVw==
X-Gm-Message-State: APjAAAU6FcO0+uY658J2mBXMPS1vyjIaKdxq37+Xx0QBjzo8oUzBepBE
        IDBS7bPx2mJ96jGHJB69j/BQp5Mi
X-Google-Smtp-Source: APXvYqwxzKpMjHARD9RmDR1Id9qihaizxqLIei0rShn3JXXydBhIZ5G7UVmfyA/1PL1Yfe9SW0G+Cg==
X-Received: by 2002:a5e:8508:: with SMTP id i8mr17447890ioj.108.1561405778305;
        Mon, 24 Jun 2019 12:49:38 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:f558:9f3d:eff4:2876? ([2601:282:800:fd80:f558:9f3d:eff4:2876])
        by smtp.googlemail.com with ESMTPSA id e188sm18389354ioa.3.2019.06.24.12.49.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Jun 2019 12:49:37 -0700 (PDT)
Subject: Re: [PATCH net-next] ipv4: enable route flushing in network
 namespaces
To:     Christian Brauner <christian@brauner.io>, davem@davemloft.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
References: <20190624132923.16792-1-christian@brauner.io>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <56ed92eb-14db-789a-c226-cdf8a5862e61@gmail.com>
Date:   Mon, 24 Jun 2019 13:49:33 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190624132923.16792-1-christian@brauner.io>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/24/19 7:29 AM, Christian Brauner wrote:
> Tools such as vpnc try to flush routes when run inside network
> namespaces by writing 1 into /proc/sys/net/ipv4/route/flush. This
> currently does not work because flush is not enabled in non-initial
> network namespaces.
> Since routes are per network namespace it is safe to enable
> /proc/sys/net/ipv4/route/flush in there.
> 
> Link: https://github.com/lxc/lxd/issues/4257
> Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
> ---
>  net/ipv4/route.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 

why not teach vpnc to use rtnetlink and then add a flush option to
RTM_DELROUTE?

