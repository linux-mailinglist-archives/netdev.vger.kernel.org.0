Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70E355FE90F
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 08:47:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbiJNGrp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 02:47:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbiJNGrn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 02:47:43 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BD5F18541B;
        Thu, 13 Oct 2022 23:47:30 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id bp11so6082105wrb.9;
        Thu, 13 Oct 2022 23:47:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=D/0A5gYLwBnKJwADaWEmj06PgAR3LilrfLx3+JDwOcA=;
        b=N6M8ET29jTTF4AhO0vXOJgud7zFOSeRPwZakbFhkELPgWXCh7Z5Ju15H1MEuDvtZI2
         Iw1Owknbw/PBE44wqO14inRJ+KkdvCE2DP4DLb79wVGW81+E0+5CfAbn8dBJLLzuYbLk
         +kz4ArLnoqFguFdqTBPlU0rkQO+arh+rVRIeH3pccOLAJqsK69/39PgJp2UYbDrr5RFr
         3eC57HbGuUxZGhEYxg8grwudnTWb3z+sMnqfI9DILtQcheDqrpeNwGBeYdl9EL9wf4Rz
         anQHLbfec73CAa5v5TpFZAo5uN/RM6MpO/OcRJRpUTyxraLJUAfbNCLxz5XUbRRAcQSW
         9/Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D/0A5gYLwBnKJwADaWEmj06PgAR3LilrfLx3+JDwOcA=;
        b=dZ/wEz97J9JaXOnDVgv1J9r6PoniegaoQ7syuNBf81/9vc/LO1dyBjq0g0UE2pgkr4
         XxNjg2UnyzwO41UTNNfRSimNHVv6pNziyLMUKM0M6bs1QQ9YfcRykVf1aN5msRUgAy/j
         P7PRuddF1bTqfgsNHKmo9J7loeLza5dgLTQSjHAMCRsNdu1mYcNm3CVOCL8prlLQetyf
         heOAB/P4iL8n5ABP0J7yWonQBpwIfnOF34UhEQssPmMy3rOcsP4jh/6mvx82KYAsEwwm
         PMF1AFeGTJ9+FpEPD0TYOTndKCHw/IuDa/ihQ9VYajCIDe6yJTt9cvKsCE1W2xyyJSUX
         JAUA==
X-Gm-Message-State: ACrzQf00feY3gQmL5s5xWBfTlep7L6U/sV1rJnIJV+L3088+ldqcWTID
        otF594BZU3hL7/Yi/sGLtC4=
X-Google-Smtp-Source: AMsMyM4UcwhCu5a6X38VXEc9IpIZvwKfm5OVUxvFgKMHhLXItHx8MYGZM/Q0WvrdgkBMpgUGp7ISjw==
X-Received: by 2002:a5d:668e:0:b0:22f:d914:80ed with SMTP id l14-20020a5d668e000000b0022fd91480edmr2225655wru.45.1665730048516;
        Thu, 13 Oct 2022 23:47:28 -0700 (PDT)
Received: from krava ([193.85.244.190])
        by smtp.gmail.com with ESMTPSA id j10-20020a05600c190a00b003c6b7f5567csm14324802wmq.0.2022.10.13.23.47.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Oct 2022 23:47:28 -0700 (PDT)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Fri, 14 Oct 2022 08:47:26 +0200
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <olsajiri@gmail.com>, Jakub Kicinski <kuba@kernel.org>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        bpf@vger.kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: WARN: multiple IDs found for 'nf_conn': 92168, 117897 - using
 92168
Message-ID: <Y0kF/radV0cg4JYk@krava>
References: <20221003214941.6f6ea10d@kernel.org>
 <YzvV0CFSi9KvXVlG@krava>
 <20221004072522.319cd826@kernel.org>
 <Yz1SSlzZQhVtl1oS@krava>
 <20221005084442.48cb27f1@kernel.org>
 <20221005091801.38cc8732@kernel.org>
 <Yz3kHX4hh8soRjGE@krava>
 <20221013080517.621b8d83@kernel.org>
 <Y0iNVwxTJmrddRuv@krava>
 <CAEf4Bzbow+8-f4rg2LRRRUD+=1wbv1MjpAh-P4=smUPtrzfZ3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4Bzbow+8-f4rg2LRRRUD+=1wbv1MjpAh-P4=smUPtrzfZ3Q@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 13, 2022 at 03:24:59PM -0700, Andrii Nakryiko wrote:
> On Thu, Oct 13, 2022 at 3:12 PM Jiri Olsa <olsajiri@gmail.com> wrote:
> >
> > On Thu, Oct 13, 2022 at 08:05:17AM -0700, Jakub Kicinski wrote:
> > > On Wed, 5 Oct 2022 22:07:57 +0200 Jiri Olsa wrote:
> > > > > Yeah, it's there on linux-next, too.
> > > > >
> > > > > Let me grab a fresh VM and try there. Maybe it's my system. Somehow.
> > > >
> > > > ok, I will look around what's the way to install that centos 8 thing
> > >
> > > Any luck?
> >
> > now BTFIDS warnings..
> >
> > I can see following on centos8 with gcc 8.5:
> >
> >           BTFIDS  vmlinux
> >         WARN: multiple IDs found for 'task_struct': 300, 56614 - using 300
> >         WARN: multiple IDs found for 'file': 540, 56649 - using 540
> >         WARN: multiple IDs found for 'vm_area_struct': 549, 56652 - using 549
> >         WARN: multiple IDs found for 'seq_file': 953, 56690 - using 953
> >         WARN: multiple IDs found for 'inode': 1132, 56966 - using 1132
> >         WARN: multiple IDs found for 'path': 1164, 56995 - using 1164
> >         WARN: multiple IDs found for 'task_struct': 300, 61905 - using 300
> >         WARN: multiple IDs found for 'file': 540, 61943 - using 540
> >         WARN: multiple IDs found for 'vm_area_struct': 549, 61946 - using 549
> >         WARN: multiple IDs found for 'inode': 1132, 62029 - using 1132
> >         WARN: multiple IDs found for 'path': 1164, 62058 - using 1164
> >         WARN: multiple IDs found for 'cgroup': 1190, 62067 - using 1190
> >         WARN: multiple IDs found for 'seq_file': 953, 62253 - using 953
> >         WARN: multiple IDs found for 'sock': 7960, 62374 - using 7960
> >         WARN: multiple IDs found for 'sk_buff': 1876, 62485 - using 1876
> >         WARN: multiple IDs found for 'bpf_prog': 6094, 62542 - using 6094
> >         WARN: multiple IDs found for 'socket': 7993, 62545 - using 7993
> >         WARN: multiple IDs found for 'xdp_buff': 6191, 62836 - using 6191
> >         WARN: multiple IDs found for 'sock_common': 8164, 63152 - using 8164
> >         WARN: multiple IDs found for 'request_sock': 17296, 63204 - using 17296
> >         WARN: multiple IDs found for 'inet_request_sock': 36292, 63222 - using 36292
> >         WARN: multiple IDs found for 'inet_sock': 32700, 63225 - using 32700
> >         WARN: multiple IDs found for 'inet_connection_sock': 33944, 63240 - using 33944
> >         WARN: multiple IDs found for 'tcp_request_sock': 36299, 63260 - using 36299
> >         WARN: multiple IDs found for 'tcp_sock': 33969, 63264 - using 33969
> >         WARN: multiple IDs found for 'bpf_map': 6623, 63343 - using 6623
> >
> > I'll need to check on that..
> >
> > and I just actually saw the 'nf_conn' warning on linux-next/master with
> > latest fedora/gcc-12:
> >
> >           BTF [M] net/netfilter/nf_nat.ko
> >         WARN: multiple IDs found for 'nf_conn': 106518, 120156 - using 106518
> >         WARN: multiple IDs found for 'nf_conn': 106518, 121853 - using 106518
> >         WARN: multiple IDs found for 'nf_conn': 106518, 123126 - using 106518
> >         WARN: multiple IDs found for 'nf_conn': 106518, 124537 - using 106518
> >         WARN: multiple IDs found for 'nf_conn': 106518, 126442 - using 106518
> >         WARN: multiple IDs found for 'nf_conn': 106518, 128256 - using 106518
> >           LD [M]  net/netfilter/nf_nat_tftp.ko
> >
> > looks like maybe dedup missed this struct for some reason
> >
> > nf_conn dump from module:
> >
> >         [120155] PTR '(anon)' type_id=120156
> >         [120156] STRUCT 'nf_conn' size=320 vlen=14
> >                 'ct_general' type_id=105882 bits_offset=0
> >                 'lock' type_id=180 bits_offset=64
> >                 'timeout' type_id=113 bits_offset=640
> >                 'zone' type_id=106520 bits_offset=672
> >                 'tuplehash' type_id=106533 bits_offset=704
> >                 'status' type_id=1 bits_offset=1600
> >                 'ct_net' type_id=3215 bits_offset=1664
> >                 'nat_bysource' type_id=139 bits_offset=1728
> >                 '__nfct_init_offset' type_id=949 bits_offset=1856
> >                 'master' type_id=120155 bits_offset=1856
> >                 'mark' type_id=106351 bits_offset=1920
> >                 'secmark' type_id=106351 bits_offset=1952
> >                 'ext' type_id=106536 bits_offset=1984
> >                 'proto' type_id=106532 bits_offset=2048
> >
> > nf_conn dump from vmlinux:
> >
> >         [106517] PTR '(anon)' type_id=106518
> >         [106518] STRUCT 'nf_conn' size=320 vlen=14
> >                 'ct_general' type_id=105882 bits_offset=0
> >                 'lock' type_id=180 bits_offset=64
> >                 'timeout' type_id=113 bits_offset=640
> >                 'zone' type_id=106520 bits_offset=672
> >                 'tuplehash' type_id=106533 bits_offset=704
> >                 'status' type_id=1 bits_offset=1600
> >                 'ct_net' type_id=3215 bits_offset=1664
> >                 'nat_bysource' type_id=139 bits_offset=1728
> >                 '__nfct_init_offset' type_id=949 bits_offset=1856
> >                 'master' type_id=106517 bits_offset=1856
> >                 'mark' type_id=106351 bits_offset=1920
> >                 'secmark' type_id=106351 bits_offset=1952
> >                 'ext' type_id=106536 bits_offset=1984
> >                 'proto' type_id=106532 bits_offset=2048
> >
> > look identical.. Andrii, any idea?
> 
> I'm pretty sure they are not identical. There is somewhere a STRUCT vs
> FWD difference. We had a similar discussion recently with Alan
> Maguire.
> 
> >                 'master' type_id=120155 bits_offset=1856
> 
> vs
> 
> >                 'master' type_id=106517 bits_offset=1856

master is pointer to same 'nf_conn' object, and rest of the ids are same

jirka
