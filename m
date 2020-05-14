Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB5331D2411
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 02:48:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729047AbgENAsA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 20:48:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728481AbgENAr7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 20:47:59 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6466DC061A0C
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 17:47:59 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id t16so495708plo.7
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 17:47:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1I2Pj2r1I6LjNaRJaV/MUBkckKeQ0mKgZQSrVaAo2YI=;
        b=r28j7TG/1mkQljOFbRq13e/S4Edx6Rh/lCuvc+dAyzyuiVyfl/fPYeK2d9QBdnGDd9
         8nbQuNhRjMXmAwUoLZylJd7i9hSq9cNXX+10Y+uPNBdOeMIyVfAgbv1K+6uKgkWOEBpH
         8kcGkx4uO7O7cLd6mRAa8Bik62vFzotwFQ0/Uox1+pqKo7E1/DvxdGNgvoz6loQOg+4M
         nc4m16WvOcTXDjtLVTk7lzGCzToUeGay2X7TafAjAtBNLlboAvkGoOjx+0s3bxpHhAeW
         l9ylKtxEikz7eajUBm1mfXd0spYUntZgknEHAVrn8P1ZIoEXOZ3lobFiN2ICg+EkDr71
         KzMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1I2Pj2r1I6LjNaRJaV/MUBkckKeQ0mKgZQSrVaAo2YI=;
        b=I+4NKVG9rgNJt280Sbp00n4YfzGc0JA6CocaCIWm/pUE/kJLR7/02x9OiOzu1RkPpu
         /fSXqA6DU+3Vrro4TheCl8UE8+04lByfDFDqMpla8yD9lZgkP1g0XK6Ke/p71zMiY/bU
         JB3OZLVOfNeP8v87oHynE4oQ5BLWbptkDSWnxzwWgSGw9o3dZ1GJaXJ8c8/C+xOZrqas
         16YkBuU24x7JxdUJb2sSgTxSuiUKOL9Kt+4dUoL2xEzacDzWJqGKfFG9Wh3xybt4aREP
         1ewVErH4ABImyuRjHLGPD+Q/TUHNBGyON0ekIH0yOMy0wgu6V4yYWH2wNzqlpETcimIC
         xjhA==
X-Gm-Message-State: AGi0PuaULwjlMMR1xixoTYvwERypk69jjTz/ax1RPzFVG/C2Jfwnlt4q
        NbX7A/T+QZMQL21Hx7ap4Q2SSA==
X-Google-Smtp-Source: APiQypJGG2ZyM7N58G+XbShxRDQnex9KETtAUUVMnJtBjS1ORQNCsRGHDijq0mEnn7rqcxvwcMi50w==
X-Received: by 2002:a17:90b:b07:: with SMTP id bf7mr37827610pjb.231.1589417278897;
        Wed, 13 May 2020 17:47:58 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id t80sm657623pfc.23.2020.05.13.17.47.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 May 2020 17:47:58 -0700 (PDT)
Date:   Wed, 13 May 2020 17:47:50 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     dsahern@gmail.com, netdev@vger.kernel.org, kiran.patil@intel.com
Subject: Re: [PATCH iproute2-next] tc: mqprio: reject queues count/offset
 pair count higher than num_tc
Message-ID: <20200513174750.5ec971f0@hermes.lan>
In-Reply-To: <20200513194717.15363-1-maciej.fijalkowski@intel.com>
References: <20200513194717.15363-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 13 May 2020 21:47:17 +0200
Maciej Fijalkowski <maciej.fijalkowski@intel.com> wrote:

> Provide a sanity check that will make sure whether queues count/offset
> pair count will not exceed the actual number of TCs being created.
> 
> Example command that is invalid because there are 4 count/offset pairs
> whereas num_tc is only 2.
> 
>  # tc qdisc add dev enp96s0f0 root mqprio num_tc 2 map 0 0 0 0 1 1 1 1
> queues 4@0 4@4 4@8 4@12 hw 1 mode channel
> 
> Store the parsed count/offset pair count onto a dedicated variable that
> will be compared against opt.num_tc after all of the command line
> arguments were parsed. Bail out if this count is higher than opt.num_tc
> and let user know about it.
> 
> Drivers were swallowing such commands as they were iterating over
> count/offset pairs where num_tc was used as a delimiter, so this is not
> a big deal, but better catch such misconfiguration at the command line
> argument parsing level.
> 
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

This doesn't have to wait for iproute2-next.
Can pick it up on the master side (after review).
