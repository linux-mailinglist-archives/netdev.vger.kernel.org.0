Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 817A8A40A4
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 00:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728191AbfH3Wps (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 18:45:48 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:41121 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728143AbfH3Wps (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 18:45:48 -0400
Received: by mail-pg1-f193.google.com with SMTP id x15so4218058pgg.8
        for <netdev@vger.kernel.org>; Fri, 30 Aug 2019 15:45:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=4ORL+253kSVMyhcldg68MCd+1Ojv3DOq3WTveagu3vI=;
        b=GyGerK5X4Z0xVT/Y7322WkZN0jum9xKit7o9HZL5GCxVyesDXYQ3H3BeEF4goRP9nU
         fyl7vyugxrELU99v/KjkKdXSAMpEha9FYzCWBWWOao4hTKXjh1jo5iqrLnBNLFAk7rgd
         zQGMRlhy7/XeNtqa+OcX7ZEAog+cK4UWSjL8dy26kcYswdcSMwvrxEZe1EPz48NH0Ukh
         pBUME+H0pVEKrnS8087vQsWEBfDXLzO5eCtG1g0kxHAQk9i9CFzXDIuf3bpiBs28YRRH
         l4VKvtSxNWMi4PVnDsZdz4x1qlZEblxJD4fqVG8rIV8rCkqIn2UpTagItFTOa36z3YMI
         WGLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=4ORL+253kSVMyhcldg68MCd+1Ojv3DOq3WTveagu3vI=;
        b=BzgEH9GAOfy/k6QyFOeK2pXVqYM9ywPVLyDc/XhE7bn1IOsV0TLeQeo2iVilJr1jPc
         VZik61xVHoAI28HvhJJUwjOm3+UUquyfqGlsV4O/BOfDtk4D8AUvq0HIgzjDai1EChlf
         Q10KEtWZGT8yhuOaBfQxWmUDqYTgjksmiV7pmtgF61um0m4OpJJJ5oL1SMpiVkWLB5Bu
         tnNzT43YKCPeGy3aknidFaJ3O95aNgAJYFWWuXnTj4PkmFRIPRaS5egfdiXcLGGVVJve
         oQDlT75HHq4R9cprVT5vrRCcQszVOTBcsow6rwBFEIIg79fa1lhXoxKVNbRWQV+bV22C
         E8pg==
X-Gm-Message-State: APjAAAVx7Z/u1lGoqdQHFYwjobvt0TRXWEeQ4TxQWlRr1UxMu4ZJWwoK
        /3010LKC1NG55dc9KZuLTFBUWNm0qZA=
X-Google-Smtp-Source: APXvYqwCRnL7t8TO/mOoARGzUbyK0xL1ZFGiIJ2odej59HepK7EXdW+wXr1HwWjjruUz3anBxWDE/g==
X-Received: by 2002:a62:34c4:: with SMTP id b187mr21247288pfa.161.1567205147519;
        Fri, 30 Aug 2019 15:45:47 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id l3sm6520709pjq.18.2019.08.30.15.45.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Aug 2019 15:45:47 -0700 (PDT)
Date:   Fri, 30 Aug 2019 15:45:23 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     borisp@mellanox.com, Eric Dumazet <eric.dumazet@gmail.com>,
        aviadye@mellanox.com, davejwatson@fb.com, davem@davemloft.net,
        john.fastabend@gmail.com,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3 3/3] net: tls: export protocol version,
 cipher, tx_conf/rx_conf to socket diag
Message-ID: <20190830154523.1ee70d81@cakuba.netronome.com>
In-Reply-To: <39ad297f2b1f129b26c4a3461a1ae443d836da52.1567158431.git.dcaratti@redhat.com>
References: <cover.1567158431.git.dcaratti@redhat.com>
        <39ad297f2b1f129b26c4a3461a1ae443d836da52.1567158431.git.dcaratti@redhat.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 30 Aug 2019 12:25:49 +0200, Davide Caratti wrote:
> When an application configures kernel TLS on top of a TCP socket, it's
> now possible for inet_diag_handler() to collect information regarding the
> protocol version, the cipher type and TX / RX configuration, in case
> INET_DIAG_INFO is requested.
> 
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>

Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>

Thank you!
