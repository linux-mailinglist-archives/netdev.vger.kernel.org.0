Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D072B5B4153
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 23:15:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229899AbiIIVPq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 17:15:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbiIIVPp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 17:15:45 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CC22A220D;
        Fri,  9 Sep 2022 14:15:45 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id p18so2914940plr.8;
        Fri, 09 Sep 2022 14:15:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=bYdkG3sA2KAUrrJYCSYLU4H9KRcohF9dqpdnh/5rnKg=;
        b=mcBuJVl8t3eyRCmOMRoeCOZpPZMo0NWm3++hS7OHGIkoDKCkhK9Lj3vnDgo4CYN9kw
         4sybxy07MVj0Fl/6XbJiQAvt/0uf1ZA9aGWegy/BEKDe/KuOkcKIyWgH5Kca17GndEyv
         tNTs+db4uV8pyPN2f+cd9XENvvZ+XJ/oyKzc2R4HPIi+MgPfyn4TNj4azNelhWe4AX4E
         TAt8Wm80JTkjJHRIjDxUGr9Yu9sFWxUZRt685zfPJmKr5tf08IcdF+W/LQy2bR4rmV2y
         KDOjop4XP7QnrWh6hWEZOZw/Mb6Kg6x1CQibqpnDrmwTJPTDyl52WskH3bLTI8+CtDPo
         GMkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=bYdkG3sA2KAUrrJYCSYLU4H9KRcohF9dqpdnh/5rnKg=;
        b=QJdbR0bAt9oW1pHZm5T8ZfEgQTlfd4ESVT8yIovSESxIPKOWZAAjWTwKJlfbDxT483
         HoqizqIr34kZDtl0A3ZubdG2xkP3+NWufV7jSwiI3qVZIWtqbSHcRK9SUONLcoHxNKVP
         KyO0V2ELN8KCEjIg0sA+L0jPsXpVwNEAleV3ILbF7FS480izA+R1GMzZAp8/RV/dT4o1
         bKmb46OprUhvAwnYqBl+LWFFq/lg7kW2+0G5CNXGqZKj6R3leRyzyMu35/ra4N/9pEUo
         eXBfAsgJm6nMH7fmqt050m21MuZnaUzQ25PHRltTQVNinFI0I9szp9Lcn46aQLhR3EJd
         TtrQ==
X-Gm-Message-State: ACgBeo1TmtO3NNqVCkNabdW+Gbxx0b0ZAbb4T2gMBPPAUsh1UitUKojW
        S+hGJicHLEIwS3Q3jKuLAQ==
X-Google-Smtp-Source: AA6agR6Eu2GT9bB4MMbG6b87ZqbZg8KH+Fqf/rJDkQFGjYrNtBR8BdWj5fK8nNFWL4cv9yeMob3N3Q==
X-Received: by 2002:a17:903:18a:b0:16f:8a63:18fe with SMTP id z10-20020a170903018a00b0016f8a6318femr15548430plg.174.1662758144506;
        Fri, 09 Sep 2022 14:15:44 -0700 (PDT)
Received: from bytedance ([74.199.177.246])
        by smtp.gmail.com with ESMTPSA id w63-20020a623042000000b00528a097aeffsm8941pfw.118.2022.09.09.14.15.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Sep 2022 14:15:43 -0700 (PDT)
Date:   Fri, 9 Sep 2022 14:15:40 -0700
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     sdf@google.com
Cc:     Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, davem@davemloft.net,
        haoluo@google.com, hawk@kernel.org,
        John Fastabend <john.fastabend@gmail.com>, jolsa@kernel.org,
        KP Singh <kpsingh@kernel.org>, kuba@kernel.org,
        lkml <linux-kernel@vger.kernel.org>, llvm@lists.linux.dev,
        martin.lau@linux.dev, nathan@kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        Networking <netdev@vger.kernel.org>, Song Liu <song@kernel.org>,
        syzkaller-bugs@googlegroups.com, Tom Rix <trix@redhat.com>,
        Yonghong Song <yhs@fb.com>,
        Peilin Ye <peilin.ye@bytedance.com>,
        Peilin Ye <yepeilin.cs@gmail.com>
Subject: Re: [syzbot] WARNING in bpf_verifier_vlog
Message-ID: <20220909211540.GA11304@bytedance>
References: <000000000000e506e905e836d9e7@google.com>
 <YxtrrG8ebrarIqnc@google.com>
 <CAO-hwJJyrhmzWY4fth5miiHd3QXHvs4KPuPRacyNp8xrTxOucA@mail.gmail.com>
 <YxuZ3j0PE0cauK1E@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YxuZ3j0PE0cauK1E@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

On Fri, Sep 09, 2022 at 12:54:06PM -0700, sdf@google.com wrote:
> On 09/09, Benjamin Tissoires wrote:
> Yeah, good point. I've run the repro. I think the issue is that
> syzkaller is able to pass btf with a super long random name which
> then hits BPF_VERIFIER_TMP_LOG_SIZE while printing the verifier
> log line. Seems like a non-issue to me, but maybe we need to
> add some extra validation..

In btf_func_proto_check_meta():

	if (t->name_off) {
		btf_verifier_log_type(env, t, "Invalid name");
		return -EINVAL;
	}

In the verifier log, maybe we should just say that BTF_KIND_FUNC_PROTO "must
not have a name" [1], instead of printing out the user-provided
(potentially very long) name and say it's "Invalid" ?

Similarly, for name-too-long errors, should we truncate the name to
KSYM_NAME_LEN bytes (see __btf_name_valid()) in the log ?

[1] commit 2667a2626f4d ("bpf: btf: Add BTF_KIND_FUNC and BTF_KIND_FUNC_PROTO")

Thanks,
Peilin Ye

