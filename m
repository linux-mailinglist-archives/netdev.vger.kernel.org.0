Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65780583FE7
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 15:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236234AbiG1NZ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 09:25:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234101AbiG1NZ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 09:25:27 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 290D232045;
        Thu, 28 Jul 2022 06:25:26 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id q18so2166114wrx.8;
        Thu, 28 Jul 2022 06:25:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc;
        bh=pVk+lkG+Ffjh5bOg4Fs3pQkJWlJ1u6yUh067aQj/ZQo=;
        b=X5PmUBjMGceNjQQT2JDwz+zIF+S7I3tObrwxSlViO1vsyVORqnPtZPdP34vPFzNi3Y
         juePBj8gLrU1n5ZIDvniuWFdvZA1aRBAMhHt9pFKrcdQB1XTCXUwFZjrrBZOytxBZ1Gz
         58wlO7+L1cu6/+kirlpD46rmBgAsygCrwk7N9RKIJ9Uhy4/QK2dLACAekG0XbNS0BDCv
         3np2I9DMtrDuBjqGKombW1Oq14xK3ZEHDBCrIPMBiL3WNbOoxXhlmu/VQEiNKavpoJQs
         yDOw+xF3pNq5FLOql0L7YLJLEzRFaumeWIzzhI6TFYeBGmAKArG6a2aWts98X5G/W6aB
         XxgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc;
        bh=pVk+lkG+Ffjh5bOg4Fs3pQkJWlJ1u6yUh067aQj/ZQo=;
        b=8QGxYVCyMOq+niYu8p/ExVhMyppiTjsonLlkjDRwrMTSr7oLB+GD1S+M8YCopN4CIT
         3Xm75dahl5f4XnueQXaS2owJ+Xh2Uwshw47HiBQyRLoTwA2Mz9pr3r57ZXPWwnvlEtFU
         NgoRSmFafahAjXt6sLUQnZGUhHiWMTiLN4Z8B9SOlHx7ToPRFWBck6sT02bYa+y1a0R4
         WfvPkl5swet2tp9nmXJGxWGcSHxXFUIemPdaEmMki0SAqBy+gOscaCNJXu8GVbY4XG5x
         XzrBmeGphuVE7Pct7+gl+fgoLXV/V5i231x3Hyq8CIWGlcFQYbxxPUP1HLZNiE9YRarK
         htyA==
X-Gm-Message-State: AJIora8I8qQ1mwuVbnhR+XmnTentOA+0IcRIrtE5j0/J9x5kCe/XMihG
        rIkb5TCF9ECaCOamHDoQcmg=
X-Google-Smtp-Source: AGRyM1t0B0CMLKYaNhh8BtsFya3ReyNBKQKoTC3RWo0Q5aq+XTCkycNCmlyukafXNpfAhTI3tAhgww==
X-Received: by 2002:a5d:674c:0:b0:21e:5135:18cb with SMTP id l12-20020a5d674c000000b0021e513518cbmr17744440wrw.298.1659014724733;
        Thu, 28 Jul 2022 06:25:24 -0700 (PDT)
Received: from krava ([193.85.244.190])
        by smtp.gmail.com with ESMTPSA id n16-20020a05600c4f9000b003a2f2bb72d5sm6719059wmq.45.2022.07.28.06.25.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 06:25:24 -0700 (PDT)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Thu, 28 Jul 2022 15:25:22 +0200
To:     Xu Kuohai <xukuohai@huaweicloud.com>
Cc:     Jiri Olsa <olsajiri@gmail.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Bruno Goncalves <bgoncalv@redhat.com>,
        Song Liu <song@kernel.org>
Subject: Re: [PATCH bpf-next] bpf: Fix NULL pointer dereference when
 registering bpf trampoline
Message-ID: <YuKOQiJt+AA1cCEE@krava>
References: <20220728114048.3540461-1-xukuohai@huaweicloud.com>
 <YuKAlk+p/ABzfUQ+@krava>
 <9170060c-8727-68d6-7be2-8aa75e30c6e6@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9170060c-8727-68d6-7be2-8aa75e30c6e6@huaweicloud.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 28, 2022 at 08:56:27PM +0800, Xu Kuohai wrote:
> On 7/28/2022 8:27 PM, Jiri Olsa wrote:
> > On Thu, Jul 28, 2022 at 07:40:48AM -0400, Xu Kuohai wrote:
> > > From: Xu Kuohai <xukuohai@huawei.com>
> > 
> > SNIP
> > 
> > > 
> > > It's caused by a NULL tr->fops passed to ftrace_set_filter_ip(). tr->fops
> > > is initialized to NULL and is assigned to an allocated memory address if
> > > CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS is enabled. Since there is no
> > > direct call on arm64 yet, the config can't be enabled.
> > > 
> > > To fix it, call ftrace_set_filter_ip() only if tr->fops is not NULL.
> > > 
> > > Fixes: 00963a2e75a8 ("bpf: Support bpf_trampoline on functions with IPMODIFY (e.g. livepatch)")
> > > Reported-by: Bruno Goncalves <bgoncalv@redhat.com>
> > > Signed-off-by: Xu Kuohai <xukuohai@huawei.com>
> > > Tested-by: Bruno Goncalves <bgoncalv@redhat.com>
> > > Acked-by: Song Liu <songliubraving@fb.com>
> > > ---
> > >   kernel/bpf/trampoline.c | 11 +++++++++--
> > >   1 file changed, 9 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
> > > index 42e387a12694..0d5a9e0b9a7b 100644
> > > --- a/kernel/bpf/trampoline.c
> > > +++ b/kernel/bpf/trampoline.c
> > > @@ -255,8 +255,15 @@ static int register_fentry(struct bpf_trampoline *tr, void *new_addr)
> > >   		return -ENOENT;
> > >   	if (tr->func.ftrace_managed) {
> > > -		ftrace_set_filter_ip(tr->fops, (unsigned long)ip, 0, 0);
> > > -		ret = register_ftrace_direct_multi(tr->fops, (long)new_addr);
> > > +		if (tr->fops)
> > > +			ret = ftrace_set_filter_ip(tr->fops, (unsigned long)ip,
> > > +						   0, 0);
> > > +		else
> > > +			ret = -ENOTSUPP;
> > > +
> > > +		if (!ret)
> > > +			ret = register_ftrace_direct_multi(tr->fops,
> > > +							   (long)new_addr);
> > >   	} else {
> > >   		ret = bpf_arch_text_poke(ip, BPF_MOD_CALL, NULL, new_addr);
> > >   	}
> > 
> > do we need to do the same also in unregister_fentry and modify_fentry ?
> > 
> 
> No need for now, this is the only place where we call ftrace_set_filter_ip().
> 
> tr->fops is passed to ftrace_set_filter_ip() and *ftrace_direct_multi()
> functions, and when CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS is not enabled,
> the *ftrace_direct_multi()s do nothing except returning an error code, so
> it's safe to pass NULL to them.

ok, makes sense

Acked-by: Jiri Olsa <jolsa@kernel.org>

jirka
