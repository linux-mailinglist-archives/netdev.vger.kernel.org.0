Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7310253D642
	for <lists+netdev@lfdr.de>; Sat,  4 Jun 2022 11:32:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234015AbiFDJcc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jun 2022 05:32:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230351AbiFDJca (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jun 2022 05:32:30 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1886C26124;
        Sat,  4 Jun 2022 02:32:29 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id q21so20131063ejm.1;
        Sat, 04 Jun 2022 02:32:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kEnlhjDu0FbGaaiDuZ0pof8c2vlmdAC3/VHnhWFqmg4=;
        b=PnimOz8UTsnQrP+tEBJhi00bkQm619fcXVGRSpNRTJK4BE0FZCxeOMZ4tv3bK3fTQe
         2VBpDrqigAmGMAgDTdPCoyUvjLVSBMLn3lNa52v+PG8+ODbpszGfmBc98L7MaP/Y2SCq
         N5jAsIquHzKMtbi+8tjg1RkholuN6cahghqBcdKW4Vo8NUP1zO8nLOXiwKF6q0FuiE55
         +KH9++ROi2nHfYjxrAR12tn52UFbbiXLiJCt2qJB4zlQL+2qJuTKc4JJvatCF/kLIPYd
         +vF6sn8DssyO8XjdU19Y7jBHzks4YzZzauxaAd/udeWawZphiIZ9C4I+RPasgyVuyWAd
         pguA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kEnlhjDu0FbGaaiDuZ0pof8c2vlmdAC3/VHnhWFqmg4=;
        b=SDCJG++6NlxUWbCBqMvQhp5toJGDxG0BLAEF00nFnoLUKxhMkFe19S2WwIsuey1uUk
         iWwczzPlQ8bBOjt69cAbvicl/HjDRfGE6XI208HvmQkj4MeRnKzTfF1wS3j3+UBwiLTN
         Mkb/Ja2v1nf5POi06E4RC7HQsSUR6t09hpqr4A3SDWqbdN5xyDuGvHBlLh14LXYACvcq
         wcguKkPmdZXi1qQng+pgqrhJbEms5SiqzlXxh46lEK8ZJLUpVXOij7+TKJ+/SXPZM0NE
         Liqi3sDs0KugViTxxp0CkEz+ECAf0Sm4+deF+0QQUMn2lqs6vVL75aEYQau0CE4oAuTK
         H7Tw==
X-Gm-Message-State: AOAM531xPd/fsXfqpVu8DaAZdSOU+6cS3iy2I6yO4tHkMCrOFMQ4Trwy
        VH0sqSqFoG+PlTtqgTYTZDS7zdpUHy2DTmfVOLw=
X-Google-Smtp-Source: ABdhPJzPjZrJ4eJvtFdkY3qOCuyVx7FzZONcP1b+1P5BVkPY2ID46v7ARm3OX9d9GsOfOQFTiXP0iWZFxzGOBMajY6E=
X-Received: by 2002:a17:907:72c1:b0:6ff:c5f:6b7d with SMTP id
 du1-20020a17090772c100b006ff0c5f6b7dmr12395793ejc.676.1654335147423; Sat, 04
 Jun 2022 02:32:27 -0700 (PDT)
MIME-Version: 1.0
References: <20220525132115.896698-1-roberto.sassu@huawei.com>
 <20220525132115.896698-2-roberto.sassu@huawei.com> <CACYkzJ7L-fE740t91amu4uiDA5dnDMU1D+c0vhb-sFHyQK08kA@mail.gmail.com>
 <89db5543066f4dccbfebd78ed3c025e7@huawei.com> <CACYkzJ4uD_k6sDktVaxkE_1QtSphZm+Rhjk4wrMm71LcmWRJ0w@mail.gmail.com>
 <cfaafb3af5be40ec80f14e134a5702cf@huawei.com>
In-Reply-To: <cfaafb3af5be40ec80f14e134a5702cf@huawei.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sat, 4 Jun 2022 11:32:15 +0200
Message-ID: <CAADnVQ+QL+rewHZ-Q=0W9o7VXKPvwHm=rmdGFKTqQBUxZhsnuQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] bpf: Add BPF_F_VERIFY_ELEM to require signature
 verification on map values
To:     Roberto Sassu <roberto.sassu@huawei.com>
Cc:     KP Singh <kpsingh@kernel.org>, "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
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

On Fri, Jun 3, 2022 at 5:44 PM Roberto Sassu <roberto.sassu@huawei.com> wrote:
> >
> > Your bpf_map_verify_value_sig hard codes the type of signature
> > (bpf_map_verify_value_sig as verify_pkcs7_signature)
> > its implementation. This is not extensible.
>
> It is hardcoded now, but it wouldn't if there are more verification
> functions. For example, if 'id_type' of module_signature is set
> to PKEY_ID_PGP, bpf_map_verify_value_sig() would call
> verify_pgp_signature() (assuming that support for PGP keys and
> signatures is added to the kernel).

I agree with KP. All hard coded things are hurting extensibility.
we just need a helper that calls verify_pkcs7_signature
where prog will specify len, keyring, etc.
