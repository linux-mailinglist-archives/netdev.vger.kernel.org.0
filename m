Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4995E2DC97A
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 00:12:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730335AbgLPXM4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 18:12:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730311AbgLPXMz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 18:12:55 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BA39C061794;
        Wed, 16 Dec 2020 15:12:15 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id d13so6496848wrc.13;
        Wed, 16 Dec 2020 15:12:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OMrxFqhSzJUt3S3zEXkhepxE3kDtdjVy10vlL12sgk0=;
        b=JDF7QZyA4D1iEjbk7g310/J/btwOxB7/fFfLD0HqjdgjwnkOSqfjLrfbOfv/CictJT
         VpaSm/ClekrTlnnL6igu5aBEoKzbxCk3nwZir5XQGFOgGKltkI7VaG1BazoV0aFhLghO
         ZlZ8sS6mlriw64p+xYXjTC9KCToCGeKboM7pdCy5xxDE50/F4EGACGHwc5b4rkgB8rB/
         QPEAkh1YH4JC0Qd1EUfe4RP9TvHf6TFmbKCCorxD3cisaO6sksiGyRcYRSBryiCwmC6+
         IrkMx/lLBjIlcawCFDftHNcqj3JJOPJLYzr9HX4bsFk+8klVcmHWsV25iQRguO8hOGfq
         E54w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OMrxFqhSzJUt3S3zEXkhepxE3kDtdjVy10vlL12sgk0=;
        b=ZkBgZS4YwYGqpL8oWzQfIM7lilpnDOb61UPlhOzy+X04oagiimBo73I1JAy9DDqMud
         aeKwBF7WGfr98/haCiRwxPSW5/WGARqL0dQXKAtC5oGNVlv3FXltv0hIHQE3IFdxWYb6
         6n/bY5eWWJvCgyckh1RNeNdGQmrawbeR/tFUQeNrGvWn2gy3Gnj6tr6IGs8zyPC3+cMN
         na7h2Z2jgBk8vCXFDFh1ysuJiMv0N60KGB+tL+R5nk+aWjmS1X57B5Bh710OfVqPCxp+
         Y6FalxNJp4cidS1CAsSBmLdYw/Jpt+7COYBhjM21T5Rvc2nod20q9jbL3mEA5RDZiils
         /OIA==
X-Gm-Message-State: AOAM531kEBHdQ7mzg4NwmwdCKS+4l95DcNNiP7K1M9t4+aRxUjYXiBIO
        RPRQd7VTPasnLnbnyb5t/+0=
X-Google-Smtp-Source: ABdhPJzF9hoDupK2p/0qDFkMHRtl5GGwjy1hCtt51rFnzOHLJJN0//PxUQJU6EwWxwO/9VICAaD40A==
X-Received: by 2002:adf:e710:: with SMTP id c16mr41012800wrm.295.1608160334174;
        Wed, 16 Dec 2020 15:12:14 -0800 (PST)
Received: from [80.5.128.40] (cpc108961-cmbg20-2-0-cust39.5-4.cable.virginm.net. [80.5.128.40])
        by smtp.gmail.com with ESMTPSA id k18sm6095339wrd.45.2020.12.16.15.12.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Dec 2020 15:12:13 -0800 (PST)
Subject: Re: [PATCH net-next] sfc: reduce the number of requested xdp ev
 queues
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Ivan Babrou <ivan@cloudflare.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@cloudflare.com,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Marek Majtyka <marekx.majtyka@intel.com>
References: <20201215012907.3062-1-ivan@cloudflare.com>
 <20201215104327.2be76156@carbon>
 <205ba636-f180-3003-a41c-828e1fe1a13b@gmail.com>
 <20201216094524.0c6e521c@carbon>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <2438e8ee-99ad-167d-d00c-fc208ba7caa9@gmail.com>
Date:   Wed, 16 Dec 2020 23:12:12 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201216094524.0c6e521c@carbon>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16/12/2020 08:45, Jesper Dangaard Brouer wrote:
> So, what I hear is that this fix is just pampering over the real issue.
Yes, it is, but it's better than nothing in the meantime while we work
 out the complete fix.

> I suggest that you/we detect the situation, and have a code path that
> will take a lock (per 16 packets bulk) and solve the issue.
Imho that would _also_ paper over the issue, because it would mean the
 system degraded to a lower performance mode of operation, while still
 appearing to support XDP_TX.  I think that that in general should not
 happen unless there is a way for the user to determine at runtime
 whether it has/should happen.  Perhaps Marek's new XDP feature flags
 could include a "tx-lockless" flag to indicate this?

-ed
