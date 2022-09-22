Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBAB85E692D
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 19:08:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbiIVRIa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 13:08:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230256AbiIVRI2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 13:08:28 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B96FFF3FD
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 10:08:27 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id j17-20020a9d7f11000000b0065a20212349so6629696otq.12
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 10:08:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date;
        bh=NsLp670RdI3g1jDRkVkeaW3CVX2HSxEN1Ogh5i9k9LY=;
        b=IEKLSGYZyAft4XxWcA4PD4UttV+HgJmCgq5nMaXUm4o2EF1aOrqRwi/FjAPgXePFO5
         1ioPjw3VrpI42US2WJWHxn0GCPmZUch7f5WDUnnF6MKmI8f0XJdriigXi4iChVKnQ25m
         iscb/XcXlYEB3a8Pco4Nxcl0te/TwAFzeS85BH4mjJJWMYAAHScb5hT/nsR9VBjQ6WCo
         sROWS/3uxZymCkF6Ps/YA3DK4rau/j/1SPrCKcHMdRbBrO2Uw8FIZUsIbap3cgvpJffW
         j1AznO+MB1ZOgWS2AMbMuzhi9nR3L8jy+PtF2/9eYYryjUTgo7EU7BMub6gFsARSyVH2
         /0VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=NsLp670RdI3g1jDRkVkeaW3CVX2HSxEN1Ogh5i9k9LY=;
        b=HGfJ1IvowP4QU2jEtWWAJyFf9/AB49W0NIokNquqKeWw5Zam2se0LjhtQixM60x6/R
         peZvlUwKto0Sajlafd6VhN3ldq53QGzRG1B70107OQlH7Ok4rMFmZGjRFCfZKgr4A3ZB
         //evxAyJNBIl7Q1iiBZ6pq0TLhtSxwlKQ1PlqmN55Lh1ACHTR9lSckgGxjDR4yu1E2He
         D4kPQxKu6A6ONIRiB9Um+WBIECfWfaSTGOoT4PSDiXEUYZUJJeBcWHdFHq4hBgAMRjd6
         AH8y1NoRJDrIpc2xW0m8U8ZJPQEeO78OJcecMFasmj6p3CDwAGYYg1UQhpn0+eexJ0wg
         2nhA==
X-Gm-Message-State: ACrzQf3jhXi8LcIJNVC55UyQrIv9bG6ePC5zbQEgsKXJWCVIGPkbBPag
        6pYi5RL8fgsJCduByIjp8aZ529gmf+c/Lunx0eEzUw==
X-Google-Smtp-Source: AMsMyM4GcKX0bCdneB/J/ZUwyoJzNyhgBt62WBUXi/PfZoJvLFtvtjK7mNxiF89ZH9QB9THsbU0/0Qku63ByaVTi1MI=
X-Received: by 2002:a9d:7a8a:0:b0:656:284c:d5bd with SMTP id
 l10-20020a9d7a8a000000b00656284cd5bdmr2142775otn.52.1663866506690; Thu, 22
 Sep 2022 10:08:26 -0700 (PDT)
MIME-Version: 1.0
References: <20220921114444.2247083-1-gregkh@linuxfoundation.org> <YyyH1oXMubeQ8KVu@shell.armlinux.org.uk>
In-Reply-To: <YyyH1oXMubeQ8KVu@shell.armlinux.org.uk>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Thu, 22 Sep 2022 19:08:16 +0200
Message-ID: <CAPv3WKch2J4tteo68wOt_ETj_eYEKy8EC5sTwDvW6UZ-Gs_sCw@mail.gmail.com>
Subject: Re: [PATCH net] net: mvpp2: debugfs: fix problem with previous memory
 leak fix
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, stable <stable@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Thank you both for the patches.


czw., 22 wrz 2022 o 18:05 Russell King (Oracle)
<linux@armlinux.org.uk> napisa=C5=82(a):
>
> On Wed, Sep 21, 2022 at 01:44:44PM +0200, Greg Kroah-Hartman wrote:
> > In commit fe2c9c61f668 ("net: mvpp2: debugfs: fix memory leak when usin=
g
> > debugfs_lookup()"), if the module is unloaded, the directory will still
> > be present if the module is loaded again and creating the directory wil=
l
> > fail, causing the creation of additional child debugfs entries for the
> > individual devices to fail.
> >
> > As this module never cleaned up the root directory it created, even whe=
n
> > loaded, and unloading/loading a module is not a normal operation, none
> > of would normally happen.
> >
> > To clean all of this up, use a tiny reference counted structure to hold
> > the root debugfs directory for the driver, and then clean it up when th=
e
> > last user of it is removed from the system.  This should resolve the
> > previously reported problems, and the original memory leak that
> > fe2c9c61f668 ("net: mvpp2: debugfs: fix memory leak when using
> > debugfs_lookup()") was attempting to fix.
>
> For the record... I have a better fix for this, but I haven't been able
> to get it into a state suitable for submission yet.
>
> http://www.home.armlinux.org.uk/~rmk/misc/mvpp2-debugfs.diff
>
> Not yet against the net tree. Might have time tomorrow to do that, not
> sure at the moment. Medical stuff is getting in the way. :(
>

I'd lean towards this version - it is a bit more compact. I'll try to
test that tomorrow or during the weekend.

Best regards,
Marcin
