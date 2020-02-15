Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DEAC15FB6A
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 01:21:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727572AbgBOAVO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 19:21:14 -0500
Received: from mail-pf1-f180.google.com ([209.85.210.180]:40050 "EHLO
        mail-pf1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727455AbgBOAVN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 19:21:13 -0500
Received: by mail-pf1-f180.google.com with SMTP id q8so5642902pfh.7
        for <netdev@vger.kernel.org>; Fri, 14 Feb 2020 16:21:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ozKrbV9YfTz6vucGT9VrMxTC/eyWscPQQFZszlSTXLs=;
        b=ZOFKQTFdGmFsdKQdBeIk3dfWkY7p633D3i2kz0IPg+3kUZGrAsB910VlR2yo1IKexF
         fQAKLwAENffwa8EpL4wF9qP1n8YDD3k2Tur8JDBxF/al64R7qDdIEKtnHqJGNE7eMDkn
         9YDwkRHjGor91Fr/5APDv6BCVlDu+NGnM2xbwTwoZ6qjV0uiogCo466T9ovcrbmcPuS+
         /1aQePqSPJZYas9KUf/WZKpWppXq63wK4WviiwoZbPgo6UskJFYiDkhtdeIkP/Okq9DG
         E6lE6Egz/3dydTFPlrCF76o+Xo2RnSRYHkXepeZSgCGoZ8p6RsMfLjayvFtwJCYsH82g
         /pzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ozKrbV9YfTz6vucGT9VrMxTC/eyWscPQQFZszlSTXLs=;
        b=BrXV5Rg4ZJcWUgxoKCLlsh0K4akm/Ocjf1MmAXOOAXZf/hIBOTvIxFQXS4N2s5MYXt
         /EecM1Tuh5jcEHYb3wCuaM4ybh+2GpsnRpbwZh6RDu41bCCRixQcjdIU7EWFYbspVElb
         4sDGwzW3+NzUiKbDooj8PzkJhGSNYRfeMKhqqsbMhN7vFu0G8X+Gqm4qLhEdzy7ZNAAx
         wyKmJjKoGlecED+bgXj3TSghXeAgWrCJs14TLs0CW1tYZlZTNM0OyEoqHELRlSdPeaJ0
         1dsZ6n4WjKXCb+Q/iAkQ3yoZ/vitO14liaMMLpMOOBEiTipBlPx9DqjUG7x8a4Arp0/T
         aR5A==
X-Gm-Message-State: APjAAAVbMQaJJ6WWppKjCU8fb0YVwErKjV9ktYOBn0mjL3EmI8BVW0JI
        +F72TlnN4USGIhuMIU+greNCIA==
X-Google-Smtp-Source: APXvYqy8DTuEFHGlRtGaV0cPmjZ/m3mjtVfHuIC1GmvBhZ1emVAHuETtIJ350OSAClGfviVU3O6USQ==
X-Received: by 2002:aa7:8ec1:: with SMTP id b1mr5918175pfr.95.1581726072996;
        Fri, 14 Feb 2020 16:21:12 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id v8sm7970637pff.151.2020.02.14.16.21.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Feb 2020 16:21:12 -0800 (PST)
Date:   Fri, 14 Feb 2020 16:21:04 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        Simon Horman <simon.horman@netronome.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCHv3 iproute2-next 3/7] iproute_lwtunnel: add options
 support for erspan metadata
Message-ID: <20200214162104.04e0bb71@hermes.lan>
In-Reply-To: <CADvbK_dYwQ6LTuNPfGjdZPkFbrV2_vrX7OL7q3oR9830Mb8NcQ@mail.gmail.com>
References: <cover.1581676056.git.lucien.xin@gmail.com>
        <44db73e423003e95740f831e1d16a4043bb75034.1581676056.git.lucien.xin@gmail.com>
        <77f68795aeb3faeaf76078be9311fded7f716ea5.1581676056.git.lucien.xin@gmail.com>
        <290ab5d2dc06b183159d293ab216962a3cc0df6d.1581676056.git.lucien.xin@gmail.com>
        <20200214081324.48dc2090@hermes.lan>
        <CADvbK_dYwQ6LTuNPfGjdZPkFbrV2_vrX7OL7q3oR9830Mb8NcQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 15 Feb 2020 01:40:27 +0800
Xin Long <lucien.xin@gmail.com> wrote:

> This's not gonna work. as the output will be:
> {"ver":"0x2","idx":"0","dir":"0x1","hwid":"0x2"}  (string)
> instead of
> {"ver":2,"index":0,"dir":1,"hwid":2} (number)

JSON is typeless. Lots of values are already printed in hex
