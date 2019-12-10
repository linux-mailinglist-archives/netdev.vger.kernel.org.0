Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E9641192C8
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 22:07:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727131AbfLJVES (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 16:04:18 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:36641 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727093AbfLJVER (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 16:04:17 -0500
Received: by mail-pg1-f194.google.com with SMTP id k3so8822177pgc.3
        for <netdev@vger.kernel.org>; Tue, 10 Dec 2019 13:04:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=52e9X1zaffKYJZsm4RmvVJgpQnjkYQQHNeT1iKIz4Fo=;
        b=ZymPCP05vBFAW9DNYFX7N3XT5LJ8qPdE57GZbZqx1laYeb6+PiPOcrHZucpRHkw3RF
         +HhT8g5WpW9RfqKiQmEv5cnycoNIjexOTRAzPy3H8s38X+MEGdrGFSCU7U/BmWj9GxY7
         4aP2CXu6Z10mxCtobp4MCv26iJDUPdpRPSkMnvgemsMOl4vStvBho0WRpQ3boVd862+8
         qmHvxsYGZCSzoeM4PMUEFbbeO30xzwKH37TkA1UwRadmG/THMHtY+xq53ow8SoBqmyqH
         eR0CIlwyxDmRYXqxxZq4ZcnEKE7OgY53LIYU8rX+YnL8N6qne6ngMkeW5m4HqI825ra9
         RWhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=52e9X1zaffKYJZsm4RmvVJgpQnjkYQQHNeT1iKIz4Fo=;
        b=GZzsenXIBV5U3b5VoYCP4oXL2mCZLxwUsYbfJwTP7y7eOS6amls3xzAEgUflU4jGYH
         U0BXOFJw85Er4UIm+r+YkRGZD1LnxJ4/g1eitfGONYVZU7DkddXh6N9f9Ko1c7WWiMxJ
         u3vmkefwoEqRmrK8RORpFN7AZ1t5kAadJLV/vhbY3UZ+/94NeJrAZocGxArXvCGpfLJS
         be196DmPkPz+m8UbrYFJdCExALXjlnZZu0lh12q4BYYCJgS4srXTCQlhUYSYet3S0SXW
         gE9sZ8itw6ZxPkqEi3xKR9LzeuNAsSPeSwGOq/Y579PsAg6FMCBXAb3jo3CLURU3D7Z5
         vRHQ==
X-Gm-Message-State: APjAAAW1SfPHSJgIWw0Jgy6+8valESv0Zdezh2XSmrutDtrHZKmMKryl
        lP/Dl4Qe5NCMMRHEvRQAdCFZmg==
X-Google-Smtp-Source: APXvYqzT3032TbZ3ENm1RLKpX9StxiKnRGYboO8xIPBzbkiJ1TisWt/KtdY6P3zcDJsogSAYgBac7Q==
X-Received: by 2002:aa7:98cd:: with SMTP id e13mr36083483pfm.56.1576011856940;
        Tue, 10 Dec 2019 13:04:16 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id l14sm2397692pgt.42.2019.12.10.13.04.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2019 13:04:16 -0800 (PST)
Date:   Tue, 10 Dec 2019 13:04:13 -0800
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
Message-ID: <20191210124101.6d5be2dd@cakuba.netronome.com>
In-Reply-To: <1e3ede4f901a36af342e71bc4fdd2b27fbf9a418.1575991886.git.paul.chaignon@orange.com>
References: <cover.1575991886.git.paul.chaignon@orange.com>
        <1e3ede4f901a36af342e71bc4fdd2b27fbf9a418.1575991886.git.paul.chaignon@orange.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Dec 2019 17:06:42 +0100, Paul Chaignon wrote:
> When working with frequently modified BPF programs, both the ID and the
> tag may change.  bpftool currently doesn't provide a "stable" way to match
> such programs.
> 
> This patch implements lookup by name for programs.  The show and dump
> commands will return all programs with the given name, whereas other
> commands will error out if several programs have the same name.
> 
> Signed-off-by: Paul Chaignon <paul.chaignon@orange.com>

> @@ -164,7 +165,7 @@ prog_parse_fds(int *argc, char ***argv, int *fds)
>  		}
>  		return 1;
>  	} else if (is_prefix(**argv, "tag")) {
> -		unsigned char tag[BPF_TAG_SIZE];
> +		char tag[BPF_TAG_SIZE];

Perhaps better to change the argument to prog_fd_by_nametag() to void *?

>  
>  		NEXT_ARGP();
>  
> @@ -176,7 +177,20 @@ prog_parse_fds(int *argc, char ***argv, int *fds)
>  		}
>  		NEXT_ARGP();
>  
> -		return prog_fd_by_tag(tag, fds);
> +		return prog_fd_by_nametag(tag, fds, true);
> +	} else if (is_prefix(**argv, "name")) {
> +		char *name;
> +
> +		NEXT_ARGP();
> +
> +		name = **argv;
> +		if (strlen(name) > BPF_OBJ_NAME_LEN - 1) {

Is this needed? strncmp will simply never match, is it preferred to
hard error?

> +			p_err("can't parse name");
> +			return -1;
> +		}
> +		NEXT_ARGP();
> +
> +		return prog_fd_by_nametag(name, fds, false);
>  	} else if (is_prefix(**argv, "pinned")) {
>  		char *path;
>  
> @@ -191,7 +205,7 @@ prog_parse_fds(int *argc, char ***argv, int *fds)
>  		return 1;
>  	}
>  
> -	p_err("expected 'id', 'tag' or 'pinned', got: '%s'?", **argv);
> +	p_err("expected 'id', 'tag', 'name' or 'pinned', got: '%s'?", **argv);
>  	return -1;
>  }
>  

