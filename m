Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 509AB5E952E
	for <lists+netdev@lfdr.de>; Sun, 25 Sep 2022 20:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbiIYSA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Sep 2022 14:00:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbiIYSAz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Sep 2022 14:00:55 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0869228E03
        for <netdev@vger.kernel.org>; Sun, 25 Sep 2022 11:00:52 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id b23so2916522qtr.13
        for <netdev@vger.kernel.org>; Sun, 25 Sep 2022 11:00:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=fGDn3BI5Hyr1B+bUIhvFjBHplPvBna8WRR86g1UyjRY=;
        b=niGIyPKvgAeB8xDNBCg5zjgnyc+vz8PgvoOpRafe7pXn2TwYkFQ//7ef55sFIQmSlz
         kaB+Lq39f1DApNBRFJBSaW6IKsyJviKxsUkTVRHpO4D1uzlAVyqlS7E/N3TO3DHv/5g5
         d/hQUwLnLtB+EixDDCilE45e1hmbmHYgEL1DtPaO7hX3OcyaT8D+dS9aeyqdNtJiOXsu
         n+DH2lssjFQp5nExwlyAXK4fKxZ6xQZi51nR5ftkJBw49mv9tJN4EBvACp3V+a2elAfa
         wBHVG8H8P/lryxD0EQz2MSR3eSt50R+leExSWe+xx5AsftqgkKUESsgYT2SGzzZ7e04j
         9pQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=fGDn3BI5Hyr1B+bUIhvFjBHplPvBna8WRR86g1UyjRY=;
        b=GINn0Uk/PRVUfKpVGChCgG3TAftv8rMxsMNsMDEJtIJ3mLhg61QXYcw0OGuW01L3e4
         Mf1EDG/Wci2ik5UrZVPIVBWi0p4+iTeGsA4yL+qvlafm261/sTkC37iWpHnRBQEBFLj7
         jbwRKvLgscPxwV1KDIG+TcttZ1nSZT0Ubh1yzLkmWFYy9B7SGH20jsZox6FQRFwzAYlm
         lub2dm4qLosRBY9bGnyUX/Z7GcwG9Y/F0b4S7th5AJxCUy8LS8qI8izKdNhJb1cn5gZv
         +8J0MDK9ygNg1xpHoMyO4ybHMzoZMoXpGcoHHNAIvB735STEPZWe+5uVP+QLYEgvN7u8
         B4eg==
X-Gm-Message-State: ACrzQf1UIbznmDm3Ycj7ypIK/Ou3vjH1wyXYaAyatEe+zZkuqCmfUOT+
        0C/2TXUkmg0pvpf0fsYT5LUQDnRcBt8=
X-Google-Smtp-Source: AMsMyM6XR+95BWpctHV59PhTYqqGmkgFLAaaF22lINzSNbWGHAy3BjM0mFu4tHrajXwCWBfyOJ5ORQ==
X-Received: by 2002:ac8:7dc4:0:b0:35c:c9b1:9f7e with SMTP id c4-20020ac87dc4000000b0035cc9b19f7emr15309469qte.661.1664128851129;
        Sun, 25 Sep 2022 11:00:51 -0700 (PDT)
Received: from localhost ([2600:1700:65a0:ab60:9061:9095:558c:ce69])
        by smtp.gmail.com with ESMTPSA id d21-20020ac86155000000b0035cebb79aaesm9613245qtm.18.2022.09.25.11.00.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Sep 2022 11:00:50 -0700 (PDT)
Date:   Sun, 25 Sep 2022 11:00:48 -0700
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     Paul Blakey <paulb@nvidia.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Vlad Buslov <vladbu@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net v2 1/2] net: Fix return value of qdisc ingress
 handling on success
Message-ID: <YzCXUN6bKSb762Pn@pop-os.localdomain>
References: <1664093662-32069-1-git-send-email-paulb@nvidia.com>
 <1664093662-32069-2-git-send-email-paulb@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1664093662-32069-2-git-send-email-paulb@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 25, 2022 at 11:14:21AM +0300, Paul Blakey wrote:
> Currently qdisc ingress handling (sch_handle_ingress()) doesn't
> set a return value and it is left to the old return value of
> the caller (__netif_receive_skb_core()) which is RX drop, so if
> the packet is consumed, caller will stop and return this value
> as if the packet was dropped.
> 
> This causes a problem in the kernel tcp stack when having a
> egress tc rule forwarding to a ingress tc rule.
> The tcp stack sending packets on the device having the egress rule
> will see the packets as not successfully transmitted (although they
> actually were), will not advance it's internal state of sent data,
> and packets returning on such tcp stream will be dropped by the tcp
> stack with reason ack-of-unsent-data. See reproduction in [0] below.
> 

Hm, but how is this return value propagated to egress? I checked
tcf_mirred_act() code, but don't see how it is even used there.

318         err = tcf_mirred_forward(want_ingress, skb2);
319         if (err) {
320 out:
321                 tcf_action_inc_overlimit_qstats(&m->common);
322                 if (tcf_mirred_is_act_redirect(m_eaction))
323                         retval = TC_ACT_SHOT;
324         }
325         __this_cpu_dec(mirred_rec_level);
326
327         return retval;


What am I missing?

Also, the offending commit is very old and this configuration is not
uncommon at all, how could we even not notice this for such a long time?

Thanks.
