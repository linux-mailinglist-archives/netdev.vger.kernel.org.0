Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B44C112FF5
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 16:18:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728112AbfECOSM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 10:18:12 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:40594 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728099AbfECOSM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 10:18:12 -0400
Received: by mail-qt1-f195.google.com with SMTP id k24so3054643qtq.7
        for <netdev@vger.kernel.org>; Fri, 03 May 2019 07:18:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=NzCSKre21JPtX58veFIQQmZcmfBsSiJd/ZyJsjnrdPE=;
        b=AKUUJ+KuztothryZybRdFHtD9D8Vug/6Gx/B5QbBCxcgy7vpyC/UtAs31J7prxbcG7
         lPPctW4NHByMq3fJrjwK0d9STmkcAYuA6v0x1EOvfod5vuZ85R/lWeko423uXlG7FSDe
         /clS1QwYFTm8eMmiKxtb/yDn+MRqAjQ4MPinGDVExY01xFP8P4lShYygujkNaIuqhNxY
         sbiJwXfQup2qxENU4LACq+mQUHfa8eE7IAC7UMo1Iv4jxe7u3HfI/JVmGD9ORBZotKdm
         i5umainWALvmTlr/qnZM4afIR4GAEHMgEGcW6x9lv0XRQ7NKm9RhuQLdpJqnZlHwBfpr
         UVSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=NzCSKre21JPtX58veFIQQmZcmfBsSiJd/ZyJsjnrdPE=;
        b=qi+AEiiAQic6E5P85asQsn8VwsabQ61a/MeNC27HBjd4m8ygJJfY6cV7wzJicwArE+
         MYSV3wFeDF0RAK5WK8/G/pbONqpEgTXTKQhRjz+sm7O5xpIZKCwvA4urXtvcgj8P12hL
         n5SpTxtRjJ6J1a85SWLbG3JhVvstdR98eIDRuvLKSEXQS38cEcf64WNy75phEf8ZARNt
         LixiFFbeq0TVjsDjvoftVFuHJWDywEWLPCV/BllqHRvyIWO6jEc0f46XLhlwRg/vonQl
         e0wkf3H4OyQmxRo4Nc/s2Yf5hHWYwchmAFyl8Pl4TFEu0olvtSg3qG7vm1miZIQTDz5e
         qF1A==
X-Gm-Message-State: APjAAAWsyaYnpR6yilfSBo2NU8vCsLcyxaQ9ikT1PtPdEtweLiJljCEW
        NNH62Ie0BSg1KdkkwPYbcN4=
X-Google-Smtp-Source: APXvYqwlVjeknbdB5i4Z3vg1QX067t8Gb+xQlwRAVDJEm9QLm2QpdYQomhvYziZWIyBpNjKhfJvYvA==
X-Received: by 2002:ac8:88f:: with SMTP id v15mr8900978qth.382.1556893091650;
        Fri, 03 May 2019 07:18:11 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id b187sm1408032qkd.73.2019.05.03.07.18.09
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 03 May 2019 07:18:10 -0700 (PDT)
Date:   Fri, 3 May 2019 10:18:09 -0400
Message-ID: <20190503101809.GB25090@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net-next 1/2] net: dsa: mv88e6xxx: Set STP disable state
 in port_disable
In-Reply-To: <20190430220831.19505-2-andrew@lunn.ch>
References: <20190430220831.19505-1-andrew@lunn.ch>
 <20190430220831.19505-2-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  1 May 2019 00:08:30 +0200, Andrew Lunn <andrew@lunn.ch> wrote:
> When requested to disable a port, set the port STP state to disabled.
> This fully disables the port and should save some power.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Vivien Didelot <vivien.didelot@gmail.com>
