Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B56F6AC36E
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 15:36:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230373AbjCFOgo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 09:36:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230088AbjCFOgm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 09:36:42 -0500
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 531A12331C;
        Mon,  6 Mar 2023 06:36:14 -0800 (PST)
Received: by mail-qt1-x830.google.com with SMTP id l13so10672083qtv.3;
        Mon, 06 Mar 2023 06:36:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678113323;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yDK95qUmtK7rh4BRcl+d6FS8ceWw89ds2nqEahTwuz0=;
        b=UxOtsg7RxUDG4Xjoo+aHR/G2P6QbDE51VloPKiDakUKx8jC2b+3P7Of6qjanYrsZIG
         RlaHNFQNDmSSEdWjyF479uEEbwsmwH+ct4w0L/JdPkfazg+bpzGI+jd19Y3mqp29Tj2l
         +ZzPJTXy6cXhzIajxllL0ef38Bno0pK+AW5h0ZBPmllMTLKQulu12v/tN5l5ezkJBT42
         3/+FKfgJHbMB4ptKkBo+qQ+treW6IZuQohQYKWF5N1aaLFBCJrKtPY9WKY9Ne3gENFYp
         Bta53p17MHw/P2dAD0JwFUu5Ip3PUEcZySM9P0yce8j/QNZMMXZIA2DnOe0W/GrQMlmn
         JyaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678113323;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=yDK95qUmtK7rh4BRcl+d6FS8ceWw89ds2nqEahTwuz0=;
        b=gBtiFx0tYPI3oLwN23lNxn7xSR3nF13kSd8319HacXouVY8adqQxY9WYat8/eIe9Sc
         +4Jjwg3UJv2lyjljmTDkvR65OMXqGxb568rKDQQiNUtlwPK7JoeoaKaqWC3nFgtUUuNr
         K2nCe7SWZ2R8TYKcKILjMiaQD8mWu2f42IZcUmJeC4NHZG1M7UpcuUd4R2Ujw1RAFJA4
         0us1t5gOWZ3vgR3MX8pq4FdmbTD0f3pItlFvbupKATF8bPBCI/NCq6Za92w4o3isowdK
         TyRJNHJNwYQTpFDJTve08KJ/qRXqgsmLl89ajzljuktk8I3UYXyj9PcWUXDlW1SLL5jb
         +zCw==
X-Gm-Message-State: AO0yUKUdaVII2auXkogO+HHghYpf7QloxO5Pu0BR/IHg3r+ptCsWwT3u
        57ht+Y6W84/kRj6lRCfjRmU=
X-Google-Smtp-Source: AK7set+n57WUuNR+qYBo3bFZ13IGkIiD5yt+MG1lXujWHqHI8rUS/QMChjkzpn2uvAv1TLOhSXWfLA==
X-Received: by 2002:ac8:5c02:0:b0:3bf:dc2e:ce5d with SMTP id i2-20020ac85c02000000b003bfdc2ece5dmr20367194qti.4.1678113323074;
        Mon, 06 Mar 2023 06:35:23 -0800 (PST)
Received: from localhost (240.157.150.34.bc.googleusercontent.com. [34.150.157.240])
        by smtp.gmail.com with ESMTPSA id 191-20020a370cc8000000b007416c11ea03sm7606527qkm.26.2023.03.06.06.35.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Mar 2023 06:35:22 -0800 (PST)
Date:   Mon, 06 Mar 2023 09:35:22 -0500
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     xu xin <xu.xin.sc@gmail.com>, willemdebruijn.kernel@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, jiang.xuexin@zte.com.cn,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, shuah@kernel.org, xu.xin16@zte.com.cn,
        yang.yang29@zte.com.cn, zhang.yunkai@zte.com.cn
Message-ID: <6405fa2a80577_bb2242089c@willemb.c.googlers.com.notmuch>
In-Reply-To: <20230306073136.155697-1-xu.xin16@zte.com.cn>
References: <6401f7889e959_3f6dc82084b@willemb.c.googlers.com.notmuch>
 <20230306073136.155697-1-xu.xin16@zte.com.cn>
Subject: RE: [PATCH linux-next v2] selftests: net: udpgso_bench_tx: Add test
 for IP fragmentation of UDP packets
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

xu xin wrote:
> >> >     IP_PMTUDISC_DONT: turn off pmtu detection.
> >> >     IP_PMTUDISC_OMIT: the same as DONT, but in some scenarios, DF will
> >> > be ignored. I did not construct such a scene, presumably when forwarding.
> >> > Any way, in this test, is the same as DONT.
> >
> >My points was not to compare IP_PMTUDISC_OMIT to .._DONT but to .._DO,
> >which is what the existing UDP GSO test is setting.
> 
> Yeah, we got your point, but the result was as the patch showed, which hadn't
> changed much (patch v2 V.S patch v1), because the fragmentation option of 'patch v1'
> used the default PMTU discovery strategy(IP_PMTUDISC_DONT, because the code didn't
> setting PMTU explicitly by setsockopt() when use './udpgso_bench_tx -f' ), which is
> not much different from the 'patch v2' using IP_PMTUDISC_OMIT.

Or IP_PMTUDISC_WANT unless sysctl_ip_no_pmtu_disc is set.
But fair point. Explicitly disabling pmtu is not needed.
 
> >
> >USO should generate segments that meet MTU rules. The test forces
> >the DF bit (IP_PMTUDISC_DO).
> >
> >UFO instead requires local fragmentation, must enter the path for this
> >in ip_output.c. It should fail if IP_PMTUDISC_DO is set:
> >
> >        /* Unless user demanded real pmtu discovery (IP_PMTUDISC_DO), we allow
> >         * to fragment the frame generated here. No matter, what transforms
> >         * how transforms change size of the packet, it will come out.
> >         */
> >        skb->ignore_df = ip_sk_ignore_df(sk);
> >
> >        /* DF bit is set when we want to see DF on outgoing frames.
> >         * If ignore_df is set too, we still allow to fragment this frame
> >         * locally. */
> >        if (inet->pmtudisc == IP_PMTUDISC_DO ||
> >            inet->pmtudisc == IP_PMTUDISC_PROBE ||
> >            (skb->len <= dst_mtu(&rt->dst) &&
> >             ip_dont_fragment(sk, &rt->dst)))
> >                df = htons(IP_DF);
> > 
> >> >
> >> > We have a question, what is the point of this test if it is not compared to
> >> > UDP GSO and IP fragmentation. No user or tool will segment in user mode,
> >
> >Are you saying no process will use UDP_SEGMENT?
> >
> No, we are saying "user-space payload splitting", in other words, use ./udpgso_bench_tx
> without '-f' or '-S'.

I see. I guess you heard the arguments why the test does not compare
udp segmentation with udp fragmentation:

- fragmentation is particularly expensive on the receiver side
- fragmentation cannot be offloaded, while segmentation can

> Sincerely.
> 
> >The local protocol stack removed UFO in series d9d30adf5677.
> >USO can be offloaded to hardware by quite a few devices (NETIF_F_GSO_UDP_L4).
> >> > UDP GSO should compare performance with IP fragmentation.
> >> 
> >> I think it is misleading to think the cost of IP fragmentation matters


