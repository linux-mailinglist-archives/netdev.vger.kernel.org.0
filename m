Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 500D7A3E82
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 21:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728178AbfH3ThY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 15:37:24 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:36419 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727888AbfH3ThX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 15:37:23 -0400
Received: by mail-pl1-f194.google.com with SMTP id f19so3807614plr.3
        for <netdev@vger.kernel.org>; Fri, 30 Aug 2019 12:37:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3kZ/NJnyXN0yquM09pSH+z00YFv7ov+AjZa3Udsid30=;
        b=XKAVN/4IVjAB97Ac7Zope7eu3O+qGHxH5q3Cb6OdxMaikpodOqCLdST4a2QVGgXQzv
         6mtabjSRdEG+JN0/+cl+OBYxsrnQwMhA/Nu0rDhUXcorw2fq+hWIUHFpBwqtmxIHkgCF
         Rk6fkUqhmSeCvBmLwuSSSHPaVjdk8CE8G55kQXvFlpn/E/xrQz9Ll2x0bpseuofiOoO2
         5F0BNHn+07IaqyvsqaE9NHCIj0p7FnVaYZvtwDFAncBHjzJFDJJW3ze3O3u2qhni+aMa
         QEr6ug2H0TagdlpBs+qNaFp02VjaRzi8VckN4nRSUEzz3i9TfqPs3zzsxrR0wfHOQm3W
         RSkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3kZ/NJnyXN0yquM09pSH+z00YFv7ov+AjZa3Udsid30=;
        b=Fqk1ZmBhCrlUdf8KrGSwdEExwEfjGs3YqVA1BvraykAQyWiz3ipW+LGxye2oKwO7xM
         U0tRnPu67kOwiWPTvBdCyjdpZwjh+SK2n/IPmpc0oyBLlM2B+bQCxOJAR+b3bw0GAiy1
         JgDtBxx9jxkIgWVY9PoUT6eruUu+XsLctxRbZTzpjIhhU8j8sbFhNLT9iBJbwOEE7OU3
         1FFPz+1pOiurPEBeJMfPWN03Y5cfERynBRwVfOjVsJ4GjkM3KwXaxgunXmUJH7wPem/e
         gtSjCEmZCnkT15rcJISSG3Gu1lQNajOBJXx0XCF3fc5ZCAHxygNpDSLl1HL1tqSVaSim
         DNDw==
X-Gm-Message-State: APjAAAX/0LbtMm4kXbM0yKFvCbW3ZbLFOc3rCuVvfnSs16csvY5S0fle
        WtgSBwT7ZRaioce9QVnT27BlIw==
X-Google-Smtp-Source: APXvYqxbvsl1y67xAv7DbANaWYAdJpu+TDBENsfl1jbfvYqXx+hNsHilibQnUC3wAw7ZTmd/etNbDg==
X-Received: by 2002:a17:902:f64:: with SMTP id 91mr17373110ply.334.1567193842913;
        Fri, 30 Aug 2019 12:37:22 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id v8sm2650838pje.6.2019.08.30.12.37.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Aug 2019 12:37:22 -0700 (PDT)
Date:   Fri, 30 Aug 2019 12:37:20 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     David Dai <zdai@linux.vnet.ibm.com>
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        zdai@us.ibm.com
Subject: Re: [v2] iproute2-next: police: support 64bit rate and peakrate in
 tc utility
Message-ID: <20190830123720.167de780@hermes.lan>
In-Reply-To: <1567192037-11684-1-git-send-email-zdai@linux.vnet.ibm.com>
References: <1567192037-11684-1-git-send-email-zdai@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 30 Aug 2019 14:07:17 -0500
David Dai <zdai@linux.vnet.ibm.com> wrote:

> +			if (rate64) {
>  				fprintf(stderr, "Double \"rate\" spec\n");
>  				return -1;
>  			}

The m_police filter should start using the common functions
for duparg and invarg that are in lib/utils.c
