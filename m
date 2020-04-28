Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BE191BC3DB
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 17:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727884AbgD1Pjb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 11:39:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727856AbgD1Pj2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 11:39:28 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1E20C03C1AB
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 08:39:28 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id hi11so1310414pjb.3
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 08:39:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UxN64oS2GY7axRRJ0GhBywNwYcRe4LJig1nJdUtOFWg=;
        b=M+jyrX/78uGz7bGSvbGvcpQosCFTy8mqzjVBtG1AWhPIBZaR9W1ZBzStudcDvaBNUR
         gfcl7QVRt0o5tx/DnmZIbhc7iDENuM7cnsGhC2z/C1jPbrxGz3JDEH9AhFByKg3YpHqT
         GDNDFO6vb6+gutErZCOcpFWBF4+OIRqMERuJYSFDOzUKYByzx3Xo2z4myLptoMPf5uQt
         lYRYxo8vSWRsYQGPZyzdP3lKU33cM4TPFrSIrIOMWO5g86mzOTY+fWT+veX8uiG5NJUi
         r7h4yaM7O1PztD0y8zWj13TPCco3oujIphdfG9lMLux6C3vnjBDqJz2BRCuaK4hkVgnk
         HgDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UxN64oS2GY7axRRJ0GhBywNwYcRe4LJig1nJdUtOFWg=;
        b=RF+3OxcLOR6N5pb9DfdWLArOWA07VdIIO5BwHd0i2Hx0xgt55JUNTPnqHlg5cBVxyT
         8iJM/bXspoGhpN5DGDCwNbxXwzAM3QQRdbcYn2XS3U3/KQusB/zyBSU1yYJBznv3Y0fh
         Qg8NnIBGexm5SD+njZuUtvevKdB9zzadrBtU4cXV3uMq/3c/xgpa3o1lvRFn+TsrEGvm
         lyvB/z04i1ofp92PHVV9bXdrb6NepjaIdvbIG28t1G1XOnxt0A6Yp7RzrKHL0m8l/Rcs
         Jl+RlN0iRCECvV1ZhGWdLNvfYWCdqn1g2wLF5EQaPonGY9P/n7gMgeunXy5lyUvYxb8r
         K7Wg==
X-Gm-Message-State: AGi0PuaM1wYY8OS8tjd6fU9h81bWAi8AVVaatnxF++d7gapbEeLGaqzc
        baog6Xa61VTpq8/+8EE65EpCMYrSo7k=
X-Google-Smtp-Source: APiQypIAoLXsBIfD+UrwWSk/pIDlr6/pEMlFZElpMTgAEXRovmAxlwjYq5TAnyv9s+ujMlPBFGKV+w==
X-Received: by 2002:a17:90a:ce05:: with SMTP id f5mr19583pju.39.1588088368200;
        Tue, 28 Apr 2020 08:39:28 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id i13sm2548337pja.40.2020.04.28.08.39.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2020 08:39:27 -0700 (PDT)
Date:   Tue, 28 Apr 2020 08:39:19 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     David Ahern <dsahern@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Andrea Claudi <aclaudi@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH iproute2-next] tc: full JSON support for 'bpf' filter
Message-ID: <20200428083919.355609a0@hermes.lan>
In-Reply-To: <57923a5a17573e7939a78a55ba5b6dd28ad1862f.1588064112.git.dcaratti@redhat.com>
References: <57923a5a17573e7939a78a55ba5b6dd28ad1862f.1588064112.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Apr 2020 11:00:07 +0200
Davide Caratti <dcaratti@redhat.com> wrote:

> +		print_hex(PRINT_ANY, "handle", "handle 0x%x ", handle);

Do you want print_0xhex instead?
