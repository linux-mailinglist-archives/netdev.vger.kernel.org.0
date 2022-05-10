Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD56D522751
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 01:04:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237624AbiEJXDy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 19:03:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231931AbiEJXDw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 19:03:52 -0400
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11168994E4;
        Tue, 10 May 2022 16:03:52 -0700 (PDT)
Received: by mail-qv1-xf2b.google.com with SMTP id h13so699172qvh.0;
        Tue, 10 May 2022 16:03:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4CWgQ7c6/so/TrZFvbwKiAbSDiJmPs4rDdHHcrJQtFY=;
        b=YRQ5V62GTRb10bX8N3+J8kh/1ZwJZL1FpEBKWVJYhMlGjneANpvKqhPlQ1a7EiO3vX
         gF72VMSHkCNicG9RpMtX1FOk2F2cw/0ekzKKzpASenfOHL2GeOEK0LCFHKNz39OgnMnZ
         FRr4lv2lEZGeq4WO2FUNps1VgdiPL23cQpJzwwoeCRY6b8Xad5FV2PkKNkY2tuVF2fW1
         uSNS3K7J4eJopwOuo6emOXzAjesxUPQ3DiHtpP+TlnAT1dlsBoR8Bopg3GCkHxUVw9aC
         vtY+hMTjmu3CKmh+pAFVu1V4NpHkPIIpkIdDsGWmI6hokKOB1txXxuvAI5XLDoYnJhbj
         vI3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4CWgQ7c6/so/TrZFvbwKiAbSDiJmPs4rDdHHcrJQtFY=;
        b=dD43bhrMcDeuquG8qXnSHK0CpKNRL6DEPERms/IrDoLPOgUZMfP1D4Rs5F/030u2U2
         uUtcSxMmUco/uRR7CED4aC2RG3Y+IEVlURk6R24wXYEjXXUAUPOTl8u4y+igDmEabf6G
         nFAzdggrAAeJIAzMES6CNH2YnqKUjGbd3MMjhjEv8tewJ57mkKfd9fILnDdrjOMop3Tw
         GRvBGAGLCbv2/ITUtItNaCTGKXLYktGl+nclBnz3PwNj2IZs+pIFOXC5zq7DLLFls1R8
         MA3uJBpcw46FAG2J8kAuIOM6VwJOb+bU2DstDmVXscFHF+BDEnOL7gfNnQu3SwSLvWHl
         bO8Q==
X-Gm-Message-State: AOAM530DZLpzHWsdedGTVhfHEAVoO1XDsbRHmbGeJ1od0Gdna+yvSgos
        eqAsOe4lhhB+5e5FaEhIUw==
X-Google-Smtp-Source: ABdhPJxv0CW8oYBzduzbC6FQyXdJZdYmqQx7/b3pW9+LHlMx6EM5cQPG9vCAGt1DxHb0IdgcU+4QwA==
X-Received: by 2002:ad4:594f:0:b0:45a:8f92:7a2e with SMTP id eo15-20020ad4594f000000b0045a8f927a2emr20340711qvb.28.1652223831205;
        Tue, 10 May 2022 16:03:51 -0700 (PDT)
Received: from bytedance (ec2-52-72-174-210.compute-1.amazonaws.com. [52.72.174.210])
        by smtp.gmail.com with ESMTPSA id s11-20020ac8528b000000b002f39b99f684sm173738qtn.30.2022.05.10.16.03.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 16:03:50 -0700 (PDT)
Date:   Tue, 10 May 2022 16:03:47 -0700
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Peilin Ye <peilin.ye@bytedance.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>
Subject: Re: [PATCH RFC v1 net-next 0/4] net: Qdisc backpressure
 infrastructure
Message-ID: <20220510230347.GA11152@bytedance>
References: <cover.1651800598.git.peilin.ye@bytedance.com>
 <2dbd5e38-b748-0c16-5b8b-b32bc0cc43b0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2dbd5e38-b748-0c16-5b8b-b32bc0cc43b0@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

On Mon, May 09, 2022 at 08:26:27PM -0700, Eric Dumazet wrote:
> On 5/6/22 12:43, Peilin Ye wrote:
> > From: Peilin Ye <peilin.ye@bytedance.com>
> > 
> > Hi all,
> > 
> > Currently sockets (especially UDP ones) can drop a lot of skbs at TC
> > egress when rate limited by shaper Qdiscs like HTB.  This experimental
> > patchset tries to improve this by introducing a backpressure mechanism, so
> > that sockets are temporarily throttled when they "send too much".
> > 
> > For now it takes care of TBF, HTB and CBQ, for UDP and TCP sockets.  Any
> > comments, suggestions would be much appreciated.  Thanks!
> 
> This very much looks like trying to solve an old problem to me.
> 
> If you were using EDT model, a simple eBPF program could get rid of the
> HTB/TBF qdisc
> 
> and you could use MQ+FQ as the packet schedulers, with the true multiqueue
> sharding.
> 
> FQ provides fairness, so a flow can not anymore consume all the qdisc limit.

This RFC tries to solve the "when UDP starts to drop (whether because of
per-flow or per-Qdisc limit), it drops a lot" issue described in [I] of
the cover letter; its main goal is not to improve fairness.

> (If your UDP sockets send packets all over the place (not connected
> sockets),
> 
> then the eBPF can also be used to rate limit them)

I was able to reproduce the same issue using EDT: default sch_fq
flow_limit (100 packets), with a 1 Gbit/sec rate limit.  Now if I run
this:

  $ iperf -u -c 1.2.3.4 -p 5678 -l 3K -i 0.5 -t 30 -b 3g

  [ ID] Interval       Transfer     Bandwidth
  [  3]  0.0- 0.5 sec   137 MBytes  2.29 Gbits/sec
  [  3]  0.5- 1.0 sec   142 MBytes  2.38 Gbits/sec
  [  3]  1.0- 1.5 sec   117 MBytes  1.96 Gbits/sec
  [  3]  1.5- 2.0 sec   105 MBytes  1.77 Gbits/sec
  [  3]  2.0- 2.5 sec   132 MBytes  2.22 Gbits/sec
  <...>                             ^^^^^^^^^^^^^^

On average it tries to send 2.31 Gbits per second, dropping 56.71% of
the traffic:

  $ tc -s qdisc show dev eth0
  <...>
  qdisc fq 5: parent 1:4 limit 10000p flow_limit 100p buckets 1024 orphan_mask 1023 quantum 18030 initial_quantum 90150 low_rate_threshold 550Kbit refill_delay 40.0ms
   Sent 16356556 bytes 14159 pkt (dropped 2814461, overlimits 0 requeues 0)
                                  ^^^^^^^^^^^^^^^

This RFC does not cover EDT though, since it does not use Qdisc watchdog
or friends.

Thanks,
Peilin Ye

