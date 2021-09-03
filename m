Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A841A400466
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 19:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350354AbhICR5m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 13:57:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350345AbhICR5l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 13:57:41 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77A01C061575;
        Fri,  3 Sep 2021 10:56:41 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id b4so5994099ilr.11;
        Fri, 03 Sep 2021 10:56:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=3CAEodC9kA1VCSt6bFv/04im0VK37uKbIMa/MU/IaFw=;
        b=Nzb/fhd4qa4Oaj3cg5DKQVSnLP2Sx7h04rJmn8gbmhIUULH+OTJ0erWi2X5vVMHkSd
         4k8TOYtfabskJfTv5FFcXgzQDKqabknfNuVq5ZRt1qw4miH1n4vkrz1EgoD7CuI0UC24
         hCJC9UIuTvkomGgmb0oIMdLM0mFtxDRJjV/FRZ8uDKwPX1KXR4ax9x/G28/Z1T8fyh7a
         WBgacO2KG2SwbFraS9breOjTDyKxs8o7o/CeyBvaLxPCjvUzy8thIH1dzZOsTs7C2gP3
         zAq1wiB0pmVZl6jYFdbE0llD9PAkj4684FpEBZ+WpevipxW6v22OUcT1hRD5SR7GpNFH
         7CYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=3CAEodC9kA1VCSt6bFv/04im0VK37uKbIMa/MU/IaFw=;
        b=e614Pezceh4BsRN3pZZCa38Deh3GuXJ6oTo140T2+fzF5Ob4zfkBZa85zpitHtBhY9
         tbb286548FiWVeB5iKwBR+LESV1YlLoA37ch3/Klyhq5ArMqc3F3Glzy7/hMBPw1Zmgb
         7FpjF9aVx1ZIKlNgb2/rDbz0962Fv9DMzc/KDDLJwkLD64Q8FV+GqaZphxtqHsEBkfaE
         n01eRurhXXqpTbIol0irvQWi0af5EL1v/9PPxh5CEIlqfnBfYXb2ydxYcTNjyHmsNXtZ
         woeXY+HoFm98UZHV8StVZsrtPk6KNe6bLDZ9LStjRCEYc+mz7RaVLyj+gMyd9QgGbsQ1
         eVAw==
X-Gm-Message-State: AOAM5320T3tEwpbHzzWLpx0ejZk2QpLh3TL8eX2DMsYpEPJ1qIK/cDNn
        XNzAKqJ354Dec8O4PGL8MGg=
X-Google-Smtp-Source: ABdhPJyc48aCROC87j9dmJeJ+9z0snWajvoScc5wDdUuhRs/cNK6JxzdviUuXIDXhnZzxoQRbJpA0Q==
X-Received: by 2002:a05:6e02:154a:: with SMTP id j10mr116437ilu.79.1630691800938;
        Fri, 03 Sep 2021 10:56:40 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id q15sm77491ilm.60.2021.09.03.10.56.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Sep 2021 10:56:40 -0700 (PDT)
Date:   Fri, 03 Sep 2021 10:56:34 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     jonathan.lemon@gmail.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, yhs@fb.com, andrii@kernel.org
Message-ID: <613261d221e71_1c22620888@john-XPS-13-9370.notmuch>
In-Reply-To: <20210901104732.10956-3-magnus.karlsson@gmail.com>
References: <20210901104732.10956-1-magnus.karlsson@gmail.com>
 <20210901104732.10956-3-magnus.karlsson@gmail.com>
Subject: RE: [PATCH bpf-next 02/20] selftests: xsk: introduce type for thread
 function
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
> Introduce a typedef of the thread function so this can be passed to
> init_iface() in order to simplify that function.
> 
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> ---

Acked-by: John Fastabend <john.fastabend@gmail.com>
