Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DB755EC35A
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 14:55:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231149AbiI0MzG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 08:55:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231322AbiI0MzE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 08:55:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD691832F4
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 05:55:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664283302;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5gc9dvAgUsoaOgVdKLy3r0X9wn5fgduzN2uGouQ/L7A=;
        b=e75LHFCS6vaKExn/yKYdDocT7VMJ6KKdrgN9XoZsB3KNmE0uq/TcxNP7Kd/aDrKQOMXaye
        9Ni1HA8S+F11jUVaBwS6jI036OreDOCb+utkuic4ffHeZwDMwZ1o0yVXSmdW2jsuYBxPfI
        Jfd7Znmu0p3edru3YyjAMD45kXmyTG8=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-607-70duU75OPyKYMtX12U6gwg-1; Tue, 27 Sep 2022 08:55:01 -0400
X-MC-Unique: 70duU75OPyKYMtX12U6gwg-1
Received: by mail-wm1-f69.google.com with SMTP id 62-20020a1c0241000000b003b4922046e5so5521911wmc.1
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 05:55:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date;
        bh=5gc9dvAgUsoaOgVdKLy3r0X9wn5fgduzN2uGouQ/L7A=;
        b=sJyqTA85i5vk8kXEZLZJlJMypbYwd8LZ3ehHjtU/dJVIac2flAI9hDxWgl5fgo7hvR
         n7xvTZxaTNMH208/p+OwS5Ox8CzNcGpwkrXi1ir6d199sCCJw15QihNIheVpxftd75Kp
         Aoe6IFlu0uOhYckxjok1ER/jTM8bbYaUwAqEN6CW9NcgwVqQSCUv9HIv56tTifn79lxJ
         o6UFMlvLkFqhPd5G/IMyRjP1BMG2uHNDf3/gYBdi22+OOyvp6x+pFyISX1VLK3WAK+zL
         YL0l/supwIYEina//bw76Yi5r5F6JpZQZpLik9sWrEy7J8Rz0TwkpzVAjpLnMSJ5IODQ
         5lvQ==
X-Gm-Message-State: ACrzQf20MGMw4AfB4dfm0rfOSdHKFs4snSN0ZEZyRv8834VNqwJVs1bP
        MzSfgfvLXVHjRzqqqP9TRg843wyg+mCwxQSrAcT3UB7pxgDlh2zLVob4TnOU/NCFmcBngYy4LhU
        7fjXiZCN6QWtVKbF8
X-Received: by 2002:a5d:4a0a:0:b0:22a:9893:6434 with SMTP id m10-20020a5d4a0a000000b0022a98936434mr16790015wrq.395.1664283300412;
        Tue, 27 Sep 2022 05:55:00 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5QJMz1IQTUTMWyIO8IS+B3F/0beuH/m03S0YwvpLF/A2hYS1FAc3AJhnzGtiuclo/JyprwNg==
X-Received: by 2002:a5d:4a0a:0:b0:22a:9893:6434 with SMTP id m10-20020a5d4a0a000000b0022a98936434mr16789990wrq.395.1664283300130;
        Tue, 27 Sep 2022 05:55:00 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-104-40.dyn.eolo.it. [146.241.104.40])
        by smtp.gmail.com with ESMTPSA id k1-20020a5d5181000000b00228da845d4dsm1679622wrv.94.2022.09.27.05.54.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 05:54:59 -0700 (PDT)
Message-ID: <415734628d8626088b74e49cb062f86a2733dd0e.camel@redhat.com>
Subject: Re: [PATCH net-next v2 07/12] net: dpaa2-eth: use dev_close/open
 instead of the internal functions
From:   Paolo Abeni <pabeni@redhat.com>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org
Date:   Tue, 27 Sep 2022 14:54:58 +0200
In-Reply-To: <20220923154556.721511-8-ioana.ciornei@nxp.com>
References: <20220923154556.721511-1-ioana.ciornei@nxp.com>
         <20220923154556.721511-8-ioana.ciornei@nxp.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2022-09-23 at 18:45 +0300, Ioana Ciornei wrote:
> Instead of calling the internal functions which implement .ndo_stop and
> .ndo_open, we can simply call dev_close and dev_open, so that we keep
> the code cleaner.
> 
> Also, in the next patches we'll use the same APIs from other files
> without needing to export the internal functions.
> 
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>

This has the not so nice side effect that in case of dev_open() error,
the device will flip status after dpaa2_eth_setup_xdp(). We should try
to avoid that.

I think it's better if you export the helper instead (or even better,
do something more low level-cant-fail like stop the relevant h/w queue,
reconfigure, restart the h/w queue).

Cheers,

Paolo

