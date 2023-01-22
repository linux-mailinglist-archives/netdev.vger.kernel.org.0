Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 947AF676B82
	for <lists+netdev@lfdr.de>; Sun, 22 Jan 2023 08:58:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbjAVH6V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Jan 2023 02:58:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbjAVH6U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Jan 2023 02:58:20 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E57314E8F;
        Sat, 21 Jan 2023 23:58:19 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id n7so8215122wrx.5;
        Sat, 21 Jan 2023 23:58:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UtvB/1OAltPp8ep+yE5hEos3of6mRbHb0MfQz+yXAOM=;
        b=ZedCJTstKPmW5+0xrac7liK+XeWAlSobYSDYL+/jkkQln7+l/tb9KrDju0NwEG60IR
         rmEku8tcqAJcTfEkx4o0NCLszC33YKa5MFIrtnoCqLdZOZRj0nxs2/O6+ewhgoq2Qls2
         HchbU3xHvlmPjqiJV9BvsxSWAiTTFn/WDH+5kQ0Xya+KYWGMOPceanlpqRTkJpkSymMU
         WY/+SoajVDbcEA6HHXd2g4Fj8hDbwYW2PNwIcYjIogdiC2sSa5bv+v3Q23UoRD6b3IbW
         4iIfa9Q+GelCpoVJcT9mSX0QegvIx5HrnCywBkOxCca0Dh65IjdL9sIg224Jn9eY8s+/
         n8sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UtvB/1OAltPp8ep+yE5hEos3of6mRbHb0MfQz+yXAOM=;
        b=hWtxIyy854PxFDQzilf4VjjgRTsyD2ShNjQvTyBbxsJrTTw4rnnWSUf6xFpAEnrPA3
         0G2oXXZ80DBdj/x4iZi3NiuxTUOsucRKrIxDnfHBLrmUDaGTNHI5ysohA14/3+k0I9O+
         VRMV6U0+0Qe4m9Fdq1hptPFUrCQioXGr5C+prHIaBjUzwmoDyZ24Jt5J2PRRCtn76UsH
         uWhiYfoOTyZnd23OF2Ns2yRImJgk4EmRpmLIQ/aJmqxOQvWHhpfiLTeaDp6YOUPjflHe
         lQrjXEEFxOXXAf9xxQh0pwF6icLorUIqgw3FtQo4UfVD1RhOLAdETDIZtdBtKnakvOhk
         AZSg==
X-Gm-Message-State: AFqh2kriIqrEWL6IQvJ757C4OC3QrYweaLTMwHnmLsURAPChh0beLSlq
        dPsTr0pNYbezWMYBSQJPPe8=
X-Google-Smtp-Source: AMrXdXujVghBXsF/idOR/W5o2d93J19zSWyra+CbIqNq/tTSjg2Nv/UsLhUsvu3YSVKDoCTsMaGJNg==
X-Received: by 2002:a5d:6b85:0:b0:2bd:d782:c2bc with SMTP id n5-20020a5d6b85000000b002bdd782c2bcmr18010546wrx.33.1674374298034;
        Sat, 21 Jan 2023 23:58:18 -0800 (PST)
Received: from [192.168.0.103] ([77.126.105.148])
        by smtp.gmail.com with ESMTPSA id e20-20020a5d5954000000b002be099f78c0sm15581609wri.69.2023.01.21.23.58.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 21 Jan 2023 23:58:17 -0800 (PST)
Message-ID: <5bedd805-34a6-61cd-c460-323be7d49f24@gmail.com>
Date:   Sun, 22 Jan 2023 09:58:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH bpf-next v8 16/17] net/mlx5e: Support RX XDP metadata
To:     Stanislav Fomichev <sdf@google.com>, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, haoluo@google.com,
        jolsa@kernel.org,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
References: <20230119221536.3349901-1-sdf@google.com>
 <20230119221536.3349901-17-sdf@google.com>
Content-Language: en-US
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <20230119221536.3349901-17-sdf@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 20/01/2023 0:15, Stanislav Fomichev wrote:
> From: Toke Høiland-Jørgensen <toke@redhat.com>
> 
> Support RX hash and timestamp metadata kfuncs. We need to pass in the cqe
> pointer to the mlx5e_skb_from* functions so it can be retrieved from the
> XDP ctx to do this.
> 
> Cc: Tariq Toukan <tariqt@nvidia.com>
> Cc: Saeed Mahameed <saeedm@nvidia.com>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Martin KaFai Lau <martin.lau@linux.dev>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Willem de Bruijn <willemb@google.com>
> Cc: Jesper Dangaard Brouer <brouer@redhat.com>
> Cc: Anatoly Burakov <anatoly.burakov@intel.com>
> Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
> Cc: Magnus Karlsson <magnus.karlsson@gmail.com>
> Cc: Maryam Tahhan <mtahhan@redhat.com>
> Cc: xdp-hints@xdp-project.net
> Cc: netdev@vger.kernel.org
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>   drivers/net/ethernet/mellanox/mlx5/core/en.h  |  5 +-
>   .../net/ethernet/mellanox/mlx5/core/en/txrx.h |  5 ++
>   .../net/ethernet/mellanox/mlx5/core/en/xdp.c  | 28 ++++++++++
>   .../net/ethernet/mellanox/mlx5/core/en/xdp.h  |  4 ++
>   .../ethernet/mellanox/mlx5/core/en/xsk/rx.c   | 14 +++++
>   .../ethernet/mellanox/mlx5/core/en/xsk/rx.h   |  2 +
>   .../net/ethernet/mellanox/mlx5/core/en_main.c |  1 +
>   .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 51 ++++++++++---------
>   8 files changed, 84 insertions(+), 26 deletions(-)
> 

Thanks for your patches.
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

