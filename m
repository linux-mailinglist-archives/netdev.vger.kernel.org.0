Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2CFFAD340
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 08:52:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730980AbfIIGwE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 02:52:04 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:40928 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730933AbfIIGwE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Sep 2019 02:52:04 -0400
Received: by mail-pg1-f194.google.com with SMTP id w10so7249466pgj.7
        for <netdev@vger.kernel.org>; Sun, 08 Sep 2019 23:52:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=4932TPqb56xvHvx3wdmeG0rNLBTovKGsoRs6eOsI0lI=;
        b=mAURJPO4CD0B+fccO3Z8FNcjjHywbAJo642PBx+Gf0UycsoSyl3EDfH/sWW+5iZB4C
         pZFO3PWNRRAWQlsZnytLn5mfNcgsbEUhBi10cDaVvHzHGS/1k/Oqt++hhDINnCdRBwXB
         i5O46BejhiNw/L2nCZaMFdP9xwO8BTK7nk/zbP9fRWVC9K9uTSYZskHUiT0CDVkDzYGi
         uN8yO0Jylg4AF6+gL43nUqX3pg6+s180RxoDOYUxbCN24Z8+w38v7I865Z5P6Avvowxy
         Y2BCcOpMyAgPz4n7R0jWU6uMQpjWhq0/YOTksz+1cIDCXZbOEjbNfUb/coqLDj1CoUsC
         6bsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=4932TPqb56xvHvx3wdmeG0rNLBTovKGsoRs6eOsI0lI=;
        b=Xmsn9SoFfkGdfgiahTUIrBSLF+Mdb0nGR90t16HZd6kQYaC5UxpQoVNHVJ9n0gtr9s
         Kx9Kwyf/S0Q73pR7i7N1T2bQhjLu5MTtYhdJlMx9Fg2iWN7BqazhLyqBgj4SZeQjDVEl
         SlFUBevwtBh+7L738Cq7XDySvm3sWWxiFJXxhdhZxd+2s89T0RaG8HB6adHB7+HAcMej
         mHUyJ7/8eGuXJSWA5RjMgRleDt83z2DJrC7pFZzca8VrzAUpsxENrp56CQLuvDjWCOZh
         UXR1q+w6oooxKPqW+C0KYhIFs4B8aJr3eV2PlrNq20wP3e8z8GdwgR8gNYrBQMNp4YjL
         j9aQ==
X-Gm-Message-State: APjAAAXS47s6wsnBWITXRtxcZZniR1mJG8Fl5zEPTWfIrHjb/wnICuRj
        OYszJ8vOVfHOdnXYD4KYrPY=
X-Google-Smtp-Source: APXvYqwg/vGXGWOgR2Jkdwn3Yon/0f7puS7loVaWkhJlQkIZY5Q7wB/FA6UoV8b9iexwCYB6tuKgjg==
X-Received: by 2002:a63:2264:: with SMTP id t36mr19329392pgm.87.1568011923879;
        Sun, 08 Sep 2019 23:52:03 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id g18sm15452727pgm.9.2019.09.08.23.52.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Sep 2019 23:52:02 -0700 (PDT)
Date:   Sun, 8 Sep 2019 23:52:00 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        David Miller <davem@davemloft.net>, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, vinicius.gomes@intel.com,
        vedang.patel@intel.com, weifeng.voon@intel.com, jiri@mellanox.com,
        m-karicheri2@ti.com, Jose.Abreu@synopsys.com,
        ilias.apalodimas@linaro.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, kurt.kanzenbach@linutronix.de,
        netdev@vger.kernel.org
Subject: Re: [PATCH v1 net-next 00/15] tc-taprio offload for SJA1105 DSA
Message-ID: <20190909065200.GA27043@localhost>
References: <20190902162544.24613-1-olteanv@gmail.com>
 <20190906.145403.657322945046640538.davem@davemloft.net>
 <20190907144548.GA21922@lunn.ch>
 <CA+h21hqLF1gE+aDH9xQPadCuo6ih=xWY73JZvg7c58C1tC+0Jg@mail.gmail.com>
 <20190908204224.GA2730@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190908204224.GA2730@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 08, 2019 at 10:42:24PM +0200, Andrew Lunn wrote:
> So if you are struggling to get something reviewed, make it more
> appealing for the reviewer. Salami tactics.

+1
