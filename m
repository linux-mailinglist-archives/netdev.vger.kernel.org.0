Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4963A1745E3
	for <lists+netdev@lfdr.de>; Sat, 29 Feb 2020 10:29:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbgB2J33 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Feb 2020 04:29:29 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:41618 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbgB2J33 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Feb 2020 04:29:29 -0500
Received: by mail-qk1-f196.google.com with SMTP id b5so5456502qkh.8
        for <netdev@vger.kernel.org>; Sat, 29 Feb 2020 01:29:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Tz+sWrvQx18W96eXVM/FQAR/Yb7nmeGGPefJ4HA/Erc=;
        b=ep6sppj/ogA0tnZAe+f/wcQv6pKpI6MLSThrNC5KB4VnI38pvdfL3N2GC4QrlkKG9K
         +Tb0PKOE52QqAJyezxAL/ud2NeUu5xywrUjgdl23KFK74011tACLMt8PewZO1ef8nPL8
         V4VZ9hFk1jIC5+FV9aWS/34gDzxfx7dhnmbIGAZPqtlqIN/6zgmJqESv3wUq061IeWL3
         QMNszKqv9RjqFgf7OU7BQVrl0yK+FTG5bUUr9vXdwPUYW8pOlAzSJG0z7cwelcCF8lw0
         cu4UC7TYOjf0ylKogPf5LB1lFURFyAkemv1CajTiYXEbckNv4Kmoxo8s6vmfT0kdRMRO
         fxcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Tz+sWrvQx18W96eXVM/FQAR/Yb7nmeGGPefJ4HA/Erc=;
        b=XfjOn0XECk3aAx+mE7aFWBirTU6Q+trT3kBM/K0Uv5+P9QvEG8eE5wHJ47aXJPlFzC
         ZGvZ3VRSOq7fcxijldW70Q71lewQZlueDtoIoymYmzd8Tvw7I3RT/zfRUgxGuwnE765G
         EXQJD5c3k2/jnUlSezds1ALwsht7Ig4N7V1yJsTCZpslc+HfLMWLVepPMKPn2uz82Xnj
         u0j62Pz0T8mxdvn55ImDix3kbZa6HlbF21psrXbcdit6rP/Jai1Vlm5PgPqqWP5Zpcj5
         Al1u8UCbXD2GD9jAA/GPU5TxvnCE0wo6MxaILFCvGhmpVF8alj2ZIv5E7MrISf7Ag1ha
         izAQ==
X-Gm-Message-State: APjAAAW6XGpB7w8T/bf0TOBqbvYPeiTQTdGPqJ1534DZJnUj2X2CYdSa
        LKkwDb0FiSTw91mQrpOQARQ=
X-Google-Smtp-Source: APXvYqz4GALEFiL036KS8Y0L0DQjW7hnrYlUiVoFxZ58I3f4ONEmMwX/r1l8kDrsa1SdPhZ9gS1Wdg==
X-Received: by 2002:a05:620a:2239:: with SMTP id n25mr8033869qkh.147.1582968568511;
        Sat, 29 Feb 2020 01:29:28 -0800 (PST)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id n38sm3588529qtf.36.2020.02.29.01.29.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Feb 2020 01:29:28 -0800 (PST)
Date:   Sat, 29 Feb 2020 17:29:22 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, Jianlin Shi <jishi@redhat.com>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH net] net/ipv6: use configured matric when add peer route
Message-ID: <20200229092921.GU2159@dhcp-12-139.nay.redhat.com>
References: <20200228091858.19729-1-liuhangbin@gmail.com>
 <5ad3ee1d-32d2-c84d-ea8a-f4daf44b4fa1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5ad3ee1d-32d2-c84d-ea8a-f4daf44b4fa1@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 28, 2020 at 09:50:45AM -0700, David Ahern wrote:
> ugh, missed that one. Thanks for the patch. Please add the tests in the
> commit message to tools/testing/selftests/net/fib_tests.sh,
> ipv{4,6}_addr_metric_test sections.

I will, thanks
