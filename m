Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 241D963E06C
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 20:06:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbiK3TGg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 14:06:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbiK3TGf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 14:06:35 -0500
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C98A46662
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 11:06:34 -0800 (PST)
Received: by mail-ot1-x32a.google.com with SMTP id p24-20020a0568301d5800b0066e6dc09be5so1242050oth.8
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 11:06:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=YEIwtglu4xRS3NnZPOYlcGRKf1k45KF06+ysr6r2J98=;
        b=Abd4UtytHNhKrbpcYfSAkkX9IHCf2163adtDrFfbOBX4J4Sd2yQZYljKpTK+XfFHpI
         +vY/d22/g7AmkndKCJT1i1GN0nTnNWopbysJLZlcf3bq9CFcYmHCuNcQS/kscRcXsYzJ
         UAaCjK+U1nR3tkTJ9wJhqIE+81ni17EJKocxFviUaj7fbFz4RH3KSigZXWxqOVuD83OA
         wDlhWBn1KSgWDKC3I6lwgp2n09l/8vV/EIgaoHdXcu32FG9yseZU2dVi+KmgAvpStfYt
         8GOqUKL03HMcuhP4fC4WyyvzpdNaEihjeF6a2sNG8AsvGEp2B2pmBjXm/MSmzgl9MbdM
         uk8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YEIwtglu4xRS3NnZPOYlcGRKf1k45KF06+ysr6r2J98=;
        b=DKMA2b/kD467riNAmRQ8D76BOCpqFOCsH1cXjcJxJBGj7qSOz1PVZREBtkT7cfM6jI
         Lse9R5vV+nrwYjDU3OSpQALEAFx9OZvFG/TLfARLGF8opb5+V97D+r1JywGWvSBojQSD
         kWh0oYFMHU6PPKkeQkctcdBcl1OkPVth/V+gfz7m0C0hRDupMPDxhJ4Ov9t1GkeJihTp
         XvejYqmdotWa7DVlXVWoWFgCF9O/avuKu7TVQIl0CVfjkqslFo1yfjUbqklhpa+K3130
         9Y+tqWGc46laLIFRsSfMuTV81vVzU+oQBy4VlKdQoLw8gSVnRnx7w5JveYcpHuKS3XqH
         w9+w==
X-Gm-Message-State: ANoB5pmjC5wlKjZpcvuUPUFLzpE9Asuu3kr9o62u/XnQF0zCN/6K5H5P
        DCt1Wd95XZgz2sHkwFqw3uXxOmwWB8ndxieODsv8SQ==
X-Google-Smtp-Source: AA0mqf72ZfSBCNRzoUNti6oVairUrG7R5l76S8dEZ8DYDFNwKW5D35G61hbCTErk4XBZHOblJ+zd3TmS/47G4MtGfnc=
X-Received: by 2002:a05:6830:18d3:b0:66c:dd29:813d with SMTP id
 v19-20020a05683018d300b0066cdd29813dmr22838138ote.312.1669835193468; Wed, 30
 Nov 2022 11:06:33 -0800 (PST)
MIME-Version: 1.0
References: <20221121182552.2152891-1-sdf@google.com> <20221121182552.2152891-3-sdf@google.com>
 <Y4eRtJOPWBOCKe1Q@lincoln>
In-Reply-To: <Y4eRtJOPWBOCKe1Q@lincoln>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Wed, 30 Nov 2022 11:06:22 -0800
Message-ID: <CAKH8qBtseOmsWmeprdRsvz0T=vAObYE_CpsYQOX0CsLR_iXNFA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 2/8] bpf: XDP metadata RX kfuncs
To:     Larysa Zaremba <larysa.zaremba@intel.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 30, 2022 at 9:38 AM Larysa Zaremba <larysa.zaremba@intel.com> wrote:
>
> On Mon, Nov 21, 2022 at 10:25:46AM -0800, Stanislav Fomichev wrote:
>
> > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > index 9528a066cfa5..315876fa9d30 100644
> > --- a/kernel/bpf/verifier.c
> > +++ b/kernel/bpf/verifier.c
> > @@ -15171,6 +15171,25 @@ static int fixup_call_args(struct bpf_verifier_env *env)
> >       return err;
> >  }
> >
> > +static int fixup_xdp_kfunc_call(struct bpf_verifier_env *env, u32 func_id)
> > +{
> > +     struct bpf_prog_aux *aux = env->prog->aux;
> > +     void *resolved = NULL;
>
> First I would like to say I really like the kfunc hints impementation.
>
> I am currently trying to test possible performace benefits of the unrolled
> version in the ice driver. I was working on top of the RFC v2,
> when I noticed a problem that also persists in this newer version.
>
> For debugging purposes, I have put the following logs in this place in code.
>
> printk(KERN_ERR "func_id=%u\n", func_id);
> printk(KERN_ERR "XDP_METADATA_KFUNC_RX_TIMESTAMP_SUPPORTED=%u\n",
>        xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_TIMESTAMP_SUPPORTED));
> printk(KERN_ERR "XDP_METADATA_KFUNC_RX_TIMESTAMP=%u\n",
>        xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_TIMESTAMP));
> printk(KERN_ERR "XDP_METADATA_KFUNC_RX_HASH_SUPPORTED=%u\n",
>        xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_HASH_SUPPORTED));
> printk(KERN_ERR "XDP_METADATA_KFUNC_RX_HASH=%u\n",
>        xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_HASH));
>
> Loading the program, which uses bpf_xdp_metadata_rx_timestamp_supported()
> and bpf_xdp_metadata_rx_timestamp(), has resulted in such messages:
>
> [  412.611888] func_id=108131
> [  412.611891] XDP_METADATA_KFUNC_RX_TIMESTAMP_SUPPORTED=108126
> [  412.611892] XDP_METADATA_KFUNC_RX_TIMESTAMP=108128
> [  412.611892] XDP_METADATA_KFUNC_RX_HASH_SUPPORTED=108130
> [  412.611893] XDP_METADATA_KFUNC_RX_HASH=108131
> [  412.611894] func_id=108130
> [  412.611894] XDP_METADATA_KFUNC_RX_TIMESTAMP_SUPPORTED=108126
> [  412.611895] XDP_METADATA_KFUNC_RX_TIMESTAMP=108128
> [  412.611895] XDP_METADATA_KFUNC_RX_HASH_SUPPORTED=108130
> [  412.611895] XDP_METADATA_KFUNC_RX_HASH=108131
>
> As you can see, I've got 108131 and 108130 IDs in program,
> while 108126 and 108128 would be more reasonable.
> It's hard to proceed with the implementation, when IDs cannot be sustainably
> compared.

Thanks for the report!
Toke has reported a similar issue in [0], have you tried his patch?
I've also tried to address it in v3 [1], could you retry on top of it?
I'll try to insert your printk in my local build to see what happens
with btf ids on my side. Will get back to you..

0: https://lore.kernel.org/bpf/87mt8e2a69.fsf@toke.dk/
1: https://lore.kernel.org/bpf/20221129193452.3448944-3-sdf@google.com/T/#u

> Furthermore, dumped vmlinux BTF shows the IDs is in the exactly reversed
> order:
>
> [108126] FUNC 'bpf_xdp_metadata_rx_hash' type_id=108125 linkage=static
> [108128] FUNC 'bpf_xdp_metadata_rx_hash_supported' type_id=108127 linkage=static
> [108130] FUNC 'bpf_xdp_metadata_rx_timestamp' type_id=108129 linkage=static
> [108131] FUNC 'bpf_xdp_metadata_rx_timestamp_supported' type_id=108127 linkage=static
>
> > +
> > +     if (func_id == xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_TIMESTAMP_SUPPORTED))
> > +             resolved = aux->xdp_netdev->netdev_ops->ndo_xdp_rx_timestamp_supported;
> > +     else if (func_id == xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_TIMESTAMP))
> > +             resolved = aux->xdp_netdev->netdev_ops->ndo_xdp_rx_timestamp;
> > +     else if (func_id == xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_HASH_SUPPORTED))
> > +             resolved = aux->xdp_netdev->netdev_ops->ndo_xdp_rx_hash_supported;
> > +     else if (func_id == xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_HASH))
> > +             resolved = aux->xdp_netdev->netdev_ops->ndo_xdp_rx_hash;
> > +
> > +     if (resolved)
> > +             return BPF_CALL_IMM(resolved);
> > +     return 0;
> > +}
> > +
>
> My working tree (based on this version) is available on github [0]. Situation
> is also described in the last commit message.
> I would be great, if you could check, whether this behaviour can be reproduced
> on your setup.
>
> [0] https://github.com/walking-machine/linux/tree/hints-v2
