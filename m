Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1000A3FD006
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 01:44:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240694AbhHaXpu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 19:45:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231511AbhHaXpt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 19:45:49 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 865C4C061575;
        Tue, 31 Aug 2021 16:44:53 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id z2so1555563iln.0;
        Tue, 31 Aug 2021 16:44:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=75h53hLhcubzYj6N91bfzi0nUQ1W63ubVCr7YWFuBIk=;
        b=FZ5RMfpPSCuR+AEqk+WN+0idRi/rrHc+b4uTH9cDQ2voqWKkc/VQTP98IuEGeYoCrd
         CBT8jAMA0wwN/ZlfACnkMYn1SQ6vaU4KoCG5/KQ1UuAjWMeUPBOktBicTyns5A1xD7ZN
         SrC2UngoEU+YiDohO6iqkbFQ6SyuweQL1FRKhi15TuetZx7Po8eR+xvg8OMg9KffRZP2
         g2VjsHcFtMtRjn4Tq7U3g54WwVP3RDEDt722LwUobhmj/Bh7xmU5XVdmxH7qRguCJjH+
         fv1eiPw8MZE5W0gXk3vpT29dxmzkUhR55eDQt+ouZtAgawqJPo1/1jJr4POxxctC6z4p
         bW6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=75h53hLhcubzYj6N91bfzi0nUQ1W63ubVCr7YWFuBIk=;
        b=oZn9o+Hkcl79UBMDBfXj5p7N7JbKgdmqzWCUqitl0/lHcrzJE9gC/NH/P7NS6Ans+b
         L5zb2FmxQyNkB/RmTDcuHeVR1rcCoPCQzkhtEMEGI8L9KsUXZT9wziNDD719991Ec6Rr
         ETX6OwFetwtpGjdpcEfjkYlSnU+ivnhEaWYnICd9J2ExzLIYeubhY+5K5xccrEmKWbCz
         rOS0E8exvIfhFWC+YPiI1AMnQj9HUA2GKXy2UEU/FtqNCRZaDUAOw1T2KzofvaiM9mSd
         8bQzvrN4Yetk5VGpr71c82EbPPXORTDOtStTdwT4745s88x0OrcwEEUHsvLXpEuwkvUx
         pNxw==
X-Gm-Message-State: AOAM5314suuxfCEyNNOduuepFkLJplDBOrmPtZUefehZb3T7VYzDerMP
        SQRGsVsc1sI3LyT5A/lnHDk=
X-Google-Smtp-Source: ABdhPJzOaEQ3tZcBmYhAqlZrLejH5blXVgyCcnKoCuOMqUKZ1kvNKH4CipCxok05YjFZQCB1ndKtgg==
X-Received: by 2002:a05:6e02:156a:: with SMTP id k10mr19388789ilu.24.1630453493048;
        Tue, 31 Aug 2021 16:44:53 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id b16sm11121430ila.1.2021.08.31.16.44.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Aug 2021 16:44:52 -0700 (PDT)
Date:   Tue, 31 Aug 2021 16:44:46 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Message-ID: <612ebeeef125d_6b872083d@john-XPS-13-9370.notmuch>
In-Reply-To: <8f98ae857b2d84e00dcfe41d02f82e9e7a43f367.1629473233.git.lorenzo@kernel.org>
References: <cover.1629473233.git.lorenzo@kernel.org>
 <8f98ae857b2d84e00dcfe41d02f82e9e7a43f367.1629473233.git.lorenzo@kernel.org>
Subject: RE: [PATCH v12 bpf-next 08/18] net: mvneta: add multi buffer support
 to XDP_TX
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenzo Bianconi wrote:
> Introduce the capability to map non-linear xdp buffer running
> mvneta_xdp_submit_frame() for XDP_TX and XDP_REDIRECT
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

Acked-by: John Fastabend <john.fastabend@gmail.com>
