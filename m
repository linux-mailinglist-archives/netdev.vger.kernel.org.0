Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2DCC49B6DD
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 15:51:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1580513AbiAYOuh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 09:50:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352053AbiAYOqq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 09:46:46 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3281C061753
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 06:46:42 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id r7so448823wmq.5
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 06:46:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fireburn-co-uk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jahFylLFQ4FlT07WI99OSrQG5jbtrsRBcgJaIkG4L6A=;
        b=UDcH1PgtLKoIYH3SlII+wx0/4ofsh2TWpwqNN3rDGUJPyk+oh+Ofe+0qIWvuCtbZP9
         Zgu4ogZ/grDV2ZBFLBQEkf3Cdw/+WoY/f+letjDjKKzHbvteFgVvNQOc8azY+NjzTZnq
         q/gZUi14p4GVYPMIcRdT6pOGfuFEnhYuW8zq0Hs2mCQe1rx9o8NHzFlHuYDddGMSLdzY
         SFhTjK+e+qkLJqs6FEWnWK/qjEgmJnbzvPIBRiky67qJ9TOlhcFhe+Bt1DHsNgYvXpuv
         +lzO9TyuPP4zTG1NilhtdAlH5z42n8fN1N8MVQxkH+ImbOhMWk5qgnaAhgTRv5rtAmXD
         fhWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jahFylLFQ4FlT07WI99OSrQG5jbtrsRBcgJaIkG4L6A=;
        b=CyCAyEOLpVuHPxXK2D9mKRu45VQNahF5rNbj9y375bjkRGxmEna7SaoQfC7WjmNNXi
         uE+DI2uQ9g4N6U2NvTQoTZdY2PnoGY5kfW7Eq2rOoNtJnJkl0isED35oISHukxWdGaA8
         GvVxDzbyll7zNa1LqTI5lADSlLsAdmamxR5drUNUCQU2UbdCEsB32N1il3TPMk0WAmNG
         NbCmjN3cacl13PBcjYtclp/3oFJWPsrlF/y0H20JmRRpvib/Fi58QHMfr//LM7r0dQMA
         npx/aP1x+N3jJO9uUSBibit4zydKU6MehIREQl18q7ZyHIfQvZalQDScEqX3H7esVFId
         S0VA==
X-Gm-Message-State: AOAM5315hTBRfaFTCO0myMX4y+K4OmVuEUWgy4Q37jyWN0EAjRDWjSMu
        FLsXTywfB31+6oLSDm7ctM/2tw==
X-Google-Smtp-Source: ABdhPJw4nvjztWbIig7Vl7dTcWWYzXRT6fmIpUqOb838PP6ua48xE1nLJHoHzDqJSYrIG8Pgx+jUOA==
X-Received: by 2002:a7b:c04b:: with SMTP id u11mr3392710wmc.104.1643122001214;
        Tue, 25 Jan 2022 06:46:41 -0800 (PST)
Received: from axion.fireburn.co.uk.lan ([2a01:4b00:f40e:900::64c])
        by smtp.gmail.com with ESMTPSA id w9sm579631wmc.36.2022.01.25.06.46.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 06:46:40 -0800 (PST)
From:   Mike Lothian <mike@fireburn.co.uk>
To:     luiz.dentz@gmail.com
Cc:     dan.carpenter@oracle.com, davem@davemloft.net, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, luiz.von.dentz@intel.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH 12/15] Bluetooth: hci_event: Use of a function table to handle HCI events
Date:   Tue, 25 Jan 2022 14:46:39 +0000
Message-Id: <20220125144639.2226-1-mike@fireburn.co.uk>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20211201000215.1134831-13-luiz.dentz@gmail.com>
References: <20211201000215.1134831-13-luiz.dentz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi

This patch is causing a lot of spam in my dmesg at boot until it seems my wifi connects (or perhaps the bluetooth manager does something)

Bluetooth: hci0: unexpected event 0xff length: 5 > 0

Thanks

Mike
