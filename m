Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BAB92AC649
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 21:49:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731351AbgKIUsa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 15:48:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729996AbgKIUs2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 15:48:28 -0500
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3D49C0613CF;
        Mon,  9 Nov 2020 12:48:27 -0800 (PST)
Received: by mail-ot1-x343.google.com with SMTP id l36so10341856ota.4;
        Mon, 09 Nov 2020 12:48:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=J669Eof3CEJD8PSQp6rHHKzPIgW64KnkQofFLzioASo=;
        b=G4/5zN6LEiieOdnp0FVzEq0jjCC3Bt6nRxeEu912FIZuGEK0Awj3Egi3xKEPEnd7WU
         f/i78jXk6QS+KBwDE1Cs74Mv6EOzQSOqb7VS3PyokbP4iYt05Ujj0XL85+ykO7nMWtO/
         8zWIzdXpp5gArk5uBbrSl2iyIEVVqpym/itcrkhMWSTHcqnYVKZ1NT/Xo9SNOp6DvxA7
         r2KiZqtCtUKokHQ8ymV/geJPebQvIPVFEiy2jeQiT9FDuQHUiKosGmqlH6bX4EkHKVO5
         IxFo3S6I2AP0xuvTPC02/AptGSaurYFiFS5TYug0QLOGjfvXip+SP17UXPRjcV/kYBcl
         /PTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=J669Eof3CEJD8PSQp6rHHKzPIgW64KnkQofFLzioASo=;
        b=lg6sphOD2hPVSL8XNielLMPMdRc2RW+idRdx5zoLa+CDQHHhch+/bkXORBKn+oHrOh
         FskoavRh6BzZobpNwNcww19PL4tKFQDE3FszTjEqP8s1CU20ZLcyvmuQ5Jaf1igFpG5i
         9FhplrO4eLBAVwYlEO08i6s6BJe+rNt4TwIlliaPoElggyMkVHcgcrFJNSjJbUSgMfHb
         W0pFpY6ogD3BhGQs3anOANVPbnuKHqBtHhLBdl7FbsYLfDi6GRq63QoGkkP3avji12fK
         ucSWkgfaEMz37F2MQbDx2qpPWKbZAKOx0x/mP2NmIZo6WqdaB6g/yhrul8z3UNsKYOlF
         ZWIg==
X-Gm-Message-State: AOAM532rgxjgdERqq6+2zwXJYlVF3bJ65wfIqnRGqhFyBe2cbDdbiPl+
        pwgttumlLHmpkX3jxjn/PYo=
X-Google-Smtp-Source: ABdhPJxz2Zu5RJ+3AlrUBvVxulSDjiP0gbPD3Btzbr1XnO6hbyOOQcdxTwOS9yEq0Ha4Kw9LBcdXBA==
X-Received: by 2002:a9d:7505:: with SMTP id r5mr11254812otk.64.1604954907193;
        Mon, 09 Nov 2020 12:48:27 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id 61sm2862941otc.9.2020.11.09.12.48.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 12:48:26 -0800 (PST)
Date:   Mon, 09 Nov 2020 12:48:19 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com
Cc:     maciejromanfijalkowski@gmail.com, intel-wired-lan@lists.osuosl.org,
        bpf@vger.kernel.org
Message-ID: <5fa9ab136176d_8c0e208cd@john-XPS-13-9370.notmuch>
In-Reply-To: <1604498942-24274-4-git-send-email-magnus.karlsson@gmail.com>
References: <1604498942-24274-1-git-send-email-magnus.karlsson@gmail.com>
 <1604498942-24274-4-git-send-email-magnus.karlsson@gmail.com>
Subject: RE: [Intel-wired-lan] [PATCH bpf-next 3/6] i40e: remove unnecessary
 sw_ring access from xsk Tx
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Magnus Karlsson wrote:
> From: Magnus Karlsson <magnus.karlsson@intel.com>
> 
> Remove the unnecessary access to the software ring for the AF_XDP
> zero-copy driver. This was used to record the length of the packet so
> that the driver Tx completion code could sum this up to produce the
> total bytes sent. This is now performed during the transmission of the
> packet, so no need to record this in the software ring.
> 
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> ---

Acked-by: John Fastabend <john.fastabend@gmail.com
