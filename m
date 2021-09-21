Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1307E413203
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 12:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232192AbhIUK5g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 06:57:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231956AbhIUK5f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 06:57:35 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B415C061574;
        Tue, 21 Sep 2021 03:56:07 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id t4so13126079plo.0;
        Tue, 21 Sep 2021 03:56:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=y7LURbSsGsDLVF+thUJ2ISGPY7TGQ+JWR2GJD3gQl74=;
        b=Zn+V9OroQ+EvS2kYx+2MQAXc1/lL+8Nh/fK2eyp67nOYVbL6w7j5TDZjaRU3Ys9fZ2
         nySpBS+1drMi7MiROt1+cLz95IAl6+UGcwByaqw+G0AmUA0jFOmPKUp9PfEH7MvJePgt
         rHOEuphF9qvBfkSeA6/CcoUbSPLtM6+F9jianHTHSyAKHJwtzFhUEHrNWNg1uddkr02k
         Xbj/8O5nx+qfHfiuf7hKe+MjKDSWOJFF1dvHjIWffPgQm5pRQzuBKA4PsbAN39zSQYpg
         OuGKUGEkeq8mNB/7vXUE361/tCV5qCWO/l4aNU/HfdmoAA6Z6JbmkZ3J8Kr1Q3oPPKQ7
         xU/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=y7LURbSsGsDLVF+thUJ2ISGPY7TGQ+JWR2GJD3gQl74=;
        b=gnNOKZ4OU22KKAUH/eMzSAJL/q9EfI5cKHJvqFMewbX41mkaKoC87BOuvC1+KB9bO5
         1vwFzg3OGugNdg5tZnO1q39DUHtM7Schx3/HpGpeDLuN0ys6TWmgSFC+L4Kn5PYWSCnR
         OP1T7D4K66uetJPKruq3npHKsFR0MnUFhuP8SBuMqEQs5uALgPO8Zeoq0Z1GDEnv/rJB
         PjaQfTuzfOvKQUEMmt71uWnD+qiolKf9KUbs5Sm5umJjUKlhAKjLZUyGJqG+dkWVheqD
         gzOaV2IQhOtEuQbDSN7eHhxlNKZ1tSQrgwwRoWnLau/I2gNAabAkN94ZKvBoEAS0S70T
         BA6w==
X-Gm-Message-State: AOAM533iBh7bR/lpqOlK9/gxu2N1RkzPlTgNnyjY6uVHh1PSxrnVqZ+z
        T80siKL8or0QUmKiDcqME28=
X-Google-Smtp-Source: ABdhPJwvzFa3P9dyBNmtq5bhtLhCGwRi18+b7ku5ZrFRQr7sb0n8C8DlXibxPdegCQqRaS7/BAcRyw==
X-Received: by 2002:a17:90b:3b41:: with SMTP id ot1mr4564161pjb.186.1632221766670;
        Tue, 21 Sep 2021 03:56:06 -0700 (PDT)
Received: from kvm.asia-northeast3-a.c.our-ratio-313919.internal (252.229.64.34.bc.googleusercontent.com. [34.64.229.252])
        by smtp.gmail.com with ESMTPSA id z9sm3083784pfr.124.2021.09.21.03.56.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 03:56:06 -0700 (PDT)
Date:   Tue, 21 Sep 2021 10:56:01 +0000
From:   Hyeonggon Yoo <42.hyeyoo@gmail.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     linux-mm@kvack.org, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>,
        John Garry <john.garry@huawei.com>,
        linux-block@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC v2 PATCH] mm, sl[au]b: Introduce lockless cache
Message-ID: <20210921105601.GA3121@kvm.asia-northeast3-a.c.our-ratio-313919.internal>
References: <20210920154816.31832-1-42.hyeyoo@gmail.com>
 <YUkErK1vVZMht4s8@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YUkErK1vVZMht4s8@casper.infradead.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Matthew,
I love your suggestion to make it more cache-friendly (and batch
allocation) and it sounds good to me. I appreciate it so much.

But give me some time (from just one to few days) to
read relevant papers. and then I'll reply to your suggestions
and send v3 with your suggestions in mind.

Cheers,
Hyeonggon
