Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3E958CF4A
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 11:24:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726704AbfHNJYK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 05:24:10 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:38144 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725280AbfHNJYK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 05:24:10 -0400
Received: by mail-lf1-f67.google.com with SMTP id h28so78766879lfj.5
        for <netdev@vger.kernel.org>; Wed, 14 Aug 2019 02:24:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=aubLn8waLrcyH8GiaZ4/P2Bxuaos2txwyKIGB9Gh2j4=;
        b=Ul21S1lis1op8IKkes8RTEHlbkQVCappEErZbRKZ/80yD1dIJHnrjhrJnVl4ZjcgQH
         rErzc0XkGd3wrTdwfUdIqtGvVaKXlsAL1m25p/glBIDFtz01bh1s/XQsqo/IyGGEj5kP
         RSxwcnLmToLQfB2ZKWBlOqKh0IPrXdJi5KrOiDyC+8W95WCPep6e3aHN44Zbuq2CcccP
         f9Wd/C4An7+1P9XofbNvxTIhq317PFTTEav1onpxaVYmC8HJj+Zi6gHx+48H17X2Jhso
         JeveMcqq/+MMTR/VleApLzuBEw8Z2wlSbWOQLjtVwogWboOdh3cwse5vyml1MlxjXGi4
         ZDkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=aubLn8waLrcyH8GiaZ4/P2Bxuaos2txwyKIGB9Gh2j4=;
        b=c91rjG8+3fjDUQ49K5ZF5c2ePrGbq7givMzLuiupTUzFethJeieDbdT08IqSwW51X2
         wDkYN6mYxh7xL8RumrcGzR1YsQQStiTBKSF7Z/+HmB87nq8XfyyYpIM5kODJB2R3eWuL
         gg4PflkBXXuy6F4Umlb89hodmTLhPAJQna1W8lzecx05zXE7DTB72flZ9WhkluU1T7VE
         EUgTa9USOGAaiw6S4MW7RHVu09JnSp2VJKOz97NgO6ITtj/R/sZf8KcLSC/+haTOhqyN
         MkOGWWaIjUpGbdS2RTSKIfAO4TrNs3LhqvuAFS1TXcrleYSe+rdD6boJ4CBE+MbiYDSL
         U2nA==
X-Gm-Message-State: APjAAAXbmaFqYT61wEBFDLqq9MFD+uk4rjDtXz+Mh8PhY0w5fgmcWL1d
        e85+ZT/MdJjfUakEowxGetBKmQ==
X-Google-Smtp-Source: APXvYqw/IbZ9AUCs5SDIK+7WNXN+iu4AlM9c2hMq7+ZqfLDbxuqRkzN7aTSaafwrcI4AOd/xgKDPQg==
X-Received: by 2002:a19:6d02:: with SMTP id i2mr24317533lfc.191.1565774648121;
        Wed, 14 Aug 2019 02:24:08 -0700 (PDT)
Received: from khorivan (168-200-94-178.pool.ukrtel.net. [178.94.200.168])
        by smtp.gmail.com with ESMTPSA id r23sm228169ljm.59.2019.08.14.02.24.06
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 14 Aug 2019 02:24:07 -0700 (PDT)
Date:   Wed, 14 Aug 2019 12:24:05 +0300
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        xdp-newbies@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH bpf-next 1/3] libbpf: add asm/unistd.h to xsk to get
 __NR_mmap2
Message-ID: <20190814092403.GA4142@khorivan>
Mail-Followup-To: Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        xdp-newbies@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
References: <20190813102318.5521-1-ivan.khoronzhuk@linaro.org>
 <20190813102318.5521-2-ivan.khoronzhuk@linaro.org>
 <CAEf4BzZ2y_DmTXkVqFh6Hdcquo6UvntvCygw5h5WwrWYXRRg_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAEf4BzZ2y_DmTXkVqFh6Hdcquo6UvntvCygw5h5WwrWYXRRg_g@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 13, 2019 at 04:38:13PM -0700, Andrii Nakryiko wrote:

Hi, Andrii

>On Tue, Aug 13, 2019 at 3:24 AM Ivan Khoronzhuk
><ivan.khoronzhuk@linaro.org> wrote:
>>
>> That's needed to get __NR_mmap2 when mmap2 syscall is used.
>>
>> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
>> ---
>>  tools/lib/bpf/xsk.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
>> index 5007b5d4fd2c..f2fc40f9804c 100644
>> --- a/tools/lib/bpf/xsk.c
>> +++ b/tools/lib/bpf/xsk.c
>> @@ -12,6 +12,7 @@
>>  #include <stdlib.h>
>>  #include <string.h>
>>  #include <unistd.h>
>> +#include <asm/unistd.h>
>
>asm/unistd.h is not present in Github libbpf projection. Is there any

Look on includes from
tools/lib/bpf/libpf.c
tools/lib/bpf/bpf.c

That's how it's done... Copping headers to arch/arm will not
solve this, it includes both of them anyway, and anyway it needs
asm/unistd.h inclusion here, only because xsk.c needs __NR_*


>way to avoid including this header? Generally, libbpf can't easily use
>all of kernel headers, we need to re-implemented all the extra used
>stuff for Github version of libbpf, so we try to minimize usage of new
>headers that are not just plain uapi headers from include/uapi.

Yes I know, it's far away from real number of changes needed.
I faced enough about this already and kernel headers, especially
for arm32 it's a bit decency problem. But this patch it's part of
normal one. I have couple issues despite this normally fixed mmap2
that is the same even if uapi includes are coppied to tools/arch/arm.

In continuation of kernel headers inclusion and arm build:

For instance, what about this rough "kernel headers" hack:
https://github.com/ikhorn/af_xdp_stuff/commit/aa645ccca4d844f404ec3c2b27402d4d7848d1b5

or this one related for arm32 only:
https://github.com/ikhorn/af_xdp_stuff/commit/2c6c6d538605aac39600dcb3c9b66de11c70b963

I have more...

>
>>  #include <arpa/inet.h>
>>  #include <asm/barrier.h>
>>  #include <linux/compiler.h>
>> --
>> 2.17.1
>>

-- 
Regards,
Ivan Khoronzhuk
