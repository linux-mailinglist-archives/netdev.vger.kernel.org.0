Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35CDA2B809
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 17:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726956AbfE0O77 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 10:59:59 -0400
Received: from mail-pl1-f169.google.com ([209.85.214.169]:38771 "EHLO
        mail-pl1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726452AbfE0O77 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 May 2019 10:59:59 -0400
Received: by mail-pl1-f169.google.com with SMTP id f97so7154942plb.5
        for <netdev@vger.kernel.org>; Mon, 27 May 2019 07:59:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cZFkhKMJq+ogRbWzDGzZ+lku5otmTGW7Q1H4giS/V+Y=;
        b=nXdPsc8tEEUAfxO3iU0c1zuqadN+GgfTvTTpWyChol5enZBUJ+jFHHSGv15qPaO4/u
         MTp7+ThokofmDQdIr16pBMsHhPUh+1j6K6JstrwFvXLGm6ZsttORDpFCE7p7iloWnXPc
         Ru/fBJUcQPQabxVaHeg7CKUSeHRcWq5Nbro9UCeaJ3DQVwTtvW1L4L1brEPw3NgknnXq
         9/rIJakmQkFXA/7DlOBr0sHXZLSC0j9oInMDJthjBXaenVI2GteBLSsRZY1b2L96NbMO
         ofB5zK89a9wMfk66xChXDzF//YRdN89Wdirui2EdNL2UzAKgcXfCBhkMEqUrHBUI8NHg
         fYTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cZFkhKMJq+ogRbWzDGzZ+lku5otmTGW7Q1H4giS/V+Y=;
        b=cV7YmnwvK20zfnjKLXjs49yl26FcK1n/FoshpKdo0L5clDsdU0JdGcRVs1WJIiAN7x
         sYBeLB1zOMqL9rORhGlERSKpd6IWwmin7ayZEH8VarOQrHY7b7KGBzFwX1NhBOkhz7mF
         8161nPVttb2PiWUs+ZsLujEDID/qP0ho2XWktAHdtG5WQmx+OplHZCr7WiLyYVO5NQyy
         4igTh6cipCCXgfNEPjmyJKv5VOtwdPeVx7ylmwsyRdhkPQTjOByIe2OLIMo4CCbom+BI
         LkHNUJiTx1ep0HBbjFp+1AjqHMj3zUvN+vfBWqM86KsvloQy9E+UGFrf7hcIKiamu4pJ
         +JJg==
X-Gm-Message-State: APjAAAUJqmSOFcq40kfLTaMjbvfMmXpdIbAimmBsO7xmTiwU2BKBcBwp
        d/gOHPOd7MBDKkxOmUv88vZGGEDpaz0=
X-Google-Smtp-Source: APXvYqxlOQ6/ugXNnTxElDQSZlgr2WYT+yHNzNH84HQuBolmiDTk+1+xystaauiQnCdVQbLPLzY6TQ==
X-Received: by 2002:a17:902:e108:: with SMTP id cc8mr119115455plb.145.1558969198300;
        Mon, 27 May 2019 07:59:58 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id f28sm13904148pfk.104.2019.05.27.07.59.58
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 27 May 2019 07:59:58 -0700 (PDT)
Date:   Mon, 27 May 2019 07:59:56 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Arun Kumar Neelakantam <aneela@codeaurora.org>
Cc:     netdev@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Chris Lew <clew@codeaurora.org>
Subject: Re: netdev_alloc_skb is failing for 16k length
Message-ID: <20190527075956.26f869ec@hermes.lan>
In-Reply-To: <6891cd8b-a3be-91f5-39c4-7a7e7d498921@codeaurora.org>
References: <6891cd8b-a3be-91f5-39c4-7a7e7d498921@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 27 May 2019 12:21:51 +0530
Arun Kumar Neelakantam <aneela@codeaurora.org> wrote:

> Hi team,
> 
> we are using "skb = netdev_alloc_skb(NULL, len);" which is getting 
> failed sometimes for len = 16k.
> 
> I suspect mostly system memory got fragmented and hence atomic memory 
> allocation for 16k is failing, can you please suggest best way to handle 
> this failure case.
> 
> Thanks
> 
> Arun N
> 

If you are handling big frames, then put the data in page size chunks
and use build_skb.
