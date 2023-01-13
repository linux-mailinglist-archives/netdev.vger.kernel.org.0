Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEBD56696FB
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 13:29:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241466AbjAMM3m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 07:29:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241670AbjAMM3I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 07:29:08 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1475E9D;
        Fri, 13 Jan 2023 04:27:59 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id x10so28067020edd.10;
        Fri, 13 Jan 2023 04:27:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Vk0yjinYi11wMINqZ2+kq9INzPvs5irLkG1ndhJJPO8=;
        b=i3Uz+ksBCp9ibaJFHUYzhM0jjYmjGu2aDWCJnPbmDwBZkQA0tzeLsRZtRZcO0F0slz
         4iDAkykONzfLMjztDDm/KiBp7EgEUBFBBmOEW75PmA9cFt2247141GmcmY+FhZi6IhI1
         JQJ/G5YcHjLCZIbTZ8YJR+aPfOtnljp5gv+hFxQMHYI01960T83TZR48Nd5hVvPS7zxc
         oeQ/jLzAgrG0KeZgb0+98AbhPxZEJCamW3C0x+M/0e/tL6G2Q1BF3awEdJqWkll1Lu1l
         SfZNFhQR5QZfjyE32q6NNdEYEcZKe/8jkN+BQyyuxhguAaKHQdMNTg2LU+rnHUFyKZqI
         Sw0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vk0yjinYi11wMINqZ2+kq9INzPvs5irLkG1ndhJJPO8=;
        b=F0mbWN5kO9WcmhHTNs1Svqt+8p9RvTTftJr313zCI9dm1YmOEPvcn0A9RcS29Tl+Cr
         0PjCLjhuKwlG1oL6Lkim4Vd+FlKeLcRGvv25BLD82CRDW71r0/xQBFsN4g5gIpDOgkPm
         /yqPxlB1OXi29Tu4TneE1QnYJ9fqA5mAuSFUMDywzVcw16GzA9sDsoTz50/mDsKuZN/N
         oeE3ATqAa4LnaHMB+y9C3D5QUZ8YVcTRc7Y57+P/+/eSUmHHr/B0ls/H7pY2tuvsMDoy
         S5n1VL/RsowtNj5VOa4NeuVIL49WrnnD2DZN+z/jxWAzdUWSySw7FKN/9IuL/c42Uh7u
         GyHA==
X-Gm-Message-State: AFqh2kqMLPXsktw6J1tMIpqltinWaYDjHbrXvrMCz+CnVpnDS1ziZz/R
        Kt7NadTWb00c13h5EYvlxh8=
X-Google-Smtp-Source: AMrXdXti9ircSYqRPXI88lrCbXrg2tYnkg1QGLFHTbX37vu371320C4ZsC/eaQ5hAcC8fDopNtEa8Q==
X-Received: by 2002:aa7:c407:0:b0:49b:67c3:39ae with SMTP id j7-20020aa7c407000000b0049b67c339aemr4379247edq.33.1673612877506;
        Fri, 13 Jan 2023 04:27:57 -0800 (PST)
Received: from skbuf ([188.26.184.223])
        by smtp.gmail.com with ESMTPSA id f9-20020a056402068900b0048999d127e0sm8089914edy.86.2023.01.13.04.27.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 04:27:57 -0800 (PST)
Date:   Fri, 13 Jan 2023 14:27:54 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Lukasz Majewski <lukma@denx.de>
Cc:     Andrew Lunn <andrew@lunn.ch>, Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/3] dsa: marvell: Provide per device information
 about max frame size
Message-ID: <20230113122754.52qvl3pvwpdy5iqk@skbuf>
References: <20230106101651.1137755-1-lukma@denx.de>
 <20230106101651.1137755-1-lukma@denx.de>
 <20230106145109.mrv2n3ppcz52jwa2@skbuf>
 <20230113131331.28ba7997@wsk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230113131331.28ba7997@wsk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 13, 2023 at 01:13:31PM +0100, Lukasz Majewski wrote:
> I think that this commit [1], made the adjustment to fix yet another
> issue.
> [1] -
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=b9c587fed61cf88bd45822c3159644445f6d5aa6

It appears that this is the commit to blame, indeed.

> It looks like the missing 8 bytes are added in the
> mv88e6xxx_change_mtu() function.

Only for DSA and CPU ports. The driver still behaves as if the max MTU
on user ports is 1492 bytes.

> > I wonder, shouldn't we first fix that, and apply this patch set
> > afterwards?
> 
> IMHO, it is up to Andrew to decide how to proceed, as the
> aforementioned patch [1] is an attempt to fix yet another issue [2].
> [2] -
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=1baf0fac10fbe3084975d7cb0a4378eb18871482

I think the handling for those switches were neither port_set_jumbo_size()
nor set_max_frame_size() is present is just a roundabout way of saying
"hey, I only support ETH_DATA_LEN MTU and can't change it, leave me alone".
But it isn't what the code does.
