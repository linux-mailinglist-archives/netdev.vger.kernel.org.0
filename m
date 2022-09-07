Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B2EF5B09D6
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 18:13:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbiIGQNa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 12:13:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbiIGQN1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 12:13:27 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 906EC9C21C;
        Wed,  7 Sep 2022 09:13:22 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id a70so4333364edf.10;
        Wed, 07 Sep 2022 09:13:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=CdfonG3Daj+a+DRtXJOAxXJ4mGEklFmGRagUZWD+cvk=;
        b=Z1rGqY1ffwxgupGWkW6pQ+f5YhPrqQnvr/EKxVoO5zamDhVUf5LFJW6hwj/MoDMCGo
         rCiXcvnPDuekOgwxJPi7xLOUMAr3g7SVrx3Ijy6giUgCxCU3P+Cy7G1iQu/YtGCS+X09
         jq4RJykUP1fu4qw2jrQEP4nQpO546ANxS8bWLYiBJyJ/hfR7W41j9LbGe11pSK1HFXfa
         qvA7OgVXsIBXah6n3P8RTNJzcNSYepd8caKdsjGhuNOJcLoMOnRsTag7aQlQQCeLeGjL
         rVIKJrbqOqCz0HBcs/YudYF7oXU3fUx3qoEnHjsrRgckkwr9OlrcaW5HMhkj7XH3PibM
         Ur9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=CdfonG3Daj+a+DRtXJOAxXJ4mGEklFmGRagUZWD+cvk=;
        b=kqOjxWozx1Wit7HI5s8TzBjCQz4V68CDwfGm79gq3omcON1jQzsQM4ZmVLiQ0SFh3n
         5xByeKF+gFcGuRtGka3KSl1bKr9kpTAq2vjNnVugA5YEdH5gzt7/0qj5m5c57WV8RBCj
         Q4LUeHMZFc9ZZeL8YphP2wjriG6H3bp/9K6MTSQBWkwowJKDJkok8sR5WZHrigNjpRD4
         9Z4pa9OXgYt8jGKWqQ/Ug40ZdDYAghHpMYex4FiBDcsk/wPRo8v8iuHkq9qodmGQ2szA
         H9LaJ1tOcMPh3t2vci/SpnmElpdBKdvIQ6Jmj/NW7qtI+hoNNCw94ZVMOE2Bzwqlxoi1
         sALw==
X-Gm-Message-State: ACgBeo2xcKF5t3NgRCtdLbWolZr/8hsSyag9kUWNbbalG4ECOtCVZ7rD
        LpHKjjnBzAaqKiCufORKFOZxLtcM6DYlmMDHY6I=
X-Google-Smtp-Source: AA6agR5+UidDgRUpY92PgyIJue81nkq58ErJIlNMk27idwNe8XRuenn1OA+5aUlnmCwefOHw+9bH0poa2V8hdxGi3LA=
X-Received: by 2002:a05:6402:28cb:b0:43b:c6d7:ef92 with SMTP id
 ef11-20020a05640228cb00b0043bc6d7ef92mr3758898edb.333.1662567201046; Wed, 07
 Sep 2022 09:13:21 -0700 (PDT)
MIME-Version: 1.0
References: <20220902023003.47124-1-laoar.shao@gmail.com> <Yxi8I4fXXSCi6z9T@slm.duckdns.org>
 <Yxi8i3eP4fDDv2+X@slm.duckdns.org>
In-Reply-To: <Yxi8i3eP4fDDv2+X@slm.duckdns.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 7 Sep 2022 09:13:09 -0700
Message-ID: <CAADnVQ+ZMCeKZOsb3GL0CnnZW0pxR0oDTUjqDczvbsVAViLs-Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 00/13] bpf: Introduce selectable memcg for bpf map
To:     Tejun Heo <tj@kernel.org>
Cc:     Yafang Shao <laoar.shao@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeelb@google.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Zefan Li <lizefan.x@bytedance.com>,
        "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 7, 2022 at 8:45 AM Tejun Heo <tj@kernel.org> wrote:
>
> On Wed, Sep 07, 2022 at 05:43:31AM -1000, Tejun Heo wrote:
> > Hello,
> >
> > On Fri, Sep 02, 2022 at 02:29:50AM +0000, Yafang Shao wrote:
> > ...
> > > This patchset tries to resolve the above two issues by introducing a
> > > selectable memcg to limit the bpf memory. Currently we only allow to
> > > select its ancestor to avoid breaking the memcg hierarchy further.
> > > Possible use cases of the selectable memcg as follows,
> >
> > As discussed in the following thread, there are clear downsides to an
> > interface which requires the users to specify the cgroups directly.
> >
> >  https://lkml.kernel.org/r/YwNold0GMOappUxc@slm.duckdns.org
> >
> > So, I don't really think this is an interface we wanna go for. I was hoping
> > to hear more from memcg folks in the above thread. Maybe ping them in that
> > thread and continue there?
>
> Ah, another thing. If the memcg accounting is breaking things right now, we
> can easily introduce a memcg disable flag for bpf memory. That should help
> alleviating the immediate breakage while we figure this out.

Hmm. We discussed this option already. We definitely don't want
to introduce an uapi knob that will allow anyone to skip memcg
accounting today and in the future.
