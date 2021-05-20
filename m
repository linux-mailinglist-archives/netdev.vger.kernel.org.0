Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9FC938A923
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 12:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236148AbhETK6R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 06:58:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49316 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238794AbhETKzz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 06:55:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621508073;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7otvyJfFGx8GAcUHC3BcMZ8usIl1fWAAFulYTKRs+wA=;
        b=bXiMMU4RLpLaaUnlRpZulO06F2FC2T2sN5aqVSgHoYi2Hjp0PrI/2xjCPcSreXgfZcYWKJ
        deuNW8vHa0B+hRypbplUNAgYytQXI91iNo4r7HJAXri179zKDKJSuLHnBedHOQ3WrIVOWn
        KLnvFvbUUL+bIKtUeNJd8jdzaCKQIR4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-143-0Aj5DPe7PdylZBFeE9RQ9A-1; Thu, 20 May 2021 06:54:31 -0400
X-MC-Unique: 0Aj5DPe7PdylZBFeE9RQ9A-1
Received: by mail-wm1-f71.google.com with SMTP id u203-20020a1cddd40000b029016dbb86d796so2182665wmg.0
        for <netdev@vger.kernel.org>; Thu, 20 May 2021 03:54:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7otvyJfFGx8GAcUHC3BcMZ8usIl1fWAAFulYTKRs+wA=;
        b=WZ8DrDYXnhaexxM0cIMUa55Xomr9rzp2cIJLyJV2HHf+JhnTZTDJOZe7E0DVOd9pcq
         bsVKFcu3RL1/u/J+tWK0NsFqIEMMj7W0HjLLOHZ+3LGQjdyxyEAlOE1T07w7ApxpuUDO
         ksWyNjWz4myp+YO5pU9oiLQk8rYUwCy8lcOu8laz0CD6mwUVDoNcIY+37ljV/loRpIJz
         hTvV5Ylt0emYUFcYsLy9FIc/NEty2N7N5yhtylx26s+yaMge7BduHINfqTZw9BpYWi2i
         9m3JE7/ggBNKVOBOnIVIIbLAQOFBCifaUfna/UbVoRZA8EBxNLANUVwEoXelVVP/SZUP
         YP4w==
X-Gm-Message-State: AOAM530eUqhiwJYhdr12Ryh/R8yjo5nXkX4z+9IItZHrlhM/LEjKk42E
        mU/JP+XfJUUNRGkXEXoA2R3lxM34DI/quIQEq80srTf+H0u0WCEW9Ji2wT7wkwdeIBbwDNTvd/L
        YfpPsvaPaYY11e/E8UNOVmGtMGIL/3/L4
X-Received: by 2002:a7b:c34a:: with SMTP id l10mr3057956wmj.46.1621508070492;
        Thu, 20 May 2021 03:54:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJySnorY2zM2ctuhMEtyyey99hxXHw4ViDXip3ZSVxjkFJPINpqGsK7RAU9UzfnxaIAsZf1eS/PhX6b0wzFm/1k=
X-Received: by 2002:a7b:c34a:: with SMTP id l10mr3057936wmj.46.1621508070251;
 Thu, 20 May 2021 03:54:30 -0700 (PDT)
MIME-Version: 1.0
References: <20210518155231.38359-1-lariel@nvidia.com> <CALnP8ZYUsuBRpMZzU=F0711RVZmwGRvLBEk09aM6MKDhAGrMFQ@mail.gmail.com>
In-Reply-To: <CALnP8ZYUsuBRpMZzU=F0711RVZmwGRvLBEk09aM6MKDhAGrMFQ@mail.gmail.com>
From:   Andrea Claudi <aclaudi@redhat.com>
Date:   Thu, 20 May 2021 12:54:19 +0200
Message-ID: <CAPpH65yhwRfv-fjj92c3v3HnUZGgu37p8s2DvgTOUYbJjCuYPA@mail.gmail.com>
Subject: Re: [PATCH iproute2-next 0/2] ] tc: Add missing ct_state flags
To:     Marcelo Ricardo Leitner <mleitner@redhat.com>
Cc:     Ariel Levkovich <lariel@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>, jiri@nvidia.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 20, 2021 at 3:15 AM Marcelo Ricardo Leitner
<mleitner@redhat.com> wrote:
> Is it me or this series didn't get to netdev@?
> I can't find it in patchwork nor lore archives.

I was about to ask the same question. Is this posted to a different
mailing list?

Cheers,
Andrea

