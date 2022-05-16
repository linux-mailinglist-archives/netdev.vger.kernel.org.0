Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16073528E4F
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 21:43:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346204AbiEPTmy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 15:42:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345778AbiEPTkZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 15:40:25 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ED893EF05;
        Mon, 16 May 2022 12:39:38 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id v11so14938896pff.6;
        Mon, 16 May 2022 12:39:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GYimId1+Z3hhnSt3/2nNJtZTsF0tDudFtRYq4c1fKfY=;
        b=R5Sk0i4/JyOhBJzBZp0K+RPNVt9HIka8OnOU+L2bHdV9YE2hWPmLIotmoiIZF8LZQz
         66O7qWnBam0wZ/0whB93uSJVskDVMvHpzgCU2Mx8msc5Tdd1Ol1iQWq3gefC+JCK1rmS
         b6ViDXxnzhTXexN/pWzDNBV6ZoSAOqS97ZXIxmbpSngi2n4HTDRElMO4v1s5YmxaX5tE
         dxzDcIhljQenRUkMeyc/GfyfFeHvaVGJQ29jhYz6zLccANx9a6u7kVXG0iaK2JShglMp
         C1PeVtT5MCq0I2hHMg+Xb3mcsgzvW9WWkeKUqVlBh306S+SLkBRla0iI3hrwd6u+vr4h
         otwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=GYimId1+Z3hhnSt3/2nNJtZTsF0tDudFtRYq4c1fKfY=;
        b=6TixvMxQ5UXauvQAJUSmedtn2di1jmSO7dky5m2wzlhzvBsZx9+9LsOXINmVL/udCu
         h1jUqTFtTqbeBmeIAWX1WDkbMN47X//dl4CEAyNoOcCmHmVXblmnseicfz6IVj12EWNw
         WtmVIENzOcWkdDkrhtIg2OLef9TYLvGqwYFNKcQzyttTbN0JinVg93diCa9kUusjzqzh
         cBE620KlF4VdzJiNP4Wh0Ao4OZEGN2tcCsrDOv2q9QvGsR0qexGXQigrZhCGhHd0TmSZ
         ZrLE6HUeV6OdlEmzXiUAAwg0DSvkOzQ0GW+ctoYBhGcO2iLkw9NqvxU6Q9YZsXqltvUk
         ETsQ==
X-Gm-Message-State: AOAM53096tXKH2CF3bPv3QIbqMJJKAxaGmhTjJsPojn+EdzTeLB2/NSS
        uxm/WQHR0Nv6E+IKFXoDfrNusZA4Zc8=
X-Google-Smtp-Source: ABdhPJyXzvwdQQ1UkYpxbYcYeTRiIKhHn0gzw4eDZjZeYj3t6YO9WJZtqDkNi2Ywf7TEKBylyV0nLA==
X-Received: by 2002:a63:e64d:0:b0:3f2:470f:c45 with SMTP id p13-20020a63e64d000000b003f2470f0c45mr10044647pgj.208.1652729977580;
        Mon, 16 May 2022 12:39:37 -0700 (PDT)
Received: from localhost ([2620:10d:c090:400::4:62fc])
        by smtp.gmail.com with ESMTPSA id q19-20020a17090a2e1300b001df78f27c10sm59447pjd.42.2022.05.16.12.39.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 12:39:37 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Mon, 16 May 2022 09:39:35 -1000
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
Subject: Re: [RFC PATCH bpf-next v2 0/7] bpf: rstat: cgroup hierarchical stats
Message-ID: <YoKod9FdpAe0L5dz@slm.duckdns.org>
References: <20220515023504.1823463-1-yosryahmed@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220515023504.1823463-1-yosryahmed@google.com>
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

Looks good from cgroup side.

Thanks.

-- 
tejun
