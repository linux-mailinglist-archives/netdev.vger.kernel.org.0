Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F4EC4BB3EC
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 09:11:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231654AbiBRILO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 03:11:14 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229938AbiBRILM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 03:11:12 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAC1719AF04
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 00:10:56 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id f37so3867994lfv.8
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 00:10:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FW7LXKU00DguRlSw2i8lyr7umFOlovlH0RqtBFjzUnQ=;
        b=XvT4n0JEcQtT07hMJhMmVdQOAC3d3AG3RLgSYgE9VzvdiS4a0V4d8kYA6FL294MxRk
         l6woWIboVWik7HdDu2EgYO5ns/vzBm0Pgukr1oCgRcgzoGQjja9ce/Mjsr3m0vlBSm3l
         wcDSJb/alg4gYWHz5rKvGV53fPJS+FdDah+MBBLP5RfEYcADRqC2nGwy3NI65+VKH8Ry
         hRAC5FYLWw3u7YbOo2XMjdW9ALIXRoSDZKvcQkV7BvkiuVaSLrkqKMG0JqVCA9hV7bZ4
         B7ciwBs5L/rHMizDbLVRzsQ3MmRbIwCsfa0m8JtUB3mjCqiQ+3mP8MQi4Ywh8eYuYrXY
         1AFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FW7LXKU00DguRlSw2i8lyr7umFOlovlH0RqtBFjzUnQ=;
        b=p4fmaAyCRSmH+4jW34obmTDSj7j+eTN3/jP+iBQH64wuHRzj5NsU2qCkA/szQCINFb
         IHUrMOHQV68koPbLQvQaoXhlGaK3veo5ELQEINpwmvJHBfU63AySVcU3i2/h7m1LGiz7
         R58Orra4NebLtZs5EtM8flnOyYqakEyPxwzfUu1cTCIJztNt7bPg8eRr43/4f03WPPgf
         RjG2eNQ7T+DOSCKwbEvxmnMUsERI0g8rAfta+Z8eDODh6kbpWE2W4k0JxZTFYedLMyi+
         CXAcMlHhbL/RJnYhs9k4SNK3CC7WXyf3cExfxNdcZ/MDfx2k4mJBv6gPQGQdGnJI3iLO
         OuFg==
X-Gm-Message-State: AOAM532oixB8ZEjHWBoAZt4yx5AEmfkevOyLd1NUJQOk+rD8mW9auh7u
        txRCleLxFNdPXDsxIp/A8LRjNUyC/gDzIx6I0nE=
X-Google-Smtp-Source: ABdhPJwTOle5GhbRwsuWG2oqr6dwy2QWgvWf1SuN3OBiq9/u9M4JZt4RFDK8RE6vGGkAHB5iitunGPIxxWyGQY+usxo=
X-Received: by 2002:ac2:518e:0:b0:442:bb6f:b54b with SMTP id
 u14-20020ac2518e000000b00442bb6fb54bmr4956347lfi.72.1645171854920; Fri, 18
 Feb 2022 00:10:54 -0800 (PST)
MIME-Version: 1.0
References: <1645109346-27600-1-git-send-email-sbhatta@marvell.com>
 <1645109346-27600-2-git-send-email-sbhatta@marvell.com> <20220217090202.3426cbac@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220217090202.3426cbac@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   sundeep subbaraya <sundeep.lkml@gmail.com>
Date:   Fri, 18 Feb 2022 13:40:43 +0530
Message-ID: <CALHRZuriYME8fr1YBMDAwUNWSy5jJ8igYCtA=kYiZJBGraNU8A@mail.gmail.com>
Subject: Re: [net-next PATCH 1/2] ethtool: add support to set/get completion
 event size
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Subbaraya Sundeep <sbhatta@marvell.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        hariprasad <hkelam@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Thu, Feb 17, 2022 at 10:32 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 17 Feb 2022 20:19:05 +0530 Subbaraya Sundeep wrote:
> > Add support to set completion event size via ethtool -G
> > parameter and get it via ethtool -g parameter.
>
> > @@ -83,6 +85,7 @@ struct kernel_ethtool_ringparam {
> >   */
> >  enum ethtool_supported_ring_param {
> >       ETHTOOL_RING_USE_RX_BUF_LEN = BIT(0),
> > +     ETHTOOL_RING_USE_CE_SIZE    = BIT(1),
> >  };
>
> include/linux/ethtool.h:90: warning: Enum value 'ETHTOOL_RING_USE_CE_SIZE' not described in enum 'ethtool_supported_ring_param'

compiled for ARM64, x86 and with COMPILE_TEST, W=1 but I did not see
any problem.
Please let me know what I am missing here.

Thanks,
Sundeep
