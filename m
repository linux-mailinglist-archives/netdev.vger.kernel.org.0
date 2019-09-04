Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8A81A9226
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387952AbfIDTD1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 15:03:27 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:44790 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387898AbfIDTD1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 15:03:27 -0400
Received: by mail-pg1-f196.google.com with SMTP id i18so11724872pgl.11
        for <netdev@vger.kernel.org>; Wed, 04 Sep 2019 12:03:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4hQeSYHxRcBUqRe3dUafKj5IhYx8NapUYvzb8MyMT+w=;
        b=hMSHr1GJPnOGpljf7DETByqIy/VxuQWaxvEEzBOerOM9HkASRTXQdOhSmZteyQWnKc
         ZyVFTYkyJH2e2/JQvlv5Yexl4sDM1gyU6g3KSTt3wfO46rAM46aTJ1qf4nNXNKo9bLoc
         mUlsc0x02I+9IeIJmHTVBHVa+7yoCI3Q4LTmb7RPROjiWAkuGWG/TQDgkp2sW5m+5pVp
         fJ76ZcbIld2mBemFPU6qIEyYf3WxvX9pB78R7nczIWBUHTWvQqQAgubPiNelYEdiMOzp
         /nlvh3quk405ONp3XNTU9GBdNoqTOlFl7tvcmwHiJxZ47APKa4U9CjDB5et5/5Rv+e7u
         XbIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4hQeSYHxRcBUqRe3dUafKj5IhYx8NapUYvzb8MyMT+w=;
        b=pzNtKPz1zwOqEUAkwMcDamTkMM44ZDqBEJmVwM6Vgan9Ytispdk8OwF/MLPvJ+uAx4
         9w3qldVkJwh+gpVPE0UUZVdDIMOywoLG+h+R8J3yui363lg9BEStCMs1rOEW01LpqwT4
         wED2Pt/M5fzIT3EmBZpfHqiTNockW/uIp9F04K6lGObFmrKzWVlq2blHWupZyzhLs+ni
         rYXv2AnvRDm57lVFxPtr50hvlZ0C8wwHKGNd8OQZJ8fWTOJ11LicpmCraK/Ufw81/AHH
         UQfcQXqJC6brrXn8gh7M1bcf4FzGfA4OoHqdkpH4GszM9pIgp596KY0V9hG6y8n44jgu
         /zOQ==
X-Gm-Message-State: APjAAAUpuVPgIZ6fHjpqxG9JZP47TdokWj9aNqcQUsoG0ZJclgaiD/0a
        jcwHfN8mlDn9rZDMnKJOSVFf4g==
X-Google-Smtp-Source: APXvYqypd0jQsgRr3t02WpFrFm8xDpaUE/5+Yima4nzusDwq5T+brXGoNaWnNP6Yk304tWl/Xpl7GQ==
X-Received: by 2002:a62:f80a:: with SMTP id d10mr9470404pfh.98.1567623806406;
        Wed, 04 Sep 2019 12:03:26 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id s5sm23368607pfm.97.2019.09.04.12.03.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2019 12:03:26 -0700 (PDT)
Date:   Wed, 4 Sep 2019 12:03:24 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Andrea Claudi <aclaudi@redhat.com>
Cc:     netdev@vger.kernel.org, dsahern@kernel.org
Subject: Re: [PATCH iproute2] devlink: fix segfault on health command
Message-ID: <20190904120324.72ed8e70@hermes.lan>
In-Reply-To: <1b981424e70678675af12bc391fbff02625640b8.1567617745.git.aclaudi@redhat.com>
References: <1b981424e70678675af12bc391fbff02625640b8.1567617745.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  4 Sep 2019 19:26:14 +0200
Andrea Claudi <aclaudi@redhat.com> wrote:

> devlink segfaults when using grace_period without reporter
> 
> $ devlink health set pci/0000:00:09.0 grace_period 3500
> Segmentation fault
> 
> devlink is instead supposed to gracefully fail printing a warning
> message
> 
> $ devlink health set pci/0000:00:09.0 grace_period 3500
> Reporter's name is expected.
> 
> This happens because DL_OPT_HEALTH_REPORTER_NAME and
> DL_OPT_HEALTH_REPORTER_GRACEFUL_PERIOD are both defined as BIT(27).
> When dl_opts_put() parse options and grace_period is set, it erroneously
> tries to set reporter name to null.
> 
> This is fixed simply shifting by 1 bit enumeration starting with
> DL_OPT_HEALTH_REPORTER_GRACEFUL_PERIOD.
> 
> Fixes: b18d89195b16 ("devlink: Add devlink health set command")
> Signed-off-by: Andrea Claudi <aclaudi@redhat.com>

Thanks, applied
