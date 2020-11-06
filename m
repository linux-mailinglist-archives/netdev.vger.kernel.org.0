Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6F492A926C
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 10:24:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726535AbgKFJX6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 04:23:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726320AbgKFJX5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 04:23:57 -0500
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA769C0613CF
        for <netdev@vger.kernel.org>; Fri,  6 Nov 2020 01:23:55 -0800 (PST)
Received: by mail-qt1-x842.google.com with SMTP id p12so314255qtp.7
        for <netdev@vger.kernel.org>; Fri, 06 Nov 2020 01:23:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+3q7G72d6hkNfZWZgOVwUWrrFSaxUirSdqvTyFkk9xE=;
        b=gKbeKVMlS6APZgjiWM9KlL4qrokaKkfZ+8JKfKaeD0oDqKhd9vhRbGW8rDMGgPSa3q
         oXGAGHdAGQkr5xhEX2DYB2yxMF3EwgR/lfOF/+g/tPjVs3W/3V0eq+AbsiwR3byJebD+
         JiHWB0Ufu8VkiwPxkvs+4mkM+u0LiJqUvZ2ZzuZf6Yd0VP5g+FAtriOssU7gEqLJq3dp
         QdgfCDaNTwL/w/Kj48BS3kzmp7Ytv0LkcOViJl8OZ58qqP1lRAkEneVyr0qsxPNyiV47
         Qw7Tr38SXIeMD+rNpr6SbdWpnBgXcoaej5e+td7sPnZzO1jg0iNRsUzm/0vc2P7fOX20
         /izQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+3q7G72d6hkNfZWZgOVwUWrrFSaxUirSdqvTyFkk9xE=;
        b=TyJVu0GvNFYZ8ozhs55w9fv3U0tnF7TS9RPrNreaDfCJZrWupvMCJHuE5SFsmdm6cS
         T4T4rQV/gA6P9rvO/TtzTI/ws0z2dwlEjFxFSKPdyjJfr1/PpR659Uj/NL8fJDxYPHpS
         ASxfmytgL96fDe5FC5SC3UfiVWD3zVSn4KIX7gQEBu+cut8i+hvHsLCZvkSoESHZCfag
         o/BF43fcbIUWaeTbVpprRqqQvai2QEyiS7vclDYR5WIm9NU644jy/aVV9F4KiHugI85X
         3b+CUpybQnU1Pd7CTebaOWUUNkn55p+DhQblMgfLFMbt5xRlG3TxsmhoT5fyOuHQa4yL
         jkjA==
X-Gm-Message-State: AOAM5310KZqUMPV0ueDAOMf2kTLiOgOmm7U8MQAEbM0UcTcVUA56Jq8l
        jN146nJbZB4l7H4sGGTKeFY=
X-Google-Smtp-Source: ABdhPJwxpNxOwmgY3i4sgaLPrbBT4bbe9NHcpWM9vjJ9Xi3dQsoSiSDHLjt4kDAIgR6lfuEyVwNDlw==
X-Received: by 2002:ac8:5a88:: with SMTP id c8mr663605qtc.35.1604654635029;
        Fri, 06 Nov 2020 01:23:55 -0800 (PST)
Received: from localhost.localdomain ([177.220.172.74])
        by smtp.gmail.com with ESMTPSA id u31sm235550qtu.87.2020.11.06.01.23.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2020 01:23:54 -0800 (PST)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id D92CAC1B80; Fri,  6 Nov 2020 06:23:51 -0300 (-03)
Date:   Fri, 6 Nov 2020 06:23:51 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     wenxu@ucloud.cn
Cc:     kuba@kernel.org, dcaratti@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH v4 net-next 1/2] net/sched: act_mirred: refactor the
 handle of xmit
Message-ID: <20201106092351.GA3555@localhost.localdomain>
References: <1604654056-24654-1-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1604654056-24654-1-git-send-email-wenxu@ucloud.cn>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 06, 2020 at 05:14:15PM +0800, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> This one is prepare for the next patch.
> 
> Signed-off-by: wenxu <wenxu@ucloud.cn>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
