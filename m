Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C76275FDD7A
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 17:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbiJMPrb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 11:47:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbiJMPra (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 11:47:30 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91EE5DED0E
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 08:47:28 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id q19so3200085edd.10
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 08:47:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=8IoJ43rvJQjX5oJeInrWEkGduhfYPR2H8rUG4XoHfwE=;
        b=mN2lSlvoTX67Uv261snt8kdxUuMUHKQsu8E9yDeBkpfxOydLaOpIPXCP3QC4HzbSr6
         5a3PCEFyhBUuFUX3MvjGMnGsWQZyAH2B7rSahsAWar6xQYfUw8BS6L6P28DLFNteosyD
         TPbNjx3jHv36SXmL8ntyGEyOYEaaEtjBVOvn8I+enfJ955e80wI9ZpzcAdjB0rzOydPI
         zktL1J9nWjIbLVLqxuiKigS0S2O/xHi/drFJ4LGemRezQYtRfz0GqW9hMNkRtpX2Dqi4
         BKLp/KnVPPM1ISPYFD3Xo0ECZFw+YCbhU0wtc8p97Bvicmb/ss7FK2Wq6eu50rZM8qlv
         CxwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8IoJ43rvJQjX5oJeInrWEkGduhfYPR2H8rUG4XoHfwE=;
        b=PD5JJPFirggjwiL6h/hsrjv1HDZSTWS4l7gVn75UCU9xSnXZv8ng5F1tXIpOD+dIcj
         38DgLMqsZEO9SSbR/IEeXMCDGchyzBdDf9MwCUnI6abLPKvq1NMgz4fBRZcdZ8p6JVvQ
         hd5nlCZpSPgTogjFU+XI907B73iZjWd69TjISpcMrmRNjVcKBTCwFSfGURfQerS+nIUS
         bn3WGtv5EW/qO23gOMboQ5uBYaFaffhBd9rToHZYZFtZt8NL/guPBGOIsdSopqhyjrsX
         6XXKEqR3EoSKCOlfGbnTN+FArbvSBFl3LS1STfZsZwV3cQ9dXhg+rkd3Y10c67741llF
         LbMg==
X-Gm-Message-State: ACrzQf2KDuiqvv9Nvh0XHJpnwrRL1y+qdsFUi9bv0MWPWNY8oGwHgUry
        fjh4nMpmV8rfPojK59F2LOyBMIngQY0Xa/EAB1M=
X-Google-Smtp-Source: AMsMyM61pvK7ZoG2yd2IEX9szAb/tO5L9/Q6iD32uxeHQXqmpfKzxjtM5mVJJ0yXjS2bs67JmpUpVTdKQyVp+VRVN4U=
X-Received: by 2002:a05:6402:847:b0:453:944a:ba8e with SMTP id
 b7-20020a056402084700b00453944aba8emr362450edz.326.1665676047108; Thu, 13 Oct
 2022 08:47:27 -0700 (PDT)
MIME-Version: 1.0
References: <20221012153737.128424-1-saproj@gmail.com> <1b919195757c49769bde19c59a846789@AcuMS.aculab.com>
 <CABikg9zdg-WW+C-46Cy=gcgsd8ZEborOJkXOPUfxy9TmNEz_wg@mail.gmail.com> <379c5499d1be4f73a6175385d3345a68@AcuMS.aculab.com>
In-Reply-To: <379c5499d1be4f73a6175385d3345a68@AcuMS.aculab.com>
From:   Sergei Antonov <saproj@gmail.com>
Date:   Thu, 13 Oct 2022 18:47:15 +0300
Message-ID: <CABikg9wC+L4cLRDDuzCVtYt9UHJMPi108V+KoGaw1WjH2SzofA@mail.gmail.com>
Subject: Re: [PATCH v2 net] net: ftmac100: do not reject packets bigger than 1514
To:     David Laight <David.Laight@aculab.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>
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

On Thu, 13 Oct 2022 at 07:24, David Laight <David.Laight@aculab.com> wrote:
>
> From: Sergei Antonov
> > Sent: 12 October 2022 17:43
> >
> > On Wed, 12 Oct 2022 at 19:13, David Laight <David.Laight@aculab.com> wrote:
> > >
> > > From: Sergei Antonov
> > > > Sent: 12 October 2022 16:38
> > > >
> > > > Despite the datasheet [1] saying the controller should allow incoming
> > > > packets of length >=1518, it only allows packets of length <=1514.
>
> Actually I bet the datasheet is correct.
> The length check is probably done before the CRC is discarded.

Thanks for clarification.
I will make a v3 version of the patch without datasheet blaming and
using the approach with MTU suggested in this thread.
