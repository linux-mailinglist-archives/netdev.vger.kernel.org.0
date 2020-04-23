Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E25721B597B
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 12:43:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727100AbgDWKnL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 06:43:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725863AbgDWKnK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 06:43:10 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ECF4C035493
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 03:43:10 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id h2so5902870wmb.4
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 03:43:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=iL38PP43JCDQ9gtRyUtFUBHnpRpz43CI9gzykrCgRz4=;
        b=PGZtFQ9NLrHdM1Fk/fWYDOJPHZDmy8cokOZk9jMKxX0L4bK9mNPkHYXzlw8skgZFJg
         eH+GJ4Ge3Yhnalwq9lyQgc+Pcm78MWgxnJJg1M+mPqC84rjFBHlYWeMoO542CIhX2qUH
         XHzpCw0herOK8JOEdU6cj+igfCTAqR9qgh+v/LdFUIzydYcHuz8gw1lRnH4BKlcCmgqi
         yoDTHT/K70GYoYmiBP3PHe/B90CUA6HPLCbn9J9WqWnKit9Nh+f5I7FL8H20catvmcZK
         N1aHMsKVAW3Z30qsRRB5FzvuVk8MhcPQ1tEXHYX2QxdAE0n6mBiBHubm/qiKxTR5vPL9
         SElw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iL38PP43JCDQ9gtRyUtFUBHnpRpz43CI9gzykrCgRz4=;
        b=Nuiu6oEwb9RBBvhwMMTNz1YiJjMnkfO8r03GIm5vYk9gbbOVAHAwEAP6WRYq0cAmB+
         /8hpoVPaxkJh+fbaemkPPA0o4cNG/WKCtANMAKBTvJmiDCEQUBrAPRV3Wb/IEORBnIiw
         o7uVEc5fqYq+osBSyYbizLeXhnMaZPH0wz/m7dKWTnpY0NwP8j1usILYTiabXve+NgmB
         CrV0yA4KtC+eLSoaWKY5W5RFU3ppIUN/WFPdII1ppNwVGvf9BO4fsDQaNFE5KrGReDgx
         n5J/jWOdGbPpC66P+yHICh3O6xlZp9/x0MLzmH9D6jLzDi+rlJd1hV7MqQ7fdxutyTWr
         swqw==
X-Gm-Message-State: AGi0PuaBuO/00uIZuEz1qHqwWR3D4s3oWHdosgpEITInok7omxL494oi
        YnxZpyVcV+GoOH3Mmf4Jwodh6w==
X-Google-Smtp-Source: APiQypKmekTqFgqOFLzgAKxeFQ6hw0Fjq9emS+lZRvxciUjkOT4axQuMs0wG5i2P9imAostkRDIuyw==
X-Received: by 2002:a05:600c:2645:: with SMTP id 5mr3419579wmy.168.1587638589273;
        Thu, 23 Apr 2020 03:43:09 -0700 (PDT)
Received: from [192.168.1.10] ([194.53.185.104])
        by smtp.gmail.com with ESMTPSA id l6sm3183754wrb.75.2020.04.23.03.43.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Apr 2020 03:43:08 -0700 (PDT)
Subject: Re: [PATCH bpf-next 13/16] bpftool: Add support for XDP egress
To:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        brouer@redhat.com, toke@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, David Ahern <dahern@digitalocean.com>
References: <20200420200055.49033-1-dsahern@kernel.org>
 <20200420200055.49033-14-dsahern@kernel.org>
From:   Quentin Monnet <quentin@isovalent.com>
Message-ID: <d1a6ce5e-bb63-80cf-2e8f-24fbb0b36ec3@isovalent.com>
Date:   Thu, 23 Apr 2020 11:43:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200420200055.49033-14-dsahern@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2020-04-20 14:00 UTC-0600 ~ David Ahern <dsahern@kernel.org>
> From: David Ahern <dahern@digitalocean.com>
> 
> Add NET_ATTACH_TYPE_XDP_EGRESS and update attach_type_strings to
> allow a user to specify 'xdp_egress' as the attach or detach point.
> 
> libbpf handles egress config via bpf_set_link_xdp_fd_opts, so
> update do_attach_detach_xdp to use it. Specifically, the new API
> requires old_fd to be set based on any currently loaded program,
> so use bpf_get_link_xdp_id and bpf_get_link_xdp_egress_id to get
> an fd to any existing program.
> 
> Update 'net show' command to dump egress programs.
> 
> Signed-off-by: David Ahern <dahern@digitalocean.com>
> ---

Thanks for the bpftool update. Can you please also update the man pages
(bpftool-prog, bpftool-net) and bash completion?

Quentin
