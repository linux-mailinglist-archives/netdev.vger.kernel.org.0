Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AA20289233
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 21:49:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388822AbgJITt3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 15:49:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726357AbgJITt3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 15:49:29 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02797C0613D2;
        Fri,  9 Oct 2020 12:49:29 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id q9so11315133iow.6;
        Fri, 09 Oct 2020 12:49:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=haLh6SHjWi8U3D1Pyc28km+ybtATBc38N6RMdxr91ug=;
        b=PEF+vX1k0tDlZjhydR4BLCrw4StHPPoqREBrrHEFDLAd/9PQVfBn5u/oKlaUWhE/iA
         it0uLF1ApFZicN2v/GAvWVtYaz8AO/fUMAmnnb6jEumB4DO8mYiWNdTudPuu0Zu2A/5t
         Za913nvdenmvWFX6QdYHbTdfxO+/sCovhRuaJa+cPCojHIooQkcWaHdAwV+KfaQ3NCFo
         XO2S2LiTTei7fChwSDCYknYiyvfGY+QDIIobA0FymxO2mU5ltGl9mYcOGn87hN/WZaXz
         yjkh775KymMHIXTq0YlXdxePOB0lxw1UmR7wirZ4oIxlX8B9SY1fVV2ujUf37qYUn9gv
         BMEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=haLh6SHjWi8U3D1Pyc28km+ybtATBc38N6RMdxr91ug=;
        b=iMAsNvzhEnBHeGP4l8nafcc6DuuB0Gw2iyCEJw8va8DwHXZuU/iBH18EsCuohgqaT8
         BCSG8hEF85T/FA6MPD/QTQHoJxO9D1HJCODbimgTSDCvPX1PIqPQSxQLNeH/W18USaZZ
         FjzlwuHedPqGj60Yd1niYvrHNw7IyX+TWML30X/vlc8Eb63fyuAmX/6ELOsFibPMKliM
         D0qYw4toueIZp+Qc8ONUnV6N4O+UBHCnkvdAbXcTixEcltEoMqN2RTSY2KGIOnKAHb2T
         gHoZuqm70iukkpgH8Ypcu6b/NYW746LwDykOLB08fD0h01RLUeEgLFhL+t+fEXtlN8Oj
         WV3Q==
X-Gm-Message-State: AOAM531qWkleORxLE9nxUSPNpHeY9TCAh+YfohjwQ560Xuypqcs1ztN+
        b/EoU7DxDlY4qns/CR2TPWszwQAf/8fZWA==
X-Google-Smtp-Source: ABdhPJxrlxwyQk+ImhV2V9VlfEC/lHmk0SPQqCiTd1d0Jx3jayHaMFAZZPM/TFoBp8bPKe1uQvq22A==
X-Received: by 2002:a6b:c94f:: with SMTP id z76mr10042990iof.88.1602272968347;
        Fri, 09 Oct 2020 12:49:28 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id m13sm2035229ioo.9.2020.10.09.12.49.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2020 12:49:27 -0700 (PDT)
Date:   Fri, 09 Oct 2020 12:49:20 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        davem@davemloft.net
Cc:     daniel@iogearbox.net, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Message-ID: <5f80bec0c60a0_ed7420896@john-XPS-13-9370.notmuch>
In-Reply-To: <20201009011240.48506-3-alexei.starovoitov@gmail.com>
References: <20201009011240.48506-1-alexei.starovoitov@gmail.com>
 <20201009011240.48506-3-alexei.starovoitov@gmail.com>
Subject: RE: [PATCH v2 bpf-next 2/4] bpf: Track spill/fill of bounded scalars.
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov wrote:
> From: Yonghong Song <yhs@fb.com>
> 
> Under register pressure the llvm may spill registers with bounds into the stack.
> The verifier has to track them through spill/fill otherwise many kinds of bound
> errors will be seen. The spill/fill of induction variables was already
> happening. This patch extends this logic from tracking spill/fill of a constant
> into any bounded register. There is no need to track spill/fill of unbounded,
> since no new information will be retrieved from the stack during register fill.
> 
> Though extra stack difference could cause state pruning to be less effective, no
> adverse affects were seen from this patch on selftests and on cilium programs.
> 
> Signed-off-by: Yonghong Song <yhs@fb.com>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> Acked-by: Andrii Nakryiko <andrii@kernel.org>
> ---
>  kernel/bpf/verifier.c | 16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)

LGTM and will be useful.

Acked-by: John Fastabend <john.fastabend@gmail.com>
