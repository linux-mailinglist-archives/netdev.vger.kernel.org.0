Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24EE16762AD
	for <lists+netdev@lfdr.de>; Sat, 21 Jan 2023 02:19:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbjAUBTo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 20:19:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjAUBTn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 20:19:43 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 487276E835;
        Fri, 20 Jan 2023 17:19:42 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id hw16so18029891ejc.10;
        Fri, 20 Jan 2023 17:19:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=FatV2ooNHBvjqYFSo0t+gNzMShU2FV8trQScCRgC2dg=;
        b=hzERaXp3nKDHOPSB9YrMhvWbGPRd2uTE3nSrb/icVY++w5FhEBMBszcHkL0TSAWLWo
         LHQZaQuqyzjFVggaRvIpsBpU3r2eOZYRSOHCLDqujpVqJChcHVU2+ZpuAuQeBcH5z62y
         3TI/bLtTejD8fkz3JrRxxJUj7LtpVGWku5amWxJSHIUZAA3uIuQDoP2c0JDYB3xuDREg
         zhDAheciFJ4VLgfgPgFJ1zc3OUYff3JewfuF5Ev3euskk0XAyqWIjDlj7NgGI96kZeiM
         Jpx0SxKYgQiDKtc2OCM05JO8MXyIfFvAktpgX1wOPSm3lLJDoswkQf25m/A2tM+dlh6F
         Ojnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FatV2ooNHBvjqYFSo0t+gNzMShU2FV8trQScCRgC2dg=;
        b=AW12H5N1Wx0qU5GIlC9uryYSX4sbFUPqbNTFghyNo9b5G6CkrKHUVNNoAYgr5onpDP
         SgeykKg25aK0HTrjTAsLQ/40Fal74SpZAL3qp0Fpa4D2JwqilBNB8KWfXKN8kyrgrGIr
         ZABAcRzHPkTPdCtdziVrlAlI/voRrycrJuN7bjH3TxmMJz5CXvoF8zZnVU14So7S9XB9
         7AghcUzQ8T5LTrSNHRGWT30384Ii084pUszMeRjeMqMOkEbcTuYhmaxlC479gkSry9bg
         juGBFah2xnpUX+LXSPlesDJxcbAuiJxhfLWkZjGagJO0xw+1fdM8APmwPxC1gZqYQcv6
         OGzw==
X-Gm-Message-State: AFqh2koA05lEA3CMtS/eWHtc6iGIpiaHvjfRqozHfcvYETRiCyL6VT9V
        amS9FsIbwp2thpz61pOYsu7H2asSHbGx6Cg1tUw=
X-Google-Smtp-Source: AMrXdXsrrUz0aXWE5rx97cC0zoI4WVGpHceIKYsbtVzuG1Uw8lkA+6nrnlmHvi3awhBYNMtiBhhjzietOCamER+MO6Q=
X-Received: by 2002:a17:906:cf9b:b0:872:a7ee:f4c7 with SMTP id
 um27-20020a170906cf9b00b00872a7eef4c7mr1669038ejb.378.1674263980703; Fri, 20
 Jan 2023 17:19:40 -0800 (PST)
MIME-Version: 1.0
References: <cover.1674234430.git.lorenzo@kernel.org> <272fa19f57de2d14e9666b4cd9b1ae8a61a94807.1674234430.git.lorenzo@kernel.org>
In-Reply-To: <272fa19f57de2d14e9666b4cd9b1ae8a61a94807.1674234430.git.lorenzo@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 20 Jan 2023 17:19:29 -0800
Message-ID: <CAADnVQLHsV2Y-UiDkEnhwnfvgRxGN4OY8mwi_p-a01WUTdDBNw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/7] netdev-genl: create a simple family for
 netdev stuff
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Marek Majtyka <alardam@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>, anthony.l.nguyen@intel.com,
        Andy Gospodarek <gospo@broadcom.com>, vladimir.oltean@nxp.com,
        Felix Fietkau <nbd@nbd.name>, john@phrozen.org,
        leon@kernel.org, Simon Horman <simon.horman@corigine.com>,
        Ariel Elior <aelior@marvell.com>,
        christophe.jaillet@wanadoo.fr, ecree.xilinx@gmail.com,
        "Michael S. Tsirkin" <mst@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        =?UTF-8?Q?Niklas_S=C3=B6derlund?= <niklas.soderlund@corigine.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 20, 2023 at 9:17 AM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
> +
> +#define NETDEV_XDP_ACT_BASIC           (NETDEV_XDP_ACT_DROP |  \
> +                                        NETDEV_XDP_ACT_PASS |  \
> +                                        NETDEV_XDP_ACT_TX |    \
> +                                        NETDEV_XDP_ACT_ABORTED)

Why split it into 4?
Is there a driver that does a subset?
