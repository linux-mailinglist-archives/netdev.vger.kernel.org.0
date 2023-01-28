Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AE0167FB2A
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 22:35:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230336AbjA1VfK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 16:35:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230303AbjA1VfH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 16:35:07 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A92318162;
        Sat, 28 Jan 2023 13:35:05 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id n6so5059996edo.9;
        Sat, 28 Jan 2023 13:35:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+zXK+884dLrmhawA8xRQQwxUqchG7ZiNECezW2lOgQA=;
        b=BVhIi1wAHrJT0sZHx5IKQ6ERyLetJwEsTCVKMe8T2grAtiQV7QwxvxHEmv6xsJAwdF
         ZjdJF6jjhLdVv89FR55E2mr7soSxcX/14NJjeSkf4/fxXxZDulGyIyUJxu3ZquRtjz2G
         XW8MQAVmxxM3Vl74UhsCHjfDx+CnMggGvKtlm406tSyFBqQ+JZijnEBmkgYkoXdbJRyd
         yQ3d6k2fTNJ++nPFl3MpC1tdnjGXp1MU6N2WZW7TgLL7VQTJzMhqLYAtvSXCRxYlJSAt
         UwufJzQ5QuvrmwBtpfOPcIluWAqJ+1OfWPnZ1fR9JE1IooIaT+JCmWpdNWghdh/+eng5
         Dqhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+zXK+884dLrmhawA8xRQQwxUqchG7ZiNECezW2lOgQA=;
        b=HpfVrLsKjzjVKAJjd8AsP0J8fJsxn35tAD/BDuZceBXkjAtEQIC2uNVV1YE/B3JTNe
         Ha7+ZpoAM8pcbi1/MAeAwN6wLIHPZyw1VZxMf1Pc3d4KAeOGgcwrJVdTOdseJam9QM9W
         VZpdrGz1xK3oaRJ/dqN+NGndg2lvEeqG9WEQ1v87/Qhl3CbP55iJNtjmcjXYCWdfhl1H
         sciTxF+MX9H1r6zlwmOrHfkIWVxT0NMgMBvl8dFv8CTBNWHXu5NKMYPF7P3E3DEKX+YK
         7Bs0QXFwgq4DjEEP7z/G6Pu7GFtk9iGMWG94BGFlnhaTvoZue5jcrKWMX8tQ67njrg4K
         QZSw==
X-Gm-Message-State: AFqh2kq6km9aQK1xN73Bnv7ShBtQLOOj7rZ3yX5u116PVFLq4VdSTKre
        KF1PXoVlTEpcQTaKPpOZRq4BykhQRg1tQFtV+IS4Dgqs
X-Google-Smtp-Source: AMrXdXsZzarXZgPPZ/o1qFc85WWamUoar/+dUFn/SXh0NavSmkBXF2uugGK4uBHZdiG1JciMajqTm514M4a/kJkg/Jo=
X-Received: by 2002:a05:6402:3814:b0:49e:6501:57a2 with SMTP id
 es20-20020a056402381400b0049e650157a2mr6932183edb.43.1674941703860; Sat, 28
 Jan 2023 13:35:03 -0800 (PST)
MIME-Version: 1.0
References: <cover.1674913191.git.lorenzo@kernel.org> <a7eaa7e3e4c0a7e70f68c32314a7f75c9bba4465.1674913191.git.lorenzo@kernel.org>
In-Reply-To: <a7eaa7e3e4c0a7e70f68c32314a7f75c9bba4465.1674913191.git.lorenzo@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sat, 28 Jan 2023 13:34:52 -0800
Message-ID: <CAADnVQJhdxM6eqvxRZ7JjxEc+fDG5CwnV_FAGs+H+djNye0e=w@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 8/8] selftests/bpf: introduce XDP compliance
 test tool
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Marek Majtyka <alardam@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>, anthony.l.nguyen@intel.com,
        Andy Gospodarek <gospo@broadcom.com>, vladimir.oltean@nxp.com,
        Felix Fietkau <nbd@nbd.name>, john@phrozen.org,
        Leon Romanovsky <leon@kernel.org>,
        Simon Horman <simon.horman@corigine.com>,
        Ariel Elior <aelior@marvell.com>,
        christophe.jaillet@wanadoo.fr, ecree.xilinx@gmail.com,
        "Michael S. Tsirkin" <mst@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Stanislav Fomichev <sdf@google.com>
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

On Sat, Jan 28, 2023 at 6:07 AM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
> diff --git a/tools/testing/selftests/bpf/xdp_features.h b/tools/testing/selftests/bpf/xdp_features.h
> new file mode 100644
> index 000000000000..28d7614c4f02
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/xdp_features.h
> @@ -0,0 +1,33 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +
> +/* test commands */
> +enum test_commands {
> +       CMD_STOP,               /* CMD */
> +       CMD_START,              /* CMD + xdp feature */
> +       CMD_ECHO,               /* CMD */
> +       CMD_ACK,                /* CMD + data */
> +       CMD_GET_XDP_CAP,        /* CMD */
> +       CMD_GET_STATS,          /* CMD */
> +};
> +
> +#define DUT_CTRL_PORT  12345
> +#define DUT_ECHO_PORT  12346
> +
> +struct tlv_hdr {
> +       __be16 type;
> +       __be16 len;
> +       __be32 data[];
> +};
> +
> +enum {
> +       XDP_FEATURE_ABORTED,
> +       XDP_FEATURE_DROP,
> +       XDP_FEATURE_PASS,
> +       XDP_FEATURE_TX,
> +       XDP_FEATURE_REDIRECT,
> +       XDP_FEATURE_NDO_XMIT,
> +       XDP_FEATURE_XSK_ZEROCOPY,
> +       XDP_FEATURE_HW_OFFLOAD,
> +       XDP_FEATURE_RX_SG,
> +       XDP_FEATURE_NDO_XMIT_SG,
> +};

This doesn't match the kernel.
How did you test this?
What should be the way to prevent such mistakes in the future?
