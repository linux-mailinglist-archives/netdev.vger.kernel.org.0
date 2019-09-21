Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC71DB9BD4
	for <lists+netdev@lfdr.de>; Sat, 21 Sep 2019 03:22:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730577AbfIUBWG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 21:22:06 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:33444 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730495AbfIUBWG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Sep 2019 21:22:06 -0400
Received: by mail-qt1-f194.google.com with SMTP id r5so10846185qtd.0
        for <netdev@vger.kernel.org>; Fri, 20 Sep 2019 18:22:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=uqbDiFhi+SpGEof7P8uYRuqbipKPZz+UOlUVO+Pv2rk=;
        b=ufipxmKgrbivXMwQR0QBj/xHSj2tD/3QGVBkhZJJEIFiqYTJ5tfg1oERPXTX1ZbgPl
         phETyJf6+3yDXy0dcTQrsRl+6w9pIJYa5FgKELFyH2sO2kByM0q6chf8YTCI0i9iLFSn
         9mvhsUFErLXXgmHA4jR8uPXZVcy8wsZgZ+OMBNmYliKcMgayKIpzMI3Ro/c3y4Y7MZiw
         xVC/LdWljC0i3pqvUVY5Gu5lXFWNMJKs6oBWAROBqdUOZJXVoexMhsGesqiIltIZZAYk
         lSl2GK5Us8q3zngGpxY79O2IHaRxi7Ii3OA8MPxrmAIA+ST130hijUk5sLkswVQ7E5pY
         Fw1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=uqbDiFhi+SpGEof7P8uYRuqbipKPZz+UOlUVO+Pv2rk=;
        b=Q21iOBu7asmzzpf7WctaMr9a4K1dRiP4/y5Scgm3D5bZNm3eDIqjAC349qceBN5W6J
         oHt9/yLcSpapN/n98fg3j7b5kYLqt3tKXQS2JX54ohxPfNBjuaWLSpwKLHU3ewdZgBS2
         5c5TP2xy629n810cfQojJU9NjYXMi/M2FbJP/sxO8k17SjvmIzsII2WYlhZ5lnoDDsw/
         xmKrx/ocxC94OdAYNidNsi3+8ERETshRAOXrFoxZnWO8BWasCzXF445xDaMNQ+mLflEt
         b7AO+DIN0xZJmgoV7NSB1X+zaO0XzQ7oPJtZ8C0iQFj+91vziT4eCv1XsPN0jVR1cKIZ
         BXlQ==
X-Gm-Message-State: APjAAAXfEUQeeKXL7MHyUdqWuzslsxVUKErlUxlPUCqWykK7tMcpr8pH
        IZIXFoBHnDYjDbpt7etWQiCr6A==
X-Google-Smtp-Source: APXvYqx0HBYUzBlj31UtC8OHM7Ix81jjFzx4nLOgT3aPcrKWRQvK0knZIkviFwps950LCTt46iVe8g==
X-Received: by 2002:a0c:e94b:: with SMTP id n11mr351007qvo.11.1569028924814;
        Fri, 20 Sep 2019 18:22:04 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id d23sm1949938qkc.127.2019.09.20.18.22.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Sep 2019 18:22:04 -0700 (PDT)
Date:   Fri, 20 Sep 2019 18:22:01 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     David Ahern <dsahern@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH] selftests: Update fib_nexthop_multiprefix to handle
 missing ping6
Message-ID: <20190920182201.51745ddb@cakuba.netronome.com>
In-Reply-To: <20190917173035.19753-1-dsahern@kernel.org>
References: <20190917173035.19753-1-dsahern@kernel.org>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Sep 2019 10:30:35 -0700, David Ahern wrote:
> From: David Ahern <dsahern@gmail.com>
> 
> Some distributions (e.g., debian buster) do not install ping6. Re-use
> the hook in pmtu.sh to detect this and fallback to ping.
> 
> Fixes: 735ab2f65dce ("selftests: Add test with multiple prefixes using single nexthop")
> Signed-off-by: David Ahern <dsahern@gmail.com>

Applied, queued, thanks!
