Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0BD062A16E
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 19:38:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231297AbiKOSiO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 13:38:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230449AbiKOSiG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 13:38:06 -0500
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 702FC2FFD7
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 10:38:03 -0800 (PST)
Received: by mail-ot1-x32e.google.com with SMTP id db10-20020a0568306b0a00b0066d43e80118so8867440otb.1
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 10:38:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9+VdkugDTO7BCZkCTE9pFpR9a05B5UZh6ZZa6FBhM2k=;
        b=l4KnKYj5JF2WH2hBfbspNe+5SW4ET3v180caFh2zKX05ZHTiI3wyhTH9sBXeDMJFCk
         hpQPmXu1xLfTAGXc1ue92syyloJdffWPa3XcF8WYZ69T6tAhMvyOI/j0gP1u7KNjN5oo
         FrfldtLPrOaaT5kvleK+20sYKQJb3rXr9CvcD0mX0VunevEQ74NBnRgBR8UaWF+ugCow
         smFSQtCt2Po95IS0tgSdyotAnxcSclp5Fx7BnGByuZW64X4SS0z90hgpEdF1ZMVrMaXh
         i5N4ZgCBVCo8p/25Mgv70XoKmsEXZJTYTJ/FRUJfUwG355YWmdLytDiKOKzFa9jbF7Io
         IcIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9+VdkugDTO7BCZkCTE9pFpR9a05B5UZh6ZZa6FBhM2k=;
        b=pEr7h6B0Chd8ZLZkZ1ivzMgAFjlT9d07JctssGxtsYySOO0c6uvo/gG/nESh4RCpRI
         NQv1ASZjq842tcGyc+anmsTmET5HFIhyli0W7YV+lRrnh+F38f4WtqKyBrG9nnazGamm
         yhAZsehfUmx066YWQLdmjEufQ+HdncDavP2fepzzxFXgig2Dar1MTi73B+lXAeJ59dM0
         3Zw1a+5OabNMVkukGgMDRmnTaz/4rO0bSN3eE6am1KTCYr4F3SFqJ9CSzC2rqOAqxaTV
         V1VNzdhdKgycxZlYtNKP2560EOb514ys/GV16yf9WuvTuirXwc1bBOq3wJNrUeb+j1mQ
         62AQ==
X-Gm-Message-State: ANoB5pm2wpx8NEuO/weE0r1QZABz5B94NNHhxBbq6iDQYlS43vPGoSnV
        xkI5SksFNlzD/CfSOMXq7aGrEoUzcHYCoNIRXx5UWQ==
X-Google-Smtp-Source: AA0mqf7uy61XIH5ek2si94nsVcYZV0O/Cv5AoaYbVCmqlSUGBSYsjU+fl3rqjpjuomfhfS9srtXa3/W9v62fUrIoGcs=
X-Received: by 2002:a9d:4f06:0:b0:66c:794e:f8c6 with SMTP id
 d6-20020a9d4f06000000b0066c794ef8c6mr9438397otl.343.1668537482593; Tue, 15
 Nov 2022 10:38:02 -0800 (PST)
MIME-Version: 1.0
References: <20221115030210.3159213-1-sdf@google.com> <87mt8si56i.fsf@toke.dk>
In-Reply-To: <87mt8si56i.fsf@toke.dk>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Tue, 15 Nov 2022 10:37:51 -0800
Message-ID: <CAKH8qBszV6Ni_k8JYOxtAQ2j79qe5KVryAzDqtb1Ng8+TW=+7A@mail.gmail.com>
Subject: Re: [xdp-hints] [PATCH bpf-next 00/11] xdp: hints via kfuncs
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 15, 2022 at 7:54 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Stanislav Fomichev <sdf@google.com> writes:
>
> > - drop __randomize_layout
> >
> >   Not sure it's possible to sanely expose it via UAPI. Because every
> >   .o potentially gets its own randomized layout, test_progs
> >   refuses to link.
>
> So this won't work if the struct is in a kernel-supplied UAPI header
> (which would include the __randomize_layout tag). But if it's *not* in a
> UAPI header it should still be included in a stable form (i.e., without
> the randomize tag) in vmlinux.h, right? Which would be the point:
> consumers would be forced to read it from there and do CO-RE on it...

So you're suggesting something like the following in the uapi header?

#ifndef __KERNEL__
#define __randomize_layout
#endif

?

Let me try to add some padding arguments to xdp_skb_metadata plus the
above to see how it goes.
