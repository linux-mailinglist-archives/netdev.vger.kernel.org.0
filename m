Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E95E4F1A8D
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 23:16:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379052AbiDDVSg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 17:18:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379585AbiDDRjX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 13:39:23 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68308B7F1;
        Mon,  4 Apr 2022 10:37:27 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id o10so2834365ple.7;
        Mon, 04 Apr 2022 10:37:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GF6jYnbv+1XzUXRiGnhvotzYBkOK/c7/Q8J5sZsBF/I=;
        b=NMBYADdu0/CesKqHTLEl52yzW4yrtN8zu7Y7cc+5VzNIEomJlvDWGHG1C0qoy1lwLj
         ncb1Ec9VBU27yDfmdH0eFLwFs6g3KWejO19Ptfi+s92r1Y4IeCUYyxuiGS1eGBKsHnHm
         6xaxAA9nYogWlYhOKKxqb/tc+bU68zDVnK4MgF98bjAbi8CFe7hEjYKOSNBQKZSAjzqt
         M1rQZfeFWzlbSlReJ2801hwI9WOJSeNmfEOloxqbQ0YuhcMlpmp9s45vg/zanmaIXz+Y
         x64Kk+bocsKiVr3v4YCkg9clHIkO4cTMTjIFORyBh7hu1BH7r1rtZV8d5AQSIQ5qJQpP
         0kSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=GF6jYnbv+1XzUXRiGnhvotzYBkOK/c7/Q8J5sZsBF/I=;
        b=XQA0IARyGFWxlKc1s+bUnY5qJM69g8qqyUDLAWT3W3Ja2JdV2hr1xsO10NwvHofA5I
         J51ZmxonsdKp+OoFVRHCh9SqhcDmnD5x53tMgbAuOgXqQ270uyiwyFmmIXRuHudNn2fq
         07F/iut35tHPF7YFxYD1FUPR+QHNfTmYJgpL9OOLD/R2A+2bEDpuZdM4lanEoPwnf4hf
         RvnLZVia+sgg3ywRH+tlJzroBmbr9OGABmKBhgvLeNnjQBljYmV4GnUcc9xp+3W3SM6w
         LDjS9sT0cBvPr98F9igr6mrkzbZIAJv9FGkI1amVtWAPtyDxQfXFZ52OggHoQuGj9xMP
         a+bw==
X-Gm-Message-State: AOAM5336TQ8EyBdHQDlnYsmx4h44LzQatrNCmmKWQZ7Vrh5tCj3cI+fc
        8cePjOt0XRwL35vAf8gcWRg=
X-Google-Smtp-Source: ABdhPJx4rdta2NfR/b+BcIMgdN7ZCIgKnXj+l1MBFsdppb0BKNRqz5eKEwlXfIBRDhaiiKADs//iwA==
X-Received: by 2002:a17:902:e743:b0:153:a902:8d8c with SMTP id p3-20020a170902e74300b00153a9028d8cmr750828plf.150.1649093846584;
        Mon, 04 Apr 2022 10:37:26 -0700 (PDT)
Received: from localhost ([2620:10d:c090:400::5:baee])
        by smtp.gmail.com with ESMTPSA id f6-20020a056a00238600b004fae79a3cbfsm13629265pfc.100.2022.04.04.10.37.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Apr 2022 10:37:25 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Mon, 4 Apr 2022 07:37:24 -1000
From:   Tejun Heo <tj@kernel.org>
To:     Bui Quang Minh <minhquangbui99@gmail.com>
Cc:     cgroups@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH v2] cgroup: Kill the parent controller when its last
 child is killed
Message-ID: <Ykss1N/VYX7femqw@slm.duckdns.org>
References: <20220404142535.145975-1-minhquangbui99@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220404142535.145975-1-minhquangbui99@gmail.com>
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

Hello,

On Mon, Apr 04, 2022 at 09:25:34PM +0700, Bui Quang Minh wrote:
> When umounting a cgroup controller, in case the controller has no children,
> the initial ref will be dropped in cgroup_kill_sb. In cgroup_rmdir path,
> the controller is deleted from the parent's children list in
> css_release_work_fn, which is run on a kernel worker.
> 
> With this simple script
> 
> 	#!/bin/sh
> 
> 	mount -t cgroup -o none,name=test test ./tmp
> 	mkdir -p ./tmp/abc
> 
> 	rmdir ./tmp/abc
> 	umount ./tmp
> 
> 	sleep 5
> 	cat /proc/self/cgroup
> 
> The rmdir will remove the last child and umount is expected to kill the
> parent controller. However, when running the above script, we may get
> 
> 	1:name=test:/

First of all, remounting after active use isn't a well-supported use case as
documented in the admin doc. The problem is that there's no finite time
horizon around when all the references are gonna go away - some references
may be held in cache which may not be released unless certain conditions are
met. So, while changing hierarchy configuration is useful for system setup,
development and debugging, for production use, it's a boot time
configuration mechanism.

> This shows that the parent controller has not been killed. The reason is
> after rmdir is completed, it is not guaranteed that the parent's children
> list is empty as css_release_work_fn is deferred to run on a worker. In
> case cgroup_kill_sb is run before that work, it does not drop the initial
> ref. Later in the worker, it just removes the child from the list without
> checking the list is empty to kill the parent controller. As a result, the
> parent controller still has the initial ref but without any logical refs
> (children ref, mount ref).
> 
> This commit adds a free parent controller path into the worker function to
> free up the parent controller when the last child is killed.

And the suggested behavior doesn't make much sense to me. It doesn't
actually solve the underlying problem but instead always make css
destructions recursive which can lead to surprises for normal use cases.

Thanks.

-- 
tejun
