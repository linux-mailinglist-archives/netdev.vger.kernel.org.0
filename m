Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 007E9EBA42
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 00:15:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728807AbfJaXPs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 19:15:48 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:44799 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728792AbfJaXPs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 19:15:48 -0400
Received: by mail-lj1-f193.google.com with SMTP id g3so2280268ljl.11;
        Thu, 31 Oct 2019 16:15:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f3a8A0/l2UF+i77uTlp/YCUbm9HqgKFeZi6vGFlnxfM=;
        b=SmBEn84o1TKsmt3gjErkbu0+qg+GHgrFHTr8ShQcBYjQAmltbXb9lIJUHMEbFbVaAR
         ZO8NeEMPxeDYFekTj/565Kl5lpfB1ngPMvBkTzWL/QX7fa02stoHqk7EIFLWOyvwdKdk
         i5sTTpEXXvzGgDYYCbx2yhf0FVNxXtzWTkPMq77MxYqtQY7+IJ6lbsrHfJrZ/X0/ph+j
         JPXbOo9eo9jJfR0uFURUzTqqsKTW9FcOEAeWL1hFGFz9IeDQAtLniP/6ImLTu30e6LJ0
         9BeXsmxojGRPbj4MAlqBFngmwBm7t5QBqYF00mZMqkS0Rns3vadjPH4/4yh04ilcws+Z
         8I6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f3a8A0/l2UF+i77uTlp/YCUbm9HqgKFeZi6vGFlnxfM=;
        b=YSCGaYM5T6cphWIartg8bpMB7Rbrfb22iCzZmGnbbSvGCQL5j3EmAQ8EnqPGScrDWi
         EqqEdXsrso/MEqBfG37pCwkPRplYvw9s95mdKDX+1YB9LkZ1gph8b/KCjnPNQt5KV059
         hWuh/MYJLqu0H5NG5mpycUyDJGnb2dxI/3pFa6SZ2s3XK8YRfQzXxxY204BvobXjzRyH
         gybyXafS8trFx/RshtLbV8uR9Wb94RwwfcxKkwUieftPBIGWpsdnHk9ptJC1WBp2yZNJ
         GUahxUAz/EYYBkWZdN6zRny+R6DSWwCnm4JysGKpJ2UmkqGP/BmDq7HI34/t7i3JHUwF
         CTgw==
X-Gm-Message-State: APjAAAWClDE5soHuJJSHC81XTUtH6uxZnRanyug13Rwvv53BVxDz1Uvd
        Vd9/TlvT1LXySWVnGZifGiOdZV7PLVi5aHj4pS0=
X-Google-Smtp-Source: APXvYqzm3NVAIKfvcCxCCPzBMZ+2ono4/z0daXiPapSXvjCWzDnY+jy8fxfoO7CLNJiQrCdtHG1T7cQTF+EnO7Rpnak=
X-Received: by 2002:a2e:9799:: with SMTP id y25mr6107877lji.228.1572563746550;
 Thu, 31 Oct 2019 16:15:46 -0700 (PDT)
MIME-Version: 1.0
References: <CAJ+HfNigHWVk2b+UJPhdCWCTcW=Eh=yfRNHg4=Fr1mv98Pq=cA@mail.gmail.com>
 <2e27b8d9-4615-cd8d-93de-2adb75d8effa@intel.com>
In-Reply-To: <2e27b8d9-4615-cd8d-93de-2adb75d8effa@intel.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 31 Oct 2019 16:15:34 -0700
Message-ID: <CAADnVQLJ95j5jfh5jFApjs4bYzOxuPcrMgH9jbdGGvOWQEPRyQ@mail.gmail.com>
Subject: Re: [Intel-wired-lan] FW: [PATCH bpf-next 2/4] xsk: allow AF_XDP
 sockets to receive packets directly from a queue
To:     "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf <bpf@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Network Development <netdev@vger.kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        "Herbert, Tom" <tom.herbert@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 31, 2019 at 3:38 PM Samudrala, Sridhar
<sridhar.samudrala@intel.com> wrote:
>
> Alexei, Jakub
>
> Do you think it will be possible to avoid this overhead when mitigations are turned ON?

yes

> The other part of the overhead is going through the redirect path.
>
> Can i assume that your silence as an indication that you are now okay with optional bypass
> flag as long as it doesn't effect the normal XDP datapath. If so, i will respin and submit
> the patches against the latest bpf-next

I'm still against it.
Looks like the only motivation for it is extra overhead due to retpolines.
imo it's not a good reason to introduce a bunch of extra code helping
single kernel feature.
We will have proper solution for indirect calls.
