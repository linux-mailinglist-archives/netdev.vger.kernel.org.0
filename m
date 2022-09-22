Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4294C5E576E
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 02:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbiIVAi2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 20:38:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbiIVAiZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 20:38:25 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FCBEA98C2;
        Wed, 21 Sep 2022 17:38:23 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id l14so17498665eja.7;
        Wed, 21 Sep 2022 17:38:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=36Uxd9fzOtQXdUTgT2x6xrnFj/OP6ll4rq+xlPqT6zs=;
        b=I5VK0kFYpdJq7uuW/my6/s1qq5Iyk5Bid9V1MLGMfcqCQWztkAuk9NwGH236IdPw0t
         aSpjgBiqC/nGZwjYEvfyXWTdEcKTcw0+alOVgKlPJp0QxZ51FAjaVDzR72eVHRH3bbvy
         gvkVll0e0g0VmQ4F+5N6/s2DIzf/I27kP/bz1CeUqjpjHLzE3nXgrjkQ/KYJ7YpMHAkl
         X4LL9WElTtiK3lEKN88AvhLMEYbUQuFbdHgajFCsib9S8OAsKjAJ2hwQaDr7Ll+KkdP+
         xKM1XMVuJO2zuGtJCha8Q5jPSh1fIwYoh4vH+EI9GVYm3sM0OCx6oEhE0nGmVgeLFMUN
         dZzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=36Uxd9fzOtQXdUTgT2x6xrnFj/OP6ll4rq+xlPqT6zs=;
        b=X5oKQdcaS+92tvbcFjs9npwpXeTaqe10vpffAfvYuTwx+lwTZ6ffupPk5ioGAdk5ZB
         PUJrBmwGszcqCEd6ln+qMxVCyvOdmO6cgLGdEyCHIz0eL9ilSpuKvNLEq94AVvd/Fy2G
         9V2dHy6K/P7l2zj2jNZHJ+tMWXSfvfTNVIfWVevMlYeAZVHGrRfFRLa92Uw30wk91yds
         OfSRiMwFY1VJLC2wjTE6AuKka8L+bX0RQSd8ZNu1pBfXS/zTRMC+G8dDMwKjHm61dw+W
         tIafHJ8k9tgZIiDiEokBvgVOI9OymCtL6mXJIlDrgkw2RX4xQNetWUuhUJaB/Lu2DPPw
         O23g==
X-Gm-Message-State: ACrzQf3UDtUQzpqiTl1fiqxkir4c0nFXLBRgf2b9a8hwbPDUqjEse2Iq
        2agh+zbH/Za2O8iw/rZbuUwQTH9yaF+I/rw1FRY=
X-Google-Smtp-Source: AMsMyM6Ry07M/XiRvs8DE4XwyxTLWwVw+IwMzGuWJO2lBy5NVGAojN78DUAFSefFqfeYCg1fyKNfsWUJO9lS/CKlptk=
X-Received: by 2002:a17:907:3d86:b0:782:1175:153f with SMTP id
 he6-20020a1709073d8600b007821175153fmr692120ejc.226.1663807101634; Wed, 21
 Sep 2022 17:38:21 -0700 (PDT)
MIME-Version: 1.0
References: <1663555725-17016-1-git-send-email-wangyufen@huawei.com> <1663555725-17016-2-git-send-email-wangyufen@huawei.com>
In-Reply-To: <1663555725-17016-2-git-send-email-wangyufen@huawei.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 21 Sep 2022 17:38:10 -0700
Message-ID: <CAEf4BzabFB-__1bcYTb8E0ixS0dNZNcp9XNB-McWvQQ98sBR-Q@mail.gmail.com>
Subject: Re: [bpf-next v3 2/2] selftests/bpf: Add testcases for pinning to errpath
To:     Wang Yufen <wangyufen@huawei.com>
Cc:     andrii@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, paul.walmsley@sifive.com,
        palmer@dabbelt.com, aou@eecs.berkeley.edu, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, nathan@kernel.org,
        ndesaulniers@google.com, trix@redhat.com, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 18, 2022 at 7:28 PM Wang Yufen <wangyufen@huawei.com> wrote:
>
> Add testcases for map and prog pin to errpath.
>
> Signed-off-by: Wang Yufen <wangyufen@huawei.com>
> ---

let's drop this selftest, it does global system manipulations just to
check those two if conditions inside pathname_concat(), probably not
worth it.

Also for the future, we shouldn't use CHECK() in new selftests (we
still have CHECK()s because there are like 2 thousand of them in old
selftest, so clean up is not trivial).

>  tools/testing/selftests/bpf/prog_tests/pinning.c   | 67 ++++++++++++++++++++++
>  .../selftests/bpf/progs/test_pinning_path.c        | 19 ++++++
>  2 files changed, 86 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/progs/test_pinning_path.c
>

[...]
