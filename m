Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D5FDA3AFE
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 17:51:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728240AbfH3PvP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 11:51:15 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:32813 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727135AbfH3PvP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 11:51:15 -0400
Received: by mail-pg1-f193.google.com with SMTP id n190so3763691pgn.0;
        Fri, 30 Aug 2019 08:51:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=qh9JMIOA6DKpPhCLXrMjeRQ/Yu9ZjBiM5utlR/Cj6uc=;
        b=qdTI7Rxa8bA7zDyC9FTroHXftoktZ3lJz1pyQDM7p4Rn2bUQFsEwGZJ0rfzzPK0gxJ
         BJWwVx5B6Yl42LJa7WyqX+7ykYYL+MxmE4cUI0DAF0RUleeaiCELdH8SaPnx42bFvqBp
         NTdXhNtJjPH0qRI1bIN1RM/jK88UUp+gfVgLzhCPHDo1hqLxhEJcuD5/myWOSB0bAXPc
         6XnvglnfEntJcP31gi21D21SB5ZnLBnTgsySn1BMnUsarf50G1JSPkT/f4U863IW/MIb
         DTI6FhxcwjgLRw6WOPFEbMwWb1cBCP2l9GUxTc08tZVtV+ZQvNB+agc5gUDiPq4UFygj
         7CMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=qh9JMIOA6DKpPhCLXrMjeRQ/Yu9ZjBiM5utlR/Cj6uc=;
        b=oiVPEhjgLkAVvv8Lrlsbx3f4y3cJMhrwhUWSKaG+VVXS+P8j+xhww44iMFX2LQ94t8
         d/Ua1d289gqTVNixouECZBF6M5oFJ8ijq6eJ+vuY9qIpGZEWEzrY/Aoxb9zS1jcilElZ
         YAC+AYywxiSaPyuth83Mk2hbbRk5fxDFYnbWWapOWtkMTIqIz4Sb4Peq140QOfy7WoBh
         RctjLCevxKOoiKUeA9WHuECd1zfEzKoXMdRipzRNQUvXe+HYAZU4/YKIwIST66j9twai
         2FK+bbEIX8sBDdz0UjPyVYam8o3iHrBf3EaQJ3kwzBZzwAkZQU4aiUAsshLAKJJum1a2
         y96w==
X-Gm-Message-State: APjAAAUYQQ4uMEVcm2KXsWTELJ0/HOOPkfjBTn1lWsK1I8MH4Sub155d
        xqnxhm8bq+CvfrZj1wTijYI=
X-Google-Smtp-Source: APXvYqxIH4BI/e4zt9lk20BW0P9HQaA9UZQnQj8IVrIOLOp/FA92JAuYZYcs56FcEFTv/PE0Gi7TWA==
X-Received: by 2002:aa7:8a83:: with SMTP id a3mr18843130pfc.115.1567180274559;
        Fri, 30 Aug 2019 08:51:14 -0700 (PDT)
Received: from [172.26.108.102] ([2620:10d:c090:180::7594])
        by smtp.gmail.com with ESMTPSA id j1sm6763972pfh.174.2019.08.30.08.51.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 30 Aug 2019 08:51:14 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Kevin Laatz" <kevin.laatz@intel.com>
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        bjorn.topel@intel.com, magnus.karlsson@intel.com,
        jakub.kicinski@netronome.com, saeedm@mellanox.com,
        maximmi@mellanox.com, stephen@networkplumber.org,
        bruce.richardson@intel.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, intel-wired-lan@lists.osuosl.org
Subject: Re: [PATCH bpf-next v6 11/12] samples/bpf: use hugepages in xdpsock
 app
Date:   Fri, 30 Aug 2019 08:51:12 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <359B63E6-49B0-4AA2-96F3-D139AF0AEA33@gmail.com>
In-Reply-To: <20190827022531.15060-12-kevin.laatz@intel.com>
References: <20190822014427.49800-1-kevin.laatz@intel.com>
 <20190827022531.15060-1-kevin.laatz@intel.com>
 <20190827022531.15060-12-kevin.laatz@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 26 Aug 2019, at 19:25, Kevin Laatz wrote:

> This patch modifies xdpsock to use mmap instead of posix_memalign. With
> this change, we can use hugepages when running the application in unaligned
> chunks mode. Using hugepages makes it more likely that we have physically
> contiguous memory, which supports the unaligned chunk mode better.
>
> Signed-off-by: Kevin Laatz <kevin.laatz@intel.com>
Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
