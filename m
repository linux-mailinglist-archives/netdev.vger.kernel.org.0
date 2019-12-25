Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A33112A6C7
	for <lists+netdev@lfdr.de>; Wed, 25 Dec 2019 09:29:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbfLYI3G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Dec 2019 03:29:06 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39838 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726000AbfLYI3F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Dec 2019 03:29:05 -0500
Received: by mail-wm1-f68.google.com with SMTP id 20so3967959wmj.4
        for <netdev@vger.kernel.org>; Wed, 25 Dec 2019 00:29:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iaOOnwZrLRA1D2rC6zU+lT4hpZewI4ftBUV/i62MDHg=;
        b=HmPh62lFeuxrVNabz7gIZ7kv0bxrjsCdwuE6lC67a7LrOcP/NMHWeRSB3gXkAQ8b2V
         y38Q31XIlhvbGAd48CWSecbRB8Q2cs+8id2t+7ZQAmgXl3h6EO7rbci/ehFPFpEc/epF
         M69MJwBoBPkZduAeX7UxTkAsNFWsBuzattGvw+V6jw9zq26d9MfScQFScvEoTdDkLy2B
         IfkWeg06GZfpmw+rc7MiwIfJCPcbifxN34+RGGY7wbktTbsW0EnOU1xKS6d8AXQCjqTt
         VrtZ5BLbDSXaZWDCyn4bDUDCrPS6zj2CRM2StlrtIFp4xZkrITqDTtklcwpTvuS1alWk
         b/7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iaOOnwZrLRA1D2rC6zU+lT4hpZewI4ftBUV/i62MDHg=;
        b=nQCEUqmuO8Pc5mbXl638rxgY4yiUn7Hr4RLVdxQxdnrbB7RrKrv3I+O6dRviTFuc+B
         lKh7zzHFLxkn+VXgi5OY1DyOGvQahzZiDGr7QVu07oPKmz0pwpWHxE8rF3jjkCYX82Ba
         eFQXqEvKYfDy01gE791PzqqFab1E/spAIz3zlpEQahwwZ8S3Y87etTmrfjYpsB9a/sXW
         LSKp5hOj23rXEBs27q9zyDfK76M1YNk9eCRgcukKPKCCCQRubLVf5f6zl4469UI55ZkC
         30tlXtgj/FBEUZjizPFdobvHBNQYk1xuZWr5vGKBmOEqKrGRGit+AsA2+yBeHyX1iYM3
         oZRw==
X-Gm-Message-State: APjAAAU0bUaCxSQL71bwoLc5eDosimTFXPvU0HiUM/8VxFVfyLtrMs2v
        R7sKsqkzNLd84hHAuLhS5wU=
X-Google-Smtp-Source: APXvYqw+PjGXmSjK8DOQs/jrI10G7rWnH7YwZK69RasppzpmvphdyHVIli9H3OfUbm7vx7EVgSX3/w==
X-Received: by 2002:a7b:ca4b:: with SMTP id m11mr8354469wml.164.1577262543695;
        Wed, 25 Dec 2019 00:29:03 -0800 (PST)
Received: from blondie ([141.226.11.88])
        by smtp.gmail.com with ESMTPSA id k8sm26765778wrl.3.2019.12.25.00.29.02
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 25 Dec 2019 00:29:03 -0800 (PST)
Date:   Wed, 25 Dec 2019 10:29:01 +0200
From:   Shmulik Ladkani <shmulik.ladkani@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        "David S . Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>,
        Shmulik Ladkani <sladkani@proofpoint.com>
Subject: Re: [PATCH net-next] net/sched: act_mirred: Ensure mac_len is
 pulled prior redirect to a non mac_header_xmit target device
Message-ID: <20191225102901.4068b3b1@blondie>
In-Reply-To: <CAM_iQpWLryJ+gPyzQEwj1kF+z7sfY50mtwmNX=swn44LP0npQw@mail.gmail.com>
References: <20191223123336.13066-1-sladkani@proofpoint.com>
        <CAM_iQpWLryJ+gPyzQEwj1kF+z7sfY50mtwmNX=swn44LP0npQw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 24 Dec 2019 12:43:32 -0800
Cong Wang <xiyou.wangcong@gmail.com> wrote:

> This is a bug fix, please target it for -net and add a proper Fixes tag.
> 
> BTW, please make the subject shorter.

Thanks. Will resubmit to -net
