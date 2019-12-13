Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3999F11E996
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 18:57:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728578AbfLMR5K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 12:57:10 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:40710 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728383AbfLMR5K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 12:57:10 -0500
Received: by mail-lf1-f68.google.com with SMTP id i23so144251lfo.7
        for <netdev@vger.kernel.org>; Fri, 13 Dec 2019 09:57:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=0ree+Xu8rZ7mkYTvWR/zpxVvZSVdBFxjnwqsdEhVoQE=;
        b=Olw5uaUjfLOeaLfOjA00de0/rop6f56eJdIxwk3KFcD5vf+zFxrESZgzYJmAe31ZY3
         isHAI11tdg9FtIKWgc9UV2SVgJhrcV0fx7i+3OMyf8xMMGxgbFoyaeLZswd2HRfHHkHc
         FEj6VOn7wafPnj5MjCSZu+9zk88kEA25yn9JPc0rn8XMXfBDg7o0a3A4FBIOPfcaYvm6
         5OoeqdfmdoEegwhPzh0fi+3kijBSdDH9cn4D04nEESZ+AUA/8E7eNBixnJjcX4U3WL8x
         54fqf8TCyzlzUrmB40idPHzb6xB6vefAY3Bob1o80jf/hPJejIDtV6PLG5P/svOMjmrI
         0XSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=0ree+Xu8rZ7mkYTvWR/zpxVvZSVdBFxjnwqsdEhVoQE=;
        b=NwqmUmBip9w28vVtldj9M1ccb6Rjg5bE8U+eZ+ZUJcoaPBcjrMEmJF331GLqoOjZMe
         9L7JcaEtayNFezSFwkZOlFyTQ7G4/5DuPMFBWi4ZR9SkIInt0fw+oEN06wCjJVUAXGPh
         zM5eSYKU67UYkH/QYw7A74EFb+uHyEEJHP+rvIzMmOT1Qg1qdTd6yhXIK1KblUKZrQeO
         CE5ohbmXRlNLL8WfqqEZ+K4wm/WJs/1HvggHqcyjMycYZaZeWV/71HUgNK12VtZR1iei
         GdS+w+XFi7GcXMfw4lRQwF1ddixRv1dSYI4uUOQScOsqxlpUF6a74mVyABz6I8GxnZs0
         TWvg==
X-Gm-Message-State: APjAAAXRTDQhIB/ryvF1gYXMhWi8sPurqgowv1g7wL92DifcDmEJ+S47
        8R6dJaCJZSifUuhIuQxXIZRKmw==
X-Google-Smtp-Source: APXvYqw2uRQCf5rheqlhTRCrB/4qF+5iOWFureszP3EXBqbU7WNe+g61qypwyWIcfWDXzPZHGqMVOQ==
X-Received: by 2002:a19:710a:: with SMTP id m10mr9520632lfc.58.1576259827860;
        Fri, 13 Dec 2019 09:57:07 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id u16sm5149692ljo.22.2019.12.13.09.57.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Dec 2019 09:57:07 -0800 (PST)
Date:   Fri, 13 Dec 2019 09:56:59 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Paul Chaignon <paul.chaignon@orange.com>
Cc:     bpf@vger.kernel.org, Quentin Monnet <quentin.monnet@netronome.com>,
        paul.chaignon@gmail.com, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH bpf-next 2/3] bpftool: match programs by name
Message-ID: <20191213095659.2782ca57@cakuba.netronome.com>
In-Reply-To: <20191213124038.GB6538@Omicron>
References: <cover.1575991886.git.paul.chaignon@orange.com>
        <1e3ede4f901a36af342e71bc4fdd2b27fbf9a418.1575991886.git.paul.chaignon@orange.com>
        <20191210124101.6d5be2dd@cakuba.netronome.com>
        <20191213124038.GB6538@Omicron>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Dec 2019 13:40:38 +0100, Paul Chaignon wrote:
> > > @@ -176,7 +177,20 @@ prog_parse_fds(int *argc, char ***argv, int *fds)
> > >  		}
> > >  		NEXT_ARGP();
> > >  
> > > -		return prog_fd_by_tag(tag, fds);
> > > +		return prog_fd_by_nametag(tag, fds, true);
> > > +	} else if (is_prefix(**argv, "name")) {
> > > +		char *name;
> > > +
> > > +		NEXT_ARGP();
> > > +
> > > +		name = **argv;
> > > +		if (strlen(name) > BPF_OBJ_NAME_LEN - 1) {  
> > 
> > Is this needed? strncmp will simply never match, is it preferred to
> > hard error?  
> 
> I tried to follow the fail-early pattern of lookups by tag above.  

Right although tag does a scanf and if we didn't scan all letters 
we'd use uninit memory.

> I do like that there's a different error message for a longer than
> expected name.  Since libbpf silently truncates names, typing a
> longer name is not uncommon.

Ugh, I didn't realize libbpf truncates names. Okay, let's keep the
error for now so we can switch to truncation if users complain.
