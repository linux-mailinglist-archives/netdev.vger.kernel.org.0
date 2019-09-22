Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB0D3BA03E
	for <lists+netdev@lfdr.de>; Sun, 22 Sep 2019 04:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727207AbfIVCiR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Sep 2019 22:38:17 -0400
Received: from mail-pf1-f178.google.com ([209.85.210.178]:40134 "EHLO
        mail-pf1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727070AbfIVCiR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Sep 2019 22:38:17 -0400
Received: by mail-pf1-f178.google.com with SMTP id x127so6933753pfb.7
        for <netdev@vger.kernel.org>; Sat, 21 Sep 2019 19:38:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=CdOWm288fcMoY3tZk//COF58Y/SKss13S36ajLpx4Vc=;
        b=aw5WftYlxXBTk4Nez3bo0BIcGpQx8ca3lrIaSMcTxPmNEybmW7A/ebnwgdFerwWZRB
         kiDsHYol4JNV9qQF7RTgCftxG0a/Y6L9Fq/9QxbK1461eTuJWVEIjweppVSzwNb+H9dH
         ik6rtOEoMOe4MK0XR4K1xe4up/jxbBPQXxcnw900kh7iM4WKWDEO+cRFkQmN+Q7rQ1ZV
         orjkaUis/Syl1b95fPPh6eBaOlU0ZqNroZIAdPpmYThRb+7EfTFHTG5+YMMrlX3VUErB
         cYFifnm51X/uSDTNprhNes2ewWgdSnd3aX4opeK+uPjm292ufUgxgMW111PvNamXqW0A
         dW5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=CdOWm288fcMoY3tZk//COF58Y/SKss13S36ajLpx4Vc=;
        b=RqkMFKE7CYGqz86ho1GfvFeFM6pY/tW6ON+8yX2BOgVwh3CXCKKaCIh/KitD2wvZPs
         2wEHFZ43IEa0gaysedHlyxVpM7ph12Q3X06lwTpn1/djj4detwJYsxjRoJm0HYBMh+B9
         f9GjhVUC/RLWZPlP+7G8LYV7NTNNRzFMNlzLERLW4siNYKD++hn2iH+QdGUZf9cyuzdJ
         2/ZepmB3LGN/yS9ZAaXsBi4zfi56yCbifKxiaRSzoyZSUL9IAGYiBvWC21aN0HB3A/UK
         bUxIlxnrd3Er9sG7tMTqwDUaWL3DnDEQqL8Rb62CvWzX3b09vbvSc0mSIn6sbtxNG6cq
         VgTQ==
X-Gm-Message-State: APjAAAXQVWjRNVQewvc9/pNeN6NW9RHpR4cTij1o+HEGEtlNbyIijOiT
        uA1g4dWGWITCxorAfzV+cvsM+w==
X-Google-Smtp-Source: APXvYqxbo1JomFjRvgh97zfWGrymxuoTMC480h6hsaiPijpp/0aKyRc0n79a4cEKX6BzHI0c5ZVSvw==
X-Received: by 2002:a63:1c4b:: with SMTP id c11mr20151834pgm.216.1569119896759;
        Sat, 21 Sep 2019 19:38:16 -0700 (PDT)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id 6sm5861758pgt.94.2019.09.21.19.38.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Sep 2019 19:38:16 -0700 (PDT)
Date:   Sat, 21 Sep 2019 19:38:13 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [Patch net] net_sched: add policy validation for action
 attributes
Message-ID: <20190921193813.1c79c7b1@cakuba.netronome.com>
In-Reply-To: <20190919014443.32581-1-xiyou.wangcong@gmail.com>
References: <20190919014443.32581-1-xiyou.wangcong@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Sep 2019 18:44:43 -0700, Cong Wang wrote:
> Similar to commit 8b4c3cdd9dd8
> ("net: sched: Add policy validation for tc attributes"), we need
> to add proper policy validation for TC action attributes too.
> 
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Jamal Hadi Salim <jhs@mojatatu.com>
> Cc: Jiri Pirko <jiri@resnulli.us>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>

Applied, thank you! 

Queued for stable 5.2+ let me know if we should backport to long term
kernels, or not at all.
