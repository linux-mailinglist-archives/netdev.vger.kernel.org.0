Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF531682E13
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 14:35:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232043AbjAaNfz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 08:35:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231600AbjAaNfy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 08:35:54 -0500
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8164B2448A
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 05:35:47 -0800 (PST)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-50aa54cc7c0so175573467b3.8
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 05:35:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=tI4kV5oM2qFPjQvEJDn5jAVsXRrgMzRfITJo9e7Rl78=;
        b=IbTU8Qz2dEo3JIi3NzAPce2fz2Pb4PMTWYfgXL3raMV1d/zoTdEoR+fmrELHo5hKkc
         rBq6FNw23PsVBuBFmc0MNBS+rIhZ4Jtw7AKx9Lv9yD0dCmolrmqrgpbYK2PHv40vH0a5
         Ra0SKdWBfq/usstmwBVh3QOnXbgTDDiD+U2JpRK9/gjOFS7B8S2Uw+wMKIV+vyS8iSje
         MHLH4xfHK42foxoZVu73hnrko+dmLmtjMTpCAbi1SE55jSi9si7H8R3tAwZf/FJcczL7
         1s3tfh3K8T8BKKhThwud/iLqu6lMIYW95v1ClMnfzkhFovWhPyxf9Kiq8HC558o23qHB
         NTrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tI4kV5oM2qFPjQvEJDn5jAVsXRrgMzRfITJo9e7Rl78=;
        b=Qk7m3KjFobOlCgjedqmbfR1OID2nvIEHnxBDcF2nhyzi3XYaovFAEOiB+M0RDVKCfs
         0a110KbI5G8EokQhu3l/ndJkYdKjK5xZSMzE4g/7iipbTiIeXrCodhQCZ9hfOwDeATSP
         FU4V03kuSUYCSHrsZVucN/9hf2fbwDxgDAXdj4SxIfy7/ic0XI+dbMIzGrGqpUz9Sxqk
         ZWcrWgW67Zk4Xje4qhH1Ze8i361s7CYrZVBg2G5tQQARwHOgSEMzPEOm2w/n4uXU61t6
         fgLg/xQTPViiO72Hf+oMvX8dYPUr51hMi7ZyqKmOJTF5b/nXyAzi0m3UpCw2dqHWPcp4
         gJrA==
X-Gm-Message-State: AFqh2koTxJHBdlsh6rDkBUqr5CBkTZpH22mWcNnUt16e7bQAZthepYxD
        eMRRATdvIPaYzYbN/1sW0rfYApHm5AKYjWHhYLlj12KvxPTK0AnO
X-Google-Smtp-Source: AMrXdXs3q2RiccipehWHg8zxYR2iLXkL7CjpaacTtKc4bg5V5IHTA41lkqUQp4FNhYntdV3LrQNKISffJTyFIxiOQX4=
X-Received: by 2002:a81:ed4:0:b0:4dd:c62f:d65a with SMTP id
 203-20020a810ed4000000b004ddc62fd65amr4835812ywo.427.1675172146677; Tue, 31
 Jan 2023 05:35:46 -0800 (PST)
MIME-Version: 1.0
References: <20230131130412.432549-1-andrei.gherzan@canonical.com> <20230131130412.432549-2-andrei.gherzan@canonical.com>
In-Reply-To: <20230131130412.432549-2-andrei.gherzan@canonical.com>
From:   Willem de Bruijn <willemb@google.com>
Date:   Tue, 31 Jan 2023 08:35:10 -0500
Message-ID: <CA+FuTSf1ffpep=wV=__J96Ju_nPkd96=c+ny4mC+SxrhRp0ofA@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] selftests: net: udpgso_bench_rx/tx: Stop when
 wrong CLI args are provided
To:     Andrei Gherzan <andrei.gherzan@canonical.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
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

On Tue, Jan 31, 2023 at 8:08 AM Andrei Gherzan
<andrei.gherzan@canonical.com> wrote:
>
> Leaving unrecognized arguments buried in the output, can easily hide a
> CLI/script typo. Avoid this by exiting when wrong arguments are provided to
> the udpgso_bench test programs.
>
> Signed-off-by: Andrei Gherzan <andrei.gherzan@canonical.com>

I'm on the fence on this. Test binaries are not necessarily robust
against bad input. If you insist.

When sending patches to net, please always add a Fixes tag.
