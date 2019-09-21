Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF763B9BC9
	for <lists+netdev@lfdr.de>; Sat, 21 Sep 2019 03:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727187AbfIUBKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 21:10:05 -0400
Received: from mail-qk1-f171.google.com ([209.85.222.171]:42619 "EHLO
        mail-qk1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726295AbfIUBKE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Sep 2019 21:10:04 -0400
Received: by mail-qk1-f171.google.com with SMTP id f16so9180171qkl.9
        for <netdev@vger.kernel.org>; Fri, 20 Sep 2019 18:10:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=Hyy07HG+pGcEjLNmzKph46y8wb/CPIyVRfwqgNnQpGg=;
        b=e4FHBAL3zmpUh3RI/y1g4oxiZiidX4HPAgeBmcUIywfF2Rgl/6ZtSyPnpYjF+6S/Ml
         Hsf7bL9id+1T6BZSo0RwiDUOllrVcAeituJSc2XA1ebbhUkcYjeHlX+1wN3E7sJ4aIRh
         QLEZPpe+PnIiYpKBjL13zpLGTv36gDYggvyk7JRO8S0hgo/Mue0gAZch9CYkA+9hQGY1
         98pK/T/pGXL5HVdCw/EpoSl41Qpyi4cfJgwcifH//0wwAZ/QTdN3Dgo0hOdwXu6vR0o/
         jOmpAHynV+hKN5yVvvNw90D6KQMJBvkXeg7skucNm9lq9FKOj3jgueDpdRuLmnkaHz7p
         qVcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=Hyy07HG+pGcEjLNmzKph46y8wb/CPIyVRfwqgNnQpGg=;
        b=fdAbBcHlzygz4c350pOFh4SULvfPnpRNGH2tZZKnWaJ7mxwuoejjMEPFt7/edKWa3v
         grKUxuqJRvGjNtT9UztArrAUXvk2vrudnSjHGaoTgwAXUSyfjSUcuT6/SdS8Kf8VE/Sm
         taC8RqMIHGzsq0DFW6SNdaj1EqVFnl5KaWPAVMQOFz66bKLllK7PM9gPfoC/3Rr7bWgA
         Xj5a6cTdYOpxdEO15W96i+2UGp7DhaQRU1sGRMmLwm7LXdyp5S3IIwAjvwRHFq5TjV1o
         +CXOIIcDI36JGdet6vdWbwyCJeC1Zv2f1/TRjBtPXr2UzdzzaOrkRgpANSA/Zo+OsIFh
         x7IA==
X-Gm-Message-State: APjAAAUUMMB7oldkTZXLpXCsdxM7lzRfn3GisaWwi1B4EMOuPxGsjt+F
        zrKc2YksbK76zedQ9uq5aNpFqQ==
X-Google-Smtp-Source: APXvYqxsnWu93WvVjpz47680Vag9kL8CcxpwMMUp4ykwxRsBp8NamBMhPEL/ryRWNMi50QRqP7Zx5g==
X-Received: by 2002:a05:620a:247:: with SMTP id q7mr6765554qkn.267.1569028203860;
        Fri, 20 Sep 2019 18:10:03 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id j2sm1558262qth.37.2019.09.20.18.10.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Sep 2019 18:10:03 -0700 (PDT)
Date:   Fri, 20 Sep 2019 18:09:59 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Ka-Cheong Poon <ka-cheong.poon@oracle.com>
Cc:     netdev@vger.kernel.org, santosh.shilimkar@oracle.com,
        davem@davemloft.net, rds-devel@oss.oracle.com
Subject: Re: [PATCH net] net/rds: Check laddr_check before calling it
Message-ID: <20190920180959.7920f2c3@cakuba.netronome.com>
In-Reply-To: <1568734158-18021-1-git-send-email-ka-cheong.poon@oracle.com>
References: <1568734158-18021-1-git-send-email-ka-cheong.poon@oracle.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Sep 2019 08:29:18 -0700, Ka-Cheong Poon wrote:
> In rds_bind(), laddr_check is called without checking if it is NULL or
> not.  And rs_transport should be reset if rds_add_bound() fails.
> 
> Reported-by: syzbot+fae39afd2101a17ec624@syzkaller.appspotmail.com
> Signed-off-by: Ka-Cheong Poon <ka-cheong.poon@oracle.com>

Looks good, but could you please provide a fixes tag? 
