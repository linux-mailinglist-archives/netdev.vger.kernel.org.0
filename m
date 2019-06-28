Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B991A59134
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 04:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbfF1Cgp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 22:36:45 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:44306 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725770AbfF1Cgp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 22:36:45 -0400
Received: by mail-pg1-f193.google.com with SMTP id n2so1878435pgp.11
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 19:36:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=lb6M/rv6FXwSZX6Qrby2H3VultnUQP+uPdwQ2YTWync=;
        b=izvJLtg6DwTZkfloSk2EPhkOsz27hMAIvy3JpDWqdhMSVYGbsnmqysH3OMgSk7Dk0q
         2DCvcitm5R1Rd9awSsIIhlBjKwp/scRV5DbuDizwFjpuTo5o1aLenNGbTxv/AyTuE4Rh
         gBK7aIIFGUm8lobH3dJg4u+XhdHxHSy4IHBlcqx3FA09VHPZgrUERATHc98WpJl5IV5h
         i2u57zPbMF8GA+W/gu4YuOqD+6UsxI/iMgeNWiQ7y8SNwUYBA4ddYgasySrNiMh++2B9
         HXRUzQx6OabY71uje2Q7otDAvElI4aJxgOdlpB8oYCwGvs9bfwPs2SnwZXKhNurv2aSr
         n3XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=lb6M/rv6FXwSZX6Qrby2H3VultnUQP+uPdwQ2YTWync=;
        b=cgzWfHJ3mRI6AleKJM+oY5a5BGiSWmGifAzoVOMpjgrAJHKFOVij1h7eYHl5prXcyl
         BOwnIX5ffI4RZ+BCZjalQkP7XtWmgpfZ/rwKKeWmkroUa669VeV0L7ooavPGoY8pnaxP
         nHnivMrYquISAk5IqfvGTVFAFQ0TXyb0DARFKZlSNMNKzvE52oyzUDyMZhiuQho8kU4H
         Js+sEraI942XyqZV4H+/Wk414juK9gTjxGA98+mEKLfZkePJrIpISrPJFKSXka4YEy5X
         TGmYEGPJhp2NMFYwQBpIJUwBom2LqA6ssIaYu4HSqT9wE5yNsURzQHKsLA3Jky5hwUKe
         kc1w==
X-Gm-Message-State: APjAAAUKncYQhOG2s0vDCsSMxD2hptLHWaWvojUB31dzNuvbZRi5uCtG
        nbJatQ55yMyXvhZ0M6M6u00=
X-Google-Smtp-Source: APXvYqw0dTfYpGmqfCIaCeaeXVM0rs+Lg8o/NNv8GFrvTOGgrLq4DJIzdEj4DY3SFkIlxCG18rSA4g==
X-Received: by 2002:a63:4c14:: with SMTP id z20mr6871145pga.360.1561689404323;
        Thu, 27 Jun 2019 19:36:44 -0700 (PDT)
Received: from [172.26.126.192] ([2620:10d:c090:180::1:1d68])
        by smtp.gmail.com with ESMTPSA id a21sm460820pfi.27.2019.06.27.19.36.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Jun 2019 19:36:43 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Jakub Kicinski" <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com, saeedm@mellanox.com,
        maximmi@mellanox.com, brouer@redhat.com, kernel-team@fb.com
Subject: Re: [PATCH 4/6 bfp-next] Simplify AF_XDP umem allocation path for
 Intel drivers.
Date:   Thu, 27 Jun 2019 19:36:42 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <32DD3CE5-327F-4D76-861B-7256F3F10EC9@gmail.com>
In-Reply-To: <20190627154206.5d458e94@cakuba.netronome.com>
References: <20190627220836.2572684-1-jonathan.lemon@gmail.com>
 <20190627220836.2572684-5-jonathan.lemon@gmail.com>
 <20190627154206.5d458e94@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; markup=markdown
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 27 Jun 2019, at 15:42, Jakub Kicinski wrote:

> On Thu, 27 Jun 2019 15:08:34 -0700, Jonathan Lemon wrote:
>> Now that the recycle stack is always used for the driver umem path, the
>> driver code path can be simplified.
>>
>> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
>
> I guess it's a question to Bjorn and Magnus whether they want Intel
> drivers to always go through the reuse queue..

I did pass this by them earlier.


> Could you be more explicit on the motivation?  I'd call this patch set
> "make all drivers use reuse queue" rather than "clean up".

The motivation is to have packets which were received on a zero-copy
AF_XDP socket, and which returned a TX verdict from the bpf program,
queued directly on the TX ring (if they're in the same napi context).

When these TX packets are completed, they are placed back onto the
reuse queue, as there isn't really any other place to handle them.

It also addresses Maxim's concern about having buffers end up sitting
on the rq after a ring resize.

I was going to send the TX change out as part of this patch, but
figured it would be better split unto its own series.

> Also when you're changing code please make sure you CC the author.

Who did I miss?
-- 
Jonathan
