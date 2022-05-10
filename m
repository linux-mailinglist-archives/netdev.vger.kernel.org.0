Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD1A0522454
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 20:46:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349054AbiEJSqo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 14:46:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349220AbiEJSq2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 14:46:28 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91AD518B34;
        Tue, 10 May 2022 11:45:49 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id n8so17550343plh.1;
        Tue, 10 May 2022 11:45:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QcmVbQMJdfUcOk6mFPVNXkZt9bGV2i5Pf6lVs2tBzVA=;
        b=bqoGmmeD2eU6J99z/Cgc1jne4RgQpPHqrHsn7nRf2qGdxNoZDNh+phWWtcjNahz+vS
         2wzLLe0k7L5MgwOmXV4u8/e8bmA8y+KMxpTTK99CMER/yylrAfLNCrqM9pBf4i8UPd7F
         x01rnWDdO+g2G5i63rBkpou6zn2e8F2IVVB5UC2Jw0+9aTu1xi5qjBcJ3hsflIlrPT7D
         Fr1W3f5vuXq3n3FeAS3U9rxOJGPOC01ANdO9TUcgKDyYhKd+50y7a7itYHn4PBVJVHuC
         VJlXsJyHAWPwf/exDBl0ViOp0cw4dcXe1tEtFWNk1LNpx6jxtPpqSnV/GN0vySoL0GbS
         QV9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=QcmVbQMJdfUcOk6mFPVNXkZt9bGV2i5Pf6lVs2tBzVA=;
        b=d7rBX3oj2UXQw5op9+YslQFwDVQpTcDKv7wd65IOucGy0eilLiawDuCfYvawtILMqs
         sXOG61Bv+hg/oWtFn9jXVPv32dbh9L9YY4w9fT1Npoj886qrV1EwkYyBxrydV5/Bav6B
         RCV8nx4AqehIui573NE/643eXs3KJzVm5Cx2AyUboL8Ok+VdlV0iv7jKHPcSDSXyQJaR
         FQTgfB1YhgBcZ7VEze/IinhDip3SF0y+aDXzqCtXfSM2UYhMhut73hMopMlURmbfWQ5k
         aW+Bp2CSL7c6sHhh0lyyndYoEU/VfIV4nGnXdN9+vMsuBgPMp91Ks+ezZyfqMabK0q6G
         Qujw==
X-Gm-Message-State: AOAM531xhKKmyJpoomxArpM+Z3dZusE8kMyGSa1IfG8cvekg1X02RYQ9
        nTTxmM+vuQFFYkck3/64lCs=
X-Google-Smtp-Source: ABdhPJzeiJHpXyGWeMyPwywIJfNtJuhkuj9PeElHaoIQmiZg/wqFKE7FFfFomIYdVMAGygq+gTnBKg==
X-Received: by 2002:a17:903:1247:b0:156:25b4:4206 with SMTP id u7-20020a170903124700b0015625b44206mr22221552plh.146.1652208348998;
        Tue, 10 May 2022 11:45:48 -0700 (PDT)
Received: from localhost ([2620:10d:c090:400::4:6c64])
        by smtp.gmail.com with ESMTPSA id az4-20020a170902a58400b0015ee1797c7asm2410584plb.113.2022.05.10.11.45.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 11:45:48 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Tue, 10 May 2022 08:45:47 -1000
From:   Tejun Heo <tj@kernel.org>
To:     Yosry Ahmed <yosryahmed@google.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shuah Khan <shuah@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Michal Hocko <mhocko@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        David Rientjes <rientjes@google.com>,
        Greg Thelen <gthelen@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [RFC PATCH bpf-next 2/9] cgroup: bpf: flush bpf stats on rstat
 flush
Message-ID: <Ynqy20FjoCIqHZ1M@slm.duckdns.org>
References: <20220510001807.4132027-1-yosryahmed@google.com>
 <20220510001807.4132027-3-yosryahmed@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220510001807.4132027-3-yosryahmed@google.com>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 10, 2022 at 12:18:00AM +0000, Yosry Ahmed wrote:
> When a cgroup is popped from the rstat updated tree, subsystems rstat
> flushers are run through the css_rstat_flush() callback. Also run bpf
> flushers for all subsystems that have at least one bpf rstat flusher
> attached, and are enabled for this cgroup.
> 
> A list of subsystems that have attached rstat flushers is maintained to
> avoid looping through all subsystems for all cpus for every cgroup that
> is being popped from the updated tree. Since we introduce a lock here to
> protect this list, also use it to protect rstat_flushers lists inside
> each subsystem (since they both need to locked together anyway), and get
> read of the locks in struct cgroup_subsys_bpf.
> 
> rstat flushers are run for any enabled subsystem that has flushers
> attached, even if it does not subscribe to css flushing through
> css_rstat_flush(). This gives flexibility for bpf programs to collect
> stats for any subsystem, regardless of the implementation changes in the
> kernel.

Yeah, again, the fact that these things are associated with a speicfic
subsystem feels a bit jarring to me. Let's get that resolved first.

Thanks.

-- 
tejun
