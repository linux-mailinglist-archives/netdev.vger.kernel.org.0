Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C07448AC62
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 03:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbfHMBLL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 21:11:11 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:40231 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726500AbfHMBLK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 21:11:10 -0400
Received: by mail-qt1-f194.google.com with SMTP id e8so4301304qtp.7
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 18:11:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=5sHEq2jGDga6Wm8k4+Sp8FG3Gq7u0q/8f4fmUBaggwU=;
        b=X+zmkH+Fk1FTW4E1qU+rN3gM7O0g5VmVk37KzI+rTlDtjJGOV91O80CVp65ebE+uNm
         U5kpieKTzG8mCYhGkgrV98xisWyIi80S9Jlcyy6esaT9UjJAs2W0MFKR1lAouUHSFl2T
         Q2TjgutWeGbzpFx78dhqgbe7nio+4fULQTcZ0CdooNwaYK+EGLQ9SDQ1tz739xlH0hfa
         zoY3UafuZyr49fuJQV+kitphBA/Lfpp53sMzEAdsqpbxJ2RPDqe70NhoNO9VBax1Wblg
         sdQ25+mhstfN07i4mS6dokSxtMWsvErAzjDlhweu+HdjoHfOxKJncmmaWtMqS/3IQUK3
         EqpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=5sHEq2jGDga6Wm8k4+Sp8FG3Gq7u0q/8f4fmUBaggwU=;
        b=EvMXlx4fOxC0oOZPrRikrj0alB2e2rkBRkaCC787nrotxPmayDJr9fWmTOtNcgAk5u
         LHt3pR0IdUcQaoBGBKbcDmsWctemkIZzCwLLDZYyvX9G/ZMFLAkykT3r+VyRcIOaApV0
         EfDYSzzyt6IBBvQVfOsZrAd7tlIZVRShv7Ac/5xkvY8uGj4h4Tmf2EiBEy9SwlVDWxBj
         AA+8vjwCT20qQ8ecdykZYNfLUN9MLOcDtzCL1sx9mkiI0iKMY7nF1VWPPvqjzfk5ZFFT
         ebV5QKEKlKKu5dTw9N8SugUaqFVekEJMPDx+sYyToyli/7oLguCwr4TjhCtVLw9P4j1C
         +8tw==
X-Gm-Message-State: APjAAAVkKKQnbbjFTpFTrYPkqf2Bx0O/hNksh8t6xncvZfMJCFipRUFb
        f1ZX/Ng9NgykS5luPJa3G2piRQ==
X-Google-Smtp-Source: APXvYqx8M4ZB9h3aVy7WHh2suLsPvqeoGjGnjtQlMF0/dl+uycAPKlDgM0bHrSIk4MVxIvBG0GORBg==
X-Received: by 2002:aed:2fe1:: with SMTP id m88mr31519739qtd.77.1565658669996;
        Mon, 12 Aug 2019 18:11:09 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id b127sm5477347qkc.22.2019.08.12.18.11.09
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 12 Aug 2019 18:11:09 -0700 (PDT)
Date:   Mon, 12 Aug 2019 18:11:00 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        davem@davemloft.net, stephen@networkplumber.org, mlxsw@mellanox.com
Subject: Re: [patch net-next v3 0/3] net: devlink: Finish network namespace
 support
Message-ID: <20190812181100.1cfd8b9d@cakuba.netronome.com>
In-Reply-To: <bfb879be-a232-0ef1-1c40-3a9c8bcba8f8@gmail.com>
References: <20190812134751.30838-1-jiri@resnulli.us>
        <bfb879be-a232-0ef1-1c40-3a9c8bcba8f8@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 12 Aug 2019 18:24:41 -0600, David Ahern wrote:
> On 8/12/19 7:47 AM, Jiri Pirko wrote:
> > From: Jiri Pirko <jiri@mellanox.com>
> > 
> > Devlink from the beginning counts with network namespaces, but the
> > instances has been fixed to init_net. The first patch allows user
> > to move existing devlink instances into namespaces:
> > 
> > $ devlink dev
> > netdevsim/netdevsim1
> > $ ip netns add ns1
> > $ devlink dev set netdevsim/netdevsim1 netns ns1
> > $ devlink -N ns1 dev
> > netdevsim/netdevsim1
> > 
> > The last patch allows user to create new netdevsim instance directly
> > inside network namespace of a caller.  
> 
> The namespace behavior seems odd to me. If devlink instance is created
> in a namespace and never moved, it should die with the namespace. With
> this patch set, devlink instance and its ports are moved to init_net on
> namespace delete.

If the devlink instance just disappeared - that'd be a very very strange
thing. Only software objects disappear with the namespace. 
Netdevices without ->rtnl_link_ops go back to init_net.
