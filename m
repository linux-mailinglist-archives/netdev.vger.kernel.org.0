Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 617EA22807A
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 15:02:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727901AbgGUNBc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 09:01:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726687AbgGUNBb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 09:01:31 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FA03C061794;
        Tue, 21 Jul 2020 06:01:29 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id s26so10696087pfm.4;
        Tue, 21 Jul 2020 06:01:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PVh0UoUWYQd3T8847SakLzIV/J/J6Lx8vEgfKUN35n8=;
        b=nxrIxIJL7rLwgkY3my8Zt5Gh6rDni7leFzWeeRl49CaLT3Q16M1gfCAyFIuvUB5+P6
         CkhIbVIkXULhjDyR0hGf0OMmAPYQkm378GoxFIFgJDQ1G7SBT4buLfGjZKBwcur/s+i4
         qFx3VdWwtOJRO2UyVR7A3nWAbY9NjKMy3KWaBXk/+h+ZqfIXl2uAPv7QbqVRyd7hEMdy
         1bK/5L1jOc3clwuLhMW66CWuwjCdUPXuSz11/F3WTfIx3dSZO2kzBZLVovAFsJOpMk0L
         y5p6ceMbMGCGlUM01uqvsPymyPZ3c2+5QEbflevWos0nHDWw3xXXBi9aYk5qAabvhOD/
         TKUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PVh0UoUWYQd3T8847SakLzIV/J/J6Lx8vEgfKUN35n8=;
        b=cI68IngoKYiIIwn9cu3Wyl74SXnGAH4rpl2UREZMiG91cr0++mLAjQMpz05fB8U9vN
         2ZJdM7zj96+Yq5cGcIhMEAoh3AyoFjPw/quNtJMO65jeL3QJx2vLVtLaffd/NGHkXa/T
         wUD5XDNtpSKNWGaEiGiJ+lQTGO/Xcb2hPS/tD6xcJLtliLT/LUh6etevAm71GnqLM1HR
         /TZOyDKidDoyQyR/5rCOaNHLqvLNcEcLP8ssZ91yUpX0r2xG3qZTR0xZrp+OSDrcBqAW
         6Ofm2rovShdrYdXB4cCpWeUyRaIx1DrSRsLByM1c3tP8dzhxu1qrt3EjT0VQkBm3sEJl
         i4KQ==
X-Gm-Message-State: AOAM5303W0dS/o90Qfl3szaQ6WL9I4HFkCj98uFic5OV6ScvGN40y+jS
        IDwbdNJ169LEcSx1vG+sOnaF1kCC2hVAFg==
X-Google-Smtp-Source: ABdhPJxzhb9UFg9JQyfO5NooNCWTMMytOO3dNVT0hez4mbKmugYBPNC2GIL8p9+BcoskQXbhEmNsJg==
X-Received: by 2002:a63:1a0c:: with SMTP id a12mr22295348pga.24.1595336489026;
        Tue, 21 Jul 2020 06:01:29 -0700 (PDT)
Received: from gmail.com ([103.105.153.67])
        by smtp.gmail.com with ESMTPSA id w29sm20191981pfq.128.2020.07.21.06.01.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2020 06:01:28 -0700 (PDT)
Date:   Tue, 21 Jul 2020 18:30:07 +0530
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Bjorn Helgaas <bjorn@helgaas.com>,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Shuah Khan <skhan@linuxfoundation.org>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH v1] prism54: islpci_hotplug: use generic power management
Message-ID: <20200721130007.GA145812@gmail.com>
References: <20200721125514.145607-1-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200721125514.145607-1-vaibhavgupta40@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This Patch is Compile-tested only.
