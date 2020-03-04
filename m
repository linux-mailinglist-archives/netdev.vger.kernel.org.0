Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07954179124
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 14:17:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388154AbgCDNRk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 08:17:40 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:40934 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388053AbgCDNRk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 08:17:40 -0500
Received: by mail-qt1-f195.google.com with SMTP id o10so1269612qtr.7
        for <netdev@vger.kernel.org>; Wed, 04 Mar 2020 05:17:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nydV2K58wcEStaQsSWvYpQaGcZ94lToULTSG3f9FgYI=;
        b=ptzhzRZnQc47OtL6F17FL3BMzzeTv6rLEsjA8C8rh3NZEQQE/TmC0St7u06cbXDWC1
         NLsnsee60VnQypQqiX6YMC4E4OxnkmITNNmI1xXpGh64Ta4bd/WX7rNFTyJHOk3d9QrJ
         d3VBdH2BPyPWTbp8P0NKy3NwwiyvsIJD+yDwRatE/5WBUlng/qZDl8rZRI78GOIxG8QK
         NKzOSQXcZXFi6qrr3020lDNFa9EKoAWKJNy64/tGh9PG1WB18FiU7KKQ47T3l7HMuDIY
         /aNtcZr6/dSmSb2WR1skRqTFtws3xZwQQNeQ/gtl5J0yCbqwpDPKCLuzn7bUXtPO3v6Y
         rISg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nydV2K58wcEStaQsSWvYpQaGcZ94lToULTSG3f9FgYI=;
        b=TWl3A06X1nJC1uQhlmajfXzSGPkZZpZqsAlgUG2IIFKzBHqh8PVPwKlGdrHErcrfoK
         lAPeJR4CleVvStr87OguKOMo54XssikpodQQC6JbeFTd60qa9n3MuH1ysvPSRHKMg/ra
         soj/Gcqc/1LdOZqsnsY/DAsxskUft0I1ZuTK3ED9m1HD6m0BMJQBKQsP4D0v6KHaf12/
         YVCh1DiBYhOURF5lilbSjmzDG/E/gLEu9NlajM4+QRNUNVPqDc/MFtwOJIHVy5n0r1eG
         xm9xdTsMlekam9uR7zkg9/sZnB96qUc1GhIaajRb/taUaF0RyvxzleQpDvBxZKTsJTLy
         39Pg==
X-Gm-Message-State: ANhLgQ3mkBtRk4ScPd4XO9Kbfa5HRQ/T5Xe+ZUxNTCOWAZaJ29CvrkuS
        7Ot7OlR9PTrN7Sj+7ZIk+Og=
X-Google-Smtp-Source: ADFU+vsK6LzZ0nwwAGhcGeIEmGtI2r5vnJBGGfImmVFid2gI1DVJgW1zBoW4alkR/FMpGeJWMwTn9w==
X-Received: by 2002:aed:3e0e:: with SMTP id l14mr2290554qtf.260.1583327859226;
        Wed, 04 Mar 2020 05:17:39 -0800 (PST)
Received: from localhost.localdomain ([177.220.172.122])
        by smtp.gmail.com with ESMTPSA id y62sm13791860qka.19.2020.03.04.05.17.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2020 05:17:38 -0800 (PST)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 4C7AFC0E8C; Wed,  4 Mar 2020 10:17:36 -0300 (-03)
Date:   Wed, 4 Mar 2020 10:17:36 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Paul Blakey <paulb@mellanox.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>
Subject: Re: [PATCH net-next 2/2] net/sched: act_ct: Use
 pskb_network_may_pull()
Message-ID: <20200304131736.GG2546@localhost.localdomain>
References: <1583322579-11558-1-git-send-email-paulb@mellanox.com>
 <1583322579-11558-3-git-send-email-paulb@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1583322579-11558-3-git-send-email-paulb@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 04, 2020 at 01:49:39PM +0200, Paul Blakey wrote:
> To make the filler functions more generic, use network
> relative skb pulling.
> 
> Signed-off-by: Paul Blakey <paulb@mellanox.com>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
