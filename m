Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AC966AB71B
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 08:31:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbjCFHbq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 02:31:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbjCFHbo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 02:31:44 -0500
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4366B1E1F6;
        Sun,  5 Mar 2023 23:31:41 -0800 (PST)
Received: by mail-pj1-x1043.google.com with SMTP id kb15so8881335pjb.1;
        Sun, 05 Mar 2023 23:31:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cEeWSamPP//pxy4lKPrymNEPE0BRaQvyhxLQGg4BK5U=;
        b=M/9ysp0aPgRd5Hv7DtjFq2u/tYGPIqFtie6zb+B5GsgkpE60amgnHgcn1YbCBs1bDE
         ft930AYKVL1xBSUEkIAP/FiQxJiawMuQRSd4RFQhn38YQ1AnEW2xcceLkHjrvmLBM2zw
         pCMMd2tRxI0e9tgkC28oNUU42o9BmTRanuyiQdq50wuKfg4PJ9iWwK7f53+eeqr2rz1P
         8Lj1xkOdp7gs8NmfbhIEXLopt2nId2/zBEiNfnfaLZ5ws4hmNCW5hBq/SXXi4CdHMui5
         MpNQBLTEyZ1a83VGF7/ih2mDAQhwSkrV4FwJ4J9iToExpJs+whCfowAatqV4pXwuk43X
         ixxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cEeWSamPP//pxy4lKPrymNEPE0BRaQvyhxLQGg4BK5U=;
        b=v1c2t50WlY4n2n57O2MwvHc53K3brMAb0SVN8WveZwjAIc6rtVGrglChJ40vNCRuPR
         zaJEieoS8KLkKe5FJCQGm5mojR3TI+k3R48dc1fvMOsU4dqS23adfnH0t0rtl2jKhXVn
         3KpUB2LEhplvtsHApciRbt9WNx4Vd5u4+yijMGAelkmkDhTtT58Z54Kjt1QT6xJpzN77
         cCwMW++sOqtE/aAuOjYKpxD+wkQaruwE/eaGcgbs/49gAh5UkCaZsTQ/pvh8O1NfyZlw
         DI8sN2jz+oNIAjZm71yAI8ucrBy7FAUi8u1aig6sQjddauTLrKE7AHINU5T4oACnHfXZ
         Hhrw==
X-Gm-Message-State: AO0yUKVeW+CLTaKmjfE2oREf2hDvGB6mQwniw/OV0uDo39nUa8Erodjj
        g7+7uXeWjkRE1KiqoCtw9mg=
X-Google-Smtp-Source: AK7set8njaPB/Dn186/pV5Shti/LPXxBpbHPjFtyC7LUjTP4mz8XnBpyH1kO30LqkNJnQG0TxzLD7Q==
X-Received: by 2002:a17:902:c951:b0:19e:9807:de48 with SMTP id i17-20020a170902c95100b0019e9807de48mr10403129pla.23.1678087900742;
        Sun, 05 Mar 2023 23:31:40 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id 4-20020a170902e9c400b0019c61616f82sm5930857plk.230.2023.03.05.23.31.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Mar 2023 23:31:40 -0800 (PST)
From:   xu xin <xu.xin.sc@gmail.com>
X-Google-Original-From: xu xin <xu.xin16@zte.com.cn>
To:     willemdebruijn.kernel@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, jiang.xuexin@zte.com.cn,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, shuah@kernel.org, xu.xin16@zte.com.cn,
        yang.yang29@zte.com.cn, zhang.yunkai@zte.com.cn
Subject: RE: [PATCH linux-next v2] selftests: net: udpgso_bench_tx: Add test for IP fragmentation of UDP packets
Date:   Mon,  6 Mar 2023 07:31:36 +0000
Message-Id: <20230306073136.155697-1-xu.xin16@zte.com.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <6401f7889e959_3f6dc82084b@willemb.c.googlers.com.notmuch>
References: <6401f7889e959_3f6dc82084b@willemb.c.googlers.com.notmuch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> >     IP_PMTUDISC_DONT: turn off pmtu detection.
>> >     IP_PMTUDISC_OMIT: the same as DONT, but in some scenarios, DF will
>> > be ignored. I did not construct such a scene, presumably when forwarding.
>> > Any way, in this test, is the same as DONT.
>
>My points was not to compare IP_PMTUDISC_OMIT to .._DONT but to .._DO,
>which is what the existing UDP GSO test is setting.

Yeah, we got your point, but the result was as the patch showed, which hadn't
changed much (patch v2 V.S patch v1), because the fragmentation option of 'patch v1'
used the default PMTU discovery strategy(IP_PMTUDISC_DONT, because the code didn't
setting PMTU explicitly by setsockopt() when use './udpgso_bench_tx -f' ), which is
not much different from the 'patch v2' using IP_PMTUDISC_OMIT.

>
>USO should generate segments that meet MTU rules. The test forces
>the DF bit (IP_PMTUDISC_DO).
>
>UFO instead requires local fragmentation, must enter the path for this
>in ip_output.c. It should fail if IP_PMTUDISC_DO is set:
>
>        /* Unless user demanded real pmtu discovery (IP_PMTUDISC_DO), we allow
>         * to fragment the frame generated here. No matter, what transforms
>         * how transforms change size of the packet, it will come out.
>         */
>        skb->ignore_df = ip_sk_ignore_df(sk);
>
>        /* DF bit is set when we want to see DF on outgoing frames.
>         * If ignore_df is set too, we still allow to fragment this frame
>         * locally. */
>        if (inet->pmtudisc == IP_PMTUDISC_DO ||
>            inet->pmtudisc == IP_PMTUDISC_PROBE ||
>            (skb->len <= dst_mtu(&rt->dst) &&
>             ip_dont_fragment(sk, &rt->dst)))
>                df = htons(IP_DF);
> 
>> >
>> > We have a question, what is the point of this test if it is not compared to
>> > UDP GSO and IP fragmentation. No user or tool will segment in user mode,
>
>Are you saying no process will use UDP_SEGMENT?
>
No, we are saying "user-space payload splitting", in other words, use ./udpgso_bench_tx
without '-f' or '-S'.

Sincerely.

>The local protocol stack removed UFO in series d9d30adf5677.
>USO can be offloaded to hardware by quite a few devices (NETIF_F_GSO_UDP_L4).
>> > UDP GSO should compare performance with IP fragmentation.
>> 
>> I think it is misleading to think the cost of IP fragmentation matters
