Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1019C58A5E2
	for <lists+netdev@lfdr.de>; Fri,  5 Aug 2022 08:29:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236021AbiHEG32 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 02:29:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230475AbiHEG31 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 02:29:27 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68F06606A2;
        Thu,  4 Aug 2022 23:29:26 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id t2-20020a17090a4e4200b001f21572f3a4so1972562pjl.0;
        Thu, 04 Aug 2022 23:29:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=66sTXdJI9D/uDofdTmj8j7tOsf58bY5fHMNycNv2J+8=;
        b=Sxdyg77bcCLSPX470DdsbQZEx5dV699VcOaq5ukagYnFSrvwC6HCy6vHuf29m2kzp6
         6jlO5vrBv6NObDGMAjeraj5FLjwX4Tp57UVpDYadL+P63SZnQR2VEepuzrElBjCWGE8/
         +V6pk4L1PxDZwIuzbVDBKMz6WLi0M1IjfDen82CXXNhEWXDk+qM9p/pLtMdIvmNo2PJT
         WHk8uGpaVfr3eJ9XKUIyyzUTYWXCgzKqEwS5ozEO9N/nS/wbPBA5xXHiRKnxWY9Wzagj
         Tv9LS/prQ9/4JbanwL3geBEP5n6WIzJHm3X1kW3HTTAuocL1BTGLHwnPRpnzbUWWbSQl
         ZW9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=66sTXdJI9D/uDofdTmj8j7tOsf58bY5fHMNycNv2J+8=;
        b=SZC9ZEub+rI28dbQ37FbG9tOhEboafy/rd5CbCO0BgxlMGGcxNs8D5TZpF4hlS1ZQY
         AFPlQbO9GFbKDPFoV2PiMU0vTonzR2DEFC9ORDhumtfFwlg4m71MKsfO/cD09lo9YLnT
         5nLlQTj+m8IDaxbqj41fM/FBfAip8wr09i5KfOZiLkClhgaMnwpujOJk8aW0q+zLKz/H
         7mjF7ynxKDyIXwZUidWTAz95Klrg+I72LwFPCc/KUtgPC/e6TRY64McEjmVjeenZV93+
         UvNNlKCKHbvug+FTF7qYISLaAFnHIvCKoxvzMxdjx7GkC53fqyB9nhRTSXZqcQEEpDmt
         9wUQ==
X-Gm-Message-State: ACgBeo2RDmxl8exq2NucYq3MU3yJahQ1GRBy7iYaFaRKeYlL/DLQJby6
        8telO/etrA0F5vE1wOxImgi6UZa1/xSPoot8dfI=
X-Google-Smtp-Source: AA6agR6UmBwWOgZYHRJ2y4V+wTp2HKx/I92yQS+ZTaDQ6QxXZrn2yn1rC0fWpJKkVCxNVmTpSak5dw==
X-Received: by 2002:a17:90a:558f:b0:1f5:bbc:c58e with SMTP id c15-20020a17090a558f00b001f50bbcc58emr14305788pji.102.1659680965733;
        Thu, 04 Aug 2022 23:29:25 -0700 (PDT)
Received: from localhost ([117.136.0.155])
        by smtp.gmail.com with ESMTPSA id m17-20020a170902d19100b0016d83ed0a2csm2056223plb.80.2022.08.04.23.29.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Aug 2022 23:29:25 -0700 (PDT)
From:   Hawkins Jiawei <yin31149@gmail.com>
To:     kuba@kernel.org
Cc:     18801353760@163.com, andrii@kernel.org, ast@kernel.org,
        borisp@nvidia.com, bpf@vger.kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, edumazet@google.com, guwen@linux.alibaba.com,
        jakub@cloudflare.com, john.fastabend@gmail.com, kafai@fb.com,
        kgraul@linux.ibm.com, kpsingh@kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, paskripkin@gmail.com, skhan@linuxfoundation.org,
        songliubraving@fb.com,
        syzbot+5f26f85569bd179c18ce@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com, yin31149@gmail.com
Subject: Re: [PATCH v4] net: fix refcount bug in sk_psock_get (2)
Date:   Fri,  5 Aug 2022 14:28:44 +0800
Message-Id: <20220805062844.89787-1-yin31149@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220804082913.5dac303c@kernel.org>
References: <20220804082913.5dac303c@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 4 Aug 2022 at 23:29, Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu,  4 Aug 2022 11:05:15 +0800 Hawkins Jiawei wrote:
> > I wonder if it is proper to gather these together in a patchset, for
> > they are all about flags in sk_user_data, maybe:
> >
> > [PATCH v5 0/2] net: enhancement to flags in sk_user_data field
> >       - introduce the patchset
> >
> > [PATCH v5 1/2] net: clean up code for flags in sk_user_data field
> >       - refactor the things in include/linux/skmsg.h and
> > include/net/sock.h
> >       - refactor the flags's usage by other code, such as
> > net/core/skmsg.c and kernel/bpf/reuseport_array.c
> >
> > [PATCH v5 2/2] net: fix refcount bug in sk_psock_get (2)
> >       - add SK_USER_DATA_PSOCK flag in sk_user_data field
>
> Usually the fix comes first, because it needs to be backported to
> stable, and we don't want to have to pull extra commits into stable
> and risk regressions in code which was not directly involved in the bug.
Ok, I got it. Thanks for the explanation.
