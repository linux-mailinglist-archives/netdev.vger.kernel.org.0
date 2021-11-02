Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B7AA442F18
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 14:30:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230336AbhKBNdH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 09:33:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50258 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230124AbhKBNdE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 09:33:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635859829;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7a9fwdqVobQq7YV4q5QN50HHW7MqP/6FfVQWJ5UuQoY=;
        b=T9HR8agO5XpeF3a9y/hs9MEFdiC/7MJ0HeNPai0lNJW8EM3L+AHH15yUTGHU4gsxdeJDjN
        bIkBnRnaXwv7iTp6+22A5DZU4ryf6/l4PJh2R0oomxqn20tpiBsSNkYiZFRlz+bwuFz6ey
        6q8JiBhONMSNx48vShLetN+DABj1EmI=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-506-CUHeYJzcPtOfR6Yo7TQB6w-1; Tue, 02 Nov 2021 09:30:19 -0400
X-MC-Unique: CUHeYJzcPtOfR6Yo7TQB6w-1
Received: by mail-ed1-f69.google.com with SMTP id v9-20020a50d849000000b003dcb31eabaaso18908848edj.13
        for <netdev@vger.kernel.org>; Tue, 02 Nov 2021 06:30:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7a9fwdqVobQq7YV4q5QN50HHW7MqP/6FfVQWJ5UuQoY=;
        b=hbNXt8BtSqCwFyErBfjQjBi8wLuhEbTD804wVP7z/EFSHJLH34ODDF49qgUXj3dHEy
         i2IFKomk+hBcXynNJGqt1rbRuhnPI4BSBa1kghEN+QDaQVxvd9ZabtDEZH02rq0jFW+I
         /a32/QxHs79VcAn5aCsbxHz3K4w2tcmV4Xw99MKe6rGm+RbtAkxJHdiIkuMDXfaPRE5w
         HRFqm/DcxcDBY5dv0BUk70e/sCd5luM4YpitwtyF4YK2q+A/e49qQNuxWglXffUBOs4U
         NJdpcEzYAI8sjMzpQYqtawq1B0WvjVH19mi5HC2pHwxxX490zf+hkB2qD7hRLw50j2yO
         2xuQ==
X-Gm-Message-State: AOAM532eO+q7/+5t2cRNJhxx71sWxZPmzUHxW55fGwgkFzorM7jX4XAx
        u3QzAgj7ddceleSkPGB9GRp10m9xDKphEsLURrNUWDeuCJgC0ap56XQN/XSemEMHzSUNlt1f+71
        YrIpgmVGhieWiO7BU
X-Received: by 2002:a17:907:8a20:: with SMTP id sc32mr19224478ejc.65.1635859818366;
        Tue, 02 Nov 2021 06:30:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw1KP4w7cRqQTgNk3Posz5punPXW0XvK5doe+IuPA7lypbSniV0SwOMyOUyhVgi2mIDO32HVw==
X-Received: by 2002:a17:907:8a20:: with SMTP id sc32mr19224458ejc.65.1635859818233;
        Tue, 02 Nov 2021 06:30:18 -0700 (PDT)
Received: from krava ([83.240.63.48])
        by smtp.gmail.com with ESMTPSA id u16sm8178560ejy.16.2021.11.02.06.30.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Nov 2021 06:30:17 -0700 (PDT)
Date:   Tue, 2 Nov 2021 14:30:15 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        keescook@chromium.org, kvalo@codeaurora.org,
        miriam.rachel.korenblit@intel.com
Subject: Re: [GIT PULL] Networking for 5.16
Message-ID: <YYE9Z3wUs9HqcqhV@krava>
References: <20211102054237.3307077-1-kuba@kernel.org>
 <CAHk-=wgdE6=ob5nF60GvRYAG24MKaJBGJf3jPufMe1k_UPBQTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgdE6=ob5nF60GvRYAG24MKaJBGJf3jPufMe1k_UPBQTA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 02, 2021 at 06:20:35AM -0700, Linus Torvalds wrote:
> On Mon, Nov 1, 2021 at 10:43 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> >   git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git tags/net-next-for-5.16
> 
> I get quite a lot of
> 
>     ./scripts/pahole-flags.sh: line 7: return: can only `return' from
> a function or sourced script
> 
> with this. Why didn't anybopdy else notice? It seems entirely bogus
> and presumably happens everywhere else too.
> 
> It's shell script. You don't "return" from it. You "exit" from it.
> 
> Grr.

ugh, sorry.. I'll send the fix shortly

jirka

> 
>                  Linus
> 

