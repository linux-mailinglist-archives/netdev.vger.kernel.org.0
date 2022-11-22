Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 000B26331E7
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 02:08:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232169AbiKVBIc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 20:08:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232192AbiKVBIM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 20:08:12 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2BD0E2236
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 17:06:39 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id l12so21330356lfp.6
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 17:06:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fZneW5pahrcT4T2dDD0v5a/T6rdlQocV9RMRy7IKFtE=;
        b=JctTdb9gNpAwOuK2G6VOtQFDTDqf6WTIK7tUhldDdqQ2XgWXz4UTLvFIuF//u2sHfW
         Zjex56jvWGJD/Ntqp9ViI5vKbL3FqQD47ELCpPgNqKH2rS7XofYnWqsglQ81jCDOzxox
         NlX3aydzi05lZQtdVIQyDIiGPw0uJnfaLVAvnzd8sFzFJsOJmRE7u36LvN9GZADQJig/
         fkO3KGwMsuISJPBI3ebE3qUnKQP54JLJmwcb7e+3PXxAl4Ej9Vi0W1OWMXGaNROfzsiZ
         rx1GucYTNaUs5n+omSLB9HZF33d0w0nc5LaN8uRovj2QniTH3m25B6dfpDDcqHUY+OL0
         UHSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fZneW5pahrcT4T2dDD0v5a/T6rdlQocV9RMRy7IKFtE=;
        b=w+u4LzmcpLGODRT3SrwCJ3vmPwpwTHUlfeX+tcRdroRTEhUOTZebnKjBEYdqi0rcYC
         z7pruhI9M6cxz0DGyhpvX6X7HU4iD1sQzgpcn9qxP75gMCQFxsIpWaW3Jvg6dD/bFCM0
         JZ9B63WPbCoRBFFdq8RUwJsR6RVUBNr9X3tGNKEHbO2zGUew8F+mLTHPuqxLiqdNR08E
         bx+y52IjXbVq5abSYgmkH/mVmaxmDGMTttDLnXkA/suvSw01SdzJpKDcgnEXSOTmECxT
         naOfnVkk23e+8Z6RSvMWqzRepw0BQkH5yYft1v5plSiH02Whz8ex2h16x4MwwKWIwudx
         Mr6w==
X-Gm-Message-State: ANoB5pmym1xXYxSxYy7Xhpk+y0dxwBz4t7EVErBDwhJtxsmCJtg0ePzL
        O32ZxlvtqcGwUzlxPMPUTS9Rr2RjeuwmE+79soM=
X-Google-Smtp-Source: AA0mqf5lfMMCVPgxdv8MwrAnTWfDwW42blHF1xkxuBq3Bcqx2Ls5OUaiEBQKXfoLntX8qQ+Ijh7KYRYwTZYi3HkypCo=
X-Received: by 2002:ac2:48ad:0:b0:4af:a599:f058 with SMTP id
 u13-20020ac248ad000000b004afa599f058mr6532942lfg.49.1669079195284; Mon, 21
 Nov 2022 17:06:35 -0800 (PST)
MIME-Version: 1.0
References: <20220816102537.33986-1-chenfeiyang@loongson.cn>
 <Yv2hlkIpd8A66+iP@lunn.ch> <CACWXhK=YF+z0wofjDAo7XW8cSV2NZgHpAK3u5=rkvvKTd8MjFQ@mail.gmail.com>
 <16d361992b707848c0b0258ad1d0e4c3958155e7.camel@xry111.site>
In-Reply-To: <16d361992b707848c0b0258ad1d0e4c3958155e7.camel@xry111.site>
From:   Feiyang Chen <chris.chenfeiyang@gmail.com>
Date:   Tue, 22 Nov 2022 09:06:23 +0800
Message-ID: <CACWXhK=M7E52aZevK_CZFdsoLrKm071LWtnoyBrFu8-9Wc5B8w@mail.gmail.com>
Subject: Re: [PATCH] stmmac: pci: Add LS7A support for dwmac-loongson
To:     Xi Ruoyao <xry111@xry111.site>
Cc:     Andrew Lunn <andrew@lunn.ch>, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        Feiyang Chen <chenfeiyang@loongson.cn>, zhangqing@loongson.cn,
        Huacai Chen <chenhuacai@loongson.cn>, netdev@vger.kernel.org,
        loongarch@lists.linux.dev
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

On Mon, 21 Nov 2022 at 21:03, Xi Ruoyao <xry111@xry111.site> wrote:
>
> On Thu, 2022-08-18 at 13:01 +0800, Feiyang Chen wrote:
> > On Thu, 18 Aug 2022 at 10:19, Andrew Lunn <andrew@lunn.ch> wrote:
> > >
> > > On Tue, Aug 16, 2022 at 06:25:37PM +0800, Feiyang Chen wrote:
> > > > Current dwmac-loongson only support LS2K in the "probed with PCI
> > > > and
> > > > configured with DT" manner. We add LS7A support on which the
> > > > devices
> > > > are fully PCI (non-DT).
> > >
> > > Please could you break this patch up into a number of smaller
> > > patches. It is very hard to follow what you are changing here.
> > >
> > > Ideally you want lots of small patches, each with a good commit
> > > message, which are obviously correct.
> > >
> >
> > Hi, Andrew,
> >
> > OK, I will have a try.
>
> Any progress on the refactoring? :)
>

WIP :)

> --
> Xi Ruoyao <xry111@xry111.site>
> School of Aerospace Science and Technology, Xidian University
