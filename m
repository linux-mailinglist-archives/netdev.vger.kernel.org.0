Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94B7683752
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 18:50:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732809AbfHFQue (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 12:50:34 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:34387 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732048AbfHFQue (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 12:50:34 -0400
Received: by mail-pg1-f196.google.com with SMTP id n9so35673245pgc.1
        for <netdev@vger.kernel.org>; Tue, 06 Aug 2019 09:50:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=3saAk1n9laJz01Pbu0zjzMo/vXkhHprB85o1pnIu7wE=;
        b=Glqtu/3Z5xFUa/N0CVLBD44cNYaDwuHHDSqo+COhVpVcuHlN2iKo0hkmFAoV4pgBTY
         HEtxQmS0sfhdmjler+j+l6ph02wbvzzDCLtz9hOluQjHlqvEz2GAh3o1QgGNC2wKn5xm
         iQhYHYjgy7dwpflTkIXzc/4/a4PQJvEG7OkQD1VopxcQmGBCRorgz1jDWVc6kyDVTqHd
         Mlod9N8tWdq9lgeHg6gO7u20S96cWy31IQYtU7j/7FZjsmK/iHsrU1Qp6xjBGJ2pDxLy
         MFgb/8JaNclTNNpIcw78i4AEFjbHYma43yK3kL4HTQvUnIXUUMd8PuJx+v1F9cZuEmhH
         YDgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=3saAk1n9laJz01Pbu0zjzMo/vXkhHprB85o1pnIu7wE=;
        b=tztStnvCcAJzUdmuR91ywfbr/WaTDiBRzM36X/pVI3X9tByfCxA2e9qqPJxj+rAtkj
         gblyPFEBVqtgZnlAuLKTUHW7DGtRf6F8gq743GrXvF9Cm8WtDtEOCYRryBdy2rDeQtXT
         zjCdmKBx/dfM6ZmtOuCNzuIHBSg8FG8Fcut7OdmiHfWK2yk3MyJlaW8446UiRLW1FGf1
         iSRfXFzdmP4hLcW1fqYIZZTYwG5Sfpm+AqCCKU91kysvSGunyP3dNN/r1GxQX+Zl7rO8
         X7XEfcRkM6M1vJfRvDoHhE+PtPagzcVuEf0LBshfO9bdYrlR/Au3gbT6LDO+7X2hA84t
         x1qQ==
X-Gm-Message-State: APjAAAV2pysASw16gCL9BjjocIjZEyh84EM+2ruejv8tklfAdub6rzjW
        SEi54alcgTQG4qjTJaNSozbpQg==
X-Google-Smtp-Source: APXvYqwZiOdub8JgqyF25uVMxja+VZo3ZXTlZMyQwijCT+QMEdcHlcsoXJFJ5ahYuHME4lAJm9iEXg==
X-Received: by 2002:a63:3046:: with SMTP id w67mr3977831pgw.37.1565110233717;
        Tue, 06 Aug 2019 09:50:33 -0700 (PDT)
Received: from cakuba.netronome.com (c-71-204-185-212.hsd1.ca.comcast.net. [71.204.185.212])
        by smtp.gmail.com with ESMTPSA id u16sm24234179pjb.2.2019.08.06.09.50.32
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 06 Aug 2019 09:50:33 -0700 (PDT)
Date:   Tue, 6 Aug 2019 09:50:08 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Edwin Peer <edwin.peer@netronome.com>,
        Yangtao Li <tiny.windzz@gmail.com>,
        Simon Horman <simon.horman@netronome.com>,
        oss-drivers@netronome.com
Subject: Re: [PATCH 08/17] nfp: no need to check return value of
 debugfs_create functions
Message-ID: <20190806095008.57007f2f@cakuba.netronome.com>
In-Reply-To: <20190806161128.31232-9-gregkh@linuxfoundation.org>
References: <20190806161128.31232-1-gregkh@linuxfoundation.org>
        <20190806161128.31232-9-gregkh@linuxfoundation.org>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  6 Aug 2019 18:11:19 +0200, Greg Kroah-Hartman wrote:
> When calling debugfs functions, there is no need to ever check the
> return value.  The function can work or not, but the code logic should
> never do something different based on this.
> 
> Cc: Jakub Kicinski <jakub.kicinski@netronome.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Jesper Dangaard Brouer <hawk@kernel.org>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Edwin Peer <edwin.peer@netronome.com>
> Cc: Yangtao Li <tiny.windzz@gmail.com>
> Cc: Simon Horman <simon.horman@netronome.com>
> Cc: oss-drivers@netronome.com
> Cc: netdev@vger.kernel.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>

I take it this is the case since commit ff9fb72bc077 ("debugfs: return
error values, not NULL")? I.e. v5.0? It'd be useful to know for backport
purposes.
