Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10ED95135F5
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 16:02:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232732AbiD1OEw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 10:04:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231940AbiD1OEv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 10:04:51 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B304F66AD1;
        Thu, 28 Apr 2022 07:01:35 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id c23so4475954plo.0;
        Thu, 28 Apr 2022 07:01:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=94ZjX36tG1SuS/7mL6pYCyU2xfYHDd7mghQrQx2P8TM=;
        b=JWrJFl1KbTEXFWJqqzwW0z6YyNG2JrRQsG65RGIVrWqgxLDnLZEgdl+rnZ/QlLOipM
         CCNSmVor/pF/A1+va6XPTzh/vksruYweyxaI2Lwb5sdiCfxrhf6TrwqB3TwMHneS43uo
         jO42q8bjQrcmBPVFX7GRqmeABKuaY3Eb0QoBCwy++JFxaxePKuhunoL/nLOSONTpuMg8
         UaoO0RdnhJ359lB5BKaqVbzIgB1c9Pif7LBLubKGwRsiawU0iv0a57/j1xiukNsqVTAm
         LGvcZJf2Iwv+YJnpUapozApWSX0l8hHeJETy6ayJiFMYfVPtM/WKuRBMoYJXF2/jfYgJ
         T02g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=94ZjX36tG1SuS/7mL6pYCyU2xfYHDd7mghQrQx2P8TM=;
        b=lcosArEQgJDhNtG44MpVVNIZoPSWVC9TBHd0MQ/HVcgxLNm2xy5qq0JTSrFsF3msal
         9D7O27b3fg3NmjvI/er7RddC8x274C4YyvWXY9Ycq7UAQjXxGxdPIgS1xXGM2GBoV0mm
         T2+ZnojNGDkSFPP20mUPEib6wfeLgjHbTmqSo+k+dBvy4ypQy/qSdOAuZWMesKiZGNHs
         ufz6AS2F+I9kzTCzaTT5WWrN+wS+3u1cK9+D2b7G4OVQ5fywgO0dBiGvYFTKXEYWZcjO
         MdDsxXCvMgwubvcaDnuvoQjv+s9J8XQbqR28fzbCT76Jo0kpxzsBpsEMZp4xuz8r5VyM
         NWrw==
X-Gm-Message-State: AOAM533yITvGgHekJbntLX0EhDD4efZhfUS04ZYIuOomoDSfL3do+u+2
        0aeQ2AUETChtt4E0V15xdL0=
X-Google-Smtp-Source: ABdhPJzXWur53vyoRbfgprR2XDX1+/HqINIQ+nHz6DIyj488TL0/9YtaMdaDfTlhFks/SWD0lOsIvg==
X-Received: by 2002:a17:902:a98b:b0:156:40cc:ddf6 with SMTP id bh11-20020a170902a98b00b0015640ccddf6mr33871636plb.111.1651154495191;
        Thu, 28 Apr 2022 07:01:35 -0700 (PDT)
Received: from localhost.localdomain ([43.132.141.8])
        by smtp.gmail.com with ESMTPSA id m11-20020a17090a71cb00b001cd4989feebsm10940042pjs.55.2022.04.28.07.01.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 07:01:34 -0700 (PDT)
From:   Yuntao Wang <ytcoode@gmail.com>
To:     andrii.nakryiko@gmail.com
Cc:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, john.fastabend@gmail.com, kafai@fb.com,
        kpsingh@kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        shuah@kernel.org, songliubraving@fb.com, yhs@fb.com,
        ytcoode@gmail.com
Subject: Re: [PATCH bpf-next] selftests/bpf: Fix incorrect TRUNNER_BINARY name output
Date:   Thu, 28 Apr 2022 22:01:30 +0800
Message-Id: <20220428140130.2011452-1-ytcoode@gmail.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <CAEf4BzbgaqWhFDQTZHDa6w7y02_f8JeoQoj30Zk2rzDe2UfZDg@mail.gmail.com>
References: <CAEf4BzbgaqWhFDQTZHDa6w7y02_f8JeoQoj30Zk2rzDe2UfZDg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrii,

I didn't run into any real problems, the purpose of this patch was to make
the output more consistent with expectations.

It confused me when I ran 'make test_progs' but saw [test_maps] output, I
even doubted whether I ran the correct command at first.

But as you said, it's not a big deal, I'm okay with keeping it as it is.

Thanks,
Yuntao
