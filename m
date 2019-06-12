Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81B1443118
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 22:48:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389162AbfFLUsL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 16:48:11 -0400
Received: from mail-vs1-f67.google.com ([209.85.217.67]:32852 "EHLO
        mail-vs1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727321AbfFLUsL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 16:48:11 -0400
Received: by mail-vs1-f67.google.com with SMTP id m8so11200916vsj.0
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 13:48:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=vOKkzbcLzHi97/dH8bfA/SdZYEQ33/9qIDYv9ztNAn0=;
        b=PznNAz+wY1K2D383IgZEufITmKhfZUOO3kExbl7yjat5rNOSPpaGwn3vIccQIcb0Cb
         X4c2EoecdXCoZmhN3QFVKiWcOLHRkEMT7hzxp5MEJdhG4IUBCvVf7cLhcHAATiOtJUjV
         H3U+1ozPdzciW6my0r2YArRRGYrc2P0umvqqrvJt6I622kweihk9yuB6So6da6C47a8S
         0DlMWDcA7+5AXlZW83YfSMENUNCczqBzjmXJqske9jOqAaU/Yw2K4+b47hRH5sk56lAw
         TAHkPt2sYMnAb22v9P0OuTSSG7A2nUiUYTkdPhKzacCKrS59feJOzafYDyq0n3FPoJaY
         I1pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=vOKkzbcLzHi97/dH8bfA/SdZYEQ33/9qIDYv9ztNAn0=;
        b=ql/Q3+JXRam1PEbPe44M4I4blXIrmyMMl00KLAZybYo+5eNLTNF7A9ploaIXr6pp57
         ui30xMiv+6JIP8RLICGwN7w3g1jyr6a5xTuSOasxj2/uzd6TDDOZeKaZQYbpRKzMI63Y
         6eAlc/UPw/W/Qzzw7NjA0Iv1ii4OH3IRMfywX5htj5zveZXC2Zp8ZxJZesLwi4mH7VhK
         MVvif7E4VPPloP/95rrvulVRmjH45C1WzIZGO54n+pZFxZrMwDCddhvxN20NMwo6cgOj
         hG0BSoaaXxJhRJnYpH5T69jqoE5aBMcAiUG54Nsc02gvG6zz4knRK9hapiZ8xri1rCtp
         Ha5w==
X-Gm-Message-State: APjAAAVPYfVBrRAd0EOqEZWaw6FN7ODOzYiLKdLeZtz9TbvZ75IqwqnA
        uhu4NMlaS+hbLFsctOGUbMVRGA==
X-Google-Smtp-Source: APXvYqwa38LgRUq0RN+nohRARAcsjMq2Lv8i2gfxz57ShpX6ss4XtL005V/X5vv8Cdy79NCdNaIp+Q==
X-Received: by 2002:a67:e3da:: with SMTP id k26mr5937734vsm.131.1560372490800;
        Wed, 12 Jun 2019 13:48:10 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id l20sm339690vkl.2.2019.06.12.13.48.09
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 12 Jun 2019 13:48:10 -0700 (PDT)
Date:   Wed, 12 Jun 2019 13:48:05 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Maxim Mikityanskiy <maximmi@mellanox.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jonathan Lemon <bsd@fb.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
Subject: Re: [PATCH bpf-next v4 00/17] AF_XDP infrastructure improvements
 and mlx5e support
Message-ID: <20190612134805.3bf4ea25@cakuba.netronome.com>
In-Reply-To: <20190612155605.22450-1-maximmi@mellanox.com>
References: <20190612155605.22450-1-maximmi@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 12 Jun 2019 15:56:33 +0000, Maxim Mikityanskiy wrote:
> UAPI is not changed, XSK RX queues are exposed to the kernel. The lower
> half of the available amount of RX queues are regular queues, and the
> upper half are XSK RX queues. 

If I have 32 queues enabled on the NIC and I install AF_XDP socket on
queue 10, does the NIC now have 64 RQs, but only first 32 are in the
normal RSS map?

> The patch "xsk: Extend channels to support combined XSK/non-XSK
> traffic" was dropped. The final patch was reworked accordingly.

The final patches has 2k LoC, kind of hard to digest.  You can also
post the clean up patches separately, no need for large series here.
