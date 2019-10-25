Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B1B1E4712
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 11:26:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438531AbfJYJ04 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 05:26:56 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:36494 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438521AbfJYJ04 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 05:26:56 -0400
Received: by mail-lj1-f194.google.com with SMTP id v24so1915008ljj.3
        for <netdev@vger.kernel.org>; Fri, 25 Oct 2019 02:26:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=5YmWlMhofV9UFzyROlgUUggoCeCMirNbDKHUIreDPVU=;
        b=OKzuRUOV39ft2lC25Neyoc6NlxLbwOIQ2yMwKhHam3NkeMXt7UZ7fe2p9nLz8pkw+Y
         c+m76Nbk9ZlMRB5V7WW/IZj9eum8fHSYHqit3IfmZKu7ByKUIiqvOc6Ww4ej+TJaYK1t
         0VvXciIrPNU+r0q85joL39PmfV3Zw6THCasZE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=5YmWlMhofV9UFzyROlgUUggoCeCMirNbDKHUIreDPVU=;
        b=T3E6ZrEaYeMJB6RdincGu2w+vjkDWbqRv9hyz8BnM3ySbuifDKEI3RhaSithbVKO+t
         GbelmzyTgXEBB8RoCPH1SQNy+HDvmqtoL/AYRwsIVIlqtwxp1M9S9gOqb4b5MxnOgdiE
         JCZWWgnDdlMEnxT8hfwH8seLdV9I0ac1TJ17vOUVtJRPA+ZVI255b0iWZzyaK/+kC7U0
         E4dTZcvgfJHofxgBvo+tDPmlSvoJN0oKn10U8rwB4aiDKItYFPHkIkYfYtY0nCbZhG0r
         3eZ5r6yW6+ixgqagYqsdBnw+3dMNRZ1X8eDNdd0EJu05oF6oytuW6tH++aOoMBk6lH19
         OPnA==
X-Gm-Message-State: APjAAAU2cwgzjqYTYsp0o/yTRBENZVcKN8H1EXo+q5aH3YayDBkRkdXD
        zj+5k0nn2eulGBH9bsRn+yyAZg==
X-Google-Smtp-Source: APXvYqxZYJAe3juNGwBgIgGihlxIcqJ5w+jaXUwdDERJ55YbZ33AF3HYVRInu2e063vTpaUc2lkbEA==
X-Received: by 2002:a2e:89c9:: with SMTP id c9mr1638643ljk.108.1571995612785;
        Fri, 25 Oct 2019 02:26:52 -0700 (PDT)
Received: from cloudflare.com ([176.221.114.230])
        by smtp.gmail.com with ESMTPSA id 3sm537079lfq.55.2019.10.25.02.26.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Oct 2019 02:26:52 -0700 (PDT)
References: <20191022113730.29303-1-jakub@cloudflare.com> <5db1d7a810bdb_5c282ada047205c08f@john-XPS-13-9370.notmuch>
User-agent: mu4e 1.1.0; emacs 26.1
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        netdev@vger.kernel.org, kernel-team@cloudflare.com
Subject: Re: [RFC bpf-next 0/5] Extend SOCKMAP to store listening sockets
In-reply-to: <5db1d7a810bdb_5c282ada047205c08f@john-XPS-13-9370.notmuch>
Date:   Fri, 25 Oct 2019 11:26:51 +0200
Message-ID: <87lft9ch0k.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 24, 2019 at 06:56 PM CEST, John Fastabend wrote:
> Jakub Sitnicki wrote:

[...]

>> I'm looking for feedback if there's anything fundamentally wrong with
>> extending SOCKMAP map type like this that I might have missed.
>
> I think this looks good. The main reason I blocked it off before is mostly
> because I had no use-case for it and the complication with what to do with
> child sockets. Clearing the psock state seems OK to me if user wants to
> add it back to a map they can simply grab it again from a sockops
> event.

Thanks for taking a look at the code.

> By the way I would eventually like to see the lookup hook return the
> correct type (PTR_TO_SOCKET_OR_NULL) so that the verifier "knows" the type
> and the socket can be used the same as if it was pulled from a sk_lookup
> helper.

Wait... you had me scratching my head there for a minute.

I haven't whitelisted bpf_map_lookup_elem for SOCKMAP in
check_map_func_compatibility so verifier won't allow lookups from BPF.

If we wanted to do that, I don't actually have a use-case for it, I
think would have to extend get_func_proto for SK_SKB and SK_REUSEPORT
prog types. At least that's what docs for bpf_map_lookup_elem suggest:

/* If kernel subsystem is allowing eBPF programs to call this function,
 * inside its own verifier_ops->get_func_proto() callback it should return
 * bpf_map_lookup_elem_proto, so that verifier can properly check the arguments
 *
 * Different map implementations will rely on rcu in map methods
 * lookup/update/delete, therefore eBPF programs must run under rcu lock
 * if program is allowed to access maps, so check rcu_read_lock_held in
 * all three functions.
 */
BPF_CALL_2(bpf_map_lookup_elem, struct bpf_map *, map, void *, key)
{
	WARN_ON_ONCE(!rcu_read_lock_held());
	return (unsigned long) map->ops->map_lookup_elem(map, key);
}

-Jakub
