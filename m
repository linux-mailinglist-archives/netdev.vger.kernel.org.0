Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C741E545D
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 21:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727150AbfJYTaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 15:30:20 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:43001 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725775AbfJYTaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 15:30:20 -0400
Received: by mail-pf1-f194.google.com with SMTP id 21so2228272pfj.9;
        Fri, 25 Oct 2019 12:30:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=0Ol0Q9d+nzw7reP27LbGXzVnDznqVRhprPqADBgH/xI=;
        b=jjAQriQ7nUxcSr1XFJkzKM1qjyQMsg0rjgisDNSiP7tBFzuDmawJSLzKQxDaZ1TZqX
         rRFCyhh6VL8xnaVoLNG+6mDcY4JOLz9HaSzB59a1aE8ZU2Zqe/goi0KB2XWie302QG3N
         bRf+D6Q0CDarWB91xusGQD7iYFGBfvZHbBlcCFeYWZuAoTBDdttlah8yTnxCpji2F8tq
         tTD2bYTqPGX2ful7uVyRb9VRubALyTsWUDb4pEJLfaNTS3Ji+V4HUlZoqdbnf3n1JXp6
         923ISWPmEHrN6Ys8ghc8HfVL4HSaK8D6tv2+cj9RkmGS+pY5sYRMVa8d7dbr2RuAZO7l
         0FIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=0Ol0Q9d+nzw7reP27LbGXzVnDznqVRhprPqADBgH/xI=;
        b=mCUFU4/zBUQoyX3Rm3kcS2ugPOQ1JaMIfKSVFVj1bMBAmwy8T3QudNuL7fS+NNu3SM
         Eab4Ijh++VzibJkcd8oye3J7Uondmj0Xmt4IVOgMhoB8YyFhy49h+W2EvDN5I6c/0hiB
         v5XmO4v1R7/EtX4RxbwFFAOcoHcMb2hsg13FhPc8clYVhqaHbksk+bcSj9rALdDTdZLM
         SblZ+crwz0fOVmIzjOlrrMF4JUu5coK+pAX0CHN25HT0orRGvEZCAQ5koAD7mB31LF7E
         NJGJ7g6YV1xR+2HPGMWghyq/g0ngKxETKopYfahQtiA8JFZ2caCoQDv7QqvmTsFmnZHA
         knQw==
X-Gm-Message-State: APjAAAW02uTyz3zkhefs09RvZf0xRD0/YCQsGmJn1uHfW76BxDPmZpXd
        aTAhxcdcBoWjD8Z1oB9Mx5tNr/pB
X-Google-Smtp-Source: APXvYqwZimV4wJux6JvoxjKcLblnon0CqTabNqkGEQa5sFF7dlM4OLeZoXS9X2fTJb58AjZjF2LISA==
X-Received: by 2002:aa7:838f:: with SMTP id u15mr6327200pfm.74.1572031819294;
        Fri, 25 Oct 2019 12:30:19 -0700 (PDT)
Received: from [172.20.54.239] ([2620:10d:c090:200::1:4b93])
        by smtp.gmail.com with ESMTPSA id v4sm3068298pff.181.2019.10.25.12.30.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 25 Oct 2019 12:30:18 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Magnus Karlsson" <magnus.karlsson@intel.com>
Cc:     bjorn.topel@intel.com, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org, degeneloy@gmail.com,
        john.fastabend@gmail.com
Subject: Re: [PATCH bpf-next v3] libbpf: fix compatibility for kernels without
 need_wakeup
Date:   Fri, 25 Oct 2019 12:30:18 -0700
X-Mailer: MailMate (1.13r5655)
Message-ID: <9CF134CD-CB33-48D0-BFAF-BCFC2F9AE6AD@gmail.com>
In-Reply-To: <1571995035-21889-1-git-send-email-magnus.karlsson@intel.com>
References: <1571995035-21889-1-git-send-email-magnus.karlsson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 25 Oct 2019, at 2:17, Magnus Karlsson wrote:

> When the need_wakeup flag was added to AF_XDP, the format of the
> XDP_MMAP_OFFSETS getsockopt was extended. Code was added to the
> kernel to take care of compatibility issues arrising from running
> applications using any of the two formats. However, libbpf was
> not extended to take care of the case when the application/libbpf
> uses the new format but the kernel only supports the old
> format. This patch adds support in libbpf for parsing the old
> format, before the need_wakeup flag was added, and emulating a
> set of static need_wakeup flags that will always work for the
> application.
>
> v2 -> v3:
> * Incorporated code improvements suggested by Jonathan Lemon

Thanks for doing this, Magnus!  It looks much simpler now.


>
> v1 -> v2:
> * Rebased to bpf-next
> * Rewrote the code as the previous version made you blind
>
> Fixes: a4500432c2587cb2a ("libbpf: add support for need_wakeup flag in 
> AF_XDP part")
> Reported-by: Eloy Degen <degeneloy@gmail.com>
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>

Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
