Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 935DF19C38C
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 16:03:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388577AbgDBODF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 10:03:05 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42817 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388357AbgDBODE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 10:03:04 -0400
Received: by mail-wr1-f68.google.com with SMTP id h15so4331715wrx.9
        for <netdev@vger.kernel.org>; Thu, 02 Apr 2020 07:03:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=ROM0NZlL8/uavKppMYhFZmhpIoRWlNeIkHl4YW1IeXQ=;
        b=dS6/5rCM4/vLn5Oy//VpCZAlhD7BDjbPJNcgTtkenuduZrGDvvix/PkbBWumdzIM4E
         Ppf1+JtrgEOi+afPPtzZJOLKh0bg0GnikmJ1cEZK77soD4Q0bjb9naI/vzr1Y2VgQnka
         SoD13n04fddvXe4/i+/tNfir/2jZslLYttg/k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=ROM0NZlL8/uavKppMYhFZmhpIoRWlNeIkHl4YW1IeXQ=;
        b=DCQ1A1wnkkzyZ37n/98V7hhplz6LuQ0bq3e6oMrLulQmYPR1f+1MsBrrbDQVfAwsCh
         +htNfKTGR0PQRCTcaZGWc65Ofk4R6LScXuhSheJyj5yBYVrkhD4M6Tiz1qfi7u7m2AXI
         v8wZHqRn6js1lp89CmvJ8H1AJ3NPfOXCYDnIZqEmpv8K/hLH4kDK0bBNHxz/UpxqRUrK
         yQOo7+hGpulksgDpn/JU91bRBHUtJQs+2zijDHviwUfBD4yWGTcJNf8s5xfpFMc89vsT
         OWoX/yukSsoiW6qFepCwaRgGhC/BAgg0lqvaBXH1M7M9rDs8qpXe+yPu6c2NLJzicpDv
         HBFA==
X-Gm-Message-State: AGi0PubPpQ0lmxqmwdCN9Y5tBqudwh2euYGuD7JgcYreKeYc3Y71tsGO
        ORARqk0rOIoltJoP3Lq6xCGpSA==
X-Google-Smtp-Source: APiQypLJTBUL+2+4Apj1ozbT3vs8eWnc03DsQNS2UzDY9+fj4p3EejYdi/YFzBetYav6I9LGsJP2xQ==
X-Received: by 2002:a5d:498b:: with SMTP id r11mr3722281wrq.368.1585836182081;
        Thu, 02 Apr 2020 07:03:02 -0700 (PDT)
Received: from revest.fritz.box ([2a02:168:ff55:0:c8d2:c098:b5ec:e20e])
        by smtp.gmail.com with ESMTPSA id p10sm7548565wrm.6.2020.04.02.07.03.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 07:03:01 -0700 (PDT)
Message-ID: <5968eda68bfec39387c34ffaf0ecc3ed5d8afd6f.camel@chromium.org>
Subject: Re: [RFC 0/3] bpf: Add d_path helper
From:   Florent Revest <revest@chromium.org>
To:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>, bgregg@netflix.com,
        Al Viro <viro@zeniv.linux.org.uk>
Date:   Thu, 02 Apr 2020 16:03:00 +0200
In-Reply-To: <20200401110907.2669564-1-jolsa@kernel.org>
References: <20200401110907.2669564-1-jolsa@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.1-2+build1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-04-01 at 13:09 +0200, Jiri Olsa wrote:
> hi,
> adding d_path helper to return full path for 'path' object.
> 
> I originally added and used 'file_path' helper, which did the same,
> but used 'struct file' object. Then realized that file_path is just
> a wrapper for d_path, so we'd cover more calling sites if we add
> d_path helper and allowed resolving BTF object within another object,
> so we could call d_path also with file pointer, like:
> 
>   bpf_d_path(&file->f_path, buf, size);
> 
> This feature is mainly to be able to add dpath (filepath originally)
> function to bpftrace, which seems to work nicely now, like:
> 
>   # bpftrace -e 'kretfunc:fget { printf("%s\n", dpath(args->ret-
> >f_path));  }' 
> 
> I'm not completely sure this is all safe and bullet proof and there's
> no other way to do this, hence RFC post.
> 
> I'd be happy also with file_path function, but I thought it'd be
> a shame not to try to add d_path with the verifier change.
> I'm open to any suggestions ;-)

First of all I want to mention that we are really interested in this
feature so thanks a lot for bringing it up Jiri! I have experimented
with similar BPF helpers in the past few months so I hope my input can
be helpful! :)

One of our use-cases is to gather information about execution events,
including a bunch of paths (such as the executable command, the
resolved executable file path and the current-working-directory) and
then output them to Perf.
Each of those paths can be up to PATH_MAX(one page) long so we would
pre-allocate a data structure with a few identifiers (to later
reassemble the event from userspace) and a page of data and then we
would output it using bpf_perf_event_output. However, with three mostly
empty pages per event, we would quickly fill up the ring buffer and
loose many events.
This might be a bit out-of-scope at this moment but one of the
teachings we got from playing with such a helper is that we would also
need a helper for outputting strings to Perf, pre-pended with a header
buffer.

