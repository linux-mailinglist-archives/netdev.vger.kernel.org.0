Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C00434E3037
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 19:45:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348878AbiCUSqz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 14:46:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245651AbiCUSqy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 14:46:54 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ADF818CD10
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 11:45:29 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id pv16so31759292ejb.0
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 11:45:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=C42AYLvFJGnCjVQE1nMdcWjGYhOZX8No3uS5+wkp4Yo=;
        b=MLwkBNTbCLt6ulUTX/IcWRlRQOAlrba/ZfJgZ8kaPEhiM6poyEaE1fojnqzSwcQoB/
         6O+EdpkNap/2x+ov7FrH1XoopUacwpKjck+5dJmzxYrqMHjjWrREXyoYsEBFRjfzKJD7
         AADmri/EaXypPNzK9xb1KznYem9I0k6k5ZSIwT+z+aAK4EkfYruVElWShbmNNcSCluVz
         PeN2tcX4v7L++MEdaURtN0zDihAKR3+qpcm6UdeCmpFYToNlNqdGjtZORzAQij2XI8v/
         t2lOuMOmc5U9O+UHkwylrsP9J1u9JLI45yd0sdNg53VKMunumV8UDvs1krWPKJ/pQtdj
         I81A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=C42AYLvFJGnCjVQE1nMdcWjGYhOZX8No3uS5+wkp4Yo=;
        b=EkzA8G6XT5SgzVmrxCmr9r9/P60qjyzFiZI56ooZSI+Wk0WYeF25eTmPlUfSYYHH4q
         0X29TDe2G0HMvt+wJGGUHFMNProaEgn1toswSIchy+RsdfDmQQct3ddh0QNEKwIEt9VW
         W2hOaCL8cri2TXL42Zx4mdxeImu9k9b3WNoDFaz63p7hcGFyMSKcwCzFJx1HW8F3u6AH
         u4d6FTbyrYDAuirLIjF0RVahg+UfwFhqjR9Aj6Tf5VvckXInkzrymgigtD3QAua854OP
         9ZU4xFLOR2es0ZIFEG3a+5XyANfcBNtMv0SEBAGrYfu7f8W/La3SYod8SH20QgfvNZu0
         v5eQ==
X-Gm-Message-State: AOAM533jhXZzBRiaKvKKZjnak3p6BuVQLXRaQR5HOShrwjZ8xIMRG2vt
        ajbB6N20IqtDkDpWWA6sN3c=
X-Google-Smtp-Source: ABdhPJyQN56BoYcy+Wm5x1XA8GiwFuGLlmNbcGoktqhgWwv6veyZgTwsTova9kVeLychLv9JxonfBw==
X-Received: by 2002:a17:906:9b96:b0:6e0:17e:fe3 with SMTP id dd22-20020a1709069b9600b006e0017e0fe3mr6926034ejc.514.1647888327832;
        Mon, 21 Mar 2022 11:45:27 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id sb31-20020a1709076d9f00b006ceb969822esm7181080ejc.76.2022.03.21.11.45.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 11:45:27 -0700 (PDT)
Date:   Mon, 21 Mar 2022 20:45:26 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Alexander Duyck <alexanderduyck@fb.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: Possible to use both dev_mc_sync and __dev_mc_sync?
Message-ID: <20220321184526.cdpzksga2fu4hyct@skbuf>
References: <20220321163213.lrn5sk7m6grighbl@skbuf>
 <SA1PR15MB513713A75488DB88C7222C2DBD169@SA1PR15MB5137.namprd15.prod.outlook.com>
 <20220321184259.dxohcx6ae2txhqiy@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220321184259.dxohcx6ae2txhqiy@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 21, 2022 at 08:42:59PM +0200, Vladimir Oltean wrote:
> On Mon, Mar 21, 2022 at 06:37:05PM +0000, Alexander Duyck wrote:
> > > -----Original Message-----
> > > From: Vladimir Oltean <olteanv@gmail.com>
> > > Sent: Monday, March 21, 2022 9:32 AM
> > > To: Alexander Duyck <alexanderduyck@fb.com>; Jakub Kicinski
> > > <kuba@kernel.org>; Jiri Pirko <jiri@nvidia.com>; Florian Fainelli
> > > <f.fainelli@gmail.com>
> > > Cc: netdev@vger.kernel.org
> > > Subject: Possible to use both dev_mc_sync and __dev_mc_sync?
> > I hadn't intended it to work this way. The expectation was that
> > __dev_mc_sync would be used by hardware devices whereas dev_mc_sync
> > was used by stacked devices such as vlan or macvlan.
> 
> Understood, thanks for confirming.
> 
> > Probably the easiest way to address it is to split things up so that
> > you are using __dev_mc_sync if the switch supports mc filtering and
> > have your dsa_slave_sync/unsync_mc call also push it down to the lower
> > device, and then call dev_mc_sync after that so that if it hasn't
> > already been pushed to the lower device it gets pushed.
> 
> Yes, I have a patch with that change, just wanted to make sure I'm not
> missing something. It's less efficient because now we need to check
> whether dsa_switch_supports_uc_filtering() for each address, whereas
> before we checked only once, before calling __dev_uc_add(). Oh well.
> 
> > The assumption is that the lower device and the hardware would be
> > synced in the same way. If we can't go that route we may have to look
> > at implementing a different setup in terms of the reference counting
> > such as what is done in __hw_addr_sync_multiple.
> 
> So as mentioned, I haven't really understood the internals of the
> reference/sync counting schemes being used here. But why are there
> different implementations for dev_mc_sync() and dev_mc_sync_multiple()?

And on the same not of me not quite understanding what goes on, I wonder
why some multicast addresses get passed both to the lower dev and to
dsa_slave_sync_mc (which is why I didn't notice the problem in the first
place), while others don't.
