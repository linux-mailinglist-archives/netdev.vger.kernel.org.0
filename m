Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BE553DDBB1
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 16:59:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234401AbhHBO7w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 10:59:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233981AbhHBO7v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 10:59:51 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2144C06175F;
        Mon,  2 Aug 2021 07:59:40 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id hs10so22705875ejc.0;
        Mon, 02 Aug 2021 07:59:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Rl9nBCVxzHPtjQlQ0C1CUCK9L5CCBMPqge/fuO5g570=;
        b=QfuVMUAbRZVIcbiMc0Ds9QIQOYLAib+/PWA56KbU2GDZNdEiF01uoTugf8+AP5Un4+
         MIK7gB5olrFRatb2B3foEI1aCTgoxFpS1OsvE6k4YboC+hVt9ABTLTrPT5vNL004azEz
         wElAFPIpPINVrUVhSNGSKUEByA4G40Zw+AtiZKyrvKdHbcUI7OxrdYgyi7onENIlOk0V
         YOgstrSj2qsmWcGzYpZjNn7Bw568HANofloiCQ7V4akLJJWx1Ze/PpxdBLx0VHHxa1nv
         CzXbEv+/2oLqYXMV/S7JiBmlocH4owBK/Y4OT393EU+R5QUg67fxdL0nE3SmC5SYDUtF
         tKEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Rl9nBCVxzHPtjQlQ0C1CUCK9L5CCBMPqge/fuO5g570=;
        b=BHaNNZKroXT5javMOGSKYhQi42wXacTtDSFV63P24pDNV/xJhXiT6yJFX3S6+PBOzn
         lDCaa6oag1b+InkxxzoK+L6s632pTmDEP8d2CaiAxjvGisvQq3bYJ2CEilad5myDPYYW
         s9avZPvjKLjDySBcE8WahUnCZ5wcDmmKdtwski2CXPPEEJiivZpRIrsMuk4BEKe0NtEu
         L/x7N5h+5Ery6euo48RLMskqzcyTLHef8HEFYP05VwmkPL56fdkVJt4MO/gHq3wTJSun
         J/4hgHF/Xet1VPHuu0+upTPPGOctkfV7cSk1kcLzjqEiUhngY4T7EJv9aMeBwE9DP6LD
         Lx9Q==
X-Gm-Message-State: AOAM532uUxC38ndeeUOqaYlYQp3d5ZN+eT8TD0uErU/3q7PZKXy7EHoB
        3SVI4aXar4HvNn3Z+k+bLRs=
X-Google-Smtp-Source: ABdhPJwcvnIPWi00cg7ALyxChVDvyGVR4WZAbajX0P0irbXHfmvvRiSFIjNlXstacO/wFShKiFsAvQ==
X-Received: by 2002:a17:906:9c84:: with SMTP id fj4mr15524669ejc.180.1627916379353;
        Mon, 02 Aug 2021 07:59:39 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id ks26sm4715190ejb.58.2021.08.02.07.59.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 07:59:38 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
X-Google-Original-From: Ioana Ciornei <ciornei.ioana@gmail.com>
Date:   Mon, 2 Aug 2021 17:59:37 +0300
To:     David Ahern <dsahern@gmail.com>
Cc:     Ioana Ciornei <ciorneiioana@gmail.com>,
        Yajun Deng <yajun.deng@linux.dev>, davem@davemloft.net,
        kuba@kernel.org, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-decnet-user@lists.sourceforge.net
Subject: Re: [PATCH] net: convert fib_treeref from int to refcount_t
Message-ID: <20210802145937.hjguodaqphxoabdt@skbuf>
References: <20210729071350.28919-1-yajun.deng@linux.dev>
 <20210802133727.bml3be3tpjgld45j@skbuf>
 <2033809a-1a07-1f5d-7732-f10f6e094f3d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2033809a-1a07-1f5d-7732-f10f6e094f3d@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 02, 2021 at 08:36:59AM -0600, David Ahern wrote:
> On 8/2/21 7:37 AM, Ioana Ciornei wrote:
> > Unfortunately, with this patch applied I get into the following WARNINGs
> > when booting over NFS:
> 
> Can you test the attached?
> 

Yep, it fixes the problem.

Thanks!

-Ioana
