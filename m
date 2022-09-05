Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFCA25AD8A1
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 19:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbiIERzb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 13:55:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbiIERz3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 13:55:29 -0400
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DFFE2314C
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 10:55:29 -0700 (PDT)
Received: by mail-qv1-xf34.google.com with SMTP id ml1so568012qvb.1
        for <netdev@vger.kernel.org>; Mon, 05 Sep 2022 10:55:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date;
        bh=s6hlzMGTArxPFymhxyQ9FCJ0IJYcWQ/ZQB5ZJuHOT10=;
        b=fudZ5LGZO5jt56hdlPe9EWREsL40JaGCBtiNKipF5EN4uELZccxjd/g74D4C+NYBPP
         VQaFc8DLD55BZLh5kXswZC7r7t3l4WnkTHR3LXfFippj4iac7RERAytN5fXVvdsy05U6
         GR6Xv8tP2F6EauglAz2bPZcb5Z8l621emNqtAvsIRYEQ0MqnUVqdkoNCM2zOJjjwOcEc
         1P4k0eB5oF3T63gHmoOFs0cnbmQsxjuGN/HYXX4txYQL7St1udrSAyTlR17PhyXjkJp8
         lRCxN9RCgXgD3BBRPO1XMInnyGex6/i5tICdIAB2bhOmfs44tYsE74cbgiMQe9TC2VfA
         /o/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date;
        bh=s6hlzMGTArxPFymhxyQ9FCJ0IJYcWQ/ZQB5ZJuHOT10=;
        b=1Hyq6fuTbtNq6agWVoi/J362+1QQpU0anzjBwgVBx9zOQPeqC/ERHUUDlw6+NFJomQ
         pCz3f2D37nNKmK9y3mL2avajO8BzCN5qEgakZ45RlBdAiFAGppGsRtVqIo8LU6tlp10M
         WtbCEwo7yATfFpjL1csAc6rhbNYHQEQfgScAC+LMUvwr+cz+4zgaCUNATRc6i3aB87a8
         F226tCmXOdbabCb9QhuPfTU335BC7upEKHgfH5eRjzXH56pesZ1iaVRvkdOdyVMZE3QU
         ViK6ZxUHdoq/UEYL+iwWuSjat02Peckxh0z4vlLCtKqf4cQtpzT/3xHe+J4zqG6/r1iy
         zc0Q==
X-Gm-Message-State: ACgBeo3yrhiPBzZa2I0OIGqGa3gBChTH74uLejlgFxP63lUTj3Gp8knG
        qzYlomz3h//RHsSC4qQ9Lg9PoMsGaOM=
X-Google-Smtp-Source: AA6agR6gc9A5bdigmCYaXS67Rxi1VIV3uVnOG8/fnnckg75J8tMwsKw9AhmGC6QRGTTJy1AUt+7YzQ==
X-Received: by 2002:a0c:b31a:0:b0:473:8062:b1b4 with SMTP id s26-20020a0cb31a000000b004738062b1b4mr41856367qve.85.1662400528200;
        Mon, 05 Sep 2022 10:55:28 -0700 (PDT)
Received: from localhost ([2600:1700:65a0:ab60:53d7:9fdb:135e:210a])
        by smtp.gmail.com with ESMTPSA id 192-20020a3708c9000000b006b60d5a7205sm8518567qki.51.2022.09.05.10.55.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Sep 2022 10:55:27 -0700 (PDT)
Date:   Mon, 5 Sep 2022 10:55:25 -0700
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        zdi-disclosures@trendmicro.com, Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net v2] sch_sfb: Don't assume the skb is still around
 after enqueueing to child
Message-ID: <YxY4DR8hoMUDgpxu@pop-os.localdomain>
References: <20220831092103.442868-1-toke@toke.dk>
 <20220831215219.499563-1-toke@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220831215219.499563-1-toke@toke.dk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 31, 2022 at 11:52:18PM +0200, Toke Høiland-Jørgensen wrote:
> The sch_sfb enqueue() routine assumes the skb is still alive after it has
> been enqueued into a child qdisc, using the data in the skb cb field in the
> increment_qlen() routine after enqueue. However, the skb may in fact have
> been freed, causing a use-after-free in this case. In particular, this
> happens if sch_cake is used as a child of sfb, and the GSO splitting mode
> of CAKE is enabled (in which case the skb will be split into segments and
> the original skb freed).
> 
> Fix this by copying the sfb cb data to the stack before enqueueing the skb,
> and using this stack copy in increment_qlen() instead of the skb pointer
> itself.
> 

I am not sure if I understand this correctly, but clearly there is
another use of skb right before increment_qlen()... See line 406 below:

402 enqueue:
403         memcpy(&cb, sfb_skb_cb(skb), sizeof(cb));
404         ret = qdisc_enqueue(skb, child, to_free);
405         if (likely(ret == NET_XMIT_SUCCESS)) {
406                 qdisc_qstats_backlog_inc(sch, skb);  // <== HERE
407                 sch->q.qlen++;
408                 increment_qlen(&cb, q);

It also uses skb->cb actually... You probably want to save qdisc_pkt_len(skb)
too.

Thanks.
