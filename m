Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2269DD1FD6
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 06:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727417AbfJJEwi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 00:52:38 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:44239 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726201AbfJJEwi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 00:52:38 -0400
Received: by mail-pg1-f196.google.com with SMTP id u12so2832415pgb.11
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 21:52:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=0og379aL1imrLdDvGHjk0uSPqwVOP8c01WJ3dXC3PIE=;
        b=mXgGtLEu9XIeMISa5guPSIUFdpSvhF+iRjMh7DvEtlKyrZ60eJoMIGXNvLXi2dc88h
         MQa3MfsGyqSEb0jmGc+Yg80xRrZDg7OvqE99qNuXeY0Wx7ZfKpNgAmr0729RdJ1S3+3c
         Q2Zi3la8ArRgqfyEDcKyHJkuAdngij0e4hNSeYCKWy8TN1Yc+LRS7wSOhlo1eDVAHxBi
         T4M/YS5Bm3+QhL1uspQBkEmxwtVDvcieVCIgULCheVu/vNyKjBXkjCcUkEo0SQvhWkFs
         3wOtPwVw+dMaUO4jICgP2xwFphbStOl8aQxTqrwtWkHcv5s6wXAgGcJY+K6AaF4sOV7n
         od1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=0og379aL1imrLdDvGHjk0uSPqwVOP8c01WJ3dXC3PIE=;
        b=lrKlJOUI11zCiOzxGtztzr6E80uoyu09DslkXUsIdRNwIi/D/GxP2Ed+DdZEbXRmBP
         HD0RSsBNxIbtpQcdwsILNH15N4Hdt5C1SsxYIDXuYYu7rEKUkOc6mJlpz2qE+oZm8gi5
         p21bH54vVi2LA9GYSaMWMXN8/MMykBX+I28w+w/ils95qs5Ve8JVG5i9Bcz67c+9Ez+I
         VDKl7GvheuNyvaPTRfKA3kufcAzpMhbb70p8Ex5wD2TkR+EvxCGiRyN0/cIW9nX4hlAj
         L8zGyX23rs7vlS057IGXH3lecKsIx3rjl7Szx1ohJzmgKL0CeDJZ8/qwnvIs2co2omFZ
         6+Pg==
X-Gm-Message-State: APjAAAUUDmO6l+H0NL11AJsq+C64NWrhBzwzE9yyISZb6WXlS2tu1A83
        7Uk6x1H5PiHeOIMTCt1GV1Q8pQ==
X-Google-Smtp-Source: APXvYqyCHhe8Bd/5NWiwKgfMBwHEWWSZ+dGzYq3B2pflRjZZ+mY+GRF8jFL6tJlnyCQ3sJjc7xlKEA==
X-Received: by 2002:aa7:8046:: with SMTP id y6mr7917863pfm.222.1570683157592;
        Wed, 09 Oct 2019 21:52:37 -0700 (PDT)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id b22sm4336637pfo.85.2019.10.09.21.52.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 21:52:37 -0700 (PDT)
Date:   Wed, 9 Oct 2019 21:52:23 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: Re: [PATCH net] net: silence KCSAN warnings about
 sk->sk_backlog.len reads
Message-ID: <20191009215223.24f1b4bb@cakuba.netronome.com>
In-Reply-To: <20191009224103.96473-1-edumazet@google.com>
References: <20191009224103.96473-1-edumazet@google.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  9 Oct 2019 15:41:03 -0700, Eric Dumazet wrote:
> sk->sk_backlog.len can be written by BH handlers, and read
> from process contexts in a lockless way.
> 
> Note the write side should also use WRITE_ONCE() or a variant.
> We need some agreement about the best way to do this.
> 
> syzbot reported :
> 
> [...]
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>

..and applied, thank you!
