Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AC7A675830
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 16:10:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231259AbjATPKq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 10:10:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230233AbjATPKp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 10:10:45 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E769BFF77;
        Fri, 20 Jan 2023 07:10:44 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id h12so1129298wrv.10;
        Fri, 20 Jan 2023 07:10:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lfDFGa21Zkbo0vLtW0Q3rbpLbXSHdYtCsF6w0cxzIXE=;
        b=IwYzXXa9ph2pRyr6ZGCjAXEEWBT8RAo9sxi66TPWb+2VaHBgHNd1ri0YpHCW1rNVF4
         6EygxL8SL5uJigfuEjPPCKEWq8Kk32K4TSjwvVEwVKQ8OmOucpiFUpARfbFr/6H9ApMe
         4ei5FINwgk/455TixLVJCVEGEmNoEAA7kto9M2SOsQeECGd0XoQZfqGWMDnPQ4SSmYZJ
         X+OB1WH/ax9vK2OlMKqkOpWBYokFYJsBVAGLHa2zeCLR7ei+3jdZdBjVyEnXaJTEx9Rf
         e9tw+FYZCklrNGWidEvpswqntGNAAW8KuDY2EOB0DTelfC2IS1iUE76TxliQjjEEtWYW
         fzaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lfDFGa21Zkbo0vLtW0Q3rbpLbXSHdYtCsF6w0cxzIXE=;
        b=6B1YMEiQXNIA7jbdSTFNEBaGUSPcgft1puLixZnNmpT31BewzfsH5/Itft2ecERxS6
         arkmtwpOuMe15tMfSsyIFJe/NRqMXRDTRqWU9dQ97DmONY8U8Km/hCHcIODWhRdct0OL
         rOLmbDnjP/fht4Qb946Zl6p1EZds19sKVbxv1P5s56ZmILRENpbqVvwugHUvP9Se/b9C
         7DLoXofJTROwY/w3W2iQc0FDsqok6md4bkOFBWjEm1x28lVdFF9nBvbpKP7J8Nzg+71h
         uSlcnQzFZEjnmqVwlZKSoW+1Ou8B7V5gjw0FKykGvdKeyCcWFAwxjghFFCDguuORGz0h
         OkXQ==
X-Gm-Message-State: AFqh2koAVOLTEgcenlfBApO9nrf3WKvDycd2jQyc2kMUGI+w0y8rMjTY
        a2fE4ElHDXSQCDNZ1hCB3lY=
X-Google-Smtp-Source: AMrXdXsPufvMLS7zEnKBIilytZS0WM++49vJrKgxgsHqw+5TLoXh8MFl4CGhg9+yJbu9kVyRWD6Z2g==
X-Received: by 2002:a5d:4cc8:0:b0:2bd:d779:c1b5 with SMTP id c8-20020a5d4cc8000000b002bdd779c1b5mr21617562wrt.27.1674227442644;
        Fri, 20 Jan 2023 07:10:42 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id i10-20020a05600011ca00b002bf94527b9esm828135wrx.85.2023.01.20.07.10.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Jan 2023 07:10:42 -0800 (PST)
Date:   Fri, 20 Jan 2023 18:10:34 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     Daniel Machon <daniel.machon@microchip.com>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Lars Povlsen <lars.povlsen@microchip.com>
Subject: Re: [PATCH net-next] net: microchip: sparx5: Fix uninitialized
 variable in vcap_path_exist()
Message-ID: <Y8qu6s4nmOQB8ZEq@kadam>
References: <Y8qbYAb+YSXo1DgR@kili>
 <ebcb9a2321ea39ac5164e5df635c2eb02835f41c.camel@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ebcb9a2321ea39ac5164e5df635c2eb02835f41c.camel@microchip.com>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 20, 2023 at 03:25:36PM +0100, Steen Hegelund wrote:
> Hi Dan,
> 
> Thanks for the fix.
> 
> I have not seen any CONFIG_INIT_STACK_ALL=y in any of my .configs, though, so I
> will be updating my test suite to catch this.

No, what I'm saying is that for a lot of people all stack variables are
initialized to zero by default so sometimes people are like, "I've
tested this a thousand times.  How has it even been working?"

In your case I guess it was working because the eport was never not
found.

regards,
dan carpenter
