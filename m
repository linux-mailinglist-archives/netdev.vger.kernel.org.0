Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3A7A41A6EF
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 07:11:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234121AbhI1FN3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 01:13:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233360AbhI1FN1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 01:13:27 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A690C061575;
        Mon, 27 Sep 2021 22:11:49 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id z5so29086659ybj.2;
        Mon, 27 Sep 2021 22:11:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=wNEfN9GmMm8ACv81lqq2HdxH7rVZO3hCMzGo5Sw7PQU=;
        b=FIhRutqSFdUoxNQZ7x0XryqsiEDitpevaKU+YiBk+prwVwyUQdEhk3h79XNY6a+Mt3
         Rpr/R2iexJsWzWiRFwcHQcEKgyYR2mBgebSflfxpIyC/rZqbJgc46rdvzLWce54okk4p
         esSogxXFBqtwBhvG+MHu38LfXnNCqLbVCVmdghr/n8pUBhtM/eyuDABiF+tEzWq3f6V+
         I2D2c1Vh7tfUu+Hg4JL7o3SGTAOeeeuxy1Xop3cmQCOFMOKIE5rl86ntdANAv2GlIx4O
         K8DaTKTH7jlioBNbQpRKBZnN6Wse53TkENraJEQ+PnF+5s8Bb9jKPbpWaWBiIHUo3DnZ
         TCGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=wNEfN9GmMm8ACv81lqq2HdxH7rVZO3hCMzGo5Sw7PQU=;
        b=sVTdlmJCqqz80fVRdvvrJswlW3pka9/xHJXQTaMk18CLAvojPN5qmkkpiuEIGQEdDn
         6+fhTmo4GSGMnoxh7HOktqK1a1CZ3+jTio0/ZNXU9A6BjwkDo8d3upiONU1BvTVl5JR7
         oBYJte/9WQf2GiRu6E8QJUkUtJJfihKA508WTYzksDLq1o4LKhqmCXY7Bnwd/e16cTHU
         zePLMr0LLsmzH1ZSSV0uTzErOpstSxcNs2wTBHoxJQEM18sfh3mqKqFZeL7kwsjdlTKz
         BAQ5c8yHGw1+DbgiXmOgSAskgHEg83ux7zE28rMhQlqI881vsWmj3oiqcvtxJno8n7WE
         DauA==
X-Gm-Message-State: AOAM532ktqmb7Yx7AuEyhOZPmIAdad+3+c16gYLbmnEWkJDSH6dJA0LG
        JxBmvU6mxP1sqKeF+UMLj3v8+YKJGztXE9/lDVE=
X-Google-Smtp-Source: ABdhPJx8PfS0ekL23tdi9Cif7wuhcC5t+p7cVqHIL/D/je7dbzKITW8RmPJdgp4VsKaAsZfhn2t1fgxj/R39tcfkqiQ=
X-Received: by 2002:a25:c88:: with SMTP id 130mr4196234ybm.176.1632805908028;
 Mon, 27 Sep 2021 22:11:48 -0700 (PDT)
MIME-Version: 1.0
References: <cab456a9-680d-9791-599b-de003b88a9ea@linux.alibaba.com>
In-Reply-To: <cab456a9-680d-9791-599b-de003b88a9ea@linux.alibaba.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 27 Sep 2021 22:11:37 -0700
Message-ID: <CAM_iQpUuST2d0LZ5i7dqz=E1uL4Wiizf5WNbdJ=vc-9MR20SyQ@mail.gmail.com>
Subject: Re: [RESEND PATCH v2] net: prevent user from passing illegal stab size
To:     =?UTF-8?B?546L6LSH?= <yun.wang@linux.alibaba.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:TC subsystem" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

It has been applied, no need to resend.

commit b193e15ac69d56f35e1d8e2b5d16cbd47764d053
Author:     =E7=8E=8B=E8=B4=87 <yun.wang@linux.alibaba.com>
AuthorDate: Fri Sep 24 10:35:58 2021 +0800
Commit:     David S. Miller <davem@davemloft.net>
CommitDate: Sun Sep 26 11:09:07 2021 +0100

    net: prevent user from passing illegal stab size

Thanks.
