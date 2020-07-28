Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E222230A5C
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 14:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729755AbgG1Mif (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 08:38:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728751AbgG1Mif (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 08:38:35 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 036B3C061794;
        Tue, 28 Jul 2020 05:38:35 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id i92so2969272pje.0;
        Tue, 28 Jul 2020 05:38:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Fie8IAXWZ8a1f4IBdyXwUsTRAo2+ebUYgUxfo3SFpeA=;
        b=SK9b2UYTW6naBrk+5Nf+HITJ8jpZ5nTD3wTAGxb37B+Ugb0+FU9daPv5RE6+KoAdKb
         A52m+AH2ReoUyWjImEbPFcuuY2un3gyDWbhZU3Z5HR0JGsEiqA1T1CGa3DXHpqaIo+m5
         Yp/IiDKSzac3d2CIz1SHRkAOmLKJrf3CMXujw+d8OHQk39gqh5ocYCpYCuQkSEEneHAm
         ziS1+TJqLiFpxeDVfdOszutkDUaX3v79cXpqfpA0wIdmevzMmXOzLcHJUYj7r6EU+272
         JN0pGtGHdHUj2KWf+0LVVONbMmeHkrR8KXJzTrvsOILhKNNvPF/rp9yAIBgwpsLanTAP
         6ywQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Fie8IAXWZ8a1f4IBdyXwUsTRAo2+ebUYgUxfo3SFpeA=;
        b=PpRE7Qh/MGStL/wzh9eW9GRvp03r61bxU/vqgNIoaFgS0L8OmGZvHDI6ZquoWy3yP2
         W8bABLImOFGPPP493mBxtaDfhA/DKkROyRL+1g22tujAl3J1bZaA/R3M1uEinw0TXHEg
         EumFdq0x5L8Y8LaEv59ZBk77T+i5WJl9FhYye7aRe12wUCfDZTgQ1IuQ5RxWrwNq1xaX
         qYqSKSeewlpbnC7rshoVeN90+MUkiGnS0+3Zl1VgwvgpD/x2vRpuMQFL8q76ZIucB0Hl
         8VuUAO3yuJ7Ux9t3AkqgVumHWQ18wPraNG3yASDRR8sYZRB6YgsXuLuZo0CHhUlkJ9g6
         puGg==
X-Gm-Message-State: AOAM533mF+K82X6IOGhR+Z4Pv+TYImhSry56YCLVBPrwtzUzHcrztY0i
        chp4MlHQ6BuFuPkCRvP3fQMw5kNIoBjg2g==
X-Google-Smtp-Source: ABdhPJwekYhSoj1idJB4yjdyuS66TSlXyc2WtTJj9+6S091YCsU5daM2krAGtIehCsmH7jRufibfUw==
X-Received: by 2002:a17:90b:30d0:: with SMTP id hi16mr4452970pjb.65.1595939914561;
        Tue, 28 Jul 2020 05:38:34 -0700 (PDT)
Received: from gmail.com ([2401:4900:2eef:ca92:3545:4a68:f406:d612])
        by smtp.gmail.com with ESMTPSA id t17sm1684380pgu.30.2020.07.28.05.38.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2020 05:38:33 -0700 (PDT)
Date:   Tue, 28 Jul 2020 18:07:03 +0530
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Bjorn Helgaas <bjorn@helgaas.com>,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [PATCH v1] pch_can: use generic power management
Message-ID: <20200728123703.GB1331847@gmail.com>
References: <20200728085757.888620-1-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200728085757.888620-1-vaibhavgupta40@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is compile-tested only.

Thanks
Vaibhav Gupta
