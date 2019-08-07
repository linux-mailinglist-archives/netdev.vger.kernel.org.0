Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A19385376
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 21:15:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730328AbfHGTPB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 15:15:01 -0400
Received: from mail-qt1-f181.google.com ([209.85.160.181]:42176 "EHLO
        mail-qt1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730145AbfHGTPB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 15:15:01 -0400
Received: by mail-qt1-f181.google.com with SMTP id t12so942568qtp.9
        for <netdev@vger.kernel.org>; Wed, 07 Aug 2019 12:15:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=Gk29u+taprDfKSXcEf+eMZe69D0U83Ltv5297XkN8gQ=;
        b=XnYoH7pcRbq61QtnjQh5N446HxYmrOuTSGF+8RiiWG6VJkVSVYsSDDPnr9Ff6XVDXe
         rsBsfPneXiZUTkly/aPcCcwYIvXBhaMBHiDEDCuUzVVey9hAhe2pmrC8brVvEaBsiZY4
         I3BvjZqN4Zk85mgH4maK71nCwwCoQyS+Lx8OFnYbxQFKyRWAbQFjMp2qawpHCOD9tIT9
         vT9sIiUZrn+YYqG801fExFV5Ob0fD+WvzGQfa0twtvkGR2NsZS/maNlys2Vfs2RetvLy
         Hnyw9dvu5XX97UOyR/10Yzc7I1noonYIvmxPsSSm33MGGZKRmtKiu2lMy0Tv2k8my4b9
         uLmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=Gk29u+taprDfKSXcEf+eMZe69D0U83Ltv5297XkN8gQ=;
        b=ZHFG3YWDRD9d7ibqdhwgLPT7keLhg8TZN1Dd3YNGXCSnpvQjtwkcY47QDrhUZBrb8Y
         VDKd1b162xfrq1V4vL60RG6Imni3w7m9JTFBI6pt9auz36Y9+GSSSm0tTqL4DH7RjoMc
         gq615OvRZdQJNjFEi4eugAd3RRh5XcGv0C1WO5qwYymXYqEvdvBIWmBWRkQCqFNLX1Q5
         WG+zoA07M6U107LRpvMhNFcrt/ItoYLljR1bJ2IOJPbiIRvX8htaArN0c1dwMAF+2EiE
         jygYKTEzU2Q8bXZaXFPZH0ybuBGdB1Osy4O26yTGCUMOT26P1GqQ5oLC75CzNkHc7j98
         yX4g==
X-Gm-Message-State: APjAAAXf4zTaNfM1MgOEO9cqXiGjQuBowVCO5huRAKHVVWi6+59KOIYI
        uofAZn/krBa5qzlO7EuQZu7/fQ==
X-Google-Smtp-Source: APXvYqwEXxh3lEBNgCxaHHVdp7vuqGTYhpK/y2PhT6UWsph0vx5NdKQXECMa+9Si5WGI67x+6Chs8w==
X-Received: by 2002:a0c:b095:: with SMTP id o21mr9924309qvc.73.1565205300286;
        Wed, 07 Aug 2019 12:15:00 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id b18sm35766652qkc.112.2019.08.07.12.14.59
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 07 Aug 2019 12:15:00 -0700 (PDT)
Date:   Wed, 7 Aug 2019 12:14:31 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Y Song <ys114321@gmail.com>
Cc:     "Daniel T. Lee" <danieltimlee@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [v3,2/4] tools: bpftool: add net detach command to detach XDP
 on interface
Message-ID: <20190807121431.434ef32b@cakuba.netronome.com>
In-Reply-To: <CAH3MdRW4LgdLoqSpLsWUOwjnNhJA1sodHqSD2Z14JY6aHMaKxg@mail.gmail.com>
References: <20190807022509.4214-1-danieltimlee@gmail.com>
        <20190807022509.4214-3-danieltimlee@gmail.com>
        <CAH3MdRW4LgdLoqSpLsWUOwjnNhJA1sodHqSD2Z14JY6aHMaKxg@mail.gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 7 Aug 2019 10:02:04 -0700, Y Song wrote:
> -bash-4.4$ sudo ./bpftool net detach x dev v2
> -bash-4.4$ sudo ./bpftool net
> xdp:
> v1(4) driver id 1172
> 
> tc:
> eth0(2) clsact/ingress fbflow_icmp id 29 act []
> eth0(2) clsact/egress cls_fg_dscp_section id 27 act []
> eth0(2) clsact/egress fbflow_egress id 28
> eth0(2) clsact/egress fbflow_sslwall_egress id 35
> 
> flow_dissector:
> 
> -bash-4.4$
> 
> Basically detaching may fail due to wrong dev name or wrong type, etc.
> But the tool did not return an error. Is this expected?
> This may be related to this funciton "bpf_set_link_xdp_fd()".
> So this patch itself should be okay.

Yup, I'm pretty sure kernel doesn't return errors on unset if there 
is no program on the interface.
