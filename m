Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4EFC114807
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 21:24:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729632AbfLEUYm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 15:24:42 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:37703 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729154AbfLEUYl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Dec 2019 15:24:41 -0500
Received: by mail-pf1-f196.google.com with SMTP id s18so2139886pfm.4
        for <netdev@vger.kernel.org>; Thu, 05 Dec 2019 12:24:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JdRS2TwiEoZAY0ywvlQZY49TkkZY2yHjS45p5y6BmPc=;
        b=Zy3Itpm6GYpgP+S6bJTbwiWQdNlXExjpVTOahmiWjB76lLludwPiNrS+ZzPodlZC7C
         mv6DHpAjxkXB2RcaVujszc6CjBD5r9ClfX7yxdrHB5U0FfpVEioxmZ7Lli2jKyF99/X3
         aflWnKMiKMvmU3nOJoWGEltumM79o1MuyT1SsI130X3NQYlAm7LVpYWTvGiNCAxeFkOb
         G5tH/WYB94cDYBKhEl56teG2U6MascUmEauL330rNSeCpxPlZtVRrRuKlTiu7Pb0vyJI
         dxBridcK2hSHQaOK2zuVDnJi+JJOFkQpm6N5mlGQLqFQnXMvP/csqV6/equIdH2FSBkq
         v5hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JdRS2TwiEoZAY0ywvlQZY49TkkZY2yHjS45p5y6BmPc=;
        b=HQa9LqE+xRPKg/Wo+q82xRCpwxedpcp092864diy/eGiDyLG7l86DXF0rgw09hnWo0
         Y3DuI0y/8jWAVGZiC1M1iyWbdK+T3QDJqPfQzSWHjrC7mJJr5M1DrrXVKHGbz3Q/nPjU
         SDaqz3GXX8unx9FtlcsmlrfX4w5eqcgPE/7vZDcGsZBrpDbjstw282WNjM82+asLM3K4
         ZI7I/1sWL4wpG2Aezd462C7RN1AnKwKBWHbIhsn4wbZAUN+xdIjHZy9n0YQBKE5pedHt
         OCBlOM8bwlFbb0ZCWaUUBLMVnTQfvmxBtL7uX2g/FiGFh37FGPEdSZ1GeSqcRZ4ZtM1q
         0zjQ==
X-Gm-Message-State: APjAAAUhKTKqcb6i2KEVDilcRVsT1dkVL0PxIPFbhzXXpPL9NfLPJGdj
        bDQR8Oaio2bONnrs/RN1tmIduA==
X-Google-Smtp-Source: APXvYqwJ6fmKCyqn4zfIEURtP78yZL7gK6g1PWAKZ78EF9XapZJs8SPEYnFe4xeux1iewvcNz3kQTw==
X-Received: by 2002:aa7:820d:: with SMTP id k13mr11185096pfi.10.1575577481207;
        Thu, 05 Dec 2019 12:24:41 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id q67sm578987pjb.4.2019.12.05.12.24.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Dec 2019 12:24:40 -0800 (PST)
Date:   Thu, 5 Dec 2019 12:24:32 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Brian Vazquez <brianvv@google.com>
Cc:     Brian Vazquez <brianvv.kernel@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Mahesh Bandewar <maheshb@google.com>,
        Maciej Zenczykowski <maze@google.com>, netdev@vger.kernel.org,
        Leslie Monis <lesliemonis@gmail.com>
Subject: Re: [PATCH iproute2 v2] tc: fix warning in tc/q_pie.c
Message-ID: <20191205122432.2bf71a7f@hermes.lan>
In-Reply-To: <20191204213203.163073-1-brianvv@google.com>
References: <20191204213203.163073-1-brianvv@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  4 Dec 2019 13:32:03 -0800
Brian Vazquez <brianvv@google.com> wrote:

> Warning was:
> q_pie.c:202:22: error: implicit conversion from 'unsigned long' to
> 'double'
> 
> Fixes: 492ec9558b30 ("tc: pie: change maximum integer value of tc_pie_xstats->prob")
> Cc: Leslie Monis <lesliemonis@gmail.com>
> Signed-off-by: Brian Vazquez <brianvv@google.com>
> ---

Applied
