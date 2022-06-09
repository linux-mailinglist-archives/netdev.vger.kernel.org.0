Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CCBA544066
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 02:13:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235703AbiFIAM6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 20:12:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbiFIAM4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 20:12:56 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A37B034676;
        Wed,  8 Jun 2022 17:12:55 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id x5so24033015edi.2;
        Wed, 08 Jun 2022 17:12:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=d+/fJF2djT1DclZjNPSTPoNHUSOfCcPs6iD3wKEM/T0=;
        b=jEvOiDBS+YNifNjxyaLVHDF+j7G8V4Nw4YjUEgr6O3/ehWQRDJahNRv1qIqI4RkyU8
         tFgrUVO0H/dBghITg3LcWXwJVCcaRPV2tLh5BabJcoF730++jgsFt4xSK7m3/5Os2pX5
         O22HzgzO9c4NjZ6O24NROX5dC7fD2sagaInba+n2zDsF/rAp4PStdG1/ZeMMETCCvebB
         4ASOSrnI+P0dCZ+9azWEeEoH+sAvdriabmroV3CobwWJMI4U2THTGnqmeM+nZng5sI5C
         ZbWXSMXZDnleEgrKOX8kZqeOemDmW+MJNb75innj2kRnTlWiVepolEOemyOyF5NH+wMn
         Yesg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d+/fJF2djT1DclZjNPSTPoNHUSOfCcPs6iD3wKEM/T0=;
        b=g36x7LmCT5DhDA+mUl67BnBSZ6g3sU4jVb6HVbjcaCkSU9nZGAYoNDyJHf6G7qtVUt
         6wuvbMVMiQ8tEG9bcQYfWs83ztX6uZyh6ItmD1ScJG3c6S54cJgLPrNOjz5L00l+NWNi
         OeWYTqIjCSJj27qMf+rRqLU8/BTM1DgM3wKQ4ePnu+UtNWoHS6Blm1q2JXuM+GLyr3Tn
         TMMzAuTl4lMC/uyT5xIF9SuLBCBKmQf3QDz0GlPWYrGveB92goy+swRBpAuk+cVmtwpP
         vTLaNjibewz3rWmA9Tnf5Y3V3hBDawsNnQj4zcrqoRAMn9vYvU1zw36O01UcOernm/sM
         yzKQ==
X-Gm-Message-State: AOAM532mKZAItQkCtSw5n0FH0wsIQTmw1CKm6ymueRcSQ1XoPkQhE1NT
        XK8r6qOlsANcfHlFgvObjr2NCZFjh+YaFKtBzjM=
X-Google-Smtp-Source: ABdhPJwnxHMwfwrtisT2I4w3h9eLchQbIXCVEYfwv8wr1DmS6m2YMxY6ATx90TISPZhEXcwR0lGzkIpJSntkYwMobbM=
X-Received: by 2002:a05:6402:3895:b0:430:6a14:8ca3 with SMTP id
 fd21-20020a056402389500b004306a148ca3mr29401064edb.421.1654733574084; Wed, 08
 Jun 2022 17:12:54 -0700 (PDT)
MIME-Version: 1.0
References: <20220608111221.373833-1-roberto.sassu@huawei.com> <20220608111221.373833-3-roberto.sassu@huawei.com>
In-Reply-To: <20220608111221.373833-3-roberto.sassu@huawei.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 8 Jun 2022 17:12:41 -0700
Message-ID: <CAADnVQJ4RCSAeDMqFpF5bQznPQaTWFr=kL7GdssDQuzLof06fg@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] selftests/bpf: Add test_progs opts for sign-file
 and kernel priv key + cert
To:     Roberto Sassu <roberto.sassu@huawei.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        KP Singh <kpsingh@kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
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

On Wed, Jun 8, 2022 at 4:15 AM Roberto Sassu <roberto.sassu@huawei.com> wrote:
>
> According to the logs of the eBPF CI, built kernel and tests are copied to
> a virtual machine to run there.
>
> Since a test for a new helper to verify PKCS#7 signatures requires to sign
> data to be verified, extend test_progs to store in the test_env data
> structure (accessible by individual tests) the path of sign-file and of the
> kernel private key and cert.
>
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> ---
>  tools/testing/selftests/bpf/test_progs.c | 12 ++++++++++++
>  tools/testing/selftests/bpf/test_progs.h |  3 +++
>  2 files changed, 15 insertions(+)
>
> diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
> index c639f2e56fc5..90ce2c06a15e 100644
> --- a/tools/testing/selftests/bpf/test_progs.c
> +++ b/tools/testing/selftests/bpf/test_progs.c
> @@ -707,6 +707,8 @@ enum ARG_KEYS {
>         ARG_TEST_NAME_GLOB_DENYLIST = 'd',
>         ARG_NUM_WORKERS = 'j',
>         ARG_DEBUG = -1,
> +       ARG_SIGN_FILE = 'S',
> +       ARG_KERNEL_PRIV_CERT = 'C',
>  };
>
>  static const struct argp_option opts[] = {
> @@ -732,6 +734,10 @@ static const struct argp_option opts[] = {
>           "Number of workers to run in parallel, default to number of cpus." },
>         { "debug", ARG_DEBUG, NULL, 0,
>           "print extra debug information for test_progs." },
> +       { "sign-file", ARG_SIGN_FILE, "PATH", 0,
> +         "sign-file path " },
> +       { "kernel-priv-cert", ARG_KERNEL_PRIV_CERT, "PATH", 0,
> +         "kernel private key and cert path " },
>         {},
>  };
>
> @@ -862,6 +868,12 @@ static error_t parse_arg(int key, char *arg, struct argp_state *state)
>         case ARG_DEBUG:
>                 env->debug = true;
>                 break;
> +       case ARG_SIGN_FILE:
> +               env->sign_file_path = arg;
> +               break;
> +       case ARG_KERNEL_PRIV_CERT:
> +               env->kernel_priv_cert_path = arg;
> +               break;

That's cumbersome approach to use to force CI and
users to pass these args on command line.
The test has to be self contained.
test_progs should execute it without any additional input.
For example by having test-only private/public key
that is used to sign and verify the signature.
