Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7053524F3F
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 16:03:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354924AbiELODJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 10:03:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354916AbiELODH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 10:03:07 -0400
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6CB65621F;
        Thu, 12 May 2022 07:03:06 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id g3so3085112qtb.7;
        Thu, 12 May 2022 07:03:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NIzK0R6x+2VqvqzkQTOwBktQ8+gticb4pC1lEDOXQo0=;
        b=TqexB6tv9k4nxRbNo9x16lUIRLlaXx8XdWf9tGh/l+Q764D2dF3VCHJ5AGsEGafZ4n
         T8jV8jbCaL8+1TxyxFxkp4eeBPmYG1T6Rn5HA1IsZLORUUoiAJbJcsSfWOWbL7phCyVn
         fhuGaCvm4oekFv/strPmhE9KO03MoldajpFGb278Baex8Sj6Fuu/gVwQGU+R9/fVrQlG
         dywlhkQWXHTWoCYS5gEy9hpwjYxK8oeNa9orVGvJvxbC92xPSUyxe7+5BLqXzaQ2xe+r
         KlusTq0qIq1jgGNBSnJRYvMcsQMvkGTUEJMzdECzZQDXw+sEdt2lupqOMLD7wyVSo9z2
         r5KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NIzK0R6x+2VqvqzkQTOwBktQ8+gticb4pC1lEDOXQo0=;
        b=YjIb+Y29r/AbkXHIkjwesLEMPQAuehHT9CgVWlPtilhCtSLEA8fI2OSwNdDKz2oCNI
         /t2TGFOnyske5mQMpLfbfA26UMFBYmLJXDNqRfFLyuMWEGS8hqbYmOP/bdaPc4bY/nEb
         K4rzWUdAIZQ2yKIok/DjiUxHvPfIJEgpfNUHLJO5aP6Kh80acPc88/p0CfYhKfNjTmSF
         lZ8B2ygopd8qtNojk02aKdAphWpWaFzN58kxKWhyrK43rDK0JkXUKc+R6CbjKxEHiEq1
         bimStniq3oJNClQ0WWzKZxmPO8MRScXtwCzhDyseO0/qenXCYjh3UvRQ+3iivymrnduT
         SBcQ==
X-Gm-Message-State: AOAM530rgaZxqBav5M/KiCthtcgS+gmnTwNlMj0dwgj6m4PL2+spbtrE
        MpwgoJ1WakU2jkpSRGJetvl1p9s4P2SvdgNRbXU=
X-Google-Smtp-Source: ABdhPJyWecdIh9kJic7EdJv78NSVzjuDETx1UGV1naYg21ISPifxgoWBXIwzo/KcciD8mwzKv5hEuhvO2rCtKvQ4Glg=
X-Received: by 2002:ac8:5946:0:b0:2f3:b8c9:ece2 with SMTP id
 6-20020ac85946000000b002f3b8c9ece2mr28822541qtz.269.1652364185615; Thu, 12
 May 2022 07:03:05 -0700 (PDT)
MIME-Version: 1.0
References: <20220512071819.199873-1-liuhangbin@gmail.com>
In-Reply-To: <20220512071819.199873-1-liuhangbin@gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 12 May 2022 07:02:54 -0700
Message-ID: <CAADnVQK_uMSLmQhWw0dHmN9+MrUFwmFACOGPjLpDPPynTaE0sw@mail.gmail.com>
Subject: Re: [PATCH net 0/2] selftests/bpf: fix ima_setup.sh missing issue
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, bpf <bpf@vger.kernel.org>
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

On Thu, May 12, 2022 at 12:18 AM Hangbin Liu <liuhangbin@gmail.com> wrote:
>
> The ima_setup.sh is needed by test_progs test_ima. But the file is
> missed if we build test_progs separately or installed bpf test to
> another folder. This patch set fixed the issue in 2 different
> scenarios.

Patch subject is incorrect.
Please use [PATCH bpf-next].
