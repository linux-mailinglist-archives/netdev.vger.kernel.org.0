Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D06338EED
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 17:25:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729797AbfFGPZU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 11:25:20 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:35034 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729462AbfFGPZU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 11:25:20 -0400
Received: by mail-pg1-f194.google.com with SMTP id s27so1354258pgl.2
        for <netdev@vger.kernel.org>; Fri, 07 Jun 2019 08:25:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RZIWsH1vQpTzB3IU3FO1sTAx7tWoYTdgLnv8UhQDvPU=;
        b=U/Hc5csuKYPY2iWaOY4QqXqpMMfiFle5I/lz9qdESGagN66tgWqq3bmIDkEqUikcsY
         wDFvNQ1SyiAx+y4UWa6dV4U6x2WZr1OO0k5y91WBK+J96HS+HQv/pZEEvKujS7VJ0Tkf
         zu+OiK06yaH9wqmuF80MSHCwSh5nyCiHxTEmdooJ4aHmS/Puu6/q9ma7HOCNQ44L5vh4
         B2wWYtVGusTcZ3A2zFBVohISuAxllMpq4f3vFpAj7y32o1x+bf4Mknb3PXJA0oZ/SBJ5
         5Uzh+KUD/mtm/U1eoZuXBMRNNIbqYiBapfdaAFkSkYCWwgRAONCByZbLf8P9AYRUgcgQ
         LUwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RZIWsH1vQpTzB3IU3FO1sTAx7tWoYTdgLnv8UhQDvPU=;
        b=HXVtupJ6WS3QkAAe2z3HYfcwtrEelfxIwukEYjLyGQnmuyRpkoGzZn1tBV8Cxm1j5l
         vcwyS9z2zw9Srk1+o3QIzWgJc+gz119JI7UAN+SnMegmZpcsgYA3K5eVW6TEPrnNftB4
         OFPt7UEfBL7z6dRdhEQTEv3yRzFakbqGGTFuhMSx0/ZeaXjRReAt5muVNXh57gdq1NIn
         pIkjF1+JE/pPfsEZgqUKr/1IOpMDsfyT6zemjmX7agnW8zuflV/6c4KpUJhU5JITwSHY
         U3WuvRm2e+Ze46KSWiXMNWcHljepbEqLP3QWUQgvsATLG4WzC/Ym81g6XZfte2GaV8kI
         Pu8A==
X-Gm-Message-State: APjAAAUziXPMWtfohglClB4HzEMxu3/TAcym6oFkpjINRZAOX3WRhJYR
        o/xka8m03Kpj8ylSB1Ck3I0Sfw==
X-Google-Smtp-Source: APXvYqyjpJPltzN9LMkePUbBwfQAXK7xhmmHrC1mPwEx59lkCHORUak1f5y7Nv785hWRAG6pcXb7+w==
X-Received: by 2002:a17:90a:2e87:: with SMTP id r7mr6027787pjd.121.1559921119665;
        Fri, 07 Jun 2019 08:25:19 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id h19sm2872004pfn.79.2019.06.07.08.25.19
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 07 Jun 2019 08:25:19 -0700 (PDT)
Date:   Fri, 7 Jun 2019 08:25:17 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Matteo Croce <mcroce@redhat.com>
Cc:     netdev@vger.kernel.org, Andrea Claudi <aclaudi@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        "Eric W . Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH iproute2] ip: reset netns after each command in batch
 mode
Message-ID: <20190607082517.5ebcceca@hermes.lan>
In-Reply-To: <20190607101313.8561-1-mcroce@redhat.com>
References: <20190607101313.8561-1-mcroce@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  7 Jun 2019 12:13:13 +0200
Matteo Croce <mcroce@redhat.com> wrote:

> +void netns_restore(void)
> +{
> +	if (saved_netns != -1) {

If saved_netns is -1 then it is a program bug becase
no save was done? then do something?


> +		if (!setns(saved_netns, CLONE_NEWNET)) {
> +			close(saved_netns);
> +			saved_netns = -1;
> +		} else {
> +			perror("setns");

If you are going to look for errors. then you need to either
return the error or cause the program to exit.
You don't want later commands in the batch to be applied
to wrong namespace.
