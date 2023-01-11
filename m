Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59402665738
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 10:19:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238840AbjAKJTO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 04:19:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236446AbjAKJSB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 04:18:01 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D8BFF023
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 01:16:59 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id v23so15243435pju.3
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 01:16:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=b/b6e7jsf5yhAgFu4fUxpZlilYa8jtlXBJ4qRjXgyTA=;
        b=8A04byfqkRIgBXjqTXdHoUDBjHIwtORv0ImwfluBMoViexK5TMJOUYTYLezSWLIjGx
         oj7pjeo7vRucSDwAikZlMwqgjqlGJD1Jb/0kzzqTygsRnSHNyC6vOCwCj6lPWJ4ssk+0
         tUeCYWZq7/WuGyeTY5gFEs9udA2RyigFIJgoiaiR3f4+eXu/+w6aTbkfT2RbB78zwHwO
         bvCnVKPRSo7D4+W8sK9u79bWc+EOHC0FiUPhGpfNt+oqE/zeBrQ30xkF+Zud2gA2R81N
         EeTGAbFITlmMmNyJkfZ51otzg8M1+3Dg7LNhab8MDrsuNUYQxrP68IykxYKdm+Utva1a
         SQew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b/b6e7jsf5yhAgFu4fUxpZlilYa8jtlXBJ4qRjXgyTA=;
        b=qAAmonLfw2Bo9s0HDczV60OPT6f8MqeGWetj2qQhW7LqiqHcr1YyLmT1SDuv9RtXPU
         TMn5o1TL8ZlSqMBFzGoll+v8pA+NdD6PgqIVTJDt93nkpQKN6ZZnz2jahyj3VI8NyZiN
         z43lpAX6LCf+zYEt00/CFc+LimUh6o46AGkhj0c8BJKQfzSYSBd1ETRzcr9OsSUOXB+X
         v6VQPec9nUb48wNPN5PMFox2uy39kNL7tWZQD1UP5a2uu88dO7RVjdcb7PJv5Bnvr1gE
         rdBNYZ7IU/4lnY7xs6N7xhc/kgOzI4OFKL0uUnE6puLVwerEjGkMxdhuWysl+kbOahMD
         2nIQ==
X-Gm-Message-State: AFqh2kqWhpq4eC3VjDj88EF4fEDJiYbc5Oi0aN4Eilm1uwufLDnxPQsy
        NX/KYl6crnczmcqjOZm3P2Jsbw==
X-Google-Smtp-Source: AMrXdXuf0Lr7sWvoQYlLiNzwQJkpcIJNfffzOu5J+n84qn7Q2m3Rhi/ZuFqPyHBOO0AIo8cvUFO62Q==
X-Received: by 2002:a17:902:b78c:b0:193:29db:e0b7 with SMTP id e12-20020a170902b78c00b0019329dbe0b7mr11940691pls.54.1673428618602;
        Wed, 11 Jan 2023 01:16:58 -0800 (PST)
Received: from localhost (thunderhill.nvidia.com. [216.228.112.22])
        by smtp.gmail.com with ESMTPSA id d5-20020a63d645000000b00478fd9bb6c7sm8059998pgj.75.2023.01.11.01.16.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 01:16:58 -0800 (PST)
Date:   Wed, 11 Jan 2023 10:16:55 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jacob.e.keller@intel.com,
        syzbot+d94d214ea473e218fc89@syzkaller.appspotmail.com
Subject: Re: [PATCH net-next] devlink: keep the instance mutex alive until
 references are gone
Message-ID: <Y75+hwMTgQaFp9qL@nanopsycho>
References: <20230111042908.988199-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230111042908.988199-1-kuba@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jan 11, 2023 at 05:29:08AM CET, kuba@kernel.org wrote:
>The reference needs to keep the instance memory around, but also
>the instance lock must remain valid. Users will take the lock,
>check registration status and release the lock. mutex_destroy()
>etc. belong in the same place as the freeing of the memory.
>
>Unfortunately lockdep_unregister_key() sleeps so we need
>to switch the an rcu_work.
>
>Note that the problem is a bit hard to repro, because
>devlink_pernet_pre_exit() iterates over registered instances.
>AFAIU the instances must get devlink_free()d concurrently with
>the namespace getting deleted for the problem to occur.
>
>Reported-by: syzbot+d94d214ea473e218fc89@syzkaller.appspotmail.com
>Fixes: 9053637e0da7 ("devlink: remove the registration guarantee of references")
>Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>


>---
>Jiri, this will likely conflict with your series, sorry :(

Yeah, I will rebase and send v5 after this is applied, no worries.
