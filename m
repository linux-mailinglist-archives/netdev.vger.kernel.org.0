Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31657998E3
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 18:12:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389829AbfHVQKq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 12:10:46 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:36561 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731436AbfHVQKq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 12:10:46 -0400
Received: by mail-pl1-f194.google.com with SMTP id f19so3734187plr.3;
        Thu, 22 Aug 2019 09:10:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=v8ITLAh+pwU2VLBKtxxP77uyjp0nYz9VSrpHCnWDVGo=;
        b=vSzF03QDqEZINQHFeCWzU+Q2fBfSalANWQl8Jm6BLitGaPYc1pzb9vk5mxB6BlEy5c
         C+zk/2pFwuiBEnYEJUp3vMI82HSK/kDbtJpQLL9+mK1n60BslTJuq+IOzcGYB1QL88HU
         4RjVMOV1ahfikogsEiJCR45zKck4ppNMYA+iM79WBzrYY99UybPj+QtqoBqiP0AcHrKK
         kun4O/D+c04DNsrM3lXD/6NaCwYtoHFMWx+YMrWW+PBO0B96tGvtcLB7Cc08OoF8VGEi
         AwEAsmsldhJ5oYLzZVG+S+gGb/eYu6nAQlYpqrkbJVGtKqiiAEWQD5D0ju8cipOR1DMw
         ZT/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=v8ITLAh+pwU2VLBKtxxP77uyjp0nYz9VSrpHCnWDVGo=;
        b=aa3SWjalsLHbIdC+ek4PhmDeEYSiNDiaqC08SezQ001eEKZVUKh4+9jb7ctA/U7vJZ
         l99L8XIpFYQ5QRrWl6RFFS2JHhA8yIuVMc77osfZXR+IlJHiHe113KXwjK3RPmDAdVnW
         BE6sc9ZDJhNwoMglw73Mouta+pVF0j94C7UdMjycEs2FiVp69A0yL4YM+k/MXCQzbU/+
         lTwgXz59q4yaFuLU4Vr3o+zrgC6iFPFA2sXJEWxo0OIfmyyp/XLPhVim1VvRMABtoebV
         7QcnnLCgPKXqwUxjlkkgEDaV0zc4adxMPoS9iCXs1ufywtmb+ixlZlOom/dpph2XHABZ
         zhaQ==
X-Gm-Message-State: APjAAAWT5/5bwDoBUy39vpxkXwswSYmAvbNer6Ai6rV/34+/fJakmgXG
        lIOy5OVue1sa2x9W4f1u/70=
X-Google-Smtp-Source: APXvYqxNOxOlSy1ov9D0zEiCk1iRrrNunsFnbkiQ8LygrGg0nFSAaMckgjLdiyV5fW610iWiJMQBuA==
X-Received: by 2002:a17:902:b68f:: with SMTP id c15mr40737696pls.104.1566490245743;
        Thu, 22 Aug 2019 09:10:45 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id p20sm23845814pgj.47.2019.08.22.09.10.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Aug 2019 09:10:44 -0700 (PDT)
Date:   Thu, 22 Aug 2019 09:10:42 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Mark Brown <broonie@kernel.org>,
        Hubert Feurstein <h.feurstein@gmail.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-spi@vger.kernel.org, netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH spi for-5.4 0/5] Deterministic SPI latency with NXP DSPI
 driver
Message-ID: <20190822161042.GD4522@localhost>
References: <20190818182600.3047-1-olteanv@gmail.com>
 <CA+h21hr4UcoJK7upNJjG0ibtX7CkF=akxVdrb--1AJn6-z=sUQ@mail.gmail.com>
 <20190821043845.GB1332@localhost>
 <20190821140815.GA1447@localhost>
 <CA+h21hrtzU1XL-0m+BG5TYZvVh8WN6hgcM7CV5taHyq2MsR5dw@mail.gmail.com>
 <20190822141641.GB1437@localhost>
 <CA+h21hpJm-3svfV93pYYrpoiV12jDjuROHCgvCjPivAjXTB_VA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hpJm-3svfV93pYYrpoiV12jDjuROHCgvCjPivAjXTB_VA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 22, 2019 at 05:58:49PM +0300, Vladimir Oltean wrote:
> If you mean the latter, then yes, having HWTSTAMP_FILTER_ALL in the
> rx_filter of the DSA master is a hard requirement.

And to clear, the marvell only recognizes PTP frames.  That means that
DSA frames cannot be time stamped.

Thanks,
Richard
