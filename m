Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E8F8442F90
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 14:57:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231251AbhKBN7q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 09:59:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47389 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231265AbhKBN7p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 09:59:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635861430;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8hWPJncMYXrUAM7YbhPFPse1fZOJqjiHJzD+bjPBA+Y=;
        b=Brvzn66vjIq2JlFQo7oqbz5VJ5LcjdBNoEDe071yuliCNSfHnkxK97dZSLGUuTpUGtRTqN
        oFKoJ90dBtdEcOm9C4VSVal7TGrqA3w7YzEXtkLBxta6O7Z2YDK9iQ5zmKadbVGQ/mdBvx
        tll+o3VTa3w+T/5hbkTXbeLtN8CtbzU=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-432-sIuthZ4eOL6oSOaite3dLQ-1; Tue, 02 Nov 2021 09:57:09 -0400
X-MC-Unique: sIuthZ4eOL6oSOaite3dLQ-1
Received: by mail-ed1-f71.google.com with SMTP id v9-20020a50d849000000b003dcb31eabaaso18990810edj.13
        for <netdev@vger.kernel.org>; Tue, 02 Nov 2021 06:57:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8hWPJncMYXrUAM7YbhPFPse1fZOJqjiHJzD+bjPBA+Y=;
        b=MiheRkSEq5sV7ouO2BXKSiPHw2M5Tokk0ywtoeCO8REureo0d5Ikw09p0oWhwtds0/
         q4fMDwnRfexfR+VrHfihuXVsiqqjTOZelW/ekrsQU4uKIygc0sLNCzSexoOUjQKrBqrI
         YgrVRoajOZ1qSpUt8I3/FJ/VvSrocLRcGAnk0DWaLQgwWSPlzGq1zh7cmjDXaI5UgU8U
         t4LI7guQtOkboBXnek8BmXrrWIc4qAIrHEpIcclASILdWyi1PGdqBlMK8KpUFRwO81Hf
         J5HlRZmcY9Ben4I41aqBW5mRQcU3V2PaUQQw1Woa1iprzpJ51fAeMd2Xk9YQDGojSt3K
         HvMg==
X-Gm-Message-State: AOAM531i8DYdU9yzpeuJQtujfe5R6HhvimYne2pwQYArbXyX0YhhtpGQ
        oTGJdRZpLMl9wQHzl1Zrewqi8b7nw5PEmbVzDyI3KAzVg5OfyWfsaV8YWZXwoOuSD/ORx6LepB5
        5WiKwQY6zXYEFbh+z
X-Received: by 2002:a17:906:58c1:: with SMTP id e1mr45931841ejs.327.1635861428303;
        Tue, 02 Nov 2021 06:57:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwB7LW8MoKLEp5zUCiihU6KobP/FCnE1R9g2oQTU/Yp/ma7WxnEyecxqcz2ZH11YTTWj4HjOw==
X-Received: by 2002:a17:906:58c1:: with SMTP id e1mr45931807ejs.327.1635861428055;
        Tue, 02 Nov 2021 06:57:08 -0700 (PDT)
Received: from krava ([83.240.63.48])
        by smtp.gmail.com with ESMTPSA id i5sm3847336eje.15.2021.11.02.06.57.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Nov 2021 06:57:07 -0700 (PDT)
Date:   Tue, 2 Nov 2021 14:57:06 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "Korenblit, Miriam Rachel" <miriam.rachel.korenblit@intel.com>
Subject: Re: [GIT PULL] Networking for 5.16
Message-ID: <YYFDsi2eRXcK+C4v@krava>
References: <20211102054237.3307077-1-kuba@kernel.org>
 <CAHk-=wgdE6=ob5nF60GvRYAG24MKaJBGJf3jPufMe1k_UPBQTA@mail.gmail.com>
 <YYE9Z3wUs9HqcqhV@krava>
 <CAHk-=wgPZM4bN=LUCrMkG3FX808QSLm6Uv6ixm5P350_7c=xUw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgPZM4bN=LUCrMkG3FX808QSLm6Uv6ixm5P350_7c=xUw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 02, 2021 at 06:32:13AM -0700, Linus Torvalds wrote:
> On Tue, Nov 2, 2021 at 6:30 AM Jiri Olsa <jolsa@redhat.com> wrote:
> >
> > ugh, sorry.. I'll send the fix shortly
> 
> Well, I turned the "return" into "exit 0" and the end result works for me.
> 
> Holler if you think it should be anything else (like a non-zero exit).

exit 0 is good,

thanks,
jirka

