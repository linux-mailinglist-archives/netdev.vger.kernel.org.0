Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2E592AEC26
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 09:40:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726037AbgKKIkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 03:40:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725929AbgKKIkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 03:40:16 -0500
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D830EC0613D1;
        Wed, 11 Nov 2020 00:40:14 -0800 (PST)
Received: by mail-oi1-x242.google.com with SMTP id q206so1307546oif.13;
        Wed, 11 Nov 2020 00:40:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=44+l5aH+9tVUZ2uSZHD5ETua+qWC6tG/was2zpKBcAY=;
        b=CZlYOvDwdBXLugtOnEGkc0r2Mw2vFrAkImfrL4Ftc+F1q83YQTUDMH+hIPrdRP7CUX
         ozpwUxv9zojM3yIfQBN15Uc0nK6cvkOu8Alb5uzDlIsexTtzyra3OqPOsGZvPuLzP3E/
         ix7AmpctBTQ74/YPCzoqaeN28JRYcdpqHhUGtSXaH+puCBvSAJAr+GowyThQWrgfWUc1
         7ovr1CyEvFGyHKs+zFwkriR8bGIStvkg1oREyrEcE6QIA5+JWmtK2oD4noA2xEqKovtL
         d56QDA/3XMxVHtyR7Slx0+/rUwz9B8oYD1LhFgWQ/G1U2AN40s2hr9tjP0l6s7WetSwx
         w1SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=44+l5aH+9tVUZ2uSZHD5ETua+qWC6tG/was2zpKBcAY=;
        b=ONt9RAuJ7n8e3gv1y49y2752HjfKPd5x5bHuCqOd1RmsVxIdmXkUAtM+zwOyM9QmHG
         TDaFMH3adLeRdtKxnWqiR/GptNfmeCn8CuCiyv3UW0B2XGGD7qh0zNLHFJmVAW6nPP4U
         +82QRpT6imknrxt8SbPMneU1A+nEto7I9RH5Iv+L3sOWIqYyOAfHAxmnYrsOf0PMTER2
         85D6MSQeEO0RqJkMwaoAuoQ72Z6D4wz9CpJV3c8D2xuj7SgM5Zeq4PQ552Fyq54oSaz8
         cNSDfSH2/ComKnkrY5QdoQwqNiI8yfOpFcHlu28Ioz67Elv2TM6/pWyFrAQ4o3NtESlA
         gbdA==
X-Gm-Message-State: AOAM5320oC0/FJ361wX7IjvK+eVIUnfaAoDcqTfR/WG1ldepqLRceMjf
        G540PGs8KPGDnad5Qp5Uwns=
X-Google-Smtp-Source: ABdhPJxQmRJobqIm7fJPGQtqA72GX/qgCiD0urPbX7FCQozly0HJeS+eH9G0IclPEqi49ZJfzKZPaQ==
X-Received: by 2002:aca:eb06:: with SMTP id j6mr1417623oih.144.1605084014346;
        Wed, 11 Nov 2020 00:40:14 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id h8sm380926otm.72.2020.11.11.00.40.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2020 00:40:13 -0800 (PST)
Date:   Wed, 11 Nov 2020 00:40:06 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, kuba@kernel.org, john.fastabend@gmail.com
Cc:     bpf@vger.kernel.org, jeffrey.t.kirsher@intel.com,
        anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com,
        maciejromanfijalkowski@gmail.com, intel-wired-lan@lists.osuosl.org
Message-ID: <5faba36671508_bb26020850@john-XPS-13-9370.notmuch>
In-Reply-To: <1605006094-31097-5-git-send-email-magnus.karlsson@gmail.com>
References: <1605006094-31097-1-git-send-email-magnus.karlsson@gmail.com>
 <1605006094-31097-5-git-send-email-magnus.karlsson@gmail.com>
Subject: RE: [PATCH bpf-next v2 4/5] xsk: introduce batched Tx descriptor
 interfaces
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
> Introduce batched descriptor interfaces in the xsk core code for the
> Tx path to be used in the driver to write a code path with higher
> performance. This interface will be used by the i40e driver in the
> next patch. Though other drivers would likely benefit from this new
> interface too.
> 
> Note that batching is only implemented for the common case when
> there is only one socket bound to the same device and queue id. When
> this is not the case, we fall back to the old non-batched version of
> the function.
> 
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> ---

Acked-by: John Fastabend <john.fastabend@gmail.com>
