Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 034416EA01A
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 01:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231561AbjDTXlh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 19:41:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231611AbjDTXlf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 19:41:35 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD3DBE65;
        Thu, 20 Apr 2023 16:41:32 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id a640c23a62f3a-95369921f8eso129495366b.0;
        Thu, 20 Apr 2023 16:41:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682034091; x=1684626091;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S9yOHMtl85I476Bn6r/OiNimXmtYfDUVlhXhwEOq7mg=;
        b=CNa7Vcv65eGNBqM5io3qM2eHoX8aJ912DXc59C63fqQXNr4bI0sMgAFyZl16XnY0UZ
         1A72u4dvtPu6mi8F3qFlBjMOt9eGZ0lHQf/R1qHB2YDZXJXLHwTOmNRsJCzWqXBrRRKX
         gvBLDOoVu/CFAVd8H+uffz0sej+f2mqxzcHGuHAmbNKnZmnALagsuFKMzEKKiAKQ7uyt
         znJ3yMUt00eGeQoBCpTD0F9jrskhd+YdrIyNsmbZ5a05n+3dYlSSjyDkIZso3Y01XtCT
         7CeOhDDduDPhU3u60MbgT8l6FS6Z0poTa6+doUEmosDAF+Ey+y7YunMx4gqbCPUDRgqd
         Uuow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682034091; x=1684626091;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S9yOHMtl85I476Bn6r/OiNimXmtYfDUVlhXhwEOq7mg=;
        b=YefHpy7K3uEmNFeBIjXNKmRtghNDb3vxFRure8Mb0pKNr/iCU327rsE2hjGRvfOaTs
         NCelqOqkOi5mu10UTPmjEf0Bu34qWJZuFGjG56UF9GFmGFSeH3EdfdjxyIaxWUKcvUxX
         Pyva3vztvNe2NijSRlbqUfWBDUwYW41dBhTwuzFCK8QSnmwREgyRdjk+p3f0cIuz0D1s
         3c+uqFhNERi3hY3sjmsZEX3igasF6MSi4YmVYCLojTQOfd+d8X4GtXZXSA4pyx1lcnsL
         nrXNFK5qsJGQfMDG3Okmy9rxVUusPjlFQ9kFcVu1eRNV2QlzoMPLdaGJeIbn8N42KXIK
         24Cg==
X-Gm-Message-State: AAQBX9dV+EBZ5fu/uqrMyIlMOqz4j27xx4H3lukLjZxVRg11wgDzJ61L
        FzvvAR0NJiXglef6TKFxnQbBV/fbYeA9VtrvVb8=
X-Google-Smtp-Source: AKy350ZzTQeMVSZMf+7DTdPOngtlbLWpQVJ/qdk7gHUULkVWQh55LMLs67bhgE4T26yCcEgmSypEAEaT8NYi2Jj2kkY=
X-Received: by 2002:a17:907:86a8:b0:94f:99:858e with SMTP id
 qa40-20020a17090786a800b0094f0099858emr308655ejc.3.1682034090876; Thu, 20 Apr
 2023 16:41:30 -0700 (PDT)
MIME-Version: 1.0
References: <20230410120629.642955-1-kal.conley@dectris.com>
 <CAJ8uoz1CmRNMdTu3on7VL2Jrvo9z3WvdmFE_hSEiZDLiO-xtFw@mail.gmail.com> <CAHApi-=UJz04Acq+4O+v7ZprkoBH=aRB01Ug1i5Y1PLz58DbAA@mail.gmail.com>
In-Reply-To: <CAHApi-=UJz04Acq+4O+v7ZprkoBH=aRB01Ug1i5Y1PLz58DbAA@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 20 Apr 2023 16:41:19 -0700
Message-ID: <CAADnVQLxKJJZe4dmn5Rg76n=6UwM5aHbKeB6ke55aho5iGC+-g@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 0/4] xsk: Support UMEM chunk_size > PAGE_SIZE
To:     Kal Cutter Conley <kal.conley@dectris.com>
Cc:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Tariq Toukan <tariqt@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 12, 2023 at 11:47=E2=80=AFAM Kal Cutter Conley
<kal.conley@dectris.com> wrote:
>
> > Thank you so much Kal for implementing this feature. After you have
> > fixed the three small things I had for patch #2, you have my ack for
> > the whole set below. Please add it.
> >
> > For the whole set:
> > Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
> >
> > It would be great if you have the time and desire to also take this to
> > zero-copy mode. I have had multiple AF_XDP users mailing me privately
> > that such a feature would be very useful for them. For some of them it
> > was even a requirement to be able to get down to the latencies they
> > were aiming for.
>
> Yes. We need this to work with zero-copy so next I will look into
> implementing this for the mlx5 driver since it has to work for us on
> Mellanox adapters.

My understanding is that the v6 version of this set is good to go.
Unfortunately it gained a merge conflict while sitting in patchwork.
Please respin with all acks.
