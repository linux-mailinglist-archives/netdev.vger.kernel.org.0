Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6E79319830
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 03:06:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbhBLCGh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 21:06:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbhBLCGf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 21:06:35 -0500
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C927DC061574;
        Thu, 11 Feb 2021 18:05:54 -0800 (PST)
Received: by mail-lj1-x22b.google.com with SMTP id q14so9829156ljp.4;
        Thu, 11 Feb 2021 18:05:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OiSkEcgchNsmSgBtf3fnMQzPIwmJ5tn4k1eUNo1HXyg=;
        b=ZBl8t/0TZL9DZivfE/IbgOPqpTHjguBG9nvWcvcI2fWez4rQfe6X4x3np/lGkOMV8d
         HN+C2nPfeG8ecfuKiA3rrSJMCkZuRuXivK6wzi3Gg1B8odvsfCp0DbhDpDAcflj170Yi
         v9kerAdvli1XESufLDKL5vZ2wJ1/m+MQSUB2Foc29vfhkiQyVxFaGMWyIVjdbMNJPbCC
         76LEPPhaDLD/2j/Q89DT6FZzt9Cm1JpyOP/Od+RpgNvDOawyVIKewDrnROnlaM6VMwNh
         t10A6jQDJSON+KrouGv/Eui7AIg9RmChd2KHXa0fucBiKJHEh6TNs7e4xKf7B2z8pizo
         whCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OiSkEcgchNsmSgBtf3fnMQzPIwmJ5tn4k1eUNo1HXyg=;
        b=qQS6rxqcfkANpbW6KdgGJpvnhhUpeqnctsH70cOudWeBstGaqFnv5+F0OqWjWpFygm
         go2Zy4d8n4/FTATLcrKJ5Zh5COyLkRqY7Fv5JSKA2hICNw8JSoK5FRDqlrleby0zOIUo
         MRYOdDhyBqSnFqW9zKX+WgMnMNVPLIMlL/4hEA47yI2ScuUhYaPZxv/0f5yMRNhTcjmh
         G9mwDXOHFc2MfpXOFWj4b1ElXZlcWYirpKj7NHGqt+sc5QJybnTarhnpYJ3mV4Ri6jxS
         i4ixT1kJktc4lWf7gfN2Cev79e14+z0VMUYcN8X32b2cRhvHx/aBd+FJGc6hn27KD383
         Byvg==
X-Gm-Message-State: AOAM533kmkDkhCkkLxrwI/Yex9P9IPZt3cc8bkz6wDZXxEn1LEbyxczh
        B6rgB2wzOGwxXJJPtI22KBLgz/xOI2qrflkMx9nZtMBWU1g=
X-Google-Smtp-Source: ABdhPJwKXqZN2gQ+HMFhDevuqT9eVhQMLKz5LWoKxPET6Lm95PKNH0TkH+6IOxIe8x5GzJC32PyD42Jith/zeyTT4Wo=
X-Received: by 2002:a2e:700c:: with SMTP id l12mr371556ljc.236.1613095553180;
 Thu, 11 Feb 2021 18:05:53 -0800 (PST)
MIME-Version: 1.0
References: <20201204102901.109709-1-marekx.majtyka@intel.com>
 <20201209125223.49096d50@carbon> <e1573338-17c0-48f4-b4cd-28eeb7ce699a@gmail.com>
 <1e5e044c8382a68a8a547a1892b48fb21d53dbb9.camel@kernel.org>
 <cb6b6f50-7cf1-6519-a87a-6b0750c24029@gmail.com> <f4eb614ac91ee7623d13ea77ff3c005f678c512b.camel@kernel.org>
 <d5be0627-6a11-9c1f-8507-cc1a1421dade@gmail.com> <6f8c23d4ac60525830399754b4891c12943b63ac.camel@kernel.org>
 <CAAOQfrHN1-oHmbOksDv-BKWv4gDF2zHZ5dTew6R_QTh6s_1abg@mail.gmail.com>
 <87h7mvsr0e.fsf@toke.dk> <CAAOQfrHA+-BsikeQzXYcK_32BZMbm54x5p5YhAiBj==uaZvG1w@mail.gmail.com>
 <87bld2smi9.fsf@toke.dk> <20210202113456.30cfe21e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAAOQfrGqcsn3wu5oxzHYxtE8iK3=gFdTka5HSh5Fe9Hc6HWRWA@mail.gmail.com>
 <20210203090232.4a259958@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <874kikry66.fsf@toke.dk> <20210210103135.38921f85@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <87czx7r0w8.fsf@toke.dk> <20210211172603.17d6a8f6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210211172603.17d6a8f6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 11 Feb 2021 18:05:41 -0800
Message-ID: <CAADnVQJ_juVMxSKUvHBEsLNQoJ4mvkqyAV8XF4mmz-dO8saUzQ@mail.gmail.com>
Subject: Re: [PATCH v2 bpf 1/5] net: ethtool: add xdp properties flag set
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Marek Majtyka <alardam@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        bpf <bpf@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 11, 2021 at 5:26 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> Perhaps I had seen one too many vendor incompatibility to trust that
> adding a driver API without a validation suite will result in something
> usable in production settings.

I agree with Jakub. I don't see how extra ethtool reporting will help.
Anyone who wants to know whether eth0 supports XDP_REDIRECT can already do so:
ethtool -S eth0 | grep xdp_redirect

I think converging on the same stat names across the drivers will make
the whole thing much more user friendly than new apis.
