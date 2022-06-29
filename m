Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33E8F5609EA
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 21:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbiF2TFc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 15:05:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbiF2TFb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 15:05:31 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 992D31F2ED
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 12:05:30 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id n16-20020a17090ade9000b001ed15b37424so382201pjv.3
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 12:05:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0GeTuZBlfQ/Y+eNOOfDxK3ZM+hvemUe7AZCxhx5HzJ8=;
        b=JJYOmj+afcpj4I6DhLvv1DJGSO9RU/r60gm7oBHP/z1whsgUGzshmjyS+68ykpAOrB
         PZMVASKhx3vYZgCdJaQmdVJhBWuZNtboZlCiQyj6WAMRN4Kvh07DF4VTpK0Sj27Lsl6/
         B+YuMmqeZEeQs4/Hm/ALEzJa6KWlGaRQbzl9tn855YrjL5qXif4aSzoOgvxnIP9DSA9A
         AjCVE/CVQkZEpunegRnMqN99nSMRJRGN9GrvEGnWTqbNczB5UFxLzgL4Q0ol3VBjFalf
         WfkCL65+80IbqNSPjmY0C880X/KyGHWw3qCM01dlaIuQdT6x35pnOEkDo3rr7x3tH16d
         1ARw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0GeTuZBlfQ/Y+eNOOfDxK3ZM+hvemUe7AZCxhx5HzJ8=;
        b=5fIInL7zMGdBq4ggJMinhKiW6b/a4W/7YYtN6VurdF7eL4nEEZ1oimb1JCevYTDMnQ
         gYSF4ZaZXrslzTWOUdCcyr+yhEgSbT6cK7jLKRChKHzMrxTk6LiMzHzw5f6zjRxq2C7+
         ien24Fi4nxj8JjgV39ATn+NggTvNAhlElq6E6lVwyLjmx6HTr/3+Y/fFnrkCSMofuYq+
         cYEeKxWSSRlVXeO7xgTiPqQm3IikiNeTDEStioHoIHucH0oRUE9mG66B1CFoXj+3oNUr
         5V9s8iWIFZSar/RcCuxi+6330fX0d6HJ5iDLq4Nzk2HFTjZ079AOkMMZlAvjk5OseXVP
         Rd1A==
X-Gm-Message-State: AJIora/j2FHzECTFb7pzvfrPoUq1WusUApDpuGIYueRCdzSoANOokLqZ
        9ztWXVdPKuYiNh93ZDhn4qO3fw==
X-Google-Smtp-Source: AGRyM1vezWQnhsis70N2EBTExcFOKozEQIEPyaWoe+3MDeqfKtNE7YXyrWd0EDrKpPcD6CkEYj+x7A==
X-Received: by 2002:a17:902:f552:b0:16a:a17:a9bd with SMTP id h18-20020a170902f55200b0016a0a17a9bdmr10672461plf.97.1656529529720;
        Wed, 29 Jun 2022 12:05:29 -0700 (PDT)
Received: from google.com ([2620:15c:211:200:1fe6:e5f3:8461:101c])
        by smtp.gmail.com with ESMTPSA id e17-20020a63ee11000000b004119deff40dsm79889pgi.23.2022.06.29.12.05.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jun 2022 12:05:28 -0700 (PDT)
Date:   Wed, 29 Jun 2022 12:05:23 -0700
From:   Kalesh Singh <kaleshsingh@google.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Todd Kjos <tkjos@android.com>,
        Martijn Coenen <maco@android.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Christian Brauner <brauner@kernel.org>,
        Hridya Valsaraju <hridya@google.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Theodore Ts'o <tytso@mit.edu>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Alex Xu (Hello71)" <alex_y_xu@yahoo.ca>,
        Paolo Abeni <pabeni@redhat.com>, Rob Herring <robh@kernel.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Neeraj Upadhyay <quic_neeraju@quicinc.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
        wireguard@lists.zx2c4.com, netdev@vger.kernel.org,
        rcu@vger.kernel.org, linux-kselftest@vger.kernel.org,
        sultan@kerneltoast.com
Subject: Re: [PATCH] remove CONFIG_ANDROID
Message-ID: <Yryic4YG9X2/DJiX@google.com>
References: <20220629150102.1582425-1-hch@lst.de>
 <20220629150102.1582425-2-hch@lst.de>
 <Yrx5Lt7jrk5BiHXx@zx2c4.com>
 <20220629161020.GA24891@lst.de>
 <Yrx6EVHtroXeEZGp@zx2c4.com>
 <20220629161527.GA24978@lst.de>
 <Yrx8/Fyx15CTi2zq@zx2c4.com>
 <20220629163007.GA25279@lst.de>
 <Yrx/8UOY+J8Ao3Bd@zx2c4.com>
 <YryNQvWGVwCjJYmB@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YryNQvWGVwCjJYmB@zx2c4.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 29, 2022 at 07:34:58PM +0200, Jason A. Donenfeld wrote:
> On Wed, Jun 29, 2022 at 06:38:09PM +0200, Jason A. Donenfeld wrote:
> > On the technical topic, an Android developer friend following this
> > thread just pointed out to me that Android doesn't use PM_AUTOSLEEP and
> > just has userspace causing suspend frequently. So by his rough
> > estimation your patch actually *will* break Android devices. Zoinks.
> > Maybe he's right, maybe he's not -- I don't know -- but you should
> > probably look into this if you want this patch to land without breakage.
> 
> More details: https://cs.android.com/android/platform/superproject/+/master:system/core/libsuspend/autosuspend_wakeup_count.cpp;bpv=1;bpt=1;l=52?q=%22%2Fsys%2Fpower%2Fstate%22&start=51&gsn=sys_power_state&gs=kythe%3A%2F%2Fandroid.googlesource.com%2Fplatform%2Fsuperproject%3Flang%3Dc%252B%252B%3Fpath%3Dsystem%2Fcore%2Flibsuspend%2Fautosuspend_wakeup_count.cpp%23ftWlDJuOhS_2fn3Ri7rClxA30blj_idGgT12aoUHd1o
> 
> So indeed it looks like it's userspace controlled. If you want this to
> be a runtime, rather than a compiletime, switch, maybe
> autosuspend_init() of that file could write to a sysctl.
> 
> Who at Google "owns" that code? Can somebody CC them in?

Hi Jason,

Thanks for raising this.

Android no longer uses PM_AUTOSLEEP, is correct. libsuspend is
also now deprecated. Android autosuspend is initiatiated from the
userspace system suspend service [1].

A runtime config sounds more reasonable since in the !PM_AUTOSLEEP
case, it is userspace which decides the suspend policy.

[1] https://cs.android.com/android/platform/superproject/+/bf3906ecb33c98ff8edd96c852b884dbccb73295:system/hardware/interfaces/suspend/1.0/default/SystemSuspend.cpp;l=265

--Kalesh

> 
> Jason
> 
