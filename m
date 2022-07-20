Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A42357C063
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 01:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbiGTXAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 19:00:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbiGTXAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 19:00:16 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6342919C2E;
        Wed, 20 Jul 2022 16:00:14 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id v21so210861plo.0;
        Wed, 20 Jul 2022 16:00:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=O60CXwG50CMNbFlPYhSbwiVpECXcVQR97MrNWudYYbU=;
        b=GV87zx+h1LsYC4vg5VgjnB9AbrOjX45i+veof+k4QSYkZQ54zna7rGlFeOH4O/Dx5u
         z32IGlZuePn4MH5P8UWLmLjFd1EmmjYN/+DWNoTMO1N3xjx7JwR59cN+qeQRNBnO7LKu
         IYZVMZFPCneCJ5lua2KLUs5BT//OUWtxsAgN51D6jfGjhFyN24iIzFoUUi4zYB7uwE3z
         B9GmsZUveR8gWujcMGePBGnnw4oU/rapQuenZ8yPATDmDwQxRoAnAd7Qc/We7bvqp5HS
         695RMT5n0WYh1A6MVbKKIcrv4wRyKEBDHHZi5y5Tm8rXNUOiPb+zL08D3wU/GXas45Rt
         sBzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=O60CXwG50CMNbFlPYhSbwiVpECXcVQR97MrNWudYYbU=;
        b=NWcuyDTaXFeMC7Igk82MwwqPt8qCdKxJsrmpzQYy6stxPZ4SYARxXmvDDRepk5P5/z
         Y+b9ITC7/vKSJrS4bVasavAYnr2cuu5cIdXlG+eS/tarRPhNKqZd7hXNP8FJI3bbdi/f
         PP4+X5U7nW6PwgP9ts6Jq2X6L4iFy5e9pWspIRNSOD6JehE4vLZiG2XWmtNorLfnbkOa
         j5pYgrv3h/q830eUUCdfVW+ZPvpi9doZXwEgyfE713E+pJn5LPxhtDW/GADrZkMLYqrC
         JYhmZDWeanSJBc9KXmglK0NIwh6xqgp9KxUuNzumCVPUlUb1kiWxPCan45tejS9JmwEP
         QdMQ==
X-Gm-Message-State: AJIora/iYkL04lmZtd49pjnwyJT91IygelgOpIUksjSTQFGCyvt3tJPF
        vlm9oB5BoiE1J00ZJIKgXGw=
X-Google-Smtp-Source: AGRyM1s87lbItSmnHSuhbYCOPsPC7+W+QdNmf7JWp1I8Kuwuy8PBsh19YZaIFJjUB1rZOtW9Pej3cg==
X-Received: by 2002:a17:902:aa0b:b0:16b:c4a6:1dc9 with SMTP id be11-20020a170902aa0b00b0016bc4a61dc9mr41133063plb.83.1658358013694;
        Wed, 20 Jul 2022 16:00:13 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z2-20020aa79f82000000b005252ab25363sm149366pfr.206.2022.07.20.16.00.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 16:00:13 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     bcm-kernel-feedback-list@broadcom.com,
        "Guilherme G. Piccoli" <gpiccoli@igalia.com>,
        akpm@linux-foundation.org, bhe@redhat.com, pmladek@suse.com,
        kexec@lists.infradead.org
Cc:     linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org, x86@kernel.org, kernel-dev@igalia.com,
        kernel@gpiccoli.net, halves@canonical.com, fabiomirmar@gmail.com,
        alejandro.j.jimenez@oracle.com, andriy.shevchenko@linux.intel.com,
        arnd@arndb.de, bp@alien8.de, corbet@lwn.net,
        d.hatayama@jp.fujitsu.com, dave.hansen@linux.intel.com,
        dyoung@redhat.com, feng.tang@intel.com, gregkh@linuxfoundation.org,
        mikelley@microsoft.com, hidehiro.kawai.ez@hitachi.com,
        jgross@suse.com, john.ogness@linutronix.de, keescook@chromium.org,
        luto@kernel.org, mhiramat@kernel.org, mingo@redhat.com,
        paulmck@kernel.org, peterz@infradead.org, rostedt@goodmis.org,
        senozhatsky@chromium.org, stern@rowland.harvard.edu,
        tglx@linutronix.de, vgoyal@redhat.com, vkuznets@redhat.com,
        will@kernel.org, Brian Norris <computersforpeace@gmail.com>,
        Doug Berger <opendmb@gmail.com>,
        Justin Chen <justinpopo6@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Markus Mayer <mmayer@broadcom.com>
Subject: Re: [PATCH v2 04/13] soc: bcm: brcmstb: Document panic notifier action and remove useless header
Date:   Wed, 20 Jul 2022 16:00:09 -0700
Message-Id: <20220720230009.2478166-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220719195325.402745-5-gpiccoli@igalia.com>
References: <20220719195325.402745-1-gpiccoli@igalia.com> <20220719195325.402745-5-gpiccoli@igalia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 Jul 2022 16:53:17 -0300, "Guilherme G. Piccoli" <gpiccoli@igalia.com> wrote:
> The panic notifier of this driver is very simple code-wise, just a
> memory write to a special position with some numeric code. But this
> is not clear from the semantic point-of-view, and there is no public
> documentation about that either.
> 
> After discussing this in the mailing-lists [0] and having Florian
> explained it very well, document that in the code for the future
> generations asking the same questions. Also, while at it, remove
> a useless header.
> 
> [0] https://lore.kernel.org/lkml/781cafb0-8d06-8b56-907a-5175c2da196a@gmail.com
> 
> Cc: Brian Norris <computersforpeace@gmail.com>
> Cc: Doug Berger <opendmb@gmail.com>
> Cc: Justin Chen <justinpopo6@gmail.com>
> Cc: Lee Jones <lee.jones@linaro.org>
> Cc: Markus Mayer <mmayer@broadcom.com>
> Acked-by: Florian Fainelli <f.fainelli@gmail.com>
> Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
> 
> ---

Applied to https://github.com/Broadcom/stblinux/commits/drivers/next, thanks!
--
Florian
