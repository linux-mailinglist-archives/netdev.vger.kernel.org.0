Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6117AD794F
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 16:59:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733149AbfJOO7D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 10:59:03 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:36636 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726523AbfJOO7D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 10:59:03 -0400
Received: by mail-qk1-f196.google.com with SMTP id y189so19463228qkc.3;
        Tue, 15 Oct 2019 07:59:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=0IKRgzJhEVbgVHJJC0u8XBcMR7mFdoVrs5PHFDROGLU=;
        b=ZCjFd3RFO7SBtJEzInClfrVeO2THKMYaALHFTO7MGgGpbRxzC654FSftUNvOnEIlTL
         QRxTcBkIT0vXQ1ozsibWl000dFh6DyU2z7sKGtg0hFfuLWdhvAxswXsCnukTByAzGXfV
         /5/aGH9757HTW+HeBEY2uOQ4UiL2uB00QTj1EYdgvLq6rHP1Y2juhVkZuf0V4nKPIjcS
         t3R/FK3eBjL0lv+4msEEOi6KklHSje3dkSPEgAXb5PCyma0pOYQpXNu/z36ZZykgztcT
         zl8/gixky6G08BnmZjTnmgPka+y1jjdVl8Y8b0K86CwminiszXeUzMTo9wxXcBHMewbx
         uunQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=0IKRgzJhEVbgVHJJC0u8XBcMR7mFdoVrs5PHFDROGLU=;
        b=Z0patw/eVeao7dzcl/HRIzVJ5dPTgqUQ8DXN7ILH9r5YvrpIcy3UjxuWK17TEqmOtE
         wCbk51sIoeZvyOgn2LaH0LCnGo1AbiRgICjsSpxzC0g275L8ec+4ml1g3hTRajlRLi3t
         7xoMEhKRnED7JXZmK+eGi9HqDwLxVs7y7vGqHLWDt04rdoGgemPbsfFmTSX2fOcVQDwu
         sXnEARt8eNHafvXcXGDRLI6gNM9G+q0EDJJy9NnIARgutYKtTPArqweNZNME/gz9EONG
         VQRRPgbi/Kuw4KCOoYXR6gUm+HXE+MFTFIy51L0Vr9/WiqA7n9/xWowL1q7yLHtSg/f0
         Xp2g==
X-Gm-Message-State: APjAAAWqsa2RLupxNU8RceAOM5CJX0HqMJb/8mfYbAifD06nYQ/P+Ruz
        0donfpL+BtTjdeTC3VSMdi0=
X-Google-Smtp-Source: APXvYqzv49zL8tQ+fv/E/gbnnJhKCx60+jHh7qJg6+s+jeS0X1pfV18QEBKgtEus9YEioLlrpMboNQ==
X-Received: by 2002:ae9:f714:: with SMTP id s20mr34935941qkg.262.1571151542217;
        Tue, 15 Oct 2019 07:59:02 -0700 (PDT)
Received: from quaco.ghostprotocols.net ([179.97.35.50])
        by smtp.gmail.com with ESMTPSA id f27sm9665024qtv.85.2019.10.15.07.59.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Oct 2019 07:59:00 -0700 (PDT)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id C905E4DD66; Tue, 15 Oct 2019 11:58:58 -0300 (-03)
Date:   Tue, 15 Oct 2019 11:58:58 -0300
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Yunfeng Ye <yeyunfeng@huawei.com>, peterz@infradead.org,
        mingo@redhat.com, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, namhyung@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, ilubashe@akamai.com,
        ak@linux.intel.com, kan.liang@linux.intel.com,
        alexey.budankov@linux.intel.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, hushiyuan@huawei.com,
        linfeilong@huawei.com
Subject: Re: [PATCH] perf tools: fix resource leak of closedir() on the error
 paths
Message-ID: <20191015145858.GA24098@kernel.org>
References: <cd5f7cd2-b80d-6add-20a1-32f4f43e0744@huawei.com>
 <20191015084451.GB10951@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191015084451.GB10951@krava>
X-Url:  http://acmel.wordpress.com
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Tue, Oct 15, 2019 at 10:44:51AM +0200, Jiri Olsa escreveu:
> On Tue, Oct 15, 2019 at 04:30:08PM +0800, Yunfeng Ye wrote:
> > Both build_mem_topology() and rm_rf_depth_pat() have resource leak of
> > closedir() on the error paths.
> > 
> > Fix this by calling closedir() before function returns.
> > 
> > Fixes: e2091cedd51b ("perf tools: Add MEM_TOPOLOGY feature to perf data file")
> > Fixes: cdb6b0235f17 ("perf tools: Add pattern name checking to rm_rf")
> 
> guilty as charged ;-)
> 
> Acked-by: Jiri Olsa <jolsa@kernel.org>

Thanks, applied to perf/urgent.

- Arnaldo
