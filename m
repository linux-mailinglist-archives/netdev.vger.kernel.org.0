Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55DB95912D
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 04:31:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726646AbfF1Cb3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 22:31:29 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:33581 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726441AbfF1Cb3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 22:31:29 -0400
Received: by mail-pf1-f195.google.com with SMTP id x15so2181945pfq.0
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 19:31:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=1PKN92TywCZCG1FnyYs8ssImhkD9mXlN88ych9w/A6g=;
        b=Se5Nff8DKgbNbaTtQybgZ1F0dnUdr92u5Kau5bpUUsq2KjpDkrQmXmvVf1Mh1Qe5np
         UaPugJQwilCpzm13RIQaunK7oB7fLVyiG1QmsvaFbfmeI+QtqEADUW4CIEKS8Sab2fgF
         DKZEfVQTRC533Bw/H6FJ8RBT4HpJqokJxmIQ58UzgRh3fnbVlxTzZkwz9ZffwXJGv8Zs
         CjrwtEEsz2KoE8r1OBQKPIav2vaKYtn+ScKG8p1Nh1zNM7DmdBvYNy6HlSb1Uo8gGJhJ
         CYhJFtLOB1ajxDjPJxXjQdH5sDKhExfeCtBAkJO/gtBwrArok/vF7Tr3+io6GizSwaQ/
         5Xpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=1PKN92TywCZCG1FnyYs8ssImhkD9mXlN88ych9w/A6g=;
        b=W7Z+OC9YLD4+1THzlasPXvoyKocJwESALaY4vQRpNXk1bfDyGWi6Atl+hwE49ZzVqH
         S3Pj8vk4cQot9oqeHUAZBCo/4auA+jrywkVVs9e1NIlT9Cy1IwosZOEcd8suBHSgd12C
         Qgm/24olFlbq4lyidXyy0y7KZb/Fr+FmB7K8gY+OAEDf8LhaoDFYLm2XewJjmRPpQhFT
         smZeAvF6ggkwRzUYdj+1OGZsGGxLkITD5C0KXXBj/LgDW4ph/6yB6Wc2NJFbGYemm7nb
         DtjXuodoS21+yhJbYfuVtQho8DZW8FqtqSzWYpHmRF6i4a0blf8szEqVabcAGvnkrXDg
         b6Ew==
X-Gm-Message-State: APjAAAVjZyiejKl1+SPZBJyW+xusq7/OQ1tvUE1UFVmBs/6i6h6JdMXk
        8QmqK3CxpsBZMC1nJ2/lEBE=
X-Google-Smtp-Source: APXvYqymBl0F3NFQbG2pyWAQJk50Be4YpA3T+4oJWbP4ljf6qj1qFSLvWDW4ZvIkUQLANzxg0Btkzw==
X-Received: by 2002:a63:8b4c:: with SMTP id j73mr6988086pge.11.1561689088637;
        Thu, 27 Jun 2019 19:31:28 -0700 (PDT)
Received: from [172.26.126.192] ([2620:10d:c090:180::1:1d68])
        by smtp.gmail.com with ESMTPSA id y22sm382732pgj.38.2019.06.27.19.31.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Jun 2019 19:31:27 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Jakub Kicinski" <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com, saeedm@mellanox.com,
        maximmi@mellanox.com, brouer@redhat.com, kernel-team@fb.com
Subject: Re: [PATCH 2/6 bpf-next] Clean up xsk reuseq API
Date:   Thu, 27 Jun 2019 19:31:26 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <8E97A6A3-2B8D-4E03-960B-8625DA3BA4FF@gmail.com>
In-Reply-To: <20190627153856.1f4d4709@cakuba.netronome.com>
References: <20190627220836.2572684-1-jonathan.lemon@gmail.com>
 <20190627220836.2572684-3-jonathan.lemon@gmail.com>
 <20190627153856.1f4d4709@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 27 Jun 2019, at 15:38, Jakub Kicinski wrote:

> On Thu, 27 Jun 2019 15:08:32 -0700, Jonathan Lemon wrote:
>> The reuseq is actually a recycle stack, only accessed from the kernel 
>> side.
>> Also, the implementation details of the stack should belong to the 
>> umem
>> object, and not exposed to the caller.
>>
>> Clean up and rename for consistency in preparation for the next 
>> patch.
>>
>> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
>
> Prepare/swap is to cater to how drivers should be written - being able
> to allocate resources independently of those currently used.  Allowing
> for changing ring sizes and counts on the fly.  This patch makes it
> harder to write drivers in the way we are encouraging people to.
>
> IOW no, please don't do this.

The main reason I rewrote this was to provide the same type
of functionality as realloc() - no need to allocate/initialize a new
array if the old one would still end up being used.  This would seem
to be a win for the typical case of having the interface go up/down.

Perhaps I should have named the function differently?
-- 
Jonathan
