Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AAD35BF28F
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 03:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230011AbiIUBFa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 21:05:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230366AbiIUBF3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 21:05:29 -0400
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 538BD17AA9;
        Tue, 20 Sep 2022 18:05:28 -0700 (PDT)
Received: by mail-qt1-x82c.google.com with SMTP id cj27so3099958qtb.7;
        Tue, 20 Sep 2022 18:05:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=NpSOfoxet6fpFE78x3YM7TEF5iWYleKq0HWQ8JXp4es=;
        b=L+vbQVXyN74JEnV20w0WoCNLCR0ZWgmXoDrA9JRcwvYNiXt1Nrb55mlCQph+16Y3HI
         AIbs//xJzjYl80dj8xINDTazyeU+Tk2Ck/bKWtEhzGD97Xzvhkh9R8tJhgGnwo4qKv/b
         cnBt5/QnrbaaUWPnzahD4M5V1ZJgjtMQDHAygpvhKxzvP4YyhPDUThmgtvumvp24KGOl
         O6YG4XB8412LfsiaMq6wSrjZbvLwxT173iNZhExISe99ih7W/xvO27TQ3YpF7hAAN2UQ
         lGdRqjhgcJOJKGRyV6he1XqdDVK76G/yC+9ALyqLdDNfg9OY+hkvCM+fZlUxERfTbvd1
         q3ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=NpSOfoxet6fpFE78x3YM7TEF5iWYleKq0HWQ8JXp4es=;
        b=PYZP5BImtBA0/2Bh7cORVPMT7pE1A+l9kD4KPeSVdshBePoq5zUAIYB4xVz1VAAFzE
         vXoWHBzQDCGGWPD0tIhxcLzPxTjrUvC2/flCRDpEH4kXO9FgvHRQUPM/tCtXjgK+aoDa
         9qswYwJa8tVathd3PR4/4DrBsoGKWo1DyW4n/MVGRBHn0Cnh2FYi26i8J7AkdD89pBps
         pWw36kJmTzIKE/NnatqSaYccVlzoUy0zV+HVYQnoG16hS0lBFtwKoDIKIuoMoBzY68Mi
         ffCwaW2WItWOK3M+6RfyaMdJC8/AbI25M1pyJVZ2YYH2pniuEkToELdKWNBofSz0ZzlJ
         7rfA==
X-Gm-Message-State: ACrzQf3fbS/GqgeI4m9CDxjhFi3iJErkTcg7eTEUdunnFCu1JPWE7lnP
        Zvlt7uDQnIIatcHGmxBfYQ==
X-Google-Smtp-Source: AMsMyM4scnSyNObpXqp6+NVFEG38jdtFZ65wDMOQ8XhGqWdnt4WEMwi/LbspcFAziI/szGOT6MVf9w==
X-Received: by 2002:a05:622a:110b:b0:35c:d403:6d95 with SMTP id e11-20020a05622a110b00b0035cd4036d95mr19170291qty.495.1663722327486;
        Tue, 20 Sep 2022 18:05:27 -0700 (PDT)
Received: from bytedance (ec2-3-231-65-244.compute-1.amazonaws.com. [3.231.65.244])
        by smtp.gmail.com with ESMTPSA id bn29-20020a05620a2add00b006bbf85cad0fsm881171qkb.20.2022.09.20.18.05.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Sep 2022 18:05:26 -0700 (PDT)
Date:   Tue, 20 Sep 2022 18:05:23 -0700
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Peilin Ye <peilin.ye@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] udp: Refactor udp_read_skb()
Message-ID: <20220921010523.GA2835@bytedance>
References: <03db9765fe1ef0f61bfc87fc68b5a95b4126aa4e.1663143016.git.peilin.ye@bytedance.com>
 <20220920173859.6137f9e9@kernel.org>
 <20220920174052.47d9858b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220920174052.47d9858b@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 20, 2022 at 05:40:52PM -0700, Jakub Kicinski wrote:
> On Tue, 20 Sep 2022 17:38:59 -0700 Jakub Kicinski wrote:
> > On Wed, 14 Sep 2022 01:15:30 -0700 Peilin Ye wrote:
> > > Delete the unnecessary while loop in udp_read_skb() for readability.
> > > Additionally, since recv_actor() cannot return a value greater than
> > > skb->len (see sk_psock_verdict_recv()), remove the redundant check.  
> > 
> > These don't apply cleanly, please rebase?
> 
> Ah, it's the WARN_ON_ONCE() change. In that case please resend after
> net is merged into net-next (Thu evening).

Sure, but only the TCP part was merged [1] into net.  I just sent the
UDP part again [2], and will resend this patchset after both [1] and [2]
are merged into net-next.  Thanks!

[1] https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=96628951869c0dedf0377adca01c8675172d8639
[2] https://lore.kernel.org/netdev/20220921005915.2697-1-yepeilin.cs@gmail.com/T/#u

Peilin Ye

