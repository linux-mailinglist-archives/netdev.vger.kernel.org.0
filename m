Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEED2D1FD3
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 06:51:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732812AbfJJEvx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 00:51:53 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:46081 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726201AbfJJEvw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 00:51:52 -0400
Received: by mail-pg1-f194.google.com with SMTP id b8so2830095pgm.13
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 21:51:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=7SAEt83MVuHB2RYl8EVswDTFl2nsqnZqWSL/7jMoTHE=;
        b=scvBLN3nqHptKuJ1LuItcT3kbN73lQQ+4Rd3j3JI2jdRYN/pOMBy5vNLweI7S+5vfz
         ilxnBX2hDOfZuAwCRIDUg2wvKqpvqXh+NJMsBNzS0aD7dCNLnWEltnRPERhV6Yqnji7p
         dGuB0UjBJJHI/p1ape6zmOaH+6XVGwMcabMS8f/6q29IOKb2wIHfiZuBqr73ZDg3NfJu
         zLpelb9cwDMvs/fDzInNx/Tu/f0wy//L5zFrDm1gVqGlvz4PizMkDAMhXU20HzoJA//m
         9a0ekL4vMBBdHhKNu7mzy0HKtuHzMFllk9/rqooPgWCg6VF0kf1jG5ODGbtxFSH5vvx8
         uj8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=7SAEt83MVuHB2RYl8EVswDTFl2nsqnZqWSL/7jMoTHE=;
        b=JdcYUX2BcTtvAM9JftzTOR9ki2Aoxn0amENK2k6eStXiVGoHmUw1376LnYRD11E3zZ
         ahnnbAfQj/vZZHJlmy7Dm1z/47UgV7qIXFMCrWY1VLTGQo6e+fkLK0Uu+VuAcd+d/jHx
         cbiK+E/154x0MYuThFJIU1KU5hC6r1PHnwEtK3BHNC7anJB0BUpDwojbXnPNLSd2vAUE
         utZWif+fl/A+bk/6RKOfKB86Yjz5wRQhVY2g9goCuLt7JdivxS/dywFxa8kJO1ZMFfO8
         lWPoyGxUs4IOTbH7Th3doF0exkTT7Pjp3BZPVHKIOMLyRJdrGwXWiJZy6D5JF+TebAkR
         T6uA==
X-Gm-Message-State: APjAAAUFh4mfZHSi1q88COri/qYp+NheXhUr8+0hpf5pxwcf2vHaHw+z
        LPThu2fVA2OWUdEAc25HFzo+eeoZLP0=
X-Google-Smtp-Source: APXvYqxZiNzs7te1GtQVrv98saq1DWP9Xwi8Wkv3PEntWaVFq+gkMQ9voFd1fh8TrbGIHa+C2VHXZA==
X-Received: by 2002:a63:eb08:: with SMTP id t8mr8916105pgh.49.1570683112020;
        Wed, 09 Oct 2019 21:51:52 -0700 (PDT)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id o185sm4545933pfg.136.2019.10.09.21.51.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 21:51:51 -0700 (PDT)
Date:   Wed, 9 Oct 2019 21:51:39 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH net] net: annotate sk->sk_rcvlowat lockless reads
Message-ID: <20191009215139.314608b6@cakuba.netronome.com>
In-Reply-To: <20191009223235.92999-1-edumazet@google.com>
References: <20191009223235.92999-1-edumazet@google.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  9 Oct 2019 15:32:35 -0700, Eric Dumazet wrote:
> sock_rcvlowat() or int_sk_rcvlowat() might be called without the socket
> lock for example from tcp_poll().
> 
> Use READ_ONCE() to document the fact that other cpus might change
> sk->sk_rcvlowat under us and avoid KCSAN splats.
> 
> Use WRITE_ONCE() on write sides too.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied, thanks!
