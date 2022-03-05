Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B39D14CE1B1
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 01:41:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230296AbiCEAm3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 19:42:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbiCEAm3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 19:42:29 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3944D15C191;
        Fri,  4 Mar 2022 16:41:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 62748CE2F37;
        Sat,  5 Mar 2022 00:41:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F927C340EF;
        Sat,  5 Mar 2022 00:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646440896;
        bh=XnyKpVbqFye4ROXP1rvn2MXKkQjlnGcCb7ljnwSBAsY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=jRgyicmmLZmddgtoXbicy9Nn759yWEAYHm4luZQFaksvkp5g0rLoxzO6a1qJvQ9Tw
         DfcT6+uDpb+xjgjrWxWY88iUgMobvbpk2zMxDKftNsu8DrHjYn2TKQBTRuI4pcpqUY
         Wz8zlW+zEjnsEt3gFCIlmoDR9fgW5R+QcOEjQnts7n7AJZHtUKG71+Ayqmkhfs34dR
         g+xdXHeoKALUY3L/fXtMPROl5IB8lrqH/RH04XgFcqCHYzRuKASZBujTvnpOnunWqv
         7Hiqwnw7p4NbvhxdB8ZwBXIkhsPrQcR5d2zS0rVq200ugJrxidBxreo1YCNCZA/eYg
         1biFWyp7LOzYw==
Received: by mail-yb1-f181.google.com with SMTP id f38so20116762ybi.3;
        Fri, 04 Mar 2022 16:41:36 -0800 (PST)
X-Gm-Message-State: AOAM533kfmvKF4wO6pMLpl2dzoBQGEpnFoPSGISDZGdYwWcR9HtnOybb
        0SVNTH/PLZ/c0K7d1mnDOdfD/PkbDU0BAvTG3xs=
X-Google-Smtp-Source: ABdhPJyWdz6gBQAx8B/98c8TW3aIPYiu+3hQvOx+it/kv+3mZhkHdigjO8Z10pH+efqGZFkRNuF9Okg/UNkLKvUEkLM=
X-Received: by 2002:a25:8546:0:b0:61e:1d34:ec71 with SMTP id
 f6-20020a258546000000b0061e1d34ec71mr917915ybn.259.1646440895532; Fri, 04 Mar
 2022 16:41:35 -0800 (PST)
MIME-Version: 1.0
References: <20220304172852.274126-1-benjamin.tissoires@redhat.com> <20220304172852.274126-6-benjamin.tissoires@redhat.com>
In-Reply-To: <20220304172852.274126-6-benjamin.tissoires@redhat.com>
From:   Song Liu <song@kernel.org>
Date:   Fri, 4 Mar 2022 16:41:24 -0800
X-Gmail-Original-Message-ID: <CAPhsuW63HQE_GWFrz-t9_Uyq3KK3raYeG_x7OYMGR02DHzQ1=g@mail.gmail.com>
Message-ID: <CAPhsuW63HQE_GWFrz-t9_Uyq3KK3raYeG_x7OYMGR02DHzQ1=g@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 05/28] selftests/bpf: add tests for the
 HID-bpf initial implementation
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>,
        Tero Kristo <tero.kristo@linux.intel.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 4, 2022 at 9:31 AM Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
>
> The test is pretty basic:
> - create a virtual uhid device that no userspace will like (to not mess
>   up the running system)
> - attach a BPF prog to it
> - open the matching hidraw node
> - inject one event and check:
>   * that the BPF program can do something on the event stream
>   * can modify the event stream
>
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
>

Does this test run with vm (qemu, etc.)? Maybe we need to update
tools/testing/selftests/bpf/config ?

Thanks,
Song
