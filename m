Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 368235E9444
	for <lists+netdev@lfdr.de>; Sun, 25 Sep 2022 18:15:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231258AbiIYQPA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Sep 2022 12:15:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiIYQO5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Sep 2022 12:14:57 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E241613DD8
        for <netdev@vger.kernel.org>; Sun, 25 Sep 2022 09:14:56 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id x23-20020a056830409700b00655c6dace73so3080659ott.11
        for <netdev@vger.kernel.org>; Sun, 25 Sep 2022 09:14:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=1+BfOKXcpoEaGQk95c12dhY+fN+OE2AYcMztraFwAsk=;
        b=wN5BooiQD42vU5abO3Jq07KAmsf1rSR14pJwwXBN1+rqeVXkc39LSPV1IoDASB+HG9
         0ScbzPo/v1IaxSlEdursT1K0f2gmE6WHmaakYwTm3K6iK2SG8bWzFSaYTVIAtJZrGuGZ
         xlCPh8ugqU7AdWT52/JTgWfbKjc1Tefn/a4rHdyz7lWpE0yF6XEnNyL3l82CeyDqZH5J
         dvUg8IHGVmKF4p+XS2JK3Bw0ZjuceM8e1MKBkavleTzKwLeCiNKz1Z9CbsTnhkVFm8tR
         5Xh/STAwQ4P7K5ZEUTWtL4tDlzVZaf/7BOSXSM5srPtDGxKg6jKmUsH3Mr5d53inXDXW
         xpjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=1+BfOKXcpoEaGQk95c12dhY+fN+OE2AYcMztraFwAsk=;
        b=NjWgc0yhemzyV5tAt45/hB6nCo8BH7o7cz6PlvnXmxLGKWoh7bq42wwWWTM1M4ESuU
         YM9D1cHc1/SRLini/t+uHsFypW+Nk45MXCIvqZWpcC3wSewZgOEVfIeGwd6yUFPET1Tn
         4SnlNNa/e/MAwf57sHKbSwyhrjP9lVgwjP+FkQOoy3/m2l8vhZ26oI1Pc90sR1BTew7u
         jaJif9M0nVzeELTpb4t1/PE0M+N3obq7Xy2v7xA6iPjY2tEDJubllZL6359s5puq9K8x
         8/+qsvRZGSmY6j6m2hM/pcpFvOkg/G6EZAyHhfSvwJohPs61cXHzC49JFbF4MYFfHeKS
         Bcdg==
X-Gm-Message-State: ACrzQf32v2pCoXlbxGK7hTklRy6M6ql25WeA7oiM0znIogl+LxQL7aDp
        d+xv0gSVOzrin0ZhP3cRQUla5h+LHtgSQJ8Wt2OFHw==
X-Google-Smtp-Source: AMsMyM4JiYaM8vkxKO5IiUPaGDs7yAidHhRSb1/KaBQm+MEZzI7BKYMfUM0mllxN+l+FRkilCa3wfCqQlqkcuqHjPTU=
X-Received: by 2002:a9d:2a7:0:b0:65a:c6a3:1d0e with SMTP id
 36-20020a9d02a7000000b0065ac6a31d0emr8377812otl.223.1664122496283; Sun, 25
 Sep 2022 09:14:56 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000a96c0b05e97f0444@google.com> <CAM0EoMnJ=STtk5BnZ9oJtnkXY2Q+Px2cKa4gowFRGpp40UNKww@mail.gmail.com>
In-Reply-To: <CAM0EoMnJ=STtk5BnZ9oJtnkXY2Q+Px2cKa4gowFRGpp40UNKww@mail.gmail.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Sun, 25 Sep 2022 12:14:44 -0400
Message-ID: <CAM0EoMm9uBQQepMb5bda1vR-Okw-tPp2nnf6TvfA0FzPu_D_2A@mail.gmail.com>
Subject: Re: [syzbot] WARNING in u32_change
To:     syzbot <syzbot+a2c4601efc75848ba321@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, jiri@resnulli.us,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com, xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SORTED_RECIPS,SPF_HELO_NONE,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 25, 2022 at 11:38 AM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>
> Is there a way to tell the boat "looking into it?"


I guess I have to swim across to it to get the message;->

I couldnt see the warning message  but it is obvious by inspection that
the memcpy is broken. We should add more test coverage.
This should fix it. Will send a formal patch later:

diff --git a/net/sched/cls_u32.c b/net/sched/cls_u32.c
index 4d27300c2..591cbbf27 100644
--- a/net/sched/cls_u32.c
+++ b/net/sched/cls_u32.c
@@ -1019,7 +1019,7 @@ static int u32_change(struct net *net, struct
sk_buff *in_skb,
        }

        s = nla_data(tb[TCA_U32_SEL]);
-       sel_size = struct_size(s, keys, s->nkeys);
+       sel_size = struct_size(s, keys, s->nkeys) + sizeof(n->sel);
        if (nla_len(tb[TCA_U32_SEL]) < sel_size) {
                err = -EINVAL;
                goto erridr;
