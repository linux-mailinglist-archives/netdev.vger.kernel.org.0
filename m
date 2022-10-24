Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81B8960B9CA
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 22:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234222AbiJXUV0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 16:21:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232814AbiJXUU6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 16:20:58 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E05BFAA44
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 11:37:25 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id d6so18094545lfs.10
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 11:37:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ZGC7atfqxheyWtYJV2fSN3wRAJFliN5cIUQehbg9BNg=;
        b=Z1ykJ9EPsWhB4i00HbSi64ik4tLLQVTWk0slUcZHdtFZ1mu91XFyg1Xg/BqvsK3quS
         UC/mlYhX7DELVAVzqDs0unSh9WYAXyav/s+sP6tA88wwcjNqWw+Ei0Ij5sLLdQJxbJpF
         kSbq8X9xPrtanTvyAJKpea0W+WV2bA/LeK0fg2EMdCPESUc3CkrfFZx2zWsfuwi23O3J
         IsYOryUcc+dfvbDPJLOybzn2OtjPvfq52HMVGJuH3+/Q9VSP8n5g6MU6R0XMjcuGZqOD
         3wm/KTyCj/U0i/f6BIoGjNhVUvEwqJUf2SUswPDl1iiy4VvIt3ZujH6f061i2YM5PVR1
         Mcxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZGC7atfqxheyWtYJV2fSN3wRAJFliN5cIUQehbg9BNg=;
        b=Z11S83yoD9eCEY3AzV90Pi6UFmB/yYpBazNw4BId/BD5hfkvhO/q2phpocFCVHSgV7
         snMsy1wICDC4mh5/Zir5lID0gjGYWCgij6Gmo+T8iEr8okzgHnuhKV06HsQGfod0+oT8
         pZW70+qw04WNMYcLT6X90CHHKmpbIohAOgQ194FuvRLSjmGRg/Iux/RiLeAKkMTOVHNq
         GkWBUGUULBFXddummL3uEoN0Zcuvq+ouJwSUREXupx3+g8LC+rqPVmpzZsJYBYUHpRVY
         Vbo82owou40Shd0rpWtwifLfVIcmq923QN72ozt5ijQRDd77mFGhvAvQBlpP/+9dFesX
         o6DA==
X-Gm-Message-State: ACrzQf3ilNP2twTykVkxGdrpr0ICMnohbIZFjiDY1OCqwPxrSZsQOZMx
        98GXh+EAQd9WZs6rDgBindzyo+GX9kxb0XDjXON/aKvDe3s=
X-Google-Smtp-Source: AMsMyM7hptZbx3udGvL61tFFqekR1qELDLrye+YkUzWxqT4sa1UvbUSZ4dEFe2HsfnBDYmjLKZng7s4EMTIXgjCdKxA=
X-Received: by 2002:a05:6402:847:b0:453:944a:ba8e with SMTP id
 b7-20020a056402084700b00453944aba8emr30840951edz.326.1666626642530; Mon, 24
 Oct 2022 08:50:42 -0700 (PDT)
MIME-Version: 1.0
References: <20221019162058.289712-1-saproj@gmail.com> <20221019165516.sgoddwmdx6srmh5e@skbuf>
 <CABikg9xBT-CPhuwAiQm3KLf8PTsWRNztryPpeP2Xb6SFzXDO0A@mail.gmail.com> <20221019184203.4ywx3ighj72hjbqz@skbuf>
In-Reply-To: <20221019184203.4ywx3ighj72hjbqz@skbuf>
From:   Sergei Antonov <saproj@gmail.com>
Date:   Mon, 24 Oct 2022 18:50:31 +0300
Message-ID: <CABikg9x8SGyva2C5HUgygS3r-c-_nv6H1g_CaBq-8m3rKp1o0g@mail.gmail.com>
Subject: Re: [PATCH v4 net-next] net: ftmac100: support mtu > 1500
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, andrew@lunn.ch
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Oct 2022 at 21:42, Vladimir Oltean <olteanv@gmail.com> wrote:
>
> On Wed, Oct 19, 2022 at 09:36:21PM +0300, Sergei Antonov wrote:
> > On Wed, 19 Oct 2022 at 19:55, Vladimir Oltean <olteanv@gmail.com> wrote:
> > >
> > > On Wed, Oct 19, 2022 at 07:20:58PM +0300, Sergei Antonov wrote:
> > > > The ftmac100 controller considers some packets FTL (frame
> > > > too long) and drops them. An example of a dropped packet:
> > > > 6 bytes - dst MAC
> > > > 6 bytes - src MAC
> > > > 2 bytes - EtherType IPv4 (0800)
> > > > 1504 bytes - IPv4 packet
> > >
> > > Why do you insist writing these confusing messages?

Working on a better version of the patch. And here is another question.
Unless the flag is set, the controller drops packets bigger than 1518
(that is 1500 payload + 14 Ethernet header + 4 FCS). So if mtu is 1500
the driver can enable the controller's functionality (clear the
FTMAC100_MACCR_RX_FTL flag) and save CPU time. When mtu is less or
greater than 1500, should the driver do the following:
if (ftmac100_rxdes_frame_length(rxdes) > netdev->mtu + ETH_HLEN) {
    drop the packet
}
I mean, is it driver's duty to drop oversized packets?

In the current version of the driver, if, for example, mtu is 1400 and
the incoming packet is 1450 bytes it is not dropped. Or is mtu < 1500
incorrect for Ethernet cards so there is no need to write code
handling it?
