Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6077E53B5
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 20:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388557AbfJYSSv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 14:18:51 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:33562 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388483AbfJYSSm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 14:18:42 -0400
Received: by mail-pf1-f195.google.com with SMTP id c184so2127252pfb.0;
        Fri, 25 Oct 2019 11:18:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lN55QHjqoYpt4NOraTywNTHCly3yYbf+A9v1xX8umRo=;
        b=e1UeZJJ1SAVvAvOeFZCVhhebJpFenW2+buXOmHvP6L2CNSUrqHAglt9ui0CrjMtBki
         c8YR3MVhn1hFKv+Zm18rTx32YJnd9hzECITfvh+Fe1+id9eG9lNfJMYBzeSS+Kl66mm5
         9zLXPMfPn/aoMmQ4bBuMrNfolDh5FA/3h92IUa7bMQXACKsFTXH3ivYQnUrVTHIpeszh
         cDlyA1QuZ2lHqyONg0H1ISaNBF02IvgmpdfGNFyFDq+8bOZZRo7paetT1wcCp6cmSDo9
         4s+aaaOzfAnI1onGMEC1qx1CHPZXdg0VQl9yPacFIwABGAZ2XpA6mL+qxQRHrPzcllfX
         jtbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lN55QHjqoYpt4NOraTywNTHCly3yYbf+A9v1xX8umRo=;
        b=cHQ6u3Ca3igqrW08Z7XRNkBDTzfCuGzm7RYb4ToePdfw1ZDJuCkYlpevQCuP5Q1iZh
         35qQni7SoHLtXIrQ2ZCsQ9VvpM0vOfgUa30iEDF8/E8se4v/ywfCHzBLpeY1ji6KQmJ3
         md9o5bJnRpjecT6cWO57IsL9c4Dzfph/ueHsNtowvp6o8ymfc1QaW2wAE2DltLB8RBRi
         J30f2Ib4MTc0MBLspgXNrt2ImyPUgWnCTbo5DblwOCJ/oXWLN3X2RhvC2MBaPlwGoeEQ
         IzbjM8E8WBQSHZ+ntqAIbDnmTDMbBSVdLPple+tewFq9ujyfhc0EfKMeRq+C6LTZ17OP
         556w==
X-Gm-Message-State: APjAAAVlXhYy122IF3jZc0y11EYDsVwhGYdb+wZG3CoG0tZceBiF0QMs
        FLysckY3oD9G8NveoI79QR8=
X-Google-Smtp-Source: APXvYqxzxBCadfN19+P8iYtHS2ATiKMVpxYB7hP//0VjBEaCVYnU6ZErCyfuuzm/Jekbt5Wz7f4FqA==
X-Received: by 2002:a17:90a:aa97:: with SMTP id l23mr5844943pjq.7.1572027521353;
        Fri, 25 Oct 2019 11:18:41 -0700 (PDT)
Received: from [172.20.54.239] ([2620:10d:c090:200::1:4b93])
        by smtp.gmail.com with ESMTPSA id y10sm3098910pfe.148.2019.10.25.11.18.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 25 Oct 2019 11:18:40 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "=?utf-8?b?QmrDtnJuIFTDtnBlbA==?=" <bjorn.topel@gmail.com>
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        jakub.kicinski@netronome.com,
        "=?utf-8?b?QmrDtnJuIFTDtnBlbA==?=" <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, magnus.karlsson@gmail.com,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        toke@redhat.com
Subject: Re: [PATCH bpf-next v3 1/2] xsk: store struct xdp_sock as a flexible
 array member of the XSKMAP
Date:   Fri, 25 Oct 2019 11:18:39 -0700
X-Mailer: MailMate (1.13r5655)
Message-ID: <BE3EE2D6-2BAC-4540-94EE-1EC5928777E6@gmail.com>
In-Reply-To: <20191025093219.10290-2-bjorn.topel@gmail.com>
References: <20191025093219.10290-1-bjorn.topel@gmail.com>
 <20191025093219.10290-2-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 25 Oct 2019, at 2:32, Björn Töpel wrote:

> From: Björn Töpel <bjorn.topel@intel.com>
>
> Prior this commit, the array storing XDP socket instances were stored
> in a separate allocated array of the XSKMAP. Now, we store the sockets
> as a flexible array member in a similar fashion as the arraymap. Doing
> so, we do less pointer chasing in the lookup.
>
> Signed-off-by: Björn Töpel <bjorn.topel@intel.com>

Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
