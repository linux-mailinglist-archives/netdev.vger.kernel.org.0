Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DE2722818D
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 16:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728483AbgGUOCw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 10:02:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbgGUOCv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 10:02:51 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2371C061794;
        Tue, 21 Jul 2020 07:02:50 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id gc9so1623845pjb.2;
        Tue, 21 Jul 2020 07:02:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DPyk9xvosUPTjA8FNUVPTKdgpCwA2f5e1N3QEYyilm0=;
        b=i8fxATqLfrBBh9ZUvUiAvBJmsWS/7jXkbzuWNTe430t/aF0eGrdP4SEdPX5uXEg7Lz
         OKfZdEqirrD17IS9T4md6ULFj1pEO/1AzGx3/CbcvFTQJH6b0GqjNIvMxeCW6herJuIc
         0tyBXJvE3s8GkZ1LLpzGp6OUAZ/m4VxGEDGIKAJ1GEiGrgdHjEbFUL3gB0lXrJoWwgBP
         /yOmadYBuqliZs6dUAnpyTUHnI6JmHV8R5ohlmJVNpi75FqjfG9fVYr9wPOD0xKlYqL8
         aiS3idM64mLEcI1wnIYgslzntmWZ92eavxFMoCuCMMGVfnNMpYQ3uv2kfOtnLwrL6tYS
         HAqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DPyk9xvosUPTjA8FNUVPTKdgpCwA2f5e1N3QEYyilm0=;
        b=WijJoMNTGGPXZTuS6jOoiplCzfq5Te7fWUGHE91ElNzcRW9GrIhJhwhEOFZOybCWmI
         9XG+d2MndMzZfvwx9rCoM8KPkAqO9cp+H0ouX7wfm5Q3EHEfyTa+v2iBKg3kNjXu+6td
         P2bjde0K/xMQDEeoEPh5wHA+boUl/bhFErS/+tGlJKUxi0a8Ll5DWzERJ43yZv9hBkqj
         x3l9h10ieF/OPqu5usUxwu6u8xtGvBTZ4yGwPe7kkUspCWv8JMUYcX1Aj5jcX0OQj+VR
         zb4WRVueN7gr+oJc11ksp+zlEFJBoCB1aw/wBH92ZDlY9XO1F6iTd6mDZlhN6h0S5gs9
         trdA==
X-Gm-Message-State: AOAM533OD+DLZLgCBZBmOI9Fh9IzB/V5Sl6N1Tb6htDvqm4eAVBCW0tw
        9F6hLAA2FDGcVd+C00Y8SVo=
X-Google-Smtp-Source: ABdhPJxrB89sIg/2vALjA0kiLsDw77UdV+9u4kvQvsrVlqkzoMk0oyY1r4NaYgX8VVgRQHNLb3fBnA==
X-Received: by 2002:a17:90a:2d7:: with SMTP id d23mr5051219pjd.57.1595340170106;
        Tue, 21 Jul 2020 07:02:50 -0700 (PDT)
Received: from localhost ([2409:10:2e40:5100:6e29:95ff:fe2d:8f34])
        by smtp.gmail.com with ESMTPSA id m9sm3271329pjs.18.2020.07.21.07.02.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2020 07:02:48 -0700 (PDT)
Date:   Tue, 21 Jul 2020 23:02:46 +0900
From:   Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To:     Jonathan Corbet <corbet@lwn.net>
Cc:     pmladek@suse.com, rostedt@goodmis.org,
        sergey.senozhatsky@gmail.com, andriy.shevchenko@linux.intel.com,
        linux@rasmusvillemoes.dk, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        "Daniel W. S. Almeida" <dwlsalmeida@gmail.com>
Subject: Re: [PATCH] docs: core-api/printk-formats.rst: use literal block
 syntax
Message-ID: <20200721140246.GB44523@jagdpanzerIV.localdomain>
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
> From: Daniel W. S. Almeida <dwlsalmeida@gmail.com>
> 
> Fix the following warning:
> 
> WARNING: Definition list ends without a blank line;
> unexpected unindent.
> 
> By switching to the literal block syntax.
> 
> Signed-off-by: Daniel W. S. Almeida <dwlsalmeida@gmail.com>

Jonathan, will you route it via the Documentation tree or do
you want it to land in the printk tree?

	-ss
