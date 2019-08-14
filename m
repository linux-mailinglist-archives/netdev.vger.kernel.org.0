Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42C2D8D6DF
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 17:09:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728021AbfHNPJl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 11:09:41 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:38597 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727273AbfHNPJl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 11:09:41 -0400
Received: by mail-lj1-f193.google.com with SMTP id r9so105121731ljg.5
        for <netdev@vger.kernel.org>; Wed, 14 Aug 2019 08:09:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=2ptfAgVpyIEhhkDUXUHOQeIgB7V3ChTfM7YuAb134Kg=;
        b=x2n6+rP6ZwrFCjfm8bFO/Vk4gMraybEkDtn/pwBnfQQjn651Lm6f83/MXyyR8JDaJE
         0tRK/p9cifp44E0FTnkOFanairQJNzX1c1zeImZ08ypWdY+O3vhaXoleBFSqBlh1/WyQ
         3nw5aLY8qaAOkW4Kr27WJdta4q7KRfmbDPzyjCe94MN8cML68DixxuMWmWQZsCDEP9vU
         WZrbCO9PrBo1mpyeFxRE6BB+JsO9MV5inELKKQU+MM8jr/Dd+EPbD4squSjv2Euk0nKK
         kgtq7iRzdyBwtJyGbcbx6KhvBupL4J3XvuPS4oMY2Ri/cWI5dK+TbVzUVWhCwFsKuonO
         DJ6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=2ptfAgVpyIEhhkDUXUHOQeIgB7V3ChTfM7YuAb134Kg=;
        b=YGZpMiAjJ3LHKlpt1ywfPJ7EpOJRcy6I7wY1gRmUovLGbzTM5x8Xf4qYyDzQCbashy
         DvU2bibW+yNiWEVj7a4XdGHNl3iV2W4W5RgShgzRNvjIBB8QnltywBbBd/a3HuCNDww/
         Cb2KD2J4rIYg3mevhQjuz8s/3hr/2lntDxOZGjDQPstWK96Lq/4BVSkqQ+kZMFRNqkk4
         POr4m1z2y8TotEftk+wriv5DM0LlITZcIRZhbAFXnuFANTPohpIeD9fsY+uc8la9JqOa
         o7gHA2w5yBC41A7y27l7Xvrg3LBnfi6wJW+4c5+SUPV4GLVS9qQz3QLTVYkiJhZQEWjY
         kj6w==
X-Gm-Message-State: APjAAAVBJ8YgOLEBwlGonQTvhwmhRi6GJe3pdV+W1UGmpa1JdJnTocZb
        2qeL3Hgs6ERqCUlAknUflfiujA==
X-Google-Smtp-Source: APXvYqyAM8eXnr+Jy6s24b158nlo/qNRMKZlplURPgkyhCKBGAc5pooN4Mik7Peninx/2IsQdmdO8w==
X-Received: by 2002:a2e:81c3:: with SMTP id s3mr162966ljg.70.1565795378768;
        Wed, 14 Aug 2019 08:09:38 -0700 (PDT)
Received: from khorivan (168-200-94-178.pool.ukrtel.net. [178.94.200.168])
        by smtp.gmail.com with ESMTPSA id l8sm2347lja.38.2019.08.14.08.09.37
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 14 Aug 2019 08:09:38 -0700 (PDT)
Date:   Wed, 14 Aug 2019 18:09:36 +0300
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     bjorn.topel@intel.com, linux-mm@kvack.org,
        xdp-newbies@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org, ast@kernel.org,
        magnus.karlsson@intel.com
Subject: Re: [PATCH v2 bpf-next] mm: mmap: increase sockets maximum memory
 size pgoff for 32bits
Message-ID: <20190814150934.GD4142@khorivan>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
        bjorn.topel@intel.com, linux-mm@kvack.org,
        xdp-newbies@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org, ast@kernel.org,
        magnus.karlsson@intel.com
References: <20190812113429.2488-1-ivan.khoronzhuk@linaro.org>
 <20190812124326.32146-1-ivan.khoronzhuk@linaro.org>
 <20190812141924.32136e040904d0c5a819dcb1@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190812141924.32136e040904d0c5a819dcb1@linux-foundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 12, 2019 at 02:19:24PM -0700, Andrew Morton wrote:

Hi, Andrew

>On Mon, 12 Aug 2019 15:43:26 +0300 Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org> wrote:
>
>> The AF_XDP sockets umem mapping interface uses XDP_UMEM_PGOFF_FILL_RING
>> and XDP_UMEM_PGOFF_COMPLETION_RING offsets. The offsets seems like are
>> established already and are part of configuration interface.
>>
>> But for 32-bit systems, while AF_XDP socket configuration, the values
>> are to large to pass maximum allowed file size verification.
>> The offsets can be tuned ofc, but instead of changing existent
>> interface - extend max allowed file size for sockets.
>
>
>What are the implications of this?  That all code in the kernel which
>handles mapped sockets needs to be audited (and tested) for correctly
>handling mappings larger than 4G on 32-bit machines?  Has that been

That's to allow only offset to be passed, mapping length is less than 4Gb.
I have verified all list of mmap for sockets and all of them contain dummy
cb sock_no_mmap() except the following:

xsk_mmap()
tcp_mmap()
packet_mmap()

xsk_mmap() - it's what this fix is needed for.
tcp_mmap() - doesn't have obvious issues with pgoff - no any references on it.
packet_mmap() - return -EINVAL if it's even set.


>done?  Are we confident that we aren't introducing user-visible buggy
>behaviour into unsuspecting legacy code?
>
>Also...  what are the user-visible runtime effects of this change?
>Please send along a paragraph which explains this, for the changelog.
>Does this patch fix some user-visible problem?  If so, should be code
>be backported into -stable kernels?
It should go to linux-next, no one has been using it till this patch
with 32 bits as w/o this fix af_xdp sockets can't be used at all.
It unblocks af_xdp socket usage for 32bit systems.


That's example of potential next commit message:
Subject: mm: mmap: increase sockets maximum memory size pgoff for 32bits

The AF_XDP sockets umem mapping interface uses XDP_UMEM_PGOFF_FILL_RING
and XDP_UMEM_PGOFF_COMPLETION_RING offsets.  These offsets are established
already and are part of the configuration interface.

But for 32-bit systems, using AF_XDP socket configuration, these values
are too large to pass the maximum allowed file size verification.  The
offsets can be tuned off, but instead of changing the existing interface,
let's extend the max allowed file size for sockets.

No one has been using it till this patch with 32 bits as w/o this fix
af_xdp sockets can't be used at all, so it unblocks af_xdp socket usage
for 32bit systems.

All list of mmap cbs for sockets were verified on side effects and
all of them contain dummy cb - sock_no_mmap() at this moment, except the
following:

xsk_mmap() - it's what this fix is needed for.
tcp_mmap() - doesn't have obvious issues with pgoff - no any references on it.
packet_mmap() - return -EINVAL if it's even set.




Is it ok to be replicated in PATCH v2 or this explanation is enough here
to use v1?

-- 
Regards,
Ivan Khoronzhuk
