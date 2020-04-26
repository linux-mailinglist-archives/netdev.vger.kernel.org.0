Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B9B51B9145
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 17:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726165AbgDZPvG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 11:51:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725818AbgDZPvF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Apr 2020 11:51:05 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E4DBC061A0F;
        Sun, 26 Apr 2020 08:51:04 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id 7so5871025pjo.0;
        Sun, 26 Apr 2020 08:51:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0tREdJmgxZBE3LuxNv5lLUb9+sRKgXBjmxyZW6AGnrE=;
        b=sDZrN2+0H3oWhbgC3FN3dRrI+vnpl/bE9yHq8HRC57KvZN2rYMU2YRLxV5qkKH1pVy
         2CEb2u+YbK6heFjgQNutKPxZDTi5bZft3ysYJscFcqPkt8EWoFfFqhuyhD0IhGc8xijs
         6wBlKoRXKVlSpCr6KqKzheomL5/Rk8Uw0UScYFq1VovEbNlisshNYBWu+C6YDqSBequT
         Nf1a7uOegzBkQrYV5IEgEwdyvM4q9w7PHzBJ0CpZzGPF6MdO/lGw3QUREHszldPK3GpU
         3qL0nrO8xVS4zdE/prR/cCJxxB3lAoKG3awGlwXr7pm9T42nRAtkMY+zlPZstgEgzkuG
         OVZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0tREdJmgxZBE3LuxNv5lLUb9+sRKgXBjmxyZW6AGnrE=;
        b=J+ORCmupeyj3uD6Bw5dJFOI4X6Ios2IAmNio4K4lpPwh/im9BPvrj1bUJ99u11KGkO
         +368kKWlKsLW6phX19dWFPLmlEZDPxTk2o2Ci+LZyCdqrN3nKiPA4TGIKebuq9IXqpKM
         qUD1TX1t6e+oDgfyb8k+djZy7+RWRJDOOM1JZ+RkJJxp8zOIjpLIKtB/O2NFlBbmJ4oz
         hXsqQ+4pvc2EaCgvspGMniGlFjIoYNp/EzivLUHkF2ptCVTAaGb1GPFXwSJsRFcUGLKn
         x4q3DTaGaaCYVy0HWGFPQrORfBs+4coC0qYoyWkiM+37Y2Hq+S/tZaL9/9/A0U9xgBKa
         n76Q==
X-Gm-Message-State: AGi0Puad/gRXHfvymfzVjwphgNS4Lo/DEpF9QWJqOxz7rCoTPsj4Zbm7
        +i9f+syGJQXAcER2Xaak1cQ=
X-Google-Smtp-Source: APiQypK/TQCrX63vJaNJa+pMMCMrbYitizNxouXhoQm6uhpCCnnkEGp/tWQ1QRiNM4UdLfeHiDtWOw==
X-Received: by 2002:a17:90a:23cd:: with SMTP id g71mr17811667pje.174.1587916263895;
        Sun, 26 Apr 2020 08:51:03 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:9db4])
        by smtp.gmail.com with ESMTPSA id j5sm1088560pfh.58.2020.04.26.08.51.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Apr 2020 08:51:02 -0700 (PDT)
Date:   Sun, 26 Apr 2020 08:51:00 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: pass kernel pointers to the sysctl ->proc_handler method v3
Message-ID: <20200426155100.bcbqnrilk45ugzva@ast-mbp>
References: <20200424064338.538313-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200424064338.538313-1-hch@lst.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 24, 2020 at 08:43:33AM +0200, Christoph Hellwig wrote:
> Hi all,
> 
> this series changes the sysctl ->proc_handler methods to take kernel
> pointers.  This simplifies some of the pointer handling in the methods
> (which could probably be further simplified now), and gets rid of the
> set_fs address space overrides used by bpf.
> 
> Changes since v2:
>  - free the buffer modified by BPF
>  - move pid_max and friends to pid.h
> 
> Changes since v1:
>  - drop a patch merged by Greg
>  - don't copy data out on a write
>  - fix buffer allocation in bpf

The set looks good to me.
Should I take it via bpf-next tree ?
