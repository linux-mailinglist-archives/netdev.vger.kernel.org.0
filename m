Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85B1020625C
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 23:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393125AbgFWU7o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 16:59:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391418AbgFWU7l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 16:59:41 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07F80C061755
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 13:59:41 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id y11so90493ljm.9
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 13:59:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=TT2FZxgpjI3VkckydSkMTZ86IbhbF6gKg3r0vREiuvk=;
        b=m+WSj3btBtZQ/D6lseNcykWUPiFeFygNNYhSssoKxz+FopYF+OQrtacfrQKI7odjvK
         GvvCY2sAIPaL2PqhZBWLCdHEcWN0UxRSMRQ9GLAgKuNMgqflcjNgQNe4dXmz6LP2HOmG
         v0S/jglF4lP8Pp5PTd4K/PmrhQxhWF8yhGJy4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=TT2FZxgpjI3VkckydSkMTZ86IbhbF6gKg3r0vREiuvk=;
        b=U0m7jaTAznVuzgALkHRvy8z457YOCiDyvYOWD83X1Ou81lfRUoo+giZwvrbrhlJY/m
         Ldu+a7OgRhY0VzPm6NEZGl2EcTzXFds2RLK1NOdRYgv/VQUE8qJXo1OOWDBBlp/N02xA
         OzOKnJIA+q0uq74o9Gh/458nrjdpzsDzSVGBIb6FC4XiRl5e7Q4FZx9ywORI0x/hNSMk
         qK5I8t/e4EpOQ/KU//DeLQUnzd/H/1C9jValm/Mgk5E7TF1/l7Vv4BGC8ZU0cSan00+U
         lhJllWAbVuCkZLP+J6VXzdf37rIBlLw/Aa7Sq6lkyn86RNINIpXjpaB0Bq4GSonYmv3W
         3rHg==
X-Gm-Message-State: AOAM5307+/r15D/FKTldZyR2Gb/bC5s/DgsXYyo2L7MPx3lbWgxZEEt4
        6iu4rc3oswmss5qBh1k/Y4jeHosSX/+G0g==
X-Google-Smtp-Source: ABdhPJzVM7jBvlMi/1dIDGHjpIwo7Vb0q67nlm85VQ9OwQDLnc5UYl+TRxakJLLS1YEM9e+jS1BCZg==
X-Received: by 2002:a05:651c:544:: with SMTP id q4mr12640870ljp.310.1592945979425;
        Tue, 23 Jun 2020 13:59:39 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id r15sm3518864ljm.31.2020.06.23.13.59.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2020 13:59:38 -0700 (PDT)
References: <20200623103459.697774-1-jakub@cloudflare.com> <20200623103459.697774-3-jakub@cloudflare.com> <20200623193352.4mdmfg4mfmgfeku4@kafai-mbp.dhcp.thefacebook.com>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        kernel-team@cloudflare.com, Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH bpf-next v2 2/3] bpf, netns: Keep attached programs in bpf_prog_array
In-reply-to: <20200623193352.4mdmfg4mfmgfeku4@kafai-mbp.dhcp.thefacebook.com>
Date:   Tue, 23 Jun 2020 22:59:37 +0200
Message-ID: <87sgelmrba.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 23, 2020 at 09:33 PM CEST, Martin KaFai Lau wrote:
> On Tue, Jun 23, 2020 at 12:34:58PM +0200, Jakub Sitnicki wrote:
>
> [ ... ]
>
>> @@ -93,8 +108,16 @@ static int bpf_netns_link_update_prog(struct bpf_link *link,
>>  		goto out_unlock;
>>  	}
>>
>> +	run_array = rcu_dereference_protected(net->bpf.run_array[type],
>> +					      lockdep_is_held(&netns_bpf_mutex));
>> +	if (run_array)
>> +		ret = bpf_prog_array_replace_item(run_array, link->prog, new_prog);
>> +	else
> When will this happen?

This will never happen, unless there is a bug. As long as there is a
link attached, run_array should never be detached (null). Because it can
be handled gracefully, we fail the bpf(LINK_UPDATE) syscall.

Your question makes me think that perhaps it should trigger a warning,
with WARN_ON_ONCE, to signal clearly to the reader that this is an
unexpected state.

WDYT?

>
>> +		ret = -ENOENT;
>> +	if (ret)
>> +		goto out_unlock;
>> +
>>  	old_prog = xchg(&link->prog, new_prog);
>> -	rcu_assign_pointer(net->bpf.progs[type], new_prog);
>>  	bpf_prog_put(old_prog);
>>
>>  out_unlock:
>> @@ -142,14 +165,38 @@ static const struct bpf_link_ops bpf_netns_link_ops = {
>>  	.show_fdinfo = bpf_netns_link_show_fdinfo,
>>  };
