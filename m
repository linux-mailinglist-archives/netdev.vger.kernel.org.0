Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 532CA53CC27
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 17:18:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245415AbiFCPSH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 11:18:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239364AbiFCPSG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 11:18:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05A8C3B550
        for <netdev@vger.kernel.org>; Fri,  3 Jun 2022 08:18:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 90EF96185A
        for <netdev@vger.kernel.org>; Fri,  3 Jun 2022 15:18:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E66CEC34114
        for <netdev@vger.kernel.org>; Fri,  3 Jun 2022 15:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654269484;
        bh=J1pDyR8eqx/9pW9pkfsdPhUb4bYf5TmuT1AOJn9bTjY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=cqY3JDYyfeK51Ep9QPS31Tyz0Yre8ksTz2L4JNU/J6heN1kLOsV/2lXZig8JrdWUD
         2qxT/21boHVrh3Ib1aX9AaTGITOP8hKd6PlhImQ8XhKfEhA1mGUKkJr6Z8is/1Xmnh
         yi/+YkjIXo6oprcMWKAvk97huJktmjdFhTTN7tYOqepXXN1Y1SEUDCR+dmBD1ZngZJ
         ucM7yMn60muDh+XPaBvmbl/bGXSJeX4Diw1XEOkiFlGW217u577sGGWICmPiZmgnb1
         p4sWuo4LddmcfGFkf9vDENerMDEk9MsyEIbz5GH3pPxcKCIygmZVAakV1P7Q6SQZhy
         zi5XhCMOZLIMw==
Received: by mail-yb1-f178.google.com with SMTP id v106so14326593ybi.0
        for <netdev@vger.kernel.org>; Fri, 03 Jun 2022 08:18:04 -0700 (PDT)
X-Gm-Message-State: AOAM531Oi5/IMWTSYvKfUsDlrEwiGIf1yLbGMXWodUVaYZ8gohP3RrOv
        7p+NHYNNx3uhjRauMfiL46VSIN4N0KloiL9wDmMseg==
X-Google-Smtp-Source: ABdhPJy3JiwtKeNNkUGb33j2HBwLWYDoqpp0Fr2u5FckeBuipR8QlfF8/Lc33zca/1upjX/eBRBTREYGX8PnaEGZ2Hg=
X-Received: by 2002:a5b:c12:0:b0:662:af24:c27c with SMTP id
 f18-20020a5b0c12000000b00662af24c27cmr2530844ybq.158.1654269483929; Fri, 03
 Jun 2022 08:18:03 -0700 (PDT)
MIME-Version: 1.0
References: <20220525132115.896698-1-roberto.sassu@huawei.com>
 <20220525132115.896698-2-roberto.sassu@huawei.com> <CACYkzJ7L-fE740t91amu4uiDA5dnDMU1D+c0vhb-sFHyQK08kA@mail.gmail.com>
 <89db5543066f4dccbfebd78ed3c025e7@huawei.com>
In-Reply-To: <89db5543066f4dccbfebd78ed3c025e7@huawei.com>
From:   KP Singh <kpsingh@kernel.org>
Date:   Fri, 3 Jun 2022 17:17:53 +0200
X-Gmail-Original-Message-ID: <CACYkzJ4uD_k6sDktVaxkE_1QtSphZm+Rhjk4wrMm71LcmWRJ0w@mail.gmail.com>
Message-ID: <CACYkzJ4uD_k6sDktVaxkE_1QtSphZm+Rhjk4wrMm71LcmWRJ0w@mail.gmail.com>
Subject: Re: [PATCH 1/3] bpf: Add BPF_F_VERIFY_ELEM to require signature
 verification on map values
To:     Roberto Sassu <roberto.sassu@huawei.com>
Cc:     "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 3, 2022 at 3:11 PM Roberto Sassu <roberto.sassu@huawei.com> wrote:
>
> > From: KP Singh [mailto:kpsingh@kernel.org]
> > Sent: Friday, June 3, 2022 2:08 PM
> > On Wed, May 25, 2022 at 3:21 PM Roberto Sassu <roberto.sassu@huawei.com>
> > wrote:
> > >
> > > In some cases, it is desirable to ensure that a map contains data from
> > > authenticated sources, for example if map data are used for making security
> > > decisions.
> >
> > I am guessing this comes from the discussion we had about digilim.
> > I remember we discussed a BPF helper that could verify signatures.
> > Why would that approach not work?
>
> The main reason is that signature verification can be done also
> for non-sleepable hooks. For example, one is fexit/array_map_update_elem.

For your use-case, why is it not possible to hook the LSM hook "bpf"
i.e security_bpf and then check if there is a MAP_UPDATE_ELEM operation?

>
> Currently the helper in patch 2 just returns the size of verified data.
> With an additional parameter, it could also be used as a helper for
> signature verification by any eBPF programs.
>

Your bpf_map_verify_value_sig hard codes the type of signature
(bpf_map_verify_value_sig as verify_pkcs7_signature)
its implementation. This is not extensible.

What we discussed was an extensible helper that can be used for
different signature types.

> To be honest, I like more the idea of a map flag, as it is more
> clear that signature verification is being done. Otherwise,
> we would need to infer it from the eBPF program code.
>
> Thanks
>
> Roberto
>
> HUAWEI TECHNOLOGIES Duesseldorf GmbH, HRB 56063
> Managing Director: Li Peng, Yang Xi, Li He
>
> > > Such restriction is achieved by verifying the signature of map values, at
> > > the time those values are added to the map with the bpf() system call (more
> > > specifically, when the commands passed to bpf() are BPF_MAP_UPDATE_ELEM
> > or
> > > BPF_MAP_UPDATE_BATCH). Mmappable maps are not allowed in this case.
> > >
> > > Signature verification is initially done with keys in the primary and
> > > secondary kernel keyrings, similarly to kernel modules. This allows system
> > > owners to enforce a system-wide policy based on the keys they trust.
> > > Support for additional keyrings could be added later, based on use case
> > > needs.
> > >
> > > Signature verification is done only for those maps for which the new map
> > > flag BPF_F_VERIFY_ELEM is set. When the flag is set, the kernel expects map
> > > values to be in the following format:
> > >
> > > +-------------------------------+---------------+-----+-----------------+
> > > | verified data+sig size (be32) | verified data | sig | unverified data |
> > > +-------------------------------+---------------+-----+-----------------+
> > >
> > > where sig is a module-style appended signature as generated by the
> > > sign-file tool. The verified data+sig size (in big endian) must be
> > > explicitly provided (it is not generated by sign-file), as it cannot be
> > > determined in other ways (currently, the map value size is fixed). It can
> > > be obtained from the size of the file created by sign-file.
> > >
> > > Introduce the new map flag BPF_F_VERIFY_ELEM, and additionally call the
> > new
> > > function bpf_map_verify_value_sig() from bpf_map_update_value() if the flag
> > > is set. bpf_map_verify_value_sig(), declared as global for a new helper, is
> > > basically equivalent to mod_verify_sig(). It additionally does the marker
> > > check, that for kernel modules is done in module_sig_check(), and the
> > > parsing of the verified data+sig size.
> > >
> > > Currently, enable the usage of the flag only for the array map. Support for
> > > more map types can be added later.
> > >
> > > Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> > > ---

[...]

> > > +                                            NULL, NULL);
> > > +               if (ret < 0)
> > > +                       return ret;
> > > +       }
> > > +
> > > +       return modlen;
> > > +}
> > > +EXPORT_SYMBOL_GPL(bpf_map_verify_value_sig);
> > >
> > >  #define BPF_MAP_UPDATE_ELEM_LAST_FIELD flags
> > >
> > > diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> > > index f4009dbdf62d..a8e7803d2593 100644
> > > --- a/tools/include/uapi/linux/bpf.h
> > > +++ b/tools/include/uapi/linux/bpf.h
> > > @@ -1226,6 +1226,9 @@ enum {
> > >
> > >  /* Create a map that is suitable to be an inner map with dynamic max entries
> > */
> > >         BPF_F_INNER_MAP         = (1U << 12),
> > > +
> > > +/* Verify map value (fmt: ver data+sig size(be32), ver data, sig, unver data) */
> > > +       BPF_F_VERIFY_ELEM       = (1U << 13)
> > >  };
> > >
> > >  /* Flags for BPF_PROG_QUERY. */
> > > --
> > > 2.25.1
> > >
