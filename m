Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC0DA5A762
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 01:07:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbfF1XHf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 19:07:35 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:46671 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbfF1XHf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 19:07:35 -0400
Received: by mail-io1-f68.google.com with SMTP id i10so2099982iol.13
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 16:07:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tuvJMR8XoDcVCNv9OJP6f929fRoUaazorNX1BHf35x4=;
        b=kxT1Htam2/DGFkvQlEZCApMRgO256UuZE6leUf3+1M+4ec+zWPHRyiDGagi3ot0KCN
         5gGtQYiJn66GcVsjK3UUGAMFJcIMt4MI2uZRhQewjCKl/CQ/VPe4K6JisH94y27RMbDi
         do00CwQ+BtNqKrygqRPHsZCVm2wHntBCih6/ERcR4GaQlaSYvzXn2ra2Ht1D9sI+xxA/
         5LC4GHbctveZcC6oTVtVcvYTJicAN10d3mvwASRyl4sLRH8//g0O0KPd3ZQ+GrHphmn7
         Se8Le50dT9U2rFXkC1WPWhG3MTELiFjHWOYRU9xp2L8/IqWn+bwFOG0oeYgMInEM0yPr
         0Vaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tuvJMR8XoDcVCNv9OJP6f929fRoUaazorNX1BHf35x4=;
        b=TCytAWQDAfdnyVPNegTEF6nNw/k9K8zvh5kfXNWWuRjVsW8xSu96hNJBjbNi+mViKq
         vQHTJ7jgUjoUL+EC3ZY/BKKIbEH5+sYhU+ifHaZo80pyyipZtufaD25dmcPb3tYYWl3r
         Kq5gzIMsGLpN+6TWtTr3xPR/pSI5p/65vU9zQBVJgqH/qi+0tI/WKSL084087vffX8uo
         4uB5VeWm9aKejc2rDj8X3uKvIFBVKGh85+XUdFpK6Z3sP4BsyBqTtng5aVpYu/pck2cC
         AwlyAZBPhqmkQgqtFFovipKUViShi99KLfJlM9AcXwhG/bRyEwslSnT59JxusiFspQ5L
         EEhg==
X-Gm-Message-State: APjAAAUFIfoMQIeT/IHN3YJzRTxYu52JvAq8RbfcurK9V1Qk7KM7/ptO
        H1wqpx76jIa8RRIe0hLhUMY=
X-Google-Smtp-Source: APXvYqxqBirQVbPHKG1mDNETLT7ql+WWpSKPpI79wHnfheBBTjHct2/Qs+bVToaeIR2c/dMPSkIjVg==
X-Received: by 2002:a6b:e608:: with SMTP id g8mr13406144ioh.88.1561763254344;
        Fri, 28 Jun 2019 16:07:34 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:a468:85d6:9e2b:8578? ([2601:282:800:fd80:a468:85d6:9e2b:8578])
        by smtp.googlemail.com with ESMTPSA id f17sm3279097ioc.2.2019.06.28.16.07.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 28 Jun 2019 16:07:33 -0700 (PDT)
Subject: Re: [PATCH iproute2-next] utils: move parse_percent() to tc_util
To:     Andrea Claudi <aclaudi@redhat.com>, netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@kernel.org
References: <e9e070178cdd26588800b43938647b7b338c2142.1561737608.git.aclaudi@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <d6b2dc2f-dab8-e5bf-abbe-f5e4b83db4e8@gmail.com>
Date:   Fri, 28 Jun 2019 17:07:32 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <e9e070178cdd26588800b43938647b7b338c2142.1561737608.git.aclaudi@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/28/19 10:03 AM, Andrea Claudi wrote:
> As parse_percent() is used only in tc.
> 
> This reduces ip, bridge and genl binaries size:
> 
> $ bloat-o-meter -t bridge/bridge bridge/bridge.new
> add/remove: 0/1 grow/shrink: 0/0 up/down: 0/-109 (-109)
> Total: Before=50973, After=50864, chg -0.21%
> 
> $ bloat-o-meter -t genl/genl genl/genl.new
> add/remove: 0/1 grow/shrink: 0/0 up/down: 0/-109 (-109)
> Total: Before=30298, After=30189, chg -0.36%
> 
> $ bloat-o-meter ip/ip ip/ip.new
> add/remove: 0/1 grow/shrink: 0/0 up/down: 0/-109 (-109)
> Total: Before=674164, After=674055, chg -0.02%
> 
> Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
> ---
>  include/utils.h |  1 -
>  lib/utils.c     | 16 ----------------
>  tc/tc_util.c    | 16 ++++++++++++++++
>  tc/tc_util.h    |  1 +
>  4 files changed, 17 insertions(+), 17 deletions(-)
> 

applied to iproute2-next. Thanks


