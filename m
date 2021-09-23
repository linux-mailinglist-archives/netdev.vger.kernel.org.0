Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EC8A41573C
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 05:56:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239112AbhIWD5a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 23:57:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232419AbhIWD5a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 23:57:30 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46253C061574;
        Wed, 22 Sep 2021 20:55:59 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id d13-20020a17090ad3cd00b0019e746f7bd4so768374pjw.0;
        Wed, 22 Sep 2021 20:55:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZFkGDmBfwTQemY7FBg23LWt2kzYZwvNOc/FK/5I0Trk=;
        b=avkvJs9R7pHcZxUnnlsnTRRlHB7UHqrW9XaY5GRbHOZbTtzpoGy8/8SlJGxOEPtNhv
         jOMmg7L4/rw7DRBnyRpttgQJomJxU9SL7mQkh0oXzbJgzqFZbvp+s0JkJF1VBqPM/D/x
         4kA106OuenBYRQ9yFQsYPr09GRS3BSRfF6HYjptqGarKBcRK1MehDaZlwquLqK8CRBDR
         Vokb3loIgUMdFWx55Bt9G86g/C1gRHXqtABNIGx13690DuykJRMMXkM7waqE9xXE9Gqk
         XuBjXhTY8UWL3Y+OZXVoIU2Sg+dmBJS497DVdl/BqtiomfOE4QJ+9nE/iIpyTqQpEy1+
         wLSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZFkGDmBfwTQemY7FBg23LWt2kzYZwvNOc/FK/5I0Trk=;
        b=WK/Z3oQxuYADU/5vXgiP/P9ggbV87zBBYvpt3fwgU3E+KxlhkX3fkMXb0M0fpXlkRN
         n85WO+AjtXVnDvWKMNsXPqytIE414+FdsZz7CasI0uYX2yVF/pmcV/GsIxCRdnAqg5xL
         uKHzJEI+FIOd60KuGcCbBHlgovIgh3DjOV/E8b4MxXi4a15Qa9UPRKXwSqg//lemDeh8
         kKz3jWFl6RKOeEOOJHwSZ8ihdW8mUNIkArSqiQJqlJjWsBzAMxxzaGsly5ceOYov/+MO
         iAAfjtwHkq6BzIKPV4qmjb70K98ltGGLMBrnmq0rPPVnsX51PvEUpTNSJB84QNWtAYdf
         noxw==
X-Gm-Message-State: AOAM533qf8qwREFc9rqhn2amKfkX3M74vaS2u8DKwOYF1xMlTRfAIuFu
        H262NzRjnOfLpC0gH4pV0aenXhMcnlc=
X-Google-Smtp-Source: ABdhPJxyR0hq8wOolCA9Xzp8LEF8ocks743zdsq5UM2xcSS1vdTP+CJUieTrSwkOwvfy7KxPQ3NojQ==
X-Received: by 2002:a17:90b:1e4d:: with SMTP id pi13mr15412337pjb.96.1632369358819;
        Wed, 22 Sep 2021 20:55:58 -0700 (PDT)
Received: from kvm.asia-northeast3-a.c.our-ratio-313919.internal (252.229.64.34.bc.googleusercontent.com. [34.64.229.252])
        by smtp.gmail.com with ESMTPSA id l128sm3871716pfd.106.2021.09.22.20.55.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 20:55:58 -0700 (PDT)
Date:   Thu, 23 Sep 2021 03:55:53 +0000
From:   Hyeonggon Yoo <42.hyeyoo@gmail.com>
To:     linux-mm@kvack.org
Cc:     Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
        Matthew Wilcox <willy@infradead.org>,
        Jens Axboe <axboe@kernel.dk>,
        John Garry <john.garry@huawei.com>,
        linux-block@vger.kernel.org, netdev@vger.kernel.org
Subject: Github link here
Message-ID: <20210923035553.GA4247@kvm.asia-northeast3-a.c.our-ratio-313919.internal>
References: <20210920154816.31832-1-42.hyeyoo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210920154816.31832-1-42.hyeyoo@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello there!

In v1 and v2, I showed simple proof of concept of lockless cache.
After some discussions, it turns out that there are some issues to solve.
It will take some to solve them.

I made git repository on github to share its progress:
	https://github.com/hygoni/linux.git

This is based on v5.15-rc2, and the main branch will be
'lockless_cache'. There's *nothing* in the repo now and
will be updated randomly. hopefully every 1-3 days, or every week.
(note that I'm not full time kernel developer. it's hobby.)

I'll make use of 'issues' and 'discussions' tab (github feature to track
issues and discussions).

You can join if you're interested.
Thank you for your interest on this project!

--
Hyeonggon
