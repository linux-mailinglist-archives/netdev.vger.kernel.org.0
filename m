Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72EAC3BEE4
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 23:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389916AbfFJVrV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 17:47:21 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:37013 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387661AbfFJVrV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 17:47:21 -0400
Received: by mail-pg1-f196.google.com with SMTP id 20so5725208pgr.4
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 14:47:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=da4PcuyPJSvKfZbGLxUE+1YW72Qq0aTyGXY7sgxEFdk=;
        b=hOHPyloE2x/poJ8Mr9W53EGn/MgIQ51MkA6ZJPL9/vaxaEMRx3p57MG5QrWo38swNO
         AiYSd8QB+PjG/wKih6uAq78i5Q6CZp/mhr+PfzGnN2Frxmr7EDqshGO36O4wRcGbpqrA
         9zr5Mj2XIpdVWizEqbILYVMwP0vtsFnaqrPZOz7DKihyMu0vOiglRpEsiwjcfxnsUMrv
         MaCy4/sUbGCV3X5EV/DCvC0uTxipr3t4VgTq4uq/aRHawEDwTdAZxjYiur86QqssWHzb
         9csHq2497ZwzAt1jNrmp8/IS9SOBVbPnRnDBfrPY+dGx5okL+MD/QNJ7EoSAVb8JnP4P
         rUVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=da4PcuyPJSvKfZbGLxUE+1YW72Qq0aTyGXY7sgxEFdk=;
        b=Qs1Ke5ecGzMQ+YfNQ938kgNOyq3YO0NaUlwe3GriwoIXIVhisMNIWOA/NslpIOZp8t
         t8WJ5G/KIVL6tke4pEPmp9AKzxpym8z/6I79NQS3Ru0NlhZgwYJBzIZOQXv2o7gdinsH
         Fq3DKuu/rlVGEO+SbAvfFzWf7GvllTzdarqe3P7mcd9Uv9255OmldMAGoU1fx+bv2BOn
         aKAugqd4Ev2gQM8D1hjNCCDzXGPIY/8iCrt6GzlXcV4FCwBL3SNfHIUwISRG+oxDcGxp
         SqQLY+1fJvDNXObb+5OBCfk9l5H7pBAwslIG6ENDEA6FGRpk/V3CSfwW7wj/ocTIdbNb
         QCkg==
X-Gm-Message-State: APjAAAWSL/ahbXH8G2BcGyGUsfNvLFvDsBLyGdOZZW59hRDanZ+n6CI5
        3sYtVkk/HftDXNVOSHJyok4CE6WJOfg=
X-Google-Smtp-Source: APXvYqzOjbrOBsTRxruCy9cpuknzgyPFc3C442XKBhdrXwO6aBHOAoa0HArA3m3tNUcJjMcj3HKEXA==
X-Received: by 2002:a63:1b65:: with SMTP id b37mr17364048pgm.408.1560203240462;
        Mon, 10 Jun 2019 14:47:20 -0700 (PDT)
Received: from [172.27.227.182] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id b66sm13945648pfa.77.2019.06.10.14.47.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Jun 2019 14:47:19 -0700 (PDT)
Subject: Re: [PATCH net v3 1/2] ipv6: Dump route exceptions too in
 rt6_dump_route()
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     David Miller <davem@davemloft.net>, Jianlin Shi <jishi@redhat.com>,
        Wei Wang <weiwan@google.com>, Martin KaFai Lau <kafai@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        netdev@vger.kernel.org
References: <cover.1560016091.git.sbrivio@redhat.com>
 <f5ca22e91017e90842ee00aa4fd41dcdf7a6e99b.1560016091.git.sbrivio@redhat.com>
 <35689c52-0969-0103-663b-c9f909f4c727@gmail.com>
 <20190610234502.41949c97@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <91d0b4a4-46ba-5dd0-e387-c9a0ba195506@gmail.com>
Date:   Mon, 10 Jun 2019 15:47:16 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190610234502.41949c97@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/10/19 3:45 PM, Stefano Brivio wrote:
> Indeed, we don't have to add much: just make this work for IPv4 too,
> honour NLM_F_MATCH, and skip filtering (further optimisation) on
> NLM_F_DUMP_FILTERED in iproute2 (ip neigh already uses that).

you can't. Not all of iproute2's filter options are handled by the
kernel (and nor should they be).
