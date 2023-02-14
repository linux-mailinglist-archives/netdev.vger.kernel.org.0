Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 069A6695FA7
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 10:47:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232611AbjBNJq7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 04:46:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232582AbjBNJqg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 04:46:36 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EE7A24CA1
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 01:46:16 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id by3so13662018wrb.10
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 01:46:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RzyI5qxmBb5M928Y/+60AiLdAkDZT4xhdm4UmfnctR4=;
        b=Tc86sIODzomWDZZIdkVZm1zunzelR4Qxb3Qth0HGMvAQr32XsB1RYylneBA59lNxyb
         P75oK1nHZqzNyiL9Jkfn1b5GpbacrapR0L190OOG7VTXi7vAh47f4i+fvUDyQQFivUef
         egN7tXZK8I/6j5lO5BLcKH4kS8P8T2bx7cg5zmypoZhZ6mGEGJmK5fGOTVPhQOo5fsC0
         dpdE0P9XM+qwXRXJwwiYSv+s+LiErSU023jScRxped1DKVDlQWi+oRTierxorBRkl5r+
         8A6E2yz/aeKiGcGavRThEDJ9CNcbaRDYBwm1/8KLJqUSvV/I0sFCFRtZgCtRmwociJb2
         MzBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RzyI5qxmBb5M928Y/+60AiLdAkDZT4xhdm4UmfnctR4=;
        b=pQHwHNMfeGl0dUri/ZOOKFO3swheBWF+PMCG+dzX3OqIUyttjD2fXK3qC6wggutR8t
         tlT4ym7g50mQ5QfWD/oIWjUw5+yLLShjL4TJuQS1QL4bWGX9QLNiDPa7vdW/y25HhLFP
         aOLWMZnc1+YdOfqAKJn/e1O9A4FJJyL6rUX34NuoFcfpfDerqgClvUlUEYiGy4IOBDbg
         icyt8rbk6jlNQ4do8SdszNOAPParIX2bUXIiiegvjViahJ7XGqkWJQON3EA/StWYyFzc
         4Db3SP2hdilXvJdsdfDQII2qYzcLPJdQqDG6jyS01wrPEPjkiStuR2mGbANmwgZ0PtuB
         XxCA==
X-Gm-Message-State: AO0yUKWwfVbUeQmfPsEgOmDbQlJVn02ZGn+F4qWEoMewoeyy2XopEiWS
        Vv5wnFTBvkQs+ZJVgjaUGHUFSg==
X-Google-Smtp-Source: AK7set804rMZ+wQKVfoKly6xmqxV5RLr+9Ma79peLrcvcvFPHqNbSTbDfH+EKW8hf4j+4pr76XRqfQ==
X-Received: by 2002:a5d:4f82:0:b0:2c5:52bf:b28 with SMTP id d2-20020a5d4f82000000b002c552bf0b28mr5927872wru.26.1676367974980;
        Tue, 14 Feb 2023 01:46:14 -0800 (PST)
Received: from myrica (054592b0.skybroadband.com. [5.69.146.176])
        by smtp.gmail.com with ESMTPSA id l2-20020a5d6742000000b002c55cdb1de5sm3525807wrw.116.2023.02.14.01.46.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 01:46:14 -0800 (PST)
Date:   Tue, 14 Feb 2023 09:46:04 +0000
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@rivosinc.com>,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH bpf-next] selftests/bpf: Cross-compile bpftool
Message-ID: <Y+tYXGMmpcmTH8P7@myrica>
References: <20230210084326.1802597-1-bjorn@kernel.org>
 <44914e8a-c8c4-046e-155d-8d893660b417@isovalent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <44914e8a-c8c4-046e-155d-8d893660b417@isovalent.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Quentin,

On Mon, Feb 13, 2023 at 08:53:31PM +0000, Quentin Monnet wrote:
> Jean-Philippe, I know you do some cross-compiling with bpftool, how does
> this look from your side?

I don't have enough time for BPF at the moment unfortunately. Zachary is
looking at cross-compiling the selftests for arm64

Thanks,
Jean

