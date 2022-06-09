Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EC71545106
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 17:38:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344559AbiFIPio (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 11:38:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237587AbiFIPik (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 11:38:40 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BF6326329E;
        Thu,  9 Jun 2022 08:38:37 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id o10so31705776edi.1;
        Thu, 09 Jun 2022 08:38:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Mg7JMiMVAhUH8K1hucSMpRfWYhKs0b5aSTxdi9koiAw=;
        b=fVwBnNiAwp7xgtTmQYNF749ks9JXSD2bg2YjxxWGiObTL28ROuVZJuS22JONbKHEAM
         lpRS4XfSOioN2mWEYrgpimmQQL7pECXClPcZB1GqYXg9wPYtYmk2wg1MNDbKNS/MSt9d
         zH6m3leRaqH5tMseU5MZBbi4/I/VyO2gr3c8yu6L0WkB1I3eTvJGYDsHWtpY8ZkpXPEy
         hLytZNL+EO17uuMVHm8bFCS46vRBe2enbDBwmQdVoeXcubs7OBJ6DnFQWZE/cR7u3CVL
         wysjuiqrIiWLhqjdwx+NPj2cZmu01pjCHMweqPROWobGuyXIXsEz+vP8nzzRVN6ZHbCx
         0zbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Mg7JMiMVAhUH8K1hucSMpRfWYhKs0b5aSTxdi9koiAw=;
        b=YqxlWM0JXoMczTTZ5T7eAoofSO3EzuEcpgEzAK88Fi77tzzHw8GLJnSLOg40q3WVeH
         ToTFJKds0dErQyX5ivlCRGH+Dtp784UH511JOA7ej9/ggSTcYPla6lVMv952Ji13OL0Y
         zDhD5DPg1hCctHRTsmAcEsPF2Q6hMj6n5C5fe152+UddizYaE+PqzepIjM9FlK1sbMbv
         8GfSWcLGsaSh0a496yaTm0mE9xm/dmXXC4dL5YasW9GBHjuWJu7/7GF9HnGeJGVCFxZn
         pmI5dV7NQZVX3PnW4vIQrLlikNhGlxUTj/k9T+DCvh339Skekt0Pa57zBARtfXaeE2v+
         uejw==
X-Gm-Message-State: AOAM533jBfOZG/A4Qdke12+xQiF4VpQHUxMLOJZqV/MBK3+xWZ+iOWhH
        3/ODuB70Wlpaut3tv+9Hy9P+yrRSCRdtgq/4kY2fMOf5rp4=
X-Google-Smtp-Source: ABdhPJz3cHnciiAj2zKCGvjtUPGW1JPISEltKYJUwf/VFV3cj1sIWruCAc+UarPUfh5NMJr73eST6atzEIAwdI3MyPo=
X-Received: by 2002:a05:6402:11d1:b0:433:4a09:3f49 with SMTP id
 j17-20020a05640211d100b004334a093f49mr884992edw.357.1654789116109; Thu, 09
 Jun 2022 08:38:36 -0700 (PDT)
MIME-Version: 1.0
References: <20220608111221.373833-1-roberto.sassu@huawei.com>
 <20220608111221.373833-3-roberto.sassu@huawei.com> <CAADnVQJ4RCSAeDMqFpF5bQznPQaTWFr=kL7GdssDQuzLof06fg@mail.gmail.com>
 <92d8b9c08e20449782f19f64cc3ec5fa@huawei.com>
In-Reply-To: <92d8b9c08e20449782f19f64cc3ec5fa@huawei.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 9 Jun 2022 08:38:24 -0700
Message-ID: <CAADnVQLd2d+_2iJ84u9zK3Nnb+LL3Gw7k=XQCVOHuekb2hLf_g@mail.gmail.com>
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

On Thu, Jun 9, 2022 at 2:00 AM Roberto Sassu <roberto.sassu@huawei.com> wrote:
>
> > From: Alexei Starovoitov [mailto:alexei.starovoitov@gmail.com]
> > Sent: Thursday, June 9, 2022 2:13 AM
> > On Wed, Jun 8, 2022 at 4:15 AM Roberto Sassu <roberto.sassu@huawei.com>
> > wrote:
> > >
> > > According to the logs of the eBPF CI, built kernel and tests are copied to
> > > a virtual machine to run there.
> > >
> > > Since a test for a new helper to verify PKCS#7 signatures requires to sign
> > > data to be verified, extend test_progs to store in the test_env data
> > > structure (accessible by individual tests) the path of sign-file and of the
> > > kernel private key and cert.
> > >
> > > Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> > > ---
> > >  tools/testing/selftests/bpf/test_progs.c | 12 ++++++++++++
> > >  tools/testing/selftests/bpf/test_progs.h |  3 +++
> > >  2 files changed, 15 insertions(+)
> > >
> > > diff --git a/tools/testing/selftests/bpf/test_progs.c
> > b/tools/testing/selftests/bpf/test_progs.c
> > > index c639f2e56fc5..90ce2c06a15e 100644
> > > --- a/tools/testing/selftests/bpf/test_progs.c
> > > +++ b/tools/testing/selftests/bpf/test_progs.c
> > > @@ -707,6 +707,8 @@ enum ARG_KEYS {
> > >         ARG_TEST_NAME_GLOB_DENYLIST = 'd',
> > >         ARG_NUM_WORKERS = 'j',
> > >         ARG_DEBUG = -1,
> > > +       ARG_SIGN_FILE = 'S',
> > > +       ARG_KERNEL_PRIV_CERT = 'C',
> > >  };
> > >
> > >  static const struct argp_option opts[] = {
> > > @@ -732,6 +734,10 @@ static const struct argp_option opts[] = {
> > >           "Number of workers to run in parallel, default to number of cpus." },
> > >         { "debug", ARG_DEBUG, NULL, 0,
> > >           "print extra debug information for test_progs." },
> > > +       { "sign-file", ARG_SIGN_FILE, "PATH", 0,
> > > +         "sign-file path " },
> > > +       { "kernel-priv-cert", ARG_KERNEL_PRIV_CERT, "PATH", 0,
> > > +         "kernel private key and cert path " },
> > >         {},
> > >  };
> > >
> > > @@ -862,6 +868,12 @@ static error_t parse_arg(int key, char *arg, struct
> > argp_state *state)
> > >         case ARG_DEBUG:
> > >                 env->debug = true;
> > >                 break;
> > > +       case ARG_SIGN_FILE:
> > > +               env->sign_file_path = arg;
> > > +               break;
> > > +       case ARG_KERNEL_PRIV_CERT:
> > > +               env->kernel_priv_cert_path = arg;
> > > +               break;
> >
> > That's cumbersome approach to use to force CI and
> > users to pass these args on command line.
> > The test has to be self contained.
> > test_progs should execute it without any additional input.
> > For example by having test-only private/public key
> > that is used to sign and verify the signature.
>
> I thought a bit about this. Just generating a test key does not work,
> as it must be signed by the kernel signing key (otherwise, loading
> in the secondary keyring will be rejected). Having the test key around
> is as dangerous as having the kernel signing key around copied
> somewhere.
>
> Allowing users to specify a test keyring in the helper is possible.

We shouldn't need to load into the secondary keyring.
The helper needs to support an arbitrary key ring.
The kernel shouldn't interfere with loading that test key into
a test ring.

> But it would introduce unnecessary code, plus the keyring identifier

What kind of 'unnecessary code' ?

> will be understood by eBPF only and not by verify_pkcs7_signature(),
> as it happens for other keyring identifiers.

Maybe wrapping verify_pkcs7_signature as a helper is too high level?

> We may have environment variables directly in the eBPF test, to
> specify the location of the signing key, but there is a risk of
> duplication, as other tests wanting the same information might
> not be aware of them.

That's no go.

> I would not introduce any code that handles the kernel signing
> key (in the Makefile, or in a separate script). This information is
> so sensible, that it must be responsibility of an external party
> to do the work of making that key available and tell where it is.
>
> Roberto
>
> HUAWEI TECHNOLOGIES Duesseldorf GmbH, HRB 56063
> Managing Director: Li Peng, Yang Xi, Li He
