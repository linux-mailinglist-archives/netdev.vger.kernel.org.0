Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E41215B8C14
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 17:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230201AbiINPlJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 11:41:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230361AbiINPkv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 11:40:51 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D25315710
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 08:40:16 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id p18so15514309plr.8
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 08:40:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:references:in-reply-to:mime-version
         :from:to:cc:subject:date;
        bh=D56n3MxsMawE+Lyp4Aq5SKAUzUENiqVmEAQR38YMZ04=;
        b=DwjDXBRTSn1PhpwwDRfLfn/N55DAGn8tDm+tuT657zWj0WyTXLbs6u1ty9W/eMduLA
         jqbH8xuRtXVaYGbEaxEfGhnpfBuKiL6WQvnpeosYh/8QyL0cqBM22vr5brmn8cnlsWds
         fhPPUAgcE6QwjsKBqJFi2t2Ksq7PPlZ0Upv9xvazKZbuSKJHycBavtCwn+srsZTMolUK
         7w2VRyAiO6ED+JlePkIVyFUARrTDxoVcG1TcyIRGcvOQJ4cgFNfCzWCKdkRLGX+ohEiA
         XtO6rwK5rNVWpLN/k4lHKGHv2taknSsfjZJYsuCgw0uhQOqENRaaAAIbZ4wZiUc5xdwR
         rl6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:references:in-reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date;
        bh=D56n3MxsMawE+Lyp4Aq5SKAUzUENiqVmEAQR38YMZ04=;
        b=Yu1Un2vZXhA+20LxfbYJE/LFXGj5gyFZYfC2EYW/l99cti5x4qJFYwtlAn3+xTLmLm
         +jAc5CV4VCDFbd8Big/1vB11CizT+4Z72s7S0NBPtulVNxOB0IQUXzIDl4GWY/HEsXsu
         E+jFDMFBuNCL6C/nqX5UfN9yQVANRhJ+5sZq5vkHfE4AAhrkQkCinG9IYKJ4DlS5eslv
         F9YIEIw54rBixSCovrKk17Ra+e1CXL71m9paCF3jA9xoSpfX+LesrfEm2Iv4VfqIhhn0
         zJRHEnv0Y3Y27JR20NpkspAomdF/BG0VomDPcv9sw6sPVvHi4V3eqeOVgtiK6fPtmLeE
         ZPdQ==
X-Gm-Message-State: ACrzQf3MOHfUWJd6OeBpimOA6lhecjRVdb1vzgmxGq3QE7m8mGWUUdVK
        NpqU4hBxrkpirpv8q/ly2EkpeVHMFLk/difTMDY=
X-Google-Smtp-Source: AMsMyM7C9TsEaoJAn5w3j/5I/2fwGOxe1hG11BOK+boOQaFvfl/s3ek3hv5NP5nwwVIIFZbP7KiH94J9ErTk0k0PJZw=
X-Received: by 2002:a17:90b:33cf:b0:202:5183:c1ab with SMTP id
 lk15-20020a17090b33cf00b002025183c1abmr5402949pjb.117.1663170014478; Wed, 14
 Sep 2022 08:40:14 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac4:93d5:0:b0:576:d591:b388 with HTTP; Wed, 14 Sep 2022
 08:40:13 -0700 (PDT)
In-Reply-To: <CAG6AZk=9Q9Ha32AOdzhJgBiWoDjPycBZ2m=BtQ2gxCW_=PE4bw@mail.gmail.com>
References: <CAG6AZkmh6Yju6zf-UGNd5bp7gXMs+o_cSVousPd2yLDp6wUgkQ@mail.gmail.com>
 <CAG6AZkmka9S7qTXYfre+zem6ArNf9=YTpgeweJj7xpMOT6idPw@mail.gmail.com>
 <CAG6AZkkQ=LQHWiLcPpXU=bSkp9qTfST4BhJWbk3r+-G+B4Pfqg@mail.gmail.com>
 <CAG6AZknUUZro5Gny4H_TALnLwMogLJ3+Vspg4j1opdA9kC+TbA@mail.gmail.com>
 <CAG6AZkmyXX1Yi3MqCnOEO9jyQp+Euz-_p4CT5Oau=qnb9_OUMQ@mail.gmail.com>
 <CAG6AZknAN_cxV9+S1A_D1m3uojB1-tHYfg7VG06y2M46VG8HJw@mail.gmail.com>
 <CAG6AZkmRLC=WQeqpyvbjWsrftuyD0PT0APDn6EY3m-PXfpMACg@mail.gmail.com>
 <CAG6AZkmvxQocTsXWKSf3j489npppHNQX2-eVowNJJr=g7L-vyQ@mail.gmail.com>
 <CAG6AZknZMFsec44gUArCWZ+9GHAcyUg0mo0LVpKF6ceB0zVVzQ@mail.gmail.com> <CAG6AZk=9Q9Ha32AOdzhJgBiWoDjPycBZ2m=BtQ2gxCW_=PE4bw@mail.gmail.com>
From:   Warren Buffett <kodjomonkli00@gmail.com>
Date:   Wed, 14 Sep 2022 08:40:13 -0700
Message-ID: <CAG6AZk=cEWuA4T7WvT0WVSu0Epzaw5zjJno2T9a0_6kMbh3Ytw@mail.gmail.com>
Subject: Fwd:
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=1.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLY,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
I want to open Charity Foundation/Company and help the covid19 victims
on your behalf is ok? for security reason Contact me (
buffettwarrenusa@gmail.com ) for more details Warren Buffett from
America
