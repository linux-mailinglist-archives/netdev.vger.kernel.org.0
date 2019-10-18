Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A00CEDD50F
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 00:48:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728910AbfJRWsx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 18:48:53 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:40571 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728267AbfJRWsw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 18:48:52 -0400
Received: by mail-lf1-f65.google.com with SMTP id f23so5838648lfk.7
        for <netdev@vger.kernel.org>; Fri, 18 Oct 2019 15:48:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=AtsybqDOWp2GnV+uGSoCuiaQAQmM7oEncDjuATiiBtI=;
        b=zWCrcAIf9x84ADk8f62f3Sf7HjjLZWQCBQld03fu/txXTZevHjEvVeDjMTlsw3ah9y
         jnBjMdhXp7DaWZQZoaX3jzK35QjsIssKlvInGypW6+DlO+Mx6q8XBuKWbNED/wh/LDPe
         W4FpsDZMGVIqnnylqu1muk6OcJdGX+gofQr4rVoOZ3lojcaInu6R086/jGei7B3t5u1t
         oE3yW62zKaz6EI7SLvlxkPFfi4OshhbmaROabYROv9TCnUuYNr2I3tiiux7LDAO5MYep
         CFp76fPK9JQVXqaD5DMjzyzyj+QsYnh3Wwe3TFpfUWbxZD5kVA45yE3XKcv+821zqLcw
         sOoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=AtsybqDOWp2GnV+uGSoCuiaQAQmM7oEncDjuATiiBtI=;
        b=sUWnTytlTP3ceb+pVllyIZnTs3A6gqmH1h/LLLyewriGcJR247YToYm2uGFQSC7chh
         v4ppA7PiV4u/c0VMAsbbrQq9/J/A8Zpz0KgtpKAo0Yr4nfQG6HA8MUEwPvE1rjhixL3V
         U1uLa5hKRk9ez6HRKi2iIy975bjhIdDMEd6R5xuU20nYn2XpHcq8l0DNY8Y/x8wLCteq
         QIR4p2dWBBN4B6ceF2FtNuzgPuYQvUkqieuXj7bwxvSo+UktKdQzfjGuBX1w7e/Ecmin
         32nxHly5M4fB3HqfD2z8SHBnuywMRZxpxESx7nLEGfY3A8qts2khgBoDK4MIb4ZD8YW9
         k44A==
X-Gm-Message-State: APjAAAUZ5fQb8hMD236zEu9O7Szk5lpZVkk5cLyosw/+N9Lu3Jhjv4UZ
        LDQdC+X8H5MJNGzDcTXu4pM3ng==
X-Google-Smtp-Source: APXvYqzKZwbqoFo5Nz9E39Yz91nh575O+k7qYjGuFO5yallh7x1FuiBZro2vXNuqLrEYGHMlR2cVjw==
X-Received: by 2002:ac2:4142:: with SMTP id c2mr7477062lfi.47.1571438930778;
        Fri, 18 Oct 2019 15:48:50 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id n3sm2975718lfl.62.2019.10.18.15.48.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Oct 2019 15:48:50 -0700 (PDT)
Date:   Fri, 18 Oct 2019 15:48:44 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Zhu Yanjun <yanjun.zhu@oracle.com>
Cc:     rain.1986.08.12@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: forcedeth: add xmit_more support
Message-ID: <20191018154844.34a27c64@cakuba.netronome.com>
In-Reply-To: <1571392885-32706-1-git-send-email-yanjun.zhu@oracle.com>
References: <1571392885-32706-1-git-send-email-yanjun.zhu@oracle.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 18 Oct 2019 06:01:25 -0400, Zhu Yanjun wrote:
> This change adds support for xmit_more based on the igb commit 6f19e12f6230
> ("igb: flush when in xmit_more mode and under descriptor pressure") and
> commit 6b16f9ee89b8 ("net: move skb->xmit_more hint to softnet data") that
> were made to igb to support this feature. The function netif_xmit_stopped
> is called to check if transmit queue on device is currently unable to send
> to determine if we must write the tail because we can add no further
> buffers.
> When normal packets and/or xmit_more packets fill up tx_desc, it is
> necessary to trigger NIC tx reg.

Looks broken. You gotta make sure you check the kick on _every_ return
path. There are 4 return statements in each function, you only touched
2.

Also the labels should be lower case.
