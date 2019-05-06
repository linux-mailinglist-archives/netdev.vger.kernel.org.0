Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CD3515086
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 17:43:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbfEFPnN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 11:43:13 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:39696 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726298AbfEFPnN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 11:43:13 -0400
Received: by mail-pg1-f195.google.com with SMTP id w22so5332023pgi.6
        for <netdev@vger.kernel.org>; Mon, 06 May 2019 08:43:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YFDcb2GDO2Kxv2PPfJ3SQUvp0mS5049CM6AN1LgUruk=;
        b=TbgX6rzDOfL58FgV4KyR14F1xu447zfrXHQ4t7MSnW4gYIMgp8eKftRluEsP1LeJtS
         8s/754uI5pE6wvLDvR+wRppZl2uwoqavkz2ayH/Rfs413mqGTrqCbzP/lovoiUF7z/IJ
         KmZkzM6nBBigWyv0qZyL48zGitIcjHVeDzJTJzcVAaRD3freVcFmgdjCWvI0yBv07oaO
         n0kzry+nTqZVjTwPIZWq1T64rS6LyXLZW6AmeNMroV3xBaQyPHHP40bCX4wF6QYpCe9q
         zumwCAA452VfjN/LP7jiUk6nfSFt0T3CZSZ2BAM25YfwvZ6yjp59EthErcqPp2Qox6Kj
         lVyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YFDcb2GDO2Kxv2PPfJ3SQUvp0mS5049CM6AN1LgUruk=;
        b=CMPcId6maNbqWRAxRcucgEHJQkDvxQ+UevchTaaGiHi2tyqa0bxA0oH0F1BALgER3r
         WebTSjZrnkGunjXN+7D1Hw0UQDxOUGbNG78RlBR7+v0pwwIyPmPt3nEy9m/J7K/ZNwVv
         XealSPP9k4AEpXupFokl2bjjw2EwdSiaPSXCoMFH2IjsaMeafxiW/VfveRzHNHeR7fnj
         MxwV1eq3M6Qopy96L1YoNk/htDzpEb6AkYMZTgFb1gKUjvUw4WoyS6qpvKM0kj1Mdmod
         4AkH7q895YiwBBuaiYWTjP1DPQ5zb4BlC9vhtLm7sy9ggrQ01V647k5uDpMqQsosNwHM
         K3tw==
X-Gm-Message-State: APjAAAUAPXHmFX8o1UI85Ew15xkDl3VhTxT1I1KUM8/ai803ZNjS4ZDZ
        0lSPHZZ4hAqsB7zX7c/7vBwojg==
X-Google-Smtp-Source: APXvYqxSVv2RJhZwT8L9BHTt50iqu/CsNwqIviSqR/l0M3AHncMrjqIqvlPIswS48Q2/CiJ1W4byzw==
X-Received: by 2002:a62:5c3:: with SMTP id 186mr28115047pff.116.1557157392779;
        Mon, 06 May 2019 08:43:12 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id k67sm18062805pfb.44.2019.05.06.08.43.12
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 06 May 2019 08:43:12 -0700 (PDT)
Date:   Mon, 6 May 2019 08:43:11 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH iproute2-master] devlink: Fix monitor command
Message-ID: <20190506084311.152bdcef@hermes.lan>
In-Reply-To: <20190505141243.9768-1-idosch@idosch.org>
References: <20190505141243.9768-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun,  5 May 2019 17:12:43 +0300
Ido Schimmel <idosch@idosch.org> wrote:

> From: Ido Schimmel <idosch@mellanox.com>
> 
> The command is supposed to allow users to filter events related to
> certain objects, but returns an error when an object is specified:
> 
> # devlink mon dev
> Command "dev" not found
> 
> Fix this by allowing the command to process the specified objects.
> 
> Example:
> 
> # devlink/devlink mon dev &
> # echo "10 1" > /sys/bus/netdevsim/new_device
> [dev,new] netdevsim/netdevsim10
> 
> # devlink/devlink mon port &
> # echo "11 1" > /sys/bus/netdevsim/new_device
> [port,new] netdevsim/netdevsim11/0: type notset flavour physical
> [port,new] netdevsim/netdevsim11/0: type eth netdev eth1 flavour physical
> 
> # devlink/devlink mon &
> # echo "12 1" > /sys/bus/netdevsim/new_device
> [dev,new] netdevsim/netdevsim12
> [port,new] netdevsim/netdevsim12/0: type notset flavour physical
> [port,new] netdevsim/netdevsim12/0: type eth netdev eth2 flavour physical
> 
> Fixes: a3c4b484a1ed ("add devlink tool")
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>

Applied, thanks.
