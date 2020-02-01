Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9297B14F5F4
	for <lists+netdev@lfdr.de>; Sat,  1 Feb 2020 03:53:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726708AbgBACxe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 21:53:34 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:36634 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726475AbgBACxd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 21:53:33 -0500
Received: by mail-ot1-f65.google.com with SMTP id j20so101778otq.3;
        Fri, 31 Jan 2020 18:53:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=i+rFn/FCvW27/b5bLIjZVOhUbNdnFH0nmoSUa8PH9yE=;
        b=MXrbMdjJiEDw8G2LULlk+h2lXrUuWlwzvd2ed1P0CIQXb4W6OO61uGiqNVZCqWe8Fx
         0gSGMXKBfwEbY98DVTICjKN9w4WR88n/m0YmC+gbg8IY35nE4PwpSw24xls4EsyijbWJ
         i6R3M2pE6yCDurSjqL2slGxkYA+Z2bNds7sNL32Rukw0R+3Iwn8Utj7HIR/HKfyWbOmH
         GTS1HjuhtQ9jKo3A0Y31LjIaMAbWX0U5JItxZqcJmq7kmpoNDjUfOjiImOg6wXn0FHHM
         /Q0flcL2kpaVEHBlM87VXpUqJCp09PSD0NGW30X+vszs/i7KYUPRSdvl3HqvwD5Nb1+r
         g/MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=i+rFn/FCvW27/b5bLIjZVOhUbNdnFH0nmoSUa8PH9yE=;
        b=N6QuzWWPKUZBDXi8LNG1Etth45dIzBpGmIWEHJXrd0B1V2Nc6G8kQA8rLJj4pegOhy
         1t0foA7TFHxwAQz88PiD7KTnc1ZOE2wjXJfazmZjDCDEYyVXo1sY1nzEfajg+8SSpqlG
         StH3OCKJDWPcW8iBtB/lbpT37Rbkz9xDiCtvydaOCLLV+e5cQkFCB1VLPh/CRK4BhpYb
         8ogJyvEt+2RnzIiyPzHeeAXRJgSlWJXXl/f42uGoOERhG3lQpGAzqmL19yv12bSNu0cJ
         CwbuBEgDzVmkpQEVYFmk7gzYXDLvcBXlFfmzMr2fmyeOV0B+EX/SebGn9Cz+C37ukAEO
         ccfQ==
X-Gm-Message-State: APjAAAXzh7mLjenlI08W0q6hGzwlpylrjCMyMWPuzgtv5boQywfPjWiu
        s7mmSTTiBRSlY2LBMUZ97iEpqu8DMzF+qsHZYJw=
X-Google-Smtp-Source: APXvYqxSrwMeTURHIvrZyG6ZHtWjgMHkHeCxhI+3hyiH6jdgQuvFG5pknmIEdhvVmoVa6mnLJtLlmOkx/MCv25A1nxg=
X-Received: by 2002:a9d:664a:: with SMTP id q10mr9427780otm.298.1580525612955;
 Fri, 31 Jan 2020 18:53:32 -0800 (PST)
MIME-Version: 1.0
References: <20200131205216.22213-1-xiyou.wangcong@gmail.com>
 <20200131205216.22213-4-xiyou.wangcong@gmail.com> <20200131220807.GJ795@breakpoint.cc>
 <CAM_iQpVVgkP8u_9ez-2fmrJDdKoFwAxGcbE3Mmk3=7cv4W_QJQ@mail.gmail.com> <20200131233659.GM795@breakpoint.cc>
In-Reply-To: <20200131233659.GM795@breakpoint.cc>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 31 Jan 2020 18:53:21 -0800
Message-ID: <CAM_iQpWbejoFPbFDSfUtvhFbU3DjhV6NAkPQ+-mirY_QEMHxkA@mail.gmail.com>
Subject: Re: [Patch nf 3/3] xt_hashlimit: limit the max size of hashtable
To:     Florian Westphal <fw@strlen.de>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        syzbot <syzbot+adf6c6c2be1c3a718121@syzkaller.appspotmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 31, 2020 at 3:37 PM Florian Westphal <fw@strlen.de> wrote:
> O would propose a max alloc size (hard limit) of ~8 MByte of vmalloc
> space, or maybe 16 at most.
>
> 1048576 max upperlimit -> ~8mbyte vmalloc request -> allows to store
> up to 2**23 entries.

Changing HASHLIMIT_MAX_SIZE to 1048576 seems fine.

>
> In order to prevent breaking userspace, perhaps make it so that the
> kernel caps cfg.max at twice that value?  Would allow storing up to
> 16777216 addresses with an average chain depth of 16 (which is quite
> large).  We could increase the max limit in case someone presents a use
> case.
>

Not sure if I understand this, I don't see how cap'ing cfg->max could
help prevent breaking user-space? Are you suggesting to cap it with
HASHLIMIT_MAX_SIZE too? Something like below?

+       if (cfg->max > 2 * HASHLIMIT_MAX_SIZE)
+               cfg->max = 2 * HASHLIMIT_MAX_SIZE;

Thanks.
