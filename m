Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C737207A58
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 19:34:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405461AbgFXRd4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 13:33:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405427AbgFXRd4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 13:33:56 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 237AFC061573
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 10:33:56 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id i3so3508928ljg.3
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 10:33:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=iiHMhZF69KlR9UB7HSYz9fQ/aeh9jk93OgbnYgxEBXY=;
        b=ScsiTYV8uNyU30PVPDMD0T7EexDW39n6cYbCFCTNfyHYOosV3+kFLigdhwvgh6xtPR
         Big/v/Y6ROy6Dn7areLwW+7Te6g1w3tPXn5KdIohKA/pNxzj01ZvTyx8ge7rq4jaDVVj
         nZc2dIgF6l4l8q0F5rwg3eOLaHQVWFsGe3oTs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=iiHMhZF69KlR9UB7HSYz9fQ/aeh9jk93OgbnYgxEBXY=;
        b=aV7K1dd+bs9wRlyTXZmbL4ceD/vgGyF7Iiz5obl2j/K89j27xHOmg9A39A7/KTWsJH
         32KusYoktAk3BPTjRRdIvZg0MrytQfRJNDWteRoMVh3JCyMaFk3N9PJG2QNU75sbcSKP
         wdEBRYwJ0O9Ako7YfguX9Hmm8tN4lSJaj3I2Rea7fNl0VKwgQ8os5UCQvrfr1xQAC1E2
         FSzfqyNSbN3Eu+R2JutvfcjD5XNG412jjBYw3CmnhPMafo8SCYXNuU2ATK/2NpMjQnI4
         ssbO4KHimc/9MfEya5fc49spJi5UQhKE4XysolBre8I1kvB01STf8t3trnrPVen6ieZJ
         8nOg==
X-Gm-Message-State: AOAM5301fDjnFmJTRT5Bdc/4B//KB8xwXh89dAQOmX8kI3KopS7Cj/qF
        49alTacCtcZFi4+NAkjETkMEgQ==
X-Google-Smtp-Source: ABdhPJw4MKvn4GhOd5M6j5CDLK2VmBawL9tmkw5N8ROHo4Ixkd9k3lqI6Vg5lFfyu7pyVS712ie6Tw==
X-Received: by 2002:a2e:b0fa:: with SMTP id h26mr14008147ljl.148.1593020034482;
        Wed, 24 Jun 2020 10:33:54 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id t4sm5364941lfp.21.2020.06.24.10.33.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 10:33:53 -0700 (PDT)
References: <20200623103459.697774-1-jakub@cloudflare.com> <20200623103459.697774-3-jakub@cloudflare.com> <20200623193352.4mdmfg4mfmgfeku4@kafai-mbp.dhcp.thefacebook.com> <87sgelmrba.fsf@cloudflare.com> <20200623212452.titgpyrxx56u3lyd@kafai-mbp.dhcp.thefacebook.com>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        kernel-team@cloudflare.com, Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH bpf-next v2 2/3] bpf, netns: Keep attached programs in bpf_prog_array
In-reply-to: <20200623212452.titgpyrxx56u3lyd@kafai-mbp.dhcp.thefacebook.com>
Date:   Wed, 24 Jun 2020 19:33:51 +0200
Message-ID: <87mu4smkqo.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 23, 2020 at 11:24 PM CEST, Martin KaFai Lau wrote:
> On Tue, Jun 23, 2020 at 10:59:37PM +0200, Jakub Sitnicki wrote:
>> On Tue, Jun 23, 2020 at 09:33 PM CEST, Martin KaFai Lau wrote:
>> > On Tue, Jun 23, 2020 at 12:34:58PM +0200, Jakub Sitnicki wrote:
>> >
>> > [ ... ]
>> >
>> >> @@ -93,8 +108,16 @@ static int bpf_netns_link_update_prog(struct bpf_link *link,
>> >>  		goto out_unlock;
>> >>  	}
>> >>
>> >> +	run_array = rcu_dereference_protected(net->bpf.run_array[type],
>> >> +					      lockdep_is_held(&netns_bpf_mutex));
>> >> +	if (run_array)
>> >> +		ret = bpf_prog_array_replace_item(run_array, link->prog, new_prog);
>> >> +	else
>> > When will this happen?
>>
>> This will never happen, unless there is a bug. As long as there is a
>> link attached, run_array should never be detached (null). Because it can
>> be handled gracefully, we fail the bpf(LINK_UPDATE) syscall.
>>
>> Your question makes me think that perhaps it should trigger a warning,
>> with WARN_ON_ONCE, to signal clearly to the reader that this is an
>> unexpected state.
>>
>> WDYT?
> Thanks for confirming and the explanation.
>
> If it will never happen, I would skip the "if (run_array)".  That
> will help the code reading in the future.
>
> I would not WARN also.

Best code is no code :-)

I realized that bpf_prog_array_replace_item() cannot fail either, unless
there is a bug how we compile the prog_array. So I plan to remove that
error check as well.

Thanks for feedback.
