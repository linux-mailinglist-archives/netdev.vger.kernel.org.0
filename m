Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C95A4350E8E
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 07:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbhDAFsw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 01:48:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbhDAFs2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 01:48:28 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46974C0613E6;
        Wed, 31 Mar 2021 22:48:28 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id x16so1052735iob.1;
        Wed, 31 Mar 2021 22:48:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=0AfQaKLbzKkZGxB7mPHMBHnInizF/kixyxpWiJfbTiI=;
        b=jcYTBqnvf18TPLuL4YJ4XKhc8JjUfpfW8NirFFCYf4jLuUiieB5alsyC/vin81jlMn
         T9FLNx0qt+FjL3BHNxfK7R+ffrQV/RIcTkgdODMN7Qh00Tw/HAsuDIIVKzALcV8Nde7B
         yDG3dNjRaRAH+EBsUyd3VvHzEzt6Y2uNUYoVeMzzYJB52JiJ4CxiTcvTBKsVjWXwqRxV
         1f8DDDd/NGr4qQ+kA6jJIxZ6tirSEQneRIMIcFP/IrMyUAbwzthwLf1SQJEyASX0vby9
         2TC3iR9sLNWB2GPQrRp2KZu2GcOUxj7UHfOWorxcMYmwpw67F+BihOhzsr5zVdgJMDMY
         F97A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=0AfQaKLbzKkZGxB7mPHMBHnInizF/kixyxpWiJfbTiI=;
        b=U2bUI3f8TuE/9zrecHRcfpiViS7dr7m9lFS1yRJ6uq7utkDMqU33jYj0XVE6B1fBHv
         qRrKCssPjbzPpm7tcy4hSqHMMhJHqfSlWsV1cQv7LZ3xzyY4Pu0u4Ibz+4yTTRs/i/77
         GJM+2U3B1E4prz4hEuzurfPstZiAdz56MoXc2/4lPVqpqCuDwK8uLfkZvxi9gGOgY2V8
         5FVGXb3/t5QzaqG8KDJOzoC7NGGI+9S5uPevcvBLKHo1VyDzqOFEl3Motnw3lwOMR2IN
         qLBL/Z0GWAIYokf+Fh5ixsumVAPumZMa+U5JUksvDDvwhLeqSRIVaD+V43xrqt10XRMY
         8UWg==
X-Gm-Message-State: AOAM532gzRODJGW3ipNjXfJW3IyRMB/nW93hN0X/hmrGLFFTRUAu9FAv
        7USUJwPl4FD9qkJ5n99qu9k=
X-Google-Smtp-Source: ABdhPJxEdU7AuDhxaV9WpfJRMCkFJ/zyIq0P4/jws9ycyFdzUuJrRKfFlih29Tr1Rmfup/sxBK8Gdw==
X-Received: by 2002:a02:ccb2:: with SMTP id t18mr6221568jap.123.1617256107712;
        Wed, 31 Mar 2021 22:48:27 -0700 (PDT)
Received: from localhost ([172.242.244.146])
        by smtp.gmail.com with ESMTPSA id p18sm2085262ilp.46.2021.03.31.22.48.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Mar 2021 22:48:27 -0700 (PDT)
Date:   Wed, 31 Mar 2021 22:48:19 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>
Message-ID: <60655ea35e6aa_938bb2085d@john-XPS-13-9370.notmuch>
In-Reply-To: <20210331023237.41094-8-xiyou.wangcong@gmail.com>
References: <20210331023237.41094-1-xiyou.wangcong@gmail.com>
 <20210331023237.41094-8-xiyou.wangcong@gmail.com>
Subject: RE: [Patch bpf-next v8 07/16] sock_map: simplify sock_map_link() a
 bit
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
> 
> sock_map_link() passes down map progs, but it is confusing
> to see both map progs and psock progs. Make the map progs
> more obvious by retrieving it directly with sock_map_progs()
> inside sock_map_link(). Now it is aligned with
> sock_map_link_no_progs() too.
> 
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> Cc: Lorenz Bauer <lmb@cloudflare.com>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---

Acked-by: John Fastabend <john.fastabend@gmail.com>
