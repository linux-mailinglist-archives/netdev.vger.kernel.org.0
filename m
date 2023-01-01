Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8C0165AB1E
	for <lists+netdev@lfdr.de>; Sun,  1 Jan 2023 20:09:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbjAATJv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Jan 2023 14:09:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbjAATJu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Jan 2023 14:09:50 -0500
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E64A3D9E;
        Sun,  1 Jan 2023 11:09:47 -0800 (PST)
Received: by mail-qv1-xf29.google.com with SMTP id qb7so3606499qvb.5;
        Sun, 01 Jan 2023 11:09:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Nh1q6xtrBgKc1fDe5/d8D5jFIgt5LSbfJ1iE1tY4NY0=;
        b=UwnH9hRCSaQXMD1ekBRj4n3jdugn6p5ha+kj9QMceWZP0PAzvDMSmcio2VlXTquVF/
         6BRBS7KRqzFq4u1ymXaetY42vnR/h/VUewl41NzcwBzQXsc7CpxR47vXsClj5Fm4wAkh
         T3awI2+sJTn6bFCvwm0K+GDxNW2l2VmI+Ea5W9ASfOVEwW7XpPMyIxyLGnEJnf7ONsF4
         YMV9b1otZKL/jxE9pnEEFRge+Uh3wwh4ZyXXqKBE8+LtlP0uU+iHMu0HrhSl06mS5ekt
         w+jfvwtfh6VGcX4EGVkaVBTtwnW3bgYOYlVy5Y8hxCwRZ0FIx2g75vOqkZdE3A+YL7kf
         iTrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Nh1q6xtrBgKc1fDe5/d8D5jFIgt5LSbfJ1iE1tY4NY0=;
        b=FfszfJVKGHDvEsFDGxHdY9x70C6lWugbxyAOoQ1rmnGwUPqrpXMLYIr79IbRrNrWxC
         5g+GDkT40pxB26yMXNOSleCXHFLbQLsOu2P7jeJStb8JtbuEsyAqE0BRXdOxgfZDoia7
         lY5glvMm/lA/w1y7vtYyWotfQBNfzaIwd3WYFHyJ6+QpxvSDiljvb9jJEQE1t/aGFfJs
         aiGCP02T9gcp90hHZ3kBUm5hBWtAvH7PdIP1upI2SvskSdkrNiWieiZcIsW4z+GgyouW
         /DEA7rh7fGXs6oue60bfbHhd7K554f6b4eC9y7TsSlir0/pXd6DDjzdCfLqIv2fue/9X
         dQHg==
X-Gm-Message-State: AFqh2kpB+a+TYtdqB1eIwkwy+cOtfv1AKJn9B6QwP7W7f5VPSGa5eT8q
        XgtUp2+pr8lLx+qda5q7l3U=
X-Google-Smtp-Source: AMrXdXuRwZ8m1kj+aK33hY6Z1Z1I7ASwAwEcox5pdWzF+iOPu8vspUPvseIArGH7bK8IissbSDrhsg==
X-Received: by 2002:a05:6214:3713:b0:531:bb5a:3418 with SMTP id np19-20020a056214371300b00531bb5a3418mr9262906qvb.13.1672600187088;
        Sun, 01 Jan 2023 11:09:47 -0800 (PST)
Received: from localhost ([2600:1700:65a0:ab60:bccc:52d4:da14:f94d])
        by smtp.gmail.com with ESMTPSA id p18-20020ac87412000000b003a4c3c4d2d4sm16459391qtq.49.2023.01.01.11.09.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Jan 2023 11:09:46 -0800 (PST)
Date:   Sun, 1 Jan 2023 11:09:45 -0800
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     Yunhui Cui <cuiyunhui@bytedance.com>
Cc:     edumazet@google.com, rostedt@goodmis.org, mhiramat@kernel.org,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, pabeni@redhat.com, duanxiongchun@bytedance.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH] tcp/udp: add tracepoint for send recv length
Message-ID: <Y7HaeTkNtfb3oIP4@pop-os.localdomain>
References: <20221229080207.1029-1-cuiyunhui@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221229080207.1029-1-cuiyunhui@bytedance.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 29, 2022 at 04:02:07PM +0800, Yunhui Cui wrote:
> From: Xiongchun Duan <duanxiongchun@bytedance.com>
> 
> Add a tracepoint for capturing TCP segments with
> a send or receive length. This makes it easy to obtain
> the packet sending and receiving information of each process
> in the user mode, such as the netatop tool.

You can obtain the same information with kretprobe:
https://www.gcardone.net/2020-07-31-per-process-bandwidth-monitoring-on-Linux-with-bpftrace/

Thanks.
