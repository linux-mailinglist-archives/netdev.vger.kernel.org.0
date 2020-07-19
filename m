Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3969A224ECB
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 04:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbgGSCze (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jul 2020 22:55:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726382AbgGSCze (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jul 2020 22:55:34 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D357EC0619D2;
        Sat, 18 Jul 2020 19:55:33 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id m16so7104819pls.5;
        Sat, 18 Jul 2020 19:55:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2M4Qa2olyORresQsut8Cp6qPC+IrwWwUiFJ6Jo6XIQ4=;
        b=ilL28ZpCZZIN10B8hkLVLHZwMKbw7ud+IGVnFxfHrCaO8ebpPjWndBZXoiEuduWCQI
         G4tCN+8HlZQXOXg50AOnvdfCO763MM8hjyj1pEOcfLbwP3EbXofh5ffTUBJZ1CYs4dxh
         KcMeklHj21U6zBdWkMQJtE7S1/0nO9T1tK4xDoazfVPwXJ8URj0LKfcYee1K1olL2AMN
         OYdSOD/s0Qflsr6Bc6NMg89MF3qhx6ocJZEDna1g4KonLcHkzMv62FGGR1kLlgppvjXJ
         10weG/3HYIqSh/SNDZgriy43ghQzx7gH/7jfmeWk/PfwjMV6/wGbCDN6WrEHQpzuqZRw
         m1nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2M4Qa2olyORresQsut8Cp6qPC+IrwWwUiFJ6Jo6XIQ4=;
        b=uEPDWb2ztBzyqMW5EVOT7FiwzWrOaDfWYvrl6nQA/rvfv+RiLeC1YOxi89iSDJ8asI
         WMXy9JtSOUe7hcdud26e9LWylXguS0mToqAV/whi+pVTtcrHGFcqHEYfkMUx37qJ8STe
         4EohnRIxjq3bUk+a2Wa9jjw6x79NxL+/nyxqSSosnBsebkE1fpPU/ND2qZZPFgtrocdS
         XUaLUtYstCNQLsV4/kg0J/jsFZ3lZZ2tK/56i1ATXIUqEaGcNcImeAmsRmaAltuJBLx9
         lbejorq6X7atmEgAiFNVg0gknvVhyHV2lPklpjfP2x89aEoRM2IeO1GImX5LxCezj5Dm
         hYMQ==
X-Gm-Message-State: AOAM530FZRAhF06rBCR40oSVRKl52OESwrGPjHbMNg/H4ywahPf6sIY3
        hkmdgS69yXQK54lfMUwT2cA=
X-Google-Smtp-Source: ABdhPJy8IEnys6yHlW+aHSX4G8axatKfXu9OmTIvh22OsdueHa0AbEfGj3bKWWxH/KWy0PAWE66d7g==
X-Received: by 2002:a17:90a:20ad:: with SMTP id f42mr16368847pjg.96.1595127333231;
        Sat, 18 Jul 2020 19:55:33 -0700 (PDT)
Received: from localhost ([2409:10:2e40:5100:6e29:95ff:fe2d:8f34])
        by smtp.gmail.com with ESMTPSA id q14sm11289958pgk.86.2020.07.18.19.55.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jul 2020 19:55:32 -0700 (PDT)
From:   Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
X-Google-Original-From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Date:   Sun, 19 Jul 2020 11:55:30 +0900
To:     "Daniel W. S. Almeida" <dwlsalmeida@gmail.com>
Cc:     corbet@lwn.net, pmladek@suse.com, rostedt@goodmis.org,
        sergey.senozhatsky@gmail.com, andriy.shevchenko@linux.intel.com,
        linux@rasmusvillemoes.dk, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH] docs: core-api/printk-formats.rst: use literal block
 syntax
Message-ID: <20200719025530.GA70571@jagdpanzerIV.localdomain>
References: <20200718165107.625847-1-dwlsalmeida@gmail.com>
 <20200718165107.625847-8-dwlsalmeida@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200718165107.625847-8-dwlsalmeida@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On (20/07/18 13:51), Daniel W. S. Almeida wrote:
> Fix the following warning:
> 
> WARNING: Definition list ends without a blank line;
> unexpected unindent.
> 
> By switching to the literal block syntax.
> 
> Signed-off-by: Daniel W. S. Almeida <dwlsalmeida@gmail.com>

Acked-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

	-ss
