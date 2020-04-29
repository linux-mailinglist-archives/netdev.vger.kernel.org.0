Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A7491BE768
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 21:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbgD2TaN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 15:30:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726481AbgD2TaN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 15:30:13 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E869C03C1AE;
        Wed, 29 Apr 2020 12:30:13 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id c2so3530587iow.7;
        Wed, 29 Apr 2020 12:30:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=Q4YCfHgQGAI/IyA88ZdbL6f/Trkpcsmu5JXOJXT4xoM=;
        b=tZ4hSNBWzW0AulTPVBXQNQPTpxjLCo3IBwKL3dQHGu1HSrDYA1aFKDxl5Hk2KNsutF
         +gq/tN90W1rdpc37E9ANSwKeIJpqF3b83PB/p7MH6IpfZRF9m1sp/yZIdqRXYx9H5mZj
         fT0n8IHTCU0FwwA0cha/l8svNToJ5yHB4p2DLwQN8TT44wCo+wXt7N+SE3tJW8nkBmiX
         msAi33tlCgRLBhxt0qQqnpKwtgYhzIltearExgLkLMgnlgS9SdGdR86K8SFhxyOwT09Q
         4eVMIZrAYQBI4gqyr3SFI+S6qcegMg0ErqUwTiLJsitbkjM483l2MpC+EZWI1YW8ikK3
         QgpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=Q4YCfHgQGAI/IyA88ZdbL6f/Trkpcsmu5JXOJXT4xoM=;
        b=LJAt63g/JLenMHxIWcZIFC10HLzKvm3rQdehMt0t3/OnhjsR7STGC7z0PvGOtDGD2n
         GX5tekmHsPDADdCx1A7UJbWBJtcRwWll0I6aRJ1qDk1+Sd5g3u0e+IeyCWwXZ4m9SMFu
         W4U/Et4F4fc4nxG6LTRJew6HlgIxnfV6ZRiDUouN+ioPYs1AWDKCTaZxKlXGlUdl+wI3
         kkS6rgHXzCrZAAaNQWWVKnaa3VernxKZ94BD8goge43XGhGj6BQGQoCaN27G7qVTvir5
         jXuhzmNeClQPR4WQyNOV/KpGGOHC4MG58+jsIpW/ZdtnTxe+7/8Nool6EcJ19hqwrxxb
         vgBw==
X-Gm-Message-State: AGi0PuZZYIzA/AHyzrqvpposgvG4HWc8L4o/CNH713IKXqvOk/IoqKFD
        BjAS5ErQr43fVBJDWUeNI+Y=
X-Google-Smtp-Source: APiQypJQMkB2zok6NWTvPVBfZ/GYaFkAUifMKg4ACEVAB77cIPwXnF9YgHd4oqoHfZAtkVDhtg5sYA==
X-Received: by 2002:a5d:8c89:: with SMTP id g9mr16775921ion.1.1588188612889;
        Wed, 29 Apr 2020 12:30:12 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id u16sm1344650ilg.55.2020.04.29.12.30.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2020 12:30:11 -0700 (PDT)
Date:   Wed, 29 Apr 2020 12:30:04 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Joe Stringer <joe@wand.net.nz>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Martin KaFai Lau <kafai@fb.com>
Message-ID: <5ea9d5bc5ab8d_4d8d2ae8075c45bc18@john-XPS-13-9370.notmuch>
In-Reply-To: <20200429181154.479310-4-jakub@cloudflare.com>
References: <20200429181154.479310-1-jakub@cloudflare.com>
 <20200429181154.479310-4-jakub@cloudflare.com>
Subject: RE: [PATCH bpf-next 3/3] selftests/bpf: Use SOCKMAP for server
 sockets in bpf_sk_assign test
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki wrote:
> Update bpf_sk_assign test to fetch the server socket from SOCKMAP, now that
> map lookup from BPF in SOCKMAP is enabled. This way the test TC BPF program
> doesn't need to know what address server socket is bound to.
> 
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---

Acked-by: John Fastabend <john.fastabend@gmail.com>
