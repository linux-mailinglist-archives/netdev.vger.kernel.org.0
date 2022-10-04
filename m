Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 521435F3CD7
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 08:42:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbiJDGmc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 02:42:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbiJDGma (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 02:42:30 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94B572C124;
        Mon,  3 Oct 2022 23:42:28 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id ay7-20020a05600c1e0700b003b49861bf48so399558wmb.0;
        Mon, 03 Oct 2022 23:42:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=YzSKhtZJ27hGDlu9ltNiKeiIH9cAwEwtecp1QC+3rtk=;
        b=A1foJcAShylyiTg/+c4560iLA/MSM7KtQH4bPtkQhoZcrpozvVmdf406dEM0uPtk9B
         SF2JgWlaCC0+iGkMFhEKuIpxs+inqpSKvYAaG5aF+tKwqnZ67PJ1aSr3G2NhF0t8XP+n
         8YtIkM1XMOcguWwOlu+rZfGt8wkM+/YUWTvxmz40TT8nn5WHe5ez5yuuR3XWBBa+8ayQ
         fpR9gdKonOlfsoYLpq45CE1MONcQO0KmVInfl17y6rnXMpA4x7rklSyQjJ9m5LkqO5Pf
         FzmNkQiVVu7tCXmWGyScwE0NtVxdpVcgsK4Whm1H6wjWWiSQoXz9IK2QQ4yFLQeMAAYI
         +2oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YzSKhtZJ27hGDlu9ltNiKeiIH9cAwEwtecp1QC+3rtk=;
        b=MwDtbGyQ+tEmCeWujI8KrcrN/hH/su5Z+4eLnYyT7+nA41QhMb4oiAdcM8yHHSxRQ+
         EBPifuC8UvE+Cesdycae2dkKb5Wlp9yYencPXVkgVPVfbjZePl4HTeW32VOWmuXpQ+cR
         1jS0HmHjVjJX6xwP29AaxYb66guX/PVXjGRpEsr8jruJetQGOhk0uheM47R4Euv83b4L
         i4qW0Wqek3zv4RIHp3z4WvMeyPxLMxuA9yEt7YGk6ZMF6poUq38X4tJ8PN8LGnmsth/v
         mbcQY5t7LRiHaEodJLZjMzA/ATfelfAhEQtgOhY8SrcbFCrHMU9thBllEcXaoSUGRmTi
         j2aA==
X-Gm-Message-State: ACrzQf3WKVobnoxCJqUXWTeBvNn0/XX1GmoZ4I541yzpuy3bgVi9bHbn
        zVcC24JA57i76q5u4stBMp+bFqETGZPbMw==
X-Google-Smtp-Source: AMsMyM5c64QbLcb0z876hdmkxgke9NxpIQtcKqn64nfzCMpvfd60wvT/pemkSLVGQ00mNtM2Bo1lag==
X-Received: by 2002:a05:600c:29c6:b0:3bd:3fd4:45c0 with SMTP id s6-20020a05600c29c600b003bd3fd445c0mr473852wmd.44.1664865746963;
        Mon, 03 Oct 2022 23:42:26 -0700 (PDT)
Received: from krava ([193.85.244.190])
        by smtp.gmail.com with ESMTPSA id t20-20020a05600c199400b003b4fe03c881sm19108940wmq.48.2022.10.03.23.42.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Oct 2022 23:42:26 -0700 (PDT)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Tue, 4 Oct 2022 08:42:24 +0200
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Daniel Xu <dxu@dxuuu.xyz>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        bpf@vger.kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: WARN: multiple IDs found for 'nf_conn': 92168, 117897 - using
 92168
Message-ID: <YzvV0CFSi9KvXVlG@krava>
References: <20221003190545.6b7c7aba@kernel.org>
 <20221003214941.6f6ea10d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221003214941.6f6ea10d@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 03, 2022 at 09:49:41PM -0700, Jakub Kicinski wrote:
> On Mon, 3 Oct 2022 19:05:45 -0700 Jakub Kicinski wrote:
> > Hi Jiri,
> > 
> > I get the following warning after merging up all the trees:
> > 
> > vmlinux.o: warning: objtool: ___ksymtab+bpf_dispatcher_xdp_func+0x0: data relocation to !ENDBR: bpf_dispatcher_xdp_func+0x0
> > vmlinux.o: warning: objtool: bpf_dispatcher_xdp+0xa0: data relocation to !ENDBR: bpf_dispatcher_xdp_func+0x0
> > 
> > $ gcc --version
> > gcc (GCC) 8.5.0 20210514 (Red Hat 8.5.0-15)
> > 
> > 
> > Is this known?
> 
> Also hit this:
> 
> WARN: multiple IDs found for 'nf_conn': 92168, 117897 - using 92168
> WARN: multiple IDs found for 'nf_conn': 92168, 121226 - using 92168

hi,
I did not see that before, could you please share your config?

thanks,
jirka
