Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69FF8E0B84
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 20:36:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387913AbfJVSgR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 14:36:17 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:45732 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387791AbfJVSgR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 14:36:17 -0400
Received: by mail-lj1-f193.google.com with SMTP id q64so18261917ljb.12
        for <netdev@vger.kernel.org>; Tue, 22 Oct 2019 11:36:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=qM7e3bKoRmX1ib5TRz4vRhbrFvOqIjMUWoapHUYAKvE=;
        b=En7jdaqINSs/VmNN4Jwkit5LlNrLvQq1xfN+EpjLqr5gSPsonNog5qNzpO8XBzzv14
         qTQbjpSA7GOcsvdAdogBYLS7XukfcA7nKFSUcAlOGsV9TP1sa3tFz5QMd5I/HtO6WDKs
         c0IgMSmOdVOW2+sWuLZDKE6LpAPOvv94GkXxAWgnlK1Y9oKhFdBy9UDX5uktOAquxyK+
         n1IsoXRh00mVfwstqX2OzDOCJ65J0K7nRiEZnnHnMf14PPZERbvNDkhJHj2koX3J9oWJ
         +F47YudXlMtoA93iEJv/ZgxCgTDD0Z/rPYdAXBnTvt/vihS5P05gyx/1bQj1eqcjcCHi
         MzEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=qM7e3bKoRmX1ib5TRz4vRhbrFvOqIjMUWoapHUYAKvE=;
        b=qmfQpRqixVhrsvseRG30vf7xgEfzimvzP09zZPjLOvvzG9ay5DjioxXnTWS6G8B1hL
         Ccl0NYhPezYqNTj+4uokpZG5iyNXxRIwAdHsU5irYNHTWIU03U3jhRDHiQONSCoilThd
         YdqtCUs99JcpU4fe7eXjrNUg4d7OXMTjXWMM2CMZX2v3PqwdAW0YnwrfaMoqVqOTxpIa
         kx431jsbVmRxN6Ba/vbgktyvRCRxsImoTQfbWesXlHUwHh6oZ8tykTIg3B95WcW9C4yx
         xpvZ0DlLex/vc3E0AZMfGEau9eP/i4dEs9GzUflvI2plX6aPiARw/l3QtGTHQh/kGrgV
         8zDA==
X-Gm-Message-State: APjAAAV3YlLgIEXX/U1frBEqyN8yyMX3R28rVVGLAcG0M+p4vPDgKJ3S
        BwrPbns2dT/rhuMJ2tf8FOL8Hw==
X-Google-Smtp-Source: APXvYqwON1rQ2VXxNQcCQEFTjXKLCOhHH9CuvzYX871jtBdlKN0iBoQGyNvokIoV1ZdIdqXrPAX/jQ==
X-Received: by 2002:a2e:700f:: with SMTP id l15mr2555256ljc.69.1571769373858;
        Tue, 22 Oct 2019 11:36:13 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id x3sm7843473ljm.103.2019.10.22.11.36.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2019 11:36:13 -0700 (PDT)
Date:   Tue, 22 Oct 2019 11:36:05 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, gor@linux.ibm.com,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: Re: [PATCH net-next 0/8] net/smc: improve termination handling
 (part 2)
Message-ID: <20191022113605.1a257a96@cakuba.netronome.com>
In-Reply-To: <20191021141315.58969-1-kgraul@linux.ibm.com>
References: <20191021141315.58969-1-kgraul@linux.ibm.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 21 Oct 2019 16:13:07 +0200, Karsten Graul wrote:
> More patches to address abnormal termination processing of
> sockets and link groups.

Applied, thanks!
