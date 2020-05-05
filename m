Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56D061C5E4E
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 19:05:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730488AbgEERFW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 13:05:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729726AbgEERFW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 13:05:22 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23274C061A0F
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 10:05:22 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id s8so1339904pgq.1
        for <netdev@vger.kernel.org>; Tue, 05 May 2020 10:05:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=10hWDYwaqggRnPTOARkpEpeTQmgCUbPwzEBQUQH1n6I=;
        b=ILB/Eh4h0lyJHs1IedfOKn2LkZOzNFe+gPKH/04WETvADXH/O6QkLmKssyegj850Oe
         27iQs06p+ZkVdOSlCS/21bOPwBRO4Hf4GZditaO5T3jkPLSTHt8x9QPfgS8j6pTJVhsn
         hblOJrNi3vGlWfFuYWNZ/ERJo/Iz3Q1EAAdiveIC0jzV6GwkOGuo7Ti1Anvc5hCu5Shf
         LgqlAePtsj/QKzPLUFU2B3rZwjDqlbI10caYObKRT75OwjeGNzxkKWBtGYFO1tr26WgI
         YeMp19vsUGCsvus91X7VROiqOz7TVPeeipB+1G0ehrT77yirV8xPrQSppoxTxDHpdw/U
         Adfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=10hWDYwaqggRnPTOARkpEpeTQmgCUbPwzEBQUQH1n6I=;
        b=nkWputD4obrK1mScBIY/EE+wsVSa1dSuGLK8Z4kbGC5zHfj9MSdJe91wYuQy999N9z
         BMLQ7UA8OXIZMXmJynm2yaFBMdCwxaP7IHMAr75q7dGahfEnz+itjR55pe0eer81OOkm
         YgLIN8zqbFNwjzL0dw/Z/sjKIjwwWCMyXK1fdbg1s14QMF/4/qxfUr9UvtR8sczKgq44
         sc5hiVYP2MuEZa/Zq3YfHGt0oPtERxWIp4BvZD8/HxULVF2HRvHxjF7XRqmi7FqY61z2
         QdUrqK+w53cpL//69R0BLqq+1tnqOPmQXF498Rei1xpOro91pZ3XBczRLKS3Ce3/LNLv
         NWYg==
X-Gm-Message-State: AGi0PuZFcqUIK3wbCvleMquA1D0e2JqniNs86U0kjrG/RF7kaisOODu2
        aQvxi6eSxfX51l+STeZxZIVpTQ==
X-Google-Smtp-Source: APiQypIe1WQaEvXtAlmgnhuzAWQ0jnbq6ECrNqS25fOVYEDwq9ZoeQqfUFveibukUAyODVp6SnrRJw==
X-Received: by 2002:aa7:8593:: with SMTP id w19mr4038258pfn.97.1588698321497;
        Tue, 05 May 2020 10:05:21 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id m3sm2372788pjs.17.2020.05.05.10.05.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 10:05:20 -0700 (PDT)
Date:   Tue, 5 May 2020 10:05:12 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     David Ahern <dsahern@gmail.com>, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH iproute2] ss: add support for Gbit speeds in sprint_bw()
Message-ID: <20200505100512.5b0d647e@hermes.lan>
In-Reply-To: <20200505153741.223354-1-edumazet@google.com>
References: <20200505153741.223354-1-edumazet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  5 May 2020 08:37:41 -0700
Eric Dumazet <edumazet@google.com> wrote:

> Also use 'g' specifier instead of 'f' to remove trailing zeros,
> and increase precision.
> 
> Examples of output :
>  Before        After
>  8.0Kbps       8Kbps
>  9.9Mbps       9.92Mbps
>  55001Mbps     55Gbps
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied, and add terrabit as well.

It looks like tc and ss are not the same in suffix here.

https://en.wikipedia.org/wiki/Data-rate_units

kilobit per sec  = kbit/sec or kb/s = kbps
kilobyte per sec = kB/s
megabit per sec  = Mbit/sec or Mb/s = Mbps

For now, lets get ss to follow the standard. 
That means "kbps" instead of "Kbps"


