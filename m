Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2612A6916AE
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 03:29:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbjBJC3z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 21:29:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbjBJC3x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 21:29:53 -0500
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE89127D41
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 18:29:52 -0800 (PST)
Received: by mail-qv1-xf2f.google.com with SMTP id d8so2741762qvs.4
        for <netdev@vger.kernel.org>; Thu, 09 Feb 2023 18:29:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=m6yNHmhE9i1P8ZsD1j2Z+7+yov5m6fJFCTU3kWOqzFs=;
        b=MnuGueky9U2jrbqsbn+HuShTtse3EjvNnzBZI5HlBHit0+3zd2rr7nXPhmfoycjxOd
         IJ0h45axqs9D1SRbV10fVhAy0kLMAcI/E438zNGp/I1dKbSgLj+NgwBQVv2I5oOVtmhD
         SfG83pK/WRytHtRXYjH+zMxaGj4QOvHnM5YUZVKYEIlH2Z0j2GFBim+wxgHcKkHv/oLu
         UMpvyAtY+CsC34rDJLBY0t351zc7EVQA5tV6D6BJ+BJZyw3wgBx96cuo1NTEToF+dRhq
         X1IvHVKvmklJa97uJj5M9fblKyeUNq5sgX5AqbUgxgAStlSW5txb5CteSv/JTkl7NiQo
         /mvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m6yNHmhE9i1P8ZsD1j2Z+7+yov5m6fJFCTU3kWOqzFs=;
        b=tacHTANPZh2GoxvWA4IgkxPp+AhmBcXKzektS+cPq7Rp9rlNZEWtg8Yfv+x0MGT8yL
         ZcfYa1MRpyCGFj8G04bORuOArnUiJ0uRGTZgfForlmHohozQWXZ1LG/wS5PiJatzPKAl
         vCq0xGiTK0tj1EHHIO0jrd4o6MTtEj/o8FPtnOMkbpyLC+wleWgn5hBI+/M6Ff+YZ045
         vQ3l5Q1Gi68MGJJWMMPAjr2dK4GU9OM9mD5pQWPd/KTeG1xLOatfCMufGqC8axEubEJd
         42y/5+ftfi/F7ZsHVbk6+dKbiUPStETHjMTFgtQpdcYPuyev/OhlFVZZurzelK/nFDLl
         0y7A==
X-Gm-Message-State: AO0yUKVQhK/sLlR6snMqAG8XsCks1Vtk8KP2zfZhRK2MGNoHtvCDxO3r
        kDvivAR7YA24JHhbxIy7/d0=
X-Google-Smtp-Source: AK7set+sqQE+6X6n3TfBIEni5AflXDrmKvTB+h5o8U7pPLxYknpri12M3mLmv/k7RbA5nBJu0hUX7g==
X-Received: by 2002:a05:6214:b61:b0:56c:25dd:f72a with SMTP id ey1-20020a0562140b6100b0056c25ddf72amr10386737qvb.14.1675996191914;
        Thu, 09 Feb 2023 18:29:51 -0800 (PST)
Received: from t14s.localdomain (rrcs-24-43-123-84.west.biz.rr.com. [24.43.123.84])
        by smtp.gmail.com with ESMTPSA id h186-20020a376cc3000000b007023fc46b64sm2526844qkc.113.2023.02.09.18.29.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 18:29:51 -0800 (PST)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id 453564C1EC0; Thu,  9 Feb 2023 18:29:50 -0800 (PST)
Date:   Thu, 9 Feb 2023 18:29:50 -0800
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Paul Blakey <paulb@nvidia.com>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Oz Shlomo <ozsh@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: Re: [PATCH net-next v9 4/7] net/mlx5: Kconfig: Make tc offload
 depend on tc skb extension
Message-ID: <20230210022950.2damcxolr54x22es@t14s.localdomain>
References: <20230206174403.32733-1-paulb@nvidia.com>
 <20230206174403.32733-5-paulb@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230206174403.32733-5-paulb@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 06, 2023 at 07:44:00PM +0200, Paul Blakey wrote:
> Tc skb extension is a basic requirement for using tc
> offload to support correct restoration on action miss.

Btw, this is great. There was at least 1 report on ovn upstream
because the person didn't know skb extensions had to be manually
enabled.
