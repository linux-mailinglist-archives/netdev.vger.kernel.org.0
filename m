Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E135358875D
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 08:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237210AbiHCG3n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 02:29:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237207AbiHCG3k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 02:29:40 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7954757267
        for <netdev@vger.kernel.org>; Tue,  2 Aug 2022 23:29:35 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id o5-20020a17090a3d4500b001ef76490983so1083014pjf.2
        for <netdev@vger.kernel.org>; Tue, 02 Aug 2022 23:29:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7AqEz9vKENWUkmXsPjwwxFbYbnHSbUFB9fv4NJqYhIA=;
        b=NaevqdB/r3F8XBIg0ud4QL6HN5CAlxQKiSl5Jx6mDG/cK0bpk7FI04Md52kiQ4gZ4s
         DNCSlQzao/wmGfwx1NJPT5YcHpE3fWOwEWhW7FAeFc2tHKT4lKHiEKukEEVVl4JAsKdb
         aQbSq+f4mLW3r3nvH3DmjM1vyQujC9UcDV25gaQK4gDwpQOqZl8xV3pEPjeX1anaP4+7
         9DvMo5IKnnF4z/SopvI+ewevoa0iAuuIKRQ4SU41hciOiuPz2p5VjHEVGYrMitv5T1LF
         /wNxsXcJaNcf5lCBAFyERsgXARG+aj4h/zz3J633XOr67wIrgurgiTtIZHeHLx4rrhEM
         7FiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7AqEz9vKENWUkmXsPjwwxFbYbnHSbUFB9fv4NJqYhIA=;
        b=RaGxTSaxOagnVcBet3x3oqzKe0YONlF6gVwT60OohfOXXwCN+g/OuJHONOCMXM0GW6
         Daee6tqzdSTM8WsdraJgadv7JC3cZhCooQ8uOQfVpNMPImOASn9R/fn0NbOZhwdbvAhb
         oATQi8CqZ/+nC/U/CD23xNAmKTiqah+rigTec62g+yBKzEBC3XV32qBDVH6YcT/IDQWj
         /IV8OL2heXHaqyrF94EDd1QiEFNA9kSmFinjFZxDsGT/5lH9r4pAEPo9I5z4D5mQplkg
         bOAFzwA2TzhY7uRfSACRLLM1A+r5SAXFGK4PXpfz3edHvmFja7cDlPROAwAoRIacFiPm
         br1g==
X-Gm-Message-State: ACgBeo0hPmgBtlZWCUa2ife47aik9YhcM7T5fh2bPhLUcJmfHoUX9gEA
        Ja9RsN3B2fZ9sn3D1igzjUk8b8U4ddYhXF09i94=
X-Google-Smtp-Source: AA6agR4FHg6hLdf7sZH9KYKpIA3wTG4mxUl1GYh/S2Ma4jpeuxVyFn5DZTuOJLsFY8pSkEALRY0G0/0p5952YKjcaHU=
X-Received: by 2002:a17:90b:4d12:b0:1f2:ad15:3ee8 with SMTP id
 mw18-20020a17090b4d1200b001f2ad153ee8mr3415431pjb.82.1659508174939; Tue, 02
 Aug 2022 23:29:34 -0700 (PDT)
MIME-Version: 1.0
References: <CA+FuTSfNLfLCxV8NNsJKSQynvBCa2_b7YqqPPXr=2gDhXnGiYA@mail.gmail.com>
 <20220803042845.5754-1-cbulinaru@gmail.com> <20220802214258.23d1d788@kernel.org>
In-Reply-To: <20220802214258.23d1d788@kernel.org>
From:   c b <cbulinaru@gmail.com>
Date:   Wed, 3 Aug 2022 02:29:24 -0400
Message-ID: <CAG0ZtY4FYGvXyapfCO4JXnBTxL5JXnfyMqufsCga3RtnSn3y2g@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] net: tap: NULL pointer derefence in
 dev_parse_header_protocol when skb->dev is null
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, willemb@google.com, netdev@vger.kernel.org
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

I sent these two w.o. in-reply, hopefully it work. sorry about confusion
[PATCH v5 net] selftests: add few test cases for tap driver
[PATCH v5 net] net: tap: NULL pointer derefence in
dev_parse_header_protocol when skb->dev is null

On Wed, 3 Aug 2022 at 00:43, Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed,  3 Aug 2022 00:28:45 -0400 Cezar Bulinaru wrote:
> > Fixes a NULL pointer derefence bug triggered from tap driver.
> > When tap_get_user calls virtio_net_hdr_to_skb the skb->dev is null
> > (in tap.c skb->dev is set after the call to virtio_net_hdr_to_skb)
> > virtio_net_hdr_to_skb calls dev_parse_header_protocol which
> > needs skb->dev field to be valid.
>
> Could you repost these patches as a normal, standalone series, with
> no fancy in-reply-to? Put [PATCH net v5] as the subject prefix.
> Patchwork bot is unable to follow your creativity it seems.
