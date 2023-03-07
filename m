Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42C5C6AD49F
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 03:25:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbjCGCZJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 21:25:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjCGCZI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 21:25:08 -0500
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75B132FCC3
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 18:24:58 -0800 (PST)
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com [209.85.210.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id C1D703F592
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 02:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1678155896;
        bh=YLunr5J1c1bIAsAVRp+OmMD+b/lWN8gWAq4G89jVn0A=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=VHjTCScvqE49wejrMD3nheUqIMta/3CKw7ZqLuUX/D13g0itrLoHmi2IxZeFXcblF
         OC2CYtBigV5PD4+fUQAlqhuf4BQX6jQFbAxBk6ue7Lqk7n9Bb/d1X7POKM8Z+f66Zf
         w6cEhIY2zAOLtAJ6xcJME0I+sqQw46X4KIEydoC9eTlm2UJTKcMU2Xa7pDqo4vZRjc
         uwlZrlMnswMAgR1ujtgOR9uwARtv/xJR5hHDZvvLiCwc6eSj1coecGi6yO/B3TFZ5E
         RAr8vAELOCeZN1pXOEWPB8ccGFleGR03ARNHPpK+bCxA6hMJgr/Z5BbL0ZWN+9A69g
         IdBZdI6i42F7g==
Received: by mail-ot1-f69.google.com with SMTP id w18-20020a056830111200b00694476cc441so5164241otq.8
        for <netdev@vger.kernel.org>; Mon, 06 Mar 2023 18:24:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678155895;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YLunr5J1c1bIAsAVRp+OmMD+b/lWN8gWAq4G89jVn0A=;
        b=kXkDjVqLJM9l9yS+BoFoNfr2AHSmJSq2yUwMRLH7DxlgOsxP2vRUes4CXiBxIfX8ly
         7rApSYGcp9Fec1p5Xfieu7E/QYvhZWMOeZUeIwZhsWJAzOqJ50o6TrxC6eydJzrygpVp
         Q2SFTi1oH+2ie1p31zmYrkVTHcUA6fNndEDSwj8u519rdLPnlISOoPp+fsXsFpvufZC9
         YsS5+/k4zur/PWYem7z2lVdJhjPiCh3QnK+gkDhr7cAUsMv9StXE/MhfuV6YCeNeeQFZ
         tvwmjCHrzpT64d+QaQkGxEz9gvhW/1iQFZX3Koh2XUsCOtBfek6MGcmEC852QGKICBAT
         1IoQ==
X-Gm-Message-State: AO0yUKWgPU20b1bTYmtJnPRo1BCLofIZOl5eGyYbeSX6HdpNwU1JvV+T
        xI5NlAGP6DNMwWq+01Blk3JW3XUXuX7I3zeHSr4qNyuKrGXccq4s8zdGJAg5489uRFALqW2xTI1
        4YuO4Kxiqef7fK31XD0n5YxlSHmvi48Ke2fTljT4NheweadBA
X-Received: by 2002:a05:6870:7703:b0:176:6a34:52a3 with SMTP id dw3-20020a056870770300b001766a3452a3mr4458216oab.1.1678155895651;
        Mon, 06 Mar 2023 18:24:55 -0800 (PST)
X-Google-Smtp-Source: AK7set8dNGzH+2+FXQMV7z43aszo63H5jBjXcdILWUXcwc3QbZH6PYy4VQmDlL7eSfcZAOgNG5EsmD02ZM2ApU6hYsA=
X-Received: by 2002:a05:6870:7703:b0:176:6a34:52a3 with SMTP id
 dw3-20020a056870770300b001766a3452a3mr4458205oab.1.1678155895347; Mon, 06 Mar
 2023 18:24:55 -0800 (PST)
MIME-Version: 1.0
References: <20230306111959.429680-1-po-hsu.lin@canonical.com> <20230306103316.3224383e@kernel.org>
In-Reply-To: <20230306103316.3224383e@kernel.org>
From:   Po-Hsu Lin <po-hsu.lin@canonical.com>
Date:   Tue, 7 Mar 2023 10:24:25 +0800
Message-ID: <CAMy_GT89khdMOCeSxqGx_hh+samb0BabbrQrY6nd9uA3xNS4Cg@mail.gmail.com>
Subject: Re: [PATCH] selftests: net: devlink_port_split.py: skip test if no
 suitable device available
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, idosch@mellanox.com,
        danieller@mellanox.com, petrm@mellanox.com, shuah@kernel.org,
        pabeni@redhat.com, edumazet@google.com, davem@davemloft.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 7, 2023 at 2:33=E2=80=AFAM Jakub Kicinski <kuba@kernel.org> wro=
te:
>
> On Mon,  6 Mar 2023 19:19:59 +0800 Po-Hsu Lin wrote:
> > The `devlink -j dev show` command output may not contain the "flavour"
> > key, for example:
> >   $ devlink -j dev show
> >   {"dev":{"pci/0001:00:00.0":{},"pci/0002:00:00.0":{}}}
>
> It's not dev that's supposed to have the flavor, it's port.
>
>   devlink -j port show
Ah yes, it's using output from this command, thanks for catching this.

>
> Are you running with old kernel or old user space?
> Flavor is not an optional attribute.
This was from a s390x LPAR instance with Ubuntu 22.10 (5.19.0-37-generic)
iproute2-5.15.0

$ devlink -j port show
{"port":{"pci/0001:00:00.0/1":{"type":"eth","netdev":"ens301"},"pci/0001:00=
:00.0/2":{"type":"eth","netdev":"ens301d1"},"pci/0002:00:00.0/1":{"type":"e=
th","netdev":"ens317"},"pci/0002:00:00.0/2":{"type":"eth","netdev":"ens317d=
1"}}}

>
> > This will cause a KeyError exception. Fix this by checking the key
> > existence first.
> >
> > Also, if max lanes is 0 the port splitting won't be tested at all.
> > but the script will end normally and thus causing a false-negative
> > test result.
> >
> > Use a test_ran flag to determine if these tests were skipped and
> > return KSFT_SKIP accordingly.
> >
> > Link: https://bugs.launchpad.net/bugs/1937133
> > Fixes: f3348a82e727 ("selftests: net: Add port split test")
> > Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>
>
> Could you factor out the existing skipping logic from main()
> (the code under "if not dev:") and add the test for flavors
> to the same function? It'll be a bit more code but cleaner
> result IMHO.
Sure, will do with V2.
Thanks!
