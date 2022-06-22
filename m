Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C539555531E
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 20:16:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377519AbiFVSQt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 14:16:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359064AbiFVSQr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 14:16:47 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB2BB3D1DE;
        Wed, 22 Jun 2022 11:16:46 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id g26so14615921ejb.5;
        Wed, 22 Jun 2022 11:16:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jL28EuTE/B/IiDSFOCkATLCzsdUidgMrBdVWQUFs7cc=;
        b=LO1pKYM/vuhd0Wi83BGq4mfQH8lRhD+ISzAR2tgKxQJ+kxQb6pjkhbr3A/qmFvVWnu
         0r6Oo9NFm22z16iwHGOw7u05VmdQ+S6lAYhBGsD19N9ERNFJqa26wX41UTMFl+iDiLbW
         FJWQHOvWHWH+NE9BvDGOmXlrDrMR0Sj1sisqBAEjicoQvmf/NpXH3hotAsnWYpteM54w
         vR9YYH4h5ROLR+CZbcYrUYpGyI90zCwFZHg2PLLizGh6p6WSwrcm/iLnO03Aikfq29Bn
         PUyghERuf/1VxsLw2S4PJwZCM6mcXot8RHrO5eCTgJ9BpuJPpzXsrs9TcoXMhu3UDTpJ
         GGfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jL28EuTE/B/IiDSFOCkATLCzsdUidgMrBdVWQUFs7cc=;
        b=MUf27+kynOHU/8MU3kueQE7iJbSzNuLpkzRZZ8ZdEKH4mSPGS4BBW/m5n02qm5YsE+
         LWgJKKo9Eh+gbv0mBK8EM8fkzgCh3L3+XV2bmhOCAvzPlGsFVzb7pi5dtcFCKpQXj9xB
         0bhR4p98vwrrcn1DgJI80HlupHCHMkD5SaMjtn9Nm9kxzsMkWd+ITLrNwvJ91iOxrmrH
         3UPplPTlu3ZVnryTAr4eVhim/w/pfg5qJK8tPXCRuCNc0YV6qmQN2DVpkbZSXIAzj2UC
         DgabaTwRS37Ofw6jYrfUHGTGFJv1/6tRlLWwl8k8NXQ9oyQ25+WJ2a0654dHIpZ8el6b
         4SUA==
X-Gm-Message-State: AJIora+fRxvTd22ysaJTfkA3iocA4bFeR6DsG3i2T5BrDZrGaeO/CA1V
        KV1ULuZNUnPmZF0TZJd8uktpakiaUBEeZPaToD4=
X-Google-Smtp-Source: AGRyM1s2NQm5CtCjmV7w3PBB0JZBDufY6KUaCPSrMmnyss4GCO9gDFw/1aEM8lRPQyVLq8qHdlkDsM822R3dbfMN4eA=
X-Received: by 2002:a17:906:5189:b0:722:dc81:222a with SMTP id
 y9-20020a170906518900b00722dc81222amr4375356ejk.502.1655921805322; Wed, 22
 Jun 2022 11:16:45 -0700 (PDT)
MIME-Version: 1.0
References: <20220621163757.760304-1-roberto.sassu@huawei.com>
 <20220621163757.760304-6-roberto.sassu@huawei.com> <20220621223135.puwe3m55yznaevm5@macbook-pro-3.dhcp.thefacebook.com>
 <76c319d5ad1e4ac69ae5d3f71e9d62f7@huawei.com>
In-Reply-To: <76c319d5ad1e4ac69ae5d3f71e9d62f7@huawei.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 22 Jun 2022 11:16:33 -0700
Message-ID: <CAADnVQLLMOfXOchNqcTOR9_-ReXrTmNjMf40HD_ZtN+BO3J3fw@mail.gmail.com>
Subject: Re: [PATCH v5 5/5] selftests/bpf: Add test for bpf_verify_pkcs7_signature()
 helper
To:     Roberto Sassu <roberto.sassu@huawei.com>
Cc:     "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "songliubraving@fb.com" <songliubraving@fb.com>,
        "kafai@fb.com" <kafai@fb.com>, "yhs@fb.com" <yhs@fb.com>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
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

On Wed, Jun 22, 2022 at 12:06 AM Roberto Sassu <roberto.sassu@huawei.com> wrote:
>
> > From: Alexei Starovoitov [mailto:alexei.starovoitov@gmail.com]
> > Sent: Wednesday, June 22, 2022 12:32 AM
> > On Tue, Jun 21, 2022 at 06:37:57PM +0200, Roberto Sassu wrote:
> > > +   if (child_pid == 0) {
> > > +           snprintf(path, sizeof(path), "%s/signing_key.pem", tmp_dir);
> > > +
> > > +           return execlp("./sign-file", "./sign-file", "-d", "sha256",
> > > +                         path, path, data_template, NULL);
> >
> > Did you miss my earlier reply requesting not to do this module_signature append
> > and use signature directly?
>
> I didn't miss. sign-file is producing the raw PKCS#7 signature here (-d).
>
> I'm doing something slightly different, to test the keyring ID part.
> I'm retrieving an existing kernel module (actually this does not work
> in the CI), parsing it to extract the raw signature, and passing it to the
> eBPF program for verification.

We don't have signed modules in CI.
When you make changes like this you have to explain that in the commit log.

> Since the kernel module is signed with a key in the built-in keyring,
> passing 1 or 0 as ID should work.
>
> Roberto
>
> (sorry, I have to keep the email signature by German law)

I don't believe that's the case since plenty of people
work from Germany and regularly contribute patches without
such banners.

> HUAWEI TECHNOLOGIES Duesseldorf GmbH, HRB 56063
> Managing Director: Li Peng, Yang Xi, Li He
