Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7793350D66E
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 03:01:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240066AbiDYBEl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 21:04:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235292AbiDYBEk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 21:04:40 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99F0B3DDFC
        for <netdev@vger.kernel.org>; Sun, 24 Apr 2022 18:01:37 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id n18so23582236plg.5
        for <netdev@vger.kernel.org>; Sun, 24 Apr 2022 18:01:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=wPm01GHjG1A3jBVuhE3t6MH7VFUSZydHeAlMfIYMkLg=;
        b=SrDCENVRdcNgTqW1oLAjK078Rnj/18J/OMxLYW1IZ/S45a2o6q4jdkqDY4Kw119XDd
         j7OZL7ormWxMYUFJDy9OoQCzmoYISbbis/IVTKFKoomj0WdS1YtoFuqKZiFg3rnQqETN
         8QriuPYsdbTkN6BELOSiEPTjyTxwHC0Dqd0+QR37H5it2An72hLNfaJK3J+Wz2NyONrM
         ZdtCRbSm0Ajic0mso28Clcl7rlUbaknxoZ33Qx5BHpTwTeEgFM5CFJqjvzwyMfod0LIh
         UXZS5O9cgElKVJDHre5fYuCNAtb7WeS7tbFN6QVu+0/SDBbDmeP38ynFfSNARng3v//E
         hCDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=wPm01GHjG1A3jBVuhE3t6MH7VFUSZydHeAlMfIYMkLg=;
        b=f/vGclCh0R1OTfbpv1Yl0ZCv1xCnEepS1uK/ITTQiqrJheMVEEKbWdzeUVLQX8rcCf
         z6pEEhNyCRHxpV2XjV0kCM8oei0tNMDp+bkJmiKV9YsW9N9tsAJqh3eGTyArPt/K5zQy
         P3E+0OIKMqko0SV4T6LY2q7Ujc3kRQ7oq1UTcBQFygWyB/Me/kdQsacqOH8M4GH+U2Rm
         mdaRs1jumaLBaMJMOmU4fsFNz9PPmoxsYUosDf53Jlda2eh9AxR7TB8IXOkLfaELp8Kb
         LbkDR7S1hhsozdKmkXpdrkEsAk/q9rTT86JtFzn9HhD+3ruy3o+vsriyLYZQg85yiJxW
         ferQ==
X-Gm-Message-State: AOAM532zFyVmbbt6Y0hiwM7zgLZXLEdwCfgZfb5NL9XjZgrIB/G7B8YH
        eXqZD5H+paJ66aVt03n8Kas=
X-Google-Smtp-Source: ABdhPJz5cg70KLdSXo5on/nXXmOeb4cWi7ea03Njm+HZRtHFsaGZs8Pd4lObkQ3kaRQMndIZIywW9g==
X-Received: by 2002:a17:902:ab59:b0:15c:f4f3:7e3b with SMTP id ij25-20020a170902ab5900b0015cf4f37e3bmr7176176plb.24.1650848497119;
        Sun, 24 Apr 2022 18:01:37 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id s14-20020a63dc0e000000b0039cc76bda79sm7804995pgg.40.2022.04.24.18.01.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Apr 2022 18:01:36 -0700 (PDT)
Date:   Sun, 24 Apr 2022 18:01:33 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     f.fainelli@gmail.com, bcm-kernel-feedback-list@broadcom.com,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH net-next v1 0/4] Broadcom PTP PHY support
Message-ID: <20220425010133.GA4472@hoboy.vegasvil.org>
References: <20220424022356.587949-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220424022356.587949-1-jonathan.lemon@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 23, 2022 at 07:23:52PM -0700, Jonathan Lemon wrote:

> There are other Broadcom chips which may benefit from using the 
> same framework here, although with different register sets.

Based on two examples, the present 542xx and the 541xx (which I am
familiar with), it appears that the registers sets are the same in
gen1, just the base offset is different.

So it would be great to store the base in bcm_ptp_private, adding the
base into each read/write operation.

Thanks,
Richard


