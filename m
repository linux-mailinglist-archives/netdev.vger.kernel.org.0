Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2A7C3ED070
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 10:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234778AbhHPImN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 04:42:13 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:60730
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234413AbhHPImL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 04:42:11 -0400
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPS id E36083F0A2
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 08:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1629103299;
        bh=+xUEc/qm1PzDJP5u3baZXXtjTc7h8rBhDiakdDHi1yM=;
        h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type;
        b=pnAUd2JV346AM2Zd1HY1VEMopx6ly3bxdpElZxYAgiC4Gt9uopwvgX4M5gguwynQp
         gQGW/RSCAxlpgVN9QhmwnXJqekZLjuXMI0r9aljvrlV2/oZjkK04Bi+O79SM2GX00Z
         h19nzNcvnwm/vFXMLPpwnfK7LDeib5x7FSwoefrnxbDgmxD+wnZzM4zZ9s2bjFktAL
         3i5QEaM1KjWJO8/QEJiTa5nN8NiVUVpHqjO1EONR8PZuUcPzOluoSxOIm+BiuqcnBF
         nWYErUUureMUHX240NlYF5x4uQxE9I+AVA6whd6KC8tQ0PeedXaHuGL6cDHcjZKmUL
         O36vUCVww0OxA==
Received: by mail-ed1-f72.google.com with SMTP id eg56-20020a05640228b8b02903be79801f9aso8430077edb.21
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 01:41:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+xUEc/qm1PzDJP5u3baZXXtjTc7h8rBhDiakdDHi1yM=;
        b=sXoMyMVSacRja1XAOJVviN4ySwqnHwrXwKxM89SQp0KaVO21UPZZz2uwGsjiNyQsKU
         fagDBsI79SZrSXu9gqWb2t9F+6VIrmdD1rUEAj+COe7vAT6abSJZTkThsIbLUe5n/hOX
         znq8gXKtc4W79rw4f/i5hcv/902wtWtcPl2iTu5S/zsHJxF2JD98J/92derx0+IiufjY
         rGt6mDmE3EpWx1yPEJyCsZRmS+LbzdOd/U+K5tEknMczsBUzDkAhFJFiE1O0YEV15ic/
         qB147IvlBCgd59oG8n10SwhXE0H7gcng0EgOiyPkEZhcpgRu5k8FK+1aTKqQOQ3K9vH3
         MqvA==
X-Gm-Message-State: AOAM533S2AzbGalKKjdSf4UaIFiTwMpTGtk7TNu7hFTBYU1giJHPXxZn
        jQ2Va2xFD2YTwdGCSUv6d58EdCOjRPUfmOGtlXx/tM4somT0mDtJ2iTT4obaHu9o3HAbsk+qu7T
        jCWwZV4O49CwINCeD1vEUVK9sxrBbJOFr5w==
X-Received: by 2002:a17:907:b09:: with SMTP id h9mr15069793ejl.278.1629103299686;
        Mon, 16 Aug 2021 01:41:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwh6pMzFSVOs7lSNGbKe0iJwJ55gCTC/3pF7/7l+/UXo12eilgMq1CpfKKWMAKorkvgL73RVA==
X-Received: by 2002:a17:907:b09:: with SMTP id h9mr15069783ejl.278.1629103299522;
        Mon, 16 Aug 2021 01:41:39 -0700 (PDT)
Received: from [192.168.8.102] ([86.32.42.198])
        by smtp.gmail.com with ESMTPSA id h13sm1523571ejq.77.2021.08.16.01.41.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Aug 2021 01:41:38 -0700 (PDT)
Subject: Re: [PATCH net-next 2/3] selftests: Remove the polling code to read a
 NCI frame
To:     bongsu.jeon2@gmail.com, shuah@kernel.org
Cc:     netdev@vger.kernel.org, linux-nfc@lists.01.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Bongsu Jeon <bongsu.jeon@samsung.com>
References: <20210816040600.175813-1-bongsu.jeon2@gmail.com>
 <20210816040600.175813-3-bongsu.jeon2@gmail.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Message-ID: <03cfd784-72ce-9835-a6b4-3af6ed34f092@canonical.com>
Date:   Mon, 16 Aug 2021 10:41:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210816040600.175813-3-bongsu.jeon2@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16/08/2021 06:05, bongsu.jeon2@gmail.com wrote:
> From: Bongsu Jeon <bongsu.jeon@samsung.com>
> 
> Because the virtual NCI device uses Wait Queue, the virtual device
> application doesn't need to poll the NCI frame.
> 
> Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
> ---
>  tools/testing/selftests/nci/nci_dev.c | 33 +++++++++------------------
>  1 file changed, 11 insertions(+), 22 deletions(-)
> 

This depends on the patch 1/3 (the NCI change) so should go via the same
tree probably (or cross tree merge). Looks good to me:


Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>


Best regards,
Krzysztof
