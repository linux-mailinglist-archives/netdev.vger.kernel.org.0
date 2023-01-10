Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A977F664613
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 17:30:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233077AbjAJQaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 11:30:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233017AbjAJQaP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 11:30:15 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EC4769B3A
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 08:30:13 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id d15so13736687pls.6
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 08:30:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4g3X2Drb8iDIejSiH0zFfNh5MOmbpVh8uX0CGV33Ygw=;
        b=jie1h2bF6T0loL1kylf5SLvyS0ttCfxL/U79701D7Jc+1IkfwixBN4MpGFNc441I8n
         rl0JBa3hUIvLS36GCdBIOkhpDcy/IDVIRWp/yuSg7PBI5ZSeQGLc7GZdZZgOKi+pYn0C
         HTRafMDZ1/gTGXGHjLx51tT+oXyMQxAoExxDwWKMu+++bGjk/5umgA8bQERjXhqxXTRy
         Q9uLnPmQ95UgBpIOzxuMsD6nfq/g9vJjvXaGHSOn42vQFuUVv2v8Y65qSxqIntgEXMLY
         0eahvmjKtp0NDUvPgAIpo38znxs8UvEjKhKVEiFgKQ6tmpjKA3pplJfAAcTpVJ3Ija0e
         kXNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4g3X2Drb8iDIejSiH0zFfNh5MOmbpVh8uX0CGV33Ygw=;
        b=3Vl+XlIkJ3oBCtaKHCBnvUfdZsiVuwvqpr0BbE5n17yYuMFkQLi1hlwh4GElTy1P5i
         iHq969tTbDFDMVrDNcJufEezXfAS/tnwlsT/Ms1RkJlWRt7JX7LqGPkjxfmrubUVHIaB
         ogkOEKbWdv6OMHy6wqGYss/bH6QP5tb5Xotymz3anALHzBwtOCovnixYdQOi/gNY60L1
         QEi0OKOqF9KkoJASeZX3xR+/Q5Lzpr/PquBF3PKdzM4+VG+KidpA0gFC25Gy+zgn0hjZ
         uwCOv7VfIffYhd19qSVB2XUjsmTzF3mrNINNSCaEPW5HSDL/2EMNttBD/a2yEqsrjJ5U
         RQ7A==
X-Gm-Message-State: AFqh2kpCpVwnxTFsOoGFeuz87rnozCXxrm0YPHL1TKKcFqA904n6Rt97
        CGJoO74tB9Fkj4dYle48RseVHpMHsRzpfqQMjYuzdQ==
X-Google-Smtp-Source: AMrXdXsXyTXOJDg2HvTe03JJzllkrApnnxWjeSXx+w/qB5rYUlhFrZp6dWVQvcOJHGx4CRPsdXmaHQ==
X-Received: by 2002:a17:90b:3557:b0:219:bd64:8e60 with SMTP id lt23-20020a17090b355700b00219bd648e60mr73264459pjb.34.1673368213082;
        Tue, 10 Jan 2023 08:30:13 -0800 (PST)
Received: from localhost (thunderhill.nvidia.com. [216.228.112.22])
        by smtp.gmail.com with ESMTPSA id y7-20020a17090a154700b002265ddfc13esm3213456pja.29.2023.01.10.08.30.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jan 2023 08:30:12 -0800 (PST)
Date:   Tue, 10 Jan 2023 17:30:09 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Kees Cook <keescook@chromium.org>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] net/mlx5e: Replace 0-length array with flexible array
Message-ID: <Y72SkdnBkwxQYXoT@nanopsycho>
References: <20230105223642.never.980-kees@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230105223642.never.980-kees@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jan 05, 2023 at 11:36:43PM CET, keescook@chromium.org wrote:
>Zero-length arrays are deprecated[1]. Replace struct mlx5e_rx_wqe_cyc's
>"data" 0-length array with a flexible array. Detected with GCC 13,
>using -fstrict-flex-arrays=3:
>
>drivers/net/ethernet/mellanox/mlx5/core/en_main.c: In function 'mlx5e_alloc_rq':
>drivers/net/ethernet/mellanox/mlx5/core/en_main.c:827:42: warning: array subscript f is outside array bounds of 'struct mlx5_wqe_data_seg[0]' [-Warray-bounds=]
>  827 |                                 wqe->data[f].byte_count = 0;
>      |                                 ~~~~~~~~~^~~
>In file included from drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h:11,
>                 from drivers/net/ethernet/mellanox/mlx5/core/eswitch.h:48,
>                 from drivers/net/ethernet/mellanox/mlx5/core/en_main.c:42:
>drivers/net/ethernet/mellanox/mlx5/core/en.h:250:39: note: while referencing 'data'
>  250 |         struct mlx5_wqe_data_seg      data[0];
>      |                                       ^~~~
>
>[1] https://www.kernel.org/doc/html/latest/process/deprecated.html#zero-length-and-one-element-arrays
>
>Cc: Saeed Mahameed <saeedm@nvidia.com>
>Cc: Leon Romanovsky <leon@kernel.org>
>Cc: "David S. Miller" <davem@davemloft.net>
>Cc: Eric Dumazet <edumazet@google.com>
>Cc: Jakub Kicinski <kuba@kernel.org>
>Cc: Paolo Abeni <pabeni@redhat.com>
>Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
>Cc: netdev@vger.kernel.org
>Cc: linux-rdma@vger.kernel.org
>Signed-off-by: Kees Cook <keescook@chromium.org>


Reviewed-by: Jiri Pirko <jiri@nvidia.com>
