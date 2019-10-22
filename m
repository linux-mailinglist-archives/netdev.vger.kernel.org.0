Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67B33E0E41
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 00:34:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731850AbfJVWei (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 18:34:38 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:42659 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727154AbfJVWeh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 18:34:37 -0400
Received: by mail-lf1-f65.google.com with SMTP id z12so14368355lfj.9
        for <netdev@vger.kernel.org>; Tue, 22 Oct 2019 15:34:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=mI05Q9KtQBZiVZ2P8r93fpesYDlDm2A779d7FzhOVC4=;
        b=2SRXw59iaelQLHtpJxIa3SKs+I+MKRTTBUu5IwvLyOA8fT5f+NWgkFP4YYu4DV0HP3
         RWp3nupXKk8IhzIVOJ4jmuUcP2KYxNrPLxRg9RHEC1Ddb3O6HlQchqg37pdcIX242jCf
         IpfsCNmb/gO/eGFhlT0rb5H+W8G/KRXJ1e+wh77RLQoHXkkXu/Mg5ZCaMwp4ESEKi4Eu
         ONSvRkNV0V2D7PdR5yO6UWn4kboHYy9aILrc/YfSiUhZDPW2XNVo2XW/iAe0iYHTsz/4
         jA5pOjYgMNjiUyc1qMty8kpr6vGnyJ2tcGuvW1evMtr1OS2hAKIAcSHJDMRCpPruEMVn
         +uDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=mI05Q9KtQBZiVZ2P8r93fpesYDlDm2A779d7FzhOVC4=;
        b=K114WVK4CntgW9wkXZGLbCk+A8idQ4qDIevlQsqyKrG4jNUz5Djb2v9RbSOhE/SUL2
         IImTgTPzjHXioQyVVCGaHluaQG5VP5o5iSv+MHYaoWn1k7MiPhGQhGDDUboYqzGTILlP
         WPsGqWIyrS1pL8Pw2WHl40ks65habpnCk1mB4c37n6YICHxUbiPxZNWeNAhLxpT7YpOu
         JL15jw1eYRYoCRymBEmPqPTFOB5REkuM6+jdT5zgrnI02zsyVpljNgHxg0WBzs7kZilX
         /c0OoWMhD+8IDCUAtsZekjy1oEbxFRhLWYO9hkH/bXqw/+dptvO65Kfi5elNzC9THNoY
         hFRQ==
X-Gm-Message-State: APjAAAX7nMJ1RivHL8lEdGVk5cbvh0nNkv5jC3Hdr/qe16ckrlCiHCNP
        BmhuS9iPrWUE85gI1E+tY4T5eQ==
X-Google-Smtp-Source: APXvYqzu1Zo3aeevJfGePPwaVZuB4jS7ekm5Ys/aaIV89y4JekR4EdxGeRZ5hlEYbkSMImsT/kL3yA==
X-Received: by 2002:a19:f707:: with SMTP id z7mr9656618lfe.0.1571783675672;
        Tue, 22 Oct 2019 15:34:35 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id 81sm9663060lje.70.2019.10.22.15.34.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2019 15:34:35 -0700 (PDT)
Date:   Tue, 22 Oct 2019 15:34:28 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH net-next] fq_codel: do not include <linux/jhash.h
Message-ID: <20191022153428.2077ccd0@cakuba.netronome.com>
In-Reply-To: <20191022163936.33220-1-edumazet@google.com>
References: <20191022163936.33220-1-edumazet@google.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 22 Oct 2019 09:39:36 -0700, Eric Dumazet wrote:
> Since commit 342db221829f ("sched: Call skb_get_hash_perturb
> in sch_fq_codel") we no longer need anything from this file.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied, thanks!
