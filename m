Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53A413FD025
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 02:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242552AbhIAALv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 20:11:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243254AbhIAALk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 20:11:40 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 395CCC061224;
        Tue, 31 Aug 2021 17:10:38 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id n24so1796023ion.10;
        Tue, 31 Aug 2021 17:10:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=X+xLaI1L2IXkvthgdQq6b99QNFK4+VSFZAb1+U1cFes=;
        b=jT7xb+2mnbVQBWw0KaZ3i7w2HwCGO4THcCB18zSoPj1XDM2e9hmPlAu6ya1hjo7+Jf
         DcIKmvgY8Ob3DLU011LedJV0KgMaQwHrh88b6lRzgIokYn9BaGp6PpzaYfbKSAJP/KC8
         XK6luq/kzfy7sBX09pXWEjoyXj73m0QoOqQRC+G8euMkxu/t3uRlDMCIYoYSm77qTvVU
         uPnJk4FfUZ1w4kyjr++BC0BpVB4Fl7CoviWdzMQF69aJRGIpbpml9LmnpO/cjgJaQqLo
         gYnMlS8YkqGTBcTRyrW+o79449oFH7J2/JlY5ei17D2vDmlE2XSMTyjTxDPg1r09n82h
         Y9Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=X+xLaI1L2IXkvthgdQq6b99QNFK4+VSFZAb1+U1cFes=;
        b=EloYe+vzlJZm7tQV5gYYIOFi6I2hatdxTfxDinxuajP4whJ4sZIJ3as8Jr8tfRlXmX
         y7iYkIuTlsDdswQgM+G2oGs/VDQFBeGDtkJaMfMv3wUWLl6S/WUCDXPM8CEEPJOzaXDG
         JMcVpuK1Zx5HPsiGqFNLNz7iw8flIdpowe83dBxF4eqJcJ1Deh+bKKGLB/Mx9b0Bm6G2
         A+rT7gaE0UhAxVziPllAOlYmbYAFPJrh2Jbgi2IZ9JZgR/7s1A03omNapru7Dy4MOMDl
         7R8olMDeEDEW1ZxU31rOpOf0+XMSi4oZ3f2j+t8e8Wzt8abf6kG4218J1pTtwxEw4Svj
         xqqg==
X-Gm-Message-State: AOAM530J12UVGDaFYLQgBnsLZssKfDLJwJB0VuhFh8jHQcszWI8cS5tD
        iEnqK9Qg+FMETSqtXK2ynGuQpYQ/qWg=
X-Google-Smtp-Source: ABdhPJxc8vPg6dOManBNJH7we1+7YL1KXSLNruK0MPRtPevRYxzC8LXVdhBzLyUbwfL4xRsTtp73Kg==
X-Received: by 2002:a5d:9409:: with SMTP id v9mr10475451ion.170.1630455037694;
        Tue, 31 Aug 2021 17:10:37 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id m10sm11085997ilg.20.2021.08.31.17.10.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Aug 2021 17:10:37 -0700 (PDT)
Date:   Tue, 31 Aug 2021 17:10:30 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Message-ID: <612ec4f6a7174_6b87208a1@john-XPS-13-9370.notmuch>
In-Reply-To: <a86c03ed84a6ca275e65d44aef8abaff890f7e3f.1629473233.git.lorenzo@kernel.org>
References: <cover.1629473233.git.lorenzo@kernel.org>
 <a86c03ed84a6ca275e65d44aef8abaff890f7e3f.1629473233.git.lorenzo@kernel.org>
Subject: RE: [PATCH v12 bpf-next 10/18] bpf: add multi-buff support to the
 bpf_xdp_adjust_tail() API
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenzo Bianconi wrote:
> From: Eelco Chaudron <echaudro@redhat.com>
> 
> This change adds support for tail growing and shrinking for XDP multi-buff.
> 
> When called on a multi-buffer packet with a grow request, it will always
> work on the last fragment of the packet. So the maximum grow size is the
> last fragments tailroom, i.e. no new buffer will be allocated.
> 
> When shrinking, it will work from the last fragment, all the way down to
> the base buffer depending on the shrinking size. It's important to mention
> that once you shrink down the fragment(s) are freed, so you can not grow
> again to the original size.
> 
> Co-developed-by: Lorenzo Bianconi <lorenzo@kernel.org>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
> ---

LGTM.

Acked-by: John Fastabend <john.fastabend@gmail.com>
