Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71F5517C1DB
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 16:31:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727181AbgCFPbX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 10:31:23 -0500
Received: from mail-pj1-f48.google.com ([209.85.216.48]:53700 "EHLO
        mail-pj1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726259AbgCFPbX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 10:31:23 -0500
Received: by mail-pj1-f48.google.com with SMTP id cx7so1198988pjb.3;
        Fri, 06 Mar 2020 07:31:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=VVTONCjty9yQikB9/1FIuVouvZO5dACbDh+vLUoJC3Q=;
        b=fQgitdoCgLtWN3M8nTQPvrjKfQ2wgyWaZ/UhG1bSccHTykkV0UFPL+WlHRk94+n+9H
         w48DARnGYTmkc57RzGjGwk4S8OdlbGtHfbKwnvzDim1mYmFpoh41RUuIt6WV2IfzzA9U
         ROTGXHlZ4fLpRzUz5EPjydrJYTyfVtnboRm0k2lHClgR/u/9E6TaUslA9nbTYdf7cKeQ
         7tbqa2zMMb3rJPXCPTDdXZlfdm1BQInL0DGmsHEltFAGlUik7l9BGs/sxqwU6A37cBPy
         cAj3QioktAs9KyxGvCZSBIStNRLrTcu8sbFTawZ5q+Em2N4q2y0+N7CvVS00Y9rupbSY
         6yCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=VVTONCjty9yQikB9/1FIuVouvZO5dACbDh+vLUoJC3Q=;
        b=PDyEEgxcVviBN1Q23Lb04VMxiYW+hcuTEprFcxZm6JV/CDddEDQr5+AwwY6t1MpVs8
         t1kWMWGaiTJIpf9aQnHukwTQ7zGdOfqnBXWKHcXK55Bs/jF/r1CBV8Tv7++ym4gpOESH
         /XVx5nQKoTC6tDBq0ijoAGNhhZBpke1O7trq0hAXwF8HY2PbTXmBRCdek4XwNKOb47ak
         7/ZGpRtc5m0FFVX3I28qk9wsuwUUrOyDIea4wCGTpPxQfv/3HaHqAl2LPztawfreFqk9
         bxKJZLjTzAnid0sRHLw9kCtJ7hPWJbFRmV049mI1ssvcmcnqDtWtvMQIpooiv9Jw6xGJ
         BLXg==
X-Gm-Message-State: ANhLgQ2v3g8LJT6XcJUnrf0kTkvDHnKZJ9hZgO/poEPQefHmtiCLSYmf
        J8pTYFosu8qcx7t667aAC4M=
X-Google-Smtp-Source: ADFU+vta5drdjzqt7eYRNQPq2e1/++f24DY0V9eNOdAoiPlV/tXlFr2vClkyp5ANNT2OhhGRMn1EbQ==
X-Received: by 2002:a17:90a:2466:: with SMTP id h93mr4132885pje.177.1583508682021;
        Fri, 06 Mar 2020 07:31:22 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id d22sm10407517pja.14.2020.03.06.07.31.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2020 07:31:21 -0800 (PST)
Date:   Fri, 06 Mar 2020 07:31:12 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Lorenz Bauer <lmb@cloudflare.com>, john.fastabend@gmail.com,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     kernel-team@cloudflare.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <5e626cc0c86c1_17502acca07205b461@john-XPS-13-9370.notmuch>
In-Reply-To: <20200304101318.5225-9-lmb@cloudflare.com>
References: <20200304101318.5225-1-lmb@cloudflare.com>
 <20200304101318.5225-9-lmb@cloudflare.com>
Subject: RE: [PATCH bpf-next v3 08/12] bpf: sockmap: add UDP support
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenz Bauer wrote:
> Allow adding hashed UDP sockets to sockmaps.
> 
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---
>  net/core/sock_map.c | 37 +++++++++++++++++++++++++++++++++----
>  1 file changed, 33 insertions(+), 4 deletions(-)
> 

Acked-by: John Fastabend <john.fastabend@gmail.com>
