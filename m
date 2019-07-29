Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88B4A79B0B
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 23:26:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729982AbfG2V0K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 17:26:10 -0400
Received: from mail-ua1-f68.google.com ([209.85.222.68]:36767 "EHLO
        mail-ua1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725945AbfG2V0J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 17:26:09 -0400
Received: by mail-ua1-f68.google.com with SMTP id v20so24649583uao.3
        for <netdev@vger.kernel.org>; Mon, 29 Jul 2019 14:26:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=9NhMXsTVHrIoWbio+tVv8QBQTMlnLV9gcLFn/UcDBHA=;
        b=Dvoyt/NZec2lOCngx1fFfj7O4sOPLB4F93El9XumNVROucevnTF/oIsBjjvmjqm09k
         JgCoQAMKvKEF8/n6vQITCvOjiCRHlnDxXAzjQUPFKbp3Pxjan7mvscTCDwYF/tMH9jnD
         1tjZpjSxzLL28qH4XcPyBgqrqazM1oKh7ElB4i3U8Y61tXSBCRakxg/w75/hV1XcrzDr
         dVgPC2qmNgGQ9VdSM+lYzaqCWVMQKiAOZM08Z8HxqZ8T0o8zih++8HELqooze0ubqBTb
         2Nb37Jwl9u0VpBTuABM9VpBcxCg2RMvah6dt8qscfRwy/lNEpmWsszfACMkJlKu6UX7W
         iVsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=9NhMXsTVHrIoWbio+tVv8QBQTMlnLV9gcLFn/UcDBHA=;
        b=tur7Kcb5RxicU6fmr6LNzR+1v8pdlZkPDXuOX2b5Rmm2z0ybF1nj37ReQNCjdScCxn
         TddV+iGgGhMXnwx/HO1mJlPd5XqLYyyeTpxIa0YUrjKMbkp1IR+3pHF8E47Q4NAEfyOV
         9kVcALIrYWwUugspdVm6vHDh0h9tvziFfAIC2r5dziAPVVpNQ6ROOFMNa5orGme1K8sP
         L8ULkgnaE6/IlsqbAZYIrFg/OGrIbP6q4iDR33anOLDMjGzb7yG/26dFTLi+KakbZVig
         w5M5X8dWhj4YdNqGube43kNULltCCCDwGkx5kyNNgVR09QsEp4y8DcF4rY2dOajOUjii
         dWdQ==
X-Gm-Message-State: APjAAAWKZbBYhoOHuQetSiQHKOQWt7CGTTEAdAuWwQYjBRicNIAaKGyT
        5vfJ2MFaWRY3h80oSKpEMmjFxQ==
X-Google-Smtp-Source: APXvYqxTRg/ADk+0jHkoTijWibNbURTANj+Css0iwgp13Syc721U8GskIgKvHLZmPgN6PV9sBVfKPQ==
X-Received: by 2002:ab0:70c8:: with SMTP id r8mr40206416ual.89.1564435569002;
        Mon, 29 Jul 2019 14:26:09 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id w12sm28124316vso.32.2019.07.29.14.26.08
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 29 Jul 2019 14:26:08 -0700 (PDT)
Date:   Mon, 29 Jul 2019 14:25:58 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     "Jonathan Lemon" <jonathan.lemon@gmail.com>
Cc:     davem@davemloft.net, kernel-team@fb.com, netdev@vger.kernel.org,
        "Matthew Wilcox" <willy@infradead.org>
Subject: Re: [PATCH 1/3 net-next] linux: Add skb_frag_t page_offset
 accessors
Message-ID: <20190729142548.028d5a2b@cakuba.netronome.com>
In-Reply-To: <20190729142211.43b5ccd8@cakuba.netronome.com>
References: <20190729171941.250569-1-jonathan.lemon@gmail.com>
        <20190729171941.250569-2-jonathan.lemon@gmail.com>
        <20190729135043.0d9a9dcb@cakuba.netronome.com>
        <932D725D-62F1-47D6-807A-45F81E66B1C6@gmail.com>
        <20190729142211.43b5ccd8@cakuba.netronome.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 29 Jul 2019 14:22:11 -0700, Jakub Kicinski wrote:
> > > I realize you're following the existing code, but should we perhaps 
> > > use
> > > the latest kdoc syntax? '()' after function name, and args should have
> > > '@' prefix, '%' would be for constants.    
> > 
> > That would be a task for a different cleanup.  Not that I disagree with 
> > you, but there's also nothing worse than mixing styles in the same file.  
> 
> Funny you should say that given that (a) I'm commenting on the new code
> you're adding, and (b) you did do an unrelated spelling fix above ;)

Ah, sorry I misread your comment there.

Some code already uses '()' in this file, as for the '%' skb_frag_
functions are the only one which have this mistake, the rest of kdoc 
is correct.
