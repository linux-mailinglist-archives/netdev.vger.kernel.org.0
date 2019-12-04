Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F6E3113546
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 19:58:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728105AbfLDS6s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 13:58:48 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:34658 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727978AbfLDS6r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 13:58:47 -0500
Received: by mail-pg1-f195.google.com with SMTP id r11so308685pgf.1
        for <netdev@vger.kernel.org>; Wed, 04 Dec 2019 10:58:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eH3HTsGQ47GyQqKA92RBuqmGmafmoTDlDTa1lrHmFuc=;
        b=EgRUbp41uo7BVpa2A0NLDs+D/WgngowoL9Nul+Zp6W3XRM2xypleq6d5F8kaE7P2SL
         9WP4Zl8RpD1/zonuOQf/PMuLDhPHfbnYP5rD1JllPh848RKbfxazsaAvtg+v6acMRP/4
         sTAXxUpB1TsxgdQFpTdkrE3dkMSzHYiNrk02bNcJzuDJ/KHuPT0N+UM3OBbCiCUWZdM3
         ms+A6y951IAlbaK0Etdbggjlgk+ABheOR3zq9V2TtCDzE26dXt4Vu17PxhqbP0MWn8cB
         mlVF3C4jyggHxyLYCtgCIQhBPlKVwyi86oRzOQiNTXKEjkXzQkoQ++2Vk7TABnQT9ERt
         UlyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eH3HTsGQ47GyQqKA92RBuqmGmafmoTDlDTa1lrHmFuc=;
        b=eWpQhXj2eQUIPMEzMP6rwpUzzsYRD3Bx2vMDU9AxqEXs8Nbs8yamCzOeUGm1qyeL3p
         APR4y+PEgU6mCxsu5Xdd8K7UW2Fs4gXr2skC1AnxYH+sSzk/bs3kprp2XPTy6mjSWKiP
         sYZRtke5BdwjCXa6vENYLfZ63I0zDbYXnFTIz5ADICFzaQTPbYGrHRHpq1D+jkwrSUN/
         NwL+IDmdy8DJ9IMPN468lJW8ghFlCb/tlfhfkRhirJzWJAmAHQLtlYvEKlL+uFVoVbAb
         qihvM+mFKTXQ0UULGlPCEYzp7T1NN5gIatapHJNBRAXvOBqnQ3Facy++VftDTR4MxvlJ
         vaSA==
X-Gm-Message-State: APjAAAUGFrtKN1v7NsUaPqHr661g7vdK2lrxGHrlJm0L8r3OSODcRCoP
        NbDCGtrOYcJXhEqnPiqNUR5glw==
X-Google-Smtp-Source: APXvYqwqYYlI+xJOB1aMinjK4WEL1T/hPOnLGmi+bY/rK/CVM9B0fetQ4+flaQvoHJvpXflKRKcugQ==
X-Received: by 2002:a65:4344:: with SMTP id k4mr4987459pgq.193.1575485927162;
        Wed, 04 Dec 2019 10:58:47 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id e1sm9407125pfl.98.2019.12.04.10.58.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Dec 2019 10:58:46 -0800 (PST)
Date:   Wed, 4 Dec 2019 10:58:37 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     David Ahern <dsahern@gmail.com>, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH iproute2] tc_util: support TCA_STATS_PKT64 attribute
Message-ID: <20191204105837.790d6d51@hermes.lan>
In-Reply-To: <20191203154701.187275-1-edumazet@google.com>
References: <20191203154701.187275-1-edumazet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  3 Dec 2019 07:47:01 -0800
Eric Dumazet <edumazet@google.com> wrote:

> Kernel exports 64bit packet counters for qdisc/class stats in linux-5.5
> 
> Tested:
> 
> $ tc -s -d qd sh dev eth1 | grep pkt
>  Sent 4041158922097 bytes 46393862190 pkt (dropped 0, overlimits 0 requeues 2072)
>  Sent 501362903764 bytes 5762621697 pkt (dropped 0, overlimits 0 requeues 247)
>  Sent 533282357858 bytes 6128246542 pkt (dropped 0, overlimits 0 requeues 329)
>  Sent 515878280709 bytes 5875638916 pkt (dropped 0, overlimits 0 requeues 267)
>  Sent 516221011694 bytes 5933395197 pkt (dropped 0, overlimits 0 requeues 258)
>  Sent 513175109761 bytes 5898402114 pkt (dropped 0, overlimits 0 requeues 231)
>  Sent 480207942964 bytes 5519535407 pkt (dropped 0, overlimits 0 requeues 229)
>  Sent 483111196765 bytes 5552917950 pkt (dropped 0, overlimits 0 requeues 240)
>  Sent 497920120322 bytes 5723104387 pkt (dropped 0, overlimits 0 requeues 271)
> $ tc -s -d cl sh dev eth1 | grep pkt
>  Sent 513196316238 bytes 5898645862 pkt (dropped 0, overlimits 0 requeues 231)
>  Sent 533304444981 bytes 6128500406 pkt (dropped 0, overlimits 0 requeues 329)
>  Sent 480227709687 bytes 5519762597 pkt (dropped 0, overlimits 0 requeues 229)
>  Sent 501383660279 bytes 5762860276 pkt (dropped 0, overlimits 0 requeues 247)
>  Sent 483131168192 bytes 5553147506 pkt (dropped 0, overlimits 0 requeues 240)
>  Sent 515899485505 bytes 5875882649 pkt (dropped 0, overlimits 0 requeues 267)
>  Sent 497940747031 bytes 5723341475 pkt (dropped 0, overlimits 0 requeues 271)
>  Sent 516242376893 bytes 5933640774 pkt (dropped 0, overlimits 0 requeues 258)
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> ---
>  tc/tc_util.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)

Applied.
