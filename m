Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 297DB1A0A0C
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 11:28:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728073AbgDGJ16 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 05:27:58 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40465 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726353AbgDGJ16 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 05:27:58 -0400
Received: by mail-wr1-f66.google.com with SMTP id s8so3021470wrt.7
        for <netdev@vger.kernel.org>; Tue, 07 Apr 2020 02:27:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=X4ebnL9FKFq17X3pHCnu37OOFN1BcUTTkawnKuPEaf4=;
        b=PxCV+msgjJfTVEbXmYgWagz9SMQD/gPBV15QP9rDBb9WK67XC2KO/GGSeUHh8ysbAi
         9UDAn1MQ1imc604W1LmpW8vQU6yhxEcUVlWKHOWoh5rEokp7SP//+tkgpT4kWJ5U/qcY
         67UZgaQcAD+YcoRoioSrxcx9YEEw/Bi5YFcds=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=X4ebnL9FKFq17X3pHCnu37OOFN1BcUTTkawnKuPEaf4=;
        b=tH3QIlLU4hLxuTi/AXbEWg2xEpV2H/tAOad0r+YpsR+Avhrar8gT+PyaVc43h9N6xA
         T+CrNUV2J34HCdV6R9hHrywJOXcl0b9RP9M0bmOWtCod+BU9cp4w8KYLyZMx63SL9lTi
         AoLZAM8C8AjQBNHe2xJmSFma0dJI7GXYyYzRdxjh61uMMjLy9XsYZLMt+3jqvlg2rMIu
         Bc7RvtCHduETtiyayFUpPm/8SSEQm2L9sRZhDDKzFrJ+24zpvBERa3S6IBTGS1h9MUes
         rVHhMNtzaSdl65sxtZmNH2AIImmNtwJc5dMWHVVaogl8YBFAIv997VMdkZu87Tg4FvYS
         Yljw==
X-Gm-Message-State: AGi0PuZVap49L2P1mapOLS4lLISNztY2tqA3NQe/SksbKQg+orx0YXIY
        oCB6mwCh8rI6dVpsTdFUKm27dQ==
X-Google-Smtp-Source: APiQypK3qB3PWwDqhsBScgrnmzwQA56QeljH9ycdKKg0XVEGUVIBcK2CB3gMaBAPt5w8egJN/h6GvA==
X-Received: by 2002:adf:fa4f:: with SMTP id y15mr1849852wrr.118.1586251675115;
        Tue, 07 Apr 2020 02:27:55 -0700 (PDT)
Received: from google.com ([2a00:79e0:42:204:8a21:ba0c:bb42:75ec])
        by smtp.gmail.com with ESMTPSA id d13sm3116411wrg.21.2020.04.07.02.27.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2020 02:27:54 -0700 (PDT)
From:   KP Singh <kpsingh@chromium.org>
X-Google-Original-From: KP Singh <kpsingh>
Date:   Tue, 7 Apr 2020 11:27:53 +0200
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jiri Olsa <jolsa@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>, bgregg@netflix.com
Subject: Re: [RFC 0/3] bpf: Add d_path helper
Message-ID: <20200407092753.GA109512@google.com>
References: <20200401110907.2669564-1-jolsa@kernel.org>
 <20200402142106.GF23230@ZenIV.linux.org.uk>
 <20200403090828.GF2784502@krava>
 <20200406031602.GR23230@ZenIV.linux.org.uk>
 <20200406090918.GA3035739@krava>
 <20200407011052.khtujfdamjtwvpdp@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200407011052.khtujfdamjtwvpdp@ast-mbp.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06-Apr 18:10, Alexei Starovoitov wrote:
> On Mon, Apr 06, 2020 at 11:09:18AM +0200, Jiri Olsa wrote:
> > 
> > is there any way we could have d_path functionality (even
> > reduced and not working for all cases) that could be used
> > or called like that?
> 
> I agree with Al. This helper cannot be enabled for all of bpf tracing.
> We have to white list its usage for specific callsites only.
> May be all of lsm hooks are safe. I don't know yet. This has to be
> analyzed carefully. Every hook. One by one.

I agree with this, there are some LSM hooks which do get called in
interrupt context, eg. task_free (which gets called in an RCU
callback).

The hooks that we are using it for and we know that it works (using
our experimental helpers similar to this) are the bprm_* hooks in the
exec pathway (for logic based on the path of the executable).

It might be worth whitelisting these functions by adding verifier ops
for LSM programs?

Would you want to do it as a part of this series?

- KP

> in_task() isn't really a solution.
> 
> At the same time I agree that such helper is badly needed.
> Folks have been requesting it for long time.
