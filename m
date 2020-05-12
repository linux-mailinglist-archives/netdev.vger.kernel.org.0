Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D651A1D00D8
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 23:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731065AbgELVZr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 17:25:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726268AbgELVZr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 17:25:47 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07286C061A0C
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 14:25:47 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id x5so6694153ioh.6
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 14:25:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=xvU4oxQbNTcOIq498Yw+l1mtZyKUpLkWiMZJgcrZo0I=;
        b=dG5yhBEFgwQPH66XklA9auezxk/1PD3pHxArPDs06tp2kMtqPHyMXKkRN+hLLSa50W
         gZZmbP0owFhQlX1fWYREIIuawbrTqP3KfzJEQ/GLrKBCkLvTX75c9O10ug8QK1wJ3mGF
         kH32omurEIbkqLaN/v248ryxJicxu978x0WQjBqjmufGpF20LfQihEHCSbhhkgpYXmjt
         5zBf+yNyUq/fNo4q/wZ+/FDBcCXST+M+ULqVVA916y7i+y7CGpLa1X/jK1fz0xUy9m8Y
         cLcUcokWf3PywHI0GaRt5oQJjTFG9dPdDFaIqtLQEW4eto/uOHI90rw+3/YAmyaqcAkW
         wvyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=xvU4oxQbNTcOIq498Yw+l1mtZyKUpLkWiMZJgcrZo0I=;
        b=oJfLWvTwFbRoZKeXNJHPo2Yu1XwpCzTS7AZ1zCe+Iy0n4DzPZNSvjzFPbR+Lxe+evE
         g431shrjOAywt4vXToNMaFgVL/pyNunMq6lPTkbcLly47KaV8RuAjALiSWgaxIE3zb9g
         kmpAPI8ifMJF2S0H849wkinmYHJSitQFXOIMphIEeTqp1wi3a4rReiOP32uAXPzwKhwV
         7bVhb+/ZJ7G/ywSkwzpxn6mDDpxQk9AN11uJI45QynX1LImrLecksyGYX+6dCHXcjh5j
         mF+2An3nhlOog7h3q/11AXrVLPYLA8WuSDj5NQlZGmDz75dmrSm1wwEYqO/POJ+5Njfn
         OE1Q==
X-Gm-Message-State: AGi0PubV9PutPTx/sxIG9Y2jzoABhWP4yfHy42hJqyc/WVqp42m8Byfb
        oAZKVtOKlCXMxEZ0nJS7E0MefvkQl69tuwzI7fBcp7o8
X-Google-Smtp-Source: APiQypKz2rQj1A3qFC17+5Idncjf3UaDYOes30Yhq41u5ixdQustG0JcWIRszOHaNPYTRM16FG5EOH1cdkU4ckTrJXk=
X-Received: by 2002:a02:cd03:: with SMTP id g3mr21945404jaq.61.1589318746139;
 Tue, 12 May 2020 14:25:46 -0700 (PDT)
MIME-Version: 1.0
References: <CANP3RGe3fnCwj5NUxKu4VDcw=_95yNkCiC2Y4L9otJS1Hnyd-g@mail.gmail.com>
 <20200512210038.11447-1-jengelh@inai.de>
In-Reply-To: <20200512210038.11447-1-jengelh@inai.de>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Tue, 12 May 2020 14:25:34 -0700
Message-ID: <CANP3RGdgrYaisD2Ecc9Uqzpay6ADGu+3rmTP0PDohfDT7=7TfQ@mail.gmail.com>
Subject: Re: [PATCH v2] doc: document danger of applying REJECT to INVALID CTs
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Linux NetDev <netdev@vger.kernel.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reviewed-by: Maciej =C5=BBenczykowski <zenczykowski@gmail.com>
