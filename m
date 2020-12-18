Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0D702DEC0C
	for <lists+netdev@lfdr.de>; Sat, 19 Dec 2020 00:31:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725936AbgLRXaq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 18:30:46 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:60393 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725831AbgLRXaq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Dec 2020 18:30:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608334159;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9L6dlKMbE1KBwzhNvipaTQJktDWMfhXVxZST2OF6X/s=;
        b=I+qt55E9NtFln9OC2qEHDurrstF5QwrZlre9oP+rlILax6915OzK4LOiRisK/1a11gBXlN
        hlgdmOU4ONwBe+jAu3ZhMJoxFYSe1zr2mNKKw2nCz9iBByNvLLvaAY1WNv5wKQQAt5g6ZO
        YfdvXuTQNvurl+hqc2FuPgBBkOcsfs4=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-506-uppOZAiEMKuoAqihHXaykw-1; Fri, 18 Dec 2020 18:29:17 -0500
X-MC-Unique: uppOZAiEMKuoAqihHXaykw-1
Received: by mail-ed1-f70.google.com with SMTP id cm4so1743762edb.0
        for <netdev@vger.kernel.org>; Fri, 18 Dec 2020 15:29:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=9L6dlKMbE1KBwzhNvipaTQJktDWMfhXVxZST2OF6X/s=;
        b=qYRBb/J57skgfRclCn75L/sMlB97T4fd9L9qosk0J3bwu2QGAl44ijaTLzX6W+jt7R
         6y8BqSUS0vHvVXUGAJ07g0zbTdIe+FAvMuyYrYqJChgouPjgxjoift6ZS+psLVlZMq+g
         Nmy0troZIGv68BYqQyB8gTxD7tFqdAd4l4yArFy10BAvM3X0zFghpW1lNLHTH1+gd7Lv
         5spUOE2w/gZFWdMsMDfia7NF8SaFELBoq5lxnxlEccjUDFmaYUaH41zxOJF9KJGc4CXF
         st4+rCnP5nBY6XmBK6vw2UODY0D7ffp/FG5L5ldAimccqyMM6x0bugpdCwGLI37Ofxtr
         8CNw==
X-Gm-Message-State: AOAM532PocmYYuMWu8sUk+Nf5IQVQZ9TFmMui/j2oB2XYZkztVG8K99H
        Pslj9qjsIbsQtIwaiHI0BUoR+XmuNbCUsZWoECT8qm46rDYPDK5g8fsMET7Qkqi1v6NpsFHAF8d
        eoQShcPggChLQOP423nOhoBFLFfK0Zp/Z
X-Received: by 2002:a50:955b:: with SMTP id v27mr6612844eda.324.1608334156476;
        Fri, 18 Dec 2020 15:29:16 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy5Dn6pUGFNUEonqACDVZrpe8rIudPjqGqLAcANwps9DekTZ2ANYrlZPML4s/bzFtzCZMqv4AXBcA0dWfI0yHM=
X-Received: by 2002:a50:955b:: with SMTP id v27mr6612832eda.324.1608334156303;
 Fri, 18 Dec 2020 15:29:16 -0800 (PST)
MIME-Version: 1.0
References: <cover.1608315719.git.aclaudi@redhat.com> <9b07b59c4c422b29d6c8297f7f7ec0f2dcc7fb3f.1608315719.git.aclaudi@redhat.com>
 <20201218230835.GY28824@orbyte.nwl.cc>
In-Reply-To: <20201218230835.GY28824@orbyte.nwl.cc>
From:   Andrea Claudi <aclaudi@redhat.com>
Date:   Sat, 19 Dec 2020 00:29:05 +0100
Message-ID: <CAPpH65zBxNo9W3VnVsSBfNsGwvVyyw5ZMnHzqSpmMuj7NbaYJQ@mail.gmail.com>
Subject: Re: [PATCH iproute2 2/2] lib/fs: Fix single return points for get_cgroup2_*
To:     Phil Sutter <phil@nwl.cc>, Andrea Claudi <aclaudi@redhat.com>,
        linux-netdev <netdev@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 19, 2020 at 12:08 AM Phil Sutter <phil@nwl.cc> wrote:
>
> On Fri, Dec 18, 2020 at 08:09:23PM +0100, Andrea Claudi wrote:
> > Functions get_cgroup2_id() and get_cgroup2_path() uncorrectly performs
> > cleanup on the single return point. Both of them may get to use close()
> > with a negative argument, if open() fails.
> >
> > Fix this adding proper labels and gotos to make sure we clean up only
> > resources we are effectively used before.
>
> Since free(NULL) is OK according to POSIX, the fds are initialized to -1
> and open() returns -1 on error, you may simplify these
> changes down to making the close() calls conditional:
>
> | if (fd >= 0)
> |       close(fd);
>
> Cheers, Phil
>

Thanks for the suggestion, Phil. Will do in v2.

