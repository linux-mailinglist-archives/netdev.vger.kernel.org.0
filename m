Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B275A60B4B5
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 20:01:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231232AbiJXSBE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 14:01:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231979AbiJXSAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 14:00:21 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5107A172B57
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 09:40:49 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id a15so8831504ljb.7
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 09:40:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9ewHs1WtNxesCvYdThMPfxZaMvkBvNzoFEJgKI+JRlc=;
        b=k+GAKnekpI+zcQTN9AMIl5m+QttWddOkEdY/iVDVj32WcLAWxhNeJmbF9+VXqwPdOk
         b5OiK3L/z7g0TD5leSDE/5o6ecJTGRSA6UG0kRQp+xHIaqlU5H/EiExHb00b4QdklSR+
         5qtxANWJupMSw6KJspkitEOk4WEkToZ1kxt3N0sQdm+lIMH27VAjRBnbq/y/P9ogQNj2
         nBbwv9Y4Tkg42LBxOwD9unY/uuAd77mQ21sACWyzcH5EeROrBe+EsWL3v91dG+Hirr/Y
         JdMSw2OwRpVDFUNyfNt1KBU77brLM94rUXO6lKYgnjVBAeOPy1pF9f437a2uc7UkEAhq
         6isA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9ewHs1WtNxesCvYdThMPfxZaMvkBvNzoFEJgKI+JRlc=;
        b=jm61R1g90Q3BLHxEQdx/zvJUgJNjdTSt6Yz4JGBMSdJLJnxBfEGyWWYt4bZnrXzEHH
         V4YjTjWXnmYWp2J7LiCh2GYTWXR3QeZ65CvmHrsJMAQFMWcIChM7IQ9mU9r+BgrHdCbt
         UOs6XZI61m5xw7gv8spTvbt3ztfF7txhw5hPkqNk4Bre7F2//6MygdgN3vZLz9Y1jMYx
         VKW+K3fsycFr6ag2QiSI9ALK0ksh5fAWMRxwy9jE9gaeCNmDLYQjXgRjFk/iR9q1XtUO
         alVqwJQKxdZqt829L0IEH1tSLvWAhEpX2DP7vgSwMVRee/3mHOJ0mrFS7XizdBnwTl3Z
         i1dg==
X-Gm-Message-State: ACrzQf2m56HA6/GQf4GozPiKZj5XYTBrxf0R8aKrDneqPytBS8txSH2t
        ZQqQMwkEhw7onGJV691d3pKnlTxlrOQmDg==
X-Google-Smtp-Source: AMsMyM6z2w/excwozJ6BviTwV358hsRtNkFRUXEe+yDxBrSohoGF1PedTaQNTCvA8HLZuEEfWcwVcA==
X-Received: by 2002:a17:907:7f1c:b0:78d:ddc7:dfb1 with SMTP id qf28-20020a1709077f1c00b0078dddc7dfb1mr29237770ejc.189.1666628678553;
        Mon, 24 Oct 2022 09:24:38 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id i9-20020a17090685c900b0078ae0fb3d11sm100407ejy.54.2022.10.24.09.24.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Oct 2022 09:24:38 -0700 (PDT)
Date:   Mon, 24 Oct 2022 19:24:36 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Sergei Antonov <saproj@gmail.com>, netdev@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Subject: Re: [PATCH v4 net-next] net: ftmac100: support mtu > 1500
Message-ID: <20221024162436.y22ynsugtguyeteh@skbuf>
References: <20221019162058.289712-1-saproj@gmail.com>
 <20221019165516.sgoddwmdx6srmh5e@skbuf>
 <CABikg9xBT-CPhuwAiQm3KLf8PTsWRNztryPpeP2Xb6SFzXDO0A@mail.gmail.com>
 <20221019184203.4ywx3ighj72hjbqz@skbuf>
 <CABikg9x8SGyva2C5HUgygS3r-c-_nv6H1g_CaBq-8m3rKp1o0g@mail.gmail.com>
 <Y1a4no+U1cbXAWLi@lunn.ch>
 <20221024162145.4t35ucrwpafbyhbc@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221024162145.4t35ucrwpafbyhbc@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 24, 2022 at 07:21:45PM +0300, Vladimir Oltean wrote:
> The only given guarantee is that packets with an L2 length <= dev->mtu
> are accepted.

L2 payload* length, i.e. the bytes between the Ethernet/VLAN header and
the FCS.
