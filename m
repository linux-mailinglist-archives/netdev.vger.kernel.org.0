Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82F0154E14D
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 15:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232131AbiFPNAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 09:00:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229927AbiFPNAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 09:00:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 853C5B4C
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 06:00:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655384421;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=e8ZVUkV5slpBiU5gnP3i9vX4TyyFnQAAf/ZHvzAvayg=;
        b=Yz1x+5b4Jgb7Mjpp/78q+9viqZ/D99oQ/ek9b0LbU4/BV/4V0Hqy3PeEhpqBuaTuSDqqRw
        YenopNz5AoYH8zQOKQZ/hL01cNgZYWDi5JdRmWSz2KqM+YqOHUPE12peoyUMaT17Ovny8U
        8WuGaiNp9nRDEOKRufJogLMgaKg+Zds=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-142-wQWllq1YPiiKzKJNFXCCNQ-1; Thu, 16 Jun 2022 09:00:20 -0400
X-MC-Unique: wQWllq1YPiiKzKJNFXCCNQ-1
Received: by mail-qk1-f200.google.com with SMTP id k188-20020a37a1c5000000b006a6c4ce2623so1653038qke.6
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 06:00:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=e8ZVUkV5slpBiU5gnP3i9vX4TyyFnQAAf/ZHvzAvayg=;
        b=KraaBy6QAGCTdnlfumGZTCk7BTsVU2P09hB9MroejTHszXw65VWE5GCpcY7l1l9MSB
         fmf460KGrAcliuJCcB5SkvXsgyc1b1eoxDA7T2M/wqShw15FT0rxysHGTg5R2eGlUmLR
         rE0PKkvrfCJQ/OW5Tp0sBGWV9HttAMFU2eF67jgpsCxpDG7qmlSMVY5euiMtCpIu7LBv
         JwbkDBf++FHgyHtR+XOZkBwAkz3NxdX2qPxrXE7yVvPc3stCDGJCYUNStuhcihprYpHO
         7mMmZsmgp0OyFleJuqNtT/Xxa+n6plMkcmQsUAgsvWGbFnpqpwQ4doMk2K4rXW7DAK9g
         LKDQ==
X-Gm-Message-State: AJIora/x9hkVuIwpBooIyG2i1DekgTzKApKICPwTOgVuV7BjxGmB3Y3B
        PMaCJ2oz+V8EQ1GsSj/tIXgGjGyA+WHNM+YTTH3uyIXc+M2yWD2yrfPTiQimMeLVemhsbK0O8mk
        bvc1JahP/UaGGDaz4yTwu3dJsUls8ycLu
X-Received: by 2002:ac8:5dd2:0:b0:304:ea09:4688 with SMTP id e18-20020ac85dd2000000b00304ea094688mr3843309qtx.526.1655384419698;
        Thu, 16 Jun 2022 06:00:19 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1s8NkXax/fhJn4p4KB+vrjzTc8SwiO52rQs1d5sXZGTBSfZ9nwuhdYltnFR7y17gdFUY49O0yt9bUAY4fI7De8=
X-Received: by 2002:ac8:5dd2:0:b0:304:ea09:4688 with SMTP id
 e18-20020ac85dd2000000b00304ea094688mr3843279qtx.526.1655384419441; Thu, 16
 Jun 2022 06:00:19 -0700 (PDT)
MIME-Version: 1.0
References: <CAK-6q+g1jy-Q911SWTGVV1nw8GAbEAVYSAKqss54+8ehPw9RDA@mail.gmail.com>
 <e3efe652-eb22-4a3f-a121-be858fe2696b@datenfreihafen.org>
In-Reply-To: <e3efe652-eb22-4a3f-a121-be858fe2696b@datenfreihafen.org>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Thu, 16 Jun 2022 09:00:08 -0400
Message-ID: <CAK-6q+h7497czku9rf9E4E=up5k5gm_NT0agPU2bUZr4ADKioQ@mail.gmail.com>
Subject: Re: 6lowpan netlink
To:     Stefan Schmidt <stefan@datenfreihafen.org>
Cc:     linux-wpan - ML <linux-wpan@vger.kernel.org>,
        linux-bluetooth@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Thu, Jun 16, 2022 at 3:57 AM Stefan Schmidt
<stefan@datenfreihafen.org> wrote:
>
> Hello Alex.
>
> On 13.06.22 05:44, Alexander Aring wrote:
> > Hi all,
> >
> > I want to spread around that I started to work on some overdue
> > implementation, a netlink 6lowpan configuration interface, because
> > rtnetlink is not enough... it's for configuring very specific 6lowpan
> > device settings.
>
> Great, looking forward to it!

I would like to trigger a discussion about rtnetlink or generic. I can
put a nested rtnetlink for some device specific settings but then the
whole iproute2 (as it's currently is) would maintain a specific
6lowpan setting which maybe the user never wants...
I think we should follow this way when there is a strict ipv6 device
specific setting e.g. l2 neighbor information in ipv6 ndisc.

- Alex

