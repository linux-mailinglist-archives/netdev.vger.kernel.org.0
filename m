Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4030853E683
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 19:07:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241174AbiFFP5m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 11:57:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241168AbiFFP5k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 11:57:40 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CA724A3C1;
        Mon,  6 Jun 2022 08:57:38 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id h23so18738555ejj.12;
        Mon, 06 Jun 2022 08:57:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=71RW4NcxoOxxSyC8SlZA5/FRkyGZqu91M7XBBAasel4=;
        b=YlJUTaIes/Bt7GARzsgnQ4mjZxipb0yUy5nubEIknFaFld6Zu5ST9Rx3tiEWGs0FsV
         Xp3vjZkxVRPCVRf5SyKRUkSo60TQI/tkinNAAiAxPCTWtl5W/atNYTDcTFRjr5o0EcIs
         faI7kg1EZbD0nxhBTwDzzlG83H55AzR8Cc74/jLaeMdoSTt+ZiHUOwY0v7eIYHNffjk2
         I6FHn1Riqor61aU1N9rF2crwCdSDzTevoLyS6vQ1KWqL2jB3IM7ItexUMlpfUwC8be0Y
         uOfZV7lhb09KzEaxEDhFYlfY6lT+UPdAAql/09eVEWyKXWnj1TTePcT6/JRMZ+9aEsI/
         l1pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=71RW4NcxoOxxSyC8SlZA5/FRkyGZqu91M7XBBAasel4=;
        b=g3+GwSTr+vO+7Zvzu6TjzByasPrIrX9Na1a/ZiTk/q41bLaZxLmDvc8ivQxSlnC/XW
         TSJfZYyH3aVDSG8BxW/wOa8bLRvLtVp9ljPo2+QOQG2XGFIsJXbxfWev1PMJP0LDidVK
         8XMPesqlk7biWZ287SiROloJSvhfr5jVIhkrIA/ldrI+0JCMq0wr+L/UuaToTMSDzoou
         ZzMIY0qhx/RZRSFlx92lLG2EsYSIJSD27DJ6j1e+5+1N0Q88aQvN+ikzQWmPiskG2Fu+
         7rcbwLR9kyjBsnQMapwp7A0/MgbR6QiotOiJBN5SJCVUskwaqZMN8Vp+8R9c2nYshLBX
         LoIQ==
X-Gm-Message-State: AOAM531K3JchLtILPcniCJHrw7q3ofYKEZnwFUrbhXtAF0vyiU4xl6x2
        CH/Zu70Ikr8DB2Dz3yzl/cDtMzuspFinHbVbNeoTrm1RUX8=
X-Google-Smtp-Source: ABdhPJwpoEaXlJdxKjWf0crjE2aWqy0H64AhFRqcFW9mVhuWXkUdSmEsIpQphFus89SILKpBVjumDM7UdLsAVJJd7pw=
X-Received: by 2002:a17:907:72c1:b0:6ff:c5f:6b7d with SMTP id
 du1-20020a17090772c100b006ff0c5f6b7dmr22322792ejc.676.1654531056926; Mon, 06
 Jun 2022 08:57:36 -0700 (PDT)
MIME-Version: 1.0
References: <20220606103734.92423-1-kurt@linutronix.de>
In-Reply-To: <20220606103734.92423-1-kurt@linutronix.de>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 6 Jun 2022 08:57:25 -0700
Message-ID: <CAADnVQJ--oj+iZYXOwB1Rs9Qiy6Ph9HNha9pJyumVom0tiOFgg@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: Add BPF-helper for accessing CLOCK_TAI
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Joanne Koong <joannelkoong@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Geliang Tang <geliang.tang@suse.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 6, 2022 at 3:38 AM Kurt Kanzenbach <kurt@linutronix.de> wrote:
>
> From: Jesper Dangaard Brouer <brouer@redhat.com>
>
> Commit 3dc6ffae2da2 ("timekeeping: Introduce fast accessor to clock tai")
> introduced a fast and NMI-safe accessor for CLOCK_TAI. Especially in time
> sensitive networks (TSN), where all nodes are synchronized by Precision Time
> Protocol (PTP), it's helpful to have the possibility to generate timestamps
> based on CLOCK_TAI instead of CLOCK_MONOTONIC. With a BPF helper for TAI in
> place, it becomes very convenient to correlate activity across different
> machines in the network.

That's a fresh feature. It feels risky to bake it into uapi already.
imo it would be better to annotate tk_core variable in vmlinux BTF.
Then progs will be able to read all possible timekeeper offsets.
